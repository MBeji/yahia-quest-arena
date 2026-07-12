# Étude 10 — Intégrité des classements & anti-fraude

> **Statut** : brouillon
> **Priorité** : 10 · **Valeur** : protéger la crédibilité de tout ce qui classe (leaderboard, percentiles d'examen blanc, duels/ligues) — un classement triché tue la motivation des élèves honnêtes · **Complexité** : moyenne
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : montée des enjeux compétitifs (études [02](../02-examen-blanc/ETUDE.md) et [05](../05-duels-ligues/ETUDE.md) livrées) — les lots 1–3 peuvent se préparer avant, le lot 4 ne s'active qu'après · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md (anti-farm, gotcha grants, DoD §7), ARCHITECTURE.md, `docs/logging-standard.md`

## 1. Contexte & objectif produit

Le projet a déjà une **prévention** solide côté soumission : clé de réponse jamais côté client
(GAP-020), gate `tooFast` (`MIN_SECONDS_PER_QUESTION` = 4 s), récompense seulement si `≥60%` et
`improved`, rate limiting persistant (`rate_limit_events` + `check_rate_limit`, migration
`20260601150000`). Ce qui manque est la **détection a posteriori** des comportements que la
prévention laisse passer : un tricheur patient (5 s/question, réponses fournies par un tiers ou
un solveur) est invisible aux gates et pollue le leaderboard (`get_global_leaderboard`), les
percentiles d'examen blanc (étude 02, R-6) et les ligues (étude 05, lot 5).
**Résultat attendu** : chaque signal suspect devient un `integrity_flag` révisé par un humain ;
un compte `confirmed` est silencieusement exclu des classements (réversible). **KPI** : délai
médian flag→revue, taux de faux positifs par détecteur (< 5 % visé après calibration), part des
top-50 leaderboard jamais flaggés. **Non-objectif** : punir automatiquement, surveiller le
device de l'élève, ou remplacer la prévention existante.

## 2. Spécification fonctionnelle

**Philosophie (non négociable)** : détection **server-side** + revue **humaine**. Jamais de
punition automatique irréversible, jamais de spyware client — public mineur : aucun
fingerprinting invasif, aucune collecte nouvelle côté navigateur. Tout signal dérive des données
serveur déjà collectées : `attempts` (`duration_seconds`), `exercise_sessions`, timestamps par
question (`question_attempts` de l'étude 04 lot A0, `answers_submitted_at` des duels étude 05).

**Acteurs** : détecteurs (jobs cron, aucun UI) ; **admin** (file de revue) ; l'élève ne voit
rien (shadow) ; le parent n'est pas notifié en v1 (Q-3).

- **US-1** : admin — je vois la file des flags ouverts (`/admin` onglet « Intégrité »), triés
  par sévérité, avec l'évidence lisible (chiffres, période, seuil franchi).
- **US-2** : admin — sur un flag je peux `dismiss` (faux positif, documenté) ou `confirm`.
- **US-3** : admin — sur un user `confirmed` je peux révoquer les récompenses d'une période
  donnée via une fonction dédiée, et lever l'exclusion plus tard (réversible).
- **US-4** : élève `confirmed` — je continue à jouer normalement ; je n'apparais simplement plus
  dans le leaderboard/percentiles/ligues, sans notification agressive.

**Règles métier** :

- **R-1** : un détecteur ne crée jamais deux flags ouverts identiques (user, kind) — il met à
  jour l'évidence du flag ouvert existant.
- **R-2** : seule une décision humaine change `status` ; les détecteurs n'écrivent que `open`.
- **R-3** : l'exclusion des classements ne s'applique qu'aux flags `confirmed` (jamais `open`),
  et se lève en repassant le flag à `dismissed`/`reviewed` — aucune donnée n'est détruite.
- **R-4** : la révocation de récompenses (US-3) est bornée à une période explicite, journalisée
  dans l'évidence du flag, et n'emmène jamais XP/coins en négatif.
- **R-5** : tous les seuils des détecteurs sont des constantes centralisées
  (`src/shared/constants/integrity.ts`), jamais inline en SQL — calibrables sans re-review.
- **R-6** : mode observation d'abord : les détecteurs tournent N semaines (Q-2) en ne produisant
  que des flags, AVANT toute activation de l'exclusion (lot 4).

**i18n** : UI admin FR uniquement en v1 (comme le reste de l'admin) ; aucune clé élève.
**Hors périmètre (v1)** : CAPTCHA, biométrie, device fingerprinting, sanctions automatiques,
modération de contenu utilisateur (c'est `content_reports`), détection par IP applicative — le
rate limiting IP vit à l'edge (Vercel) et chez Supabase Auth, pas dans l'app.

## 3. Architecture technique (décisions fermées)

**Modèle de données** (migration additive ; grants EXPLICITES — gotcha CLAUDE.md nouvelles tables) :

```sql
CREATE TABLE public.integrity_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  kind TEXT NOT NULL CHECK (kind IN
    ('timing_uniform','timing_superhuman','accuracy_jump','nocturnal_robot','multi_account')),
  severity TEXT NOT NULL DEFAULT 'medium' CHECK (severity IN ('low','medium','high')),
  evidence JSONB NOT NULL DEFAULT '{}'::jsonb,   -- métriques, période, seuil franchi, run_id
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','reviewed','dismissed','confirmed')),
  reviewed_by UUID REFERENCES auth.users(id), reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX idx_integrity_flags_open ON public.integrity_flags(user_id, kind)
  WHERE status = 'open';                          -- R-1
CREATE INDEX idx_integrity_flags_queue ON public.integrity_flags(status, severity, created_at);
ALTER TABLE public.integrity_flags ENABLE ROW LEVEL SECURITY;
-- RLS admin-only (profiles.role = 'admin' pour SELECT/UPDATE) ; l'élève ne lit JAMAIS ses flags.
REVOKE ALL ON public.integrity_flags FROM anon, authenticated;
GRANT SELECT, UPDATE ON public.integrity_flags TO authenticated;  -- filtré par la policy admin
```

**Détecteurs** = fonctions SQL `SECURITY DEFINER` (REVOKE anon/authenticated) appelées par un
cron server fn sur le patron exact de `notifications.cron.server.ts` (route
`/api/cron/integrity`, `Authorization: Bearer CRON_SECRET`, quotidien) :

- **DET-1 `timing_uniform`** — distribution des temps anormale : sur ≥ 30 `attempts` de 7 jours,
  variance des `duration_seconds` quasi nulle (coefficient de variation < seuil) = script/robot.
- **DET-2 `timing_superhuman`** — cadence surhumaine soutenue : temps médian par question sous
  `INTEGRITY_MIN_HUMAN_MEDIAN_SECONDS` sur des sessions d3/d4 réussies, répété sur ≥ 3 jours
  (le gate `tooFast` unitaire ne voit pas la répétition ; source fine : `question_attempts` 04,
  `answers_submitted_at` duels 05).
- **DET-3 `accuracy_jump`** — saut d'exactitude impossible : profil historique faible en d1/d2
  (< 50 % sur ≥ 20 tentatives) puis soudainement ~100 % en d4/examens sur une fenêtre courte.
- **DET-4 `nocturnal_robot`** — volume nocturne robotique : sessions soutenues plusieurs nuits
  (02:00–05:00 heure de Tunis) à cadence régulière — combiné, jamais flaggant seul (severity low).
- **DET-5 `multi_account`** — multi-comptes v1 **limité aux signaux server-side non invasifs** :
  plusieurs comptes élèves croisant les mêmes `parent_student_links`, ou bursts d'inscriptions
  corrélés (créations rapprochées + mêmes patterns d'activité) alimentant un même classement.
  **Pas d'IP côté app** (voir Hors périmètre).

**Exclusion shadow** : pas de colonne sur `profiles` — une jointure d'exclusion
`NOT EXISTS (SELECT 1 FROM integrity_flags f WHERE f.user_id = p.id AND f.status='confirmed')`
ajoutée à la vue matérialisée `global_leaderboard_ranked` (migration `20260630170000`), au
percentile d'examen (étude 02 R-6) et à l'agrégat ligue (étude 05 D-6). Réversible par simple
changement de statut, refresh au prochain cycle pg_cron (≤ 5 min).

**Server fns** (`src/features/integrity/integrity.server.ts`, admin-only, zod +
`requireSupabaseAuth`) : `getIntegrityFlags`, `reviewIntegrityFlag`, `revokePeriodRewards`
(RPC dédiée `admin_revoke_period_rewards(user, from, to)`, patron `admin_revoke_parcours`).
**Observabilité** : logs `integrity.detector_run` (compteurs par kind), `integrity.flag_reviewed`.

**ADR** : **D-1** détection batch SQL (cron) plutôt que triggers temps réel — coût nul au chemin
chaud de `submit_exercise_attempt`, rejeté : hooks dans les RPCs de soumission. **D-2** jointure
d'exclusion plutôt que colonne dénormalisée `profiles.is_shadow_banned` — une seule source de
vérité, réversibilité gratuite ; rejeté : colonne (risque de désynchronisation, visible via RLS
profiles). **D-3** seuils en constantes TS injectées en paramètres des fonctions SQL par le cron
(R-5) — rejeté : seuils codés en dur en SQL (re-migration à chaque calibration).

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                             | fichiers/objets créés                                          | tests exigés                                            | dépend de                          |
| --- | ------------------------------------------------------------ | -------------------------------------------------------------- | ------------------------------------------------------- | ---------------------------------- |
| 1   | Migration `integrity_flags` + RLS admin-only + grants        | 1 migration                                                    | pgTAP (RLS, grants, R-1 index partiel)                  | —                                  |
| 2   | Détecteurs DET-1…5 + cron + constantes, **mode observation** | fonctions SQL, `/api/cron/integrity`, `integrity.ts`           | pgTAP (chaque DET sur jeux synthétiques)                | 1 (+04-A0 pour DET-2 fin)          |
| 3   | Admin UI « Intégrité » + workflow revue + révocation         | feature `integrity/` + fns + RPC `admin_revoke_period_rewards` | Vitest (US-1…3, R-2/R-4) ; pgTAP RPC                    | 1                                  |
| 4   | Activation shadow-exclusion (leaderboard/percentile/ligue)   | migration jointure d'exclusion                                 | pgTAP (R-3, réversibilité) ; non-régression leaderboard | 2+3 calibrés, GO humain (R-6, Q-2) |

- [ ] Lot 1 — schéma & sécurité (merge seul — DoD §7). **Stop-point** : aucun détecteur.
- [ ] Lot 2 — détecteurs en observation + **calibration à blanc** : rapport du taux de flags
      (≈ faux positifs présumés) de chaque DET sur les données existantes, joint à la PR.
      **Stop-point** : aucune exclusion, aucune UI.
- [ ] Lot 3 — admin UI + revue. **Stop-point** : pas d'exclusion.
- [ ] Lot 4 — shadow-exclusion, seulement après GO humain sur les taux observés (R-6).

## 5. Stratégie de test

pgTAP = cœur : RLS (un non-admin ne lit/n'écrit rien), R-1 (upsert du flag ouvert), chaque
détecteur sur données synthétiques (un profil robot déclenche, un très bon élève « rapide mais
humain » — variance normale, progression graduelle — ne déclenche PAS : anti-faux-positif
testé), R-3/R-4 (exclusion réversible, révocation bornée, jamais négatif), non-régression de
`get_global_leaderboard` (mêmes résultats sans flag confirmed). Vitest : fns admin (zod,
guard rôle), composants file de revue. Pas d'e2e ni de `smoke:shell` (admin-only, hors bundle
public).

## 6. Risques & mitigations

- **RISK-1** — **Faux positifs sur des enfants = le risque n°1** : un excellent élève rapide et
  régulier ressemble statistiquement à un robot. _Prob. haute, impact haut._ Mitigations
  décidées : jamais de sanction automatique (R-2), shadow (jamais de message accusateur, US-4),
  calibration à blanc N semaines (R-6), DET-4 jamais seul, pgTAP anti-faux-positif obligatoire
  (§5), et revue humaine qui compare toujours au profil historique complet avant `confirm`.
- **RISK-2** — Biais contre les très bons élèves légitimes (les flags se concentrent sur le top
  du classement). _Prob. moyenne, impact haut._ Mitigation : DET-1/2 mesurent la **forme** de la
  distribution (variance, régularité), pas la performance ; le rapport de calibration (lot 2)
  doit ventiler les flags par percentile de niveau et tout biais top-heavy bloque le lot 4.
- **RISK-3** — Adaptation des tricheurs (délais randomisés). _Prob. moyenne, impact moyen._
  Mitigation : la combinaison de détecteurs indépendants (timing + accuracy_jump + nocturne)
  reste coûteuse à contourner ; seuils calibrables sans déploiement (D-3) ; on accepte que la
  détection soit un filet, pas un mur (la prévention GAP-020/tooFast reste la première ligne).
- **RISK-4** — File de revue non traitée (flags qui s'accumulent). _Prob. moyenne, impact
  moyen._ Mitigation : compteur de flags ouverts dans le digest admin existant du cron
  notifications ; sévérité pour prioriser ; R-3 garantit qu'un flag ignoré ne punit personne.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : valeurs initiales des seuils (CV minimal DET-1, médiane « humaine » DET-2, fenêtres
  DET-3/4) — proposition chiffrée à produire au lot 2 à partir des distributions réelles
  d'`attempts.duration_seconds`, puis arbitrage humain avant le lot 4.
- **Q-2** : durée du mode observation avant activation (proposition : 4 semaines, alignée sur le
  GO de l'étude 04-A2) et taux de faux positifs acceptable pour le GO du lot 4 (proposition < 5 %).
- **Q-3** : politique de communication aux familles — informer le parent lié quand un flag est
  `confirmed` (transparence) ou rester 100 % silencieux (shadow pur) ? v1 propose : silencieux,
  avec mention générique « fair-play » dans les CGU ; à trancher avant le lot 4.

## 8. Journal d'exécution

_(vide — rempli par l'exécuteur, lot par lot)_

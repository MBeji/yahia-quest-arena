# Étude 08 — Analytics parents & enseignants

> **Statut** : brouillon (⚠️ 2026-07-11 : le wording « ceux qui paient / abonnement » précède le pivot gratuité — en phase gratuite le suivi parent est un **pilier de l'offre gratuite** ; à re-scoper à la validation)
> **Priorité** : 08 · **Valeur** : rendre la progression visible et honnête pour les familles — le rapport parent devient un tableau de bord descriptif (temps, progression, matières, points faibles, examens blancs) · **Complexité** : moyenne
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : étude 04 lot A0 (télémétrie `question_attempts`) pour les vues compétences ; étude 07 (knowledge graph — **en cours de rédaction** : table `user_competency_mastery`, maîtrise 0–100 par compétence) pour les points faibles ; étude 02 (examen blanc) pour le percentile · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md (RLS, DoD §7, gotcha grants), ARCHITECTURE.md, FableEtudes/02-examen-blanc/ETUDE.md, FableEtudes/04-moteur-adaptatif/ETUDE.md

## 1. Contexte & objectif produit

Le rapport parent existe (`src/features/parent-report/`, RPC `get_student_report`, objectif hebdo,
partage texte) mais reste un instantané 7 jours — pas de série temporelle, pas de vue compétences,
pas de mise en perspective — et le digest push hebdo (`dispatchParentDigest` dans
`src/features/notifications/notifications.cron.server.ts`) est un générique « ton rapport est
prêt ». Objectif v1 : un tableau de bord **strictement descriptif** — temps d'étude, progression
XP/niveau/streak, activité par matière, top 5 des compétences faibles, percentile des examens
blancs — servi par des agrégats SQL, plus un digest hebdo opt-in enrichi. KPI : % de parents liés
consultant le rapport ≥1×/semaine, taux d'opt-in au digest, churn des entitled avec vs sans parent
actif. Non-objectif : prédiction, prescription, export de données, rôle enseignant (v2, Q-2).

## 2. Spécification fonctionnelle

**Acteurs** : parent lié (`parent_student_links` actif) ; admin (voit tout, comme aujourd'hui) ;
l'élève ne voit pas cette vue (sa progression a ses propres écrans). Aucun nouveau rôle.

- **US-1** : parent — je vois le **temps d'étude** de mon enfant (cette semaine, 8 dernières
  semaines en série hebdo) agrégé depuis les durées d'`exercise_sessions` + `attempts`.
- **US-2** : parent — la **progression** XP/niveau/streak en série hebdo (8 semaines), paliers inclus.
- **US-3** : parent — l'**activité par matière** (temps, missions, score moyen) sur la période.
- **US-4** : parent — les **5 compétences les plus faibles** (maîtrise 0–100 via
  `user_competency_mastery`, étude 07), libellé lisible ; si 07 n'est pas livrée, repli
  automatique : taux de réussite par chapitre depuis `question_attempts` (étude 04, A0).
- **US-5** : parent — si mon enfant a passé des examens blancs (étude 02), je vois score et
  percentile par examen (mêmes règles d'affichage que l'étude 02, R-6 : seuil N≥20).
- **US-6** : parent — un encart « rythme » signale un **risque de décrochage** expliqué : la
  règle déclenchée est affichée en clair (R-4). Jamais de score opaque.
- **US-7** : parent — j'active (opt-in) le **digest hebdo** : le push du dimanche contient le
  résumé chiffré de la semaine (temps, missions, streak, 1 point faible) au lieu du générique.
- **US-8** : parent — je peux situer mon enfant par rapport à la **moyenne de la plateforme sur
  ce parcours** (score moyen, temps hebdo) — agrégat anonymisé, masqué sous N<30 (R-6).

**Règles métier** :

- **R-1** : temps d'étude = somme des durées `exercise_sessions` (bornées à 30 min/session pour
  neutraliser les sessions laissées ouvertes) + durées d'`attempts` hors session ; constante de
  borne centralisée dans `src/shared/constants/gamification.ts`.
- **R-2** : toutes les séries sont **hebdomadaires** (semaine lundi–dimanche, fuseau app/Tunis),
  8 semaines glissantes ; une semaine sans activité apparaît à zéro (pas de trou).
- **R-3** : points faibles = 5 compétences de maîtrise la plus basse ayant ≥N_MIN occurrences
  (données creuses → panneau « pas encore assez de données », jamais de faux diagnostic). Le
  repli chapitre (US-4) applique le même seuil.
- **R-4** : « risque de décrochage » v1 = heuristique transparente, 3 règles OR : inactivité ≥7 j ;
  streak cassée cette semaine (streak > 5 la semaine passée, 0 maintenant) ; maîtrise moyenne en
  baisse sur 2 semaines consécutives. Pas de ML ni pondération cachée ; un libellé i18n par règle.
- **R-5** : l'expression « moyenne nationale » est **interdite** dans l'UI et les i18n : le
  libellé est « moyenne de la plateforme sur ce parcours » (D-3).
- **R-6** : tout comparatif plateforme est calculé sur ≥30 élèves distincts du même parcours,
  sinon masqué (« comparaison disponible à partir de 30 élèves ») ; l'agrégat ne contient que
  des moyennes/médianes, **jamais** de donnée individuelle d'un autre élève.
- **R-7** : digest enrichi = opt-in explicite (préférence par parent, défaut : voir Q-1) ; le
  contenu push ne contient aucun identifiant sensible (prénom affiché uniquement).
- **R-8** : vie privée mineurs — aucune exposition des faiblesses au-delà du parent lié actif (leur
  visibilité parent est la **Q-2 de l'étude 04** : on en hérite, on ne la re-tranche pas) ; pas
  d'export CSV/PDF en v1 ; les RPCs ne retournent jamais de données d'un élève non lié (pgTAP dédié).

**i18n** : toutes les nouvelles clés en FR/EN/AR ; graphiques et badges lisibles en RTL (axes,
légendes) ; libellés compétences fournis par le registre de l'étude 07 (id jamais affiché).
**Hors périmètre (v1)** : « prédiction du score au concours » = **v2 GELÉE** — explicitement
conditionnée à un volume suffisant d'examens blancs (étude 02) pour calibrer quoi que ce soit ;
rôle enseignant / vue classe (Q-2) ; export de données ; comparaisons inter-élèves nominatives
(interdites, R-6) ; recommandations pédagogiques (c'est l'étude 04, US-3).

## 3. Architecture technique (décisions fermées)

- **D-1 — Étendre `parent-report/`, pas de nouvelle feature.** Fns, composants et i18n vont dans
  `src/features/parent-report/` (barrel existant) ; la route reste
  `routes/_authenticated/parent-report.tsx`. Rejeté : feature `analytics/` (guard parent dupliqué).
- **D-2 — Agrégats servis par des RPCs SQL read-only `SECURITY DEFINER`.** Chaque RPC vérifie en
  tête le lien via le modèle de policy de `parcours_entitlements` (« owner, admin or linked
  parent », migration `20260608120000_parcours_entity.sql`) puis agrège en SQL (index dédiés).
  Rejeté : agrégation TS côté server fn (N requêtes, charge, risque de fuite RLS par jointure).
- **D-3 — Honnêteté des comparatifs.** Pas de « moyenne nationale » (donnée inexistante) : agrégat
  plateforme par parcours, anonymisé, seuillé N≥30 (R-5/R-6). Rejeté : benchmark externe importé.
- **D-4 — Décrochage = heuristique lisible, pas de ML** (R-4) : fonction SQL pure retournant les
  règles déclenchées ; constantes centralisées. Rejeté : score prédictif (pas de données, opacité).
- **D-5 — Chaîne de repli compétences** : `user_competency_mastery` (07) si la table existe et a des
  lignes pour l'élève → sinon taux de réussite par chapitre (`question_attempts`, 04-A0) → sinon
  « pas assez de données ». Repli décidé **dans le RPC** ; payload unique
  `{ mode: 'competency' | 'chapter' | 'empty', items: [...] }`.
- **D-6 — Digest par le canal existant** : on enrichit `dispatchParentDigest` (payload construit
  par un RPC résumé + préférence opt-in) ; aucun nouveau cron, même `CRON_SECRET`/planning.

**Modèle de données** (migration additive + GRANTs explicites — gotcha CLAUDE.md) :

```sql
CREATE TABLE public.parent_digest_prefs (          -- opt-in digest (R-7)
  parent_user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  enriched_digest BOOLEAN NOT NULL DEFAULT false,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- RLS owner-only (SELECT/INSERT/UPDATE) + GRANT explicites ; lecture cron via service-role.
-- Index d'agrégation (additifs) :
CREATE INDEX IF NOT EXISTS idx_exercise_sessions_user_started
  ON public.exercise_sessions (user_id, started_at DESC);
CREATE INDEX IF NOT EXISTS idx_attempts_user_created
  ON public.attempts (user_id, created_at DESC);
```

**Server** (toutes read-only, `SECURITY DEFINER`, `REVOKE anon`, check lien parent en tête) :

- `get_student_analytics(p_student uuid)` : JSONB — séries hebdo temps/XP/niveau/streak (R-1/R-2),
  activité par matière (US-3), drapeaux décrochage (R-4 : `{rules: text[]}`).
- `get_student_weaknesses_parent(p_student uuid)` : payload D-5 (top 5, R-3, R-8).
- `get_student_exam_summary(p_student uuid)` : scores + percentiles `mock_exam_sessions`
  (réutilise `get_mock_exam_percentile` de l'étude 02 ; vide si l'étude 02 n'est pas livrée —
  dégradation gracieuse, pattern CLAUDE.md).
- `get_parcours_platform_stats(p_parcours text)` : moyennes anonymes seuillées (R-6) ; `STABLE`.
- `get_parent_digest_summary(p_parent uuid)` : résumé compact par élève lié (D-6, appelé par le
  cron via service-role).
- Server fns zod correspondantes dans `parent-report.server.ts` (mêmes patterns
  `failWithClientError` + schémas `.catch()` que l'existant) ; `setDigestPref` (POST, rate-limité
  comme `setStudentWeeklyGoal`).

**Client** : extension de `ReportContent` (`components/report-content.tsx`) : sections séries
hebdo (sparklines SVG maison, pas de lib de charts), matières, faiblesses, examens, comparatif
plateforme, encart rythme ; toggle digest. États vides/chargement/erreur par section (une section
qui échoue ne casse pas la page). **Observabilité** : logs structurés par RPC (durée, mode de
repli D-5 servi, comparatif masqué/affiché) ; compteur digest enrichi envoyé/refusé.

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                                                     | fichiers/objets créés                                        | tests exigés                                               | dépend de           |
| --- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------------------- | ------------------- |
| 1   | Migration prefs + index + 4 RPCs élève (analytics/faiblesses/examens/digest-summary) | 2 migrations                                                 | pgTAP : lien parent (R-8), séries R-1/R-2, repli D-5, R-4  | 04-A0 livré (repli) |
| 2   | Page rapport enrichie (US-1→US-6) + fns zod + i18n                                   | `parent-report.server.ts` étendu, `report-content.tsx`, i18n | Vitest : schémas, sections, états vides, RTL               | 1                   |
| 3   | Digest hebdo opt-in enrichi (US-7)                                                   | `parent_digest_prefs` fns + cron étendu                      | Vitest cron (opt-in respecté, payload, fallback générique) | 1                   |
| 4   | Comparatifs plateforme seuillés (US-8)                                               | RPC `get_parcours_platform_stats` + section UI               | pgTAP : seuil N≥30, anonymat (R-6) ; Vitest libellé R-5    | 1                   |

- [ ] Lot 1 — RPCs agrégats + pgTAP (merge seul, avant le code — DoD §7)
- [ ] Lot 2 — page rapport enrichie
- [ ] Lot 3 — digest hebdo opt-in
- [ ] Lot 4 — comparatifs plateforme seuillés

**Stop-points** : lot 1 ne modifie AUCUN RPC existant (`get_student_report` reste tel quel) ; lot 2
ne crée ni feature ni lib de charts ; lot 3 ne touche ni au planning cron ni au reminder streak ;
aucun lot n'affiche « moyenne nationale » ni n'expose de donnée d'un autre élève ; le mode
`competency` s'active seul quand l'étude 07 livre sa table — ne pas l'implémenter en avance.

## 5. Stratégie de test

pgTAP porte la sécurité et l'exactitude : matrice d'accès (parent lié / parent non lié / élève /
admin / anonyme) sur chaque RPC (R-8), séries hebdo avec jeu de données multi-semaines (R-2, borne
R-1), repli D-5 (avec/sans table 07, avec/sans données 04), règles R-4 une par une, seuil R-6
(29 vs 30 élèves). Vitest co-localisés (`__tests__/`) : schémas zod `.catch()`, sections UI
(vide/plein/erreur isolée), RTL, cron digest (opt-in, payload, VAPID absent). Non-régression :
les tests existants `parent-report.test.ts` / `notifications.cron.test.ts` restent verts sans
modification de leurs assertions. Pas d'impact `smoke:shell` (route authed) ; e2e non requis v1.

## 6. Risques & mitigations

- **RISK-1** Mésusage du comparatif (pression parentale, lecture « classement ») (probable/moyen) →
  R-5/R-6 : libellé honnête, agrégat seuillé, jamais de rang individuel ; encart « chaque élève
  progresse à son rythme » dans l'UI.
- **RISK-2** Charge des agrégats sur les grosses tables (possible/moyen) → D-2 : SQL indexé
  (index lot 1), fenêtre bornée 8 semaines, RPCs `STABLE` cacheables TanStack Query ; bascule vue
  matérialisée notée comme optimisation future (même posture que D-3 de l'étude 02).
- **RISK-3** Données creuses au lancement (faiblesses/percentiles vides) (certain/faible) →
  R-3 + D-5 : seuils explicites, états vides positifs, aucune section ne montre un diagnostic
  sous-alimenté ; le rapport reste utile avec les seules US-1/US-2/US-3.
- **RISK-4** Le repli chapitre (04) contredit la vue compétences (07) au moment de la bascule
  (possible/faible) → payload unique D-5 avec `mode` affiché (« vue par chapitre » vs « vue par
  compétence ») ; bascule côté serveur, sans déploiement client.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : le digest enrichi est-il opt-in par défaut désactivé (proposition, conservateur
  vie privée) ou activé pour les parents déjà destinataires du digest générique ?
- **Q-2** : « enseignants » — le rôle n'existe pas (`profiles.role` ∈ student/parent/admin). Un
  rôle `teacher` + vue classe est un chantier propre (liens N élèves, consentement, RLS dédiée) :
  proposé **v2, étude séparée**. Valider ce report.
- **Q-3** : seuils R-3 (N_MIN d'occurrences par compétence) et fenêtre R-4 (7 j d'inactivité) —
  valider les valeurs par défaut avant lot 1 (constantes centralisées, ajustables ensuite).

## 8. Journal d'exécution

_(vide — rempli par l'exécuteur, lot par lot)_

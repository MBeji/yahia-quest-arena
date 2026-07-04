# Étude 02 — Examen blanc / simulation concours

> **Statut** : brouillon
> **Priorité** : 02 · **Valeur** : l'expérience « concours » qui justifie les parcours premium (6ème, 9ème, bac) : conditions réelles, classement percentile, diagnostic par matière · **Complexité** : moyenne+
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : contenu exam-style suffisant (paliers d4 + `NN-annales-bac` pour le bac) ; rien côté code
> **Docs normatifs liés** : CLAUDE.md (Premium gate, gamification centralisée, DoD §7), docs/lycee-architecture.md (palier annales), ARCHITECTURE.md

## 1. Contexte & objectif produit

Les parcours payants s'appellent « concours » mais rien ne simule un concours : tout est mission
par mission, avec récompenses immédiates. Il manque l'épreuve : sujet multi-matières, durée
globale, pas de feedback pendant, correction différée, **percentile face aux autres candidats**.
KPI : % d'entitled qui font ≥1 examen blanc, récurrence mensuelle, corrélation score↔progression
(argument parents), churn des entitled avant/après.
Non-objectif : reproduire officiellement les barèmes ministériels (on affiche « simulation »),
surveiller/anti-plagiat lourd, épreuves rédactionnelles (QCM/engine actuel uniquement).

## 2. Spécification fonctionnelle

**Acteurs** : élève entitled (le mode est un **perk premium concours**, comme le Dungeon) ;
admin (composer/publier des examens) ; anonyme : rien.

- **US-1** : je vois la liste des examens blancs de MON parcours (ex. « Concours blanc 9ème —
  session 1 », durée totale, matières) avec mon historique (fait/score/percentile).
- **US-2** : je démarre : écran consignes → le chrono global démarre (deadline serveur) ; je
  navigue entre les épreuves (une par matière), je réponds, je peux revenir en arrière tant que
  le temps court ; aucun indice/correction pendant.
- **US-3** : je rends (ou le temps expire) → écran résultats : score global sur barème, détail
  par matière et par chapitre, percentile parmi tous les candidats de cet examen, et liens de
  remédiation (« revois le chapitre X »).
- **US-4** : je ne peux faire chaque examen qu'une fois en mode classé ; je peux le refaire en
  mode entraînement (non classé, non récompensé).
- **US-5** : admin — je compose un examen (choix d'exercices existants par matière, durée, barème
  par exercice), je le publie/dépublie.

**Règles métier** :

- **R-1** : un examen = une liste ordonnée d'**exercices existants** (mode `challenge`/`boss`,
  idéalement issus des paliers d4/annales) — pas de banque parallèle, pas de génération dynamique.
- **R-2** : la deadline est **serveur** : `deadline = started_at + duration`; toute soumission
  après deadline est acceptée mais tronquée aux réponses déjà enregistrées (auto-rendu).
- **R-3** : pendant la session, aucune review/clé n'est renvoyée (posture GAP-020) ; la review
  complète se débloque à l'état `finished` seulement.
- **R-4** : une seule session classée (`ranked`) par (user, exam) — contrainte unique ; les
  suivantes sont `practice` (US-4).
- **R-5** : récompense forfaitaire à la fin (XP/coins selon score, constantes dans
  `src/shared/constants/gamification.ts`) versée UNE fois (session classée uniquement) via
  `award_xp` ; les gates anti-farm existants (tooFast par épreuve) s'appliquent.
- **R-6** : percentile calculé sur les sessions `ranked finished` du même examen ; affiché à
  partir de N≥20 candidats (sinon « classement disponible à partir de 20 candidats »).
- **R-7** : accès = entitlement live sur le parcours de l'examen (réutilise
  `has_parcours_entitlement`), pas de preview gratuit en v1.
- **R-8** : réponses **enregistrées au fil de l'eau** (par épreuve) côté serveur — un crash/refresh
  ne perd rien ; reprise de session tant que la deadline court.

**i18n** : FR/EN/AR (RTL complet — les épreuves héritent de la langue de leur matière, l'enveloppe
UI suit la langue de l'app). **Hors périmètre (v1)** : examens programmés à heure fixe
(synchrones), certificats PDF, mode surveillé.

## 3. Architecture technique (décisions fermées)

- **D-1 — Composition par curation, pas par tirage** : un examen référence des exercices existants
  (R-1). Rejeté : assemblage aléatoire par chapitre (qualité/équilibrage non garantis, percentile
  non comparable). La rotation anti-partage se fait en publiant de nouvelles sessions (contenu
  pipeline `NN-annales-bac` alimente).
- **D-2 — Sessions serveur, réponses au fil de l'eau** (R-8) : pas de state client précieux ;
  reprise gratuite. Rejeté : tout-soumettre-à-la-fin (fragile mobile).
- **D-3 — Percentile à la lecture** (requête window sur scores finis, index dédié), pas de vue
  matérialisée en v1 (volumes faibles) ; bascule matérialisée = optimisation future notée.
- **D-4 — Réutiliser le moteur de rendu** : l'épreuve rend les questions via les mêmes briques
  (`shuffleOptions`, `RichField`/`OptionContent`) mais dans un conteneur examen dédié
  (`src/features/exam/`) — PAS de fork d'`ExercisePlayer` (trop couplé quête/récompenses) ni
  d'import de la feature quest (frontières) : les briques partagées vivent déjà dans `shared/`.

**Modèle de données** (migration additive + GRANTs explicites) :

```sql
CREATE TABLE public.mock_exams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parcours_id TEXT NOT NULL REFERENCES public.parcours(id),
  title_fr TEXT NOT NULL, title_ar TEXT, title_en TEXT,
  duration_minutes INT NOT NULL CHECK (duration_minutes BETWEEN 15 AND 300),
  status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
  display_order INT NOT NULL DEFAULT 0, created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE public.mock_exam_papers (      -- une "épreuve" = un exercice pondéré
  exam_id UUID NOT NULL REFERENCES public.mock_exams(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id),
  points INT NOT NULL CHECK (points > 0),   -- barème de l'épreuve
  display_order INT NOT NULL, PRIMARY KEY (exam_id, exercise_id)
);
CREATE TABLE public.mock_exam_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exam_id UUID NOT NULL REFERENCES public.mock_exams(id),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  kind TEXT NOT NULL DEFAULT 'ranked' CHECK (kind IN ('ranked','practice')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  deadline   TIMESTAMPTZ NOT NULL,
  finished_at TIMESTAMPTZ,
  answers JSONB NOT NULL DEFAULT '{}'::jsonb,   -- {questionId: choice} au fil de l'eau (R-8)
  score_points NUMERIC, max_points INT,
  UNIQUE (exam_id, user_id, kind) DEFERRABLE INITIALLY IMMEDIATE  -- R-4 (unique ranked; practice: cf. note lot 1)
);
-- RLS: sessions owner-only; exams/papers SELECT authenticated (published only via policy), admin ALL.
-- NOTE lot 1: l'unicité ne vaut que pour kind='ranked' → index partiel UNIQUE (exam_id,user_id) WHERE kind='ranked'.
```

**Server** (SQL d'abord — le scoring reste en SQL comme tout le projet) :

- RPC `start_mock_exam(exam uuid, kind text)` SECURITY DEFINER : vérifie R-7 + R-4, crée la
  session, retourne (session, épreuves+questions **sans clés**).
- RPC `save_mock_answers(session uuid, answers jsonb)` : merge si deadline non passée (R-2/R-8).
- RPC `finish_mock_exam(session uuid)` : score en SQL (mêmes égalités que
  `submit_exercise_attempt`, pondérées par `points`), fige `finished_at`, applique R-5 (award_xp
  une fois, ranked only) ; retourne le détail par épreuve/chapitre.
- RPC `get_mock_exam_review(session)` : review complète seulement si `finished` (R-3) ;
  `get_mock_exam_percentile(session)` : window function (D-3, R-6).
- Server fns zod dans `src/features/exam/exam.server.ts` (wrap RPCs + `requireSupabaseAuth`) ;
  admin fns pour US-5.
- Les 4 RPCs sont REVOKE anon ; pgTAP complet (états, deadline, unicité ranked, percentile).

**Client** : `src/features/exam/` (barrel, `exam.server.ts`, `components/ExamShell`,
`ExamPaper`, `ExamResults`, `__tests__/`) ; routes `_authenticated/examens.tsx` (liste) et
`_authenticated/examen.$sessionId.tsx` (passation, guard deadline) ; chrono global affiché depuis
la deadline serveur (resync à chaque save, jamais source de vérité côté client).

**Observabilité** : log structuré start/finish/expire + compteur sessions abandonnées.

## 4. Plan d'exécution en lots

| lot | contenu                                                                  | objets créés                    | tests exigés                                                        | dépend de |
| --- | ------------------------------------------------------------------------ | ------------------------------- | ------------------------------------------------------------------- | --------- |
| 1   | Migration tables + RLS/grants + index partiel ranked                     | 1 migration                     | pgTAP (RLS, unicité ranked, contraintes)                            | —         |
| 2   | RPCs start/save/finish/review/percentile                                 | 1 migration RPCs                | pgTAP (deadline R-2, review-gate R-3, R-5 une fois, percentile R-6) | 1         |
| 3   | Server fns + liste examens + passation UI (chrono, navigation, autosave) | feature `exam/` + routes + i18n | Vitest (guards, autosave, états UI, RTL)                            | 2         |
| 4   | Résultats + percentile + liens remédiation                               | `ExamResults` + fns             | Vitest ; snapshot breakdown par chapitre                            | 3         |
| 5   | Admin composition/publication (US-5) + e2e authed                        | fns + UI admin                  | Vitest ; 1 spec e2e (start→finish practice)                         | 2         |

- [ ] Lot 1 — schéma & sécurité (merge seul, avant le code — DoD §7)
- [ ] Lot 2 — moteur SQL de session
- [ ] Lot 3 — passation
- [ ] Lot 4 — résultats & percentile
- [ ] Lot 5 — admin & e2e

**Stop-points** : lot 2 ne touche PAS aux RPCs existants (`submit_exercise_attempt` & co) ; lot 3
ne fork pas `ExercisePlayer` (D-4) ; aucun lot n'introduit de récompense hors constantes
centralisées ; la composition des examens (contenu) n'est pas du ressort de l'exécuteur.

## 5. Stratégie de test

pgTAP = cœur (machine d'états, fenêtres de temps simulées via `clock_timestamp` injecté/paramètre,
percentile avec jeu de 25 sessions). Vitest : fns (zod, guards entitlement), composants (chrono
resync, autosave debounce, états finished/expired). E2E authed : un examen practice complet sur le
projet TEST (seed dédié dans `scripts/e2e/`). Pas d'impact `smoke:shell` (routes authed).

## 6. Risques & mitigations

- **RISK-1** Partage des sujets entre élèves (probable/moyen) → D-1 rotation de sessions +
  percentile par examen (le partage fausse le classement, pas l'accès) ; v2 possible : variantes.
- **RISK-2** Triche au chrono (client) (probable/faible) → R-2 deadline serveur, saves refusés après.
- **RISK-3** Percentile trompeur à faible N (certain/faible) → R-6 seuil d'affichage 20.
- **RISK-4** Charge de la window function (rare/faible) → index (exam_id, score) ; D-3 note la
  bascule matérialisée si besoin.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : barème d'XP/coins de la récompense forfaitaire (proposition : 300 XP × score%, 60
  coins × score%, ranked uniquement).
- **Q-2** : cadence éditoriale des sessions (1/mois par concours ?) et qui compose (admin humain
  via US-5, ou pipeline contenu dédié ?).
- **Q-3** : le mode examen doit-il être ouvert en preview limitée aux non-entitled (marketing) ?
  v1 = non (R-7).

## 8. Journal d'exécution

_(vide — rempli par l'exécuteur, lot par lot)_

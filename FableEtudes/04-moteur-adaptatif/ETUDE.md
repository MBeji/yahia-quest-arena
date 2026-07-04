# Étude 04 — Moteur adaptatif & diagnostic de misconceptions

> **Statut** : brouillon
> **Priorité** : 04 · **Valeur** : le différenciateur défendable — chaque distracteur du contenu encode déjà une erreur nommée (protocole « erreur exécutée ») ; personne n'exploite ce signal. Diagnostic par élève → révision/remédiation personnalisées → progression mesurable (l'argument de vente parents) · **Complexité** : haute
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : volume d'usage (la télémétrie A0 doit tourner quelques semaines avant A2) ; le tagging de contenu (pipeline) monte en charge progressivement
> **Docs normatifs liés** : CLAUDE.md (gamification centralisée, anti-farm, gotcha grants), `content-engine/references/expert-exercises.md` (taxonomies de pièges — la matière première), ARCHITECTURE.md

## 1. Contexte & objectif produit

L'app sait _si_ l'élève a raté, pas _pourquoi_. Or le contenu d3–4 est construit pour que chaque
distracteur soit **l'exécution d'une erreur précise** (les taxonomies des prof-\*) : choisir le
distracteur « 0,45 > 0,5 » diagnostique « compare les décimaux par longueur d'écriture ». La table
`spaced_repetition_schedule` (SM-2) existe mais n'alimente aucune expérience visible (seul le
dashboard l'effleure). Objectif en trois marches : **A0** tracer le choix par question ; **A1**
transformer SM-2 en « Révision du jour » jouable ; **A2** profil de misconceptions + remédiation
recommandée. KPI : complétion de la révision du jour, delta de réussite sur notions remédiées,
rétention hebdo. Non-objectif (v1) : génération dynamique d'exercices (A3, gelé), IA générative,
crédit partiel.

## 2. Spécification fonctionnelle

- **US-1 (A1)** : chaque jour, je vois « Révision du jour » : 1–3 exercices existants recommandés
  (notions dues SM-2 + faiblesses récentes), avec la raison (« Tu n'as pas revu _Fractions_ depuis
  12 jours »). Les récompenses standard s'appliquent (règles anti-farm inchangées).
- **US-2 (A2)** : dans ma progression, un panneau « Tes points faibles » : jusqu'à 5 misconceptions
  actives, en langage élève (« Tu additionnes les dénominateurs »), chacune avec un bouton
  « S'entraîner » → l'exercice de remédiation du chapitre concerné.
- **US-3 (A2)** : le rapport parent inclut les 3 points faibles majeurs + tendance.
- **R-1** : la télémétrie n'enregistre que (question, option choisie, correct, contexte session) —
  jamais la clé ; aucune donnée nouvelle exposée au client hors agrégats de l'élève lui-même.
- **R-2** : une misconception est « active » à partir de **3 occurrences du même tag sur ≥2
  sessions dans les 30 derniers jours** (constantes centralisées, ajustables).
- **R-3** : la recommandation ne propose QUE des exercices accessibles à l'élève (gate premium
  `resolve_exercise_access` respecté ; sinon repli sur un exercice d1–2 du même chapitre).
- **R-4** : « Révision du jour » plafonnée (3 exercices) et sans nouveau type de récompense —
  c'est un _sélecteur_, pas une nouvelle économie.
- **R-5** : tags de misconception **namespacés par matière** (`math.frac.add-denominators`) et
  centralisés dans un registre versionné du pipeline contenu (pas de texte libre).
- **i18n** : libellés élève des tags en FR/EN/AR dans le registre (le tag est un id, jamais affiché).
- **Hors périmètre (v1)** : A3 (assemblage dynamique de missions à partir de questions
  individuelles — étude séparée quand A2 aura des données), notifications push de rappel (le cron
  notifications existant peut s'y brancher plus tard). La **maîtrise par compétence** (profil
  fractions/équations/géométrie, prérequis, BKT-allégé) et les modèles avancés (IRT/ML, gate de
  volume) sont l'**étude 07** — cette étude-ci reste le socle télémétrie + heuristique ; le lot
  A1.1 devient compétence-aware via le lot 5 de l'étude 07.

## 3. Architecture technique (décisions fermées)

- **D-1 — Les tags vivent côté serveur uniquement.** Si on taggait `options` JSONB (envoyé au
  client), l'option correcte serait la seule sans tag → **fuite de la clé**. Donc : nouvelle
  colonne `questions.distractor_tags JSONB` (`{"b":"math.frac.add-denominators", …}`), posture
  `correct_option` : jamais sélectionnée par une requête client. Rejeté : tagger dans `options`.
- **D-2 — Télémétrie append-only alimentée par le RPC existant.** `submit_exercise_attempt`
  (et `submit_dungeon_answer`) insèrent dans `question_attempts` dans la même transaction —
  extension additive du RPC, pas de nouveau round-trip client. Rejeté : événement côté client
  (falsifiable, incomplet).
- **D-3 — Recommandation = sélection d'exercices existants** (comme D-1 de l'étude 02) : aucun
  nouveau mode de session. L'algorithme est une fonction SQL lisible, pas du ML : score de
  priorité = retard SM-2 normalisé + poids misconceptions actives du chapitre + malus « déjà
  recommandé hier ». Rejeté v1 : bandit/ML (pas de données), génération dynamique (A3).
- **D-4 — Le tagging du contenu est progressif et outillé** : champ optionnel `misconceptionTag`
  par option dans les fichiers `content/` (schema zod additif) ; `sql-builder` route les tags vers
  `distractor_tags` (et les **retire** de `options`) ; registre `content/misconceptions.json`
  (id → libellés FR/EN/AR + matière) validé par `content:qa` (tag inconnu = erreur). Les skills
  prof-\* taguent naturellement (leurs tableaux de pièges = le registre) ; le stock existant est
  taggé par vagues via `content-audit`.

**Modèle de données** (migrations additives + GRANTs — gotcha CLAUDE.md) :

```sql
ALTER TABLE public.questions ADD COLUMN IF NOT EXISTS distractor_tags JSONB; -- server-only (R-1/D-1)
CREATE TABLE public.question_attempts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  chapter_id UUID NOT NULL,                -- dénormalisé pour l'agrégation
  choice TEXT NOT NULL, is_correct BOOLEAN NOT NULL,
  misconception_tag TEXT,                  -- résolu à l'insert depuis distractor_tags[choice]
  source TEXT NOT NULL CHECK (source IN ('exercise','quiz','dungeon','exam')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- RLS: owner SELECT (agrégats via RPC), admin ALL; INSERT uniquement via les RPCs SECURITY DEFINER.
-- Index: (user_id, created_at DESC), (user_id, misconception_tag) WHERE misconception_tag IS NOT NULL.
-- Rétention: purge >12 mois par le cron (job dédié) — la matière première reste les agrégats.
CREATE TABLE public.user_misconceptions ( -- agrégat entretenu à l'insert (trigger léger) — évite le scan
  user_id UUID NOT NULL, tag TEXT NOT NULL, occurrences INT NOT NULL DEFAULT 0,
  last_seen_at TIMESTAMPTZ NOT NULL, sessions_seen INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, tag)
);
```

**Server** : RPC `get_daily_plan()` (D-3 : retourne ≤3 exercice_ids + raisons, R-3/R-4) ;
RPC `get_my_weaknesses()` (tags actifs R-2 + libellés côté fn via le registre embarqué au build) ;
extension de `submit_exercise_attempt`/`submit_dungeon_answer` (D-2 — migration qui remplace les
fonctions, pgTAP de régression sur les récompenses) ; server fns zod dans
`src/features/progression/` (feature existante — la révision/faiblesses sont de la progression ;
pas de nouvelle feature). Rapport parent : extension de `parent-report` (US-3) via `shared/`.

**Client** : panneau « Révision du jour » sur le dashboard (composant dans `progression/`,
consommé par la route dashboard — via barrel public), panneau « Points faibles » dans la page
progression, extension du rapport parent. États vides soignés (« Rien à réviser, continue ! »).

**Observabilité** : logs agrégés d'insertion refusée / tag inconnu ; compteur plan-servi/plan-joué.

## 4. Plan d'exécution en lots

| lot  | contenu                                                                                               | tests exigés                                     | dépend de            |
| ---- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------ | -------------------- |
| A0.1 | Migration : `distractor_tags`, `question_attempts`, `user_misconceptions` (+RLS/grants/index/trigger) | pgTAP (RLS, trigger d'agrégat, R-1)              | —                    |
| A0.2 | Extension des 2 RPCs de soumission (D-2) + purge cron                                                 | pgTAP régression récompenses + insert télémétrie | A0.1                 |
| A0.3 | Pipeline : `misconceptionTag` (zod) + registre + routage sql-builder (D-4) + lint QA                  | Vitest schema/sql-builder ; content:check/qa     | A0.1                 |
| A1.1 | RPC `get_daily_plan` + fn + panneau « Révision du jour » (US-1, R-3/R-4)                              | pgTAP (sélection, gate premium) ; Vitest UI      | A0.2                 |
| A2.1 | RPC `get_my_weaknesses` (R-2) + panneau « Points faibles » (US-2)                                     | pgTAP (seuils R-2) ; Vitest UI + i18n libellés   | A0.2, A0.3 + données |
| A2.2 | Rapport parent enrichi (US-3)                                                                         | Vitest                                           | A2.1                 |

- [ ] A0.1 — schéma télémétrie (merge seul — DoD §7)
- [ ] A0.2 — capture (RPCs) + purge
- [ ] A0.3 — pipeline tags + registre
- [ ] A1.1 — révision du jour
- [ ] A2.1 — points faibles (GO humain : ≥4 semaines de télémétrie ou seuil de volume)
- [ ] A2.2 — rapport parent

**Stop-points** : A0.2 ne change AUCUN barème/gate de récompense (pgTAP de régression obligatoire
avant merge) ; les tags ne transitent jamais dans `options` (D-1) ; A2.1 attend le GO humain ;
le tagging de masse du stock existant est un chantier CONTENU (content-audit), pas un lot code.

## 5. Stratégie de test

pgTAP porte le risque : régression complète de `submit_exercise_attempt` (barèmes, anti-farm,
potions/shields — la matrice existante doit rester verte), trigger d'agrégat, seuils R-2, gate
R-3. Vitest : fns zod, panneaux (états vides/pleins, RTL). E2E authed : un cycle
« rater 3× le même tag → le point faible apparaît → l'exercice recommandé se lance » sur TEST.

## 6. Risques & mitigations

- **RISK-1** Régression du RPC de soumission (rare/critique) → lots A0.2 minuscule + pgTAP de
  régression exhaustif + `content-audit`/nightly en filet.
- **RISK-2** Fuite de clé via les tags (rare/critique) → D-1 (colonne server-only) + test pgTAP
  « distractor_tags jamais lisible par authenticated via les vues/requêtes client ».
- **RISK-3** Tags de mauvaise qualité → registre fermé (R-5) + lint + montée progressive (D-4) ;
  une misconception mal libellée se corrige dans le registre sans toucher aux données.
- **RISK-4** Reco perçue comme punitive (possible/moyen) → ton RPG des libellés, plafond R-4,
  états vides positifs ; mesurer plan-servi/plan-joué.
- **RISK-5** Volume `question_attempts` (long terme/faible) → append-only + index partiels +
  purge 12 mois + agrégat `user_misconceptions`.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : GO A2 — seuil de données jugé suffisant (proposition : 4 semaines OU 50k lignes).
- **Q-2** : les faiblesses sont-elles visibles par le parent par défaut (US-3) ou opt-in élève ?
- **Q-3** : politique de rétention télémétrie (proposition 12 mois) — conformité vie privée mineurs.

## 8. Journal d'exécution

_(vide — rempli par l'exécuteur, lot par lot)_

# Étude 17 — Rappel actif (rejouer les QCM en saisie libre)

> **Statut** : validée (Q-1…Q-4 arbitrées par Mohamed le 2026-07-13)
> **Priorité** : 17 · **Valeur** : ~2 000 missions « doublées » à coût de génération zéro — chaque QCM maîtrisé devient un exercice de mémorisation réelle (active recall) · **Complexité** : moyenne
> **Architecte** : Fable 5 / 2026-07-13 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : rien (le contenu QCM existant suffit) — s'articule avec l'étude 03 (seam `score_answer`, livrée) et l'étude 04-A1 (« Révision du jour », non livrée, voir §1) · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/interactive-question-types.md`, `docs/content-voice-and-composition.md`

## 1. Contexte & objectif produit

**Problème.** Le catalogue compte ~18 500 questions QCM authored (99,8 % du contenu jouable).
Un QCM réussi une fois n'exerce plus que la **reconnaissance** (retrouver la bonne option parmi 4) — la forme de mémoire la plus faible. La science de l'apprentissage est sans ambiguïté :
le **rappel actif** (produire la réponse sans assistance) consolide bien mieux que la
re-lecture ou le re-choix. Aujourd'hui, une mission terminée à 100 % est un cul-de-sac :
la rejouer ne rapporte plus rien (anti-farm `improved`) et n'apprend plus rien.

**Résultat attendu.** Chaque mission QCM dont l'élève a validé la totalité des questions se
débloque en **seconde forme** : mêmes questions, **zéro option affichée**, l'élève **tape** sa
réponse, le serveur la compare — normalisée — à la bonne réponse déjà en base. Aucune nouvelle
question, aucune donnée dupliquée, aucun coût de génération IA : c'est un **mode d'affichage et
de scoring** d'un exercice existant, plus difficile et mieux récompensé (XP ×1,5).

**État réel du code (audit 2026-07-13, chiffres mesurés sur `content/`)** — annexe §9 :

- 18 533 questions `mcq` sur 18 572 (39 natives) ; **12 431 éligibles (67,1 %)** à la saisie
  libre selon la règle déterministe R-2 (réponse courte tapable au clavier, énoncé
  auto-suffisant).
- **2 007 exercices sur 2 647 (75,8 %)** ont ≥ 3 questions éligibles → autant de missions
  « Rappel » potentielles. Taux homogène par langue (ar 70 %, fr 60 %, en 63 %).
- La couture technique existe déjà : le wire `answers: [{questionId, choice: string}]`
  transporte une chaîne libre (précédent `numeric`, étude 03), le scoring est factorisé
  derrière `score_answer(question, choice)` (5 RPCs), la clé (`correct_option` /
  `answer_key` / `explanation`) n'atteint **jamais** le client avant soumission
  (`getExercise` whitelist ses colonnes), et `exercise_sessions` est un simple jeton de
  timing sans snapshot.

**Pourquoi ce n'est PAS le non-goal « free-text grading » de la spec Tier B.**
`docs/interactive-question-types.md` exclut la correction de texte libre _subjective_ (essai,
pas de correcteur fiable). Le rappel actif est l'inverse : une **égalité déterministe** entre
la saisie normalisée et une chaîne cible courte déjà connue — même posture que le scoring
`numeric` (normalisation + comparaison), aucun correcteur, aucun jugement.

**Articulation avec l'étude 04-A1 (« Révision du jour »).** Complémentaires, pas concurrents :
04-A1 est un **sélecteur** (quels exercices re-proposer aujourd'hui), l'étude 17 est un
**mode de session** (comment rejouer UNE mission, en plus dur). Quand 04-A1 se réalisera, la
Révision du jour pourra proposer la variante Rappel pour les missions déjà maîtrisées — zéro
couplage requis aujourd'hui. Bonus télémétrie : une réponse tapée qui égale un distracteur
(normalisé) résout le même `misconception_tag` que le clic QCM (R-7) — le rappel **enrichit**
le moteur adaptatif au lieu de l'appauvrir.

**KPI de succès** : ≥ 20 % des élèves ayant une mission à 100 % lancent la variante Rappel
dans les 7 jours ; score moyen Rappel < score moyen QCM (preuve que le mode teste plus dur) ;
taux de signalements « réponse juste refusée » < 1 % des sessions Rappel (qualité de la
normalisation R-4).

**Ce que l'epic ne cherche PAS à faire** : générer ou reformuler des questions (0 IA),
introduire un nouveau `question_type` en base, du crédit partiel, un correcteur flou
(Levenshtein), ni toucher au quiz de compréhension, au Donjon ou aux duels (v1).

## 2. Spécification fonctionnelle

### Acteurs & parcours

Élève **connecté** uniquement (v1). L'anonyme ne voit pas le mode (R-9) : le déblocage repose
sur l'historique durable `attempts`, que l'anonyme n'a pas.

- **US-1 — débloquer.** Élève : quand je termine une mission QCM avec **toutes les questions
  justes** (100 %), le mode Rappel de cette mission se débloque ; l'écran de résultats me le
  célèbre (« Mode Rappel débloqué ! ») avec un CTA direct.
- **US-2 — rejouer sans filet.** Élève : dans le hub matière, une mission débloquée porte un
  second bouton « 🧠 Rappel » ; il ouvre la même mission, mêmes questions (celles éligibles),
  **sans aucune option** ; je tape ma réponse et je valide (Entrée ou bouton).
- **US-3 — être mieux récompensé.** Élève : une session Rappel réussie rapporte **XP ×1,5**
  (mêmes gates anti-farm que le mode classique, scopées à la variante — R-5/R-6) ; l'écran
  d'entrée m'annonce l'enjeu avant de jouer (gabarit « Mode », étude 15).
- **US-4 — comprendre mes erreurs.** Élève : à la fin (jamais pendant), la correction montre
  **ma réponse tapée** vs **la réponse attendue** (texte) + l'explication — comme en QCM.
- **US-5 — arabe équitable.** Élève (contenu ar) : je tape en arabe avec ou sans tashkeel,
  avec chiffres arabes-indics ou occidentaux, hamza approximative — la comparaison me juge
  sur le fond (R-4), l'input est RTL (R-8).
- **US-6 — pas de cul-de-sac.** Élève : une mission avec < 3 questions éligibles n'affiche
  jamais le mode (ni verrou ni promesse) ; une mission non terminée à 100 % montre le chip
  verrouillé avec la raison en une phrase.

**Flux écran par écran** (gabarits étude 15, registre élève, tutoiement, RPG dosé) :

1. **Hub matière `/matiere/$subjectId`** (connecté) : sous chaque mission éligible, chip
   secondaire « 🧠 Rappel » — état débloqué (lien) / verrouillé (`Lock` + tooltip
   « Termine d'abord la mission à 100 % ») / absent (inéligible ou anonyme). Le meilleur
   score Rappel s'affiche à côté quand il existe (même style que le score classique).
2. **Player `/quest/$exerciseId?variant=recall`** : bandeau d'en-tête « Mode Rappel · sans
   options · XP ×1,5 » ; question identique (RichField) ; **input texte** à la place du
   radiogroup, avec la **barre de caractères d'appoint** sous l'input (R-12 — chips par
   langue de contenu, ex. accents FR, hamza AR) ; bouton Indice **absent** (R-11) ;
   validation par question comme aujourd'hui.
   États : chargement identique au player actuel ; erreur `RECALL_LOCKED` /
   `RECALL_NOT_ELIGIBLE` → écran de verrou (même pattern que `QuizLockScreen`) avec CTA
   « Rejouer la mission en QCM ».
3. **Résultats** : grid récompenses standard (XP affiché = déjà multiplié), badge visuel
   « Rappel » sur le titre, `QuestReviewList` avec réponse tapée vs texte attendu,
   continuation primaire unique (mission suivante débloquée ou retour chapitre).
4. **Résultats d'une session QCM classique à 100 %** : bloc célébration « Mode Rappel
   débloqué ! » + CTA `?variant=recall` (uniquement si la mission est éligible R-2).

### Règles métier

- **R-1 — clé server-only, renforcée.** En variante Rappel, le client ne reçoit **ni**
  `options`, **ni** `correct_option`/`answer_key`, **ni** `explanation` avant soumission.
  La comparaison est exclusivement serveur (`SECURITY DEFINER`). Les fonctions de scoring
  et de normalisation sont `REVOKE`d de `anon`/`authenticated` (pas d'oracle).
- **R-2 — éligibilité déterministe (SQL, zéro donnée nouvelle).** Une question est éligible
  ssi TOUTES les conditions tiennent :
  (a) `question_type='mcq'` et `correct_option` non nul ;
  (b) ≥ 3 options ;
  (c) texte de la bonne option : 1–60 caractères, ≤ 6 mots, une seule ligne ;
  (d) sans contenu riche (`<svg`, `<img`, `![`, `$$`, `http`) ;
  (e) sans symbole mathématique de structure (`= < > ^ √ × ÷ ± ≤ ≥ ≠ ≈ → ∈ ∪ ∩`, exposants/
  indices Unicode…) ;
  (f) sans marqueur composite (`/`, `…`, `...`, `___`, parenthèse ouvrante initiale) ;
  (g) énoncé **auto-suffisant** : ne matche aucun motif « dépendant des options »
  (FR `lequel|laquelle|parmi|…suivant(e)s|ci-dessous|intrus|incorrect…`, EN
  `which of|following|below|odd one out…`, AR `مما يلي|من بين|أي من|الدخيل|الخاطئ…` —
  liste close dans la fonction SQL, annexe §9) ;
  (h) pas de collision : la bonne réponse normalisée ≠ un distracteur normalisé ;
  (i) **charset tapable au clavier** : la bonne réponse, une fois normalisée (R-4), ne
  contient que des lettres latines de base, des lettres arabes, des chiffres et le point
  décimal (`^[a-z0-9.ء-ي]+$`) — tout caractère qu'un clavier classique ne produit pas
  (grec, flèches, symboles spéciaux…) rend la question inéligible plutôt que la saisie
  injuste (mesuré : 0,5 % d'exclusions, annexe §9).
  Un **exercice** est éligible ssi ≥ `RECALL_MIN_QUESTIONS = 3` questions éligibles ;
  la session Rappel joue **uniquement** les questions éligibles, dans le `display_order`.
- **R-3 — déverrouillage (authoritative serveur).** La variante Rappel d'un exercice `E`
  s'ouvre ssi il existe `attempts(user, E, variant='classic')` avec `score_pct = 100`
  **et** `duration_seconds ≥ total_count × MIN_SECONDS_PER_QUESTION` (anti-rush, même
  posture que le quiz gate). Vérifié dans `start_exercise_session` (erreur `RECALL_LOCKED`)
  — le chip du hub n'est qu'un affichage. Jamais de rappel sur un `mode='quiz'` ni un
  exercice `source='parent'`.
- **R-4 — comparaison normalisée, stricte, tout-ou-rien.** Pipeline de normalisation
  (fonction SQL IMMUTABLE unique, §3) appliqué aux DEUX côtés ; égalité stricte ensuite.
  Pas de crédit partiel, pas de distance d'édition (v1). Une réponse vide/blanche = fausse.
- **R-5 — récompenses.** `xp = ROUND(xp_reward × (score_pct/100) × RECALL_XP_MULTIPLIER)`
  avec `RECALL_XP_MULTIPLIER = 1.5`, si et seulement si les gates standards passent
  (`score_pct ≥ 60`, non `tooFast` à 4 s/question sur le compte de questions éligibles,
  `score_pct >` meilleur score **de la variante** — R-6). Pièces : `reward_coins`
  inchangés (l'économie du jeu reste à instrumenter — étude 09). Potions/retry-shield/
  streak-shield : sémantique strictement identique au classique. Badges existants
  (`perfect_score`, `speed_demon`, `streak_7`) : déclenchement inchangé, quel que soit le
  variant.
- **R-6 — cloisonnement par variante.** `attempts.variant` scope le meilleur score, le
  flag `improved` et l'anti-farm : un 100 % classique ne prive pas la première session
  Rappel de ses XP, et réciproquement. `get_best_scores_by_exercise` ne renvoie que le
  classique (affichage hub inchangé) ; le meilleur score Rappel arrive par
  `get_recall_availability` (§3).
- **R-7 — télémétrie (étude 04 A0).** Chaque réponse Rappel appende `question_attempts`
  avec `choice = texte tapé` (≤ 512 c., borne wire existante) et `source='exercise'`.
  `misconception_tag` : si le texte tapé normalisé égale le texte normalisé d'UN
  distracteur, on résout `distractor_tags ->> <option_id>` de ce distracteur — sinon NULL.
  Le trigger `user_misconceptions` fonctionne sans changement.
- **R-8 — RTL/bidi.** L'input Rappel suit la langue du **contenu** (`content_language='ar'`
  → `dir="rtl"`), jamais forcé LTR (contrairement à `numeric`) ; l'affichage de la réponse
  tapée/attendue dans la review passe par `isolateLtrRuns` comme tout texte existant.
  `autocomplete/autocorrect/spellcheck` désactivés (le correcteur du téléphone ne doit pas
  souffler la réponse).
- **R-9 — anonyme. ⚠️ AMENDÉE le 2026-07-15 (arbitrage Mohamed).** ~~Aucune surface Rappel
  dans le registre public v1.~~ Désormais la mission Rappel est **découvrable par tous, anonyme
  inclus** : le hub matière affiche la **ligne de mission Rappel dédiée verrouillée** (cadenas +
  raison « connecte-toi et finis la mission à 100 % ») même déconnecté. L'éligibilité est dérivée
  du contenu (aucune donnée de compte), donc calculable sans session ; le déblocage (`unlocked`)
  et le meilleur score restent des concepts de compte → `false`/absent pour l'anonyme, jamais de
  lien jouable. Le RPC `get_recall_availability` est rendu appelable par `anon` (migration
  `20260715120000`, sans le garde `Unauthorized`), `getSubject` le résout pour tout le monde, et
  `RecallMissionRow` ne conditionne plus l'affichage à `isAuthenticated` (seule la raison change).
  Les routes de jeu Rappel (`/quest/$exerciseId?variant=recall`) restent gardées côté serveur
  (`start_exercise_session` → `RECALL_LOCKED`) : l'anonyme voit la promesse, il ne peut pas jouer.
- **R-10 — périmètre moteur.** Quiz de compréhension, Donjon, duels, examens : jamais de
  variante Rappel v1. `check_answers`, `score_quiz`, `submit_dungeon_answer` ne sont
  **pas modifiés**.
- **R-11 — pas d'indice en Rappel.** `explanation` contient souvent la réponse : le bouton
  Indice est absent du player en variante Rappel (`capabilities.hints = false`) et
  `consume_hint` reste inchangé (il n'est simplement jamais offert dans ce contexte).
- **R-12 — barre de caractères d'appoint (amendement 2026-07-13).** Sous l'input, une
  rangée de chips tapables insère les caractères peu accessibles au clavier, **définie
  statiquement par la langue du contenu** — JAMAIS dérivée de la réponse attendue (une
  barre par-réponse révélerait des lettres de la réponse : anti-fuite, même posture que
  R-1). Palettes v1 (constante UI `RECALL_CHAR_BAR` par langue) :
  FR → `à â ç é è ê ë î ï ô û ù œ` · AR → `أ إ آ ء ؤ ئ ة ى` · EN → aucune barre.
  Comportement : insertion au caret, focus conservé sur l'input, ordre RTL pour l'arabe,
  boutons avec `aria-label` (« insérer é »), masquée quand le clavier de l'OS suffit n'est
  PAS détectable → toujours affichée pour FR/AR. Ces chips sont un confort d'écriture :
  grâce à R-4 (accents/hamza/ta marbuta pliés, `%`/`°` insignifiants, ligatures `œ→oe`),
  **aucune réponse éligible n'exige un caractère absent du clavier** — critère (i).

### i18n

Nouvelles clés dans `fr.ts`/`en.ts`/`ar.ts` (app connectée uniquement, R-9) sous `t.quest.*` :
nom du mode, bandeau d'en-tête, chip hub (débloqué/verrouillé + tooltip), écran de verrou,
célébration de déblocage, placeholder de l'input, review (« Ta réponse » réutilisé). Libellés
du player pilotés par la **langue du contenu** via `buildQuestLabels` (mécanique existante).
Nom du mode **tranché (Q-2, 2026-07-13)** : FR « Rappel » (mode Rappel) · EN "Recall" ·
AR « الاسترجاع » — entrée lexique à ajouter à `docs/content-voice-and-composition.md` §2 au
lot 5. RPG dosé : la célébration peut titrer « Sans filet ! », les instructions restent
littérales (règle étude 15).

### Hors périmètre (v1)

Quiz de compréhension et Donjon en variante Rappel · anonyme (y c. teaser conversion) ·
crédit partiel / tolérance orthographique (Levenshtein — aucune extension fuzzy en base) ·
alias de réponses acceptées authored (`recallAnswers` dans le pipeline contenu — extension
v2 naturelle si le taux de signalements l'exige) · badge dédié Rappel · intégration
« Révision du jour » (étude 04-A1) · réglage per-question de l'éligibilité par les auteurs.

## 3. Architecture technique (décisions fermées)

### Modèle de données (migration additive unique, lot 1)

Aucune nouvelle table. Deux colonnes discriminantes (défaut = existant, zéro backfill) :

```sql
ALTER TABLE public.exercise_sessions
  ADD COLUMN variant text NOT NULL DEFAULT 'classic'
  CHECK (variant IN ('classic','recall'));

ALTER TABLE public.attempts
  ADD COLUMN variant text NOT NULL DEFAULT 'classic'
  CHECK (variant IN ('classic','recall'));

-- Anti-farm scopé + unlock : requêtes MAX(score_pct)/EXISTS par (user, exercise, variant)
CREATE INDEX IF NOT EXISTS idx_attempts_user_exercise_variant
  ON public.attempts (user_id, exercise_id, variant);
```

Pas de grant nouveau sur ces tables (les écritures passent par les RPCs DEFINER ; le SELECT
RLS « own rows » existant expose la colonne sans risque). `question_attempts` : **aucune
colonne ajoutée** — la variante se retrouve par jointure `session_id → exercise_sessions`.

### Fonctions SQL pures (lot 1) — le cœur du mode

```sql
-- Normalisation : IMMUTABLE, pur SQL (regexp_replace/translate/lower/normalize),
-- AUCUNE extension (unaccent/citext/pg_trgm absents du projet — décision D-2).
CREATE FUNCTION public.normalize_recall_text(p text) RETURNS text
IMMUTABLE LANGUAGE sql AS $$ ... $$;
```

Pipeline exact (appliqué dans cet ordre, testé table-driven en pgTAP) :

1. `normalize(p, NFKC)` puis `lower()` ;
2. dé-accentuation latine par `translate()` (map close : `àâäéèêëïîôöùûüÿçñ…`) et pliage
   des ligatures `œ → oe`, `æ → ae` (NFKC ne les décompose PAS — sans ce pliage, taper
   `soeur` contre `sœur` échouerait) ;
3. arabe : suppression tashkeel/tatweel (`[ً-ْ ـ ٰ]`), pliage `أ/إ/آ → ا`, `ى → ي`,
   `ة → ه` ;
4. chiffres arabes-indics (٠-٩, ۰-۹) → occidentaux ;
5. jonction des groupes de chiffres séparés par espaces (`1 000 → 1000`) ;
6. virgule décimale → point (`3,14 → 3.14`) ;
7. suppression de toute ponctuation/symbole **sauf** le `.` — y compris `%` et `°`,
   rendus **insignifiants** (amendement 2026-07-13 : `°` est introuvable sur beaucoup de
   claviers ; `50 %` ≡ `50`, `45°` ≡ `45` — l'ambiguïté intra-question est impossible par
   construction, critère (h) collision) ;
8. suppression des `.` non intercalés entre deux chiffres (point final, abréviations) ;
9. suppression de **tous** les espaces (comparaison insensible à la segmentation :
   `grand-père` = `grand père` = `grandpère`, `25 cm` = `25cm`).

```sql
-- Éligibilité question (R-2) : IMMUTABLE, fonction du seul row questions.
CREATE FUNCTION public.is_question_recall_eligible(q public.questions) RETURNS boolean
IMMUTABLE LANGUAGE plpgsql AS $$ ... $$;   -- critères R-2 (a)–(i), listes closes en tête

-- Scoring Rappel : STABLE. score_answer N'EST PAS MODIFIÉE (D-3).
CREATE FUNCTION public.score_recall_answer(q public.questions, p_choice text) RETURNS boolean
STABLE LANGUAGE sql AS $$
  SELECT public.normalize_recall_text(p_choice) = public.normalize_recall_text(
    (SELECT opt->>'text' FROM jsonb_array_elements(q.options) opt
      WHERE opt->>'id' = q.correct_option)
  ) AND btrim(coalesce(p_choice,'')) <> '';
$$;

REVOKE EXECUTE ON FUNCTION public.normalize_recall_text(text),
  public.is_question_recall_eligible(public.questions),
  public.score_recall_answer(public.questions, text)
  FROM PUBLIC, anon, authenticated;   -- pas d'oracle client (R-1)
```

### RPCs (lot 2) — recréations verbatim + branches `variant`

Pattern imposé : **recréer verbatim** la dernière définition et n'ajouter que la branche
Rappel (précédent : télémétrie A0, `20260706130000`). Aucune signature existante ne casse.

- **`start_exercise_session(p_exercise_id uuid, p_variant text DEFAULT 'classic')`** —
  remplace la version à 1 argument (`DROP FUNCTION` de l'ancienne signature + `CREATE` de
  la nouvelle, grants réappliqués ; l'appel TS existant reste valide grâce au défaut).
  Branche Rappel, APRÈS les portes actuelles (accès parcours + quiz gate) :
  `p_variant NOT IN ('classic','recall')` → exception `INVALID_VARIANT` ;
  exercice `mode='quiz'` ou `source<>'admin'` → `RECALL_NOT_ELIGIBLE` ;
  `COUNT(is_question_recall_eligible) < 3` → `RECALL_NOT_ELIGIBLE` ;
  R-3 non satisfaite → `RECALL_LOCKED`. Insère la session avec `variant`.
- **`submit_exercise_attempt(p_session_id, p_exercise_id, p_answers)`** — signature
  **inchangée** : la variante est lue depuis la session (`v_variant`). Branches :
  - scoring : `WHERE q.exercise_id = p_exercise_id` gagne
    `AND (v_variant = 'classic' OR public.is_question_recall_eligible(q))` ; le scorer est
    `CASE v_variant WHEN 'recall' THEN score_recall_answer(q, a.choice) ELSE score_answer(q, a.choice) END` ;
    `total_count` = questions éligibles en Rappel ;
  - anti-farm : `v_prev_best` filtré `AND variant = v_variant` (R-6) ;
  - XP : multiplicateur ×1,5 en Rappel (R-5), pièces inchangées ;
  - insert `attempts` avec `variant` ;
  - télémétrie : `misconception_tag` en Rappel = résolution « texte tapé ≡ distracteur »
    (R-7, sous-requête sur `jsonb_array_elements(q.options)` + `distractor_tags`) ;
  - retour JSON : + `variant`, + `perQuestion: [{questionId, isCorrect}]` **uniquement en
    Rappel** (D-4 — le TS ne doit jamais réimplémenter la normalisation pour la review).
- **`get_attempt_review(p_session_id)`** — recréée : quand la session est `recall`, ne
  renvoie que les questions éligibles et `correct_option` devient le **texte** de la bonne
  option (le client n'a pas les options pour mapper l'id) ; en classique, sortie inchangée.
- **`get_recall_questions(p_exercise_id uuid)`** — nouvelle, STABLE DEFINER,
  `GRANT authenticated` : `TABLE(id uuid, prompt text, display_order int)` des questions
  éligibles (jamais `options` — R-1), ordre `display_order`. Garde : mêmes contrôles
  d'accès que `getExercise` (exercice admin, non-quiz).
- **`get_recall_availability(p_subject_id text)`** — nouvelle, STABLE DEFINER,
  `GRANT authenticated` : `TABLE(exercise_id uuid, eligible_count int, unlocked boolean,
best_recall_pct numeric)` pour tous les exercices non-quiz du sujet — un seul
  aller-retour pour le hub (chips US-2/US-6).
- **`get_best_scores_by_exercise`** — recréée avec `WHERE variant = 'classic'`
  (comportement d'affichage hub inchangé, R-6).

### Server fns (lot 3, `src/features/quest/quest.server.ts`)

- `startExerciseSession` : input `{ exerciseId: z.guid(), variant: z.enum(["classic","recall"]).default("classic") }` ;
  relaie `RECALL_LOCKED` / `RECALL_NOT_ELIGIBLE` en erreurs localisées (pattern `QUIZ_LOCKED`).
- `getExercise` : input + `variant` ; en Rappel, les questions viennent de
  `get_recall_questions` (shape `{id, prompt, display_order, question_type:'mcq',
options: []}` — options vides par construction) et `hintCharges` est forcé à 0 (R-11).
- `submitAttempt` : inchangé côté wire (le `choice` tapé est déjà un `string(1..512)`) ;
  construit la review Rappel : `selectedChoice` = texte tapé (local), `correctChoice` =
  texte (RPC review), `isCorrect` = map `perQuestion` du submit (D-4).
- `getSubject` : quand authentifié, appelle `get_recall_availability` et expose
  `recall: { eligibleByExercise, unlockedByExercise, bestByExercise }` (dégradation
  gracieuse : RPC absente → objet vide, pattern `get_best_scores_by_exercise`).

### Client (lot 4)

- `src/shared/lib/answer-formats.ts` : type effectif `"recall"` → non-vide, ≤ 120 c.
  (borne UX ; le wire garde 512).
- `<RecallCharBar>` (nouveau, rendu par `<RecallInput>`) : chips d'insertion au caret
  (R-12), palettes dans une constante `RECALL_CHAR_BAR: Record<ContentLanguage, string[]>`
  co-localisée avec `quest-labels.ts` (contenu UI, pas une règle de jeu — ne va PAS dans
  `gamification.ts`) ; boutons `type="button"` + `aria-label`, ordre RTL en arabe, aucun
  rendu quand la palette de la langue est vide (EN).
- `question-input.tsx` : prop `variant` ; en Rappel rendre `<RecallInput>` (nouveau,
  calqué sur `NumericInput` : `type="text"`, `inputMode="text"`, `dir` = langue contenu,
  `data-testid="recall-answer-input"`, Entrée = valider, `autoComplete/autoCorrect/
spellCheck` off — R-8).
- `exercise-player.tsx` : `variant` traverse le player (search param validé
  `validateSearch` zod sur `/quest/$exerciseId` — première utilisation de search params
  sur cette route) ; bandeau d'en-tête Rappel ; `capabilities.hints=false` ;
  `getDisplayChoice` : en Rappel, afficher les textes bruts (pas de mapping lettre).
- `subject-hub.tsx` : chip « 🧠 Rappel » par mission (états US-6), données de
  `getSubject().recall`, visible seulement `isAuthenticated`.
- Résultat classique 100 % : bloc « Mode Rappel débloqué ! » + CTA (strategy connectée).
- `src/shared/constants/gamification.ts` : `RECALL_XP_MULTIPLIER = 1.5`,
  `RECALL_MIN_QUESTIONS = 3`, `RECALL_UNLOCK_SCORE_PCT = 100`,
  `RECALL_MAX_ANSWER_LENGTH = 120` (miroirs des constantes SQL, même règle de synchro que
  `PASS_THRESHOLD_PCT`).

### Sécurité & anti-triche

Invariants : la clé et la normalisation restent inaccessibles au client (REVOKE, R-1) ;
pas de nouvel oracle (le submit ne révèle les verdicts par question qu'APRÈS scoring d'une
session complétée, possédée, non-quiz) ; le déblocage est re-vérifié serveur au start (R-3) ;
rate limiting existant inchangé (sessions + bornes wire) ; RLS inchangée. Un élève qui
inspecte le réseau ne voit jamais mieux que ce que le mode QCM classique lui montrait déjà.

### Intégrations, env, observabilité

Aucune variable d'env, aucun service externe. Logs structurés existants des server fns ;
`RECALL_LOCKED`/`RECALL_NOT_ELIGIBLE` visibles dans les logs serveur comme `QUIZ_LOCKED`.
Suivi produit : les sessions Rappel se comptent en SQL (`attempts WHERE variant='recall'`).

### Décisions d'architecture (ADR)

- **D-1 — Variante de session, pas de nouveau `question_type` ni de nouvelles lignes.**
  Rejetés : (a) matérialiser des questions `recall` (duplique les données — contrainte
  produit explicite) ; (b) convertir `mcq → numeric` à la volée (ne couvre que les réponses
  numériques, ~12 % des éligibles). Le mode est un attribut de la **session**, résolu par
  les RPCs — zéro mutation du contenu, réversible en supprimant deux colonnes.
- **D-2 — Normalisation 100 % SQL pur, sans extension.** `unaccent`/`citext`/`pg_trgm`
  sont absents du projet ; en dépendre créerait un risque CI fresh-DB (gotcha grants/CLI
  pinnée) pour un gain nul — les maps `translate()` sont closes, déterministes, testables
  en pgTAP. Une seule source de vérité : le TS ne normalise jamais (D-4).
- **D-3 — `score_answer` intouchée ; scorer Rappel séparé.** La seam de l'étude 03 est
  appelée par 5 RPCs : la laisser verbatim réduit la surface de régression à zéro pour le
  classique. Le `CASE` sur `v_variant` vit dans `submit_exercise_attempt` seulement.
- **D-4 — Verdicts par question renvoyés par le submit (Rappel uniquement).** Alternative
  rejetée : re-comparer côté TS pour la review — duplique la normalisation, dérive
  garantie. Le RPC qui a scoré renvoie `perQuestion` ; le TS assemble sans logique métier.
- **D-5 — Déblocage lu dans `attempts` (durable), pas dans la télémétrie.** L'alternative
  « toutes les questions validées cumulativement » exigerait `question_attempts`, purgée à
  12 mois (pg_cron) → un déblocage qui expire. `attempts` est éternel, l'anti-rush du quiz
  gate s'y applique déjà. Arbitré Q-1 (2026-07-13) : cette option est la règle retenue.
- **D-6 — L'accès parcours suit l'exercice de base.** `resolve_exercise_access` inchangée :
  la variante n'est ni un exercice ni une difficulté en base (le « +1 étoile » est une
  présentation, R-5/US-3) — si le premium se réactive un jour, une mission verrouillée l'est
  dans les deux modes, sans cas particulier.
- **D-7 — Éligibilité calculée à la volée (STABLE), pas stockée.** Une colonne matérialisée
  serait une donnée dérivée à invalider à chaque rebuild contenu (UUIDv5 update-in-place).
  Les volumes (≤ 50 questions/exercice, index `exercise_id`) rendent le calcul négligeable.

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                                                                                                                                                                                 | tests exigés                                                                                                                                                                         | dépend de |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| 1   | Migration : colonnes `variant` + index, `normalize_recall_text`, `is_question_recall_eligible`, `score_recall_answer`, REVOKEs                                                                                   | pgTAP table-driven : normalisation (FR/AR/EN, chiffres, ponctuation), éligibilité (a)–(h), scorer, REVOKEs                                                                           | —         |
| 2   | Migration : `start_exercise_session` v2, `submit_exercise_attempt` (branches variant), `get_attempt_review` v2, `get_recall_questions`, `get_recall_availability`, `get_best_scores_by_exercise` scopée + grants | pgTAP : R-3 (LOCKED/NOT_ELIGIBLE/anti-rush), scoring Rappel bout-en-bout, R-5/R-6 (XP ×1,5, best scopé), R-7 (misconception typée), review texte, **régression classique inchangée** | lot 1     |
| 3   | Server fns : `startExerciseSession`/`getExercise`/`submitAttempt`/`getSubject` + zod + regen `types.ts`                                                                                                          | Vitest quest.test.ts : variant relayé, questions sans options, hints=0, review assemblée, erreurs localisées                                                                         | lot 2     |
| 4   | UI : `RecallInput` + `RecallCharBar` (R-12), player variant + search param, chip hub, écran verrou, célébration déblocage, i18n ×3, constantes gamification                                                      | Vitest : question-input (recall), char bar (insertion caret, RTL, a11y), exercise-player (bandeau, pas d'indice, review), subject-hub (états chip), answer-formats                   | lot 3     |
| 5   | E2E authed (`recall-mode.spec.ts` : débloquer → jouer → XP ×1,5 → review), `docs/guide-rappel-actif.md`, lexique voice doc, STATUS.md §3, ARCHITECTURE.md                                                        | Playwright authed + `npm run ci:verify` complet                                                                                                                                      | lot 4     |

- [x] Lot 1 — fondations SQL pures (rien d'appelable par le client)
- [x] Lot 2 — RPCs variant-aware (le mode existe en base, aucune UI)
- [x] Lot 3 — couche server fns/TS
- [x] Lot 4 — UI complète + i18n
- [x] Lot 5 — e2e + docs + lexique

**Stop-points.** Lot 1–2 sont DB-only : ne toucher AUCUN fichier `src/` (le défaut
`'classic'` garantit que le code déployé continue de fonctionner — DoD §7, migration
d'abord). Lot 3 ne crée aucun composant. Lot 4 ne touche pas au registre public
(`*-public.ts`, `/exercice`). Chaque lot = une PR, gate verte, migration jamais back-datée
(check `Migration order`). Un exécuteur qui rencontre une contradiction avec le code réel
STOPPE et escalade (règle FableEtudes).

## 5. Stratégie de test

- **pgTAP (lots 1–2, le gros de la confiance)** : la normalisation est testée en table
  (≥ 25 cas : accents FR, tashkeel/hamza/ta marbuta AR, chiffres arabes-indics, `3,14`/
  `3.14`, `1 000`, ponctuation, espaces, casse, vide) ; l'éligibilité critère par critère
  (un cas par lettre R-2 (a)–(h)) ; le flux submit Rappel complet sur données seedées ;
  et la **non-régression classique** : mêmes seeds, mêmes résultats qu'avant (XP, best,
  badges, télémétrie) quand `variant` est absent/`'classic'`.
- **Vitest (lots 3–4)** : pattern mock Supabase existant (`mockQuery`/`mockRpc`) pour les
  server fns ; Testing Library pour `RecallInput` (dir RTL, Entrée, spellcheck off),
  `RecallCharBar` (insertion au caret, focus conservé, palettes par langue, a11y),
  le player (bandeau, absence du bouton Indice, review textes), le hub (3 états du chip).
- **Playwright (lot 5, projet TEST)** : spec authed — jouer une mission QCM à 100 % (helper
  `answerKey` existant, pace anti-rush), vérifier le chip débloqué, jouer la variante
  Rappel en tapant `correctText` (le helper AdminDb expose déjà le texte de la bonne
  option), vérifier XP > XP classique équivalent et la review. Un cas contenu arabe.
- **smoke:shell** : couvert d'office (le bundle prod charge le player) — aucun ajout.

## 6. Risques & mitigations

- **RISK-1 — réponse juste refusée (normalisation trop stricte).** Probabilité moyenne,
  impact confiance élève. Mitigations : éligibilité conservatrice (R-2 exclut math,
  composites, phrases > 6 mots — mesuré à 67 % de couverture avec ces exclusions),
  cadrage UX « retrouve la réponse de la mission » (l'élève a déjà VU les réponses en
  QCM), bouton « Signaler une erreur » déjà présent sur le player, et télémétrie
  `question_attempts.choice` (texte tapé conservé 12 mois) pour auditer les refus et
  durcir/assouplir la normalisation par migration. KPI < 1 % de signalements.
- **RISK-2 — énoncé à réponses multiples valides** (ex. « Choisis la bonne question… » :
  plusieurs formulations correctes existent hors options). Probabilité moyenne, impact
  ponctuel (1 question sur N, jamais la session). Mitigations : motifs R-2 (g) excluant
  les tournures ouvertes les plus fréquentes (mesuré : 6,4 % d'exclusions), framing
  « réponse de la mission », signalement. V2 : champ authored `recallAnswers` (alias
  acceptés) dans le pipeline contenu si le signal le justifie.
- **RISK-3 — double farm XP entre variantes.** Faible : R-6 scope best/`improved` par
  variante ; les gates ≥ 60 %/tooFast/amélioration restent, et le multiplicateur ne
  s'applique qu'à des XP légitimes.
- **RISK-4 — régression du RPC chaud `submit_exercise_attempt`.** Faible probabilité,
  impact fort. Mitigations : recréation verbatim + branche (pattern éprouvé A0), pgTAP de
  non-régression classique, déploiement migration-d'abord (le code TS du lot 3 n'arrive
  qu'après), `pgTAP suite` sur PR.
- **RISK-5 — saisie mobile pénible (clavier, RTL, autocorrect, caractères spéciaux).**
  Moyenne/UX. Mitigations : attributs R-8, réponses cibles courtes par construction
  (≤ 60 c., 83 % ≤ 30 c.), Entrée pour valider, **barre de caractères d'appoint R-12** +
  critère (i) (aucune réponse éligible n'exige un caractère hors clavier) + `%`/`°`/
  ligatures neutralisés par R-4, e2e mobile public non requis (mode connecté) mais test
  manuel mobile au lot 4.
- **RISK-6 — dérive éligibilité SQL vs audit TS.** Faible : l'audit (annexe §9) est un
  one-shot de conception ; la seule source runtime est la fonction SQL. Le lot 5 documente
  dans le guide que toute évolution des critères se fait par migration + re-mesure.

## 7. Questions ouvertes (pour l'humain)

**Section vidée — les quatre questions ont été arbitrées par Mohamed le 2026-07-13** (trace) :

- **Q-1 — Règle de déblocage → tranché : un run classique à 100 %** (+ durée anti-rush),
  tel qu'écrit en R-3/D-5. La variante cumulative (table d'agrégat) est écartée.
- **Q-2 — Nom du mode → tranché : FR « Rappel » / EN "Recall" / AR « الاسترجاع »**,
  célébrations RPG « Sans filet ! » en habillage. Entrée lexique à ajouter au lot 5.
- **Q-3 — Pièces → tranché : inchangées** (seul l'XP porte la difficulté ; économie du jeu
  à instrumenter par l'étude 09).
- **Q-4 — Multiplicateur XP → tranché : ×1,5** (`RECALL_XP_MULTIPLIER = 1.5`).

## 8. Journal d'exécution

- 2026-07-13 — étude créée (brouillon). Audit d'éligibilité mesuré sur `content/` (annexe
  §9). PR #399.
- 2026-07-13 — Q-1…Q-4 arbitrées par Mohamed (toutes sur les recommandations) → statut
  **validée**. PR #401.
- 2026-07-13 — amendement (demande Mohamed, avant exécution) : caractères hors clavier.
  Nouvelle règle **R-12** (barre de caractères d'appoint par langue, jamais dérivée de la
  réponse), R-4 durci (ligatures `œ/æ` pliées, `%`/`°` insignifiants), nouveau critère
  d'éligibilité **(i)** charset tapable (0,5 % d'exclusions), annexe §9 re-mesurée.
  Aucun lot démarré — prête pour l'exécuteur (lot 1).
- 2026-07-14 — **Lot 1 livré** : migration `20260714120000_recall_mode_foundations.sql`
  (colonnes `variant` sur `exercise_sessions`/`attempts` + index anti-farm ;
  `normalize_recall_text` IMMUTABLE — pipeline 9 étapes ; `is_question_recall_eligible`
  IMMUTABLE — R-2 (a)–(i) ; `score_recall_answer` STABLE ; REVOKEs R-1). Test pgTAP
  `supabase/tests/28_recall_mode_foundations.test.sql` (38 assertions : normalisation
  FR/AR/EN table-driven, éligibilité critère par critère, scorer, REVOKEs). DB-only,
  aucun fichier `src/` touché. Écart accepté : critère R-2(a) implémenté en
  `question_type = 'mcq'` **strict** (le pipeline de contenu écrit toujours `'mcq'`
  explicitement — cf. `sql-builder.ts`), conforme à la posture « précision d'abord ».
- 2026-07-14 — **Lot 2 livré** : migration `20260714130000_recall_mode_rpcs.sql`. Six RPCs
  recréés VERBATIM depuis leur dernière définition + branche Rappel additive (pattern A0) :
  `start_exercise_session` v2 (`p_variant text DEFAULT 'classic'` ; porte R-3 après premium +
  quiz gate : `INVALID_VARIANT`, `RECALL_NOT_ELIGIBLE` quiz|non-admin|< 3 éligibles,
  `RECALL_LOCKED`), `submit_exercise_attempt` (variante lue depuis la session, jamais du
  client ; scoring éligible via `score_recall_answer`, anti-farm/best scopés par variante R-6,
  XP ×1,5 R-5, misconception typée par appariement de texte R-7, retour `variant`+`perQuestion`
  D-4), `get_attempt_review` v2 (Rappel : questions éligibles seules, `correct_option` = TEXTE
  de la bonne option), `get_best_scores_by_exercise` (+ `variant = 'classic'`, R-6) ; deux
  nouvelles fonctions `get_recall_questions` (prompt seul, jamais d'options — R-1) et
  `get_recall_availability` (compteur éligible + déblocage + meilleur Rappel). Test pgTAP
  `supabase/tests/29_recall_mode_rpcs.test.sql` (26 assertions : porte R-3, scoring bout-en-bout,
  R-5/R-6/R-7, review texte, `get_recall_*`, **non-régression classique**). DB-only, aucun
  fichier `src/` touché (le défaut `'classic'` garde le code déployé inchangé).
- 2026-07-14 — **Lot 3 livré** : couche server fns/TS (premier lot qui touche `src/`).
  `types.ts` amendé à la main hors-ligne (pas de stack Supabase locale) : `p_variant?` sur
  `start_exercise_session`, + `get_recall_questions` et `get_recall_availability`. Dans
  `quest.server.ts` : `startExerciseSession` relaie `variant` (zod enum fermé, défaut `classic`)
  au RPC et mappe `RECALL_LOCKED`/`RECALL_NOT_ELIGIBLE`/`INVALID_VARIANT` vers leurs messages
  localisés (pattern `QUIZ_LOCKED`) ; `getExercise` porte `variant`, sert le jeu Rappel via
  `get_recall_questions` (prompt seul, `options: []` — R-1) et force `hintCharges = 0` (R-11) ;
  `submitAttempt` assemble la review depuis `get_attempt_review` (`correct_option` = TEXTE) en
  prenant les verdicts par question du RPC de soumission (`perQuestion`, D-4 — jamais re-normalisé
  côté TS) et expose `variant` ; `getSubject` expose `recall {eligibleByExercise, unlockedByExercise,
bestByExercise}` via `get_recall_availability` avec dégradation gracieuse (RPC absent → objets
  vides, pattern `get_best_scores_by_exercise`). Helpers extraits dans un module co-localisé
  `quest.recall.ts` (constantes + `fetchRecallQuestions`/`fetchRecallAvailability`/
  `buildAttemptReview`/`toPerQuestion`) pour rester sous le plafond `max-lines`. Tests co-localisés
  `__tests__/recall-mode.test.ts` (10 cas : variant relayé, jeu Rappel sans options, hints=0,
  review sourcée du `perQuestion`, erreurs localisées, dispo + dégradation) + contrats de shape
  non-régression mis à jour. Gate vert (lint/typecheck/1307 tests vitest). Aucune migration
  (lot pur TS) ; aucun composant UI (réservé au lot 4).
- 2026-07-15 — **Lot 4 livré** : couche UI complète + i18n ×3 + constantes gamification.
  Constantes (`gamification.ts`) : `RECALL_XP_MULTIPLIER = 1.5` (R-5), `RECALL_MIN_QUESTIONS = 3`,
  `RECALL_UNLOCK_SCORE_PCT = 100`, `RECALL_MAX_ANSWER_LENGTH = 120`. `answer-formats.ts` :
  type effectif `recall` (non vide ≤ 120, accepte la ponctuation que les CSV rejettent).
  `QuestionInput` reçoit `variant` : en `recall` il rend `RecallInput` (champ libre, `dir` =
  langue de contenu R-8, autocomplete/correct/spellcheck off, Entrée valide si non vide) +
  `RecallCharBar` (palette STATIQUE par langue R-12, insertion au caret, `type=button` + aria,
  RTL, rien si palette vide → anglais). `RECALL_CHAR_BAR` vit dans `quest-labels.ts` (contenu UI,
  jamais dérivé de la réponse — anti-fuite). `exercise-player.tsx` : prop `variant`, clé/fn de
  query portant `variant`, bandeau Rappel (testid `recall-banner`), écran verrou `recall`
  (LOCKED/NOT_ELIGIBLE via `QuizLockScreen`, CTA « rejouer en QCM »), pas d'indice (R-11),
  `getDisplayChoice` recall-aware (texte libre, jamais branche CSV B2), célébration de déblocage
  après un 100 % classique (`?variant=recall`). Écran résultat extrait dans un nouveau composant
  `quest-result-screen.tsx` (badge Rappel + déblocage) pour rester sous le plafond `max-lines`.
  Route `quest.$exerciseId.tsx` : `validateSearch` (`variant?` optionnel — `.default()` rendrait
  `search` obligatoire sur tous les `<Link>`), défaut à la destructuration. `SubjectHub` : chip
  « 🧠 Rappel » par mission (3 états US-6 : absent < 3 éligibles/anon/quiz, verrou inerte, lien
  déverrouillé + meilleur score), gardé sur `isAuthenticated` (R-9). i18n `t.quest.recall*` ×3
  (badge, déblocage, chip). Tests co-localisés : `question-input` (recall + char bar : insertion
  caret, RTL, a11y, palette vide masquée), `exercise-player` (bandeau, options remplacées, verrou),
  `subject-hub` (états chip), `answer-formats` (validation recall). Gate vert (lint incl. RTL/token
  guards, typecheck, 1322 tests vitest). Aucune migration (lot UI pur) ; registre public intact (R-9).
  Suivi (même lot) : `validateSearch` réécrit en fonction plate sans `zod` — le schéma zod faisait
  basculer l'heuristique de partage de Rollup et hissait toute la lib (~63 kB min) dans le chunk
  `index` eager (434→498 kB, hors budget 450) ; validateur zéro-dépendance équivalent → index 435 kB.
- 2026-07-15 — **Lot 5 livré** : e2e + docs. `e2e/authed/recall-mode.spec.ts` (maîtriser un QCM
  100 % non-rushé → chip `recall-chip-unlocked` sur le hub → jouer en saisie libre `?variant=recall`
  → review + XP créditée), helper `adminDb.recallReadyExercise()` (sélection d'une mission
  non-scolaire à ≥ 3 questions éligibles + clé de réponse), Page Object `QuestPage.answerRecallAll`
  - getters `recallBanner`/`recallInput`/`prompt`. Skip propre si le catalogue TEST n'a rien
    d'éligible ; le ×1,5 exact reste épinglé par pgTAP R-5 (XP monotone sous utilisateur partagé).
    Doc fonctionnel `docs/guide-rappel-actif.md` (parcours élève, déblocage, récompenses, ops,
    constantes), ligne « rappel actif » ajoutée au lexique trilingue `content-voice-and-composition.md`
    §2 (FR Rappel · EN Recall · AR استرجاع), `STATUS.md` §3/§4 (feature 🟢, étude 17 → Livrées),
    `ARCHITECTURE.md` §8/§8b (colonnes `variant`, sous-section « Active recall »), guide listé dans
    `CLAUDE.md`. Gate `ci:verify` vert. Aucune migration.

## 9. Annexe — audit d'éligibilité (mesuré le 2026-07-13, re-mesuré après l'amendement R-12/(i))

Méthode : script one-shot sur les fichiers `content/**/exercices/*.json` + `quiz.json`
(75 dossiers sujets authored), appliquant les critères R-2 (a)–(i) et la normalisation R-4
durcie. Chiffres au niveau authored (les sujets `compileTo` du lycée comptent une fois).

| Mesure                                               | Valeur                                            |
| ---------------------------------------------------- | ------------------------------------------------- |
| Questions totales / `mcq`                            | 18 572 / 18 533 (99,8 %)                          |
| Questions `mcq` **éligibles**                        | **12 431 (67,1 %)**                               |
| — dont réponse purement numérique                    | 1 543                                             |
| — dont « réponse sûrement unique » (cloze/numérique) | 4 303 (23,2 %)                                    |
| Exercices avec ≥ 3 questions éligibles               | **2 007 / 2 647 (75,8 %)**                        |
| Exercices avec ≥ 4 questions éligibles               | 1 663 (62,8 %)                                    |
| Exercices 100 % éligibles                            | 767 (29,0 %)                                      |
| Quiz avec ≥ 3 éligibles (hors périmètre v1)          | 417 / 533 (78,2 %)                                |
| Par langue (éligibles/total)                         | ar 8 692/12 448 · fr 2 093/3 513 · en 1 646/2 611 |

Exclusions (cumulables) : réponse > 6 mots 24,4 % · > 60 caractères 10,7 % · énoncé
dépendant des options 6,4 % · symboles math 5,6 % · réponse composite 2,1 % · contenu riche
(SVG/img/URL) 1,4 % · collision distracteur normalisé 0,8 % · **charset hors clavier,
critère (i) : 0,5 %**. Longueurs des bonnes réponses :
≤ 15 c. 54 % · 16–30 c. 16 % · 31–60 c. 19 % · > 60 c. 11 %.

Lecture : la règle R-2 est volontairement **conservatrice** (précision d'abord — un refus
injuste coûte plus cher qu'une question non proposée). Le sous-ensemble « cloze strict »
(23,3 %) a été rejeté comme règle v1 : il tuerait l'objectif de doubler le contenu. Les
seuils (60 c. / 6 mots / min 3 questions) sont des constantes nommées de la fonction SQL —
re-calibrables par migration après télémétrie réelle.

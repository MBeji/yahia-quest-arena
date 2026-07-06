# Étude 03 — Types de questions natifs (Tier B : numeric, ordering, matching, multi)

> **Statut** : en exécution — **phases B1 (`numeric`) et B2 (`ordering`+`matching`) livrées
> intégralement** (2026-07-05) ; **phase B3 (`multi`) en cours** (GO humain reçu le 2026-07-06)
> **Priorité** : 03 · **Valeur** : tue la devinette par élimination (saisie numérique), vraie manipulation (drag & drop), jugement multi-sélection — l'expérience d'exercice passe un cran au-dessus de tout QCM concurrent · **Complexité** : haute (5 RPC SQL + UI + pipeline), mais dé-risquée : la spec normative est déjà écrite
> **Architecte** : Fable (claude-fable-5), 2026-07-04 · **Exécuteur cible** : Sonnet
> **Dépend de** : rien (indépendant) ; recommandé avant le lancement bac (annales en saisie numérique)
> **Docs normatifs liés** : **`docs/interactive-question-types.md` (LA spec — normative, à lire en entier avant tout lot)**, CLAUDE.md (DoD §7, gotcha grants), `content-engine/references/interactive-formats.md` (Tier A, reste valide)

## 1. Contexte & objectif produit

Cette étude est l'**enveloppe d'exécution** de `docs/interactive-question-types.md` : la spec y
fixe le modèle de données (`question_type` + `answer_key`), la sémantique de scoring par type, la
carte exacte des points de code à modifier, et le phasage B1→B3. Ne rien re-décider ici — cette
étude découpe la spec en lots exécutables et fixe les critères d'acceptation.
KPI : part des nouvelles missions math/physique utilisant `numeric` ; écart de score moyen
QCM vs numeric sur une même notion (mesure de l'anti-devinette) ; zéro régression `'mcq'`.

## 2. Spécification fonctionnelle

Voir la spec §« Target data model » (tableau des 5 types) et §« Why ». Résumé opérationnel :

- **US-1** : une question `numeric` affiche un champ de saisie (clavier numérique mobile), accepte
  `-`, `.`/`,` (normalisées), valide serveur avec tolérance.
- **US-2** : une question `ordering`/`matching` se manipule par drag & drop (et tap-to-order en
  accessibilité/mobile), soumission encodée en un `choice` string (format spec).
- **US-3** : une question `multi` affiche des cases à cocher avec la mention explicite
  « sélectionne TOUTES les bonnes réponses ».
- **US-4** : les anciennes questions `'mcq'` sont rendues et scorées **strictement à l'identique**.
- **R-1** : la clé (`answer_key`) n'atteint JAMAIS le client (posture `correct_option`).
- **R-2** : tout-ou-rien par question, pas de crédit partiel (v1 — spec §Non-goals).
- **R-3** : un type non supporté par le client affiché = item « indisponible » propre, jamais un
  crash de session (posture rollback de la spec).
- **R-4** : RTL — la saisie numérique reste LTR isolée dans un contexte arabe (réutiliser
  `isolateLtrRuns`) ; le drag & drop fonctionne en direction RTL.
- **Hors périmètre** : texte libre noté, crédit partiel, tout changement du modèle de langue.

## 3. Architecture technique (décisions fermées)

Intégralement dans la spec — carte des touchpoints (5 RPCs SQL, zod/TS, UI, pipeline contenu) :
`docs/interactive-question-types.md` §« Touchpoint map ». Décisions d'exécution complémentaires :

- **D-1** : la couture SQL est UNE fonction `score_answer(question, choice) returns boolean`
  appelée par les 5 RPCs — livrée et pgTAP-ée AVANT toute UI (elle porte tout le risque).
- **D-2** : chaque phase (B1 `numeric` → B2 `ordering`+`matching` → B3 `multi`) est une séquence
  de lots complète et **shippable seule** ; on ne commence pas B2 avant que B1 soit en prod et que
  du contenu `numeric` existe.
- **D-3** : drag & drop = `@dnd-kit` (léger, accessible, RTL-ok, pas de dépendance lourde) —
  ajouté en B2 seulement ; vérifier le budget bundle (`build:check`) et le chunking manuel
  (gotcha vite.config).
- **D-4** : le pipeline contenu passe à un `questionSchema` en union discriminée avec défaut
  `'mcq'` — **zéro fichier existant modifié** ; `content:qa` gagne des lints par type (spec
  §Content pipeline). Les skills (`content-interactif`, prof-\*) ne sont mis à jour qu'à la levée
  du ban Tier-B, phase par phase (dernier lot de chaque phase).

## 4. Plan d'exécution en lots

**Phase B1 — `numeric`** (prouve toute la couture) :

| lot  | contenu                                                                                                                           | tests exigés                                                                      | dépend de |
| ---- | --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------- |
| B1.1 | Migration : `question_type` + `answer_key` (+GRANTs), fonction `score_answer` (mcq fast-path + numeric), branchée dans les 5 RPCs | pgTAP : mcq inchangé (régression), numeric ±tolérance, clés jamais exposées (R-1) | —         |
| B1.2 | Serveur/types : zod par type dans quest+dungeon server fns, regen `types.ts`                                                      | Vitest fns (formats de `choice`)                                                  | B1.1      |
| B1.3 | UI : extraction `<QuestionInput>` + `NumericInput` (+ R-3 fallback, R-4 RTL) — quest ET dungeon unifiés                           | Vitest composants ; e2e public 1 spec ; smoke:shell                               | B1.2      |
| B1.4 | Pipeline : union discriminée schema.ts + sql-builder + lints QA ; MàJ skills (levée du ban `numeric`)                             | Vitest schema/sql-builder ; content:check/qa verts                                | B1.1      |

- [x] B1.1 — DB + couture scoring (merge seul d'abord — DoD §7)
- [x] B1.2 — serveur
- [x] B1.3 — UI
- [x] B1.4 — pipeline + skills

**Phase B2 — `ordering` + `matching`** : mêmes 4 lots (B2.1 étend `score_answer`; B2.3 =
`OrderingBoard`/`MatchingBoard` avec @dnd-kit — D-3). **Phase B3 — `multi`** : idem, plus l'UX
« toutes les bonnes réponses » (US-3). Chaque phase démarre sur GO humain après la précédente (D-2).

- [x] B2.1 — DB + couture scoring étendue (merge seul d'abord — DoD §7)
- [x] B2.2 — serveur
- [x] B2.3 — UI (@dnd-kit)
- [x] B2.4 — pipeline + skills

- [x] B3.1 — DB + couture scoring étendue (merge seul d'abord — DoD §7)
- [x] B3.2 — serveur
- [x] B3.3 — UI (cases à cocher, US-3)
- [ ] B3.4 — pipeline + skills

**Stop-points** : ne jamais modifier la sémantique `'mcq'` ; ne jamais sélectionner `answer_key`
dans une requête client ; ne pas anticiper une phase ; tout écart avec la spec = STOP + escalade
(la spec gagne sur cette étude en cas de conflit).

## 5. Stratégie de test

Le filet principal est **pgTAP sur `score_answer`** (matrice type × cas limites : tolérance 0,
virgule/point, ordre partiel faux, paires inversées, sous-ensemble multi). Vitest : composants
d'input (clavier, a11y, RTL), fns. E2E public : une mission de démo par type sur le projet TEST.
`smoke:shell` obligatoire aux lots UI (le player est du code prod-gated). Non-régression :
la suite existante entière + un pgTAP « old mcq rows score identically ».

## 6. Risques & mitigations

- **RISK-1** Régression du scoring mcq (rare/critique) → D-1 fast-path inchangé + pgTAP de
  régression dédié avant toute UI.
- **RISK-2** Fuite de clé via `answer_key` (rare/critique) → R-1 testé (pgTAP SELECT policies +
  revue des vues/requêtes client au lot B1.2).
- **RISK-3** Poids bundle @dnd-kit (possible/moyen) → D-3 : import en B2 seulement, chunk dédié,
  `build:check` gate.
- **RISK-4** Contenu numeric mal calibré (tolérances) (possible/moyen) → lint QA dédié (B1.4) +
  passage `content-audit`.

## 7. Questions ouvertes (pour l'humain)

- **Q-1** : GO de phase — valider B1 en prod (et premier lot de contenu numeric) avant d'ouvrir B2.
- **Q-2** : faut-il un fallback « ancien client mobile » au-delà de R-3 (versioning d'app) ? v1 :
  non (web only).

## 8. Journal d'exécution

### Lot B1.1 — 2026-07-05 (exécuté par le modèle architecte, Fable)

Livré : migration `20260705130000_native_question_types_b1_score_answer.sql`
(colonnes `question_type`/`answer_key` + grants, fonction `score_answer`, les 5 RPCs
re-créés verbatim avec la seule couture changée) + pgTAP
`supabase/tests/16_score_answer_native_types.test.sql` (24 assertions : matrice
mcq/numeric, contraintes de forme de clé, R-1, bout-en-bout sur les 5 RPCs).
Validé localement : les ~200 migrations s'appliquent sur base vierge, suite pgTAP
complète 151/151, `npm run verify` vert.

Écarts acceptés (arbitrage architecte — le code réel rendait la spec incomplète) :

1. **`correct_option` passe NULL-able** + CHECK `questions_answer_key_shape_check`
   (mcq ⇒ `correct_option` non nul ; non-mcq ⇒ `answer_key` non nul). La colonne
   était `NOT NULL` : aucune question `numeric` n'était insérable sans ça. La spec
   ne le mentionnait pas ; changement additif minimal, sans effet sur les lignes
   existantes.
2. **`get_attempt_review` ne comporte aucune égalité à remplacer** (la spec listait
   les « 5 sites qui font `q.correct_option = a.choice` », mais ce RPC ne compare
   pas — il révèle la correction). Le branchement retenu : révélation type-aware,
   `COALESCE(correct_option, answer_key->>'value')` dans la colonne `correct_option`
   existante (même signature, même gate session-possédée-et-complétée). Idem pour
   la révélation de `check_answers` et le `correctChoice` du donjon.
3. **CHECK `questions_question_type_check`** ferme la liste aux 5 types de la spec
   (mcq/numeric/ordering/matching/multi) — garde-fou anti-typo au niveau DB ; les
   types B2/B3 sont stockables (le pipeline garde son ban) mais scorent `false`
   sans exception (posture R-3).

### Lot B1.2 — 2026-07-05 (exécuté par le modèle architecte, Fable)

Livré : validation de format par type dans les server fns (`quest.server.ts` :
`submitAttempt`/`checkAnswersPublic`/`scoreQuizPublic` ; `dungeon.server.ts` :
`submitDungeonAnswer`) via le helper partagé `src/shared/lib/answer-formats.ts`
(`choice` reste un string sur le fil ; borne 512 ; `numeric` = nombre décimal
point/virgule ; fetch du `question_type` client-lisible, dégradation ouverte si le
fetch échoue — les RPCs restent garbage-safe) ; `types.ts` mis à jour à la main
(hors-ligne, minimal : colonnes `questions` + signature `get_attempt_review`).
Tests : +18 Vitest (helper + 4 fns), pgTAP 153/153, `verify` vert.

Écart accepté (arbitrage architecte) :

4. **Le lot gagne une migration additive** `20260705150000_get_attempt_review_scored.sql` :
   `get_attempt_review` accepte un `p_answers` optionnel et retourne `is_correct`
   scoré via `score_answer`. Sans ça, la correction de fin de quête (recalculée en
   égalité de chaîne dans `submitAttempt`) contredirait le score pour une réponse
   numeric dans la tolérance (comptée juste, affichée fausse). L'ancienne forme
   d'appel (sans réponses) reste valide (`is_correct` NULL) — fenêtre de déploiement
   sûre ; tous les gates du RPC sont inchangés.

### Lot B1.3 — 2026-07-05 (exécuté par le modèle architecte, Fable)

Livré : `<QuestionInput>` par type (`src/features/quest/components/question-input.tsx`) —
radiogroup mcq historique (styles/indicateurs injectés par la surface), `NumericInput`
(clavier décimal mobile, `dir="ltr"` forcé même en sujet RTL — R-4, hint/erreur de
format), fallback R-3 « question indisponible » (sentinel auto-rempli, la session
reste terminable) — branché dans le player quest ET la route donjon (le bloc options
dupliqué du donjon est supprimé). Labels trilingues dans `buildQuestLabels`.
`getExercise` expose `question_type` ; le payload donjon aussi (écart 5).
Extraction complémentaire `QuestReviewList` (la spec listait « review display » dans
l'extraction ; le player dépassait sinon le cap max-lines). E2E : page-object
type-aware + spec `native-question-types.spec.ts` (skip propre tant que le catalogue
TEST n'a pas de mission numeric — B1.4 la sèmera). Gates : verify (996 tests, +10),
build:check, smoke:shell, pgTAP 154/154.

Écarts acceptés (arbitrage architecte) :

5. **Migration additive** `20260705170000_dungeon_questions_carry_question_type.sql` :
   `get_dungeon_questions` porte `question_type` dans son payload (recréé verbatim,
   seul ce champ ajouté) — sans lui le donjon ne peut pas choisir le renderer.
6. **Sentinels d'abandon acceptés par la validation de format** (`__timeout__`,
   `__unsupported__`, centralisés dans `answer-formats.ts`) : sans ça, l'expiration
   du chrono boss sur une question numeric (saisie partielle invalide) ferait
   rejeter TOUTE la soumission par la validation serveur du lot B1.2. Ils scorent
   toujours faux.
7. La spec e2e numeric s'auto-skippe tant qu'aucune mission numeric n'existe sur le
   projet TEST (l'authoring reste banni jusqu'à B1.4) — elle s'activera d'elle-même.

### Lot B1.4 — 2026-07-05 (exécuté par le modèle architecte, Fable) — PHASE B1 COMPLÈTE

Livré : `questionSchema` en **union discriminée** sur `type` (défaut `mcq` par
préprocesseur — les 73 sujets existants revalident sans modification, D-4 prouvé par
`content:check`) ; membre `numeric` (`answerKey {value, tolerance?, unit?}`) ; les types
B2/B3 restent rejetés par le schéma (le ban EST le schéma). `sql-builder` émet
`question_type`/`answer_key` (mcq inchangé + `answer_key NULL`). Lints QA numeric dans
`content:qa` (tolérance ≥ |valeur| = error ; > 25 % = warn ; valeur non reprise dans
l'explication = warn ; contrôles de rendu partagés factorisés). Levée du ban `numeric`
dans CLAUDE.md, la spec, `content-engine` (SKILL + content-schema + interactive-formats +
generation-pipeline) et `content-interactif`. **Mission démo** « saisie libre » (6
questions numeric, d1→d3) dans `iq-training-{fr,en,ar}/03-maths-raisonnement` (thème
non-scolaire → jamais quiz-gaté → la spec e2e s'active) + migrations régénérées scopées
(`--subject`), re-timestampées après `20260705170000` (gotcha ordre). Validé local :
migrations sur base vierge, `score_answer` sur la démo réelle (13,5 ✓ / 13.5 ✓ / 14 ✗),
pgTAP 154/154, verify 1009 tests, content:check + content:qa:strict verts (mon propre
lint a d'ailleurs attrapé une virgule arabe dans ma version ar — corrigée).

Écart accepté : néant (le lot suit la spec ; la démo trilingue remplace la « mission de
démo sur TEST » de §5 — même contenu, appliqué partout par le pipeline normal).

### Lot B2.1 — 2026-07-05 (exécuté par le modèle architecte, Fable — GO humain phase B2 reçu)

Livré : migration `20260705190000_native_question_types_b2_score_answer.sql` —
`score_answer` étendu avec `ordering` (séquence exacte sur le CSV d'ids, insensible aux
espaces, tout-ou-rien R-2) et `matching` (égalité d'ENSEMBLES de paires `l:r`, insensible
à l'ordre, doublons neutralisés) ; entrées malformées → `false`, jamais d'exception (R-3) ;
`multi` (B3) score toujours `false` ; mcq/numeric strictement inchangés (régression pgTAP).
Aucun RPC de scoring re-branché — bénéfice direct de la couture unique D-1. pgTAP :
nouveau `17_score_answer_b2_ordering_matching.test.sql` (24 assertions) ; le test 16 a
basculé sa fixture « type futur » d'`ordering` vers `multi` (son intention — un type non
livré ne crashe pas — est préservée). Suite 178/178, verify vert.

Écart accepté (arbitrage architecte) :

8. **Helper `answer_key_display(question)`** (server-only, non exécutable par les clients) :
   la révélation canonique `COALESCE(correct_option, answer_key->>'value')` de B1 ne
   couvrait pas ordering/matching. Le helper sérialise la clé dans le MÊME format de fil
   que `choice` (ordering : CSV d'ids ; matching : CSV de paires) et remplace l'expression
   dans les trois RPCs de correction (recréés verbatim, gates inchangés) — l'UI B2.3
   consommera ce format tel quel.

### Lot B2.2 — 2026-07-05 (exécuté par le modèle architecte, Fable)

Livré : formats de fil stricts dans `answer-formats.ts` — `ordering` = CSV d'ids uniques
(≥ 2, parts non vides, pas de `:`, insensible aux espaces), `matching` = CSV de paires
`gauche:droite` uniques (exactement un `:`, côtés non vides) ; les sentinels d'abandon
passent toujours. La validation des server fns quest/dungeon était déjà branchée en B1.2
(`assertAnswerFormats`/`isValidAnswerFormat`) — seule la table des formats change. Borne
zod du `choice` donjon élargie 32 → `MAX_CHOICE_LENGTH` (un matching de 6 paires dépasse
32 caractères). `types.ts` inchangé — B2.1 n'a modifié aucune signature consommée par TS
(le helper de révélation est server-only). Tests : +8 Vitest (matrices ordering/matching

- intégration fn) ; verify vert (1015 tests).

Écart accepté : néant.

### Lot B2.3 — 2026-07-05 (exécuté par le modèle architecte, Fable)

Livré : `OrderingBoard` et `MatchingBoard` (`question-boards.tsx`) branchés dans le
`<QuestionInput>` unifié (quest ET donjon, zéro changement de surface). Drag & drop
via **@dnd-kit** (core+sortable+utilities — D-3 : dépendance introduite en B2
seulement, chunk dédié `vendor-dndkit` dans vite.config, budget 64 KB — mesuré
53,9 KB, l'index n'a pas bougé) + **flèches tap-to-order** (accessibilité/mobile,
KeyboardSensor en prime). L'arrangement initial (mélangé) est auto-enregistré comme
réponse — la validation est toujours possible, jamais de session coincée. Matching :
colonne gauche fixe, colonne droite réordonnable (paires = alignement de lignes) ;
côtés déséquilibrés → panneau R-3. Review et récap donjon : les CSV sont re-mappés
vers les textes d'options (courts, sans SVG) au lieu d'ids mélangés opaques ;
`canValidate` unifié sur `isValidAnswerFormat` pour tous les types. Gates : verify
1027 tests (+12), build:check (budget dndkit OK), smoke:shell vert.

Écart accepté : néant (D-3 suivi à la lettre).

### Lot B2.4 — 2026-07-05 (exécuté par le modèle architecte, Fable) — PHASE B2 COMPLÈTE

Livré : membres `ordering`/`matching` du `questionSchema` (ids wire-safe `[A-Za-z0-9_-]`,
clé ordering = **permutation exacte** des ids d'options, clé matching = **bijection**
gauche→droite — l'intégrité structurelle est le schéma, hard-fail à `content:check`) ;
`sql-builder` émet options + `answer_key` pour les deux types ; lints QA `auditBoardQuestion`
(textes d'items dupliqués = error, explication mince, contrôles de rendu partagés) ; levée du
ban B2 dans CLAUDE.md, la spec, `content-engine` (SKILL, content-schema — avec les règles
d'authoring et la préférence natif > formats encodés Tier-A pour le nouveau contenu —,
interactive-formats, generation-pipeline) et `content-interactif`. **Mission démo trilingue**
« glisser-déposer » (2 ordering + 2 matching, d1→d3) dans
`iq-training-{fr,en,ar}/03-maths-raisonnement` + migrations régénérées scopées
(timestamps rendus uniques — le générateur avait émis trois fichiers à la même seconde).
E2E : page-object type-aware (boards) + spec `native-board-types.spec.ts` (auto-fill vérifié,
réarrangement par flèches, run complet — skip-si-absent). Preuve bout-en-bout locale : les
12 questions boards scorent `true` contre `answer_key_display` via `score_answer` ; pgTAP
178/178 ; verify 1037 tests ; content:check (73 sujets) + content:qa:strict verts.

Écart accepté : néant. Note d'exploitation (hors périmètre étude, à corriger un jour dans
`auto-pr.yml`/le ruleset) : les checks nés des vagues push/dispatch ne satisfont pas le
ruleset `main-protection` sur les PRs bot-créées — chaque PR de cette étude a nécessité un
commit vide `synchronize` (diagnostiqué sur #298/#299, contournement systématisé ensuite).

### Lot B3.1 — 2026-07-06 (exécuté par le modèle architecte, Fable — GO humain phase B3 reçu)

Livré : migration `20260705220000_native_question_types_b3_score_answer.sql` —
`score_answer` étendu avec `multi` (égalité d'ENSEMBLES des ids cochés, CSV insensible à
l'ordre/aux espaces, doublons neutralisés, sous-ensemble/sur-ensemble = faux — R-2) ;
`answer_key_display` sérialise `multi` en CSV trié (même format de fil que `choice`).
Aucun RPC re-branché (D-1). pgTAP : nouveau `18_score_answer_b3_multi.test.sql`
(12 assertions, dont la sonde « type futur inconnu ne crashe jamais » via
`jsonb_populate_record` — la contrainte CHECK interdit de telles lignes en table) ;
tests 16/17 ajustés (leurs fixtures multi affirmaient le comportement pré-B3 ; l'intention
« pas de crédit partiel » est conservée via des réponses sous-ensemble). Suite 190/190,
verify vert (1037 tests).

Écart accepté : néant.

### Lot B3.2 — 2026-07-06 (exécuté par le modèle architecte, Fable)

Livré : format de fil `multi` dans `answer-formats.ts` — CSV d'ids **uniques** (≥ 1 part
non vide, pas de `:`), même moule que `ordering`/`matching` (B2). La validation des
server fns quest/dungeon était déjà branchée sur cette table depuis B1.2 — aucun
changement de handler. `types.ts` intentionnellement intouché (aucune signature TS
modifiée par B3.1 — `answer_key_display` est server-only). Tests : +6 Vitest (matrice
de format multi) ; verify vert (1039 tests).

Écart accepté : néant.

### Lot B3.3 — 2026-07-06 (exécuté par le modèle architecte, Fable)

Livré : `MultiSelect` (cases à cocher, `question-input.tsx`) branché dans le
`<QuestionInput>` unifié quest+donjon. La mention explicite « sélectionne TOUTES les
bonnes réponses » (US-3) est un bandeau visible non manqué, pas une astuce de style —
c'est ce qui rend l'exercice honnête. `choice` = CSV **trié** des ids cochés (même
format que le calcul serveur `score_answer`/`answer_key_display`) ; aucune case cochée
→ `value` vide → `canValidate` (déjà générique via `isValidAnswerFormat`) bloque la
validation sans code dédié. Review et récap donjon fonctionnent sans changement (la
logique de re-mapping CSV→textes de B2 couvre déjà tout CSV séparé par virgules).
Tests : +10 Vitest (bandeau, cocher/décocher, CSV trié, état initial) ; le fallback
R-3 utilisait `"multi"` comme type factice — basculé sur `"essay"` puisque `multi`
est désormais un vrai type livré. Gates : verify 1043 tests (+4 nets), `build:check`
(chunk dndkit inchangé), `smoke:shell` verts.

Écart accepté : néant.

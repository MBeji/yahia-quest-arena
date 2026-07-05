# Étude 03 — Types de questions natifs (Tier B : numeric, ordering, matching, multi)

> **Statut** : en exécution (validée par l'humain le 2026-07-05 ; lot B1.1 livré)
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
- [ ] B1.2 — serveur
- [ ] B1.3 — UI
- [ ] B1.4 — pipeline + skills

**Phase B2 — `ordering` + `matching`** : mêmes 4 lots (B2.1 étend `score_answer`; B2.3 =
`OrderingBoard`/`MatchingBoard` avec @dnd-kit — D-3). **Phase B3 — `multi`** : idem, plus l'UX
« toutes les bonnes réponses » (US-3). Chaque phase démarre sur GO humain après la précédente (D-2).

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

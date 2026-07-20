# Guide fonctionnel — Types de questions natifs (étude 03)

> **Public** : auteurs de contenu (humains + skills), relecteurs, produit.
> **Statut** : livré en production (3 phases, 12 lots, PRs #295→#307).
> Ce guide explique **quoi utiliser et quand**. La spec normative (modèle de données,
> scoring, sécurité) reste [`docs/interactive-question-types.md`](./interactive-question-types.md) ;
> les formes exactes des champs sont dans le skill `content-engine`
> (`references/content-schema.md`). En cas de contradiction, ces deux documents priment.
>
> 📦 **Où écrire** : depuis l'étude 24 (2026-07-20), le corpus (`content/`) et le skill
> `content-engine` vivent dans le dépôt **privé** `MBeji/yahia-quest-content` ; ce dépôt public
> ne garde que le moteur (`src/shared/content/`, `scripts/content/`). Voir
> [content-generation-pipeline.md](./content-generation-pipeline.md).

## Ce que ça apporte

Le moteur QCM ne savait comparer qu'une chaîne : « l'id de l'option choisie == la bonne option ».
On lançait donc **tout** comme un choix parmi des options (`mcq`), y compris quand ce n'était pas
pédagogiquement honnête (l'élève éliminait au lieu de calculer). Les **types natifs** ajoutent
quatre vraies mécaniques de réponse, sans jamais casser le `mcq` existant :

| Type       | Ce que fait l'élève                                  | Quand l'utiliser                                                        |
| ---------- | ---------------------------------------------------- | ----------------------------------------------------------------------- |
| `mcq`      | choisit **une** option (défaut historique)           | question à réponse unique parmi 2–6 propositions                        |
| `numeric`  | **tape un nombre** (pas d'options)                   | maths/physique : calcul, mesure — supprime la devinette par élimination |
| `ordering` | **glisse-dépose** 3–6 étapes dans le bon ordre       | chronologie, algorithme, étapes d'une méthode                           |
| `matching` | **relie** chaque élément de gauche à celui de droite | vocabulaire↔définition, symbole↔nom, cause↔effet                        |
| `multi`    | **coche TOUTES** les bonnes réponses (2–5 sur 3–6)   | jugement : « lesquelles de ces propriétés sont vraies ? »               |

**Invariants garantis** (donc rien à gérer côté auteur) : la réponse reste **une seule chaîne**
transmise au serveur, le **scoring est tout-ou-rien** par question (l'économie XP/anti-farm est
inchangée), et la **clé de réponse ne quitte jamais le serveur** (`answer_key`/`correct_option`
ne sont jamais lus par le client — même posture pour tous les types).

## Comment les utiliser (auteur de contenu)

Les types natifs s'écrivent **dans les fichiers d'exercices** (`content/<sujet>/NN-<slug>/exercices/*.json`,
**dépôt privé**), comme tout le reste du contenu — jamais en SQL. Le champ `type` par question sélectionne la mécanique ;
**omettre `type` reste un `mcq`** (donc tous les fichiers existants restent valides sans édition).

### `numeric` — saisie numérique libre

```jsonc
{
  "prompt": "Combien fait 3/4 + 1/8 ? (donne le résultat sous forme décimale)",
  "type": "numeric",
  "answerKey": { "value": 0.875, "tolerance": 0.001 }, // tolerance omise = exact (0)
}
```

- Pas d'`options`. L'unité éventuelle se met **dans le `prompt`** (l'élève ne tape jamais l'unité).
- `content:qa` **erreur** si `tolerance ≥ |value|` et **avertit** au-delà de 25 %.
- Notation standard : chiffres 0–9 occidentaux, point décimal — même en contenu arabe.

### `ordering` — remise en ordre (glisser-déposer)

```jsonc
{
  "prompt": "Range ces étapes de la division euclidienne dans l'ordre.",
  "type": "ordering",
  "options": [
    { "id": "a", "text": "Poser l'opération" },
    { "id": "b", "text": "…" } /* 3–6 */,
  ],
  "answerKey": { "order": ["a", "b", "c", "d"] }, // permutation EXACTE des ids d'options
}
```

- 3 à 6 étapes, ids alphanumériques sans `,` ni `:` ni espace. Les options sont **mélangées au rendu**.
- Scoring : séquence exacte, pas de crédit partiel (v1).

### `matching` — appariement (glisser-déposer)

```jsonc
{
  "prompt": "Associe chaque symbole à son élément.",
  "type": "matching",
  "options": [
    { "id": "l1", "text": "Fe" },
    { "id": "r1", "text": "Fer" } /* l*, r* */,
  ],
  "answerKey": {
    "pairs": [
      ["l1", "r1"],
      ["l2", "r2"],
    ],
  }, // bijection gauche→droite
}
```

- Chaque gauche s'apparie à **exactement un** droite (bijection, vérifiée par Zod).
- Scoring : égalité d'ensembles des paires, pas de crédit partiel (v1).

### `multi` — sélection multiple (« coche TOUT ce qui s'applique »)

```jsonc
{
  "prompt": "Parmi ces nombres, lesquels sont premiers ? (coche TOUTES les bonnes réponses)",
  "type": "multi",
  "options": [
    { "id": "a", "text": "2" },
    { "id": "b", "text": "9" } /* 3–6 */,
  ],
  "answerKey": { "correct": ["a", "c"] }, // 2–5 ids, sous-ensemble STRICT (au moins 1 faux)
}
```

- Sous-ensemble **strict** obligatoire (au moins une option fausse), sinon « coche tout » n'a pas
  de sens et le QA le rejette.
- La consigne doit dire explicitement « coche TOUTES les bonnes réponses » (déjà porté par l'UI, mais
  le libellé pédagogique reste à la charge de l'auteur).

### Le workflow (dépôt privé)

1. Éditer les fichiers `content/…` **dans le dépôt privé** `MBeji/yahia-quest-content`.
2. Ouvrir la PR là-bas : la **Content CI** joue `content:check` puis `content:qa:strict` (lints par
   type : sanité de tolérance numérique, intégrité des ids ordering/matching, clé multi ≥ 2 — un id
   inconnu = **erreur**) en récupérant le moteur depuis ce dépôt public.
3. Merger : `apply-content.yml` compile le SQL de la matière (`content:emit`) et l'applique en
   prod, avec une ligne de journal dans `content_releases`.

> Le contenu **n'est plus livré en migrations Supabase** — voir
> [content-generation-pipeline.md](./content-generation-pipeline.md) §11.

> **Conseil de choix** : préférer ces types natifs aux formats « encodés » Tier-A (permutation/
> multi-select simulés dans un QCM) pour le **nouveau** contenu. Les formats encodés existants
> restent valides — aucune reprise du contenu déjà écrit n'est nécessaire.

## Où vit le code (pour le produit / la maintenance)

- **Contenu** : `src/shared/content/schema.ts` (union discriminée sur `type`), `sql-builder.ts`
  (émet `question_type` + `answer_key`), lints dans le pipeline `content:qa`.
- **Base** : colonne `questions.question_type` (défaut `'mcq'`) + `questions.answer_key` (JSONB,
  server-only) ; scoring factorisé dans **une** fonction SQL `score_answer(question, choice)`
  appelée par les 5 RPC (`submit_exercise_attempt`, `get_attempt_review`, `check_answers`,
  `score_quiz`, `submit_dungeon_answer`).
- **UI** : composant unifié `<QuestionInput>` (quest **et** dungeon) qui rend `NumericInput`,
  `OrderingBoard`/`MatchingBoard` (@dnd-kit) et `MultiSelect` selon le type.

## Limites connues (hors périmètre v1)

- Pas de **crédit partiel** (ordering/matching/multi sont tout-ou-rien).
- Pas de **texte libre / dissertation** (aucun correcteur serveur fiable — hors scope produit).
- Pas de **traduction par enregistrement** : le modèle « une langue par sujet » est inchangé.

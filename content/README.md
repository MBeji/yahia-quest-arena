# `content/` — pipeline de contenu pédagogique

Le contenu (matières, chapitres, cours, résumés, exercices) vit ici sous forme
de **fichiers versionnés**. Un générateur les valide puis les compile en
**migrations Supabase idempotentes**. On peut donc compléter / améliorer le
programme en continu, à partir de n'importe quelle source (sites en ligne,
manuels, repos locaux), avec une relecture en PR.

## Arborescence

```
content/
  <matière>/                 # ex. math
    subject.json             # méta matière (langue native, attribut, icône…)
    01-<slug>/               # un dossier par chapitre (préfixe = ordre)
      chapter.json           # titre, description, ordre, sources[]
      cours.md               # cours théorique complet (markdown)
      resume.md              # résumé du cours (markdown)
      quiz.json              # quiz de compréhension OBLIGATOIRE (verrou des exercices)
      exercices/
        01-<slug>.json       # un exercice QCM (questions + explications)
        02-<slug>.json
```

## Format des fichiers

- **`subject.json`** : `id`, `nameFr`, `description`, `attribute`, `colorToken`,
  `icon`, `displayOrder`, `contentLanguage` (`ar` | `fr` | `en`), `themeId`
  (thème d'appartenance — **obligatoire**, ex. `ecole-tn` pour le programme
  scolaire ou `francais` pour un module autonome), `gradeSlug` (niveau dans
  l'échelle du thème, ex. `9eme-base` ; `null` pour les matières indépendantes
  d'un niveau — le slug est résolu en UUID `grades` à la compilation, jamais
  codé en dur), `isPremium?`, `compileTo?` (mutualisation lycée — voir plus bas).
- **`chapter.json`** : `title`, `description`, `displayOrder`, `sources` (liste
  d'URLs / références — traçabilité des sources), `gradeSlugs?` (dossier partagé
  uniquement : sections destinataires du chapitre).
- **`quiz.json`** (obligatoire) : `title?` + `questions[]` (même forme que les
  questions d'exercice). Compilé en exercice `mode='quiz'` ; l'élève doit le
  réussir (≥ `QUIZ_PASS_THRESHOLD_PCT`) pour débloquer les exercices du chapitre.
- **exercice `*.json`** : `title`, `difficulty` (1-4), `mode`
  (`practice` | `boss` | `challenge`), `xpReward`, `rewardCoins`, `displayOrder`,
  `gradeSlugs?` (dossier partagé uniquement), et
  `questions[]` : `{ prompt, options:[{id,text}], correctOption, explanation, difficulty? (1-3) }`.

### Mutualisation entre sections (`compileTo` — étude 16)

Au lycée, plusieurs sections partagent des programmes identiques (tronc commun :
langues, philo, histoire-géo). Une matière partagée s'écrit **une seule fois**
dans un dossier « source » dont le `subject.json` déclare ses cibles :

```jsonc
{
  "id": "anglais-3eme-sec", // id source VIRTUEL (<matière>-<année>) — n'atteint jamais la DB
  // ... pas de gradeSlug racine ...
  "compileTo": [
    { "id": "anglais-3eme-sec-math", "gradeSlug": "3eme-sec-math" },
    { "id": "anglais-3eme-sec-lettres", "gradeSlug": "3eme-sec-lettres", "description": "…" },
  ],
}
```

À la compilation, le dossier devient **un subject par cible** (id
`<matière>-<gradeSlug>` verbatim, migration séparée par cible). `nameFr` /
`description` peuvent être surchargés par cible. Un chapitre ou un exercice
peut restreindre ses sections via `gradeSlugs` (sous-ensemble des cibles —
permet des paliers d3/d4 propres à une section dans le dossier partagé).
Slugs autorisés : le référentiel canonique (`KNOWN_GRADE_SLUGS`,
`src/shared/content/schema.ts`) hors nœuds plats legacy.

**Invariant capital** : les UUID v5 dérivent de l'**identité compilée** (id
cible + slugs), jamais du dossier source. **Forker** une section (lui donner
son dossier dédié en reprenant l'id cible et les slugs de chapitres/exercices)
ne perd donc **aucune progression élève**. Règle de partage : programme
officiel identique (constaté sur transcription) ⇒ partage ; divergence
structurelle ⇒ dossiers séparés ; divergence de profondeur seulement ⇒
partage + `gradeSlugs` par exercice — doctrine complète :
`docs/lycee-architecture.md` §2/§8 et `FableEtudes/16-ouverture-lycee/ETUDE.md` (D-4).

Tout est validé par Zod (`src/shared/content/schema.ts`). Un fichier invalide
n'atteint jamais la base.

**Notation standard dans toutes les langues** : chiffres occidentaux (0-9),
équations en notation internationale (LTR), unités SI — y compris dans le
contenu en arabe (prose arabe autour de maths standard ; jamais de chiffres
arabes-orientaux ٠١٢٣). Règle complète :
`.claude/skills/content-engine/references/math-and-notation.md`. La barre de
qualité des questions (distracteurs, explications, équilibre des clés,
auto-vérification) : `.claude/skills/content-engine/references/quality-bar.md`.

## Commandes

```bash
npm run content:check                 # valide tout le contenu (n'écrit rien)
npm run content:build -- --subject <id>   # régénère la migration du SEUL sujet modifié
```

> ⚠️ **Ne lance jamais `content:build` sans `--subject`** : il régénère les ~60 sujets avec un
> horodatage neuf → des dizaines de migrations parasites (doublons de sujets non modifiés) qu'il ne
> faut **pas** committer. Toujours cibler `--subject <id>` (une fois par sujet changé). Un build
> complet involontaire se nettoie avec `git clean -f supabase/migrations/`.
> `--subject` désigne le **dossier source** : un dossier partagé (`compileTo`)
> régénère d'un coup ses N migrations `_generated_<id-cible>_content.sql`.

> **Quel skill pour quoi ?** La carte complète du pipeline (skills de base `content-*` pour
> créer/compléter un chapitre vs professeurs `prof-*` pour rehausser le plafond en d3–4, + règles
> cumulatives) est dans `.claude/skills/content-engine/references/generation-pipeline.md`.

Les `id` de chapitres / exercices / questions sont des **UUID v5 déterministes**
dérivés des slugs : régénérer met à jour les lignes en place (pas de doublon),
et le contenu admin retiré est élagué automatiquement (le contenu créé par les
parents n'est jamais touché).

## Workflow DB ↔ code

Le SQL généré est **appliqué automatiquement à la prod au merge sur `main`**
(workflow `db-migrate-prod.yml`, voir `CLAUDE.md` §7) — on n'applique **jamais**
à la main. Ordre : `content:build` → relire le SQL → ouvrir la PR → merge (la
migration part en prod toute seule) → le code dépendant suit.

**Mettre à jour un sujet déjà en prod** : `content:build` écrit une migration à **horodatage neuf**
(comportement par défaut) — la garder telle quelle. Régénérer **en place** (même horodatage via
`--timestamp <existant>`) ne sert à rien en prod : `db push` la voit comme **déjà appliquée** et la
**saute** (log « Remote database is up to date »), donc le nouveau contenu n'atteint jamais la base.
Vérifier le log du run `db-migrate-prod` : il doit lister `Applying migration <ts>_generated_<id>…`. Les
anciennes migrations générées du sujet restent (les supprimer casse l'historique ; `math`/`math-6eme` en
cumulent déjà plusieurs, c'est attendu).

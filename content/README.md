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
      exercices/
        01-<slug>.json       # un exercice QCM (questions + explications)
        02-<slug>.json
```

## Format des fichiers

- **`subject.json`** : `id`, `nameFr`, `description`, `attribute`, `colorToken`,
  `icon`, `displayOrder`, `contentLanguage` (`ar` | `fr` | `en`).
- **`chapter.json`** : `title`, `description`, `displayOrder`, `sources` (liste
  d'URLs / références — traçabilité des sources).
- **exercice `*.json`** : `title`, `difficulty` (1-3), `mode`
  (`practice` | `boss`), `xpReward`, `rewardCoins`, `displayOrder`, et
  `questions[]` : `{ prompt, options:[{id,text}], correctOption, explanation }`.

Tout est validé par Zod (`src/shared/content/schema.ts`). Un fichier invalide
n'atteint jamais la base.

## Commandes

```bash
npm run content:check   # valide tout le contenu (n'écrit rien)
npm run content:build   # génère les migrations dans supabase/migrations/
```

Les `id` de chapitres / exercices / questions sont des **UUID v5 déterministes**
dérivés des slugs : régénérer met à jour les lignes en place (pas de doublon),
et le contenu admin retiré est élagué automatiquement (le contenu créé par les
parents n'est jamais touché).

## Workflow DB ↔ code

Le SQL généré doit être **appliqué à la base avant** que le code dépendant ne
soit déployé (voir `CLAUDE.md` §7). Ordre : `content:build` → relire le SQL →
appliquer la migration (SQL editor ou `supabase db push`) → pousser le code.

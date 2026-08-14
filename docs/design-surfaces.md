# Surfaces & couleurs — la règle qui a remplacé la rustine

> **Normatif.** AGENTS.md § Conventions pointe ici. Ce document dit ce qu'une couleur a le
> droit d'être dans cette application, et pourquoi la règle est ce qu'elle est.
> Écrit le 2026-08-14, à la fin de la migration des surfaces (#724 → #734).

## La règle, en une phrase

Une surface se demande par sa **profondeur**, jamais par sa couleur : `bg-surface-1` (creux),
`bg-surface-2` (contrôles), `bg-surface-3` (carte surélevée). Chaque thème décide de quoi ces
trois niveaux sont faits.

## Ce qu'il ne faut plus écrire, et pourquoi ça marchait avant

Les écrans ont longtemps été écrits « sombre d'abord », en `bg-black/<alpha>` littéraux. Le
thème clair — qui est le **défaut** (`DEFAULT_THEME = "reference"`) — les rattrapait par un
remap du token Tailwind :

```css
html.reference .app-shell {
  --color-black: oklch(1 0 0);
} /* SUPPRIMÉ */
```

Cette règle n'existe plus. Trois raisons de ne pas la regretter :

1. **Elle ne couvrait que son périmètre.** Le lecteur de quête vit aussi dans la coquille
   publique : il a fallu lui donner une copie de la rustine, laquelle repeignait au passage
   l'incrustation vidéo — encre sombre sur scrim sombre, illisible. Un correctif qui crée un
   bug ailleurs est un correctif de trop.
2. **Elle interdisait au thème clair d'exister vraiment.** « Noir → blanc » ne produit ni
   ombre, ni filet, ni hiérarchie de surfaces : que des cartes plates. Le clair était un
   décalquage du sombre, pas un registre dessiné.
3. **Elle rendait la faute invisible.** Un `bg-black` en revue paraissait acceptable puisqu'une
   règle, trente fichiers plus loin, s'en occupait.

Conséquence pratique : **un littéral qui revient reste noir sur fond clair.** Personne ne le
repeindra.

## Le tableau de conversion

| Intention                           | Écrire                                  | Pas                          |
| ----------------------------------- | --------------------------------------- | ---------------------------- |
| Bloc calme, creux                   | `bg-surface-1`                          | `bg-black/30`                |
| Champ, option, contrôle             | `bg-surface-2`                          | `bg-black/40`, `/50`         |
| Carte surélevée, panneau            | `bg-surface-3`                          | `bg-black/60`, `/70`         |
| Encre sur un CTA d'accent           | `text-primary-foreground`               | `text-black`                 |
| Lavis sur fond sombre               | `bg-foreground/5`, `/10`                | `bg-white/5`, `/10`          |
| Letterbox vidéo et son incrustation | `bg-media-scrim`, `text-ink-on-media`   | `bg-black`, `text-white`     |
| Cran de rareté d'un badge           | `--rarity-{common,rare,epic,legendary}` | une teinte choisie à la main |

Deux nuances qui ne se devinent pas :

- **un lavis n'est pas une surface.** `bg-white/5` sur fond sombre est de l'encre diluée : il
  doit foncer quand l'encre fonce, donc `bg-foreground/5`. Le laisser blanc le ferait
  disparaître en thème clair ;
- **le média n'est pas de l'interface.** Une vidéo est noire et son incrustation blanche dans
  les **deux** thèmes — d'où deux tokens volontairement identiques partout, qui échappent aussi
  à tout remap.

## Ce qui reste littéral, et l'assume

La **landing** et l'**écran d'auth** vivent hors de la coquille : leur registre sombre est un
choix de composition, pas un oubli. Ils ne sont pas dans le périmètre du garde-fou.

## Le garde-fou

`scripts/lint/check-design-tokens.mjs`, dans `npm run lint` (donc bloquant en CI). Il refuse :

- la palette Tailwind brute (`text-blue-400`…) — partout ;
- `text-white` — partout ;
- `bg-black` / `text-black` / `bg-white` — dans `features/` et `routes/_authenticated`, la
  liste `MIGRATED`. C'est un **cliquet** : elle s'allonge, elle ne raccourcit jamais.

`bg-black-deep` n'est pas un littéral : c'est une utilitaire adossée au token `--black-deep`,
surchargée par thème. La regex du garde-fou l'écarte explicitement.

Exception documentée quand elle est justifiée : `// token-ok: <raison>` sur la ligne ou les
trois au-dessus, `token-ok-block` … `/token-ok-block` pour une région.

## Ajouter un thème, ou un token

Tout token de couleur se définit dans **les deux** blocs de `src/styles.css` — `:root` (sombre)
et `html.reference` (clair) — puis s'expose à Tailwind dans `@theme inline`. En définir un d'un
seul côté sert l'encre d'un thème sur le fond de l'autre : c'est le bug classique de tout design
system à deux thèmes, et `src/features/quest/__tests__/surface-tokens-css.test.ts` l'épingle.

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

## Typographie : une famille pour tout le texte, une face pour le logotype

Depuis le 2026-11-14, **Space Grotesk écrit tout le texte de l'interface, titres compris**
(`--font-display` et `--font-sans` désignent la même famille ; un titre se distingue par sa
graisse, son corps et son interlettrage resserré, pas par une autre face). **Orbitron n'écrit
plus que le logotype « Na9ra Nal3ab »**, par l'utilitaire `font-brand` : en-tête public, en-tête
connecté, écran d'accès, filigrane d'impression.

Pourquoi les titres ont quitté Orbitron, constaté sur les écrans réels :

1. **Elle se lisait mal là où on lit le plus.** Zéro barré, « 1 » et « 7 » ambigus : « 1ère
   année », « 0 / 200 XP », « 6 718 missions » demandaient un effort, sur une plateforme dont
   la moitié des titres porte un chiffre.
2. **Elle n'a pas d'arabe.** Un titre arabe retombait sur la police du système : sur la même
   page, le titre de la matière et celui de la section n'avaient pas la même écriture.
3. **Elle datait le produit.** Une face de science-fiction sur « Politique de confidentialité »
   ou « Rapport de suivi » : ce que voit un parent arrivé des réseaux.

Règles qui en découlent :

- `font-display` reste la classe d'un titre (elle porte l'interlettrage) : ne pas la retirer
  des écrans, ne pas la remplacer par `font-sans`.
- `font-brand` ne se pose **que** sur le logotype. Jamais sur un titre, jamais sur un chiffre.
- Le fichier Orbitron reste préchargé : le logotype est dans l'en-tête de chaque page.

`src/__tests__/self-hosted-fonts.test.ts` épingle les deux rôles.

## Le sens d'écriture d'un libellé sur un écran posé dans le sens du contenu

La page d'une matière en arabe est posée de droite à gauche — c'est son contenu qui décide.
Mais elle porte aussi les libellés de l'interface, qui peuvent être dans une autre écriture :
sous une interface française, « Pourquoi ? » s'y affichait « ? Pourquoi », « 1. Cours »
devenait « Cours .1 », et l'écran de résultat écrivait « bonnes réponses · 0 % 5 / 0 ». La
ponctuation et les chiffres, neutres, prenaient le sens du bloc.

Deux utilitaires, dans `src/styles.css` :

- **`bidi-plaintext`**, sur le conteneur qui porte le `dir` du contenu : chaque libellé choisit
  son sens d'écriture d'après sa première lettre, et garde l'alignement de l'écran. Il
  **n'atteint jamais un nœud qui déclare son `dir`**, ni ce qu'il contient — un énoncé arabe
  qui commence par un symbole latin doit rester de droite à gauche. Donc à ne poser que là où
  chaque nœud de contenu déclare le sien : le hub de matière, l'écran de résultat (dont la
  correction est enveloppée dans un `dir` explicite).
- **`bidi-label`**, la même règle pour UN libellé, sur un écran dont le contenu hérite le sens
  de l'écran (le lecteur de quête : l'énoncé et ses options n'ont pas de `dir` propre).

Écrire un nouveau libellé d'interface sur un tel écran : ne lui donner **aucun** `dir`. Écrire
un nouveau nœud de contenu : lui donner le sien (`dir={isRtlText(texte) ? "rtl" : "ltr"}`).

## La marque : une couronne, une seule

Le logo de Na9ra Nal3ab est une **couronne dorée**. Elle vivait déjà dans tout ce que
l'application montre hors de son interface — `public/favicon.svg`, les trois icônes PWA
(`public/icons/*.png`) et `public/offline.html` — mais l'interface, elle, dessinait une
`Sparkles` de lucide : l'en-tête de la coquille, le verrou de marque de l'écran d'auth et
l'avatar du héros sans avatar choisi. L'onglet du navigateur ne ressemblait pas à la page
qu'il ouvrait, et personne ne voyait la faute puisque chaque écran, pris seul, était cohérent.

La marque se dessine donc désormais en **un seul endroit** : `src/components/brand-mark.tsx`
(`<CrownMark className="…" />`). Deux règles tiennent, et
`src/components/__tests__/brand-mark.test.tsx` fait échouer le gate sur chacune :

1. **le tracé est celui de la page hors-ligne** (`public/offline.html`), primitive par
   primitive. Une couronne dans le produit, jamais deux silhouettes à faire diverger — le test
   compare les deux fichiers ;
2. **le `viewBox` est la boîte englobante EXACTE du tracé** (serrée, là où l'original porte les
   marges d'une icône d'application). Toucher au tracé sans la recalculer rogne le dessin en
   silence, à une taille où personne ne le remarque.

**Deux visages voulus (arbitrage du 2026-11-14).** Dehors — `public/favicon.svg`, les quatre
icônes de `public/icons/` et les comptes Facebook et Instagram — la marque est le monogramme
**« N9 »** blanc et ambre sur le vert des pages publiques (`#0f6e56`) : c'est ce que voit le
parent qui arrive des réseaux. Dedans — l'interface connectée et la page hors-ligne — la
couronne reste l'emblème du jeu. Le favicon n'est donc plus la référence du tracé de la couronne.

Le composant ne code aucune couleur : l'encre vient de `currentColor` (donc du `text-…` de
l'appelant) et la lueur du conteneur (`shadow-gold`), comme pour l'icône qu'elle remplace.
Une `Sparkles` reste légitime partout où elle veut dire _autre chose_ — les pièces, la forge
IA, un badge : ce sont des icônes sémantiques, pas la marque.

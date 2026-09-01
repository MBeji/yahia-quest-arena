# Outillage « schémas explicatifs » (`scripts/content/svg/`)

Petit pipeline pour **créer, rendre et vérifier** les figures SVG inline embarquées
dans le contenu — dans les cours (`cours.md` / `resume.md`) et dans les **questions**
(le champ `prompt` d'un `quiz.json` / `exercices/*.json`, un `<svg>` par champ).

Il a servi à produire et auditer ~315 figures lors de la campagne « schémas
explicatifs » (cours + questions). Zéro dépendance pour la génération ; le rendu
utilise Playwright (déjà dans les devDeps) + Chromium (`npx playwright install chromium`).

> 📦 **Cet outillage est le moteur, il reste public — le corpus qu'il traite, non.** Depuis
> l'étude 24 (2026-07-20), les fichiers `content/…` cités plus bas vivent dans le dépôt **privé**
> `MBeji/yahia-quest-content` : les chemins d'exemple s'entendent relativement à ce dépôt-là.
> Ne recopie jamais de corpus ici pour tester — `npm run leak:check` fait échouer le build.
> Voir [`docs/content-generation-pipeline.md`](../../../docs/content-generation-pipeline.md).

## Les outils

| Fichier                  | Rôle                                                                                                                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `svglib.mjs`             | mini-builder SVG sans dépendance — calcule la géométrie (flèches, arcs, ticks, angle droit) et n'émet que les primitives autorisées par le sanitizer                                             |
| `preview.mjs`            | rend les figures d'un fichier en **grille PNG** pour relecture visuelle ; pour un `.json` il **décode** les SVG depuis les chaînes (ce qui part réellement en prod)                              |
| `check-figures.mjs`      | lint structurel de toutes les figures de `content/` (whitelist sanitizer, viewBox, chiffres occidentaux, un `<svg>` par champ) — `npm run content:figures:check`                                 |
| `check-overflow.mjs`     | mesure quel texte de figure sort de son `viewBox` — donc arrive **rogné** chez l'élève ; Chromium + les polices de l'app, et une calibration à chaque passage — `npm run content:overflow:check` |
| `import.mjs`             | **importe une illustration libre du net** et la rend embarquable — voir § « Importer une illustration libre » — `npm run content:figures:import`                                                 |
| `sanitizer-contract.mjs` | la source unique du contrat (liste blanche, interdits, miroir de la config DOMPurify) — importée par `check-figures.mjs` et `import.mjs`                                                         |

## Contraintes (le sanitizer décide)

Les figures traversent `src/shared/lib/figure.ts` → DOMPurify (profil SVG). **Éléments
autorisés uniquement** : `svg, title, g, line, path, polygon, polyline, rect, circle,
ellipse, text, tspan`. **Interdits** : `image, use, foreignObject, script, style`, et tout
`href`/`xlink:href` — ceux-là, le sanitizer les détruit vraiment.

**Les flèches et les dégradés font exception** (`defs, marker, linearGradient,
radialGradient, stop`) : le sanitizer garde ces éléments, l'attribut qui les appelle
(`marker-end`, `fill="url(#…)"`) et l'`id` auquel ils pendent — vérifié dans l'app, en
Chromium, sur les figures du corpus. Trois règles les rendent sûrs, parce que chacune de
leurs façons de casser est muette :

- toute `url(#id)` doit **résoudre** dans la même figure (une coquille = pas de flèche) ;
- toute définition doit être **appelée** (sinon elle ne dessine rien : elle voyage) ;
- tout `id` porte un **tiret**. Sans tiret il peut porter le nom d'une propriété de
  `document` (`body`, `all`, `location`…) : la garde anti-clobbering de DOMPurify le
  retire, la référence pointe dans le vide, et rien ne le signale.

Donc :

- **un seul `<svg>` par champ** (le renderer n'en extrait qu'un) ;
- premier enfant = un `<title>` (accessibilité) dans la langue du chapitre ;
- **chiffres occidentaux (0-9) partout**, y compris en contenu arabe (`math-and-notation`) ;
- style maison : traits sombres `#0f172a`, couleurs d'accent pour les rayons/surlignages,
  trait ≥ 2, libellés à **halo blanc** (via `label()` / `labels()`) pour rester lisibles ;
- **jamais** `fill="#ffffff"` sur un `<text>` qui porte déjà le halo blanc → texte invisible.

## Boucle de travail

```bash
# 1. Générer : un script par figure/chapitre qui importe svglib.mjs
node mon-generateur.mjs           # écrit un .svg (ou colle la sortie dans le contenu)

# 2. Rendre & relire visuellement
node scripts/content/svg/preview.mjs content/<sujet>/<chap>/cours.md /tmp/out.png
node scripts/content/svg/preview.mjs content/<sujet>/<chap>/quiz.json /tmp/out.png   # .json = décodé

# 3. Intégrer
#    - cours.md : coller le <svg> sur sa propre ligne, entouré de lignes vides
#    - question : APPENDRE le <svg> au prompt (json.load → prompt += "\n"+svg → json.dump(ensure_ascii=False, indent=2))

# 4. Vérifier le round-trip depuis le JSON sauvegardé (indispensable pour les questions)
node scripts/content/svg/preview.mjs content/<sujet>/<chap>/quiz.json /tmp/verify.png

# 5. Lint structurel + gate contenu
npm run content:figures:check
npm run content:check && npm run content:qa:strict
# puis PR dans le dépôt privé : la Content CI rejoue ces gates, et le merge
# déclenche apply-content.yml (compilation + application en prod).
```

> ⚠️ Pour vérifier une figure embarquée dans un `.json`, **passe le `.json` à `preview.mjs`**
> (il fait le `JSON.parse`). Rendre le texte brut du JSON échoue : les guillemets y sont
> échappés (`\"`) et la figure sort blanche. C'est exactement le piège que `preview.mjs`
> évite en décodant.

## `svglib.mjs` en un coup d'œil

```js
import * as S from "./svglib.mjs";
const {
  svg,
  line,
  ray,
  arc,
  circle,
  rect,
  polygon,
  polyline,
  ellipse,
  label,
  labels,
  hatch,
  tick,
  chevron,
  rightAngle,
  DARK,
  GREY,
  BLUE,
  RED,
  GREEN,
  AMBER,
  PURPLE,
} = S;

const body =
  polygon([
    [100, 24],
    [28, 126],
    [172, 126],
  ]) + // triangle ABC
  tick([100, 24], [28, 126], 0.5, 1) + // I milieu de [AB] (1 tick)
  chevron([65, 75], [135, 75]) +
  chevron([28, 126], [172, 126]) + // (IJ) // (BC)
  rightAngle([28, 126], [172, 126], [28, 24]) + // angle droit en B
  labels([
    [100, 16, "A"],
    [20, 132, "B", { anchor: "end" }],
    [180, 132, "C", { anchor: "start" }],
  ]);
const figure = svg(200, 150, "Triangle ABC : (IJ) parallèle à (BC)", body);
```

## Importer une illustration libre

`svglib.mjs` sert à dessiner des **schémas** (géométrie, optique, droite graduée) — et c'est
là qu'il est imbattable. Il est en revanche le mauvais outil pour représenter un **objet du
monde réel** : une vache, un oiseau, une plante codés à la main à coups d'ellipses donnent
des taches non identifiables. Pour ceux-là, on part d'une illustration libre existante et on
l'importe.

### Le piège que l'import supprime

Coller un SVG du net dans le contenu **n'échoue pas bruyamment, il échoue en silence**. Le
sanitizer retire `<style>`, `<use>` et `<image>` : la figure « s'affiche » toujours, mais
décolorée ou amputée. Mesuré sur le vrai sanitizer :

| ce que porte le fichier | ce qui arrive à l'écran                                                          |
| ----------------------- | -------------------------------------------------------------------------------- |
| un bloc `<style>` CSS   | **toutes les couleurs sautent** — les formes retombent en noir par défaut        |
| des `<defs>` + `<use>`  | **les formes réutilisées disparaissent** (le `<defs>`, lui, reste dans le poids) |
| un bitmap `<image>`     | **figure vide**                                                                  |
| un `<linearGradient>`   | toléré par le sanitizer, mais refusé par le lint maison                          |

`import.mjs` résout ces constructions **avant** que le sanitizer puisse les manger : il aplatit
la cascade CSS en attributs de présentation (résolue par Chromium lui-même, pas par un moteur
CSS maison), inline les `<use>`, aplatit les dégradés en aplat, jette le reste, puis **prouve**
le résultat.

### Trois preuves, pas une promesse

1. **le sanitizer rejoué** — la vraie config DOMPurify de `src/shared/lib/figure.ts` est
   appliquée à la sortie ; s'il ampute encore quoi que ce soit, l'import échoue en nommant
   l'élément ou l'attribut perdu ;
2. **les pixels** — l'original et la figure assainie sont rendus et comparés sur deux axes :
   les **formes** (une patte disparue = échec, seuil 4 %) et la **couleur** (un dégradé aplati
   déplace légitimement beaucoup de couleur : c'est reporté, pas jugé) ;
3. **le contrat maison** — le même `lintSvg` que le gate.

```bash
npm run content:figures:import -- vache.svg --title "Une vache dans un pré" \
  --out figure.svg --proof preuve.png
```

`--proof` écrit un PNG « original | normalisé + assaini » côte à côte : **regarde-le**. La
doctrine de vérification intégrale (étude 19, Q-3) vaut pour les figures importées comme pour
les figures dessinées. Options : `--max-bytes` (défaut 12 000 — une figure voyage dans chaque
ligne de contenu qui l'utilise).

### Provenance et licence — la seule chose que l'outil ne peut pas vérifier

`import.mjs` ne sait pas d'où vient le fichier. **Noter la source et sa licence est le travail
de l'auteur**, dans le dépôt privé, au moment de l'intégration.

| source                | licence                        | à savoir                                                  |
| --------------------- | ------------------------------ | --------------------------------------------------------- |
| **Openclipart**       | CC0                            | domaine public, aucune attribution — le défaut à préférer |
| **SVG Repo**          | variable (CC0, MIT, CC-BY…)    | **à vérifier collection par collection**                  |
| **Wikimedia Commons** | variable (PD, CC0, CC-BY, -SA) | **à vérifier fichier par fichier**                        |
| **OpenMoji**          | CC BY-SA 4.0                   | attribution **et** partage à l'identique                  |
| **unDraw**            | licence propre, libre          | pas d'attribution exigée                                  |

⚠️ **Préférer CC0 par défaut.** L'application n'a aujourd'hui **aucune surface de crédits** :
une illustration CC-BY / CC-BY-SA créerait une obligation d'attribution que rien ne remplit.
Tant que cette surface n'existe pas, une figure sous attribution obligatoire ne s'intègre pas.

### La frontière du médium

`import.mjs` **refuse** un fichier qui embarque un bitmap. Une vraie photographie n'est pas
un problème d'outillage mais un **changement de médium** — il faudrait un bucket, un cache
hors ligne et un cadre de licence. C'est la décision D-8 de l'étude 18 (« SVG seul »,
2026-07-14), reconduite par la Q-1 de l'étude 19 : un chantier séparé, pas cet outil.

## Règle d'or pour les figures de **questions** : _answer-safe_

Une figure de question ne montre **que ce que l'énoncé donne**, jamais ce qu'il
**demande**. Sinon elle donne la réponse.

- angle cherché → laissé « ? » (on ne marque que l'angle donné) ;
- périmètre / aire / volume → on cote le donné, jamais le résultat ;
- Pythagore / triangles isométriques → configuration sans longueurs ni marques d'égalité ;
- angle inscrit dans un demi-cercle → le point est sur le cercle mais **l'angle droit n'est pas tracé** ;
- réflexion / réfraction → rayon incident + normale + interface, **jamais** le rayon réfléchi/réfracté ;
- circuits → grandeurs données affichées, la grandeur cherchée = « ? ».

**Dans le doute, pas de figure.** Les questions dont toute figure trahirait la réponse
(nature d'une forme, image par symétrie, série-vs-dérivation, réciproques, vecteurs,
coordonnées lisibles sur quadrillage, comptage) restent **en texte** — c'est le bon
choix pédagogique, pas un manque.

## Voir aussi

- `src/shared/lib/figure.ts` — l'extraction + sanitizer (source de vérité des contraintes)
- [`docs/content-generation-pipeline.md`](../../../docs/content-generation-pipeline.md) — le
  pipeline de contenu de bout en bout (répartition public/privé, boucle auteur, application)
- Dans le **dépôt privé** `MBeji/yahia-quest-content` :
  `content-engine/references/interactive-formats.md` (QCM visuel / figures) et
  `content-engine/references/math-and-notation.md` (notation standard, chiffres)

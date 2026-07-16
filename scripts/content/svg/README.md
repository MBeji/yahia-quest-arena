# Outillage « schémas explicatifs » (`scripts/content/svg/`)

Petit pipeline pour **créer, rendre et vérifier** les figures SVG inline embarquées
dans le contenu — dans les cours (`cours.md` / `resume.md`) et dans les **questions**
(le champ `prompt` d'un `quiz.json` / `exercices/*.json`, un `<svg>` par champ).

Il a servi à produire et auditer ~315 figures lors de la campagne « schémas
explicatifs » (cours + questions). Zéro dépendance pour la génération ; le rendu
utilise Playwright (déjà dans les devDeps) + le Chromium pré-installé.

## Les trois outils

| Fichier             | Rôle                                                                                                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `svglib.mjs`        | mini-builder SVG sans dépendance — calcule la géométrie (flèches, arcs, ticks, angle droit) et n'émet que les primitives autorisées par le sanitizer                |
| `preview.mjs`       | rend les figures d'un fichier en **grille PNG** pour relecture visuelle ; pour un `.json` il **décode** les SVG depuis les chaînes (ce qui part réellement en prod) |
| `check-figures.mjs` | lint structurel de toutes les figures de `content/` (whitelist sanitizer, viewBox, chiffres occidentaux, un `<svg>` par champ) — `npm run content:figures:check`    |

## Contraintes (le sanitizer décide)

Les figures traversent `src/shared/lib/figure.ts` → DOMPurify (profil SVG). **Éléments
autorisés uniquement** : `svg, title, g, line, path, polygon, polyline, rect, circle,
ellipse, text, tspan`. **Interdits** : `image, use, foreignObject, script, style,
marker, defs`, et tout `href`/`xlink:href`. Donc :

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
# puis regénérer la migration du sujet : npm run content:build -- --subject <id>
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
- `.claude/skills/content-engine/references/interactive-formats.md` — QCM visuel / figures
- `.claude/skills/content-engine/references/math-and-notation.md` — notation standard, chiffres
- `content/README.md` — pipeline de contenu (fichiers → migrations)

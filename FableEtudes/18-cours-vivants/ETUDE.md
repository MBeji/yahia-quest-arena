# Étude 18 — Cours vivants : moteur de blocs pédagogiques & doctrine d'illustration

> **Statut** : validée
> **Priorité** : 18 · **Valeur** : le cours cesse d'être un mur de texte — 517 cours gagnent une structure lisible sans qu'un fichier de contenu soit touché, et la géométrie cesse de s'enseigner sans figure · **Complexité** : moyenne+
> **Architecte** : Opus 4.8 / 2026-07-14 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : é14 (design system, livrée) · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/xss-rendering-policy.md`,
> `docs/content-voice-and-composition.md`, `content-engine/references/{course-quality,style-guide,math-and-notation,content-schema}.md`

---

## 1. Contexte & objectif produit

### Le problème, tel qu'il a été signalé

> « Les cours n'ont pas de vie, sont statiques, texte, trop fades. Un cours géométrie sans
> illustration ça n'a aucun sens. Il faut donner plus de vie, d'ergonomie et de design au cours
> et au résumé de cours. » — Mohamed, 2026-07-14

### L'état réel, mesuré sur le dépôt (2026-07-14)

Il y a **deux causes distinctes**. N'en corriger qu'une ne produira aucun effet visible.

**Cause A — le moteur de rendu est aveugle à la pédagogie.** `renderMarkdown`
(`src/shared/lib/markdown.ts`) est un rendu regex maison qui n'émet que
`h1/h2/h3/p/strong/em/blockquote/div/hr/table/tr/td/th/ul/ol/li`. Une définition, une propriété, un
exemple résolu, un piège, un « à retenir », une figure légendée : rien de tout cela n'existe dans son
vocabulaire. Tout retombe en `<p>` ou en `<blockquote>` indifférencié.

Or **le contenu encode déjà cette sémantique** — le `style-guide.md` l'impose (§ squelette
`cours.md`, lignes 21/28/29) et les auteurs l'ont respectée :

| sémantique déjà écrite dans `content/**/cours.md` | occurrences | cours concernés |
| ------------------------------------------------- | ----------: | --------------: |
| `> ⚠️` — le piège classique                       |         821 |             448 |
| `> 🗡️` — l'astuce du prof                         |         759 |             452 |
| `> 💡` — l'accroche / l'épigraphe                 |         539 |             512 |
| `> 🏆` — la clôture « chapitre validé »           |         518 |             512 |
| `$$ … $$` — formule isolée                        |         457 |             128 |
| tableaux markdown                                 |           — |             405 |
| sections `##`                                     |           — |             526 |

**2 637 callouts sémantiques**, présents dans **517 cours sur 541 (95,6 %)**, sont aujourd'hui
aplatis en `<blockquote>` identiques. Idem côté résumé : **525 `resume.md` sur 541 (97,0 %)** suivent
déjà le motif normatif `- **Concept** : essence` (`course-quality.md` axe 3, « resume ↔ course
bijection ») — c'est-à-dire une carte de révision, rendue en puce grise.

**Cause B — le contenu n'a jamais reçu la consigne d'illustrer.** La barre qualité
`content-engine/references/course-quality.md` a **quatre axes** (clarté, compréhension, exhaustivité,
expérience) et **aucun n'est visuel**. Le skill `content-cours` — celui qui écrit les leçons — ne
prononce **pas une seule fois** les mots _figure_, _svg_, _illustration_, _schéma_, _visuel_ ou
_image_. La **seule** règle sur les figures de tout le système d'écriture est le § « Calibrate to the
student's age (**and colourful figures for the youngest**) » de `style-guide.md`, qui vise les
**questions** des **petites classes** (« one figure per question »).

Cela explique exactement la distribution observée :

| mesure                                                       | valeur          |
| ------------------------------------------------------------ | --------------- |
| `cours.md` dans `content/`                                   | 541             |
| `cours.md` portant au moins un `<svg>`                       | **66** (12,2 %) |
| `resume.md` portant au moins un `<svg>`                      | **0**           |
| fichiers `quiz.json` / `exercices/*.json` portant un `<svg>` | 382             |
| figures dans les 5 chapitres de géométrie de maths 9ᵉ        | **0**           |

Les 66 cours illustrés sont massivement ceux des **petites classes** (`arabic-1ere`, formes de
lettres) et de `muscle-cerveau` — exactement là où la seule règle existante pointe. Les cinq
chapitres de géométrie de l'année de **concours national** (`math/08-thales` 112 lignes,
`09-triangle-rectangle-trigo` 119, `10-angles-cercle` 122, `11-vecteurs-translation` 120,
`13-geometrie-espace` 146) n'ont **aucune figure** : le cours de Thalès décrit le triangle ABC et la
droite (MN) **uniquement avec des mots**, et l'élève doit construire la figure dans sa tête en même
temps qu'il découvre le théorème.

**Cause B bis — rien ne garde le portail.** `scripts/content/qa.ts` ne lit **jamais** `cours.md` ni
`resume.md` : il ne parcourt que les questions du quiz et des exercices. Les 541 leçons sont
**hors du gate contenu déterministe** — la dérive pouvait donc durer indéfiniment sans qu'aucune CI
ne s'en aperçoive.

### Résultat attendu

1. Le lecteur de cours (`/chapitre/$chapterId`, public, anonyme compris) expose une **structure
   pédagogique lisible d'un coup d'œil** : définition, propriété, formule, exemple résolu, méthode,
   piège, astuce, à retenir, figure légendée — plus un sommaire et une progression de lecture.
2. Les **figures deviennent une exigence** pour tout chapitre à notions spatiales, portée par la
   barre qualité, les skills d'écriture, le skill d'audit et le gate contenu.
3. Le **résumé** devient un jeu de **cartes de révision**, pas une liste de puces.
4. La géométrie de 9ᵉ est illustrée (chantier pilote, déjà maquetté et validé).

### Indicateurs de succès (mesurables)

| KPI                                                                        | avant | cible (fin d'étude) |
| -------------------------------------------------------------------------- | ----- | ------------------- |
| Cours dont la sémantique est rendue en blocs typés (non en `<blockquote>`) | 0     | **517** (95,6 %)    |
| Résumés rendus en cartes de révision                                       | 0     | **541**             |
| Figures dans les 5 chapitres de géométrie 9ᵉ                               | 0     | **≥ 12**            |
| Axes de la barre qualité couvrant le visuel                                | 0 / 4 | **1 / 5**           |
| `cours.md` / `resume.md` inspectés par `content:qa`                        | 0     | **541 / 541**       |

### Ce que l'epic ne cherche PAS à faire

- **Pas de photo, pas de bitmap.** Arbitré 2026-07-14 : **SVG inline uniquement**. Le SVG couvre
  géométrie, schémas, diagrammes, frises, graphiques ; il ne couvre pas la photo (cellule SVT, carte
  satellite, portrait historique), qui exigerait Supabase Storage, un pipeline d'assets et une source
  d'images libres de droits — les planches des manuels scannés ne sont pas redistribuables. Chantier
  séparé si un jour souhaité.
- **Pas de refonte de l'identité RPG** (é14). Les titres de sections à emoji (`## ⚔️ …`) du contenu
  existant sont **conservés tels quels** : c'est l'**appareil** de la page (blocs, figures, sommaire)
  qui porte le nouveau registre de lecture, pas la prose.
- **Pas de rendu mathématique** (KaTeX/MathJax). Les formules restent de l'Unicode brut isolé LTR,
  conformément à `math-and-notation.md`.
- **Pas de touche aux 382 figures de questions** ni au composant `SvgFigure` : leur surface et leur
  convention restent inchangées (voir D-4).
- **Pas de changement de base de données.** Cette étude ne crée **aucune** migration (§3).

---

## 2. Spécification fonctionnelle

### Acteurs & parcours

Le lecteur de cours est **public** : un visiteur anonyme lit sans compte (`getChapterLesson`,
chantier C8). Tout ce qui suit vaut donc pour l'anonyme comme pour l'élève connecté.

- **US-1** — En tant qu'élève, je distingue **d'un coup d'œil** une définition, une formule, un
  exemple résolu, un piège et un « à retenir » : ils ne se ressemblent plus.
- **US-2** — En tant qu'élève de 9ᵉ en géométrie, **je vois la figure** du théorème (configuration
  triangle, configuration papillon, réciproque) au lieu de devoir l'imaginer.
- **US-3** — En tant qu'élève sur téléphone, je peux **agrandir une figure** pour lire ses étiquettes.
- **US-4** — En tant qu'élève, je vois le **sommaire** du chapitre, je sais **où j'en suis**, et je
  saute directement à une section.
- **US-5** — En tant qu'élève arabophone, le cours reste **RTL** tandis que formules et figures
  restent **LTR** en notation standard (chiffres occidentaux, équations LTR — `math-and-notation.md`).
- **US-6** — En tant qu'élève qui révise la veille du concours, le **résumé** est un jeu de **cartes**
  (concept + essence, formules isolées), pas une liste de puces.
- **US-7** — En tant qu'élève qui imprime son cours, les blocs et les figures **s'impriment**
  proprement (le bouton Imprimer existe déjà).
- **US-8** — En tant qu'auteur (skill `content-cours`), je dispose de **gabarits SVG** et d'une règle
  claire : _un chapitre à notions spatiales sans figure est une non-conformité_.
- **US-9** — En tant qu'auditeur (skill `content-audit`), je note l'**axe Illustration** au même titre
  que les quatre autres.

### Règles métier

**Rendu — invariants de sécurité**

- **R-1** — **Le contenu ne porte jamais de HTML.** L'invariant actuel est conservé mot pour mot : le
  corps markdown est **intégralement HTML-échappé** (`&` `<` `>`) _avant_ toute émission de balise ;
  les seules balises qui survivent sont **celles que le renderer émet lui-même**. Un auteur ne peut
  donc pas injecter de markup, quoi qu'il écrive.
- **R-2** — L'**unique exception** reste le bloc `<svg>…</svg>`, extrait avant l'échappement, passé par
  `sanitizeSvg` (profil SVG DOMPurify : primitives de dessin seules — ni `script`/`style`/
  `foreignObject`/`<a>`/`<image>`/`<use>`, ni `on*`, ni `href`/`xlink:href`, schémas dangereux
  neutralisés), puis ré-injecté après la passe de sanitize. **Aucun changement à `sanitizeSvg`.**
- **R-3** — `ALLOWED_ATTR` n'accueille **ni `style` ni `href`**. Il passe de `["class","id","dir"]` à
  `["class","id","dir","role","tabindex","aria-label"]` — trois attributs inertes, requis par
  l'accessibilité des figures agrandissables (US-3).

**Rendu — promotion de la sémantique existante (zéro fichier de contenu touché)**

- **R-4** — Le renderer **promeut** les callouts emoji déjà normatifs :

  | ligne markdown | rendu                                                                                                                                   |
  | -------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
  | `> ⚠️ …`       | bloc **piège**                                                                                                                          |
  | `> 🗡️ …`       | bloc **astuce**                                                                                                                         |
  | `> 💡 …`       | bloc **éclairage** — sauf le **premier**, s'il précède le premier `##` : c'est l'**épigraphe** (`style-guide.md` § squelette, ligne 21) |
  | `> 🏆 …`       | bloc **à retenir** (la clôture « chapitre validé »)                                                                                     |
  | tout autre `>` | `<blockquote class="lesson-quote">` — **inchangé, aucune régression**                                                                   |

- **R-5** — Le renderer **ne devine jamais par la prose**. Aucune détection sur « **Exemple calculé** : »
  ou « مثال محسوب » : le sniffing de prose est fragile en trois langues et sera silencieusement faux.
  Un exemple résolu est un bloc **explicite** (R-6) ou n'en est pas un.

**Rendu — directives explicites (contenu neuf et rattrapage)**

- **R-6** — Grammaire des directives, **la seule syntaxe d'auteur ajoutée** :

  ```
  ::: <type>[ <titre libre>]
  <contenu markdown>
  :::
  ```

  - ligne ouvrante : `^:::[ \t]+([a-z]+)(?:[ \t]+(.*))?$` — type en ASCII minuscule, sans accent
  - ligne fermante : `^:::[ \t]*$`
  - **types clos** : `definition` · `propriete` · `exemple` · `methode` · `figure` · `piege` ·
    `astuce` · `retenir`
  - **pas d'imbrication** en v1 (un `:::` ouvrant dans un bloc ouvert = `[error]` QA)

- **R-7** — **Fail-safe, toujours.** Un type **inconnu** est rendu en bloc **neutre** (classe de base,
  sans modificateur) et remonté `[error]` par `content:qa`. Une directive **non fermée** est
  **implicitement fermée en fin de document** et remontée `[error]`. Le renderer **ne jette jamais** et
  ne produit jamais de page cassée : une faute d'auteur dégrade le style, jamais la lecture.

- **R-8** — Le **libellé** d'un bloc (« DÉFINITION », « تحذير », « TIP »…) suit la **langue du contenu**,
  pas la locale de l'interface : la leçon est un document, son appareil en fait partie. Un libellé
  français dans une prose arabe RTL serait une faute de composition (`docs/content-voice-and-composition.md`).

**Figures**

- **R-9** — Toute figure de cours porte une **légende** : `::: figure <légende>`. Sans légende →
  `[error]` QA.
- **R-10** — Les figures sont **numérotées automatiquement** dans l'ordre du document (« Figure 1 »,
  « الشكل 1 »…), la numérotation étant émise par le renderer, jamais écrite par l'auteur.
- **R-11** — Tout `<svg>` a un `viewBox` (sinon il s'effondre au rendu). Règle déjà appliquée aux
  questions (`auditRenderedFields`), **étendue au cours** → `[error]`.
- **R-12** — Un cours qui **désigne** une figure (« ci-dessous », « الشكل المجاور »… — la regex
  `FIGURE_REFERENCE` existe déjà dans `qa-checks.ts`) **sans en contenir aucune** → `[error]`.
  C'est le contrôle le plus discriminant : il attrape le cours qui parle d'une image absente.
- **R-13** — Un chapitre déclaré « à figures obligatoires » (familles listées dans
  `course-figures.md` : géométrie plane, cercle, repère & vecteurs, solides, schémas SVT, circuits,
  frises, graphiques) sans aucun `<svg>` → `[warn]` au lot 4, **promu `[error]`** matière par matière
  au fil de la campagne de rattrapage.

**Résumé**

- **R-14** — Chaque puce de premier niveau de `resume.md` devient une **carte**. Si elle commence par
  `**Concept**`, le gras devient le **titre** de la carte et le reste son **corps** ; sinon la carte
  est sans titre. **Uniforme, sans seuil, sans branche** — les 16 résumés non conformes (541 − 525)
  dégradent proprement en cartes sans titre.
- **R-15** — Une carte contenant une formule (`$$ … $$`) l'isole **LTR** comme dans le cours.

### i18n

- **Chrome du lecteur** (fr/en/ar, dans `@/lib/i18n`) : `t.public.reader.toc` (« Sommaire »),
  `t.public.reader.zoomFigure` (« Agrandir la figure »), `t.public.reader.closeFigure` (« Fermer »),
  `t.public.reader.readingTime` (« {n} min de lecture »), `t.public.reader.figureCount` (« {n} figures »).
- **Libellés de blocs** : **hors i18n de l'UI** (R-8). Table close fr/en/ar dans
  `src/shared/lib/lesson-blocks.ts`, indexée par la langue **du contenu**
  (`subjects.content_language`, repli sur `isRtlText`).
- **RTL** : le conteneur de lecture garde son `dir` piloté par la langue du contenu (comportement
  actuel de `LessonReader`) ; formules, figures et étiquettes de figures restent **LTR isolés**.

### Hors périmètre (v1)

- Photos / images bitmap (arbitré : SVG seul).
- Les **382 figures de questions** et le composant `SvgFigure` : inchangés (D-4).
- Figures nativement sombres (voir D-4 : la planche reste claire dans les deux thèmes) → backlog.
- Rendu mathématique (KaTeX) → hors sujet.
- La **campagne de fond** au-delà de la géométrie 9ᵉ : elle sort de l'étude et rejoint les sessions
  de contenu, **une matière par session** (standard « profondeur de génération », audit 2026-07-12).

---

## 3. Architecture technique (décisions fermées)

### Modèle de données

**Aucun changement.** Ni table, ni colonne, ni RPC, ni migration. `chapters.lesson_content` et
`chapters.summary` restent des `text` markdown ; `src/shared/content/schema.ts` continue de les typer
`lesson: string` / `summary: string`. Le DoD §7 (coordination DB↔code) **ne s'applique pas** à cette
étude, **sauf au lot 5** qui, en modifiant `content/math/**`, produit une migration de contenu
ordinaire via `npm run content:build -- --subject math`.

### Serveur

**Aucun changement.** Aucune server fn, aucun RPC. Le lecteur consomme déjà `getChapterLesson`
(anon-capable). Tout ce qui suit est du **rendu**.

### Client — le moteur

**`src/shared/lib/markdown.ts`** — `renderMarkdown` est **remplacé** (pas doublé : DoD §3, « delete
what you replace » ; il n'a qu'un seul appelant, `lesson-reader.tsx`) :

```ts
export type LessonBlockType =
  "definition" | "propriete" | "exemple" | "methode" | "figure" | "piege" | "astuce" | "retenir";

export type LessonSection = { id: string; title: string };

export type RenderedLesson = {
  /** HTML assaini, prêt pour dangerouslySetInnerHTML. */
  html: string;
  /** Sections `##` dans l'ordre, pour le sommaire construit en React. */
  sections: LessonSection[];
  /** Nombre de figures — alimente la puce « N figures » du rail. */
  figureCount: number;
};

export type RenderedSummary = { html: string; cardCount: number };

export function renderLesson(md: string, opts?: { lang?: ContentLang }): RenderedLesson;
export function renderSummary(md: string, opts?: { lang?: ContentLang }): RenderedSummary;
```

**Pipeline de `renderLesson`, dans cet ordre (l'ordre est l'invariant de sécurité) :**

1. **Extraction des `<svg>`** → placeholders (mécanisme actuel, inchangé), chaque figure passée par
   `sanitizeSvg`.
2. **Pré-passe par lignes** (un vrai petit parser de blocs, ~120 lignes — **pas** une regex globale) :
   segmentation en blocs `:::` (R-6/R-7) et en callouts `>` promus (R-4). Produit un arbre plat
   `Array<{ kind: "block" | "quote" | "raw"; type?; title?; lines: string[] }>`.
3. **Échappement HTML** du texte de chaque segment (R-1) — inchangé.
4. **Rendu inline** (gras, italique, `$$`, tableaux, listes, titres) — passes existantes, réutilisées.
5. **Émission** des balises de blocs par le renderer.
6. **`DOMPurify.sanitize`** avec l'allowlist ci-dessous.
7. **Ré-injection** des figures assainies.

**Allowlist (`ALLOWED_TAGS`)** — ajouts en gras :
`h1 h2 h3 p strong em blockquote div hr table tr td th ul ol li` **`section figure figcaption span`**
**`ALLOWED_ATTR`** : `class id dir` **`role tabindex aria-label`** (R-3).

**HTML émis**

```html
<!-- bloc typé -->
<section class="lesson-blk lesson-blk--piege">
  <span class="lesson-blk__label">تحذير</span>
  <p>…</p>
</section>

<!-- figure -->
<figure class="lesson-figure" role="button" tabindex="0" aria-label="الشكل 1 — …">
  <div class="lesson-figure__plate"><svg …>…</svg></div>
  <figcaption class="lesson-figure__caption">
    <span class="lesson-figure__num">الشكل 1</span><span>…légende…</span>
  </figcaption>
</figure>

<!-- épigraphe (premier `> 💡` avant le premier `##`) -->
<blockquote class="lesson-epigraph">…</blockquote>
```

**`src/shared/lib/lesson-blocks.ts` (nouveau)** — table close des libellés, indexée par type × langue
de contenu (R-8) :

```ts
export type ContentLang = "fr" | "en" | "ar";
export const BLOCK_LABELS: Record<LessonBlockType, Record<ContentLang, string>> = {
  definition: { fr: "Définition", en: "Definition", ar: "تعريف" },
  propriete: { fr: "Propriété", en: "Property", ar: "خاصّية" },
  exemple: { fr: "Exemple résolu", en: "Worked example", ar: "مثال محلول" },
  methode: { fr: "Méthode", en: "Method", ar: "طريقة" },
  piege: { fr: "Piège", en: "Pitfall", ar: "تحذير" },
  astuce: { fr: "Astuce", en: "Tip", ar: "حيلة" },
  retenir: { fr: "À retenir", en: "Remember", ar: "للحفظ" },
  figure: { fr: "Figure", en: "Figure", ar: "الشكل" },
};
```

### Client — le lecteur

**`src/features/quest/components/lesson-reader.tsx`** :

- appelle `renderLesson` / `renderSummary` (mémoïsés comme aujourd'hui) ;
- construit le **sommaire en React** à partir de `sections` — **jamais** dans la chaîne HTML
  assainie : aucun `href` n'entre donc dans le HTML injecté (R-3) ;
- rail **collant** en `lg:` (grille 2 colonnes), replié en `<details>` sous `lg` ;
- **scroll-spy** via `IntersectionObserver` sur les `#section-N` (les `id` sont déjà générés
  aujourd'hui — et ne servaient à rien) ; dégradation propre si l'API manque ;
- **agrandissement de figure** (US-3) : écouteur **délégué** sur le conteneur (le HTML est injecté),
  clic ou `Enter`/`Space` sur une `.lesson-figure` → `Dialog` (`@/components/ui/dialog`) affichant le
  SVG **re-passé par `sanitizeSvg`** (défense en profondeur) ;
- l'onglet **Résumé** existant rend désormais le deck de cartes.

### Client — le style

**`src/styles.css`**, section « Lesson content styling », classes `.lesson-*` (nomenclature conservée) :
`.lesson-blk` + modificateurs, `.lesson-blk__label`, `.lesson-epigraph`, `.lesson-figure` (refonte),
`.lesson-figure__plate`, `.lesson-figure__caption`, `.lesson-figure__num`, `.lesson-cards`,
`.lesson-card`, `.lesson-card__title`. `.lesson-math` **garde son nom** (restylé, pas renommé).

Couleurs **exclusivement** via les tokens é14 (`--primary`, `--secondary`, `--border`, `--foreground`,
`--muted-foreground`, `--neon-gold`) ; aucune couleur littérale. Sémantique : le teal porte définition/
propriété/formule, l'or porte « à retenir », et le **piège** reçoit une couleur **sémantique
d'avertissement** distincte de l'accent de marque.

**Impression** : blocs et figures s'impriment (`print:` ne masque que le chrome — comportement actuel).

### Sécurité & anti-triche

- Le corps reste **échappé avant émission** (R-1) : la surface d'injection est **inchangée**.
- `sanitizeSvg` **n'est pas touché**. Le profil SVG reste la frontière vettée.
- `ALLOWED_ATTR` ne gagne que des attributs **inertes** (R-3) : ni `style`, ni `href`, ni `on*`.
- **`docs/xss-rendering-policy.md` est mis à jour** au lot 1 : la frontière « Lesson markdown renderer
  path (`renderMarkdown`) » devient `renderLesson` / `renderSummary`, avec la liste des balises émises.
- Aucun secret, aucune clé de réponse : le cours est du contenu **public**.

### Observabilité

Rien à instrumenter (rendu pur, pas d'I/O). Aucun log ajouté.

### Décisions d'architecture (ADR)

- **D-1 — Deux mécanismes de rendu, pas un.** (a) **Promotion** des callouts emoji déjà normatifs
  (R-4) : 517 cours sur 541 gagnent une structure **sans qu'un fichier de contenu soit touché** ;
  (b) **directives `:::`** (R-6) pour la sémantique que le contenu n'encode pas encore (définition,
  propriété, exemple, méthode, figure, à retenir).
  _Alternatives rejetées_ : le **sniffing de prose** (« Exemple calculé : ») — fragile en trois langues,
  faux silencieusement ; le **tout-directives** — imposerait de réécrire 541 cours avant le moindre
  effet visible.
- **D-2 — Le contenu ne porte jamais de HTML brut**, malgré la demande littérale « je veux que ça soit
  du HTML ». Ce qui est demandé est un **résultat** (une page riche), pas un **format d'écriture**. Le
  HTML riche est bien ce qui sort du renderer ; le laisser **entrer** par le contenu ouvrirait une
  surface XSS sur 541 fichiers écrits par des modèles, ferait diverger le design de 541 cours, et
  rendrait tout re-thémage impossible. L'app possède le markup ; le contenu porte du **sens**.
- **D-3 — Le renderer retourne une structure, pas une chaîne.** `RenderedLesson.sections` alimente le
  sommaire **côté React**, ce qui évite d'introduire des `<a href>` dans le HTML assaini.
- **D-4 — La figure reste une planche claire dans les deux thèmes.** C'est la décision **déjà en
  vigueur** (commentaire de `src/styles.css` : _« Authored SVGs use dark ink on an implied light
  worksheet… matching the exercise figure surface »_), et **448 figures existantes** (66 cours + 382
  questions) en dépendent. Ce que le lot 2 change : la **taille** (22 rem → pleine colonne de lecture,
  avec débord maîtrisé), la **légende**, la **numérotation**, l'**agrandissement** et le **cadre**.
  _Alternative rejetée_ : figures nativement thémées (classes de peinture + planche sombre) — impose la
  migration de 448 SVG pour une valeur pédagogique nulle, et créerait **deux conventions de figure**
  (cours ≠ question) pour les auteurs. En sombre, la planche est une **planche de manuel** : c'est un
  choix, pas un oubli. → backlog si un jour souhaité.
- **D-5 — Le libellé de bloc suit la langue du contenu**, pas la locale de l'UI (R-8).
- **D-6 — Le résumé se promeut, il ne se réécrit pas.** 525 `resume.md` sur 541 portent déjà
  `- **Concept** : essence` : le deck de cartes se déduit (R-14). Zéro fichier de contenu touché.
- **D-7 — Le gate contenu s'ouvre enfin aux leçons.** `content:qa` cesse d'ignorer `cours.md` /
  `resume.md` (lot 4). Bénéfice collatéral : les contrôles de **notation** existants
  (`hasBidiFragileMath`, `hasArabicCommaInMath`) — qui n'avaient **jamais** tourné sur les cours — s'y
  appliquent enfin. **Attendre des découvertes** : le lot 4 doit budgéter la correction des
  non-conformités qu'il révélera.
- **D-8 — SVG seul.** Arbitré par Mohamed le 2026-07-14. Motifs : versionné avec le cours, thémable,
  net à toute échelle, imprimable, zéro réseau, zéro stockage, zéro question de droits — et **déjà
  supporté de bout en bout** (sanitizer, renderer, CSS, 382 fichiers d'exercices).

---

## 4. Plan d'exécution en lots

| lot   | contenu (résumé)                                              | fichiers / objets                                                                                                                                                                                           | tests exigés                                        | dépend de |
| ----- | ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- | --------- |
| **1** | Moteur de blocs + sommaire — **0 fichier de contenu**         | `src/shared/lib/markdown.ts` (→ `renderLesson`), `src/shared/lib/lesson-blocks.ts` (n), `src/styles.css`, `src/features/quest/components/lesson-reader.tsx`, `src/lib/i18n`, `docs/xss-rendering-policy.md` | `markdown.test.ts` étendu, `lesson-reader.test.tsx` | —         |
| **2** | Figures côté rendu : planche, légende, numéro, agrandissement | `markdown.ts`, `styles.css`, `lesson-reader.tsx` (+ `Dialog`), i18n                                                                                                                                         | unit + a11y clavier                                 | 1         |
| **3** | Résumé en cartes de révision — **0 fichier de contenu**       | `markdown.ts` (`renderSummary`), `styles.css`, `lesson-reader.tsx`                                                                                                                                          | unit                                                | 1         |
| **4** | Doctrine d'illustration + ouverture du gate contenu           | `course-quality.md`, `course-figures.md` (n), `content-engine/SKILL.md`, `content-cours/SKILL.md`, `content-audit/SKILL.md`, `style-guide.md`, `scripts/content/qa.ts`, `scripts/content/qa-checks.ts`      | `qa-checks.test.ts` étendu                          | 2         |
| **5** | Campagne pilote : géométrie 9ᵉ illustrée                      | `content/math/{08,09,10,11,13}-*/cours.md` + `resume.md`, migration `content:build -- --subject math`                                                                                                       | `content:check` + `content:qa:strict`               | 4         |

- [x] **Lot 1 — Le moteur de blocs.**
      _Périmètre_ : R-1 → R-8. Remplacer `renderMarkdown` par `renderLesson` (un seul appelant).
      Parser de blocs par lignes (pas de regex globale). Promotion des callouts. Directives `:::`
      (tous types, y compris `figure`, mais **sans** la refonte visuelle des figures — lot 2). CSS des
      blocs. Sommaire + scroll-spy. i18n. Mise à jour de `docs/xss-rendering-policy.md`.
      _Acceptation_ : US-1, US-4, US-5, US-7 ; R-1…R-8. **Aucun fichier sous `content/` modifié** (le
      diff doit le prouver). Les 30+ tests XSS existants de `markdown.test.ts` passent **sans
      modification** — s'ils doivent être touchés, c'est que l'invariant R-1 a été cassé : **STOP**.
      _Stop-point_ : ne pas toucher aux figures (lot 2), au résumé (lot 3), ni au moindre skill.

- [x] **Lot 2 — Les figures.**
      _Périmètre_ : R-9 → R-11 côté rendu. Planche `.lesson-figure__plate` (claire dans les deux
      thèmes, D-4), légende + numérotation automatique, débord maîtrisé de la colonne de lecture,
      agrandissement en `Dialog` (clic + clavier + `aria-label`), impression.
      _Acceptation_ : US-2 (côté rendu), US-3, US-7. Une figure sans légende ne casse pas la page.
      _Stop-point_ : ne **pas** migrer les 66 SVG de cours existants, ne **pas** toucher à `SvgFigure`
      ni aux 382 figures de questions (D-4).

- [x] **Lot 3 — Le résumé en cartes.**
      _Périmètre_ : R-14, R-15, D-6. `renderSummary`, `.lesson-cards` / `.lesson-card`, onglet Résumé.
      _Acceptation_ : US-6. Les 16 résumés non conformes rendent des cartes sans titre, sans erreur.
      **Aucun fichier sous `content/` modifié.**

- [ ] **Lot 4 — La doctrine d'illustration.**
      _Périmètre_ :
      (a) `course-quality.md` gagne un **axe 5 — Illustration** (et la section « Audit grading » +
      la ligne « Report per axis » passent de 4 à 5 axes). Sévérités : chapitre à notions spatiales
      **sans aucune figure** → `[MAJOR]` ; règle spatiale énoncée sans sa figure → `[MAJOR]` ; figure
      sans légende / redondante avec le texte / illisible en RTL → `[MINOR]`.
      (b) **nouveau** `content-engine/references/course-figures.md` : la doctrine + les **gabarits SVG**
      par famille — géométrie plane (triangle, parallèles, configurations de Thalès), cercle & angles,
      repère & vecteurs, solides, schéma SVT, circuit électrique, frise chronologique, graphique — plus
      les règles de dessin (`viewBox` obligatoire, encre sombre sur planche claire, étiquettes en
      notation standard LTR, ni `<image>`/`<use>`/`href`, **une figure = une idée**, cohérence
      **stricte** avec l'énoncé : les points annoncés sur les segments y sont, les parallèles le sont
      réellement).
      (c) `content-cours/SKILL.md` gagne une étape « Illustrer » ; `content-audit/SKILL.md` audite
      l'axe 5 ; `style-guide.md` cesse de laisser croire que les figures ne concernent que les petites
      classes ; `content-engine/SKILL.md` référence `course-figures.md`.
      (d) `scripts/content/qa.ts` **parcourt enfin** `chapter.lesson` et `chapter.summary` ; nouveau
      `auditLesson(md, where)` dans `qa-checks.ts` : R-7 (type inconnu, non fermé), R-9, R-11, R-12,
      R-13, plus la réutilisation de `auditRenderedFields` (notation, bidi, virgule arabe).
      _Acceptation_ : US-8, US-9 ; `npm run content:qa:strict` **vert sur les 541 cours** — donc ce lot
      **inclut la correction des non-conformités révélées** (D-7). Si leur volume dépasse une PR
      raisonnable, **STOP** et escalade : on scinde en 4a (règles + `[warn]`) et 4b (corrections + passage
      en `[error]`).
      _Stop-point_ : R-13 reste `[warn]` — ne le passer en `[error]` que matière par matière, au fil de
      la campagne.

- [ ] **Lot 5 — Campagne pilote : la géométrie de 9ᵉ.**
      _Périmètre_ : illustrer les 5 chapitres (`math/08-thales`, `09-triangle-rectangle-trigo`,
      `10-angles-cercle`, `11-vecteurs-translation`, `13-geometrie-espace`) — **≥ 12 figures** —, ajouter
      les blocs `::: definition` / `::: exemple` / `::: figure` là où la prose les portait implicitement,
      et illustrer les résumés correspondants. Écrit par `content-cours` + `prof-math-9eme`, audité par
      `content-audit` (axe 5).
      Les trois figures de `08-thales` (configuration triangle, configuration papillon, réciproque sur
      l'exemple chiffré déjà présent ligne 57 du cours) sont **maquettées et validées** — s'y conformer.
      _Acceptation_ : US-2 ; `content:check` + `content:qa:strict` verts ; migration générée par
      `npm run content:build -- --subject math` (**jamais** `content:build` nu — CLAUDE.md) ; DoD §7.
      _Stop-point_ : **une seule matière** (`math`). Ne pas enchaîner sur SVT/physique dans la même PR.

**Après le lot 5** : la campagne de fond sort de l'étude → backlog contenu, **une matière par session**
(standard « profondeur de génération », audit 2026-07-12). Ordre recommandé : SVT 9ᵉ → physique 9ᵉ →
maths 6ᵉ → collège → lycée (Q-1).

---

## 5. Stratégie de test

**Unit (Vitest, co-localisés)** — l'essentiel du gate, cette étude étant du rendu pur.

- `src/shared/lib/__tests__/markdown.test.ts` (étendu) :
  - **non-régression XSS** : les 30+ tests existants passent **sans être modifiés** (invariant R-1) ;
  - promotion de chaque callout (R-4), y compris la règle « premier `> 💡` avant le premier `##`
    = épigraphe » et le repli `<blockquote>` pour un `>` sans emoji connu ;
  - directives (R-6) : chaque type ; **type inconnu → bloc neutre, pas de crash** ; **non fermée →
    fermeture implicite** ; `:::` imbriqué ;
  - figures : légende, numérotation dans l'ordre, `aria-label`, `viewBox` absent ;
  - `sections` extraites dans l'ordre avec les bons `id` ; `figureCount` ;
  - **RTL/bidi** : prose arabe + formule LTR + étiquettes de figure préservées (le test « handles mixed
    Arabic and math » existant doit rester vert) ;
  - libellés de blocs par langue de contenu (R-8).
- `src/shared/lib/__tests__/lesson-blocks.test.ts` (nouveau) : table close complète (aucun type sans
  libellé dans les 3 langues).
- `src/features/quest/components/__tests__/lesson-reader.test.tsx` : sommaire rendu depuis `sections` ;
  bascule Cours/Résumé ; ouverture/fermeture du `Dialog` de figure **au clavier** ; absence de crash
  sans `IntersectionObserver` (jsdom).
- `scripts/content/__tests__/qa-checks.test.ts` (étendu, lot 4) : chacun des contrôles R-7/R-9/R-11/
  R-12/R-13 sur des fixtures minimales.

**pgTAP** — **aucun** : cette étude ne touche pas une ligne de SQL.

**Gate contenu** — `npm run content:check` + `npm run content:qa:strict` verts (lots 4 et 5). Le lot 4
est le premier à faire passer les 541 leçons dans le gate : **prévoir les découvertes** (D-7).

**`smoke:shell` — non négociable.** Le renderer est dans le bundle **prod** et le lecteur de cours est
une page **publique** : c'est exactement la classe de code que l'incident du 2026-07-01 a rendue
obligatoire à couvrir. Aucun lot ne merge sans `smoke:shell` vert.

**e2e (Playwright)** — les specs publiques existantes couvrent déjà `/chapitre/$chapterId` ; vérifier
qu'elles restent vertes. Ajouter **une** assertion au lot 2 : une figure est présente et
agrandissable sur un chapitre illustré (projet `public-chromium` + `public-mobile`).

**Non-régression de l'existant** — la preuve tient en deux points : (1) le diff des lots 1 à 3 ne
contient **aucun** fichier sous `content/` ; (2) les tests XSS de `markdown.test.ts` sont verts **sans
avoir été touchés**.

---

## 6. Risques & mitigations

- **RISK-1 — Régression XSS en élargissant le renderer.** _Probabilité faible / impact critique._
  Mitigation : l'invariant « échapper d'abord, émettre nos balises ensuite » (R-1) est **conservé
  intact** ; `sanitizeSvg` n'est pas touché (R-2) ; `ALLOWED_ATTR` ne gagne que des attributs inertes
  (R-3) ; les tests XSS existants doivent passer **sans modification** — toute modification nécessaire
  est le signal d'un invariant cassé et impose un **STOP**.
- **RISK-2 — Le renderer regex devient ingérable** (il enchaîne déjà ~15 passes).
  Mitigation : la segmentation en blocs se fait dans une **pré-passe par lignes** (petit parser
  explicite, ~120 lignes, testé), **pas** en ajoutant une 16ᵉ regex globale. Les passes inline
  existantes sont réutilisées telles quelles.
- **RISK-3 — 512 cours changent d'apparence d'un seul coup au lot 1.** _Probabilité certaine / impact
  moyen._ Mitigation : **aucun contenu n'est modifié** — le retour arrière est le revert d'une PR de
  code ; `smoke:shell` + e2e publiques couvrent le lecteur ; la promotion est **conservatrice** (un `>`
  non reconnu reste un `<blockquote>`).
- **RISK-4 — Le lot 4 révèle un volume inattendu de non-conformités** en ouvrant le gate aux leçons
  (D-7). _Probabilité forte / impact moyen._ Mitigation : scission prévue et **autorisée d'avance** en
  4a (règles + `[warn]`) et 4b (corrections + `[error]`) — l'exécuteur n'a pas à demander l'arbitrage
  pour ça, il l'annonce dans la PR.
- **RISK-5 — La campagne produit des figures géométriquement fausses** (point hors du segment,
  « parallèles » qui ne le sont pas). _Probabilité moyenne / impact fort — une figure fausse est pire
  qu'aucune figure._ Mitigation : `course-figures.md` impose la **cohérence stricte avec l'énoncé** et
  la **vérification des coordonnées** ; l'axe 5 de `content-audit` la contrôle ; le balayage planifié
  `content-audit.yml` (mer. + sam.) repasse sur le contenu modifié de la semaine.
- **RISK-6 — Conflit d'identité avec l'é14** (registre RPG vs registre de lecture sobre).
  _Probabilité faible._ Mitigation : le contenu n'est pas retouché — les titres de sections à emoji
  restent ; le nouveau registre est porté par l'**appareil** (blocs, figures, sommaire), et toutes les
  couleurs proviennent des tokens é14. Direction **validée sur maquette** le 2026-07-14.
- **RISK-7 — Budget de bundle.** _Probabilité faible._ Le parser ajoute quelques ko au chunk partagé.
  Mitigation : `npm run build:check` fait partie du gate ; aucune dépendance nouvelle (pas de
  `remark`/`marked` — le renderer maison reste maison).

---

## 7. Questions ouvertes (pour l'humain)

Les deux arbitrages structurants ont été rendus le **2026-07-14** :

- ✅ **Médium des illustrations** → **SVG inline uniquement** (D-8). La photo/bitmap est écartée de
  l'étude ; chantier séparé si un jour souhaité.
- ✅ **Cadrage** → étude formelle puis exécution **lot par lot** (une PR par lot).

Reste :

- **Q-1 — Ordre de la campagne de fond, après la géométrie 9ᵉ (lot 5).** Recommandation de
  l'architecte : **SVT 9ᵉ → physique 9ᵉ → maths 6ᵉ**, puis le collège, puis le lycée — priorité aux
  **années de concours national** et aux matières dont les notions sont intrinsèquement spatiales.
  À confirmer quand le lot 5 sera livré (la question ne bloque aucun lot de cette étude).

---

## 8. Journal d'exécution

| date       | lot | PR  | écarts acceptés / dettes notées                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------- | --- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 2026-07-14 | —   | —   | Étude rédigée (Opus 4.8). Maquette du chapitre pilote (Thalès) validée par Mohamed. Q-1 ouverte.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| 2026-07-14 | 1   | —   | **Lot 1 livré.** Mesure réelle : **517** cours / 541 (95,6 %) gagnent un bloc typé — l'étude annonçait 512, qui était le compte du seul `> 💡` ; l'union des 4 marqueurs donne 517 (§1 et KPI corrigés). 2 637 citations promues sur 2 974 : les 337 autres restent des `<blockquote>` inchangés. Aucun `:::` préexistant dans `content/` → zéro collision de syntaxe. **3 écarts assumés** : (a) la directive `::: figure` est reportée au **lot 2** avec la refonte visuelle — la garder ici aurait forcé la réécriture des 6 tests de figure existants, or le stop-point du lot 1 l'interdit ; le `<svg>` nu rend donc exactement comme avant ; (b) le **rail collant `lg:`** passe au lot 2 (qui touche déjà la colonne de lecture) — le lot 1 livre le sommaire en carte, scroll-spy compris, ce qui couvre US-4 ; (c) `renderMarkdown` → `renderLesson` a imposé un renommage **mécanique** de 31 appels dans `markdown.test.ts` : **aucune assertion modifiée** (le diff ne contient pas une seule ligne `expect` touchée), l'invariant R-1 tient.                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 2026-07-14 | 2   | —   | **Lot 2 livré.** La figure est désormais une **planche légendée, numérotée et agrandissable** (clic + clavier) : le plafond de 22 rem — le vrai bug visuel — est levé, la figure occupe la colonne et déborde légèrement. Les **186 figures nues des 66 cours legacy** reçoivent le MÊME habillage au rendu : **aucun de leurs SVG n'a été modifié**, le stop-point est respecté (c'est le rendu qui change, pas les fichiers). **Surface de sécurité neuve** : la légende d'auteur atterrit pour la première fois dans un **attribut** (`aria-label`) — `escapeHtml` n'échappe pas les guillemets, d'où `escapeAttr` + un test de non-régression dédié ; `docs/xss-rendering-policy.md` documente les deux frontières (ALLOWED_ATTR élargi à `role`/`tabindex`/`aria-label`, tous inertes ; le dialogue d'agrandissement **re-assainit** le SVG relu du DOM). **Écarts** : (a) le **rail collant `lg:`**, reporté du lot 1, est **abandonné** — la carte de sommaire couvre entièrement US-4, alors qu'un rail imposerait de restructurer la grille de l'article (header, barre d'outils, CTA et nav vivent tous dans le `max-w-3xl`) pour un gain marginal ; le débord des figures livre la respiration attendue ; (b) `figureCount`, introduit au lot 1 et alors inutilisé, est branché sur la carte de sommaire (« 3 figures ») — plus de code mort ; (c) les 6 tests de figure ont changé d'assertions, ce qui est **légitime ici et nulle part ailleurs** : le lot 2 est propriétaire du markup des figures. |
| 2026-07-14 | 3   | —   | **Lot 3 livré.** Le résumé devient un jeu de **cartes de révision** — sans qu'aucun des 541 fichiers soit réécrit (D-6). **Corpus réel passé dans le moteur** : 541 résumés rendus **sans une seule erreur** → **3 827 cartes dans 526 résumés**, dont **127 typées** ; les 15 résumés sans aucune puce retombent proprement en prose. Idem côté cours : 541 fichiers, 2 637 blocs, 186 figures habillées. **Écarts** : (a) l'étude prévoyait un type `RenderedSummary { html, cardCount }` — `renderSummary` retourne finalement le **même type** que `renderLesson`, car un type unique garde le lecteur uniforme et `cardCount` n'aurait été affiché nulle part (= code mort, DoD §3) ; (b) **les puces indentées** (27 résumés) sont rattachées à leur **carte parente** — l'étude ne les avait pas vues, et un parseur naïf en aurait fait des cartes orphelines ; (c) une puce `- ⚠️` / `- 🏆` devient une carte **typée** (117 + 10 puces) : la promotion des callouts du lot 1 se réutilise telle quelle, gain gratuit non prévu par R-14 ; (d) l'allowlist du sanitize n'a **pas** grandi — un paquet de cartes est une **liste** (`ul`/`li`/`h3`, déjà autorisés) ; (e) les tests vivent dans leur propre spec (`summary.test.ts`) : `markdown.test.ts` n'est pas touché par ce lot.                                                                                                                                                                                                                     |

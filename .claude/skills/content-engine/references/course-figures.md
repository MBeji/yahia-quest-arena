# Content figures — the illustration doctrine for courses AND questions

> **Scope.** This file is the single doctrine for **every** figure in the catalogue — a `cours.md`
> or `resume.md` illustration **and** an `<svg>` inside a question (`prompt`, an option's `text`, or
> `explanation`). The families that require a figure, the "a figure must be TRUE" rule, the
> per-cycle vertex-naming, the young-grade colour rule: all apply to both. The only difference is
> the label — a **course** figure labels the notion's word (it teaches it), a **question** figure
> shows the scene but carries **no answer-word label** (it would leak the key). The question quality
> bar (`quality-bar.md`, § Visual) and the course quality bar (`course-quality.md`, Axis 5) both
> point here; do not duplicate the rules — extend them here.

> **Why this file exists.** On 2026-07-14 an audit of the repo found **66 illustrated courses out
> of 541** — and **zero figures in the five geometry chapters of 9ème**, the national-exam year.
> The cause was not laziness: it was a **hole in the instructions**. `course-quality.md` had four
> axes and none of them was visual, `content-cours` never once said the word _figure_, and the only
> figure rule in the whole system — «_colourful figures for the youngest_» (`style-guide.md`) — was
> about **questions** for **young grades**. So a model writing the Thalès lesson had no reason to
> draw the triangle, and didn't. The Thalès course described triangle ABC and line (MN) **in words
> only**, leaving the pupil to build the figure in their head while discovering the theorem.
>
> This file closes that hole. It is the normative reference for **axis 5 — Illustration** of
> `course-quality.md`. Étude: `FableEtudes/18-cours-vivants/ETUDE.md`.

The **SVG contract itself** (allowed primitives, forbidden elements, the white "paper" surface,
`viewBox`-driven sizing) is specified once, in `content-schema.md` § « Figures (inline SVG) ». Read
it first — everything there applies verbatim to course figures. This file adds what is specific to a
**lesson**: when a figure is _required_, how to attach it, and what to draw.

---

## 1. When a figure is REQUIRED (not optional)

A rule about **shapes, space, structure or change over time**, taught **without a drawing**, is a
non-conformity. `content:qa` warns on it; `content-audit` grades it `[MAJOR]`.

**Families where a chapter MUST carry at least one figure:**

| family                | typical chapters                                                                                                |
| --------------------- | --------------------------------------------------------------------------------------------------------------- |
| Plane geometry        | Thalès, Pythagore, triangles, quadrilatères, polygones, droites, symétries                                      |
| Circle & angles       | cercle, disque, angles inscrits / au centre, arcs                                                               |
| Coordinates & vectors | repère, coordonnées, vecteurs, translations, colinéarité                                                        |
| Solids                | cube, pavé, prisme, cylindre, cône, sphère, pyramide, géométrie dans l'espace                                   |
| Trigonometry          | rapports trigonométriques (the right triangle must be drawn)                                                    |
| Measurement of shapes | périmètre, aire, volume — the shape being measured is drawn                                                     |
| Science diagrams      | SVT (organs, cycles, food chains), physics (circuits, optics, forces)                                           |
| **Functions**         | fonctions linéaires, affines — **la droite EST la leçon** : sans elle, le cours décrit ce qu'il fallait montrer |
| Time & data           | statistiques (bâtons, circulaire, histogramme), frises chronologiques, graphiques                               |

The QA regex that mirrors this table lives in `scripts/content/qa-checks.ts` (`SPATIAL_CHAPTER`,
tested on the chapter **slug**). **Keep the two in phase**: adding a family here means adding its
keywords there.

**Two rules that hold everywhere, in every subject:**

- **Never point at a figure that does not exist.** If the prose says «ci-dessous», «الشكل المجاور»,
  «comme le montre le schéma», there must be an `<svg>` in the file. `content:qa` fails **strict**
  on this (`[error]`) — it is the single most damning defect: the pupil is sent to an image that
  isn't there.
- **One figure = one idea.** A figure that carries two notions carries neither. Split it.

---

## 2. How to attach a figure to a lesson

```markdown
::: figure Configuration « triangle » — le petit triangle AMN est une réduction de ABC
<svg viewBox="0 0 340 260">…</svg>
:::
```

- The caption is **mandatory** (`content:qa` → `[error]` without it). It says what the reader should
  **see**, not what the figure _is_: not «Un triangle», but «Le petit triangle AMN est une réduction
  du grand — c'est tout le théorème, en une image».
- The **number is automatic** («Figure 1», «الشكل 1») — never write it yourself. It follows document
  order and is emitted by the renderer.
- The caption is written in the subject's **content language** (Arabic course → Arabic caption).
- A bare `<svg>` outside a `::: figure` still renders (that is how the 186 legacy figures survive),
  but it gets no caption. **New course figures always use the directive.**

---

## 3. Drawing rules (course-specific)

Everything in `content-schema.md` § Figures applies. On top of it:

- **Dark ink on a light plate.** The renderer always draws a course figure on a light "paper" plate,
  in **both** themes (étude 18, D-4). So author with **dark literal ink** — never rely on
  `currentColor`, and never assume a dark background.
  Palette: ink `#0f172a` · accent `#0f6e56` · accent wash `#0f6e56` at `opacity="0.12"` ·
  muted `#94a3b8`.
- **`viewBox` is mandatory**, `width`/`height` are forbidden (`content:qa` → `[error]`). Author for
  a ~340×260 box; the renderer scales it to the reading column and lets the reader enlarge it.
- **Label the vertices the way the COURSE labels them.** This rule was wrong in its first version
  (2026-07-14), which demanded Latin letters everywhere; illustrating maths 6ème showed why. The
  official Tunisian curriculum names points with **Arabic letters in the primary cycle** (« الزاوية
  أ‌ب‌ج رأسُها ب », « نصف القطر ر », « القطر ق ») and switches to **Latin letters from collège on**
  (A, B, C, M, N — as maths 9ème does). A figure labelled A/B/C under a text that says أ‌ب‌ج teaches
  nothing to an 11-year-old: **the figure must be consistent with its own statement**. So: read the
  course, and use its letters.
- **Digits, units and operators stay standard everywhere** — Western digits (0–9), SI units, LTR
  equations, in **every** language and every cycle (`math-and-notation.md`). Only the _vertex naming_
  follows the cycle.
- **Never put Arabic PROSE inside the drawing.** A label is a glyph (`أ`, `ر`, `5`, `cm`), not a
  sentence. Words like « القاعدة » or « الارتفاع » belong in the caption — the drawing shows them
  (a dashed segment, a right-angle square), it does not spell them. Keep every label to one or two
  characters. (A short Arabic _annotation_ on an arithmetic/algebra figure — « أربعة عوامل » naming
  a brace — is fine; a sentence is not.)
- **Arabic labels in an SVG are a bidi minefield — three rules, all verified at the pixel across the
  5ème/6ème/7ème campaigns (2026-07):**
  1. **A phrase mixing Arabic text + numbers + units is ONE `<text>` node**, never one node per token
     at hand-set `x`. Per-token absolute positioning lays tokens in visual (LTR) order, so a reader
     reading right-to-left sees the phrase **reversed** — « 2 سا 40 د » (2 h 40) becomes « د 40 سا 2 ».
     In a single node the bidi algorithm orders it correctly, exactly like the course prose.
  2. **A pure math expression (`3x = 20 − 5 = 15`, `|−3| = 3`, `2⁴ = 16`, `3/4 × 2/3 = 6/12`) gets its
     own node with `direction="ltr" unicode-bidi="isolate"` and NO Arabic inside** — so it renders
     verbatim. Don't splice an Arabic word (« إذن ») into an isolated LTR node; split into two nodes.
  3. **`text-anchor="end"`/`"start"` on Arabic anchors the _visual-opposite_ edge** (end ≈ visual-left),
     so a side-label at a large `x` overflows off-canvas and gets clipped. Prefer `anchor="middle"`
     positioned by centre, or move the text to the **caption**. A transformation that would overflow
     horizontally (« 3 سا 75 د → 4 سا 15 د ») reads better as a **vertical** flow (arrow down + result
     below).
     A number line (`مستقيم مدرّج`) is the one axis that stays **LTR by convention** — 0 at centre,
     negatives left, values increasing rightward — even in Arabic content; its tick numbers are isolated
     LTR nodes. None of this is caught by any gate: **render the figure in a `dir="rtl"` container and
     look at it before shipping.**
- **Label legibility over strokes**: give `<text>` a halo —
  `paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round"`.
- **THE FIGURE MUST BE TRUE.** A figure that contradicts its own statement is worse than no figure.
  Before shipping, re-derive the coordinates: points announced _on_ a segment are actually on it,
  lines announced parallel actually are, a right angle is actually 90°. A wrong figure teaches a
  wrong shape and no gate can catch it. **Double-check the arithmetic.**
- **Young grades (≈ 1ère–3ème) are the HIGHEST illustration priority, not the lowest.** This was
  learned the hard way (2026-07-14): the campaign began with the exam years and left the youngest
  for last — backwards. A 6-year-old can barely read; they learn almost entirely from pictures. A
  chapter like «التموقع في الفضاء» (dessus/dessous, gauche/droite, dedans/dehors) or «الأشكال» or
  «الخطوط» taught as pure text is the most flagrant possible anomaly. And at that age the bar is
  **broader than "spatial"**: numbers (count the apples), money (draw the coins), sets (draw the
  grouping), comparison (big vs small) — **nearly every young-grade chapter earns a figure**, well
  beyond what the slug-based `SPATIAL_CHAPTER`/`GRAPHICAL_CHAPTER` heuristic can flag. So for the
  primary cycle, illustrate by **pedagogical judgement**, not only when the gate warns.
- **Young-grade figures are playful and colourful** (`style-guide.md`): concrete, recognisable
  objects (a bird above a tree, a ball in a box, an elephant beside a mouse), **dark outline +
  bright saturated fills**, not grey geometry. The colour rule and the ink rule do not conflict —
  the outline stays dark, the fills are free. Label the object with the notion's word in the
  **course** (it teaches the word); in a **question**, show the scene but carry **no answer-word
  label** (it would leak the key — R-4 of étude 19).

---

## 4. Templates (copy, then adapt — and re-check the coordinates)

### 4.1 Plane geometry — the Thalès configuration

Triangle ABC · M ∈ [AB], N ∈ [AC] · (MN) ∥ (BC). The small triangle is washed to show the reduction;
the chevrons mark the parallel.

```xml
<svg viewBox="0 0 340 260">
  <path d="M170 30 L111.5 113 L228.5 113 Z" fill="#0f6e56" opacity="0.12"/>
  <path d="M170 30 L40 215 L300 215 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
  <path d="M111.5 113 L228.5 113" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linecap="round"/>
  <g fill="none" stroke="#0f6e56" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M165 107 L172 113 L165 119"/>
    <path d="M165 209 L172 215 L165 221"/>
  </g>
  <g fill="#0f172a"><circle cx="170" cy="30" r="4"/><circle cx="40" cy="215" r="4"/><circle cx="300" cy="215" r="4"/></g>
  <g fill="#0f6e56"><circle cx="111.5" cy="113" r="4"/><circle cx="228.5" cy="113" r="4"/></g>
  <g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
    <text x="170" y="20" text-anchor="middle" fill="#0f172a">A</text>
    <text x="27" y="233" text-anchor="middle" fill="#0f172a">B</text>
    <text x="313" y="233" text-anchor="middle" fill="#0f172a">C</text>
    <text x="96" y="110" text-anchor="middle" fill="#0f6e56">M</text>
    <text x="244" y="110" text-anchor="middle" fill="#0f6e56">N</text>
  </g>
</svg>
```

**The arithmetic behind it** (redo it when you move a point): A(170,30), B(40,215), C(300,215).
With k = 0.45: M = A + k(B−A) = (111.5, 113.25) and N = A + k(C−A) = (228.5, 113.25). M and N share
the same y, and so do B and C → (MN) ∥ (BC). **True by construction, not by eye.**

### 4.2 The butterfly configuration (the second legitimate Thalès case)

Two triangles opposed at the vertex A, with (MN) ∥ (BC).

```xml
<svg viewBox="0 0 340 250">
  <path d="M60 45 L280 45 L170 130 Z" fill="#0f6e56" opacity="0.12"/>
  <path d="M170 130 L249 191 L91 191 Z" fill="#0f6e56" opacity="0.12"/>
  <g fill="none" stroke="#0f172a" stroke-width="2" stroke-linecap="round">
    <path d="M60 45 L280 45"/><path d="M60 45 L249 191"/><path d="M280 45 L91 191"/>
  </g>
  <path d="M91 191 L249 191" fill="none" stroke="#0f6e56" stroke-width="2.5" stroke-linecap="round"/>
  <g fill="#0f172a"><circle cx="60" cy="45" r="4"/><circle cx="280" cy="45" r="4"/><circle cx="170" cy="130" r="4"/></g>
  <g fill="#0f6e56"><circle cx="249" cy="191" r="4"/><circle cx="91" cy="191" r="4"/></g>
  <g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
    <text x="48" y="36" text-anchor="middle" fill="#0f172a">B</text>
    <text x="292" y="36" text-anchor="middle" fill="#0f172a">C</text>
    <text x="184" y="127" text-anchor="middle" fill="#0f172a">A</text>
    <text x="264" y="206" text-anchor="middle" fill="#0f6e56">M</text>
    <text x="76" y="206" text-anchor="middle" fill="#0f6e56">N</text>
  </g>
</svg>
```

B, A, M are collinear (M − A = 0.72·(A − B)); same for C, A, N. B and C share a y, M and N share a
y → the parallel holds.

### 4.3 Right triangle (Pythagore / trigonométrie)

The right-angle square is not decoration: it is the hypothesis.

```xml
<svg viewBox="0 0 300 220">
  <path d="M50 170 L250 170 L50 40 Z" fill="#0f6e56" opacity="0.10"/>
  <path d="M50 170 L250 170 L50 40 Z" fill="none" stroke="#0f172a" stroke-width="2" stroke-linejoin="round"/>
  <path d="M50 152 L68 152 L68 170" fill="none" stroke="#0f172a" stroke-width="2"/>
  <g fill="#0f172a"><circle cx="50" cy="170" r="4"/><circle cx="250" cy="170" r="4"/><circle cx="50" cy="40" r="4"/></g>
  <g font-size="15" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
    <text x="38" y="188" text-anchor="middle" fill="#0f172a">A</text>
    <text x="262" y="188" text-anchor="middle" fill="#0f172a">B</text>
    <text x="38" y="34" text-anchor="middle" fill="#0f172a">C</text>
    <text x="150" y="190" text-anchor="middle" fill="#0f6e56">c</text>
    <text x="34" y="110" text-anchor="middle" fill="#0f6e56">b</text>
    <text x="160" y="98" text-anchor="middle" fill="#0f6e56">a</text>
  </g>
</svg>
```

### 4.4 Circle — inscribed angle vs central angle

```xml
<svg viewBox="0 0 300 250">
  <circle cx="150" cy="125" r="95" fill="none" stroke="#0f172a" stroke-width="2"/>
  <path d="M150 125 L70 175 M150 125 L230 175" fill="none" stroke="#0f6e56" stroke-width="2"/>
  <path d="M150 30 L70 175 M150 30 L230 175" fill="none" stroke="#0f172a" stroke-width="2"/>
  <g fill="#0f172a"><circle cx="150" cy="125" r="3.5"/><circle cx="150" cy="30" r="4"/><circle cx="70" cy="175" r="4"/><circle cx="230" cy="175" r="4"/></g>
  <g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
    <text x="163" y="122" text-anchor="middle" fill="#0f172a">O</text>
    <text x="150" y="20" text-anchor="middle" fill="#0f172a">M</text>
    <text x="56" y="190" text-anchor="middle" fill="#0f172a">A</text>
    <text x="244" y="190" text-anchor="middle" fill="#0f172a">B</text>
  </g>
</svg>
```

### 4.5 Repère & vecteurs

```xml
<svg viewBox="0 0 300 240">
  <g stroke="#94a3b8" stroke-width="1">
    <path d="M30 40 V210 M70 40 V210 M110 40 V210 M150 40 V210 M190 40 V210 M230 40 V210 M270 40 V210"/>
    <path d="M30 60 H270 M30 100 H270 M30 140 H270 M30 180 H270"/>
  </g>
  <path d="M30 200 H285 M50 220 V30" fill="none" stroke="#0f172a" stroke-width="2"/>
  <path d="M279 194 L288 200 L279 206 Z M44 39 L50 28 L56 39 Z" fill="#0f172a"/>
  <path d="M90 160 L210 80" fill="none" stroke="#0f6e56" stroke-width="2.5"/>
  <path d="M201 74 L212 79 L205 89 Z" fill="#0f6e56"/>
  <g fill="#0f6e56"><circle cx="90" cy="160" r="4"/><circle cx="210" cy="80" r="4"/></g>
  <g font-size="14" font-weight="700" paint-order="stroke" stroke="#ffffff" stroke-width="4" stroke-linejoin="round">
    <text x="80" y="178" text-anchor="middle" fill="#0f6e56">A</text>
    <text x="222" y="76" text-anchor="middle" fill="#0f6e56">B</text>
    <text x="40" y="216" text-anchor="middle" fill="#0f172a">O</text>
  </g>
</svg>
```

### 4.6 Solid — cavalier perspective (cube / pavé)

```xml
<svg viewBox="0 0 280 220">
  <path d="M60 70 L190 70 L190 170 L60 170 Z" fill="#0f6e56" opacity="0.10"/>
  <path d="M60 70 L190 70 L190 170 L60 170 Z" fill="none" stroke="#0f172a" stroke-width="2"/>
  <path d="M60 70 L105 35 L235 35 L190 70" fill="none" stroke="#0f172a" stroke-width="2"/>
  <path d="M190 170 L235 135 L235 35" fill="none" stroke="#0f172a" stroke-width="2"/>
  <path d="M60 170 L105 135 L235 135 M105 135 L105 35" fill="none" stroke="#94a3b8" stroke-width="1.5" stroke-dasharray="5 4"/>
</svg>
```

The **hidden edges are dashed and grey** — that convention IS the lesson in solid geometry.

### 4.7 Timeline (history) & data graph

A frise is a line, ticks, and labels; a graph is two axes, a grid, and one curve with its endpoint
marked. Same palette, same rules: the axes are ink, the plotted object is accent.

---

## 5. What the gate enforces

`content:qa` inspects `cours.md` and `resume.md` since étude 18, lot 4 (before that, **the 541
lessons were outside every automated check**). On a lesson it fails **strict** on:

- `<svg>` without a `viewBox`;
- a lesson pointing at a figure it does not contain;
- `::: figure` without a caption; an unknown `::: type`; an unclosed directive;
- Arabic-Indic digits, an Arabic comma inside a math bracket group, a bidi-fragile radical
  (`math-and-notation.md` — these had never run on lessons, and the first pass found 46 violations
  across 22 files).

It **warns** on a spatial chapter with no figure at all (axis 5). That warning is the campaign
backlog: it currently names 28 chapters, geometry first.

## 6. Self-check before running QA

1. Every rule about a shape has its drawing next to it.
2. Every figure has a caption saying what to **see**.
3. Every figure is **true**: coordinates re-derived, parallels really parallel, right angles really 90°.
4. `viewBox` present; no `width`/`height`; no `<image>`, `<use>`, `href`, `<script>`, `<style>`.
5. Labels are Latin/Western-digit, short, and haloed; Arabic lives in the caption, not in the drawing.
6. One figure, one idea.

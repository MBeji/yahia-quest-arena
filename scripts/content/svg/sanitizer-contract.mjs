// The one contract every SVG figure must satisfy, shared by the tools in this folder.
//
// Two layers, and they are NOT the same:
//
//   1. The RUNTIME sanitizer — `src/shared/lib/figure.ts` (DOMPurify SVG profile).
//      It decides what actually reaches the DOM. Whatever it strips is lost silently:
//      the figure does not error, it renders wrong (missing shapes, black fills).
//   2. The HOUSE lint — stricter still: it keeps a figure a flat drawing of primitives,
//      so it stays themable and printable.
//
// The lint's job is to catch what the runtime loses in SILENCE — so it may only forbid
// what actually breaks. Until 2026-09-01 it also banned `defs`, `marker` and gradients
// outright, in the name of that same "flat drawing". Measured in the real
// app (dev server, real Chromium, real `renderLesson`): `<defs>`, `<marker>`,
// `<linearGradient>`, `marker-end="url(#…)"`, `fill="url(#…)"` and the `id` they hang on
// all SURVIVE, and the arrows paint. The ban was rejecting six figures that render
// perfectly — and "fixing" them would have deleted the arrows from an electrostatics
// lesson. Referenced indirection is therefore allowed, under the three rules in
// `lintSvg` that make it safe (the reference resolves, nothing is dead weight, the id
// cannot be clobbered).
//
// What stays forbidden is what the sanitizer really destroys: `<use>`/`href` (the
// reference is stripped, the payload stays behind as invisible ballast), `<image>`,
// `<foreignObject>`, `<script>`, `<style>` — plus `clipPath`/`mask`/`pattern`/`filter`/
// `symbol`, indirection this house has no use for.
//
// A figure imported from the web (Openclipart, SVG Repo, OpenMoji, Wikimedia) almost
// never satisfies either one as-is — it leans on `<style>` blocks, `<use>` and gradients.
// `import.mjs` is what turns such a file into something this contract accepts.
//
// Keep DOMPURIFY_CONFIG in sync with `src/shared/lib/figure.ts`: the test
// `__tests__/sanitizer-contract.test.mjs` fails the gate if the two drift apart.

/** Elements a figure may contain. Anything else is dropped by the lint. */
export const ALLOWED = new Set([
  "svg",
  "title",
  "g",
  "line",
  "path",
  "polygon",
  "polyline",
  "rect",
  "circle",
  "ellipse",
  "text",
  "tspan",
]);

/**
 * Elements that paint ONLY through a reference, and whose reference the runtime sanitizer
 * keeps (`marker-end`, `fill="url(#…)"`). Allowed in a figure — but every one of them is
 * conditional: see the `url(#…)` rules in `lintSvg`. Deliberately NOT in `ALLOWED`, which
 * is the flat-primitive whitelist `import.mjs` normalizes imported clipart down to.
 */
export const REFERENCED = new Set(["defs", "marker", "linearGradient", "radialGradient", "stop"]);

/** Elements/attributes that must never survive to the content — house rule (see header). */
export const FORBIDDEN = /<(image|use|foreignObject|script|style)\b|(?:xlink:)?href\s*=/i;

/** Arabic-Indic / Persian digits: figures use Western digits everywhere (math-and-notation). */
export const INDIC = /[٠-٩۰-۹]/;

/**
 * Containers whose children are NEVER painted where they sit — they only ever appear
 * through a reference (`clip-path="url(#…)"`, `<use href>`, a gradient fill).
 *
 * The distinction is load-bearing for `import.mjs`: unwrapping one of these instead of
 * deleting it promotes an invisible mask into a visible black shape on top of the drawing.
 * A `<clipPath>` does not have to live inside `<defs>` for that to happen.
 *
 * This is `import.mjs`'s list, not the lint's: a clipart imported from the web gets
 * FLATTENED (gradients resolved to a solid colour, containers dropped whole), whatever
 * the lint would tolerate in a hand-drawn figure. Hence the overlap with `REFERENCED`.
 */
export const NON_RENDERING = [
  "defs",
  "clipPath",
  "mask",
  "marker",
  "symbol",
  "pattern",
  "linearGradient",
  "radialGradient",
  "filter",
  "metadata",
  "desc",
  "style",
  "script",
];

/**
 * Mirror of the DOMPurify options in `src/shared/lib/figure.ts` → `sanitizeSvg`.
 * Used by `import.mjs` to replay the runtime sanitizer in-browser and prove that
 * normalization survives it untouched.
 */
export const DOMPURIFY_CONFIG = {
  USE_PROFILES: { svg: true, svgFilters: true },
  FORBID_TAGS: ["foreignObject", "a", "image", "use", "script", "style"],
  FORBID_ATTR: ["href", "xlink:href"],
};

/** An `id`/`url(#…)` as they are written in a figure. */
const URL_REF = /url\(#([^)"'\s]+)\)/g;
const ID_ATTR = /\bid="([^"]*)"/g;

/**
 * The three ways `url(#…)` indirection breaks, and they are all SILENT — no error, no
 * warning, just a figure that draws less than the author wrote. Nothing else in the
 * chain will say a word, which is why they are checked here.
 *
 * 1. The reference resolves to nothing (a typo): the arrow simply does not appear.
 * 2. Nothing references the definition: it is never painted, it only travels — in every
 *    content row, forever. This is the `<use href>` trap the sanitizer creates, where the
 *    reference is stripped and the payload stays (see `__tests__`, "clipart brut du net").
 * 3. The `id` collides with a property of `document`. DOMPurify's anti-DOM-clobbering
 *    guard then DROPS the id — measured: `id="body"` is removed, `id="ar"` is not — and
 *    the surviving `url(#body)` points at nothing. The colliding set is not ours to
 *    enumerate: it is whatever the RUNNING page's `document` exposes, so it grows with
 *    each Chromium release. A hyphen is the exact and permanent answer instead — a JS
 *    property name reached by dot access cannot contain one, so a hyphenated id can
 *    never collide, in any browser, ever.
 */
function lintReferences(svg, where) {
  const issues = [];
  const refs = new Set([...svg.matchAll(URL_REF)].map((m) => m[1]));
  const ids = new Set([...svg.matchAll(ID_ATTR)].map((m) => m[1]));

  for (const ref of refs) {
    if (!ids.has(ref)) issues.push(`${where}: url(#${ref}) points at no id in this figure`);
    else if (!ref.includes("-"))
      issues.push(
        `${where}: id="${ref}" needs a hyphen — a bare word can collide with a document ` +
          `property, and the sanitizer then drops the id and kills the reference`,
      );
  }

  // Une définition que personne n'appelle ne dessine rien : elle ne fait que voyager.
  for (const [, tag, attrs] of svg.matchAll(
    /<(marker|linearGradient|radialGradient)\b([^>]*)>/gi,
  )) {
    const id = new RegExp(ID_ATTR.source).exec(attrs)?.[1];
    if (!id || !refs.has(id))
      issues.push(`${where}: <${tag}> that nothing references — it is never painted`);
  }
  for (const block of svg.match(/<defs\b[\s\S]*?<\/defs>/gi) || [])
    if (![...block.matchAll(ID_ATTR)].some((m) => refs.has(m[1])))
      issues.push(`${where}: <defs> holds nothing this figure references — dead weight`);

  // `<stop>` n'existe que dans un dégradé ; seul, il ne veut rien dire.
  if (/<stop\b/i.test(svg) && !/<(linear|radial)Gradient\b/i.test(svg))
    issues.push(`${where}: <stop> outside any gradient`);

  return issues;
}

/**
 * Structural lint of a single `<svg>…</svg>` block. Returns a list of human-readable
 * issues (empty = clean). This is the single implementation behind
 * `check-figures.mjs` (corpus-wide) and `import.mjs` (one imported file).
 */
export function lintSvg(svg, where = "figure") {
  const issues = [];

  const opens = (svg.match(/<svg[\s>]/g) || []).length;
  const closes = (svg.match(/<\/svg>/g) || []).length;
  if (opens !== 1 || closes !== 1)
    issues.push(`${where}: malformed <svg> (${opens} open / ${closes} close)`);

  const openTag = svg.match(/<svg[^>]*>/i)?.[0] || "";
  if (!/viewBox/i.test(openTag) && !(/\bwidth=/i.test(openTag) && /\bheight=/i.test(openTag)))
    issues.push(`${where}: <svg> has no viewBox (nor width+height) — will not scale`);

  if (FORBIDDEN.test(svg))
    issues.push(`${where}: forbidden element/attr (image/use/foreignObject/script/style/href)`);

  for (const tag of svg.match(/<\/?([a-zA-Z][\w:-]*)/g) || []) {
    const name = tag.replace(/[</]/g, "");
    if (!ALLOWED.has(name) && !REFERENCED.has(name))
      issues.push(`${where}: disallowed element <${name}>`);
  }

  issues.push(...lintReferences(svg, where));

  if (INDIC.test(svg))
    issues.push(`${where}: Arabic-Indic/Persian digits in figure — use Western digits (0-9)`);

  return issues;
}

/** Split a text/JSON field into its `<svg>` blocks (the renderer shows only the first). */
export const SVG_BLOCKS = /<svg[\s\S]*?<\/svg>/gi;

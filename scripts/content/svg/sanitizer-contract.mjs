// The one contract every SVG figure must satisfy, shared by the tools in this folder.
//
// Two layers, and they are NOT the same:
//
//   1. The RUNTIME sanitizer — `src/shared/lib/figure.ts` (DOMPurify SVG profile).
//      It decides what actually reaches the DOM. Whatever it strips is lost silently:
//      the figure does not error, it renders wrong (missing shapes, black fills).
//   2. The HOUSE lint — stricter still. It also rejects `defs`/`marker` and gradients,
//      which the runtime sanitizer would tolerate, so that a figure stays a flat,
//      themable, printable drawing with no indirection.
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

/** Elements/attributes that must never survive to the content — house rule (see header). */
export const FORBIDDEN =
  /<(image|use|foreignObject|script|style|marker|defs)\b|(?:xlink:)?href\s*=/i;

/** Arabic-Indic / Persian digits: figures use Western digits everywhere (math-and-notation). */
export const INDIC = /[٠-٩۰-۹]/;

/**
 * Containers whose children are NEVER painted where they sit — they only ever appear
 * through a reference (`clip-path="url(#…)"`, `<use href>`, a gradient fill).
 *
 * The distinction is load-bearing for `import.mjs`: unwrapping one of these instead of
 * deleting it promotes an invisible mask into a visible black shape on top of the drawing.
 * A `<clipPath>` does not have to live inside `<defs>` for that to happen.
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
    issues.push(
      `${where}: forbidden element/attr (image/use/foreignObject/script/style/marker/defs/href)`,
    );

  for (const tag of svg.match(/<\/?([a-zA-Z][\w:-]*)/g) || []) {
    const name = tag.replace(/[</]/g, "");
    if (!ALLOWED.has(name)) issues.push(`${where}: disallowed element <${name}>`);
  }

  if (INDIC.test(svg))
    issues.push(`${where}: Arabic-Indic/Persian digits in figure — use Western digits (0-9)`);

  return issues;
}

/** Split a text/JSON field into its `<svg>` blocks (the renderer shows only the first). */
export const SVG_BLOCKS = /<svg[\s\S]*?<\/svg>/gi;

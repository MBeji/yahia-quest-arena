import DOMPurify from "dompurify";

/**
 * Inline-figure support for QCM content.
 *
 * Content question fields (`prompt`, an option's `text`, `explanation`) are plain
 * strings, but a field MAY embed a single `<svg>…</svg>` block to carry a figure
 * (geometry, IQ matrices, shape sequences). At render time we split the field into
 * its text part and its SVG part; the SVG is sanitized through DOMPurify's SVG
 * profile before it ever reaches the DOM. One figure per field.
 *
 * This is a vetted sanitization boundary — see `docs/xss-rendering-policy.md`.
 * The regression tests in `__tests__/figure.test.ts` assert that scripts, event
 * handlers, `<foreignObject>` and external references are stripped.
 */

const SVG_BLOCK = /<svg[\s\S]*?<\/svg>/i;

/** URL schemes that can carry executable content (not just `javascript:` —
 *  `data:` and `vbscript:` are equally capable per CWE-20/CWE-184). */
const DANGEROUS_URL_SCHEME = /(?:javascript|data|vbscript):/gi;

/** Split a content field into its plain text and an optional embedded SVG block. */
export function extractFigure(raw: string): { text: string; svg: string | null } {
  if (!raw) return { text: "", svg: null };
  const match = raw.match(SVG_BLOCK);
  if (!match || match.index === undefined) return { text: raw, svg: null };
  const svg = match[0];
  const text = (raw.slice(0, match.index) + raw.slice(match.index + svg.length)).trim();
  return { text, svg };
}

/** True if the field carries an embedded SVG figure. */
export function hasFigure(raw: string): boolean {
  return SVG_BLOCK.test(raw);
}

/**
 * Sanitize an author-supplied SVG to a safe subset: drawing primitives only.
 * Strips `<script>`/`<style>`, event handlers (DOMPurify removes `on*`),
 * `<foreignObject>` (HTML injection), and any external reference
 * (`href`/`xlink:href`, `<image>`, `<use>`) to avoid SSRF/exfiltration.
 */
export function sanitizeSvg(svg: string): string {
  // Fail closed: DOMPurify is a no-op when no DOM is available (e.g. an SSR
  // runtime without a global `window` — jsdom is a dev-only dependency). Rather
  // than let author SVG through unsanitized, drop the figure entirely when
  // sanitization is unavailable — a missing figure is safe, raw markup is not.
  if (!DOMPurify.isSupported) return "";
  const cleaned = DOMPurify.sanitize(svg, {
    USE_PROFILES: { svg: true, svgFilters: true },
    FORBID_TAGS: ["foreignObject", "a", "image", "use", "script", "style"],
    FORBID_ATTR: ["href", "xlink:href"],
  });
  // Defense-in-depth: neutralize any residual dangerous scheme DOMPurify may leave
  // inside non-URI attribute values (e.g. fill="url(javascript:…)").
  return cleaned.replace(DANGEROUS_URL_SCHEME, "");
}

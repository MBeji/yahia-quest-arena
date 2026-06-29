import { createElement, type ElementType } from "react";
import { extractFigure, sanitizeSvg } from "@/shared/lib/figure";
import { isRtlText } from "@/shared/lib/utils";
import { isolateLtrRuns } from "@/shared/lib/bidi";

/**
 * "Paper" surface every figure is drawn on. Two problems are solved here:
 *
 *  1. Contrast — authored SVGs use dark ink (`#1f2937`, `#222`, `currentColor`,
 *     …) assuming a light, worksheet-like background. The app's default theme is
 *     dark, so a bare figure is dark-on-dark and invisible. We always draw on a
 *     white surface with dark default text, visible on every theme.
 *  2. Size — the figures carry only a `viewBox` (no width/height), so a browser
 *     gives them the default 300×150 replaced size (or collapses them), not the
 *     viewBox ratio. We give the figure a DEFINITE width and let the SVG fill it
 *     (`w-full h-auto`), so the viewBox ratio drives a correct, visible size.
 */
const FIGURE_SURFACE = "rounded-xl bg-white text-slate-900 ring-1 ring-black/10";

/**
 * Renders a sanitized inline SVG figure. The markup is passed through
 * `sanitizeSvg` (DOMPurify SVG profile) so no script/event/foreignObject/external
 * reference can reach the DOM. See `docs/xss-rendering-policy.md`.
 */
export function SvgFigure({ markup, className }: { markup: string; className?: string }) {
  return <span className={className} dangerouslySetInnerHTML={{ __html: sanitizeSvg(markup) }} />;
}

/**
 * A content field (prompt / explanation) that may embed a single `<svg>` figure.
 * Renders the text in the element given by `as`, then the figure below it.
 */
export function RichField({
  raw,
  as: As = "div",
  className,
}: {
  raw: string;
  as?: ElementType;
  className?: string;
}) {
  const { text, svg } = extractFigure(raw);
  return (
    <>
      {text
        ? createElement(
            As,
            { className, dir: isRtlText(text) ? "rtl" : undefined },
            isolateLtrRuns(text),
          )
        : null}
      {svg ? (
        <div className="my-3 flex justify-center">
          <SvgFigure
            markup={svg}
            className={`block w-64 max-w-full p-3 shadow-sm ${FIGURE_SURFACE} [&>svg]:block [&>svg]:h-auto [&>svg]:w-full`}
          />
        </div>
      ) : null}
    </>
  );
}

/** An answer option whose `text` may be a label, an SVG figure, or both. */
export function OptionContent({ raw }: { raw: string }) {
  const { text, svg } = extractFigure(raw);
  return (
    <>
      {text ? <span>{isolateLtrRuns(text)}</span> : null}
      {svg ? (
        <SvgFigure
          markup={svg}
          className={`inline-flex items-center justify-center p-1.5 ${FIGURE_SURFACE} [&>svg]:block [&>svg]:h-16 [&>svg]:w-16`}
        />
      ) : null}
    </>
  );
}

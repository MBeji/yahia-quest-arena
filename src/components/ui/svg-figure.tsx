import { createElement, type ElementType } from "react";
import { extractFigure, sanitizeSvg } from "@/shared/lib/figure";
import { isRtlText } from "@/shared/lib/utils";

/**
 * "Paper" surface every figure is drawn on. Authored SVGs use dark ink
 * (`#1f2937`, `#222`, `currentColor`, …) on the assumption of a light
 * background — like a printed worksheet. The app's default theme is dark, so
 * without this a figure would be dark-on-dark and effectively invisible. We
 * always render figures on a white surface with dark default text, so both the
 * hardcoded-dark and `currentColor` strokes stay visible on every theme.
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
        ? createElement(As, { className, dir: isRtlText(text) ? "rtl" : undefined }, text)
        : null}
      {svg ? (
        <div className="my-3 flex justify-center">
          <SvgFigure
            markup={svg}
            className={`block p-3 shadow-sm ${FIGURE_SURFACE} [&>svg]:h-auto [&>svg]:max-h-64 [&>svg]:max-w-full`}
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
      {text ? <span>{text}</span> : null}
      {svg ? (
        <SvgFigure
          markup={svg}
          className={`inline-flex items-center p-1.5 ${FIGURE_SURFACE} [&>svg]:h-16 [&>svg]:w-16`}
        />
      ) : null}
    </>
  );
}

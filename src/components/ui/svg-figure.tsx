import { createElement, Fragment, type ElementType, type ReactNode } from "react";
import { extractFigure, sanitizeSvg } from "@/shared/lib/figure";
import { isRtlText } from "@/shared/lib/utils";
import { isDisplayEquation, splitMathRuns } from "@/shared/lib/bidi";

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
 * Rend le texte d'un champ de contenu en gardant chaque formule d'un seul
 * tenant : un run mathématique devient un `.math-run` — isolé gauche-à-droite,
 * et insécable (`.math-run-tight`) tant qu'il tient sur une ligne
 * (`src/styles.css`). Sans cela le navigateur coupe une équation un peu longue
 * en son milieu, et l'algorithme bidi réordonne CHAQUE ligne pour elle-même :
 * l'élève lit deux moitiés de formule mêlées à la prose arabe (défaut signalé
 * sur `(x − 4)(x + 2) = 0`).
 *
 * Le découpage est celui de `isolateLtrRuns` — mêmes runs, même signal — mais
 * porté par un élément au lieu d'isolats Unicode, parce qu'un caractère ne peut
 * pas empêcher un retour à la ligne. La prose ne reçoit aucun élément : un
 * champ sans formule rend exactement le même DOM qu'avant.
 */
function renderRuns(text: string): ReactNode {
  const runs = splitMathRuns(text);
  if (runs.length === 1 && !runs[0].math) return text;
  return runs.map((run, index) =>
    run.math ? (
      <span key={index} className={run.nowrap ? "math-run math-run-tight" : "math-run"}>
        {run.text}
      </span>
    ) : (
      <Fragment key={index}>{run.text}</Fragment>
    ),
  );
}

/**
 * Rend un champ ligne à ligne. Une ligne qui n'est QUE de la notation devient
 * un bloc `.math-equation` : l'équation est posée seule, centrée, hors du texte
 * de la question — la forme attendue d'un énoncé qui présente une formule.
 * Les autres lignes gardent leur prose et leurs runs insécables.
 *
 * Le saut de ligne authored était jusqu'ici perdu (un nœud de texte React rend
 * `\n` comme une espace), alors que 1 139 énoncés du corpus s'en servent déjà
 * pour séparer un support de la question posée. Les lignes sont des `<span>` en
 * `display:block` — `RichField` est parfois monté `as="p"`, où un `<div>` ou un
 * `<p>` imbriqué serait du HTML invalide.
 */
function renderLines(text: string): ReactNode {
  const lines = text.split("\n").filter((line) => line.trim() !== "");
  if (lines.length <= 1) return renderRuns(text);
  return lines.map((line, index) =>
    isDisplayEquation(line) ? (
      <span key={index} className="math-equation">
        {line.trim()}
      </span>
    ) : (
      <span key={index} className="block">
        {renderRuns(line)}
      </span>
    ),
  );
}

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
            renderLines(text),
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
      {text ? <span>{renderRuns(text)}</span> : null}
      {svg ? (
        <SvgFigure
          markup={svg}
          className={`inline-flex items-center justify-center p-1.5 ${FIGURE_SURFACE} [&>svg]:block [&>svg]:h-16 [&>svg]:w-16`}
        />
      ) : null}
    </>
  );
}

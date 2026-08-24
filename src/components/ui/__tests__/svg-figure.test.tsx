import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";

import { RichField, OptionContent, SvgFigure } from "@/components/ui/svg-figure";

// Authored figures use dark ink (#1f2937, currentColor, …) and the default
// theme is dark, so a figure rendered straight onto the card would be
// dark-on-dark and invisible. Every figure must sit on a light "paper" surface
// with dark default text. These tests pin that contract.
const TRIANGLE =
  '<svg viewBox="0 0 10 10"><polygon points="1,9 1,1 9,9" fill="none" stroke="currentColor"/></svg>';
const DARK_INK =
  '<svg viewBox="0 0 10 10"><rect x="1" y="1" width="8" height="8" fill="none" stroke="#1f2937"/></svg>';

const surface = (el: HTMLElement | null) => el?.className ?? "";

describe("figure rendering — visible on a light surface", () => {
  it("RichField draws the prompt figure on a white surface with dark text", () => {
    const { container } = render(<RichField raw={`ما نوع هذا الشكل؟ ${DARK_INK}`} />);
    const figure = container.querySelector("svg")?.parentElement ?? null;
    expect(surface(figure)).toMatch(/bg-white/);
    expect(surface(figure)).toMatch(/text-slate-900/);
    expect(container.querySelector("svg")).not.toBeNull();
  });

  it("RichField gives the figure a definite width so a viewBox-only SVG can't collapse", () => {
    const { container } = render(<RichField raw={DARK_INK} />);
    const figure = container.querySelector("svg")?.parentElement ?? null;
    // a definite container width + the svg filling it (w-full/h-auto) drives the
    // viewBox ratio to a real, visible size instead of the 300x150 default.
    expect(surface(figure)).toMatch(/\bw-64\b/);
    expect(surface(figure)).toMatch(/\[&>svg\]:w-full/);
    expect(surface(figure)).toMatch(/\[&>svg\]:h-auto/);
  });

  it("OptionContent draws an option figure on the same light surface", () => {
    const { container } = render(<OptionContent raw={TRIANGLE} />);
    const figure = container.querySelector("svg")?.parentElement ?? null;
    expect(surface(figure)).toMatch(/bg-white/);
    expect(surface(figure)).toMatch(/text-slate-900/);
  });

  it("SvgFigure keeps the sanitized drawing primitives", () => {
    const { container } = render(<SvgFigure markup={DARK_INK} />);
    expect(container.querySelector("rect")).not.toBeNull();
  });
});

// ---------------------------------------------------------------------------
// Une équation ne se coupe jamais en deux lignes, et ne se mêle pas au texte.
//
// L'isolat Unicode posé par `isolateLtrRuns` corrige l'ORDRE des glyphes, pas le
// RETOUR À LA LIGNE. Un énoncé arabe un peu long voyait donc son équation scindée
// entre deux lignes, chacune réordonnée pour elle-même — la capture signalée sur
// `(x − 4)(x + 2) = 0`. Seul le rendu peut l'empêcher : ces tests l'épinglent.
// ---------------------------------------------------------------------------
const PROMPT_AR = "بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة (x − 4)(x + 2) = 0 ؟";

describe("rendu des formules — insécables et hors du texte", () => {
  it("pose l'équation d'un énoncé arabe dans un seul élément insécable", () => {
    const { container } = render(<RichField raw={PROMPT_AR} />);
    const runs = container.querySelectorAll(".math-run");
    expect(runs).toHaveLength(1);
    expect(runs[0].textContent).toContain("(x − 4)(x + 2) = 0");
    expect(runs[0].className).toContain("math-run-tight");
  });

  it("rend le texte de l'énoncé sans y glisser de caractère invisible", () => {
    const { container } = render(<RichField raw={PROMPT_AR} />);
    // L'isolement passe désormais par un élément, plus par des LRI/PDI insérés
    // dans le texte : ce que lit un lecteur d'écran est l'énoncé, exactement.
    expect(container.textContent).toBe(PROMPT_AR);
    expect(container.textContent).not.toMatch(/[⁦-⁩]/);
  });

  it("laisse la prose sans formule exactement telle quelle", () => {
    const { container } = render(<RichField raw="ما ينصّ عليه مبدأ الجداء المعدوم؟" />);
    expect(container.querySelectorAll(".math-run")).toHaveLength(0);
    expect(container.textContent).toBe("ما ينصّ عليه مبدأ الجداء المعدوم؟");
  });

  it("pose une ligne qui n'est QUE la formule en bloc centré, hors de la question", () => {
    const { container } = render(
      <RichField
        raw={"بتطبيق مبدأ الجداء المعدوم، ما حلول المعادلة التالية؟\n(x − 4)(x + 2) = 0"}
      />,
    );
    const equation = container.querySelector(".math-equation");
    expect(equation?.textContent).toBe("(x − 4)(x + 2) = 0");
    // La prose garde sa propre ligne — le saut authored n'est plus aplati en espace.
    expect(container.querySelectorAll(".block")).toHaveLength(1);
  });

  it("garde chaque ligne authored sur sa ligne (support de lecture puis question)", () => {
    const { container } = render(
      <RichField raw={'Read: "Tom is from London."\nWhere is Tom from?'} as="p" />,
    );
    const lines = container.querySelectorAll("p > span.block");
    expect(lines).toHaveLength(2);
    expect(lines[1].textContent).toBe("Where is Tom from?");
    // `as="p"` : les lignes sont des <span> en display:block, jamais des <p> imbriqués.
    expect(container.querySelector("p p")).toBeNull();
  });

  it("garde aussi la formule d'un énoncé latin d'un seul tenant", () => {
    const { container } = render(
      <RichField raw="Quelle est la solution de (x − 4)(x + 2) = 0 ?" />,
    );
    const runs = container.querySelectorAll(".math-run");
    expect(runs).toHaveLength(1);
    expect(runs[0].textContent?.trim()).toBe("(x − 4)(x + 2) = 0");
  });

  it("n'exige pas l'insécable d'une chaîne de calcul trop longue pour une ligne", () => {
    const { container } = render(
      <RichField raw="الحساب p(Y = 1) = 4 × 0,368 × 0,632³ ≈ 4 × 0,368 ≈ 0,372 إذن" />,
    );
    const runs = container.querySelectorAll(".math-run");
    expect(runs).toHaveLength(1);
    expect(runs[0].className).not.toContain("math-run-tight");
  });

  it("isole aussi la formule d'une option de réponse", () => {
    const { container } = render(<OptionContent raw="x = −4 و x = 2" />);
    expect(container.querySelectorAll(".math-run").length).toBeGreaterThan(0);
    expect(container.textContent).toBe("x = −4 و x = 2");
  });
});

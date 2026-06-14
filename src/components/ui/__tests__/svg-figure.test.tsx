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

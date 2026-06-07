import { describe, it, expect } from "vitest";
import { extractFigure, hasFigure, sanitizeSvg } from "../figure";

describe("extractFigure", () => {
  it("returns the raw text when there is no svg", () => {
    expect(extractFigure("Quelle figure complète la suite ?")).toEqual({
      text: "Quelle figure complète la suite ?",
      svg: null,
    });
  });

  it("handles empty input", () => {
    expect(extractFigure("")).toEqual({ text: "", svg: null });
  });

  it("splits an embedded svg from the surrounding text and trims", () => {
    const svg = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4" /></svg>';
    const { text, svg: out } = extractFigure(`Complète la série : ${svg}`);
    expect(out).toBe(svg);
    expect(text).toBe("Complète la série :");
  });

  it("returns empty text for a figure-only field", () => {
    const svg = "<svg><rect width='4' height='4' /></svg>";
    expect(extractFigure(svg)).toEqual({ text: "", svg });
  });
});

describe("hasFigure", () => {
  it("detects (or not) an svg block", () => {
    expect(hasFigure("x <svg></svg> y")).toBe(true);
    expect(hasFigure("no figure here")).toBe(false);
  });
});

describe("sanitizeSvg (security boundary)", () => {
  it("keeps safe drawing primitives", () => {
    const out = sanitizeSvg(
      '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4" fill="red" /></svg>',
    );
    expect(out.toLowerCase()).toContain("<svg");
    expect(out).toContain("<circle");
  });

  it("strips <script>", () => {
    const out = sanitizeSvg("<svg><script>alert(1)</script><rect /></svg>");
    expect(out.toLowerCase()).not.toContain("<script");
    expect(out).not.toContain("alert");
  });

  it("strips event handlers", () => {
    const out = sanitizeSvg('<svg><rect onload="alert(1)" onclick="x()" /></svg>');
    expect(out.toLowerCase()).not.toContain("onload");
    expect(out.toLowerCase()).not.toContain("onclick");
  });

  it("strips <foreignObject> (HTML injection vector)", () => {
    const out = sanitizeSvg("<svg><foreignObject><div>hi</div></foreignObject><rect /></svg>");
    expect(out.toLowerCase()).not.toContain("foreignobject");
  });

  it("strips external references (a/image/use + href/xlink:href)", () => {
    const out = sanitizeSvg(
      '<svg><a href="https://evil.test">x</a><image href="https://evil.test/x.png" /><use href="#y" /></svg>',
    );
    expect(out.toLowerCase()).not.toContain("href");
    expect(out.toLowerCase()).not.toContain("<image");
    expect(out.toLowerCase()).not.toContain("<use");
    expect(out).not.toContain("evil.test");
  });

  it("strips javascript: payloads", () => {
    const out = sanitizeSvg('<svg><rect fill="url(javascript:alert(1))" /></svg>');
    expect(out.toLowerCase()).not.toContain("javascript:");
  });
});

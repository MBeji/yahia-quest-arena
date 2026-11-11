import { render, screen } from "@testing-library/react";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, it, expect } from "vitest";
import React from "react";

import { CrownMark } from "../brand-mark";

/**
 * La marque, enfin portée par l'interface.
 *
 * L'application dessinait une `Sparkles` de lucide dans son en-tête, sur l'écran
 * d'authentification et dans l'avatar du héros — alors que le favicon, les trois
 * icônes PWA et la page hors-ligne montraient tous une COURONNE dorée. Le logo de
 * l'onglet ne ressemblait pas à l'en-tête qu'il ouvrait.
 *
 * Ce fichier tient les deux invariants qui empêchent cet écart de revenir :
 *
 *   1. ⭐ le tracé du composant est CELUI du favicon, primitive par primitive —
 *      une seule couronne dans le produit, pas deux silhouettes à faire diverger ;
 *   2. le `viewBox` reste la boîte englobante EXACTE de ce tracé : il est serré à
 *      dessein (l'original porte les marges d'une icône d'application), et le
 *      resserrer à la main est précisément le geste qui rogne le dessin en silence.
 */

/** Les primitives géométriques d'un SVG, sous une forme comparable des deux côtés. */
type Shapes = { paths: string[]; rects: string[]; circles: string[] };

/** Normalise les espaces d'un attribut `d` : le JSX et le fichier peuvent les poser autrement. */
const tidy = (d: string) => d.trim().replace(/\s+/g, " ");

function shapesOfSvgSource(svg: string): Shapes {
  const all = (re: RegExp) => [...svg.matchAll(re)].map((m) => m[1]);
  return {
    paths: all(/<path[^>]*\sd="([^"]+)"/g).map(tidy),
    rects: all(/<rect([^>]*)>/g).map((attrs) =>
      ["x", "y", "width", "height", "rx"]
        .map((k) => `${k}=${new RegExp(`\\b${k}="([^"]+)"`).exec(attrs)?.[1] ?? ""}`)
        .join(" "),
    ),
    circles: all(/<circle([^>]*)>/g).map((attrs) =>
      ["cx", "cy", "r"]
        .map((k) => `${k}=${new RegExp(`\\b${k}="([^"]+)"`).exec(attrs)?.[1] ?? ""}`)
        .join(" "),
    ),
  };
}

function renderCrown(): SVGSVGElement {
  render(<CrownMark />);
  return screen.getByTestId("brand-crown") as unknown as SVGSVGElement;
}

/** Boîte englobante calculée à la main : jsdom ne sait pas faire `getBBox()`. */
function boundingBox(svg: SVGSVGElement) {
  const xs: number[] = [];
  const ys: number[] = [];
  const push = (x: number, y: number) => {
    xs.push(x);
    ys.push(y);
  };
  const num = (el: Element, name: string) => Number(el.getAttribute(name));

  for (const p of svg.querySelectorAll("path")) {
    const coords = (p.getAttribute("d") ?? "").match(/-?\d+(?:\.\d+)?/g) ?? [];
    for (let i = 0; i + 1 < coords.length; i += 2) push(Number(coords[i]), Number(coords[i + 1]));
  }
  for (const r of svg.querySelectorAll("rect")) {
    push(num(r, "x"), num(r, "y"));
    push(num(r, "x") + num(r, "width"), num(r, "y") + num(r, "height"));
  }
  for (const c of svg.querySelectorAll("circle")) {
    push(num(c, "cx") - num(c, "r"), num(c, "cy") - num(c, "r"));
    push(num(c, "cx") + num(c, "r"), num(c, "cy") + num(c, "r"));
  }
  return {
    minX: Math.min(...xs),
    minY: Math.min(...ys),
    maxX: Math.max(...xs),
    maxY: Math.max(...ys),
  };
}

describe("CrownMark — la couronne de la marque", () => {
  it("⭐ dessine EXACTEMENT la couronne du favicon, pas une seconde silhouette", () => {
    const favicon = readFileSync(join(process.cwd(), "public/favicon.svg"), "utf8");
    const expected = shapesOfSvgSource(favicon);
    const actual = shapesOfSvgSource(renderCrown().outerHTML);

    // Le favicon pose aussi la plaque de fond de l'icône (`<rect width="512" …>`),
    // qui n'a pas de sens dans l'interface : on compare la couronne seule.
    const crownRects = expected.rects.filter((r) => !r.startsWith("x= "));

    expect(actual.paths).toEqual(expected.paths);
    expect(actual.rects).toEqual(crownRects);
    expect(actual.circles).toEqual(expected.circles);
    expect(actual.paths.length).toBeGreaterThan(0);
  });

  it("⭐ garde un `viewBox` collé à la boîte englobante du tracé", () => {
    const svg = renderCrown();
    const [x, y, w, h] = (svg.getAttribute("viewBox") ?? "").split(/\s+/).map(Number);
    const box = boundingBox(svg);

    expect({ x, y, w, h }).toEqual({
      x: box.minX,
      y: box.minY,
      w: box.maxX - box.minX,
      h: box.maxY - box.minY,
    });
  });

  it("prend son encre de l'appelant plutôt que d'une couleur codée en dur", () => {
    render(<CrownMark className="h-5 w-5 text-primary-foreground" />);
    const svg = screen.getByTestId("brand-crown");
    expect(svg.getAttribute("fill")).toBe("currentColor");
    expect(svg.getAttribute("class")).toBe("h-5 w-5 text-primary-foreground");
    // Aucune teinte littérale : le thème clair repeint la marque comme le reste.
    expect(svg.outerHTML).not.toMatch(/#[0-9a-f]{3,8}\b/i);
  });

  it("reste décorative — le nom de la marque est déjà lu à côté", () => {
    const svg = renderCrown();
    expect(svg.getAttribute("aria-hidden")).toBe("true");
    expect(svg.getAttribute("focusable")).toBe("false");
  });
});

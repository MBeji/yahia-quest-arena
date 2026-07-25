import { describe, it, expect } from "vitest";
import { readFileSync } from "node:fs";
import { lintSvg, ALLOWED, DOMPURIFY_CONFIG, NON_RENDERING } from "../sanitizer-contract.mjs";
import { sanitizeSvg } from "@/shared/lib/figure";

/**
 * These tests guard the contract that `import.mjs` exists to satisfy.
 *
 * They deliberately do NOT launch Chromium: the normalizer is dev-time tooling, and the
 * gate has no browser. What the gate must protect is the CONTRACT — that a figure produced
 * by the tool still survives the runtime sanitizer, and that the sanitizer's own rules
 * have not drifted away from the mirror this folder relies on.
 */

/** Real output of `import.mjs` on an Openclipart-shaped source (CSS block + <use> + gradient). */
const NORMALIZED_FIGURE =
  '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 160"><title>Une vache dans un pré</title>' +
  '<rect x="0" y="0" width="240" height="160" fill="#79d2fb"/>' +
  '<ellipse cx="120" cy="80" rx="62" ry="38" fill="#f5f5f4" stroke="#1f2937" stroke-width="3"/>' +
  '<ellipse cx="100" cy="70" rx="16" ry="11" fill="#292524"/>' +
  '<circle cx="184" cy="60" r="24" fill="#f5f5f4" stroke="#1f2937" stroke-width="3"/>' +
  '<circle cx="180" cy="52" r="3" fill="#1f2937"/>' +
  '<g transform="translate(80 112)"><rect x="0" y="0" width="7" height="26" fill="#292524"/></g></svg>';

/** The same drawing BEFORE normalization — how such a file actually ships from the web. */
const RAW_CLIPART =
  '<svg viewBox="0 0 240 160"><style>.corps{fill:#f5f5f4;stroke:#1f2937}</style>' +
  '<defs><g id="patte"><rect width="7" height="26" fill="#292524"/></g></defs>' +
  '<ellipse class="corps" cx="120" cy="80" rx="62" ry="38"/>' +
  '<use href="#patte" x="80" y="112"/></svg>';

describe("le problème que le normaliseur résout", () => {
  it("un clipart brut du net perd ses couleurs et ses formes en traversant le sanitizer", () => {
    const out = sanitizeSvg(RAW_CLIPART);

    // Le <style> saute : plus rien ne porte les fills, la figure vire au noir par défaut.
    expect(out).not.toContain("<style");
    expect(out).not.toContain("#f5f5f4");

    // Le <use> saute — et c'est le piège dans sa forme la plus vicieuse : le <defs> et le
    // dessin de la patte, eux, RESTENT dans la charge utile. Un enfant du <defs> n'est
    // jamais tracé : la patte est invisible à l'écran tout en continuant à voyager dans
    // chaque ligne de contenu. Rien ne signale l'erreur, ni au rendu, ni au poids.
    expect(out).not.toContain("<use");
    expect(out).toContain("<defs");
    expect(out).toContain('width="7"');

    // …et il reste un SVG parfaitement valide : voilà pourquoi l'erreur est muette.
    expect(out).toContain("<ellipse");
  });
});

describe("une figure normalisée traverse le sanitizer sans perte", () => {
  const sanitized = sanitizeSvg(NORMALIZED_FIGURE);

  it("ne perd aucun élément", () => {
    const tags = (s) => (s.match(/<([a-zA-Z][\w:-]*)/g) || []).map((t) => t.slice(1)).sort();
    expect(tags(sanitized)).toEqual(tags(NORMALIZED_FIGURE));
  });

  it("garde les couleurs, la géométrie et le viewBox", () => {
    for (const kept of ["#79d2fb", "#f5f5f4", "#1f2937", "#292524", "viewBox", "translate(80 112)"])
      expect(sanitized).toContain(kept);
  });

  it("garde le <title> — c'est le nom accessible de la figure", () => {
    expect(sanitized).toContain("<title>Une vache dans un pré</title>");
  });

  it("satisfait le lint maison, qui est plus strict que le sanitizer", () => {
    expect(lintSvg(NORMALIZED_FIGURE)).toEqual([]);
  });
});

describe("lintSvg", () => {
  const good = '<svg viewBox="0 0 10 10"><title>t</title><circle cx="5" cy="5" r="4"/></svg>';

  it("accepte une figure conforme", () => {
    expect(lintSvg(good)).toEqual([]);
  });

  it("refuse une figure sans viewBox — elle s'effondrerait au rendu", () => {
    expect(lintSvg("<svg><circle cx='5' cy='5' r='4'/></svg>").join()).toMatch(/no viewBox/);
  });

  it("accepte width+height à défaut de viewBox", () => {
    expect(lintSvg('<svg width="10" height="10"><circle r="4"/></svg>')).toEqual([]);
  });

  it.each([
    ["image", '<svg viewBox="0 0 1 1"><image href="x.png"/></svg>'],
    ["use", '<svg viewBox="0 0 1 1"><use href="#a"/></svg>'],
    ["style", '<svg viewBox="0 0 1 1"><style>.a{fill:red}</style></svg>'],
    ["defs", '<svg viewBox="0 0 1 1"><defs><g id="a"/></defs></svg>'],
    ["marker", '<svg viewBox="0 0 1 1"><marker id="m"/></svg>'],
    ["foreignObject", '<svg viewBox="0 0 1 1"><foreignObject/></svg>'],
    ["script", '<svg viewBox="0 0 1 1"><script>alert(1)</script></svg>'],
  ])("refuse <%s>", (_name, svg) => {
    expect(lintSvg(svg).length).toBeGreaterThan(0);
  });

  it("refuse un élément hors liste blanche", () => {
    expect(lintSvg('<svg viewBox="0 0 1 1"><clipPath/></svg>').join()).toMatch(/disallowed/);
  });

  it("refuse les chiffres arabes-indiens — les figures sont en chiffres occidentaux", () => {
    expect(lintSvg('<svg viewBox="0 0 1 1"><text>٣٥</text></svg>').join()).toMatch(/digits/);
  });

  it("refuse un <svg> mal formé", () => {
    expect(lintSvg('<svg viewBox="0 0 1 1"><circle r="1"/>').join()).toMatch(/malformed/);
  });

  it("préfixe chaque problème par son emplacement", () => {
    expect(lintSvg("<svg></svg>", "content/x/cours.md")[0]).toMatch(/^content\/x\/cours\.md:/);
  });
});

describe("NON_RENDERING — les conteneurs qui ne se déplient jamais", () => {
  // Le bug que cette liste empêche : un <clipPath> n'a pas besoin d'être dans <defs>.
  // Déplié au lieu d'être supprimé, son rectangle de découpe — invisible dans l'original —
  // devient une forme noire posée SUR le dessin.
  it("aucun conteneur non-rendu n'est dans la liste blanche", () => {
    for (const tag of NON_RENDERING) expect(ALLOWED.has(tag)).toBe(false);
  });

  it("couvre les conteneurs qui ne peignent que par référence", () => {
    for (const tag of ["clipPath", "mask", "marker", "symbol", "pattern", "defs"])
      expect(NON_RENDERING).toContain(tag);
  });

  it("chacun est refusé par le lint, où qu'il se trouve dans la figure", () => {
    for (const tag of NON_RENDERING) {
      const svg = `<svg viewBox="0 0 1 1"><g><${tag}></${tag}></g></svg>`;
      expect(lintSvg(svg).length, `<${tag}> devrait être refusé`).toBeGreaterThan(0);
    }
  });
});

describe("anti-dérive : le miroir du sanitizer reste fidèle à la source", () => {
  // Si `figure.ts` change sa configuration DOMPurify sans que ce miroir suive, `import.mjs`
  // validerait ses figures contre des règles qui ne sont plus celles de la production.
  const source = readFileSync("src/shared/lib/figure.ts", "utf8");

  it("FORBID_TAGS est identique à celui de src/shared/lib/figure.ts", () => {
    const real = /FORBID_TAGS:\s*\[([^\]]*)\]/.exec(source)?.[1] ?? "";
    const parsed = [...real.matchAll(/"([^"]+)"/g)].map((m) => m[1]);
    expect(parsed).toEqual(DOMPURIFY_CONFIG.FORBID_TAGS);
  });

  it("FORBID_ATTR est identique à celui de src/shared/lib/figure.ts", () => {
    const real = /FORBID_ATTR:\s*\[([^\]]*)\]/.exec(source)?.[1] ?? "";
    const parsed = [...real.matchAll(/"([^"]+)"/g)].map((m) => m[1]);
    expect(parsed).toEqual(DOMPURIFY_CONFIG.FORBID_ATTR);
  });

  it("USE_PROFILES est identique à celui de src/shared/lib/figure.ts", () => {
    expect(source).toMatch(/USE_PROFILES:\s*\{\s*svg:\s*true,\s*svgFilters:\s*true\s*\}/);
    expect(DOMPURIFY_CONFIG.USE_PROFILES).toEqual({ svg: true, svgFilters: true });
  });

  it("la liste blanche couvre les primitives que produit svglib", () => {
    for (const tag of ["svg", "title", "g", "line", "path", "polygon", "polyline", "text"])
      expect(ALLOWED.has(tag)).toBe(true);
  });
});

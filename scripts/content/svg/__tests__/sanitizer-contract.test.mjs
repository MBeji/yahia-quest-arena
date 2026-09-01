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

  it("refuse un dégradé dont il ne reste que le <stop>", () => {
    expect(lintSvg('<svg viewBox="0 0 1 1"><stop offset="0"/></svg>').join()).toMatch(
      /outside any gradient/,
    );
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

describe("indirection url(#…) — une flèche, un dégradé", () => {
  /** La forme exacte qu'ont les 5 figures à flèches du corpus (physique, arabe). */
  const arrow = (id = "fleche-noire") =>
    `<svg viewBox="0 0 100 20"><defs><marker id="${id}" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto"><path d="M0 0 L9 4.5 L0 9 Z" fill="#0f172a"/></marker></defs>` +
    `<path d="M5 10 L90 10" stroke="#0f172a" stroke-width="2" fill="none" marker-end="url(#${id})"/></svg>`;

  // Le fait qui a renversé la règle. Ce test est le garde-fou dans l'autre sens : si un
  // jour `figure.ts` se met VRAIMENT à retirer les marqueurs, il rougit — et le lint doit
  // alors les réinterdire, parce que la flèche aura, elle, réellement disparu.
  it("le sanitizer de production garde le marqueur, sa référence et son id", () => {
    const out = sanitizeSvg(arrow());
    for (const kept of [
      "<defs",
      "<marker",
      'id="fleche-noire"',
      "marker-end",
      "url(#fleche-noire)",
    ])
      expect(out).toContain(kept);
  });

  it("le lint accepte une flèche référencée", () => {
    expect(lintSvg(arrow())).toEqual([]);
  });

  it("le lint accepte un dégradé référencé", () => {
    const svg =
      '<svg viewBox="0 0 100 20"><defs><linearGradient id="echelle-degre"><stop offset="0" stop-color="#dbeafe"/><stop offset="1" stop-color="#2563eb"/></linearGradient></defs>' +
      '<rect x="0" y="0" width="100" height="20" fill="url(#echelle-degre)"/></svg>';
    expect(lintSvg(svg)).toEqual([]);
  });

  it("refuse une référence qui ne résout rien — la flèche ne serait tout simplement pas là", () => {
    const typo = arrow().replace("url(#fleche-noire)", "url(#fleche-noir)");
    expect(lintSvg(typo).join()).toMatch(/url\(#fleche-noir\) points at no id/);
  });

  it("refuse une définition que personne n'appelle — elle ne dessine rien, elle voyage", () => {
    const orphan = arrow().replace(' marker-end="url(#fleche-noire)"', "");
    const joined = lintSvg(orphan).join();
    expect(joined).toMatch(/<marker> that nothing references/);
    expect(joined).toMatch(/<defs> holds nothing this figure references/);
  });

  describe("un id sans tiret", () => {
    it("est refusé par le lint", () => {
      expect(lintSvg(arrow("fleche")).join()).toMatch(/needs a hyphen/);
    });

    // …et voici pourquoi, prouvé sur le sanitizer réel plutôt que raconté : la garde
    // anti-DOM-clobbering de DOMPurify retire l'id qui porte le nom d'une propriété de
    // `document`. Le `url(#body)` survit et ne pointe alors sur rien : flèche muette,
    // sans une seule erreur nulle part.
    it("peut être supprimé par le sanitizer, ce qui casse la référence en silence", () => {
      const out = sanitizeSvg(arrow("body"));
      expect(out).not.toContain('id="body"');
      expect(out).toContain("url(#body)");
    });

    it("contrôle négatif : le même sanitizer garde un id avec tiret", () => {
      expect(sanitizeSvg(arrow("body-fleche"))).toContain('id="body-fleche"');
    });
  });
});

describe("SVG déclaré sous préfixe de namespace", () => {
  // Rencontré sur un fichier réel de Wikimedia Commons (Raptor Silhouette, NIH BioArt) :
  // il déclare `xmlns:ns0="…/svg"` et écrit `<ns0:svg><ns0:path>`. Inkscape et plusieurs
  // exportateurs font pareil. Une figure sortie ainsi n'est dessinée par rien, et le
  // sérialiseur XML conserve fidèlement le préfixe si on ne le retire pas à la structure.
  const prefixed = '<ns0:svg viewBox="0 0 10 10"><ns0:path d="M0 0 L5 5"/></ns0:svg>';

  it("est refusé par le lint — c'est ce qui rend le dé-préfixage obligatoire", () => {
    const issues = lintSvg(prefixed).join(" ");
    expect(issues).toMatch(/disallowed element <ns0:svg>/);
    expect(issues).toMatch(/disallowed element <ns0:path>/);
  });

  it("la même figure sans préfixe passe", () => {
    expect(lintSvg('<svg viewBox="0 0 10 10"><path d="M0 0 L5 5"/></svg>')).toEqual([]);
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

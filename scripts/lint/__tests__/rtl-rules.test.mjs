import { describe, expect, it } from "vitest";
import { blankComments, findRtlViolations } from "../rtl-rules.mjs";

/**
 * Le garde RTL, règle par règle. Chaque cas « vu » ci-dessous est un trou que le
 * garde d'origine laissait passer (issue #1228, `rtl-physical-classes-missed-by-lint`) ;
 * chaque cas « laissé » est un faux positif qu'il ne doit pas inventer.
 */
const names = (source, kind = "tsx") => findRtlViolations(source, kind).map((v) => v.rule);

describe("classes Tailwind physiques", () => {
  it.each([
    ['<div className="ml-auto flex" />', "margin/padding physiques"],
    ['<div className="sm:pl-4" />', "margin/padding physiques"],
    ['<div className="-mr-1" />', "margin/padding physiques"],
    ['<div className="absolute right-2 top-2" />', "position left-/right- physique"],
    ['<div className="md:left-0" />', "position left-/right- physique"],
    ['<div className="right-auto" />', "position left-/right- physique"],
    ['<p className="sm:text-left" />', "text-left/text-right"],
    ['<div className="float-right" />', "float/clear physiques"],
    ['<div className="scroll-ml-4" />', "scroll-margin/padding physiques"],
    ['<div className="rounded-tl-lg" />', "rounded-l/r physiques"],
    ['<div className="border-l-2" />', "border-l/r physiques"],
    [
      '<div className="data-[state=open]:slide-in-from-left" />',
      "glissement physique (tw-animate)",
    ],
  ])("vu : %s", (source, rule) => {
    expect(names(source)).toContain(rule);
  });

  it.each([
    '<div className="ms-auto ps-4 start-0 end-2 text-start rounded-s-lg border-e" />',
    '<div className="left-1/2 -translate-x-1/2" />',
    '<div className="fixed left-[50%] translate-x-[-50%]" />',
    '<div className="data-[side=left]:slide-in-from-right-2" />',
    '<div className="data-[state=open]:slide-in-from-end" />',
    "const note = 'formulas stay left-to-right, on the right-hand side';",
  ])("laissé : %s", (source) => {
    expect(names(source)).toEqual([]);
  });
});

describe("styles en ligne", () => {
  it("voit les propriétés physiques en camelCase", () => {
    expect(names("<div style={{ marginLeft: 8 }} />")).toContain("style en ligne physique");
    expect(names("<div style={{ borderTopLeftRadius: 4 }} />")).toContain(
      "style en ligne physique",
    );
    expect(names('<p style={{ textAlign: "right" }} />')).toContain("textAlign left/right");
  });

  it("laisse les propriétés logiques", () => {
    expect(names('<div style={{ marginInlineStart: 8, textAlign: "start" }} />')).toEqual([]);
  });
});

describe("texte rendu", () => {
  it("voit une flèche écrite en dur dans du JSX", () => {
    expect(names("<a>{t.quest.next} →</a>")).toEqual(["flèche littérale"]);
  });

  it("laisse une flèche que sa classe retourne en RTL", () => {
    const source =
      '<span aria-hidden="true" className="inline-block rtl:-scale-x-100">\n  →\n</span>';
    expect(names(source)).toEqual([]);
  });

  it("laisse les flèches des commentaires, sur une ou plusieurs lignes", () => {
    expect(names("// score → gains → étoile\nconst a = 1;")).toEqual([]);
    expect(names("{/* cours (ici)\n    → quiz → missions */}\n<p />")).toEqual([]);
    expect(names("/**\n * `a` → `b`\n */\nexport const x = 1;")).toEqual([]);
  });

  it("voit un signe collé à un nombre interpolé", () => {
    expect(names("<span>+{xp} XP</span>")).toEqual(["signe collé à un nombre interpolé"]);
    expect(names("const v = `+${coins}`;")).toEqual(["signe collé à un nombre interpolé"]);
  });

  it("laisse une addition et le signe posé par plus()", () => {
    expect(names("const total = a + b;\nconst label = plus(xp);")).toEqual([]);
    expect(names("const s = `${a}+${b}`;")).toEqual([]);
  });

  it("ne cherche pas de texte rendu dans un fichier .ts", () => {
    expect(names("export const arrow = '→';", "ts")).toEqual([]);
  });
});

describe("feuille de style", () => {
  it.each([
    ["  margin-left: 1rem;", "propriété CSS physique"],
    ["  border-top-left-radius: 4px;", "propriété CSS physique"],
    ["  left: 0;", "propriété CSS physique"],
    ["  text-align: right;", "text-align/float physiques"],
    ["  border-radius: 0 0.75rem 0.75rem 0;", "border-radius à coins inégaux"],
  ])("vu : %s", (source, rule) => {
    expect(names(source, "css")).toEqual([rule]);
  });

  it.each([
    "  margin-inline-start: 1rem;",
    "  border-start-end-radius: 0.75rem;",
    "  inset-inline: 0;",
    "  text-align: center;",
    "  border-radius: 0.75rem;",
    "  border-radius: 4px 4px 4px 4px;",
    "  border-inline-start: 3px solid var(--primary);",
    "  scroll-padding-left-fake: 0;",
  ])("laissé : %s", (source) => {
    expect(names(source, "css")).toEqual([]);
  });
});

describe("exception documentée", () => {
  it("`rtl-ok` vaut pour sa ligne et les trois suivantes", () => {
    const source = [
      "// rtl-ok: trace technique, toujours LTR",
      "<pre",
      '  dir="ltr"',
      '  className="text-left"',
      "/>",
    ].join("\n");
    expect(names(source)).toEqual([]);
    expect(names(`${source}\n<p className="text-left" />`)).toEqual(["text-left/text-right"]);
  });

  it("donne la ligne et le correctif", () => {
    expect(findRtlViolations('\n<div className="pl-2" />', "tsx")).toEqual([
      {
        line: 2,
        rule: "margin/padding physiques",
        fix: "ms-/me-/ps-/pe-",
        text: '<div className="pl-2" />',
      },
    ]);
  });
});

describe("blankComments", () => {
  it("garde longueur et lignes, épargne les URL dans les chaînes", () => {
    const source = 'const u = "https://a.b"; // → c\n/* → */ const d = 1;';
    const blanked = blankComments(source);
    expect(blanked).toHaveLength(source.length);
    expect(blanked.split("\n")).toHaveLength(2);
    expect(blanked).toContain('"https://a.b"');
    expect(blanked).not.toContain("→");
  });
});

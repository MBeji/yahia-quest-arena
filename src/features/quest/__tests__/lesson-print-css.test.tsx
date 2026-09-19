import { render } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

// Mêmes doublures que `lesson-reader.test.tsx` : ce test veut le DOM du lecteur,
// pas son routeur ni ses sections auto-chargées.
// Le `Link` du routeur devient un `<a>` — en laissant passer les autres attributs
// (`data-testid`, `className`), puisque c'est sur eux que ce test interroge le DOM.
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params: _params,
    activeProps: _activeProps,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    params?: unknown;
    activeProps?: unknown;
  } & React.AnchorHTMLAttributes<HTMLAnchorElement>) =>
    React.createElement("a", { href: to, ...rest }, children),
}));
vi.mock("../components/manuel-pages-section", () => ({ ManuelPagesSection: () => null }));
vi.mock("../components/chapter-videos-section", () => ({ ChapterVideosSection: () => null }));

import { LessonReader, type LessonReaderChapter } from "../components/lesson-reader";

/**
 * IMPRESSION D'UN COURS — ce test interroge le DOM RÉEL du lecteur, pas le texte
 * de la feuille de style.
 *
 * Son prédécesseur cherchait la chaîne `.app-shell .lesson-content` dans
 * `styles.css`. Il est resté vert alors que le cours sortait en pages blanches :
 * le chantier C8 avait déplacé le lecteur de `.app-shell` vers `.public-shell`
 * (`/lesson/$chapterId` n'est plus qu'une redirection 301), et la règle qui
 * remettait le cours à l'encre ne matchait donc plus AUCUN élément. Un test qui
 * vérifie qu'une règle existe ne dit rien de ce qu'elle atteint.
 *
 * On monte donc le lecteur, on prend ses vrais nœuds, et on demande à
 * `Element.matches()` si une règle `@media print` les attrape vraiment — sous
 * chacune des coquilles de l'application, et sans coquille du tout.
 */

// Les commentaires tombent AVANT tout découpage : une prose qui cite « @media print »
// ferait sinon naître un bloc fantôme, et le test se mettrait à lire du texte.
const CSS = readFileSync(resolve(import.meta.dirname, "../../../styles.css"), "utf-8").replace(
  /\/\*[\s\S]*?\*\//g,
  "",
);

/** Le corps de chaque bloc `@media print` de la feuille (il y en a plusieurs). */
function printBlocks(css: string): string[] {
  const blocks: string[] = [];
  const marker = "@media print";
  let from = 0;
  for (;;) {
    const at = css.indexOf(marker, from);
    if (at === -1) return blocks;
    const open = css.indexOf("{", at);
    let depth = 0;
    let end = open;
    for (; end < css.length; end += 1) {
      if (css[end] === "{") depth += 1;
      else if (css[end] === "}") {
        depth -= 1;
        if (depth === 0) break;
      }
    }
    blocks.push(css.slice(open + 1, end));
    from = end;
  }
}

type Rule = { selectors: string[]; body: string };

/**
 * Les règles d'un bloc, en `{ selectors, body }`. Découpage par `split` et non par
 * une expression qui décrirait un sélecteur — même raison que
 * `lesson-table-rtl-css.test.ts` : un groupe répété d'espaces y avait valu une
 * alerte CodeQL « inefficient regular expression ». Les commentaires et les
 * at-rules imbriquées (`@page`) tombent d'abord.
 */
function rulesOf(block: string): Rule[] {
  return block
    .replace(/\/\*[\s\S]*?\*\//g, "")
    .replace(/@[\w-]+[^{]*\{[^}]*\}/g, "")
    .split("}")
    .map((chunk) => {
      const [selector = "", body = ""] = chunk.split("{");
      return { selectors: selector.split(",").map((s) => s.trim()), body };
    })
    .filter((rule) => rule.body.trim() && rule.selectors.some(Boolean));
}

const PRINT_RULES = printBlocks(CSS).flatMap(rulesOf);

/** Les règles d'impression qui attrapent CET élément et déclarent `prop`. */
function printRulesFor(el: Element, prop: string): Rule[] {
  return PRINT_RULES.filter(
    (rule) =>
      new RegExp(`(^|;)\\s*${prop}\\s*:`).test(rule.body) &&
      rule.selectors.some((sel) => sel && el.matches(sel)),
  );
}

/**
 * Une déclaration `color` qui met VRAIMENT à l'encre : une couleur littérale noire,
 * jamais un token de thème, et `!important` — sans quoi elle perdrait contre le
 * `color: var(--foreground)` que `.lesson-content` pose sur l'élément lui-même.
 * L'ancre `(^|;)` écarte `border-color` et `-webkit-text-fill-color`.
 */
const INK = /(^|;)\s*color\s*:\s*#(000|0{6})\s*!important/;

const chapter: LessonReaderChapter = {
  title: "Les fractions",
  lesson_content: [
    "# Les fractions",
    "",
    "## Comparer deux fractions",
    "",
    "Une fraction exprime une **part** d'un tout.",
    "",
    "::: definition Fraction",
    "Le quotient de deux entiers, dénominateur non nul.",
    ":::",
    "",
    "| Fraction | Valeur |",
    "| --- | --- |",
    "| 1/2 | 0,5 |",
    "",
    "## Mettre au même dénominateur",
    "",
    "On multiplie haut et bas par le même nombre.",
  ].join("\n"),
  summary: null,
  subject_id: "math-6",
  videos: null,
  subjects: { name_fr: "Maths", content_language: "fr" },
};

/** Le lecteur monté sous la coquille demandée — `null` = aucune coquille. */
function mountReader(shellClass: string | null) {
  const Wrapper = ({ children }: { children: React.ReactNode }) =>
    shellClass ? <div className={shellClass}>{children}</div> : <>{children}</>;
  return render(
    <LessonReader chapterId="c1" chapter={chapter} allChapters={[]} practiceExerciseId="ex-1" />,
    { wrapper: Wrapper },
  ).container;
}

/** Les nœuds dont l'encre décide qu'une page imprimée porte le cours ou rien. */
const PROBES: ReadonlyArray<[label: string, selector: string]> = [
  ["le corps du cours", ".lesson-content"],
  ["un paragraphe", ".lesson-content p"],
  ["un titre de section", ".lesson-h2"],
  ["le titre d'un bloc pédagogique", ".lesson-blk__title"],
  ["le libellé d'un bloc pédagogique", ".lesson-blk__label"],
  ["une cellule de tableau", ".lesson-table td"],
  ["le fil d'ariane de l'en-tête", "[data-testid='reader-domain'], header a"],
  ["le titre du chapitre", "header h1"],
];

// Les trois montages possibles du lecteur. `.public-shell` est celui d'aujourd'hui
// (`/chapitre/$chapterId`) ; les deux autres disent que la règle ne doit dépendre
// d'aucune coquille — c'est la bascule de l'une à l'autre qui avait cassé l'impression.
describe.each([["public-shell"], ["app-shell"], [null]])(
  "@media print — un cours imprimé, coquille %s",
  (shellClass) => {
    it("met à l'encre CHAQUE nœud du cours, pas seulement la coquille", () => {
      // En thème « Noir & Or », `.lesson-content { color: var(--foreground) }` vaut
      // un quasi-blanc : sans règle d'impression plus forte, la feuille sort vide.
      const container = mountReader(shellClass);
      for (const [label, selector] of PROBES) {
        const el = container.querySelector(selector);
        expect(el, `sonde absente du lecteur : ${label} (${selector})`).not.toBeNull();
        const inked = printRulesFor(el as Element, "color").filter((rule) => INK.test(rule.body));
        expect(inked.length, `aucune règle @media print ne met à l'encre ${label}`).toBeGreaterThan(
          0,
        );
      }
    });

    it("neutralise le dégradé-clip du titre, qui peint son texte en transparent", () => {
      // `.lesson-h1` s'appuie sur `-webkit-text-fill-color: transparent` + un fond en
      // dégradé. Les fonds ne s'impriment pas : sans remise à `currentColor`, le titre
      // du cours disparaît — y compris sur une feuille par ailleurs correcte.
      const h1 = mountReader(shellClass).querySelector(".lesson-h1");
      expect(h1).not.toBeNull();
      const fixed = printRulesFor(h1 as Element, "-webkit-text-fill-color");
      expect(
        fixed.some((rule) => /-webkit-text-fill-color\s*:\s*currentColor/i.test(rule.body)),
        "le titre du cours resterait transparent sur le papier",
      ).toBe(true);
    });

    it("ne masque jamais le cours à l'impression", () => {
      const content = mountReader(shellClass).querySelector(".lesson-content");
      for (const rule of printRulesFor(content as Element, "display")) {
        expect(rule.body).not.toMatch(/display\s*:\s*none/);
      }
    });
  },
);

describe("@media print — le chrome ne s'imprime pas", () => {
  // La remise à l'encre couvre TOUT l'article : ce qui n'est pas le cours doit donc
  // sortir du papier par `print:hidden`, sinon il s'imprime en noir bien lisible.
  it.each([["lesson-print"], ["lesson-toc"], ["lesson-practice-cta"]])(
    "sort %s du document imprimé",
    (testid) => {
      const el = mountReader("public-shell").querySelector(`[data-testid='${testid}']`);
      expect(el, `sonde absente du lecteur : ${testid}`).not.toBeNull();
      expect(
        (el as Element).closest('[class*="print:hidden"]'),
        `${testid} reste sur le papier`,
      ).not.toBeNull();
    },
  );
});

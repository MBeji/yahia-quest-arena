// @vitest-environment node
import { describe, expect, it } from "vitest";
import {
  auditBoardQuestion,
  auditNumericQuestion,
  auditQuestion,
  auditShortAnswerQuestion,
  QUESTION_MARKUP_LEVEL,
  type Flag,
  type QAQuestion,
} from "../../../../scripts/content/qa-checks.ts";

/**
 * CHAQUE TYPE ROUTÉ PAR `qa.ts` PORTE LES CONTRÔLES DE RENDU PARTAGÉS.
 *
 * Ce fichier existe parce que le trou s'est DÉJÀ produit, et qu'il est
 * invisible autrement. #654 a branché `short_answer` dans le ternaire par type
 * de `scripts/content/qa.ts` sans lui donner `auditRenderedFields` — alors que
 * la fonction existait déjà et que les trois autres audits l'appelaient déjà.
 * Le type neuf n'a hérité de rien, et les 119 questions `short_answer` du
 * corpus ont traversé le gate sans qu'aucun de ces contrôles ne les regarde.
 *
 * Personne ne l'a vu, et c'est le point : le gate était VERT, précisément
 * parce qu'il ne mesurait rien. C'est aussi ce qui a fait osciller #853 entre
 * « 145 énoncés » et « zéro » — le compte réel était 12, tous dans le seul type
 * que la règle ne pouvait pas voir.
 *
 * Un test par type ne suffirait pas : il faut une TABLE, sinon le prochain type
 * ajouté rejouera la même panne. Le jour où `qa.ts` route un type de plus, ce
 * fichier échoue tant qu'il n'est pas dans la table ET qu'il ne porte pas les
 * contrôles.
 */
const AVEC_GRAS = "Combien vaut **deux** plus deux ?";
const SANS_GRAS = "Combien vaut deux plus deux ?";
const EXPLICATION = "Une explication suffisamment longue pour passer le seuil de brièveté.";

const mcq = (prompt: string): QAQuestion => ({
  prompt,
  options: [
    { id: "a", text: "Alpha" },
    { id: "b", text: "Beta" },
    { id: "c", text: "Gamma" },
    { id: "d", text: "Delta" },
  ],
  correctOption: "a",
  explanation: EXPLICATION,
});

/** Une entrée par branche du ternaire de `scripts/content/qa.ts`. */
const ROUTES: ReadonlyArray<{ type: string; flags: (prompt: string) => Flag[] }> = [
  { type: "mcq (branche par défaut)", flags: (prompt) => auditQuestion(mcq(prompt), "w") },
  {
    type: "numeric",
    flags: (prompt) =>
      auditNumericQuestion({ prompt, answerKey: { value: 4 }, explanation: EXPLICATION }, "w"),
  },
  ...(["ordering", "matching", "multi"] as const).map((type) => ({
    type,
    flags: (prompt: string) =>
      auditBoardQuestion(
        {
          prompt,
          options: [
            { id: "a", text: "Alpha" },
            { id: "b", text: "Beta" },
          ],
          explanation: EXPLICATION,
        },
        "w",
      ),
  })),
  {
    type: "short_answer",
    flags: (prompt) =>
      auditShortAnswerQuestion(
        { type: "short_answer", prompt, explanation: EXPLICATION, answerKey: { text: "quatre" } },
        new Set<string>(),
        "w",
      ),
  },
];

describe("les contrôles de rendu partagés s'appliquent à TOUS les types", () => {
  for (const { type, flags } of ROUTES) {
    it(`${type} : un énoncé écrit en Markdown est vu`, () => {
      const vus = flags(AVEC_GRAS);
      expect(
        vus.some((f) => f.level === QUESTION_MARKUP_LEVEL && f.msg.includes("Markdown markup")),
      ).toBe(true);
    });

    it(`${type} : contrôle négatif — un énoncé propre ne déclenche rien`, () => {
      expect(flags(SANS_GRAS).filter((f) => f.msg.includes("Markdown markup"))).toEqual([]);
    });
  }
});

import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import {
  isRecallEligible,
  normalizeRecallText,
  PARITY_CORPUS,
  TYPABLE_CHARSET,
  type EligibilityInput,
} from "../free-answer.ts";

// Étude 20 lot 1 — le miroir TS des primitives SQL de l'étude 17.
//
// RISK-2 : la QA (TS) valide un ensemble que le scoring (SQL) recalcule. Si les
// deux normalisations divergent, une variante validée au build est refusée en
// base — ou pire, l'inverse. La défense est le corpus partagé : joué ici contre
// l'implémentation TS, et dans le pgTAP contre la fonction déployée. Le test
// « présence dans le pgTAP » ferme la boucle : on ne peut pas ajouter un cas
// d'un seul côté.

const PGTAP_FILE = join(process.cwd(), "supabase/tests/34_accepted_answers_set.test.sql");

describe("normalizeRecallText — parity corpus (TS side)", () => {
  it.each(PARITY_CORPUS)("$why: $input", ({ input, expected }) => {
    expect(normalizeRecallText(input)).toBe(expected);
  });

  it("treats null/undefined as the empty string (SQL coalesce)", () => {
    expect(normalizeRecallText(null)).toBe("");
    expect(normalizeRecallText(undefined)).toBe("");
  });

  it("keeps a dot only BETWEEN two digits, including in chains", () => {
    expect(normalizeRecallText("1.2.3")).toBe("1.2.3");
    expect(normalizeRecallText("M. Dupont")).toBe("mdupont");
  });

  it("makes segmentation irrelevant (the point of step 9)", () => {
    expect(normalizeRecallText("grand-père")).toBe(normalizeRecallText("grand père"));
    expect(normalizeRecallText("25 cm")).toBe("25cm");
  });
});

describe("parity corpus — the SQL side must assert the same rows", () => {
  const pgtap = readFileSync(PGTAP_FILE, "utf8");

  // A pgTAP literal escapes `'` by doubling it; compare in that alphabet.
  const asSqlLiteral = (s: string) => s.replaceAll("'", "''");

  it.each(PARITY_CORPUS)("pgTAP asserts $input", ({ input, expected }) => {
    // The whole assertion, not just the input: a pgTAP row expecting something
    // ELSE than this file would silently disagree with the TS mirror.
    expect(pgtap).toContain(
      `is(public.normalize_recall_text('${asSqlLiteral(input)}'), '${asSqlLiteral(expected)}'`,
    );
  });

  it("declares a plan matching its assertion count", () => {
    const planned = Number(/SELECT plan\((\d+)\)/.exec(pgtap)?.[1]);
    const asserted = (pgtap.match(/^SELECT (is|ok|has_column|col_not_null|throws_ok)\(/gm) ?? [])
      .length;
    expect(asserted).toBe(planned);
  });
});

const mcq = (over: Partial<EligibilityInput> = {}): EligibilityInput => ({
  type: "mcq",
  prompt: "Capitale de la France ?",
  options: [
    { id: "a", text: "Paris" },
    { id: "b", text: "Lyon" },
    { id: "c", text: "Nice" },
  ],
  correctOption: "a",
  ...over,
});

// Ces cas rejouent un à un ceux du pgTAP de l'étude 17
// (supabase/tests/28_recall_mode_foundations.test.sql, E1–E12) : le miroir doit
// classer comme la fonction déployée, sinon la QA avertirait à tort ou à raison
// sur un ensemble parfaitement consommé.
describe("isRecallEligible — mirror of is_question_recall_eligible (R-2 a–i)", () => {
  it("E1: a short, self-sufficient mcq is eligible", () => {
    expect(isRecallEligible(mcq())).toBe(true);
  });

  it("E2 (b): fewer than 3 options", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "Vrai" },
            { id: "b", text: "Faux" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E3 (c): answer longer than 6 words", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "un deux trois quatre cinq six sept" },
            { id: "b", text: "huit" },
            { id: "c", text: "neuf" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E4 (c): answer longer than 60 characters", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "a".repeat(63) },
            { id: "b", text: "court" },
            { id: "c", text: "bref" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E5 (d): rich content (URL) in the answer", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "http://x.test" },
            { id: "b", text: "un" },
            { id: "c", text: "deux" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E6 (e): structural mathematical symbol", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "x = 5" },
            { id: "b", text: "six" },
            { id: "c", text: "sept" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E7 (f): composite marker (slash)", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "3/4" },
            { id: "b", text: "deux" },
            { id: "c", text: "trois" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E8 (g): prompt depends on the options", () => {
    expect(isRecallEligible(mcq({ prompt: "Laquelle de ces villes est la capitale ?" }))).toBe(
      false,
    );
    expect(isRecallEligible(mcq({ prompt: "أي من المدن التالية هي العاصمة ؟" }))).toBe(false);
  });

  it("E9 (h): the answer collides with a distractor once normalised", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "Deux" },
            { id: "b", text: "deux" },
            { id: "c", text: "trois" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E10 (i): the answer normalises to nothing (off-keyboard charset)", () => {
    expect(
      isRecallEligible(
        mcq({
          options: [
            { id: "a", text: "π" },
            { id: "b", text: "un" },
            { id: "c", text: "deux" },
          ],
        }),
      ),
    ).toBe(false);
  });

  it("E11 (a): a non-mcq is never eligible — short_answer included (R-11)", () => {
    expect(isRecallEligible(mcq({ type: "numeric" }))).toBe(false);
    expect(isRecallEligible(mcq({ type: "short_answer" }))).toBe(false);
  });

  it("E12: an Arabic mcq is eligible", () => {
    expect(
      isRecallEligible(
        mcq({
          prompt: "عاصمة فرنسا؟",
          options: [
            { id: "a", text: "باريس" },
            { id: "b", text: "لندن" },
            { id: "c", text: "روما" },
          ],
        }),
      ),
    ).toBe(true);
  });
});

describe("TYPABLE_CHARSET — R-5", () => {
  it("admits Latin, Arabic, digits and an interdigit dot", () => {
    expect(TYPABLE_CHARSET.test("lafrique")).toBe(true);
    expect(TYPABLE_CHARSET.test("فوقالشجره")).toBe(true);
    expect(TYPABLE_CHARSET.test("3.14")).toBe(true);
  });

  it("rejects the empty string and anything off-keyboard", () => {
    expect(TYPABLE_CHARSET.test("")).toBe(false);
    expect(TYPABLE_CHARSET.test("π")).toBe(false);
    expect(TYPABLE_CHARSET.test("a b")).toBe(false);
  });
});

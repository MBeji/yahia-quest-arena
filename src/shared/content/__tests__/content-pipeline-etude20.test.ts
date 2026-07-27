import { describe, expect, it } from "vitest";
import { questionSchema } from "../schema.ts";
import {
  ACCEPTED_ANSWERS_MAX,
  buildMigrationSql,
  withMorphologicalVariants,
} from "../sql-builder.ts";
import {
  auditAcceptedAnswers,
  type QAAcceptedAnswersQuestion,
} from "../../../../scripts/content/qa-checks.ts";

// Étude 20 lot 1 — le socle du scoring ensembliste, côté pipeline de contenu :
// le champ `acceptedAnswers` (zod), son émission dans la colonne SERVER-ONLY
// `accepted_answers`, et la garde QA (R-4 anti-collision / R-5 typabilité).
//
// Rappel de l'enjeu : le SQL fait confiance à l'ensemble compilé — il n'existe
// aucune défense runtime contre un ensemble empoisonné (étude §5). Ces tests
// sont donc la preuve que la seule garde existante fonctionne.

const mcqBase = {
  type: "mcq" as const,
  prompt: "Sur quel continent se trouve le Sahara ?",
  options: [
    { id: "a", text: "Afrique" },
    { id: "b", text: "Asie" },
    { id: "c", text: "Europe" },
  ],
  correctOption: "a",
  explanation: "Le Sahara couvre une large bande du nord du continent africain.",
};

describe("schema — acceptedAnswers (étude 20 R-2)", () => {
  it("accepts a question carrying accepted variants", () => {
    expect(
      questionSchema.safeParse({
        ...mcqBase,
        acceptedAnswers: ["l'Afrique", "le continent africain"],
      }).success,
    ).toBe(true);
  });

  it("stays optional — its absence is the étude 17 behaviour, not a regression", () => {
    expect(questionSchema.safeParse(mcqBase).success).toBe(true);
  });

  it("rejects an empty variant (nothing to compare against)", () => {
    expect(questionSchema.safeParse({ ...mcqBase, acceptedAnswers: [""] }).success).toBe(false);
  });

  it("bounds the set at 24 entries (no ballooned sets)", () => {
    const of = (n: number) => Array.from({ length: n }, (_, i) => `variante ${i}`);
    expect(questionSchema.safeParse({ ...mcqBase, acceptedAnswers: of(24) }).success).toBe(true);
    expect(questionSchema.safeParse({ ...mcqBase, acceptedAnswers: of(25) }).success).toBe(false);
  });

  it("is available on every type — the QA guard, not zod, rules on consumers", () => {
    expect(
      questionSchema.safeParse({
        type: "numeric",
        prompt: "Combien font 6×7 ?",
        answerKey: { value: 42 },
        explanation: "6 × 7 = 42.",
        acceptedAnswers: ["quarante-deux"],
      }).success,
    ).toBe(true);
  });
});

describe("sql-builder — accepted_answers is emitted server-side, raw and readable", () => {
  const build = (acceptedAnswers?: string[]) =>
    buildMigrationSql({
      meta: {
        id: "etude20-subj",
        nameFr: "Étude 20",
        description: "d",
        attribute: "Esprit",
        colorToken: "subject-math",
        icon: "Brain",
        displayOrder: 1,
        contentLanguage: "fr" as const,
        themeId: "ecole-tn",
        gradeSlug: null,
        isPremium: false,
      },
      chapters: [
        {
          slug: "01-etude20",
          meta: { title: "t", description: "d", displayOrder: 1, sources: [] },
          lesson: "l",
          summary: "s",
          quiz: {
            questions: [
              {
                type: "mcq" as const,
                prompt: "q",
                options: [
                  { id: "a", text: "1" },
                  { id: "b", text: "2" },
                  { id: "c", text: "3" },
                ],
                correctOption: "a",
                explanation: "e",
              },
            ],
          },
          exercises: [
            {
              slug: "ex-etude20",
              data: {
                title: "mcq",
                difficulty: 2,
                mode: "practice" as const,
                xpReward: 75,
                rewardCoins: 15,
                displayOrder: 1,
                questions: [{ ...mcqBase, ...(acceptedAnswers ? { acceptedAnswers } : {}) }],
              },
            },
          ],
        },
      ],
    });

  /** Même matière, mais une question que la règle d'éligibilité R-2(g) écarte. */
  const buildNonEligible = () =>
    buildMigrationSql({
      meta: {
        id: "etude20-subj",
        nameFr: "Étude 20",
        description: "d",
        attribute: "Esprit",
        colorToken: "subject-math",
        icon: "Brain",
        displayOrder: 1,
        contentLanguage: "fr" as const,
        themeId: "ecole-tn",
        gradeSlug: null,
        isPremium: false,
      },
      chapters: [
        {
          slug: "01-etude20",
          meta: { title: "t", description: "d", displayOrder: 1, sources: [] },
          lesson: "l",
          summary: "s",
          quiz: { questions: [] },
          exercises: [
            {
              slug: "ex-etude20",
              data: {
                title: "mcq",
                difficulty: 2,
                mode: "practice" as const,
                xpReward: 75,
                rewardCoins: 15,
                displayOrder: 1,
                questions: [
                  {
                    ...mcqBase,
                    prompt: "Lequel de ces continents parmi les suivants ?",
                  },
                ],
              },
            },
          ],
        },
      ],
    });

  it("emits the authored text VERBATIM — normalisation belongs to SQL (D-3)", () => {
    // L'ensemble émis commence par l'authoré, mot pour mot. Depuis le lot 2 il
    // se poursuit par les variantes Tier A, d'où l'assertion sur le PRÉFIXE.
    const sql = build(["l'Afrique", "le continent africain"]);
    expect(sql).toContain(`'["l''Afrique","le continent africain"`);
  });

  it("émet les variantes Tier A sur une question éligible (lot 2)", () => {
    // Le lot 1 n'écrivait rien sans ensemble authoré ; le lot 2 backfille la
    // morphologie. La réponse « Afrique » (fr) gagne ses formes articulées.
    expect(build()).toContain("l''Afrique");
  });

  it("n'écrit RIEN sur une question que le Rappel ne lit pas", () => {
    // Le vrai invariant qui survit au lot 2 : pas de backfill là où l'ensemble
    // dormirait. Ici le prompt dépend des options (R-2 g), donc non éligible.
    expect(buildNonEligible()).toContain("'[]'::jsonb");
  });

  it("re-applies the set on conflict, so a rebuild updates it in place", () => {
    expect(build(["l'Afrique"])).toContain("accepted_answers = EXCLUDED.accepted_answers");
  });
});

const qa = (over: Partial<QAAcceptedAnswersQuestion>): QAAcceptedAnswersQuestion => ({
  type: "mcq",
  prompt: mcqBase.prompt,
  options: mcqBase.options,
  correctOption: "a",
  ...over,
});

describe("auditAcceptedAnswers — R-4 anti-collision (the safety-critical rule)", () => {
  it("passes a clean set", () => {
    expect(
      auditAcceptedAnswers(qa({ acceptedAnswers: ["l'Afrique", "le continent africain"] }), "w"),
    ).toEqual([]);
  });

  it("stays silent when there is no set at all", () => {
    expect(auditAcceptedAnswers(qa({}), "w")).toEqual([]);
  });

  it("REJECTS a variant equal to a distractor — cheating must stay wrong (US-4)", () => {
    const flags = auditAcceptedAnswers(qa({ acceptedAnswers: ["Asie"] }), "w");
    expect(flags).toHaveLength(1);
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toContain("collides with the distractor");
  });

  it("catches a collision that only appears AFTER normalisation", () => {
    // "  aSiE " normalises exactly like the distractor "Asie".
    const flags = auditAcceptedAnswers(qa({ acceptedAnswers: ["  aSiE "] }), "w");
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toContain("collides with the distractor");
  });

  it("rejects a variant duplicating the canonical answer (implicitly accepted)", () => {
    const flags = auditAcceptedAnswers(qa({ acceptedAnswers: ["afrique"] }), "w");
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toContain("duplicates the canonical answer");
  });

  it("rejects two variants that normalise alike", () => {
    const flags = auditAcceptedAnswers(
      qa({ acceptedAnswers: ["le continent africain", "Le Continent Africain"] }),
      "w",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0].msg).toContain("duplicates an earlier entry");
  });
});

describe("auditAcceptedAnswers — R-5 typability", () => {
  it("rejects a variant that normalises to nothing", () => {
    const flags = auditAcceptedAnswers(qa({ acceptedAnswers: ["π"] }), "w");
    expect(flags[0].level).toBe("error");
    expect(flags[0].msg).toContain("normalises to nothing");
  });

  it("accepts a Latin transliteration of an Arabic answer (Q-1: scope = all)", () => {
    expect(
      auditAcceptedAnswers(
        qa({
          prompt: "أيّ حيوان أصغر ؟",
          options: [
            { id: "a", text: "النملة" },
            { id: "b", text: "الفيل" },
            { id: "c", text: "الأسد" },
          ],
          acceptedAnswers: ["نملة", "namla", "nemla"],
        }),
        "w",
      ),
    ).toEqual([]);
  });
});

describe("auditAcceptedAnswers — only a consumer may carry a set (étude §3 QA 3)", () => {
  it("ERRORS on a type no scorer reads it for", () => {
    for (const type of ["numeric", "ordering", "matching", "multi"]) {
      const flags = auditAcceptedAnswers(qa({ type, acceptedAnswers: ["quarante-deux"] }), "w");
      expect(flags).toHaveLength(1);
      expect(flags[0].level).toBe("error");
      expect(flags[0].msg).toContain("no scorer reads it");
    }
  });

  it("WARNS (never errors) on an mcq that is not recall-eligible — R-6 forbids removing content", () => {
    const flags = auditAcceptedAnswers(
      qa({
        prompt: "Laquelle de ces villes est la capitale ?",
        acceptedAnswers: ["le continent africain"],
      }),
      "w",
    );
    expect(flags).toHaveLength(1);
    expect(flags[0].level).toBe("warn");
    expect(flags[0].msg).toContain("not recall-eligible");
  });

  it("still enforces R-4 on a non-eligible mcq (warn AND error together)", () => {
    const flags = auditAcceptedAnswers(
      qa({ prompt: "Laquelle de ces villes est la capitale ?", acceptedAnswers: ["Asie"] }),
      "w",
    );
    expect(flags.map((f) => f.level)).toEqual(["warn", "error"]);
  });
});

// Étude 20 lot 2 — Tier A au BUILD. La fonction pure est testée dans
// free-answer.test.ts ; ici on prouve les trois gardes de l'appelant :
// éligibilité, anti-collision R-4, et la borne des 24 qui n'évince pas l'auteur.

describe("withMorphologicalVariants — Tier A au build (étude 20 lot 2)", () => {
  it("ajoute la forme sans article à une réponse arabe éligible", () => {
    const variants = withMorphologicalVariants(
      questionSchema.parse({
        type: "mcq",
        prompt: "أيّ حيوان أصغر ؟",
        options: [
          { id: "a", text: "النملة" },
          { id: "b", text: "الفيل" },
          { id: "c", text: "الأسد" },
        ],
        correctOption: "a",
        explanation: "النملة أصغر من الفيل ومن الأسد.",
      }),
      "ar",
    );
    expect(variants).toContain("نملة");
  });

  it("ÉCARTE la variante qui collisionne avec un distracteur — R-4", () => {
    // Le distracteur « نملة » est déclaré FAUX : la variante sans article de la
    // bonne réponse lui est identique une fois normalisée. L'accepter noterait
    // juste une réponse déclarée fausse. La question, elle, reste jouable (D-2).
    const variants = withMorphologicalVariants(
      questionSchema.parse({
        type: "mcq",
        prompt: "ما هو الجواب ؟",
        options: [
          { id: "a", text: "النملة" },
          { id: "b", text: "نملة" },
          { id: "c", text: "الفيل" },
        ],
        correctOption: "a",
        explanation: "الجواب هو النملة بالتعريف.",
      }),
      "ar",
    );
    expect(variants).not.toContain("نملة");
  });

  it("laisse intacte une question NON éligible au Rappel", () => {
    // Prompt dépendant des options (R-2 g) : l'ensemble ne serait jamais lu.
    const variants = withMorphologicalVariants(
      questionSchema.parse({
        type: "mcq",
        prompt: "Lequel de ces continents parmi les suivants ?",
        options: [
          { id: "a", text: "Afrique" },
          { id: "b", text: "Asie" },
          { id: "c", text: "Europe" },
        ],
        correctOption: "a",
        explanation: "Le Sahara couvre une large bande du nord de l'Afrique.",
      }),
      "fr",
    );
    expect(variants).toEqual([]);
  });

  it("garde les variantes authorées en tête et ne les évince jamais", () => {
    const authored = Array.from({ length: ACCEPTED_ANSWERS_MAX }, (_, i) => `variante ${i}`);
    const variants = withMorphologicalVariants(
      questionSchema.parse({
        ...mcqBase,
        acceptedAnswers: authored,
      }),
      "fr",
    );
    expect(variants).toEqual(authored);
    expect(variants.length).toBe(ACCEPTED_ANSWERS_MAX);
  });
});

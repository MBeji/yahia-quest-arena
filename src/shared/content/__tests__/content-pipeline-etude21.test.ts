// @vitest-environment node
import { describe, it, expect, afterEach } from "vitest";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { exerciseManuelSchema, exerciseSchema } from "../schema.ts";
import { loadSubject, ContentValidationError } from "../loader.ts";
import { buildMigrationSql } from "../sql-builder.ts";
import { manifestChapterSchema } from "../program-manifest.ts";
import {
  chapterCoverage,
  coverageRate,
  normalizeItem,
  subjectCoverage,
  type ChapterCoverageInput,
} from "../manuel-coverage.ts";

/**
 * Étude 21 — valorisation des manuels élèves, lots 2 (traçabilité) et 4
 * (couverture). Éprouve les cinq étages que le champ traverse : schéma, loader
 * (héritage du code), sql-builder (colonne compilée), manifeste (trois
 * profondeurs) et le module de couverture.
 *
 * Le test qui compte le plus est celui de l'INVARIANT : la couverture est
 * advisory. Un rapport de campagne qui fait rougir la CI est un rapport qu'on
 * finit par désactiver — et l'étude l'écrit noir sur blanc (§3.5).
 */

// ---------------------------------------------------------------- le schéma

describe("exerciseManuelSchema — ce qu'une reprise doit dire d'elle-même", () => {
  it("accepte la forme complète", () => {
    const r = exerciseManuelSchema.safeParse({
      code: "222104P01",
      pages: "68-71",
      items: ["ex. 12", "ex. 13", "ex. 15a"],
    });
    expect(r.success).toBe(true);
  });

  it("accepte un code absent — il s'hérite du chapitre, au loader", () => {
    expect(exerciseManuelSchema.safeParse({ items: ["ex. 1"] }).success).toBe(true);
  });

  it("REFUSE une reprise sans items : elle ne tracerait rien", () => {
    // Ni ce qui est repris, ni ce qui reste — donc rien à mettre au rapport.
    expect(exerciseManuelSchema.safeParse({ code: "X1", items: [] }).success).toBe(false);
    expect(exerciseManuelSchema.safeParse({ code: "X1" }).success).toBe(false);
  });

  it("borne les items : 30 au plus, 40 caractères chacun", () => {
    const long = "e".repeat(41);
    expect(exerciseManuelSchema.safeParse({ items: [long] }).success).toBe(false);
    const many = Array.from({ length: 31 }, (_, i) => `ex. ${i}`);
    expect(exerciseManuelSchema.safeParse({ items: many }).success).toBe(false);
  });

  it("revalide `pages` avec la grammaire du chapitre", () => {
    expect(exerciseManuelSchema.safeParse({ items: ["ex. 1"], pages: "68-71" }).success).toBe(true);
    expect(exerciseManuelSchema.safeParse({ items: ["ex. 1"], pages: "12, 14-16" }).success).toBe(
      true,
    );
    // Descendante, et donc impossible à déplier.
    expect(exerciseManuelSchema.safeParse({ items: ["ex. 1"], pages: "71-68" }).success).toBe(
      false,
    );
    expect(exerciseManuelSchema.safeParse({ items: ["ex. 1"], pages: "p. 68" }).success).toBe(
      false,
    );
  });

  it("le champ reste OPTIONNEL sur l'exercice — le corpus existant ne bouge pas", () => {
    const base = {
      title: "exo",
      difficulty: 1,
      mode: "practice",
      xpReward: 50,
      rewardCoins: 10,
      displayOrder: 1,
      questions: [
        {
          type: "mcq",
          prompt: "2+2 ?",
          options: [
            { id: "a", text: "3" },
            { id: "b", text: "4" },
          ],
          correctOption: "b",
          explanation: "= 4",
        },
      ],
    };
    expect(exerciseSchema.safeParse(base).success).toBe(true);
    expect(exerciseSchema.safeParse({ ...base, manuel: { items: ["ex. 1"] } }).success).toBe(true);
  });
});

// ---------------------------------------------------------------- le loader

describe("loader — l'héritage du code, et son échec", () => {
  let dir: string | undefined;
  afterEach(() => {
    if (dir) rmSync(dir, { recursive: true, force: true });
    dir = undefined;
  });

  /** Écrit une matière minimale à un chapitre et une mission. */
  const writeSubject = (opts: {
    chapterManuel?: { code: string; pages: string };
    exerciseManuel?: Record<string, unknown>;
  }): string => {
    const root = mkdtempSync(join(tmpdir(), "e21-"));
    const chap = join(root, "01-thales");
    mkdirSync(join(chap, "exercices"), { recursive: true });
    writeFileSync(
      join(root, "subject.json"),
      JSON.stringify({
        id: "math",
        nameFr: "الرياضيات",
        description: "d",
        attribute: "Force",
        colorToken: "subject-math",
        icon: "Calculator",
        displayOrder: 1,
        contentLanguage: "ar",
        themeId: "ecole-tn",
        gradeSlug: "9eme-base",
        isPremium: false,
      }),
    );
    writeFileSync(
      join(chap, "chapter.json"),
      JSON.stringify({
        title: "طاليس",
        description: "d",
        displayOrder: 1,
        ...(opts.chapterManuel ? { manuel: opts.chapterManuel } : {}),
      }),
    );
    writeFileSync(join(chap, "cours.md"), "# cours");
    writeFileSync(join(chap, "resume.md"), "## résumé");
    const question = {
      type: "mcq",
      prompt: "2+2 ?",
      options: [
        { id: "a", text: "3" },
        { id: "b", text: "4" },
      ],
      correctOption: "b",
      explanation: "= 4",
    };
    writeFileSync(
      join(chap, "quiz.json"),
      // Le quiz exige 3 questions au moins (quizSchema) — trois variantes du même
      // gabarit suffisent : ce test porte sur le manuel, pas sur le quiz.
      JSON.stringify({
        questions: [1, 2, 3].map((n) => ({ ...question, prompt: `${n}+${n} ?` })),
      }),
    );
    writeFileSync(
      join(chap, "exercices", "01-pratique.json"),
      JSON.stringify({
        title: "exo",
        difficulty: 1,
        mode: "practice",
        xpReward: 50,
        rewardCoins: 10,
        displayOrder: 1,
        ...(opts.exerciseManuel ? { manuel: opts.exerciseManuel } : {}),
        questions: [question],
      }),
    );
    return root;
  };

  it("hérite du code du chapitre quand la mission ne le porte pas", () => {
    dir = writeSubject({
      chapterManuel: { code: "222104P01", pages: "60-71" },
      exerciseManuel: { items: ["ex. 12"] },
    });
    const subject = loadSubject(dir);
    expect(subject.chapters[0]?.exercises[0]?.data.manuel?.code).toBe("222104P01");
  });

  it("garde le code de la mission quand elle en porte un (tome différent)", () => {
    dir = writeSubject({
      chapterManuel: { code: "222104P01", pages: "60-71" },
      exerciseManuel: { code: "222104P02", items: ["ex. 3"] },
    });
    const subject = loadSubject(dir);
    expect(subject.chapters[0]?.exercises[0]?.data.manuel?.code).toBe("222104P02");
  });

  it("ÉCHOUE quand aucun code n'est résoluble — une reprise anonyme ne trace rien", () => {
    dir = writeSubject({ exerciseManuel: { items: ["ex. 12"] } });
    expect(() => loadSubject(dir as string)).toThrow(ContentValidationError);
    expect(() => loadSubject(dir as string)).toThrow(/no book code/);
  });

  it("ne touche à rien quand la mission ne déclare aucune reprise", () => {
    dir = writeSubject({ chapterManuel: { code: "222104P01", pages: "60-71" } });
    const subject = loadSubject(dir);
    expect(subject.chapters[0]?.exercises[0]?.data.manuel).toBeUndefined();
  });
});

// ----------------------------------------------------------- le sql-builder

describe("sql-builder — la colonne compilée", () => {
  const makeSubject = (exerciseManuel?: Record<string, unknown>) => ({
    meta: {
      id: "math",
      nameFr: "الرياضيات",
      description: "d",
      attribute: "Force",
      colorToken: "subject-math",
      icon: "Calculator",
      displayOrder: 1,
      contentLanguage: "ar" as const,
      themeId: "ecole-tn",
      gradeSlug: "9eme-base",
      isPremium: false,
    },
    chapters: [
      {
        slug: "01-thales",
        meta: { title: "طاليس", description: "d", displayOrder: 1, sources: [], videos: [] },
        lesson: "# cours",
        summary: "## résumé",
        quiz: {
          questions: [
            {
              type: "mcq" as const,
              prompt: "q؟",
              options: [
                { id: "a", text: "1" },
                { id: "b", text: "2" },
              ],
              correctOption: "a",
              explanation: "ج",
            },
          ],
        },
        exercises: [
          {
            slug: "ex1",
            data: {
              title: "exo",
              difficulty: 1,
              mode: "practice" as const,
              xpReward: 50,
              rewardCoins: 10,
              displayOrder: 1,
              ...(exerciseManuel ? { manuel: exerciseManuel } : {}),
              questions: [
                {
                  type: "mcq" as const,
                  prompt: "2+2 ?",
                  options: [
                    { id: "a", text: "3" },
                    { id: "b", text: "4" },
                  ],
                  correctOption: "b",
                  explanation: "= 4",
                },
              ],
            },
          },
        ],
      },
    ],
  });

  it("compile la reprise, pages dépliées comme pour le chapitre", () => {
    const sql = buildMigrationSql(
      makeSubject({ code: "222104P01", pages: "68-69", items: ["ex. 12", "ex. 13"] }) as never,
      {},
    );
    expect(sql).toContain("source, display_order, correction_video, manuel_ref) VALUES");
    expect(sql).toContain("manuel_ref = EXCLUDED.manuel_ref");
    expect(sql).toContain('"code":"222104P01"');
    expect(sql).toContain('"pageNumbers":[68,69]');
    expect(sql).toContain('"items":["ex. 12","ex. 13"]');
  });

  it("omet `pages` quand la mission n'en déclare pas — jamais de plage inventée", () => {
    const sql = buildMigrationSql(makeSubject({ code: "X1", items: ["ex. 1"] }) as never, {});
    expect(sql).toContain('"code":"X1"');
    expect(sql).not.toContain('"pageNumbers"');
  });

  it("rend NULL sans reprise — et le quiz n'en porte JAMAIS", () => {
    const sql = buildMigrationSql(makeSubject() as never, {});
    // Deux lignes d'exercice (le quiz + la mission), toutes deux à NULL.
    expect(sql.match(/'admin', \d+, NULL, NULL\)/g)?.length).toBe(2);
  });

  it("le quiz reste NULL même quand la mission trace une reprise", () => {
    const sql = buildMigrationSql(makeSubject({ code: "X1", items: ["ex. 1"] }) as never, {});
    expect(sql).toMatch(/'admin', 0, NULL, NULL\)/); // display_order 0 = le quiz
  });
});

// -------------------------------------------------------------- le manifeste

describe("manifestChapterSchema — les trois profondeurs assumées", () => {
  const base = { slug: "04-thales", notion: "ثالس" };

  it("rien : la couverture sera « non mesurable »", () => {
    expect(manifestChapterSchema.safeParse(base).success).toBe(true);
  });

  it("un compte : la couverture sera un taux", () => {
    const r = manifestChapterSchema.safeParse({
      ...base,
      manuel: { code: "222104P01", pages: "60-71", exerciseCount: 24 },
    });
    expect(r.success).toBe(true);
  });

  it("des libellés : la couverture sera un diff nominal", () => {
    const r = manifestChapterSchema.safeParse({
      ...base,
      manuel: { code: "222104P01", exerciseItems: ["ex. 1", "ex. 2"] },
    });
    expect(r.success).toBe(true);
  });

  it("refuse un compte non positif — zéro exercice déclaré n'est pas une déclaration", () => {
    const r = manifestChapterSchema.safeParse({
      ...base,
      manuel: { code: "222104P01", exerciseCount: 0 },
    });
    expect(r.success).toBe(false);
  });
});

// ------------------------------------------------------------- la couverture

describe("normalizeItem — ce qu'on considère comme le même exercice", () => {
  it("absorbe casse, points et espaces", () => {
    expect(normalizeItem("Ex. 12")).toBe(normalizeItem("ex.12"));
    expect(normalizeItem(" ex .  12 ")).toBe(normalizeItem("ex. 12"));
  });

  it("ne confond PAS deux items voisins — « 15a » n'est pas « 15 »", () => {
    expect(normalizeItem("ex. 15a")).not.toBe(normalizeItem("ex. 15"));
  });
});

describe("chapterCoverage — les trois profondeurs, et ce qu'elles rendent", () => {
  const takenUp = [{ exerciseSlug: "05-manuel", code: "P01", items: ["ex. 12", "ex. 13"] }];

  it("sans déclaration : non mesurable, mais les reprises se comptent quand même", () => {
    const c = chapterCoverage({ slug: "04-thales", chapterManuelCode: "P01", takenUp });
    expect(c.precision).toBe("none");
    expect(c.takenUpCount).toBe(2);
    expect(c.declaredCount).toBeNull();
    expect(c.remaining).toBeNull();
    // Sans liste de référence, un item « inconnu » ne veut rien dire.
    expect(c.unknownItems).toEqual([]);
  });

  it("avec un compte : un taux, mais pas de nominal", () => {
    const c = chapterCoverage({
      slug: "04-thales",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseCount: 24 },
      takenUp,
    });
    expect(c.precision).toBe("count");
    expect(c.declaredCount).toBe(24);
    expect(c.remaining).toBeNull();
  });

  it("avec des libellés : le diff nominal de ce qui RESTE", () => {
    const c = chapterCoverage({
      slug: "04-thales",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseItems: ["ex. 12", "ex. 13", "ex. 14", "ex. 15"] },
      takenUp,
    });
    expect(c.precision).toBe("items");
    expect(c.takenUpCount).toBe(2);
    expect(c.declaredCount).toBe(4);
    expect(c.remaining).toEqual(["ex. 14", "ex. 15"]);
    expect(c.unknownItems).toEqual([]);
  });

  it("signale l'item tracé qui n'existe pas au manuel — typo bien plus probable", () => {
    const c = chapterCoverage({
      slug: "04-thales",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseItems: ["ex. 12"] },
      takenUp: [{ exerciseSlug: "05-manuel", code: "P01", items: ["ex. 12", "ex. 120"] }],
    });
    expect(c.unknownItems).toEqual(["ex. 120"]);
  });

  it("ne compte qu'UNE fois un exercice repris par deux missions", () => {
    const c = chapterCoverage({
      slug: "04-thales",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseItems: ["ex. 12", "ex. 13"] },
      takenUp: [
        { exerciseSlug: "05-manuel", code: "P01", items: ["ex. 12"] },
        { exerciseSlug: "06-boss", code: "P01", items: ["Ex.12", "ex. 13"] },
      ],
    });
    expect(c.takenUpCount).toBe(2);
    expect(c.remaining).toEqual([]);
  });

  it("relève R-9 : le chapitre ne déclare aucun manuel", () => {
    const c = chapterCoverage({ slug: "04-thales", takenUp: [] });
    expect(c.missingChapterManuel).toBe(true);
  });

  it("relève une mission qui parle d'un autre livre que le manifeste", () => {
    const c = chapterCoverage({
      slug: "04-thales",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseCount: 3 },
      takenUp: [{ exerciseSlug: "05-manuel", code: "P99", items: ["ex. 1"] }],
    });
    expect(c.codeMismatches).toEqual(["05-manuel"]);
  });
});

describe("subjectCoverage — l'agrégat, et le dénominateur honnête", () => {
  const chapters: ChapterCoverageInput[] = [
    {
      slug: "01",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseItems: ["ex. 1", "ex. 2"] },
      takenUp: [{ exerciseSlug: "a", code: "P01", items: ["ex. 1"] }],
    },
    {
      slug: "02",
      chapterManuelCode: "P01",
      declared: { code: "P01", exerciseCount: 8 },
      takenUp: [{ exerciseSlug: "b", code: "P01", items: ["ex. 3"] }],
    },
    // Non mesurable : rien n'est déclaré.
    { slug: "03", chapterManuelCode: "P01", takenUp: [] },
  ];

  it("agrège les reprises et ne met AU DÉNOMINATEUR que le mesurable", () => {
    const s = subjectCoverage("math-1ere-sec", chapters);
    expect(s.takenUpTotal).toBe(2);
    expect(s.declaredTotal).toBe(10); // 2 + 8 ; le chapitre 03 n'y entre pas
    expect(s.unmeasurable).toBe(1);
    expect(coverageRate(s)).toBe(20);
  });

  it("rend `null` — et pas 0 % — quand rien n'est mesurable", () => {
    // « La campagne n'a pas commencé » et « rien n'est déclaré » sont deux
    // états différents : les afficher pareil ferait passer une transcription
    // incomplète pour un retard de contenu.
    const s = subjectCoverage("math-1ere-sec", [
      { slug: "01", chapterManuelCode: "P01", takenUp: [] },
    ]);
    expect(coverageRate(s)).toBeNull();
  });
});

describe("L'INVARIANT de l'étude : la couverture est advisory", () => {
  it("le module ne produit aucun « finding » — il n'a pas de quoi", () => {
    // Ce test garde une DÉCISION, pas un calcul : la surface publique du module
    // ne doit jamais exposer de sévérité. Le jour où quelqu'un ajoute un
    // `severity: "error"` ici, ce test tombe et la conversation a lieu — c'est
    // exactement ce que §3.5 demande de protéger.
    const c = chapterCoverage({
      slug: "01",
      declared: { code: "P01", exerciseItems: ["ex. 1", "ex. 2"] },
      takenUp: [],
    });
    const keys = Object.keys(c);
    expect(keys).not.toContain("severity");
    expect(keys).not.toContain("level");
    expect(JSON.stringify(c)).not.toMatch(/"error"/);
    // Une couverture NULLE reste une couverture, pas une erreur.
    expect(c.takenUpCount).toBe(0);
    expect(c.remaining).toEqual(["ex. 1", "ex. 2"]);
  });
});

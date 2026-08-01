import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { misconceptionRegistrySchema, questionSchema } from "../schema.ts";
import {
  buildCompetencyRegistryMigrationSql,
  buildMigrationSql,
  buildMisconceptionRegistryMigrationSql,
} from "../sql-builder.ts";
import { ContentValidationError, loadMisconceptionRegistry } from "../loader.ts";

// Adaptive-engine A0.3 (étude 04): the server-only misconception tagging path —
// the zod field + the registry + sql-builder routing (tags → distractor_tags,
// STRIPPED from options). Split from content-pipeline.test.ts (max-lines cap).

const mcqBase = {
  type: "mcq" as const,
  prompt: "1/2 + 1/3 = ?",
  options: [
    { id: "a", text: "5/6" },
    { id: "b", text: "2/5", misconceptionTag: "math.frac.add-numerators-and-denominators" },
    { id: "c", text: "1/6" },
  ],
  correctOption: "a",
  explanation: "On réduit au même dénominateur : 3/6 + 2/6 = 5/6. 2/5 additionne à tort.",
};

describe("schema — misconceptionTag on mcq options", () => {
  it("accepts a distractor carrying a well-formed namespaced tag", () => {
    expect(questionSchema.safeParse(mcqBase).success).toBe(true);
  });

  it("rejects a free-text (non-namespaced) tag", () => {
    const bad = {
      ...mcqBase,
      options: [
        { id: "a", text: "5/6" },
        { id: "b", text: "2/5", misconceptionTag: "adds denominators" },
        { id: "c", text: "1/6" },
      ],
    };
    expect(questionSchema.safeParse(bad).success).toBe(false);
  });

  it("rejects a tag on the CORRECT option (a right answer has no misconception)", () => {
    const bad = {
      ...mcqBase,
      options: [
        { id: "a", text: "5/6", misconceptionTag: "math.frac.add-denominators" },
        { id: "b", text: "2/5" },
        { id: "c", text: "1/6" },
      ],
    };
    expect(questionSchema.safeParse(bad).success).toBe(false);
  });
});

describe("registry schema — content/misconceptions.json", () => {
  const entry = { subject: "math", labels: { fr: "f", en: "e", ar: "ا" } };

  it("accepts a namespaced id → {subject, trilingual labels}", () => {
    expect(
      misconceptionRegistrySchema.safeParse({ "math.frac.add-denominators": entry }).success,
    ).toBe(true);
  });

  it("rejects a non-namespaced key", () => {
    expect(misconceptionRegistrySchema.safeParse({ frac: entry }).success).toBe(false);
  });

  it("rejects an entry missing a language label", () => {
    expect(
      misconceptionRegistrySchema.safeParse({
        "math.frac.add-denominators": { subject: "math", labels: { fr: "f", en: "e" } },
      }).success,
    ).toBe(false);
  });
});

describe("sql-builder — tags routed server-side, stripped from options", () => {
  const buildOneMcq = (
    options: Array<{ id: string; text: string; misconceptionTag?: string }>,
    correctOption = "a",
  ) =>
    buildMigrationSql({
      meta: {
        id: "a0-subj",
        nameFr: "A0",
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
          slug: "01-a0",
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
              slug: "ex-a0",
              data: {
                title: "mcq",
                difficulty: 2,
                mode: "practice" as const,
                xpReward: 75,
                rewardCoins: 15,
                displayOrder: 1,
                questions: [
                  {
                    type: "mcq" as const,
                    prompt: "1/2 + 1/3 = ?",
                    options,
                    correctOption,
                    explanation: "explication assez longue pour passer la QA du contenu.",
                  },
                ],
              },
            },
          ],
        },
      ],
    });

  it("emits distractor_tags keyed by option id and drops the tag from options", () => {
    const sql = buildOneMcq([
      { id: "a", text: "5/6" },
      { id: "b", text: "2/5", misconceptionTag: "math.frac.add-numerators-and-denominators" },
      { id: "c", text: "1/6", misconceptionTag: "math.frac.add-denominators" },
    ]);
    // The server-only map carries both distractors.
    expect(sql).toContain(
      `'{"b":"math.frac.add-numerators-and-denominators","c":"math.frac.add-denominators"}'::jsonb`,
    );
    // options JSONB is stripped back to {id,text} — the tag never reaches the client.
    expect(sql).toContain(
      `'[{"id":"a","text":"5/6"},{"id":"b","text":"2/5"},{"id":"c","text":"1/6"}]'::jsonb`,
    );
    expect(sql).not.toContain("misconceptionTag");
  });

  it("emits distractor_tags NULL when no option is tagged", () => {
    const sql = buildOneMcq([
      { id: "a", text: "5/6" },
      { id: "b", text: "2/5" },
      { id: "c", text: "1/6" },
    ]);
    // The questions INSERT ends with question_type, answer_key, distractor_tags
    // and — since étude 20 lot 1 — the accepted-answer set (default '[]').
    expect(sql).toContain("'mcq', NULL, NULL, '[]'::jsonb)");
  });
});

describe("loadMisconceptionRegistry", () => {
  let dir: string;
  beforeAll(() => {
    dir = mkdtempSync(join(tmpdir(), "misc-registry-"));
  });
  afterAll(() => rmSync(dir, { recursive: true, force: true }));

  it("returns an empty registry when the file is absent (tagging is progressive)", () => {
    expect(loadMisconceptionRegistry(dir)).toEqual({});
  });

  it("throws a ContentValidationError on a malformed registry", () => {
    mkdirSync(dir, { recursive: true });
    writeFileSync(
      join(dir, "misconceptions.json"),
      JSON.stringify({ "not a tag": { subject: "math", labels: { fr: "f", en: "e", ar: "ا" } } }),
    );
    expect(() => loadMisconceptionRegistry(dir)).toThrow(ContentValidationError);
  });

  // The assertion on the REAL content/misconceptions.json moved to the private repo
  // with the corpus (étude 24, lot 3b): it guarded corpus integrity, not loader
  // behaviour, and `content:check` re-runs this very loader over the real registry
  // on every private PR. The loader itself stays covered by the fixtures above.
});

/**
 * Étude 04 lot A1.2b — le registre devient le vocabulaire que l'élève LIT.
 *
 * A1.2a rend un tag ; sans cette compilation, la correction n'a aucune phrase à
 * afficher. Le SQL produit voyage par le canal de contenu (`apply-content.yml`),
 * donc il doit être IDEMPOTENT et rejouable : c'est ce qui garantit qu'une
 * misconception mal formulée se corrige dans le registre, sans migration.
 */
describe("buildMisconceptionRegistryMigrationSql", () => {
  const registry = {
    "math.frac.add-denominators": {
      subject: "math",
      labels: {
        fr: "Tu additionnes les dénominateurs",
        en: "You add the denominators",
        ar: "تجمع المقامات",
      },
    },
    "math.dec.compare-by-length": {
      subject: "math",
      labels: {
        fr: "Tu compares par la longueur",
        en: "You compare by length",
        ar: "تقارن بالطول",
      },
    },
  };

  it("écrit les trois langues de chaque tag", () => {
    const sql = buildMisconceptionRegistryMigrationSql(registry);
    expect(sql).toContain("INSERT INTO public.misconceptions");
    expect(sql).toContain("Tu additionnes les dénominateurs");
    expect(sql).toContain("You add the denominators");
    expect(sql).toContain("تجمع المقامات");
  });

  it("est REJOUABLE : un upsert, pas un insert qui casserait au second passage", () => {
    const sql = buildMisconceptionRegistryMigrationSql(registry);
    expect(sql).toContain("ON CONFLICT (tag) DO UPDATE SET");
    expect(sql).toContain("label_fr = EXCLUDED.label_fr");
  });

  it("purge ce que le registre ne déclare plus (dépréciation, jamais renommage)", () => {
    const sql = buildMisconceptionRegistryMigrationSql(registry);
    expect(sql).toContain("DELETE FROM public.misconceptions WHERE tag NOT IN (");
    // …mais jamais nue : la purge est gardée (voir la suite dédiée plus bas).
    expect(sql).toContain("PURGE REFUSÉE");
    expect(sql).toContain("'math.frac.add-denominators'");
  });

  it("est DÉTERMINISTE : deux appels rendent le même SQL, ordre des clés compris", () => {
    const reversed = {
      "math.dec.compare-by-length": registry["math.dec.compare-by-length"],
      "math.frac.add-denominators": registry["math.frac.add-denominators"],
    };
    expect(buildMisconceptionRegistryMigrationSql(reversed)).toBe(
      buildMisconceptionRegistryMigrationSql(registry),
    );
  });

  it("un registre VIDE n'émet aucun DELETE — « rien à dire » n'est pas « tout effacer »", () => {
    const sql = buildMisconceptionRegistryMigrationSql({});
    expect(sql).not.toContain("DELETE");
    expect(sql).not.toContain("INSERT");
  });

  it("échappe les apostrophes plutôt que de casser le SQL", () => {
    const sql = buildMisconceptionRegistryMigrationSql({
      "math.x.y": {
        subject: "math",
        labels: { fr: "Tu confonds l'aire et l'périmètre", en: "e", ar: "ا" },
      },
    });
    expect(sql).toContain("'Tu confonds l''aire et l''périmètre'");
  });
});

/**
 * La garde fail-closed des purges de registre.
 *
 * Le SQL d'un registre CONVERGE la base vers le fichier : il upserte ce qui est
 * déclaré et efface ce qui ne l'est plus. Correct tant que le fichier est intact,
 * catastrophique sinon — et `apply-content.yml` appliquerait la purge sans
 * broncher : idempotente, journalisée, irréprochable, destructrice.
 *
 * Le danger n'est pas théorique et il a été mesuré sur un Postgres réel : avec
 * 20 compétences et 1 362 mappings question → compétence (l'état d'après C4), un
 * registre tronqué à 3 compétences effaçait **les 1 362 mappings** par cascade FK.
 * Toute la campagne de tagging, en un `workflow_dispatch` de routine.
 */
describe("garde fail-closed des purges de registre", () => {
  const misconceptions = (n: number) =>
    Object.fromEntries(
      Array.from({ length: n }, (_, i) => [
        `math.dom.t${i}`,
        { subject: "math", labels: { fr: "f", en: "e", ar: "ا" } },
      ]),
    );

  it("compte les condamnés AVANT d'effacer, et refuse au-delà du seuil", () => {
    const sql = buildMisconceptionRegistryMigrationSql(misconceptions(3));
    // L'ordre compte : compter après avoir effacé ne garde rien.
    expect(sql.indexOf("INTO v_doomed")).toBeLessThan(
      sql.indexOf("DELETE FROM public.misconceptions"),
    );
    expect(sql).toContain("RAISE EXCEPTION");
  });

  it("laisse passer une base VIDE — un premier `apply` n'est pas une purge", () => {
    const sql = buildMisconceptionRegistryMigrationSql(misconceptions(3));
    // La garde ne mord que si le périmètre existe déjà.
    expect(sql).toContain("IF v_scope > 0 AND");
  });

  it("nomme les DEUX nombres dans le refus — un refus muet se contourne au hasard", () => {
    const sql = buildMisconceptionRegistryMigrationSql(misconceptions(3));
    expect(sql).toContain("v_doomed, v_scope");
    expect(sql).toMatch(/% lignes sur %/);
  });

  it("dit la casse COLLATÉRALE, qui est le vrai motif de la garde", () => {
    const comp = buildCompetencyRegistryMigrationSql([
      {
        family: "math",
        subjectPrefixes: ["math"],
        competencies: [{ id: "math.dom.a", labels: { fr: "f", en: "e", ar: "ا" }, prereqs: [] }],
      },
    ]);
    expect(comp).toContain("question_competencies");
    expect(comp).toContain("CASCADE");
  });

  it("échappe les apostrophes du message — sinon le fichier ne compile plus", () => {
    // « qu'ils nomment » terminait la chaîne SQL : attrapé à l'exécution, pas à
    // la relecture. Le SQL doit porter l'apostrophe DOUBLÉE.
    const sql = buildMisconceptionRegistryMigrationSql(misconceptions(3));
    expect(sql).toContain("qu''ils nomment");
    expect(sql).not.toMatch(/[^']'ils nomment/);
  });

  it("garde AUSSI le registre des compétences, pas seulement le vocabulaire", () => {
    const sql = buildCompetencyRegistryMigrationSql([
      {
        family: "math",
        subjectPrefixes: ["math"],
        competencies: [{ id: "math.dom.a", labels: { fr: "f", en: "e", ar: "ا" }, prereqs: [] }],
      },
    ]);
    expect(sql).toContain("PURGE REFUSÉE");
    expect(sql).toContain("v_doomed::numeric / v_scope");
  });
});

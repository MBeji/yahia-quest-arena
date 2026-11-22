// @vitest-environment node
import { describe, it, expect } from "vitest";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { mockExamEntrySchema, mockExamRegistrySchema, type MockExamEntry } from "../schema.ts";
import {
  ContentValidationError,
  findMockExamIssues,
  loadMockExamRegistry,
  type MockExamCorpusSubject,
} from "../loader.ts";
import {
  MOCK_EXAMS_SQL_FILE_NAME,
  buildMockExamRegistrySql,
  exerciseId,
  mockExamId,
} from "../sql-builder.ts";
import { MOCK_EXAM_FIXTURE_V1, MOCK_EXAM_FIXTURE_V2 } from "./mock-exam-registry.fixture.ts";

/**
 * Étude 02, suite (2026-11-22) — les examens blancs composés par le corpus.
 *
 * Trois couches du pipeline : le schéma du registre (`content/mock-exams.json`),
 * le contrôle croisé avec les sujets chargés, et le SQL compilé. La quatrième —
 * ce que ce SQL fait vraiment à une base — est jouée par
 * `supabase/tests/115_mock_exams_from_corpus.test.sql`, et le dernier bloc de ce
 * fichier garantit que les deux parlent du MÊME SQL.
 */

const here = dirname(fileURLToPath(import.meta.url));
const PGTAP_FILE = resolve(here, "../../../../supabase/tests/115_mock_exams_from_corpus.test.sql");

const label = { fr: "Épreuve", en: "Paper", ar: "اختبار" };

const entry = (over: Partial<MockExamEntry> = {}): MockExamEntry => ({
  parcours: "concours-9eme",
  subject: "french",
  title: { fr: "Français — épreuve n° 1", en: "French — paper 1", ar: "الفرنسية — اختبار 1" },
  durationMinutes: 60,
  displayOrder: 110,
  papers: [
    { exercise: "french/10-annales/04-comprehension", label, points: 70 },
    { exercise: "french/10-annales/05-langue", label, points: 60 },
  ],
  ...over,
});

const corpus: MockExamCorpusSubject[] = [
  {
    meta: { id: "french" },
    chapters: [
      { slug: "10-annales", exercises: [{ slug: "04-comprehension" }, { slug: "05-langue" }] },
    ],
  },
];

describe("mock-exam registry — schema", () => {
  it("accepte une épreuve de matière bien formée", () => {
    expect(mockExamEntrySchema.safeParse(entry()).success).toBe(true);
  });

  it("accepte un blanc multi-matières : sans `subject`, les épreuves viennent d'où elles veulent", () => {
    const multi = entry({
      subject: undefined,
      papers: [
        { exercise: "french/10-annales/04-comprehension", label, points: 30 },
        { exercise: "math/14-annales/01-sujet", label, points: 40 },
      ],
    });
    expect(mockExamEntrySchema.safeParse(multi).success).toBe(true);
  });

  it("refuse une épreuve hors de la matière déclarée — `subject` engage", () => {
    const mixed = entry({
      papers: [
        { exercise: "french/10-annales/04-comprehension", label, points: 70 },
        { exercise: "math/14-annales/01-sujet", label, points: 60 },
      ],
    });
    const result = mockExamEntrySchema.safeParse(mixed);
    expect(result.success).toBe(false);
    expect(JSON.stringify(result.error?.issues)).toContain("not in subject 'french'");
  });

  it("refuse deux fois le même exercice — la clé primaire le refuserait en base, trop tard", () => {
    const twice = entry({
      papers: [
        { exercise: "french/10-annales/04-comprehension", label, points: 70 },
        { exercise: "french/10-annales/04-comprehension", label, points: 60 },
      ],
    });
    expect(mockExamEntrySchema.safeParse(twice).success).toBe(false);
  });

  it("refuse une référence qui n'est pas <sujet>/<chapitre>/<exercice>", () => {
    for (const exercise of ["french/04-comprehension", "french/10/04/extra", "French/10/04", ""]) {
      const bad = entry({ papers: [{ exercise, label, points: 10 }] });
      expect(mockExamEntrySchema.safeParse(bad).success, exercise).toBe(false);
    }
  });

  it("tient les bornes de durée du CHECK de la base (15 à 300 minutes)", () => {
    expect(mockExamEntrySchema.safeParse(entry({ durationMinutes: 14 })).success).toBe(false);
    expect(mockExamEntrySchema.safeParse(entry({ durationMinutes: 301 })).success).toBe(false);
    expect(mockExamEntrySchema.safeParse(entry({ durationMinutes: 120 })).success).toBe(true);
  });

  it("refuse un barème nul, décimal ou sans épreuve", () => {
    const withPoints = (points: number) =>
      entry({ papers: [{ exercise: "french/10-annales/04-comprehension", label, points }] });
    expect(mockExamEntrySchema.safeParse(withPoints(0)).success).toBe(false);
    expect(mockExamEntrySchema.safeParse(withPoints(3.5)).success).toBe(false);
    expect(mockExamEntrySchema.safeParse(entry({ papers: [] })).success).toBe(false);
  });

  it("exige les trois langues du titre et de chaque libellé", () => {
    const untitled = { ...entry(), title: { fr: "Français", en: "French" } };
    expect(mockExamEntrySchema.safeParse(untitled).success).toBe(false);
  });

  it("refuse un champ inconnu — une faute de frappe ne passe pas pour une option", () => {
    expect(mockExamEntrySchema.safeParse({ ...entry(), duration: 60 }).success).toBe(false);
  });

  it("refuse un slug d'examen hors kebab-case", () => {
    expect(mockExamRegistrySchema.safeParse({ "Français 1": entry() }).success).toBe(false);
    expect(mockExamRegistrySchema.safeParse({ "francais-9eme-1": entry() }).success).toBe(true);
  });
});

describe("mock-exam registry — loader", () => {
  it("rend un registre vide quand le fichier n'existe pas : un corpus sans examen est légitime", () => {
    const dir = mkdtempSync(join(tmpdir(), "mock-exams-"));
    try {
      expect(loadMockExamRegistry(dir)).toEqual({});
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("charge un registre valide", () => {
    const dir = mkdtempSync(join(tmpdir(), "mock-exams-"));
    try {
      writeFileSync(join(dir, "mock-exams.json"), JSON.stringify({ "francais-9eme-1": entry() }));
      expect(Object.keys(loadMockExamRegistry(dir))).toEqual(["francais-9eme-1"]);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });

  it("échoue sur un registre mal formé, en nommant le fichier", () => {
    const dir = mkdtempSync(join(tmpdir(), "mock-exams-"));
    try {
      writeFileSync(join(dir, "mock-exams.json"), JSON.stringify({ "francais-9eme-1": {} }));
      expect(() => loadMockExamRegistry(dir)).toThrow(ContentValidationError);
      expect(() => loadMockExamRegistry(dir)).toThrow(/mock-exams\.json/);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
});

describe("mock-exam registry — contrôle croisé avec le corpus", () => {
  it("ne dit rien quand chaque épreuve désigne un exercice qui existe", () => {
    expect(findMockExamIssues({ "francais-9eme-1": entry() }, corpus)).toEqual([]);
  });

  it("nomme l'exercice absent — sinon l'INSERT compilé n'écrirait rien, en silence", () => {
    const registry = {
      "francais-9eme-1": entry({
        papers: [{ exercise: "french/10-annales/06-production", label, points: 70 }],
      }),
    };
    expect(findMockExamIssues(registry, corpus)).toEqual([
      "francais-9eme-1: 'french/10-annales/06-production' — no exercise '06-production' in 'french/10-annales'",
    ]);
  });

  it("nomme le chapitre absent", () => {
    const registry = {
      "francais-9eme-1": entry({
        papers: [{ exercise: "french/11-ailleurs/04-comprehension", label, points: 70 }],
      }),
    };
    expect(findMockExamIssues(registry, corpus)[0]).toContain("no chapter '11-ailleurs'");
  });

  it("nomme la matière inconnue quand tout le corpus est chargé", () => {
    const registry = {
      "blanc-1": entry({
        subject: undefined,
        papers: [{ exercise: "math/14-annales/01-sujet", label, points: 40 }],
      }),
    };
    expect(findMockExamIssues(registry, corpus)[0]).toContain("unknown subject 'math'");
  });

  it("en mode `--subject`, ne juge pas une matière qui n'est pas chargée", () => {
    const registry = {
      "blanc-1": entry({
        subject: undefined,
        papers: [
          { exercise: "math/14-annales/01-sujet", label, points: 40 },
          { exercise: "french/10-annales/06-production", label, points: 30 },
        ],
      }),
    };
    // La matière absente est tue ; l'exercice absent d'une matière CHARGÉE reste une faute.
    expect(findMockExamIssues(registry, corpus, { partial: true })).toEqual([
      "blanc-1: 'french/10-annales/06-production' — no exercise '06-production' in 'french/10-annales'",
    ]);
  });
});

describe("buildMockExamRegistrySql", () => {
  const sql = buildMockExamRegistrySql(MOCK_EXAM_FIXTURE_V1);

  it("voyage sous un nom de fichier stable, à côté des autres registres", () => {
    expect(MOCK_EXAMS_SQL_FILE_NAME).toBe("_mock_exams_registry.sql");
  });

  it("dérive l'identité de l'examen de son seul slug — les copies des élèves y pendent", () => {
    expect(mockExamId("fixture-epreuve-langue-1")).toBe(mockExamId("fixture-epreuve-langue-1"));
    expect(mockExamId("fixture-epreuve-langue-1")).not.toBe(mockExamId("fixture-epreuve-langue-2"));
    expect(sql).toContain(`'${mockExamId("fixture-epreuve-langue-1")}'::uuid`);
  });

  it("désigne chaque épreuve par l'UUIDv5 que le sujet a écrit en base", () => {
    expect(sql).toContain(exerciseId("exam-reg-a", "01-chapitre", "04-comprehension"));
    expect(sql).toContain(exerciseId("exam-reg-b", "01-chapitre", "01-calcul"));
  });

  it("n'écrit une épreuve que si son exercice est en base (JOIN, jamais une FK qui casse)", () => {
    expect(sql).toMatch(/JOIN public\.exercises x ON x\.id = d\.exercise_id/);
  });

  it("ne publie qu'un examen COMPLET, et le repasse brouillon sinon", () => {
    expect(sql).toMatch(/= d\.expected\s+THEN 'published'\s+ELSE 'draft'/);
  });

  it("archive ce qu'il ne déclare plus, sans jamais supprimer un examen", () => {
    expect(sql).toContain("SET status = 'archived'");
    expect(sql).toContain("WHERE slug IS NOT NULL");
    expect(sql).not.toMatch(/DELETE FROM public\.mock_exams\b(?!_)/);
    expect(sql).not.toMatch(/DELETE FROM public\.mock_exam_sessions/);
  });

  it("ne retire des épreuves qu'aux examens encore déclarés — un archivé garde les siennes", () => {
    const del = sql.slice(sql.indexOf("DELETE FROM public.mock_exam_papers"));
    expect(del.slice(0, del.indexOf(";"))).toContain("pp.exam_id IN (");
  });

  it("pose la matière en NULL typé pour un blanc multi-matières", () => {
    expect(sql).toContain("NULL::text");
    expect(sql).toContain("'exam-reg-a'::text");
  });

  it("double les apostrophes des titres — sinon le fichier ne compile plus", () => {
    expect(sql).toContain("'Épreuve de l''élève'");
    expect(sql).toContain("'The student''s paper'");
  });

  it("est déterministe : l'ordre des clés du registre ne change pas le fichier", () => {
    const reversed = Object.fromEntries(Object.entries(MOCK_EXAM_FIXTURE_V1).reverse());
    expect(buildMockExamRegistrySql(reversed)).toBe(sql);
  });

  it("un registre vide n'écrit rien et n'archive rien", () => {
    const empty = buildMockExamRegistrySql({});
    expect(empty).not.toMatch(/^\s*(INSERT|UPDATE|DELETE)/m);
  });
});

describe("le SQL rejoué par pgTAP est celui que le constructeur génère", () => {
  const pgtap = readFileSync(PGTAP_FILE, "utf8");
  const block = (tag: string): string => {
    const open = `AS $${tag}$\n`;
    const start = pgtap.indexOf(open);
    const end = pgtap.indexOf(`\n$${tag}$;`);
    expect(start, `bloc ${tag} introuvable dans le test pgTAP`).toBeGreaterThan(-1);
    expect(end).toBeGreaterThan(start);
    return pgtap.slice(start + open.length, end);
  };

  it("bloc gen_v1 = buildMockExamRegistrySql(fixture v1)", () => {
    expect(block("gen_v1")).toBe(buildMockExamRegistrySql(MOCK_EXAM_FIXTURE_V1).trimEnd());
  });

  it("bloc gen_v2 = buildMockExamRegistrySql(fixture v2)", () => {
    expect(block("gen_v2")).toBe(buildMockExamRegistrySql(MOCK_EXAM_FIXTURE_V2).trimEnd());
  });
});

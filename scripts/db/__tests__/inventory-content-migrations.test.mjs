import { describe, it, expect } from "vitest";
import {
  CONSTRAINT_GUARD,
  classifyMigration,
  ddlKind,
  groupByKind,
  stripComments,
  tablesTouched,
} from "../inventory-content-migrations.mjs";

/** The idempotent guard every generated content migration embeds, verbatim. */
const GUARD_SQL = `
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'exercises_mode_check') THEN
    ALTER TABLE public.exercises DROP CONSTRAINT exercises_mode_check;
  END IF;
  ALTER TABLE public.exercises
    ADD CONSTRAINT exercises_mode_check CHECK (mode IN ('practice', 'boss', 'quiz', 'challenge'));
END $$;
`;

describe("tablesTouched", () => {
  it("finds inserted, deleted and updated tables", () => {
    const sql = `
      INSERT INTO public.questions (id) VALUES ('x');
      DELETE FROM public.dungeon_run_questions WHERE question_id = 'x';
      UPDATE public.chapters SET title = 'y';
    `;
    expect(tablesTouched(sql)).toEqual(["chapters", "dungeon_run_questions", "questions"]);
  });

  it("reads a table with or without the public schema prefix", () => {
    expect(tablesTouched("INSERT INTO questions (id) VALUES (1);")).toEqual(["questions"]);
  });

  it("ignores `FOR UPDATE USING` in an RLS policy", () => {
    const sql = `CREATE POLICY p ON public.profiles FOR UPDATE USING (auth.uid() = id);`;
    expect(tablesTouched(sql)).toEqual([]);
  });

  it("ignores the `DO UPDATE SET` of an upsert — it names no table", () => {
    const sql = `
      INSERT INTO public.subjects (id) VALUES ('math')
      ON CONFLICT (id) DO UPDATE SET name_fr = EXCLUDED.name_fr;
    `;
    expect(tablesTouched(sql)).toEqual(["subjects"]);
  });

  it("does not read prose in a comment as SQL", () => {
    const sql = `-- users can update their own row\nINSERT INTO public.questions (id) VALUES (1);`;
    expect(tablesTouched(sql)).toEqual(["questions"]);
  });
});

describe("stripComments", () => {
  it("removes line comments but keeps the statements", () => {
    expect(stripComments("SELECT 1; -- a note\nSELECT 2;")).toContain("SELECT 2;");
    expect(stripComments("SELECT 1; -- a note\nSELECT 2;")).not.toContain("a note");
  });
});

describe("ddlKind", () => {
  it("reports none for pure DML", () => {
    expect(ddlKind("INSERT INTO public.questions (id) VALUES (1);")).toBe("none");
  });

  it("recognises the embedded constraint guard as its own category", () => {
    expect(ddlKind(GUARD_SQL)).toBe("constraint-guard");
    expect(GUARD_SQL).toContain(CONSTRAINT_GUARD);
  });

  it("reports real schema evolution as schema", () => {
    expect(ddlKind("CREATE TABLE public.foo (id uuid primary key);")).toBe("schema");
    expect(ddlKind("DROP FUNCTION public.bar();")).toBe("schema");
  });

  it("does not let the guard mask a real DDL statement in the same file", () => {
    expect(ddlKind(`${GUARD_SQL}\nCREATE TABLE public.foo (id uuid);`)).toBe("schema");
  });
});

describe("classifyMigration", () => {
  const generated = "20260602141000_generated_math_content.sql";
  const contentSql = `${GUARD_SQL}\nINSERT INTO public.questions (id) VALUES (1);`;

  it("classifies a pipeline-generated migration as revocable content", () => {
    const e = classifyMigration(generated, contentSql);
    expect(e.kind).toBe("content-generated");
    expect(e.version).toBe("20260602141000");
    expect(e.foreignTables).toEqual([]);
  });

  it("classifies the generated competency registry as content too", () => {
    const sql = "INSERT INTO public.competencies (id) VALUES (1);";
    const e = classifyMigration("20260711120000_generated_competences_registry.sql", sql);
    expect(e.kind).toBe("content-generated");
    expect(e.foreignTables).toEqual([]);
  });

  it("classifies a hand-written content migration as legacy, never as generated", () => {
    const e = classifyMigration("20260526200000_complete_math_program.sql", contentSql);
    expect(e.kind).toBe("content-legacy");
  });

  it("surfaces non-content seeds that make a bulk revert unsafe", () => {
    const sql = `
      INSERT INTO public.questions (id) VALUES (1);
      INSERT INTO public.badges (id) VALUES (2);
      INSERT INTO public.shop_items (id) VALUES (3);
    `;
    const e = classifyMigration("20260522170000_seed_content.sql", sql);
    expect(e.kind).toBe("content-legacy");
    expect(e.foreignTables).toEqual(["badges", "shop_items"]);
  });

  it("treats cascade and compiler-output tables as content, not as foreign", () => {
    const sql = `
      INSERT INTO public.questions (id) VALUES (1);
      INSERT INTO public.question_competencies (question_id) VALUES (1);
      DELETE FROM public.dungeon_run_questions WHERE question_id = 1;
    `;
    expect(classifyMigration(generated, sql).foreignTables).toEqual([]);
  });

  it("leaves a schema migration out of the content channel", () => {
    const sql = "CREATE TABLE public.duels (id uuid primary key);";
    const e = classifyMigration("20260610120000_duels.sql", sql);
    expect(e.kind).toBe("schema-ops");
  });
});

describe("groupByKind", () => {
  it("splits entries into the three buckets", () => {
    const entries = [
      { kind: "content-generated" },
      { kind: "content-generated" },
      { kind: "content-legacy" },
      { kind: "schema-ops" },
    ];
    const groups = groupByKind(entries);
    expect(groups["content-generated"]).toHaveLength(2);
    expect(groups["content-legacy"]).toHaveLength(1);
    expect(groups["schema-ops"]).toHaveLength(1);
  });
});

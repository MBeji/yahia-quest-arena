import { describe, it, expect } from "vitest";
import {
  CONTENT_FKS,
  splitStatements,
  splitTopLevelCommas,
  literalOf,
  parseContentInsert,
  replayMigrations,
  summarizeOrphans,
  parseFixtureInsert,
  findFixtureCollisions,
  findDuplicateVersions,
} from "../check-migration-chain.mjs";

/** The one INSERT that seeds the five real subjects, shortened. */
const SEED_SUBJECTS = `
INSERT INTO public.subjects (id, name_fr, description, attribute, color_token, icon, display_order) VALUES
  ('math', 'Mathématiques', 'Algèbre', 'Force', 'subject-math', 'Calculator', 1),
  ('french', 'Français', 'Grammaire', 'Sagesse', 'subject-french', 'BookOpen', 2)
ON CONFLICT (id) DO NOTHING;
`;

describe("splitStatements", () => {
  it("splits on top-level semicolons and drops comments", () => {
    const out = splitStatements("SELECT 1; -- a comment\nSELECT 2;\n/* block */ SELECT 3;");
    expect(out).toHaveLength(3);
    expect(out[1]).toBe("SELECT 2");
    expect(out[2].trim()).toBe("SELECT 3");
  });

  it("keeps a semicolon that lives INSIDE a literal", () => {
    // French coordinate notation in an Arabic prompt — 20260604190000.
    const out = splitStatements("INSERT INTO t VALUES ('A(1 ; 2) وB(5 ; 8)');");
    expect(out).toHaveLength(1);
    expect(out[0]).toContain("A(1 ; 2)");
  });

  it("treats `--` inside a literal as data, not a comment", () => {
    // Markdown horizontal rules inside lesson_content — 40+ in 20260526200000.
    const out = splitStatements("INSERT INTO t VALUES ('line\n---\nnext');");
    expect(out).toHaveLength(1);
    expect(out[0]).toContain("---");
  });

  it("handles the doubled-quote escape without ending the string", () => {
    const out = splitStatements("INSERT INTO t VALUES ('C''est le héros; vraiment');");
    expect(out).toHaveLength(1);
    expect(out[0]).toContain("C''est");
  });

  it("does NOT treat LaTeX `$$` inside a literal as a dollar-quote", () => {
    // The trap: 66 `$$` in the content files are display-math delimiters sitting
    // inside literals. A scanner that matched `$$` before string state would
    // swallow the rest of the file and see one statement instead of two.
    const sql = "INSERT INTO t VALUES ('$$a+b$$');\nINSERT INTO u VALUES ('x');";
    const out = splitStatements(sql);
    expect(out).toHaveLength(2);
    expect(out[1]).toContain("INSERT INTO u");
  });

  it("still honours a REAL dollar-quoted body outside a literal", () => {
    const sql =
      "CREATE FUNCTION f() RETURNS void AS $$ BEGIN; END; $$ LANGUAGE plpgsql;\nSELECT 1;";
    const out = splitStatements(sql);
    expect(out).toHaveLength(2);
    expect(out[0]).toContain("BEGIN; END;");
  });

  it("does not swallow the file on an unterminated dollar tag", () => {
    const out = splitStatements("SELECT $tag$ never closed; SELECT 2;");
    expect(out.length).toBeGreaterThan(1);
  });

  it("keeps a multi-line literal in one statement", () => {
    const out = splitStatements(`INSERT INTO t VALUES ('${"line\n".repeat(400)}');`);
    expect(out).toHaveLength(1);
  });
});

describe("splitTopLevelCommas / literalOf", () => {
  it("ignores commas nested in a JSON literal", () => {
    const parts = splitTopLevelCommas(`'id', '[{"id":"a","text":"8"}]', 'a', 1`);
    expect(parts).toHaveLength(4);
    expect(parts[1]).toContain('"text":"8"');
  });

  it("unescapes a doubled quote and tolerates a trailing cast", () => {
    expect(literalOf("'C''est'")).toBe("C'est");
    expect(literalOf("'abc'::uuid")).toBe("abc");
  });

  it("returns null for an expression it cannot evaluate statically", () => {
    expect(literalOf("gen_random_uuid()")).toBeNull();
    expect(literalOf("v.id")).toBeNull();
  });
});

describe("parseContentInsert", () => {
  it("reads a plain VALUES insert and its header columns", () => {
    const [stmt] = splitStatements(SEED_SUBJECTS);
    const parsed = parseContentInsert(stmt);
    expect(parsed.table).toBe("subjects");
    expect(parsed.columns[0]).toBe("id");
    expect(parsed.rows).toHaveLength(2);
    expect(parsed.guarded).toBe(false);
  });

  it("ignores an INSERT into a non-content table", () => {
    const [stmt] = splitStatements("INSERT INTO public.attempts (id, user_id) VALUES ('a', 'b');");
    expect(parseContentInsert(stmt)).toBeNull();
  });

  it("takes tuple columns from the `AS v(…)` alias, not the INSERT header", () => {
    // Shape B: the header names TARGET columns, the alias names the tuple
    // fields — and only the alias is what WHERE EXISTS references.
    const sql = `
      INSERT INTO public.exercises (id, chapter_id, subject_id, title)
      SELECT v.id::uuid, v.chapter_id::uuid, v.subject_id, v.title
      FROM (VALUES ('e1', 'c1', 'french', 'T')) AS v(id, chapter_id, subject_id, title)
      WHERE EXISTS (SELECT 1 FROM public.chapters p WHERE p.id = v.chapter_id::uuid)
        AND EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id)
      ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title;`;
    const [stmt] = splitStatements(sql);
    const parsed = parseContentInsert(stmt);
    expect(parsed.columns).toEqual(["id", "chapter_id", "subject_id", "title"]);
    expect(parsed.guarded).toBe(true);
    expect(parsed.guards).toEqual([
      { parent: "chapters", column: "chapter_id" },
      { parent: "subjects", column: "subject_id" },
    ]);
  });

  it("finds the guard even though ON CONFLICT follows it", () => {
    // The guard is NOT the tail of the statement — a parser that cut at the
    // end would still have to look past `ON CONFLICT … DO UPDATE SET`.
    const sql = `
      INSERT INTO public.questions (id, exercise_id)
      SELECT v.id::uuid, v.exercise_id::uuid
      FROM (VALUES ('q1', 'e1')) AS v(id, exercise_id)
      WHERE EXISTS (SELECT 1 FROM public.exercises e WHERE e.id = v.exercise_id::uuid)
      ON CONFLICT (id) DO UPDATE SET exercise_id = EXCLUDED.exercise_id;`;
    const [stmt] = splitStatements(sql);
    expect(parseContentInsert(stmt).guards).toEqual([
      { parent: "exercises", column: "exercise_id" },
    ]);
  });

  it("marks a NOT EXISTS guard opaque rather than guessing its polarity", () => {
    const sql = `
      INSERT INTO public.chapters (id, subject_id)
      SELECT v.id::uuid, v.subject_id
      FROM (VALUES ('c1', 'math')) AS v(id, subject_id)
      WHERE NOT EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id);`;
    const [stmt] = splitStatements(sql);
    const parsed = parseContentInsert(stmt);
    expect(parsed.opaque).toBe(true);
    expect(parsed.guards).toEqual([]);
  });
});

describe("replayMigrations", () => {
  const file = (sql, name = "supabase/migrations/20260101000000_x.sql") => ({ file: name, sql });

  it("accepts a chain whose parents are created first", () => {
    const { created, orphans } = replayMigrations([
      file(SEED_SUBJECTS),
      file(
        `INSERT INTO public.chapters (id, subject_id, title) VALUES ('c1', 'math', 'T');
         INSERT INTO public.exercises (id, chapter_id, subject_id, title) VALUES ('e1', 'c1', 'math', 'T');
         INSERT INTO public.questions (exercise_id, prompt) VALUES ('e1', 'p');`,
      ),
    ]);
    expect(orphans).toEqual([]);
    expect(created.chapters.has("c1")).toBe(true);
    expect(created.exercises.has("e1")).toBe(true);
  });

  it("flags the #548 breakage: a question whose exercise never existed", () => {
    const { orphans } = replayMigrations([
      file(SEED_SUBJECTS),
      file(
        `INSERT INTO public.questions (exercise_id, prompt) VALUES ('5680c5e9-gone', 'ما قيمة √64 ؟');`,
        "supabase/migrations/20260604140000_content_quality_pass_delta.sql",
      ),
    ]);
    expect(orphans).toHaveLength(1);
    expect(orphans[0]).toMatchObject({
      table: "questions",
      column: "exercise_id",
      parent: "exercises",
      value: "5680c5e9-gone",
    });
  });

  it("flags the #552 breakage: a chapter on a subject the repo no longer seeds", () => {
    const { orphans } = replayMigrations([
      file(SEED_SUBJECTS),
      file(
        `INSERT INTO public.chapters (id, subject_id, title) VALUES ('c9', 'sciences-vie-terre', 'T');`,
      ),
    ]);
    expect(orphans).toHaveLength(1);
    expect(orphans[0]).toMatchObject({ column: "subject_id", value: "sciences-vie-terre" });
  });

  it("respects chain order — a parent created LATER does not save an earlier child", () => {
    const { orphans } = replayMigrations([
      file(SEED_SUBJECTS),
      file(
        `INSERT INTO public.exercises (id, chapter_id, subject_id) VALUES ('e1', 'c1', 'math');`,
      ),
      file(`INSERT INTO public.chapters (id, subject_id) VALUES ('c1', 'math');`),
    ]);
    expect(orphans).toHaveLength(1);
    expect(orphans[0].column).toBe("chapter_id");
  });

  it("stays silent on a guarded INSERT whose parent is missing", () => {
    // This is the whole point of the #548/#552 fixes: the row is simply not
    // inserted on a blank DB, so it can never violate the FK.
    const { orphans, created } = replayMigrations([
      file(SEED_SUBJECTS),
      file(`
        INSERT INTO public.chapters (id, subject_id, title)
        SELECT v.id::uuid, v.subject_id, v.title
        FROM (VALUES ('c9', 'sciences-vie-terre', 'T')) AS v(id, subject_id, title)
        WHERE EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id);`),
    ]);
    expect(orphans).toEqual([]);
    expect(created.chapters.has("c9")).toBe(false);
  });

  it("EVALUATES the guard: a guarded row whose parent exists is created", () => {
    const { orphans, created } = replayMigrations([
      file(SEED_SUBJECTS),
      file(`
        INSERT INTO public.chapters (id, subject_id, title)
        SELECT v.id::uuid, v.subject_id, v.title
        FROM (VALUES ('c1', 'math', 'T'), ('c9', 'sciences-vie-terre', 'T')) AS v(id, subject_id, title)
        WHERE EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id);`),
    ]);
    expect(orphans).toEqual([]);
    expect(created.chapters.has("c1")).toBe(true);
    expect(created.chapters.has("c9")).toBe(false);
  });

  it("cascades: a child guarded on a row the guard already dropped stays silent", () => {
    const { orphans, created } = replayMigrations([
      file(SEED_SUBJECTS),
      file(`
        INSERT INTO public.chapters (id, subject_id)
        SELECT v.id::uuid, v.subject_id FROM (VALUES ('c9', 'gone')) AS v(id, subject_id)
        WHERE EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id);
        INSERT INTO public.exercises (id, chapter_id, subject_id)
        SELECT v.id::uuid, v.chapter_id::uuid, v.subject_id
        FROM (VALUES ('e9', 'c9', 'gone')) AS v(id, chapter_id, subject_id)
        WHERE EXISTS (SELECT 1 FROM public.chapters p WHERE p.id = v.chapter_id::uuid)
          AND EXISTS (SELECT 1 FROM public.subjects p WHERE p.id = v.subject_id);`),
    ]);
    expect(orphans).toEqual([]);
    expect(created.exercises.has("e9")).toBe(false);
  });

  it("counts a non-literal reference as unresolved instead of inventing an orphan", () => {
    const { orphans, unresolved } = replayMigrations([
      file(SEED_SUBJECTS),
      file(`INSERT INTO public.chapters (id, subject_id) VALUES ('c1', lower('MATH'));`),
    ]);
    expect(orphans).toEqual([]);
    expect(unresolved).toBe(1);
  });
});

describe("summarizeOrphans", () => {
  it("collapses many rows sharing one missing parent into a single finding", () => {
    const raw = [
      {
        file: "m.sql",
        table: "questions",
        column: "exercise_id",
        parent: "exercises",
        value: "e1",
      },
      {
        file: "m.sql",
        table: "questions",
        column: "exercise_id",
        parent: "exercises",
        value: "e1",
      },
      {
        file: "m.sql",
        table: "questions",
        column: "exercise_id",
        parent: "exercises",
        value: "e2",
      },
    ];
    const out = summarizeOrphans(raw);
    expect(out).toHaveLength(2);
    expect(out[0]).toMatchObject({ value: "e1", rows: 2 });
    expect(out[1]).toMatchObject({ value: "e2", rows: 1 });
  });
});

describe("parseFixtureInsert", () => {
  it("reads a literal fixture id", () => {
    const [stmt] = splitStatements(
      `INSERT INTO public.chapters (id, subject_id, title) VALUES ('c5000000-0000-0000-0000-000000000001', 's', 'T');`,
    );
    expect(parseFixtureInsert(stmt)).toEqual({
      table: "chapters",
      ids: ["c5000000-0000-0000-0000-000000000001"],
    });
  });

  it("expands the `('prefix' || g)::uuid … generate_series(1, 5)` form", () => {
    // Unexpanded, this prefix would hide a real collision.
    const [stmt] = splitStatements(`
      INSERT INTO public.questions (id, exercise_id, prompt)
      SELECT ('e3000000-0000-0000-0000-00000000000' || g)::uuid, '7e570402-0000-0000-0000-000000000001', 'p'
      FROM generate_series(1, 5) AS g;`);
    const parsed = parseFixtureInsert(stmt);
    expect(parsed.ids).toHaveLength(5);
    expect(parsed.ids[0]).toBe("e3000000-0000-0000-0000-000000000001");
    expect(parsed.ids[4]).toBe("e3000000-0000-0000-0000-000000000005");
  });

  it("skips an insert with no id column — a generated id cannot collide", () => {
    const [stmt] = splitStatements(
      `INSERT INTO public.questions (exercise_id, prompt) VALUES ('e1', 'p');`,
    );
    expect(parseFixtureInsert(stmt)).toBeNull();
  });

  it("skips an insert protected by ON CONFLICT", () => {
    const [stmt] = splitStatements(
      `INSERT INTO public.subjects (id, name_fr) VALUES ('math', 'M') ON CONFLICT (id) DO NOTHING;`,
    );
    expect(parseFixtureInsert(stmt)).toBeNull();
  });
});

describe("findFixtureCollisions", () => {
  const created = {
    subjects: new Set(["math"]),
    chapters: new Set(["c5000000-0000-0000-0000-000000000001"]),
    exercises: new Set(["e3000000-0000-0000-0000-000000000001"]),
    questions: new Set(),
  };

  it("flags the #557 collision: same id, same table", () => {
    const { collisions } = findFixtureCollisions(
      [
        {
          file: "supabase/tests/06_start_exercise_session.test.sql",
          sql: `INSERT INTO public.chapters (id, subject_id) VALUES ('c5000000-0000-0000-0000-000000000001', 'math');`,
        },
      ],
      created,
    );
    expect(collisions).toHaveLength(1);
    expect(collisions[0]).toMatchObject({
      table: "chapters",
      id: "c5000000-0000-0000-0000-000000000001",
    });
  });

  it("downgrades a same-id/different-table hit to an advisory overlap", () => {
    // The PK is per table, so a fixture question reusing an exercise id raises
    // nothing today — but it is one table move away from being the same bug.
    const { collisions, overlaps } = findFixtureCollisions(
      [
        {
          file: "supabase/tests/04_scoring_submit_attempt.test.sql",
          sql: `INSERT INTO public.questions (id, exercise_id) VALUES ('e3000000-0000-0000-0000-000000000001', 'x');`,
        },
      ],
      created,
    );
    expect(collisions).toEqual([]);
    expect(overlaps).toHaveLength(1);
    expect(overlaps[0]).toMatchObject({ table: "questions", migrationTable: "exercises" });
  });

  it("does not flag a fixture id that no migration creates", () => {
    const { collisions, overlaps } = findFixtureCollisions(
      [
        {
          file: "supabase/tests/04_scoring_submit_attempt.test.sql",
          sql: `INSERT INTO public.chapters (id, subject_id) VALUES ('7e570401-0000-0000-0000-000000000001', 'math');`,
        },
      ],
      created,
    );
    expect(collisions).toEqual([]);
    expect(overlaps).toEqual([]);
  });
});

describe("findDuplicateVersions", () => {
  it("flags two migrations sharing a 14-digit version", () => {
    // The 2026-07-20 near-miss between étude 24's mode-check fix and étude 22 lot 5.
    const dups = findDuplicateVersions([
      "supabase/migrations/20260720190000_exercises_mode_check.sql",
      "supabase/migrations/20260720190000_etude22_lot5.sql",
      "supabase/migrations/20260720170000_sm2_close_reviews_on_pass.sql",
    ]);
    expect(dups).toHaveLength(1);
    expect(dups[0].version).toBe("20260720190000");
    expect(dups[0].files).toEqual([
      "20260720190000_etude22_lot5.sql",
      "20260720190000_exercises_mode_check.sql",
    ]);
  });

  it("passes a chain of distinct versions and ignores untimestamped files", () => {
    expect(
      findDuplicateVersions([
        "supabase/migrations/20260720190000_a.sql",
        "supabase/migrations/20260720200000_b.sql",
        "supabase/migrations/README.md",
      ]),
    ).toEqual([]);
  });
});

describe("CONTENT_FKS", () => {
  it("covers the four content foreign keys of the chain", () => {
    expect(CONTENT_FKS.chapters).toEqual([{ column: "subject_id", parent: "subjects" }]);
    expect(CONTENT_FKS.exercises).toEqual([
      { column: "chapter_id", parent: "chapters" },
      { column: "subject_id", parent: "subjects" },
    ]);
    expect(CONTENT_FKS.questions).toEqual([{ column: "exercise_id", parent: "exercises" }]);
  });
});

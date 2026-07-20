import { describe, expect, it } from "vitest";

import { MANUAL_CONTENT_MIGRATIONS, leakReason } from "../check-content-leak.mjs";

describe("leakReason — corpus", () => {
  it("flags the corpus itself", () => {
    expect(leakReason("content/math-9eme/01-fractions/quiz.json")).toMatch(/corpus/);
    expect(leakReason("content/misconceptions.json")).toMatch(/corpus/);
  });

  it("does NOT flag the generic engine under scripts/content/", () => {
    // The engine stays public — this is the distinction the gate exists to make.
    expect(leakReason("scripts/content/build.ts")).toBeNull();
    expect(leakReason("scripts/content/qa-checks.ts")).toBeNull();
    expect(leakReason("src/shared/content/loader.ts")).toBeNull();
  });

  it("flags compiled per-subject SQL from content:emit", () => {
    expect(leakReason("sql/content/math-9eme.sql")).toMatch(/content:emit/);
  });
});

describe("leakReason — pedagogical skills", () => {
  it("flags content-*, prof-* and curriculum-architect", () => {
    expect(leakReason(".claude/skills/content-engine/SKILL.md")).toMatch(/skill pédagogique/);
    expect(leakReason(".claude/skills/prof-math-9eme/SKILL.md")).toMatch(/skill pédagogique/);
    expect(leakReason(".claude/skills/curriculum-architect/SKILL.md")).toMatch(/skill pédagogique/);
    expect(leakReason(".agents/skills/content-ecole-tn/SKILL.md")).toMatch(/skill pédagogique/);
  });

  it("does NOT flag the technical skills that stay public", () => {
    for (const skill of [
      "verify",
      "code-review",
      "regression-guard",
      "upgrade-guard",
      "report-triage",
    ]) {
      expect(leakReason(`.claude/skills/${skill}/SKILL.md`)).toBeNull();
    }
  });
});

describe("leakReason — migrations (provenance criterion)", () => {
  it("flags generated content migrations", () => {
    expect(
      leakReason("supabase/migrations/20260719140000_generated_math-bac-math_content.sql"),
    ).toMatch(/générée/);
  });

  it("flags the generated competences registry (the second provenance pattern)", () => {
    // Regression guard: an inventory built on `_generated_*_content` alone misses
    // this one — the discrepancy that surfaced while executing lot 3b.
    expect(
      leakReason("supabase/migrations/20260712131000_generated_competences_registry.sql"),
    ).toMatch(/générée/);
  });

  it("does NOT flag schema or ops migrations", () => {
    expect(leakReason("supabase/migrations/20260720140000_exercises_mode_check.sql")).toBeNull();
    expect(leakReason("supabase/migrations/20260719210000_content_releases.sql")).toBeNull();
  });

  it("does NOT flag any of the 17 hand-written content migrations", () => {
    // §4.4: without this exclusion the gate would fail on the very tip étude 24 produces.
    expect(MANUAL_CONTENT_MIGRATIONS.size).toBe(17);
    for (const name of MANUAL_CONTENT_MIGRATIONS) {
      expect(leakReason(`supabase/migrations/${name}`)).toBeNull();
    }
  });
});

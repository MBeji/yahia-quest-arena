import { describe, expect, it } from "vitest";
import { GAMEPLAY_TABLES } from "../gameplay-tables.mjs";

// Regression guard: the nightly E2E spec (content-report.spec.ts) submits one
// content report per run to exercise the "Signaler une erreur" workflow. If the
// reset script does not delete these rows between runs they accumulate in the
// TEST project and flood the production triage queue. Same risk for bug_reports
// if a bug-report E2E spec is ever added.
describe("GAMEPLAY_TABLES", () => {
  it("includes content_reports so nightly E2E reports do not accumulate", () => {
    expect(GAMEPLAY_TABLES).toContain("content_reports");
  });

  it("includes bug_reports so any future bug-report E2E spec stays clean", () => {
    expect(GAMEPLAY_TABLES).toContain("bug_reports");
  });
});

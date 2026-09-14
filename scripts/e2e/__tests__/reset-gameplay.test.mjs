// @vitest-environment node
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

  // Le grand livre de l'étude 34 est le seul décor e2e qui ne se dégrade pas tout
  // seul : il est insert-only et MONOTONE (R-6), donc rien ne le remet à zéro au
  // fil du temps. Omis ici, il ne casse aucun test le premier soir — il les casse
  // tous les suivants, parce qu'une étoile déjà inscrite ne peut plus être gagnée
  // et qu'un sceau déjà posé ne décerne plus son badge.
  it.each(["user_chapter_stars", "user_subject_seals"])(
    "includes %s so a star can be EARNED again on the next run",
    (table) => {
      expect(GAMEPLAY_TABLES).toContain(table);
    },
  );
});

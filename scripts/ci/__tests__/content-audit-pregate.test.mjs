// @vitest-environment node
import { describe, expect, it } from "vitest";

import {
  changedSubjects,
  collectFiledLocators,
  decideRun,
  parseLocators,
  subjectOf,
} from "../content-audit-pregate.mjs";

describe("subjectOf", () => {
  it("reads the subject out of a corpus path, on either slash", () => {
    expect(subjectOf("content/math-8eme/12-cercle/cours.md")).toBe("math-8eme");
    expect(subjectOf("content\\anglais-a2\\08-reading\\quiz.json")).toBe("anglais-a2");
  });

  it("ignores anything that is not a file inside a subject", () => {
    expect(subjectOf("content/README.md")).toBeNull();
    expect(subjectOf("FableEtudes/ROADMAP.md")).toBeNull();
    expect(subjectOf(".github/workflows/content-audit.yml")).toBeNull();
    expect(subjectOf("")).toBeNull();
  });
});

describe("changedSubjects", () => {
  const log = [
    "",
    "content/math-8eme/12-cercle/cours.md",
    "content/math-8eme/12-cercle/quiz.json",
    "",
    "content/anglais-a2/08-reading/cours.md",
    "FableEtudes/ROADMAP.md",
    "content/README.md",
  ].join("\n");

  it("de-duplicates and sorts the subjects touched in the window", () => {
    const calls = [];
    const runGit = (args) => {
      calls.push(args);
      return log;
    };
    expect(changedSubjects(runGit, 4)).toEqual(["anglais-a2", "math-8eme"]);
    expect(calls[0]).toContain("--since=4 days ago");
    expect(calls[0]).toContain("content");
  });

  it("returns nothing on an empty window", () => {
    expect(changedSubjects(() => "", 4)).toEqual([]);
    expect(changedSubjects(() => "\n\n", 4)).toEqual([]);
  });
});

describe("parseLocators", () => {
  it("reads the contract line the prompt imposes, in its usual markdown skins", () => {
    const body = [
      "Le distracteur (c) est absurde.",
      "Locator: math-8eme/12-cercle/quiz.json#q3",
      "- **Locator**: `anglais-a2/08-reading/cours.md#L42`",
      "",
      "Proposition de correction: …",
    ].join("\n");
    expect(parseLocators(body)).toEqual([
      "math-8eme/12-cercle/quiz.json#q3",
      "anglais-a2/08-reading/cours.md#L42",
    ]);
  });

  it("never guesses at free-form prose", () => {
    expect(parseLocators("Il y a un souci dans math-8eme, chapitre 12.")).toEqual([]);
    expect(parseLocators(undefined)).toEqual([]);
  });
});

describe("collectFiledLocators", () => {
  it("keeps an issue that carries no locator instead of dropping it", () => {
    expect(
      collectFiledLocators([
        { number: 7, title: "math-8eme — clé fausse", body: "Locator: math-8eme/12/quiz.json#q1" },
        { number: 9, title: "anglais-a2 — explication mince", body: "pas de contrat ici" },
      ]),
    ).toEqual([
      { number: 7, title: "math-8eme — clé fausse", locators: ["math-8eme/12/quiz.json#q1"] },
      { number: 9, title: "anglais-a2 — explication mince", locators: [] },
    ]);
  });

  it("tolerates an absent listing", () => {
    expect(collectFiledLocators(undefined)).toEqual([]);
  });
});

describe("decideRun", () => {
  it("skips when no subject changed — the agent would have said « nothing to audit »", () => {
    expect(decideRun({ subjects: [] })).toMatchObject({ run: false, reason: "no-content-change" });
  });

  it("runs as soon as one subject changed, and names them", () => {
    const d = decideRun({ subjects: ["math-8eme", "anglais-a2"] });
    expect(d.run).toBe(true);
    expect(d.detail).toContain("math-8eme");
  });

  it("a manual dispatch always runs, even on an empty window", () => {
    expect(decideRun({ eventName: "workflow_dispatch", subjects: [] })).toMatchObject({
      run: true,
      reason: "manual-dispatch",
    });
  });
});

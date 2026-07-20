import { describe, it, expect } from "vitest";
import {
  chapterMissionCounts,
  isCatalogueMission,
  isChapterComplete,
  isChapterPublished,
  isMissionPassed,
  subjectProgression,
  type CompletionExercise,
} from "../chapter-completion";

const mission = (id: string, over: Partial<CompletionExercise> = {}): CompletionExercise => ({
  id,
  chapter_id: "c1",
  mode: "practice",
  ...over,
});

describe("isCatalogueMission", () => {
  it("keeps admin missions and drops the quiz and parent-authored ones", () => {
    expect(isCatalogueMission(mission("a"))).toBe(true);
    expect(isCatalogueMission(mission("b", { mode: "quiz" }))).toBe(false);
    expect(isCatalogueMission(mission("c", { source: "parent" }))).toBe(false);
  });

  it("treats a missing source as admin (the column default)", () => {
    expect(isCatalogueMission(mission("a", { source: null }))).toBe(true);
  });
});

describe("isMissionPassed", () => {
  // R-14 — « réussie » vaut 60 %, et surtout PAS « tentée » : c'est le bug que le hub portait.
  it("requires 60%, not merely an attempt", () => {
    expect(isMissionPassed(60)).toBe(true);
    expect(isMissionPassed(100)).toBe(true);
    expect(isMissionPassed(59)).toBe(false);
    expect(isMissionPassed(10)).toBe(false);
    expect(isMissionPassed(undefined)).toBe(false);
    expect(isMissionPassed(null)).toBe(false);
  });
});

describe("isChapterPublished", () => {
  it("needs at least one playable catalogue mission", () => {
    expect(isChapterPublished([mission("a")])).toBe(true);
    // Un chapitre qui n'a qu'un quiz, ou que des missions familiales, n'est pas « publié ».
    expect(isChapterPublished([mission("q", { mode: "quiz" })])).toBe(false);
    expect(isChapterPublished([mission("p", { source: "parent" })])).toBe(false);
    expect(isChapterPublished([])).toBe(false);
  });
});

describe("isChapterComplete", () => {
  const chapter = [
    mission("q", { mode: "quiz" }),
    mission("m1"),
    mission("m2"),
    mission("parent", { source: "parent" }),
  ];

  it("completes when the quiz gate is satisfied and every catalogue mission is passed", () => {
    expect(isChapterComplete(chapter, { m1: 80, m2: 65 }, true)).toBe(true);
  });

  it("ignores parent-authored missions", () => {
    // La mission `parent` n'est jamais tentée et n'empêche pourtant pas la complétion.
    expect(isChapterComplete(chapter, { m1: 80, m2: 65, parent: 0 }, true)).toBe(true);
  });

  it("does not complete while a catalogue mission is merely attempted", () => {
    expect(isChapterComplete(chapter, { m1: 80, m2: 30 }, true)).toBe(false);
  });

  it("does not complete while the comprehension quiz gate is closed", () => {
    expect(isChapterComplete(chapter, { m1: 80, m2: 65 }, false)).toBe(false);
  });

  it("never completes an unpublished chapter by vacuity", () => {
    // Zéro mission de catalogue : « toutes réussies » serait vrai, ce serait un faux positif.
    expect(isChapterComplete([mission("q", { mode: "quiz" })], {}, true)).toBe(false);
    expect(isChapterComplete([], {}, true)).toBe(false);
  });
});

describe("chapterMissionCounts", () => {
  it("counts passed catalogue missions over catalogue missions", () => {
    const chapter = [
      mission("q", { mode: "quiz" }),
      mission("m1"),
      mission("m2"),
      mission("p", { source: "parent" }),
    ];
    // Le quiz et la mission parent sortent des deux termes ; m2 raté ne compte pas comme fait.
    expect(chapterMissionCounts(chapter, { q: 100, m1: 90, m2: 20, p: 100 })).toEqual({
      done: 1,
      total: 2,
    });
  });
});

describe("subjectProgression", () => {
  const exercises = [
    mission("q1", { chapter_id: "c1", mode: "quiz" }),
    mission("a1", { chapter_id: "c1" }),
    mission("b1", { chapter_id: "c2" }),
    mission("b2", { chapter_id: "c2" }),
    mission("only-quiz", { chapter_id: "c3", mode: "quiz" }),
  ];

  it("counts completed over published chapters, skipping unpublished ones", () => {
    const progress = subjectProgression(
      ["c1", "c2", "c3"],
      exercises,
      { a1: 100, b1: 100, b2: 20 },
      { c1: true, c2: true, c3: true },
    );
    // c3 n'a qu'un quiz : hors du dénominateur. c1 complété, c2 non (b2 raté).
    expect(progress).toEqual({ total: 2, completed: 1, pct: 50 });
  });

  it("returns a null percentage — never 100% — when nothing is published", () => {
    expect(subjectProgression(["c3"], exercises, {}, { c3: true })).toEqual({
      total: 0,
      completed: 0,
      pct: null,
    });
  });

  it("reaches 100% only when every published chapter is complete", () => {
    const progress = subjectProgression(
      ["c1", "c2"],
      exercises,
      { a1: 60, b1: 75, b2: 60 },
      { c1: true, c2: true },
    );
    expect(progress.pct).toBe(100);
  });
});

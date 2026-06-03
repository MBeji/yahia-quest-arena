import { describe, it, expect } from "vitest";
import { computeNextExerciseId } from "../next-exercise";

const chapters = [
  { id: "c1", display_order: 1 },
  { id: "c2", display_order: 2 },
];
const exercises = [
  { id: "c1-quiz", chapter_id: "c1", display_order: 0, mode: "quiz" },
  { id: "c1-e1", chapter_id: "c1", display_order: 1, mode: "practice" },
  { id: "c1-e2", chapter_id: "c1", display_order: 2, mode: "boss" },
  { id: "c2-quiz", chapter_id: "c2", display_order: 0, mode: "quiz" },
  { id: "c2-e1", chapter_id: "c2", display_order: 1, mode: "practice" },
];

describe("computeNextExerciseId", () => {
  it("returns the next playable exercise within a chapter", () => {
    expect(
      computeNextExerciseId(chapters, exercises, {
        id: "c1-e1",
        chapter_id: "c1",
        mode: "practice",
      }),
    ).toBe("c1-e2");
  });

  it("crosses to the next chapter's first playable exercise", () => {
    expect(
      computeNextExerciseId(chapters, exercises, { id: "c1-e2", chapter_id: "c1", mode: "boss" }),
    ).toBe("c2-e1");
  });

  it("skips quizzes", () => {
    const next = computeNextExerciseId(chapters, exercises, {
      id: "c1-e2",
      chapter_id: "c1",
      mode: "boss",
    });
    expect(next).not.toBe("c2-quiz");
  });

  it("from a quiz, returns the first playable exercise of its chapter", () => {
    expect(
      computeNextExerciseId(chapters, exercises, { id: "c2-quiz", chapter_id: "c2", mode: "quiz" }),
    ).toBe("c2-e1");
  });

  it("returns null after the last exercise", () => {
    expect(
      computeNextExerciseId(chapters, exercises, {
        id: "c2-e1",
        chapter_id: "c2",
        mode: "practice",
      }),
    ).toBeNull();
  });
});

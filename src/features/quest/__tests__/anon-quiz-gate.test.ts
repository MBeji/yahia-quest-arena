import { describe, it, expect, beforeEach } from "vitest";
import {
  hasPassedChapterQuiz,
  markChapterQuizPassed,
  isQuizGateLocked,
} from "@/features/quest/anon-quiz-gate";

// The anonymous gate stores "passed chapter quizzes" in sessionStorage. jsdom
// provides a real sessionStorage, so these exercise the actual persistence.
describe("anon-quiz-gate", () => {
  beforeEach(() => {
    window.sessionStorage.clear();
  });

  describe("hasPassedChapterQuiz / markChapterQuizPassed", () => {
    it("starts unpassed and flips to passed after marking", () => {
      expect(hasPassedChapterQuiz("ch1")).toBe(false);
      markChapterQuizPassed("ch1");
      expect(hasPassedChapterQuiz("ch1")).toBe(true);
    });

    it("isolates chapters from one another", () => {
      markChapterQuizPassed("ch1");
      expect(hasPassedChapterQuiz("ch1")).toBe(true);
      expect(hasPassedChapterQuiz("ch2")).toBe(false);
    });

    it("is idempotent and persists across multiple marks", () => {
      markChapterQuizPassed("ch1");
      markChapterQuizPassed("ch1");
      markChapterQuizPassed("ch2");
      expect(hasPassedChapterQuiz("ch1")).toBe(true);
      expect(hasPassedChapterQuiz("ch2")).toBe(true);
    });

    it("treats a null/empty chapter id as never passed and ignores marking it", () => {
      expect(hasPassedChapterQuiz(null)).toBe(false);
      expect(hasPassedChapterQuiz(undefined)).toBe(false);
      markChapterQuizPassed(null);
      markChapterQuizPassed("");
      // Nothing was stored.
      expect(window.sessionStorage.getItem("na9ra.anonQuizPassed")).toBeNull();
    });

    it("recovers (no throw) when sessionStorage holds malformed JSON", () => {
      window.sessionStorage.setItem("na9ra.anonQuizPassed", "{not json");
      expect(hasPassedChapterQuiz("ch1")).toBe(false);
      // A subsequent mark overwrites the bad value cleanly.
      markChapterQuizPassed("ch1");
      expect(hasPassedChapterQuiz("ch1")).toBe(true);
    });
  });

  describe("isQuizGateLocked", () => {
    it("locks only a gated chapter that has not been passed", () => {
      expect(isQuizGateLocked({ quizGated: true, quizPassed: false })).toBe(true);
      expect(isQuizGateLocked({ quizGated: true, quizPassed: true })).toBe(false);
      expect(isQuizGateLocked({ quizGated: false, quizPassed: false })).toBe(false);
      expect(isQuizGateLocked({ quizGated: false, quizPassed: true })).toBe(false);
    });
  });
});

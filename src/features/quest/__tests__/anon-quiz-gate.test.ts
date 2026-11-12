import { describe, it, expect, beforeEach } from "vitest";
import {
  hasPassedChapterQuiz,
  markChapterQuizPassed,
  isQuizGateLocked,
} from "@/features/quest/anon-quiz-gate";

// The anonymous gate stores "passed chapter quizzes" on the DEVICE (localStorage, 30 days —
// étude 38 lot 5; it was sessionStorage before, so the gate closed with the tab). jsdom
// provides a real localStorage, so these exercise the actual persistence.
const KEY = "na9ra.anon.quizPassed.v1";
describe("anon-quiz-gate", () => {
  beforeEach(() => {
    window.localStorage.clear();
    window.sessionStorage.clear();
  });

  it("⭐ é38 lot 5 : une porte réussie reste ouverte dans un NOUVEL onglet", () => {
    markChapterQuizPassed("ch1");
    // Un nouvel onglet partage `localStorage` avec le premier, jamais `sessionStorage` :
    // la réussite ne doit donc rien devoir à ce dernier.
    expect(window.sessionStorage.length).toBe(0);
    expect(window.localStorage.getItem(KEY)).not.toBeNull();
    expect(hasPassedChapterQuiz("ch1")).toBe(true);
  });

  it("localStorage jeté ⇒ la porte se referme, comme avant le lot", () => {
    markChapterQuizPassed("ch1");
    window.localStorage.clear();
    expect(hasPassedChapterQuiz("ch1")).toBe(false);
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
      expect(window.localStorage.getItem(KEY)).toBeNull();
    });

    it("recovers (no throw) when localStorage holds malformed JSON", () => {
      window.localStorage.setItem(KEY, "{not json");
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

import { describe, it, expect } from "vitest";
import { buildQuestLabels, type QuestContentLang } from "../quest-labels";

// The quest screens (quiz-gate lock, banners, review CTA) are labeled in the
// EXERCISE's content language, not the UI locale — a regression here ships the
// wrong language to students mid-quest. Assert every key exists per language
// and that the three languages actually differ (no copy-paste fallback).
describe("buildQuestLabels", () => {
  const langs: QuestContentLang[] = ["fr", "en", "ar"];

  it.each(langs)("returns a complete, non-empty label set for %s", (lang) => {
    const labels = buildQuestLabels(lang);
    for (const [key, value] of Object.entries(labels)) {
      expect(value, `${key} (${lang})`).toBeTruthy();
      expect(typeof value).toBe("string");
    }
  });

  it("localizes each key differently per language", () => {
    const fr = buildQuestLabels("fr");
    const en = buildQuestLabels("en");
    const ar = buildQuestLabels("ar");
    for (const key of Object.keys(fr) as (keyof typeof fr)[]) {
      expect(fr[key]).not.toBe(en[key]);
      expect(fr[key]).not.toBe(ar[key]);
      expect(en[key]).not.toBe(ar[key]);
    }
  });

  it("keeps the lock/unlock journey wording (quiz gate contract)", () => {
    const fr = buildQuestLabels("fr");
    expect(fr.lockedTitle).toContain("verrouillé");
    expect(fr.lockedBody).toContain("quiz");
    expect(fr.quizFailedBanner).toContain("80%");
    expect(fr.quizPassedBanner).toContain("débloqués");
    expect(buildQuestLabels("en").quizFailedBanner).toContain("80%");
  });

  it("does not promise an on-screen correction during the quiz", () => {
    // The student must self-validate: the in-quiz message only announces the
    // final result, never a per-question correction.
    expect(buildQuestLabels("fr").quizRecorded).toContain("fin du quiz");
    expect(buildQuestLabels("en").quizRecorded).toContain("end of the quiz");
  });
});

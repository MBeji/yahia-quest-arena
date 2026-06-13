import { describe, it, expect } from "vitest";
import { buildLessonLabels, type LessonContentLang } from "../lesson-labels";

const LANGS: LessonContentLang[] = ["ar", "fr", "en"];

describe("buildLessonLabels", () => {
  it("returns a non-empty label for every key in every supported language", () => {
    for (const lang of LANGS) {
      const labels = buildLessonLabels(lang);
      for (const [key, value] of Object.entries(labels)) {
        expect(value, `${lang}.${key}`).toBeTypeOf("string");
        expect(value.length, `${lang}.${key}`).toBeGreaterThan(0);
      }
    }
  });

  it("keeps the {subject} placeholder in allChaptersOf for every language", () => {
    for (const lang of LANGS) {
      expect(buildLessonLabels(lang).allChaptersOf).toContain("{subject}");
    }
  });

  it("exposes the course → exercises CTA label per content language", () => {
    expect(buildLessonLabels("fr").goToExercises).toContain("quiz");
    expect(buildLessonLabels("en").goToExercises).toContain("quiz");
    expect(buildLessonLabels("ar").goToExercises.length).toBeGreaterThan(0);
  });
});

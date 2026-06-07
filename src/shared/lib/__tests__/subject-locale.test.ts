import { describe, it, expect } from "vitest";
import { filterSubjectsByLocale } from "../subject-locale";

const S = (id: string, theme_id: string, content_language: string) => ({
  id,
  theme_id,
  content_language,
});

describe("filterSubjectsByLocale", () => {
  it("keeps only the active-locale version for a trilingual theme", () => {
    const subs = [
      S("cg-hist-fr", "culture-generale", "fr"),
      S("cg-hist-en", "culture-generale", "en"),
      S("cg-hist-ar", "culture-generale", "ar"),
    ];
    expect(filterSubjectsByLocale(subs, "en").map((s) => s.id)).toEqual(["cg-hist-en"]);
    expect(filterSubjectsByLocale(subs, "ar").map((s) => s.id)).toEqual(["cg-hist-ar"]);
    expect(filterSubjectsByLocale(subs, "fr").map((s) => s.id)).toEqual(["cg-hist-fr"]);
  });

  it("keeps a single-language theme regardless of locale (fallback)", () => {
    const subs = [S("anglais-a1", "anglais", "en"), S("anglais-a2", "anglais", "en")];
    expect(filterSubjectsByLocale(subs, "fr").map((s) => s.id)).toEqual([
      "anglais-a1",
      "anglais-a2",
    ]);
    expect(filterSubjectsByLocale(subs, "en").map((s) => s.id)).toEqual([
      "anglais-a1",
      "anglais-a2",
    ]);
  });

  it("filters per theme independently and preserves order", () => {
    const subs = [
      S("cg-fr", "culture-generale", "fr"),
      S("cg-en", "culture-generale", "en"),
      S("ang-en", "anglais", "en"), // no fr sibling -> kept via fallback
      S("mc-fr", "muscle-cerveau", "fr"),
      S("mc-en", "muscle-cerveau", "en"),
    ];
    expect(filterSubjectsByLocale(subs, "fr").map((s) => s.id)).toEqual([
      "cg-fr",
      "ang-en",
      "mc-fr",
    ]);
  });

  it("returns empty for empty input", () => {
    expect(filterSubjectsByLocale([], "fr")).toEqual([]);
  });
});

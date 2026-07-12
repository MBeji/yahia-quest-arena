import { describe, expect, it } from "vitest";
import { parcoursName } from "@/shared/lib/parcours-locale";

const full = {
  name_fr: "Préparation Concours 9ème",
  name_en: "9th-grade national exam prep",
  name_ar: "الإعداد لمناظرة التاسعة أساسي",
};

describe("parcoursName", () => {
  it("returns the locale's translation when present", () => {
    expect(parcoursName(full, "fr")).toBe("Préparation Concours 9ème");
    expect(parcoursName(full, "en")).toBe("9th-grade national exam prep");
    expect(parcoursName(full, "ar")).toBe("الإعداد لمناظرة التاسعة أساسي");
  });

  it("falls back to French when the translation is missing or empty", () => {
    expect(parcoursName({ name_fr: "Culture générale" }, "ar")).toBe("Culture générale");
    expect(parcoursName({ name_fr: "Culture générale", name_en: null }, "en")).toBe(
      "Culture générale",
    );
    expect(parcoursName({ name_fr: "Culture générale", name_ar: "  " }, "ar")).toBe(
      "Culture générale",
    );
  });
});

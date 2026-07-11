import { describe, expect, it } from "vitest";
import {
  formatObjectiveType,
  formatQuestType,
  resolveDailyAction,
  resolveWeeklyAction,
} from "@/features/dashboard/dashboard-helpers";

import { fr } from "@/lib/i18n/fr";
import { ar } from "@/lib/i18n/ar";

describe("formatObjectiveType", () => {
  it("maps known types through the locale dictionary", () => {
    expect(formatObjectiveType("3_exercises", fr.dashboard.objectiveTypes)).toBe(
      "Complète 3 exercices",
    );
    expect(formatObjectiveType("perfect_score", fr.dashboard.objectiveTypes)).toBe(
      "Réussis un sans-faute",
    );
    expect(formatObjectiveType("3_exercises", ar.dashboard.objectiveTypes)).toBe("أكمل 3 تمارين");
  });

  it("falls back to a humanized string for unknown types", () => {
    expect(formatObjectiveType("some_unknown_type", fr.dashboard.objectiveTypes)).toBe(
      "some unknown type",
    );
  });
});

describe("formatQuestType", () => {
  it("maps known types through the locale dictionary — no more raw English", () => {
    expect(formatQuestType("2_boss_exercises", fr.dashboard.questTypes)).toBe("Bats 2 boss");
    expect(formatQuestType("5_day_streak", fr.dashboard.questTypes)).toBe(
      "Tiens une série de 5 jours",
    );
    expect(formatQuestType("all_subjects", ar.dashboard.questTypes)).toBe("تدرّب في كل المواد");
  });

  it("falls back to a humanized string for unknown types", () => {
    expect(formatQuestType("weekly_bonus", fr.dashboard.questTypes)).toBe("weekly bonus");
  });
});

describe("resolveDailyAction", () => {
  it("returns retry for perfect_score", () => {
    expect(resolveDailyAction("perfect_score")).toBe("retry");
  });

  it("returns subject for 15_min_study", () => {
    expect(resolveDailyAction("15_min_study")).toBe("subject");
  });

  it("returns subject as default", () => {
    expect(resolveDailyAction("3_exercises")).toBe("subject");
    expect(resolveDailyAction("unknown")).toBe("subject");
  });
});

describe("resolveWeeklyAction", () => {
  it("returns dungeon for boss-related types", () => {
    expect(resolveWeeklyAction("beat_2_bosses")).toBe("dungeon");
    expect(resolveWeeklyAction("2_boss_exercises")).toBe("dungeon");
  });

  it("returns subject for all_subjects", () => {
    expect(resolveWeeklyAction("all_subjects")).toBe("subject");
  });

  it("returns subject as default", () => {
    expect(resolveWeeklyAction("10_exercises")).toBe("subject");
    expect(resolveWeeklyAction("unknown")).toBe("subject");
  });
});

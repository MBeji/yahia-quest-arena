import { describe, expect, it } from "vitest";
import {
  formatObjectiveType,
  formatQuestType,
  resolveDailyAction,
  resolveWeeklyAction,
} from "@/features/dashboard/dashboard-helpers";

describe("formatObjectiveType", () => {
  it("maps known types", () => {
    expect(formatObjectiveType("3_exercises")).toBe("Complete 3 exercises");
    expect(formatObjectiveType("15_min_study")).toBe("15 min study time");
    expect(formatObjectiveType("perfect_score")).toBe("Get a perfect score");
  });

  it("falls back to formatted string for unknown types", () => {
    expect(formatObjectiveType("some_unknown_type")).toBe("some unknown type");
  });
});

describe("formatQuestType", () => {
  it("maps known types", () => {
    expect(formatQuestType("5_day_streak")).toBe("Maintain 5-day streak");
    expect(formatQuestType("2_boss_exercises")).toBe("Beat 2 boss exercises");
    expect(formatQuestType("10_exercises")).toBe("Complete 10 exercises");
    expect(formatQuestType("all_subjects")).toBe("Practice all subjects");
  });

  it("falls back to formatted string for unknown types", () => {
    expect(formatQuestType("weekly_bonus")).toBe("weekly bonus");
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

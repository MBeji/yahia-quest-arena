import { describe, it, expect } from "vitest";
import {
  appLocalDate,
  isStreakAtRisk,
  selectStreakAtRiskUserIds,
  streakReminderPayload,
  type StreakProfileRow,
} from "../push-audience";

describe("push-audience", () => {
  describe("appLocalDate", () => {
    it("maps a late-UTC instant to the next Tunisia-local day (UTC+1)", () => {
      // 23:30 UTC on 2026-06-12 is already 00:30 on 2026-06-13 in Tunis.
      expect(appLocalDate(new Date("2026-06-12T23:30:00Z"))).toBe("2026-06-13");
    });
    it("keeps the same civil day for a midday instant", () => {
      expect(appLocalDate(new Date("2026-06-12T10:00:00Z"))).toBe("2026-06-12");
    });
  });

  describe("isStreakAtRisk", () => {
    const today = "2026-06-13";
    it("flags a live streak last active before today", () => {
      expect(
        isStreakAtRisk({ id: "a", current_streak: 4, last_active_date: "2026-06-12" }, today),
      ).toBe(true);
    });
    it("does not flag a streak already active today", () => {
      expect(
        isStreakAtRisk({ id: "a", current_streak: 4, last_active_date: "2026-06-13" }, today),
      ).toBe(false);
    });
    it("does not flag a zero streak", () => {
      expect(
        isStreakAtRisk({ id: "a", current_streak: 0, last_active_date: "2026-06-01" }, today),
      ).toBe(false);
    });
    it("flags a live streak with a null last-active date", () => {
      expect(isStreakAtRisk({ id: "a", current_streak: 2, last_active_date: null }, today)).toBe(
        true,
      );
    });
  });

  it("selectStreakAtRiskUserIds keeps only the at-risk ids", () => {
    const rows: StreakProfileRow[] = [
      { id: "at-risk", current_streak: 3, last_active_date: "2026-06-12" },
      { id: "safe", current_streak: 3, last_active_date: "2026-06-13" },
      { id: "no-streak", current_streak: 0, last_active_date: null },
    ];
    expect(selectStreakAtRiskUserIds(rows, "2026-06-13")).toEqual(["at-risk"]);
  });

  it("streakReminderPayload targets the dashboard with a stable tag", () => {
    const p = streakReminderPayload();
    expect(p.url).toBe("/dashboard");
    expect(p.tag).toBe("streak-at-risk");
    expect(p.title.length).toBeGreaterThan(0);
    expect(p.body.length).toBeGreaterThan(0);
  });
});

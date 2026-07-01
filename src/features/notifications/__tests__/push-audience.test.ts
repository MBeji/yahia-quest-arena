import { describe, it, expect } from "vitest";
import {
  appLocalDate,
  appLocalWeekday,
  isParentDigestDay,
  isStreakAtRisk,
  selectStreakAtRiskUserIds,
  streakReminderPayload,
  weeklyParentDigestPayload,
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

  describe("weekly parent digest scheduling", () => {
    it("appLocalWeekday resolves the Tunisia-local weekday across the UTC boundary", () => {
      // 23:30 UTC on Saturday 2026-07-04 is already Sunday 00:30 in Tunis (UTC+1).
      expect(appLocalWeekday(new Date("2026-07-04T23:30:00Z"))).toBe("Sun");
      expect(appLocalWeekday(new Date("2026-07-01T18:00:00Z"))).toBe("Wed");
    });

    it("isParentDigestDay fires on Sunday (Tunis-local) only", () => {
      expect(isParentDigestDay(new Date("2026-07-05T18:00:00Z"))).toBe(true); // Sunday 19:00 Tunis
      expect(isParentDigestDay(new Date("2026-07-01T18:00:00Z"))).toBe(false); // Wednesday
      expect(isParentDigestDay(new Date("2026-07-04T23:30:00Z"))).toBe(true); // Sunday in Tunis already
    });

    it("weeklyParentDigestPayload targets the parent report with a stable tag", () => {
      const p = weeklyParentDigestPayload();
      expect(p.url).toBe("/parent-report");
      expect(p.tag).toBe("weekly-family-report");
      expect(p.title.length).toBeGreaterThan(0);
      expect(p.body.length).toBeGreaterThan(0);
    });
  });
});

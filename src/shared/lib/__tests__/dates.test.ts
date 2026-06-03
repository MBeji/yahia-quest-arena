import { describe, it, expect } from "vitest";
import { getCurrentWeekStartUtc, getTodayUtc } from "@/shared/lib/dates";

describe("getTodayUtc", () => {
  it("formats a date as YYYY-MM-DD in UTC", () => {
    expect(getTodayUtc(new Date("2026-06-02T13:45:00Z"))).toBe("2026-06-02");
  });

  it("uses UTC fields, not local time", () => {
    expect(getTodayUtc(new Date("2026-06-02T23:30:00Z"))).toBe("2026-06-02");
  });

  it("does not mutate the input", () => {
    const input = new Date("2026-06-02T00:00:00Z");
    const before = input.getTime();
    getTodayUtc(input);
    expect(input.getTime()).toBe(before);
  });
});

describe("getCurrentWeekStartUtc", () => {
  it("returns the same day when given a Monday", () => {
    expect(getCurrentWeekStartUtc(new Date("2026-06-01T10:00:00Z"))).toBe("2026-06-01");
  });

  it("returns Monday for a midweek date", () => {
    // 2026-06-03 is a Wednesday.
    expect(getCurrentWeekStartUtc(new Date("2026-06-03T08:00:00Z"))).toBe("2026-06-01");
  });

  it("returns the previous Monday when given a Sunday", () => {
    // 2026-06-07 is a Sunday.
    expect(getCurrentWeekStartUtc(new Date("2026-06-07T23:59:59Z"))).toBe("2026-06-01");
  });

  it("handles month boundaries", () => {
    // 2026-03-01 is a Sunday -> week start 2026-02-23.
    expect(getCurrentWeekStartUtc(new Date("2026-03-01T00:00:00Z"))).toBe("2026-02-23");
  });

  it("does not mutate the input", () => {
    const input = new Date("2026-06-03T08:00:00Z");
    const before = input.getTime();
    getCurrentWeekStartUtc(input);
    expect(input.getTime()).toBe(before);
  });
});

import { describe, it, expect, beforeEach, vi } from "vitest";
import { isRateLimited } from "@/lib/rate-limit";

describe("isRateLimited", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  it("allows requests under the limit", () => {
    const key = "test-user-1";
    expect(isRateLimited(key, 3, 10_000)).toBe(false);
    expect(isRateLimited(key, 3, 10_000)).toBe(false);
    expect(isRateLimited(key, 3, 10_000)).toBe(false);
  });

  it("blocks requests over the limit", () => {
    const key = "test-user-2";
    expect(isRateLimited(key, 2, 10_000)).toBe(false);
    expect(isRateLimited(key, 2, 10_000)).toBe(false);
    expect(isRateLimited(key, 2, 10_000)).toBe(true);
  });

  it("resets after window expires", () => {
    const key = "test-user-3";
    expect(isRateLimited(key, 1, 5_000)).toBe(false);
    expect(isRateLimited(key, 1, 5_000)).toBe(true); // blocked

    vi.advanceTimersByTime(5_001);
    expect(isRateLimited(key, 1, 5_000)).toBe(false); // allowed again
  });

  it("different keys are independent", () => {
    expect(isRateLimited("user-a", 1, 10_000)).toBe(false);
    expect(isRateLimited("user-b", 1, 10_000)).toBe(false);
    expect(isRateLimited("user-a", 1, 10_000)).toBe(true);
    expect(isRateLimited("user-b", 1, 10_000)).toBe(true);
  });

  it("handles sliding window correctly", () => {
    const key = "test-user-4";
    expect(isRateLimited(key, 2, 10_000)).toBe(false); // t=0
    vi.advanceTimersByTime(6_000);
    expect(isRateLimited(key, 2, 10_000)).toBe(false); // t=6s
    vi.advanceTimersByTime(5_000);
    // t=11s — first request expired, second still valid
    expect(isRateLimited(key, 2, 10_000)).toBe(false); // allowed (only 1 in window)
  });
});

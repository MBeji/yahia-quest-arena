import { describe, it, expect, beforeEach, vi } from "vitest";
import { isRateLimitedLocal } from "@/shared/lib/rate-limit";

describe("isRateLimitedLocal", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  it("allows requests under the limit", () => {
    const key = "test-user-1";
    expect(isRateLimitedLocal(key, 3, 10_000)).toBe(false);
    expect(isRateLimitedLocal(key, 3, 10_000)).toBe(false);
    expect(isRateLimitedLocal(key, 3, 10_000)).toBe(false);
  });

  it("blocks requests over the limit", () => {
    const key = "test-user-2";
    expect(isRateLimitedLocal(key, 2, 10_000)).toBe(false);
    expect(isRateLimitedLocal(key, 2, 10_000)).toBe(false);
    expect(isRateLimitedLocal(key, 2, 10_000)).toBe(true);
  });

  it("resets after window expires", () => {
    const key = "test-user-3";
    expect(isRateLimitedLocal(key, 1, 5_000)).toBe(false);
    expect(isRateLimitedLocal(key, 1, 5_000)).toBe(true); // blocked

    vi.advanceTimersByTime(5_001);
    expect(isRateLimitedLocal(key, 1, 5_000)).toBe(false); // allowed again
  });

  it("different keys are independent", () => {
    expect(isRateLimitedLocal("user-a", 1, 10_000)).toBe(false);
    expect(isRateLimitedLocal("user-b", 1, 10_000)).toBe(false);
    expect(isRateLimitedLocal("user-a", 1, 10_000)).toBe(true);
    expect(isRateLimitedLocal("user-b", 1, 10_000)).toBe(true);
  });

  it("handles sliding window correctly", () => {
    const key = "test-user-4";
    expect(isRateLimitedLocal(key, 2, 10_000)).toBe(false); // t=0
    vi.advanceTimersByTime(6_000);
    expect(isRateLimitedLocal(key, 2, 10_000)).toBe(false); // t=6s
    vi.advanceTimersByTime(5_000);
    // t=11s — first request expired, second still valid
    expect(isRateLimitedLocal(key, 2, 10_000)).toBe(false); // allowed (only 1 in window)
  });
});

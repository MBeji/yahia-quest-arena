import { describe, it, expect, vi, beforeEach } from "vitest";
import { isRateLimited, isRateLimitedLocal } from "@/shared/lib/rate-limit";

describe("isRateLimited — RPC integration", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("returns false when RPC says not rate limited", async () => {
    const mockSupabase = {
      rpc: vi.fn().mockResolvedValue({ data: false, error: null }),
    };

    const result = await isRateLimited(mockSupabase, "user_key", 5, 10_000);
    expect(result).toBe(false);
    expect(mockSupabase.rpc).toHaveBeenCalledWith("check_rate_limit", {
      p_key: "user_key",
      p_max_requests: 5,
      p_window_ms: 10_000,
    });
  });

  it("returns true when RPC says rate limited", async () => {
    const mockSupabase = {
      rpc: vi.fn().mockResolvedValue({ data: true, error: null }),
    };

    const result = await isRateLimited(mockSupabase, "user_key", 5, 10_000);
    expect(result).toBe(true);
  });

  it("falls back to local limiter when RPC returns error", async () => {
    const mockSupabase = {
      rpc: vi.fn().mockResolvedValue({ data: null, error: { message: "function not found" } }),
    };

    // First call should fall back to local and allow
    const result = await isRateLimited(mockSupabase, "fallback_key_1", 1, 10_000);
    expect(result).toBe(false);
  });

  it("falls back to local limiter when RPC throws", async () => {
    const mockSupabase = {
      rpc: vi.fn().mockRejectedValue(new Error("network error")),
    };

    const result = await isRateLimited(mockSupabase, "fallback_key_2", 1, 10_000);
    expect(result).toBe(false);
  });

  it("local fallback still enforces limits when RPC is down", async () => {
    const mockSupabase = {
      rpc: vi.fn().mockRejectedValue(new Error("network error")),
    };

    // Use a unique key to avoid state from other tests
    const key = "fallback_enforce_" + Date.now();
    const r1 = await isRateLimited(mockSupabase, key, 1, 10_000);
    const r2 = await isRateLimited(mockSupabase, key, 1, 10_000);

    expect(r1).toBe(false);
    expect(r2).toBe(true);
  });
});

describe("isRateLimitedLocal — extended", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("prunes store when exceeding max size", () => {
    // Fill store with many keys
    for (let i = 0; i < 5001; i++) {
      isRateLimitedLocal(`prune_test_${i}`, 10, 60_000);
    }
    // Should not throw and continue working
    const result = isRateLimitedLocal("prune_test_final", 10, 60_000);
    expect(result).toBe(false);
  });
});

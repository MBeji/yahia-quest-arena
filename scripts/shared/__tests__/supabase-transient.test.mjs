// @vitest-environment node
import { describe, expect, it, vi } from "vitest";
import {
  isTransient,
  RETRY_DELAYS_MS,
  transientHint,
  withTransientRetry,
} from "../supabase-transient.mjs";

/** The exact string four scheduled runs died on, 2026-08-26 (report-triage, report-apply). */
const JWT_SKEW = "JWT issued at future";

describe("isTransient", () => {
  it("recognises the provider clock-skew message that killed the report crons", () => {
    expect(isTransient(JWT_SKEW)).toBe(true);
  });

  it("recognises ordinary transport failures", () => {
    for (const msg of [
      "fetch failed",
      "socket hang up",
      "read ECONNRESET",
      "connect ETIMEDOUT 1.2.3.4:443",
      "getaddrinfo EAI_AGAIN db.supabase.co",
      "503 Service Unavailable",
      "504 Gateway Timeout",
    ]) {
      expect(isTransient(msg), msg).toBe(true);
    }
  });

  // The whole point of an allow-list: OUR bugs must go red on the first attempt,
  // not 14 seconds later. A retry that hides a schema or RLS mistake is worse
  // than no retry at all.
  it("refuses to retry the failures that are ours", () => {
    for (const msg of [
      'permission denied for table "bug_reports"',
      "new row violates row-level security policy",
      'column "statuss" does not exist',
      "invalid input syntax for type uuid",
      "JWT expired",
      "Invalid API key",
    ]) {
      expect(isTransient(msg), msg).toBe(false);
    }
  });

  it("treats a missing message as non-transient", () => {
    expect(isTransient(undefined)).toBe(false);
    expect(isTransient(null)).toBe(false);
    expect(isTransient("")).toBe(false);
  });
});

describe("transientHint", () => {
  it("names the cause when the failure is upstream", () => {
    expect(transientHint(JWT_SKEW)).toContain("docs/agents/gardes.md");
  });

  it("stays silent on our own bugs, so they are not dressed up as an outage", () => {
    expect(transientHint('permission denied for table "bug_reports"')).toBe("");
  });
});

describe("withTransientRetry", () => {
  const ok = { data: [{ id: "1" }], error: null };
  const skew = { data: null, error: { message: JWT_SKEW } };
  const mine = { data: null, error: { message: "permission denied for table x" } };

  it("returns the first success without sleeping", async () => {
    const sleep = vi.fn();
    const run = vi.fn().mockResolvedValue(ok);
    await expect(withTransientRetry(run, { sleep, onRetry: () => {} })).resolves.toEqual(ok);
    expect(run).toHaveBeenCalledTimes(1);
    expect(sleep).not.toHaveBeenCalled();
  });

  it("retries a blip and returns the success that follows", async () => {
    const sleep = vi.fn().mockResolvedValue(undefined);
    const run = vi.fn().mockResolvedValueOnce(skew).mockResolvedValueOnce(ok);
    await expect(withTransientRetry(run, { sleep, onRetry: () => {} })).resolves.toEqual(ok);
    expect(run).toHaveBeenCalledTimes(2);
    expect(sleep).toHaveBeenCalledWith(RETRY_DELAYS_MS[0]);
  });

  it("gives up after the last delay and hands the caller the final error", async () => {
    const sleep = vi.fn().mockResolvedValue(undefined);
    const run = vi.fn().mockResolvedValue(skew);
    await expect(withTransientRetry(run, { sleep, onRetry: () => {} })).resolves.toEqual(skew);
    expect(run).toHaveBeenCalledTimes(RETRY_DELAYS_MS.length + 1);
    expect(sleep.mock.calls.map(([ms]) => ms)).toEqual(RETRY_DELAYS_MS);
  });

  it("does not retry an error that is ours", async () => {
    const sleep = vi.fn();
    const run = vi.fn().mockResolvedValue(mine);
    await expect(withTransientRetry(run, { sleep, onRetry: () => {} })).resolves.toEqual(mine);
    expect(run).toHaveBeenCalledTimes(1);
  });

  it("says out loud that it is retrying, and names the table", async () => {
    const onRetry = vi.fn();
    const run = vi.fn().mockResolvedValueOnce(skew).mockResolvedValueOnce(ok);
    await withTransientRetry(run, { sleep: vi.fn(), onRetry, label: "bug_reports" });
    expect(onRetry).toHaveBeenCalledTimes(1);
    expect(onRetry.mock.calls[0][0]).toContain("bug_reports");
    expect(onRetry.mock.calls[0][0]).toContain(JWT_SKEW);
  });
});

import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { captureError, consumeLastCapturedError } from "@/shared/lib/error-capture";

describe("consumeLastCapturedError", () => {
  beforeEach(() => {
    vi.useFakeTimers();
    // Clear any previous captured error by consuming it
    consumeLastCapturedError();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("returns undefined when nothing was captured", () => {
    expect(consumeLastCapturedError()).toBeUndefined();
  });

  it("returns undefined on subsequent calls (consumed)", () => {
    // After first consume, second should be undefined
    expect(consumeLastCapturedError()).toBeUndefined();
    expect(consumeLastCapturedError()).toBeUndefined();
  });

  it("captures a global 'error' event and returns it on consume", () => {
    const error = new Error("boom");
    globalThis.dispatchEvent(new ErrorEvent("error", { error }));

    expect(consumeLastCapturedError()).toBe(error);
    // consumed -> next call is undefined
    expect(consumeLastCapturedError()).toBeUndefined();
  });

  it("captures an 'unhandledrejection' reason and returns it on consume", () => {
    const reason = new Error("rejected");
    globalThis.dispatchEvent(
      new PromiseRejectionEvent("unhandledrejection", {
        promise: Promise.reject(reason).catch(() => undefined) as unknown as Promise<unknown>,
        reason,
      }),
    );

    expect(consumeLastCapturedError()).toBe(reason);
  });

  // La voie Node : aucun événement global n'y existe pour un throw que le
  // framework attrape, c'est donc le middleware de requête qui dépose l'erreur.
  it("returns an error handed over explicitly, once", () => {
    const error = new Error("seen by the request middleware");
    captureError(error);

    expect(consumeLastCapturedError()).toBe(error);
    expect(consumeLastCapturedError()).toBeUndefined();
  });

  it("keeps the most recent error when two are captured before a consume", () => {
    captureError(new Error("first"));
    const second = new Error("second");
    captureError(second);

    expect(consumeLastCapturedError()).toBe(second);
  });

  it("returns undefined and clears state once the TTL (5s) elapses", () => {
    const error = new Error("stale");
    globalThis.dispatchEvent(new ErrorEvent("error", { error }));

    // Advance beyond TTL_MS (5_000ms)
    vi.advanceTimersByTime(5_001);

    expect(consumeLastCapturedError()).toBeUndefined();
    // State was cleared, so a second call is still undefined
    expect(consumeLastCapturedError()).toBeUndefined();
  });
});

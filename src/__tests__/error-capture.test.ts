import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { consumeLastCapturedError } from "@/lib/error-capture";

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
});

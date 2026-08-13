import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockCapture } = vi.hoisted(() => ({ mockCapture: vi.fn() }));
vi.mock("@/shared/lib/product-analytics", () => ({ captureProductEvent: mockCapture }));

import {
  buildVitalsPayload,
  initWebVitals,
  __resetWebVitalsForTests,
} from "@/shared/lib/web-vitals";

describe("buildVitalsPayload", () => {
  it("rounds, rates, and keeps CLS at three decimals", () => {
    const payload = buildVitalsPayload({ lcp: 1234.6, cls: 0.05123, inp: 190.2 }, "/programme");

    expect(payload).toEqual({
      path: "/programme",
      lcp: 1235,
      lcp_rating: "good",
      cls: 0.051,
      cls_rating: "good",
      inp: 190,
      inp_rating: "good",
    });
  });

  it("rates each metric against its own thresholds", () => {
    const payload = buildVitalsPayload({ lcp: 3000, cls: 0.3, ttfb: 900 }, "/")!;
    expect(payload.lcp_rating).toBe("needs-improvement");
    expect(payload.cls_rating).toBe("poor");
    expect(payload.ttfb_rating).toBe("needs-improvement");
  });

  it("returns null when nothing was measured, rather than a row of nulls", () => {
    // A dashboard averaging empty rows is worse than a dashboard missing them.
    expect(buildVitalsPayload({}, "/")).toBeNull();
    expect(buildVitalsPayload({ lcp: Number.NaN }, "/")).toBeNull();
  });

  it("omits metrics the browser never reported", () => {
    const payload = buildVitalsPayload({ lcp: 1000 }, "/")!;
    expect(payload).toHaveProperty("lcp");
    expect(payload).not.toHaveProperty("cls");
    expect(payload).not.toHaveProperty("inp");
  });
});

describe("initWebVitals", () => {
  const observed: string[] = [];
  /** entry type → the observer callback registered for it, so tests can feed entries. */
  const callbacks = new Map<string, PerformanceObserverCallback>();

  /** Hand `entries` to whatever observer registered for `type`. */
  function emit(type: string, entries: Partial<PerformanceEntry>[]): void {
    const cb = callbacks.get(type);
    if (!cb) throw new Error(`nothing observing "${type}"`);
    cb(
      { getEntries: () => entries as PerformanceEntry[] } as PerformanceObserverEntryList,
      {} as PerformanceObserver,
    );
  }

  beforeEach(() => {
    mockCapture.mockReset();
    observed.length = 0;
    callbacks.clear();
    __resetWebVitalsForTests();

    class FakePO {
      constructor(private cb: PerformanceObserverCallback) {}
      observe(init: { type: string }) {
        observed.push(init.type);
        callbacks.set(init.type, this.cb);
      }
      disconnect() {}
    }
    vi.stubGlobal("PerformanceObserver", FakePO as unknown as typeof PerformanceObserver);
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it("observes the four entry types the metrics need", () => {
    initWebVitals();
    expect(observed).toEqual(
      expect.arrayContaining(["largest-contentful-paint", "paint", "layout-shift", "event"]),
    );
  });

  it("is idempotent — a second call does not double-arm the observers", () => {
    initWebVitals();
    const afterFirst = observed.length;
    initWebVitals();
    expect(observed.length).toBe(afterFirst);
  });

  it("never throws when PerformanceObserver rejects an entry type", () => {
    class ThrowingPO {
      constructor(_cb: PerformanceObserverCallback) {}
      observe() {
        throw new Error("unsupported entry type");
      }
      disconnect() {}
    }
    vi.stubGlobal("PerformanceObserver", ThrowingPO as unknown as typeof PerformanceObserver);
    expect(() => initWebVitals()).not.toThrow();
  });

  it("never throws when PerformanceObserver is absent entirely", () => {
    vi.stubGlobal("PerformanceObserver", undefined);
    expect(() => initWebVitals()).not.toThrow();
  });

  it("sends exactly one beacon, even across repeated terminal signals", () => {
    initWebVitals();
    emit("largest-contentful-paint", [{ startTime: 1500 }]);

    window.dispatchEvent(new Event("pagehide"));
    window.dispatchEvent(new Event("pagehide"));
    document.dispatchEvent(new Event("visibilitychange"));

    expect(mockCapture).toHaveBeenCalledTimes(1);
    expect(mockCapture).toHaveBeenCalledWith(
      "web_vitals",
      expect.objectContaining({ lcp: 1500, lcp_rating: "good" }),
    );
  });

  it("keeps the LAST largest-contentful-paint, since LCP is revised upward", () => {
    initWebVitals();
    emit("largest-contentful-paint", [{ startTime: 800 }]);
    emit("largest-contentful-paint", [{ startTime: 2600 }]);

    window.dispatchEvent(new Event("pagehide"));

    expect(mockCapture).toHaveBeenCalledWith(
      "web_vitals",
      expect.objectContaining({ lcp: 2600, lcp_rating: "needs-improvement" }),
    );
  });

  it("ignores layout shifts that follow a user interaction", () => {
    initWebVitals();
    emit("layout-shift", [
      { startTime: 100, value: 0.4, hadRecentInput: true } as never,
      { startTime: 200, value: 0.05, hadRecentInput: false } as never,
    ]);

    window.dispatchEvent(new Event("pagehide"));

    // 0.4 was input-driven and expected; only the 0.05 counts.
    expect(mockCapture).toHaveBeenCalledWith(
      "web_vitals",
      expect.objectContaining({ cls: 0.05, cls_rating: "good" }),
    );
  });

  it("reports the WORST CLS session window, not the running total", () => {
    initWebVitals();
    // Two windows separated by a >1 s gap: 0.06 then 0.09. Summing would give
    // 0.15 ("needs improvement"); the real CLS is the worst window, 0.09.
    emit("layout-shift", [
      { startTime: 1000, value: 0.06, hadRecentInput: false } as never,
      { startTime: 5000, value: 0.09, hadRecentInput: false } as never,
    ]);

    window.dispatchEvent(new Event("pagehide"));

    expect(mockCapture).toHaveBeenCalledWith("web_vitals", expect.objectContaining({ cls: 0.09 }));
  });

  it("counts only real interactions towards INP", () => {
    initWebVitals();
    emit("event", [
      { duration: 900 } as never, // no interactionId → not an interaction
      { duration: 240, interactionId: 7 } as never,
    ]);

    window.dispatchEvent(new Event("pagehide"));

    expect(mockCapture).toHaveBeenCalledWith(
      "web_vitals",
      expect.objectContaining({ inp: 240, inp_rating: "needs-improvement" }),
    );
  });
});

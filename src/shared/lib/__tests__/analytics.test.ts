import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";

/**
 * The analytics module reads `import.meta.env` and mutates module-level state
 * (`installed`, `lastTrackedPath`), so each test re-imports it fresh after
 * stubbing the env it needs.
 */
async function loadModule() {
  return import("@/shared/lib/analytics");
}

beforeEach(() => {
  vi.resetModules();
  delete window.dataLayer;
  delete window.gtag;
  document.head.querySelectorAll("script[src*='googletagmanager']").forEach((s) => s.remove());
});

afterEach(() => {
  vi.unstubAllEnvs();
});

describe("GA_MEASUREMENT_ID", () => {
  it("defaults to the project data stream when no env override is set", async () => {
    const { GA_MEASUREMENT_ID } = await loadModule();
    expect(GA_MEASUREMENT_ID).toBe("G-H0JRQ7192V");
  });

  it("honours the VITE_GA_MEASUREMENT_ID override (trimmed)", async () => {
    vi.stubEnv("VITE_GA_MEASUREMENT_ID", "  G-TEST12345  ");
    const { GA_MEASUREMENT_ID } = await loadModule();
    expect(GA_MEASUREMENT_ID).toBe("G-TEST12345");
  });
});

describe("isAnalyticsEnabled", () => {
  it("is false outside a production build (the unit run)", async () => {
    const { isAnalyticsEnabled } = await loadModule();
    expect(isAnalyticsEnabled()).toBe(false);
  });

  it("is true in a production build with a Measurement ID and a window", async () => {
    vi.stubEnv("PROD", true);
    const { isAnalyticsEnabled } = await loadModule();
    expect(isAnalyticsEnabled()).toBe(true);
  });

  it("is false in production when the Measurement ID is blank", async () => {
    vi.stubEnv("PROD", true);
    vi.stubEnv("VITE_GA_MEASUREMENT_ID", "   ");
    const { isAnalyticsEnabled } = await loadModule();
    expect(isAnalyticsEnabled()).toBe(false);
  });
});

describe("initAnalytics", () => {
  it("no-ops (injects nothing) when disabled", async () => {
    const { initAnalytics } = await loadModule();
    initAnalytics();
    expect(document.head.querySelector("script[src*='googletagmanager']")).toBeNull();
    expect(window.gtag).toBeUndefined();
  });

  it("injects the external gtag.js loader and configures the stream when enabled", async () => {
    vi.stubEnv("PROD", true);
    const { initAnalytics, GA_MEASUREMENT_ID } = await loadModule();
    initAnalytics();

    const loader = document.head.querySelector<HTMLScriptElement>(
      "script[src*='googletagmanager']",
    );
    expect(loader).not.toBeNull();
    expect(loader?.async).toBe(true);
    expect(loader?.src).toContain(`gtag/js?id=${GA_MEASUREMENT_ID}`);
    expect(typeof window.gtag).toBe("function");
    // js + config commands recorded on the dataLayer, initial page_view suppressed.
    const entries = (window.dataLayer as IArguments[]).map((entry) => Array.from(entry));
    expect(entries).toEqual([
      ["js", expect.any(Date)],
      ["config", GA_MEASUREMENT_ID, { send_page_view: false }],
    ]);
    // Regression guard (prod incident 2026-07-01): entries must be exotic
    // `arguments` objects — gtag.js mis-processes plain arrays and can throw
    // synchronously in the caller's stack once its own push() is installed.
    for (const entry of window.dataLayer as unknown[]) {
      expect(Array.isArray(entry)).toBe(false);
    }
  });

  it("survives a hijacked dataLayer.push (gtag.js replaces it after load)", async () => {
    vi.stubEnv("PROD", true);
    const { initAnalytics, trackPageview } = await loadModule();
    // Simulate the loaded library: gtag.js swaps dataLayer.push for its own
    // processor, which runs synchronously inside our callers and may throw.
    window.dataLayer = [];
    (window.dataLayer as unknown[]).push = () => {
      throw new Error("GTM internal failure");
    };
    expect(() => initAnalytics()).not.toThrow();
    expect(() => trackPageview("/dashboard")).not.toThrow();
  });

  it("is idempotent — a second call injects no second loader", async () => {
    vi.stubEnv("PROD", true);
    const { initAnalytics } = await loadModule();
    initAnalytics();
    initAnalytics();
    expect(document.head.querySelectorAll("script[src*='googletagmanager']")).toHaveLength(1);
  });
});

describe("trackPageview", () => {
  it("no-ops when disabled", async () => {
    const { trackPageview } = await loadModule();
    window.gtag = vi.fn();
    trackPageview("/dashboard");
    expect(window.gtag).not.toHaveBeenCalled();
  });

  it("never propagates a throw from window.gtag (third-party code)", async () => {
    vi.stubEnv("PROD", true);
    const { initAnalytics, trackPageview } = await loadModule();
    initAnalytics();
    window.gtag = () => {
      throw new Error("No default value");
    };
    expect(() => trackPageview("/quest")).not.toThrow();
  });

  it("sends a page_view event and de-dupes consecutive identical paths", async () => {
    vi.stubEnv("PROD", true);
    const { initAnalytics, trackPageview } = await loadModule();
    initAnalytics();
    const gtag = vi.fn();
    window.gtag = gtag;

    trackPageview("/dashboard");
    trackPageview("/dashboard"); // duplicate — ignored
    trackPageview("/shop");

    expect(gtag).toHaveBeenCalledTimes(2);
    expect(gtag).toHaveBeenNthCalledWith(
      1,
      "event",
      "page_view",
      expect.objectContaining({ page_path: "/dashboard" }),
    );
    expect(gtag).toHaveBeenNthCalledWith(
      2,
      "event",
      "page_view",
      expect.objectContaining({ page_path: "/shop" }),
    );
  });
});

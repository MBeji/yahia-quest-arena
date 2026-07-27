import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";

/**
 * The module reads `import.meta.env` at import time and keeps module-level state
 * (the de-dupe path, the in-memory distinct id), so every test re-imports it
 * fresh after stubbing the env it needs.
 */
async function loadModule() {
  return import("@/shared/lib/product-analytics");
}

/** Enable the module the way a production build with a configured key does. */
async function loadEnabled() {
  vi.stubEnv("PROD", true);
  vi.stubEnv("VITE_POSTHOG_KEY", "phc_test_key");
  return loadModule();
}

beforeEach(() => {
  vi.resetModules();
  window.localStorage.clear();
  vi.stubGlobal("fetch", vi.fn().mockResolvedValue(new Response(null, { status: 200 })));
});

afterEach(() => {
  vi.unstubAllEnvs();
  vi.unstubAllGlobals();
});

describe("isProductAnalyticsEnabled", () => {
  it("is false outside a production build (the unit run)", async () => {
    const { isProductAnalyticsEnabled } = await loadModule();
    expect(isProductAnalyticsEnabled()).toBe(false);
  });

  it("is false in production when no key is configured", async () => {
    vi.stubEnv("PROD", true);
    const { isProductAnalyticsEnabled } = await loadModule();
    expect(isProductAnalyticsEnabled()).toBe(false);
  });

  it("is false in production when the key is blank", async () => {
    vi.stubEnv("PROD", true);
    vi.stubEnv("VITE_POSTHOG_KEY", "   ");
    const { isProductAnalyticsEnabled } = await loadModule();
    expect(isProductAnalyticsEnabled()).toBe(false);
  });

  it("is true in a production build with a key and a window", async () => {
    const { isProductAnalyticsEnabled } = await loadEnabled();
    expect(isProductAnalyticsEnabled()).toBe(true);
  });
});

describe("POSTHOG_HOST", () => {
  it("defaults to the EU ingest origin (data residency)", async () => {
    const { POSTHOG_HOST, POSTHOG_DEFAULT_HOST } = await loadModule();
    expect(POSTHOG_DEFAULT_HOST).toBe("https://eu.i.posthog.com");
    expect(POSTHOG_HOST).toBe("https://eu.i.posthog.com");
  });

  it("honours the VITE_POSTHOG_HOST override (trimmed)", async () => {
    vi.stubEnv("VITE_POSTHOG_HOST", "  https://ph.example.com  ");
    const { POSTHOG_HOST } = await loadModule();
    expect(POSTHOG_HOST).toBe("https://ph.example.com");
  });
});

describe("buildCaptureBody", () => {
  it("never creates a person profile (anonymous by construction)", async () => {
    const { buildCaptureBody } = await loadModule();
    const body = buildCaptureBody({
      event: "$pageview",
      distinctId: "did-1",
      key: "phc_x",
      timestampIso: "2026-07-27T10:00:00.000Z",
      properties: { $pathname: "/programme" },
    });
    const properties = body.properties as Record<string, unknown>;
    expect(properties.$process_person_profile).toBe(false);
    expect(properties.$pathname).toBe("/programme");
    expect(body).toMatchObject({
      api_key: "phc_x",
      event: "$pageview",
      distinct_id: "did-1",
      timestamp: "2026-07-27T10:00:00.000Z",
    });
  });

  it("cannot be tricked into re-enabling person profiles from a caller property", async () => {
    const { buildCaptureBody } = await loadModule();
    const body = buildCaptureBody({
      event: "x",
      distinctId: "d",
      key: "k",
      timestampIso: "2026-07-27T10:00:00.000Z",
      properties: { $process_person_profile: true },
    });
    expect((body.properties as Record<string, unknown>).$process_person_profile).toBe(false);
  });
});

describe("getDistinctId", () => {
  it("is stable across calls and persisted first-party", async () => {
    const { getDistinctId } = await loadEnabled();
    const first = getDistinctId();
    expect(getDistinctId()).toBe(first);
    expect(window.localStorage.getItem("na9ra.ph_did")).toBe(first);
  });

  it("falls back to an in-memory id when storage throws (private mode)", async () => {
    const { getDistinctId } = await loadEnabled();
    const spy = vi.spyOn(Storage.prototype, "getItem").mockImplementation(() => {
      throw new Error("denied");
    });
    const first = getDistinctId();
    expect(first).toBeTruthy();
    expect(getDistinctId()).toBe(first);
    spy.mockRestore();
  });
});

describe("captureProductEvent", () => {
  it("sends nothing when disabled", async () => {
    const { captureProductEvent } = await loadModule();
    captureProductEvent("video_open", { video_id: "abc" });
    expect(fetch).not.toHaveBeenCalled();
  });

  it("posts to the EU ingest endpoint with the event payload", async () => {
    const { captureProductEvent } = await loadEnabled();
    captureProductEvent("video_open", { video_id: "abc" });

    expect(fetch).toHaveBeenCalledTimes(1);
    const [url, init] = vi.mocked(fetch).mock.calls[0] as [string, RequestInit];
    expect(url).toBe("https://eu.i.posthog.com/i/v0/e/");
    expect(init.method).toBe("POST");
    expect(init.keepalive).toBe(true);
    const body = JSON.parse(init.body as string) as Record<string, unknown>;
    expect(body.event).toBe("video_open");
    expect(body.api_key).toBe("phc_test_key");
    expect((body.properties as Record<string, unknown>).video_id).toBe("abc");
  });

  it("never throws when the network rejects", async () => {
    const { captureProductEvent } = await loadEnabled();
    vi.mocked(fetch).mockRejectedValueOnce(new Error("offline"));
    expect(() => captureProductEvent("video_open")).not.toThrow();
  });
});

describe("capturePageview", () => {
  it("de-dupes consecutive identical paths on its own state", async () => {
    const { capturePageview } = await loadEnabled();
    capturePageview("/programme", "production");
    capturePageview("/programme", "production"); // duplicate — ignored
    capturePageview("/extras", "production");
    expect(fetch).toHaveBeenCalledTimes(2);
  });

  it("carries the traffic_type so preview/local sessions can be filtered out", async () => {
    const { capturePageview } = await loadEnabled();
    capturePageview("/dashboard", "developer");
    const [, init] = vi.mocked(fetch).mock.calls[0] as [string, RequestInit];
    const body = JSON.parse(init.body as string) as Record<string, unknown>;
    const properties = body.properties as Record<string, unknown>;
    expect(body.event).toBe("$pageview");
    expect(properties.traffic_type).toBe("developer");
    expect(properties.$pathname).toBe("/dashboard");
  });

  it("sends nothing when disabled", async () => {
    const { capturePageview } = await loadModule();
    capturePageview("/programme", "production");
    expect(fetch).not.toHaveBeenCalled();
  });
});

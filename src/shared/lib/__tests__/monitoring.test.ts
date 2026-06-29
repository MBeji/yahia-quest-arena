import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { parseDsn, buildSentryEvent, captureException } from "@/shared/lib/monitoring";

const DSN = "https://abc123@o4511564492570624.ingest.de.sentry.io/4511564703137872";
const EVENT_OPTS = {
  eventId: "e".repeat(32),
  timestampSec: 1000,
  release: "deadbeef",
  environment: "production",
};

describe("parseDsn", () => {
  it("parses a valid DSN into the envelope ingest URL + public key", () => {
    const p = parseDsn(DSN);
    expect(p?.publicKey).toBe("abc123");
    expect(p?.ingestUrl).toBe(
      "https://o4511564492570624.ingest.de.sentry.io/api/4511564703137872/envelope/",
    );
  });

  it("returns undefined for a malformed or incomplete DSN", () => {
    expect(parseDsn("not a url")).toBeUndefined();
    expect(parseDsn("https://o123.ingest.de.sentry.io/")).toBeUndefined(); // no key/project
  });
});

describe("buildSentryEvent", () => {
  it("carries level, source tag, request path and the exception", () => {
    const ev = buildSentryEvent(
      "boom",
      new Error("kaboom"),
      { source: "logger", path: "/dash" },
      EVENT_OPTS,
    );
    expect(ev.level).toBe("error");
    expect(ev.tags.source).toBe("logger");
    expect(ev.request?.url).toBe("/dash");
    expect(ev.exception?.values[0]).toEqual({ type: "Error", value: "kaboom" });
    expect(ev.release).toBe("deadbeef");
  });

  it("attaches the raw stack as scrubbed extra (no parsed frames)", () => {
    const err = new Error("kaboom");
    const ev = buildSentryEvent("boom", err, {}, EVENT_OPTS);
    expect(typeof (ev.extra as Record<string, unknown>)?.stack).toBe("string");
  });

  it("scrubs e-mail addresses from the message and the exception value", () => {
    const ev = buildSentryEvent(
      "user a@b.com failed",
      new Error("contact c@d.org"),
      {},
      EVENT_OPTS,
    );
    const json = JSON.stringify(ev);
    expect(json).not.toContain("a@b.com");
    expect(json).not.toContain("c@d.org");
    expect(json).toContain("[redacted-email]");
  });

  it("redacts sensitive extra keys but keeps safe ones", () => {
    const ev = buildSentryEvent(
      "x",
      undefined,
      { extra: { authToken: "xyz", email: "a@b.com", userId: "u1", safe: "ok" } },
      EVENT_OPTS,
    );
    expect(ev.extra).toMatchObject({
      authToken: "[redacted]",
      email: "[redacted]",
      userId: "u1",
      safe: "ok",
    });
  });

  it("omits the exception block when there is no error", () => {
    const ev = buildSentryEvent("just a message", undefined, {}, EVENT_OPTS);
    expect(ev.exception).toBeUndefined();
    expect(ev.message).toEqual({ formatted: "just a message" });
  });
});

describe("captureException", () => {
  beforeEach(() => {
    vi.unstubAllEnvs();
    vi.unstubAllGlobals();
  });
  afterEach(() => {
    vi.unstubAllEnvs();
    vi.unstubAllGlobals();
  });

  it("is a no-op without a DSN (never calls fetch)", () => {
    const fetchMock = vi.fn();
    vi.stubGlobal("fetch", fetchMock);
    captureException("boom", new Error("x"));
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it("POSTs a Sentry envelope to the right endpoint when a DSN is set", () => {
    vi.stubEnv("VITE_SENTRY_DSN", DSN);
    const fetchMock = vi.fn(() => Promise.resolve(new Response(null, { status: 200 })));
    vi.stubGlobal("fetch", fetchMock);

    captureException("boom", new Error("kaboom"), { source: "test", path: "/dash" });

    expect(fetchMock).toHaveBeenCalledTimes(1);
    const [url, init] = fetchMock.mock.calls[0] as unknown as [string, RequestInit];
    expect(url).toContain("/api/4511564703137872/envelope/");
    expect(url).toContain("sentry_key=abc123");
    expect(init.method).toBe("POST");
    const body = String(init.body);
    expect(body).toContain('"type":"event"');
    expect(body).toContain("kaboom");
  });

  it("never throws, even if fetch itself throws", () => {
    vi.stubEnv("VITE_SENTRY_DSN", DSN);
    vi.stubGlobal("fetch", () => {
      throw new Error("network down");
    });
    expect(() => captureException("boom", new Error("x"))).not.toThrow();
  });
});

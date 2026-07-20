import { beforeEach, describe, expect, it, vi } from "vitest";

const {
  mockRenderErrorPage,
  mockConsumeLastCapturedError,
  mockLoggerError,
  mockServerFetch,
  mockHandleHealthRequest,
} = vi.hoisted(() => ({
  mockRenderErrorPage: vi.fn(() => "<html>fallback</html>"),
  mockConsumeLastCapturedError: vi.fn((): unknown => undefined),
  mockLoggerError: vi.fn(),
  mockServerFetch: vi.fn(),
  mockHandleHealthRequest: vi.fn(),
}));

vi.mock("@/shared/lib/health", () => ({
  handleHealthRequest: mockHandleHealthRequest,
}));

vi.mock("@tanstack/react-start/server-entry", () => ({
  default: {
    fetch: mockServerFetch,
  },
}));

vi.mock("@/shared/lib/error-page", () => ({
  renderErrorPage: mockRenderErrorPage,
}));

vi.mock("@/shared/lib/error-capture", () => ({
  consumeLastCapturedError: mockConsumeLastCapturedError,
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: {
    error: mockLoggerError,
  },
}));

describe("server fetch wrapper", () => {
  beforeEach(() => {
    vi.resetModules();
    mockServerFetch.mockReset();
    mockLoggerError.mockReset();
    mockConsumeLastCapturedError.mockReset();
    mockRenderErrorPage.mockReset();
    mockRenderErrorPage.mockReturnValue("<html>fallback</html>");
    mockHandleHealthRequest.mockReset();
  });

  it("serves /api/health BEFORE the bot guard, so a monitor is never refused", async () => {
    mockHandleHealthRequest.mockResolvedValue(
      new Response('{"status":"ok"}', {
        status: 200,
        headers: { "content-type": "application/json" },
      }),
    );

    const server = (await import("@/server")).default;
    // `python-requests` is on the guard's block list (403) — and it is exactly
    // the kind of agent a real uptime monitor announces itself with. If this
    // ever regresses to running after the guard, the monitor reports a
    // permanent outage that does not exist.
    const request = new Request("https://app.local/api/health", {
      headers: { "user-agent": "python-requests/2.31.0" },
    });

    const response = await server.fetch(request, {}, {});

    expect(response.status).toBe(200);
    expect(mockHandleHealthRequest).toHaveBeenCalled();
    expect(mockServerFetch).not.toHaveBeenCalled();
  });

  it("answers 503 JSON — not the branded HTML page — when the probe itself throws", async () => {
    mockHandleHealthRequest.mockRejectedValue(new Error("boom"));

    const server = (await import("@/server")).default;
    const response = await server.fetch(new Request("https://app.local/api/health"), {}, {});

    expect(response.status).toBe(503);
    expect(response.headers.get("content-type")).toContain("application/json");
    expect(response.headers.get("cache-control")).toContain("no-store");
    expect(mockLoggerError).toHaveBeenCalledWith("Health endpoint failed", expect.anything());
  });

  it("returns branded HTML response when server entry throws", async () => {
    mockServerFetch.mockRejectedValue(new Error("boom"));

    const server = (await import("@/server")).default;
    const request = new Request("https://app.local/fail");

    const response = await server.fetch(request, {}, {});

    expect(response.status).toBe(500);
    expect(response.headers.get("content-type")).toContain("text/html");
    await expect(response.text()).resolves.toBe("<html>fallback</html>");
    expect(mockLoggerError).toHaveBeenCalledWith(
      "Unhandled server fetch error",
      expect.objectContaining({ path: "/fail" }),
    );
  });

  it("normalizes swallowed catastrophic SSR JSON errors", async () => {
    mockServerFetch.mockResolvedValue(
      new Response(JSON.stringify({ unhandled: true, message: "HTTPError", status: 500 }), {
        status: 500,
        headers: { "content-type": "application/json" },
      }),
    );
    mockConsumeLastCapturedError.mockReturnValue(new Error("captured-ssr"));

    const server = (await import("@/server")).default;
    const request = new Request("https://app.local/catastrophic");

    const response = await server.fetch(request, {}, {});

    expect(response.status).toBe(500);
    expect(response.headers.get("content-type")).toContain("text/html");
    await expect(response.text()).resolves.toBe("<html>fallback</html>");
    expect(mockLoggerError).toHaveBeenCalledWith(
      "SSR response normalized after swallowed catastrophic error",
      expect.objectContaining({ status: 500 }),
    );
  });

  it("keeps non-catastrophic responses unchanged", async () => {
    const upstream = new Response(JSON.stringify({ ok: true }), {
      status: 500,
      headers: { "content-type": "application/json" },
    });
    mockServerFetch.mockResolvedValue(upstream);

    const server = (await import("@/server")).default;
    const request = new Request("https://app.local/regular");

    const response = await server.fetch(request, {}, {});

    expect(response).toBe(upstream);
    expect(mockLoggerError).not.toHaveBeenCalled();
  });
});

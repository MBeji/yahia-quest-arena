import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockRenderErrorPage, mockConsumeLastCapturedError, mockLoggerError, mockServerFetch } =
  vi.hoisted(() => ({
    mockRenderErrorPage: vi.fn(() => "<html>fallback</html>"),
    mockConsumeLastCapturedError: vi.fn((): unknown => undefined),
    mockLoggerError: vi.fn(),
    mockServerFetch: vi.fn(),
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

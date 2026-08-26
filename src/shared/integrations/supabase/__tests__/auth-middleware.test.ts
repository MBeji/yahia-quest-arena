// @vitest-environment node
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetRequest, mockCreateClient, mockGetClaims, mockLoggerError, mockLoggerWarn } =
  vi.hoisted(() => {
    return {
      mockGetRequest: vi.fn(),
      mockCreateClient: vi.fn(),
      mockGetClaims: vi.fn(),
      mockLoggerError: vi.fn(),
      mockLoggerWarn: vi.fn(),
    };
  });

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({
    server: (handler: unknown) => handler,
  }),
}));

vi.mock("@tanstack/react-start/server", () => ({
  getRequest: mockGetRequest,
}));

// Only `createClient` is stubbed: the middleware also asks the library to
// classify its own errors (`isAuthRetryableFetchError`), and a hand-written
// stand-in would test our idea of auth-js instead of auth-js.
vi.mock("@supabase/supabase-js", async (importOriginal) => ({
  ...(await importOriginal<typeof import("@supabase/supabase-js")>()),
  createClient: mockCreateClient,
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: {
    error: mockLoggerError,
    warn: mockLoggerWarn,
  },
}));

import { AuthRetryableFetchError } from "@supabase/supabase-js";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";

// The mock above makes `.server(handler)` return the handler, so at runtime the
// middleware is directly callable. Cast to a callable for type-checking the tests.
const callMiddleware = requireSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

describe("requireSupabaseAuth", () => {
  const originalUrl = process.env.SUPABASE_URL;
  const originalKey = process.env.SUPABASE_PUBLISHABLE_KEY;

  beforeEach(() => {
    process.env.SUPABASE_URL = "https://example.supabase.co";
    process.env.SUPABASE_PUBLISHABLE_KEY = "public-key";

    mockGetRequest.mockReset();
    mockCreateClient.mockReset();
    mockGetClaims.mockReset();
    mockLoggerError.mockReset();
    mockLoggerWarn.mockReset();

    mockCreateClient.mockReturnValue({
      auth: {
        getClaims: mockGetClaims,
      },
    });
  });

  afterEach(() => {
    if (originalUrl === undefined) {
      delete process.env.SUPABASE_URL;
    } else {
      process.env.SUPABASE_URL = originalUrl;
    }

    if (originalKey === undefined) {
      delete process.env.SUPABASE_PUBLISHABLE_KEY;
    } else {
      process.env.SUPABASE_PUBLISHABLE_KEY = originalKey;
    }
  });

  it("throws and logs when required env vars are missing", async () => {
    delete process.env.SUPABASE_URL;
    delete process.env.SUPABASE_PUBLISHABLE_KEY;

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Missing Supabase environment variable(s)",
    );

    expect(mockLoggerError).toHaveBeenCalledTimes(1);
    expect(mockLoggerError).toHaveBeenCalledWith("Supabase auth middleware misconfiguration", {
      missing: ["SUPABASE_URL", "SUPABASE_PUBLISHABLE_KEY"],
    });
  });

  it("throws when request headers are unavailable", async () => {
    mockGetRequest.mockReturnValue(undefined);

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: No request headers available",
    );
  });

  it("throws when authorization header is missing", async () => {
    mockGetRequest.mockReturnValue({ headers: new Headers() });

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: No authorization header provided",
    );
  });

  it("throws when auth scheme is not Bearer", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Basic abc" }),
    });

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: Only Bearer tokens are supported",
    );
  });

  it("throws when bearer token is empty", async () => {
    mockGetRequest.mockReturnValue({
      headers: {
        get: vi.fn().mockReturnValue("Bearer "),
      },
    });

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: No token provided",
    );
  });

  it("throws when token claims are invalid", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });
    mockGetClaims.mockResolvedValue({ data: null, error: { message: "invalid" } });

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: Invalid token",
    );
  });

  it("throws when token has no subject", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });
    mockGetClaims.mockResolvedValue({ data: { claims: {} }, error: null });

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: No user ID found in token",
    );
  });

  it("forwards context to next() when token is valid", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });

    const claims = {
      sub: "user-1",
      role: "authenticated",
    };

    mockGetClaims.mockResolvedValue({ data: { claims }, error: null });

    const next = vi.fn().mockResolvedValue("ok");

    const result = await callMiddleware({ next } as never);

    expect(result).toBe("ok");
    expect(mockCreateClient).toHaveBeenCalledTimes(1);
    expect(mockCreateClient).toHaveBeenCalledWith(
      "https://example.supabase.co",
      "public-key",
      expect.objectContaining({
        global: {
          headers: {
            Authorization: "Bearer token-123",
          },
        },
      }),
    );

    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({
          userId: "user-1",
          claims,
        }),
      }),
    );
  });

  // `getClaims` is the ONLY refusal in this middleware that depends on a remote
  // service answering — and it used to throw its reason away. #772 (« une panne
  // ne laisse plus Valider actif et sans effet ») shipped saying in as many
  // words that identifying the SERVER failure behind the prod report needed the
  // prod database: the app knew why it had refused, and logged nothing.
  describe("a refused token says WHY it was refused", () => {
    function bearerRequest() {
      mockGetRequest.mockReturnValue({
        url: "https://app.example/_serverFn/getDashboard?token=secret",
        headers: new Headers({ authorization: "Bearer token-123" }),
      });
    }

    it("logs a rejected token as a warning, and keeps the Unauthorized verdict", async () => {
      bearerRequest();
      mockGetClaims.mockResolvedValue({
        data: null,
        error: { message: "invalid JWT: token is expired", status: 401 },
      });

      await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
        "Unauthorized: Invalid token",
      );

      expect(mockLoggerWarn).toHaveBeenCalledWith("Bearer token rejected", {
        path: "/_serverFn/getDashboard",
        error: "invalid JWT: token is expired",
      });
      // An expiring session is routine. Filing it as an error would drown the
      // incident below — the case this whole suite exists to make visible.
      expect(mockLoggerError).not.toHaveBeenCalled();
    });

    it("calls an unreachable Auth service an incident, not a bad token", async () => {
      bearerRequest();
      mockGetClaims.mockResolvedValue({
        data: null,
        error: new AuthRetryableFetchError("request failed", 503),
      });

      await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
        "Auth verification unavailable",
      );

      expect(mockLoggerError).toHaveBeenCalledWith("Auth verification unavailable", {
        path: "/_serverFn/getDashboard",
        error: "request failed",
      });
      expect(mockLoggerWarn).not.toHaveBeenCalled();
    });

    it("treats a rate-limited Auth service the same way", async () => {
      // auth-js does NOT file a 429 as retryable, but "we could not check" is
      // exactly what it means — and on the symmetric-key path (C-1bis) every
      // server fn spends one Auth call, so this is the shape a busy hour takes.
      bearerRequest();
      mockGetClaims.mockResolvedValue({
        data: null,
        error: { message: "rate limit exceeded", status: 429 },
      });

      await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
        "Auth verification unavailable",
      );

      expect(mockLoggerError).toHaveBeenCalledWith("Auth verification unavailable", {
        path: "/_serverFn/getDashboard",
        error: "rate limit exceeded",
      });
    });

    it("never lets the query string into the log line", async () => {
      bearerRequest();
      mockGetClaims.mockResolvedValue({ data: null, error: { message: "boom" } });

      await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow("Unauthorized");

      const [, meta] = mockLoggerWarn.mock.calls[0] as [string, { path: string }];
      expect(meta.path).not.toContain("secret");
    });
  });

  // Perf audit M-1 (server half): this middleware is the only place every server
  // fn passes through, so it is where slow calls get named.
  describe("slow server-function timing", () => {
    function validRequest() {
      mockGetRequest.mockReturnValue({
        url: "https://app.example/_serverFn/getDashboard?token=secret",
        headers: new Headers({ authorization: "Bearer token-123" }),
      });
      mockGetClaims.mockResolvedValue({ data: { claims: { sub: "user-1" } }, error: null });
    }

    it("names a server fn that crosses the slow threshold", async () => {
      validRequest();
      const nowSpy = vi.spyOn(Date, "now");
      nowSpy.mockReturnValueOnce(0).mockReturnValueOnce(1500);

      await callMiddleware({ next: vi.fn().mockResolvedValue("ok") } as never);

      expect(mockLoggerWarn).toHaveBeenCalledWith("Slow server function", {
        path: "/_serverFn/getDashboard",
        durationMs: 1500,
      });
      nowSpy.mockRestore();
    });

    it("stays silent for a healthy call", async () => {
      validRequest();
      const nowSpy = vi.spyOn(Date, "now");
      nowSpy.mockReturnValueOnce(0).mockReturnValueOnce(40);

      await callMiddleware({ next: vi.fn().mockResolvedValue("ok") } as never);

      expect(mockLoggerWarn).not.toHaveBeenCalled();
      nowSpy.mockRestore();
    });

    it("still times a call that threw, and never leaks the query string", async () => {
      validRequest();
      const nowSpy = vi.spyOn(Date, "now");
      nowSpy.mockReturnValueOnce(0).mockReturnValueOnce(2000);

      await expect(
        callMiddleware({ next: vi.fn().mockRejectedValue(new Error("boom")) } as never),
      ).rejects.toThrow("boom");

      const [, meta] = mockLoggerWarn.mock.calls[0] as [string, { path: string }];
      expect(meta.path).toBe("/_serverFn/getDashboard");
      expect(meta.path).not.toContain("secret");
      nowSpy.mockRestore();
    });
  });
});

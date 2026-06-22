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

vi.mock("@supabase/supabase-js", () => ({
  createClient: mockCreateClient,
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: {
    error: mockLoggerError,
    warn: mockLoggerWarn,
  },
}));

import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";

// The mock above makes `.server(handler)` return the handler, so at runtime the
// middleware is directly callable. Cast to a callable for type-checking the tests.
const callMiddleware = optionalSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

describe("optionalSupabaseAuth", () => {
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

    expect(mockLoggerError).toHaveBeenCalledWith(
      "Supabase optional-auth middleware misconfiguration",
      { missing: ["SUPABASE_URL", "SUPABASE_PUBLISHABLE_KEY"] },
    );
    expect(mockCreateClient).not.toHaveBeenCalled();
  });

  it("falls back to an anonymous client when no request is available", async () => {
    mockGetRequest.mockReturnValue(undefined);
    const next = vi.fn().mockResolvedValue("ok");

    const result = await callMiddleware({ next } as never);

    expect(result).toBe("ok");
    expect(mockGetClaims).not.toHaveBeenCalled();
    // Anonymous client is created WITHOUT an Authorization header.
    expect(mockCreateClient).toHaveBeenCalledTimes(1);
    expect(mockCreateClient.mock.calls[0][2]).not.toHaveProperty("global");
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: null }),
      }),
    );
    expect(next.mock.calls[0][0].context.supabase).toBeDefined();
  });

  it("falls back to anonymous when the authorization header is missing", async () => {
    mockGetRequest.mockReturnValue({ headers: new Headers() });
    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(mockGetClaims).not.toHaveBeenCalled();
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: null }),
      }),
    );
  });

  it("falls back to anonymous when the scheme is not Bearer", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Basic abc" }),
    });
    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(mockGetClaims).not.toHaveBeenCalled();
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: null }),
      }),
    );
  });

  it("falls back to anonymous when the bearer token is empty", async () => {
    mockGetRequest.mockReturnValue({
      headers: { get: vi.fn().mockReturnValue("Bearer ") },
    });
    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(mockGetClaims).not.toHaveBeenCalled();
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: null }),
      }),
    );
  });

  it("degrades to anonymous and warns when the token is invalid", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });
    mockGetClaims.mockResolvedValue({ data: null, error: { message: "invalid" } });
    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(mockLoggerWarn).toHaveBeenCalledTimes(1);
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: null }),
      }),
    );
  });

  it("degrades to anonymous and warns when the token has no subject", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });
    mockGetClaims.mockResolvedValue({ data: { claims: {} }, error: null });
    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(mockLoggerWarn).toHaveBeenCalledTimes(1);
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: null }),
      }),
    );
  });

  it("forwards an authenticated context when the token is valid", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });

    const claims = { sub: "user-1", role: "authenticated" };
    mockGetClaims.mockResolvedValue({ data: { claims }, error: null });

    const next = vi.fn().mockResolvedValue("ok");

    const result = await callMiddleware({ next } as never);

    expect(result).toBe("ok");
    expect(mockCreateClient).toHaveBeenCalledWith(
      "https://example.supabase.co",
      "public-key",
      expect.objectContaining({
        global: { headers: { Authorization: "Bearer token-123" } },
      }),
    );
    expect(mockLoggerWarn).not.toHaveBeenCalled();
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({ userId: "user-1" }),
      }),
    );
  });
});

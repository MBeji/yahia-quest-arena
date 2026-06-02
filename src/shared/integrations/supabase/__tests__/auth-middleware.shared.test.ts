import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetRequest, mockCreateClient, mockGetClaims, mockLoggerError } = vi.hoisted(() => {
  return {
    mockGetRequest: vi.fn(),
    mockCreateClient: vi.fn(),
    mockGetClaims: vi.fn(),
    mockLoggerError: vi.fn(),
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
  },
}));

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";

// The mock above makes `.server(handler)` return the handler, so at runtime the
// middleware is directly callable. Cast to a callable for type-checking the tests.
const callMiddleware = requireSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

describe("requireSupabaseAuth (shared)", () => {
  const originalUrl = process.env.SUPABASE_URL;
  const originalKey = process.env.SUPABASE_PUBLISHABLE_KEY;

  beforeEach(() => {
    process.env.SUPABASE_URL = "https://example.supabase.co";
    process.env.SUPABASE_PUBLISHABLE_KEY = "public-key";

    mockGetRequest.mockReset();
    mockCreateClient.mockReset();
    mockGetClaims.mockReset();
    mockLoggerError.mockReset();

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

  it("throws when token claims are invalid", async () => {
    mockGetRequest.mockReturnValue({
      headers: new Headers({ authorization: "Bearer token-123" }),
    });
    mockGetClaims.mockResolvedValue({ data: null, error: { message: "invalid" } });

    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(
      "Unauthorized: Invalid token",
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
    expect(next).toHaveBeenCalledWith(
      expect.objectContaining({
        context: expect.objectContaining({
          userId: "user-1",
          claims,
        }),
      }),
    );
  });
});

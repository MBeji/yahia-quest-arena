import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks (vitest hoists vi.mock; `mock*`-named vars are allowed in factories) ----
const mockCreateSignedUrls = vi.fn();
const mockStorageFrom = vi.fn(() => ({ createSignedUrls: mockCreateSignedUrls }));
const mockSupabase = { storage: { from: mockStorageFrom } };

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      inputValidator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        // TanStack server fns are invoked as `fn({ data })`; unwrap `data` and run
        // it through the validator, mirroring the real call contract.
        return async (opts: unknown) => {
          const input = (opts as { data?: unknown })?.data;
          return handlerFn({
            data: validatorFn ? validatorFn(input) : input,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({ requireSupabaseAuth: "mw" }));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mw-opt",
}));
vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { getSubjectManuels } from "../manuel.server";

describe("getSubjectManuels", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("signs one PDF url per volume, preserving the authored order", async () => {
    // Returned out of order on purpose — the handler must keep the input order.
    mockCreateSignedUrls.mockResolvedValue({
      data: [
        { path: "102105P02.pdf", signedUrl: "https://s/t2", error: null },
        { path: "102105P01.pdf", signedUrl: "https://s/t1", error: null },
      ],
      error: null,
    });

    const res = await getSubjectManuels({
      data: {
        manuels: [
          { code: "102105P01", label: "الجزء الأول" },
          { code: "102105P02", label: "الجزء الثاني" },
        ],
      },
    });

    expect(res.manuels).toEqual([
      { code: "102105P01", label: "الجزء الأول", url: "https://s/t1" },
      { code: "102105P02", label: "الجزء الثاني", url: "https://s/t2" },
    ]);
    expect(mockStorageFrom).toHaveBeenCalledWith("manuel-eleve");
    expect(mockCreateSignedUrls).toHaveBeenCalledWith(["102105P01.pdf", "102105P02.pdf"], 3600);
  });

  it("skips a volume whose PDF is missing / failed to sign (card degrades)", async () => {
    mockCreateSignedUrls.mockResolvedValue({
      data: [
        { path: "102306.pdf", signedUrl: "https://s/ok", error: null },
        { path: "102407.pdf", signedUrl: "", error: "Object not found" },
      ],
      error: null,
    });

    const res = await getSubjectManuels({
      data: { manuels: [{ code: "102306" }, { code: "102407" }] },
    });

    expect(res.manuels).toEqual([{ code: "102306", label: null, url: "https://s/ok" }]);
  });

  it("returns no manuels when signing fails wholesale", async () => {
    mockCreateSignedUrls.mockResolvedValue({ data: null, error: { message: "boom" } });

    const res = await getSubjectManuels({ data: { manuels: [{ code: "102306" }] } });

    expect(res.manuels).toEqual([]);
  });

  it("rejects a malformed code (path-traversal guard) at validation", async () => {
    await expect(
      getSubjectManuels({ data: { manuels: [{ code: "../secrets" }] } }),
    ).rejects.toThrow();
    expect(mockCreateSignedUrls).not.toHaveBeenCalled();
  });

  it("rejects an oversized volume list", async () => {
    const manuels = Array.from({ length: 9 }, (_, i) => ({ code: `10000${i}` }));
    await expect(getSubjectManuels({ data: { manuels } })).rejects.toThrow();
    expect(mockCreateSignedUrls).not.toHaveBeenCalled();
  });
});

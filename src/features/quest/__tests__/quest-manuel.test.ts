import { describe, it, expect, vi, beforeEach } from "vitest";

// ---- Mocks (vitest hoists vi.mock; `mock*`-named vars are allowed in factories) ----
const mockSingle = vi.fn();
const mockCreateSignedUrls = vi.fn();
const mockStorageFrom = vi.fn(() => ({ createSignedUrls: mockCreateSignedUrls }));
const mockFrom = vi.fn(() => {
  const chain = {
    select: vi.fn(() => chain),
    eq: vi.fn(() => chain),
    single: mockSingle,
  };
  return chain;
});
const mockSupabase = { from: mockFrom, storage: { from: mockStorageFrom } };

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

import { getManuelPageUrls } from "../quest.server";

const CHAPTER_ID = "11111111-1111-4111-8111-111111111111";

describe("getManuelPageUrls", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns a signed url per manuel page, sorted by page number", async () => {
    mockSingle.mockResolvedValue({
      data: { manuel_ref: { code: "103304", pages: "12-13", pageNumbers: [12, 13] } },
      error: null,
    });
    // Returned out of order on purpose — the handler must sort by page.
    mockCreateSignedUrls.mockResolvedValue({
      data: [
        { path: "103304/13.webp", signedUrl: "https://s/13", error: null },
        { path: "103304/12.webp", signedUrl: "https://s/12", error: null },
      ],
      error: null,
    });

    const res = await getManuelPageUrls({ data: { chapterId: CHAPTER_ID } });

    expect(res.pages).toEqual([
      { page: 12, url: "https://s/12" },
      { page: 13, url: "https://s/13" },
    ]);
    expect(mockStorageFrom).toHaveBeenCalledWith("manuel-pages");
    expect(mockCreateSignedUrls).toHaveBeenCalledWith(["103304/12.webp", "103304/13.webp"], 3600);
  });

  it("returns no pages (hides the section) when the chapter has no manuel_ref", async () => {
    mockSingle.mockResolvedValue({ data: { manuel_ref: null }, error: null });

    const res = await getManuelPageUrls({ data: { chapterId: CHAPTER_ID } });

    expect(res.pages).toEqual([]);
    expect(mockCreateSignedUrls).not.toHaveBeenCalled();
  });

  it("skips a page whose object is missing / failed to sign", async () => {
    mockSingle.mockResolvedValue({
      data: { manuel_ref: { code: "103304", pageNumbers: [12, 13] } },
      error: null,
    });
    mockCreateSignedUrls.mockResolvedValue({
      data: [
        { path: "103304/12.webp", signedUrl: "https://s/12", error: null },
        { path: "103304/13.webp", signedUrl: "", error: "Object not found" },
      ],
      error: null,
    });

    const res = await getManuelPageUrls({ data: { chapterId: CHAPTER_ID } });

    expect(res.pages).toEqual([{ page: 12, url: "https://s/12" }]);
  });

  it("returns no pages when the chapter lookup errors", async () => {
    mockSingle.mockResolvedValue({ data: null, error: { message: "boom" } });

    const res = await getManuelPageUrls({ data: { chapterId: CHAPTER_ID } });

    expect(res.pages).toEqual([]);
    expect(mockCreateSignedUrls).not.toHaveBeenCalled();
  });

  it("rejects a malformed code (path-traversal guard) without signing", async () => {
    mockSingle.mockResolvedValue({
      data: { manuel_ref: { code: "../secrets", pageNumbers: [1] } },
      error: null,
    });

    const res = await getManuelPageUrls({ data: { chapterId: CHAPTER_ID } });

    expect(res.pages).toEqual([]);
    expect(mockCreateSignedUrls).not.toHaveBeenCalled();
  });
});

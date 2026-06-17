/**
 * Parcours interest votes — server functions.
 *
 * Same mock harness as dashboard-parcours.test.ts: server fns become directly
 * callable and supabase is a `from`/`rpc` double with a chainable query builder.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
        const wrapped = async (input: unknown) => {
          const data = validatorFn
            ? validatorFn((input as { data?: unknown })?.data ?? input)
            : input;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of ["select", "eq", "order", "limit", "insert", "delete"]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  Object.assign(chain, result);
  return chain;
}

type Fn = (d?: unknown) => Promise<unknown>;

describe("parcours-interest server fns", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  describe("getMyParcoursInterests", () => {
    it("returns the parcours ids the user voted for", async () => {
      mockFrom.mockImplementation(() =>
        mockQuery([{ parcours_id: "ecole-1ere-base" }, { parcours_id: "concours-6eme" }]),
      );
      const { getMyParcoursInterests } = await import("@/features/dashboard");
      const res = (await (getMyParcoursInterests as unknown as Fn)()) as { parcoursIds: string[] };
      expect(res.parcoursIds).toEqual(["ecole-1ere-base", "concours-6eme"]);
    });

    it("returns an empty list when the user has no votes", async () => {
      mockFrom.mockImplementation(() => mockQuery([]));
      const { getMyParcoursInterests } = await import("@/features/dashboard");
      const res = (await (getMyParcoursInterests as unknown as Fn)()) as { parcoursIds: string[] };
      expect(res.parcoursIds).toEqual([]);
    });

    it("throws a generic message on error", async () => {
      mockFrom.mockImplementation(() => mockQuery(null, { message: "boom" }));
      const { getMyParcoursInterests } = await import("@/features/dashboard");
      await expect((getMyParcoursInterests as unknown as Fn)()).rejects.toThrow(
        /intérêts de parcours/i,
      );
    });
  });

  describe("getParcoursInterestCounts", () => {
    it("maps the aggregate rpc rows to {parcoursId, name, count}", async () => {
      mockRpc.mockResolvedValue({
        data: [
          { parcours_id: "ecole-1ere-base", name_fr: "1ère année de base", interest_count: 12 },
          { parcours_id: "concours-bac", name_fr: "Bac", interest_count: 5 },
        ],
        error: null,
      });
      const { getParcoursInterestCounts } = await import("@/features/dashboard");
      const res = (await (getParcoursInterestCounts as unknown as Fn)()) as {
        counts: { parcoursId: string; name: string; count: number }[];
      };
      expect(mockRpc).toHaveBeenCalledWith("parcours_interest_counts");
      expect(res.counts).toEqual([
        { parcoursId: "ecole-1ere-base", name: "1ère année de base", count: 12 },
        { parcoursId: "concours-bac", name: "Bac", count: 5 },
      ]);
    });

    it("coerces a string bigint count to a number", async () => {
      mockRpc.mockResolvedValue({
        data: [{ parcours_id: "x", name_fr: "X", interest_count: "7" }],
        error: null,
      });
      const { getParcoursInterestCounts } = await import("@/features/dashboard");
      const res = (await (getParcoursInterestCounts as unknown as Fn)()) as {
        counts: { count: number }[];
      };
      expect(res.counts[0].count).toBe(7);
    });

    it("throws a generic message on error", async () => {
      mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
      const { getParcoursInterestCounts } = await import("@/features/dashboard");
      await expect((getParcoursInterestCounts as unknown as Fn)()).rejects.toThrow(
        /intérêts de parcours/i,
      );
    });
  });

  describe("toggleParcoursInterest", () => {
    it("registers interest and returns interested:true", async () => {
      mockRpc.mockResolvedValue({ data: true, error: null });
      const { toggleParcoursInterest } = await import("@/features/dashboard");
      const res = (await (toggleParcoursInterest as unknown as Fn)({
        data: { parcoursId: "ecole-1ere-base" },
      })) as { interested: boolean };
      expect(mockRpc).toHaveBeenCalledWith("toggle_parcours_interest", {
        p_parcours: "ecole-1ere-base",
      });
      expect(res.interested).toBe(true);
    });

    it("removes interest and returns interested:false", async () => {
      mockRpc.mockResolvedValue({ data: false, error: null });
      const { toggleParcoursInterest } = await import("@/features/dashboard");
      const res = (await (toggleParcoursInterest as unknown as Fn)({
        data: { parcoursId: "ecole-1ere-base" },
      })) as { interested: boolean };
      expect(res.interested).toBe(false);
    });

    it("throws a generic message on error", async () => {
      mockRpc.mockResolvedValue({ data: null, error: { message: "PARCOURS_NOT_COMING_SOON:x" } });
      const { toggleParcoursInterest } = await import("@/features/dashboard");
      await expect(
        (toggleParcoursInterest as unknown as Fn)({ data: { parcoursId: "concours-9eme" } }),
      ).rejects.toThrow(/enregistrer ton intérêt/i);
    });

    it("rejects an empty parcours id at the validator (never hits the rpc)", async () => {
      const { toggleParcoursInterest } = await import("@/features/dashboard");
      await expect(
        (toggleParcoursInterest as unknown as Fn)({ data: { parcoursId: "" } }),
      ).rejects.toThrow();
      expect(mockRpc).not.toHaveBeenCalled();
    });
  });
});

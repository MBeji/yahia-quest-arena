import { describe, it, expect, vi, beforeEach } from "vitest";

// Exercises the REAL duel server fns. They are thin wrappers over the lot-2/lot-5
// SECURITY DEFINER RPCs plus a few participant-scoped table reads, so we mock the
// rpc + from() + rate-limit + auth-middleware layers (same pattern as
// dungeon.test.ts) and assert on parsed return values, rate-limit guards,
// RPC-error propagation (via failWithClientError), and the parser branches.

const mockRpc = vi.fn();
const mockFrom = vi.fn();
const mockSupabase = { rpc: mockRpc, from: mockFrom };

/** A chainable, thenable query stub: every builder method returns the same
 *  object, and awaiting it (directly or after maybeSingle()) resolves to
 *  `result`. Covers `.delete().eq()`, `.select().in()`, `.select()…maybeSingle()`
 *  and `.select()…limit()` uniformly. */
function makeQuery(result: { data: unknown; error: unknown }) {
  const q: Record<string, unknown> = {};
  for (const m of ["select", "eq", "neq", "order", "limit", "in", "delete", "maybeSingle"]) {
    q[m] = vi.fn(() => q);
  }
  (q as { then: unknown }).then = (resolve: (v: unknown) => unknown) => resolve(result);
  return q;
}

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
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
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

const mockIsRateLimited = vi.fn().mockResolvedValue(false);
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: (...args: unknown[]) => mockIsRateLimited(...args),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

const DUEL_ID = "11111111-1111-1111-1111-111111111111";
const QUESTION_ID = "22222222-2222-2222-2222-222222222222";

type AnyFn = (d?: unknown) => Promise<unknown>;

beforeEach(() => {
  vi.resetModules();
  mockRpc.mockReset();
  mockFrom.mockReset().mockReturnValue(makeQuery({ data: null, error: null }));
  mockIsRateLimited.mockReset();
  mockIsRateLimited.mockResolvedValue(false);
});

describe("duel — matchDuel", () => {
  it("returns the duel id when paired", async () => {
    mockRpc.mockResolvedValue({ data: DUEL_ID, error: null });
    const { matchDuel } = await import("@/features/duel");
    const res = (await (matchDuel as unknown as AnyFn)()) as { duelId: string | null };
    expect(res.duelId).toBe(DUEL_ID);
    expect(mockRpc).toHaveBeenCalledWith("match_duel");
  });

  it("returns null while still waiting (empty rpc result)", async () => {
    mockRpc.mockResolvedValue({ data: "", error: null });
    const { matchDuel } = await import("@/features/duel");
    const res = (await (matchDuel as unknown as AnyFn)()) as { duelId: string | null };
    expect(res.duelId).toBeNull();
  });

  it("blocks when rate limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    const { matchDuel } = await import("@/features/duel");
    await expect((matchDuel as unknown as AnyFn)()).rejects.toThrow(/appariement/i);
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("hides the raw RPC error behind a safe message", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "internal: boom" } });
    const { matchDuel } = await import("@/features/duel");
    const err = await (matchDuel as unknown as AnyFn)().catch((e: unknown) => e);
    expect((err as Error).message).toBe("Impossible de rejoindre la file des duels.");
    expect((err as Error).message).not.toMatch(/boom/);
  });
});

describe("duel — leaveDuelQueue", () => {
  it("returns ok on a clean delete", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: null, error: null }));
    const { leaveDuelQueue } = await import("@/features/duel");
    const res = (await (leaveDuelQueue as unknown as AnyFn)()) as { ok: boolean };
    expect(res.ok).toBe(true);
    expect(mockFrom).toHaveBeenCalledWith("duel_queue");
  });

  it("hides the raw delete error behind a safe message", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: null, error: { message: "rls denied" } }));
    const { leaveDuelQueue } = await import("@/features/duel");
    const err = await (leaveDuelQueue as unknown as AnyFn)().catch((e: unknown) => e);
    expect((err as Error).message).toBe("Impossible de quitter la file.");
  });
});

describe("duel — forfeitDuel", () => {
  it("closes the duel via the forfeit_duel rpc", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { forfeitDuel } = await import("@/features/duel");
    const res = (await (forfeitDuel as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      ok: boolean;
    };
    expect(res.ok).toBe(true);
    expect(mockRpc).toHaveBeenCalledWith("forfeit_duel", { p_duel: DUEL_ID });
  });

  it("hides the rpc error behind a safe message", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { forfeitDuel } = await import("@/features/duel");
    const err = await (forfeitDuel as unknown as AnyFn)({ data: { duelId: DUEL_ID } }).catch(
      (e: unknown) => e,
    );
    expect((err as Error).message).toBe("Impossible d'abandonner le duel.");
  });
});

describe("duel — getDuelState", () => {
  it("parses an active snapshot and keeps the opponent score hidden", async () => {
    mockRpc.mockResolvedValue({
      data: {
        duelId: DUEL_ID,
        status: "active",
        total: 5,
        myAnswered: 2,
        myScore: 1,
        opponentAnswered: 3,
        opponentFinished: false,
      },
      error: null,
    });
    const { getDuelState } = await import("@/features/duel");
    const res = (await (getDuelState as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      status: string;
      opponentScore: number | null;
      review: unknown;
    };
    expect(res.status).toBe("active");
    expect(res.opponentScore).toBeNull();
    expect(res.review).toBeNull();
    // no participant read while active
    expect(mockFrom).not.toHaveBeenCalled();
  });

  it("reveals the opponent score once finished and parses the review", async () => {
    mockRpc.mockResolvedValue({
      data: {
        duelId: DUEL_ID,
        status: "finished",
        total: 2,
        myAnswered: 2,
        myScore: 2,
        opponentAnswered: 2,
        opponentFinished: true,
        review: [
          { questionId: "q1", prompt: "P1", correctChoice: "a", explanation: "because" },
          null,
          { questionId: 5, prompt: 7, correctChoice: 9, explanation: 3 }, // coerced to defaults
        ],
      },
      error: null,
    });
    mockFrom.mockReturnValue(makeQuery({ data: { score: 1 }, error: null }));
    const { getDuelState } = await import("@/features/duel");
    const res = (await (getDuelState as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      opponentScore: number | null;
      review: Array<{ questionId: string; correctChoice: string | null }>;
    };
    expect(res.opponentScore).toBe(1);
    expect(res.review).toHaveLength(2); // null filtered out
    expect(res.review[0].correctChoice).toBe("a");
    expect(res.review[1]).toEqual({
      questionId: "",
      prompt: "",
      correctChoice: null,
      explanation: null,
    });
    expect(mockFrom).toHaveBeenCalledWith("duel_participants");
  });

  it("yields a null opponent score when no participant row is found", async () => {
    mockRpc.mockResolvedValue({
      data: { duelId: DUEL_ID, status: "expired", total: 5 },
      error: null,
    });
    mockFrom.mockReturnValue(makeQuery({ data: null, error: null }));
    const { getDuelState } = await import("@/features/duel");
    const res = (await (getDuelState as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      opponentScore: number | null;
    };
    expect(res.opponentScore).toBeNull();
  });

  it("hides the RPC error behind a safe message", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { getDuelState } = await import("@/features/duel");
    const err = await (getDuelState as unknown as AnyFn)({ data: { duelId: DUEL_ID } }).catch(
      (e: unknown) => e,
    );
    expect((err as Error).message).toBe("Duel introuvable.");
  });

  it("throws when the RPC payload is not an object", async () => {
    mockRpc.mockResolvedValue({ data: "nope", error: null });
    const { getDuelState } = await import("@/features/duel");
    await expect((getDuelState as unknown as AnyFn)({ data: { duelId: DUEL_ID } })).rejects.toThrow(
      /Unexpected duel state/i,
    );
  });
});

describe("duel — getDuelQuestions", () => {
  it("returns an empty set when the duel has no frozen ids", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: { question_ids: [] }, error: null }));
    const { getDuelQuestions } = await import("@/features/duel");
    const res = (await (getDuelQuestions as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      questions: unknown[];
    };
    expect(res.questions).toEqual([]);
  });

  it("reorders to the frozen order and normalizes options/type", async () => {
    const duelsQ = makeQuery({ data: { question_ids: ["b", "a"] }, error: null });
    const questionsQ = makeQuery({
      data: [
        { id: "a", prompt: "PA", options: [{ id: "x", text: "X" }], question_type: "numeric" },
        { id: "b", prompt: "PB", options: "not-an-array", question_type: 42 },
      ],
      error: null,
    });
    mockFrom.mockImplementation((t: string) => (t === "duels" ? duelsQ : questionsQ));
    const { getDuelQuestions } = await import("@/features/duel");
    const res = (await (getDuelQuestions as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      questions: Array<{ id: string; options: unknown[]; questionType: string }>;
    };
    // frozen order is [b, a]
    expect(res.questions.map((q) => q.id)).toEqual(["b", "a"]);
    expect(res.questions[0].options).toEqual([]); // non-array → []
    expect(res.questions[0].questionType).toBe("mcq"); // non-string → mcq
    expect(res.questions[1].questionType).toBe("numeric");
  });

  it("drops ids that have no matching question row", async () => {
    const duelsQ = makeQuery({ data: { question_ids: ["a", "missing"] }, error: null });
    const questionsQ = makeQuery({
      data: [{ id: "a", prompt: "PA", options: [], question_type: "mcq" }],
      error: null,
    });
    mockFrom.mockImplementation((t: string) => (t === "duels" ? duelsQ : questionsQ));
    const { getDuelQuestions } = await import("@/features/duel");
    const res = (await (getDuelQuestions as unknown as AnyFn)({ data: { duelId: DUEL_ID } })) as {
      questions: Array<{ id: string }>;
    };
    expect(res.questions.map((q) => q.id)).toEqual(["a"]);
  });

  it("hides a duel-read error behind a safe message", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: null, error: { message: "boom" } }));
    const { getDuelQuestions } = await import("@/features/duel");
    const err = await (getDuelQuestions as unknown as AnyFn)({ data: { duelId: DUEL_ID } }).catch(
      (e: unknown) => e,
    );
    expect((err as Error).message).toBe("Duel introuvable.");
  });

  it("hides a questions-read error behind a safe message", async () => {
    const duelsQ = makeQuery({ data: { question_ids: ["a"] }, error: null });
    const questionsQ = makeQuery({ data: null, error: { message: "boom" } });
    mockFrom.mockImplementation((t: string) => (t === "duels" ? duelsQ : questionsQ));
    const { getDuelQuestions } = await import("@/features/duel");
    const err = await (getDuelQuestions as unknown as AnyFn)({ data: { duelId: DUEL_ID } }).catch(
      (e: unknown) => e,
    );
    expect((err as Error).message).toBe("Duel introuvable.");
  });
});

describe("duel — submitDuelAnswer", () => {
  const input = { data: { duelId: DUEL_ID, questionId: QUESTION_ID, choice: "a" } };

  it("parses the submit result", async () => {
    mockRpc.mockResolvedValue({
      data: { answered: 3, total: 5, finished: false, tooFast: false },
      error: null,
    });
    const { submitDuelAnswer } = await import("@/features/duel");
    const res = (await (submitDuelAnswer as unknown as AnyFn)(input)) as {
      answered: number;
      finished: boolean;
    };
    expect(res.answered).toBe(3);
    expect(res.finished).toBe(false);
  });

  it("blocks when rate limited", async () => {
    mockIsRateLimited.mockResolvedValue(true);
    const { submitDuelAnswer } = await import("@/features/duel");
    await expect((submitDuelAnswer as unknown as AnyFn)(input)).rejects.toThrow(/réponses/i);
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("hides the RPC error behind a safe message", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { submitDuelAnswer } = await import("@/features/duel");
    const err = await (submitDuelAnswer as unknown as AnyFn)(input).catch((e: unknown) => e);
    expect((err as Error).message).toBe("Impossible de valider la réponse.");
  });

  it("throws when the RPC payload is not an object", async () => {
    mockRpc.mockResolvedValue({ data: 7, error: null });
    const { submitDuelAnswer } = await import("@/features/duel");
    await expect((submitDuelAnswer as unknown as AnyFn)(input)).rejects.toThrow(
      /Unexpected duel answer/i,
    );
  });
});

describe("duel — getDuelLeague", () => {
  it("maps rows and applies defaults for missing fields", async () => {
    mockRpc.mockResolvedValue({
      data: [
        {
          rank: 1,
          display_name: "Alpha",
          hero_class: "mage",
          avatar_tier: 3,
          points: 9,
          wins: 3,
          played: 4,
          tier: "diamond",
          is_me: true,
        },
        {}, // all defaults
      ],
      error: null,
    });
    const { getDuelLeague } = await import("@/features/duel");
    const res = (await (getDuelLeague as unknown as AnyFn)()) as { rows: DuelRow[] };
    type DuelRow = {
      rank: number;
      displayName: string | null;
      tier: string;
      avatarTier: number;
      isMe: boolean;
    };
    expect(res.rows[0]).toMatchObject({
      rank: 1,
      displayName: "Alpha",
      tier: "diamond",
      isMe: true,
    });
    expect(res.rows[1]).toMatchObject({
      rank: 0,
      displayName: null,
      tier: "bronze",
      avatarTier: 1,
      isMe: false,
    });
    expect(mockRpc).toHaveBeenCalledWith("get_duel_league", { p_limit: 20 });
  });

  it("returns an empty list when the rpc yields null", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { getDuelLeague } = await import("@/features/duel");
    const res = (await (getDuelLeague as unknown as AnyFn)()) as { rows: unknown[] };
    expect(res.rows).toEqual([]);
  });

  it("hides the RPC error behind a safe message", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { getDuelLeague } = await import("@/features/duel");
    const err = await (getDuelLeague as unknown as AnyFn)().catch((e: unknown) => e);
    expect((err as Error).message).toBe("Impossible de charger la ligue.");
  });
});

describe("duel — getDuelLastAward", () => {
  it("maps the latest award row", async () => {
    mockFrom.mockReturnValue(
      makeQuery({
        data: { week_start: "2026-06-29", tier: "gold", rank: 2, points: 6, coins_awarded: 30 },
        error: null,
      }),
    );
    const { getDuelLastAward } = await import("@/features/duel");
    const res = (await (getDuelLastAward as unknown as AnyFn)()) as {
      award: { tier: string; coins: number } | null;
    };
    expect(res.award).toMatchObject({ tier: "gold", coins: 30 });
  });

  it("returns a null award when there is no row", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: null, error: null }));
    const { getDuelLastAward } = await import("@/features/duel");
    const res = (await (getDuelLastAward as unknown as AnyFn)()) as { award: unknown };
    expect(res.award).toBeNull();
  });

  it("fails with a safe (empty) message on a read error", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: null, error: { message: "boom" } }));
    const { getDuelLastAward } = await import("@/features/duel");
    const err = await (getDuelLastAward as unknown as AnyFn)().catch((e: unknown) => e);
    expect(err).toBeInstanceOf(Error);
  });
});

describe("duel — getDuelHistory", () => {
  it("maps, filters null duels and sorts newest first", async () => {
    mockFrom.mockReturnValue(
      makeQuery({
        data: [
          {
            score: 2,
            finished_at: "2026-07-01T00:00:00Z",
            duels: {
              id: "old",
              status: "finished",
              created_at: "2026-07-01T00:00:00Z",
              question_ids: ["a", "b"],
            },
          },
          { score: 0, finished_at: null, duels: null }, // dropped
          {
            score: 1,
            finished_at: null,
            duels: {
              id: "new",
              status: "weird", // coerced to "pending"
              created_at: "2026-07-05T00:00:00Z",
              question_ids: null,
            },
          },
        ],
        error: null,
      }),
    );
    const { getDuelHistory } = await import("@/features/duel");
    const res = (await (getDuelHistory as unknown as AnyFn)()) as {
      entries: Array<{ duelId: string; status: string; total: number; myFinished: boolean }>;
    };
    expect(res.entries.map((e) => e.duelId)).toEqual(["new", "old"]); // sorted desc
    expect(res.entries[0].status).toBe("pending"); // invalid status coerced
    expect(res.entries[0].total).toBe(0); // non-array question_ids
    expect(res.entries[0].myFinished).toBe(false);
    expect(res.entries[1].total).toBe(2);
    expect(res.entries[1].myFinished).toBe(true);
  });

  it("hides the read error behind a safe message", async () => {
    mockFrom.mockReturnValue(makeQuery({ data: null, error: { message: "boom" } }));
    const { getDuelHistory } = await import("@/features/duel");
    const err = await (getDuelHistory as unknown as AnyFn)().catch((e: unknown) => e);
    expect((err as Error).message).toBe("Impossible de charger l'historique.");
  });
});

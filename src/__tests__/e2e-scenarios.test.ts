/**
 * END-TO-END SCENARIO SUITE
 * =========================
 * Each test chains several server functions together to exercise a realistic
 * user journey (quest completion, premium gating, beta access, admin actions,
 * dashboard bootstrap, shop, leaderboards, dungeon, streak recovery) against
 * the mocked Supabase layer. Complements the per-function non-regression suite.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };
let capturedHandlers: Record<string, (...args: unknown[]) => unknown> = {};

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: ({ method }: { method: string }) => {
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
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({
            data,
            context: {
              supabase: mockSupabase,
              userId: "user-regression-test",
              claims: { sub: "user-regression-test", user_metadata: { display_name: "Yahia" } },
            },
          });
        };
        capturedHandlers[method + "_" + Object.keys(capturedHandlers).length] = wrapped;
        return wrapped;
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/lib/rate-limit", () => ({ isRateLimited: vi.fn().mockResolvedValue(false) }));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  for (const m of [
    "select",
    "eq",
    "gt",
    "gte",
    "lte",
    "neq",
    "not",
    "in",
    "order",
    "limit",
    "insert",
    "update",
    "upsert",
    "delete",
  ]) {
    chain[m] = vi.fn().mockReturnValue(chain);
  }
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.then = (resolve: (v: unknown) => unknown) => resolve(result);
  Object.assign(chain, result);
  return chain;
}

// =============================================================================
// END-TO-END SCENARIOS — chain multiple server fns to mimic real journeys.
// Each step re-arms the supabase mock so every call gets a realistic response.
// =============================================================================
const EX = "22222222-2222-2222-2222-222222222222";
const SESS = "11111111-1111-1111-1111-111111111111";
const Q = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
const CH = "33333333-3333-3333-3333-333333333333";
const REQ = "44444444-4444-4444-4444-444444444444";
const U = "55555555-5555-5555-5555-555555555555";

/** Dispatch RPC responses by function name (default ok/empty). */
function rpcByName(map: Record<string, { data?: unknown; error?: unknown }>) {
  return (fn: string) => Promise.resolve(map[fn] ?? { data: null, error: null });
}

type Fn = (d?: unknown) => Promise<unknown>;

describe("END-TO-END: student completes a quest", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getSubject → getExercise → startExerciseSession → submitAttempt", async () => {
    const quest = await import("@/features/quest");

    // 1) Browse the subject.
    mockFrom.mockImplementation((table: string) => {
      if (table === "subjects")
        return mockQuery({
          id: "s1",
          name_fr: "Math",
          color_token: "math",
          content_language: "fr",
        });
      if (table === "chapters") return mockQuery([{ id: "ch1", title: "Ch1", display_order: 1 }]);
      if (table === "exercises")
        return mockQuery([{ id: "ex1", title: "Ex1", display_order: 1, mode: "practice" }]);
      return mockQuery([]);
    });
    mockRpc.mockResolvedValue({ data: [], error: null });
    const subject = (await (quest.getSubject as unknown as Fn)({ subjectId: "s1" })) as Record<
      string,
      unknown
    >;
    expect(subject).toHaveProperty("exercises");
    expect(subject).toHaveProperty("viewer");

    // 2) Open the exercise.
    mockFrom.mockImplementation((table: string) => {
      if (table === "exercises") return mockQuery({ id: "ex1", title: "Ex1", mode: "practice" });
      if (table === "questions")
        return mockQuery([{ id: Q, prompt: "2+2?", options: [], display_order: 1 }]);
      return mockQuery([]);
    });
    const exercise = (await (quest.getExercise as unknown as Fn)({ exerciseId: EX })) as Record<
      string,
      unknown
    >;
    expect(exercise).toHaveProperty("questions");

    // 3) Start a secure session — the start_exercise_session RPC enforces access +
    //    the quiz gate server-side and returns the created session.
    mockRpc.mockImplementation(
      rpcByName({
        start_exercise_session: {
          data: [{ session_id: "sess1", started_at: "2026-06-03T00:00:00Z" }],
        },
      }),
    );
    const session = (await (quest.startExerciseSession as unknown as Fn)({ exerciseId: EX })) as {
      sessionId: string;
    };
    expect(session.sessionId).toBe("sess1");

    // 4) Submit the attempt → scoring RPC.
    mockFrom.mockImplementation((table: string) =>
      table === "questions"
        ? mockQuery([{ id: Q, prompt: "2+2?", correct_option: "4", explanation: "x" }])
        : mockQuery([]),
    );
    mockRpc.mockResolvedValue({
      data: {
        correct: 1,
        total: 1,
        scorePct: 100,
        xpEarned: 10,
        coinsEarned: 2,
        durationSeconds: 30,
        profile: null,
        unlockedBadges: [],
      },
      error: null,
    });
    const result = (await (quest.submitAttempt as unknown as Fn)({
      sessionId: SESS,
      exerciseId: EX,
      answers: [{ questionId: Q, choice: "4" }],
    })) as Record<string, unknown>;
    expect(result).toHaveProperty("review");
    expect(result.scorePct).toBe(100);
  });
});

describe("END-TO-END: premium-parcours gating of an élite challenge", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("blocks an unentitled user on a locked mission, then allows an entitled one", async () => {
    const { startExerciseSession } = await import("@/features/quest");

    // No entitlement, outside the free preview → the RPC raises PARCOURS_LOCKED.
    mockRpc.mockImplementation(
      rpcByName({ start_exercise_session: { error: { message: "PARCOURS_LOCKED" } } }),
    );
    await expect((startExerciseSession as unknown as Fn)({ exerciseId: EX })).rejects.toThrow(
      /Parcours premium/,
    );

    // Entitled + quiz passed → the RPC returns the created session.
    mockRpc.mockImplementation(
      rpcByName({
        start_exercise_session: {
          data: [{ session_id: "sess1", started_at: "2026-06-03T00:00:00Z" }],
        },
      }),
    );
    const session = (await (startExerciseSession as unknown as Fn)({ exerciseId: EX })) as {
      sessionId: string;
    };
    expect(session.sessionId).toBe("sess1");
  });
});

describe("END-TO-END: beta tester request → admin approval", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("request → pending status → admin lists → admin approves", async () => {
    const sub = await import("@/features/subscription");

    // 1) User submits a request (no existing one).
    const maybeNull = mockQuery(null);
    const insertOk = mockQuery(null);
    let betaCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "beta_access_requests") {
        betaCalls += 1;
        return betaCalls === 1 ? maybeNull : insertOk; // existing-check, then insert
      }
      return mockQuery([]);
    });
    const submitted = (await (sub.requestBetaAccess as unknown as Fn)({
      name: "Yahia",
      email: "y@example.com",
      motivation: "I want to test",
    })) as { status: string };
    // requestBetaAccess validates input itself; call via the data envelope:
    expect(submitted.status).toBe("pending");

    // 2) The user now sees a pending request.
    mockFrom.mockImplementation((table: string) =>
      table === "beta_access_requests"
        ? mockQuery({
            id: REQ,
            name: "Yahia",
            email: "y@example.com",
            motivation: "I want to test",
            status: "pending",
            created_at: "2026-06-03T00:00:00Z",
            reviewed_at: null,
          })
        : mockQuery([]),
    );
    const mine = (await (sub.getMyBetaRequest as unknown as Fn)()) as { status: string } | null;
    expect(mine?.status).toBe("pending");

    // 3) Admin lists and approves. Approval reviews the request (dormant
    //    subscription write) AND grants a per-parcours `beta` entitlement.
    mockFrom.mockImplementation((table: string) => {
      if (table === "beta_access_requests") return mockQuery({ user_id: U });
      if (table === "profiles") return mockQuery({ current_parcours_id: "concours-9eme" });
      return mockQuery([]);
    });
    mockRpc.mockImplementation(
      rpcByName({
        admin_list_beta_requests: {
          data: [
            {
              id: REQ,
              user_id: U,
              name: "Yahia",
              email: "y@example.com",
              motivation: "I want to test",
              status: "pending",
              created_at: "2026-06-03T00:00:00Z",
              reviewed_at: null,
            },
          ],
          error: null,
        },
        admin_review_beta_request: { data: null, error: null },
        admin_grant_parcours: { data: null, error: null },
      }),
    );
    const list = (await (sub.listBetaRequests as unknown as Fn)()) as {
      requests: Array<{ status: string }>;
    };
    expect(list.requests).toHaveLength(1);
    const reviewed = (await (sub.reviewBetaRequest as unknown as Fn)({
      requestId: REQ,
      approve: true,
    })) as { ok: boolean };
    expect(reviewed.ok).toBe(true);
    expect(mockRpc).toHaveBeenCalledWith("admin_review_beta_request", {
      p_request: REQ,
      p_approve: true,
    });
    // The beta tester gets a per-parcours entitlement under the live gate.
    const grantCall = mockRpc.mock.calls.find((c) => c[0] === "admin_grant_parcours");
    expect(grantCall).toBeTruthy();
    expect((grantCall![1] as Record<string, unknown>).p_source).toBe("beta");
    expect((grantCall![1] as Record<string, unknown>).p_parcours).toBe("concours-9eme");
  });
});

describe("END-TO-END: admin manages parcours entitlements", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("list → grant → revoke", async () => {
    const sub = await import("@/features/subscription");

    mockRpc.mockImplementation(
      rpcByName({
        admin_list_parcours_entitlements: {
          data: [
            {
              user_id: U,
              display_name: "Yahia",
              email: "y@example.com",
              parcours_id: "concours-9eme",
              parcours_name: "Concours 9ème",
              source: "purchase",
              granted_at: "2026-06-01T00:00:00Z",
              expires_at: null,
              is_active: true,
            },
          ],
          error: null,
        },
        admin_grant_parcours: { data: null, error: null },
        admin_revoke_parcours: { data: null, error: null },
      }),
    );

    const list = (await (sub.listParcoursEntitlements as unknown as Fn)()) as {
      entitlements: unknown[];
    };
    expect(list.entitlements).toHaveLength(1);

    const granted = (await (sub.grantParcoursEntitlement as unknown as Fn)({
      userId: U,
      parcoursId: "concours-9eme",
      source: "gift",
      months: 6,
    })) as { ok: boolean };
    expect(granted.ok).toBe(true);

    const revoked = (await (sub.revokeParcoursEntitlement as unknown as Fn)({
      userId: U,
      parcoursId: "concours-9eme",
    })) as { ok: boolean };
    expect(revoked.ok).toBe(true);
  });
});

describe("END-TO-END: new user dashboard bootstrap", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getDashboard (auto-creates profile) → secondary → sprint2", async () => {
    const dash = await import("@/features/dashboard");

    // 1) First visit: no profile yet → it is created then reloaded.
    let profileCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles") {
        profileCalls += 1;
        if (profileCalls === 1) return mockQuery(null); // maybeSingle → none
        if (profileCalls === 2) return mockQuery(null); // insert
        return mockQuery({ id: "user-regression-test", display_name: "Yahia", xp: 0, level: 1 });
      }
      return mockQuery([]);
    });
    mockRpc.mockResolvedValue({ data: [], error: null });
    const dashboard = (await (dash.getDashboard as unknown as Fn)()) as Record<string, unknown>;
    expect(dashboard).toHaveProperty("profile");
    expect(dashboard).toHaveProperty("subjects");

    // 2) Secondary data (badges/inventory/shop).
    mockFrom.mockImplementation(() => mockQuery([]));
    const secondary = (await (dash.getDashboardSecondary as unknown as Fn)()) as Record<
      string,
      unknown
    >;
    expect(secondary).toHaveProperty("badges");
    expect(secondary).toHaveProperty("shopItems");

    // 3) Sprint-2 widgets (objectives / quests / spaced repetition).
    mockFrom.mockImplementation(() => mockQuery([]));
    const sprint2 = (await (dash.getSprint2Dashboard as unknown as Fn)()) as Record<
      string,
      unknown
    >;
    expect(sprint2).toHaveProperty("dailyObjectives");
    expect(sprint2).toHaveProperty("weeklyQuests");
  });
});

describe("END-TO-END: shop purchase then equip", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("purchaseShopItem → equipInventorySkin", async () => {
    const shop = await import("@/features/shop");

    mockRpc.mockImplementation(
      rpcByName({
        purchase_shop_item: {
          data: { item_code: "skin_gold", remaining_coins: 40, purchased_item_name: "Gold Skin" },
          error: null,
        },
        equip_inventory_skin: {
          data: { item_code: "skin_gold", item_name: "Gold Skin", avatar_slug: "gold" },
          error: null,
        },
      }),
    );

    const bought = (await (shop.purchaseShopItem as unknown as Fn)({ itemCode: "skin_gold" })) as {
      remainingCoins: number;
    };
    expect(bought.remainingCoins).toBe(40);

    const equipped = (await (shop.equipInventorySkin as unknown as Fn)({
      itemCode: "skin_gold",
    })) as { avatarSlug: string | null };
    expect(equipped.avatarSlug).toBe("gold");
  });
});

describe("END-TO-END: leaderboards (global + per-subject)", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getLeaderboard → getSubjectLeaderboard", async () => {
    const dash = await import("@/features/dashboard");

    mockRpc.mockImplementation(
      rpcByName({
        get_global_leaderboard: {
          data: [
            {
              rank: 1,
              display_name: "Yahia",
              hero_class: "warrior",
              level: 5,
              xp: 1000,
              current_streak: 7,
              avatar_tier: 2,
              is_me: true,
            },
          ],
          error: null,
        },
      }),
    );
    const global = (await (dash.getLeaderboard as unknown as Fn)()) as { leaderboard: unknown[] };
    expect(global.leaderboard).toHaveLength(1);

    mockRpc.mockImplementation(
      rpcByName({
        get_subject_leaderboard: {
          // No peer/self user_id in the RPC shape (P0 S2b); is_me flags self.
          data: [
            {
              rank: 1,
              display_name: "Yahia",
              hero_class: "warrior",
              level: 5,
              current_streak: 7,
              avatar_tier: 2,
              subject_xp: 500,
              is_me: true,
            },
          ],
          error: null,
        },
      }),
    );
    const perSubject = (await (dash.getSubjectLeaderboard as unknown as Fn)({
      subjectId: "math",
    })) as { leaderboard: unknown[] };
    expect(perSubject.leaderboard).toHaveLength(1);
  });
});

describe("END-TO-END: dungeon run", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("startDungeonRun → getDungeonQuestions", async () => {
    const dungeon = await import("@/features/dungeon");

    mockRpc.mockImplementation(
      rpcByName({
        start_dungeon_run: { data: SESS, error: null },
        get_dungeon_questions: {
          data: {
            currentFloor: 1,
            questions: [{ id: "q1", prompt: "2+2?", options: ["3", "4"], explanation: null }],
          },
          error: null,
        },
      }),
    );

    const run = (await (dungeon.startDungeonRun as unknown as Fn)()) as { runId: string };
    expect(run).toHaveProperty("runId");

    const questions = (await (dungeon.getDungeonQuestions as unknown as Fn)({ runId: SESS })) as {
      questions: unknown[];
    };
    expect(questions).toHaveProperty("questions");
  });
});

describe("END-TO-END: lesson then streak recovery", () => {
  beforeEach(() => {
    vi.resetModules();
    capturedHandlers = {};
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("getChapterLesson → recoverStreak", async () => {
    const quest = await import("@/features/quest");
    let chCalls = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "chapters") {
        chCalls += 1;
        return chCalls === 1
          ? mockQuery({ id: "ch1", title: "Ch1", subject_id: "s1", lesson_content: "cours" })
          : mockQuery([{ id: "ch1", title: "Ch1", display_order: 1, lesson_content: "cours" }]);
      }
      return mockQuery([]);
    });
    const lesson = (await (quest.getChapterLesson as unknown as Fn)({ chapterId: CH })) as Record<
      string,
      unknown
    >;
    expect(lesson).toHaveProperty("chapter");
    expect(lesson).toHaveProperty("allChapters");

    // Recover a lost streak (had a streak, enough coins).
    const { recoverStreak } = await import("@/features/progression");
    mockFrom.mockImplementation((table: string) =>
      table === "profiles"
        ? mockQuery({
            id: "user-regression-test",
            yahia_coins: 50,
            current_streak: 0,
            longest_streak: 5,
            last_active_date: null,
          })
        : mockQuery([]),
    );
    mockRpc.mockResolvedValue({ data: null, error: null }); // spend_coins ok
    const recovered = (await (recoverStreak as unknown as Fn)()) as { success: boolean };
    expect(recovered.success).toBe(true);
  });
});

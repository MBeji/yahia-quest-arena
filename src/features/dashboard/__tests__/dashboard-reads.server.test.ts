// @vitest-environment node
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Trois lectures du tableau de bord qui n'avaient aucun test d'appel : l'anneau du
 * jour (é31 lot 3), l'événement en cours (é31 lot 8) et le bilan de la semaine.
 * Passées au client généré par #1263, elles n'étaient couvertes que par le
 * typecheck.
 */
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    // `.validator` reçoit tantôt une fonction, tantôt un schéma Zod (setDailyXpGoal).
    let validate: (d: unknown) => unknown = (d) => d;
    const chain = {
      middleware: () => chain,
      validator: (v: unknown) => {
        validate =
          typeof v === "function"
            ? (v as (d: unknown) => unknown)
            : (d) => (v as { parse: (d: unknown) => unknown }).parse(d);
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => async (input?: unknown) =>
        fn({ data: validate(input), context: { supabase: mockSupabase, userId: "user-1" } }),
    };
    return chain;
  },
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

type Call = (input?: unknown) => Promise<unknown>;

function profileRow(row: Record<string, unknown> | null, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  chain.select = vi.fn(() => chain);
  chain.eq = vi.fn(() => chain);
  chain.maybeSingle = vi.fn(() => Promise.resolve({ data: row, error }));
  mockFrom.mockReturnValue(chain);
  return chain;
}

beforeEach(() => {
  vi.resetModules();
  mockFrom.mockReset();
  mockRpc.mockReset();
});

// =============================================================================
// L'anneau du jour
// =============================================================================
describe("dashboard — getDailyRing", () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(new Date("2026-11-13T10:00:00Z"));
  });
  afterEach(() => vi.useRealTimers());

  it("compte l'XP du jour depuis la base du compteur, sur l'objectif choisi", async () => {
    profileRow({
      xp: 1250,
      daily_xp_day: "2026-11-13",
      daily_xp_base: 1180,
      daily_xp_goal: 200,
      daily_xp_goal_set_on: "2026-11-12",
    });
    const { getDailyRing } = await import("../daily-goal.server");

    await expect((getDailyRing as unknown as Call)()).resolves.toEqual({
      xpToday: 70,
      goal: 200,
      canChange: true,
    });
  });

  it("repart de zéro quand le compteur date d'hier, même si `award_xp` n'a pas encore tourné", async () => {
    profileRow({
      xp: 1250,
      daily_xp_day: "2026-11-12",
      daily_xp_base: 1100,
      daily_xp_goal: 100,
      daily_xp_goal_set_on: "2026-11-13",
    });
    const { getDailyRing } = await import("../daily-goal.server");

    // Et l'objectif déjà changé aujourd'hui ne se rechange pas.
    await expect((getDailyRing as unknown as Call)()).resolves.toEqual({
      xpToday: 0,
      goal: 100,
      canChange: false,
    });
  });

  it("n'affiche jamais un XP du jour négatif (base au-dessus du total)", async () => {
    profileRow({
      xp: 90,
      daily_xp_day: "2026-11-13",
      daily_xp_base: 120,
      daily_xp_goal: 50,
      daily_xp_goal_set_on: null,
    });
    const { getDailyRing } = await import("../daily-goal.server");

    await expect((getDailyRing as unknown as Call)()).resolves.toMatchObject({ xpToday: 0 });
  });

  it("prend l'objectif par défaut (100) quand le profil n'est pas lisible", async () => {
    profileRow(null);
    const { getDailyRing } = await import("../daily-goal.server");

    await expect((getDailyRing as unknown as Call)()).resolves.toEqual({
      xpToday: 0,
      goal: 100,
      canChange: true,
    });
  });

  it("refuse avec un message lisible quand la lecture échoue", async () => {
    profileRow(null, { message: "permission denied" });
    const { getDailyRing } = await import("../daily-goal.server");

    await expect((getDailyRing as unknown as Call)()).rejects.toThrow(
      "Impossible de charger ton objectif du jour.",
    );
  });
});

describe("dashboard — setDailyXpGoal", () => {
  it("enregistre l'un des trois objectifs proposés", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { setDailyXpGoal } = await import("../daily-goal.server");

    await expect((setDailyXpGoal as unknown as Call)({ goal: 200 })).resolves.toEqual({
      goal: 200,
    });
    expect(mockRpc).toHaveBeenCalledWith("set_daily_xp_goal", { p_goal: 200 });
  });

  it("refuse une valeur hors des trois paliers avant d'appeler la base", async () => {
    const { setDailyXpGoal } = await import("../daily-goal.server");

    await expect((setDailyXpGoal as unknown as Call)({ goal: 150 })).rejects.toThrow();
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("fait remonter le refus du jour TEL QUEL, pour que l'écran dise « demain »", async () => {
    mockRpc.mockResolvedValue({
      data: null,
      error: { message: "DAILY_GOAL_ALREADY_SET_TODAY: one change per day" },
    });
    const { setDailyXpGoal, DAILY_GOAL_ALREADY_SET } = await import("../daily-goal.server");

    await expect((setDailyXpGoal as unknown as Call)({ goal: 50 })).rejects.toThrow(
      new RegExp(`^${DAILY_GOAL_ALREADY_SET}$`),
    );
  });

  it("traduit toute autre panne en message d'enregistrement", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "connection reset" } });
    const { setDailyXpGoal } = await import("../daily-goal.server");

    await expect((setDailyXpGoal as unknown as Call)({ goal: 50 })).rejects.toThrow(
      "Impossible d'enregistrer ton objectif du jour.",
    );
  });
});

// =============================================================================
// L'événement en cours
// =============================================================================
describe("dashboard — getActiveEvent", () => {
  it("rend l'affiche et la progression de l'appelant", async () => {
    mockRpc.mockResolvedValue({
      data: {
        code: "rentree-2026",
        name: { fr: "La rentrée" },
        description: { fr: "Dix missions" },
        endsAt: "2026-11-30T23:59:59Z",
        goalType: "score_90_n",
        goalTarget: 10,
        progress: 4,
        badgeCode: "rentree",
      },
      error: null,
    });
    const { getActiveEvent } = await import("../events.server");

    await expect((getActiveEvent as unknown as Call)()).resolves.toEqual({
      code: "rentree-2026",
      name: { fr: "La rentrée" },
      description: { fr: "Dix missions" },
      endsAt: "2026-11-30T23:59:59Z",
      goalType: "score_90_n",
      goalTarget: 10,
      progress: 4,
      badgeCode: "rentree",
    });
  });

  it("ramène un type d'objectif inconnu au défaut, et un badge absent à null", async () => {
    mockRpc.mockResolvedValue({
      data: { code: "x", goalType: "autre", goalTarget: "5", badgeCode: 7 },
      error: null,
    });
    const { getActiveEvent } = await import("../events.server");

    await expect((getActiveEvent as unknown as Call)()).resolves.toMatchObject({
      goalType: "exercises_n",
      goalTarget: 5,
      progress: 0,
      badgeCode: null,
      name: {},
    });
  });

  it("rend null quand aucun événement n'est ouvert", async () => {
    mockRpc.mockResolvedValue({ data: null, error: null });
    const { getActiveEvent } = await import("../events.server");

    await expect((getActiveEvent as unknown as Call)()).resolves.toBeNull();
  });

  it("refuse avec un message lisible quand la lecture échoue", async () => {
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const { getActiveEvent } = await import("../events.server");

    await expect((getActiveEvent as unknown as Call)()).rejects.toThrow(
      "Impossible de charger l'événement en cours.",
    );
  });
});

describe("dashboard — claimEventBadge", () => {
  it.each([
    [{ granted: true }, true],
    [{ granted: false }, false],
    [null, false],
  ])("rend granted=%j → %s", async (data, granted) => {
    mockRpc.mockResolvedValue({ data, error: null });
    const { claimEventBadge } = await import("../events.server");

    await expect((claimEventBadge as unknown as Call)()).resolves.toEqual({ granted });
  });
});

// =============================================================================
// Le bilan de la semaine
// =============================================================================
describe("dashboard — getWeeklyRecap", () => {
  const RECAP = {
    weekStart: "2026-11-09",
    hasActivity: true,
    thisWeek: { xp: 320, missions: 6, avgScore: 78, daysActive: 4 },
    lastWeek: { xp: 210, missions: 4, avgScore: 70, daysActive: 3 },
    delta: { xp: 110, missions: 2, avgScore: 8, daysActive: 1 },
    streak: 5,
    badges: ["first-quest"],
    stars: 3,
    seals: 1,
    league: { tier: "silver", rank: 4, coins: 30, week_start: "2026-11-09" },
  };

  it("rend le bilan validé", async () => {
    mockRpc.mockResolvedValue({ data: RECAP, error: null });
    const { getWeeklyRecap } = await import("../weekly-recap.server");

    await expect((getWeeklyRecap as unknown as Call)()).resolves.toEqual(RECAP);
  });

  it("garde un bilan antérieur aux étoiles : `stars` et `seals` absents valent 0", async () => {
    const { stars: _stars, seals: _seals, ...beforeStars } = RECAP;
    mockRpc.mockResolvedValue({ data: beforeStars, error: null });
    const { getWeeklyRecap } = await import("../weekly-recap.server");

    await expect((getWeeklyRecap as unknown as Call)()).resolves.toMatchObject({
      stars: 0,
      seals: 0,
    });
  });

  it("refuse une forme inattendue plutôt que de dessiner des chiffres partiels", async () => {
    mockRpc.mockResolvedValue({ data: { ...RECAP, thisWeek: null }, error: null });
    const { getWeeklyRecap } = await import("../weekly-recap.server");

    await expect((getWeeklyRecap as unknown as Call)()).rejects.toThrow(
      "Impossible de charger le bilan de ta semaine.",
    );
  });
});

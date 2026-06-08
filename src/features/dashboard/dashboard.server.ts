import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import {
  DASHBOARD_RECENT_LIMIT,
  LEADERBOARD_LIMIT,
  PASS_THRESHOLD_PCT,
} from "@/shared/constants/gamification";
import type { BadgeRow, DashboardShopItem, InventoryRow } from "@/shared/types/gamification";
import { getCurrentWeekStartUtc, getTodayUtc } from "@/shared/lib/dates";
import { failWithClientError } from "@/shared/lib/safe-error";

const DASHBOARD_ERROR_FR = "Impossible de charger le tableau de bord. Veuillez réessayer.";

function resolveFallbackDisplayName(claims: Record<string, unknown>): string {
  const userMetadata = claims.user_metadata;
  if (userMetadata && typeof userMetadata === "object") {
    const displayName = (userMetadata as Record<string, unknown>).display_name;
    if (typeof displayName === "string" && displayName.trim().length > 0) {
      return displayName.trim();
    }
  }

  return "Aspirant";
}

// ---------- Get dashboard ----------
export const getDashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const claims = (context.claims ?? {}) as Record<string, unknown>;
    const fallbackDisplayName = resolveFallbackDisplayName(claims);

    // Per-subject aggregates (#18) must be computed over ALL of the user's attempts,
    // not just the recent window — otherwise active users get truncated counts/averages.
    // We fetch a lightweight projection (3 columns) of every attempt for the user.
    // TODO(review #18): a `subject_stats` SQL view or RPC (GROUP BY subject_id) would be
    // the ideal aggregate source; implement once a DB migration is in scope.
    const [profileRes, subjectsRes, recentRes, statsRes] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", userId).maybeSingle(),
      supabase.from("subjects").select("*").order("display_order"),
      supabase
        .from("attempts")
        .select("subject_id,score_pct,xp_earned,completed_at,exercise_id")
        .eq("user_id", userId)
        .order("completed_at", { ascending: false })
        .limit(DASHBOARD_RECENT_LIMIT),
      supabase.from("attempts").select("subject_id,score_pct,xp_earned").eq("user_id", userId),
    ]);

    if (profileRes.error)
      failWithClientError("getDashboard.profile", profileRes.error, DASHBOARD_ERROR_FR);
    if (subjectsRes.error)
      failWithClientError("getDashboard.subjects", subjectsRes.error, DASHBOARD_ERROR_FR);
    if (recentRes.error)
      failWithClientError("getDashboard.recent", recentRes.error, DASHBOARD_ERROR_FR);
    if (statsRes.error)
      failWithClientError("getDashboard.stats", statsRes.error, DASHBOARD_ERROR_FR);

    let profile = profileRes.data;

    if (!profile) {
      const { error: profileInsertError } = await supabase
        .from("profiles")
        .insert({ id: userId, display_name: fallbackDisplayName });

      if (profileInsertError && profileInsertError.code !== "23505") {
        failWithClientError("getDashboard.profileInsert", profileInsertError, DASHBOARD_ERROR_FR);
      }

      const { data: profileData, error: profileReloadError } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", userId)
        .maybeSingle();

      if (profileReloadError)
        failWithClientError("getDashboard.profileReload", profileReloadError, DASHBOARD_ERROR_FR);
      profile = profileData;
    }

    // Build per-subject count/avg/xp over the FULL attempt set (#18).
    const bySubject: Record<string, { count: number; avg: number; xp: number }> = {};
    for (const a of statsRes.data ?? []) {
      const s = (bySubject[a.subject_id] ??= { count: 0, avg: 0, xp: 0 });
      s.avg = (s.avg * s.count + Number(a.score_pct)) / (s.count + 1);
      s.count += 1;
      s.xp += a.xp_earned;
    }

    // Find next incomplete exercise (score < pass threshold)
    let nextExerciseId: string | null = null;
    if (recentRes.data && recentRes.data.length > 0) {
      const lastAttempt = recentRes.data[0];
      if (lastAttempt.score_pct < PASS_THRESHOLD_PCT) {
        nextExerciseId = lastAttempt.exercise_id;
      }
    }

    // Scope subjects by the student's ACTIVE parcours (#parcours-pivot). A parcours
    // pins a theme (and, for concours, a grade); the dashboard shows only that
    // parcours' subjects. Premium parcours without an entitlement surface their
    // subjects as locked (the server gate is authoritative; this only drives the
    // lock badges in the UI).
    const allSubjects = subjectsRes.data ?? [];
    const parcoursId = profile?.current_parcours_id ?? null;
    let subjects: typeof allSubjects = [];
    let premiumLockedSubjectIds: string[] = [];
    if (parcoursId) {
      const { data: par } = await supabase
        .from("parcours")
        .select("theme_id,grade_id,is_premium")
        .eq("id", parcoursId)
        .maybeSingle();
      if (par) {
        subjects = allSubjects.filter(
          (s) =>
            s.theme_id === par.theme_id &&
            (par.grade_id ? s.grade_id === par.grade_id : s.grade_id == null),
        );
        if (par.is_premium) {
          const { data: ent } = await supabase.rpc("has_parcours_entitlement", {
            p_user: userId,
            p_parcours: parcoursId,
          });
          if (ent !== true) premiumLockedSubjectIds = subjects.map((s) => s.id);
        }
      }
    }
    // Other free parcours to discover (free-theme subjects not in the active parcours).
    const activeIds = new Set(subjects.map((s) => s.id));
    const otherSubjects = allSubjects.filter((s) => s.grade_id == null && !activeIds.has(s.id));

    return {
      profile,
      subjects,
      otherSubjects,
      stats: bySubject,
      recent: recentRes.data ?? [],
      nextExerciseId,
      premiumLockedSubjectIds,
      currentParcoursId: parcoursId,
    };
  });

// ---------- Get dashboard secondary sections (badges + inventory + shop) ----------
// Split out of getDashboard (#15): these heavy joins back the lazy/deferred
// radar/inventory and badges/shop sections, so they load via their own query
// once the primary dashboard has rendered.
export const getDashboardSecondary = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const [badgesRes, inventoryRes, shopRes] = await Promise.all([
      supabase
        .from("student_badges")
        .select("awarded_at, awarded_reason, badge:badges(code,name,rarity,icon_name)")
        .eq("student_user_id", userId)
        .order("awarded_at", { ascending: false }),
      supabase
        .from("inventory_items")
        .select(
          "quantity, is_equipped, is_active, acquired_at, item:shop_items(id,code,name,item_type,description,price_coins,effect_payload)",
        )
        .eq("student_user_id", userId)
        .order("acquired_at", { ascending: false }),
      supabase
        .from("shop_items")
        .select("id,code,name,item_type,description,price_coins,is_active,effect_payload")
        .eq("is_active", true)
        .order("price_coins", { ascending: true }),
    ]);

    if (badgesRes.error)
      failWithClientError("getDashboardSecondary.badges", badgesRes.error, DASHBOARD_ERROR_FR);
    if (inventoryRes.error)
      failWithClientError(
        "getDashboardSecondary.inventory",
        inventoryRes.error,
        DASHBOARD_ERROR_FR,
      );
    if (shopRes.error)
      failWithClientError("getDashboardSecondary.shop", shopRes.error, DASHBOARD_ERROR_FR);

    const badges = (badgesRes.data ?? []).flatMap((row: BadgeRow) => {
      if (!row.badge) return [];

      return [
        {
          code: row.badge.code,
          name: row.badge.name,
          rarity: row.badge.rarity,
          iconName: row.badge.icon_name,
          awardedAt: row.awarded_at,
          awardedReason: row.awarded_reason,
        },
      ];
    });

    // Armable consumables fall into two independent arming slots, derived from the
    // effect payload (mirrors activate_inventory_item):
    //   * "next-quest": multiplier potions (xpMultiplier/coinMultiplier) + the retry
    //     shield (retries) — applied to the next quest, one armed at a time.
    //   * "passive": the streak shield (streakShield) — protects a missed day
    //     automatically, armed independently of the next-quest slot.
    // Hint potions (hintBoost) carry no armable effect and stay out of scope.
    const armSlotFor = (
      itemType: string,
      payload: Record<string, unknown>,
    ): "next-quest" | "passive" | null => {
      if (itemType !== "potion" && itemType !== "shield") return null;
      if ("streakShield" in payload) return "passive";
      if ("xpMultiplier" in payload || "coinMultiplier" in payload || "retries" in payload) {
        return "next-quest";
      }
      return null;
    };

    // Hint consumables (booster_hint / potion_rappel) are NOT armed — they are
    // spent on demand during a quest via the "Indice" button. Each owned unit is
    // one reveal charge. The inventory UI labels them "à utiliser en quête" (no
    // "Activer" button). Mirrors the consume_hint RPC's eligibility check.
    const isHintConsumableFor = (itemType: string, payload: Record<string, unknown>): boolean =>
      (itemType === "booster" || itemType === "potion") &&
      ("hints" in payload || "hintBoost" in payload);

    const inventory = (inventoryRes.data ?? []).flatMap((row: InventoryRow) => {
      if (!row.item) return [];

      const payload =
        row.item.effect_payload && typeof row.item.effect_payload === "object"
          ? (row.item.effect_payload as Record<string, unknown>)
          : {};
      const armSlot = armSlotFor(row.item.item_type, payload);

      return [
        {
          code: row.item.code,
          name: row.item.name,
          itemType: row.item.item_type,
          description: row.item.description,
          priceCoins: row.item.price_coins,
          quantity: row.quantity,
          isEquipped: row.is_equipped,
          isActive: row.is_active,
          isArmable: armSlot !== null,
          armSlot,
          isHintConsumable: isHintConsumableFor(row.item.item_type, payload),
          acquiredAt: row.acquired_at,
        },
      ];
    });

    const inventoryByCode = new Map(inventory.map((item) => [item.code, item]));
    const shopItems: DashboardShopItem[] = (shopRes.data ?? []).map((item) => {
      const owned = inventoryByCode.get(item.code);
      const payload =
        item.effect_payload && typeof item.effect_payload === "object"
          ? (item.effect_payload as Record<string, unknown>)
          : {};
      const avatarSlug = typeof payload.avatarSlug === "string" ? payload.avatarSlug : null;
      const armSlot = armSlotFor(item.item_type, payload);

      return {
        code: item.code,
        name: item.name,
        itemType: item.item_type,
        description: item.description,
        priceCoins: item.price_coins,
        isOwned: Boolean(owned),
        isEquipped: owned?.isEquipped ?? false,
        quantity: owned?.quantity ?? 0,
        avatarSlug,
        isArmable: Boolean(owned) && armSlot !== null,
        armSlot,
        isActive: owned?.isActive ?? false,
      };
    });

    return { badges, inventory, shopItems };
  });

// ---------- Leaderboard ----------
export const getLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const [topPlayersRes, meRes] = await Promise.all([
      supabase
        .from("profiles")
        .select("id,display_name,hero_class,level,xp,current_streak,avatar_tier")
        .eq("role", "student")
        .order("xp", { ascending: false })
        .limit(LEADERBOARD_LIMIT),
      supabase
        .from("profiles")
        .select("id,xp,display_name,hero_class,level,current_streak,avatar_tier")
        .eq("id", userId)
        .maybeSingle(),
    ]);

    if (topPlayersRes.error)
      failWithClientError("getLeaderboard.topPlayers", topPlayersRes.error, DASHBOARD_ERROR_FR);
    if (meRes.error) failWithClientError("getLeaderboard.me", meRes.error, DASHBOARD_ERROR_FR);

    const topPlayers = topPlayersRes.data ?? [];

    // SECURITY: never expose peer `user_id`s to the client. `isMe` is computed
    // here (server-side) from the caller's own id; the client keys/highlights
    // rows by `rank` + `isMe`, so no other user's UUID leaves the server.
    const ranked = topPlayers.map((p, i) => ({
      rank: i + 1,
      displayName: p.display_name,
      heroClass: p.hero_class,
      level: p.level,
      xp: p.xp,
      streak: p.current_streak,
      avatarTier: p.avatar_tier,
      isMe: p.id === userId,
    }));

    let myRank = ranked.find((r) => r.isMe);

    if (!myRank && meRes.data && typeof meRes.data.xp === "number") {
      const { count, error: rankErr } = await supabase
        .from("profiles")
        .select("id", { head: true, count: "exact" })
        .eq("role", "student")
        .gt("xp", meRes.data.xp);

      if (rankErr) failWithClientError("getLeaderboard.rank", rankErr, DASHBOARD_ERROR_FR);

      myRank = {
        rank: (count ?? 0) + 1,
        displayName: meRes.data.display_name,
        heroClass: meRes.data.hero_class,
        level: meRes.data.level,
        xp: meRes.data.xp,
        streak: meRes.data.current_streak,
        avatarTier: meRes.data.avatar_tier,
        isMe: true,
      };
    }

    return { leaderboard: ranked, myRank };
  });

// ---------- Parcours catalogue (sellable journeys: concours + free libre tracks) ----------
export const getParcours = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;
    const { data, error } = await supabase
      .from("parcours")
      .select("id,name_fr,kind,is_premium,status,display_order,icon,color,theme_id,grade_id")
      .order("display_order");
    if (error) failWithClientError("getParcours", error, DASHBOARD_ERROR_FR);
    return { parcours: data ?? [] };
  });

// ---------- Subjects (lightweight list, for leaderboard tabs etc.) ----------
// ---------- Root content themes (culture générale, école tunisienne, …) ----------
export const getThemes = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;
    const { data, error } = await supabase
      .from("themes")
      .select("id,name_fr,description,icon,color_token,content_language,has_grades")
      .order("display_order");
    if (error) failWithClientError("getThemes", error, DASHBOARD_ERROR_FR);
    return { themes: data ?? [] };
  });

// ---------- Grade levels of a theme (the Tunisian ladder under 'ecole-tn') ----------
export const getGradesByTheme = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ themeId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: rows, error } = await supabase
      .from("grades")
      .select("id,slug,name_fr,cycle,is_concours_national")
      .eq("theme_id", data.themeId)
      .order("display_order");
    if (error) failWithClientError("getGradesByTheme", error, DASHBOARD_ERROR_FR);
    return { grades: rows ?? [] };
  });

// ---------- Subjects, optionally scoped to a theme and/or grade ----------
// No filter → every subject (backward compatible). Callers pass `themeId`
// (and `gradeId` for the school theme) to browse one branch of the catalogue.
export const getSubjects = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        themeId: z.string().min(1).optional(),
        gradeId: z.string().uuid().optional(),
      })
      .parse(d ?? {}),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    let query = supabase
      .from("subjects")
      .select("id,name_fr,color_token,icon,content_language,theme_id,grade_id")
      .order("display_order");
    if (data.themeId) query = query.eq("theme_id", data.themeId);
    if (data.gradeId) query = query.eq("grade_id", data.gradeId);
    const { data: rows, error } = await query;
    if (error) failWithClientError("getSubjects", error, DASHBOARD_ERROR_FR);
    return { subjects: rows ?? [] };
  });

// ---------- Per-subject leaderboard (ranked by XP earned in the subject) ----------
export const getSubjectLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ subjectId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: rows, error } = await supabase.rpc("get_subject_leaderboard", {
      p_subject: data.subjectId,
      p_limit: LEADERBOARD_LIMIT,
    });
    if (error) failWithClientError("getSubjectLeaderboard", error, DASHBOARD_ERROR_FR);

    // SECURITY: the RPC no longer returns peer `user_id`s (UUID-leak fix). Rows
    // are identified to the client by `rank` (stable, unique per board) and the
    // self row by the RPC's `is_me` flag — no other user's id is ever exposed.
    const mapped = (rows ?? []).map((r) => ({
      rank: Number(r.rank),
      displayName: r.display_name,
      heroClass: r.hero_class,
      level: r.level,
      xp: Number(r.subject_xp),
      streak: r.current_streak,
      avatarTier: r.avatar_tier,
      isMe: r.is_me,
    }));

    const leaderboard = mapped.filter((r) => r.rank <= LEADERBOARD_LIMIT);
    const myRank = mapped.find((r) => r.isMe) ?? null;

    return { leaderboard, myRank };
  });

// ---------- Get Sprint 2 dashboard data (daily objectives + weekly quests + spaced rep) ----------
export const getSprint2Dashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const currentWeekStart = getCurrentWeekStartUtc();
    const today = getTodayUtc();

    // Create today's daily objective & this week's weekly quest if missing, so
    // the widgets show a real goal (and the submit RPC has a row to increment).
    await supabase.rpc("ensure_daily_weekly_goals", { p_user: userId });

    const [dailyObjs, weeklyQs, spacedRep] = await Promise.all([
      supabase
        .from("daily_objectives")
        .select(
          "id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at",
        )
        .eq("user_id", userId)
        // #2: only today's objectives (UTC). A 24h-ago lower bound returned
        // yesterday + today, inflating daily XP and producing duplicate rows.
        .eq("objective_date", today),
      supabase
        .from("weekly_quests")
        .select(
          "id,quest_type,target_value,current_value,xp_reward,coin_reward,status,completed_at",
        )
        .eq("user_id", userId)
        .eq("week_start_date", currentWeekStart),
      supabase
        .from("spaced_repetition_schedule")
        .select("id,retry_level,scheduled_for,exercises(id,title)")
        .eq("user_id", userId)
        .eq("status", "pending")
        .lte("scheduled_for", new Date().toISOString())
        .limit(3),
    ]);

    if (dailyObjs.error)
      failWithClientError(
        "getSprint2Dashboard.dailyObjectives",
        dailyObjs.error,
        DASHBOARD_ERROR_FR,
      );
    if (weeklyQs.error)
      failWithClientError("getSprint2Dashboard.weeklyQuests", weeklyQs.error, DASHBOARD_ERROR_FR);
    if (spacedRep.error)
      failWithClientError("getSprint2Dashboard.spacedRep", spacedRep.error, DASHBOARD_ERROR_FR);

    return {
      dailyObjectives: dailyObjs.data ?? [],
      weeklyQuests: weeklyQs.data ?? [],
      pendingSpacedReps: spacedRep.data ?? [],
    };
  });

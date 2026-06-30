import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import {
  DASHBOARD_RECENT_LIMIT,
  LEADERBOARD_LIMIT,
  PASS_THRESHOLD_PCT,
} from "@/shared/constants/gamification";
import type { BadgeRow, DashboardShopItem, InventoryRow } from "@/shared/types/gamification";
import { getCurrentWeekStartUtc, getTodayUtc } from "@/shared/lib/dates";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";

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

    // Per-subject aggregates (#18) are computed over ALL of the user's attempts
    // by the `get_user_subject_stats` RPC (GROUP BY subject_id), so the dashboard
    // no longer transfers a user's entire attempt history to reduce it in JS
    // (perf audit M4). The result is bounded to one row per subject.
    const [profileRes, subjectsRes, recentRes, statsRes] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", userId).maybeSingle(),
      supabase.from("subjects").select("*").order("display_order"),
      supabase
        .from("attempts")
        .select("subject_id,score_pct,xp_earned,completed_at,exercise_id")
        .eq("user_id", userId)
        .order("completed_at", { ascending: false })
        .limit(DASHBOARD_RECENT_LIMIT),
      supabase.rpc("get_user_subject_stats"),
    ]);

    if (profileRes.error)
      failWithClientError("getDashboard.profile", profileRes.error, DASHBOARD_ERROR_FR);
    if (subjectsRes.error)
      failWithClientError("getDashboard.subjects", subjectsRes.error, DASHBOARD_ERROR_FR);
    if (recentRes.error)
      failWithClientError("getDashboard.recent", recentRes.error, DASHBOARD_ERROR_FR);
    // Stats degrade gracefully: if the RPC errors (e.g. the migration hasn't
    // applied yet during a deploy), show the dashboard with empty stats rather
    // than failing the whole page.
    if (statsRes.error)
      logger.warn("getDashboard.stats: subject-stats RPC failed, defaulting to empty", {
        error: statsRes.error.message,
      });

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

    // Build per-subject count/avg/xp from the bounded RPC aggregate (#18, M4).
    const bySubject: Record<string, { count: number; avg: number; xp: number }> = {};
    for (const r of statsRes.data ?? []) {
      bySubject[r.subject_id] = {
        count: Number(r.attempts_count),
        avg: Number(r.avg_score),
        xp: Number(r.total_xp),
      };
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
// Reads through the SECURITY DEFINER `get_global_leaderboard` RPC rather than
// `profiles` directly: since migration 20260522153000 the profiles SELECT policy
// is "own or linked profiles", so a direct query returned ONLY the caller's row
// (you could see your own score but no one else's). The RPC aggregates across all
// students despite per-row RLS and — like the per-subject board — returns no peer
// `user_id`, only the public-safe fields plus the `is_me` flag. Rows past the
// visible window are dropped; the caller's own row is always returned so "my rank"
// is known even when outside the top `LEADERBOARD_LIMIT`.
export const getLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase } = context;

    const { data: rows, error } = await supabase.rpc("get_global_leaderboard", {
      p_limit: LEADERBOARD_LIMIT,
    });
    if (error) failWithClientError("getLeaderboard", error, DASHBOARD_ERROR_FR);

    const mapped = (rows ?? []).map((r) => ({
      rank: Number(r.rank),
      displayName: r.display_name,
      heroClass: r.hero_class,
      level: r.level,
      xp: Number(r.xp),
      streak: r.current_streak,
      avatarTier: r.avatar_tier,
      isMe: r.is_me,
    }));

    const leaderboard = mapped.filter((r) => r.rank <= LEADERBOARD_LIMIT);
    const myRank = mapped.find((r) => r.isMe) ?? null;

    return { leaderboard, myRank };
  });

// ---------- Parcours catalogue (sellable journeys: concours + free libre tracks) ----------
// Each row is enriched with `hasEntitlement`: always true for free parcours, and for
// premium parcours the result of the `has_parcours_entitlement` RPC for the caller.
// The Explorer hub + onboarding read this to drive the Crown/Lock badges; the server
// gate (`resolve_exercise_access`) stays authoritative — this only shapes the UI.
// Anon-capable (chantier C8): the public catalogue (`/programme`, `/extras`) reads it
// without a session. An anonymous visitor holds no entitlement, so every parcours is
// returned `hasEntitlement: true` (the public register has no premium lock — the pivot
// is free) and the RPC is skipped. Authenticated behaviour is unchanged.
export const getParcours = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("parcours")
      .select("id,name_fr,kind,is_premium,status,display_order,icon,color,theme_id,grade_id")
      .order("display_order");
    if (error) failWithClientError("getParcours", error, DASHBOARD_ERROR_FR);
    const rows = data ?? [];

    // Enrich each parcours with its grade's cycle + pedagogical order so the
    // school group can be grouped by cycle (primaire/collège/secondaire) and
    // ordered 1ère année → Bac. One cheap lookup beats N embedded joins.
    const { data: gradeRows } = await supabase.from("grades").select("id,cycle,display_order");
    const gradeById = new Map((gradeRows ?? []).map((g) => [g.id, g]));

    const enriched = await Promise.all(
      rows.map(async (p) => {
        const grade = p.grade_id ? gradeById.get(p.grade_id) : undefined;
        const base = {
          ...p,
          grade_cycle: grade?.cycle ?? null,
          grade_order: grade?.display_order ?? null,
        };
        // Free parcours — and every parcours for an anonymous visitor — carry no
        // lock in the public register; skip the entitlement RPC (anon has none).
        if (!p.is_premium || !userId) return { ...base, hasEntitlement: true };
        const { data: ent } = await supabase.rpc("has_parcours_entitlement", {
          p_user: userId,
          p_parcours: p.id,
        });
        return { ...base, hasEntitlement: ent === true };
      }),
    );

    return { parcours: enriched };
  });

// ---------- Subjects of one parcours (public drill: catalogue → level → subjects) ----------
// Anon-capable (chantier C8). The public catalogue drills a parcours/level down to its
// subjects, each linking to the public subject hub (`/matiere/$subjectId`). A parcours
// pins a (theme, grade) pair — grade is null for the `libre` extras — and subjects are
// filtered exactly like getDashboard's active-parcours scoping. No gameplay and no
// premium lock here (free pivot); the server gate stays authoritative on `/quest`. A
// `coming_soon` parcours simply has no subjects yet → the page shows its "bientôt" state.
export const getParcoursSubjects = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .inputValidator((d) => z.object({ parcoursId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: parcours, error: parErr } = await supabase
      .from("parcours")
      .select("id,name_fr,kind,is_premium,status,theme_id,grade_id")
      .eq("id", data.parcoursId)
      .maybeSingle();
    if (parErr) failWithClientError("getParcoursSubjects.parcours", parErr, DASHBOARD_ERROR_FR);
    if (!parcours) return { parcours: null, subjects: [] };

    let query = supabase
      .from("subjects")
      .select("id,name_fr,attribute,description,content_language")
      .eq("theme_id", parcours.theme_id)
      .order("display_order");
    query = parcours.grade_id
      ? query.eq("grade_id", parcours.grade_id)
      : query.is("grade_id", null);
    const { data: subjects, error } = await query;
    if (error) failWithClientError("getParcoursSubjects.subjects", error, DASHBOARD_ERROR_FR);

    return { parcours, subjects: subjects ?? [] };
  });

// ---------- Subjects of the caller's ACTIVE parcours (leaderboard tabs) ----------
// The leaderboard offers one tab per subject of the active parcours only (GAP-018):
// listing every academy subject produced ~30 tabs, with homonym subjects across
// grades (e.g. "Mathématiques" in 9ème AND 6ème) indistinguishable. Scoping to the
// parcours both trims the tab row and removes the ambiguity (one grade → one
// subject per name). Same resolution as getDashboard: profile → parcours →
// subjects of its (theme, grade) pair. No parcours (pre-onboarding) → empty list,
// the page then shows the Global tab alone.
export const getLeaderboardSubjects = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: profile } = await supabase
      .from("profiles")
      .select("current_parcours_id")
      .eq("id", userId)
      .maybeSingle();
    const parcoursId = profile?.current_parcours_id ?? null;
    if (!parcoursId) return { subjects: [] };

    const { data: par } = await supabase
      .from("parcours")
      .select("theme_id,grade_id")
      .eq("id", parcoursId)
      .maybeSingle();
    if (!par) return { subjects: [] };

    let query = supabase
      .from("subjects")
      .select("id,name_fr,color_token,icon,content_language")
      .eq("theme_id", par.theme_id)
      .order("display_order");
    query = par.grade_id ? query.eq("grade_id", par.grade_id) : query.is("grade_id", null);
    const { data: rows, error } = await query;
    if (error) failWithClientError("getLeaderboardSubjects", error, DASHBOARD_ERROR_FR);
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

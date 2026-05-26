import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import {
  DASHBOARD_RECENT_LIMIT,
  LEADERBOARD_LIMIT,
  PASS_THRESHOLD_PCT,
} from "./gamification.constants";
import type { BadgeRow, DashboardShopItem, InventoryRow } from "./gamification.types";

function resolveFallbackDisplayName(claims: Record<string, unknown>): string {
  const userMetadata = claims.user_metadata;
  if (userMetadata && typeof userMetadata === "object") {
    const displayName = (userMetadata as Record<string, unknown>).display_name;
    if (typeof displayName === "string" && displayName.trim().length > 0) {
      return displayName.trim();
    }
  }

  return claims.is_anonymous === true ? "Guest Hero" : "Aspirant";
}

// ---------- Get dashboard ----------
export const getDashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;
    const claims = (context.claims ?? {}) as Record<string, unknown>;
    const fallbackDisplayName = resolveFallbackDisplayName(claims);

    const [profileRes, subjectsRes, attemptsRes, badgesRes, inventoryRes, shopRes] = await Promise.all([
      supabase.from("profiles").select("*").eq("id", userId).maybeSingle(),
      supabase.from("subjects").select("*").order("display_order"),
      supabase
        .from("attempts")
        .select("subject_id,score_pct,xp_earned,completed_at,exercise_id")
        .eq("user_id", userId)
        .order("completed_at", { ascending: false })
        .limit(DASHBOARD_RECENT_LIMIT),
      supabase
        .from("student_badges")
        .select("awarded_at, awarded_reason, badge:badges(code,name,rarity,icon_name)")
        .eq("student_user_id", userId)
        .order("awarded_at", { ascending: false }),
      supabase
        .from("inventory_items")
        .select("quantity, is_equipped, acquired_at, item:shop_items(id,code,name,item_type,description,price_coins)")
        .eq("student_user_id", userId)
        .order("acquired_at", { ascending: false }),
      supabase
        .from("shop_items")
        .select("id,code,name,item_type,description,price_coins,is_active")
        .eq("is_active", true)
        .order("price_coins", { ascending: true }),
    ]);

    if (profileRes.error) throw new Error(profileRes.error.message);
    if (subjectsRes.error) throw new Error(subjectsRes.error.message);
    if (attemptsRes.error) throw new Error(attemptsRes.error.message);
    if (badgesRes.error) throw new Error(badgesRes.error.message);
    if (inventoryRes.error) throw new Error(inventoryRes.error.message);
    if (shopRes.error) throw new Error(shopRes.error.message);

    let profile = profileRes.data;

    if (!profile) {
      const { error: profileInsertError } = await supabase
        .from("profiles")
        .insert({ id: userId, display_name: fallbackDisplayName });

      if (profileInsertError && profileInsertError.code !== "23505") {
        throw new Error(profileInsertError.message);
      }

      const { data: profileData, error: profileReloadError } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", userId)
        .maybeSingle();

      if (profileReloadError) throw new Error(profileReloadError.message);
      profile = profileData;
    }

    // build per-subject avg score
    const bySubject: Record<string, { count: number; avg: number; xp: number }> = {};
    for (const a of attemptsRes.data ?? []) {
      const s = (bySubject[a.subject_id] ??= { count: 0, avg: 0, xp: 0 });
      s.avg = (s.avg * s.count + Number(a.score_pct)) / (s.count + 1);
      s.count += 1;
      s.xp += a.xp_earned;
    }

    const badges = (badgesRes.data ?? []).flatMap((row: BadgeRow) => {
      if (!row.badge) return [];

      return [{
        code: row.badge.code,
        name: row.badge.name,
        rarity: row.badge.rarity,
        iconName: row.badge.icon_name,
        awardedAt: row.awarded_at,
        awardedReason: row.awarded_reason,
      }];
    });

    const inventory = (inventoryRes.data ?? []).flatMap((row: InventoryRow) => {
      if (!row.item) return [];

      return [{
        code: row.item.code,
        name: row.item.name,
        itemType: row.item.item_type,
        description: row.item.description,
        priceCoins: row.item.price_coins,
        quantity: row.quantity,
        isEquipped: row.is_equipped,
        acquiredAt: row.acquired_at,
      }];
    });

    const inventoryByCode = new Map(inventory.map((item) => [item.code, item]));
    const shopItems: DashboardShopItem[] = (shopRes.data ?? []).map((item) => {
      const owned = inventoryByCode.get(item.code);

      return {
        code: item.code,
        name: item.name,
        itemType: item.item_type,
        description: item.description,
        priceCoins: item.price_coins,
        isOwned: Boolean(owned),
        isEquipped: owned?.isEquipped ?? false,
        quantity: owned?.quantity ?? 0,
      };
    });

    // Find next incomplete exercise (score < pass threshold)
    let nextExerciseId: string | null = null;
    if (attemptsRes.data && attemptsRes.data.length > 0) {
      const lastAttempt = attemptsRes.data[0];
      if (lastAttempt.score_pct < PASS_THRESHOLD_PCT) {
        nextExerciseId = lastAttempt.exercise_id;
      }
    }

    return {
      profile,
      subjects: subjectsRes.data ?? [],
      stats: bySubject,
      recent: attemptsRes.data ?? [],
      badges,
      inventory,
      shopItems,
      nextExerciseId,
    };
  });

// ---------- Leaderboard ----------
export const getLeaderboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: topPlayers, error } = await supabase
      .from("profiles")
      .select("id,display_name,hero_class,level,xp,current_streak,avatar_tier")
      .eq("role", "student")
      .order("xp", { ascending: false })
      .limit(LEADERBOARD_LIMIT);

    if (error) throw new Error(error.message);

    const ranked = (topPlayers ?? []).map((p, i) => ({
      rank: i + 1,
      id: p.id,
      displayName: p.display_name,
      heroClass: p.hero_class,
      level: p.level,
      xp: p.xp,
      streak: p.current_streak,
      avatarTier: p.avatar_tier,
      isMe: p.id === userId,
    }));

    const myRank = ranked.find((r) => r.isMe);

    return { leaderboard: ranked, myRank };
  });

// ---------- Get Sprint 2 dashboard data (daily objectives + weekly quests + spaced rep) ----------
export const getSprint2Dashboard = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const [dailyObjs, weeklyQs, spacedRep] = await Promise.all([
      supabase
        .from("daily_objectives")
        .select("id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at")
        .eq("user_id", userId)
        .gte("objective_date", new Date(Date.now() - 86400000).toISOString().split("T")[0]),
      supabase
        .from("weekly_quests")
        .select("id,quest_type,target_value,current_value,xp_reward,coin_reward,status,completed_at")
        .eq("user_id", userId),
      supabase
        .from("spaced_repetition_schedule")
        .select("id,retry_level,scheduled_for,exercises(id,title)")
        .eq("user_id", userId)
        .eq("status", "pending")
        .lte("scheduled_for", new Date().toISOString())
        .limit(3),
    ]);

    return {
      dailyObjectives: dailyObjs.data ?? [],
      weeklyQuests: weeklyQs.data ?? [],
      pendingSpacedReps: spacedRep.data ?? [],
    };
  });

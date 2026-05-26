import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";

type UnlockedBadge = {
  code: string;
  name: string;
  rarity: string;
  iconName: string | null;
};

type DashboardShopItem = {
  code: string;
  name: string;
  itemType: string;
  description: string | null;
  priceCoins: number;
  isOwned: boolean;
  isEquipped: boolean;
  quantity: number;
};

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
        .limit(50),
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

    const badges = (badgesRes.data ?? []).flatMap((row: any) => {
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

    const inventory = (inventoryRes.data ?? []).flatMap((row: any) => {
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

    return {
      profile,
      subjects: subjectsRes.data ?? [],
      stats: bySubject,
      recent: attemptsRes.data ?? [],
      badges,
      inventory,
      shopItems,
    };
  });

// ---------- Buy a shop item ----------
export const purchaseShopItem = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const [profileRes, shopItemRes] = await Promise.all([
      supabase.from("profiles").select("id,yahia_coins").eq("id", userId).single(),
      supabase
        .from("shop_items")
        .select("id,code,name,item_type,description,price_coins,is_active")
        .eq("code", data.itemCode)
        .eq("is_active", true)
        .single(),
    ]);

    if (profileRes.error) throw new Error(profileRes.error.message);
    if (shopItemRes.error) throw new Error(shopItemRes.error.message);

    const profile = profileRes.data;
    const shopItem = shopItemRes.data;

    if ((profile.yahia_coins ?? 0) < shopItem.price_coins) {
      throw new Error("Insufficient XP Coins.");
    }

    const existingInventoryRes = await supabase
      .from("inventory_items")
      .select("id,quantity")
      .eq("student_user_id", userId)
      .eq("shop_item_id", shopItem.id)
      .maybeSingle();
    if (existingInventoryRes.error) throw new Error(existingInventoryRes.error.message);

    if (shopItem.item_type === "skin" && existingInventoryRes.data) {
      throw new Error("This skin is already in your inventory.");
    }

    const newCoins = (profile.yahia_coins ?? 0) - shopItem.price_coins;
    const profileUpdateRes = await supabase
      .from("profiles")
      .update({ yahia_coins: newCoins })
      .eq("id", userId);
    if (profileUpdateRes.error) throw new Error(profileUpdateRes.error.message);

    if (existingInventoryRes.data) {
      const inventoryUpdateRes = await supabase
        .from("inventory_items")
        .update({ quantity: existingInventoryRes.data.quantity + 1 })
        .eq("id", existingInventoryRes.data.id)
        .eq("student_user_id", userId);
      if (inventoryUpdateRes.error) throw new Error(inventoryUpdateRes.error.message);
    } else {
      const inventoryInsertRes = await supabase
        .from("inventory_items")
        .insert({
          student_user_id: userId,
          shop_item_id: shopItem.id,
          quantity: 1,
          is_equipped: false,
        });
      if (inventoryInsertRes.error) throw new Error(inventoryInsertRes.error.message);
    }

    return {
      itemCode: shopItem.code,
      remainingCoins: newCoins,
      purchasedItemName: shopItem.name,
    };
  });

// ---------- Equip a skin from inventory ----------
export const equipInventorySkin = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ itemCode: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const inventoryRes = await supabase
      .from("inventory_items")
      .select("id,shop_item_id,item:shop_items(code,name,item_type,effect_payload)")
      .eq("student_user_id", userId);

    if (inventoryRes.error) throw new Error(inventoryRes.error.message);
    const inventoryItem = (inventoryRes.data ?? []).find((row: any) => row.item?.code === data.itemCode);

    if (!inventoryItem?.item) throw new Error("Item not found in inventory.");
    if (inventoryItem.item.item_type !== "skin") throw new Error("Only skins can be equipped.");

    const skinRows = (inventoryRes.data ?? []).filter((row: any) => row.item?.item_type === "skin");
    if (skinRows.length > 0) {
      const resetRes = await supabase
        .from("inventory_items")
        .update({ is_equipped: false })
        .in("id", skinRows.map((row: any) => row.id));
      if (resetRes.error) throw new Error(resetRes.error.message);
    }

    const equipRes = await supabase
      .from("inventory_items")
      .update({ is_equipped: true })
      .eq("id", inventoryItem.id)
      .eq("student_user_id", userId);
    if (equipRes.error) throw new Error(equipRes.error.message);

    const avatarSlug = typeof inventoryItem.item.effect_payload === "object"
      && inventoryItem.item.effect_payload !== null
      && "avatarSlug" in inventoryItem.item.effect_payload
      ? inventoryItem.item.effect_payload.avatarSlug
      : null;

    if (typeof avatarSlug === "string") {
      const profileRes = await supabase
        .from("profiles")
        .update({ avatar_slug: avatarSlug })
        .eq("id", userId);
      if (profileRes.error) throw new Error(profileRes.error.message);
    }

    return {
      itemCode: inventoryItem.item.code,
      itemName: inventoryItem.item.name,
      avatarSlug: typeof avatarSlug === "string" ? avatarSlug : null,
    };
  });

// ---------- Get a subject with chapters & exercises ----------
export const getSubject = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ subjectId: z.string() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const [subj, chaps, exs, atts] = await Promise.all([
      supabase.from("subjects").select("*").eq("id", data.subjectId).single(),
      supabase.from("chapters").select("*").eq("subject_id", data.subjectId).order("display_order"),
      supabase.from("exercises").select("*").eq("subject_id", data.subjectId).order("display_order"),
      supabase.from("attempts").select("exercise_id,score_pct").eq("user_id", userId).eq("subject_id", data.subjectId),
    ]);
    if (subj.error) throw new Error(subj.error.message);

    const best: Record<string, number> = {};
    for (const a of atts.data ?? []) {
      best[a.exercise_id] = Math.max(best[a.exercise_id] ?? 0, Number(a.score_pct));
    }

    return {
      subject: subj.data,
      chapters: chaps.data ?? [],
      exercises: exs.data ?? [],
      bestByExercise: best,
    };
  });

// ---------- Get chapter lesson content ----------
export const getChapterLesson = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ chapterId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: chapter, error } = await supabase
      .from("chapters")
      .select("id, title, description, lesson_content, subject_id, subjects(name_fr, color_token, icon)")
      .eq("id", data.chapterId)
      .single();
    if (error) throw new Error(error.message);
    return { chapter };
  });

// ---------- Get exercise + questions ----------
export const getExercise = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const [ex, qs] = await Promise.all([
      supabase.from("exercises").select("*, subjects(*), chapters(*)").eq("id", data.exerciseId).single(),
      supabase
        .from("questions")
        .select("id,prompt,options,explanation,display_order")
        .eq("exercise_id", data.exerciseId)
        .order("display_order"),
    ]);
    if (ex.error) throw new Error(ex.error.message);
    return { exercise: ex.data, questions: qs.data ?? [] };
  });

// ---------- Start a secure exercise session ----------
export const startExerciseSession = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ exerciseId: z.string().uuid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: session, error } = await supabase
      .from("exercise_sessions")
      .insert({ user_id: userId, exercise_id: data.exerciseId })
      .select("id,started_at")
      .single();

    if (error) throw new Error(error.message);

    return {
      sessionId: session.id,
      startedAt: session.started_at,
    };
  });

// ---------- Submit attempt ----------
export const submitAttempt = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      sessionId: z.string().uuid(),
      exerciseId: z.string().uuid(),
      answers: z.array(z.object({ questionId: z.string().uuid(), choice: z.string() })).min(1).max(100),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const [sessionRes, exRes, qsRes] = await Promise.all([
      supabase
        .from("exercise_sessions")
        .select("id,exercise_id,started_at,completed_at")
        .eq("id", data.sessionId)
        .eq("user_id", userId)
        .single(),
      supabase.from("exercises").select("id,subject_id,xp_reward,reward_coins,difficulty").eq("id", data.exerciseId).single(),
      supabase
        .from("questions")
        .select("id,prompt,correct_option,explanation")
        .eq("exercise_id", data.exerciseId),
    ]);
    if (sessionRes.error) throw new Error(sessionRes.error.message);
    if (exRes.error) throw new Error(exRes.error.message);
    if (qsRes.error) throw new Error(qsRes.error.message);

    if (sessionRes.data.exercise_id !== data.exerciseId) {
      throw new Error("Invalid quest session.");
    }

    if (sessionRes.data.completed_at) {
      throw new Error("This quest session is already completed.");
    }

    const questionMap = new Map(qsRes.data.map((q) => [q.id, q]));
    let correct = 0;
    for (const a of data.answers) {
      if (questionMap.get(a.questionId)?.correct_option === a.choice) correct += 1;
    }
    const total = qsRes.data.length;
    const pct = total > 0 ? (correct / total) * 100 : 0;

    const review = data.answers.map((answer) => {
      const question = questionMap.get(answer.questionId);

      return {
        questionId: answer.questionId,
        prompt: question?.prompt ?? "Question",
        selectedChoice: answer.choice,
        correctChoice: question?.correct_option ?? "",
        isCorrect: question?.correct_option === answer.choice,
        explanation: question?.explanation ?? null,
      };
    });

    const durationSeconds = Math.max(
      1,
      Math.round((Date.now() - new Date(sessionRes.data.started_at).getTime()) / 1000),
    );

    // Scoring: base + speed bonus
    const idealTime = total * 30; // 30s per Q
    const speedFactor = Math.max(0.5, Math.min(1.4, idealTime / Math.max(15, durationSeconds)));
    const xpEarned = Math.round(exRes.data.xp_reward * (pct / 100) * speedFactor);

    // Coin reward: full coins if score >= 60%, half if >= 40%, zero otherwise
    const rewardCoins = exRes.data.reward_coins ?? 0;
    const coinsEarned = pct >= 60 ? rewardCoins : pct >= 40 ? Math.round(rewardCoins / 2) : 0;

    // Insert attempt
    const insRes = await supabase.from("attempts").insert({
      user_id: userId,
      exercise_id: data.exerciseId,
      subject_id: exRes.data.subject_id,
      correct_count: correct,
      total_count: total,
      score_pct: pct,
      duration_seconds: durationSeconds,
      xp_earned: xpEarned,
    });
    if (insRes.error) throw new Error(insRes.error.message);

    const sessionUpdate = await supabase
      .from("exercise_sessions")
      .update({ completed_at: new Date().toISOString() })
      .eq("id", data.sessionId)
      .eq("user_id", userId);
    if (sessionUpdate.error) throw new Error(sessionUpdate.error.message);

    // Award XP via DB function (security definer)
    const { data: newProfile, error: rpcErr } = await supabase.rpc("award_xp", { p_user: userId, p_xp: xpEarned });
    if (rpcErr) throw new Error(rpcErr.message);

    const profile = Array.isArray(newProfile) ? newProfile[0] : newProfile;

    // Award coins
    if (coinsEarned > 0 && profile) {
      const newCoins = (profile.yahia_coins ?? 0) + coinsEarned;
      const { error: coinErr } = await supabase
        .from("profiles")
        .update({ yahia_coins: newCoins })
        .eq("id", userId);
      if (coinErr) throw new Error(coinErr.message);
      profile.yahia_coins = newCoins;
    }

    const unlockedBadges: UnlockedBadge[] = [];

    // Badge: first_quest (first attempt ever)
    const { count: attemptCount } = await supabase
      .from("attempts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", userId);
    if (attemptCount === 1) {
      const { data: firstBadge } = await supabase
        .from("badges")
        .select("id,code,name,rarity,icon_name")
        .eq("code", "first_quest")
        .maybeSingle();
      if (firstBadge) {
        const { error: fbErr } = await supabase
          .from("student_badges")
          .insert({ student_user_id: userId, badge_id: firstBadge.id, awarded_reason: "First quest completed" });
        if (!fbErr) {
          unlockedBadges.push({ code: firstBadge.code, name: firstBadge.name, rarity: firstBadge.rarity, iconName: firstBadge.icon_name });
        }
      }
    }

    // Badge: perfect_score
    if (pct === 100) {
      const { data: perfectBadge } = await supabase
        .from("badges")
        .select("id,code,name,rarity,icon_name")
        .eq("code", "perfect_score")
        .maybeSingle();
      if (perfectBadge) {
        const { error: psErr } = await supabase
          .from("student_badges")
          .insert({ student_user_id: userId, badge_id: perfectBadge.id, awarded_reason: "Perfect score: 100%" });
        if (!psErr) {
          unlockedBadges.push({ code: perfectBadge.code, name: perfectBadge.name, rarity: perfectBadge.rarity, iconName: perfectBadge.icon_name });
        }
      }
    }

    // Badge: speed_demon (under 60s)
    if (durationSeconds < 60 && pct >= 60) {
      const { data: speedBadge } = await supabase
        .from("badges")
        .select("id,code,name,rarity,icon_name")
        .eq("code", "speed_demon")
        .maybeSingle();
      if (speedBadge) {
        const { error: sdErr } = await supabase
          .from("student_badges")
          .insert({ student_user_id: userId, badge_id: speedBadge.id, awarded_reason: "Quest completed in under 60s" });
        if (!sdErr) {
          unlockedBadges.push({ code: speedBadge.code, name: speedBadge.name, rarity: speedBadge.rarity, iconName: speedBadge.icon_name });
        }
      }
    }

    // Badge: streak_7
    if (profile?.current_streak >= 7) {
      const { data: streakBadge, error: badgeErr } = await supabase
        .from("badges")
        .select("id,code,name,rarity,icon_name")
        .eq("code", "streak_7")
        .maybeSingle();

      if (badgeErr) throw new Error(badgeErr.message);

      if (streakBadge) {
        const { error: insertBadgeErr } = await supabase
          .from("student_badges")
          .insert({
            student_user_id: userId,
            badge_id: streakBadge.id,
            awarded_reason: "7 consecutive days of studying",
          });

        if (insertBadgeErr && insertBadgeErr.code !== "23505") {
          throw new Error(insertBadgeErr.message);
        }

        if (!insertBadgeErr) {
          unlockedBadges.push({
            code: streakBadge.code,
            name: streakBadge.name,
            rarity: streakBadge.rarity,
            iconName: streakBadge.icon_name,
          });
        }
      }
    }

    return {
      correct, total, scorePct: pct, xpEarned, coinsEarned, durationSeconds,
      profile,
      review,
      unlockedBadges,
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
      .limit(50);

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

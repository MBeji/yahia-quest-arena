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

    // Find next incomplete exercise (score < 60%)
    let nextExerciseId: string | null = null;
    if (attemptsRes.data && attemptsRes.data.length > 0) {
      const lastAttempt = attemptsRes.data[0];
      if (lastAttempt.score_pct < 60) {
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
      .select("id, title, description, lesson_content, subject_id, display_order, subjects(id, name_fr, color_token, icon)")
      .eq("id", data.chapterId)
      .single();
    if (error) throw new Error(error.message);

    // Fetch all sibling chapters for navigation
    const { data: siblings } = await supabase
      .from("chapters")
      .select("id, title, display_order, lesson_content")
      .eq("subject_id", chapter.subject_id)
      .order("display_order");

    const allChapters = (siblings ?? []).map((s) => ({
      id: s.id,
      title: s.title,
      display_order: s.display_order,
      hasLesson: !!s.lesson_content,
    }));

    return { chapter, allChapters };
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
        .select("id,prompt,options,explanation,display_order,correct_option")
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

    // ========== SPRINT 2: Update daily objectives, weekly quests, spaced repetition ==========
    
    // Try to get the attempt ID we just inserted (for spaced repetition scheduling)
    const { data: justInserted } = await supabase
      .from("attempts")
      .select("id")
      .eq("user_id", userId)
      .eq("exercise_id", data.exerciseId)
      .order("completed_at", { ascending: false })
      .limit(1)
      .single();

    const attemptId = justInserted?.id ?? "";

    // Schedule spaced repetition if score < 60%
    if (pct < 60 && attemptId) {
      await supabase.from("spaced_repetition_schedule").insert({
        user_id: userId,
        exercise_id: data.exerciseId,
        subject_id: exRes.data.subject_id,
        failed_attempt_id: attemptId,
        retry_level: 1,
        scheduled_for: new Date(Date.now() + 86400000).toISOString(), // 1 day from now
        status: "pending",
      }).catch(() => {
        // Ignore errors, don't break the flow
      });

      // Also schedule 3-day and 7-day retries
      await supabase.from("spaced_repetition_schedule").insert({
        user_id: userId,
        exercise_id: data.exerciseId,
        subject_id: exRes.data.subject_id,
        failed_attempt_id: attemptId,
        retry_level: 2,
        scheduled_for: new Date(Date.now() + 259200000).toISOString(), // 3 days
        status: "pending",
      }).catch(() => {
        // Ignore errors
      });

      await supabase.from("spaced_repetition_schedule").insert({
        user_id: userId,
        exercise_id: data.exerciseId,
        subject_id: exRes.data.subject_id,
        failed_attempt_id: attemptId,
        retry_level: 3,
        scheduled_for: new Date(Date.now() + 604800000).toISOString(), // 7 days
        status: "pending",
      }).catch(() => {
        // Ignore errors
      });
    }

    // Adapt difficulty based on performance
    await supabase
      .from("difficulty_adaptation")
      .upsert({
        user_id: userId,
        subject_id: exRes.data.subject_id,
        avg_score: Math.max(0, pct),
        current_difficulty_level: 1,
      }, { onConflict: "user_id,subject_id" })
      .catch(() => {
        // Ignore errors
      });

    // Update daily objective: 3 exercises (increment by 1)
    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);
    const todayStr = today.toISOString().split("T")[0];

    const { data: dailyObj } = await supabase
      .from("daily_objectives")
      .select("id,current_value,target_value")
      .eq("user_id", userId)
      .eq("objective_type", "3_exercises")
      .eq("objective_date", todayStr)
      .maybeSingle()
      .catch(() => ({ data: null }));

    if (dailyObj) {
      const newValue = dailyObj.current_value + 1;
      const isCompleted = newValue >= dailyObj.target_value;
      await supabase
        .from("daily_objectives")
        .update({
          current_value: newValue,
          status: isCompleted ? "completed" : "active",
          completed_at: isCompleted ? new Date().toISOString() : null,
        })
        .eq("id", dailyObj.id)
        .catch(() => {
          // Ignore errors
        });
    }

    // Update weekly quest: maintain streak or beat bosses (if this is a "boss" mode exercise)
    const exerciseMode = exRes.data.mode;
    if (pct >= 60 && exerciseMode === "boss") {
      const dayOfWeek = new Date().getUTCDay();
      const diff = new Date().getUTCDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1);
      const monday = new Date();
      monday.setUTCDate(diff);
      monday.setUTCHours(0, 0, 0, 0);
      const mondayStr = monday.toISOString().split("T")[0];

      const { data: bossQuest } = await supabase
        .from("weekly_quests")
        .select("id,current_value,target_value")
        .eq("user_id", userId)
        .eq("quest_type", "beat_2_bosses")
        .eq("week_start_date", mondayStr)
        .maybeSingle()
        .catch(() => ({ data: null }));

      if (bossQuest) {
        const newValue = bossQuest.current_value + 1;
        const isCompleted = newValue >= bossQuest.target_value;
        await supabase
          .from("weekly_quests")
          .update({
            current_value: newValue,
            status: isCompleted ? "completed" : "active",
            completed_at: isCompleted ? new Date().toISOString() : null,
          })
          .eq("id", bossQuest.id)
          .catch(() => {
            // Ignore errors
          });
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

// ========== SPRINT 2: SPACED REPETITION, DAILY OBJECTIVES, WEEKLY QUESTS ==========

// ---------- Schedule spaced repetition after failed attempt ----------
export const scheduleSpacedRepetition = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      exerciseId: z.string().uuid(),
      subjectId: z.string().uuid(),
      attemptId: z.string().uuid(),
      scorePct: z.number(),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Only schedule if score < 60% (failed attempt)
    if (data.scorePct >= 60) {
      return { scheduled: false, reason: "Score >= 60%, no need for spaced repetition" };
    }

    // Schedule retry levels: 1d, 3d, 7d
    const schedules = [
      { retryLevel: 1, daysOffset: 1 },
      { retryLevel: 2, daysOffset: 3 },
      { retryLevel: 3, daysOffset: 7 },
    ];

    const now = new Date();
    const scheduledForDates = schedules.map((s) => {
      const d = new Date(now);
      d.setDate(d.getDate() + s.daysOffset);
      return {
        retryLevel: s.retryLevel,
        scheduledFor: d.toISOString(),
      };
    });

    for (const schedule of scheduledForDates) {
      const { error } = await supabase.from("spaced_repetition_schedule").insert({
        user_id: userId,
        exercise_id: data.exerciseId,
        subject_id: data.subjectId,
        failed_attempt_id: data.attemptId,
        retry_level: schedule.retryLevel,
        scheduled_for: schedule.scheduledFor,
        status: "pending",
      });

      if (error && error.code !== "23505") {
        // Ignore duplicate key errors
        throw new Error(error.message);
      }
    }

    return { scheduled: true, levels: 3 };
  });

// ---------- Get pending spaced repetition exercises ----------
export const getPendingSpacedRepetition = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: pending, error } = await supabase
      .from("spaced_repetition_schedule")
      .select(
        `id,exercise_id,subject_id,retry_level,scheduled_for,
        exercises(id,title,chapter_id,subject_id,subjects(name_fr)),
        subjects(name_fr,color_token)`
      )
      .eq("user_id", userId)
      .eq("status", "pending")
      .lte("scheduled_for", new Date().toISOString())
      .order("scheduled_for");

    if (error) throw new Error(error.message);

    return pending ?? [];
  });

// ---------- Get today's daily objectives ----------
export const getDailyObjectives = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);
    const todayStr = today.toISOString().split("T")[0];

    let { data: objectives, error } = await supabase
      .from("daily_objectives")
      .select("id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at")
      .eq("user_id", userId)
      .eq("objective_date", todayStr);

    if (error) throw new Error(error.message);

    // If no objectives for today, auto-create them
    if (!objectives || objectives.length === 0) {
      const objectiveTypes = [
        { type: "10_min", target: 10, xp: 50, coins: 10 },
        { type: "3_exercises", target: 3, xp: 75, coins: 15 },
      ];

      for (const obj of objectiveTypes) {
        const { error: insertErr } = await supabase.from("daily_objectives").insert({
          user_id: userId,
          objective_type: obj.type,
          target_value: obj.target,
          current_value: 0,
          objective_date: todayStr,
          xp_reward: obj.xp,
          coin_reward: obj.coins,
          status: "active",
        });

        if (insertErr && insertErr.code !== "23505") {
          throw new Error(insertErr.message);
        }
      }

      // Fetch again
      const { data: newObjs, error: fetchErr } = await supabase
        .from("daily_objectives")
        .select("id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at")
        .eq("user_id", userId)
        .eq("objective_date", todayStr);

      if (fetchErr) throw new Error(fetchErr.message);
      objectives = newObjs;
    }

    return objectives ?? [];
  });

// ---------- Update daily objective progress ----------
export const updateDailyObjectiveProgress = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      objectiveType: z.enum(["10_min", "15_min", "3_exercises"]),
      incrementValue: z.number().positive(),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const today = new Date();
    today.setUTCHours(0, 0, 0, 0);
    const todayStr = today.toISOString().split("T")[0];

    const { data: objective, error: fetchErr } = await supabase
      .from("daily_objectives")
      .select("id,objective_type,target_value,current_value,status")
      .eq("user_id", userId)
      .eq("objective_type", data.objectiveType)
      .eq("objective_date", todayStr)
      .maybeSingle();

    if (fetchErr) throw new Error(fetchErr.message);
    if (!objective) return { completed: false, progress: 0 };

    const newValue = objective.current_value + data.incrementValue;
    const isCompleted = newValue >= objective.target_value;

    const { error: updateErr } = await supabase
      .from("daily_objectives")
      .update({
        current_value: newValue,
        status: isCompleted ? "completed" : "active",
        completed_at: isCompleted ? new Date().toISOString() : null,
      })
      .eq("id", objective.id);

    if (updateErr) throw new Error(updateErr.message);

    return {
      completed: isCompleted,
      progress: Math.min(newValue, objective.target_value),
      target: objective.target_value,
    };
  });

// ---------- Get this week's quests ----------
export const getWeeklyQuests = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const today = new Date();
    const dayOfWeek = today.getUTCDay();
    const diff = today.getUTCDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1); // Monday start
    const monday = new Date(today.setUTCDate(diff));
    monday.setUTCHours(0, 0, 0, 0);
    const mondayStr = monday.toISOString().split("T")[0];

    let { data: quests, error } = await supabase
      .from("weekly_quests")
      .select("id,quest_type,subject_id,target_value,current_value,xp_reward,coin_reward,status,completed_at")
      .eq("user_id", userId)
      .eq("week_start_date", mondayStr);

    if (error) throw new Error(error.message);

    // If no quests for this week, auto-create them
    if (!quests || quests.length === 0) {
      const questTypes = [
        { type: "maintain_streak_5", target: 5, xp: 150, coins: 30 },
        { type: "beat_2_bosses", target: 2, xp: 200, coins: 50 },
      ];

      for (const q of questTypes) {
        const { error: insertErr } = await supabase.from("weekly_quests").insert({
          user_id: userId,
          quest_type: q.type,
          target_value: q.target,
          current_value: 0,
          week_start_date: mondayStr,
          xp_reward: q.xp,
          coin_reward: q.coins,
          status: "active",
        });

        if (insertErr && insertErr.code !== "23505") {
          throw new Error(insertErr.message);
        }
      }

      // Fetch again
      const { data: newQuests, error: fetchErr } = await supabase
        .from("weekly_quests")
        .select("id,quest_type,subject_id,target_value,current_value,xp_reward,coin_reward,status,completed_at")
        .eq("user_id", userId)
        .eq("week_start_date", mondayStr);

      if (fetchErr) throw new Error(fetchErr.message);
      quests = newQuests;
    }

    return quests ?? [];
  });

// ---------- Update weekly quest progress ----------
export const updateWeeklyQuestProgress = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      questType: z.string().min(1),
      incrementValue: z.number().positive(),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const today = new Date();
    const dayOfWeek = today.getUTCDay();
    const diff = today.getUTCDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1);
    const monday = new Date(today.setUTCDate(diff));
    monday.setUTCHours(0, 0, 0, 0);
    const mondayStr = monday.toISOString().split("T")[0];

    const { data: quest, error: fetchErr } = await supabase
      .from("weekly_quests")
      .select("id,quest_type,target_value,current_value,status")
      .eq("user_id", userId)
      .eq("quest_type", data.questType)
      .eq("week_start_date", mondayStr)
      .maybeSingle();

    if (fetchErr) throw new Error(fetchErr.message);
    if (!quest) return { completed: false, progress: 0 };

    const newValue = quest.current_value + data.incrementValue;
    const isCompleted = newValue >= quest.target_value;

    const { error: updateErr } = await supabase
      .from("weekly_quests")
      .update({
        current_value: newValue,
        status: isCompleted ? "completed" : "active",
        completed_at: isCompleted ? new Date().toISOString() : null,
      })
      .eq("id", quest.id);

    if (updateErr) throw new Error(updateErr.message);

    return {
      completed: isCompleted,
      progress: Math.min(newValue, quest.target_value),
      target: quest.target_value,
    };
  });

// ---------- Adapt difficulty based on performance ----------
export const adaptDifficulty = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      subjectId: z.string().uuid(),
      newScore: z.number().min(0).max(100),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Get or create difficulty adaptation record
    let { data: adaptation, error: fetchErr } = await supabase
      .from("difficulty_adaptation")
      .select("*")
      .eq("user_id", userId)
      .eq("subject_id", data.subjectId)
      .maybeSingle();

    if (fetchErr) throw new Error(fetchErr.message);

    if (!adaptation) {
      // Create new record
      const { data: newAdapt, error: createErr } = await supabase
        .from("difficulty_adaptation")
        .insert({
          user_id: userId,
          subject_id: data.subjectId,
          avg_score: data.newScore,
          recent_avg_score: data.newScore,
          total_attempts: 1,
          current_difficulty_level: 1,
        })
        .select()
        .single();

      if (createErr) throw new Error(createErr.message);
      adaptation = newAdapt;
    } else {
      // Update existing record
      const totalAttempts = adaptation.total_attempts + 1;
      
      // Recalculate average from last 10 attempts
      const { data: recentAttempts } = await supabase
        .from("attempts")
        .select("score_pct")
        .eq("user_id", userId)
        .eq("subject_id", data.subjectId)
        .order("completed_at", { ascending: false })
        .limit(10);

      const recentScores = [data.newScore, ...(recentAttempts ?? []).map((a) => a.score_pct as number)];
      const recentAvg = Math.round(recentScores.slice(0, 10).reduce((a, b) => a + b, 0) / Math.min(recentScores.length, 10));

      const overallAvg = Math.round(((adaptation.avg_score * adaptation.total_attempts) + data.newScore) / totalAttempts);

      let newDifficulty = adaptation.current_difficulty_level;
      
      // Increase difficulty if recent avg > 75%
      if (recentAvg > 75 && newDifficulty < 4) {
        newDifficulty = newDifficulty + 1;
      }
      // Decrease difficulty if recent avg < 40%
      else if (recentAvg < 40 && newDifficulty > 1) {
        newDifficulty = newDifficulty - 1;
      }

      const { error: updateErr } = await supabase
        .from("difficulty_adaptation")
        .update({
          avg_score: overallAvg,
          recent_avg_score: recentAvg,
          total_attempts: totalAttempts,
          current_difficulty_level: newDifficulty,
          updated_at: new Date().toISOString(),
        })
        .eq("id", adaptation.id);

      if (updateErr) throw new Error(updateErr.message);

      adaptation.avg_score = overallAvg;
      adaptation.recent_avg_score = recentAvg;
      adaptation.current_difficulty_level = newDifficulty;
    }

    return adaptation;
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

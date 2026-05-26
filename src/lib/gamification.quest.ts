import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { isRateLimited } from "./rate-limit";
import type { UnlockedBadge } from "./gamification.types";
import {
  HALF_COIN_THRESHOLD_PCT,
  IDEAL_TIME_PER_QUESTION_S,
  MIN_DURATION_FLOOR_S,
  PASS_THRESHOLD_PCT,
  SPACED_REPETITION_INTERVALS_MS,
  SPEED_DEMON_THRESHOLD_S,
  SPEED_FACTOR_MAX,
  SPEED_FACTOR_MIN,
  STREAK_BADGE_THRESHOLD,
} from "./gamification.constants";

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

    // Rate limit: max 5 submissions per 10 seconds
    if (isRateLimited(`submit_${userId}`, 5, 10_000)) {
      throw new Error("Too many submissions. Please slow down.");
    }

    const [sessionRes, exRes, qsRes] = await Promise.all([
      supabase
        .from("exercise_sessions")
        .select("id,exercise_id,started_at,completed_at")
        .eq("id", data.sessionId)
        .eq("user_id", userId)
        .single(),
      supabase.from("exercises").select("id,subject_id,xp_reward,reward_coins,difficulty,mode").eq("id", data.exerciseId).single(),
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
    const idealTime = total * IDEAL_TIME_PER_QUESTION_S;
    const speedFactor = Math.max(SPEED_FACTOR_MIN, Math.min(SPEED_FACTOR_MAX, idealTime / Math.max(MIN_DURATION_FLOOR_S, durationSeconds)));
    const xpEarned = Math.round(exRes.data.xp_reward * (pct / 100) * speedFactor);

    // Coin reward: full coins if score >= pass threshold, half if >= half threshold, zero otherwise
    const rewardCoins = exRes.data.reward_coins ?? 0;
    const coinsEarned = pct >= PASS_THRESHOLD_PCT ? rewardCoins : pct >= HALF_COIN_THRESHOLD_PCT ? Math.round(rewardCoins / 2) : 0;

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

    // Award coins atomically
    if (coinsEarned > 0 && profile) {
      await supabase.rpc("award_coins", { p_user: userId, p_coins: coinsEarned }).catch(() => {});
      profile.yahia_coins = (profile.yahia_coins ?? 0) + coinsEarned;
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

    // Badge: speed_demon
    if (durationSeconds < SPEED_DEMON_THRESHOLD_S && pct >= PASS_THRESHOLD_PCT) {
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
    if (profile?.current_streak >= STREAK_BADGE_THRESHOLD) {
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

    // ========== Post-attempt side effects: spaced repetition, daily objectives, weekly quests ==========

    // Get the attempt ID we just inserted (for spaced repetition scheduling)
    const { data: justInserted } = await supabase
      .from("attempts")
      .select("id")
      .eq("user_id", userId)
      .eq("exercise_id", data.exerciseId)
      .order("completed_at", { ascending: false })
      .limit(1)
      .single();

    const attemptId = justInserted?.id ?? "";

    // Schedule spaced repetition if score < pass threshold (with dedup)
    if (pct < PASS_THRESHOLD_PCT && attemptId) {
      // Check if there's already a pending schedule for this exercise
      const { data: existingSchedule } = await supabase
        .from("spaced_repetition_schedule")
        .select("id")
        .eq("user_id", userId)
        .eq("exercise_id", data.exerciseId)
        .eq("status", "pending")
        .limit(1)
        .maybeSingle()
        .catch(() => ({ data: null }));

      if (!existingSchedule) {
        for (const [i, intervalMs] of SPACED_REPETITION_INTERVALS_MS.entries()) {
          await supabase.from("spaced_repetition_schedule").insert({
            user_id: userId,
            exercise_id: data.exerciseId,
            subject_id: exRes.data.subject_id,
            failed_attempt_id: attemptId,
            retry_level: i + 1,
            scheduled_for: new Date(Date.now() + intervalMs).toISOString(),
            status: "pending",
          }).catch(() => {});
        }
      }
    }

    // Adapt difficulty based on recent performance (windowed average)
    {
      const { data: adaptation } = await supabase
        .from("difficulty_adaptation")
        .select("*")
        .eq("user_id", userId)
        .eq("subject_id", exRes.data.subject_id)
        .maybeSingle();

      if (!adaptation) {
        await supabase.from("difficulty_adaptation").insert({
          user_id: userId,
          subject_id: exRes.data.subject_id,
          avg_score: pct,
          recent_avg_score: pct,
          total_attempts: 1,
          current_difficulty_level: 1,
        }).catch(() => {});
      } else {
        const { data: recentAtts } = await supabase
          .from("attempts")
          .select("score_pct")
          .eq("user_id", userId)
          .eq("subject_id", exRes.data.subject_id)
          .order("completed_at", { ascending: false })
          .limit(10);

        const scores = (recentAtts ?? []).map((a) => a.score_pct as number);
        const recentAvg = scores.length > 0 ? Math.round(scores.reduce((a, b) => a + b, 0) / scores.length) : pct;
        const totalAttempts = adaptation.total_attempts + 1;
        const overallAvg = Math.round(((adaptation.avg_score * adaptation.total_attempts) + pct) / totalAttempts);

        let newDiff = adaptation.current_difficulty_level;
        if (recentAvg > 75 && newDiff < 4) newDiff++;
        else if (recentAvg < 40 && newDiff > 1) newDiff--;

        await supabase.from("difficulty_adaptation").update({
          avg_score: overallAvg,
          recent_avg_score: recentAvg,
          total_attempts: totalAttempts,
          current_difficulty_level: newDiff,
          updated_at: new Date().toISOString(),
        }).eq("id", adaptation.id).catch(() => {});
      }
    }

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

    // Update weekly quest: beat bosses (if this is a "boss" mode exercise)
    const exerciseMode = exRes.data.mode;
    if (pct >= PASS_THRESHOLD_PCT && exerciseMode === "boss") {
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

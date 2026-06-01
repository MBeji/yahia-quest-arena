import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import {
  DEFAULT_DAILY_OBJECTIVES,
  DEFAULT_WEEKLY_QUESTS,
  DIFFICULTY_DECREASE_THRESHOLD,
  DIFFICULTY_INCREASE_THRESHOLD,
  MAX_DIFFICULTY_LEVEL,
  MIN_DIFFICULTY_LEVEL,
  PASS_THRESHOLD_PCT,
  RECENT_ATTEMPTS_WINDOW,
  SPACED_REPETITION_INTERVALS_MS,
} from "./gamification.constants";
import { isRateLimited } from "./rate-limit";

// ---------- Schedule spaced repetition after failed attempt ----------
export const scheduleSpacedRepetition = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        exerciseId: z.string().uuid(),
        subjectId: z.string().uuid(),
        attemptId: z.string().uuid(),
        scorePct: z.number(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (data.scorePct >= PASS_THRESHOLD_PCT) {
      return {
        scheduled: false,
        reason: `Score >= ${PASS_THRESHOLD_PCT}%, no need for spaced repetition`,
      };
    }

    // Check if pending schedules already exist for this exercise
    const { data: existing } = await supabase
      .from("spaced_repetition_schedule")
      .select("id")
      .eq("user_id", userId)
      .eq("exercise_id", data.exerciseId)
      .eq("status", "pending")
      .limit(1);

    if (existing && existing.length > 0) {
      return { scheduled: false, reason: "Exercise already scheduled for retry" };
    }

    const now = new Date();

    for (const [i, intervalMs] of SPACED_REPETITION_INTERVALS_MS.entries()) {
      const scheduledFor = new Date(now.getTime() + intervalMs).toISOString();

      const { error } = await supabase.from("spaced_repetition_schedule").insert({
        user_id: userId,
        exercise_id: data.exerciseId,
        subject_id: data.subjectId,
        failed_attempt_id: data.attemptId,
        retry_level: i + 1,
        scheduled_for: scheduledFor,
        status: "pending",
      });

      if (error && error.code !== "23505") {
        throw new Error(error.message);
      }
    }

    return { scheduled: true, levels: SPACED_REPETITION_INTERVALS_MS.length };
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
        subjects(name_fr,color_token)`,
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

    const { data: objectivesData, error: fetchError } = await supabase
      .from("daily_objectives")
      .select(
        "id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at",
      )
      .eq("user_id", userId)
      .eq("objective_date", todayStr);

    if (fetchError) throw new Error(fetchError.message);

    let objectives = objectivesData;

    // If no objectives for today, auto-create them
    if (!objectives || objectives.length === 0) {
      for (const obj of DEFAULT_DAILY_OBJECTIVES) {
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
      const { data: newObjs, error: refetchErr } = await supabase
        .from("daily_objectives")
        .select(
          "id,objective_type,target_value,current_value,xp_reward,coin_reward,status,completed_at",
        )
        .eq("user_id", userId)
        .eq("objective_date", todayStr);

      if (refetchErr) throw new Error(refetchErr.message);
      objectives = newObjs;
    }

    return objectives ?? [];
  });

// ---------- Update daily objective progress ----------
export const updateDailyObjectiveProgress = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        objectiveType: z.enum(["10_min", "15_min", "3_exercises"]),
        incrementValue: z.number().int().min(1).max(5),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `daily_objective_${userId}`, 20, 60_000)) {
      throw new Error("Too many objective updates. Please slow down.");
    }

    if (data.objectiveType === "3_exercises" && data.incrementValue !== 1) {
      throw new Error("Invalid increment for exercise objective.");
    }

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

    const { data: questsData, error: fetchError } = await supabase
      .from("weekly_quests")
      .select(
        "id,quest_type,subject_id,target_value,current_value,xp_reward,coin_reward,status,completed_at",
      )
      .eq("user_id", userId)
      .eq("week_start_date", mondayStr);

    if (fetchError) throw new Error(fetchError.message);

    let quests = questsData;

    // If no quests for this week, auto-create them
    if (!quests || quests.length === 0) {
      for (const q of DEFAULT_WEEKLY_QUESTS) {
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
      const { data: newQuests, error: refetchErr } = await supabase
        .from("weekly_quests")
        .select(
          "id,quest_type,subject_id,target_value,current_value,xp_reward,coin_reward,status,completed_at",
        )
        .eq("user_id", userId)
        .eq("week_start_date", mondayStr);

      if (refetchErr) throw new Error(refetchErr.message);
      quests = newQuests;
    }

    return quests ?? [];
  });

// ---------- Update weekly quest progress ----------
export const updateWeeklyQuestProgress = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        questType: z.enum(["maintain_streak_5", "beat_2_bosses"]),
        incrementValue: z.literal(1),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `weekly_quest_${userId}`, 20, 60_000)) {
      throw new Error("Too many quest updates. Please slow down.");
    }

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
    z
      .object({
        subjectId: z.string().uuid(),
        newScore: z.number().min(0).max(100),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: adaptationData, error: fetchErr } = await supabase
      .from("difficulty_adaptation")
      .select("*")
      .eq("user_id", userId)
      .eq("subject_id", data.subjectId)
      .maybeSingle();

    if (fetchErr) throw new Error(fetchErr.message);

    let adaptation = adaptationData;

    if (!adaptation) {
      const { data: newAdapt, error: createErr } = await supabase
        .from("difficulty_adaptation")
        .insert({
          user_id: userId,
          subject_id: data.subjectId,
          avg_score: data.newScore,
          recent_avg_score: data.newScore,
          total_attempts: 1,
          current_difficulty_level: MIN_DIFFICULTY_LEVEL,
        })
        .select()
        .single();

      if (createErr) throw new Error(createErr.message);
      adaptation = newAdapt;
    } else {
      const totalAttempts = adaptation.total_attempts + 1;

      // Recalculate average from last N attempts
      const { data: recentAttempts } = await supabase
        .from("attempts")
        .select("score_pct")
        .eq("user_id", userId)
        .eq("subject_id", data.subjectId)
        .order("completed_at", { ascending: false })
        .limit(RECENT_ATTEMPTS_WINDOW);

      const recentScores = [
        data.newScore,
        ...(recentAttempts ?? []).map((a) => a.score_pct as number),
      ];
      const windowSize = Math.min(recentScores.length, RECENT_ATTEMPTS_WINDOW);
      const recentAvg = Math.round(
        recentScores.slice(0, windowSize).reduce((a, b) => a + b, 0) / windowSize,
      );

      const overallAvg = Math.round(
        (adaptation.avg_score * adaptation.total_attempts + data.newScore) / totalAttempts,
      );

      let newDifficulty = adaptation.current_difficulty_level;

      if (recentAvg > DIFFICULTY_INCREASE_THRESHOLD && newDifficulty < MAX_DIFFICULTY_LEVEL) {
        newDifficulty = newDifficulty + 1;
      } else if (
        recentAvg < DIFFICULTY_DECREASE_THRESHOLD &&
        newDifficulty > MIN_DIFFICULTY_LEVEL
      ) {
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

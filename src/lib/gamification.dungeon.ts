import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { isRateLimited } from "./rate-limit";

/** Dungeon constants */
export const DUNGEON_XP_PER_FLOOR = 15;
export const DUNGEON_COINS_PER_5_FLOORS = 5;
export const DUNGEON_DIFFICULTY_STEP = 5; // Every N floors, difficulty increases

/**
 * Fetch a batch of random questions for the dungeon, with difficulty scaling.
 * Returns questions from all subjects, ordered randomly, filtered by difficulty.
 */
export const getDungeonQuestions = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      floor: z.number().min(1).max(9999),
      batchSize: z.number().min(1).max(20).default(5),
      excludeIds: z.array(z.string().uuid()).max(500).default([]),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 10 requests per 10 seconds per user
    if (isRateLimited(`dungeon_q_${userId}`, 10, 10_000)) {
      throw new Error("Too many requests. Please slow down.");
    }

    // Difficulty ramps: floors 1-5 → diff 1, 6-10 → diff 1-2, 11-15 → diff 1-3, 16+ → all
    const maxDifficulty = Math.min(3, Math.ceil(data.floor / DUNGEON_DIFFICULTY_STEP));

    // Fetch exercises matching the difficulty range (all subjects mixed)
    let query = supabase
      .from("questions")
      .select("id, prompt, options, explanation, correct_option, exercise_id, exercises!inner(difficulty, subject_id, subjects!inner(name_fr, color_token, icon))")
      .lte("exercises.difficulty", maxDifficulty)
      .limit(data.batchSize * 3); // fetch extra for random pick

    // Exclude already-seen questions
    if (data.excludeIds.length > 0) {
      query = query.not("id", "in", `(${data.excludeIds.map((id) => `"${id}"`).join(",")})`);
    }

    const { data: questions, error } = await query;
    if (error) throw new Error(error.message);

    if (!questions || questions.length === 0) {
      // If we ran out of unique questions, reset exclusion and fetch again
      const { data: fallback, error: fbErr } = await supabase
        .from("questions")
        .select("id, prompt, options, explanation, correct_option, exercise_id, exercises!inner(difficulty, subject_id, subjects!inner(name_fr, color_token, icon))")
        .lte("exercises.difficulty", maxDifficulty)
        .limit(data.batchSize * 3);
      if (fbErr) throw new Error(fbErr.message);
      // Shuffle and take batchSize
      const shuffled = (fallback ?? []).sort(() => Math.random() - 0.5);
      return { questions: shuffled.slice(0, data.batchSize), resetExclusions: true };
    }

    // Shuffle and pick batchSize
    const shuffled = questions.sort(() => Math.random() - 0.5);
    return { questions: shuffled.slice(0, data.batchSize), resetExclusions: false };
  });

/**
 * Submit the final dungeon run result — awards XP and coins based on floors cleared.
 */
export const submitDungeonRun = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({
      floorsCleared: z.number().min(0).max(99999),
      totalCorrect: z.number().min(0),
      totalAnswered: z.number().min(0),
      durationSeconds: z.number().min(0),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Rate limit: max 3 run submissions per 30 seconds
    if (isRateLimited(`dungeon_run_${userId}`, 3, 30_000)) {
      throw new Error("Too many submissions. Please wait.");
    }

    const xpEarned = data.floorsCleared * DUNGEON_XP_PER_FLOOR;
    const coinsEarned = Math.floor(data.floorsCleared / 5) * DUNGEON_COINS_PER_5_FLOORS;

    // Award XP
    if (xpEarned > 0) {
      const { error: rpcErr } = await supabase.rpc("award_xp", { p_user: userId, p_xp: xpEarned });
      if (rpcErr) throw new Error(rpcErr.message);
    }

    // Award coins atomically
    if (coinsEarned > 0) {
      const { error: coinErr } = await supabase.rpc("award_coins", { p_user: userId, p_coins: coinsEarned });
      if (coinErr) throw new Error(coinErr.message);
    }

    return { xpEarned, coinsEarned, floorsCleared: data.floorsCleared };
  });

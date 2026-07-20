import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { STREAK_RECOVERY_COST } from "@/shared/constants/gamification";
import { getTodayUtc, getYesterdayUtc } from "@/shared/lib/dates";
import { failWithClientError } from "@/shared/lib/safe-error";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { logger } from "@/shared/lib/logger";
import type { CompetencyExercise } from "@/shared/types/competency";

/**
 * `get_exercises_for_competency` (étude 07 lot 4) est postérieure aux types Supabase générés,
 * qui ne peuvent être régénérés sans accès DB : on fige son contrat ici (même patron que les
 * RPC de `dashboard.server.ts`). L'accès est arbitré côté SQL par `resolve_exercise_access`.
 */
type CompetencyExercisesRpcClient = {
  rpc: (
    fn: "get_exercises_for_competency",
    args: { p_competency: string },
  ) => PromiseLike<{ data: CompetencyExercise[] | null; error: { message: string } | null }>;
};

// ---------- Streak Recovery (buy back streak with coins) ----------
export const recoverStreak = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `streak_recover_${userId}`, 3, 60_000)) {
      throw new Error("Trop de tentatives. Réessaie dans une minute.");
    }

    const { data: profile, error: profileErr } = await supabase
      .from("profiles")
      .select("id,yahia_coins,current_streak,longest_streak,last_active_date")
      .eq("id", userId)
      .single();

    if (profileErr) {
      failWithClientError("recoverStreak: failed to load profile", profileErr, profileErr.message);
    }

    // A streak counted today or yesterday is still alive — nothing to recover yet.
    // award_xp only resets current_streak to 1 on the NEXT study after a missed day,
    // so the reachable signal of a broken streak is a stale last_active_date, NOT
    // current_streak === 0 (which award_xp never persists — that was the dead gate).
    const lastActive = profile.last_active_date;
    if (lastActive != null && lastActive >= getYesterdayUtc()) {
      throw new Error("Ton streak est actif ! Pas besoin de le récupérer.");
    }

    if ((profile.longest_streak ?? 0) === 0) {
      throw new Error("Tu n'as pas encore eu de streak à récupérer.");
    }

    if ((profile.yahia_coins ?? 0) < STREAK_RECOVERY_COST) {
      throw new Error(`Il te faut ${STREAK_RECOVERY_COST} Coins pour récupérer ton streak.`);
    }

    // Spend coins
    const { error: spendErr } = await supabase.rpc("spend_coins", {
      p_user: userId,
      p_coins: STREAK_RECOVERY_COST,
    });
    if (spendErr) {
      failWithClientError("recoverStreak: failed to spend coins", spendErr, spendErr.message);
    }

    // Restore the streak to its pre-break value (still held in current_streak until
    // the next award_xp would reset it), floored at 1, and mark today active so it
    // holds — the player keeps the streak they paid to save instead of dropping to 1.
    const restoredStreak = Math.max(profile.current_streak ?? 0, 1);
    const { error: updateErr } = await supabase
      .from("profiles")
      .update({
        current_streak: restoredStreak,
        last_active_date: getTodayUtc(),
      })
      .eq("id", userId);

    if (updateErr) {
      failWithClientError("recoverStreak: failed to update streak", updateErr, updateErr.message);
    }

    return {
      success: true,
      newStreak: restoredStreak,
      coinsSpent: STREAK_RECOVERY_COST,
      remainingCoins: (profile.yahia_coins ?? 0) - STREAK_RECOVERY_COST,
    };
  });

// ---------- « S'entraîner » sur une compétence faible (étude 07 lot 4, US-2) ----------
// Les exercices EXISTANTS qui évaluent la compétence, déjà filtrés par la porte d'accès (R-3)
// côté SQL. On-demand : le panneau l'appelle quand l'élève clique « S'entraîner », puis route
// vers le premier exercice rendu. Dégradation gracieuse : une RPC absente rend une liste vide
// (le bouton ne mène nulle part) plutôt que de casser la page.
export const getCompetencyExercises = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ competency: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }): Promise<CompetencyExercise[]> => {
    const client = context.supabase as unknown as CompetencyExercisesRpcClient;
    const res = await client.rpc("get_exercises_for_competency", { p_competency: data.competency });
    if (res.error) {
      logger.warn("getCompetencyExercises: RPC failed, defaulting to empty", {
        error: res.error.message,
      });
      return [];
    }
    return res.data ?? [];
  });

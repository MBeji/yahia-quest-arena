import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { STREAK_RECOVERY_COST } from "@/shared/constants/gamification";
import { getTodayUtc, getYesterdayUtc } from "@/shared/lib/dates";
import { failWithClientError } from "@/shared/lib/safe-error";
import { isRateLimited } from "@/shared/lib/rate-limit";

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

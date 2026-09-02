import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { STREAK_RECOVERY_COST } from "@/shared/constants/gamification";
import { getTodayUtc } from "@/shared/lib/dates";
import { streakRecoveryBlock } from "@/shared/lib/streak-recovery";
import { failWithClientError } from "@/shared/lib/safe-error";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { logger } from "@/shared/lib/logger";
import type {
  CompetencyExercise,
  LearningFrontierRow,
  LearningStateRow,
} from "@/shared/types/competency";

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

    // La condition vit dans `streak-recovery.ts` et NULLE PART ailleurs : le
    // client la lit aussi, et c'est leur divergence qui avait muré ce chemin.
    // Les messages, eux, restent ici — le serveur seul parle à l'élève.
    switch (streakRecoveryBlock(profile)) {
      case "streak-actif":
        throw new Error("Ton streak est actif ! Pas besoin de le récupérer.");
      case "aucun-streak":
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

// ---------- Tuteur déterministe : les lectures de croyance (étude 30 lot 3) ----------
/**
 * Les trois RPC du lot 3 sont, elles aussi, postérieures aux types Supabase générés (qui ne
 * peuvent être régénérés sans accès DB) : on fige leurs contrats ici, même patron que la
 * voisine ci-dessus. Le périmètre est `auth.uid()` EN DUR côté SQL — aucune de ces fonctions
 * ne prend d'identifiant d'élève, et le test pgTAP le prouve par leur signature (R-6).
 */
type LearningRpcClient = {
  rpc: ((
    fn: "get_learning_state",
    args: { p_family: string | null },
  ) => PromiseLike<{ data: LearningStateRow[] | null; error: { message: string } | null }>) &
    ((
      fn: "get_learning_frontier",
      args: { p_family: string | null; p_limit: number },
    ) => PromiseLike<{ data: LearningFrontierRow[] | null; error: { message: string } | null }>) &
    ((
      fn: "dispute_inference",
      args: { p_competency: string },
    ) => PromiseLike<{
      data: { competency_id: string; p_known: number; state: string }[] | null;
      error: { message: string } | null;
    }>);
};

/**
 * « Où tu en es » — l'état et la zone de chaque compétence de la famille (§3.10).
 *
 * Dégradation gracieuse, comme sa voisine : une RPC absente rend une liste vide, donc un
 * panneau qui ne s'affiche pas, plutôt qu'une page cassée. Sur une matière NON TAGGÉE le
 * résultat est vide aussi — et c'est R-6 qui parle, pas une erreur : l'écran est alors
 * exactement celui d'aujourd'hui.
 */
export const getLearningState = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ family: z.string().min(1).nullable().default(null) }).parse(d))
  .handler(async ({ data, context }): Promise<LearningStateRow[]> => {
    const client = context.supabase as unknown as LearningRpcClient;
    const res = await client.rpc("get_learning_state", { p_family: data.family });
    if (res.error) {
      logger.warn("getLearningState: RPC failed, defaulting to empty", {
        error: res.error.message,
      });
      return [];
    }
    return res.data ?? [];
  });

/** « Prêt à apprendre » — la frontière, triée par fan-out, avec son exercice d'entrée (§3.4). */
export const getLearningFrontier = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        family: z.string().min(1).nullable().default(null),
        // Trois cartes, jamais une liste (é15 R-1 : un seul CTA à la fois, et une frontière
        // qui déroulerait vingt compétences serait un catalogue, pas une proposition).
        limit: z.number().int().min(1).max(10).default(3),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<LearningFrontierRow[]> => {
    const client = context.supabase as unknown as LearningRpcClient;
    const res = await client.rpc("get_learning_frontier", {
      p_family: data.family,
      p_limit: data.limit,
    });
    if (res.error) {
      logger.warn("getLearningFrontier: RPC failed, defaulting to empty", {
        error: res.error.message,
      });
      return [];
    }
    return res.data ?? [];
  });

/**
 * « Je ne suis pas d'accord » (US-3, R-10) — l'élève refuse une croyance DÉDUITE.
 *
 * Le mandat parle d'un tuteur autonome, pas d'un tuteur qui a toujours raison. Le SQL ne
 * touche qu'une ligne `belief_source = 'inference'` : contester une croyance gagnée par la
 * preuve n'a aucun effet, parce que ce serait effacer ce que l'élève a réellement fait.
 * Un `false` en retour n'est donc pas une erreur — c'est « il n'y avait rien à contester ».
 */
export const disputeInference = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ competency: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }): Promise<{ disputed: boolean }> => {
    const { userId } = context;
    // Un geste d'élève, pas une API de masse : le graphe compte 62 compétences, personne n'a
    // besoin d'en contester dix par minute.
    if (await isRateLimited(context.supabase, `dispute_inference_${userId}`, 10, 60_000)) {
      throw new Error("Trop de contestations d'affilée. Réessaie dans une minute.");
    }
    const client = context.supabase as unknown as LearningRpcClient;
    const res = await client.rpc("dispute_inference", { p_competency: data.competency });
    if (res.error) {
      logger.warn("disputeInference: RPC failed", { error: res.error.message });
      return { disputed: false };
    }
    const disputed = (res.data ?? []).length > 0;
    logger.info("belief.disputed", { competency: data.competency, disputed });
    return { disputed };
  });

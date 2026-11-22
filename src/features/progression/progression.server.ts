import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { STREAK_RECOVERY_COST, STREAK_RECOVERY_WINDOW_DAYS } from "@/shared/constants/gamification";
import { getTodayUtc } from "@/shared/lib/dates";
import { streakRecoveryBlock } from "@/shared/lib/streak-recovery";
import { failWithClientError } from "@/shared/lib/safe-error";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { logger } from "@/shared/lib/logger";
import {
  competencyExerciseSchema,
  learningFrontierRowSchema,
  parseRpcRows,
} from "@/shared/integrations/supabase/rpc-rows";
import type { CompetencyExercise, LearningFrontierRow } from "@/shared/types/competency";
import type { StudyReport } from "@/shared/lib/study-report";
import { parseStudyReport } from "@/shared/lib/study-report.schema";

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
      case "fenetre-expiree":
        // Un fait, pas un reproche (R-8) : la fenêtre est passée, le palmarès reste,
        // et la phrase suivante est déjà tournée vers aujourd'hui.
        throw new Error(
          `La fenêtre de rachat est passée (${STREAK_RECOVERY_WINDOW_DAYS} jours). ` +
            "Ta plus longue série reste à ton palmarès — la prochaine repart aujourd'hui.",
        );
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
  .validator((d) => z.object({ competency: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }): Promise<CompetencyExercise[]> => {
    const res = await context.supabase.rpc("get_exercises_for_competency", {
      p_competency: data.competency,
    });
    if (res.error) {
      logger.warn("getCompetencyExercises: RPC failed, defaulting to empty", {
        error: res.error.message,
      });
      return [];
    }
    return parseRpcRows(competencyExerciseSchema, res.data, "getCompetencyExercises");
  });

// ---------- Tuteur déterministe : les lectures de croyance (étude 30 lot 3) ----------
// « Où tu en es » (§3.10) n'est plus une server fn : `getDashboard` lit l'état une fois
// (`readLearningState`, `@/shared/lib/adaptive-inputs`) et le passe à `LearningPanels` en prop.

/** « Prêt à apprendre » — la frontière, triée par fan-out, avec son exercice d'entrée (§3.4). */
export const getLearningFrontier = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d) =>
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
    const res = await context.supabase.rpc("get_learning_frontier", {
      // `p_family TEXT DEFAULT NULL` : omettre l'argument EST « toutes les familles ».
      p_family: data.family ?? undefined,
      p_limit: data.limit,
    });
    if (res.error) {
      logger.warn("getLearningFrontier: RPC failed, defaulting to empty", {
        error: res.error.message,
      });
      return [];
    }
    return parseRpcRows(learningFrontierRowSchema, res.data, "getLearningFrontier");
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
  .validator((d) => z.object({ competency: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }): Promise<{ disputed: boolean }> => {
    const { userId } = context;
    // Un geste d'élève, pas une API de masse : le graphe compte 62 compétences, personne n'a
    // besoin d'en contester dix par minute.
    if (await isRateLimited(context.supabase, `dispute_inference_${userId}`, 10, 60_000)) {
      throw new Error("Trop de contestations d'affilée. Réessaie dans une minute.");
    }
    const res = await context.supabase.rpc("dispute_inference", { p_competency: data.competency });
    if (res.error) {
      logger.warn("disputeInference: RPC failed", { error: res.error.message });
      return { disputed: false };
    }
    const disputed = (res.data ?? []).length > 0;
    logger.info("belief.disputed", { competency: data.competency, disputed });
    return { disputed };
  });

// ---------------------------------------------------------------------------
// BILAN ET PROGRAMME DU JOUR (commande du 2026-11-22).
// ---------------------------------------------------------------------------
// La lecture complète de l'écran « Mon bilan » : niveau par matière, état de chaque chapitre,
// programme du jour. Tout est tranché par `get_study_report` — cette fonction ne fait que
// valider la forme. `null` sur panne comme sur forme inattendue : l'écran dit que le bilan
// n'est pas disponible, il n'en affiche jamais la moitié.
export const getStudyReport = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<StudyReport | null> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("get_study_report");
    if (error) {
      logger.warn("progression.studyReport", { error: error.message });
      return null;
    }
    const report = parseStudyReport(data);
    if (!report) logger.warn("progression.studyReport: unexpected shape");
    return report;
  });

// L'élève déclare les chapitres VUS EN CLASSE d'une matière. La liste remplace la déclaration
// (un appel par geste, idempotent) ; la base refuse un chapitre d'une autre matière.
export const setClassChapters = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
    z
      .object({
        subjectId: z.string().min(1).max(120),
        chapterIds: z.array(z.guid()).max(200),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<{ count: number }> => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `class_chapters_${userId}`, 30, 60_000)) {
      throw new Error("Trop de modifications. Réessaie dans une minute.");
    }

    const { data: count, error } = await supabase.rpc("set_class_chapters", {
      p_subject_id: data.subjectId,
      p_chapter_ids: data.chapterIds,
    });
    if (error) {
      failWithClientError(
        "setClassChapters: rpc failed",
        error,
        "Enregistrement impossible. Réessaie.",
      );
    }
    return { count: count ?? 0 };
  });

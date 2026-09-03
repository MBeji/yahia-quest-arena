import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import { getTodayUtc } from "@/shared/lib/dates";

/**
 * Étude 31 lot 3 — L'OBJECTIF DU JOUR, choisi par l'élève (US-2, R-12).
 *
 * L'anneau du tableau de bord affichait une progression fausse — la somme des
 * `xp_reward` des objectifs COMPLÉTÉS, sur 100 en dur : 0 % ou 50 %, jamais
 * l'XP réel. La moitié serveur du correctif est le compteur tenu par `award_xp`
 * (`daily_xp_base`) ; celle-ci est l'autre moitié : le DÉNOMINATEUR cesse d'être
 * une constante et devient un choix.
 *
 * **Une fois par jour** (R-12) : un objectif qu'on remonte quand il est atteint
 * et qu'on baisse quand il fait peur ne veut plus rien dire. La garde vit en SQL
 * (`set_daily_xp_goal`), pas ici — le client ne fait que rendre le refus lisible.
 */

/** Les trois valeurs de R-12 ; 100 est le défaut hérité de é22 R-28. */
export const DAILY_XP_GOALS = [50, 100, 200] as const;

const SAVE_ERROR_FR = "Impossible d'enregistrer ton objectif du jour.";
const LOAD_ERROR_FR = "Impossible de charger ton objectif du jour.";

/** Le refus « déjà changé aujourd'hui » remonte par ce code, pas par un message. */
export const DAILY_GOAL_ALREADY_SET = "DAILY_GOAL_ALREADY_SET_TODAY";

/**
 * `set_daily_xp_goal` est postérieure aux types Supabase générés (qui ne peuvent
 * pas être régénérés sans accès DB) : contrat figé ici, même patron que
 * `economy.server.ts`. À supprimer à la prochaine régénération.
 */
type DailyGoalRpcClient = {
  rpc: (
    fn: "set_daily_xp_goal",
    args: { p_goal: number },
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

export const setDailyXpGoal = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator(z.object({ goal: z.union([z.literal(50), z.literal(100), z.literal(200)]) }))
  .handler(async ({ context, data }): Promise<{ goal: number }> => {
    const client = context.supabase as unknown as DailyGoalRpcClient;
    const { error } = await client.rpc("set_daily_xp_goal", { p_goal: data.goal });

    if (error) {
      // Le refus du jour n'est pas une panne : il remonte tel quel pour que
      // l'écran dise « demain », au lieu de « quelque chose s'est mal passé ».
      if (error.message.includes(DAILY_GOAL_ALREADY_SET)) {
        throw new Error(DAILY_GOAL_ALREADY_SET);
      }
      failWithClientError("dashboard.setDailyXpGoal", error, SAVE_ERROR_FR);
    }
    return { goal: data.goal };
  });

/**
 * Les quatre colonnes du lot 3 sont postérieures aux types générés : contrat
 * étroit, à supprimer à la prochaine régénération (même patron que le catalogue
 * de badges).
 */
type DailyRingClient = {
  from: (table: "profiles") => {
    select: (columns: string) => {
      eq: (
        column: string,
        value: string,
      ) => {
        maybeSingle: () => PromiseLike<{
          data: {
            xp: number;
            daily_xp_day: string | null;
            daily_xp_base: number | null;
            daily_xp_goal: number;
            daily_xp_goal_set_on: string | null;
          } | null;
          error: { message: string } | null;
        }>;
      };
    };
  };
};

/**
 * é31 lot 3 (R-12) — L'ANNEAU DU JOUR, honnête.
 *
 * Avant : la progression était la somme des `xp_reward` des objectifs COMPLÉTÉS,
 * sur 100 en dur — donc 0 % ou 50 %, jamais l'XP réel. Ici l'XP du jour vient du
 * compteur tenu par `award_xp` (l'unique frappe : quête, donjon, duel, objectifs
 * y passent tous), et le dénominateur est l'objectif CHOISI par l'élève.
 */
export const getDailyRing = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ xpToday: number; goal: number; canChange: boolean }> => {
    const { supabase, userId } = context;
    const today = getTodayUtc();

    const { data, error } = await (supabase as unknown as DailyRingClient)
      .from("profiles")
      .select("xp,daily_xp_day,daily_xp_base,daily_xp_goal,daily_xp_goal_set_on")
      .eq("id", userId)
      .maybeSingle();
    if (error) failWithClientError("getDailyRing", error, LOAD_ERROR_FR);

    const row = data ?? null;
    // Un compteur d'hier ne vaut rien aujourd'hui : le jour a changé, l'XP du
    // jour repart de zéro même si `award_xp` n'a pas encore été rappelée.
    const xpToday =
      row && row.daily_xp_day === today ? Math.max(0, row.xp - (row.daily_xp_base ?? 0)) : 0;

    return {
      xpToday,
      goal: row?.daily_xp_goal ?? 100,
      canChange: (row?.daily_xp_goal_set_on ?? null) !== today,
    };
  });

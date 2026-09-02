import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";

/**
 * Étude 31 lot 1 — la boucle de mesure du RETOUR (US-13, KPI-A…KPI-E).
 *
 * STATUS §1bis porte depuis le 2026-07-19 la ligne « rétention **jamais
 * publiée** ». Ce n'est pas un oubli d'écran : rien ne la calculait. PostHog ne
 * le peut pas (profils de personne désactivés — décision de protection des
 * mineurs, D-1), et aucune vue Postgres ne la produisait. Cette lecture est la
 * réponse : un seul RPC, un seul JSON, une section par KPI.
 *
 * **R-1 : la métrique de garde voyage avec les autres.** La section `learning`
 * (précision, chapitres complétés par actif) n'est pas optionnelle — elle est la
 * condition pour que les chiffres d'engagement aient le droit d'être lus. Un
 * engagement qui monte pendant que la précision baisse est un échec, et il doit
 * se voir sur le MÊME écran.
 *
 * **Read-only, comme `/admin/economie`** : aucune server fn de mutation en face.
 * Un instrument qui sait aussi agir devient un levier (é09 R-1).
 *
 * **Une seule porte** : `admin_engagement_overview()` est SECURITY DEFINER et
 * gardée par `is_admin()`. Les vues `eng_*` sont REVOKE de anon/authenticated —
 * la volumétrie du parc n'est pas un chiffre d'élève.
 */

const LOAD_ERROR_FR = "Impossible de charger les indicateurs d'engagement.";

/**
 * `admin_engagement_overview` est postérieure aux types Supabase générés, qui ne
 * peuvent pas être régénérés sans accès DB : son contrat est figé ici, même
 * patron que `economy.server.ts`. À supprimer à la prochaine régénération.
 */
type EngagementOverviewRpcClient = {
  rpc: (fn: "admin_engagement_overview") => PromiseLike<{
    data: unknown;
    error: { message: string } | null;
  }>;
};

/** Au-delà, la console mérite un instantané journalier plutôt qu'un calcul à la volée. */
const SLOW_RPC_MS = 2000;

/** KPI-A — une semaine ISO et son retour en semaine suivante. */
const currWeekSchema = z.object({
  week_start: z.string(),
  active: z.coerce.number(),
  returned: z.coerce.number(),
  /** NULL quand la semaine n'a eu aucun actif : 0 % serait un chiffre faux. */
  curr_pct: z.coerce.number().nullable(),
});

/**
 * KPI-B — une cohorte d'inscription hebdomadaire.
 *
 * `*_base` est la part de la cohorte dont la fenêtre est ENTIÈREMENT écoulée :
 * un compte de la semaine dernière n'a pas encore pu « rater » son J+30. Le
 * pourcentage est donc NULL tant que la base est vide — « pas encore mesurable »
 * et « personne n'est revenu » ne se confondent pas.
 */
const cohortSchema = z.object({
  cohort_week: z.string(),
  size: z.coerce.number(),
  d1_base: z.coerce.number(),
  d1_back: z.coerce.number(),
  d1_pct: z.coerce.number().nullable(),
  d7_base: z.coerce.number(),
  d7_back: z.coerce.number(),
  d7_pct: z.coerce.number().nullable(),
  d30_base: z.coerce.number(),
  d30_back: z.coerce.number(),
  d30_pct: z.coerce.number().nullable(),
});

const activitySchema = z.object({
  dau: z.coerce.number(),
  wau: z.coerce.number(),
  mau: z.coerce.number(),
  daily: z.array(z.object({ day: z.string(), actives: z.coerce.number() })),
});

/**
 * KPI-C — la série EFFECTIVE, pas la colonne brute. `profiles.current_streak`
 * n'est réécrite que par `award_xp` : un élève parti depuis dix jours y porte
 * encore « 12 ». Le serveur la remet à zéro dès que `last_active_date` a plus
 * d'un jour — sinon la distribution publierait des séries de fantômes.
 */
const streaksSchema = z.object({
  students: z.coerce.number(),
  b0: z.coerce.number(),
  b1_6: z.coerce.number(),
  b7_29: z.coerce.number(),
  b30_plus: z.coerce.number(),
  weekly_active: z.coerce.number(),
  weekly_active_7plus: z.coerce.number(),
});

/** KPI-D — opt-in ET opt-out (garde-fou R-4 : opt-out mensuel < 5 %). */
const pushSchema = z.object({
  optin_students: z.coerce.number(),
  subscriptions: z.coerce.number(),
  optin_30d: z.coerce.number(),
  optout_30d: z.coerce.number(),
  students_total: z.coerce.number(),
  optout_pct: z.coerce.number().nullable(),
});

/** KPI-E — la métrique de garde (R-1) : ce que l'engagement ne doit pas coûter. */
const learningSchema = z.object({
  active_30d: z.coerce.number(),
  accuracy_avg_pct: z.coerce.number().nullable(),
  accuracy_p50_pct: z.coerce.number().nullable(),
  attempts_30d: z.coerce.number(),
  chapters_completed: z.coerce.number(),
  chapters_per_active: z.coerce.number().nullable(),
});

const overviewSchema = z.object({
  curr: z.array(currWeekSchema),
  cohorts: z.array(cohortSchema),
  activity: activitySchema,
  streaks: streaksSchema,
  push: pushSchema,
  learning: learningSchema,
  notes: z.object({
    generated_at: z.string(),
    week_timezone: z.string(),
    streak_clock: z.string(),
    retention_rule: z.string(),
    activity_rule: z.string(),
    current_week: z.string(),
  }),
});

export type EngagementOverview = z.infer<typeof overviewSchema>;
export type EngagementCohort = z.infer<typeof cohortSchema>;
export type EngagementCurrWeek = z.infer<typeof currWeekSchema>;

export const getEngagementOverview = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<EngagementOverview> => {
    const { supabase } = context;
    const startedAt = Date.now();

    const client = supabase as unknown as EngagementOverviewRpcClient;
    const { data, error } = await client.rpc("admin_engagement_overview");
    if (error) failWithClientError("engagement.overview", error, LOAD_ERROR_FR);

    const elapsedMs = Date.now() - startedAt;
    if (elapsedMs > SLOW_RPC_MS) {
      logger.warn("engagement.overview: RPC lent — un instantané journalier devient utile", {
        elapsedMs,
        thresholdMs: SLOW_RPC_MS,
      });
    }

    const parsed = overviewSchema.safeParse(data);
    if (!parsed.success) {
      // Une forme inattendue est une PANNE DE LECTURE, pas une page à moitié
      // remplie : sur un tableau de bord, un chiffre partiel se décide dessus.
      failWithClientError("engagement.overview", parsed.error, LOAD_ERROR_FR);
    }
    return parsed.data;
  });

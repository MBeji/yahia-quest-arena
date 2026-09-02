import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * « Ta semaine » (étude 31 lot 5 — US-8, R-18).
 *
 * Le cycle de la semaine se terminait sans rien dire : la ligue virait ses pièces
 * le lundi à 02:30 par cron, et l'élève ne l'apprenait qu'en revenant de
 * lui-même. Cette carte est la fin de cycle qui manquait — les FAITS de la
 * semaine, comparés à la précédente.
 *
 * **Déterministe, et sans récompense** (R-18) : aucune clé d'IA n'est requise, et
 * lire son bilan ne rapporte ni XP ni pièces. Un bilan qui paye devient une
 * tâche, et le lire cesse d'être un choix (é11 R-11). Quand le pilote é29 aura
 * tourné, la prose d'El Ostedh pourra ENRICHIR cette carte — jamais la
 * conditionner (D-7).
 */

const LOAD_ERROR_FR = "Impossible de charger le bilan de ta semaine.";

const weekFactsSchema = z.object({
  xp: z.coerce.number(),
  missions: z.coerce.number(),
  avgScore: z.coerce.number(),
  daysActive: z.coerce.number(),
});

const recapSchema = z.object({
  weekStart: z.string(),
  /** Une semaine sans mission n'a pas de bilan à montrer — et ne dit pas « tu n'as rien fait ». */
  hasActivity: z.boolean(),
  thisWeek: weekFactsSchema,
  lastWeek: weekFactsSchema,
  delta: z.object({
    xp: z.coerce.number(),
    missions: z.coerce.number(),
    /** NULL = pas comparable (une des deux semaines est vide), jamais 0 par défaut. */
    avgScore: z.coerce.number().nullable(),
    daysActive: z.coerce.number(),
  }),
  streak: z.coerce.number(),
  badges: z.array(z.string()),
  league: z
    .object({
      tier: z.string(),
      rank: z.coerce.number(),
      coins: z.coerce.number(),
      week_start: z.string(),
    })
    .nullable(),
});

export type WeeklyRecap = z.infer<typeof recapSchema>;

/** `get_weekly_recap` est postérieure aux types générés — contrat étroit, comme ses voisines. */
type WeeklyRecapClient = {
  rpc: (
    fn: "get_weekly_recap",
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

export const getWeeklyRecap = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<WeeklyRecap> => {
    const client = context.supabase as unknown as WeeklyRecapClient;
    const { data, error } = await client.rpc("get_weekly_recap");
    if (error) failWithClientError("dashboard.getWeeklyRecap", error, LOAD_ERROR_FR);

    const parsed = recapSchema.safeParse(data);
    if (!parsed.success)
      failWithClientError("dashboard.getWeeklyRecap", parsed.error, LOAD_ERROR_FR);
    return parsed.data;
  });

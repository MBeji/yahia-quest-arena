import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import { logger } from "@/shared/lib/logger";

/**
 * Étude 09 lot 1 — la boucle de mesure de l'économie (US-1…US-4).
 *
 * L'économie est centralisée et son design n'est pas en cause ; ce qui manquait,
 * c'est de savoir ce qu'elle produit **en vrai**. Cette lecture répond aux quatre
 * questions sans requête manuelle : à quelle vitesse on monte, si les coins
 * s'accumulent sans puits, si les consommables servent, et où en est le funnel.
 *
 * **R-1 : read-only.** Il n'existe volontairement aucune server fn de mutation en
 * face. Un instrument de mesure qui sait aussi agir devient un levier, et un levier
 * se tire sans réfléchir — c'est exactement ce que RISK-2 (sur-tuning) redoute.
 *
 * **D-2 : une seule porte.** Les vues `econ_*` sont REVOKE de anon/authenticated ;
 * seul `admin_economy_overview()` (SECURITY DEFINER, garde `is_admin()`) les lit.
 * Le contrôle est donc **serveur**, pas le `isAdmin` de la route — celui-ci ne fait
 * qu'éviter d'afficher un écran vide à un non-admin.
 *
 * **D-5 / observabilité** : la durée d'exécution est journalisée. Au-delà de 2 s en
 * prod réelle, c'est le déclencheur du lot 3 (snapshot journalier) — écrit ici pour
 * que le seuil soit observé plutôt que deviné.
 */

const LOAD_ERROR_FR = "Impossible de charger les indicateurs économiques.";

/**
 * `admin_economy_overview` est postérieure aux types Supabase générés, qui ne
 * peuvent pas être régénérés sans accès DB : on fige son contrat ici, même patron
 * que les RPC de `progression.server.ts` et `dashboard.server.ts`. À supprimer à la
 * prochaine régénération des types.
 */
type EconomyOverviewRpcClient = {
  rpc: (fn: "admin_economy_overview") => PromiseLike<{
    data: unknown;
    error: { message: string } | null;
  }>;
};

/** Seuil de déclenchement du lot 3 (é09 §3, observabilité). */
const SLOW_RPC_MS = 2000;

/** Distribution de l'XP quotidien — percentiles, jamais une moyenne seule (RISK-1). */
const xpDailySchema = z.object({
  p50: z.coerce.number().nullable(),
  p90: z.coerce.number().nullable(),
  max: z.coerce.number().nullable(),
  active_days: z.coerce.number(),
});

/** Jours réels pour atteindre un palier, par percentiles. */
const levelVelocitySchema = z.object({
  level_reached: z.coerce.number(),
  students: z.coerce.number(),
  p50_days: z.coerce.number().nullable(),
  p90_days: z.coerce.number().nullable(),
});

/**
 * Sources RECONSTRUITES (D-5) contre puits réels. `sink_ratio` est nul quand rien
 * n'a été gagné : sur une économie à l'arrêt, « 0 % d'inflation » serait un chiffre
 * faux, pas un chiffre prudent.
 */
const coinFlowsSchema = z.object({
  sources_estimated: z.coerce.number(),
  sinks_shop: z.coerce.number(),
  sink_ratio: z.coerce.number().nullable(),
});

/** Un objet acquis mais jamais consommé est un signal de design, pas un bug. */
const consumableSchema = z.object({
  code: z.string(),
  name: z.string(),
  item_type: z.string(),
  price_coins: z.coerce.number(),
  acquired: z.coerce.number(),
  still_armed: z.coerce.number(),
  consumed: z.coerce.number(),
  holders: z.coerce.number(),
});

/** Dormant en phase gratuite — et c'est dit sur la page plutôt que masqué. */
const premiumFunnelSchema = z.object({
  active_30d: z.coerce.number(),
  entitled_total: z.coerce.number(),
  active_entitled: z.coerce.number(),
  premium_parcours: z.coerce.number(),
});

const overviewSchema = z.object({
  xp_daily: xpDailySchema,
  level_velocity: z.array(levelVelocitySchema),
  coin_flows: coinFlowsSchema,
  consumables: z.array(consumableSchema),
  premium_funnel: premiumFunnelSchema,
  notes: z.object({
    coins_sources_estimated: z.boolean(),
    xp_per_level: z.coerce.number(),
  }),
});

export type EconomyOverview = z.infer<typeof overviewSchema>;

export const getEconomyOverview = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<EconomyOverview> => {
    const { supabase } = context;
    const startedAt = Date.now();

    const client = supabase as unknown as EconomyOverviewRpcClient;
    const { data, error } = await client.rpc("admin_economy_overview");
    if (error) failWithClientError("economy.overview", error, LOAD_ERROR_FR);

    const elapsedMs = Date.now() - startedAt;
    if (elapsedMs > SLOW_RPC_MS) {
      // Le déclencheur du lot 3, observé et non deviné (é09 §3).
      logger.warn("economy.overview: RPC lent — seuil du lot 3 atteint", {
        elapsedMs,
        thresholdMs: SLOW_RPC_MS,
      });
    }

    const parsed = overviewSchema.safeParse(data);
    if (!parsed.success) {
      // Une forme inattendue est une panne de lecture, pas une page à moitié
      // remplie : mieux vaut le dire que dessiner des chiffres partiels.
      failWithClientError("economy.overview", parsed.error, LOAD_ERROR_FR);
    }
    return parsed.data;
  });

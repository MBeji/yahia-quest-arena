import { createServerFn } from "@tanstack/react-start";

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * LA RÉCOMPENSE DE BIENVENUE (étude 31 lot 6 — US-9, R-19).
 *
 * Constat n° 8 : « le compte naît à ZÉRO ». Trois écrans de choix, aucune
 * question jouée, aucune récompense, et une fin qui renvoie vers un tableau de
 * bord vide. Le premier moment d'un élève était une page d'administration — alors
 * que la boucle de jeu, elle, est excellente.
 *
 * **30 pièces exactement** (Q-4, arbitrée) : le prix d'un `booster_hint`, parce
 * que la boutique s'apprend par l'usage et non par une notice. La valeur est
 * inscrite au registre économie (§3.9) — é09 la mesurera comme le reste.
 *
 * **Idempotente côté SQL**, pas ici : la garde est un `UPDATE … WHERE
 * welcome_pack_at IS NULL`, donc deux appels simultanés (double clic, rejeu du
 * réseau) ne peuvent pas gagner tous les deux.
 */

const CLAIM_ERROR_FR = "Impossible de récupérer ta récompense de bienvenue.";

type WelcomePackClient = {
  rpc: (
    fn: "claim_welcome_pack",
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

export type WelcomePack = {
  /** `true` seulement si CET appel a crédité — l'écran ne fête pas deux fois. */
  granted: boolean;
  coins: number;
  /** La première quête du parcours choisi : la fin de l'accueil est UNE action. */
  firstExerciseId: string | null;
};

export const claimWelcomePack = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<WelcomePack> => {
    const client = context.supabase as unknown as WelcomePackClient;
    const { data, error } = await client.rpc("claim_welcome_pack");
    if (error) failWithClientError("auth.claimWelcomePack", error, CLAIM_ERROR_FR);

    const row = (data ?? {}) as Record<string, unknown>;
    return {
      granted: row.granted === true,
      coins: Number(row.coins ?? 0),
      firstExerciseId: typeof row.firstExerciseId === "string" ? row.firstExerciseId : null,
    };
  });

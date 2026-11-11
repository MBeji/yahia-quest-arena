import { createServerFn } from "@tanstack/react-start";

import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * LE CALENDRIER SCOLAIRE (étude 31 lot 8 — US-12, R-21).
 *
 * Constat n° 9 : « aucun événement, aucune saison » hors la semaine ISO de la
 * ligue. Rien ne rythme l'année scolaire tunisienne — ni la rentrée, ni les
 * devoirs de synthèse, ni les révisions de mai.
 *
 * ⚠️ **R-2 en tête** : un événement borne un DÉFI et son badge, **jamais un
 * contenu**. Chaque chapitre reste jouable avant, pendant et après la fenêtre —
 * c'est la ligne qui sépare un événement d'un mur.
 */

const LOAD_ERROR_FR = "Impossible de charger l'événement en cours.";

export type ActiveEvent = {
  code: string;
  name: Record<string, string>;
  description: Record<string, string>;
  endsAt: string;
  goalType: "exercises_n" | "score_90_n";
  goalTarget: number;
  progress: number;
  badgeCode: string | null;
};

type EventClient = {
  rpc: (
    fn: "get_active_event" | "claim_event_badge",
  ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
};

/**
 * L'événement du moment, avec la progression de l'appelant. Lecture PUBLIQUE
 * assumée (`optionalSupabaseAuth`) : l'affiche est la même pour un visiteur, la
 * progression est simplement à zéro — un événement est une affiche, pas un secret.
 */
export const getActiveEvent = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .handler(async ({ context }): Promise<ActiveEvent | null> => {
    const client = context.supabase as unknown as EventClient;
    const { data, error } = await client.rpc("get_active_event");
    if (error) failWithClientError("dashboard.getActiveEvent", error, LOAD_ERROR_FR);
    if (!data || typeof data !== "object") return null;

    const row = data as Record<string, unknown>;
    return {
      code: String(row.code ?? ""),
      name: (row.name ?? {}) as Record<string, string>,
      description: (row.description ?? {}) as Record<string, string>,
      endsAt: String(row.endsAt ?? ""),
      goalType: row.goalType === "score_90_n" ? "score_90_n" : "exercises_n",
      goalTarget: Number(row.goalTarget ?? 0),
      progress: Number(row.progress ?? 0),
      badgeCode: typeof row.badgeCode === "string" ? row.badgeCode : null,
    };
  });

/**
 * Réclame le badge saisonnier — PENDANT la fenêtre seulement (R-21 : « jamais
 * après, jamais retiré »). La borne haute est la moitié qui compte : sans elle,
 * un défi de rentrée se rattraperait en juin, et le badge ne dirait plus rien.
 */
export const claimEventBadge = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ granted: boolean }> => {
    const client = context.supabase as unknown as EventClient;
    const { data, error } = await client.rpc("claim_event_badge");
    if (error) failWithClientError("dashboard.claimEventBadge", error, LOAD_ERROR_FR);
    return { granted: (data as { granted?: boolean } | null)?.granted === true };
  });

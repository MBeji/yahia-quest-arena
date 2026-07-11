import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

// "Interest" votes on a coming-soon parcours (a not-yet-built class). A signed-in
// user toggles interest; the aggregate counts drive the public "X intéressé·e·s"
// badge and the admin priority ranking. Writes go only through the SECURITY
// DEFINER `toggle_parcours_interest` RPC (clients can never write the table).

const LOAD_ERROR_FR = "Impossible de charger les intérêts de parcours.";

/** A coming-soon parcours with its live interest count (PII-free aggregate). */
export type ParcoursInterestCount = {
  parcoursId: string;
  name: string;
  count: number;
};

/** The parcours ids the current user has registered interest in (toggle state). */
export const getMyParcoursInterests = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ parcoursIds: string[] }> => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("parcours_interest")
      .select("parcours_id")
      .eq("user_id", userId);
    if (error) failWithClientError("parcoursInterest.getMine", error, LOAD_ERROR_FR);
    return { parcoursIds: (data ?? []).map((r) => r.parcours_id) };
  });

/**
 * Live interest count per coming-soon parcours, busiest first. Anon-capable
 * (étude 16 D-7/Q-5): the badge shows on the PUBLIC catalogue too — the RPC is
 * a PII-free aggregate granted to `anon` (migration 20260711140000). Voting
 * (`toggleParcoursInterest`) stays authenticated-only.
 */
export const getParcoursInterestCounts = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .handler(async ({ context }): Promise<{ counts: ParcoursInterestCount[] }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("parcours_interest_counts");
    if (error) failWithClientError("parcoursInterest.counts", error, LOAD_ERROR_FR);
    return {
      counts: (data ?? []).map((r) => ({
        parcoursId: r.parcours_id,
        name: r.name_fr,
        count: Number(r.interest_count ?? 0),
      })),
    };
  });

/**
 * Toggle the caller's interest in a coming-soon parcours. Returns the NEW state
 * (`interested: true` = registered, `false` = removed). The RPC rejects voting on
 * a non-coming-soon parcours, so the gate stays server-authoritative.
 */
export const toggleParcoursInterest = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ parcoursId: z.string().trim().min(1).max(100) }).parse(d))
  .handler(async ({ data, context }): Promise<{ interested: boolean }> => {
    const { supabase } = context;
    const { data: result, error } = await supabase.rpc("toggle_parcours_interest", {
      p_parcours: data.parcoursId,
    });
    if (error)
      failWithClientError(
        "parcoursInterest.toggle",
        error,
        "Impossible d'enregistrer ton intérêt. Réessaie.",
      );
    return { interested: result === true };
  });

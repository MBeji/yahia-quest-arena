import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * Bootstrap the freshly-signed-up user's profile (display name + role).
 *
 * The `handle_new_user` SQL trigger already inserts a base profile row on signup,
 * so this server fn only sets the user-chosen display name and role on top of it.
 * It is authenticated via `requireSupabaseAuth` (writes are constrained to the
 * caller's own id), so it MUST only be called once a session exists — i.e. after a
 * signup that auto-logs-in. When email confirmation is required there is no session
 * yet; in that case the trigger-created profile + signUp metadata are sufficient and
 * this fn is intentionally not called.
 *
 * SECURITY: the `role` column is no longer client-writable — direct PostgREST writes
 * to it are blocked by both a column-grant revoke and the `prevent_role_escalation`
 * trigger (see 20260606150000_security_p0_hardening.sql). The only sanctioned way for
 * a normal user to set their own onboarding role is the `set_profile_role` SECURITY
 * DEFINER RPC, which self-scopes and only permits 'student' | 'parent'. So we set the
 * display name via the (still client-writable) upsert and the role via that RPC.
 */
export const bootstrapProfile = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z
      .object({
        displayName: z.string().trim().min(1).max(80),
        role: z.enum(["student", "parent"]),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { error: nameError } = await supabase.from("profiles").upsert(
      {
        id: userId,
        display_name: data.displayName,
      },
      { onConflict: "id" },
    );

    if (nameError) {
      failWithClientError(
        "auth.bootstrapProfile upsert failed",
        nameError,
        "profile_bootstrap_failed",
      );
    }

    const { error: roleError } = await supabase.rpc("set_profile_role", { p_role: data.role });

    if (roleError) {
      failWithClientError(
        "auth.bootstrapProfile set_profile_role failed",
        roleError,
        "profile_bootstrap_failed",
      );
    }

    return { ok: true as const };
  });

/**
 * Persist the student's active parcours (chosen at onboarding).
 *
 * Goes through the `set_current_parcours` SECURITY DEFINER RPC, which self-scopes
 * (writes only the caller's own profile), sets `current_parcours_id`, and — for
 * concours parcours — syncs `current_grade_id` so the school-theme catalogue scopes
 * to the right level. Returns the updated profile row.
 */
export const setCurrentParcours = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) => z.object({ parcoursId: z.string().min(1) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: profile, error } = await supabase.rpc("set_current_parcours", {
      p_parcours: data.parcoursId,
    });
    if (error) {
      failWithClientError(
        "auth.setCurrentParcours",
        error,
        "Impossible d'enregistrer ton parcours.",
      );
    }
    return { profile };
  });

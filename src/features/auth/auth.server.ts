import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * Bootstrap the freshly-signed-up user's profile (display name + role).
 *
 * The `handle_new_user` SQL trigger already inserts a base profile row on signup,
 * so this server fn only sets the user-chosen display name and role on top of it.
 * It is authenticated via `requireSupabaseAuth` (the upsert is constrained to the
 * caller's own id), so it MUST only be called once a session exists — i.e. after a
 * signup that auto-logs-in. When email confirmation is required there is no session
 * yet; in that case the trigger-created profile + signUp metadata are sufficient and
 * this fn is intentionally not called.
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

    const { error } = await supabase.from("profiles").upsert(
      {
        id: userId,
        display_name: data.displayName,
        role: data.role,
      },
      { onConflict: "id" },
    );

    if (error) {
      failWithClientError("auth.bootstrapProfile upsert failed", error, "profile_bootstrap_failed");
    }

    return { ok: true as const };
  });

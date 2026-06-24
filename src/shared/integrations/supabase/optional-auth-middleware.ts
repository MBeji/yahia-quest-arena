import { createMiddleware } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
import { logger } from "@/shared/lib/logger";
import { createAuthedSupabaseClient, createPublicSupabaseClient } from "./public-client";

/**
 * Context injected by {@link optionalSupabaseAuth}. `userId` is the authenticated
 * user's id, or `null` for an anonymous visitor — handlers MUST branch on it.
 */
export type OptionalAuthContext = {
  supabase: ReturnType<typeof createPublicSupabaseClient>;
  userId: string | null;
};

/**
 * Optional Supabase authentication for PUBLIC-FIRST routes.
 *
 * - A valid `Bearer` JWT yields an authenticated client and a non-null `userId`.
 * - No token — or an invalid/expired one — degrades gracefully to an anonymous
 *   client (the `anon` Postgres role) with `userId: null`.
 *
 * Handlers MUST branch on `userId` and never assume a session. Use this only for
 * content reads that should be visible to everyone; gameplay/account mutations keep
 * {@link requireSupabaseAuth}. RLS still enforces what `anon` may read.
 */
export const optionalSupabaseAuth = createMiddleware({ type: "function" }).server(
  async ({ next }) => {
    const authHeader = getRequest()?.headers?.get("authorization");

    if (authHeader?.startsWith("Bearer ")) {
      const token = authHeader.slice("Bearer ".length);
      if (token) {
        const supabase = createAuthedSupabaseClient(token);
        const { data, error } = await supabase.auth.getClaims(token);
        if (!error && data?.claims?.sub) {
          const context: OptionalAuthContext = { supabase, userId: data.claims.sub };
          return next({ context });
        }
        logger.warn("optionalSupabaseAuth: invalid bearer token, continuing as anonymous");
      }
    }

    const context: OptionalAuthContext = {
      supabase: createPublicSupabaseClient(),
      userId: null,
    };
    return next({ context });
  },
);

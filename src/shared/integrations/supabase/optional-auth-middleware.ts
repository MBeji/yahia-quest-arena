import { createMiddleware } from "@tanstack/react-start";
import { getRequest } from "@tanstack/react-start/server";
import { createClient } from "@supabase/supabase-js";
import type { Database } from "./types";
import { logger } from "@/shared/lib/logger";

type SupabaseEnv = { url: string; key: string };

function readSupabaseEnv(): SupabaseEnv {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_PUBLISHABLE_KEY;

  if (!url || !key) {
    const missing = [
      ...(!url ? ["SUPABASE_URL"] : []),
      ...(!key ? ["SUPABASE_PUBLISHABLE_KEY"] : []),
    ];
    const message = `Missing Supabase environment variable(s): ${missing.join(", ")}. Set them in your deployment environment.`;
    logger.error("Supabase optional-auth middleware misconfiguration", { missing });
    throw new Error(message);
  }

  return { url, key };
}

const SUPABASE_AUTH_OPTIONS = {
  storage: undefined,
  persistSession: false,
  autoRefreshToken: false,
} as const;

function createAnonymousClient({ url, key }: SupabaseEnv) {
  return createClient<Database>(url, key, { auth: { ...SUPABASE_AUTH_OPTIONS } });
}

function createAuthenticatedClient({ url, key }: SupabaseEnv, token: string) {
  return createClient<Database>(url, key, {
    global: { headers: { Authorization: `Bearer ${token}` } },
    auth: { ...SUPABASE_AUTH_OPTIONS },
  });
}

/**
 * Context injected by {@link optionalSupabaseAuth}. `userId` is the authenticated
 * user's id, or `null` for an anonymous visitor — handlers MUST branch on it.
 */
export type OptionalAuthContext = {
  supabase: ReturnType<typeof createAnonymousClient>;
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
    const env = readSupabaseEnv();
    const authHeader = getRequest()?.headers?.get("authorization");

    if (authHeader?.startsWith("Bearer ")) {
      const token = authHeader.slice("Bearer ".length);
      if (token) {
        const supabase = createAuthenticatedClient(env, token);
        const { data, error } = await supabase.auth.getClaims(token);
        if (!error && data?.claims?.sub) {
          const context: OptionalAuthContext = { supabase, userId: data.claims.sub };
          return next({ context });
        }
        logger.warn("optionalSupabaseAuth: invalid bearer token, continuing as anonymous");
      }
    }

    const context: OptionalAuthContext = {
      supabase: createAnonymousClient(env),
      userId: null,
    };
    return next({ context });
  },
);

import { createClient } from "@supabase/supabase-js";
import type { Database } from "./types";
import { logger } from "@/shared/lib/logger";

type SupabaseEnv = { url: string; key: string };

const SUPABASE_AUTH_OPTIONS = {
  storage: undefined,
  persistSession: false,
  autoRefreshToken: false,
} as const;

/**
 * Read the publishable Supabase credentials from the environment, throwing a
 * descriptive error (and logging the missing keys) when either is absent. Shared
 * by the optional-auth middleware and the public sitemap generator so the
 * env-reading + client-creation logic lives in exactly one place.
 */
export function readSupabaseEnv(): SupabaseEnv {
  const url = process.env.SUPABASE_URL;
  const key = process.env.SUPABASE_PUBLISHABLE_KEY;

  if (!url || !key) {
    const missing = [
      ...(!url ? ["SUPABASE_URL"] : []),
      ...(!key ? ["SUPABASE_PUBLISHABLE_KEY"] : []),
    ];
    const message = `Missing Supabase environment variable(s): ${missing.join(", ")}. Set them in your deployment environment.`;
    logger.error("Supabase public client misconfiguration", { missing });
    throw new Error(message);
  }

  return { url, key };
}

/**
 * Anonymous Supabase client (the `anon` Postgres role). RLS decides what an
 * unauthenticated visitor may read — use this only for content that should be
 * visible to everyone (public-first reads, the sitemap generator).
 */
export function createPublicSupabaseClient() {
  const { url, key } = readSupabaseEnv();
  return createClient<Database>(url, key, { auth: { ...SUPABASE_AUTH_OPTIONS } });
}

/** Supabase client that carries a caller's bearer token (authenticated role). */
export function createAuthedSupabaseClient(token: string) {
  const { url, key } = readSupabaseEnv();
  return createClient<Database>(url, key, {
    global: { headers: { Authorization: `Bearer ${token}` } },
    auth: { ...SUPABASE_AUTH_OPTIONS },
  });
}

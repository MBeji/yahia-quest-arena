import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { requireAdminEnv } from "./env";

/**
 * Test-only DB access via the service-role key (bypasses RLS). Use to pick
 * deterministic content ids / set up data, instead of walking a quiz-gated UI.
 * Exposed to specs through the `adminDb` fixture.
 */
export interface AdminDb {
  readonly client: SupabaseClient;
  /**
   * Id of a premium (subscription-only) subject. A free account opening its
   * subject page gets the subscription paywall rendered directly — the reliable
   * way to assert the free-user paywall journey (no quest-session / quiz race).
   */
  premiumSubjectId(): Promise<string>;
}

export function createAdminDb(): AdminDb {
  const { url, serviceRoleKey } = requireAdminEnv();
  const client = createClient(url, serviceRoleKey, { auth: { persistSession: false } });

  return {
    client,
    async premiumSubjectId() {
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", true)
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`premiumSubjectId: ${error.message}`);
      if (!data) throw new Error("No premium subject (is_premium=true) found in the test project.");
      return data.id as string;
    },
  };
}

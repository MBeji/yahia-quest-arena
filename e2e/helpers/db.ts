import { createClient } from "@supabase/supabase-js";

/**
 * Test-only DB access via the service-role key (set in the same env used by
 * `npm run e2e:seed`: SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY). Used to pick
 * deterministic content ids instead of walking a quiz-gated UI.
 */
function adminClient() {
  const url = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL ?? "";
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY ?? "";
  if (!url || !serviceKey) {
    throw new Error(
      "helpers/db needs SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in the environment " +
        "(same vars as `npm run e2e:seed`).",
    );
  }
  return createClient(url, serviceKey, { auth: { persistSession: false } });
}

/**
 * Id of a premium (subscription-only) subject — the whole module is reserved to
 * subscribers. A free account opening its subject page gets the subscription
 * paywall rendered directly on the page (no quest session / chapter-quiz race),
 * so it is the reliable way to assert the free-user paywall journey.
 */
export async function getPremiumSubjectId(): Promise<string> {
  const { data, error } = await adminClient()
    .from("subjects")
    .select("id")
    .eq("is_premium", true)
    .limit(1)
    .maybeSingle();
  if (error) throw new Error(`getPremiumSubjectId: ${error.message}`);
  if (!data) {
    throw new Error("No premium subject (is_premium=true) found in the test project.");
  }
  return data.id as string;
}

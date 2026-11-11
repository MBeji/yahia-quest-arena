/**
 * Reset the TEST project's gameplay state to a clean slate, so authenticated e2e
 * runs are deterministic and repeatable. Clears progress tables and zeroes
 * profile progression; CONTENT (subjects/chapters/exercises/questions/shop/badge
 * definitions), the accounts, and their per-parcours entitlements are preserved
 * (roles + entitlements are re-applied by `npm run e2e:seed`).
 *
 *   SUPABASE_URL=...                 (the TEST project URL)
 *   SUPABASE_SERVICE_ROLE_KEY=...
 *   node scripts/e2e/reset-gameplay.mjs
 *
 * ⚠️ Never run against production. Add new mutable gameplay tables to
 * gameplay-tables.mjs (not here) so the unit-test coverage catches omissions.
 */
import "./_env.mjs";
import { createClient } from "@supabase/supabase-js";
import { findProdTarget, prodRefusalMessage } from "../shared/prod-targets.mjs";
import { GAMEPLAY_TABLES, isMissingTableError, rowKey } from "./gameplay-tables.mjs";

const URL =
  process.env.SUPABASE_URL ?? process.env.TEST_SUPABASE_URL ?? process.env.VITE_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!URL || !SERVICE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.");
  process.exit(1);
}

// Safety net: never wipe the known production project, even if misconfigured.
const prodTarget = findProdTarget([URL]);
if (prodTarget) {
  console.error(`Refusing to reset: ${prodRefusalMessage(prodTarget)} Use the TEST project.`);
  process.exit(1);
}

const admin = createClient(URL, SERVICE_KEY, { auth: { persistSession: false } });

// PostgREST refuse un DELETE sans filtre : `.not(<clé>, "is", null)` vise toutes les
// lignes, et la clé dépend de la table (`id` par défaut, `user_id` pour le grand livre —
// voir ROW_KEY). Une table absente se saute ; toute autre erreur est un reset raté, et un
// reset raté se voit ICI, pas trois specs plus loin sur un « élément introuvable ».
let failed = 0;
for (const table of GAMEPLAY_TABLES) {
  const { error } = await admin.from(table).delete().not(rowKey(table), "is", null);
  if (!error) {
    console.log(`  • cleared ${table}`);
  } else if (isMissingTableError(error)) {
    console.log(`  • skip ${table} (absente : ${error.message})`);
  } else {
    failed += 1;
    console.error(`  ✗ ${table} NON vidée : ${error.message}`);
  }
}

const { error: pErr } = await admin
  .from("profiles")
  .update({
    xp: 0,
    level: 1,
    yahia_coins: 0,
    current_streak: 0,
    longest_streak: 0,
    last_active_date: null,
    avatar_slug: null,
  })
  .not("id", "is", null);
if (pErr) failed += 1;
console.log(pErr ? `  ✗ profiles: ${pErr.message}` : "  • reset profiles progression");

if (failed > 0) {
  console.error(`[e2e] reset INCOMPLET — ${failed} table(s) non vidée(s) : le décor est sale.`);
  process.exit(1);
}

console.log("[e2e] gameplay reset complete");

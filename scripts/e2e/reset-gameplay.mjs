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
 * ⚠️ Never run against production. Add new mutable gameplay tables to GAMEPLAY_TABLES.
 */
import "./_env.mjs";
import { createClient } from "@supabase/supabase-js";

const URL =
  process.env.SUPABASE_URL ?? process.env.TEST_SUPABASE_URL ?? process.env.VITE_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!URL || !SERVICE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.");
  process.exit(1);
}

// Safety net: never wipe the known production project, even if misconfigured.
const PROD_REFS = ["fasrenmmrkqjoobrztbp"];
if (PROD_REFS.some((ref) => URL.includes(ref))) {
  console.error(`Refusing to reset: ${URL} is the production project. Use the TEST project.`);
  process.exit(1);
}

// Children before parents (FKs). Tolerant: a missing table is skipped, not fatal.
const GAMEPLAY_TABLES = [
  "attempts",
  "dungeon_run_questions",
  "dungeon_runs",
  "spaced_repetition_schedule",
  "daily_objectives",
  "weekly_quests",
  "difficulty_adaptation",
  "student_badges",
  "inventory_items",
  "exercise_assignments",
  "rate_limit_events",
];

const admin = createClient(URL, SERVICE_KEY, { auth: { persistSession: false } });
const ALL_ROWS = ["id", "is", null]; // delete().not("id","is",null) ⇒ matches every row

for (const table of GAMEPLAY_TABLES) {
  const { error } = await admin
    .from(table)
    .delete()
    .not(...ALL_ROWS);
  console.log(error ? `  • skip ${table} (${error.message})` : `  • cleared ${table}`);
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
  .not(...ALL_ROWS);
console.log(pErr ? `  • profiles: ${pErr.message}` : "  • reset profiles progression");

console.log("[e2e] gameplay reset complete");

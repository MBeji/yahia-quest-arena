/**
 * Seed (or refresh) the E2E test accounts in the TEST Supabase project.
 * Idempotent: creates each user if missing, always resets the password, and
 * sets role / subscription on the profile. Uses the SERVICE-ROLE key.
 *
 *   SUPABASE_URL=...            (the TEST project URL)
 *   SUPABASE_SERVICE_ROLE_KEY=...
 *   E2E_USER_PASSWORD=...       (same value used by the Playwright specs)
 *   node scripts/e2e/seed-test-users.mjs
 *
 * ⚠️ Never run against production. Run all DB migrations + content on the test
 * project first so subjects/exercises exist for the journeys.
 */
import { createClient } from "@supabase/supabase-js";

const URL = process.env.SUPABASE_URL ?? process.env.TEST_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const PASSWORD = process.env.E2E_USER_PASSWORD ?? "E2e-Test-Passw0rd!";

if (!URL || !SERVICE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.");
  process.exit(1);
}

const admin = createClient(URL, SERVICE_KEY, { auth: { persistSession: false } });

const USERS = [
  {
    email: "student.free@e2e.xpscholars.test",
    display: "Free Student",
    role: "student",
    premium: false,
  },
  {
    email: "student.premium@e2e.xpscholars.test",
    display: "Premium Student",
    role: "student",
    premium: true,
  },
  { email: "parent@e2e.xpscholars.test", display: "Test Parent", role: "parent", premium: false },
  { email: "admin@e2e.xpscholars.test", display: "Test Admin", role: "admin", premium: false },
];

async function findUserByEmail(email) {
  // Paginate through users (test projects are tiny, a few pages is plenty).
  for (let page = 1; page <= 20; page++) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage: 200 });
    if (error) throw error;
    const found = data.users.find((u) => u.email?.toLowerCase() === email.toLowerCase());
    if (found) return found;
    if (data.users.length < 200) break;
  }
  return null;
}

async function getOrCreate(email, display) {
  const existing = await findUserByEmail(email);
  if (existing) {
    await admin.auth.admin.updateUserById(existing.id, {
      password: PASSWORD,
      email_confirm: true,
      user_metadata: { display_name: display },
    });
    return existing.id;
  }
  const { data, error } = await admin.auth.admin.createUser({
    email,
    password: PASSWORD,
    email_confirm: true,
    user_metadata: { display_name: display },
  });
  if (error) throw error;
  return data.user.id;
}

async function main() {
  for (const u of USERS) {
    const id = await getOrCreate(u.email, u.display);

    const patch = { role: u.role, display_name: u.display };
    if (u.premium) {
      const now = new Date();
      const expires = new Date(now.getTime() + 365 * 24 * 60 * 60 * 1000);
      patch.subscription_type = "annual";
      patch.subscription_activated_at = now.toISOString();
      patch.subscription_expires_at = expires.toISOString();
    } else {
      patch.subscription_type = null;
      patch.subscription_activated_at = null;
      patch.subscription_expires_at = null;
    }

    // Profile is created by the handle_new_user trigger; update its role/subscription.
    const { error } = await admin.from("profiles").update(patch).eq("id", id);
    if (error) throw error;

    console.log(`✓ ${u.email}  (role=${u.role}, premium=${u.premium})`);
  }
  console.log(`\nSeeded ${USERS.length} test users.`);
}

main().catch((e) => {
  console.error("Seed failed:", e.message ?? e);
  process.exit(1);
});

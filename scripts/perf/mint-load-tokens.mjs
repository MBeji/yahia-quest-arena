/**
 * Mint access tokens for the k6 load suite (perf/k6/**).
 *
 * Idempotently creates N throwaway load-test students in a DEDICATED load-test
 * Supabase project, then signs each in to obtain a short-lived access token.
 * Prints a ready-to-paste `LOAD_USER_JWTS=...` line (and the user ids).
 *
 *   SUPABASE_URL=...                 (the LOAD-TEST project URL — never prod)
 *   SUPABASE_SERVICE_ROLE_KEY=...
 *   SUPABASE_PUBLISHABLE_KEY=...     (anon key, used for password sign-in)
 *   LOAD_USER_COUNT=50               (how many VU identities to mint; default 50)
 *   LOAD_USER_PASSWORD=...           (optional; defaults to a fixed test password)
 *   node scripts/perf/mint-load-tokens.mjs
 *
 * ⚠️ NEVER run against production. These accounts submit real attempts and earn
 * XP during a load run. The known prod ref is refused as a safety net.
 */
import { createClient } from "@supabase/supabase-js";

const URL = process.env.SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANON_KEY = process.env.SUPABASE_PUBLISHABLE_KEY;
const COUNT = Number(process.env.LOAD_USER_COUNT ?? 50);
const PASSWORD = process.env.LOAD_USER_PASSWORD ?? "Load-Test-Passw0rd!";
const PROD_REF = "fasrenmmrkqjoobrztbp"; // mirrors PROD_REFS in scripts/e2e/_env.mjs

if (!URL || !SERVICE_KEY || !ANON_KEY) {
  console.error("Missing SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY / SUPABASE_PUBLISHABLE_KEY.");
  process.exit(1);
}
if (URL.includes(PROD_REF)) {
  console.error(`Refusing to mint load tokens against the known production ref (${PROD_REF}).`);
  process.exit(1);
}

const admin = createClient(URL, SERVICE_KEY, { auth: { persistSession: false } });
const anon = createClient(URL, ANON_KEY, { auth: { persistSession: false } });

async function ensureUser(email) {
  // Try to create; if it already exists, that's fine (idempotent re-run).
  const { data, error } = await admin.auth.admin.createUser({
    email,
    password: PASSWORD,
    email_confirm: true,
    user_metadata: { display_name: email.split("@")[0], load_test: true },
  });
  if (error && !/already.*registered|exists/i.test(error.message)) {
    throw error;
  }
  return data?.user?.id ?? null;
}

async function token(email) {
  const { data, error } = await anon.auth.signInWithPassword({ email, password: PASSWORD });
  if (error) throw error;
  return data.session.access_token;
}

const tokens = [];
const ids = [];
for (let i = 0; i < COUNT; i++) {
  const email = `load.${i}@loadtest.xpscholars.test`;
  try {
    const id = await ensureUser(email);
    if (id) ids.push(id);
    tokens.push(await token(email));
    if ((i + 1) % 10 === 0) console.error(`  …${i + 1}/${COUNT} ready`);
  } catch (e) {
    console.error(`  ! ${email}: ${e.message}`);
  }
}

console.error(`\nMinted ${tokens.length}/${COUNT} tokens.`);
console.error("Tokens expire in ~1h — re-run before a long stress/soak.\n");
console.log(`LOAD_USER_JWTS=${tokens.join(",")}`);
if (ids.length) console.error(`# user ids: ${ids.join(",")}`);

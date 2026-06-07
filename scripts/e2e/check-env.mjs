/**
 * Doctor: verify the e2e environment is ready before running the authenticated
 * suite. Loads `.env.test` (via _env.mjs), reports which vars are set (secrets
 * masked), resolves the target project ref, and confirms it isn't production.
 *
 *   npm run e2e:doctor
 */
import "./_env.mjs";

const mask = (v) => (v ? `${v.slice(0, 6)}…${v.slice(-4)} (len ${v.length})` : "(missing)");

const REQUIRED = [
  "VITE_SUPABASE_URL",
  "VITE_SUPABASE_PUBLISHABLE_KEY",
  "SUPABASE_URL",
  "SUPABASE_PUBLISHABLE_KEY",
  "SUPABASE_SERVICE_ROLE_KEY",
  "E2E_USER_PASSWORD",
];
const OPTIONAL = ["TEST_SUPABASE_DB_URL"];

let ok = true;
console.log("e2e environment check\n=====================");
for (const key of REQUIRED) {
  const val = process.env[key];
  const bad = !val || val.includes("your-") || val.includes("<");
  if (bad) ok = false;
  console.log(`${bad ? "✗" : "✓"} ${key.padEnd(30)} ${mask(val)}`);
}
for (const key of OPTIONAL) {
  const val = process.env[key];
  console.log(
    `${val ? "✓" : "•"} ${key.padEnd(30)} ${val ? mask(val) : "(optional — for npm run e2e:db:push)"}`,
  );
}

const url = process.env.SUPABASE_URL ?? process.env.VITE_SUPABASE_URL ?? "";
const refMatch = url.match(/https?:\/\/([a-z0-9]+)\.supabase\.co/i);
console.log(`\nTarget project ref: ${refMatch ? refMatch[1] : "(unresolved)"}`);

if (!ok) {
  console.error(
    "\n✗ Environment incomplete. Copy .env.test.example → .env.test and fill the TEST values.",
  );
  process.exit(1);
}
console.log("\n✓ Environment looks ready. Next: npm run e2e:setup && npm run test:e2e:auth");

/**
 * Dev server bound to the TEST Supabase project — for local capture runs
 * (études 14/15, règle R-5) and manual QA against the seeded e2e accounts.
 *
 * Injects `.env.test` (repo root) exactly like the rest of the e2e tooling —
 * including the anti-production safety net — then starts `npm run dev`
 * (port 8080, same default the Playwright config expects).
 *
 *   node scripts/design/dev-server-test.mjs
 */
import "../e2e/_env.mjs";
import { spawn } from "node:child_process";

const child = spawn("npm", ["run", "dev"], { stdio: "inherit", shell: true });
child.on("exit", (code) => process.exit(code ?? 0));

/**
 * Production-shell browser smoke (incident 2026-07-01 regression net).
 *
 * Builds the REAL production bundle, serves it (SSR worker + static assets),
 * loads the public pages in a real Chromium, and fails on any page error or
 * error-boundary page. This is the only tier that can catch client-runtime
 * crashes in prod-gated code paths (`import.meta.env.PROD`): tsc can be blind
 * to them (unregistered router → `any`), the unit gate excludes route glue by
 * design, SSR never runs effects, and the Playwright e2e tier runs the DEV
 * server where prod-gated code no-ops. The 2026-07-01 outage (GA4 effect
 * string-coercing the parsed search object — Safari "No default value") was
 * exactly this class: green gate, dead production. This script's probe logic
 * is what finally reproduced and pinned it.
 *
 * Hermetic: dummy Supabase env (the shell never reaches the network), every
 * non-localhost request is blocked, no TEST project needed. Runs in CI after
 * `npx playwright install chromium`, or locally with any Playwright Chromium.
 *
 * Usage: npm run smoke:shell   (builds into dist/ — overwrites a prior build)
 */

import { spawnSync } from "node:child_process";
import http from "node:http";
import { readFile } from "node:fs/promises";
import { existsSync } from "node:fs";
import { join, extname, resolve } from "node:path";

const ROOT = resolve(import.meta.dirname, "../..");
const CLIENT_DIR = join(ROOT, "dist/client");
const SERVER_ENTRY = join(ROOT, "dist/server/index.js");
const PORT = 8129;
const ORIGIN = `http://localhost:${PORT}`;

// Dummy env: inlined into the client bundle at build time and read by the SSR
// runtime. Values are never dialled (all external requests are blocked below).
const DUMMY_ENV = {
  VITE_SUPABASE_URL: "https://smoke-test.supabase.co",
  VITE_SUPABASE_PUBLISHABLE_KEY: "smoke-dummy-anon-key",
  SUPABASE_URL: "https://smoke-test.supabase.co",
  SUPABASE_PUBLISHABLE_KEY: "smoke-dummy-anon-key",
};

/** Pages to probe: path → a text marker that MUST be present when the page
 *  really rendered (default locale is French). */
const PAGES = {
  "/": "GRATUIT",
  "/programme": "Programme",
};

/** Substrings that flag the branded error pages (React boundary in fr/en/ar +
 *  the static server fallback). Any hit = the shell died. */
const ERROR_MARKERS = ["s'est déchiré", "didn't load", "تمزّقت", "torn apart"];

const MIME = {
  ".js": "text/javascript",
  ".css": "text/css",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".webmanifest": "application/manifest+json",
  ".json": "application/json",
};

function buildProdBundle() {
  console.log("▶ smoke:shell — building the production bundle (dummy env)…");
  const res = spawnSync("npx", ["vite", "build"], {
    cwd: ROOT,
    stdio: "inherit",
    env: { ...process.env, ...DUMMY_ENV },
  });
  if (res.status !== 0) {
    console.error("✖ vite build failed — cannot smoke-test.");
    process.exit(1);
  }
}

function startServer(worker) {
  return new Promise((resolveStarted) => {
    const server = http.createServer(async (req, res) => {
      const url = new URL(req.url, ORIGIN);
      try {
        if (url.pathname.startsWith("/assets/") || extname(url.pathname)) {
          try {
            const body = await readFile(join(CLIENT_DIR, url.pathname));
            res.writeHead(200, {
              "content-type": MIME[extname(url.pathname)] ?? "application/octet-stream",
            });
            return res.end(body);
          } catch {
            // Not a static file after all — fall through to SSR.
          }
        }
        const request = new Request(ORIGIN + req.url, { headers: { ...req.headers } });
        const response = await worker.fetch(request, {}, { waitUntil: () => {} });
        res.writeHead(response.status, Object.fromEntries(response.headers));
        res.end(Buffer.from(await response.arrayBuffer()));
      } catch (error) {
        res.writeHead(500);
        res.end(String(error));
      }
    });
    server.listen(PORT, () => resolveStarted(server));
  });
}

async function launchChromium() {
  const { chromium } = await import(join(ROOT, "node_modules/playwright/index.mjs"));
  try {
    return await chromium.launch();
  } catch (error) {
    // Sandbox fallback: a Chromium provided outside the Playwright registry.
    const fallback = "/opt/pw-browsers/chromium";
    if (existsSync(fallback)) return chromium.launch({ executablePath: fallback });
    throw error;
  }
}

async function probePage(browser, path, marker) {
  const context = await browser.newContext();
  const page = await context.newPage();
  // Hermetic: localhost only. Blocks fonts/gtag/Supabase — the shell must
  // survive all of them being unreachable anyway.
  await page.route(
    (url) => url.origin !== ORIGIN,
    (route) => route.abort(),
  );
  const failures = [];
  page.on("pageerror", (error) => failures.push(`pageerror: ${error.stack ?? error.message}`));

  await page
    .goto(ORIGIN + path, { waitUntil: "load", timeout: 30_000 })
    .catch((error) => failures.push(`goto failed: ${error.message}`));
  // Give hydration + mount effects (where the 2026-07-01 crash lived) time to run.
  await page.waitForTimeout(2_500);

  const body = await page.evaluate(() => document.body.innerText).catch(() => "");
  for (const errorMarker of ERROR_MARKERS) {
    if (body.includes(errorMarker)) failures.push(`error page detected ("${errorMarker}")`);
  }
  if (!body.includes(marker)) failures.push(`expected content marker "${marker}" not found`);

  await context.close();
  return failures;
}

buildProdBundle();
Object.assign(process.env, DUMMY_ENV);
const worker = (await import(SERVER_ENTRY)).default;
const server = await startServer(worker);
const browser = await launchChromium();

let failed = false;
for (const [path, marker] of Object.entries(PAGES)) {
  const failures = await probePage(browser, path, marker);
  if (failures.length === 0) {
    console.log(`✔ ${path} renders in a real browser (no page errors)`);
  } else {
    failed = true;
    console.error(`✖ ${path} FAILED:`);
    for (const failure of failures) console.error(`    ${failure.split("\n").join("\n    ")}`);
  }
}

await browser.close();
server.close();
if (failed) {
  console.error("✖ smoke:shell — the production shell is broken in a real browser.");
  process.exit(1);
}
console.log("✔ smoke:shell passed — production shell renders cleanly.");
process.exit(0);

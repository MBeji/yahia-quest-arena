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
import { createRequire } from "node:module";
import { join, dirname, extname, resolve } from "node:path";
import { pathToFileURL } from "node:url";

const ROOT = resolve(import.meta.dirname, "../..");
const CLIENT_DIR = join(ROOT, "dist/client");
const SERVER_ENTRY = join(ROOT, "dist/server/index.js");
const PORT = 8129;
const ORIGIN = `http://localhost:${PORT}`;
/** La face arabe complète : aucune page publique ne doit la demander. */
const FULL_ARABIC_FACE = "/fonts/noto-kufi-arabic-var.woff2";

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

/**
 * The canonical origin, READ FROM THE SOURCE rather than repeated here — so that
 * changing `SITE_URL` moves this check with it instead of leaving a second,
 * quietly diverging copy. A plain .mjs cannot import the .ts module, hence the
 * extraction; it throws rather than falls back, because a smoke that silently
 * checks the wrong origin is worse than one that does not run.
 */
const CANONICAL_ORIGIN = await (async () => {
  const src = await readFile(join(ROOT, "src/shared/constants/site.ts"), "utf8");
  const match = src.match(/export const SITE_URL\s*=\s*["'`]([^"'`]+)["'`]/);
  if (!match) throw new Error("shell-smoke: SITE_URL not found in src/shared/constants/site.ts");
  return match[1].replace(/\/+$/, "");
})();

/** Substrings that flag the branded error pages (React boundary in fr/en/ar +
 *  the static server fallback). Any hit = the shell died. */
const ERROR_MARKERS = ["s'est déchiré", "didn't load", "تمزّقت", "torn apart"];

/**
 * LE STOCKAGE REFUSÉ (#1307). Cookies et données de site bloqués, certains modes privés, un
 * navigateur intégré verrouillé : `localStorage` lève à l'ACCÈS ; quota plein : il lève à
 * l'USAGE. Une seule lecture sans garde au démarrage remplaçait le site entier par l'écran
 * d'erreur de la racine — vert partout ailleurs, puisque ni jsdom ni le serveur de dev ne
 * refusent quoi que ce soit. Script injecté avant tout code de la page.
 */
const STORAGE_DENIAL = {
  refused: `
    for (const name of ["localStorage", "sessionStorage"]) {
      Object.defineProperty(window, name, {
        configurable: true,
        get() { throw new DOMException("The operation is insecure.", "SecurityError"); },
      });
    }`,
  full: `
    for (const store of [window.localStorage, window.sessionStorage]) {
      const proto = Object.getPrototypeOf(store);
      for (const method of ["getItem", "setItem", "removeItem", "key", "clear"]) {
        Object.defineProperty(proto, method, {
          configurable: true,
          value() { throw new DOMException("The quota has been exceeded.", "QuotaExceededError"); },
        });
      }
    }`,
};

const MIME = {
  ".js": "text/javascript",
  ".css": "text/css",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".webmanifest": "application/manifest+json",
  ".json": "application/json",
  ".html": "text/html; charset=utf-8",
};

function buildProdBundle() {
  console.log("▶ smoke:shell — building the production bundle (dummy env)…");
  // Run the local vite bin with the current Node, not `spawnSync("npx", …)`:
  // on Windows npx is npx.cmd, which spawnSync can't exec without a shell
  // (ENOENT). Vite's exports map only exposes ./package.json, so resolve the
  // bin path through it.
  const require = createRequire(import.meta.url);
  const vitePkgPath = require.resolve("vite/package.json");
  const viteBin = join(dirname(vitePkgPath), require(vitePkgPath).bin.vite);
  const res = spawnSync(process.execPath, [viteBin, "build"], {
    cwd: ROOT,
    stdio: "inherit",
    env: { ...process.env, ...DUMMY_ENV },
  });
  if (res.status !== 0) {
    console.error("✖ vite build failed — cannot smoke-test.");
    process.exit(1);
  }
}

/**
 * Le service worker que le serveur rend à la place de `dist/client/sw.js`, quand il
 * est posé — c'est ainsi que `probeNetwork` joue une MISE À JOUR : l'ancien worker
 * d'abord, le vrai ensuite, comme chez un visiteur qui revient après un déploiement.
 */
let swOverride = null;

function startServer(worker) {
  return new Promise((resolveStarted) => {
    const server = http.createServer(async (req, res) => {
      const url = new URL(req.url, ORIGIN);
      try {
        if (url.pathname === "/sw.js" && swOverride !== null) {
          res.writeHead(200, { "content-type": MIME[".js"], "cache-control": "no-store" });
          return res.end(swOverride);
        }
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
  // pathToFileURL: import() of a bare Windows path reads "D:" as a URL scheme.
  const { chromium } = await import(
    pathToFileURL(join(ROOT, "node_modules/playwright/index.mjs")).href
  );
  try {
    return await chromium.launch();
  } catch (error) {
    // Sandbox fallback: a Chromium provided outside the Playwright registry.
    const fallback = "/opt/pw-browsers/chromium";
    if (existsSync(fallback)) return chromium.launch({ executablePath: fallback });
    throw error;
  }
}

async function probePage(browser, path, marker, storage = null) {
  const context = await browser.newContext();
  if (storage) await context.addInitScript(STORAGE_DENIAL[storage]);
  const page = await context.newPage();
  // Hermetic: localhost only. Blocks fonts/gtag/Supabase — the shell must
  // survive all of them being unreachable anyway.
  await page.route(
    (url) => url.origin !== ORIGIN,
    (route) => route.abort(),
  );
  const failures = [];
  page.on("pageerror", (error) => failures.push(`pageerror: ${error.stack ?? error.message}`));
  // Perf bundle-03 (2026-10-31) : la face Noto Kufi complète (124 ko,
  // incompressible) partait sur chaque page publique pour la seule signature
  // « نقرا نلعب », qui porte depuis sa sous-police de 6,8 ko. Les fontes sont
  // same-origin, donc pas bloquées par la route ci-dessus : c'est le seul
  // étage qui voit la requête réelle, un test jsdom ne sait pas quelle face le
  // navigateur télécharge.
  page.on("request", (request) => {
    if (new URL(request.url()).pathname === FULL_ARABIC_FACE)
      failures.push(
        `full Arabic face requested (${FULL_ARABIC_FACE}) — the brand subset should suffice`,
      );
  });

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

  // <link rel="canonical"> — what THIS tier proves, and what it does not.
  //
  // PROVES: the tag really reaches <head> in a real browser on the real bundle,
  // exactly once, carrying the right PATH. The component is rendered deep in the
  // public layout and relies on React hoisting the <link> up; a jsdom unit test
  // shows the component's return value and nothing whatsoever about that
  // hoisting. Only this tier can tell crawler-visible from merely-rendered.
  //
  // DOES NOT PROVE: that the origin is the right one. `CANONICAL_ORIGIN` is read
  // from the same `SITE_URL` the tag is built from, so both move together and
  // the comparison stays green on a wrong host — verified by deliberately
  // flipping SITE_URL back to the apex, which this check happily accepted. The
  // HOST is pinned by a literal in `sitemap.test.ts` ("declares the host prod
  // actually serves"), which did fail on that flip. Two dimensions, two guards:
  // do not merge them, and do not make that unit assertion read SITE_URL.
  const canonicals = await page
    .evaluate(() =>
      [...document.head.querySelectorAll('link[rel="canonical"]')].map((l) =>
        l.getAttribute("href"),
      ),
    )
    .catch(() => []);
  const expected = CANONICAL_ORIGIN + (path === "/" ? "" : path);
  if (canonicals.length === 0) failures.push('no <link rel="canonical"> in <head>');
  else if (canonicals.length > 1)
    failures.push(`${canonicals.length} canonical tags in <head> (expected exactly 1)`);
  else if (canonicals[0] !== expected)
    failures.push(`canonical is "${canonicals[0]}", expected "${expected}"`);

  await context.close();
  return failures;
}

/**
 * LE RÉSEAU SE VOIT (étude 38, lot 4) — et c'est ici, pas ailleurs, que cela se prouve.
 *
 * Le service worker ne s'enregistre qu'en production (`import.meta.env.PROD`), et le
 * serveur de dev recharge ses modules à chaque navigation : seul CE étage exécute le
 * vrai worker sur le vrai bundle. Quatre temps, dans l'ordre où un élève les vit :
 *
 *  1. LA MISE À JOUR — un visiteur a l'ancien worker (`v1`) et son ancienne page de
 *     repli en cache ; le nouveau se déploie. Il doit prendre la main sans rechargement
 *     ni geste, purger l'ancien cache, et tenir la nouvelle page.
 *  2. LE BANDEAU — le réseau tombe : la coquille le dit.
 *  3. L'ATTENTE — une page dont la lecture ne peut pas partir dit « en attente du
 *     réseau » ; au retour, cet état s'efface sans rechargement. (Backend factice : le
 *     contenu, lui, n'arrivera pas — c'est l'état d'attente qu'on regarde partir.)
 *  4. LA PAGE DE REPLI — une navigation complète sans réseau rend `offline.html` :
 *     trois langues, zéro script.
 */
async function probeNetwork(browser) {
  const failures = [];
  const context = await browser.newContext();
  const page = await context.newPage();
  page.on("pageerror", (error) => failures.push(`pageerror: ${error.stack ?? error.message}`));

  const cacheKeys = () => page.evaluate(() => caches.keys());
  const waitForCaches = async (predicate, what) => {
    const deadline = Date.now() + 20_000;
    for (;;) {
      const keys = await cacheKeys();
      if (predicate(keys)) return keys;
      if (Date.now() > deadline) {
        failures.push(`${what} — caches: ${JSON.stringify(keys)}`);
        return keys;
      }
      await page.waitForTimeout(250);
    }
  };

  try {
    // --- 1. La mise à jour v1 → v2 --------------------------------------------
    const currentSw = await readFile(join(CLIENT_DIR, "sw.js"), "utf8");
    const version = currentSw.match(/const VERSION = "([^"]+)";/)?.[1];
    if (version !== "v2") failures.push(`sw.js VERSION is "${version}", expected "v2"`);
    swOverride = currentSw.replace(/const VERSION = "[^"]+";/, 'const VERSION = "v1";');

    await page.goto(ORIGIN + "/", { waitUntil: "load", timeout: 30_000 });
    await page.evaluate(() => navigator.serviceWorker.ready.then(() => undefined));
    await waitForCaches((keys) => keys.includes("xp-offline-v1"), "old worker never installed");

    swOverride = null;
    // Un rechargement efface ce marqueur ; une navigation client le garde. (L'événement
    // `framenavigated` ne les distingue pas : il part aussi sur un simple `pushState`.)
    const stillSameDocument = () => page.evaluate(() => window.__smokeDocument === true);
    await page.evaluate(() => {
      window.__smokeDocument = true;
    });
    await page.evaluate(() =>
      navigator.serviceWorker.getRegistration().then((registration) => registration?.update()),
    );
    await waitForCaches(
      (keys) => keys.includes("xp-offline-v2") && !keys.some((key) => key.endsWith("v1")),
      "new worker did not take over and purge the v1 caches",
    );
    if (!(await stillSameDocument())) failures.push("the worker update reloaded the page");

    const cachedFallback = await page.evaluate(async () => {
      const cache = await caches.open("xp-offline-v2");
      const hit = await cache.match("/offline.html");
      return hit ? hit.text() : null;
    });
    if (cachedFallback === null) failures.push("offline.html is not in the v2 cache");

    // --- 2. Le bandeau ---------------------------------------------------------
    // Le code de /programme entre en mémoire tant que le réseau est là (clic = navigation
    // client), puis retour à l'accueil : c'est la page « déjà connue » du temps 3.
    const banner = page.getByTestId("network-banner").first();
    await page.locator('header a[href="/programme"]').first().click();
    await page.waitForURL("**/programme", { timeout: 15_000 });
    await page.goBack();
    await page.waitForURL(ORIGIN + "/", { timeout: 15_000 });

    if ((await banner.innerText()).trim() !== "")
      failures.push("the network banner speaks while online");
    await context.setOffline(true);
    await banner
      .locator("div")
      .waitFor({ timeout: 5_000 })
      .catch(() => failures.push("offline: no network banner in the public shell"));

    // --- 3. L'attente, puis le retour -----------------------------------------
    await page.locator('header a[href="/programme"]').first().click();
    const waiting = page.getByTestId("waiting-for-network");
    await waiting
      .waitFor({ timeout: 10_000 })
      .catch(() => failures.push('offline: /programme does not say "waiting for the network"'));

    await context.setOffline(false);
    await waiting
      .waitFor({ state: "detached", timeout: 15_000 })
      .catch(() => failures.push("back online: the waiting state did not clear by itself"));
    await banner
      .locator("div")
      .waitFor({ state: "detached", timeout: 5_000 })
      .catch(() => failures.push("back online: the network banner stayed"));
    if (!(await stillSameDocument())) failures.push("coming back online reloaded the page");

    // --- 4. La page de repli ---------------------------------------------------
    await context.setOffline(true);
    await page.goto(ORIGIN + "/extras", { waitUntil: "load", timeout: 15_000 }).catch(() => {});
    const fallback = await page
      .evaluate(() => ({
        languages: [...document.querySelectorAll("section[lang]")].map(
          (section) => `${section.lang}:${section.dir}`,
        ),
        scripts: document.querySelectorAll("script").length,
        handlers: [...document.querySelectorAll("*")].filter((element) =>
          [...element.attributes].some((attribute) => attribute.name.startsWith("on")),
        ).length,
        retryLinks: document.querySelectorAll('a[href=""]').length,
      }))
      .catch(() => null);
    if (!fallback) failures.push("offline navigation: no fallback page rendered");
    else {
      if (fallback.languages.join(" ") !== "fr:ltr en:ltr ar:rtl")
        failures.push(
          `offline.html languages are [${fallback.languages}], expected fr, en, ar(rtl)`,
        );
      if (fallback.scripts + fallback.handlers > 0)
        failures.push("offline.html carries a script or an inline handler");
      if (fallback.retryLinks !== 3)
        failures.push("offline.html: one retry link per language expected");
    }
  } catch (error) {
    failures.push(`network probe crashed: ${error.stack ?? error.message}`);
  }

  swOverride = null;
  await context.close();
  return failures;
}

buildProdBundle();
Object.assign(process.env, DUMMY_ENV);
const worker = (await import(pathToFileURL(SERVER_ENTRY).href)).default;
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

// Le stockage refusé se joue sur l'accueil : la racine est commune à toutes les pages.
for (const storage of Object.keys(STORAGE_DENIAL)) {
  const failures = await probePage(browser, "/", PAGES["/"], storage);
  if (failures.length === 0) {
    console.log(`✔ / renders with storage ${storage} (#1307)`);
  } else {
    failed = true;
    console.error(`✖ / with storage ${storage} FAILED:`);
    for (const failure of failures) console.error(`    ${failure.split("\n").join("\n    ")}`);
  }
}

{
  const failures = await probeNetwork(browser);
  if (failures.length === 0) {
    console.log(
      "✔ network: worker v1 → v2 without reload, offline banner, waiting state, trilingual fallback",
    );
  } else {
    failed = true;
    console.error("✖ network (service worker + offline) FAILED:");
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

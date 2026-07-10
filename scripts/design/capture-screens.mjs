/**
 * Screen-capture harness for the UX refonte (études 14/15 — règle R-5).
 *
 * Screenshots every student/parent/admin-facing screen of the app against a
 * dev server bound to the TEST Supabase project, across a small
 * locale × viewport × theme matrix, and collects per-page console/page errors
 * into a manifest. Dynamic routes ($subjectId, $chapterId…) are discovered at
 * runtime by following real links, so the harness needs no hard-coded content
 * ids and works on any seeded TEST project.
 *
 * Prereqs (one-time per session):
 *   npm run e2e:setup                        # TEST db + seeded users
 *   npx playwright test --project=setup      # storage states in e2e/.auth/
 *   node scripts/design/dev-server-test.mjs  # dev server on :8080 (keep running)
 *
 * Run:
 *   node scripts/design/capture-screens.mjs --out <dir> [--base http://localhost:8080] [--only id1,id2]
 *
 * Output: <out>/<role>/<screen>--<variant>.png (+ `--fold.png` viewport shots
 * for key screens) and <out>/manifest.json (final URLs, redirects, errors).
 */
import { chromium, devices } from "@playwright/test";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";

// ---------------------------------------------------------------------------
// CLI args
// ---------------------------------------------------------------------------
const args = process.argv.slice(2);
function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 ? args[i + 1] : undefined;
}
const OUT_DIR = argValue("--out");
const BASE_URL = argValue("--base") ?? "http://localhost:8080";
const ONLY = argValue("--only")
  ?.split(",")
  .map((s) => s.trim());
if (!OUT_DIR) {
  console.error(
    "Usage: node scripts/design/capture-screens.mjs --out <dir> [--base <url>] [--only id1,id2]",
  );
  process.exit(1);
}

const STORAGE_STATE = {
  free: "e2e/.auth/free.json",
  premium: "e2e/.auth/premium.json",
  parent: "e2e/.auth/parent.json",
  admin: "e2e/.auth/admin.json",
};

// ---------------------------------------------------------------------------
// Matrix
// ---------------------------------------------------------------------------
const DESKTOP = { viewport: { width: 1280, height: 800 } };
const MOBILE = devices["Pixel 7"]; // 412×915, touch, mobile UA

/** Variants: locale is driven by the app cookie; theme cookie only when set
 *  (absent = the app default, `reference`). */
const VARIANTS = {
  "fr-desktop": { locale: "fr", theme: null, device: DESKTOP },
  "fr-mobile": { locale: "fr", theme: null, device: MOBILE },
  "ar-mobile": { locale: "ar", theme: null, device: MOBILE },
  "dark-desktop": { locale: "fr", theme: "dark", device: DESKTOP },
};

/**
 * Screens. `path` for static routes; `discover` follows the first link whose
 * href matches `href` on a source page (`from` = static path, or `fromId` =
 * another screen of the SAME role discovered earlier — order matters).
 * `fold: true` also saves a viewport-height shot per variant (above-the-fold
 * judgment: "l'action n°1 est-elle visible sans scroll ?").
 */
const SCREENS = [
  // ---- Public (anonymous) ----
  {
    id: "landing",
    role: "anon",
    path: "/",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile", "dark-desktop"],
    fold: true,
  },
  { id: "programme", role: "anon", path: "/programme", variants: ["fr-desktop", "ar-mobile"] },
  {
    id: "niveau",
    role: "anon",
    discover: { from: "/programme", href: /\/niveau\/[^/?#]+/ },
    variants: ["fr-desktop", "ar-mobile"],
  },
  {
    id: "matiere",
    role: "anon",
    discover: { fromId: "niveau", href: /\/matiere\/[^/?#]+/ },
    variants: ["fr-desktop", "ar-mobile"],
  },
  {
    id: "chapitre",
    role: "anon",
    discover: { fromId: "matiere", href: /\/chapitre\/[^/?#]+/ },
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
  },
  {
    id: "exercice-public",
    role: "anon",
    discover: { fromId: "chapitre", href: /\/exercice\/[^/?#]+/ },
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
    fold: true,
  },
  { id: "extras", role: "anon", path: "/extras", variants: ["fr-desktop", "ar-mobile"] },
  { id: "suivi", role: "anon", path: "/suivi", variants: ["fr-desktop", "ar-mobile"] },
  {
    id: "auth",
    role: "anon",
    path: "/auth",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile", "dark-desktop"],
  },
  { id: "login", role: "anon", path: "/login", variants: ["fr-desktop"] },
  { id: "signup", role: "anon", path: "/signup", variants: ["fr-desktop"] },

  // ---- Student (free = fresh account, free preview / gates visible) ----
  {
    id: "dashboard",
    role: "free",
    path: "/dashboard",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile", "dark-desktop"],
    fold: true,
  },
  // NB IA réelle (chantiers C8/L2.A) : /themes, /themes/$familyId, /lesson/$id et
  // /subject/$id sont des redirects 301 vers le registre public (/programme,
  // /chapitre/$id, /matiere/$id). Le hub matière et le lecteur de cours sont des
  // pages publiques PARTAGÉES ; connecté, le hub route les missions vers /quest/$id.
  {
    id: "programme-authed",
    role: "free",
    path: "/programme",
    variants: ["fr-desktop"],
  },
  {
    id: "parcours",
    role: "free",
    path: "/parcours",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
    fold: true,
  },
  {
    id: "matiere-authed",
    role: "free",
    discover: { from: "/parcours", href: /\/matiere\/[^/?#]+/ },
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
    fold: true,
  },
  {
    id: "chapitre-authed",
    role: "free",
    discover: { fromId: "matiere-authed", href: /\/chapitre\/[^/?#]+/ },
    variants: ["fr-desktop", "fr-mobile"],
  },
  {
    id: "quest-free",
    role: "free",
    discover: { fromId: "matiere-authed", href: /\/quest\/[^/?#]+/ },
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
    fold: true,
  },
  {
    id: "dungeon-free",
    role: "free",
    path: "/dungeon",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
  },
  { id: "duel", role: "free", path: "/duel", variants: ["fr-desktop", "fr-mobile", "ar-mobile"] },
  {
    id: "leaderboard",
    role: "free",
    path: "/leaderboard",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
  },

  // ---- Student (premium = entitlements, unlocked states) ----
  {
    id: "matiere-premium",
    role: "premium",
    discover: { from: "/parcours", href: /\/matiere\/[^/?#]+/ },
    variants: ["fr-desktop"],
  },
  {
    id: "quest-premium",
    role: "premium",
    discover: { fromId: "matiere-premium", href: /\/quest\/[^/?#]+/ },
    variants: ["fr-desktop"],
  },
  {
    id: "dungeon-premium",
    role: "premium",
    path: "/dungeon",
    variants: ["fr-desktop", "fr-mobile"],
  },

  // ---- Parent ----
  {
    id: "parent-report",
    role: "parent",
    path: "/parent-report",
    variants: ["fr-desktop", "fr-mobile", "ar-mobile"],
  },

  // ---- Admin (desktop FR only — internal tooling) ----
  {
    id: "admin-subscriptions",
    role: "admin",
    path: "/admin/subscriptions",
    variants: ["fr-desktop"],
  },
  {
    id: "admin-beta-requests",
    role: "admin",
    path: "/admin/beta-requests",
    variants: ["fr-desktop"],
  },
  {
    id: "admin-content-reports",
    role: "admin",
    path: "/admin/content-reports",
    variants: ["fr-desktop"],
  },
  { id: "admin-bug-reports", role: "admin", path: "/admin/bug-reports", variants: ["fr-desktop"] },
  {
    id: "admin-parcours-interest",
    role: "admin",
    path: "/admin/parcours-interest",
    variants: ["fr-desktop"],
  },
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
async function waitForServer(url, timeoutMs = 120_000) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    try {
      const res = await fetch(url, { redirect: "manual" });
      if (res.status > 0) return;
    } catch {
      await new Promise((r) => setTimeout(r, 1500));
    }
  }
  throw new Error(
    `No server responding at ${url}. Start it first: node scripts/design/dev-server-test.mjs`,
  );
}

function contextOptions(role, variant) {
  const opts = {
    ...variant.device,
    reducedMotion: "reduce",
    ignoreHTTPSErrors: true,
  };
  if (role !== "anon") {
    const state = STORAGE_STATE[role];
    if (!existsSync(state)) {
      throw new Error(`Missing ${state} — run: npx playwright test --project=setup`);
    }
    opts.storageState = state;
  }
  return opts;
}

async function newVariantContext(browser, role, variant) {
  const ctx = await browser.newContext(contextOptions(role, variant));
  const cookies = [{ name: "xp-scholars-locale", value: variant.locale, url: BASE_URL }];
  if (variant.theme)
    cookies.push({ name: "xp-scholars-theme", value: variant.theme, url: BASE_URL });
  await ctx.addCookies(cookies);
  return ctx;
}

async function settle(page) {
  await page.waitForLoadState("networkidle", { timeout: 12_000 }).catch(() => {});
  await page.waitForTimeout(700);
}

/** First internal href on `page` matching `re` (TanStack <Link> renders plain anchors). */
async function firstHref(page, re) {
  const hrefs = await page.$$eval("a[href]", (as) => as.map((a) => a.getAttribute("href")));
  for (const href of hrefs) {
    if (!href) continue;
    const path = href.replace(/^https?:\/\/[^/]+/, "");
    const m = path.match(re);
    if (m) return m[0];
  }
  return null;
}

// ---------------------------------------------------------------------------
// Run
// ---------------------------------------------------------------------------
const manifest = {
  baseUrl: BASE_URL,
  startedAt: new Date().toISOString(),
  captures: [],
  failures: [],
};
const outRoot = resolve(OUT_DIR);
mkdirSync(outRoot, { recursive: true });

console.log(`[captures] server check: ${BASE_URL}`);
await waitForServer(BASE_URL);

const browser = await chromium.launch();
const roles = [...new Set(SCREENS.map((s) => s.role))];

for (const role of roles) {
  const screens = SCREENS.filter((s) => s.role === role && (!ONLY || ONLY.includes(s.id)));
  const allRoleScreens = SCREENS.filter((s) => s.role === role); // discovery may be needed by --only'd screens
  if (screens.length === 0) continue;

  // -- discovery pass (fr-desktop context) --------------------------------
  const resolved = {};
  const discoCtx = await newVariantContext(browser, role, VARIANTS["fr-desktop"]);
  const discoPage = await discoCtx.newPage();
  for (const screen of allRoleScreens) {
    if (screen.path) {
      resolved[screen.id] = screen.path;
      continue;
    }
    const fromPath = screen.discover.from ?? resolved[screen.discover.fromId];
    if (!fromPath) {
      manifest.failures.push({
        id: screen.id,
        role,
        error: `discovery source unresolved (${screen.discover.fromId})`,
      });
      continue;
    }
    try {
      await discoPage.goto(BASE_URL + fromPath, { waitUntil: "domcontentloaded", timeout: 60_000 });
      await settle(discoPage);
      const found = await firstHref(discoPage, screen.discover.href);
      if (found) {
        resolved[screen.id] = found;
        console.log(`[discover] ${role}/${screen.id} → ${found}`);
      } else {
        manifest.failures.push({
          id: screen.id,
          role,
          error: `no link matching ${screen.discover.href} on ${fromPath}`,
        });
        console.warn(
          `[discover] ${role}/${screen.id}: no link matching ${screen.discover.href} on ${fromPath}`,
        );
      }
    } catch (e) {
      manifest.failures.push({ id: screen.id, role, error: `discovery failed: ${e.message}` });
    }
  }
  await discoCtx.close();

  // -- capture pass, grouped by variant (one context per role×variant) -----
  const variantIds = [...new Set(screens.flatMap((s) => s.variants))];
  for (const variantId of variantIds) {
    const variant = VARIANTS[variantId];
    const ctx = await newVariantContext(browser, role, variant);
    for (const screen of screens.filter((s) => s.variants.includes(variantId))) {
      const path = resolved[screen.id];
      if (!path) continue; // discovery failure already recorded
      const page = await ctx.newPage();
      const consoleErrors = [];
      const pageErrors = [];
      page.on(
        "console",
        (msg) => msg.type() === "error" && consoleErrors.push(msg.text().slice(0, 500)),
      );
      page.on("pageerror", (err) => pageErrors.push(String(err).slice(0, 500)));
      const t0 = Date.now();
      try {
        await page.goto(BASE_URL + path, { waitUntil: "domcontentloaded", timeout: 60_000 });
        await settle(page);
        const dir = join(outRoot, role);
        mkdirSync(dir, { recursive: true });
        const file = join(dir, `${screen.id}--${variantId}.png`);
        await page.screenshot({
          path: file,
          fullPage: true,
          animations: "disabled",
          caret: "hide",
          timeout: 30_000,
        });
        let foldFile = null;
        if (screen.fold) {
          foldFile = join(dir, `${screen.id}--${variantId}--fold.png`);
          await page.screenshot({
            path: foldFile,
            fullPage: false,
            animations: "disabled",
            caret: "hide",
            timeout: 30_000,
          });
        }
        const finalPath = new URL(page.url()).pathname;
        manifest.captures.push({
          id: screen.id,
          role,
          variant: variantId,
          path,
          finalPath,
          redirected: finalPath !== path,
          file,
          foldFile,
          consoleErrors,
          pageErrors,
          ms: Date.now() - t0,
        });
        const flags = [
          finalPath !== path ? `→ ${finalPath}` : "",
          pageErrors.length ? `⚠ ${pageErrors.length} pageerror` : "",
        ]
          .filter(Boolean)
          .join(" ");
        console.log(`[shot] ${role}/${screen.id}--${variantId} ${flags}`);
      } catch (e) {
        manifest.failures.push({
          id: screen.id,
          role,
          variant: variantId,
          error: e.message?.slice(0, 300),
        });
        console.warn(`[fail] ${role}/${screen.id}--${variantId}: ${e.message?.slice(0, 200)}`);
      } finally {
        await page.close();
      }
    }
    await ctx.close();
  }
}

await browser.close();
manifest.finishedAt = new Date().toISOString();

// Merge with a previous run's manifest (partial re-runs via --only must not
// erase earlier entries): this run's captures win on (role, id, variant).
const manifestPath = join(outRoot, "manifest.json");
if (existsSync(manifestPath)) {
  try {
    const prev = JSON.parse(readFileSync(manifestPath, "utf8"));
    const captureKey = (c) => `${c.role}/${c.id}--${c.variant}`;
    const shot = new Set(manifest.captures.map(captureKey));
    manifest.captures = [
      ...(prev.captures ?? []).filter((c) => !shot.has(captureKey(c))),
      ...manifest.captures,
    ];
    manifest.failures = [
      ...(prev.failures ?? []).filter((f) => !shot.has(`${f.role}/${f.id}--${f.variant ?? ""}`)),
      ...manifest.failures,
    ].filter(
      // a failure is resolved once ANY capture of that screen exists
      (f) => !manifest.captures.some((c) => c.role === f.role && c.id === f.id),
    );
  } catch {
    // unreadable previous manifest: overwrite
  }
}
writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));

const withErrors = manifest.captures.filter((c) => c.pageErrors.length || c.consoleErrors.length);
console.log(
  `\n[captures] done: ${manifest.captures.length} shots, ${manifest.failures.length} failures, ${withErrors.length} pages with console/page errors`,
);
console.log(`[captures] manifest: ${join(outRoot, "manifest.json")}`);
if (manifest.failures.length) process.exitCode = 2;

/**
 * Budget de perf RUNTIME — le garde-fou qui manquait (`docs/dette-technique.md`).
 *
 * `build:check` borne le poids de chaque chunk ; rien ne bornait ce qu'une page fait
 * RÉELLEMENT télécharger et attendre à un téléphone. Un chunk peut rester sous son plafond
 * pendant que la page en charge trois de plus : c'est ce que ce script voit, et lui seul.
 *
 * Ce qu'il fait : sert le bundle de PRODUCTION (`dist/`, fonction SSR + fichiers statiques
 * compressés en brotli comme le fait le CDN), charge chaque page de `budget.mjs` dans un
 * vrai Chromium bridé au profil téléphone de `measure-pages.mjs`, et compare au budget.
 *
 * Hermétique, comme `smoke:shell` dont il reprend le serveur : variables Supabase factices,
 * toute requête hors `localhost` refusée. Aucun secret, aucune base, aucun tiers — donc la
 * même réponse sur un poste, en CI et dans un conteneur.
 *
 * Stabilité — pourquoi ceci ne rend pas la CI capricieuse :
 *   • le POIDS et le NOMBRE DE REQUÊTES sont déterministes (mêmes octets à chaque passe) :
 *     plafonds serrés, c'est eux qui attrapent une régression ordinaire ;
 *   • le LCP dépend de la machine : médiane de 5 chargements, plafond large. Il n'attrape
 *     que la régression franche — un premier rendu qui se met à attendre le JavaScript.
 *
 * Usage :
 *   npm run perf:budget              # construit dist/ (env factice) puis mesure
 *   npm run perf:budget -- --no-build   # dist/ déjà construit (CI, après smoke:shell)
 */

import { spawnSync } from "node:child_process";
import http from "node:http";
import { readFile } from "node:fs/promises";
import { existsSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, extname, join, resolve } from "node:path";
import { pathToFileURL } from "node:url";
import { brotliCompressSync, constants as zlib } from "node:zlib";

import { BUDGETS, LCP_RUNS } from "./budget.mjs";
import { launchChromium, measurePage } from "./measure-pages.mjs";

const ROOT = resolve(import.meta.dirname, "../..");
const CLIENT_DIR = join(ROOT, "dist/client");
const SERVER_ENTRY = join(ROOT, "dist/server/index.js");
const PORT = 8131;
const ORIGIN = `http://localhost:${PORT}`;

const DUMMY_ENV = {
  VITE_SUPABASE_URL: "https://smoke-test.supabase.co",
  VITE_SUPABASE_PUBLISHABLE_KEY: "smoke-dummy-anon-key",
  SUPABASE_URL: "https://smoke-test.supabase.co",
  SUPABASE_PUBLISHABLE_KEY: "smoke-dummy-anon-key",
};

const MIME = {
  ".js": "text/javascript",
  ".css": "text/css",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".woff2": "font/woff2",
  ".webmanifest": "application/manifest+json",
  ".json": "application/json",
  ".html": "text/html; charset=utf-8",
};

/** Ce que le CDN compresse ; une police woff2 ou un PNG le sont déjà. */
const COMPRESSIBLE = /^(text\/|application\/(json|manifest\+json|javascript)|image\/svg)/;

function buildProdBundle() {
  console.log("▶ perf:budget — construction du bundle de production (env factice)…");
  const require = createRequire(import.meta.url);
  const vitePkgPath = require.resolve("vite/package.json");
  const viteBin = join(dirname(vitePkgPath), require(vitePkgPath).bin.vite);
  const res = spawnSync(process.execPath, [viteBin, "build"], {
    cwd: ROOT,
    stdio: "inherit",
    env: { ...process.env, ...DUMMY_ENV },
  });
  if (res.status !== 0) {
    console.error("✖ vite build a échoué — pas de mesure possible.");
    process.exit(1);
  }
}

/** Brotli au niveau maximal, mis en cache : un actif haché ne se compresse qu'une fois. */
const compressed = new Map();
function brotli(key, body) {
  if (key && compressed.has(key)) return compressed.get(key);
  const out = brotliCompressSync(body, {
    params: { [zlib.BROTLI_PARAM_QUALITY]: zlib.BROTLI_MAX_QUALITY },
  });
  if (key) compressed.set(key, out);
  return out;
}

function send(req, res, status, headers, body, cacheKey) {
  const type = String(headers["content-type"] ?? "");
  const acceptsBr = String(req.headers["accept-encoding"] ?? "").includes("br");
  if (acceptsBr && COMPRESSIBLE.test(type) && body.length > 512) {
    const out = brotli(cacheKey, body);
    res.writeHead(status, { ...headers, "content-encoding": "br", "content-length": out.length });
    return res.end(out);
  }
  res.writeHead(status, { ...headers, "content-length": body.length });
  return res.end(body);
}

function startServer(worker) {
  return new Promise((resolveStarted) => {
    const server = http.createServer(async (req, res) => {
      const url = new URL(req.url, ORIGIN);
      try {
        if (url.pathname.startsWith("/assets/") || extname(url.pathname)) {
          try {
            const body = await readFile(join(CLIENT_DIR, url.pathname));
            const type = MIME[extname(url.pathname)] ?? "application/octet-stream";
            return send(req, res, 200, { "content-type": type }, body, url.pathname);
          } catch {
            // Pas un fichier statique : la fonction SSR répond.
          }
        }
        const request = new Request(ORIGIN + req.url, { headers: { ...req.headers } });
        const response = await worker.fetch(request, {}, { waitUntil: () => {} });
        const headers = Object.fromEntries(response.headers);
        delete headers["content-length"];
        delete headers["content-encoding"];
        return send(req, res, response.status, headers, Buffer.from(await response.arrayBuffer()));
      } catch (error) {
        res.writeHead(500);
        res.end(String(error));
      }
    });
    server.listen(PORT, () => resolveStarted(server));
  });
}

const kb = (bytes) => bytes / 1024;
const fmt = (n, unit) =>
  `${unit === "ms" ? Math.round(n) : n.toFixed(unit ? 1 : 0)}${unit ? ` ${unit}` : ""}`;

/** Les grandeurs budgétées : [clé du budget, libellé, valeur lue sur la médiane, unité]. */
const METRICS = [
  ["requests", "requêtes", (m) => m.requests, ""],
  ["transferredKb", "transféré (br)", (m) => kb(m.transferred), "Ko"],
  ["jsKb", "JavaScript (br)", (m) => kb(m.js), "Ko"],
  ["htmlKb", "HTML (br)", (m) => kb(m.htmlEncoded), "Ko"],
  ["lcpMs", "LCP (profil téléphone)", (m) => m.lcp, "ms"],
];

if (!process.argv.includes("--no-build")) buildProdBundle();
if (!existsSync(SERVER_ENTRY)) {
  console.error("✖ perf:budget — dist/ absent : lancer sans --no-build, ou `npm run build` avant.");
  process.exit(1);
}
Object.assign(process.env, DUMMY_ENV);
const worker = (await import(pathToFileURL(SERVER_ENTRY).href)).default;
const server = await startServer(worker);
const browser = await launchChromium();

let failed = false;
try {
  for (const [path, budget] of Object.entries(BUDGETS)) {
    const { median, runs } = await measurePage(browser, ORIGIN + path, {
      runs: LCP_RUNS,
      pauseMs: 0,
      block: (url) => !url.startsWith(ORIGIN) && !url.startsWith("data:"),
      // Les appels de données n'ont pas de base en face : ils échouent puis se rejouent
      // selon l'horloge. Hors du compte — c'est le premier rendu qu'on borne ici.
      ignore: (url) => url.includes("/_serverFn/"),
    });
    if (median.status !== 200 || median.lcp == null) {
      failed = true;
      console.error(
        `✖ ${path} — la page n'a pas rendu (statut ${median.status}, LCP ${median.lcp}).`,
      );
      continue;
    }
    console.log(
      `\n${path}   LCP par passe : ${runs.map((r) => Math.round(r.lcp)).join(" / ")} ms — ${median.lcpElement}`,
    );
    for (const [key, label, read, unit] of METRICS) {
      const value = read(median);
      const max = budget[key];
      const ok = value <= max;
      if (!ok) failed = true;
      const share = ((value / max) * 100).toFixed(0);
      console.log(
        `  ${ok ? "✔" : "✖"} ${label.padEnd(24)} ${fmt(value, unit).padStart(10)}  /  ${fmt(max, unit).padStart(10)}   (${share} %)`,
      );
    }
  }
} finally {
  await browser.close();
  server.close();
}

if (failed) {
  console.error(
    "\n✖ perf:budget — une page publique dépasse son budget runtime.\n" +
      "  Ce n'est pas le plafond qu'il faut relever : chercher ce que la page s'est mise à\n" +
      "  charger ou à attendre (`node perf/runtime/measure-pages.mjs --detail`, perf/README.md).",
  );
  process.exit(1);
}
console.log("\n✔ perf:budget — les pages publiques tiennent leur budget runtime.");
process.exit(0);

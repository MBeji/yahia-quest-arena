/**
 * Mesure runtime d'une page, vue d'un téléphone bridé — la sonde de `docs/performance-audit.md`
 * §0-quater, et la moitié « mesure » du budget runtime (`perf/runtime/check-budget.mjs`).
 *
 * Ce qu'elle rend, par page, médiane de N chargements à CACHE FROID (un contexte neuf par
 * chargement) : TTFB, FCP, LCP, octets transférés (encodés, en-têtes compris), nombre de
 * requêtes, poids du HTML (encodé / décodé), du JS, du CSS, des polices.
 *
 * Profil par défaut — celui de Lighthouse mobile (« slow 4G ») : 150 ms de RTT,
 * 1,6 Mbit/s descendant, 750 kbit/s montant, processeur ralenti 4×, écran 360×740.
 * Ce n'est pas « la 4G tunisienne » : c'est un plancher REPRODUCTIBLE, le même à chaque
 * mesure, ce qui est la seule chose qu'on demande à un avant/après.
 *
 * Usage :
 *   node perf/runtime/measure-pages.mjs --base https://www.na9ranal3ab.tn \
 *     --page accueil=/ --page cours=/chapitre/<id> [--runs 3] [--json out.json]
 *
 * Lecture seule : des GET, avec un User-Agent de navigateur, espacés (`--pause`, 2 s par
 * défaut). Sur la prod, peu de pages et peu de passes — c'est un site réel.
 */

import { writeFile } from "node:fs/promises";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);

export const PHONE_PROFILE = {
  latencyMs: 150,
  downloadBps: (1.6 * 1024 * 1024) / 8,
  uploadBps: (750 * 1024) / 8,
  cpuSlowdown: 4,
  viewport: { width: 360, height: 740 },
  userAgent:
    "Mozilla/5.0 (Linux; Android 13; SM-A135F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36",
};

const median = (values) => {
  const sorted = values.filter((v) => typeof v === "number").sort((a, b) => a - b);
  if (sorted.length === 0) return null;
  const mid = Math.floor(sorted.length / 2);
  return sorted.length % 2 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
};

const kindOf = (mimeType, url) => {
  if (mimeType.includes("html")) return "html";
  if (mimeType.includes("javascript")) return "js";
  if (mimeType.includes("css")) return "css";
  if (mimeType.includes("font") || /\.woff2?(\?|$)/.test(url)) return "font";
  if (mimeType.startsWith("image/")) return "image";
  return "other";
};

/**
 * Un chargement à cache froid. `throttle: false` rend la même page sans bridage — c'est ce
 * qui isole le temps de réponse du serveur du débit simulé.
 */
export async function loadOnce(
  browser,
  url,
  { throttle = true, settleMs = 1500, block = null, ignore = null } = {},
) {
  const context = await browser.newContext({
    viewport: PHONE_PROFILE.viewport,
    userAgent: PHONE_PROFILE.userAgent,
    deviceScaleFactor: 2,
    isMobile: true,
    hasTouch: true,
    locale: "fr-FR",
  });
  const page = await context.newPage();
  // `block(url)` : refuser certaines requêtes (expérience « et sans tel script ? », ou
  // herméticité d'une mesure locale : aucun tiers, aucune base).
  if (block) {
    await page.route("**/*", (route) =>
      block(route.request().url()) ? route.abort() : route.continue(),
    );
  }
  const cdp = await context.newCDPSession(page);
  await cdp.send("Network.enable");
  if (throttle) {
    await cdp.send("Network.emulateNetworkConditions", {
      offline: false,
      latency: PHONE_PROFILE.latencyMs,
      downloadThroughput: PHONE_PROFILE.downloadBps,
      uploadThroughput: PHONE_PROFILE.uploadBps,
    });
    await cdp.send("Emulation.setCPUThrottlingRate", { rate: PHONE_PROFILE.cpuSlowdown });
  }

  const requests = new Map();
  cdp.on("Network.responseReceived", ({ requestId, response }) => {
    requests.set(requestId, {
      url: response.url,
      status: response.status,
      kind: kindOf(response.mimeType ?? "", response.url),
      encoded: 0,
      decoded: 0,
      cache: response.headers["x-vercel-cache"] ?? response.headers["X-Vercel-Cache"] ?? null,
    });
  });
  cdp.on("Network.dataReceived", ({ requestId, dataLength }) => {
    const entry = requests.get(requestId);
    if (entry) entry.decoded += dataLength;
  });
  cdp.on("Network.loadingFinished", ({ requestId, encodedDataLength }) => {
    const entry = requests.get(requestId);
    if (entry) entry.encoded = encodedDataLength;
  });

  await page.addInitScript(() => {
    window.__lcp = null;
    new PerformanceObserver((list) => {
      const entries = list.getEntries();
      const last = entries[entries.length - 1];
      window.__lcp = {
        time: last.startTime,
        size: last.size,
        tag: last.element?.tagName ?? null,
        text: (last.element?.textContent ?? "").trim().slice(0, 60),
        url: last.url || null,
      };
    }).observe({ type: "largest-contentful-paint", buffered: true });
  });

  const response = await page.goto(url, { waitUntil: "load", timeout: 120_000 });
  await page.waitForTimeout(settleMs);
  const timing = await page.evaluate(() => {
    const nav = performance.getEntriesByType("navigation")[0];
    const fcp = performance.getEntriesByName("first-contentful-paint")[0];
    return {
      ttfb: nav.responseStart,
      // Sans la résolution de nom ni la poignée de main : ce que la page coûte au serveur
      // (et au trajet), vu d'une connexion déjà ouverte.
      requestToFirstByte: nav.responseStart - nav.requestStart,
      domContentLoaded: nav.domContentLoadedEventEnd,
      load: nav.loadEventEnd,
      fcp: fcp ? fcp.startTime : null,
      lcp: window.__lcp,
    };
  });
  await context.close();

  // `ignore(url)` : sortir des comptes ce qui ne dépend pas de la page elle-même (les appels
  // de données d'une mesure hermétique, qui échouent et se rejouent selon l'horloge).
  const all = [...requests.values()].filter((r) => !ignore || !ignore(r.url));
  const sum = (kind, field) =>
    all.filter((r) => kind === "*" || r.kind === kind).reduce((n, r) => n + r[field], 0);
  const html = all.find((r) => r.kind === "html");
  return {
    status: response?.status() ?? 0,
    ttfb: timing.ttfb,
    requestToFirstByte: timing.requestToFirstByte,
    fcp: timing.fcp,
    lcp: timing.lcp?.time ?? null,
    lcpElement: timing.lcp ? `${timing.lcp.tag} « ${timing.lcp.text} »` : null,
    domContentLoaded: timing.domContentLoaded,
    load: timing.load,
    requests: all.length,
    transferred: sum("*", "encoded"),
    htmlEncoded: html?.encoded ?? 0,
    htmlDecoded: html?.decoded ?? 0,
    js: sum("js", "encoded"),
    css: sum("css", "encoded"),
    font: sum("font", "encoded"),
    cache: html?.cache ?? null,
    // Le détail par requête, pour `--detail` : qui pèse, dans quel ordre.
    detail: all.map((r) => ({ url: r.url, kind: r.kind, encoded: r.encoded, decoded: r.decoded })),
  };
}

const NUMERIC = [
  "ttfb",
  "requestToFirstByte",
  "fcp",
  "lcp",
  "domContentLoaded",
  "load",
  "requests",
  "transferred",
  "htmlEncoded",
  "htmlDecoded",
  "js",
  "css",
  "font",
];

export function summarize(runs) {
  const summary = {};
  for (const key of NUMERIC) summary[key] = median(runs.map((r) => r[key]));
  summary.lcpElement = runs[runs.length - 1].lcpElement;
  summary.cache = runs.map((r) => r.cache).join(",");
  summary.status = runs[runs.length - 1].status;
  return summary;
}

export async function launchChromium() {
  const { chromium } = require("playwright");
  const proxy = process.env.HTTPS_PROXY || process.env.https_proxy;
  // `PERF_CHROMIUM_PATH` : un Chromium déjà installé dont la version ne correspond pas au
  // Playwright du dépôt (conteneurs cloud). En CI, `npx playwright install chromium` suffit.
  const executablePath = process.env.PERF_CHROMIUM_PATH;
  return chromium.launch({
    ...(proxy ? { proxy: { server: proxy, bypass: "localhost,127.0.0.1" } } : {}),
    ...(executablePath ? { executablePath } : {}),
  });
}

export async function measurePage(browser, url, { runs = 3, pauseMs = 2000, ...options } = {}) {
  const results = [];
  for (let i = 0; i < runs; i += 1) {
    results.push(await loadOnce(browser, url, options));
    if (pauseMs) await new Promise((r) => setTimeout(r, pauseMs));
  }
  return { runs: results, median: summarize(results) };
}

const kb = (n) => (n == null ? "—" : (n / 1024).toFixed(1));
const ms = (n) => (n == null ? "—" : String(Math.round(n)));

export function toMarkdown(rows) {
  const lines = [
    "| Page | TTFB (ms) | FCP (ms) | LCP (ms) | Transféré (Ko) | Requêtes | HTML br / brut (Ko) | JS (Ko) | CSS (Ko) | Polices (Ko) | Élément LCP |",
    "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
  ];
  for (const { name, median: m } of rows) {
    lines.push(
      `| ${name} | ${ms(m.ttfb)} | ${ms(m.fcp)} | ${ms(m.lcp)} | ${kb(m.transferred)} | ${m.requests} | ${kb(m.htmlEncoded)} / ${kb(m.htmlDecoded)} | ${kb(m.js)} | ${kb(m.css)} | ${kb(m.font)} | ${m.lcpElement ?? "—"} |`,
    );
  }
  return lines.join("\n");
}

async function main() {
  const args = process.argv.slice(2);
  const take = (flag) => {
    const values = [];
    for (let i = 0; i < args.length; i += 1) if (args[i] === flag) values.push(args[i + 1]);
    return values;
  };
  const base = take("--base")[0];
  const pages = take("--page").map((spec) => {
    const eq = spec.indexOf("=");
    return { name: spec.slice(0, eq), path: spec.slice(eq + 1) };
  });
  if (!base || pages.length === 0) {
    console.error("usage: measure-pages.mjs --base <origin> --page nom=/chemin [...] [--runs 3]");
    process.exit(2);
  }
  const runs = Number(take("--runs")[0] ?? 3);
  const pauseMs = Number(take("--pause")[0] ?? 2000);
  const throttle = !args.includes("--no-throttle");
  const browser = await launchChromium();
  const rows = [];
  try {
    for (const { name, path } of pages) {
      const measured = await measurePage(browser, new URL(path, base).href, {
        runs,
        pauseMs,
        throttle,
      });
      rows.push({ name, path, ...measured });
      console.error(`✓ ${name} ${path}`);
    }
  } finally {
    await browser.close();
  }
  console.log(toMarkdown(rows));
  if (args.includes("--detail")) {
    for (const { name, runs: pageRuns } of rows) {
      console.log(`\n${name}`);
      for (const r of pageRuns[pageRuns.length - 1].detail) {
        console.log(
          `  ${kb(r.encoded).padStart(7)} / ${kb(r.decoded).padStart(7)} Ko  ${r.kind.padEnd(5)} ${r.url}`,
        );
      }
    }
  }
  const jsonPath = take("--json")[0];
  if (jsonPath) {
    await writeFile(
      jsonPath,
      JSON.stringify({ base, throttle, runs, profile: PHONE_PROFILE, rows }, null, 2),
    );
  }
}

if (import.meta.url === `file://${process.argv[1]}`) {
  await main();
}

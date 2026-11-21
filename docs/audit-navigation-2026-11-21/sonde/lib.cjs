// Sonde de navigation — voir README.md. Lecture seule : aucun compte, aucune écriture.
const { chromium } = require("playwright");
require("node:fs").mkdirSync("captures", { recursive: true });
const ORIGIN = process.env.ORIGIN || "http://127.0.0.1:5198";
const UA_PHONE =
  "Mozilla/5.0 (Linux; Android 13; SM-A536B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36";
const UA_DESKTOP =
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36";
const VIEWPORTS = {
  phone: {
    viewport: { width: 360, height: 780 },
    userAgent: UA_PHONE,
    hasTouch: true,
    isMobile: true,
    deviceScaleFactor: 1,
  },
  phone412: {
    viewport: { width: 412, height: 892 },
    userAgent: UA_PHONE,
    hasTouch: true,
    isMobile: true,
    deviceScaleFactor: 1,
  },
  tablet: {
    viewport: { width: 820, height: 1180 },
    userAgent: UA_PHONE.replace("Mobile ", ""),
    hasTouch: true,
    deviceScaleFactor: 1,
  },
  lgxl: { viewport: { width: 1100, height: 800 }, userAgent: UA_DESKTOP, deviceScaleFactor: 1 },
  laptop: { viewport: { width: 1280, height: 800 }, userAgent: UA_DESKTOP, deviceScaleFactor: 1 },
  desktop: { viewport: { width: 1440, height: 900 }, userAgent: UA_DESKTOP, deviceScaleFactor: 1 },
};
async function launch() {
  // CHROMIUM_PATH : un Chromium déjà installé, quand celui du Playwright du dépôt ne l'est pas.
  return chromium.launch(
    process.env.CHROMIUM_PATH ? { executablePath: process.env.CHROMIUM_PATH } : {},
  );
}
async function newContext(browser, vp, extra = {}) {
  const ctx = await browser.newContext({ ...VIEWPORTS[vp], locale: "fr-FR", ...extra });
  // Never let analytics leave this machine.
  await ctx.route(/googletagmanager|google-analytics|posthog|sentry/i, (r) => r.abort());
  return ctx;
}
/** What navigation chrome is visible right now. */
async function chrome(page) {
  return page.evaluate(() => {
    const vis = (el) => {
      if (!el) return false;
      const r = el.getBoundingClientRect();
      const s = getComputedStyle(el);
      return r.width > 0 && r.height > 0 && s.visibility !== "hidden" && s.display !== "none";
    };
    const links = (root) =>
      [...root.querySelectorAll("a[href]")]
        .filter(vis)
        .map(
          (a) =>
            `${(a.textContent || "").trim().replace(/\s+/g, " ").slice(0, 28)}→${a.getAttribute("href")}${a.getAttribute("aria-current") === "page" || a.dataset.status === "active" ? " *" : ""}`,
        );
    const header = document.querySelector("header");
    const tab = document.querySelector('[data-testid="student-tab-bar"]');
    return {
      url: location.pathname + location.search,
      title: document.title,
      header: header ? links(header) : null,
      headerH: header ? Math.round(header.getBoundingClientRect().height) : 0,
      tabBar: tab && vis(tab) ? links(tab) : null,
      hud: vis(document.querySelector('[data-testid="account-hud"]')),
      h1: (document.querySelector("h1")?.textContent || "").trim().slice(0, 60),
      back: [...document.querySelectorAll("main a")]
        .filter(vis)
        .filter((a) => a.querySelector("svg.lucide-arrow-left"))
        .map((a) => `${a.textContent.trim().slice(0, 30)}→${a.getAttribute("href")}`),
    };
  });
}
module.exports = { ORIGIN, VIEWPORTS, launch, newContext, chrome };

const { ORIGIN, launch } = require("./lib.cjs");
const { signInAs } = require("./session-simulee.cjs");
(async () => {
  const browser = await launch();
  const rows = [];
  for (const locale of ["fr", "ar"]) {
    for (const stats of [
      { xp: 0, current_streak: 0 },
      { xp: 950, current_streak: 12 },
      { xp: 1234, current_streak: 3 },
      { xp: 123456, current_streak: 120 },
    ]) {
      for (const width of [320, 360, 375, 390, 412]) {
        // NOT isMobile: the layout viewport stays at the device width, so an overflow is measurable.
        const ctx = await browser.newContext({
          viewport: { width, height: 780 },
          hasTouch: true,
          userAgent:
            "Mozilla/5.0 (Linux; Android 13; SM-A536B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36",
        });
        await ctx.route(/googletagmanager|google-analytics|posthog|sentry/i, (r) => r.abort());
        if (locale === "ar")
          await ctx.addCookies([{ name: "xp-scholars-locale", value: "ar", url: ORIGIN }]);
        await signInAs(ctx, { role: "student", ...stats });
        const page = await ctx.newPage();
        if (locale === "ar")
          await page.addInitScript(() => localStorage.setItem("xp-scholars-locale", "ar"));
        await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle", timeout: 120000 });
        await page
          .waitForSelector('[data-testid="account-hud"]', { timeout: 15000 })
          .catch(() => {});
        await page.waitForTimeout(600);
        const m = await page.evaluate(() => {
          const de = document.documentElement;
          const hdrRow = document.querySelector("[data-public-header] > div");
          const hud = document.querySelector('[data-testid="account-hud"]');
          return {
            lang: de.lang,
            clientW: de.clientWidth,
            scrollW: de.scrollWidth,
            rowScrollW: hdrRow?.scrollWidth,
            hudW: hud ? Math.round(hud.getBoundingClientRect().width) : null,
            hudRight: hud ? Math.round(hud.getBoundingClientRect().right) : null,
            hudLeft: hud ? Math.round(hud.getBoundingClientRect().left) : null,
            hudText: hud?.textContent,
          };
        });
        rows.push(
          `${m.lang} xp=${String(stats.xp).padEnd(6)} w=${width}  doc ${m.clientW}/${m.scrollW}  overflow=${m.scrollW - m.clientW}px  hud ${m.hudLeft}..${m.hudRight} (${m.hudW}px) "${m.hudText}"`,
        );
        if (width === 360 && stats.xp === 1234)
          await page.screenshot({ path: `captures/overflow-${locale}-360.png` });
        await ctx.close();
      }
    }
  }
  console.log(rows.join("\n"));
  await browser.close();
})().catch((e) => {
  console.error(e);
  process.exit(1);
});

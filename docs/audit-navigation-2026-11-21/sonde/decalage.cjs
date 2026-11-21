const { ORIGIN, launch, newContext } = require("./lib.cjs");
const { signInAs } = require("./session-simulee.cjs");
(async () => {
  const browser = await launch();
  const ctx = await newContext(browser, "phone412");
  await signInAs(ctx, { role: "student" });
  await ctx.addInitScript(() => {
    window.__ls = [];
    try {
      new PerformanceObserver((l) => {
        for (const e of l.getEntries())
          window.__ls.push({
            t: Math.round(e.startTime),
            v: +e.value.toFixed(3),
            input: e.hadRecentInput,
            src: (e.sources || []).slice(0, 3).map((s) => {
              const n = s.node;
              return n && n.nodeType === 1
                ? `${n.tagName.toLowerCase()}${n.dataset?.testid ? "[" + n.dataset.testid + "]" : ""}.${String(n.className).split(" ").slice(0, 2).join(".")} ${Math.round(s.previousRect.y)}→${Math.round(s.currentRect.y)}`
                : "?";
            }),
          });
      }).observe({ type: "layout-shift", buffered: true });
    } catch {}
  });
  const page = await ctx.newPage();
  await page.goto(ORIGIN + "/arene", { waitUntil: "networkidle" });
  await page.waitForTimeout(2000);
  const t0 = await page.evaluate(() => Math.round(performance.now()));
  await page.locator('[data-testid="student-tab-bar"] a[href="/programme"]').click();
  await page.waitForTimeout(4000);
  const ls = await page.evaluate(
    (t0) => window.__ls.filter((e) => e.t >= t0).map((e) => ({ ...e, t: e.t - t0 })),
    t0,
  );
  console.log(JSON.stringify(ls, null, 1));
  await browser.close();
})().catch((e) => {
  console.error(String(e).split("\n")[0]);
  process.exit(1);
});

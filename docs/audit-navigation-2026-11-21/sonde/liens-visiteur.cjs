const { ORIGIN, launch, newContext } = require("./lib.cjs");
const { signInAs } = require("./session-simulee.cjs");
(async () => {
  const browser = await launch();
  for (const slow of [false, true]) {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student" });
    await ctx.addInitScript(() => {
      window.__w = [];
      let last = "";
      const tick = () => {
        const ex = document.querySelectorAll('main a[href^="/exercice/"]').length,
          q = document.querySelectorAll('main a[href^="/quest/"]').length;
        const s = `exercice:${ex} quest:${q}`;
        if (s !== last) {
          last = s;
          window.__w.push(`${Math.round(performance.now())}ms ${s}`);
        }
        requestAnimationFrame(tick);
      };
      document.addEventListener("DOMContentLoaded", () => requestAnimationFrame(tick));
    });
    const page = await ctx.newPage();
    if (slow) {
      const cdp = await ctx.newCDPSession(page);
      await cdp.send("Network.enable");
      await cdp.send("Network.emulateNetworkConditions", {
        offline: false,
        latency: 150,
        downloadThroughput: 1.6e6 / 8,
        uploadThroughput: 750e3 / 8,
      });
      await cdp.send("Emulation.setCPUThrottlingRate", { rate: 4 });
    }
    await page.goto(ORIGIN + "/matiere/math-7eme", {
      waitUntil: "domcontentloaded",
      timeout: 120000,
    });
    await page.waitForTimeout(slow ? 14000 : 5000);
    console.log(
      slow ? "téléphone de référence (÷4, 1,6 Mbit/s) :" : "sans bridage :",
      (await page.evaluate(() => window.__w)).join("  →  "),
    );
    await ctx.close();
  }
  await browser.close();
})().catch((e) => {
  console.error(String(e).split("\n")[0]);
  process.exit(1);
});

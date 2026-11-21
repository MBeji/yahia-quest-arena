const { ORIGIN, launch, newContext } = require("./lib.cjs");
(async () => {
  const browser = await launch();
  const ctx = await newContext(browser, "phone412");
  const page = await ctx.newPage();
  await page.goto(ORIGIN + "/matiere/math-7eme", { waitUntil: "networkidle" });
  await page.waitForTimeout(1500);
  // The network drops for the app's own calls AFTER the page is loaded (tunnel, lift, bad 3G).
  await ctx.route(/\/_serverFn\//, (r) => r.abort("failed"));
  const link = page.locator('main a[href^="/exercice/"]').first();
  console.log("lien tapé :", await link.getAttribute("href"));
  await link.click();
  for (const s of [3, 12, 30]) {
    await page.waitForTimeout(s === 3 ? 3000 : s === 12 ? 9000 : 18000);
    const st = await page.evaluate(() => ({
      url: location.pathname.slice(0, 20),
      main: (document.querySelector("main")?.innerText || "")
        .trim()
        .replace(/\s+/g, " ")
        .slice(0, 80),
      actions: [...document.querySelectorAll("main a[href], main button")].map((e) =>
        e.textContent.trim().slice(0, 20),
      ),
    }));
    console.log(`à ${s} s :`, JSON.stringify(st));
  }
  await page.screenshot({ path: "captures/exercice-preparation-sans-fin.png" });
  await browser.close();
})().catch((e) => {
  console.error(String(e).split("\n")[0]);
  process.exit(1);
});

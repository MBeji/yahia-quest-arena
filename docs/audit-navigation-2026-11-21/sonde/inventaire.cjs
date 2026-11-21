const { ORIGIN, launch, newContext, chrome } = require("./lib.cjs");
const { signInAs } = require("./session-simulee.cjs");
const show = (label, c) => {
  console.log(`\n[${label}] ${c.url}  h1="${c.h1}"`);
  console.log(`   en-tête (${c.headerH}px) : ${c.header ? c.header.join(" ; ") : "aucun"}`);
  console.log(
    `   onglets : ${c.tabBar ? c.tabBar.join(" ; ") : "aucun"} | retour : ${c.back.join(" ; ") || "aucun"}`,
  );
};
(async () => {
  const browser = await launch();
  for (const [role, vps] of [
    ["student", ["tablet", "lgxl", "laptop", "desktop"]],
    ["parent", ["phone412", "desktop"]],
  ]) {
    for (const vp of vps) {
      const ctx = await newContext(browser, vp);
      await signInAs(ctx, { role, ...(role === "parent" ? { current_parcours_id: null } : {}) });
      const page = await ctx.newPage();
      await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle", timeout: 120000 });
      await page.waitForTimeout(1200);
      show(`${role} · ${vp} (${page.viewportSize().width}px)`, await chrome(page));
      if (role === "student" && (vp === "laptop" || vp === "lgxl")) {
        await page.screenshot({ path: `captures/student-${vp}-programme.png` });
        await page.locator('main a[href^="/niveau/"]').nth(6).click();
        await page.waitForURL(/\/niveau\//);
        await page.waitForTimeout(1500);
        show(`${role} · ${vp}`, await chrome(page));
        await page.locator('main a[href^="/matiere/"]').first().click();
        await page.waitForURL(/\/matiere\//);
        await page.waitForTimeout(2500);
        show(`${role} · ${vp}`, await chrome(page));
        const chap = page.locator('main a[href^="/chapitre/"]').first();
        if (await chap.count()) {
          await chap.click();
          await page.waitForURL(/\/chapitre\//);
          await page.waitForTimeout(2500);
          show(`${role} · ${vp}`, await chrome(page));
          await page.screenshot({ path: `captures/student-${vp}-chapitre.png` });
        }
        await page.goto(ORIGIN + "/dashboard", { waitUntil: "domcontentloaded" });
        await page.waitForTimeout(2500);
        show(`${role} · ${vp}`, await chrome(page));
        await page.screenshot({ path: `captures/student-${vp}-dashboard.png` });
      }
      await ctx.close();
    }
  }
  // signed-in student on the landing and on a 404
  const ctx = await newContext(browser, "phone412");
  await signInAs(ctx, { role: "student" });
  const page = await ctx.newPage();
  await page.goto(ORIGIN + "/?src=pwa", { waitUntil: "networkidle" });
  await page.waitForTimeout(1500);
  show("élève connecté · accueil (start_url de la PWA)", await chrome(page));
  await page.screenshot({ path: "captures/student-phone-landing.png" });
  await page.goto(ORIGIN + "/page-qui-n-existe-pas", { waitUntil: "networkidle" });
  await page.waitForTimeout(1000);
  const nf = await page.evaluate(() => ({
    links: [...document.querySelectorAll("a[href]")].map(
      (a) => `${a.textContent.trim()}→${a.getAttribute("href")}`,
    ),
    header: !!document.querySelector("header"),
    tab: !!document.querySelector('[data-testid="student-tab-bar"]'),
  }));
  console.log("\n[élève connecté · 404]", JSON.stringify(nf));
  await ctx.close();
  await browser.close();
})().catch((e) => {
  console.error(e);
  process.exit(1);
});

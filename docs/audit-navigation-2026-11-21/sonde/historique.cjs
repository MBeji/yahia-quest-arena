const { ORIGIN, launch, newContext } = require("./lib.cjs");
const { signInAs, installRecorder, mark, since } = require("./session-simulee.cjs");
const only = process.argv[2];
const urlLog = async (page, ms = 2500) => {
  const seen = [];
  const t0 = Date.now();
  let last = "";
  while (Date.now() - t0 < ms) {
    const u = new URL(page.url());
    const p = u.pathname + u.search;
    if (p !== last) {
      seen.push(`+${Date.now() - t0}ms ${p}`);
      last = p;
    }
    await page.waitForTimeout(40);
  }
  return seen;
};
const hist = (page) => page.evaluate(() => history.length);
const run = async (name, fn) => {
  if (only && only !== name) return;
  console.log(`\n================ ${name}`);
  const browser = await launch();
  try {
    await fn(browser);
  } catch (e) {
    console.log("  !! " + String(e).split("\n")[0]);
  }
  await browser.close();
};
(async () => {
  await run("C1 visiteur → lien protégé → Retour", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    console.log("  départ /programme, history.length =", await hist(page));
    await page.goto(ORIGIN + "/parcours", { waitUntil: "domcontentloaded" });
    console.log(
      "  ouvre /parcours :",
      (await urlLog(page, 3000)).join("  →  "),
      "| history.length =",
      await hist(page),
    );
    for (let i = 1; i <= 3; i++) {
      await page.goBack({ waitUntil: "commit" }).catch(() => {});
      console.log(
        `  Retour n°${i} :`,
        (await urlLog(page, 2500)).join("  →  "),
        "| history.length =",
        await hist(page),
      );
    }
  });
  await run("C2 visiteur chapitre → Connexion → Retour", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    await page.locator('a[href^="/niveau/"]').first().click();
    await page.waitForURL(/\/niveau\//);
    const start = new URL(page.url()).pathname;
    await page
      .locator('[data-testid="header-login-phone"]:visible, [data-testid="header-login"]:visible')
      .first()
      .click();
    console.log(`  depuis ${start}, tap Connexion :`, (await urlLog(page, 2500)).join("  →  "));
    console.log(
      "  returnTo mémorisé :",
      await page.evaluate(() => localStorage.getItem("na9ra.returnTo.v1")),
    );
    await page.goBack({ waitUntil: "commit" });
    console.log("  Retour :", (await urlLog(page, 2000)).join("  →  "));
  });
  await run("C3 connexion depuis une page de contenu, puis Retour", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student" }, [], { seed: false });
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    await page.locator('a[href^="/niveau/"]').first().click();
    await page.waitForURL(/\/niveau\//);
    const start = new URL(page.url()).pathname;
    await page
      .locator('[data-testid="header-login-phone"]:visible, [data-testid="header-login"]:visible')
      .first()
      .click();
    await page.waitForSelector("#auth-email");
    await page.fill("#auth-email", "probe@example.invalid");
    await page.fill("#auth-password", "probe-password");
    await page.locator('form button[type="submit"]').click();
    console.log(
      `  depuis ${start}, connexion :`,
      (await urlLog(page, 3500)).join("  →  "),
      "| history.length =",
      await hist(page),
    );
    for (let i = 1; i <= 2; i++) {
      await page.goBack({ waitUntil: "commit" }).catch(() => {});
      console.log(`  Retour n°${i} :`, (await urlLog(page, 3000)).join("  →  "));
    }
  });
  await run("C4 parent : /dashboard → rebond → Retour", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "parent", current_parcours_id: null });
    await installRecorder(ctx);
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    await page.waitForTimeout(1500);
    const m = await mark(page);
    await page.locator("[data-public-header] a").first().click();
    console.log(
      "  tap sur la marque (en-tête public) :",
      (await urlLog(page, 12000)).join("  →  "),
    );
    console.log("  " + (await since(page, m)).steps.join("\n  "));
    await page.goBack({ waitUntil: "commit" }).catch(() => {});
    console.log("  Retour :", (await urlLog(page, 12000)).join("  →  "));
  });
  await run("C5 élève sans parcours : Hall → onboarding → Retour", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student", current_parcours_id: null });
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    await page.waitForTimeout(1500);
    await page.locator('[data-testid="student-tab-bar"] a[href="/dashboard"]').click();
    console.log("  tap Hall :", (await urlLog(page, 3000)).join("  →  "));
    for (let i = 1; i <= 2; i++) {
      await page.goBack({ waitUntil: "commit" }).catch(() => {});
      console.log(`  Retour n°${i} :`, (await urlLog(page, 3000)).join("  →  "));
    }
  });
  await run("C6 déconnexion depuis la coquille connectée", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student" });
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/arene", { waitUntil: "networkidle" });
    await page.waitForTimeout(1500);
    await page.locator('[data-testid="settings-trigger"]').click();
    await page.locator('[data-testid="settings-menu"] button').last().click();
    console.log("  Déconnexion :", (await urlLog(page, 4000)).join("  →  "));
    console.log(
      "  returnTo mémorisé :",
      await page.evaluate(() => localStorage.getItem("na9ra.returnTo.v1")),
    );
    await page.goBack({ waitUntil: "commit" }).catch(() => {});
    console.log("  Retour :", (await urlLog(page, 3000)).join("  →  "));
  });
  await run("C7 déconnexion sur place (coquille publique)", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student" });
    await installRecorder(ctx);
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    await page.waitForTimeout(1500);
    const m = await mark(page);
    await page.locator('[data-testid="settings-trigger"]').click();
    await page.locator('[data-testid="settings-menu"] button').last().click();
    console.log("  Déconnexion :", (await urlLog(page, 3000)).join("  →  "));
    console.log("  " + (await since(page, m)).steps.join("\n  "));
  });
})();

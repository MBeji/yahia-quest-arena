const { ORIGIN, launch, newContext, chrome } = require("./lib.cjs");
const { signInAs, installRecorder, mark, since } = require("./session-simulee.cjs");
const only = process.argv[2];
const run = async (name, fn) => {
  if (only && !name.startsWith(only)) return;
  console.log(`\n================ ${name}`);
  const browser = await launch();
  try {
    await fn(browser);
  } catch (e) {
    console.log("  !! " + String(e).split("\n")[0]);
  }
  await browser.close();
};
// The reference phone of the 2026-11-12 survey: CPU x4, 1.6 Mbit/s down, 750 kbit/s up, 150 ms.
async function throttle(page) {
  const cdp = await page.context().newCDPSession(page);
  await cdp.send("Network.enable");
  await cdp.send("Network.emulateNetworkConditions", {
    offline: false,
    latency: 150,
    downloadThroughput: 1.6e6 / 8,
    uploadThroughput: 750e3 / 8,
  });
  await cdp.send("Emulation.setCPUThrottlingRate", { rate: 4 });
  return cdp;
}
/** Tap, then time: the first change inside <main>, and the arrival of the new screen's heading. */
async function timedTap(page, locator, label) {
  const js = [];
  const onReq = (r) => {
    if (/\.js(\?|$)/.test(r.url())) js.push(r);
  };
  page.on("requestfinished", onReq);
  const before = await page.evaluate(() => {
    window.__t0 = 0;
    window.__firstMut = 0;
    const main = document.querySelector("main") || document.body;
    const h = (document.querySelector("h1")?.textContent || "").trim();
    const obs = new MutationObserver(() => {
      if (!window.__firstMut && window.__t0) window.__firstMut = performance.now();
    });
    obs.observe(main, { childList: true, subtree: true, characterData: true });
    window.__obs = obs;
    return { h, path: location.pathname };
  });
  await page.evaluate(() => {
    window.__t0 = performance.now();
  });
  const t0 = Date.now();
  await locator.click({ noWaitAfter: true });
  let tUrl = null,
    tH1 = null,
    h1 = before.h;
  while (Date.now() - t0 < 15000) {
    const s = await page.evaluate(() => ({
      p: location.pathname,
      h: (document.querySelector("h1")?.textContent || "").trim(),
      fm: window.__firstMut ? Math.round(window.__firstMut - window.__t0) : null,
    }));
    if (tUrl === null && s.p !== before.path) tUrl = Date.now() - t0;
    if (
      s.fm !== null &&
      (s.h !== before.h || s.p !== before.path) &&
      tH1 === null &&
      s.h !== before.h &&
      s.h
    ) {
      tH1 = Date.now() - t0;
      h1 = s.h;
    }
    if (tH1 !== null) {
      var fm = s.fm;
      break;
    }
    var fm = s.fm;
    await page.waitForTimeout(25);
  }
  await page.waitForTimeout(400);
  page.off("requestfinished", onReq);
  let bytes = 0;
  for (const r of js) {
    try {
      const sz = await r.sizes();
      bytes += sz.responseBodySize;
    } catch {}
  }
  console.log(
    `  ${label.padEnd(34)} adresse +${tUrl ?? "—"} ms · 1er changement à l'écran +${fm ?? "—"} ms · nouveau titre +${tH1 ?? "—"} ms ("${String(h1).slice(0, 22)}") · JS chargé au tap : ${js.length} fichier(s), ${(bytes / 1024).toFixed(1)} ko`,
  );
}
(async () => {
  await run("F4a visiteur, réseau lent — premier passage puis second", async (browser) => {
    for (const pass of ["1er passage (rien en cache)", "2e passage (tout en cache)"]) {
      const ctx = await newContext(browser, "phone412");
      const page = await ctx.newPage();
      await throttle(page);
      if (pass.startsWith("2e")) {
        // warm every chunk first, same context
        await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle", timeout: 120000 });
        await page.locator('main a[href="/niveau/ecole-7eme-base"]').click();
        await page.waitForSelector('main a[href^="/matiere/"]', { timeout: 60000 });
        await page.locator('main a[href^="/matiere/"]').first().click();
        await page.waitForSelector('main a[href^="/chapitre/"]', { timeout: 60000 });
        await page.locator('main a[href^="/chapitre/"]').first().click();
        await page.waitForTimeout(6000);
      }
      console.log(` — ${pass}`);
      await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle", timeout: 120000 });
      await page.waitForTimeout(1500);
      await timedTap(
        page,
        page.locator('main a[href="/niveau/ecole-7eme-base"]'),
        "Programme → Niveau",
      );
      await page.waitForSelector('main a[href^="/matiere/"]', { timeout: 60000 });
      await page.waitForTimeout(1200);
      await timedTap(page, page.locator('main a[href^="/matiere/"]').first(), "Niveau → Matière");
      await page.waitForSelector('main a[href^="/chapitre/"]', { timeout: 60000 });
      await page.waitForTimeout(1200);
      await timedTap(
        page,
        page.locator('main a[href^="/chapitre/"]').first(),
        "Matière → Chapitre",
      );
      await ctx.close();
    }
  });
  await run("F4b élève connecté, réseau lent — onglets", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student" });
    await installRecorder(ctx);
    const page = await ctx.newPage();
    await throttle(page);
    await page.goto(ORIGIN + "/dashboard", { waitUntil: "domcontentloaded", timeout: 120000 });
    await page.waitForTimeout(9000);
    for (const pass of ["1er passage", "2e passage"]) {
      console.log(` — ${pass}`);
      for (const [label, href] of [
        ["Hall → Arène", "/arene"],
        ["Arène → Découvrir (bascule)", "/programme"],
        ["Découvrir → Hall (bascule)", "/dashboard"],
      ]) {
        const m = await mark(page);
        await page
          .locator(`[data-testid="student-tab-bar"] a[href="${href}"]`)
          .click({ noWaitAfter: true });
        await page.waitForTimeout(4500);
        const r = await since(page, m);
        console.log(`  ${label}\n     ` + r.steps.join("\n     "));
      }
    }
  });
  await run("F3 quête dont la lecture échoue (écran immersif)", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    await signInAs(ctx, { role: "student" });
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/quest/37aad97c-67f2-5723-9a72-e44c58aae8a5", {
      waitUntil: "domcontentloaded",
    });
    for (const s of [5, 15, 30]) {
      await page.waitForTimeout(s === 5 ? 5000 : s === 15 ? 10000 : 15000);
      const st = await page.evaluate(() => ({
        main: (document.querySelector("main")?.innerText || "")
          .trim()
          .replace(/\s+/g, " ")
          .slice(0, 90),
        links: [...document.querySelectorAll("main a[href], main button")].map((e) =>
          e.textContent.trim().slice(0, 20),
        ),
        tab: !!document.querySelector('[data-testid="student-tab-bar"]'),
      }));
      console.log(`  à ${s} s :`, JSON.stringify(st));
    }
    await page.screenshot({ path: "captures/quest-preparation-sans-fin.png" });
  });
  await run("F5 restauration du défilement au Retour (visiteur)", async (browser) => {
    const ctx = await newContext(browser, "phone412");
    const page = await ctx.newPage();
    await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
    const link = page.locator('main a[href^="/niveau/"]').nth(8);
    await link.scrollIntoViewIfNeeded();
    await page.waitForTimeout(400);
    const y0 = await page.evaluate(() => Math.round(scrollY));
    await link.click();
    await page.waitForURL(/\/niveau\//);
    await page.waitForTimeout(1500);
    const yNiveau = await page.evaluate(() => Math.round(scrollY));
    const active = await page.evaluate(
      () =>
        `${document.activeElement?.tagName}${document.activeElement?.getAttribute?.("href") ? " " + document.activeElement.getAttribute("href") : ""}`,
    );
    await page.goBack();
    await page.waitForTimeout(1500);
    const y1 = await page.evaluate(() => Math.round(scrollY));
    console.log(
      `  /programme défilé à ${y0}px → /niveau arrive à ${yNiveau}px (focus après navigation : ${active}) → Retour : ${y1}px`,
    );
    // deeper: matière → chapitre → back
    await page.goto(ORIGIN + "/matiere/math-7eme", { waitUntil: "networkidle" });
    await page.waitForTimeout(1500);
    const chap = page.locator('main a[href^="/chapitre/"]').nth(3);
    await chap.scrollIntoViewIfNeeded();
    await page.waitForTimeout(400);
    const m0 = await page.evaluate(() => Math.round(scrollY));
    await chap.click();
    await page.waitForURL(/\/chapitre\//);
    await page.waitForTimeout(2000);
    await page.goBack();
    await page.waitForTimeout(2500);
    const m1 = await page.evaluate(() => Math.round(scrollY));
    console.log(`  /matiere défilé à ${m0}px → chapitre → Retour : ${m1}px`);
  });
  await run("F8 bascule public → connecté, processeur ralenti", async (browser) => {
    for (const rate of [4, 6]) {
      const ctx = await newContext(browser, "phone412");
      await signInAs(ctx, { role: "student" });
      await installRecorder(ctx);
      const page = await ctx.newPage();
      await page.goto(ORIGIN + "/dashboard", { waitUntil: "networkidle" }).catch(() => {});
      await page.waitForTimeout(2000);
      await page.goto(ORIGIN + "/programme", { waitUntil: "networkidle" });
      await page.waitForTimeout(2000);
      const cdp = await page.context().newCDPSession(page);
      await cdp.send("Emulation.setCPUThrottlingRate", { rate });
      const m = await mark(page);
      await page
        .locator('[data-testid="student-tab-bar"] a[href="/dashboard"]')
        .click({ noWaitAfter: true });
      await page.waitForTimeout(3000);
      console.log(`  processeur ÷${rate} :\n     ` + (await since(page, m)).steps.join("\n     "));
      await ctx.close();
    }
  });
})();

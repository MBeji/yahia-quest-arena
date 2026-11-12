import { test, expect } from "../fixtures";

// Le premier rendu sort dans la langue du cookie (issue #1228,
// `ssr-body-wrong-language-flash`). Avant le 2026-11-12, le serveur rendait
// TOUJOURS le corps en français : un élève dont le cookie disait « ar » ou « en »
// recevait une page française, qui basculait après l'hydratation — seul
// `<html lang dir>` était juste. Trois choses sont tenues ici, que seul un vrai
// navigateur voit ensemble :
//   1. le HTML du SERVEUR (lu sans exécuter de script) porte déjà le texte traduit ;
//   2. l'hydratation ne signale aucun écart (React le dit en console en dev) ;
//   3. le titre ne change pas entre le HTML servi et la page hydratée.
const LOCALE_COOKIE = "xp-scholars-locale";

const CASES = [
  { cookie: null, lang: "fr", dir: "ltr", hero: /Tous les cours/ },
  { cookie: "fr", lang: "fr", dir: "ltr", hero: /Tous les cours/ },
  { cookie: "en", lang: "en", dir: "ltr", hero: /Every lesson/ },
  { cookie: "ar", lang: "ar", dir: "rtl", hero: /كل دروس/ },
] as const;

test.describe("Premier rendu dans la langue du cookie", () => {
  for (const { cookie, lang, dir, hero } of CASES) {
    test(`cookie ${cookie ?? "absent"} → corps serveur en « ${lang} », hydratation sans écart`, async ({
      page,
      context,
      baseURL,
      landing,
    }) => {
      if (!baseURL) throw new Error("baseURL manquant");
      if (cookie) await context.addCookies([{ name: LOCALE_COOKIE, value: cookie, url: baseURL }]);

      // 1. Le HTML tel que le serveur l'envoie, sans navigateur ni script.
      const served = await context.request.get("/");
      const html = await served.text();
      expect(html).toMatch(new RegExp(`<html[^>]*lang="${lang}"[^>]*dir="${dir}"`));

      // 2. L'hydratation : ni erreur de page, ni avertissement d'écart en console.
      const hydrationIssues: string[] = [];
      page.on("pageerror", (error) => hydrationIssues.push(error.message));
      page.on("console", (message) => {
        if (
          message.type() === "error" &&
          /hydrat|did not match|#418|#423|#425/i.test(message.text())
        )
          hydrationIssues.push(message.text());
      });

      await landing.goto();
      const html$ = page.locator("html");
      await expect(html$).toHaveAttribute("lang", lang);
      await expect(html$).toHaveAttribute("dir", dir);
      // L'hydratation est finie quand l'en-tête montre son bouton de compte : il
      // dépend de la session, le serveur ne le rend pas.
      await expect(landing.signupCta).toBeVisible();

      // 3. Le titre du HTML servi est déjà traduit, et c'est le même une fois la page
      // hydratée : aucune bascule de langue après coup. Le HTML servi est lu par un
      // DOMParser (inerte : il n'exécute aucun script), pas par une regex de balises.
      const servedTitle = await page.evaluate(
        (source) =>
          new DOMParser().parseFromString(source, "text/html").querySelector("h1")?.textContent,
        html,
      );
      expect(servedTitle).toMatch(hero);
      expect(await landing.heroTitle.textContent()).toBe(servedTitle);
      expect(hydrationIssues).toEqual([]);
    });
  }
});

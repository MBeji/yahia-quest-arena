import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";
import { KeepRowPage } from "../pages/keep-row.page";

/**
 * Étude 40, lot 5 — « Inviter mon parent » (US-9, R-19).
 *
 * L'élève invite son parent depuis le paramétrage ; le message porte le lien de SON bilan, code
 * déjà rempli. Ouvert SANS compte, ce lien affiche le bilan, retire `?src=share` de l'adresse,
 * garde `?code=` et propose de retenir le code.
 *
 * Rien ne part : la sonde de `KeepRowPage` (le même geste de partage, lot 4) remplace la feuille
 * de partage, WhatsApp et le presse-papiers avant le chargement.
 */
test.use({ storageState: STORAGE_STATE.free });

/** Miroir de `formatStudentAllianceCode` : uuid → HEX, par groupes de 4. */
function allianceCode(userId: string): string {
  return (
    userId
      .replace(/-/g, "")
      .toUpperCase()
      .match(/.{1,4}/g)
      ?.join("-") ?? ""
  );
}

test.describe("Inviter mon parent (étude 40, lot 5)", () => {
  test.describe.configure({ timeout: 90_000 });

  test("le message de l'élève ouvre son bilan sans compte, code déjà rempli", async ({
    page,
    browser,
    baseURL,
    adminDb,
  }) => {
    const code = allianceCode(await adminDb.userIdByEmail(TEST_USERS.free.email));
    const device = new KeepRowPage(page);
    await device.shapeDevice({ whatsapp: true });

    await page.goto("/parametrage");
    const invite = page.getByTestId("invite-parent");
    await expect(invite).toBeVisible({ timeout: 25_000 });
    // Un clic avant l'hydratation se perd : on rejoue jusqu'à ce que le message soit parti.
    await expect(async () => {
      await invite.click();
      expect((await device.whatsappTexts()).length).toBeGreaterThan(0);
    }).toPass({ timeout: 20_000 });

    const [message] = await device.whatsappTexts();
    const link = message.match(/https:\/\/\S+$/)?.[0] ?? "";
    const shared = new URL(link);
    expect(shared.origin).toBe("https://www.na9ranal3ab.tn");
    expect(`${shared.pathname}${shared.search}`).toBe(`/suivi?code=${code}&src=share`);

    // Le parent : un autre navigateur, SANS session. Le lien est rejoué sur le serveur du test.
    const parent = await browser.newContext({ storageState: { cookies: [], origins: [] } });
    try {
      const suivi = await parent.newPage();
      await suivi.goto(new URL(`${shared.pathname}${shared.search}`, baseURL).toString());

      // Le bilan est affiché : ses deux lectures sont là, et le code a été retenu (case cochée
      // par défaut) — « Oublier ce code » n'existe qu'après un bilan ouvert ET mémorisé.
      await expect(
        suivi.getByRole("button", { name: /jour par jour|day by day|يومًا بيوم/i }),
      ).toBeVisible({ timeout: 30_000 });
      await expect(suivi.getByRole("checkbox")).toBeChecked();
      await expect(
        suivi.getByRole("button", { name: /oublier ce code|forget this code|نسيان هذا الرمز/i }),
      ).toBeVisible();
      await expect(suivi.getByPlaceholder(/code alliance|alliance code|رمز التحالف/i)).toHaveValue(
        code,
      );

      // `src` est parti de l'adresse affichée, `code` est resté.
      await expect
        .poll(() => new URL(suivi.url()).search, { timeout: 10_000 })
        .toBe(`?code=${code}`);
    } finally {
      await parent.close();
    }
  });
});

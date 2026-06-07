import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Language can be changed from inside the app too, and Arabic flips the whole
// authenticated shell to RTL — without a reload or losing the session.
test.use({ storageState: STORAGE_STATE.free });

test.describe("In-app language switch + RTL (authenticated)", () => {
  test("switching to Arabic flips the shell to RTL, then back to LTR", async ({
    dashboard,
    nav,
    page,
  }) => {
    await dashboard.goto();
    await expect(page.locator("html")).toHaveAttribute("dir", "ltr");

    await nav.changeLanguage("العربية");
    await expect(page.locator("html")).toHaveAttribute("lang", "ar");
    await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
    await expect(nav.languageTrigger).toContainText("AR");
    // Session is intact: the catalogue is still rendered after the switch.
    await expect(dashboard.subjectCards.first()).toBeVisible();

    await nav.changeLanguage("English");
    await expect(page.locator("html")).toHaveAttribute("lang", "en");
    await expect(page.locator("html")).toHaveAttribute("dir", "ltr");
  });
});

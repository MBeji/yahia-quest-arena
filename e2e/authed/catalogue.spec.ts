import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Catalogue navigation (usage): a student opens a subject from the dashboard and
// reaches its missions. Covers the dashboard → subject → mission click-through.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Catalogue navigation", () => {
  test("open a subject from the dashboard and see its missions", async ({ dashboard, page }) => {
    await dashboard.goto();
    await expect(dashboard.subjectCards.first()).toBeVisible();

    await dashboard.openFirstSubject();
    // The subject hub moved to the public Référence register at /matiere (C8 rename).
    await expect(page).toHaveURL(/\/matiere\//);
    // For a signed-in visitor the hub exposes scored-quest links (the quiz tile +
    // each chapter's missions); allow for the subject content fetch on a cold server.
    await expect(page.locator('a[href^="/quest/"]').first()).toBeVisible({ timeout: 15_000 });
  });
});

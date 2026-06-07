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
    await expect(page).toHaveURL(/\/subject\//);
    // The subject page always exposes at least one mission link (the quiz tile).
    await expect(page.locator('a[href^="/quest/"]').first()).toBeVisible();
  });
});

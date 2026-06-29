import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The authenticated nav shell routes correctly. Driven from the leaderboard page
// (the banner is identical on every authed page, and it's lighter than the 3D
// dashboard). Targeted by href, not link text, so it stays robust to the UI
// locale (the labels are translated; the FR-default switch — GAP-010 — renamed
// them "Aventure"/"Donjon"/"Hall des Héros").
test.use({ storageState: STORAGE_STATE.free });

const NAV = [
  { href: "/parcours", url: /\/parcours/ },
  // « Découvrir » converged onto the public catalogue (chantier L2.A) — the nav now
  // points at /programme (the old /themes hub is a 301 redirect to it).
  { href: "/programme", url: /\/programme/ },
  { href: "/dungeon", url: /\/dungeon/ },
  { href: "/dashboard", url: /\/dashboard/ },
];

test.describe("Primary navigation", () => {
  test.describe.configure({ timeout: 60_000 });

  for (const item of NAV) {
    test(`nav → ${item.url.source}`, async ({ leaderboard, page }) => {
      await leaderboard.goto();
      await page.getByRole("banner").locator(`a[href="${item.href}"]`).first().click();
      await expect(page).toHaveURL(item.url);
    });
  }

  test("the brand returns to the dashboard", async ({ leaderboard, page }) => {
    await leaderboard.goto();
    await page
      .getByRole("banner")
      .getByRole("link", { name: /na9ra\s*nal3ab/i })
      .click();
    await expect(page).toHaveURL(/\/dashboard/);
  });
});

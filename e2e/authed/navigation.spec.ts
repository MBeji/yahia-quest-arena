import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// The authenticated nav shell routes correctly. Driven from the leaderboard page
// (the banner is identical on every authed page, and it's lighter than the 3D
// dashboard). Scoped to the header so body links with similar names don't clash.
test.use({ storageState: STORAGE_STATE.free });

const NAV = [
  { name: /adventure/i, url: /\/parcours/ },
  { name: /themes/i, url: /\/themes/ },
  { name: /dungeon/i, url: /\/dungeon/ },
  { name: /heroes hall/i, url: /\/dashboard/ },
];

test.describe("Primary navigation", () => {
  test.describe.configure({ timeout: 60_000 });

  for (const item of NAV) {
    test(`nav → ${item.url.source}`, async ({ leaderboard, page }) => {
      await leaderboard.goto();
      await page.getByRole("banner").getByRole("link", { name: item.name }).first().click();
      await expect(page).toHaveURL(item.url);
    });
  }

  test("the brand returns to the dashboard", async ({ leaderboard, page }) => {
    await leaderboard.goto();
    await page
      .getByRole("banner")
      .getByRole("link", { name: /xp\s*scholars/i })
      .click();
    await expect(page).toHaveURL(/\/dashboard/);
  });
});

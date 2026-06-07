import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Leaderboard display (gamification): the global ranking renders, and switching
// to a per-subject board works. Tolerant of an empty board (a fresh test project
// may have no XP yet) — the requirement is that it renders, not that it's full.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Leaderboard", () => {
  test("the global ranking renders without errors", async ({ leaderboard }) => {
    await leaderboard.goto();
    await expect(leaderboard.heading).toBeVisible();
    await expect(leaderboard.globalTab).toBeVisible();

    // Wait for the board to finish loading — either ranked rows or the explicit
    // empty-state. (Reading rows.count() before the query resolves is a race.)
    await expect(leaderboard.rows.first().or(leaderboard.emptyState)).toBeVisible({
      timeout: 15_000,
    });
    const rendered =
      (await leaderboard.rows.count()) > 0 || (await leaderboard.emptyState.isVisible());
    expect(rendered).toBeTruthy();
  });

  test("can switch to a per-subject ranking", async ({ leaderboard, adminDb }) => {
    const { data } = await adminDb.client
      .from("subjects")
      .select("name_fr")
      .order("display_order")
      .limit(1)
      .maybeSingle();
    const name = (data?.name_fr as string | undefined) ?? null;
    test.skip(!name, "No subject in the test project to build a leaderboard tab.");

    await leaderboard.goto();
    await leaderboard.subjectTab(name as string).click();
    // The board re-renders for the subject (heading persists, no crash).
    await expect(leaderboard.heading).toBeVisible();
    await leaderboard.globalTab.click();
    await expect(leaderboard.heading).toBeVisible();
  });
});

import { test, expect } from "../fixtures";

// Graphical: the dark/light theme toggle flips the document theme class and the
// choice survives a reload (persisted). Verified on the public landing.
test.describe("Theme switcher", () => {
  test("toggles light/dark and persists across reload", async ({ page, landing }) => {
    await landing.goto();
    await page.waitForLoadState("networkidle");
    await page.waitForTimeout(1000); // let React hydrate so the toggle handler is live

    const html = page.locator("html");
    const toggle = page.getByRole("button", { name: /switch to (light|dark) theme/i });
    await expect(toggle).toBeVisible();

    const wasDark = ((await html.getAttribute("class")) ?? "").includes("dark");
    await toggle.click();
    await expect(html).toHaveClass(wasDark ? /\blight\b/ : /\bdark\b/);

    // The preference persists across a full reload.
    await page.reload();
    await expect(html).toHaveClass(wasDark ? /\blight\b/ : /\bdark\b/);
  });
});

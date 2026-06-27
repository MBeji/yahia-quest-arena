import { test, expect } from "../fixtures";

/**
 * The theme picker is global chrome (present in both the public and the
 * authenticated headers). The chosen theme is the SINGLE `<html>` class,
 * persisted to localStorage + cookie, so it never changes on navigation —
 * no public↔connecté "theme mixing". Backendless tier: only the static public
 * routes (`/` and `/login`) are visited.
 */
test.describe("Theme picker — unified global skin", () => {
  test("default is reference; picking a theme applies, persists, and never mixes on navigation", async ({
    page,
    landing,
    nav,
  }) => {
    await landing.goto();
    const html = page.locator("html");

    // Default (no stored preference) = the « Référence » reading register.
    await expect(html).toHaveClass(/\breference\b/);

    // Pick « Sombre » → the single <html> class flips and is persisted.
    await nav.changeTheme("dark");
    await expect(html).toHaveClass(/\bdark\b/);
    await expect(html).not.toHaveClass(/\breference\b/);
    expect(await page.evaluate(() => localStorage.getItem("xp-scholars-theme"))).toBe("dark");

    // Persisted across a reload (cookie-driven SSR + localStorage).
    await page.reload();
    await expect(html).toHaveClass(/\bdark\b/);

    // No mixing across navigation: a different route keeps the chosen theme —
    // even one without the picker (the auth page).
    await page.goto("/login");
    await expect(html).toHaveClass(/\bdark\b/);

    // Round-trip back to « Référence » from the picker.
    await landing.goto();
    await nav.changeTheme("reference");
    await expect(html).toHaveClass(/\breference\b/);
    await expect(html).not.toHaveClass(/\bdark\b/);
  });
});

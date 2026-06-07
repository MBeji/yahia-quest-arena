import { test, expect } from "../fixtures";

// The language can be changed at any time and the UI updates live (no reload),
// including the document direction (Arabic ⇒ RTL). Verified on the public landing
// (the switcher is in the always-visible top bar, so it works on mobile too).
test.describe("Dynamic language switch + RTL", () => {
  test("switching locale updates content and document direction live", async ({
    page,
    landing,
    nav,
  }) => {
    await landing.goto();
    const html = page.locator("html");

    // Normalise to English first (default-locale agnostic).
    await nav.changeLanguage("English");
    await expect(html).toHaveAttribute("lang", "en");
    await expect(html).toHaveAttribute("dir", "ltr");
    await expect(landing.signupCta).toContainText(/Join/i);

    // → French: still LTR, CTA text translated, no navigation/reload.
    await nav.changeLanguage("Français");
    await expect(html).toHaveAttribute("lang", "fr");
    await expect(html).toHaveAttribute("dir", "ltr");
    await expect(landing.signupCta).toContainText(/Rejoindre/i);
    await expect(nav.languageTrigger).toContainText("FR");

    // → Arabic: document flips to RTL and the CTA shows Arabic text.
    await nav.changeLanguage("العربية");
    await expect(html).toHaveAttribute("lang", "ar");
    await expect(html).toHaveAttribute("dir", "rtl");
    await expect(landing.signupCta).toContainText("انضم");

    // → back to English: RTL is cleared again.
    await nav.changeLanguage("English");
    await expect(html).toHaveAttribute("dir", "ltr");
    await expect(landing.signupCta).toContainText(/Join/i);
  });
});

import { test, expect } from "../fixtures";

/**
 * CSP nonce (GAP-022) — public, no backend/auth.
 *
 * Verifies the per-request nonce policy end-to-end: the SSR function sets a
 * `Content-Security-Policy` with a fresh `script-src … 'nonce-…'` (no
 * 'unsafe-inline'), the served HTML stamps that same nonce on its inline
 * scripts, and the page still hydrates with zero CSP violations — the guard
 * against the "page renders but JS is inert" class of regression.
 *
 * The request-based assertions are wrapped in `toPass()` so a cold Vite dev
 * server (optimizing deps on first hit) can't flake them — the policy is a
 * property of every steady-state response, not of the very first one.
 */
const NONCE_RE = /script-src[^;]*'nonce-([^']+)'/;

test.describe("Content-Security-Policy (nonce)", () => {
  test("HTML response carries a nonce'd script-src without 'unsafe-inline'", async ({ page }) => {
    await expect(async () => {
      const res = await page.request.get("/");
      expect(res.ok()).toBeTruthy();

      const csp = res.headers()["content-security-policy"];
      expect(csp, "CSP header must be present on the HTML response").toBeTruthy();
      expect(csp, `script-src must carry a nonce — got: ${csp}`).toMatch(NONCE_RE);

      // The whole point of GAP-022: no inline-script escape hatch.
      const scriptSrc = csp.split("; ").find((d) => d.startsWith("script-src "));
      expect(scriptSrc).not.toContain("'unsafe-inline'");
      // 'self' stays so the hashed /assets/*.js chunks still load.
      expect(scriptSrc).toContain("'self'");
    }).toPass();
  });

  test("the served inline scripts carry the same nonce as the header", async ({ page }) => {
    await expect(async () => {
      const res = await page.request.get("/");
      const nonce = res.headers()["content-security-policy"]?.match(NONCE_RE)?.[1];
      expect(nonce, "header must expose a nonce").toBeTruthy();

      // TanStack Start emits at least one inline hydration <script>; it must be nonced.
      const html = await res.text();
      expect(html).toContain(`nonce="${nonce}"`);
    }).toPass();
  });

  test("the nonce is fresh per request", async ({ page }) => {
    const read = async () =>
      (await page.request.get("/")).headers()["content-security-policy"]?.match(NONCE_RE)?.[1];

    await expect(async () => {
      const [first, second] = [await read(), await read()];
      expect(first).toBeTruthy();
      expect(second).toBeTruthy();
      expect(first).not.toBe(second);
    }).toPass();
  });

  test("the landing page hydrates with no CSP violations", async ({ page, landing }) => {
    const violations: string[] = [];
    page.on("console", (msg) => {
      if (msg.type() === "error") violations.push(msg.text());
    });
    page.on("pageerror", (err) => violations.push(String(err)));

    await landing.goto();
    // Hydration markers: an interactive CTA must be present and the title set.
    await expect(page).toHaveTitle(/Na9ra Nal3ab/i);
    await expect(landing.signupCta).toBeVisible();

    const cspErrors = violations.filter((v) =>
      /content security policy|refused to (execute|load|apply)|violates the following/i.test(v),
    );
    expect(cspErrors, `unexpected CSP violations:\n${cspErrors.join("\n")}`).toEqual([]);
  });
});

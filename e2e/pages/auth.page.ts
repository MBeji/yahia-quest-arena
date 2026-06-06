import { type Page, type Locator, expect } from "@playwright/test";

/** The /auth screen (login + signup). Owns the SSR-hydration-robust login flow. */
export class AuthPage {
  constructor(private readonly page: Page) {}

  get email(): Locator {
    return this.page.locator('input[type="email"]');
  }
  get password(): Locator {
    return this.page.locator('input[type="password"]');
  }
  get submit(): Locator {
    return this.page.locator('button[type="submit"]');
  }
  get google(): Locator {
    return this.page.getByRole("button", { name: /google/i });
  }

  async goto(mode: "login" | "signup" = "login"): Promise<void> {
    await this.page.goto(`/auth?mode=${mode}`);
  }

  /**
   * Log in through the real UI. This is an SSR app: a click before React hydrates
   * does a native form submit that never calls Supabase, so we re-navigate + fill
   * + submit until the POST /auth/v1/token actually fires, then wait for the
   * dashboard redirect. Used by auth.setup.ts (per role) and any login spec.
   */
  async login(email: string, password: string): Promise<void> {
    await expect(async () => {
      await this.goto("login");
      await this.page.waitForTimeout(2000); // let React hydrate before interacting
      await this.email.fill(email);
      await this.password.fill(password);
      await Promise.all([
        this.page.waitForResponse(
          (r) => r.url().includes("/auth/v1/token") && r.request().method() === "POST",
          { timeout: 8000 },
        ),
        this.submit.click(),
      ]);
    }).toPass({ timeout: 90_000 });

    await this.page.waitForURL(/\/dashboard/, { timeout: 20_000 });
  }
}

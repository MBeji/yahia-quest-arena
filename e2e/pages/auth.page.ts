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
  /** Page heading ("Welcome back, warrior" / "Forge your hero"). */
  get heading(): Locator {
    return this.page.getByRole("heading", { level: 1 });
  }
  /** Inline, screen-reader-announced form error (role="alert"). */
  get error(): Locator {
    return this.page.getByRole("alert");
  }
  /** The "Hero name" field — present only in signup mode. */
  get nameField(): Locator {
    return this.page.locator("#auth-name");
  }
  /** The bottom link that switches between login and signup. */
  get toggleModeLink(): Locator {
    return this.page.getByRole("link", { name: /create an account|sign in/i });
  }

  async goto(mode: "login" | "signup" = "login"): Promise<void> {
    await this.page.goto(`/auth?mode=${mode}`);
  }

  /**
   * Fill + submit the login form, firing the real auth request (retries to beat
   * the SSR-hydration window where a click does a native submit). Does NOT wait
   * for a dashboard redirect — use for negative cases (bad credentials) where the
   * app stays on /auth and surfaces an error.
   */
  async attemptLogin(email: string, password: string): Promise<void> {
    await this.goto("login");
    await expect(async () => {
      await this.email.fill(email);
      await this.password.fill(password);
      await Promise.all([
        this.page.waitForResponse(
          (r) => r.url().includes("/auth/v1/token") && r.request().method() === "POST",
          { timeout: 8000 },
        ),
        this.submit.click(),
      ]);
    }).toPass({ timeout: 60_000 });
  }

  /**
   * Fill + submit the signup form, firing the real signup request (hydration-safe
   * retry). Creates a real auth user — the caller MUST clean it up.
   */
  async attemptSignup(name: string, email: string, password: string): Promise<void> {
    await this.goto("signup");
    await expect(async () => {
      await this.nameField.fill(name);
      await this.email.fill(email);
      await this.password.fill(password);
      await Promise.all([
        this.page.waitForResponse(
          (r) => r.url().includes("/auth/v1/signup") && r.request().method() === "POST",
          { timeout: 8000 },
        ),
        this.submit.click(),
      ]);
    }).toPass({ timeout: 60_000 });
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

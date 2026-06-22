import { type Page, type Locator } from "@playwright/test";

/**
 * Public landing page (`/`) — the « Référence » register entry (chantier C8, L1.2).
 * Repositioned from the old paid-concours RPG hero to the free, family, public
 * platform. Selectors are locale-independent (brand text, route hrefs, and stable
 * `data-testid`s) so they survive the FR/EN/AR catalogue and the RTL switch.
 */
export class LandingPage {
  constructor(private readonly page: Page) {}

  /** Brand wordmark (locale-independent), the link home in the public header. */
  get brand(): Locator {
    return this.page.getByRole("link", { name: /Na9ra\s*Nal3ab/i }).first();
  }
  /** The single primary account CTA in the public header ("Créer mon compte"). */
  get signupCta(): Locator {
    return this.page.locator('header a[href="/signup"]').first();
  }
  /** The discreet login link in the public header (hidden on mobile by CSS). */
  get loginCta(): Locator {
    return this.page.locator('header a[href="/login"]').first();
  }
  /** Hero CTA into the official-programme catalogue. */
  get programmeCta(): Locator {
    return this.page.locator('main a[href="/programme"]').first();
  }
  /** Hero CTA into the optional extras (off-programme). */
  get extrasCta(): Locator {
    return this.page.locator('main a[href="/extras"]').first();
  }
  /** The promise headline (role-based, so locale-independent). */
  get heroTitle(): Locator {
    return this.page.getByRole("heading", { level: 1 });
  }
  /** The 3 persona doors (élève / parent / enseignant). */
  get personaDoors(): Locator {
    return this.page.getByTestId("persona-door");
  }
  /** The 3 parcours-cycle cards (Primaire / Collège / Lycée). */
  get cycleCards(): Locator {
    return this.page.getByTestId("cycle-card");
  }
  /** The single "apprends en jouant" (Jeu register) block — the only RPG surface. */
  get gameBlock(): Locator {
    return this.page.getByTestId("game-block");
  }

  async goto(): Promise<void> {
    await this.page.goto("/");
  }
}

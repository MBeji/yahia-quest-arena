import { type Page, type Locator } from "@playwright/test";

/**
 * La carte « installer l'application » (étude 40 lot 3) — écran de résultat après une réussite,
 * bilan parent. Ses libellés sont traduits : tout passe par des `data-testid`.
 */
export class InstallInvitePage {
  /** La mémoire commune des invitations, telle que `nudge-memory.ts` l'écrit. */
  static readonly NUDGE_KEY = "na9ra.nudge";

  constructor(private readonly page: Page) {}

  get card(): Locator {
    return this.page.getByTestId("install-invite");
  }
  /** Le bouton qui ouvre la fenêtre du navigateur — Chromium seulement. */
  get cta(): Locator {
    return this.page.getByTestId("install-invite-cta");
  }
  get later(): Locator {
    return this.page.getByTestId("install-invite-later");
  }
  /** Les deux gestes de Safari iOS. */
  get steps(): Locator {
    return this.page.getByTestId("install-invite-steps").locator("li");
  }

  /**
   * Fait passer `beforeinstallprompt` comme Chromium le ferait quand l'application est
   * installable. À appeler une fois la page chargée : la coquille a déjà posé son écouteur.
   * `outcome` est ce que la personne répondra à la fenêtre du navigateur.
   */
  async offerNativeInstall(outcome: "accepted" | "dismissed" = "accepted"): Promise<void> {
    await this.page.evaluate((choice) => {
      const state = { prompted: 0 };
      const event = Object.assign(new Event("beforeinstallprompt", { cancelable: true }), {
        prompt: () => {
          state.prompted += 1;
          return Promise.resolve();
        },
        userChoice: Promise.resolve({ outcome: choice }),
      });
      Object.assign(window, { __installProbe: state });
      window.dispatchEvent(event);
    }, outcome);
  }

  /** Combien de fois la fenêtre d'installation du navigateur a été ouverte. */
  promptCount(): Promise<number> {
    return this.page.evaluate(
      () =>
        (window as unknown as { __installProbe?: { prompted: number } }).__installProbe?.prompted ??
        0,
    );
  }

  /** Ce que l'appareil retient de l'invitation à installer — `null` s'il ne retient rien. */
  remembered(): Promise<{ shown: string; dismissed: number } | null> {
    return this.page.evaluate((key) => {
      const raw = window.localStorage.getItem(key);
      const memory = raw
        ? (JSON.parse(raw) as Record<string, { shown: string; dismissed: number }>)
        : {};
      return memory.install ?? null;
    }, InstallInvitePage.NUDGE_KEY);
  }
}

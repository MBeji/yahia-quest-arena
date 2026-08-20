import { type Page, type Locator } from "@playwright/test";

/**
 * Console d'administration des abonnements (`/admin/subscriptions`) — la seule
 * route de l'app que deux specs observent depuis les DEUX côtés du garde de rôle,
 * et c'est ce qui rend cette page object nécessaire.
 *
 * Ses deux getters sont des miroirs l'un de l'autre, chacun avec un usage positif
 * ET un usage négatif (règle « Every negative assertion needs a paired positive
 * one », e2e/README.md — issue #733) :
 *
 * | getter         | positif                        | négatif                        |
 * | -------------- | ------------------------------ | ------------------------------ |
 * | `accessDenied` | `authorization.spec` (élève)   | `admin-and-parent.spec` (admin) |
 * | `consolePanel` | `admin-and-parent.spec` (admin)| `authorization.spec` (élève)   |
 *
 * Les deux sont ciblés par `data-testid`, jamais par la copie : celle du refus est
 * traduite (`t.subscription.accessDenied`) et le défaut de l'application est le
 * FRANÇAIS (GAP-010) — « Accès réservé aux administrateurs. ». Le sélecteur en clair
 * que ces deux specs portaient (`/access denied|accès refusé/i`, puis
 * `/administrators only|administrateurs|للمسؤولين/i`) était donc au mieux un pari sur
 * le libellé du jour, au pire — pour le premier — un sélecteur qui ne désignait
 * personne dans aucune des trois langues.
 */
export class AdminSubscriptionsPage {
  constructor(private readonly page: Page) {}

  /**
   * L'écran de refus servi à un compte NON-admin (`role !== null && !isAdmin`).
   *
   * ⚠️ Il n'existe qu'une fois le rôle CONNU : tant que `useMyRole` charge, la route
   * rend la console pour tout le monde (c'est délibéré — « no access-denied flash »,
   * cf. `src/routes/_authenticated/__tests__/admin-routes.test.tsx`). Un
   * `toHaveCount(0)` sur ce getter est donc vrai au premier paint : il faut attendre
   * une preuve de rôle résolu avant de l'opposer à quoi que ce soit.
   */
  get accessDenied(): Locator {
    return this.page.getByTestId("admin-access-denied");
  }

  /** La console elle-même — l'outillage admin que le refus doit remplacer, pas recouvrir. */
  get consolePanel(): Locator {
    return this.page.getByTestId("admin-subscriptions-console");
  }

  async goto(): Promise<void> {
    await this.page.goto("/admin/subscriptions");
  }
}

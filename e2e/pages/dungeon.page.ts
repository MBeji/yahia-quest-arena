import { type Page, type Locator } from "@playwright/test";

/** Dungeon page (`/dungeon`): timed boss mode behind a progress/level gate. */
export class DungeonPage {
  constructor(private readonly page: Page) {}

  /** Progress lock ("Donjon verrouillé") — shown to a user who has not attempted
   * enough distinct subjects/chapters yet. Phase gratuite (étude 15, lot 2): the
   * former concours-entitlement premium gate is gone, this is the first gate. */
  get lockedGate(): Locator {
    return this.page.getByText(/donjon verrouillé/i);
  }
  /**
   * Le CTA qui lance une run (présent seulement une fois l'accès accordé). Ciblé par
   * `data-testid`, jamais par son nom accessible : celui-ci vient de
   * `t.dungeon.enterDungeonAria`, donc il est TRADUIT, et le défaut de l'application
   * est le français (GAP-010). Le libellé anglais que ce getter a porté jusqu'ici ne
   * pouvait donc désigner personne — et comme ses deux seuls usages étaient des
   * `toHaveCount(0)`, il passait à VIDE sans rien mesurer : même classe de défaut que
   * `dashboard.adminNavLink` (#796), même issue (#733). Ce qui rend ces négatifs
   * opposables, c'est le test POSITIF appairé de `dungeon.spec.ts` — les trois usages
   * doivent rester sur CE getter, sinon plus rien ne prouve qu'il désigne quelque chose.
   */
  get enterButton(): Locator {
    return this.page.getByTestId("dungeon-enter");
  }

  async goto(): Promise<void> {
    await this.page.goto("/dungeon");
  }
}

import { type Page, type Locator } from "@playwright/test";

/** Leaderboard page (`/leaderboard`): global + per-subject XP rankings. */
export class LeaderboardPage {
  constructor(private readonly page: Page) {}

  get heading(): Locator {
    return this.page.getByRole("heading", { name: /classement|leaderboard/i });
  }
  /** One row per ranked player in the full ranking list. */
  get rows(): Locator {
    return this.page.getByTestId("leaderboard-row");
  }
  /** The "🌍 Global" tab. */
  get globalTab(): Locator {
    return this.page.getByTestId("leaderboard-global-tab");
  }
  /**
   * La puce « Toi » que porte MA ligne du classement (rendue seulement si je suis
   * classé). Ciblée par `data-testid`, jamais par son texte : ce libellé sort de
   * `t.leaderboard.youChip`, donc il est TRADUIT — « Toi » en français, et le français
   * est le défaut de l'application depuis GAP-010. Le « You » anglais que ce getter a
   * visé jusqu'ici ne pouvait désigner personne : même classe de défaut que
   * `dashboard.adminNavLink` (#796) et `dungeon.enterButton`, même issue (#733).
   *
   * Il n'avait alors AUCUN usage — donc même pas un faux vert, juste un piège armé pour
   * la première spec qui l'appellerait. Ce qui le tient désormais honnête, c'est le test
   * POSITIF de `leaderboard.spec.ts` : tout usage futur en assertion négative doit rester
   * sur CE getter, sinon plus rien ne prouve qu'il désigne quelque chose.
   */
  get meBadge(): Locator {
    return this.page.getByTestId("leaderboard-me-chip");
  }
  /**
   * The empty-state block, shown when the active board has no ranked hero yet.
   *
   * Matched on the shared EmptyState hook, NOT on copy. The previous locator
   * looked for "aucun héros inscrit" (`leaderboard.emptyGlobal`), which stopped
   * being rendered when étude 15 lot 11 replaced the flat message with the
   * cold-start invitation ("Le classement démarre !"); étude 22 lot 4 then added
   * a third wording for the "Ma classe" cohort. Since `reset-gameplay` wipes all
   * XP before every run, the board is ALWAYS empty in CI — so the dead copy made
   * this locator match nothing at all, and the test failed on a board that was in
   * fact rendering correctly.
   */
  get emptyState(): Locator {
    return this.page.getByTestId("empty-state");
  }
  /**
   * L'AXE PÉRIODE, second axe du classement depuis é31 lot 5 (#949) — à ne pas confondre
   * avec les onglets de COHORTE (Global / Ma classe / matière), qui sont l'autre axe.
   *
   * ⚠️ « Cette semaine » est le DÉFAUT (Q-3, arbitrée), et les deux périodes ne lisent pas
   * la même source : le cumulatif lit `profiles.xp` (l'XP à vie) via
   * `get_global_leaderboard`, la semaine lit `attempts` sur les 7 jours courants via
   * `get_weekly_leaderboard`. Une spec qui POSE une XP à vie doit donc demander le
   * cumulatif — sinon elle interroge un tableau qu'elle n'a pas garni. C'est la panne
   * #1015 : le test est né le 2026-08-26, l'axe le 2026-09-03, le nightly a rougi le
   * 2026-09-04.
   */
  get periodAll(): Locator {
    return this.page.getByTestId("leaderboard-period-all");
  }
  /** L'onglet « cette semaine » — le défaut. */
  get periodWeek(): Locator {
    return this.page.getByTestId("leaderboard-period-week");
  }
  /** All subject tabs — scoped to the active parcours' subjects (GAP-018). */
  get subjectTabs(): Locator {
    return this.page.getByTestId("leaderboard-subject-tab");
  }
  /** A subject tab, located by the subject's display name. */
  subjectTab(name: string): Locator {
    return this.page.getByRole("button", { name, exact: true });
  }

  async goto(): Promise<void> {
    await this.page.goto("/leaderboard");
  }
}

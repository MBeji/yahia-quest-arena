import { test, expect } from "../fixtures";
import { STORAGE_STATE, TEST_USERS } from "../helpers/users";

// Leaderboard display (gamification): the global ranking renders, and switching
// to a per-subject board works. Tolerant of an empty board (a fresh test project
// may have no XP yet) — the requirement is that it renders, not that it's full.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Leaderboard", () => {
  test("the global ranking renders without errors", async ({ leaderboard }) => {
    await leaderboard.goto();
    await expect(leaderboard.heading).toBeVisible();
    await expect(leaderboard.globalTab).toBeVisible();

    // Wait for the board to finish loading — either ranked rows or the explicit
    // empty-state. (Reading rows.count() before the query resolves is a race.)
    await expect(leaderboard.rows.first().or(leaderboard.emptyState)).toBeVisible({
      timeout: 15_000,
    });
    const rendered =
      (await leaderboard.rows.count()) > 0 || (await leaderboard.emptyState.isVisible());
    expect(rendered).toBeTruthy();
  });

  test("can switch to a per-subject ranking", async ({ leaderboard }) => {
    await leaderboard.goto();
    // Tabs are scoped to the ACTIVE parcours' subjects (GAP-018), so pick whatever
    // subject tab actually renders instead of querying the whole catalogue.
    await expect(leaderboard.globalTab).toBeVisible();
    const tabCount = await leaderboard.subjectTabs.count();
    test.skip(tabCount === 0, "The seeded user's parcours has no subject tabs.");

    await leaderboard.subjectTabs.first().click();
    // The board re-renders for the subject (heading persists, no crash).
    await expect(leaderboard.heading).toBeVisible();
    await leaderboard.globalTab.click();
    await expect(leaderboard.heading).toBeVisible();
  });
});

// L'USAGE POSITIF de `leaderboard.meBadge`, qui n'en avait aucun. Il visait le texte
// anglais « You » d'une puce rendue « Toi » par défaut (GAP-010) : la classe de défaut de
// l'issue #733, celle de `dashboard.adminNavLink` (#796) puis de `dungeon.enterButton`.
// Sans usage il n'était même pas un faux vert — juste un piège armé pour la première spec
// qui l'appellerait en `toHaveCount(0)`, où il aurait mesuré un vide et non une absence.
// La convention d'`e2e/README.md` veut ce positif appairé sur le MÊME getter ; le voici,
// posé d'avance.
//
// Le cobaye est le compte PREMIUM, pas le `free` des tests ci-dessus, pour deux raisons :
//   * il faut un `role = 'student'` — `get_global_leaderboard` ne lit qu'eux, donc le
//     compte admin (cobaye du donjon) n'entrerait jamais au classement ;
//   * l'XP du compte `free` est DISPUTÉE : `progression-stats.spec.ts` et
//     `recall-mode.spec.ts` y guettent une croissance à partir d'une valeur qu'ils ont
//     capturée. Lui POSER une XP peut la faire retomber sous leur repère et casser leur
//     attente. Personne n'observe celle du premium : la boutique compte ses pièces, les
//     specs premium ses droits, le donjon ses tentatives — aucune ne lit son XP.
// Seule `profiles` est touchée, et `reset-gameplay.mjs` en rend la progression au run
// suivant (il remet xp/level/coins/streak à zéro avant la suite).
test.describe("Leaderboard — ma propre ligne", () => {
  test.use({ storageState: STORAGE_STATE.premium });

  test("un compte classé porte la puce « Toi », et sa ligne seule la porte", async ({
    leaderboard,
    adminDb,
  }) => {
    const userId = await adminDb.userIdByEmail(TEST_USERS.premium.email);
    const xp = await adminDb.rankOnLeaderboard(userId);

    await leaderboard.goto();
    // DEUX axes, et il faut les demander tous les deux (#1015).
    //
    // COHORTE — « Global » explicitement : le défaut bascule sur « Ma classe » dès que la
    // cohorte compte assez de classés (GRADE_TAB_DEFAULT_MIN_RANKED), et ce test n'a pas à
    // dépendre de cet arbitrage.
    await leaderboard.globalTab.click();
    // PÉRIODE — « cumulatif » explicitement, et c'est ce qui manquait. « Cette semaine »
    // est le DÉFAUT depuis é31 lot 5 (#949, 2026-09-03), et les deux périodes ne lisent pas
    // la même source : le cumulatif lit `profiles.xp` via `get_global_leaderboard`, dont la
    // CTE `me` calcule MA ligne en direct — elle n'attend pas le rafraîchissement 5 min de
    // la vue matérialisée, contrairement à celle des autres. La semaine, elle, lit
    // `attempts` sur les 7 jours courants, avec `HAVING SUM(xp_earned) > 0` et AUCUNE
    // splice du demandeur (« on n'annonce jamais un rang à qui n'a rien joué cette
    // semaine », é15 D-7).
    //
    // Or `rankOnLeaderboard()` pose une XP À VIE dans `profiles`, et `reset-gameplay` vide
    // les tentatives avant chaque run : sur l'axe « semaine », ce compte n'a rien joué,
    // donc zéro ligne. Le test est né le 2026-08-26, l'axe le 2026-09-03 ; le nightly a
    // rougi le 2026-09-04 et l'est resté huit nuits. Il interrogeait un tableau qu'il
    // n'avait pas garni.
    await leaderboard.periodAll.click();
    // La période active est ASSERTÉE, pas supposée : si le défaut rebasculait un jour, ce
    // test doit le dire au lieu de mesurer en silence le mauvais tableau — c'est très
    // exactement ce qui vient de coûter huit nuits de nightly rouge.
    await expect(leaderboard.periodAll).toHaveAttribute("aria-checked", "true");
    await expect(leaderboard.rows.first()).toBeVisible({ timeout: 15_000 });

    // Le sélecteur désigne quelque chose — ce qu'un `toHaveCount(0)` seul, lui, ne prouve
    // jamais.
    await expect(leaderboard.meBadge).toHaveCount(1);
    // …et la ligne qui la porte est bien la mienne : celle qui affiche mon XP. La puce ne
    // flotte donc pas ailleurs dans la page, et `isMe` désigne la bonne ligne.
    const meRow = leaderboard.rows.filter({ has: leaderboard.meBadge });
    await expect(meRow).toHaveCount(1);
    await expect(meRow).toContainText(`${xp} XP`);
  });
});

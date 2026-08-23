import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

// Negative authorization: a free student must not reach admin tooling, and the
// admin entry points must be hidden from them.
test.use({ storageState: STORAGE_STATE.free });

test.describe("Authorization — student boundaries", () => {
  // LE POSITIF APPAIRÉ du `toHaveCount(0)` d'`admin-and-parent.spec` : c'est ce test-ci
  // qui prouve que `adminSubscriptions.accessDenied` désigne quelque chose, donc que
  // l'absence mesurée là-bas est une absence et non un vide (issue #733).
  //
  // Il passait déjà — sa regex nommait « administrateurs », que la copie française
  // contient — mais elle restait une copie de sélecteur dans un spec, et un pari sur le
  // libellé du jour dans trois langues. Elle passe par la page object et par
  // `data-testid`, comme celle d'en face : les deux specs observent désormais le même
  // objet, et un renommage de la copie ne peut plus les désaccorder en silence.
  test("the admin area is blocked with an access-denied notice", async ({ adminSubscriptions }) => {
    await adminSubscriptions.goto();
    await expect(adminSubscriptions.accessDenied).toBeVisible({ timeout: 15_000 });
    // …et l'outillage admin n'est pas rendu SOUS l'avis de refus. Miroir du même
    // raisonnement sur l'autre getter : `consolePanel` est prouvé matchable par le test
    // admin, prouvé absent par celui-ci. L'ordre est voulu — le garde ne refuse qu'une
    // fois le rôle connu, donc la console EST là au premier paint ; c'est l'attente
    // ci-dessus qui la fait disparaître.
    await expect(adminSubscriptions.consolePanel).toHaveCount(0);
  });

  test("the admin nav link is not shown to a student", async ({ dashboard }) => {
    await dashboard.goto();
    await expect(dashboard.adminNavLink).toHaveCount(0);
  });

  test("parent-report shows the alliance-link state, not another student's data", async ({
    page,
  }) => {
    await page.goto("/parent-report");
    // Le refus de `/parent-report` est un `throw` serveur (`getLinkedStudents`) que la
    // route ne rend jamais en texte de page : elle retombe sur l'UI d'association, sans
    // aucun élève lié. C'est cet écran-ci qui EST le garde observable — d'où l'absence
    // de tout `toHaveCount(0)` sur un « avis de refus » qui n'existe pas ici.
    // A student's getLinkedStudents is denied server-side; React Query retries
    // (~7s) before the page settles to the alliance-code linking UI (no linked
    // students → no foreign data), so allow generous time.
    await expect(page.getByText(/alliance code/i).first()).toBeVisible({ timeout: 20_000 });
  });
});

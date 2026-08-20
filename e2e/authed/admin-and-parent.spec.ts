import { test, expect } from "../fixtures";
import { STORAGE_STATE } from "../helpers/users";

/** Role-gated nav and pages for admin + parent accounts. */
test.describe("Admin", () => {
  test.use({ storageState: STORAGE_STATE.admin });

  // Ce test portait `page.getByText(/access denied|accès refusé/i)` en clair — une
  // copie de sélecteur dans un spec (contraire à « Selectors live in Page Objects »),
  // et surtout un sélecteur qui ne pouvait désigner PERSONNE. Le refus de cette route
  // est rendu depuis `t.subscription.accessDenied`, dont les trois valeurs sont
  // « Accès réservé aux administrateurs. » (fr, le défaut de l'application — GAP-010),
  // « Administrators only. » (en) et « للمسؤولين فقط. » (ar) : aucune ne contient
  // « access denied » ni « accès refusé ». Le `toHaveCount(0)` passait donc VERT sur du
  // vide depuis toujours — issue #733, 3e instance après `dashboard.adminNavLink`
  // (#796) et `dungeon.enterButton` (#797), et la pire des trois : ici une copie réelle
  // et matchable EXISTE, le sélecteur se contentait de ne pas la nommer.
  //
  // Ce qui rend ce négatif opposable, c'est le test POSITIF appairé sur le MÊME getter
  // — le premier d'`authorization.spec` : un élève free qui ouvre cette route DOIT voir
  // ce bloc. Sans lui, `toHaveCount(0)` resterait décoratif (la leçon explicite de #796).
  test("can open the subscriptions admin page", async ({ page, adminSubscriptions, dashboard }) => {
    await adminSubscriptions.goto();
    await expect(page).toHaveURL(/\/admin\/subscriptions/);
    // Le garde ne refuse qu'une fois le rôle CONNU (`role !== null`) : avant ça la route
    // rend la console pour tout le monde, refus compris. L'entrée « Console » de la nav
    // n'existe que pour un admin — c'est donc elle qui prouve que le rôle est résolu, ET
    // résolu admin. Sans cette attente, le `toHaveCount(0)` d'en dessous serait vrai au
    // premier paint, avant que le refus ait eu la moindre chance de paraître : un vert
    // gratuit, exactement le défaut que cette PR corrige.
    await expect(dashboard.adminNavLink).toBeVisible({ timeout: 15_000 });
    await expect(adminSubscriptions.consolePanel).toBeVisible();
    await expect(adminSubscriptions.accessDenied).toHaveCount(0);
  });

  test("sees admin nav entries on the dashboard", async ({ dashboard }) => {
    await dashboard.goto();
    await expect(dashboard.adminNavLink).toBeVisible({ timeout: 15_000 });
  });
});

test.describe("Parent", () => {
  test.use({ storageState: STORAGE_STATE.parent });

  // Ce test portait la MÊME copie de sélecteur, et elle était vide ici aussi — mais pour
  // une raison qu'aucun sélecteur ne corrige : `/parent-report` n'a AUCUN écran de refus.
  // Le refus vient d'un `throw new Error("Access denied: parent or admin account
  // required.")` serveur (`src/features/parent-report/parent-report.server.ts:185`) que
  // `useQuery` laisse en état d'erreur ; la route n'a pas de branche `isError`, donc ce
  // texte n'est jamais rendu dans la page — un élève y voit l'UI d'association d'Alliance
  // Code, ce que pin déjà le 3e test d'`authorization.spec`.
  //
  // Un négatif sans surface observable ne peut pas être appairé à un positif : il n'est
  // pas re-visé, il est remplacé par le positif qu'il aurait dû être. `codeInput` est le
  // bloc d'association, rendu pour tout compte non-admin — donc la preuve que le parent
  // a bien obtenu SON écran, et non celui de l'admin.
  test("can open the parent report page", async ({ page, parentReport }) => {
    await parentReport.goto();
    await expect(page).toHaveURL(/\/parent-report/);
    await expect(parentReport.codeInput).toBeVisible({ timeout: 15_000 });
  });
});

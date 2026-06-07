import { test as base } from "@playwright/test";
import { LandingPage } from "./pages/landing.page";
import { AuthPage } from "./pages/auth.page";
import { DashboardPage } from "./pages/dashboard.page";
import { SubjectPage } from "./pages/subject.page";
import { QuestPage } from "./pages/quest.page";
import { NavBar } from "./pages/nav.page";
import { LeaderboardPage } from "./pages/leaderboard.page";
import { ShopPage } from "./pages/shop.page";
import { createAdminDb, type AdminDb } from "./helpers/db";

/**
 * Project-wide test fixtures. Specs get ready-to-use Page Objects bound to the
 * current `page`, plus `adminDb` (service-role) for deterministic data setup.
 * Authentication stays idiomatic: authed specs declare their role with
 * `test.use({ storageState: STORAGE_STATE.<role> })` (see helpers/users.ts).
 *
 * Add a new screen → add a Page Object under pages/ and wire one line here.
 *
 * NB: the fixture callback is named `provide` (not the conventional `use`) so the
 * react-hooks ESLint rule doesn't mistake it for React's `use` hook.
 */
type Pages = {
  landing: LandingPage;
  auth: AuthPage;
  dashboard: DashboardPage;
  subject: SubjectPage;
  quest: QuestPage;
  nav: NavBar;
  leaderboard: LeaderboardPage;
  shop: ShopPage;
};

type Helpers = {
  adminDb: AdminDb;
};

export const test = base.extend<Pages & Helpers>({
  landing: async ({ page }, provide) => {
    await provide(new LandingPage(page));
  },
  auth: async ({ page }, provide) => {
    await provide(new AuthPage(page));
  },
  dashboard: async ({ page }, provide) => {
    await provide(new DashboardPage(page));
  },
  subject: async ({ page }, provide) => {
    await provide(new SubjectPage(page));
  },
  quest: async ({ page }, provide) => {
    await provide(new QuestPage(page));
  },
  nav: async ({ page }, provide) => {
    await provide(new NavBar(page));
  },
  leaderboard: async ({ page }, provide) => {
    await provide(new LeaderboardPage(page));
  },
  shop: async ({ page }, provide) => {
    await provide(new ShopPage(page));
  },
  // Built lazily from env; only specs that request `adminDb` need the service key.
  // eslint-disable-next-line no-empty-pattern
  adminDb: async ({}, provide) => {
    await provide(createAdminDb());
  },
});

export { expect } from "@playwright/test";

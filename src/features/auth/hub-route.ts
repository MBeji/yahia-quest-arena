/** The landing screen of a signed-in user's own space. */
export type HubRoute = "/dashboard" | "/parent-report";

/**
 * Which screen is "home" for this user.
 *
 * A PARENT has no game profile — the Heroes' Hall would show them nothing — so
 * their space is the family report. EVERYONE ELSE, ADMINS INCLUDED, lands on the
 * Hall.
 *
 * Admins used to be sent to /parent-report as well, and that redirect broke the
 * whole shell: /dashboard is the return destination of the entire app — the header
 * logo, the account chip, the « Hall des héros » nav entry, and the « Retour au
 * hall » link of every /admin console. Bouncing the admin off it meant each of
 * those doors landed them back on /parent-report, so navigation looped and the
 * Hall was unreachable.
 *
 * Kept as a pure function so a single place decides, and the rule is unit-testable
 * in isolation — same contract as shouldRedirectToOnboarding.
 */
export function hubRouteForRole(role: string | null | undefined): HubRoute {
  return role === "parent" ? "/parent-report" : "/dashboard";
}

/**
 * True when a user landing on /dashboard must be sent to their own hub instead.
 * Only ever true for a parent — and never for a role that is still unknown
 * (loading), so no redirect fires before the profile is actually read.
 */
export function shouldLeaveDashboard(role: string | null | undefined): boolean {
  return hubRouteForRole(role) !== "/dashboard";
}

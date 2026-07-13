/**
 * Profile-first onboarding guard decision.
 *
 * A signed-in STUDENT with no active parcours must be sent to /onboarding to pick
 * their learning track. Parents and admins never enrol in a parcours (onboarding
 * is the student track picker), so they are exempt — otherwise a parent who signs
 * in or links a child via their alliance code is trapped in the student onboarding
 * loop and can never reach /parent-report (their whole feature set becomes
 * unreachable). Kept as a pure function so the layout stays thin and the rule is
 * unit-testable in isolation.
 */
export function shouldRedirectToOnboarding(params: {
  hasProfile: boolean;
  role: string | null;
  currentParcoursId: string | null;
  pathname: string;
}): boolean {
  const { hasProfile, role, currentParcoursId, pathname } = params;
  return (
    hasProfile && role === "student" && currentParcoursId == null && pathname !== "/onboarding"
  );
}

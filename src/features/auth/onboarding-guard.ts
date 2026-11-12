/**
 * Profile-first onboarding guard decision.
 *
 * A signed-in STUDENT with no active parcours must be sent to /onboarding to pick
 * their learning track — except on a quest they asked for (étude 38, lot 2). Parents and admins never enrol in a parcours (onboarding
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
  if (!hasProfile || role !== "student" || currentParcoursId != null) return false;
  if (pathname === "/onboarding") return false;
  // Étude 38, lot 2 (R-5, D-3) — l'accueil n'est plus un péage. Un élève qui a DEMANDÉ
  // une quête (tapée depuis un hub, ou suivie par un lien) la joue : l'assistant ne
  // s'interpose plus entre lui et ce qu'il venait faire. Rien ne l'exigeait —
  // `start_exercise_session` ne connaît aucune porte « parcours » — et la quête lui
  // propose sa classe en un geste (`ParcoursQuickPick`), avec le même pack de
  // bienvenue. SEULE la quête est épargnée : un hall sans parcours est un hall vide,
  // la redirection y reste le bon écran.
  if (pathname.startsWith("/quest/")) return false;
  return true;
}

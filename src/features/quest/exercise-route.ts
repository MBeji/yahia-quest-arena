/**
 * Auth-aware destination for a public exercise link (« Référence » register, C8).
 *
 * A signed-in visitor goes to the scored quest (`/quest`, XP); an anonymous one
 * goes to free practice (`/exercice`). Both registers now run the SAME
 * question-by-question player and enforce the SAME comprehension-quiz gate (the
 * public one tracks the pass in the browser session) — so the route choice
 * depends ONLY on whether the visitor is authenticated, never on the exercise
 * mode. (Routing an anonymous visitor's quiz tap to `/quest` would bounce them to
 * the login wall; sending it to `/exercice` keeps the public journey login-free,
 * where the quiz is playable and unlocks the chapter's exercises on a pass.)
 *
 * Single source of truth shared by <SubjectHub/> (the hub list) and
 * <LessonReader/> (the end-of-course « practise » CTA).
 */
export function exerciseRouteFor(
  isAuthenticated: boolean,
): "/quest/$exerciseId" | "/exercice/$exerciseId" {
  return isAuthenticated ? "/quest/$exerciseId" : "/exercice/$exerciseId";
}

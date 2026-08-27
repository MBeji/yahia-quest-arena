// R-1 (é11) — LES REFUS DE LA PORTE, et le seul endroit qui les nomme.
//
// `can_use_tutor` rend un CODE, jamais une phrase : la porte est un juge SQL, et
// aucun enfant ne lit `ACTIVE_SESSION`. La traduction vit donc ici, hors des
// deux écrans qui l'appliquent — la correction d'une question et le chat d'un
// chapitre — parce qu'ils doivent la MÊME phrase au même refus. Deux copies
// auraient divergé au premier code ajouté.
//
// Ce que ce module REFUSE de faire compte autant : un code qu'il ne connaît pas
// rend `null`, et l'écran s'efface plutôt que d'inventer (R-A1.2-3). Jamais un
// code technique sous les yeux d'un élève.

/** Les clés du catalogue (`t.tutor[…]`) pour les refus qu'on sait dire. */
export type TutorLockedKey =
  "lockedSession" | "lockedDungeon" | "lockedDuel" | "lockedNotAttempted";

const LOCKED_KEYS: Readonly<Record<string, TutorLockedKey>> = {
  ACTIVE_SESSION: "lockedSession",
  ACTIVE_DUNGEON: "lockedDungeon",
  ACTIVE_DUEL: "lockedDuel",
  NOT_ATTEMPTED: "lockedNotAttempted",
};

/**
 * La clé d'affichage d'un refus de porte, ou `null` s'il n'y en a pas.
 *
 * `null` couvre les deux cas où se taire est la bonne réponse : un refus
 * technique (`BAD_SCOPE`, `NOT_AUTHENTICATED`) et un code inconnu — celui d'une
 * version future, ou d'une porte qu'on n'a pas su interroger.
 */
export function tutorLockedKey(reason: string): TutorLockedKey | null {
  return LOCKED_KEYS[reason] ?? null;
}

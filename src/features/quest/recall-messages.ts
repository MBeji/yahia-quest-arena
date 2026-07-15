/**
 * Recall mode (étude 17) gate messages. Kept in a ZERO-import module on purpose:
 * the connected route (`/quest/$exerciseId`) imports these plain strings to map a
 * failed `startExerciseSession` onto its recall lock screen. Re-exporting them
 * from `quest.server.ts` would drag that server module's whole client-side
 * evaluation into the browser `index` chunk (bundle-budget regression). The RPC
 * raises a stable token per gate; these are the localized surfaces (same pattern
 * as QUIZ_LOCKED). `RECALL_LOCKED` = the classic run isn't mastered yet;
 * `RECALL_NOT_ELIGIBLE` = the mission can't be played in recall at all
 * (quiz/non-admin/too few eligible questions); `INVALID_VARIANT` (a programming
 * error — the input is a closed enum) maps to the not-eligible surface.
 */
export const RECALL_LOCKED_MESSAGE =
  "Réussis d'abord cette mission à 100 % en QCM pour débloquer le mode Rappel.";
export const RECALL_NOT_ELIGIBLE_MESSAGE = "Cette mission ne peut pas être jouée en mode Rappel.";

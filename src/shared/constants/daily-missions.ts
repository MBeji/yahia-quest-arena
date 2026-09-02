/**
 * Étude 31 lot 3 — les types de missions du jour, côté code.
 *
 * La base tire trois missions d'un pool de huit (`app_daily_mission_pool`), plus
 * une ligne de BONUS DE COMPLÉTION. Ce module n'est pas la source de vérité du
 * pool — elle est en SQL, là où l'éligibilité se calcule — mais il fixe les deux
 * choses que le client doit savoir sans deviner :
 *
 *   * `DAILY_COMPLETE_TYPE` : la ligne qui n'est PAS une mission, mais la fin de
 *     la journée. La rendre comme une quatrième carte ferait mentir « 3 missions
 *     du jour » et noierait la célébration de fin (R-6) ;
 *   * `DAILY_MISSION_TYPES` : la liste fermée, pour qu'un type ajouté en SQL sans
 *     son libellé se voie en test plutôt qu'à l'écran, en anglais technique.
 */

/** La ligne de bonus : cible = le nombre de missions du jour, 5 XP / 1 pièce (R-11). */
export const DAILY_COMPLETE_TYPE = "daily_complete";

/** Les huit types de missions du pool (R-10), dans l'ordre de l'étude. */
export const DAILY_MISSION_TYPES = [
  "exercises_n",
  "review_due",
  "subject_focus",
  "score_90",
  "recall_one",
  "dungeon_floors",
  "duel_play",
  "chapter_step",
] as const;

export type DailyMissionType = (typeof DAILY_MISSION_TYPES)[number];

/** L'enveloppe du jour (R-11), constante : 3 × 15 + 5 = 50 XP, 3 × 3 + 1 = 10 pièces. */
export const DAILY_MISSION_XP = 15;
export const DAILY_MISSION_COINS = 3;
export const DAILY_COMPLETE_XP = 5;
export const DAILY_COMPLETE_COINS = 1;
export const DAILY_MISSIONS_PER_DAY = 3;

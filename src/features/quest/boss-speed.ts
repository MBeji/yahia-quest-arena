import {
  BOSS_PAR_SECONDS_PER_QUESTION,
  BOSS_RANK_MIN_DAMAGE,
  BOSS_SPEED_WEIGHTS,
} from "@/shared/constants/gamification";

// =============================================================================
// Notation du combat de boss AU CHRONOMÈTRE.
//
// Le chronomètre est ouvert : il n'interrompt personne, il note. Chaque question
// répondue retire au boss une part de HP d'autant plus grande qu'elle a été
// répondue vite — jamais nulle. La barre de HP du combat EST donc le score du
// chronomètre, et le rang final n'est que sa lecture.
//
// Module PUR (aucun React, aucun réseau) : c'est ce qui le rend testable seul, et
// c'est aussi la raison pour laquelle il ne connaît ni la justesse des réponses
// (la clé n'atteint jamais le client) ni les XP (correction seule, cf.
// `gamification.ts`). Il ne sait que lire une durée.
// =============================================================================

/** Palier de rapidité d'une réponse, mesuré au chronomètre ouvert. */
export type BossSpeedTier = keyof typeof BOSS_SPEED_WEIGHTS;

/** Palier d'une réponse rendue en `seconds` secondes. */
export function bossSpeedTier(seconds: number): BossSpeedTier {
  if (seconds <= BOSS_PAR_SECONDS_PER_QUESTION) return "critical";
  if (seconds <= BOSS_PAR_SECONDS_PER_QUESTION * 2) return "fast";
  return "steady";
}

/**
 * Points de HP (sur 100) retirés au boss par une question répondue en `seconds`.
 * Une manche entièrement jouée sous le temps de référence met le boss à 0 ; une
 * manche entièrement au-delà le laisse à 50 — debout, mais l'élève a fini son
 * exercice sans avoir été coupé une seule fois.
 */
export function bossDamageFor(seconds: number, totalQuestions: number): number {
  if (totalQuestions <= 0) return 0;
  return (100 / totalQuestions) * BOSS_SPEED_WEIGHTS[bossSpeedTier(Math.max(0, seconds))];
}

/** Rang final du combat, lu sur les dégâts cumulés. */
export function bossRankForDamage(damage: number): BossSpeedTier {
  if (damage >= BOSS_RANK_MIN_DAMAGE.critical) return "critical";
  if (damage >= BOSS_RANK_MIN_DAMAGE.fast) return "fast";
  return "steady";
}

/** HP restants du boss (0–100) pour des dégâts cumulés donnés. */
export function bossHpForDamage(damage: number): number {
  return Math.min(100, Math.max(0, Math.round(100 - damage)));
}

/**
 * Chronomètre lisible : `42s` sous la minute, `2:07` au-delà. Le format long
 * n'existait pas quand le compteur était plafonné à 20 s — il devient la norme
 * dès lors qu'on laisse l'élève prendre le temps qu'il lui faut.
 */
export function formatChrono(seconds: number): string {
  const s = Math.max(0, Math.floor(seconds));
  if (s < 60) return `${s}s`;
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;
}

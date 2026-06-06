import { PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";

export interface NoXpResult {
  tooFast: boolean;
  scorePct: number;
  improved: boolean;
}

/**
 * Explains, in one short playful sentence, why an attempt earned no XP.
 *
 * Mirrors the server-side anti-rush / anti-farm gate (XP is awarded only when
 * the attempt is not too fast, scores ≥ 60%, AND beats the previous best).
 * Order matches the server's precedence: too-fast → under-threshold → not
 * improved. Kept as a pure helper so it is unit-testable and keeps the result
 * route thin.
 */
export function noXpReason(result: NoXpResult): string {
  if (result.tooFast) {
    return "⏱️ Trop rapide — aucune XP. Prends le temps de lire et de comprendre chaque question.";
  }
  if (result.scorePct < PASS_THRESHOLD_PCT) {
    return "🎯 Sous 60 % — aucune XP. Répondre au hasard ne rapporte rien : vise la compréhension.";
  }
  if (!result.improved) {
    return "✅ Déjà maîtrisé — pas de nouvelle XP. Bats ton meilleur score sur cet exercice pour en regagner.";
  }
  return "Aucune XP gagnée cette fois.";
}

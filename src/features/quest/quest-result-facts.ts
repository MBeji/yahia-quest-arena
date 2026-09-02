import { levelForXp } from "@/shared/lib/level";
import { trackProductEvent } from "@/shared/lib/product-events";

/** Ce que le lecteur d'exercice sait d'une tentative rendue par le serveur. */
export type FinishedQuest = {
  scorePct: number;
  xpEarned: number;
  replayed?: boolean;
  profile: Record<string, unknown> | null;
  unlockedBadges: readonly { code: string }[];
};

/**
 * Le palier FRANCHI par cette tentative, ou `null` s'il n'y en a pas.
 *
 * ⚠️ PAS SUR UN REJEU. Le calcul suppose que `profile.xp` est celui d'APRÈS
 * cette tentative-ci ; sur un résultat relu, le profil rendu est l'actuel, qui a
 * pu gagner de l'XP depuis (d'autres missions). La soustraction ne désigne alors
 * plus rien, et la célébration se déclencherait — ou pas — au hasard. Le score,
 * lui, reste affiché : il est exact, et c'est souvent la première fois que
 * l'élève le voit.
 *
 * Le registre anonyme ne monte jamais de palier : il ne gagne pas d'XP.
 */
export function levelCrossedBy(result: FinishedQuest, rewarded: boolean): number | null {
  if (!rewarded || result.xpEarned <= 0 || result.replayed) return null;
  const level = Number(result.profile?.level ?? 0);
  const previous = levelForXp(Number(result.profile?.xp ?? 0) - result.xpEarned);
  return level > previous ? level : null;
}

/**
 * Étude 31 lot 1 — ce qu'une fin de quête PRODUIT comme faits, sorti du lecteur
 * d'exercice : le palier franchi, et les trois événements du funnel.
 *
 * Ils vivent ici plutôt que dans `exercise-player.tsx` pour deux raisons : le
 * lecteur est déjà au plafond de complexité (`max-lines`, la règle qui a fait
 * extraire l'écran de résultat), et une émission d'événement se teste mieux
 * seule que derrière un rendu complet.
 *
 * **`quest_completed` part aussi pour le registre ANONYME.** Le visiteur qui
 * joue sans compte est précisément celui que US-10 cherche à convertir :
 * l'effacer du funnel reviendrait à ne mesurer que les convertis, donc à trouver
 * la conversion excellente. Les deux autres événements supposent un compte (pas
 * de badge ni de niveau sans profil).
 *
 * **Zéro PII** (D-1) : une matière est un slug de catalogue public, un code de
 * badge une constante ; aucun identifiant de personne ne sort d'ici.
 */
export function emitQuestResultTelemetry(params: {
  result: FinishedQuest;
  subjectId: string | null | undefined;
  variant: "classic" | "recall";
  isQuiz: boolean;
  /** Registre connecté (XP, pièces, badges) — faux pour la pratique anonyme. */
  rewarded: boolean;
  passed: boolean;
  /** Le niveau ATTEINT, ou null si la tentative n'a pas fait monter de palier. */
  leveledUpTo: number | null;
}): void {
  const { result } = params;
  trackProductEvent("quest_completed", {
    subject_id: params.subjectId ?? undefined,
    variant: params.variant,
    is_quiz: params.isQuiz,
    passed: params.passed,
    score_pct: result.scorePct,
    xp_earned: result.xpEarned,
    replayed: Boolean(result.replayed),
    anonymous: !params.rewarded,
  });
  if (!params.rewarded) return;
  for (const badge of result.unlockedBadges) {
    trackProductEvent("badge_earned", { badge_code: badge.code, source: "quest" });
  }
  if (params.leveledUpTo !== null) {
    trackProductEvent("level_up", { level: params.leveledUpTo });
  }
}

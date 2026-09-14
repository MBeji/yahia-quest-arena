import type { QuestionVerdict } from "./verdict";
import type { UnlockedBadge } from "@/shared/types/gamification";

/**
 * LES TYPES DE DONNÉES DU LECTEUR D'EXERCICE.
 *
 * Sortis de `exercise-player.tsx` quand il a atteint sa limite de 750 lignes. Ce
 * n'est pas qu'une question de taille : ces quatre types sont le CONTRAT entre le
 * lecteur et ses deux registres (connecté et anonyme), et les deux routes les
 * importent. Les avoir à part dit que le contrat se lit sans lire le composant.
 */
export type PlayerAnswer = { questionId: string; choice: string };

export type { QuestionVerdict };

export type PlayerReviewItem = {
  questionId: string;
  prompt: string;
  selectedChoice: string;
  correctChoice: string;
  isCorrect: boolean;
  explanation: string | null;
  /**
   * Étude 04 lot A1.2 — l'erreur nommée et son chapitre. OPTIONNELS à dessein :
   * la correction anonyme (`check_answers`) n'a ni l'une ni l'autre, et le rendu
   * dégradé est le comportement exigé (R-A1.2-3), pas un cas d'erreur.
   */
  misconceptionTag?: string | null;
  chapterId?: string | null;
  /** Les trois langues de l'erreur ; l'écran choisit la sienne (é07 `pickLabel`). */
  misconceptionLabels?: { fr: string; en: string; ar: string } | null;
  /** La compétence mise en défaut (A12) — cible du geste « m'entraîner ». */
  misconceptionCompetency?: string | null;
};

/** Unified result superset. Anonymous results leave the reward fields neutral. */
export type PlayerResult = {
  correct: number;
  total: number;
  scorePct: number;
  durationSeconds: number;
  reviewHidden: boolean;
  review: PlayerReviewItem[];
  // Reward fields — populated only by the connected strategy (rewards capability).
  xpEarned: number;
  coinsEarned: number;
  profile: Record<string, unknown> | null;
  unlockedBadges: UnlockedBadge[];
  potionApplied: { xpMultiplier: number; coinMultiplier: number } | null;
  retryShieldUsed: boolean;
  tooFast: boolean;
  improved: boolean;
  /**
   * Prime de rapidité appliquée aux XP du boss (1 = aucune). Décidée serveur ;
   * le registre anonyme, qui ne gagne pas d'XP, la laisse toujours à 1.
   */
  speedBonus: number;
  /** Anon quiz only: reached the score but rushed, so the chapter stays locked. */
  quizTooFast?: boolean;
  /**
   * Ce résultat est RELU : la session était déjà rendue et la RPC a renvoyé la
   * tentative enregistrée au lieu de lever (migration 20260831130000). Le score
   * est le vrai ; les compteurs de récompense, eux, sont neutres — ils ont été
   * crédités au premier rendu. Absent dans le registre anonyme.
   */
  replayed?: boolean;
};

/** Outcome of starting an exercise: a playable session, or a gate that blocks it. */
export type StartOutcome =
  | { ok: true; sessionId: string }
  | { ok: false; kind: "quiz" }
  | { ok: false; kind: "premium"; message: string }
  // Recall gates (étude 17): the classic run isn't mastered yet ("locked") or
  // the mission can't be played in recall at all ("not-eligible").
  | { ok: false; kind: "recall"; reason: "locked" | "not-eligible" };

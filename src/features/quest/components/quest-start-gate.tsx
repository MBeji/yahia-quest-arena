import type { StartOutcome } from "../player-types";
import type { QuestContentLang, QuestLabels } from "@/shared/lib/quest-labels";
import { QuizLockScreen } from "@/features/quest/components/quiz-lock-screen";
import type { ExercisePlayerStrategy } from "@/features/quest/components/exercise-player";

/**
 * Les portes qui bloquent le DÉMARRAGE d'une partie — sorties de
 * `exercise-player.tsx` (2026-11-03) : trois écrans complets, sans état partagé
 * avec la boucle de jeu, qui ne dépendent que de ce que `startExerciseSession` a
 * répondu.
 *
 * - premium (connecté seulement) : la stratégie possède la mise en page du mur ;
 * - quiz de compréhension : les exercices d'un chapitre restent verrouillés tant
 *   que son quiz n'est pas réussi (connecté : côté serveur ; anonyme : local à la
 *   session). Même écran, seule la destination du « passer le quiz » change ;
 * - rappel (étude 17) : le mode rappel de la mission est verrouillé (classique pas
 *   encore maîtrisé) ou inéligible. Même motif que le quiz ; le CTA devient
 *   « rejouer cette mission en QCM ».
 */
export function QuestStartGate({
  gate,
  strategy,
  labels,
  exerciseId,
  chapterId,
  subjectId,
  chapterQuizId,
  rtl,
  contentLang,
}: {
  gate: Exclude<StartOutcome, { ok: true }>;
  strategy: Pick<ExercisePlayerStrategy, "quizExerciseTo" | "renderPremiumLock">;
  labels: QuestLabels;
  exerciseId: string;
  chapterId: string | null;
  subjectId: string | null;
  chapterQuizId: string | null;
  rtl: boolean;
  contentLang: QuestContentLang;
}) {
  if (gate.kind === "premium") {
    return strategy.renderPremiumLock?.({ message: gate.message, subjectId, contentLang }) ?? null;
  }

  if (gate.kind === "quiz") {
    return (
      <QuizLockScreen
        title={labels.lockedTitle}
        body={labels.lockedBody}
        takeQuizLabel={labels.takeQuiz}
        reviewLabel={labels.review}
        backLabel={labels.back}
        quizId={chapterQuizId}
        chapterId={chapterId}
        subjectId={subjectId}
        rtl={rtl}
        quizExerciseTo={strategy.quizExerciseTo}
      />
    );
  }

  const locked = gate.reason === "locked";
  return (
    <QuizLockScreen
      title={locked ? labels.recallLockedTitle : labels.recallNotEligibleTitle}
      body={locked ? labels.recallLockedBody : labels.recallNotEligibleBody}
      takeQuizLabel={labels.recallReplayQcm}
      reviewLabel={labels.review}
      backLabel={labels.back}
      quizId={exerciseId}
      chapterId={chapterId}
      subjectId={subjectId}
      rtl={rtl}
      quizExerciseTo={strategy.quizExerciseTo}
    />
  );
}

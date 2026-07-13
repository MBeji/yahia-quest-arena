import { Link } from "@tanstack/react-router";
import { BookOpen, Brain, Lock } from "lucide-react";
import { useT } from "@/lib/i18n";
import { QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";

/**
 * The quiz's pedagogical contract, said ON the quiz itself (étude 15 lot 7,
 * R-4 — audit §B-5: the central gate used to be invisible on the very screen
 * that runs it). Rendered by the player under the quiz header.
 */
export function QuizContractHint({ className = "" }: { className?: string }) {
  const t = useT();
  return (
    <p className={`text-xs text-muted-foreground ${className}`}>
      🧠 {t.quest.quizContract.replace("{pct}", String(QUIZ_PASS_THRESHOLD_PCT))}
    </p>
  );
}

/**
 * Shown when a chapter's comprehension quiz must be passed before its exercises
 * unlock — the gate is enforced server-side in `startExerciseSession`, the route
 * just reflects the rejection. Purely presentational: the route owns the trigger
 * condition and supplies already-localized copy so this stays i18n-agnostic.
 */
export function QuizLockScreen({
  title,
  body,
  takeQuizLabel,
  reviewLabel,
  backLabel,
  quizId,
  chapterId,
  subjectId,
  rtl,
  quizExerciseTo = "/quest/$exerciseId",
}: {
  title: string;
  body: string;
  takeQuizLabel: string;
  reviewLabel: string;
  backLabel: string;
  quizId: string | null;
  chapterId: string | null;
  subjectId: string | null;
  rtl: boolean;
  /**
   * Where "take the quiz" routes: the scored quest (`/quest`, connected) or the
   * login-free public flow (`/exercice`, anonymous). Both screens are now the same
   * question-by-question player; only the destination register differs.
   */
  quizExerciseTo?: "/quest/$exerciseId" | "/exercice/$exerciseId";
}) {
  const takeQuizInner = (
    <>
      <Brain className="h-4 w-4" /> {takeQuizLabel}
    </>
  );
  const takeQuizClass =
    "inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-black shadow-gold hover:scale-105 [@media(pointer:coarse)]:min-h-11";
  return (
    <div className="mx-auto max-w-md px-6 py-16 text-center" dir={rtl ? "rtl" : undefined}>
      <div className="rounded-3xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-8">
        <Lock className="mx-auto h-12 w-12 text-[color:var(--neon-gold)]" />
        <h1 className="mt-4 font-display text-2xl font-bold">{title}</h1>
        <p className="mt-3 text-sm text-muted-foreground">{body}</p>
        <div className="mt-6 flex flex-wrap justify-center gap-3">
          {quizId &&
            (quizExerciseTo === "/exercice/$exerciseId" ? (
              <Link
                to="/exercice/$exerciseId"
                params={{ exerciseId: quizId }}
                className={takeQuizClass}
              >
                {takeQuizInner}
              </Link>
            ) : (
              <Link
                to="/quest/$exerciseId"
                params={{ exerciseId: quizId }}
                className={takeQuizClass}
              >
                {takeQuizInner}
              </Link>
            ))}
          {chapterId && (
            <Link
              to="/chapitre/$chapterId"
              params={{ chapterId }}
              className="inline-flex items-center gap-1.5 rounded-lg border border-border bg-black/50 px-5 py-2.5 text-sm font-semibold hover:bg-black/80 [@media(pointer:coarse)]:min-h-11"
            >
              <BookOpen className="h-4 w-4" /> {reviewLabel}
            </Link>
          )}
          {subjectId && (
            <Link
              to="/matiere/$subjectId"
              params={{ subjectId }}
              className="inline-flex items-center rounded-lg border border-border bg-black/50 px-5 py-2.5 text-sm font-semibold hover:bg-black/80 [@media(pointer:coarse)]:min-h-11"
            >
              {backLabel}
            </Link>
          )}
        </div>
      </div>
    </div>
  );
}

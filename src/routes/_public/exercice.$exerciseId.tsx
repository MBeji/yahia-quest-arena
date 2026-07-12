import { createFileRoute, Link } from "@tanstack/react-router";
import { useServerFn } from "@tanstack/react-start";
import { useMemo, useRef } from "react";
import { Dumbbell, RotateCcw, Sparkles, Zap } from "lucide-react";
import { checkAnswersPublic, getChapterLesson, scoreQuizPublic } from "@/features/quest";
import {
  hasPassedChapterQuiz,
  isQuizGateLocked,
  markChapterQuizPassed,
} from "@/features/quest/anon-quiz-gate";
import {
  ExercisePlayer,
  type ExercisePlayerStrategy,
  type PlayerResult,
  type StartOutcome,
} from "@/features/quest/components/exercise-player";
import { MIN_SECONDS_PER_QUESTION, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { useAuth } from "@/features/auth";
import { useT } from "@/lib/i18n";

/**
 * Public « entraînement » register — login-free. Thin: builds the anonymous
 * strategy and hands it to the shared <ExercisePlayer/> (same question-by-question
 * flow as the connected quest, without rewards/sessions). The comprehension-quiz
 * gate now applies here too: a school chapter's exercises stay locked until the
 * visitor passes its quiz (tracked in the browser session) — parity with the
 * connected gate. Scoring is stateless (no XP, nothing recorded): non-quiz
 * exercises are corrected via `checkAnswersPublic`, the quiz is scored
 * aggregate-only via `scoreQuizPublic` (the answer key stays secret).
 */
export const Route = createFileRoute("/_public/exercice/$exerciseId")({
  head: () => ({ meta: [{ title: "Entraînement · Na9ra Nal3ab" }] }),
  component: ExercicePage,
});

function ExercicePage() {
  const { exerciseId } = Route.useParams();
  const { user } = useAuth();
  const isAuthenticated = !!user;
  const t = useT();
  const check = useServerFn(checkAnswersPublic);
  const score = useServerFn(scoreQuizPublic);
  const fetchLesson = useServerFn(getChapterLesson);
  // A passed quiz unlocks the chapter: keep the happy path unbroken by offering
  // the chapter's first exercise right on the result screen (audit §D-5). Refs:
  // set during submit(), read when the result footer renders.
  const quizJustPassedRef = useRef(false);
  const nextPracticeRef = useRef<string | null>(null);

  const strategy = useMemo<ExercisePlayerStrategy>(
    () => ({
      capabilities: { rewards: false, hints: false, boss: false, next: false },
      quizExerciseTo: "/exercice/$exerciseId",
      homeTo: "/",
      startSession: async ({ quizGated, chapterId, mode }): Promise<StartOutcome> => {
        // The quiz itself is always playable; only a gated non-quiz exercise locks
        // until this session has passed the chapter's comprehension quiz.
        if (
          mode !== "quiz" &&
          isQuizGateLocked({ quizGated, quizPassed: hasPassedChapterQuiz(chapterId) })
        ) {
          return { ok: false, kind: "quiz" };
        }
        return { ok: true, sessionId: "anon" };
      },
      submit: async ({
        exerciseId: exId,
        chapterId,
        answers,
        durationSeconds,
        isQuiz,
        totalQuestions,
      }): Promise<PlayerResult> => {
        const neutral = {
          xpEarned: 0,
          coinsEarned: 0,
          profile: null,
          unlockedBadges: [],
          potionApplied: null,
          retryShieldUsed: false,
          improved: false,
        };
        if (isQuiz) {
          const { correct, total, scorePct } = await score({
            data: { exerciseId: exId, answers },
          });
          // Mirror the connected gate exactly: a pass needs the score AND not
          // rushed (>= 4s/question), else a fast random pass would unlock.
          const notRushed = durationSeconds >= totalQuestions * MIN_SECONDS_PER_QUESTION;
          const reachedScore = scorePct >= QUIZ_PASS_THRESHOLD_PCT;
          const passedNow = reachedScore && notRushed;
          if (passedNow) markChapterQuizPassed(chapterId);
          quizJustPassedRef.current = passedNow;
          nextPracticeRef.current = null;
          if (passedNow) {
            try {
              const lesson = await fetchLesson({ data: { chapterId } });
              nextPracticeRef.current = lesson.practiceExerciseId ?? null;
            } catch {
              // continuation is a bonus — the result footer simply omits it
            }
          }
          return {
            correct,
            total,
            scorePct,
            durationSeconds,
            reviewHidden: true,
            review: [],
            tooFast: !notRushed,
            quizTooFast: reachedScore && !notRushed,
            ...neutral,
          };
        }
        quizJustPassedRef.current = false;
        const r = await check({ data: { exerciseId: exId, answers } });
        return {
          correct: r.correct,
          total: r.total,
          scorePct: r.scorePct,
          durationSeconds,
          reviewHidden: !r.reviewable,
          review: r.review.map((it) => ({
            questionId: it.questionId,
            prompt: "",
            selectedChoice: it.selectedChoice,
            correctChoice: it.correctChoice ?? "",
            isCorrect: it.isCorrect,
            explanation: it.explanation,
          })),
          tooFast: false,
          ...neutral,
        };
      },
      renderResultFooter: ({ exerciseId: exId, subjectId, onReplay }) => (
        <div className="mt-8 space-y-4">
          {/* Quiz just passed → the chapter is unlocked: continue straight into
              its first exercise instead of scrolling back through the hub. */}
          {quizJustPassedRef.current && nextPracticeRef.current && (
            <Link
              to="/exercice/$exerciseId"
              params={{ exerciseId: nextPracticeRef.current }}
              className="flex items-center justify-center gap-2 rounded-2xl bg-primary p-4 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              <Dumbbell className="h-4 w-4" /> {t.public.practice.continueCta}
            </Link>
          )}
          <div className="flex flex-wrap justify-center gap-3">
            <button
              type="button"
              onClick={onReplay}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
            >
              <RotateCcw className="h-4 w-4" /> {t.public.practice.restart}
            </button>
            {subjectId && (
              <Link
                to="/matiere/$subjectId"
                params={{ subjectId }}
                className="inline-flex items-center rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
              >
                {t.public.practice.back}
              </Link>
            )}
          </div>

          {isAuthenticated ? (
            <Link
              to="/quest/$exerciseId"
              params={{ exerciseId: exId }}
              className="flex items-center justify-center gap-2 rounded-2xl border border-primary/30 bg-primary/[0.04] p-4 text-sm font-semibold text-primary transition hover:bg-primary/10"
            >
              <Zap className="h-4 w-4" /> {t.public.practice.questCta}
            </Link>
          ) : (
            <div className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-5 text-center">
              <Sparkles className="mx-auto h-6 w-6 text-primary" />
              <p className="mt-2 text-sm font-semibold">{t.public.practice.inviteDesc}</p>
              <Link
                to="/signup"
                className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
              >
                {t.public.practice.inviteCta}
              </Link>
            </div>
          )}
        </div>
      ),
    }),
    [check, score, fetchLesson, isAuthenticated, t],
  );

  // `game-surface` carries the immersive player's light-theme remap (black→white
  // panels + ink text) so the quiz is readable in the public shell too — the
  // connected `.app-shell` provides the same remap, here it travels with the player.
  return (
    <div className="game-surface">
      <ExercisePlayer exerciseId={exerciseId} strategy={strategy} />
    </div>
  );
}

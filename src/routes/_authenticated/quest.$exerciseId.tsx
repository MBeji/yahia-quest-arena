import { createFileRoute, Link } from "@tanstack/react-router";
import { useServerFn } from "@tanstack/react-start";
import { useMemo } from "react";
import { ArrowLeft, Crown } from "lucide-react";
import {
  RECALL_LOCKED_MESSAGE,
  RECALL_NOT_ELIGIBLE_MESSAGE,
  revealHint,
  startExerciseSession,
  submitAttempt,
} from "@/features/quest";
import {
  ExercisePlayer,
  type ExercisePlayerStrategy,
  type PlayerResult,
  type StartOutcome,
} from "@/features/quest/components/exercise-player";
import { QuestResultActions } from "@/features/quest/components/quest-result-actions";
import { buildQuestLabels } from "@/features/quest/quest-labels";
import { useT } from "@/lib/i18n";
import { ReportErrorButton } from "@/features/content-report";
import { SubscriptionPaywall } from "@/features/subscription";

/**
 * Connected « quête » register. Thin: builds the connected strategy (session-based
 * scoring + XP/badges, hints, boss timer, premium gate, next/replay) and hands it
 * to the shared <ExercisePlayer/>. The play loop itself lives in the player, which
 * the public `/exercice` register reuses with an anonymous strategy — one
 * implementation, no drift.
 */
export const Route = createFileRoute("/_authenticated/quest/$exerciseId")({
  head: () => ({ meta: [{ title: "Quête · Na9ra Nal3ab" }] }),
  // Recall mode (étude 17) travels as a search param. Optional (not defaulted)
  // so every existing link to `/quest/$exerciseId` stays valid without passing a
  // search — the component treats an absent value as classic. Hand-rolled (no zod)
  // to keep the validator out of the eager index chunk (bundle budget).
  validateSearch: (search: Record<string, unknown>): { variant?: "classic" | "recall" } => {
    const variant = search.variant;
    return variant === "recall" || variant === "classic" ? { variant } : {};
  },
  component: QuestPage,
});

function QuestPage() {
  const { exerciseId } = Route.useParams();
  const { variant = "classic" } = Route.useSearch();
  const t = useT();
  const startSession = useServerFn(startExerciseSession);
  const submit = useServerFn(submitAttempt);
  const reveal = useServerFn(revealHint);

  const strategy = useMemo<ExercisePlayerStrategy>(
    () => ({
      capabilities: { rewards: true, hints: true, boss: true, next: true },
      quizExerciseTo: "/quest/$exerciseId",
      homeTo: "/dashboard",
      startSession: async ({ exerciseId: exId, variant: v }): Promise<StartOutcome> => {
        try {
          const res = await startSession({ data: { exerciseId: exId, variant: v } });
          return { ok: true, sessionId: res.sessionId };
        } catch (e) {
          const msg = e instanceof Error ? e.message : "";
          // The server fn raises localized, stable messages per gate.
          if (msg.startsWith("Parcours premium")) {
            return { ok: false, kind: "premium", message: msg };
          }
          if (msg.includes("quiz de compréhension")) return { ok: false, kind: "quiz" };
          if (msg === RECALL_LOCKED_MESSAGE) return { ok: false, kind: "recall", reason: "locked" };
          if (msg === RECALL_NOT_ELIGIBLE_MESSAGE) {
            return { ok: false, kind: "recall", reason: "not-eligible" };
          }
          throw e instanceof Error ? e : new Error(t.errors.sessionStartFailed);
        }
      },
      submit: async ({ sessionId, exerciseId: exId, answers }): Promise<PlayerResult> => {
        const res = await submit({ data: { sessionId, exerciseId: exId, answers } });
        return {
          correct: res.correct,
          total: res.total,
          scorePct: res.scorePct,
          durationSeconds: res.durationSeconds,
          reviewHidden: res.reviewHidden,
          review: res.review,
          xpEarned: res.xpEarned,
          coinsEarned: res.coinsEarned,
          profile: res.profile as Record<string, unknown> | null,
          unlockedBadges: res.unlockedBadges,
          potionApplied: res.potionApplied
            ? {
                xpMultiplier: res.potionApplied.xpMultiplier,
                coinMultiplier: res.potionApplied.coinMultiplier,
              }
            : null,
          retryShieldUsed: res.retryShieldUsed,
          tooFast: res.tooFast,
          improved: res.improved,
        };
      },
      revealHint: async (questionId) => {
        const r = await reveal({ data: { questionId } });
        return { questionId: r.questionId, hint: r.hint, consumed: r.consumed };
      },
      renderPremiumLock: ({ message, subjectId, contentLang }) => {
        const QL = buildQuestLabels(contentLang);
        return (
          <div className="mx-auto max-w-md px-6 py-12 text-center">
            <div className="rounded-3xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-8">
              <Crown className="mx-auto h-12 w-12 text-[color:var(--neon-gold)]" />
              <h1 className="mt-4 font-display text-2xl font-bold">{QL.eliteLockedTitle}</h1>
              <p className="mt-3 text-sm text-muted-foreground">{message}</p>
              <SubscriptionPaywall />
              {subjectId && (
                <Link
                  to="/matiere/$subjectId"
                  params={{ subjectId }}
                  className="mt-5 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
                >
                  <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {QL.back}
                </Link>
              )}
            </div>
          </div>
        );
      },
      renderResultFooter: ({ exerciseId: exId, subjectId, nextExerciseId, onReplay }) => (
        <>
          <QuestResultActions
            subjectId={subjectId}
            nextExerciseId={nextExerciseId}
            onReplay={onReplay}
          />
          <ReportErrorButton exerciseId={exId} />
        </>
      ),
    }),
    [startSession, submit, reveal, t],
  );

  // `game-surface` makes the player self-contained (it carries the same light-theme
  // remap the surrounding `.app-shell` provides), so the connected and public
  // registers render identically.
  return (
    <div className="game-surface">
      <ExercisePlayer exerciseId={exerciseId} strategy={strategy} variant={variant} />
    </div>
  );
}

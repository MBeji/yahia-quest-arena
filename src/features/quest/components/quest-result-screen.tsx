import { Link } from "@tanstack/react-router";
import { motion } from "motion/react";
import { type ReactNode } from "react";
import { Trophy, BookOpen } from "lucide-react";
import { PASS_THRESHOLD_PCT, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { noXpReason } from "@/features/quest/no-xp-reason";
import { QuestRewardGrid } from "@/features/quest/components/quest-reward-grid";
import { QuestReviewList } from "@/features/quest/components/quest-review-list";
import { buildQuestLabels, type QuestContentLang } from "@/features/quest/quest-labels";
import { Confetti } from "@/features/quest/components/confetti";
import { LevelUpCelebration } from "@/components/ui/level-up-celebration";
import { ExplainHint } from "@/components/ui/explain-hint";
import { useT } from "@/lib/i18n";
import { PageShell } from "@/components/ui/page-shell";
import { useEntrance } from "@/shared/lib/motion";
import type { PlayerResult } from "@/features/quest/components/exercise-player";

// =============================================================================
// <QuestResultScreen> — the result screen of the shared <ExercisePlayer/>,
// extracted to keep the play-loop file under the max-lines complexity cap. It is
// purely presentational: the player owns all state and passes it in. Recall mode
// (étude 17) adds a title badge and, on a classic 100% run, the "recall unlocked"
// celebration + CTA.
// =============================================================================

export function QuestResultScreen({
  result,
  isQuiz,
  isRtl,
  isRecall,
  rewards,
  recallUnlockable,
  qlang,
  chapterId,
  subjectId,
  exerciseId,
  nextExerciseId,
  showConfetti,
  showLevelUp,
  onLevelUpComplete,
  onReplay,
  renderResultFooter,
  resolvePrompt,
  getDisplayChoice,
}: {
  result: PlayerResult;
  isQuiz: boolean;
  isRtl: boolean;
  isRecall: boolean;
  rewards: boolean;
  recallUnlockable: boolean;
  qlang: QuestContentLang;
  chapterId: string | null;
  subjectId: string | null;
  exerciseId: string;
  nextExerciseId: string | null;
  showConfetti: boolean;
  showLevelUp: boolean;
  onLevelUpComplete: () => void;
  onReplay: () => void;
  renderResultFooter: (ctx: {
    exerciseId: string;
    subjectId: string | null;
    nextExerciseId: string | null;
    onReplay: () => void;
    result: PlayerResult;
  }) => ReactNode;
  resolvePrompt: (questionId: string) => string;
  getDisplayChoice: (questionId: string, choice: string) => string;
}) {
  const t = useT();
  const scaleIn = useEntrance("scale");
  const QL = buildQuestLabels(qlang);
  const passed = result.scorePct >= (isQuiz ? QUIZ_PASS_THRESHOLD_PCT : PASS_THRESHOLD_PCT);
  const resultLevel = Number(result.profile?.level ?? 1);

  return (
    <PageShell width="narrow" className="py-12" dir={isRtl ? "rtl" : undefined}>
      {rewards && showConfetti && <Confetti />}
      {rewards && (
        <LevelUpCelebration
          show={showLevelUp}
          newLevel={resultLevel}
          xpGained={result.xpEarned}
          onComplete={onLevelUpComplete}
        />
      )}
      <motion.div
        {...scaleIn}
        className="relative overflow-hidden rounded-3xl border border-gold/40 bg-black/60 p-8 text-center backdrop-blur-xl shadow-gold"
      >
        <div className="absolute -top-20 left-1/2 h-48 w-48 -translate-x-1/2 rounded-full bg-gold/30 blur-3xl" />
        <div className="relative">
          <div className="animate-gold-pulse mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)]">
            <Trophy className="h-10 w-10 text-primary-foreground" />
          </div>
          <h1 className="mt-5 font-display text-3xl font-bold">
            {passed ? t.quest.victoryTitle : t.quest.niceTriTitle}
          </h1>
          {isRecall && (
            <div
              className="mx-auto mt-3 inline-flex items-center gap-1.5 rounded-full border border-(--gold)/40 bg-(--gold)/10 px-3 py-1 text-xs font-bold text-(--gold)"
              data-testid="recall-result-badge"
            >
              🧠 {t.quest.recallBadge}
            </div>
          )}
          <p className="mt-1 text-muted-foreground" data-testid="quest-score">
            <ExplainHint
              text={t.explain.questResultScore
                .replace("{correct}", String(result.correct))
                .replace("{total}", String(result.total))}
            >
              {t.quest.resultScore
                .replace("{correct}", String(result.correct))
                .replace("{total}", String(result.total))
                .replace("{pct}", String(Math.round(result.scorePct)))}
            </ExplainHint>
          </p>
          <p className="mt-1 text-xs uppercase tracking-widest text-muted-foreground">
            {/* "Server-validated" only holds on the connected strategy — anon measures client-side. */}
            {(rewards ? t.quest.serverValidatedTime : t.quest.timeSpent).replace(
              "{n}",
              String(result.durationSeconds),
            )}
          </p>
          {isQuiz && (
            <div
              className={`mt-4 rounded-2xl border p-4 text-sm font-semibold ${
                passed && !result.quizTooFast
                  ? "border-success/40 bg-success/10 text-success"
                  : "border-neon-gold/50 bg-neon-gold/10 text-neon-gold"
              }`}
              dir={isRtl ? "rtl" : undefined}
            >
              {result.quizTooFast
                ? QL.quizTooFast
                : passed
                  ? QL.quizPassedBanner
                  : QL.quizFailedBanner}
              {(!passed || result.quizTooFast) && chapterId && (
                <Link
                  to="/chapitre/$chapterId"
                  params={{ chapterId }}
                  className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-xs font-bold text-primary-foreground shadow-gold hover:scale-105"
                >
                  <BookOpen className="h-4 w-4" /> {QL.review}
                </Link>
              )}
            </div>
          )}
          {rewards && result.xpEarned === 0 && (
            <div className="mt-6 rounded-xl border border-gold/30 bg-gold/5 p-3 text-center text-xs text-gold">
              {noXpReason(result)}
            </div>
          )}
          {rewards && result.potionApplied && (
            <div className="mt-6 rounded-xl border border-gold/40 bg-gold/10 p-3 text-center text-sm font-bold text-gold">
              {result.potionApplied.xpMultiplier > 1
                ? t.quest.potionXpApplied.replace("{x}", String(result.potionApplied.xpMultiplier))
                : t.quest.potionCoinsApplied.replace(
                    "{x}",
                    String(result.potionApplied.coinMultiplier),
                  )}
            </div>
          )}
          {rewards && (
            <>
              <QuestRewardGrid
                xpEarned={result.xpEarned}
                coinsEarned={result.coinsEarned ?? 0}
                level={(result.profile?.level as number | string) ?? "?"}
                streak={(result.profile?.current_streak as number) ?? 0}
              />
              <div className="mt-6 text-xs uppercase tracking-widest text-[color:var(--champagne)]">
                {result.profile?.hero_class as string}
              </div>
              {result.unlockedBadges.length > 0 && (
                <div className="mt-6 rounded-2xl border border-neon-gold/30 bg-neon-gold/10 p-4 text-start">
                  <div className="text-xs uppercase tracking-widest text-neon-gold">
                    {t.quest.badgesUnlocked}
                  </div>
                  <div className="mt-3 flex flex-wrap gap-3">
                    {result.unlockedBadges.map((badge) => (
                      <div key={badge.code} className="rounded-xl bg-black/70 px-4 py-3">
                        <div className="font-display text-sm font-bold">{badge.name}</div>
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">
                          {badge.rarity}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
              {result.retryShieldUsed && (
                <div className="mt-6 rounded-xl border border-gold/40 bg-gold/10 p-3 text-center text-sm font-bold text-gold">
                  {t.quest.retryShieldUsed}
                </div>
              )}
            </>
          )}

          {rewards && recallUnlockable && result.scorePct === 100 && (
            <div
              className="mt-6 rounded-2xl border border-(--gold)/40 bg-(--gold)/10 p-5 text-center"
              data-testid="recall-unlock"
            >
              <div className="font-display text-lg font-bold text-(--gold)">
                🧠 {t.quest.recallUnlockedTitle}
              </div>
              <p className="mt-1 text-sm text-muted-foreground">{t.quest.recallUnlockedBody}</p>
              <Link
                to="/quest/$exerciseId"
                params={{ exerciseId }}
                search={{ variant: "recall" }}
                className="mt-4 inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-black shadow-gold transition hover:scale-105"
              >
                {t.quest.recallPlay}
              </Link>
            </div>
          )}

          {renderResultFooter({
            exerciseId,
            subjectId,
            nextExerciseId,
            onReplay,
            result,
          })}

          {!isQuiz && !result.reviewHidden && result.review.length > 0 && (
            <QuestReviewList
              review={result.review}
              labels={{
                questReview: t.quest.questReview,
                questionN: t.quest.questionN,
                passed: t.quest.passed,
                needsWork: t.quest.needsWork,
                yourAnswer: t.quest.yourAnswer,
                correctAnswer: t.quest.correctAnswer,
              }}
              resolvePrompt={resolvePrompt}
              getDisplayChoice={getDisplayChoice}
            />
          )}
        </div>
      </motion.div>
    </PageShell>
  );
}

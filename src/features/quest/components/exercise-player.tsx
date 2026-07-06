import { Link } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from "react";
import { ArrowLeft, Loader2, Trophy, Skull, Heart, BookOpen, Check } from "lucide-react";
import { toast } from "sonner";
import { computeNextExerciseId, getExercise, getSubject } from "@/features/quest";
import { PASS_THRESHOLD_PCT, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { shuffleOptions, type BaseOption } from "@/shared/lib/question-utils";
import { isValidAnswerFormat, TIMEOUT_ANSWER_CHOICE } from "@/shared/lib/answer-formats";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import { RichField } from "@/components/ui/svg-figure";
import { QuestionInput, type McqOptionRender } from "@/features/quest/components/question-input";
import { levelForXp } from "@/shared/lib/level";
import { noXpReason } from "@/features/quest/no-xp-reason";
import { QuestRewardGrid } from "@/features/quest/components/quest-reward-grid";
import { QuestReviewList } from "@/features/quest/components/quest-review-list";
import { QuizLockScreen } from "@/features/quest/components/quiz-lock-screen";
import { QuestHintButton } from "@/features/quest/components/quest-hint-button";
import { BossCountdown } from "@/features/quest/components/boss-countdown";
import { buildQuestLabels, type QuestContentLang } from "@/features/quest/quest-labels";
import { Confetti } from "@/features/quest/components/confetti";
import { LevelUpCelebration } from "@/components/ui/level-up-celebration";
import { ExplainHint } from "@/components/ui/explain-hint";
import { useT } from "@/lib/i18n";
import { useSound } from "@/lib/sound";
import type { UnlockedBadge } from "@/shared/types/gamification";

// =============================================================================
// ExercisePlayer — the single question-by-question gameplay screen shared by the
// connected (`/quest`, scored) and anonymous (`/exercice`, login-free) registers.
//
// Both modes drive the SAME interaction model: one question at a time, select →
// validate → advance, then a result screen. Mode-specific behaviour (session
// scoring vs stateless scoring, rewards, hints, boss timer, premium gate, the
// comprehension-quiz gate's pass source, the result CTA) is injected via a
// `strategy`, so there is exactly one implementation of the play loop — no more
// drift between the two modes.
// =============================================================================

export type PlayerAnswer = { questionId: string; choice: string };

export type PlayerReviewItem = {
  questionId: string;
  prompt: string;
  selectedChoice: string;
  correctChoice: string;
  isCorrect: boolean;
  explanation: string | null;
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
  /** Anon quiz only: reached the score but rushed, so the chapter stays locked. */
  quizTooFast?: boolean;
};

/** Outcome of starting an exercise: a playable session, or a gate that blocks it. */
export type StartOutcome =
  | { ok: true; sessionId: string }
  | { ok: false; kind: "quiz" }
  | { ok: false; kind: "premium"; message: string };

export type ExercisePlayerStrategy = {
  capabilities: { rewards: boolean; hints: boolean; boss: boolean; next: boolean };
  /** Where the quiz-lock "take the quiz" CTA routes. */
  quizExerciseTo: "/quest/$exerciseId" | "/exercice/$exerciseId";
  /** Fallback "leave" destination when the exercise has no subject. */
  homeTo: "/dashboard" | "/";
  startSession: (ctx: {
    exerciseId: string;
    quizGated: boolean;
    chapterId: string | null;
    mode: string;
  }) => Promise<StartOutcome>;
  submit: (args: {
    sessionId: string;
    exerciseId: string;
    chapterId: string | null;
    answers: PlayerAnswer[];
    durationSeconds: number;
    isQuiz: boolean;
    totalQuestions: number;
  }) => Promise<PlayerResult>;
  revealHint?: (
    questionId: string,
  ) => Promise<{ questionId: string; hint: string | null; consumed: boolean }>;
  /** Premium paywall (connected only). */
  renderPremiumLock?: (ctx: {
    message: string;
    subjectId: string | null;
    contentLang: QuestContentLang;
  }) => ReactNode;
  /** Result-screen call-to-action (next/replay vs signup upsell). */
  renderResultFooter: (ctx: {
    exerciseId: string;
    subjectId: string | null;
    nextExerciseId: string | null;
    onReplay: () => void;
    result: PlayerResult;
  }) => ReactNode;
};

export function ExercisePlayer({
  exerciseId,
  strategy,
}: {
  exerciseId: string;
  strategy: ExercisePlayerStrategy;
}) {
  const t = useT();
  const { play } = useSound();
  const qc = useQueryClient();
  const fetchExercise = useServerFn(getExercise);
  const fetchSubjectForNext = useServerFn(getSubject);
  const { capabilities } = strategy;

  const { data, isLoading } = useQuery({
    queryKey: ["exercise", exerciseId],
    queryFn: () => fetchExercise({ data: { exerciseId } }),
  });

  const subjectIdForNext = data?.exercise?.subject_id ?? null;
  const siblingSubjectQuery = useQuery({
    queryKey: ["subject", subjectIdForNext],
    queryFn: () => fetchSubjectForNext({ data: { subjectId: subjectIdForNext as string } }),
    enabled: capabilities.next && Boolean(subjectIdForNext),
  });

  const nextExerciseId = useMemo<string | null>(() => {
    const sd = siblingSubjectQuery.data;
    const cur = data?.exercise;
    if (!sd || !cur) return null;
    return computeNextExerciseId(sd.chapters, sd.exercises, cur);
  }, [siblingSubjectQuery.data, data]);

  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<PlayerAnswer[]>([]);
  const [selected, setSelected] = useState<string | null>(null);
  const [showConfetti, setShowConfetti] = useState(false);
  const [showLevelUp, setShowLevelUp] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [startGate, setStartGate] = useState<Exclude<StartOutcome, { ok: true }> | null>(null);
  const [result, setResult] = useState<PlayerResult | null>(null);
  const [hintsRemaining, setHintsRemaining] = useState(0);
  const [revealedHints, setRevealedHints] = useState<Record<string, string | null>>({});

  // Wall-clock start of the run, used to measure the answer duration the anon
  // strategy needs for its anti-rush check (connected scoring is server-timed).
  const runStartedAtRef = useRef<number>(0);

  const sessionMutation = useMutation({
    mutationFn: (payload: {
      exerciseId: string;
      quizGated: boolean;
      chapterId: string | null;
      mode: string;
    }) => strategy.startSession(payload),
    onSuccess: (outcome) => {
      if (outcome.ok) {
        setSessionId(outcome.sessionId);
        runStartedAtRef.current = Date.now();
      } else {
        setStartGate(outcome);
      }
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : "Unable to start the quest"),
  });
  const { mutate: startSessionMutate, reset: resetSessionMutation } = sessionMutation;

  const mutation = useMutation({
    mutationFn: (payload: {
      sessionId: string;
      exerciseId: string;
      chapterId: string | null;
      answers: PlayerAnswer[];
      durationSeconds: number;
      isQuiz: boolean;
      totalQuestions: number;
    }) => strategy.submit(payload),
    onSuccess: (res) => {
      setResult(res);
      const passed = res.scorePct >= PASS_THRESHOLD_PCT;
      // Reward cue on the result screen (both connected and anon registers).
      play(passed ? "victory" : "wrong");
      if (capabilities.rewards) {
        if (passed) setShowConfetti(true);
        if (res.unlockedBadges.length > 0) setTimeout(() => play("badge"), 600);
        const profileLevel = Number(res.profile?.level ?? 0);
        const profileXp = Number(res.profile?.xp ?? 0);
        const prevLevel = levelForXp(profileXp - res.xpEarned);
        if (profileLevel > prevLevel && res.xpEarned > 0) {
          setTimeout(() => {
            setShowLevelUp(true);
            play("levelUp");
          }, 1200);
        }
        qc.invalidateQueries({ queryKey: ["dashboard"] });
        qc.invalidateQueries({ queryKey: ["subject"] });
      }
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.errors.errorFallback),
  });

  const hintCharges = data?.hintCharges ?? 0;
  useEffect(() => {
    setHintsRemaining(capabilities.hints ? hintCharges : 0);
  }, [hintCharges, exerciseId, capabilities.hints]);

  const hintMutation = useMutation({
    mutationFn: (payload: { questionId: string }) => {
      if (!strategy.revealHint) return Promise.reject(new Error("hints unsupported"));
      return strategy.revealHint(payload.questionId);
    },
    onSuccess: (res) => {
      setRevealedHints((prev) =>
        res.questionId in prev ? prev : { ...prev, [res.questionId]: res.hint },
      );
      if (res.consumed) setHintsRemaining((n) => Math.max(0, n - 1));
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.errors.errorFallback),
  });

  const questions = useMemo(() => data?.questions ?? [], [data?.questions]);
  // Resolve a review item's prompt: the connected review carries it; the anon
  // public correction does not, so the player fills it from the loaded questions.
  const promptByQuestionId = useMemo(
    () => new Map(questions.map((q) => [q.id, q.prompt])),
    [questions],
  );
  const shuffledOptionsByQuestionId = useMemo(() => {
    return new Map(
      questions.map((q) => [q.id, shuffleOptions((q.options as BaseOption[]) ?? [])] as const),
    );
  }, [questions]);

  const getDisplayChoice = useCallback(
    (questionId: string, choice: string) => {
      if (!choice) return "-";
      const opts = shuffledOptionsByQuestionId.get(questionId) ?? [];
      // mcq: show the option's display letter.
      const direct = opts.find((opt) => opt.id === choice)?.displayId;
      if (direct) return direct;
      // B2 CSV answers (ordering "b,a,…" / matching "l1:r2,…"): map each id
      // back to its option text when it is short plain text — raw shuffled ids
      // mean nothing to the student. SVG/long texts fall back to the id.
      if (choice.includes(",") || choice.includes(":")) {
        const textById = new Map(opts.map((opt) => [opt.id, opt.text]));
        const plain = (id: string) => {
          const text = textById.get(id);
          return text && !text.includes("<") && text.length <= 40 ? text : id;
        };
        const rendered = choice
          .replace(/\s+/g, "")
          .split(",")
          .map((part) => {
            const [left, right] = part.split(":");
            return right !== undefined ? `${plain(left)} ⇢ ${plain(right)}` : plain(left);
          })
          .join(" · ");
        return isolateLtrRuns(rendered);
      }
      // Otherwise (numeric value, give-up sentinel): the raw answer, LTR-isolated.
      return isolateLtrRuns(choice);
    },
    [shuffledOptionsByQuestionId],
  );

  const total = questions.length;
  const current = questions[idx];
  const currentType =
    (current as { question_type?: string | null } | undefined)?.question_type ?? "mcq";
  // The answer must match its type's wire format before it can be validated
  // (the server rejects malformed payloads with a client error). mcq option
  // ids and the boards' generated CSVs always pass; a half-typed number doesn't.
  const canValidate = Boolean(selected && isValidAnswerFormat(currentType, selected));
  const progress = useMemo(() => (total > 0 ? (idx / total) * 100 : 0), [idx, total]);
  const isQuiz = data?.exercise?.mode === "quiz";
  // Boss chrome + time pressure are a connected perk; an anon visitor plays a
  // boss exercise as a plain question-by-question quest (no timer).
  const bossMode = data?.exercise?.mode === "boss" && capabilities.boss;
  const subjectInfo = data?.exercise?.subjects as {
    color_token?: string;
    content_language?: string;
  } | null;
  const isRtlSubject = subjectInfo?.content_language === "ar";
  const qlang = (subjectInfo?.content_language ?? "fr") as QuestContentLang;
  const QL = useMemo(() => buildQuestLabels(qlang), [qlang]);

  const answeredQuestionRef = useRef<string | null>(null);
  const sessionStartedForRef = useRef<string | null>(null);
  const selectedRef = useRef(selected);
  const answersRef = useRef(answers);
  const idxRef = useRef(idx);
  const totalRef = useRef(total);
  const currentRef = useRef(current);
  const sessionIdRef = useRef(sessionId);
  selectedRef.current = selected;
  answersRef.current = answers;
  idxRef.current = idx;
  totalRef.current = total;
  currentRef.current = current;
  sessionIdRef.current = sessionId;

  const durationSeconds = useCallback(
    () => Math.max(0, Math.round((Date.now() - runStartedAtRef.current) / 1000)),
    [],
  );

  const submitRun = useCallback(
    (finalAnswers: PlayerAnswer[]) => {
      mutation.mutate({
        sessionId: sessionIdRef.current!,
        exerciseId,
        chapterId: (data?.exercise?.chapter_id as string | null) ?? null,
        answers: finalAnswers,
        durationSeconds: durationSeconds(),
        isQuiz: data?.exercise?.mode === "quiz",
        totalQuestions: totalRef.current,
      });
    },
    [mutation, exerciseId, durationSeconds, data?.exercise?.mode, data?.exercise?.chapter_id],
  );

  const handleBossTimeout = useCallback(() => {
    if (answeredQuestionRef.current === currentRef.current?.id) return;
    answeredQuestionRef.current = currentRef.current?.id ?? null;
    // A half-typed numeric answer at the buzzer must not fail the submission's
    // server-side format validation — fall back to the (always-valid) sentinel.
    const timeoutType =
      (currentRef.current as { question_type?: string | null } | undefined)?.question_type ?? "mcq";
    const timedSelection = selectedRef.current;
    const autoAnswer: PlayerAnswer = {
      questionId: currentRef.current?.id ?? "",
      choice:
        timedSelection && isValidAnswerFormat(timeoutType, timedSelection)
          ? timedSelection
          : TIMEOUT_ANSWER_CHOICE,
    };
    const nextAnswers = [...answersRef.current, autoAnswer];
    if (idxRef.current + 1 >= totalRef.current) {
      submitRun(nextAnswers);
    } else {
      setAnswers(nextAnswers);
      setIdx((i) => i + 1);
      setSelected(null);
      answeredQuestionRef.current = null;
    }
  }, [submitRun]);

  const bossHp = useMemo(() => {
    if (!bossMode || total === 0) return 100;
    return Math.max(0, Math.round(((total - idx) / total) * 100));
  }, [bossMode, total, idx]);

  const resetRun = useCallback(() => {
    answeredQuestionRef.current = null;
    sessionStartedForRef.current = null;
    resetSessionMutation();
    setResult(null);
    setStartGate(null);
    setIdx(0);
    setAnswers([]);
    setSelected(null);
    setShowConfetti(false);
    setShowLevelUp(false);
    setSessionId(null);
    setRevealedHints({});
    setHintsRemaining(capabilities.hints ? hintCharges : 0);
  }, [resetSessionMutation, hintCharges, capabilities.hints]);

  useEffect(() => {
    resetRun();
  }, [exerciseId, resetRun]);

  useEffect(() => {
    const ex = data?.exercise;
    if (!ex?.id || sessionId || result || startGate) return;
    if (sessionStartedForRef.current === ex.id) return;
    sessionStartedForRef.current = ex.id;
    startSessionMutate({
      exerciseId: ex.id,
      quizGated: data?.quizGated ?? false,
      chapterId: (ex.chapter_id as string | null) ?? null,
      mode: (ex.mode as string | null) ?? "",
    });
  }, [data, result, sessionId, startGate, startSessionMutate]);

  const advanceWithChoice = useCallback(
    (choice: string) => {
      if (!sessionId || !current?.id) return;
      if (answeredQuestionRef.current === current.id) return;
      answeredQuestionRef.current = current.id;
      const nextAnswers = [...answers, { questionId: current.id, choice }];
      if (idx + 1 >= total) {
        submitRun(nextAnswers);
        return;
      }
      setAnswers(nextAnswers);
      setIdx((i) => i + 1);
      setSelected(null);
      answeredQuestionRef.current = null;
    },
    [answers, current?.id, idx, sessionId, total, submitRun],
  );

  const validate = useCallback(() => {
    if (!selected || !canValidate || !sessionId) return;
    advanceWithChoice(selected);
  }, [advanceWithChoice, selected, canValidate, sessionId]);

  useEffect(() => {
    if (result) return;
    function handleKeyDown(e: KeyboardEvent) {
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return;
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        validate();
        return;
      }
      const optionsList = current ? (shuffledOptionsByQuestionId.get(current.id) ?? []) : [];
      const num = parseInt(e.key, 10);
      if (num >= 1 && num <= optionsList.length) {
        e.preventDefault();
        setSelected(optionsList[num - 1].id);
        return;
      }
      const letterIdx = "abcd".indexOf(e.key.toLowerCase());
      if (letterIdx >= 0 && letterIdx < optionsList.length) {
        e.preventDefault();
        setSelected(optionsList[letterIdx].id);
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  });

  const preparingScreen = (
    <div className="grid min-h-[60dvh] place-items-center text-sm text-muted-foreground">
      {t.quest.preparing}
    </div>
  );

  if (isLoading || !data) return preparingScreen;

  const chapterId = (data.exercise.chapter_id as string | null) ?? null;
  const exSubjectId = (data.exercise.subject_id as string | null) ?? null;

  // Premium gate (connected only): the strategy owns the paywall layout.
  if (startGate?.kind === "premium") {
    return (
      strategy.renderPremiumLock?.({
        message: startGate.message,
        subjectId: exSubjectId,
        contentLang: qlang,
      }) ?? null
    );
  }

  // Comprehension-quiz gate: a chapter's exercises stay locked until its quiz is
  // passed (connected: server-side; anon: session-local). Same lock screen, only
  // the "take the quiz" destination register differs.
  if (startGate?.kind === "quiz") {
    return (
      <QuizLockScreen
        title={QL.lockedTitle}
        body={QL.lockedBody}
        takeQuizLabel={QL.takeQuiz}
        reviewLabel={QL.review}
        backLabel={QL.back}
        quizId={data.chapterQuizId}
        chapterId={chapterId}
        subjectId={exSubjectId}
        rtl={isRtlSubject}
        quizExerciseTo={strategy.quizExerciseTo}
      />
    );
  }

  if (result) {
    const passed = result.scorePct >= (isQuiz ? QUIZ_PASS_THRESHOLD_PCT : PASS_THRESHOLD_PCT);
    const resultLevel = Number(result.profile?.level ?? 1);
    return (
      <div className="mx-auto max-w-2xl px-6 py-12" dir={isRtlSubject ? "rtl" : undefined}>
        {capabilities.rewards && showConfetti && <Confetti />}
        {capabilities.rewards && (
          <LevelUpCelebration
            show={showLevelUp}
            newLevel={resultLevel}
            xpGained={result.xpEarned}
            onComplete={() => setShowLevelUp(false)}
          />
        )}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/40 bg-black/60 p-8 text-center backdrop-blur-xl shadow-gold"
        >
          <div className="absolute -top-20 left-1/2 h-48 w-48 -translate-x-1/2 rounded-full bg-[color:var(--gold)]/30 blur-3xl" />
          <div className="relative">
            <div className="animate-gold-pulse mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)]">
              <Trophy className="h-10 w-10 text-black" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold">
              {passed ? t.quest.victoryTitle : t.quest.niceTriTitle}
            </h1>
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
              {t.quest.serverValidatedTime.replace("{n}", String(result.durationSeconds))}
            </p>
            {isQuiz && (
              <div
                className={`mt-4 rounded-2xl border p-4 text-sm font-semibold ${
                  passed && !result.quizTooFast
                    ? "border-emerald-500/40 bg-emerald-500/10 text-emerald-300"
                    : "border-[color:var(--neon-gold)]/50 bg-[color:var(--neon-gold)]/10 text-[color:var(--neon-gold)]"
                }`}
                dir={isRtlSubject ? "rtl" : undefined}
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
                    className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-xs font-bold text-black shadow-gold hover:scale-105"
                  >
                    <BookOpen className="h-4 w-4" /> {QL.review}
                  </Link>
                )}
              </div>
            )}
            {capabilities.rewards && result.xpEarned === 0 && (
              <div className="mt-6 rounded-xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-3 text-center text-xs text-[color:var(--gold)]">
                {noXpReason(result)}
              </div>
            )}
            {capabilities.rewards && result.potionApplied && (
              <div className="mt-6 rounded-xl border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/10 p-3 text-center text-sm font-bold text-[color:var(--gold)]">
                {result.potionApplied.xpMultiplier > 1
                  ? t.quest.potionXpApplied.replace(
                      "{x}",
                      String(result.potionApplied.xpMultiplier),
                    )
                  : t.quest.potionCoinsApplied.replace(
                      "{x}",
                      String(result.potionApplied.coinMultiplier),
                    )}
              </div>
            )}
            {capabilities.rewards && (
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
                  <div className="mt-6 rounded-2xl border border-(--neon-gold)/30 bg-(--neon-gold)/10 p-4 text-left">
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
                  <div className="mt-6 rounded-xl border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/10 p-3 text-center text-sm font-bold text-[color:var(--gold)]">
                    {t.quest.retryShieldUsed}
                  </div>
                )}
              </>
            )}

            {strategy.renderResultFooter({
              exerciseId,
              subjectId: exSubjectId,
              nextExerciseId,
              onReplay: resetRun,
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
                resolvePrompt={(questionId) => promptByQuestionId.get(questionId) ?? ""}
                getDisplayChoice={getDisplayChoice}
              />
            )}
          </div>
        </motion.div>
      </div>
    );
  }

  if (!sessionId && !sessionMutation.isError) return preparingScreen;

  function handleSelect(optId: string) {
    // Discrete taps get a blip; typed input (numeric) would fire on every
    // keystroke, so it stays silent.
    if (currentType === "mcq" || currentType === "multi") play("select");
    setSelected(optId);
  }

  const options = current ? (shuffledOptionsByQuestionId.get(current.id) ?? []) : [];
  const canUseHints = !isQuiz && !bossMode && capabilities.hints;
  const currentHintRevealed = current ? current.id in revealedHints : false;
  const leaveClass =
    "mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground";

  return (
    <div className="mx-auto max-w-2xl px-6 py-8" dir={isRtlSubject ? "rtl" : undefined}>
      {exSubjectId ? (
        <Link to="/matiere/$subjectId" params={{ subjectId: exSubjectId }} className={leaveClass}>
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.quest.leaveQuest}
        </Link>
      ) : (
        <Link to={strategy.homeTo} className={leaveClass}>
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.quest.leaveQuest}
        </Link>
      )}

      {bossMode && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
        >
          <div className="flex items-center justify-between gap-3">
            <div className="flex min-w-0 items-center gap-3">
              <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-linear-to-br from-destructive to-[color:var(--gold)] shadow-lg animate-pulse">
                <Skull className="h-5 w-5 text-primary-foreground" />
              </div>
              <div className="min-w-0">
                <div className="text-xs uppercase tracking-[0.3em] text-destructive font-bold">
                  {t.quest.bossFight}
                </div>
                <div className="truncate font-display text-lg font-bold">{data.exercise.title}</div>
              </div>
            </div>
            <BossCountdown
              active={bossMode && Boolean(sessionId) && !result}
              questionIndex={idx}
              onTimeout={handleBossTimeout}
            />
          </div>
          <div className="mt-4">
            <div className="mb-1 flex items-center justify-between text-xs">
              <span className="flex items-center gap-1 font-bold text-destructive">
                <Heart className="h-3 w-3" /> {t.quest.bossHp}
              </span>
              <span className="text-muted-foreground">{bossHp}%</span>
            </div>
            <div className="h-3 overflow-hidden rounded-full bg-secondary/80">
              <motion.div
                className="h-full rounded-full bg-linear-to-r from-destructive to-[color:var(--gold)]"
                initial={{ width: "100%" }}
                animate={{ width: `${bossHp}%` }}
                transition={{ duration: 0.5 }}
              />
            </div>
          </div>
        </motion.div>
      )}

      <div className="mb-6">
        <div className="mb-2 flex items-center justify-between text-xs uppercase tracking-widest text-muted-foreground">
          <span>
            {t.quest.questionOf
              .replace("{current}", String(idx + 1))
              .replace("{total}", String(total))}
          </span>
          {!bossMode && <span className="text-[color:var(--gold)]">{data.exercise.title}</span>}
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-secondary">
          <motion.div
            className={`h-full rounded-full shadow-gold ${bossMode ? "bg-linear-to-r from-destructive to-[color:var(--gold)]" : "bg-[image:var(--gradient-gold)]"}`}
            initial={{ width: 0 }}
            animate={{ width: `${progress}%` }}
            transition={{ duration: 0.4 }}
          />
        </div>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={current.id}
          initial={{ opacity: 0, x: 30 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -30 }}
          transition={{ duration: 0.3 }}
          className={`rounded-3xl border p-6 backdrop-blur-xl sm:p-8 ${bossMode ? "border-destructive/30 bg-destructive/5" : "border-border/50 bg-black/60"}`}
        >
          <RichField
            raw={current.prompt}
            as="h2"
            className="font-display text-xl font-semibold sm:text-2xl"
          />
          <p className="mt-2 text-sm text-muted-foreground">
            {bossMode ? t.quest.bossStrike : isQuiz ? QL.quizRecorded : t.quest.feedbackMsg}
          </p>
          <QuestionInput
            questionType={currentType}
            prompt={current.prompt}
            options={options}
            value={selected}
            onChange={handleSelect}
            onSubmit={validate}
            rtl={isRtlSubject}
            labels={QL}
            optionClassName={({ isSelected }: McqOptionRender) =>
              `active:scale-[0.97] ${
                isSelected
                  ? bossMode
                    ? "border-destructive bg-destructive/20"
                    : "border-(--gold) bg-(--gold)/15"
                  : bossMode
                    ? "border-destructive/20 bg-black/40 hover:border-destructive/60 hover:bg-destructive/10"
                    : "border-border bg-black/40 hover:border-(--gold)/60 hover:bg-black/70"
              }`
            }
            optionTrailing={({ isSelected }: McqOptionRender) =>
              isSelected ? (
                <span className="flex shrink-0 items-center gap-1">
                  <Check className="h-5 w-5" aria-hidden="true" />
                  <span className="sr-only">{t.quest.selectedAnswer}</span>
                </span>
              ) : null
            }
          />

          {currentType === "mcq" && (
            <div className="mt-3 text-center text-xs text-muted-foreground/60 hidden sm:block">
              {t.quest.keyboardHint.replace("{keys1}", "1-4").replace("{keys2}", "A-D")}
            </div>
          )}

          {canUseHints && current && (
            <QuestHintButton
              remaining={hintsRemaining}
              revealed={revealedHints[current.id]}
              isRevealed={currentHintRevealed}
              isPending={hintMutation.isPending}
              onReveal={() => {
                if (currentHintRevealed) return;
                hintMutation.mutate({ questionId: current.id });
              }}
            />
          )}

          <div className="mt-6 flex justify-end">
            <button
              data-testid="quest-submit"
              disabled={!canValidate || mutation.isPending || sessionMutation.isPending}
              onClick={validate}
              className={`inline-flex items-center gap-2 rounded-lg px-6 py-2.5 text-sm font-bold shadow-gold transition disabled:opacity-40 ${
                bossMode
                  ? "bg-linear-to-r from-destructive to-[color:var(--gold)] text-primary-foreground"
                  : "bg-[image:var(--gradient-gold)] text-black"
              }`}
            >
              {(mutation.isPending || sessionMutation.isPending) && (
                <Loader2 className="h-4 w-4 animate-spin" />
              )}
              {bossMode
                ? idx + 1 >= total
                  ? t.quest.bossFinalBlow
                  : t.quest.bossAttack
                : idx + 1 >= total
                  ? t.quest.finishQuest
                  : t.quest.nextQuestion}
            </button>
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}

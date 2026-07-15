import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence, useReducedMotion } from "motion/react";
import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from "react";
import { Loader2, Skull, Heart, Check } from "lucide-react";
import { toast } from "sonner";
import { computeNextExerciseId, getExercise, getSubject } from "@/features/quest";
import { PASS_THRESHOLD_PCT, RECALL_MIN_QUESTIONS } from "@/shared/constants/gamification";
import { shuffleOptions, type BaseOption } from "@/shared/lib/question-utils";
import { isValidAnswerFormat, TIMEOUT_ANSWER_CHOICE } from "@/shared/lib/answer-formats";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import { RichField } from "@/components/ui/svg-figure";
import { QuestionInput, type McqOptionRender } from "@/features/quest/components/question-input";
import { levelForXp } from "@/shared/lib/level";
import { QuestResultScreen } from "@/features/quest/components/quest-result-screen";
import { QuizContractHint, QuizLockScreen } from "@/features/quest/components/quiz-lock-screen";
import { QuestHintButton } from "@/features/quest/components/quest-hint-button";
import { BossCountdown } from "@/features/quest/components/boss-countdown";
import {
  buildQuestLabels,
  RECALL_CHAR_BAR,
  type QuestContentLang,
} from "@/features/quest/quest-labels";
import { useT } from "@/lib/i18n";
import { LoadingState } from "@/components/ui/loading-state";
import { BackLink } from "@/components/ui/back-link";
import { PageShell } from "@/components/ui/page-shell";
import { GoldProgress } from "@/components/game/gold-progress";
import { questionSlide, useEntrance } from "@/shared/lib/motion";
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
  | { ok: false; kind: "premium"; message: string }
  // Recall gates (étude 17): the classic run isn't mastered yet ("locked") or
  // the mission can't be played in recall at all ("not-eligible").
  | { ok: false; kind: "recall"; reason: "locked" | "not-eligible" };

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
    variant: "classic" | "recall";
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
  variant = "classic",
}: {
  exerciseId: string;
  strategy: ExercisePlayerStrategy;
  variant?: "classic" | "recall";
}) {
  const t = useT();
  const scaleIn = useEntrance("scale");
  // Width tweens (boss HP / progress) can't use the entrance presets (they
  // animate a value, not an entrance) — gated by hand instead.
  const reduced = useReducedMotion();
  const { play } = useSound();
  const qc = useQueryClient();
  const fetchExercise = useServerFn(getExercise);
  const fetchSubjectForNext = useServerFn(getSubject);
  const { capabilities } = strategy;
  const isRecall = variant === "recall";

  const { data, isLoading } = useQuery({
    queryKey: ["exercise", exerciseId, variant],
    queryFn: () => fetchExercise({ data: { exerciseId, variant } }),
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

  // Recall (étude 17, US-1): a classic 100% run unlocks this mission's recall
  // mode, but only if the mission is recall-eligible (>= 3 eligible questions).
  // The count rides the same getSubject round-trip as the best/next lookups.
  const recallEligibleCount =
    siblingSubjectQuery.data?.recall?.eligibleByExercise?.[exerciseId] ?? 0;
  const recallUnlockable = !isRecall && recallEligibleCount >= RECALL_MIN_QUESTIONS;

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
      variant: "classic" | "recall";
    }) => strategy.startSession(payload),
    onSuccess: (outcome) => {
      if (outcome.ok) {
        setSessionId(outcome.sessionId);
        runStartedAtRef.current = Date.now();
        play("start");
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
      play("hint");
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
      // Recall (étude 17): the answer is free text, options are empty by
      // construction — show the raw typed/expected text, LTR-isolated. Skipping
      // the option/CSV lookups avoids a comma/colon in the text hitting the B2
      // branch by accident.
      if (isRecall) return isolateLtrRuns(choice);
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
    [shuffledOptionsByQuestionId, isRecall],
  );

  const total = questions.length;
  const current = questions[idx];
  const currentType =
    (current as { question_type?: string | null } | undefined)?.question_type ?? "mcq";
  // The answer must match its type's wire format before it can be validated
  // (the server rejects malformed payloads with a client error). mcq option
  // ids and the boards' generated CSVs always pass; a half-typed number doesn't.
  // In recall the play set is served as mcq prompts but answered as free text,
  // so validation uses the "recall" effective format (non-empty, bounded).
  const effectiveType = isRecall ? "recall" : currentType;
  const canValidate = Boolean(selected && isValidAnswerFormat(effectiveType, selected));
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
      variant,
    });
  }, [data, result, sessionId, startGate, startSessionMutate, variant]);

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

  const preparingScreen = <LoadingState label={t.quest.preparing} className="min-h-[60dvh]" />;

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

  // Recall gates (étude 17): the mission's recall mode is locked (classic not
  // mastered) or not eligible. Same lock pattern as the quiz gate; the CTA is
  // "replay this mission in QCM" (classic) instead of "take the quiz".
  if (startGate?.kind === "recall") {
    const locked = startGate.reason === "locked";
    return (
      <QuizLockScreen
        title={locked ? QL.recallLockedTitle : QL.recallNotEligibleTitle}
        body={locked ? QL.recallLockedBody : QL.recallNotEligibleBody}
        takeQuizLabel={QL.recallReplayQcm}
        reviewLabel={QL.review}
        backLabel={QL.back}
        quizId={exerciseId}
        chapterId={chapterId}
        subjectId={exSubjectId}
        rtl={isRtlSubject}
        quizExerciseTo={strategy.quizExerciseTo}
      />
    );
  }

  if (result) {
    return (
      <QuestResultScreen
        result={result}
        isQuiz={isQuiz}
        isRtl={isRtlSubject}
        isRecall={isRecall}
        rewards={capabilities.rewards}
        recallUnlockable={recallUnlockable}
        qlang={qlang}
        chapterId={chapterId}
        subjectId={exSubjectId}
        exerciseId={exerciseId}
        nextExerciseId={nextExerciseId}
        showConfetti={showConfetti}
        showLevelUp={showLevelUp}
        onLevelUpComplete={() => setShowLevelUp(false)}
        onReplay={resetRun}
        renderResultFooter={strategy.renderResultFooter}
        resolvePrompt={(questionId) => promptByQuestionId.get(questionId) ?? ""}
        getDisplayChoice={getDisplayChoice}
      />
    );
  }

  if (!sessionId && !sessionMutation.isError) return preparingScreen;

  function handleSelect(optId: string) {
    // Discrete taps get a blip; typed input (numeric, recall free text) would
    // fire on every keystroke, so it stays silent.
    if (!isRecall && (currentType === "mcq" || currentType === "multi")) play("select");
    setSelected(optId);
  }

  const options = current ? (shuffledOptionsByQuestionId.get(current.id) ?? []) : [];
  const canUseHints = !isQuiz && !bossMode && capabilities.hints && !isRecall;
  const currentHintRevealed = current ? current.id in revealedHints : false;

  return (
    <PageShell width="narrow" dir={isRtlSubject ? "rtl" : undefined}>
      {exSubjectId ? (
        <BackLink to="/matiere/$subjectId" params={{ subjectId: exSubjectId }}>
          {t.quest.leaveQuest}
        </BackLink>
      ) : (
        <BackLink to={strategy.homeTo}>{t.quest.leaveQuest}</BackLink>
      )}

      {isRecall && (
        <div
          className="mb-6 rounded-2xl border border-(--gold)/40 bg-(--gold)/5 px-4 py-3 text-center text-sm font-bold text-(--gold)"
          data-testid="recall-banner"
          dir={isRtlSubject ? "rtl" : undefined}
        >
          {QL.recallBanner}
        </div>
      )}

      {bossMode && (
        <motion.div
          {...scaleIn}
          className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
        >
          <div className="flex items-center justify-between gap-3">
            <div className="flex min-w-0 items-center gap-3">
              <div className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-linear-to-br from-destructive to-gold shadow-lg animate-pulse">
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
                className="h-full rounded-full bg-linear-to-r from-destructive to-gold"
                initial={reduced ? false : { width: "100%" }}
                animate={{ width: `${bossHp}%` }}
                transition={{ duration: reduced ? 0 : 0.5 }}
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
          {!bossMode && <span className="text-gold">{data.exercise.title}</span>}
        </div>
        {bossMode ? (
          <div className="h-2 overflow-hidden rounded-full bg-secondary">
            <motion.div
              className="h-full rounded-full shadow-gold bg-linear-to-r from-destructive to-gold"
              initial={reduced ? false : { width: 0 }}
              animate={{ width: `${progress}%` }}
              transition={{ duration: reduced ? 0 : 0.4 }}
            />
          </div>
        ) : (
          <GoldProgress
            value={progress}
            aria-label={t.quest.questionOf
              .replace("{current}", String(idx + 1))
              .replace("{total}", String(total))}
            className="shadow-gold"
          />
        )}
        {isQuiz && <QuizContractHint className="mt-2" />}
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={current.id}
          {...questionSlide(reduced)}
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
            variant={variant}
            prompt={current.prompt}
            options={options}
            value={selected}
            onChange={handleSelect}
            onSubmit={validate}
            rtl={isRtlSubject}
            labels={QL}
            recallChars={RECALL_CHAR_BAR[qlang]}
            optionClassName={({ isSelected }: McqOptionRender) =>
              `active:scale-[0.97] ${
                isSelected
                  ? bossMode
                    ? "border-destructive bg-destructive/20"
                    : "border-gold bg-gold/15"
                  : bossMode
                    ? "border-destructive/20 bg-black/40 hover:border-destructive/60 hover:bg-destructive/10"
                    : "border-border bg-black/40 hover:border-gold/60 hover:bg-black/70"
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

          {currentType === "mcq" && !isRecall && (
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
                  ? "bg-linear-to-r from-destructive to-gold text-primary-foreground"
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
    </PageShell>
  );
}

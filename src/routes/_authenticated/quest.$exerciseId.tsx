import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  ArrowLeft,
  Zap,
  Flame,
  Sparkles,
  Loader2,
  Trophy,
  Skull,
  Heart,
  Timer,
} from "lucide-react";
import { toast } from "sonner";
import { getExercise, startExerciseSession, submitAttempt } from "@/features/quest";
import { BOSS_TIME_PER_QUESTION_S, PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { isRtlText, isMathExpression } from "@/shared/lib/utils";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";
import { LevelUpCelebration } from "@/components/ui/level-up-celebration";
import { useT } from "@/lib/i18n";

// Confetti component for victory
function Confetti() {
  const particles = useMemo(
    () =>
      Array.from({ length: 50 }, (_, i) => ({
        id: i,
        x: Math.random() * 100,
        delay: Math.random() * 0.5,
        duration: 1.5 + Math.random() * 2,
        color: ["#a855f7", "#06b6d4", "#f59e0b", "#ec4899", "#10b981"][
          Math.floor(Math.random() * 5)
        ],
        size: 6 + Math.random() * 8,
      })),
    [],
  );
  return (
    <div className="pointer-events-none fixed inset-0 z-50 overflow-hidden">
      {particles.map((p) => (
        <motion.div
          key={p.id}
          className="absolute rounded-sm"
          style={{ left: `${p.x}%`, width: p.size, height: p.size, backgroundColor: p.color }}
          initial={{ y: -20, opacity: 1, rotate: 0 }}
          animate={{ y: "100vh", opacity: 0, rotate: 360 + Math.random() * 360 }}
          transition={{ duration: p.duration, delay: p.delay, ease: "easeIn" }}
        />
      ))}
    </div>
  );
}

export const Route = createFileRoute("/_authenticated/quest/$exerciseId")({
  head: () => ({ meta: [{ title: "Quest · XP Scholars" }] }),
  component: QuestPage,
});

type Answer = { questionId: string; choice: string };

function QuestPage() {
  const { exerciseId } = Route.useParams();
  const t = useT();
  const qc = useQueryClient();
  const fetchExercise = useServerFn(getExercise);
  const startSession = useServerFn(startExerciseSession);
  const submit = useServerFn(submitAttempt);

  const { data, isLoading } = useQuery({
    queryKey: ["exercise", exerciseId],
    queryFn: () => fetchExercise({ data: { exerciseId } }),
  });

  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<Answer[]>([]);
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [showConfetti, setShowConfetti] = useState(false);
  const [showLevelUp, setShowLevelUp] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [result, setResult] = useState<Awaited<ReturnType<typeof submitAttempt>> | null>(null);

  const sessionMutation = useMutation({
    mutationFn: (payload: { exerciseId: string }) => startSession({ data: payload }),
    onSuccess: (res) => setSessionId(res.sessionId),
    onError: (e) => toast.error(e instanceof Error ? e.message : "Unable to start the quest"),
  });

  const mutation = useMutation({
    mutationFn: (payload: { sessionId: string; exerciseId: string; answers: Answer[] }) =>
      submit({ data: payload }),
    onSuccess: (res) => {
      setResult(res);
      if (res.scorePct >= PASS_THRESHOLD_PCT) setShowConfetti(true);
      // Detect level-up: if XP earned caused a level boundary crossing
      const profileLevel = Number((res.profile as Record<string, unknown>)?.level ?? 0);
      const profileXp = Number((res.profile as Record<string, unknown>)?.xp ?? 0);
      const prevXp = profileXp - res.xpEarned;
      const prevLevel = Math.floor(prevXp / 200) + 1;
      if (profileLevel > prevLevel && res.xpEarned > 0) {
        setTimeout(() => setShowLevelUp(true), 1200);
      }
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      qc.invalidateQueries({ queryKey: ["subject"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : "Error"),
  });

  const questions = useMemo(() => data?.questions ?? [], [data?.questions]);
  const shuffledOptionsByQuestionId = useMemo(() => {
    return new Map(
      questions.map((q) => {
        const sourceOptions = (q.options as BaseOption[]) ?? [];
        return [q.id, shuffleOptions(sourceOptions)] as const;
      }),
    );
  }, [questions]);

  const getDisplayChoice = useCallback(
    (questionId: string, choice: string) => {
      if (!choice) return "-";
      const questionOptions = shuffledOptionsByQuestionId.get(questionId) ?? [];
      const matchedOption = questionOptions.find((opt) => opt.id === choice);
      return matchedOption?.displayId ?? choice.toUpperCase();
    },
    [shuffledOptionsByQuestionId],
  );

  const total = questions.length;
  const current = questions[idx];
  const progress = useMemo(() => (total > 0 ? (idx / total) * 100 : 0), [idx, total]);
  const isBoss = data?.exercise?.mode === "boss";
  const subjectInfo = data?.exercise?.subjects as { color_token?: string } | null;
  const isRtlSubject = subjectInfo?.color_token === "math" || subjectInfo?.color_token === "arabic";

  // Boss mode: timer
  const [bossTimer, setBossTimer] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const feedbackTimeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const answeredQuestionRef = useRef<string | null>(null);
  // Refs to avoid stale closures in setInterval
  const selectedRef = useRef(selected);
  const answersRef = useRef(answers);
  const idxRef = useRef(idx);
  const totalRef = useRef(total);
  const currentRef = useRef(current);
  selectedRef.current = selected;
  answersRef.current = answers;
  idxRef.current = idx;
  totalRef.current = total;
  currentRef.current = current;

  useEffect(() => {
    if (!isBoss || !sessionId || result) return;
    setBossTimer(BOSS_TIME_PER_QUESTION_S);
    if (timerRef.current) clearInterval(timerRef.current);
    timerRef.current = setInterval(() => {
      setBossTimer((t) => {
        if (t <= 1) {
          // Auto-submit with no answer if time runs out
          if (!selectedRef.current) {
            const autoAnswer: Answer = {
              questionId: currentRef.current?.id ?? "",
              choice: "__timeout__",
            };
            const nextAnswers = [...answersRef.current, autoAnswer];
            if (idxRef.current + 1 >= totalRef.current) {
              mutation.mutate({ sessionId: sessionId!, exerciseId, answers: nextAnswers });
            } else {
              setAnswers(nextAnswers);
              setIdx((i) => i + 1);
              setSelected(null);
            }
          }
          return BOSS_TIME_PER_QUESTION_S;
        }
        return t - 1;
      });
    }, 1000);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isBoss, sessionId, idx, result]);

  useEffect(() => {
    return () => {
      if (feedbackTimeoutRef.current) clearTimeout(feedbackTimeoutRef.current);
    };
  }, []);

  // Boss HP: starts at 100%, decreases per answered question
  const bossHp = useMemo(() => {
    if (!isBoss || total === 0) return 100;
    return Math.max(0, Math.round(((total - idx) / total) * 100));
  }, [isBoss, total, idx]);

  useEffect(() => {
    if (!data?.exercise?.id || sessionId || sessionMutation.isPending || result) return;
    sessionMutation.mutate({ exerciseId: data.exercise.id });
  }, [data?.exercise?.id, result, sessionId, sessionMutation]);

  const advanceWithChoice = useCallback(
    (choice: string) => {
      if (!sessionId || !current?.id) return;

      // Prevent duplicate processing when auto-advance and manual button race.
      if (answeredQuestionRef.current === current.id) return;
      answeredQuestionRef.current = current.id;

      const nextAnswer: Answer = { questionId: current.id, choice };
      const nextAnswers = [...answers, nextAnswer];
      if (idx + 1 >= total) {
        mutation.mutate({ sessionId, exerciseId, answers: nextAnswers });
        return;
      }

      setAnswers(nextAnswers);
      setIdx((i) => i + 1);
      setSelected(null);
      setShowFeedback(false);
      answeredQuestionRef.current = null;
    },
    [answers, current?.id, exerciseId, idx, mutation, sessionId, total],
  );

  const advanceNow = useCallback(() => {
    if (!selected || !sessionId || !showFeedback) return;
    if (feedbackTimeoutRef.current) {
      clearTimeout(feedbackTimeoutRef.current);
      feedbackTimeoutRef.current = null;
    }
    advanceWithChoice(selected);
  }, [advanceWithChoice, selected, sessionId, showFeedback]);

  // Keyboard shortcuts: 1-4 to select answer, Enter/Space to advance
  useEffect(() => {
    if (result) return;
    function handleKeyDown(e: KeyboardEvent) {
      // Prevent if focus is on an input or button (unless it's the body)
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return;

      const optionsList = current ? (shuffledOptionsByQuestionId.get(current.id) ?? []) : [];

      if (!showFeedback) {
        const num = parseInt(e.key, 10);
        if (num >= 1 && num <= optionsList.length) {
          e.preventDefault();
          handleSelect(optionsList[num - 1].id);
        }
        // A, B, C, D keys
        const letterIdx = "abcd".indexOf(e.key.toLowerCase());
        if (letterIdx >= 0 && letterIdx < optionsList.length) {
          e.preventDefault();
          handleSelect(optionsList[letterIdx].id);
        }
      } else if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        advanceNow();
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  });

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">
        {t.quest.preparing}
      </div>
    );
  }

  // RESULTS SCREEN
  if (result) {
    const passed = result.scorePct >= PASS_THRESHOLD_PCT;
    const resultLevel = Number((result.profile as Record<string, unknown>)?.level ?? 1);
    return (
      <div className="mx-auto max-w-2xl px-6 py-12" dir={isRtlSubject ? "rtl" : undefined}>
        {showConfetti && <Confetti />}
        <LevelUpCelebration
          show={showLevelUp}
          newLevel={resultLevel}
          xpGained={result.xpEarned}
          onComplete={() => setShowLevelUp(false)}
        />
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-(--neon-violet)/40 bg-card/60 p-8 text-center backdrop-blur-xl shadow-neon"
        >
          <div className="absolute -top-20 left-1/2 h-48 w-48 -translate-x-1/2 rounded-full bg-(--neon-violet)/40 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-linear-to-br from-neon-violet to-neon-magenta shadow-neon animate-pulse-neon">
              <Trophy className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold">
              {passed ? t.quest.victoryTitle : t.quest.niceTriTitle}
            </h1>
            <p className="mt-1 text-muted-foreground">
              {result.correct} / {result.total} correct answers · {Math.round(result.scorePct)}%
            </p>
            <p className="mt-1 text-xs uppercase tracking-widest text-muted-foreground">
              Server-validated time · {result.durationSeconds}s
            </p>
            <div className="mt-6 grid grid-cols-4 gap-3">
              <div className="rounded-xl bg-(--neon-gold)/15 p-4">
                <Zap className="mx-auto h-5 w-5 text-neon-gold" />
                <div className="mt-1 font-display text-2xl font-bold text-neon-gold">
                  +{result.xpEarned}
                </div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">
                  {t.quest.xpLabel}
                </div>
              </div>
              <div className="rounded-xl bg-(--neon-cyan)/15 p-4">
                <Sparkles className="mx-auto h-5 w-5 text-neon-cyan" />
                <div className="mt-1 font-display text-2xl font-bold text-neon-cyan">
                  +{result.coinsEarned ?? 0}
                </div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">
                  {t.quest.coinsLabel}
                </div>
              </div>
              <div className="rounded-xl bg-(--neon-violet)/15 p-4">
                <Sparkles className="mx-auto h-5 w-5 text-neon-violet" />
                <div className="mt-1 font-display text-2xl font-bold text-neon-violet">
                  {result.profile?.level ?? "?"}
                </div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">
                  {t.quest.levelLabel}
                </div>
              </div>
              <div className="rounded-xl bg-(--flame)/15 p-4">
                <Flame className="mx-auto h-5 w-5 text-flame animate-flame" />
                <div className="mt-1 font-display text-2xl font-bold text-flame">
                  {result.profile?.current_streak ?? 0}
                </div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">
                  {t.quest.streakLabel}
                </div>
              </div>
            </div>
            <div className="mt-6 text-xs uppercase tracking-widest text-neon-cyan">
              {result.profile?.hero_class}
            </div>
            {result.unlockedBadges.length > 0 && (
              <div className="mt-6 rounded-2xl border border-(--neon-gold)/30 bg-(--neon-gold)/10 p-4 text-left">
                <div className="text-xs uppercase tracking-widest text-neon-gold">
                  {t.quest.badgesUnlocked}
                </div>
                <div className="mt-3 flex flex-wrap gap-3">
                  {result.unlockedBadges.map((badge) => (
                    <div key={badge.code} className="rounded-xl bg-card/70 px-4 py-3">
                      <div className="font-display text-sm font-bold">{badge.name}</div>
                      <div className="text-xs uppercase tracking-widest text-muted-foreground">
                        {badge.rarity}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
            <div className="mt-8 flex flex-wrap justify-center gap-3">
              <Link
                to="/dashboard"
                className="rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80"
              >
                {t.common.backToHall}
              </Link>
              <button
                onClick={() => {
                  if (feedbackTimeoutRef.current) {
                    clearTimeout(feedbackTimeoutRef.current);
                    feedbackTimeoutRef.current = null;
                  }
                  answeredQuestionRef.current = null;
                  setResult(null);
                  setIdx(0);
                  setAnswers([]);
                  setSelected(null);
                  setShowFeedback(false);
                  setShowConfetti(false);
                  setSessionId(null);
                }}
                className="rounded-lg bg-linear-to-r from-neon-violet to-neon-magenta px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-neon hover:scale-105"
              >
                {t.quest.replayQuest}
              </button>
            </div>

            <div className="mt-8 text-left">
              <h2 className="font-display text-xl font-bold">{t.quest.questReview}</h2>
              <div className="mt-4 space-y-3">
                {result.review.map((item, reviewIndex) => (
                  <div
                    key={item.questionId}
                    className="rounded-2xl border border-border/50 bg-background/30 p-4"
                  >
                    <div className="flex items-start justify-between gap-4">
                      <div>
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">
                          Question {reviewIndex + 1}
                        </div>
                        <div
                          className="mt-1 font-semibold"
                          dir={isRtlText(item.prompt) ? "rtl" : undefined}
                        >
                          {item.prompt}
                        </div>
                      </div>
                      <div
                        className={`rounded-full px-3 py-1 text-xs font-bold ${item.isCorrect ? "bg-(--success)/15 text-success" : "bg-destructive/15 text-destructive"}`}
                      >
                        {item.isCorrect ? t.quest.passed : t.quest.needsWork}
                      </div>
                    </div>
                    <div className="mt-3 grid gap-2 text-sm sm:grid-cols-2">
                      <div className="rounded-xl bg-card/60 p-3">
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">
                          {t.quest.yourAnswer}
                        </div>
                        <div className="mt-1 font-mono uppercase">
                          {getDisplayChoice(item.questionId, item.selectedChoice)}
                        </div>
                      </div>
                      <div className="rounded-xl bg-card/60 p-3">
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">
                          {t.quest.correctAnswer}
                        </div>
                        <div className="mt-1 font-mono uppercase">
                          {getDisplayChoice(item.questionId, item.correctChoice)}
                        </div>
                      </div>
                    </div>
                    {item.explanation && (
                      <p
                        className="mt-3 text-sm text-muted-foreground"
                        dir={isRtlText(item.explanation) ? "rtl" : undefined}
                      >
                        {item.explanation}
                      </p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    );
  }

  function handleSelect(optId: string) {
    if (showFeedback) return; // prevent changing during feedback
    setSelected(optId);
    setShowFeedback(true);

    if (feedbackTimeoutRef.current) clearTimeout(feedbackTimeoutRef.current);

    // Auto-advance after showing feedback
    feedbackTimeoutRef.current = setTimeout(() => {
      advanceWithChoice(optId);
    }, 1800);
  }

  const options = current ? (shuffledOptionsByQuestionId.get(current.id) ?? []) : [];

  return (
    <div className="mx-auto max-w-2xl px-6 py-8" dir={isRtlSubject ? "rtl" : undefined}>
      <Link
        to=".."
        className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4" /> {t.quest.leaveQuest}
      </Link>

      {/* Boss Mode Header */}
      {isBoss && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="grid h-10 w-10 place-items-center rounded-xl bg-linear-to-br from-destructive to-neon-magenta shadow-lg animate-pulse">
                <Skull className="h-5 w-5 text-primary-foreground" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.3em] text-destructive font-bold">
                  {t.quest.bossFight}
                </div>
                <div className="font-display text-lg font-bold">{data.exercise.title}</div>
              </div>
            </div>
            <div className="flex items-center gap-2 rounded-full bg-background/60 px-3 py-1.5 text-sm font-bold">
              <Timer className="h-4 w-4 text-destructive" />
              <span
                className={bossTimer <= 5 ? "text-destructive animate-pulse" : "text-neon-cyan"}
              >
                {bossTimer}s
              </span>
            </div>
          </div>
          {/* Boss HP Bar */}
          <div className="mt-4">
            <div className="mb-1 flex items-center justify-between text-xs">
              <span className="flex items-center gap-1 font-bold text-destructive">
                <Heart className="h-3 w-3" /> {t.quest.bossHp}
              </span>
              <span className="text-muted-foreground">{bossHp}%</span>
            </div>
            <div className="h-3 overflow-hidden rounded-full bg-secondary/80">
              <motion.div
                className="h-full rounded-full bg-linear-to-r from-destructive to-neon-magenta"
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
            Question {idx + 1} / {total}
          </span>
          {!isBoss && <span className="text-neon-cyan">{data.exercise.title}</span>}
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-secondary">
          <motion.div
            className={`h-full rounded-full shadow-neon ${isBoss ? "bg-linear-to-r from-destructive to-neon-magenta" : "bg-linear-to-r from-neon-violet to-neon-magenta"}`}
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
          className={`rounded-3xl border p-6 backdrop-blur-xl sm:p-8 ${isBoss ? "border-destructive/30 bg-destructive/5" : "border-border/50 bg-card/60"}`}
        >
          <h2
            className="font-display text-xl font-semibold sm:text-2xl"
            dir={isRtlText(current.prompt) ? "rtl" : undefined}
          >
            {current.prompt}
          </h2>
          <p className="mt-2 text-sm text-muted-foreground">
            {isBoss ? t.quest.bossStrike : t.quest.feedbackMsg}
          </p>
          <div className="mt-6 space-y-3">
            {options.map((opt) => {
              const isSel = selected === opt.id;
              let cls = isBoss
                ? "border-destructive/20 bg-background/40 hover:border-destructive/60 hover:bg-destructive/10"
                : "border-border bg-background/40 hover:border-(--neon-violet)/60 hover:bg-background/70";
              if (showFeedback) {
                if (isSel) {
                  cls = isBoss
                    ? "border-destructive bg-destructive/20"
                    : "border-(--neon-violet) bg-(--neon-violet)/15";
                } else cls = "border-border/30 bg-background/20 opacity-50";
              } else if (isSel) {
                cls = isBoss
                  ? "border-destructive bg-destructive/20"
                  : "border-(--neon-violet) bg-(--neon-violet)/15";
              }
              return (
                <button
                  key={opt.id}
                  onClick={() => handleSelect(opt.id)}
                  disabled={showFeedback}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition-all duration-200 ${cls} ${showFeedback ? "cursor-default" : "active:scale-[0.97]"}`}
                >
                  <span
                    className="flex items-center gap-3"
                    dir={
                      isMathExpression(opt.text) ? "ltr" : isRtlText(opt.text) ? "rtl" : undefined
                    }
                  >
                    <span className="grid h-7 w-7 place-items-center rounded-md border border-current font-mono text-xs uppercase">
                      {opt.displayId}
                    </span>
                    <span>{opt.text}</span>
                  </span>
                </button>
              );
            })}
          </div>

          {!showFeedback && (
            <div className="mt-3 text-center text-xs text-muted-foreground/60 hidden sm:block">
              {t.quest.keyboardHint.replace("{keys1}", "1-4").replace("{keys2}", "A-D")}
            </div>
          )}

          {showFeedback && (
            <motion.div
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              className="mt-4 rounded-xl border border-(--neon-cyan)/30 bg-(--neon-cyan)/10 p-4 text-sm text-neon-cyan"
            >
              <p>{t.quest.feedbackMsg}</p>
            </motion.div>
          )}

          <div className="mt-6 flex justify-end">
            <button
              disabled={!showFeedback || mutation.isPending || sessionMutation.isPending}
              onClick={advanceNow}
              className={`inline-flex items-center gap-2 rounded-lg px-6 py-2.5 text-sm font-bold text-primary-foreground shadow-neon transition disabled:opacity-40 ${
                isBoss
                  ? "bg-linear-to-r from-destructive to-neon-magenta"
                  : "bg-linear-to-r from-neon-violet to-neon-magenta"
              }`}
            >
              {(mutation.isPending || sessionMutation.isPending) && (
                <Loader2 className="h-4 w-4 animate-spin" />
              )}
              {isBoss
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

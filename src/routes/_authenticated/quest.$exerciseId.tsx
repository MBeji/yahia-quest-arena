import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { ArrowLeft, Zap, Flame, Sparkles, Loader2, Trophy, Skull, Heart, Timer, CheckCircle2, XCircle } from "lucide-react";
import { toast } from "sonner";
import { getExercise, startExerciseSession, submitAttempt } from "@/lib/gamification.quest";
import { BOSS_TIME_PER_QUESTION_S, PASS_THRESHOLD_PCT } from "@/lib/gamification.constants";
import { isRtlText, isMathExpression } from "@/lib/utils";

// Confetti component for victory
function Confetti() {
  const particles = useMemo(() => Array.from({ length: 50 }, (_, i) => ({
    id: i,
    x: Math.random() * 100,
    delay: Math.random() * 0.5,
    duration: 1.5 + Math.random() * 2,
    color: ['#a855f7', '#06b6d4', '#f59e0b', '#ec4899', '#10b981'][Math.floor(Math.random() * 5)],
    size: 6 + Math.random() * 8,
  })), []);
  return (
    <div className="pointer-events-none fixed inset-0 z-50 overflow-hidden">
      {particles.map((p) => (
        <motion.div
          key={p.id}
          className="absolute rounded-sm"
          style={{ left: `${p.x}%`, width: p.size, height: p.size, backgroundColor: p.color }}
          initial={{ y: -20, opacity: 1, rotate: 0 }}
          animate={{ y: '100vh', opacity: 0, rotate: 360 + Math.random() * 360 }}
          transition={{ duration: p.duration, delay: p.delay, ease: 'easeIn' }}
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
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [result, setResult] = useState<Awaited<ReturnType<typeof submitAttempt>> | null>(null);

  const sessionMutation = useMutation({
    mutationFn: (payload: { exerciseId: string }) => startSession({ data: payload }),
    onSuccess: (res) => setSessionId(res.sessionId),
    onError: (e) => toast.error(e instanceof Error ? e.message : "Unable to start the quest"),
  });

  const mutation = useMutation({
    mutationFn: (payload: { sessionId: string; exerciseId: string; answers: Answer[] }) => submit({ data: payload }),
    onSuccess: (res) => {
      setResult(res);
      if (res.scorePct >= PASS_THRESHOLD_PCT) setShowConfetti(true);
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      qc.invalidateQueries({ queryKey: ["subject"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : "Error"),
  });

  const questions = data?.questions ?? [];
  const total = questions.length;
  const current = questions[idx];
  const progress = useMemo(() => (total > 0 ? ((idx) / total) * 100 : 0), [idx, total]);
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
            const autoAnswer: Answer = { questionId: currentRef.current?.id ?? "", choice: "__timeout__" };
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
    return () => { if (timerRef.current) clearInterval(timerRef.current); };
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

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Preparing the arena…</div>;
  }

  // RESULTS SCREEN
  if (result) {
    const passed = result.scorePct >= PASS_THRESHOLD_PCT;
    return (
      <div className="mx-auto max-w-2xl px-6 py-12" dir={isRtlSubject ? "rtl" : undefined}>
        {showConfetti && <Confetti />}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-violet)]/40 bg-card/60 p-8 text-center backdrop-blur-xl shadow-neon"
        >
          <div className="absolute -top-20 left-1/2 h-48 w-48 -translate-x-1/2 rounded-full bg-[color:var(--neon-violet)]/40 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon animate-pulse-neon">
              <Trophy className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold">{passed ? "Victory!" : "Nice try, warrior"}</h1>
            <p className="mt-1 text-muted-foreground">
              {result.correct} / {result.total} correct answers · {Math.round(result.scorePct)}%
            </p>
            <p className="mt-1 text-xs uppercase tracking-widest text-muted-foreground">
              Server-validated time · {result.durationSeconds}s
            </p>
            <div className="mt-6 grid grid-cols-4 gap-3">
              <div className="rounded-xl bg-[color:var(--neon-gold)]/15 p-4">
                <Zap className="mx-auto h-5 w-5 text-[color:var(--neon-gold)]" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--neon-gold)]">+{result.xpEarned}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">XP</div>
              </div>
              <div className="rounded-xl bg-[color:var(--neon-cyan)]/15 p-4">
                <Sparkles className="mx-auto h-5 w-5 text-[color:var(--neon-cyan)]" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--neon-cyan)]">+{result.coinsEarned ?? 0}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Coins</div>
              </div>
              <div className="rounded-xl bg-[color:var(--neon-violet)]/15 p-4">
                <Sparkles className="mx-auto h-5 w-5 text-[color:var(--neon-violet)]" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--neon-violet)]">{result.profile?.level ?? "?"}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Level</div>
              </div>
              <div className="rounded-xl bg-[color:var(--flame)]/15 p-4">
                <Flame className="mx-auto h-5 w-5 text-[color:var(--flame)] animate-flame" />
                <div className="mt-1 font-display text-2xl font-bold text-[color:var(--flame)]">{result.profile?.current_streak ?? 0}</div>
                <div className="text-xs uppercase tracking-wider text-muted-foreground">Streak</div>
              </div>
            </div>
            <div className="mt-6 text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">
              {result.profile?.hero_class}
            </div>
            {result.unlockedBadges.length > 0 && (
              <div className="mt-6 rounded-2xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 p-4 text-left">
                <div className="text-xs uppercase tracking-widest text-[color:var(--neon-gold)]">Badges unlocked</div>
                <div className="mt-3 flex flex-wrap gap-3">
                  {result.unlockedBadges.map((badge) => (
                    <div key={badge.code} className="rounded-xl bg-card/70 px-4 py-3">
                      <div className="font-display text-sm font-bold">{badge.name}</div>
                      <div className="text-xs uppercase tracking-widest text-muted-foreground">{badge.rarity}</div>
                    </div>
                  ))}
                </div>
              </div>
            )}
            <div className="mt-8 flex flex-wrap justify-center gap-3">
              <Link to="/dashboard" className="rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80">Back to hall</Link>
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
                className="rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-neon hover:scale-105"
              >
                Replay quest
              </button>
            </div>

            <div className="mt-8 text-left">
              <h2 className="font-display text-xl font-bold">Quest Review</h2>
              <div className="mt-4 space-y-3">
                {result.review.map((item, reviewIndex) => (
                  <div key={item.questionId} className="rounded-2xl border border-border/50 bg-background/30 p-4">
                    <div className="flex items-start justify-between gap-4">
                      <div>
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">Question {reviewIndex + 1}</div>
                        <div className="mt-1 font-semibold" dir={isRtlText(item.prompt) ? "rtl" : undefined}>{item.prompt}</div>
                      </div>
                      <div className={`rounded-full px-3 py-1 text-xs font-bold ${item.isCorrect ? "bg-[color:var(--success)]/15 text-[color:var(--success)]" : "bg-destructive/15 text-destructive"}`}>
                        {item.isCorrect ? "Passed" : "Needs work"}
                      </div>
                    </div>
                    <div className="mt-3 grid gap-2 text-sm sm:grid-cols-2">
                      <div className="rounded-xl bg-card/60 p-3">
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">Your answer</div>
                        <div className="mt-1 font-mono uppercase">{item.selectedChoice}</div>
                      </div>
                      <div className="rounded-xl bg-card/60 p-3">
                        <div className="text-xs uppercase tracking-widest text-muted-foreground">Correct answer</div>
                        <div className="mt-1 font-mono uppercase">{item.correctChoice}</div>
                      </div>
                    </div>
                    {item.explanation && (
                      <p className="mt-3 text-sm text-muted-foreground" dir={isRtlText(item.explanation) ? "rtl" : undefined}>{item.explanation}</p>
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

  const advanceWithChoice = useCallback((choice: string) => {
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
  }, [answers, current?.id, exerciseId, idx, mutation, sessionId, total]);

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

  const advanceNow = useCallback(() => {
    if (!selected || !sessionId || !showFeedback) return;
    if (feedbackTimeoutRef.current) {
      clearTimeout(feedbackTimeoutRef.current);
      feedbackTimeoutRef.current = null;
    }
    advanceWithChoice(selected);
  }, [advanceWithChoice, selected, sessionId, showFeedback]);

  const options = (current.options as { id: string; text: string }[]) ?? [];
  const correctOpt = (current as { correct_option?: string }).correct_option;
  const isCorrectAnswer = showFeedback && selected === correctOpt;
  const isWrongAnswer = showFeedback && selected !== correctOpt;

  return (
    <div className="mx-auto max-w-2xl px-6 py-8" dir={isRtlSubject ? "rtl" : undefined}>
      <Link to=".." className="mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-4 w-4" /> Leave quest
      </Link>

      {/* Boss Mode Header */}
      {isBoss && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }}
          className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="grid h-10 w-10 place-items-center rounded-xl bg-gradient-to-br from-destructive to-[color:var(--neon-magenta)] shadow-lg animate-pulse">
                <Skull className="h-5 w-5 text-primary-foreground" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.3em] text-destructive font-bold">⚔️ Boss Fight</div>
                <div className="font-display text-lg font-bold">{data.exercise.title}</div>
              </div>
            </div>
            <div className="flex items-center gap-2 rounded-full bg-background/60 px-3 py-1.5 text-sm font-bold">
              <Timer className="h-4 w-4 text-destructive" />
              <span className={bossTimer <= 5 ? "text-destructive animate-pulse" : "text-[color:var(--neon-cyan)]"}>
                {bossTimer}s
              </span>
            </div>
          </div>
          {/* Boss HP Bar */}
          <div className="mt-4">
            <div className="mb-1 flex items-center justify-between text-xs">
              <span className="flex items-center gap-1 font-bold text-destructive">
                <Heart className="h-3 w-3" /> Boss HP
              </span>
              <span className="text-muted-foreground">{bossHp}%</span>
            </div>
            <div className="h-3 overflow-hidden rounded-full bg-secondary/80">
              <motion.div
                className="h-full rounded-full bg-gradient-to-r from-destructive to-[color:var(--neon-magenta)]"
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
          <span>Question {idx + 1} / {total}</span>
          {!isBoss && <span className="text-[color:var(--neon-cyan)]">{data.exercise.title}</span>}
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-secondary">
          <motion.div
            className={`h-full rounded-full shadow-neon ${isBoss ? "bg-gradient-to-r from-destructive to-[color:var(--neon-magenta)]" : "bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)]"}`}
            initial={{ width: 0 }} animate={{ width: `${progress}%` }} transition={{ duration: 0.4 }}
          />
        </div>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={current.id}
          initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
          transition={{ duration: 0.3 }}
          className={`rounded-3xl border p-6 backdrop-blur-xl sm:p-8 ${isBoss ? "border-destructive/30 bg-destructive/5" : "border-border/50 bg-card/60"}`}
        >
          <h2 className="font-display text-xl font-semibold sm:text-2xl" dir={isRtlText(current.prompt) ? "rtl" : undefined}>{current.prompt}</h2>
          <p className="mt-2 text-sm text-muted-foreground">
            {isBoss ? "Strike fast and true to deal damage to the Boss!" : "Correction is stored server-side until the quest ends."}
          </p>
          <div className="mt-6 space-y-3">
            {options.map((opt) => {
              const isSel = selected === opt.id;
              const isCorrect = showFeedback && opt.id === correctOpt;
              const isWrong = showFeedback && isSel && opt.id !== correctOpt;
              let cls = isBoss
                ? "border-destructive/20 bg-background/40 hover:border-destructive/60 hover:bg-destructive/10"
                : "border-border bg-background/40 hover:border-[color:var(--neon-violet)]/60 hover:bg-background/70";
              if (showFeedback) {
                if (isCorrect) cls = "border-emerald-500 bg-emerald-500/15";
                else if (isWrong) cls = "border-destructive bg-destructive/15";
                else cls = "border-border/30 bg-background/20 opacity-50";
              } else if (isSel) {
                cls = isBoss
                  ? "border-destructive bg-destructive/20"
                  : "border-[color:var(--neon-violet)] bg-[color:var(--neon-violet)]/15";
              }
              return (
                <button
                  key={opt.id}
                  onClick={() => handleSelect(opt.id)}
                  disabled={showFeedback}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition ${cls} ${showFeedback ? "cursor-default" : ""}`}
                >
                  <span className="flex items-center gap-3" dir={isMathExpression(opt.text) ? "ltr" : isRtlText(opt.text) ? "rtl" : undefined}>
                    <span className="grid h-7 w-7 place-items-center rounded-md border border-current font-mono text-xs uppercase">{opt.id}</span>
                    <span>{opt.text}</span>
                  </span>
                  {showFeedback && isCorrect && <CheckCircle2 className="h-5 w-5 text-emerald-500 shrink-0" />}
                  {showFeedback && isWrong && <XCircle className="h-5 w-5 text-destructive shrink-0" />}
                </button>
              );
            })}
          </div>

          {/* Feedback: explanation */}
          {showFeedback && current.explanation && (
            <motion.div
              initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
              className={`mt-4 rounded-xl border p-4 text-sm ${isCorrectAnswer ? "border-emerald-500/30 bg-emerald-500/10 text-emerald-200" : "border-destructive/30 bg-destructive/10 text-orange-200"}`}
            >
              <div className="mb-1 flex items-center gap-2 text-xs font-bold uppercase tracking-widest">
                {isCorrectAnswer ? <CheckCircle2 className="h-3.5 w-3.5" /> : <XCircle className="h-3.5 w-3.5" />}
                {isCorrectAnswer ? "Correct !" : "Pas tout à fait…"}
              </div>
              <p dir={isRtlText(current.explanation) ? "rtl" : undefined}>{current.explanation}</p>
            </motion.div>
          )}

          {showFeedback && !current.explanation && (
            <motion.div
              initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
              className={`mt-4 rounded-xl border p-3 text-sm font-semibold ${isCorrectAnswer ? "border-emerald-500/30 bg-emerald-500/10 text-emerald-300" : "border-destructive/30 bg-destructive/10 text-destructive"}`}
            >
              {isCorrectAnswer ? "✓ Bonne réponse !" : `✗ La bonne réponse était : ${correctOpt?.toUpperCase()}`}
            </motion.div>
          )}

          <div className="mt-6 flex justify-end">
            <button
              disabled={!showFeedback || mutation.isPending || sessionMutation.isPending}
              onClick={advanceNow}
              className={`inline-flex items-center gap-2 rounded-lg px-6 py-2.5 text-sm font-bold text-primary-foreground shadow-neon transition disabled:opacity-40 ${
                isBoss
                  ? "bg-gradient-to-r from-destructive to-[color:var(--neon-magenta)]"
                  : "bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)]"
              }`}
            >
              {(mutation.isPending || sessionMutation.isPending) && <Loader2 className="h-4 w-4 animate-spin" />}
              {isBoss
                ? (idx + 1 >= total ? "⚔️ Final blow!" : "⚔️ Attack!")
                : (idx + 1 >= total ? "Finish quest" : "Next question")
              }
            </button>
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}

import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useEffect, useMemo, useRef, useState } from "react";
import { ArrowLeft, Zap, Flame, Sparkles, Loader2, Trophy, Skull, Heart, Timer } from "lucide-react";
import { toast } from "sonner";
import { getExercise, startExerciseSession, submitAttempt } from "@/lib/gamification.functions";
import { isRtlText } from "@/lib/utils";

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

  // Boss mode: timer (20s per question)
  const BOSS_TIME_PER_Q = 20;
  const [bossTimer, setBossTimer] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    if (!isBoss || !sessionId || result) return;
    setBossTimer(BOSS_TIME_PER_Q);
    if (timerRef.current) clearInterval(timerRef.current);
    timerRef.current = setInterval(() => {
      setBossTimer((t) => {
        if (t <= 1) {
          // Auto-submit with no answer if time runs out
          if (!selected) {
            const autoAnswer: Answer = { questionId: current?.id ?? "", choice: "__timeout__" };
            const nextAnswers = [...answers, autoAnswer];
            if (idx + 1 >= total) {
              mutation.mutate({ sessionId: sessionId!, exerciseId, answers: nextAnswers });
            } else {
              setAnswers(nextAnswers);
              setIdx((i) => i + 1);
              setSelected(null);
            }
          }
          return BOSS_TIME_PER_Q;
        }
        return t - 1;
      });
    }, 1000);
    return () => { if (timerRef.current) clearInterval(timerRef.current); };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isBoss, sessionId, idx, result]);

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
    const passed = result.scorePct >= 60;
    return (
      <div className="mx-auto max-w-2xl px-6 py-12">
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
                  setResult(null);
                  setIdx(0);
                  setAnswers([]);
                  setSelected(null);
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

  function handleSelect(optId: string) {
    setSelected(optId);
  }

  function next() {
    if (!selected || !sessionId) return;

    const nextAnswer: Answer = { questionId: current.id, choice: selected };
    const nextAnswers = [...answers, nextAnswer];

    if (idx + 1 >= total) {
      mutation.mutate({ sessionId, exerciseId, answers: nextAnswers });
    } else {
      setAnswers(nextAnswers);
      setIdx((i) => i + 1);
      setSelected(null);
    }
  }

  const options = (current.options as { id: string; text: string }[]) ?? [];

  return (
    <div className="mx-auto max-w-2xl px-6 py-8">
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
              let cls = isBoss
                ? "border-destructive/20 bg-background/40 hover:border-destructive/60 hover:bg-destructive/10"
                : "border-border bg-background/40 hover:border-[color:var(--neon-violet)]/60 hover:bg-background/70";
              if (isSel) cls = isBoss
                ? "border-destructive bg-destructive/20"
                : "border-[color:var(--neon-violet)] bg-[color:var(--neon-violet)]/15";
              return (
                <button
                  key={opt.id}
                  onClick={() => handleSelect(opt.id)}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition ${cls}`}
                >
                  <span className="flex items-center gap-3" dir={isRtlText(opt.text) ? "rtl" : undefined}>
                    <span className="grid h-7 w-7 place-items-center rounded-md border border-current font-mono text-xs uppercase">{opt.id}</span>
                    <span>{opt.text}</span>
                  </span>
                </button>
              );
            })}
          </div>

          <div className="mt-6 flex justify-end">
            <button
              disabled={!selected || !sessionId || mutation.isPending || sessionMutation.isPending}
              onClick={next}
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

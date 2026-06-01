import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useMemo, useRef, useState } from "react";
import { ArrowLeft, Zap, Sparkles, Flame, Skull, Shield, Layers, CheckCircle2, XCircle, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { getDungeonQuestions, submitDungeonRun, DUNGEON_XP_PER_FLOOR, DUNGEON_COINS_PER_5_FLOORS } from "@/lib/gamification.dungeon";
import { isRtlText, isMathExpression } from "@/lib/utils";

export const Route = createFileRoute("/_authenticated/dungeon")({
  head: () => ({ meta: [{ title: "Dungeon · XP Scholars" }] }),
  component: DungeonPage,
});

type DungeonQuestion = {
  id: string;
  prompt: string;
  options: DisplayOption[];
  correct_option: string;
  explanation: string | null;
  exercises: {
    difficulty: number;
    subject_id: string;
    subjects: { name_fr: string; color_token: string; icon: string };
  };
};

type GameState = "lobby" | "playing" | "gameover";

type BaseOption = { id: string; text: string };
type DisplayOption = BaseOption & { displayId: string };

const DISPLAY_LABELS = ["A", "B", "C", "D", "E", "F"] as const;

function shuffleOptions(options: BaseOption[]): DisplayOption[] {
  const shuffled = [...options];
  for (let i = shuffled.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }

  return shuffled.map((opt, index) => ({
    ...opt,
    displayId: DISPLAY_LABELS[index] ?? String(index + 1),
  }));
}

function DungeonPage() {
  const qc = useQueryClient();
  const fetchQuestions = useServerFn(getDungeonQuestions);
  const submitRun = useServerFn(submitDungeonRun);

  const [state, setState] = useState<GameState>("lobby");
  const [floor, setFloor] = useState(0);
  const [questions, setQuestions] = useState<DungeonQuestion[]>([]);
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [totalCorrect, setTotalCorrect] = useState(0);
  const [totalAnswered, setTotalAnswered] = useState(0);
  const [seenIds, setSeenIds] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [runResult, setRunResult] = useState<{ xpEarned: number; coinsEarned: number; floorsCleared: number } | null>(null);
  const [lastWrongAnswer, setLastWrongAnswer] = useState<{ prompt: string; selected: string; correct: string; explanation: string | null } | null>(null);
  const startTimeRef = useRef<number>(0);

  const submitMutation = useMutation({
    mutationFn: (payload: { floorsCleared: number; totalCorrect: number; totalAnswered: number; durationSeconds: number }) =>
      submitRun({ data: payload }),
    onSuccess: (res) => {
      setRunResult(res);
      qc.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : "Error saving run"),
  });

  const currentQuestion = questions[currentIdx] as DungeonQuestion | undefined;

  const loadBatch = useCallback(async (currentFloor: number, currentSeenIds: string[]) => {
    setLoading(true);
    try {
      const res = await fetchQuestions({ data: { floor: currentFloor, batchSize: 5, excludeIds: currentSeenIds.slice(-300) } });
      const newQuestions = (res.questions ?? []) as unknown as (Omit<DungeonQuestion, "options"> & { options: BaseOption[] })[];
      if (newQuestions.length === 0) {
        toast.error("No more questions available in the dungeon!");
        return false;
      }
      const shuffledQuestions: DungeonQuestion[] = newQuestions.map((question) => ({
        ...question,
        options: shuffleOptions((question.options ?? []) as BaseOption[]),
      }));

      setQuestions(shuffledQuestions);
      setCurrentIdx(0);
      if (res.resetExclusions) {
        setSeenIds(shuffledQuestions.map((q) => q.id));
      } else {
        setSeenIds((prev) => [...prev, ...shuffledQuestions.map((q) => q.id)]);
      }
      return true;
    } catch {
      toast.error("Failed to load dungeon questions");
      return false;
    } finally {
      setLoading(false);
    }
  }, [fetchQuestions]);

  async function startDungeon() {
    setState("playing");
    setFloor(1);
    setTotalCorrect(0);
    setTotalAnswered(0);
    setSeenIds([]);
    setRunResult(null);
    setLastWrongAnswer(null);
    startTimeRef.current = Date.now();
    await loadBatch(1, []);
  }

  function handleSelect(optId: string) {
    if (showFeedback || !currentQuestion) return;
    const selectedOption = currentQuestion.options.find((opt) => opt.id === optId);
    const correctOption = currentQuestion.options.find((opt) => opt.id === currentQuestion.correct_option);
    setSelected(optId);
    setShowFeedback(true);
    setTotalAnswered((n) => n + 1);

    const isCorrect = optId === currentQuestion.correct_option;

    if (isCorrect) {
      setTotalCorrect((n) => n + 1);
      // Advance after feedback delay
      setTimeout(() => advanceOrEnd(true), 1200);
    } else {
      // Wrong answer — game over after showing feedback
      setLastWrongAnswer({
        prompt: currentQuestion.prompt,
        selected: selectedOption?.displayId ?? optId.toUpperCase(),
        correct: correctOption?.displayId ?? currentQuestion.correct_option.toUpperCase(),
        explanation: currentQuestion.explanation,
      });
      setTimeout(() => endRun(), 2000);
    }
  }

  async function advanceOrEnd(wasCorrect: boolean) {
    if (!wasCorrect) return;

    const nextFloor = floor + 1;
    setFloor(nextFloor);
    setSelected(null);
    setShowFeedback(false);

    // If we have more questions in current batch
    if (currentIdx + 1 < questions.length) {
      setCurrentIdx((i) => i + 1);
    } else {
      // Need new batch
      const ok = await loadBatch(nextFloor, seenIds);
      if (!ok) endRun();
    }
  }

  function endRun() {
    setState("gameover");
    const durationSeconds = Math.round((Date.now() - startTimeRef.current) / 1000);
    const floorsCleared = Math.max(0, floor - 1); // current floor wasn't cleared
    submitMutation.mutate({ floorsCleared, totalCorrect, totalAnswered, durationSeconds });
  }

  // ========== LOBBY ==========
  if (state === "lobby") {
    return (
      <div className="mx-auto max-w-2xl px-6 py-12">
        <Link to="/dashboard" className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-4 w-4" /> Heroes Hall
        </Link>

        <motion.div
          initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-magenta)]/40 bg-card/60 p-8 text-center backdrop-blur-xl"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-[color:var(--neon-magenta)]/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-magenta)] to-[color:var(--neon-violet)] shadow-neon animate-pulse-neon">
              <Skull className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-4xl font-bold">The Infinite Dungeon</h1>
            <p className="mt-3 text-muted-foreground max-w-md mx-auto">
              Descends floor by floor. Questions from all subjects, increasingly difficult.
              One wrong answer and it's over. How deep can you go?
            </p>

            <div className="mt-8 grid grid-cols-3 gap-4 max-w-sm mx-auto">
              <div className="rounded-xl bg-[color:var(--neon-gold)]/10 p-3">
                <Zap className="mx-auto h-5 w-5 text-[color:var(--neon-gold)]" />
                <div className="mt-1 font-display text-lg font-bold text-[color:var(--neon-gold)]">{DUNGEON_XP_PER_FLOOR}</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">XP / floor</div>
              </div>
              <div className="rounded-xl bg-[color:var(--neon-cyan)]/10 p-3">
                <Sparkles className="mx-auto h-5 w-5 text-[color:var(--neon-cyan)]" />
                <div className="mt-1 font-display text-lg font-bold text-[color:var(--neon-cyan)]">{DUNGEON_COINS_PER_5_FLOORS}</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">Coins / 5 floors</div>
              </div>
              <div className="rounded-xl bg-destructive/10 p-3">
                <Skull className="mx-auto h-5 w-5 text-destructive" />
                <div className="mt-1 font-display text-lg font-bold text-destructive">1</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">Life</div>
              </div>
            </div>

            <button
              onClick={startDungeon}
              aria-label="Enter the infinite dungeon mode"
              className="mt-8 inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-[color:var(--neon-magenta)] to-[color:var(--neon-violet)] px-8 py-3.5 text-base font-bold text-primary-foreground shadow-neon transition-transform hover:scale-105"
            >
              <Skull className="h-5 w-5" /> Enter the Dungeon
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  // ========== GAME OVER ==========
  if (state === "gameover") {
    const floorsCleared = Math.max(0, floor - 1);
    return (
      <div className="mx-auto max-w-2xl px-6 py-12">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-destructive/40 bg-card/60 p-8 text-center backdrop-blur-xl"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-destructive/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-destructive to-[color:var(--neon-magenta)] shadow-lg">
              <Skull className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold">Dungeon Collapsed</h1>
            <p className="mt-2 text-muted-foreground">You fell at floor {floor}.</p>

            {/* Last wrong answer */}
            {lastWrongAnswer && (
              <div className="mt-4 rounded-2xl border border-destructive/30 bg-destructive/5 p-4 text-left">
                <div className="text-xs uppercase tracking-widest text-destructive font-bold mb-2">Fatal question</div>
                <p className="font-semibold" dir={isRtlText(lastWrongAnswer.prompt) ? "rtl" : undefined}>{lastWrongAnswer.prompt}</p>
                <div className="mt-2 grid gap-2 sm:grid-cols-2 text-sm">
                  <div className="rounded-lg bg-destructive/10 p-2">
                    <div className="text-[10px] uppercase tracking-widest text-muted-foreground">Your answer</div>
                    <div className="font-mono uppercase text-destructive">{lastWrongAnswer.selected}</div>
                  </div>
                  <div className="rounded-lg bg-emerald-500/10 p-2">
                    <div className="text-[10px] uppercase tracking-widest text-muted-foreground">Correct answer</div>
                    <div className="font-mono uppercase text-emerald-400">{lastWrongAnswer.correct}</div>
                  </div>
                </div>
                {lastWrongAnswer.explanation && (
                  <p className="mt-2 text-sm text-muted-foreground" dir={isRtlText(lastWrongAnswer.explanation) ? "rtl" : undefined}>
                    {lastWrongAnswer.explanation}
                  </p>
                )}
              </div>
            )}

            {/* Stats */}
            <div className="mt-6 grid grid-cols-4 gap-3">
              <div className="rounded-xl bg-[color:var(--neon-violet)]/15 p-3">
                <Layers className="mx-auto h-4 w-4 text-[color:var(--neon-violet)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--neon-violet)]">{floorsCleared}</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">Floors</div>
              </div>
              <div className="rounded-xl bg-[color:var(--neon-gold)]/15 p-3">
                <Zap className="mx-auto h-4 w-4 text-[color:var(--neon-gold)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--neon-gold)]">+{runResult?.xpEarned ?? "..."}</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">XP</div>
              </div>
              <div className="rounded-xl bg-[color:var(--neon-cyan)]/15 p-3">
                <Sparkles className="mx-auto h-4 w-4 text-[color:var(--neon-cyan)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--neon-cyan)]">+{runResult?.coinsEarned ?? "..."}</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">Coins</div>
              </div>
              <div className="rounded-xl bg-[color:var(--flame)]/15 p-3">
                <Shield className="mx-auto h-4 w-4 text-[color:var(--flame)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--flame)]">{totalCorrect}/{totalAnswered}</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">Correct</div>
              </div>
            </div>

            <div className="mt-8 flex flex-wrap justify-center gap-3">
              <Link to="/dashboard" className="rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80">
                Back to hall
              </Link>
              <button
                onClick={startDungeon}
                className="rounded-lg bg-gradient-to-r from-[color:var(--neon-magenta)] to-[color:var(--neon-violet)] px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-neon hover:scale-105"
              >
                Retry dungeon
              </button>
            </div>
          </div>
        </motion.div>
      </div>
    );
  }

  // ========== PLAYING ==========
  if (loading || !currentQuestion) {
    return (
      <div className="grid min-h-[60vh] place-items-center">
        <div className="flex flex-col items-center gap-3">
          <Loader2 className="h-8 w-8 animate-spin text-[color:var(--neon-magenta)]" />
          <div className="font-display text-sm uppercase tracking-widest text-muted-foreground">Descending to floor {floor}…</div>
        </div>
      </div>
    );
  }

  const options = (currentQuestion.options as DisplayOption[]) ?? [];
  const correctOpt = currentQuestion.correct_option;
  const subjectInfo = currentQuestion.exercises?.subjects;
  const difficulty = currentQuestion.exercises?.difficulty ?? 1;
  const isCorrectAnswer = showFeedback && selected === correctOpt;

  return (
    <div className="mx-auto max-w-2xl px-6 py-8">
      <div className="mb-4 flex items-center justify-between">
        <Link to="/dashboard" className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-4 w-4" /> Leave dungeon
        </Link>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 rounded-full bg-[color:var(--neon-magenta)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-magenta)]">
            <Layers className="h-3.5 w-3.5" /> Floor {floor}
          </div>
          <div className="flex items-center gap-1.5 rounded-full bg-destructive/20 px-3 py-1 text-sm font-bold text-destructive">
            <Skull className="h-3.5 w-3.5" /> 1 HP
          </div>
        </div>
      </div>

      {/* Subject & difficulty indicator */}
      <div className="mb-4 flex items-center justify-between">
        {subjectInfo && (
          <div className="rounded-full px-3 py-1 text-xs font-bold uppercase tracking-wider" style={{ color: `var(--subject-${subjectInfo.color_token})`, background: `color-mix(in oklab, var(--subject-${subjectInfo.color_token}) 15%, transparent)` }}>
            {subjectInfo.name_fr}
          </div>
        )}
        <div className="flex gap-1">
          {[1, 2, 3].map((d) => (
            <div
              key={d}
              className={`h-2 w-5 rounded-full ${d <= difficulty ? "bg-[color:var(--neon-magenta)]" : "bg-secondary"}`}
            />
          ))}
        </div>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentQuestion.id}
          initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
          transition={{ duration: 0.25 }}
          className="rounded-3xl border border-[color:var(--neon-magenta)]/30 bg-card/60 p-6 backdrop-blur-xl sm:p-8"
          dir={subjectInfo && (subjectInfo.color_token === "math" || subjectInfo.color_token === "arabic") ? "rtl" : undefined}
        >
          <h2 className="font-display text-xl font-semibold sm:text-2xl" dir={isRtlText(currentQuestion.prompt) ? "rtl" : undefined}>
            {currentQuestion.prompt}
          </h2>
          <p className="mt-2 text-sm text-muted-foreground">
            One wrong answer ends the run. Choose wisely.
          </p>

          <div className="mt-6 space-y-3">
            {options.map((opt) => {
              const isSel = selected === opt.id;
              const isCorrect = showFeedback && opt.id === correctOpt;
              const isWrong = showFeedback && isSel && opt.id !== correctOpt;

              let cls = "border-[color:var(--neon-magenta)]/20 bg-background/40 hover:border-[color:var(--neon-magenta)]/60 hover:bg-[color:var(--neon-magenta)]/5";
              if (showFeedback) {
                if (isCorrect) cls = "border-emerald-500 bg-emerald-500/15";
                else if (isWrong) cls = "border-destructive bg-destructive/15";
                else cls = "border-border/30 bg-background/20 opacity-50";
              } else if (isSel) {
                cls = "border-[color:var(--neon-magenta)] bg-[color:var(--neon-magenta)]/15";
              }

              return (
                <button
                  key={opt.id}
                  onClick={() => handleSelect(opt.id)}
                  disabled={showFeedback}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition ${cls} ${showFeedback ? "cursor-default" : ""}`}
                >
                  <span className="flex items-center gap-3" dir={isMathExpression(opt.text) ? "ltr" : isRtlText(opt.text) ? "rtl" : undefined}>
                    <span className="grid h-7 w-7 place-items-center rounded-md border border-current font-mono text-xs uppercase">{opt.displayId}</span>
                    <span>{opt.text}</span>
                  </span>
                  {showFeedback && isCorrect && <CheckCircle2 className="h-5 w-5 text-emerald-500 shrink-0" />}
                  {showFeedback && isWrong && <XCircle className="h-5 w-5 text-destructive shrink-0" />}
                </button>
              );
            })}
          </div>

          {/* Feedback */}
          {showFeedback && (
            <motion.div
              initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
              className={`mt-4 rounded-xl border p-3 text-sm font-semibold ${isCorrectAnswer ? "border-emerald-500/30 bg-emerald-500/10 text-emerald-300" : "border-destructive/30 bg-destructive/10 text-destructive"}`}
            >
              {isCorrectAnswer ? (
                <span className="flex items-center gap-2"><CheckCircle2 className="h-4 w-4" /> Correct! Descending deeper…</span>
              ) : (
                <span className="flex items-center gap-2"><XCircle className="h-4 w-4" /> Wrong! The dungeon collapses…</span>
              )}
            </motion.div>
          )}
        </motion.div>
      </AnimatePresence>

      {/* Floor progress bar (visual flair) */}
      <div className="mt-6 flex items-center gap-3">
        <div className="text-xs uppercase tracking-widest text-muted-foreground">Depth</div>
        <div className="flex-1 h-2 overflow-hidden rounded-full bg-secondary/60" role="progressbar" aria-label="Dungeon depth" aria-valuenow={floor} aria-valuemin={0} aria-valuemax={50}>
          <motion.div
            className="h-full rounded-full bg-gradient-to-r from-[color:var(--neon-magenta)] to-[color:var(--neon-violet)]"
            animate={{ width: `${Math.min(100, (floor / 50) * 100)}%` }}
            transition={{ duration: 0.5 }}
          />
        </div>
        <div className="text-xs font-bold text-[color:var(--neon-magenta)]">{floor}</div>
      </div>
    </div>
  );
}

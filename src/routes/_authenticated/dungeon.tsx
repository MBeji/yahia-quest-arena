import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useMemo, useRef, useState } from "react";
import {
  ArrowLeft,
  Zap,
  Sparkles,
  Flame,
  Skull,
  Shield,
  Layers,
  CheckCircle2,
  XCircle,
  Loader2,
  Lock,
} from "lucide-react";
import { toast } from "sonner";
import {
  getDungeonAccess,
  getDungeonQuestions,
  startDungeonRun,
  submitDungeonAnswer,
  submitDungeonRun,
  DUNGEON_XP_PER_FLOOR,
  DUNGEON_COINS_PER_5_FLOORS,
} from "@/features/dungeon";
import { SubscriptionPaywall } from "@/features/subscription";
import { isRtlText, isMathExpression } from "@/shared/lib/utils";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/dungeon")({
  head: () => ({ meta: [{ title: "Dungeon · XP Scholars" }] }),
  component: DungeonPage,
});

// Derive the question shape from the server fn so we never fabricate non-null fields.
// The server returns options as raw {id,text}; we replace them with shuffled, labelled
// DisplayOption[] for rendering.
type ServerDungeonQuestion = Awaited<ReturnType<typeof getDungeonQuestions>>["questions"][number];
type DungeonQuestion = Omit<ServerDungeonQuestion, "options"> & { options: DisplayOption[] };

type GameState = "lobby" | "playing" | "gameover";

function DungeonPage() {
  const qc = useQueryClient();
  const t = useT();
  const startRun = useServerFn(startDungeonRun);
  const fetchQuestions = useServerFn(getDungeonQuestions);
  const submitAnswer = useServerFn(submitDungeonAnswer);
  const submitRun = useServerFn(submitDungeonRun);
  const fetchAccess = useServerFn(getDungeonAccess);

  const accessQuery = useQuery({
    queryKey: ["dungeon-access"],
    queryFn: () => fetchAccess(),
  });
  const access = accessQuery.data;

  const [state, setState] = useState<GameState>("lobby");
  const [runId, setRunId] = useState<string | null>(null);
  const [floor, setFloor] = useState(0);
  const [questions, setQuestions] = useState<DungeonQuestion[]>([]);
  const [currentIdx, setCurrentIdx] = useState(0);
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [answerWasCorrect, setAnswerWasCorrect] = useState<boolean | null>(null);
  const [totalCorrect, setTotalCorrect] = useState(0);
  const [totalAnswered, setTotalAnswered] = useState(0);
  const [loading, setLoading] = useState(false);
  const [runResult, setRunResult] = useState<{
    xpEarned: number;
    coinsEarned: number;
    floorsCleared: number;
    totalCorrect: number;
    totalAnswered: number;
  } | null>(null);
  const [lastWrongAnswer, setLastWrongAnswer] = useState<{
    prompt: string;
    selected: string;
    correct: string;
    explanation: string | null;
  } | null>(null);
  const startTimeRef = useRef<number>(0);

  const submitMutation = useMutation({
    mutationFn: (payload: { runId: string; durationSeconds: number }) =>
      submitRun({ data: payload }),
    onSuccess: (res) => {
      setRunResult(res);
      setTotalCorrect(res.totalCorrect);
      setTotalAnswered(res.totalAnswered);
      qc.invalidateQueries({ queryKey: ["dashboard"] });
    },
    // TODO(review #32): no i18n key for this fallback yet — add t.dungeon.errorSavingRun.
    onError: (e) => toast.error(e instanceof Error ? e.message : "Error saving run"),
  });

  const answerMutation = useMutation({
    mutationFn: (payload: { runId: string; questionId: string; choice: string }) =>
      submitAnswer({ data: payload }),
  });

  const currentQuestion: DungeonQuestion | undefined = questions[currentIdx];

  const loadBatch = useCallback(
    async (activeRunId: string) => {
      setLoading(true);
      try {
        const res = await fetchQuestions({ data: { runId: activeRunId, batchSize: 5 } });
        setFloor(res.currentFloor);
        const newQuestions = res.questions ?? [];
        if (newQuestions.length === 0) {
          // TODO(review #32): no i18n key for this dungeon toast yet — add
          // t.dungeon.noMoreQuestions and switch to it.
          toast.error("No more questions available in the dungeon. Finalizing your run...");
          return false;
        }
        const shuffledQuestions: DungeonQuestion[] = newQuestions.map((question) => ({
          ...question,
          options: shuffleOptions((question.options ?? []) as BaseOption[]),
        }));

        setQuestions(shuffledQuestions);
        setCurrentIdx(0);
        return true;
      } catch {
        // TODO(review #32): no i18n key for this toast yet — add t.dungeon.failedLoadQuestions.
        toast.error("Failed to load dungeon questions");
        return false;
      } finally {
        setLoading(false);
      }
    },
    [fetchQuestions],
  );

  async function startDungeon() {
    setState("playing");
    setRunId(null);
    setFloor(1);
    setTotalCorrect(0);
    setTotalAnswered(0);
    setRunResult(null);
    setLastWrongAnswer(null);
    setAnswerWasCorrect(null);
    setSelected(null);
    setShowFeedback(false);
    setQuestions([]);
    setCurrentIdx(0);
    startTimeRef.current = Date.now();

    try {
      const run = await startRun();
      setRunId(run.runId);
      qc.invalidateQueries({ queryKey: ["dungeon-access"] });
      const ok = await loadBatch(run.runId);
      if (!ok) {
        setState("gameover");
        const durationSeconds = Math.round((Date.now() - startTimeRef.current) / 1000);
        submitMutation.mutate({ runId: run.runId, durationSeconds });
      }
    } catch (error) {
      setState("lobby");
      // TODO(review #32): no i18n key for this fallback yet — add t.dungeon.failedStartRun.
      toast.error(error instanceof Error ? error.message : "Failed to start dungeon run");
    }
  }

  async function handleSelect(optId: string) {
    if (showFeedback || answerMutation.isPending || !currentQuestion || !runId) return;
    const selectedOption = currentQuestion.options.find((opt) => opt.id === optId);

    setSelected(optId);
    setShowFeedback(true);
    setAnswerWasCorrect(null);

    try {
      const result = await answerMutation.mutateAsync({
        runId,
        questionId: currentQuestion.id,
        choice: optId,
      });

      setAnswerWasCorrect(result.isCorrect);
      setTotalCorrect(result.totalCorrect);
      setTotalAnswered(result.totalAnswered);

      if (result.isCorrect) {
        setTimeout(() => advanceOrEnd(result.nextFloor), 1200);
      } else {
        const correctOption = currentQuestion.options.find(
          (opt) => opt.id === result.correctChoice,
        );
        setLastWrongAnswer({
          prompt: result.prompt,
          selected: selectedOption?.displayId ?? optId.toUpperCase(),
          correct: correctOption?.displayId ?? (result.correctChoice ?? "-").toUpperCase(),
          explanation: result.explanation,
        });
        setFloor(result.nextFloor);
        setTimeout(() => endRun(), 2000);
      }
    } catch (error) {
      setShowFeedback(false);
      setSelected(null);
      setAnswerWasCorrect(null);
      // TODO(review #32): no i18n key for this fallback yet — add t.dungeon.failedValidateAnswer.
      toast.error(error instanceof Error ? error.message : "Failed to validate answer");
    }
  }

  async function advanceOrEnd(nextFloor: number) {
    setFloor(nextFloor);
    setSelected(null);
    setShowFeedback(false);
    setAnswerWasCorrect(null);

    if (currentIdx + 1 < questions.length) {
      setCurrentIdx((i) => i + 1);
    } else if (runId) {
      const ok = await loadBatch(runId);
      if (!ok) {
        endRun();
      }
    }
  }

  function endRun() {
    setState("gameover");
    if (!runId) return;

    const durationSeconds = Math.round((Date.now() - startTimeRef.current) / 1000);
    submitMutation.mutate({ runId, durationSeconds });
  }

  // ========== LOBBY ==========
  if (state === "lobby") {
    return (
      <div className="mx-auto max-w-2xl px-6 py-12">
        <Link
          to="/dashboard"
          className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.dungeon.heroesHall}
        </Link>

        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/40 bg-black/60 p-8 text-center backdrop-blur-xl"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-[color:var(--gold)]/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)] shadow-gold animate-pulse-neon">
              <Skull className="h-10 w-10 text-black" />
            </div>
            <h1 className="mt-5 font-display text-4xl font-bold">{t.dungeon.title}</h1>
            <p className="mt-3 text-muted-foreground max-w-md mx-auto">{t.dungeon.desc}</p>

            <div className="mt-8 grid grid-cols-3 gap-4 max-w-sm mx-auto">
              <div className="rounded-xl bg-[color:var(--gold)]/10 p-3">
                <Zap className="mx-auto h-5 w-5 text-[color:var(--gold)]" />
                <div className="mt-1 font-display text-lg font-bold text-[color:var(--gold)]">
                  {DUNGEON_XP_PER_FLOOR}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.xpPerFloor}
                </div>
              </div>
              <div className="rounded-xl bg-[color:var(--gold)]/10 p-3">
                <Sparkles className="mx-auto h-5 w-5 text-[color:var(--gold)]" />
                <div className="mt-1 font-display text-lg font-bold text-[color:var(--gold)]">
                  {DUNGEON_COINS_PER_5_FLOORS}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.coinsPerFloors}
                </div>
              </div>
              <div className="rounded-xl bg-destructive/10 p-3">
                <Skull className="mx-auto h-5 w-5 text-destructive" />
                <div className="mt-1 font-display text-lg font-bold text-destructive">1</div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.life}
                </div>
              </div>
            </div>

            {accessQuery.isLoading || !access ? (
              <div className="mt-8 text-sm text-muted-foreground">…</div>
            ) : access.reason === "SUBSCRIPTION" ? (
              <SubscriptionPaywall />
            ) : !access.canAccess ? (
              <div className="mx-auto mt-8 max-w-sm rounded-2xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-5 text-left">
                <div className="flex items-center gap-2 font-display font-bold text-[color:var(--neon-gold)]">
                  <Lock className="h-5 w-5" /> Donjon verrouillé
                </div>
                <p className="mt-2 text-sm text-muted-foreground">
                  {access.reason === "DAILY_LIMIT"
                    ? `Limite quotidienne atteinte (${access.maxRunsPerDay} run${
                        access.maxRunsPerDay > 1 ? "s" : ""
                      }/jour). Reviens demain.`
                    : access.reason === "LEVEL"
                      ? "Monte de niveau pour débloquer le Donjon."
                      : "Le Donjon exige d'avoir déjà progressé dans plusieurs matières et chapitres."}
                </p>
                {access.reason === "PREREQ" && (
                  <div className="mt-3 space-y-1 text-xs text-muted-foreground">
                    <div>
                      Matières entamées : {access.subjectsDone}/{access.requiredSubjects}
                    </div>
                    <div>
                      Chapitres entamés : {access.chaptersDone}/{access.requiredChapters}
                    </div>
                  </div>
                )}
                <Link
                  to="/dashboard"
                  className="mt-4 inline-flex items-center gap-1.5 rounded-lg border border-border/50 px-4 py-2 text-sm font-semibold text-foreground hover:bg-card/60"
                >
                  Continuer à m'entraîner
                </Link>
              </div>
            ) : (
              <>
                <button
                  onClick={startDungeon}
                  aria-label="Enter the infinite dungeon mode"
                  className="mt-8 inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-8 py-3.5 text-base font-bold text-black shadow-gold transition-transform hover:scale-105"
                >
                  <Skull className="h-5 w-5" /> {t.dungeon.enterDungeon}
                </button>
                <div className="mt-3 text-xs text-muted-foreground">
                  Runs aujourd'hui : {access.runsToday}/{access.maxRunsPerDay}
                </div>
              </>
            )}
          </div>
        </motion.div>
      </div>
    );
  }

  // ========== GAME OVER ==========
  if (state === "gameover") {
    const floorsCleared = runResult?.floorsCleared ?? Math.max(0, floor - 1);
    return (
      <div className="mx-auto max-w-2xl px-6 py-12">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-destructive/40 bg-black/60 p-8 text-center backdrop-blur-xl"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-destructive/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-linear-to-br from-destructive to-[color:var(--gold)] shadow-lg">
              <Skull className="h-10 w-10 text-black" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold">{t.dungeon.collapsed}</h1>
            <p className="mt-2 text-muted-foreground">
              {t.dungeon.fellAt.replace("{n}", String(floor))}
            </p>

            {/* Last wrong answer */}
            {lastWrongAnswer && (
              <div className="mt-4 rounded-2xl border border-destructive/30 bg-destructive/5 p-4 text-left">
                <div className="text-xs uppercase tracking-widest text-destructive font-bold mb-2">
                  {t.dungeon.fatalQuestion}
                </div>
                <p
                  className="font-semibold"
                  dir={isRtlText(lastWrongAnswer.prompt) ? "rtl" : undefined}
                >
                  {lastWrongAnswer.prompt}
                </p>
                <div className="mt-2 grid gap-2 sm:grid-cols-2 text-sm">
                  <div className="rounded-lg bg-destructive/10 p-2">
                    <div className="text-[10px] uppercase tracking-widest text-muted-foreground">
                      {t.dungeon.yourAnswer}
                    </div>
                    <div className="font-mono uppercase text-destructive">
                      {lastWrongAnswer.selected}
                    </div>
                  </div>
                  <div className="rounded-lg bg-emerald-500/10 p-2">
                    <div className="text-[10px] uppercase tracking-widest text-muted-foreground">
                      {t.dungeon.correctAnswer}
                    </div>
                    <div className="font-mono uppercase text-emerald-400">
                      {lastWrongAnswer.correct}
                    </div>
                  </div>
                </div>
                {lastWrongAnswer.explanation && (
                  <p
                    className="mt-2 text-sm text-muted-foreground"
                    dir={isRtlText(lastWrongAnswer.explanation) ? "rtl" : undefined}
                  >
                    {lastWrongAnswer.explanation}
                  </p>
                )}
              </div>
            )}

            {/* Stats */}
            <div className="mt-6 grid grid-cols-4 gap-3">
              <div className="rounded-xl bg-(--neon-violet)/15 p-3">
                <Layers className="mx-auto h-4 w-4 text-neon-violet" />
                <div className="mt-1 font-display text-xl font-bold text-neon-violet">
                  {floorsCleared}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.floors}
                </div>
              </div>
              <div className="rounded-xl bg-(--neon-gold)/15 p-3">
                <Zap className="mx-auto h-4 w-4 text-neon-gold" />
                <div className="mt-1 font-display text-xl font-bold text-neon-gold">
                  +{runResult?.xpEarned ?? "..."}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.xp}
                </div>
              </div>
              <div className="rounded-xl bg-(--neon-cyan)/15 p-3">
                <Sparkles className="mx-auto h-4 w-4 text-neon-cyan" />
                <div className="mt-1 font-display text-xl font-bold text-neon-cyan">
                  +{runResult?.coinsEarned ?? "..."}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.coins}
                </div>
              </div>
              <div className="rounded-xl bg-(--flame)/15 p-3">
                <Shield className="mx-auto h-4 w-4 text-flame" />
                <div className="mt-1 font-display text-xl font-bold text-flame">
                  {runResult?.totalCorrect ?? totalCorrect}/
                  {runResult?.totalAnswered ?? totalAnswered}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.correct}
                </div>
              </div>
            </div>

            <div className="mt-8 flex flex-wrap justify-center gap-3">
              <Link
                to="/dashboard"
                className="rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80"
              >
                {t.dungeon.backToHall}
              </Link>
              <button
                onClick={startDungeon}
                className="rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-black shadow-gold hover:scale-105"
              >
                {t.dungeon.retryDungeon}
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
          <Loader2 className="h-8 w-8 animate-spin text-neon-magenta" />
          <div className="font-display text-sm uppercase tracking-widest text-muted-foreground">
            {t.dungeon.descending.replace("{n}", String(floor))}
          </div>
        </div>
      </div>
    );
  }

  const options = currentQuestion.options;
  const subjectInfo = currentQuestion.exercises?.subjects;
  const difficulty = currentQuestion.exercises?.difficulty ?? 1;
  const isCorrectAnswer = showFeedback && answerWasCorrect === true;

  return (
    <div className="mx-auto max-w-2xl px-6 py-8">
      <div className="mb-4 flex items-center justify-between">
        <Link
          to="/dashboard"
          className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.dungeon.leaveDungeon}
        </Link>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 rounded-full bg-(--neon-magenta)/20 px-3 py-1 text-sm font-bold text-neon-magenta">
            <Layers className="h-3.5 w-3.5" /> {t.dungeon.floor.replace("{n}", String(floor))}
          </div>
          <div className="flex items-center gap-1.5 rounded-full bg-destructive/20 px-3 py-1 text-sm font-bold text-destructive">
            <Skull className="h-3.5 w-3.5" /> {t.dungeon.oneHp}
          </div>
        </div>
      </div>

      {/* Subject & difficulty indicator */}
      <div className="mb-4 flex items-center justify-between">
        {subjectInfo && (
          <div
            className="rounded-full px-3 py-1 text-xs font-bold uppercase tracking-wider"
            style={{
              color: `var(--subject-${subjectInfo.color_token})`,
              background: `color-mix(in oklab, var(--subject-${subjectInfo.color_token}) 15%, transparent)`,
            }}
          >
            {subjectInfo.name_fr}
          </div>
        )}
        <div className="flex gap-1">
          {[1, 2, 3].map((d) => (
            <div
              key={d}
              className={`h-2 w-5 rounded-full ${d <= difficulty ? "bg-neon-magenta" : "bg-secondary"}`}
            />
          ))}
        </div>
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentQuestion.id}
          initial={{ opacity: 0, x: 30 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -30 }}
          transition={{ duration: 0.25 }}
          className="rounded-3xl border border-(--neon-magenta)/30 bg-card/60 p-6 backdrop-blur-xl sm:p-8"
          dir={
            subjectInfo &&
            (subjectInfo.color_token === "math" || subjectInfo.color_token === "arabic")
              ? "rtl"
              : undefined
          }
        >
          <h2
            className="font-display text-xl font-semibold sm:text-2xl"
            dir={isRtlText(currentQuestion.prompt) ? "rtl" : undefined}
          >
            {currentQuestion.prompt}
          </h2>
          <p className="mt-2 text-sm text-muted-foreground">{t.dungeon.warning}</p>

          <div className="mt-6 space-y-3" role="radiogroup" aria-label={currentQuestion.prompt}>
            {options.map((opt) => {
              const isSel = selected === opt.id;
              const isCorrect = showFeedback && isSel && answerWasCorrect === true;
              const isWrong = showFeedback && isSel && answerWasCorrect === false;

              let cls =
                "border-(--neon-magenta)/20 bg-background/40 hover:border-(--neon-magenta)/60 hover:bg-(--neon-magenta)/5";
              if (showFeedback) {
                if (isCorrect) cls = "border-emerald-500 bg-emerald-500/15";
                else if (isWrong) cls = "border-destructive bg-destructive/15";
                else cls = "border-border/30 bg-background/20 opacity-50";
              } else if (isSel) {
                cls = "border-(--neon-magenta) bg-(--neon-magenta)/15";
              }

              return (
                <button
                  key={opt.id}
                  type="button"
                  role="radio"
                  aria-checked={isSel}
                  onClick={() => handleSelect(opt.id)}
                  disabled={showFeedback || answerMutation.isPending}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition ${cls} ${showFeedback ? "cursor-default" : ""}`}
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
                  {/* Non-color indicator: icon + screen-reader text so correctness is
                      conveyed without relying on colour alone. */}
                  {showFeedback && isCorrect && (
                    <span className="flex shrink-0 items-center">
                      <CheckCircle2 className="h-5 w-5 text-emerald-500" aria-hidden="true" />
                      <span className="sr-only">{t.dungeon.correctMsg}</span>
                    </span>
                  )}
                  {showFeedback && isWrong && (
                    <span className="flex shrink-0 items-center">
                      <XCircle className="h-5 w-5 text-destructive" aria-hidden="true" />
                      <span className="sr-only">{t.dungeon.wrongMsg}</span>
                    </span>
                  )}
                </button>
              );
            })}
          </div>

          {/* Feedback */}
          {showFeedback && (
            <motion.div
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              className={`mt-4 rounded-xl border p-3 text-sm font-semibold ${isCorrectAnswer ? "border-emerald-500/30 bg-emerald-500/10 text-emerald-300" : "border-destructive/30 bg-destructive/10 text-destructive"}`}
            >
              {isCorrectAnswer ? (
                <span className="flex items-center gap-2">
                  <CheckCircle2 className="h-4 w-4" /> {t.dungeon.correctMsg}
                </span>
              ) : (
                <span className="flex items-center gap-2">
                  <XCircle className="h-4 w-4" /> {t.dungeon.wrongMsg}
                </span>
              )}
            </motion.div>
          )}
        </motion.div>
      </AnimatePresence>

      {/* Floor progress bar (visual flair) */}
      <div className="mt-6 flex items-center gap-3">
        <div className="text-xs uppercase tracking-widest text-muted-foreground">
          {t.dungeon.depth}
        </div>
        <div
          className="flex-1 h-2 overflow-hidden rounded-full bg-secondary/60"
          role="progressbar"
          aria-label="Dungeon depth"
          aria-valuenow={floor}
          aria-valuemin={0}
          aria-valuemax={50}
        >
          <motion.div
            className="h-full rounded-full bg-linear-to-r from-neon-magenta to-neon-violet"
            animate={{ width: `${Math.min(100, (floor / 50) * 100)}%` }}
            transition={{ duration: 0.5 }}
          />
        </div>
        <div className="text-xs font-bold text-neon-magenta">{floor}</div>
      </div>
    </div>
  );
}

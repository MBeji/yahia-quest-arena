import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useRef, useState } from "react";
import {
  ArrowLeft,
  Zap,
  Sparkles,
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
// Deep component imports (route→feature convention, like quest.$exerciseId):
// the barrel would drag quest.server.ts into this route's module graph.
import { QuestionInput, type McqOptionRender } from "@/features/quest/components/question-input";
import { buildQuestLabels } from "@/features/quest/quest-labels";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";
import { isValidAnswerFormat } from "@/shared/lib/answer-formats";
import { RichField } from "@/components/ui/svg-figure";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/dungeon")({
  head: () => ({ meta: [{ title: "Donjon · Na9ra Nal3ab" }] }),
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
    onError: (e) => toast.error(e instanceof Error ? e.message : t.dungeon.errorSavingRun),
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
          toast.error(t.dungeon.noMoreQuestions);
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
        toast.error(t.dungeon.failedLoadQuestions);
        return false;
      } finally {
        setLoading(false);
      }
    },
    [fetchQuestions, t.dungeon.failedLoadQuestions, t.dungeon.noMoreQuestions],
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
      toast.error(error instanceof Error ? error.message : t.dungeon.failedStartRun);
    }
  }

  // Selecting only highlights a choice; it is freely changeable until the
  // player commits with "Valider". No answer is sent to the server here — which
  // means a misclick can no longer end the run.
  function handleSelect(optId: string) {
    if (showFeedback || answerMutation.isPending) return;
    setSelected(optId);
  }

  // The sole commit path: submits the currently selected choice. A wrong answer
  // still ends the run — but only once the player has deliberately validated.
  async function validate() {
    if (showFeedback || answerMutation.isPending || !currentQuestion || !runId || !selected) return;
    if (!isValidAnswerFormat(currentQuestion.questionType, selected)) return;
    // Native types (numeric value, ordering/matching CSVs) have no display
    // letter — show their raw wire answers in the game-over recap.
    const isNativeAnswer = currentQuestion.questionType !== "mcq";
    const optId = selected;
    const selectedOption = currentQuestion.options.find((opt) => opt.id === optId);

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
          selected: isNativeAnswer ? optId : (selectedOption?.displayId ?? optId.toUpperCase()),
          correct: isNativeAnswer
            ? (result.correctChoice ?? "-")
            : (correctOption?.displayId ?? (result.correctChoice ?? "-").toUpperCase()),
          explanation: result.explanation,
        });
        setFloor(result.nextFloor);
        setTimeout(() => endRun(), 2000);
      }
    } catch (error) {
      setShowFeedback(false);
      setSelected(null);
      setAnswerWasCorrect(null);
      toast.error(error instanceof Error ? error.message : t.dungeon.failedValidateAnswer);
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
      <div className="mx-auto max-w-2xl px-4 py-12 sm:px-6">
        <Link
          to="/dashboard"
          className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.dungeon.heroesHall}
        </Link>

        <motion.div
          initial={{ opacity: 0, y: 12 }}
          animate={{ opacity: 1, y: 0 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/40 bg-black/60 p-5 text-center backdrop-blur-xl sm:p-8"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-[color:var(--gold)]/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)] shadow-gold animate-pulse-neon">
              <Skull className="h-10 w-10 text-black" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold sm:text-4xl">{t.dungeon.title}</h1>
            <p className="mt-3 text-muted-foreground max-w-md mx-auto">{t.dungeon.desc}</p>

            <div className="mt-8 grid grid-cols-3 gap-2 max-w-sm mx-auto sm:gap-4">
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

            {accessQuery.isError ? (
              // A failed access check must not strand the lobby on an endless
              // spinner — surface the error and offer a retry.
              <div className="mx-auto mt-8 max-w-sm rounded-2xl border border-destructive/40 bg-destructive/5 p-5 text-left">
                <div className="flex items-center gap-2 font-display font-bold text-destructive">
                  <XCircle className="h-5 w-5" /> {t.dungeon.loadAccessError}
                </div>
                <button
                  onClick={() => accessQuery.refetch()}
                  disabled={accessQuery.isFetching}
                  className="mt-4 inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-border/50 px-4 py-2 text-sm font-semibold text-foreground hover:bg-black/60 disabled:opacity-50"
                >
                  {accessQuery.isFetching && <Loader2 className="h-4 w-4 animate-spin" />}
                  {t.common.retry}
                </button>
              </div>
            ) : accessQuery.isLoading || !access ? (
              <div className="mt-8 text-sm text-muted-foreground">{t.common.loading}</div>
            ) : access.reason === "SUBSCRIPTION" ? (
              <SubscriptionPaywall />
            ) : !access.canAccess ? (
              <div className="mx-auto mt-8 max-w-sm rounded-2xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-5 text-left">
                <div className="flex items-center gap-2 font-display font-bold text-[color:var(--neon-gold)]">
                  <Lock className="h-5 w-5" /> {t.dungeon.locked}
                </div>
                <p className="mt-2 text-sm text-muted-foreground">
                  {access.reason === "DAILY_LIMIT"
                    ? t.dungeon.dailyLimitReached.replace("{max}", String(access.maxRunsPerDay))
                    : access.reason === "LEVEL"
                      ? t.dungeon.levelLocked
                      : t.dungeon.prereqLocked}
                </p>
                {access.reason === "PREREQ" && (
                  <div className="mt-3 space-y-1 text-xs text-muted-foreground">
                    <div>
                      {t.dungeon.subjectsStarted
                        .replace("{done}", String(access.subjectsDone))
                        .replace("{required}", String(access.requiredSubjects))}
                    </div>
                    <div>
                      {t.dungeon.chaptersStarted
                        .replace("{done}", String(access.chaptersDone))
                        .replace("{required}", String(access.requiredChapters))}
                    </div>
                  </div>
                )}
                <Link
                  to="/dashboard"
                  className="mt-4 inline-flex items-center gap-1.5 rounded-lg border border-border/50 px-4 py-2 text-sm font-semibold text-foreground hover:bg-black/60"
                >
                  {t.dungeon.keepTraining}
                </Link>
              </div>
            ) : (
              <>
                <button
                  onClick={startDungeon}
                  aria-label={t.dungeon.enterDungeonAria}
                  className="mt-8 inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-8 py-3.5 text-base font-bold text-black shadow-gold transition-transform hover:scale-105"
                >
                  <Skull className="h-5 w-5" /> {t.dungeon.enterDungeon}
                </button>
                <div className="mt-3 text-xs text-muted-foreground">
                  {t.dungeon.runsToday
                    .replace("{n}", String(access.runsToday))
                    .replace("{max}", String(access.maxRunsPerDay))}
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
      <div className="mx-auto max-w-2xl px-4 py-12 sm:px-6">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="relative overflow-hidden rounded-3xl border border-destructive/40 bg-black/60 p-5 text-center backdrop-blur-xl sm:p-8"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-destructive/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-linear-to-br from-destructive to-[color:var(--gold)] shadow-lg">
              <Skull className="h-10 w-10 text-black" />
            </div>
            <h1 className="mt-5 font-display text-2xl font-bold sm:text-3xl">
              {t.dungeon.collapsed}
            </h1>
            <p className="mt-2 text-muted-foreground">
              {t.dungeon.fellAt.replace("{n}", String(floor))}
            </p>

            {/* Last wrong answer */}
            {lastWrongAnswer && (
              <div className="mt-4 rounded-2xl border border-destructive/30 bg-destructive/5 p-4 text-left">
                <div className="text-xs uppercase tracking-widest text-destructive font-bold mb-2">
                  {t.dungeon.fatalQuestion}
                </div>
                <RichField raw={lastWrongAnswer.prompt} as="p" className="font-semibold" />
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
                  <RichField
                    raw={lastWrongAnswer.explanation}
                    as="p"
                    className="mt-2 text-sm text-muted-foreground"
                  />
                )}
              </div>
            )}

            {/* Stats */}
            <div className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-4">
              <div className="rounded-xl bg-[color:var(--gold)]/15 p-3">
                <Layers className="mx-auto h-4 w-4 text-[color:var(--gold)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--gold)]">
                  {floorsCleared}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.floors}
                </div>
              </div>
              <div className="rounded-xl bg-[color:var(--gold)]/15 p-3">
                <Zap className="mx-auto h-4 w-4 text-[color:var(--gold)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--gold)]">
                  +{runResult?.xpEarned ?? "..."}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.xp}
                </div>
              </div>
              <div className="rounded-xl bg-[color:var(--gold)]/15 p-3">
                <Sparkles className="mx-auto h-4 w-4 text-[color:var(--gold)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--gold)]">
                  +{runResult?.coinsEarned ?? "..."}
                </div>
                <div className="text-[10px] uppercase tracking-wider text-muted-foreground">
                  {t.dungeon.coins}
                </div>
              </div>
              <div className="rounded-xl bg-[color:var(--gold)]/15 p-3">
                <Shield className="mx-auto h-4 w-4 text-[color:var(--gold)]" />
                <div className="mt-1 font-display text-xl font-bold text-[color:var(--gold)]">
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
                className="inline-flex items-center rounded-lg border border-border bg-background/50 px-5 py-2.5 text-sm font-semibold hover:bg-background/80 [@media(pointer:coarse)]:min-h-11"
              >
                {t.dungeon.backToHall}
              </Link>
              <button
                onClick={startDungeon}
                className="rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-black shadow-gold hover:scale-105 [@media(pointer:coarse)]:min-h-11"
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
      <div className="grid min-h-[60dvh] place-items-center">
        <div className="flex flex-col items-center gap-3">
          <Loader2 className="h-8 w-8 animate-spin text-[color:var(--gold)]" />
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
  // Content-language labels for the per-type input. The dungeon payload only
  // carries color_token (not content_language) — same signal as the RTL flag.
  const dungeonInputLabels = buildQuestLabels(subjectInfo?.color_token === "arabic" ? "ar" : "fr");
  const canValidate = Boolean(
    selected && isValidAnswerFormat(currentQuestion.questionType, selected),
  );

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
        <Link
          to="/dashboard"
          className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.dungeon.leaveDungeon}
        </Link>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 rounded-full bg-[color:var(--gold)]/20 px-3 py-1 text-sm font-bold text-[color:var(--gold)]">
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
              className={`h-2 w-5 rounded-full ${d <= difficulty ? "bg-[color:var(--gold)]" : "bg-secondary"}`}
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
          className="rounded-3xl border border-[color:var(--gold)]/30 bg-black/60 p-6 backdrop-blur-xl sm:p-8"
          // Only Arabic content is RTL. Math uses standard LTR notation (project
          // rule), so it must NOT be forced RTL. Full unification on the subject's
          // content_language is pending a get_dungeon_questions RPC change to carry
          // it in the payload; until then the color_token is the only signal here.
          dir={subjectInfo && subjectInfo.color_token === "arabic" ? "rtl" : undefined}
        >
          <RichField
            raw={currentQuestion.prompt}
            as="h2"
            className="font-display text-xl font-semibold sm:text-2xl"
          />
          <p className="mt-2 text-sm text-muted-foreground">{t.dungeon.warning}</p>

          <QuestionInput
            questionType={currentQuestion.questionType}
            prompt={currentQuestion.prompt}
            options={options}
            value={selected}
            onChange={handleSelect}
            onSubmit={validate}
            disabled={showFeedback || answerMutation.isPending}
            rtl={subjectInfo?.color_token === "arabic"}
            labels={dungeonInputLabels}
            optionClassName={({ isSelected }: McqOptionRender) => {
              const isCorrect = showFeedback && isSelected && answerWasCorrect === true;
              const isWrong = showFeedback && isSelected && answerWasCorrect === false;
              let cls =
                "border-[color:var(--gold)]/20 bg-background/40 hover:border-[color:var(--gold)]/60 hover:bg-[color:var(--gold)]/5";
              if (showFeedback) {
                if (isCorrect) cls = "border-emerald-500 bg-emerald-500/15";
                else if (isWrong) cls = "border-destructive bg-destructive/15";
                else cls = "border-border/30 bg-background/20 opacity-50";
              } else if (isSelected) {
                cls = "border-[color:var(--gold)] bg-[color:var(--gold)]/15";
              }
              return `${cls} ${showFeedback ? "cursor-default" : ""}`;
            }}
            optionTrailing={({ isSelected }: McqOptionRender) => {
              const isCorrect = showFeedback && isSelected && answerWasCorrect === true;
              const isWrong = showFeedback && isSelected && answerWasCorrect === false;
              // Non-color indicator: icon + screen-reader text so correctness is
              // conveyed without relying on colour alone.
              if (isCorrect) {
                return (
                  <span className="flex shrink-0 items-center">
                    <CheckCircle2 className="h-5 w-5 text-emerald-500" aria-hidden="true" />
                    <span className="sr-only">{t.dungeon.correctMsg}</span>
                  </span>
                );
              }
              if (isWrong) {
                return (
                  <span className="flex shrink-0 items-center">
                    <XCircle className="h-5 w-5 text-destructive" aria-hidden="true" />
                    <span className="sr-only">{t.dungeon.wrongMsg}</span>
                  </span>
                );
              }
              return null;
            }}
          />

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

          {!showFeedback && (
            <div className="mt-6 flex justify-end">
              <button
                type="button"
                data-testid="dungeon-validate"
                disabled={!canValidate || answerMutation.isPending}
                onClick={validate}
                className="inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-6 py-2.5 text-sm font-bold text-black shadow-gold transition disabled:opacity-40"
              >
                {answerMutation.isPending && <Loader2 className="h-4 w-4 animate-spin" />}
                {t.dungeon.validate}
              </button>
            </div>
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
            className="h-full rounded-full bg-[linear-gradient(to_right,var(--gold),var(--gold-bright))]"
            animate={{ width: `${Math.min(100, (floor / 50) * 100)}%` }}
            transition={{ duration: 0.5 }}
          />
        </div>
        <div className="text-xs font-bold text-[color:var(--gold)]">{floor}</div>
      </div>
    </div>
  );
}

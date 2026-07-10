import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useRef, useState } from "react";
import {
  Zap,
  Sparkles,
  Skull,
  Shield,
  Layers,
  CheckCircle2,
  XCircle,
  Loader2,
  Lock,
  Flame,
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
import { LoadingState } from "@/components/ui/loading-state";
import { BackLink } from "@/components/ui/back-link";
import { PageShell } from "@/components/ui/page-shell";
import { GoldProgress } from "@/components/game/gold-progress";
import { StatTile } from "@/components/game/stat-tile";
import { DifficultyStars } from "@/components/game/difficulty-stars";
import { useEntrance } from "@/shared/lib/motion";
import { useSound, encouragementFor, type Encouragement } from "@/lib/sound";

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
  const riseIn = useEntrance("rise");
  const scaleIn = useEntrance("scale");
  const { play, combo } = useSound();
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
  // Transient encouragement banner shown on combo milestones (3, 5, 7, 10…).
  const [encouragement, setEncouragement] = useState<Encouragement | null>(null);
  const startTimeRef = useRef<number>(0);

  const submitMutation = useMutation({
    mutationFn: (payload: { runId: string; durationSeconds: number }) =>
      submitRun({ data: payload }),
    onSuccess: (res) => {
      setRunResult(res);
      setTotalCorrect(res.totalCorrect);
      setTotalAnswered(res.totalAnswered);
      play("gameOver");
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
        play("descend");
        return true;
      } catch {
        toast.error(t.dungeon.failedLoadQuestions);
        return false;
      } finally {
        setLoading(false);
      }
    },
    [fetchQuestions, play, t.dungeon.failedLoadQuestions, t.dungeon.noMoreQuestions],
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
    setEncouragement(null);
    play("start");
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
    // Discrete taps get a blip; typed numeric input stays silent.
    if (currentQuestion?.questionType === "mcq" || currentQuestion?.questionType === "multi")
      play("select");
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
        // Every correct answer in a run is consecutive (one miss ends it), so the
        // running total IS the combo streak — the pitch climbs and milestones
        // surface an encouraging banner.
        combo(result.totalCorrect);
        setEncouragement(encouragementFor(t.encouragement, result.totalCorrect));
        setTimeout(() => advanceOrEnd(result.nextFloor), 1200);
      } else {
        play("wrong");
        setEncouragement(null);
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
      <PageShell width="narrow" className="py-12">
        <BackLink to="/dashboard">{t.dungeon.heroesHall}</BackLink>

        <motion.div
          {...riseIn}
          className="relative overflow-hidden rounded-3xl border border-gold/40 bg-black/60 p-5 text-center backdrop-blur-xl sm:p-8"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-gold/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)] shadow-gold animate-pulse-neon">
              <Skull className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-3xl font-bold sm:text-4xl">{t.dungeon.title}</h1>
            <p className="mt-3 text-muted-foreground max-w-md mx-auto">{t.dungeon.desc}</p>

            <div className="mt-8 grid grid-cols-3 gap-2 max-w-sm mx-auto sm:gap-4">
              <StatTile icon={Zap} value={DUNGEON_XP_PER_FLOOR} label={t.dungeon.xpPerFloor} />
              <StatTile
                icon={Sparkles}
                value={DUNGEON_COINS_PER_5_FLOORS}
                label={t.dungeon.coinsPerFloors}
              />
              <StatTile icon={Skull} tone="destructive" value={1} label={t.dungeon.life} />
            </div>

            {accessQuery.isError ? (
              // A failed access check must not strand the lobby on an endless
              // spinner — surface the error and offer a retry.
              <div className="mx-auto mt-8 max-w-sm rounded-2xl border border-destructive/40 bg-destructive/5 p-5 text-start">
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
              <LoadingState label={t.common.loading} className="mt-2 py-8" />
            ) : access.reason === "SUBSCRIPTION" ? (
              <SubscriptionPaywall />
            ) : !access.canAccess ? (
              <div className="mx-auto mt-8 max-w-sm rounded-2xl border border-neon-gold/40 bg-neon-gold/5 p-5 text-start">
                <div className="flex items-center gap-2 font-display font-bold text-neon-gold">
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
                  className="mt-8 inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-8 py-3.5 text-base font-bold text-primary-foreground shadow-gold transition-transform hover:scale-105"
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
      </PageShell>
    );
  }

  // ========== GAME OVER ==========
  if (state === "gameover") {
    const floorsCleared = runResult?.floorsCleared ?? Math.max(0, floor - 1);
    return (
      <PageShell width="narrow" className="py-12">
        <motion.div
          {...scaleIn}
          className="relative overflow-hidden rounded-3xl border border-destructive/40 bg-black/60 p-5 text-center backdrop-blur-xl sm:p-8"
        >
          <div className="absolute -top-16 left-1/2 h-40 w-40 -translate-x-1/2 rounded-full bg-destructive/30 blur-3xl" />
          <div className="relative">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-2xl bg-linear-to-br from-destructive to-gold shadow-lg">
              <Skull className="h-10 w-10 text-primary-foreground" />
            </div>
            <h1 className="mt-5 font-display text-2xl font-bold sm:text-3xl">
              {t.dungeon.collapsed}
            </h1>
            <p className="mt-2 text-muted-foreground">
              {t.dungeon.fellAt.replace("{n}", String(floor))}
            </p>

            {/* Last wrong answer */}
            {lastWrongAnswer && (
              <div className="mt-4 rounded-2xl border border-destructive/30 bg-destructive/5 p-4 text-start">
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
                  <div className="rounded-lg bg-success/10 p-2">
                    <div className="text-[10px] uppercase tracking-widest text-muted-foreground">
                      {t.dungeon.correctAnswer}
                    </div>
                    <div className="font-mono uppercase text-success">
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
              <StatTile icon={Layers} value={floorsCleared} label={t.dungeon.floors} />
              <StatTile
                icon={Zap}
                value={`+${runResult?.xpEarned ?? "..."}`}
                label={t.dungeon.xp}
              />
              <StatTile
                icon={Sparkles}
                value={`+${runResult?.coinsEarned ?? "..."}`}
                label={t.dungeon.coins}
              />
              <StatTile
                icon={Shield}
                value={`${runResult?.totalCorrect ?? totalCorrect}/${runResult?.totalAnswered ?? totalAnswered}`}
                label={t.dungeon.correct}
              />
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
                className="rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-primary-foreground shadow-gold hover:scale-105 [@media(pointer:coarse)]:min-h-11"
              >
                {t.dungeon.retryDungeon}
              </button>
            </div>
          </div>
        </motion.div>
      </PageShell>
    );
  }

  // ========== PLAYING ==========
  if (loading || !currentQuestion) {
    return (
      <LoadingState
        label={t.dungeon.descending.replace("{n}", String(floor))}
        className="min-h-[60dvh]"
      />
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
    <PageShell width="narrow">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
        <BackLink to="/dashboard" className="mb-0">
          {t.dungeon.leaveDungeon}
        </BackLink>
        <div className="flex items-center gap-3">
          <AnimatePresence>
            {totalCorrect >= 2 && (
              <motion.div
                key="combo-chip"
                initial={{ opacity: 0, scale: 0.6 }}
                animate={{ opacity: 1, scale: 1 }}
                exit={{ opacity: 0, scale: 0.6 }}
                className="flex items-center gap-1.5 rounded-full bg-flame/20 px-3 py-1 text-sm font-bold text-flame"
              >
                <Flame className="h-3.5 w-3.5" /> x{totalCorrect}
              </motion.div>
            )}
          </AnimatePresence>
          <div className="flex items-center gap-1.5 rounded-full bg-gold/20 px-3 py-1 text-sm font-bold text-gold">
            <Layers className="h-3.5 w-3.5" /> {t.dungeon.floor.replace("{n}", String(floor))}
          </div>
          <div className="flex items-center gap-1.5 rounded-full bg-destructive/20 px-3 py-1 text-sm font-bold text-destructive">
            <Skull className="h-3.5 w-3.5" /> {t.dungeon.oneHp}
          </div>
        </div>
      </div>

      {/* Encouragement banner — surfaces on combo milestones, then fades. */}
      <AnimatePresence mode="wait">
        {encouragement && (
          <motion.div
            key={encouragement.message}
            initial={{ opacity: 0, y: -8, scale: 0.9 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -8, scale: 0.9 }}
            transition={{ type: "spring", damping: 14, stiffness: 240 }}
            className="mb-4 text-center font-display text-lg font-black text-flame drop-shadow-[0_0_12px_color-mix(in_oklab,var(--flame)_50%,transparent)]"
            aria-live="polite"
          >
            {encouragement.message}
          </motion.div>
        )}
      </AnimatePresence>

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
        <DifficultyStars level={difficulty} />
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentQuestion.id}
          initial={{ opacity: 0, x: 30 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -30 }}
          transition={{ duration: 0.25 }}
          className="rounded-3xl border border-gold/30 bg-black/60 p-6 backdrop-blur-xl sm:p-8"
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
              let cls = "border-gold/20 bg-background/40 hover:border-gold/60 hover:bg-gold/5";
              if (showFeedback) {
                if (isCorrect) cls = "border-emerald-500 bg-emerald-500/15";
                else if (isWrong) cls = "border-destructive bg-destructive/15";
                else cls = "border-border/30 bg-background/20 opacity-50";
              } else if (isSelected) {
                cls = "border-gold bg-gold/15";
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
                className="inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-6 py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition disabled:opacity-40"
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
        <GoldProgress
          value={Math.min(100, (floor / 50) * 100)}
          size="sm"
          aria-label={t.dungeon.depth}
          className="flex-1"
        />
        <div className="text-xs font-bold text-gold">{floor}</div>
      </div>
    </PageShell>
  );
}

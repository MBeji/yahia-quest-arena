import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence } from "motion/react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { ArrowLeft, Loader2, Trophy, Skull, Heart, BookOpen, Check, Crown } from "lucide-react";
import { toast } from "sonner";
import {
  computeNextExerciseId,
  getExercise,
  getSubject,
  noXpReason,
  revealHint,
  startExerciseSession,
  submitAttempt,
} from "@/features/quest";
import { PASS_THRESHOLD_PCT, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { isRtlText, isMathExpression } from "@/shared/lib/utils";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";
import { RichField, OptionContent } from "@/components/ui/svg-figure";
import { levelForXp } from "@/shared/lib/level";
import { QuestResultActions } from "@/features/quest/components/quest-result-actions";
import { QuestRewardGrid } from "@/features/quest/components/quest-reward-grid";
import { QuizLockScreen } from "@/features/quest/components/quiz-lock-screen";
import { QuestHintButton } from "@/features/quest/components/quest-hint-button";
import { BossCountdown } from "@/features/quest/components/boss-countdown";
import { buildQuestLabels, type QuestContentLang } from "@/features/quest/quest-labels";
import { ReportErrorButton } from "@/features/content-report";
import { Confetti } from "@/features/quest/components/confetti";
import { SubscriptionPaywall } from "@/features/subscription";
import { LevelUpCelebration } from "@/components/ui/level-up-celebration";
import { ExplainHint } from "@/components/ui/explain-hint";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/quest/$exerciseId")({
  head: () => ({ meta: [{ title: "Quête · Na9ra Nal3ab" }] }),
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
  const fetchSubjectForNext = useServerFn(getSubject);
  const reveal = useServerFn(revealHint);

  const { data, isLoading } = useQuery({
    queryKey: ["exercise", exerciseId],
    queryFn: () => fetchExercise({ data: { exerciseId } }),
  });

  const subjectIdForNext = data?.exercise?.subject_id ?? null;
  const siblingSubjectQuery = useQuery({
    queryKey: ["subject", subjectIdForNext],
    queryFn: () => fetchSubjectForNext({ data: { subjectId: subjectIdForNext as string } }),
    enabled: Boolean(subjectIdForNext),
  });

  // The next playable exercise (skipping quizzes), in chapter → display order.
  const nextExerciseId = useMemo<string | null>(() => {
    const sd = siblingSubjectQuery.data;
    const cur = data?.exercise;
    if (!sd || !cur) return null;
    return computeNextExerciseId(sd.chapters, sd.exercises, cur);
  }, [siblingSubjectQuery.data, data]);

  const [idx, setIdx] = useState(0);
  const [answers, setAnswers] = useState<Answer[]>([]);
  // The chosen option for the current question. It is freely changeable until the
  // student clicks "Valider": selecting only highlights a choice — nothing is
  // recorded or advanced until validation. There is NO auto-advance on select.
  const [selected, setSelected] = useState<string | null>(null);
  const [showConfetti, setShowConfetti] = useState(false);
  const [showLevelUp, setShowLevelUp] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [result, setResult] = useState<Awaited<ReturnType<typeof submitAttempt>> | null>(null);
  // Hint consumables (booster_hint / potion_rappel): remaining reveal charges and
  // the hints revealed this session, keyed by question id (value = text or null
  // when the question has no explanation). A revealed question can't be re-spent.
  const [hintsRemaining, setHintsRemaining] = useState(0);
  const [revealedHints, setRevealedHints] = useState<Record<string, string | null>>({});

  const sessionMutation = useMutation({
    mutationFn: (payload: { exerciseId: string }) => startSession({ data: payload }),
    onSuccess: (res) => setSessionId(res.sessionId),
    onError: (e) => toast.error(e instanceof Error ? e.message : "Unable to start the quest"),
  });
  // `mutate`/`reset` are referentially stable (bound to the mutation observer),
  // so the session-start effect can depend on `startSessionMutate` instead of the
  // whole `sessionMutation` object — the latter is recreated every render and
  // would make the effect re-run (and re-fire mutate) on each status change.
  const { mutate: startSessionMutate, reset: resetSessionMutation } = sessionMutation;

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
      const prevLevel = levelForXp(prevXp);
      if (profileLevel > prevLevel && res.xpEarned > 0) {
        setTimeout(() => setShowLevelUp(true), 1200);
      }
      qc.invalidateQueries({ queryKey: ["dashboard"] });
      qc.invalidateQueries({ queryKey: ["subject"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.errors.errorFallback),
  });

  // Sync the available reveal charges once the exercise (and the user's hint
  // inventory) loads. The server fn is the authority for decrementing; this only
  // seeds the client-side display/guard.
  const hintCharges = data?.hintCharges ?? 0;
  useEffect(() => {
    setHintsRemaining(hintCharges);
  }, [hintCharges, exerciseId]);

  const hintMutation = useMutation({
    mutationFn: (payload: { questionId: string }) => reveal({ data: payload }),
    onSuccess: (res) => {
      // Record the reveal result for this question (text, or null when the
      // question has no explanation).
      setRevealedHints((prev) =>
        res.questionId in prev ? prev : { ...prev, [res.questionId]: res.hint },
      );
      // Drop a charge locally only when the RPC actually spent one. A question
      // with no hint to give costs nothing (anti-waste, matches the server).
      if (res.consumed) {
        setHintsRemaining((n) => Math.max(0, n - 1));
      }
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.errors.errorFallback),
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
  const subjectInfo = data?.exercise?.subjects as {
    color_token?: string;
    content_language?: string;
  } | null;
  // RTL follows the subject's content language (Arabic), consistent with the
  // subject and lesson screens — never the color_token, which is cosmetic.
  const isRtlSubject = subjectInfo?.content_language === "ar";

  // Boss mode: the per-question countdown lives in <BossCountdown> so its 1 Hz
  // tick re-renders only that chip, not the whole QuestPage tree.
  const answeredQuestionRef = useRef<string | null>(null);
  // The exercise id we've already started (or attempted to start) a session for.
  // This guards the start effect so a rejected start (e.g. a premium-locked
  // mission the server refuses) does NOT retry in a loop and spam an error toast
  // on every render. resetRun() clears it so replays / navigation start fresh.
  const sessionStartedForRef = useRef<string | null>(null);
  // Refs so the boss-timeout callback reads live values at fire time (avoids
  // stale closures without restarting <BossCountdown>'s interval).
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

  // Boss mode keeps its time pressure: when the per-question timer expires we
  // commit whatever the student has currently selected, or a `__timeout__` answer
  // if they didn't pick one. This is the only automatic advance left — a *timeout*,
  // not a passage on select. Reads live state via refs, so the identity churn from
  // `mutation` never restarts <BossCountdown>'s interval.
  const handleBossTimeout = useCallback(() => {
    if (answeredQuestionRef.current === currentRef.current?.id) return;
    answeredQuestionRef.current = currentRef.current?.id ?? null;
    const autoAnswer: Answer = {
      questionId: currentRef.current?.id ?? "",
      choice: selectedRef.current ?? "__timeout__",
    };
    const nextAnswers = [...answersRef.current, autoAnswer];
    if (idxRef.current + 1 >= totalRef.current) {
      mutation.mutate({ sessionId: sessionIdRef.current!, exerciseId, answers: nextAnswers });
    } else {
      setAnswers(nextAnswers);
      setIdx((i) => i + 1);
      setSelected(null);
      answeredQuestionRef.current = null;
    }
  }, [exerciseId, mutation]);

  // Boss HP: starts at 100%, decreases per answered question
  const bossHp = useMemo(() => {
    if (!isBoss || total === 0) return 100;
    return Math.max(0, Math.round(((total - idx) / total) * 100));
  }, [isBoss, total, idx]);

  const resetRun = useCallback(() => {
    answeredQuestionRef.current = null;
    // Allow the next exercise (or a replay of this one) to start a fresh session,
    // and clear any prior start error so it can't leak into the new run's render.
    sessionStartedForRef.current = null;
    resetSessionMutation();
    setResult(null);
    setIdx(0);
    setAnswers([]);
    setSelected(null);
    setShowConfetti(false);
    setShowLevelUp(false);
    setSessionId(null);
    setRevealedHints({});
    setHintsRemaining(hintCharges);
  }, [resetSessionMutation, hintCharges]);

  // Reset run state when navigating to a different exercise (e.g. "Next quest"),
  // so the same component instance starts the new quest cleanly.
  useEffect(() => {
    resetRun();
  }, [exerciseId, resetRun]);

  // Start the secure session once per exercise. The ref guard (not the mutation
  // status) is what stops re-firing: a rejected start settles to `isError`, and
  // re-running mutate() would loop and pop an error toast each time. Keying on
  // the exercise id lets a new exercise — or a replay, which clears the ref —
  // start cleanly on this same (reused) component instance.
  useEffect(() => {
    const exId = data?.exercise?.id;
    if (!exId || sessionId || result) return;
    if (sessionStartedForRef.current === exId) return;
    sessionStartedForRef.current = exId;
    startSessionMutate({ exerciseId: exId });
  }, [data?.exercise?.id, result, sessionId, startSessionMutate]);

  const advanceWithChoice = useCallback(
    (choice: string) => {
      if (!sessionId || !current?.id) return;

      // Prevent duplicate processing when a boss timeout and the manual button race.
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
      answeredQuestionRef.current = null;
    },
    [answers, current?.id, exerciseId, idx, mutation, sessionId, total],
  );

  // The sole validation path: records the selected choice and advances. Enabled
  // only once an option is selected; the student can re-pick freely until then.
  const validate = useCallback(() => {
    if (!selected || !sessionId) return;
    advanceWithChoice(selected);
  }, [advanceWithChoice, selected, sessionId]);

  // Keyboard shortcuts: 1-4 / A-D (re)select an answer — freely changeable —
  // and Enter/Space validates the current selection.
  useEffect(() => {
    if (result) return;
    function handleKeyDown(e: KeyboardEvent) {
      // Prevent if focus is on an input or button (unless it's the body)
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
      // A, B, C, D keys
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
    <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">
      {t.quest.preparing}
    </div>
  );

  if (isLoading || !data) return preparingScreen;

  const isQuiz = data.exercise.mode === "quiz";
  const chapterId = (data.exercise.chapter_id as string | null) ?? null;
  const exSubjectId = (data.exercise.subject_id as string | null) ?? null;
  const qlang = ((data.exercise.subjects as { content_language?: string } | null)
    ?.content_language ?? "fr") as QuestContentLang;
  const QL = buildQuestLabels(qlang);

  // Locked screen: the chapter comprehension quiz must be passed first
  // (enforced server-side in startExerciseSession).
  const sessionErrorMsg =
    sessionMutation.error instanceof Error ? sessionMutation.error.message : "";

  // Premium lock: the resolved parcours is premium and the mission is outside the
  // free preview. The server rejects the session start; show the paywall + reason.
  if (sessionMutation.isError && sessionErrorMsg.startsWith("Parcours premium")) {
    return (
      <div className="mx-auto max-w-md px-6 py-12 text-center">
        <div className="rounded-3xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-8">
          <Crown className="mx-auto h-12 w-12 text-[color:var(--neon-gold)]" />
          <h1 className="mt-4 font-display text-2xl font-bold">{QL.eliteLockedTitle}</h1>
          <p className="mt-3 text-sm text-muted-foreground">{sessionErrorMsg}</p>
          <SubscriptionPaywall />
          {exSubjectId && (
            <Link
              to="/matiere/$subjectId"
              params={{ subjectId: exSubjectId }}
              className="mt-5 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
            >
              <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {QL.back}
            </Link>
          )}
        </div>
      </div>
    );
  }

  if (sessionMutation.isError && sessionErrorMsg.includes("quiz de compréhension")) {
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
      />
    );
  }

  // RESULTS SCREEN
  if (result) {
    const passed = result.scorePct >= (isQuiz ? QUIZ_PASS_THRESHOLD_PCT : PASS_THRESHOLD_PCT);
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
                  passed
                    ? "border-emerald-500/40 bg-emerald-500/10 text-emerald-300"
                    : "border-[color:var(--neon-gold)]/50 bg-[color:var(--neon-gold)]/10 text-[color:var(--neon-gold)]"
                }`}
                dir={isRtlSubject ? "rtl" : undefined}
              >
                {passed ? QL.quizPassedBanner : QL.quizFailedBanner}
                {!passed && chapterId && (
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
            {result.xpEarned === 0 && (
              <div className="mt-6 rounded-xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-3 text-center text-xs text-[color:var(--gold)]">
                {noXpReason(result)}
              </div>
            )}
            {result.potionApplied && (
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
            <QuestRewardGrid
              xpEarned={result.xpEarned}
              coinsEarned={result.coinsEarned ?? 0}
              level={result.profile?.level ?? "?"}
              streak={result.profile?.current_streak ?? 0}
            />
            <div className="mt-6 text-xs uppercase tracking-widest text-[color:var(--champagne)]">
              {result.profile?.hero_class}
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
            <QuestResultActions
              subjectId={exSubjectId}
              nextExerciseId={nextExerciseId}
              onReplay={resetRun}
            />
            <ReportErrorButton exerciseId={exerciseId} />

            {!isQuiz && (
              <div className="mt-8 text-left">
                <h2 className="font-display text-xl font-bold">{t.quest.questReview}</h2>
                <div className="mt-4 space-y-3">
                  {result.review.map((item, reviewIndex) => (
                    <div
                      key={item.questionId}
                      data-testid="review-item"
                      data-correct={item.isCorrect ? "true" : "false"}
                      className="rounded-2xl border border-border/50 bg-black/30 p-4"
                    >
                      <div className="flex items-start justify-between gap-4">
                        <div>
                          <div className="text-xs uppercase tracking-widest text-muted-foreground">
                            {t.quest.questionN.replace("{n}", String(reviewIndex + 1))}
                          </div>
                          <RichField raw={item.prompt} className="mt-1 font-semibold" />
                        </div>
                        <div
                          className={`rounded-full px-3 py-1 text-xs font-bold ${item.isCorrect ? "bg-(--success)/15 text-success" : "bg-destructive/15 text-destructive"}`}
                        >
                          {item.isCorrect ? t.quest.passed : t.quest.needsWork}
                        </div>
                      </div>
                      <div className="mt-3 grid gap-2 text-sm sm:grid-cols-2">
                        <div className="rounded-xl bg-black/60 p-3">
                          <div className="text-xs uppercase tracking-widest text-muted-foreground">
                            {t.quest.yourAnswer}
                          </div>
                          <div className="mt-1 font-mono uppercase">
                            {getDisplayChoice(item.questionId, item.selectedChoice)}
                          </div>
                        </div>
                        <div className="rounded-xl bg-black/60 p-3">
                          <div className="text-xs uppercase tracking-widest text-muted-foreground">
                            {t.quest.correctAnswer}
                          </div>
                          <div className="mt-1 font-mono uppercase">
                            {getDisplayChoice(item.questionId, item.correctChoice)}
                          </div>
                        </div>
                      </div>
                      {item.explanation && (
                        <RichField
                          raw={item.explanation}
                          as="p"
                          className="mt-3 text-sm text-muted-foreground"
                        />
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </motion.div>
      </div>
    );
  }

  // The secure session is still being created (or re-created after a replay).
  // Hold on the "preparing" screen until we have a session id, so a premium-
  // locked mission never flashes the playing screen before the paywall (handled
  // by the early returns above) appears. A genuine non-premium/non-quiz start
  // error keeps `isError` set, surfaces its toast, and falls through below.
  if (!sessionId && !sessionMutation.isError) return preparingScreen;

  // Selecting only highlights a choice; the student can change it freely until
  // they click "Valider". No recording, no auto-advance here.
  function handleSelect(optId: string) {
    setSelected(optId);
  }

  const options = current ? (shuffledOptionsByQuestionId.get(current.id) ?? []) : [];
  // Hints are only offered in standard practice quests: quizzes hide their
  // explanations on purpose, and boss mode is a timed speed fight. The "Indice"
  // button reveals the current question's explanation for one consumable charge.
  const canUseHints = !isQuiz && !isBoss;
  const currentHintRevealed = current ? current.id in revealedHints : false;
  const leaveQuestClass =
    "mb-4 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground";

  return (
    <div className="mx-auto max-w-2xl px-6 py-8" dir={isRtlSubject ? "rtl" : undefined}>
      {exSubjectId ? (
        <Link
          to="/matiere/$subjectId"
          params={{ subjectId: exSubjectId }}
          className={leaveQuestClass}
        >
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.quest.leaveQuest}
        </Link>
      ) : (
        <Link to="/dashboard" className={leaveQuestClass}>
          <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.quest.leaveQuest}
        </Link>
      )}

      {/* Boss Mode Header */}
      {isBoss && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="mb-6 rounded-2xl border border-destructive/40 bg-destructive/10 p-4 backdrop-blur-md"
        >
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="grid h-10 w-10 place-items-center rounded-xl bg-linear-to-br from-destructive to-[color:var(--gold)] shadow-lg animate-pulse">
                <Skull className="h-5 w-5 text-primary-foreground" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.3em] text-destructive font-bold">
                  {t.quest.bossFight}
                </div>
                <div className="font-display text-lg font-bold">{data.exercise.title}</div>
              </div>
            </div>
            <BossCountdown
              active={isBoss && Boolean(sessionId) && !result}
              questionIndex={idx}
              onTimeout={handleBossTimeout}
            />
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
          {!isBoss && <span className="text-[color:var(--gold)]">{data.exercise.title}</span>}
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-secondary">
          <motion.div
            className={`h-full rounded-full shadow-gold ${isBoss ? "bg-linear-to-r from-destructive to-[color:var(--gold)]" : "bg-[image:var(--gradient-gold)]"}`}
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
          className={`rounded-3xl border p-6 backdrop-blur-xl sm:p-8 ${isBoss ? "border-destructive/30 bg-destructive/5" : "border-border/50 bg-black/60"}`}
        >
          <RichField
            raw={current.prompt}
            as="h2"
            className="font-display text-xl font-semibold sm:text-2xl"
          />
          <p className="mt-2 text-sm text-muted-foreground">
            {isBoss ? t.quest.bossStrike : isQuiz ? QL.quizRecorded : t.quest.feedbackMsg}
          </p>
          <div className="mt-6 space-y-3" role="radiogroup" aria-label={current.prompt}>
            {options.map((opt) => {
              const isSel = selected === opt.id;
              // Selected option is highlighted; the rest stay fully interactive so
              // the student can change their mind until they validate.
              const cls = isSel
                ? isBoss
                  ? "border-destructive bg-destructive/20"
                  : "border-(--gold) bg-(--gold)/15"
                : isBoss
                  ? "border-destructive/20 bg-black/40 hover:border-destructive/60 hover:bg-destructive/10"
                  : "border-border bg-black/40 hover:border-(--gold)/60 hover:bg-black/70";
              return (
                <button
                  key={opt.id}
                  type="button"
                  role="radio"
                  aria-checked={isSel}
                  onClick={() => handleSelect(opt.id)}
                  className={`flex w-full items-center justify-between gap-3 rounded-xl border px-4 py-3.5 text-left text-sm transition-all duration-200 active:scale-[0.97] ${cls}`}
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
                    <OptionContent raw={opt.text} />
                  </span>
                  {/* Non-color indicator: mark the currently selected (not yet
                      validated) choice with an icon + screen-reader text. */}
                  {isSel && (
                    <span className="flex shrink-0 items-center gap-1">
                      <Check className="h-5 w-5" aria-hidden="true" />
                      <span className="sr-only">{t.quest.selectedAnswer}</span>
                    </span>
                  )}
                </button>
              );
            })}
          </div>

          <div className="mt-3 text-center text-xs text-muted-foreground/60 hidden sm:block">
            {t.quest.keyboardHint.replace("{keys1}", "1-4").replace("{keys2}", "A-D")}
          </div>

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
              disabled={!selected || mutation.isPending || sessionMutation.isPending}
              onClick={validate}
              className={`inline-flex items-center gap-2 rounded-lg px-6 py-2.5 text-sm font-bold shadow-gold transition disabled:opacity-40 ${
                isBoss
                  ? "bg-linear-to-r from-destructive to-[color:var(--gold)] text-primary-foreground"
                  : "bg-[image:var(--gradient-gold)] text-black"
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

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion, AnimatePresence, useReducedMotion } from "motion/react";
import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from "react";
import { Loader2 } from "lucide-react";
import { toast } from "sonner";
import { computeNextExerciseId, getExercise, getSubject } from "@/features/quest";
import { PASS_THRESHOLD_PCT, RECALL_MIN_QUESTIONS } from "@/shared/constants/gamification";
import { shuffleOptions, type BaseOption } from "@/shared/lib/question-utils";
import { isValidAnswerFormat } from "@/shared/lib/answer-formats";
import { isolateLtrRuns } from "@/shared/lib/bidi";
import { RichField } from "@/components/ui/svg-figure";
import { QuestionInput, type McqOptionRender } from "@/features/quest/components/question-input";
import { levelForXp } from "@/shared/lib/level";
import { QuestResultScreen } from "@/features/quest/components/quest-result-screen";
import { QuizContractHint, QuizLockScreen } from "@/features/quest/components/quiz-lock-screen";
import { QuestHintButton } from "@/features/quest/components/quest-hint-button";
import { QuestSessionError } from "@/features/quest/components/quest-session-error";
import { BossBanner } from "@/features/quest/components/boss-chrono";
import {
  bossDamageFor,
  bossHpForDamage,
  bossRankForDamage,
  type BossSpeedTier,
} from "@/features/quest/boss-speed";
import {
  buildQuestLabels,
  KEYPAD_BY_LANG,
  RECALL_CHAR_BAR,
  type QuestContentLang,
} from "@/features/quest/quest-labels";
import { useT } from "@/lib/i18n";
import { LoadingState } from "@/components/ui/loading-state";
import { BackLink } from "@/components/ui/back-link";
import { PageShell } from "@/components/ui/page-shell";
import { GoldProgress } from "@/components/game/gold-progress";
import { questionSlide, useEntrance } from "@/shared/lib/motion";
import { useQuestPulse } from "@/features/quest/quest-pulse";
import { useSound } from "@/lib/sound";
import {
  ComboStrip,
  OptionVerdictMark,
  QuestionVerdictPanel,
} from "@/features/quest/components/question-verdict";
import { optionClassNameFor, type QuestionVerdict } from "@/features/quest/verdict";
import { useInstantFeedback } from "@/features/quest/components/use-instant-feedback";
import { useExerciseSession } from "@/features/quest/components/use-exercise-session";
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
//
// RETOUR IMMÉDIAT (levier 01) — pourquoi c'est tenable. Corriger une question en
// cours de partie révèle la bonne réponse avant que le score final ne soit
// calculé : il faut donc que la réponse ne puisse plus bouger. Deux verrous, et
// ce qu'ils ne couvrent pas :
//   1. La réponse est figée AVANT l'appel (`answeredQuestionRef` + `committedChoiceRef`),
//      la liste passe en `disabled`, les raccourcis clavier de sélection se taisent,
//      et « Continuer » rejoue la réponse figée — pas la sélection courante.
//   2. Le verdict ne vient jamais du client : c'est la RPC `check_answers`, qui
//      refuse le quiz de compréhension et tout exercice hors catalogue `admin`.
// Ce que ça ne prétend pas être : une garantie contre un client modifié. Cette
// même RPC est ouverte à `authenticated` depuis l'étude « types natifs » — la clé
// d'un exercice d'entraînement est donc déjà atteignable depuis une console, avec
// ou sans ce lot. Le modèle anti-triche du score repose sur le serveur
// (`submit_exercise_attempt`, anti-rush, session à usage unique), pas sur le
// secret de la clé côté navigateur. Ce lot n'ajoute aucune capacité — il rend
// visible dans l'UI ce que la plateforme sert déjà.
// =============================================================================

export type PlayerAnswer = { questionId: string; choice: string };

export type { QuestionVerdict };

export type PlayerReviewItem = {
  questionId: string;
  prompt: string;
  selectedChoice: string;
  correctChoice: string;
  isCorrect: boolean;
  explanation: string | null;
  /**
   * Étude 04 lot A1.2 — l'erreur nommée et son chapitre. OPTIONNELS à dessein :
   * la correction anonyme (`check_answers`) n'a ni l'une ni l'autre, et le rendu
   * dégradé est le comportement exigé (R-A1.2-3), pas un cas d'erreur.
   */
  misconceptionTag?: string | null;
  chapterId?: string | null;
  /** Les trois langues de l'erreur ; l'écran choisit la sienne (é07 `pickLabel`). */
  misconceptionLabels?: { fr: string; en: string; ar: string } | null;
  /** La compétence mise en défaut (A12) — cible du geste « m'entraîner ». */
  misconceptionCompetency?: string | null;
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
  /**
   * Prime de rapidité appliquée aux XP du boss (1 = aucune). Décidée serveur ;
   * le registre anonyme, qui ne gagne pas d'XP, la laisse toujours à 1.
   */
  speedBonus: number;
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
  capabilities: {
    rewards: boolean;
    hints: boolean;
    boss: boolean;
    next: boolean;
    /** Retour immédiat par question — exige `checkAnswer` pour s'activer. */
    instantFeedback: boolean;
  };
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
  /**
   * Corrige la question qui vient d'être validée. Appelée APRÈS le verrouillage
   * de la réponse, jamais avant : le verdict ne doit pouvoir changer aucune
   * réponse déjà donnée.
   */
  checkAnswer?: (args: {
    exerciseId: string;
    questionId: string;
    choice: string;
  }) => Promise<QuestionVerdict | null>;
  /** Premium paywall (connected only). */
  renderPremiumLock?: (ctx: {
    message: string;
    subjectId: string | null;
    contentLang: QuestContentLang;
  }) => ReactNode;
  /** Result-screen call-to-action (next/replay vs signup upsell). */
  /**
   * Étude 11 lot 1 — le panneau « Demander au Prof », sous une question ratée de
   * la correction. Fourni par la route CONNECTÉE seulement : le registre anonyme
   * (/exercice) n'a ni compte, ni clé de famille, ni tuteur. Absent = aucune
   * surface IA, ce qui est le mode NORMAL tant qu'aucune clé n'est branchée.
   */
  renderTutor?: (questionId: string) => ReactNode;
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
  const [result, setResult] = useState<PlayerResult | null>(null);
  const [hintsRemaining, setHintsRemaining] = useState(0);
  const [revealedHints, setRevealedHints] = useState<Record<string, string | null>>({});

  // Retour immédiat (levier 01). Jamais sur le quiz de compréhension (l'élève
  // s'y valide seul, la clé n'y est pas rendue) ni en Rappel (réponse libre :
  // `check_answers` la confronterait à la clé du QCM et rendrait des verdicts
  // faux). La machine à états vit dans son hook ; ici on décide quand l'appeler.
  const feedbackEnabled =
    capabilities.instantFeedback &&
    Boolean(strategy.checkAnswer) &&
    !isRecall &&
    data?.exercise?.mode !== "quiz";
  const {
    verdict: feedback,
    checking: feedbackChecking,
    streak: comboStreak,
    encouragement,
    check: checkAnswerNow,
    clear: clearFeedback,
    reset: resetFeedback,
  } = useInstantFeedback({
    enabled: feedbackEnabled,
    exerciseId,
    labels: t.encouragement,
    checkAnswer: strategy.checkAnswer,
  });

  // Wall-clock start of the run, used to measure the answer duration the anon
  // strategy needs for its anti-rush check (connected scoring is server-timed).
  const runStartedAtRef = useRef<number>(0);

  const session = useExerciseSession({
    data,
    paused: Boolean(result),
    variant,
    startSession: strategy.startSession,
    onStarted: () => {
      runStartedAtRef.current = Date.now();
      play("start");
    },
  });
  const { sessionId, startGate, reset: resetSession } = session;

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

  /** type par question — la correction en a besoin, pas seulement la question courante. */
  const typeByQuestionId = useMemo(
    () =>
      new Map(
        questions.map((q) => [
          q.id,
          (q as { question_type?: string | null }).question_type ?? "mcq",
        ]),
      ),
    [questions],
  );

  const getDisplayChoice = useCallback(
    (questionId: string, choice: string) => {
      if (!choice) return "-";
      // `short_answer` (étude 20 lot 7) : réponse tapée, aucune option — même
      // chemin d'affichage que le Rappel. Sans ce court-circuit, une réponse
      // contenant une virgule tomberait dans la branche CSV des types B2 et
      // s'afficherait découpée.
      if (typeByQuestionId.get(questionId) === "short_answer") return isolateLtrRuns(choice);
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
    [shuffledOptionsByQuestionId, isRecall, typeByQuestionId],
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

  // Temps réellement passé sur la mission, abandons compris — ce que
  // `attempts.duration_seconds` (écrit à la soumission) ne voit jamais. Gate :
  // `capabilities.rewards` n'est vrai que dans le registre CONNECTÉ ; le registre
  // public `/exercice` joue en anonyme et n'a aucun suivi à alimenter.
  useQuestPulse(data?.exercise ?? null, exerciseId, isRecall, capabilities.rewards);

  const answeredQuestionRef = useRef<string | null>(null);
  /** La réponse figée au moment de la correction, rejouée à « Continuer ». */
  const committedChoiceRef = useRef<string | null>(null);
  // Miroirs en ref des seuls états lus depuis un callback dont l'identité ne doit
  // pas changer. Les quatre autres (selected/answers/idx/current) n'existaient
  // que pour l'auto-réponse au buzzer, disparue avec le compte à rebours.
  const totalRef = useRef(total);
  const sessionIdRef = useRef(sessionId);
  totalRef.current = total;
  sessionIdRef.current = sessionId;

  const durationSeconds = useCallback(
    () => Math.max(0, Math.round((Date.now() - runStartedAtRef.current) / 1000)),
    [],
  );

  const submitRun = useCallback(
    (finalAnswers: PlayerAnswer[]) => {
      mutation.mutate(
        {
          sessionId: sessionIdRef.current!,
          exerciseId,
          chapterId: (data?.exercise?.chapter_id as string | null) ?? null,
          answers: finalAnswers,
          durationSeconds: durationSeconds(),
          isQuiz: data?.exercise?.mode === "quiz",
          totalQuestions: totalRef.current,
        },
        {
          // La soumission a ÉCHOUÉ : rien n'est enregistré, et l'élève est encore
          // devant sa dernière question. Sans ce relâchement, le verrou posé par
          // `advanceWithChoice` reste sur cette question — « Valider » redevient
          // cliquable mais ne fait PLUS RIEN, définitivement (seul un rechargement
          // en sort). C'est exactement ce que voyait un élève dont la RPC de
          // soumission rendait une erreur : il sélectionne, il valide, rien.
          onError: () => {
            answeredQuestionRef.current = null;
          },
        },
      );
    },
    [mutation, exerciseId, durationSeconds, data?.exercise?.mode, data?.exercise?.chapter_id],
  );

  // Chronomètre du combat de boss. Il ne coupe rien : la seule chose qu'il
  // décide, ce sont les dégâts de la question qu'on vient de répondre. La mesure
  // est prise ICI, à la validation — pas dans la pastille qui l'affiche, et pas
  // après l'écran de correction, qui n'est plus du temps de réflexion.
  const questionStartedAtRef = useRef<number>(0);
  const bossTimedQuestionRef = useRef<string | null>(null);
  const [bossDamage, setBossDamage] = useState(0);

  useEffect(() => {
    if (!bossMode || !sessionId) return;
    questionStartedAtRef.current = Date.now();
    bossTimedQuestionRef.current = null;
  }, [bossMode, sessionId, idx]);

  const commitBossTiming = useCallback(
    (questionId: string) => {
      if (!bossMode || bossTimedQuestionRef.current === questionId) return;
      bossTimedQuestionRef.current = questionId;
      const elapsed = (Date.now() - questionStartedAtRef.current) / 1000;
      setBossDamage((d) => d + bossDamageFor(elapsed, totalRef.current));
    },
    [bossMode],
  );

  // La barre de HP EST le score du chronomètre : elle ne suit plus l'avancement
  // (« question 3 sur 5 », qui ne disait rien), elle suit les dégâts cumulés.
  const bossHp = useMemo(
    () => (bossMode ? bossHpForDamage(bossDamage) : 100),
    [bossMode, bossDamage],
  );
  const bossSummary = useMemo<{ hp: number; rank: BossSpeedTier } | null>(
    () => (bossMode ? { hp: bossHp, rank: bossRankForDamage(bossDamage) } : null),
    [bossMode, bossHp, bossDamage],
  );

  const resetRun = useCallback(() => {
    answeredQuestionRef.current = null;
    bossTimedQuestionRef.current = null;
    resetSession();
    setResult(null);
    setBossDamage(0);
    setIdx(0);
    setAnswers([]);
    setSelected(null);
    setShowConfetti(false);
    setShowLevelUp(false);
    setRevealedHints({});
    // On dépend des CALLBACKS du hook, jamais de l'objet `instant` : il est neuf
    // à chaque rendu, donc en dépendre relancerait `resetRun` à chaque changement
    // d'état — et effacerait le verdict à l'instant même où il paraît.
    resetFeedback();
    committedChoiceRef.current = null;
    setHintsRemaining(capabilities.hints ? hintCharges : 0);
  }, [resetSession, hintCharges, capabilities.hints, resetFeedback]);

  useEffect(() => {
    resetRun();
  }, [exerciseId, resetRun]);

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

  const continueAfterFeedback = useCallback(() => {
    const choice = committedChoiceRef.current;
    if (!choice) return;
    committedChoiceRef.current = null;
    clearFeedback();
    // `advanceWithChoice` refuse une question déjà marquée répondue : on lève le
    // verrou posé à la correction, la réponse étant désormais figée.
    answeredQuestionRef.current = null;
    advanceWithChoice(choice);
  }, [advanceWithChoice, clearFeedback]);

  const validate = useCallback(() => {
    if (!selected || !canValidate || !sessionId) return;
    if (feedback || feedbackChecking) return;
    // Point de passage UNIQUE d'une réponse d'élève (les deux branches ci-dessous
    // en découlent, correction immédiate comprise) : c'est donc ici, et une seule
    // fois par question, que le chronomètre est lu.
    if (current?.id) commitBossTiming(current.id);
    if (!feedbackEnabled || !current?.id) {
      advanceWithChoice(selected);
      return;
    }
    // La réponse est VERROUILLÉE avant que la demande de verdict ne parte : à
    // partir d'ici elle ne peut plus changer, et c'est ce qui rend la correction
    // en cours de partie compatible avec le score calculé à la fin.
    if (answeredQuestionRef.current === current.id) return;
    answeredQuestionRef.current = current.id;
    committedChoiceRef.current = selected;
    const committed = selected;
    void checkAnswerNow(current.id, committed).then((held) => {
      if (held) return;
      // Pas de verdict à montrer (exercice non corrigible, panne) : on enchaîne
      // exactement comme avant ce lot, avec la réponse que l'élève a donnée.
      answeredQuestionRef.current = null;
      committedChoiceRef.current = null;
      advanceWithChoice(committed);
    });
  }, [
    advanceWithChoice,
    selected,
    canValidate,
    sessionId,
    feedback,
    feedbackEnabled,
    checkAnswerNow,
    feedbackChecking,
    current?.id,
    commitBossTiming,
  ]);

  useEffect(() => {
    if (result) return;
    function handleKeyDown(e: KeyboardEvent) {
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return;
      // Verdict à l'écran : la seule touche qui agit est celle qui enchaîne. Les
      // raccourcis de sélection sont muets — la réponse est déjà figée.
      if (feedback) {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          continueAfterFeedback();
        }
        return;
      }
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
        boss={bossSummary}
        rewards={capabilities.rewards}
        recallUnlockable={recallUnlockable}
        qlang={qlang}
        chapterId={chapterId}
        subjectId={exSubjectId}
        correctionVideo={data?.correctionVideo ?? null}
        exerciseId={exerciseId}
        nextExerciseId={nextExerciseId}
        showConfetti={showConfetti}
        showLevelUp={showLevelUp}
        onLevelUpComplete={() => setShowLevelUp(false)}
        onReplay={resetRun}
        renderResultFooter={strategy.renderResultFooter}
        renderTutor={strategy.renderTutor}
        resolvePrompt={(questionId) => promptByQuestionId.get(questionId) ?? ""}
        getDisplayChoice={getDisplayChoice}
      />
    );
  }

  // Pas de session = pas de partie jouable (`QuestSessionError` dit pourquoi).
  if (!sessionId) {
    if (!session.isError) return preparingScreen;
    const failure = session.error;
    return (
      <QuestSessionError
        title={t.errors.errorTitle}
        message={
          failure instanceof Error && failure.message
            ? failure.message
            : t.errors.sessionStartFailed
        }
        retryLabel={t.common.retry}
        onRetry={session.retry}
      />
    );
  }

  function handleSelect(optId: string) {
    // Une fois la question corrigée (ou en cours de correction), la réponse est
    // figée : plus aucune sélection n'est acceptée.
    if (feedback || feedbackChecking) return;
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
        <BossBanner
          title={data.exercise.title}
          hp={bossHp}
          questionIndex={idx}
          chronoActive={Boolean(sessionId) && !result && !feedback && !feedbackChecking}
          entrance={scaleIn}
          reduced={Boolean(reduced)}
          labels={{ fight: t.quest.bossFight, hp: t.quest.bossHp }}
        />
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

      {feedbackEnabled && (
        <ComboStrip streak={comboStreak} encouragement={encouragement} entrance={scaleIn} />
      )}

      <AnimatePresence mode="wait">
        <motion.div
          key={current.id}
          // Stable e2e hook — it must live HERE, on the animated card, not on
          // the progress counter outside AnimatePresence: `setIdx` flips that
          // counter in ~16ms while this card is only swapped once its 0.3s exit
          // finishes (~430ms). A spec that treats the counter as "the question
          // advanced" acts on the OUTGOING card — reading its stale checkbox,
          // clicking its stale submit — and then stalls on the real one.
          data-question-id={current.id}
          {...questionSlide(reduced)}
          className={`rounded-3xl border p-6 backdrop-blur-xl sm:p-8 ${bossMode ? "border-destructive/30 bg-destructive/5" : "border-border/50 bg-surface-3"}`}
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
            recallKeypadRows={KEYPAD_BY_LANG[qlang]}
            disabled={Boolean(feedback) || feedbackChecking}
            optionClassName={(state: McqOptionRender) =>
              optionClassNameFor(feedback, bossMode, state)
            }
            optionTrailing={(state: McqOptionRender) => (
              <OptionVerdictMark feedback={feedback} state={state} labels={t.quest} />
            )}
          />

          {feedback && (
            <QuestionVerdictPanel
              feedback={feedback}
              labels={QL}
              showAnswerInText={!feedback.isCorrect && currentType !== "mcq"}
              answerText={
                feedback.correctChoice ? getDisplayChoice(current.id, feedback.correctChoice) : null
              }
              rtl={isRtlSubject}
            />
          )}

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
              disabled={
                feedback
                  ? mutation.isPending
                  : !canValidate || feedbackChecking || mutation.isPending || session.isPending
              }
              onClick={feedback ? continueAfterFeedback : validate}
              className={`inline-flex items-center gap-2 rounded-lg px-6 py-2.5 text-sm font-bold shadow-gold transition disabled:opacity-40 ${
                bossMode
                  ? "bg-linear-to-r from-destructive to-gold text-primary-foreground"
                  : "bg-[image:var(--gradient-gold)] text-primary-foreground"
              }`}
            >
              {(mutation.isPending || session.isPending || feedbackChecking) && (
                <Loader2 className="h-4 w-4 animate-spin" />
              )}
              {feedback
                ? idx + 1 >= total
                  ? QL.feedbackFinish
                  : QL.feedbackContinue
                : bossMode
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

import { createFileRoute, Link, notFound } from "@tanstack/react-router";
import { useServerFn } from "@tanstack/react-start";
import { useMemo, useRef } from "react";
import { ArrowRight, Dumbbell, RotateCcw, Sparkles, Zap } from "lucide-react";
import { checkAnswersPublic, getChapterLesson, scoreQuizPublic } from "@/features/quest";
import {
  hasPassedChapterQuiz,
  isQuizGateLocked,
  markChapterQuizPassed,
} from "@/features/quest/anon-quiz-gate";
import {
  ExercisePlayer,
  type ExercisePlayerStrategy,
  type PlayerResult,
  type StartOutcome,
} from "@/features/quest/components/exercise-player";
import {
  MIN_SECONDS_PER_QUESTION,
  PASS_THRESHOLD_PCT,
  QUIZ_PASS_THRESHOLD_PCT,
} from "@/shared/constants/gamification";
import { useAuth } from "@/features/auth";
import { InstallNudge } from "@/components/public/install-nudge";
import { useT } from "@/lib/i18n";
import { trackProductEvent } from "@/shared/lib/product-events";
import { rememberCurrentPage } from "@/shared/lib/return-to";
import { isUuid, publicPageHead, seedOnServer } from "@/shared/lib/public-page-seo";
import { CatalogueNotFound } from "./-catalogue-not-found";

/**
 * Public « entraînement » register — login-free. Thin: builds the anonymous
 * strategy and hands it to the shared <ExercisePlayer/> (same question-by-question
 * flow as the connected quest, without rewards/sessions). The comprehension-quiz
 * gate now applies here too: a school chapter's exercises stay locked until the
 * visitor passes its quiz (tracked in the browser session) — parity with the
 * connected gate. Scoring is stateless (no XP, nothing recorded): non-quiz
 * exercises are corrected via `checkAnswersPublic`, the quiz is scored
 * aggregate-only via `scoreQuizPublic` (the answer key stays secret).
 */
export const Route = createFileRoute("/_public/exercice/$exerciseId")({
  // Rendu serveur du <head> seulement (`public-page-seo.ts`) : la page annonce son
  // exercice, son chapitre et sa matière. Le lecteur, lui, charge ses questions
  // côté client avec la session de l'élève — elles ne sont pas préchargées ici.
  // Derrière `import.meta.env.SSR`, ce code sort du bundle client.
  loader: ({ params }) => (import.meta.env.SSR ? seedExercice(params.exerciseId) : null),
  head: ({ loaderData }) =>
    loaderData?.head ?? { meta: [{ title: "Entraînement · Na9ra Nal3ab" }] },
  component: ExercicePage,
  // Un exercice qui n'existe pas (ou n'est pas public) : HTTP 404 dans la coquille
  // publique (voir `seedExercice`), pas un lecteur en erreur servi en 200.
  notFoundComponent: () => <CatalogueNotFound />,
});

/** SSR seulement : le <head> d'une page d'entraînement (titre, description, carte de partage). */
async function seedExercice(exerciseId: string) {
  if (!isUuid(exerciseId)) throw notFound();
  // Trois issues, enveloppées pour ne pas confondre les deux `null` : `seedOnServer`
  // rend `null` quand la lecture a ÉCHOUÉ (200, le lecteur charge côté client),
  // `getExerciseMeta` rend `null` quand elle a réussi sans rien trouver (404).
  const found = await seedOnServer("exercice", async () => {
    const server = await import("@/features/quest/quest.practice.server");
    return { meta: await server.getExerciseMeta({ data: { exerciseId } }) };
  });
  if (!found) return null;
  const { meta } = found;
  if (!meta) throw notFound();
  const where = [meta.chapterTitle, meta.subjectName].filter(Boolean).join(" · ");
  const kind = meta.mode === "quiz" ? "Quiz de compréhension" : "Exercice corrigé";
  const head = publicPageHead({
    title: meta.chapterTitle ? `${meta.title} — ${meta.chapterTitle}` : meta.title,
    description: `${kind}, gratuit et sans inscription : ${meta.title}${where ? ` (${where})` : ""}.`,
    path: `/exercice/${exerciseId}`,
    contentLanguage: meta.contentLanguage,
  });
  return { head };
}

function ExercicePage() {
  const { exerciseId } = Route.useParams();
  const { user, loading } = useAuth();
  const isAuthenticated = !!user;
  const t = useT();
  const check = useServerFn(checkAnswersPublic);
  const score = useServerFn(scoreQuizPublic);
  const fetchLesson = useServerFn(getChapterLesson);
  // A passed quiz unlocks the chapter: keep the happy path unbroken by offering
  // the chapter's first exercise right on the result screen (audit §D-5). Refs:
  // set during submit(), read when the result footer renders.
  const quizJustPassedRef = useRef(false);
  const nextPracticeRef = useRef<string | null>(null);
  // Le dernier rendu était-il un quiz ? Un quiz raté à 70 % ne doit pas offrir la « mission
  // suivante » : elle est derrière la porte qu'il vient de ne pas ouvrir.
  const lastWasQuizRef = useRef(false);

  const strategy = useMemo<ExercisePlayerStrategy>(
    () => ({
      capabilities: {
        rewards: false,
        hints: false,
        boss: false,
        // La suite existe aussi sans compte : après une réussite, l'écran de résultat ne
        // proposait que « Recommencer », « Retour à la matière » et « Créer mon compte »
        // (relevé « première visite » du 2026-11-12, C-3).
        next: true,
        instantFeedback: true,
      },
      quizExerciseTo: "/exercice/$exerciseId",
      homeTo: "/",
      startSession: async ({
        exerciseId: exId0,
        quizGated,
        chapterId,
        mode,
      }): Promise<StartOutcome> => {
        // The quiz itself is always playable; only a gated non-quiz exercise locks
        // until this device has passed the chapter's comprehension quiz.
        if (
          mode !== "quiz" &&
          isQuizGateLocked({ quizGated, quizPassed: hasPassedChapterQuiz(chapterId) })
        ) {
          // La porte vue par un visiteur sans compte : la mesure qui dit combien d'arrivées
          // butent dessus (fiche D-1 du relevé « première visite »). Un identifiant de catalogue.
          if (!isAuthenticated) trackProductEvent("public_gate_shown", { exercise_id: exId0 });
          return { ok: false, kind: "quiz" };
        }
        return { ok: true, sessionId: "anon" };
      },
      // La première réponse validée : sans elle, un visiteur parti à la question 3 n'existait pas.
      onFirstAnswer: ({ exerciseId: exId, isQuiz }) =>
        trackProductEvent("public_practice_started", { exercise_id: exId, is_quiz: isQuiz }),
      submit: async ({
        exerciseId: exId,
        chapterId,
        answers,
        durationSeconds,
        isQuiz,
        totalQuestions,
      }): Promise<PlayerResult> => {
        lastWasQuizRef.current = isQuiz;
        const neutral = {
          xpEarned: 0,
          coinsEarned: 0,
          profile: null,
          unlockedBadges: [],
          potionApplied: null,
          retryShieldUsed: false,
          improved: false,
          // Le visiteur anonyme ne gagne pas d'XP : il n'y a rien à primer.
          speedBonus: 1,
        };
        if (isQuiz) {
          const { correct, total, scorePct } = await score({
            data: { exerciseId: exId, answers },
          });
          // Mirror the connected gate exactly: a pass needs the score AND not
          // rushed (>= 4s/question), else a fast random pass would unlock.
          const notRushed = durationSeconds >= totalQuestions * MIN_SECONDS_PER_QUESTION;
          const reachedScore = scorePct >= QUIZ_PASS_THRESHOLD_PCT;
          const passedNow = reachedScore && notRushed;
          if (passedNow) markChapterQuizPassed(chapterId);
          // é38 lot 0 (R-16) — le premier fait du tunnel sans compte : un entraînement
          // terminé. Aucun identifiant de personne : un id de catalogue et deux booléens.
          trackProductEvent("public_practice_completed", {
            exercise_id: exId,
            is_quiz: true,
            passed: passedNow,
          });
          quizJustPassedRef.current = passedNow;
          nextPracticeRef.current = null;
          if (passedNow) {
            try {
              const lesson = await fetchLesson({ data: { chapterId } });
              nextPracticeRef.current = lesson.practiceExerciseId ?? null;
            } catch {
              // continuation is a bonus — the result footer simply omits it
            }
          }
          return {
            correct,
            total,
            scorePct,
            durationSeconds,
            reviewHidden: true,
            review: [],
            tooFast: !notRushed,
            quizTooFast: reachedScore && !notRushed,
            ...neutral,
          };
        }
        quizJustPassedRef.current = false;
        const r = await check({ data: { exerciseId: exId, answers } });
        trackProductEvent("public_practice_completed", {
          exercise_id: exId,
          is_quiz: false,
          passed: r.scorePct >= PASS_THRESHOLD_PCT,
        });
        return {
          correct: r.correct,
          total: r.total,
          scorePct: r.scorePct,
          durationSeconds,
          reviewHidden: !r.reviewable,
          review: r.review.map((it) => ({
            questionId: it.questionId,
            prompt: "",
            selectedChoice: it.selectedChoice,
            correctChoice: it.correctChoice ?? "",
            isCorrect: it.isCorrect,
            explanation: it.explanation,
          })),
          tooFast: false,
          ...neutral,
        };
      },
      // Même retour immédiat que le registre connecté, servi par la correction
      // publique déjà en place (`check_answers`) : une seule réponse à la fois.
      // Elle rend `null` sur un exercice non corrigible — le lecteur enchaîne alors
      // sans verdict.
      checkAnswer: async ({ exerciseId: exId, questionId, choice }) => {
        const res = await check({ data: { exerciseId: exId, answers: [{ questionId, choice }] } });
        const item = res.review.find((entry) => entry.questionId === questionId);
        if (!item) return null;
        return {
          questionId,
          isCorrect: item.isCorrect,
          correctChoice: item.correctChoice,
          explanation: item.explanation,
        };
      },
      renderResultFooter: ({
        exerciseId: exId,
        subjectId,
        nextExerciseId,
        xpReward,
        onReplay,
        result,
        passed,
      }) => (
        <div className="mt-8 space-y-4">
          {/* Mission réussie → la suivante, en un toucher. Jamais après un quiz (réussi, il a sa
              propre suite ci-dessous) ni après un échec : rejouer vient alors d'abord. */}
          {!lastWasQuizRef.current && nextExerciseId && result.scorePct >= PASS_THRESHOLD_PCT && (
            <Link
              to="/exercice/$exerciseId"
              params={{ exerciseId: nextExerciseId }}
              data-testid="practice-next"
              className="flex items-center justify-center gap-2 rounded-2xl bg-primary p-4 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              {t.quest.nextQuest} <ArrowRight className="h-4 w-4 rtl:-scale-x-100" />
            </Link>
          )}
          {/* Quiz just passed → the chapter is unlocked: continue straight into
              its first exercise instead of scrolling back through the hub. */}
          {quizJustPassedRef.current && nextPracticeRef.current && (
            <Link
              to="/exercice/$exerciseId"
              params={{ exerciseId: nextPracticeRef.current }}
              className="flex items-center justify-center gap-2 rounded-2xl bg-primary p-4 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
            >
              <Dumbbell className="h-4 w-4" /> {t.public.practice.continueCta}
            </Link>
          )}
          <div className="flex flex-wrap justify-center gap-3">
            <button
              type="button"
              onClick={onReplay}
              className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
            >
              <RotateCcw className="h-4 w-4" /> {t.public.practice.restart}
            </button>
            {subjectId && (
              <Link
                to="/matiere/$subjectId"
                params={{ subjectId }}
                className="inline-flex items-center rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition hover:border-primary/60"
              >
                {t.public.practice.back}
              </Link>
            )}
          </div>

          {/* é40 lot 3 (R-11) — l'invitation à installer : après une RÉUSSITE seulement, sous les
              actions et avant l'invitation au compte, qui reste en dernier. (Le lot 4 posera
              « Garder ce chapitre » juste au-dessus.) */}
          <InstallNudge audience="student" eligible={passed} />

          {/* Suppress both CTAs while the session is still resolving — an
              authenticated visitor must never see a stale "create account" card. */}
          {!loading &&
            (isAuthenticated ? (
              <Link
                to="/quest/$exerciseId"
                params={{ exerciseId: exId }}
                className="flex items-center justify-center gap-2 rounded-2xl border border-primary/30 bg-primary/[0.04] p-4 text-sm font-semibold text-primary transition hover:bg-primary/10"
              >
                <Zap className="h-4 w-4" /> {t.public.practice.questCta}
              </Link>
            ) : (
              <div className="rounded-2xl border border-primary/30 bg-primary/[0.04] p-5 text-center">
                <Sparkles className="mx-auto h-6 w-6 text-primary" />
                {/* é38 R-8 : la VALEUR de la mission, en gain futur, quand elle est connue ;
                    sinon la phrase sans chiffre (é31 R-20). */}
                <p className="mt-2 text-sm font-semibold">
                  {xpReward === null
                    ? t.public.practice.inviteDesc
                    : t.public.practice.inviteValue.replace("{xp}", String(xpReward))}
                </p>
                <Link
                  to="/signup"
                  onClick={() => {
                    rememberCurrentPage();
                    trackProductEvent("account_invite_clicked", { surface: "practice" });
                  }}
                  className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
                >
                  {t.public.practice.inviteCta}
                </Link>
              </div>
            ))}
        </div>
      ),
    }),
    [check, score, fetchLesson, isAuthenticated, loading, t],
  );

  // Idem registre connecté : les tokens `surface-*` suffisent, plus besoin d'une
  // classe qui remappe le noir en blanc pour rendre le quiz lisible ici.
  return <ExercisePlayer exerciseId={exerciseId} strategy={strategy} />;
}

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useServerFn } from "@tanstack/react-start";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { ChevronLeft, ChevronRight, ShieldAlert } from "lucide-react";

import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { PageShell } from "@/components/ui/page-shell";
import { RichField } from "@/components/ui/svg-figure";
import { useI18n, useT } from "@/lib/i18n";
// Imports profonds route→feature (même convention que `dungeon` et
// `quest.$exerciseId`) : passer par le barrel de `quest` tirerait
// `quest.server.ts` — et toute la boucle de récompense — dans le graphe de
// modules de cette route.
import { QuestionInput, type McqOptionRender } from "@/features/quest/components/question-input";
import { buildQuestLabels } from "@/features/quest/quest-labels";
import { ExamCountdown } from "@/features/exam/components/exam-countdown";
import { ExamResults } from "@/features/exam/components/exam-results";
import {
  finishMockExam,
  getMockExamPercentile,
  getMockExamReview,
  saveMockAnswers,
  startMockExam,
  type ExamPercentile,
  type ExamResult,
  type ExamReview,
} from "@/features/exam";
import { shuffleOptions, type BaseOption, type DisplayOption } from "@/shared/lib/question-utils";
import { EXAM_AUTOSAVE_INTERVAL_MS } from "@/shared/constants/gamification";

/**
 * L'épreuve — étude 02.
 *
 * Ce que cet écran fait de DIFFÉRENT du reste de l'app, et qui est tout l'intérêt :
 * il ne corrige rien. Pas de retour à la validation, pas d'indice, pas de combo,
 * pas de son. On répond, on navigue entre les matières, on rend — et c'est
 * seulement là que la copie s'ouvre. C'est l'exercice que le concours demande et
 * que la boucle de quête, par construction, n'entraîne pas.
 *
 * Le chrono est un AFFICHEUR : la deadline vit en base (R-2), l'écart d'horloge
 * poste↔serveur est mesuré à l'ouverture, et un rendu tardif est tronqué côté
 * SQL. Fermer l'onglet ne perd rien : les réponses partent au fil de l'eau (R-8)
 * et la session se reprend au même endroit.
 */

// `validateSearch` écrit à la main, sans zod : le validateur d'une route reste
// hors du chunk d'index (budget de bundle), motif de `quest.$exerciseId`.
type ExamSearch = { kind: "ranked" | "practice" };

export const Route = createFileRoute("/_authenticated/examen/$examId")({
  head: () => ({ meta: [{ title: "Examen blanc · Na9ra Nal3ab" }] }),
  validateSearch: (search: Record<string, unknown>): ExamSearch => ({
    kind: search.kind === "practice" ? "practice" : "ranked",
  }),
  component: ExamPage,
});

/**
 * La clé remonte le composant quand on passe du classé à l'entraînement : une
 * nouvelle session est une nouvelle copie, pas un rafraîchissement de l'ancienne
 * (les réponses déjà saisies et le chrono ne doivent surtout pas survivre).
 */
function ExamPage() {
  const { examId } = Route.useParams();
  const { kind } = Route.useSearch();
  return <ExamRunner key={`${examId}-${kind}`} examId={examId} kind={kind} />;
}

function ExamRunner({ examId, kind }: { examId: string; kind: "ranked" | "practice" }) {
  const t = useT();
  const { locale } = useI18n();
  const navigate = useNavigate();
  const queryClient = useQueryClient();

  const rtl = locale === "ar";
  const questLabels = useMemo(() => buildQuestLabels(locale), [locale]);

  const start = useServerFn(startMockExam);
  const save = useServerFn(saveMockAnswers);
  const finish = useServerFn(finishMockExam);
  const fetchReview = useServerFn(getMockExamReview);
  const fetchPercentile = useServerFn(getMockExamPercentile);

  // Une seule ouverture : la RPC crée OU reprend, et re-jouer la requête
  // relancerait un chrono déjà parti.
  const startQuery = useQuery({
    queryKey: ["exam-start", examId, kind],
    queryFn: () => start({ data: { examId, kind } }),
    staleTime: Infinity,
    refetchOnWindowFocus: false,
    retry: false,
  });

  const payload = startQuery.data;
  const sessionId = payload?.session.id ?? null;

  const [paperIndex, setPaperIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [saveError, setSaveError] = useState(false);
  const [result, setResult] = useState<ExamResult | null>(null);
  const [review, setReview] = useState<ExamReview | null>(null);
  const [percentile, setPercentile] = useState<ExamPercentile | null>(null);

  // L'écart entre l'horloge du poste et celle du serveur, figé à l'ouverture.
  const clockOffsetMs = useMemo(
    () => (payload ? Date.parse(payload.serverNow) - Date.now() : 0),
    [payload],
  );

  const seededRef = useRef(false);
  useEffect(() => {
    if (!payload || seededRef.current) return;
    seededRef.current = true;
    setAnswers(payload.session.answers ?? {});
  }, [payload]);

  // --- Sauvegarde au fil de l'eau (R-8) -----------------------------------
  const pendingRef = useRef<Record<string, string>>({});

  const flush = useCallback(async () => {
    if (!sessionId) return;
    const pending = pendingRef.current;
    const entries = Object.entries(pending);
    if (entries.length === 0) return;
    pendingRef.current = {};
    try {
      await save({
        data: {
          sessionId,
          answers: entries.map(([questionId, choice]) => ({ questionId, choice })),
        },
      });
      setSaveError(false);
    } catch {
      // Une réponse perdue en silence est pire qu'un bandeau : on la remet en
      // file (sans écraser ce qui a été saisi entre-temps) et on le DIT.
      pendingRef.current = { ...pending, ...pendingRef.current };
      setSaveError(true);
    }
  }, [save, sessionId]);

  const finished = result !== null;

  useEffect(() => {
    if (!sessionId || finished) return;
    const id = setInterval(() => void flush(), EXAM_AUTOSAVE_INTERVAL_MS);
    return () => clearInterval(id);
  }, [flush, sessionId, finished]);

  const answerQuestion = useCallback((questionId: string, choice: string) => {
    setAnswers((prev) => ({ ...prev, [questionId]: choice }));
    pendingRef.current[questionId] = choice;
  }, []);

  // --- Rendre la copie ----------------------------------------------------
  const submitMutation = useMutation({
    mutationFn: async () => {
      if (!sessionId) throw new Error("no session");
      await flush().catch(() => undefined);
      return finish({ data: { sessionId } });
    },
    onSuccess: async (res) => {
      setResult(res);
      // Le corrigé et le rang n'existent qu'après le rendu (R-3/R-6). Un échec
      // ici ne doit pas effacer la note, qui est acquise.
      const [rev, pct] = await Promise.all([
        fetchReview({ data: { sessionId: res.sessionId } }).catch(() => null),
        fetchPercentile({ data: { sessionId: res.sessionId } }).catch(() => null),
      ]);
      setReview(rev);
      setPercentile(pct);
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
  });

  const submit = submitMutation.mutate;
  const handleExpire = useCallback(() => {
    if (!finished) submit();
  }, [finished, submit]);

  // --- Options mélangées une fois par épreuve -----------------------------
  const paper = payload?.papers[paperIndex] ?? null;
  const optionsByQuestion = useMemo(() => {
    const map = new Map<string, DisplayOption[]>();
    for (const q of paper?.questions ?? []) {
      map.set(q.id, shuffleOptions((q.options ?? []) as BaseOption[]));
    }
    return map;
  }, [paper]);

  if (startQuery.isLoading) {
    return <LoadingState label={t.exam.loading} className="min-h-[40dvh]" />;
  }

  if (startQuery.isError || !payload || !sessionId) {
    return (
      <PageShell width="narrow" className="py-12">
        <EmptyState
          icon={ShieldAlert}
          title={startQuery.error instanceof Error ? startQuery.error.message : t.exam.notFound}
          action={
            <button
              type="button"
              onClick={() => navigate({ to: "/examens" })}
              className="rounded-lg border border-border bg-surface-2 px-4 py-2 text-sm font-medium hover:bg-surface-3"
            >
              {t.exam.back}
            </button>
          }
        />
      </PageShell>
    );
  }

  const examTitle =
    (locale === "ar" ? payload.exam.titleAr : locale === "en" ? payload.exam.titleEn : null) ||
    payload.exam.titleFr;

  if (result) {
    return (
      <PageShell width="narrow" className="py-8">
        <header className="mb-6">
          <p className="text-sm text-muted-foreground">{examTitle}</p>
          <h1 className="font-display text-3xl font-bold">{t.exam.resultTitle}</h1>
        </header>
        <ExamResults
          result={result}
          percentile={percentile}
          review={review}
          onRetryPractice={
            result.kind === "ranked"
              ? () =>
                  navigate({
                    to: "/examen/$examId",
                    params: { examId },
                    search: { kind: "practice" },
                  })
              : undefined
          }
        />
      </PageShell>
    );
  }

  const answeredCount = Object.keys(answers).length;
  const totalQuestions = payload.papers.reduce((n, p) => n + p.questions.length, 0);
  const paperLabel =
    (locale === "ar" ? paper?.labelAr : locale === "en" ? paper?.labelEn : null) ||
    paper?.labelFr ||
    "";

  return (
    <PageShell width="narrow" className="py-6 pb-28">
      <header className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="font-display text-xl font-bold">{examTitle}</h1>
          <p className="text-sm text-muted-foreground">{t.exam.noHelp}</p>
        </div>
        <ExamCountdown
          deadline={payload.session.deadline}
          clockOffsetMs={clockOffsetMs}
          onExpire={handleExpire}
        />
      </header>

      {/* Onglets d'épreuves : au concours l'élève voit des matières. */}
      <nav aria-label={t.exam.byPaper} className="mb-4 flex flex-wrap gap-2">
        {payload.papers.map((p, i) => {
          const label =
            (locale === "ar" ? p.labelAr : locale === "en" ? p.labelEn : null) || p.labelFr;
          const done = p.questions.filter((q) => answers[q.id] !== undefined).length;
          return (
            <button
              key={p.exerciseId}
              type="button"
              onClick={() => {
                void flush();
                setPaperIndex(i);
              }}
              aria-current={i === paperIndex ? "true" : undefined}
              className={`rounded-full border px-3 py-1 text-sm transition-colors ${
                i === paperIndex
                  ? "border-gold bg-gold/15 text-foreground"
                  : "border-border bg-surface-2 text-muted-foreground hover:bg-surface-3"
              }`}
            >
              {label}{" "}
              <span className="tabular-nums">
                {done}/{p.questions.length}
              </span>
            </button>
          );
        })}
      </nav>

      {paper ? (
        <section className="flex flex-col gap-5">
          <p className="text-sm text-muted-foreground">
            {paperLabel} ·{" "}
            {t.exam.coefficient.replace(
              "{n}",
              Number.isInteger(paper.points / 10)
                ? String(paper.points / 10)
                : (paper.points / 10).toFixed(1),
            )}
          </p>

          {paper.questions.map((q, i) => (
            <article key={q.id} className="rounded-xl border border-border bg-surface-2 p-4">
              <p className="mb-2 text-xs uppercase tracking-wide text-muted-foreground">
                {t.exam.questionOf
                  .replace("{i}", String(i + 1))
                  .replace("{n}", String(paper.questions.length))}
              </p>
              <RichField raw={q.prompt} className="mb-3 font-medium" />
              <QuestionInput
                questionType={q.questionType}
                prompt={q.prompt}
                options={optionsByQuestion.get(q.id) ?? []}
                value={answers[q.id] ?? null}
                onChange={(choice) => answerQuestion(q.id, choice)}
                rtl={rtl}
                labels={questLabels}
                // Aucun verdict pendant l'épreuve : la sélection seule est
                // marquée. C'est la règle qui distingue un examen d'une quête.
                optionClassName={({ isSelected }: McqOptionRender) =>
                  `flex w-full items-center gap-3 rounded-lg border p-3 text-start transition-colors ${
                    isSelected
                      ? "border-gold bg-gold/15"
                      : "border-border bg-surface-1 hover:bg-surface-3"
                  }`
                }
              />
            </article>
          ))}

          <div className="flex items-center justify-between gap-2">
            <button
              type="button"
              disabled={paperIndex === 0}
              onClick={() => {
                void flush();
                setPaperIndex((i) => Math.max(0, i - 1));
              }}
              className="inline-flex items-center gap-1 rounded-lg border border-border bg-surface-2 px-3 py-2 text-sm disabled:opacity-40"
            >
              <ChevronLeft className="size-4 rtl:-scale-x-100" aria-hidden="true" />
              {t.exam.previous}
            </button>
            <button
              type="button"
              disabled={paperIndex >= payload.papers.length - 1}
              onClick={() => {
                void flush();
                setPaperIndex((i) => Math.min(payload.papers.length - 1, i + 1));
              }}
              className="inline-flex items-center gap-1 rounded-lg border border-border bg-surface-2 px-3 py-2 text-sm disabled:opacity-40"
            >
              {t.exam.next}
              <ChevronRight className="size-4 rtl:-scale-x-100" aria-hidden="true" />
            </button>
          </div>
        </section>
      ) : null}

      {/* Barre de rendu, toujours atteignable. */}
      <div className="fixed inset-x-0 bottom-0 z-20 border-t border-border bg-surface-3/95 px-4 py-3 backdrop-blur">
        <div className="mx-auto flex max-w-2xl flex-wrap items-center justify-between gap-3">
          <p className="text-sm text-muted-foreground tabular-nums">
            {t.exam.answered
              .replace("{n}", String(answeredCount))
              .replace("{total}", String(totalQuestions))}
            {saveError ? <span className="ms-2 text-destructive">{t.exam.saveFailed}</span> : null}
          </p>
          <button
            type="button"
            onClick={() => submit()}
            disabled={submitMutation.isPending}
            className="rounded-lg bg-gold px-4 py-2 text-sm font-semibold text-primary-foreground disabled:opacity-60"
          >
            {submitMutation.isPending ? t.exam.saving : t.exam.submit}
          </button>
        </div>
      </div>
    </PageShell>
  );
}

import { createFileRoute, Link } from "@tanstack/react-router";
import { useServerFn } from "@tanstack/react-start";
import { useQuery } from "@tanstack/react-query";
import { ClipboardCheck } from "lucide-react";

import { BackLink } from "@/components/ui/back-link";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { PageShell } from "@/components/ui/page-shell";
import { useI18n, useT } from "@/lib/i18n";
import { groupExamsBySubject, listMockExams, type ExamListItem } from "@/features/exam";
import { pageTitle } from "@/lib/i18n/head";

/**
 * Le catalogue des examens blancs — étude 02.
 *
 * Un examen se présente par ce qu'il ENGAGE : sa durée, ses épreuves, son barème
 * total. L'élève doit savoir avant de cliquer qu'il s'assoit pour 90 minutes ;
 * découvrir un chrono après coup, c'est en faire un piège plutôt qu'un
 * entraînement.
 *
 * La session classée ne se joue qu'une fois (R-4) — l'écran le dit en amont et
 * bascule ensuite sur l'entraînement, plutôt que d'afficher un bouton qui
 * échouera.
 *
 * Depuis le 2026-11-22 le corpus déclare des épreuves PAR MATIÈRE : le catalogue
 * les range sous leur matière, le concours blanc multi-matières en tête. Tant
 * qu'il n'existe que ce dernier, l'écran reste la liste nue d'avant — un
 * intertitre au-dessus d'une seule carte n'aiderait personne.
 */
export const Route = createFileRoute("/_authenticated/examens")({
  head: () => ({ meta: [{ title: pageTitle((t) => t.exam.title) }] }),
  component: ExamListPage,
});

function ExamListPage() {
  const t = useT();
  const { locale } = useI18n();
  const fetchExams = useServerFn(listMockExams);

  const examsQuery = useQuery({
    queryKey: ["mock-exams"],
    queryFn: () => fetchExams({ data: {} }),
  });

  if (examsQuery.isLoading) {
    return <LoadingState label={t.exam.loading} className="min-h-[40dvh]" />;
  }

  const exams = examsQuery.data ?? [];
  const groups = groupExamsBySubject(exams);
  const grouped = groups.some((group) => group.subjectId !== null);

  return (
    <PageShell width="narrow" className="py-8">
      {/* Enfant de l'Arène : son retour y mène (audit de navigation du 2026-11-21, N-10). */}
      <BackLink to="/arene">{t.arena.title}</BackLink>
      <header className="mb-6">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">{t.exam.title}</h1>
        <p className="mt-2 text-muted-foreground">{t.exam.subtitle}</p>
      </header>

      {exams.length === 0 ? (
        <EmptyState icon={ClipboardCheck} title={t.exam.none} />
      ) : grouped ? (
        <div className="flex flex-col gap-8">
          {groups.map((group) => (
            <section key={group.key} aria-labelledby={`exam-group-${group.key}`}>
              <h2
                id={`exam-group-${group.key}`}
                className="mb-3 font-display text-xl font-bold"
                // Le nom d'une matière est dans SA langue (« العربية » sur un écran
                // français) : `dir="auto"` le pose dans son sens, sans retourner la page.
                dir="auto"
              >
                {group.subjectName ?? t.exam.groupMixed}
              </h2>
              <ul className="flex flex-col gap-4">
                {group.exams.map((exam) => (
                  <ExamCard key={exam.id} exam={exam} locale={locale} headingLevel="h3" />
                ))}
              </ul>
            </section>
          ))}
        </div>
      ) : (
        <ul className="flex flex-col gap-4">
          {exams.map((exam) => (
            <ExamCard key={exam.id} exam={exam} locale={locale} headingLevel="h2" />
          ))}
        </ul>
      )}
    </PageShell>
  );
}

function ExamCard({
  exam,
  locale,
  headingLevel: Heading,
}: {
  exam: ExamListItem;
  locale: string;
  /** `h3` sous un intertitre de matière, `h2` dans la liste nue : le plan de la page reste juste. */
  headingLevel: "h2" | "h3";
}) {
  const t = useT();

  const title =
    (locale === "ar" ? exam.titleAr : locale === "en" ? exam.titleEn : null) || exam.titleFr;

  const ranked = exam.mySessions.find((s) => s.kind === "ranked");
  const rankedOpen = ranked && ranked.finishedAt === null;
  const rankedDone = ranked && ranked.finishedAt !== null;

  const ctaKind = rankedDone ? "practice" : "ranked";
  const ctaLabel = rankedDone
    ? t.exam.startPractice
    : rankedOpen
      ? t.exam.resume
      : t.exam.startRanked;

  return (
    <li className="rounded-xl border border-border bg-surface-2 p-4">
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <Heading className="font-display text-lg font-bold">{title}</Heading>
        <span className="text-sm text-muted-foreground tabular-nums">
          {t.exam.duration.replace("{min}", String(exam.durationMinutes))} ·{" "}
          {t.exam.papers.replace("{n}", String(exam.paperCount))} ·{" "}
          {t.exam.maxPoints.replace("{n}", String(exam.maxPoints))}
        </span>
      </div>

      {rankedDone && ranked.scorePoints !== null && ranked.maxPoints ? (
        <p className="mt-2 text-sm text-success tabular-nums">
          {t.exam.done} · {t.exam.scoreOn20}{" "}
          {((ranked.scorePoints * 20) / ranked.maxPoints).toFixed(2)}
        </p>
      ) : null}

      <Link
        to="/examen/$examId"
        params={{ examId: exam.id }}
        search={{ kind: ctaKind as "ranked" | "practice" }}
        className="mt-3 inline-block rounded-lg bg-gold px-4 py-2 text-sm font-semibold text-primary-foreground"
      >
        {ctaLabel}
      </Link>
    </li>
  );
}

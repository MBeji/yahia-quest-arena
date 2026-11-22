import { createFileRoute } from "@tanstack/react-router";
import { useServerFn } from "@tanstack/react-start";
import { useQuery } from "@tanstack/react-query";

import { StudyReportView } from "@/components/study-report/study-report-view";
import { BackLink } from "@/components/ui/back-link";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { PageShell } from "@/components/ui/page-shell";
import { getStudyReport, setClassChapters, setStudyPreferences } from "@/features/progression";
import { useT } from "@/lib/i18n";
import { pageTitle } from "@/lib/i18n/head";
import { useStudyT } from "@/lib/i18n/study";

/**
 * « Mon bilan » — commande du 2026-11-22 : l'élève lit LE MÊME bilan que son parent, et dit
 * où en est sa classe.
 *
 * La route ne fait que composer : `get_study_report` tranche tout (niveau, état des chapitres,
 * programme), `StudyReportView` le rend, et le parent reçoit ce même composant dans son suivi.
 * La carte « Programme du jour » du tableau de bord mène ici.
 */
const STUDY_REPORT_QUERY_KEY = ["study-report"] as const;

export const Route = createFileRoute("/_authenticated/bilan")({
  head: () => ({ meta: [{ title: pageTitle((t) => t.dashboard.studyReportTitle) }] }),
  component: StudyReportPage,
});

function StudyReportPage() {
  const t = useT();
  const study = useStudyT().study;
  const fetchReport = useServerFn(getStudyReport);
  const saveChapters = useServerFn(setClassChapters);
  const savePreferences = useServerFn(setStudyPreferences);

  const reportQuery = useQuery({
    queryKey: STUDY_REPORT_QUERY_KEY,
    queryFn: () => fetchReport(),
  });

  if (reportQuery.isLoading) {
    return <LoadingState label={t.common.loading} className="min-h-[40dvh]" />;
  }

  const report = reportQuery.data;

  return (
    <PageShell width="narrow" className="py-8">
      <BackLink to="/dashboard">{t.dashboard.zoneToday}</BackLink>
      <header className="mb-6">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">{study.title.student}</h1>
      </header>
      {report ? (
        <StudyReportView
          report={report}
          audience="student"
          queryKey={STUDY_REPORT_QUERY_KEY}
          save={(subjectId, chapterIds) => saveChapters({ data: { subjectId, chapterIds } })}
          savePreferences={(prefs) => savePreferences({ data: prefs })}
          alsoInvalidate={[["dashboard"]]}
        />
      ) : (
        <EmptyState title={study.unavailable} />
      )}
    </PageShell>
  );
}

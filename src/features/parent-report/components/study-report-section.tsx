import { useServerFn } from "@tanstack/react-start";
import { useQuery } from "@tanstack/react-query";
import { CalendarCheck } from "lucide-react";

import { StudyReportView } from "@/components/study-report/study-report-view";
import { useStudyT } from "@/lib/i18n/study";
import {
  getStudentStudyReport,
  setStudentClassChapters,
  setStudentStudyPreferences,
} from "../parent-report.server";

/**
 * Commande du 2026-11-22 — le bilan et le programme du jour de l'enfant, au suivi parental.
 *
 * C'est LE composant que l'élève voit sur `/bilan`, nourri par la même RPC : le parent ne lit
 * pas une version « pour adulte » du bilan, il lit le bilan. Il peut aussi cocher les chapitres
 * vus en classe à la place de son enfant — le lien actif est jugé en base, pas ici.
 *
 * La section porte sa propre lecture, comme le bilan hebdomadaire du tuteur : la route
 * authentifiée la PLACE, le chemin public au code alliance ne l'a pas. Refus ou panne : rien à
 * l'écran, le reste du suivi demeure.
 */
export function StudyReportSection({ studentId }: { studentId: string }) {
  const t = useStudyT().study;
  const fetchReport = useServerFn(getStudentStudyReport);
  const saveChapters = useServerFn(setStudentClassChapters);
  const savePreferences = useServerFn(setStudentStudyPreferences);
  const queryKey = ["parent-study-report", studentId] as const;

  const { data: report } = useQuery({
    queryKey,
    queryFn: () => fetchReport({ data: { studentId } }),
  });

  if (!report) return null;

  return (
    <section data-testid="report-study" aria-label={t.title.parent}>
      <h3 className="text-foreground mb-3 flex items-center gap-2 font-semibold">
        <CalendarCheck className="text-gold h-5 w-5" />
        {t.title.parent}
      </h3>
      <StudyReportView
        report={report}
        audience="parent"
        queryKey={queryKey}
        save={(subjectId, chapterIds) =>
          saveChapters({ data: { studentId, subjectId, chapterIds } })
        }
        savePreferences={(prefs) => savePreferences({ data: { studentId, ...prefs } })}
      />
    </section>
  );
}

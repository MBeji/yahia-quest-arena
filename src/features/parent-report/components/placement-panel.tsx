import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  getStudentPlacementSummary,
  getStudentPlacementSummaryByCode,
} from "../parent-report.server";
import { reportSourceKey, type ReportSource } from "../report-source";
import { PlacementSection } from "./placement-section";

/**
 * Étude 39 lot 5 (é08) — les tests de niveau, posés AU-DESSUS des onglets du rapport.
 *
 * Pourquoi au-dessus, et pas dans « Bilan » (2026-11-24) : les deux écrans de suivi
 * (`/parent-report` et `/suivi`) s'ouvrent sur « Jour par jour ». Rangée dans l'autre onglet, la
 * section existait sans être vue — le propriétaire l'a constaté sur le compte de son fils. Un
 * test de niveau est une photographie de départ : elle se lit quel que soit l'onglet.
 *
 * Deux sources, une seule section (`ReportSource`) : le parent connecté et lié, ou le porteur du
 * code d'alliance. Le droit est jugé en base dans les deux cas. Aucun test, refus ou panne :
 * rien à l'écran — le reste du rapport ne dépend pas de cette lecture.
 */
export function PlacementPanel({ source }: { source: ReportSource }) {
  const byStudent = useServerFn(getStudentPlacementSummary);
  const byCode = useServerFn(getStudentPlacementSummaryByCode);

  const { data } = useQuery({
    queryKey: ["parent-placement-summary", source.kind, reportSourceKey(source)],
    queryFn: () =>
      source.kind === "student"
        ? byStudent({ data: { studentId: source.studentId } })
        : byCode({ data: { studentCode: source.studentCode } }),
  });

  if (!data || data.tests.length === 0) return null;
  return (
    <div className="mb-4">
      <PlacementSection summary={data} />
    </div>
  );
}

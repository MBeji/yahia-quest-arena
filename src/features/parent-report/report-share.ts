import type { ParentTranslations } from "@/lib/i18n/parent.types";
import { shareText, type ShareEnv, type ShareMethod } from "@/shared/lib/share-text";
import type { getStudentReport } from "./parent-report.server";

/** La forme du bilan famille telle que retournée (et validée) par le server fn. */
export type ReportData = Awaited<ReturnType<typeof getStudentReport>>;

/**
 * Le conseil actionnable de la semaine : la lacune la plus marquée d'abord,
 * sinon relancer un élève peu actif, sinon féliciter la régularité. Partagé
 * entre l'affichage du bilan et le texte de partage (WhatsApp / Web Share).
 */
export function buildWeeklyAdvice(report: ReportData, t: ParentTranslations): string {
  const { student, summary, chapterInsights } = report;
  const worstChapter = chapterInsights.weaknesses[0];
  if (worstChapter) {
    return t.parentReport.adviceWeakness
      .replace("{chapter}", worstChapter.chapterTitle)
      .replace("{subject}", worstChapter.subjectName);
  }
  if (summary.verdict === "inactive" || summary.verdict === "needs_improvement") {
    return t.parentReport.adviceInactive;
  }
  return t.parentReport.adviceKeepUp.replace(
    "{name}",
    student.displayName ?? t.parentReport.defaultStudentName,
  );
}

/**
 * Le bilan en texte brut, prêt à partager (WhatsApp est le canal familial n°1) :
 * résumé de la semaine, points forts / à renforcer, et le conseil de la semaine.
 */
export function buildFamilyReportShareText(report: ReportData, t: ParentTranslations): string {
  const { student, weekComparison, chapterInsights } = report;
  const name = student.displayName ?? t.parentReport.defaultStudentName;
  const week = weekComparison.thisWeek;

  const lines: string[] = [
    `📋 ${t.parentReport.printTitle}`,
    `⭐ ${name} — ${week.exercises} ${t.parentReport.exercisesLabel.toLowerCase()} · ${week.minutes} ${t.parentReport.weekMinutes.toLowerCase()} · ${week.avgScore}%`,
  ];

  if (chapterInsights.strengths.length > 0) {
    lines.push(
      `💪 ${t.parentReport.strengthsTitle} : ${chapterInsights.strengths
        .map((c) => `${c.chapterTitle} (${c.avgScore}%)`)
        .join(", ")}`,
    );
  }
  if (chapterInsights.weaknesses.length > 0) {
    lines.push(
      `🎯 ${t.parentReport.weaknessesTitle} : ${chapterInsights.weaknesses
        .map((c) => `${c.chapterTitle} (${c.avgScore}%)`)
        .join(", ")}`,
    );
  }
  lines.push(`💡 ${t.parentReport.adviceTitle} : ${buildWeeklyAdvice(report, t)}`);
  return lines.join("\n");
}

/**
 * Partage du bilan : la feuille de partage de l'appareil quand elle existe (mobile), sinon
 * WhatsApp web — le canal familial n°1 en Tunisie. Le geste est celui de `shareText` (é40 R-18),
 * réglé comme ces deux écrans l'ont toujours fait : une feuille fermée ou refusée n'ouvre rien
 * d'autre, et il n'y a pas de repli sur la copie.
 */
export function shareFamilyReport(text: string, env?: ShareEnv): Promise<ShareMethod> {
  return shareText(text, { channels: ["share", "whatsapp"], afterUnsharedSheet: "stop" }, env);
}

import { GraduationCap } from "lucide-react";
import { useI18n } from "@/lib/i18n";
import { useParentT } from "@/lib/i18n/parent";
import type { StudentExamSummary } from "../parent-report.schemas";

/**
 * Étude 08 lot 1 (US-5) — les examens blancs de l'enfant, au rapport parent.
 *
 * **Une note sur 20 d'abord** : c'est l'échelle que l'élève, le parent et
 * l'établissement lisent de la même façon (é02). Le percentile ne vient qu'en
 * second, et seulement quand il veut dire quelque chose — sous le seuil de
 * candidats, l'écran dit QUAND il s'affichera plutôt que de montrer un rang qui
 * ne serait qu'une anecdote.
 *
 * **Trois états, tous dits** : des examens rendus (la liste) ; aucun rendu mais
 * des examens ouverts dans son parcours (une phrase, qui est aussi une
 * invitation) ; ni l'un ni l'autre — rien, parce qu'un encadré vide sur un
 * parcours sans examen blanc ferait attendre quelque chose qui n'existe pas.
 *
 * Chaque phrase chiffrée est UN seul nœud de texte (docs/design-surfaces.md) :
 * en arabe, un nombre posé dans un nœud voisin part de l'autre côté de la ligne.
 */
/**
 * « 120 / 150 » dans une phrase arabe : les deux nombres, séparés par des
 * espaces, sont deux séquences que le bidi réordonne — le parent lirait
 * « 150 / 120 ». Un isolat LTR (U+2066 … U+2069) garde la fraction d'un bloc,
 * sans nœud DOM de plus.
 */
function ltr(text: string): string {
  return `\u2066${text}\u2069`;
}

export function ExamSection({ summary }: { summary: StudentExamSummary }) {
  const { locale } = useI18n();
  const t = useParentT();
  const { exams, openExams, minCandidates } = summary;

  if (exams.length === 0 && openExams <= 0) return null;

  const titleOf = (exam: StudentExamSummary["exams"][number]) =>
    (locale === "ar" ? exam.titleAr : locale === "en" ? exam.titleEn : exam.titleFr) ||
    exam.titleFr;

  return (
    <div className="bg-surface-2 border-border/50 rounded-xl border p-4" data-testid="report-exams">
      <h3 className="text-foreground flex items-center gap-2 font-semibold">
        <GraduationCap className="text-gold h-5 w-5" />
        {t.parentReport.examsTitle}
      </h3>

      {exams.length === 0 ? (
        <p className="text-muted-foreground mt-2 text-sm" data-testid="report-exams-empty">
          {t.parentReport.examsNone}
        </p>
      ) : (
        <ul className="mt-3 space-y-2">
          {exams.map((exam) => (
            <li
              key={exam.examId}
              data-testid="report-exam"
              className="bg-surface-3 border-border/40 rounded-lg border p-3"
            >
              <div className="flex flex-wrap items-baseline justify-between gap-2">
                <span className="text-foreground font-medium" dir="auto">
                  {titleOf(exam)}
                </span>
                {exam.finishedAt ? (
                  <span className="text-muted-foreground text-xs">
                    {new Date(exam.finishedAt).toLocaleDateString(locale, {
                      day: "numeric",
                      month: "long",
                      year: "numeric",
                    })}
                  </span>
                ) : null}
              </div>
              <p className="text-gold mt-1 text-lg font-bold tabular-nums">
                {ltr(`${exam.scoreOn20.toFixed(2)} / 20`)}
              </p>
              <p className="text-muted-foreground text-xs tabular-nums">
                {t.parentReport.examsPoints.replace(
                  "{points}",
                  ltr(`${exam.scorePoints} / ${exam.maxPoints}`),
                )}
              </p>
              <p className="text-foreground mt-1 text-sm tabular-nums">
                {exam.percentile === null
                  ? t.parentReport.examsPending.replace("{n}", String(minCandidates))
                  : t.parentReport.examsPercentile
                      .replace("{pct}", String(exam.percentile))
                      .replace("{n}", String(exam.candidates))}
              </p>
            </li>
          ))}
        </ul>
      )}

      {exams.length > 0 ? (
        <p className="text-muted-foreground mt-3 text-xs">{t.parentReport.examsHint}</p>
      ) : null}
    </div>
  );
}

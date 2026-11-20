import { Compass } from "lucide-react";
import { useI18n } from "@/lib/i18n";
import { useParentT } from "@/lib/i18n/parent";
import { formatScoreOn20 } from "@/shared/constants/placement";
import type { StudentPlacementSummary } from "../parent-report.schemas";

/**
 * Étude 39 lot 5 (é08) — les tests de niveau de l'enfant, au rapport parent.
 *
 * **Une photographie de départ, pas un bulletin** : la note sur 20 et la bande
 * viennent du serveur, figées au jour du test (é39 R-13) — rien n'est reclassé
 * ici. Ce qui tient vient avant ce qui est à revoir, dans l'ordre du programme
 * (R-7), et la portée dit sur QUOI l'enfant a été testé (R-22) : un 12/20 sur
 * quatre chapitres vus en novembre ne se lit pas comme un 12/20 sur l'année.
 *
 * **Pas de percentile, pas de correction** : le rapport est un repère, pas un
 * classement (é08 R-5) ; explications et erreurs nommées restent à l'élève.
 *
 * Aucun test : rien — un encadré vide ferait attendre quelque chose que
 * l'enfant n'a pas choisi de faire.
 *
 * Chaque phrase chiffrée est UN seul nœud de texte (docs/design-surfaces.md).
 */

/** Un isolat LTR garde « 13,5 / 20 » d'un bloc dans une phrase arabe. */
function ltr(text: string): string {
  return `⁦${text}⁩`;
}

export function PlacementSection({ summary }: { summary: StudentPlacementSummary }) {
  const { locale } = useI18n();
  const t = useParentT().parentReport;
  const { tests } = summary;

  if (tests.length === 0) return null;

  return (
    <div
      className="bg-surface-2 border-border/50 rounded-xl border p-4"
      data-testid="report-placement"
    >
      <h3 className="text-foreground flex items-center gap-2 font-semibold">
        <Compass className="text-gold h-5 w-5" />
        {t.placementTitle}
      </h3>

      <ul className="mt-3 space-y-2">
        {tests.map((test) => (
          <li
            key={test.sessionId}
            data-testid="report-placement-test"
            className="bg-surface-3 border-border/40 rounded-lg border p-3"
          >
            <div className="flex flex-wrap items-baseline justify-between gap-2">
              <span className="text-foreground font-medium" dir="auto">
                {test.gradeNameFr
                  ? `${test.subjectNameFr} · ${test.gradeNameFr}`
                  : test.subjectNameFr}
              </span>
              {test.finishedAt ? (
                <span className="text-muted-foreground text-xs">
                  {new Date(test.finishedAt).toLocaleDateString(locale, {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })}
                </span>
              ) : null}
            </div>

            <div className="mt-1 flex flex-wrap items-baseline gap-x-3 gap-y-1">
              <span className="text-gold text-lg font-bold tabular-nums">
                {ltr(`${formatScoreOn20(test.scoreOn20, locale)} / 20`)}
              </span>
              <span
                className="text-foreground text-sm font-medium"
                data-testid="report-placement-band"
              >
                {t.placementBands[test.band]}
              </span>
            </div>

            {test.chaptersHeld.length > 0 ? (
              <p className="text-foreground mt-2 text-sm" data-testid="report-placement-held">
                <span className="text-success font-medium">{t.placementHeld}</span>
                {" — "}
                <bdi>{test.chaptersHeld.join(" · ")}</bdi>
              </p>
            ) : null}
            {test.chaptersToReview.length > 0 ? (
              <p className="text-foreground mt-1 text-sm" data-testid="report-placement-review">
                <span className="text-gold font-medium">{t.placementToReview}</span>
                {" — "}
                <bdi>{test.chaptersToReview.join(" · ")}</bdi>
              </p>
            ) : null}

            <p className="text-muted-foreground mt-2 text-xs" data-testid="report-placement-scope">
              {test.scope
                ? t.placementScope
                    .replace("{chapter}", test.scope.throughTitle)
                    .replace("{n}", String(test.scope.chaptersInScope))
                    .replace("{total}", String(test.scope.chaptersTotal))
                : t.placementWholeYear}
            </p>
          </li>
        ))}
      </ul>

      <p className="text-muted-foreground mt-3 text-xs">{t.placementHint}</p>
    </div>
  );
}

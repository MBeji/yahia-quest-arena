import { Compass } from "lucide-react";
import { useI18n } from "@/lib/i18n";
import { useParentT } from "@/lib/i18n/parent";
import type { ParcoursComparison } from "../parent-report.schemas";

/**
 * Étude 08 lot 3 (US-8) — l'enfant à côté du repère de son parcours.
 *
 * **R-5** : ce repère est la moyenne des élèves actifs DE LA PLATEFORME sur ce
 * parcours — jamais une « moyenne nationale », et le libellé le dit en donnant
 * l'effectif et la fenêtre. **D-3 / RISK-1** : un repère, pas un classement —
 * aucun rang, et la phrase de source le rappelle.
 *
 * **R-6** : sous 30 élèves, la base ne rend AUCUN chiffre (`masked`). L'écran
 * n'affiche alors rien du tout, pas même « pas encore assez d'élèves » : ce
 * serait une phrase sur la plateforme, posée en permanence sur le bilan d'un
 * enfant. Même silence quand l'enfant n'a rien rendu sur la fenêtre — il n'y a
 * personne à situer.
 *
 * Chaque ligne chiffrée est UN seul nœud de texte, avec ses deux nombres : en
 * arabe, deux nœuds voisins s'inverseraient.
 */
export function ParcoursComparisonSection({
  comparison,
}: {
  comparison: NonNullable<ParcoursComparison>;
}) {
  const { locale } = useI18n();
  const t = useParentT();
  const { parcours, student, platform } = comparison;

  if (
    platform.masked ||
    !student ||
    platform.students === null ||
    platform.avgScore === null ||
    platform.weeklyMinutes === null
  ) {
    return null;
  }

  const name =
    (locale === "ar" ? parcours.nameAr : locale === "en" ? parcours.nameEn : parcours.nameFr) ||
    parcours.nameFr;
  const line = (template: string, child: number, avg: number) =>
    template.replace("{child}", String(child)).replace("{avg}", String(avg));

  return (
    <div
      className="bg-surface-2 border-border/50 rounded-xl border p-4"
      data-testid="report-parcours-comparison"
    >
      <h3 className="text-foreground flex items-center gap-2 font-semibold">
        <Compass className="text-gold h-5 w-5" />
        {t.parentReport.compareTitle}
      </h3>
      <p className="text-foreground mt-2 text-sm tabular-nums">
        {line(t.parentReport.compareScore, student.avgScore, platform.avgScore)}
      </p>
      <p className="text-foreground mt-1 text-sm tabular-nums">
        {line(t.parentReport.compareTime, student.weeklyMinutes, platform.weeklyMinutes)}
      </p>
      <p className="text-muted-foreground mt-2 text-xs">
        {t.parentReport.compareSource
          .replace("{n}", String(platform.students))
          .replace("{parcours}", name)}
      </p>
    </div>
  );
}

import { StarGauge } from "@/components/game/star-gauge";
import { useProgressT } from "@/lib/i18n/progress";
import type { AttemptProgress } from "@/shared/lib/progress-stars";

/**
 * « ÉTOILE DU CHAPITRE » — le bloc de l'écran de résultat (étude 34, R-12).
 *
 * Ce qu'il fête, et ce qu'il ne fête PAS. Il n'apparaît que lorsque cette
 * soumission a fait monter l'étoile du chapitre : `starAfter > starBefore`. Un
 * exercice réussi qui ne change rien ne déclenche rien — une fête à chaque
 * exercice n'est plus une fête, c'est un bruit de fond, et l'élève apprend à la
 * sauter. C'est aussi pourquoi le delta vient du SERVEUR : lui seul sait ce que
 * le grand livre a réellement enregistré.
 *
 * Il montre la jauge APRÈS, avec son nouveau cran allumé, et nomme le palier
 * atteint. Aucune XP, aucune pièce (R-11, D-10) : la reconnaissance suffit, et
 * l'étude 09 garde seule la main sur la valeur.
 */
export function StarResultBlock({ progress }: { progress: AttemptProgress | null }) {
  const t = useProgressT();
  if (!progress || progress.starAfter <= progress.starBefore) return null;

  const gained = progress.starAfter - progress.starBefore;
  const mastered = progress.starAfter >= 4;

  return (
    <div
      data-testid="result-star-block"
      className="mt-4 rounded-xl border border-(--gold)/40 bg-(--gold)/8 p-4 text-center"
    >
      <p className="font-display text-sm font-bold uppercase tracking-[0.14em] text-(--gold)">
        {gained > 1
          ? t.progress.celebration.starTitlePlural.replace("{n}", String(gained))
          : t.progress.celebration.starTitle}
      </p>
      <div className="mt-2 flex justify-center">
        <StarGauge
          rungs={progress.rungs}
          size="md"
          label={t.progress.chapterStars.gaugeLabel
            .replace("{star}", String(progress.starAfter))
            .replace("{total}", String(progress.rungs.length))}
        />
      </div>
      <p className="mt-2 text-xs text-muted-foreground" data-testid="result-star-body">
        {mastered
          ? t.progress.celebration.starMastered
          : t.progress.celebration.starBody.replace("{star}", String(progress.starAfter))}
      </p>
    </div>
  );
}

import { StarGauge } from "@/components/game/star-gauge";
import { useProgressT } from "@/lib/i18n/progress";
import type { ChapterProgress, ChapterRung, StarTier } from "@/shared/lib/progress-stars";
import { nextRung, rungNovelties } from "@/shared/lib/progress-stars";

/**
 * L'ÉTAT D'UN CHAPITRE au hub matière (étude 34, US-1/US-4/US-5/US-6).
 *
 * Deux surfaces, un seul fichier parce qu'elles disent la même chose à deux
 * niveaux de détail : le bandeau replié (`ChapterStarsChip`) et la note dépliée
 * (`ChapterStarsNote`).
 *
 * Ce qui a changé, et pourquoi : le bandeau affichait « Chapitre terminé ✓ » ou
 * « quiz ✓ · 3/5 », deux états recalculés à chaque rendu depuis les meilleurs
 * scores. Un chapitre fini qui recevait une mission repassait donc de « terminé »
 * à « 3/4 » sans que rien ne l'explique — c'est très exactement le défaut que
 * l'étude corrige. Désormais : la jauge dit l'ACQUIS (grand livre), le compteur
 * de cran dit le reste-à-faire (vivant), et ✨ nomme ce qui a grandi entre les
 * deux. Aucun des trois ne peut contredire les autres, puisqu'ils ne répondent
 * pas à la même question.
 *
 * « Maîtrisé » est le SEUL mot de verdict (R-1/R-5, Q-2 arbitrée contre la
 * recommandation) : il vaut pour l'étoile 4, et rien d'autre ne se nomme.
 */

/** Le nom du cran — l'échelle du CONTENU, pas une échelle de plus (R-1, D-9). */
function tierName(t: ReturnType<typeof useProgressT>, tier: StarTier): string {
  const names = t.progress.chapterStars;
  return tier === 1
    ? names.tier1
    : tier === 2
      ? names.tier2
      : tier === 3
        ? names.tier3
        : names.tier4;
}

/**
 * Le bandeau replié : jauge + verdict. `progress` est `null` pour l'anonyme, qui
 * voit alors la FORME du chapitre (ses crans, tous éteints) sans aucun chiffre —
 * il découvre ce qu'un compte lui ferait gagner, sans qu'on calcule quoi que ce
 * soit sans lui (R-16).
 */
export function ChapterStarsChip({
  progress,
  rungs,
  locked,
}: {
  progress: ChapterProgress | null;
  /** Les crans à dessiner — ceux du serveur, ou la forme vide de l'anonyme. */
  rungs: ChapterRung[];
  /** La porte du quiz est fermée (é22 R-7) — un état d'ACCÈS, pas de progression. */
  locked: boolean;
}) {
  const t = useProgressT();
  const acquired = rungs.filter((r) => r.lit).length;
  const gaugeLabel = t.progress.chapterStars.gaugeLabel
    .replace("{star}", String(acquired))
    .replace("{total}", String(rungs.length));
  const novelties = progress ? rungNovelties(rungs) : 0;

  return (
    <span className="flex shrink-0 items-center gap-2">
      {progress?.isNew && (
        <span
          data-testid="chapter-new"
          className="rounded-full bg-(--gold)/12 px-2 py-0.5 text-2xs font-bold text-(--gold)"
        >
          {t.progress.newChapter}
        </span>
      )}
      <StarGauge rungs={rungs} label={gaugeLabel} />
      {locked ? (
        <span
          // Surface de carte opaque + bordure flamme plutôt qu'une encre flamme
          // sur fond flamme : la variante teintée mesurait 3,36:1 en 11px gras et
          // échouait WCAG AA (GAP-047, même remède que la pastille « Toi »).
          className="rounded-full border border-[color:var(--flame)]/40 bg-card px-2 py-0.5 text-2xs font-bold text-foreground"
          data-testid="chapter-quiz-locked"
        >
          🔒 {t.public.subject.quizToPass}
        </span>
      ) : progress?.mastered ? (
        <span
          data-testid="chapter-mastered"
          className="rounded-full bg-success/12 px-2 py-0.5 text-2xs font-bold text-success"
        >
          {novelties > 0
            ? t.progress.chapterStars.masteredWithNew.replace("{n}", String(novelties))
            : t.progress.chapterStars.mastered}
        </span>
      ) : null}
    </span>
  );
}

/**
 * La note dépliée : ce qui donne le prochain cran, ce que « comptée » veut dire,
 * et la ligne des missions familiales.
 *
 * La légende est **partout** et non dans une bulle d'aide (R-8, RISK-2) : la
 * vacuité — un chapitre maîtrisé avec deux crans — ne se comprend pas toute
 * seule, et un état qu'il faut chercher à expliquer est un état mal expliqué.
 */
export function ChapterStarsNote({ progress }: { progress: ChapterProgress | null }) {
  const t = useProgressT();
  if (!progress) return null;

  const next = nextRung(progress.rungs);
  const novelties = rungNovelties(progress.rungs);

  return (
    <div className="mt-2 space-y-1 text-xs text-muted-foreground" data-testid="chapter-stars-note">
      {next && (
        <p>
          {t.progress.chapterStars.legend
            .replace("{star}", String(next.tier))
            .replace("{tier}", tierName(t, next.tier))}{" "}
          <span className="text-muted-foreground/90">{t.progress.chapterStars.countedRule}</span>
        </p>
      )}
      {novelties > 0 && (
        <p data-testid="chapter-new-missions" className="font-semibold text-(--gold)">
          {t.progress.newMissions.replace("{n}", String(novelties))}
        </p>
      )}
      {progress.family.total > 0 && (
        <p data-testid="chapter-family">
          {t.progress.familyMissions
            .replace("{done}", String(progress.family.counted))
            .replace("{total}", String(progress.family.total))}{" "}
          <span className="text-muted-foreground/90">{t.progress.familyMissionsHint}</span>
        </p>
      )}
    </div>
  );
}

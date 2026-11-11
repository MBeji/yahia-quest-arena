import { SealMark } from "@/components/game/seal-mark";
import { useI18n } from "@/lib/i18n";
import { useProgressT } from "@/lib/i18n/progress";
import { STAR_TIERS, type SubjectProgress } from "@/shared/lib/progress-stars";

/**
 * LES SCEAUX D'UNE MATIÈRE, son prochain palier et l'effort déjà fourni
 * (étude 34, US-2/US-3/US-8 · R-9/R-10/R-16).
 *
 * Ce bloc remplace le silence. Le hub ne disait rien du niveau atteint dans la
 * matière : l'élève de milieu d'année — quiz et mission ⭐ faits sur douze
 * chapitres sur vingt — n'y lisait aucune trace de son travail, et la carte
 * `/parcours` lui opposait « 0 % ». Ici il lit trois choses, dans cet ordre :
 *
 *  1. **ce qu'il a** — les sceaux inscrits, datés, définitifs ;
 *  2. **ce qui vient** — « Prochain sceau ⭐⭐ : 12/20 chapitres prêts », la SEULE
 *     fraction de l'étude, et elle nomme ce qui l'a fait bouger (« dont 1
 *     nouveau ») plutôt que de laisser un dénominateur grandir en silence ;
 *  3. **ce qu'il a fait** — missions réussies, XP, chapitres commencés et
 *     maîtrisés. Des compteurs qui montent, jamais un pourcentage (R-10) : un
 *     pourcentage divise un travail par un catalogue qui bouge, et fait donc
 *     reculer l'élève quand c'est le produit qui grandit.
 *
 * L'anonyme (`progress === null`) voit les quatre cachets en attente et une
 * promesse en une ligne — jamais un verrou de plus, jamais un chiffre calculé
 * sans compte (R-16).
 */
export function SubjectSeals({ progress }: { progress: SubjectProgress | null }) {
  const t = useProgressT();
  // La date du sceau se rend dans la LANGUE de l'élève, comme celle des badges.
  const { locale } = useI18n();
  const sealStar = progress?.sealStar ?? 0;
  const nextSeal = progress?.nextSeal ?? null;

  const sealLabel = (star: number) => t.progress.seal.title.replace("{stars}", "⭐".repeat(star));

  return (
    <section
      data-testid="subject-seals"
      aria-label={t.progress.seal.heading}
      className="mb-6 rounded-2xl border border-border bg-card p-4"
    >
      <h2 className="font-display text-sm font-bold uppercase tracking-[0.14em] text-muted-foreground">
        {t.progress.seal.heading}
      </h2>

      <div className="mt-3 flex flex-wrap items-center gap-3">
        {STAR_TIERS.map((star) => (
          <SealMark key={star} star={star} earned={sealStar >= star} label={sealLabel(star)} />
        ))}
        <div className="min-w-0 flex-1 text-sm">
          {sealStar > 0 ? (
            <p className="font-bold text-(--gold)" data-testid="seal-current">
              {sealLabel(sealStar)}
              {/* La date n'est pas un détail : un sceau daté est un souvenir, et
                  c'est ce qui le distingue d'un compteur. Format LOCAL, sans
                  heure — le jour suffit, et l'heure daterait une transaction. */}
              {progress?.seals.at(-1)?.reachedAt && (
                <span className="ms-2 font-normal text-muted-foreground">
                  {t.progress.seal.earnedOn.replace(
                    "{date}",
                    new Date(progress.seals.at(-1)!.reachedAt!).toLocaleDateString(locale),
                  )}
                </span>
              )}
            </p>
          ) : (
            <p className="font-semibold text-muted-foreground" data-testid="seal-none">
              {t.progress.seal.none}
            </p>
          )}

          {progress ? (
            nextSeal ? (
              <p className="mt-0.5 text-muted-foreground" data-testid="seal-next">
                {(nextSeal.newChapters > 0 ? t.progress.seal.nextWithNew : t.progress.seal.next)
                  .replace("{stars}", "⭐".repeat(nextSeal.star))
                  .replace("{ready}", String(nextSeal.chaptersReady))
                  .replace("{total}", String(nextSeal.chaptersTotal))
                  .replace("{n}", String(nextSeal.newChapters))}
              </p>
            ) : (
              <p className="mt-0.5 text-muted-foreground">{t.progress.seal.rule}</p>
            )
          ) : (
            <p className="mt-0.5 font-semibold text-primary" data-testid="seal-anon-promise">
              {t.progress.anonPromise}
            </p>
          )}
        </div>
      </div>

      {progress && (
        <dl
          data-testid="subject-effort"
          className="mt-4 flex flex-wrap gap-x-5 gap-y-1 border-t border-border/60 pt-3 text-xs"
        >
          <dt className="sr-only">{t.progress.effort.heading}</dt>
          <dd className="font-semibold text-foreground">
            {t.progress.effort.missions.replace("{n}", String(progress.effort.missionsCounted))}
          </dd>
          <dd className="font-semibold text-foreground">
            {t.progress.effort.xp.replace("{n}", String(progress.effort.xp))}
          </dd>
          <dd className="text-muted-foreground">
            {t.progress.effort.chaptersStarted.replace(
              "{started}",
              String(progress.effort.chaptersStarted),
            )}
          </dd>
          <dd className="text-muted-foreground">
            {t.progress.effort.chaptersMastered.replace(
              "{mastered}",
              String(progress.effort.chaptersMastered),
            )}
          </dd>
        </dl>
      )}
    </section>
  );
}

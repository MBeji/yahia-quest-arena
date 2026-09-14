import { SealMark } from "@/components/game/seal-mark";
import { useI18n } from "@/lib/i18n";
import { useProgressT } from "@/lib/i18n/progress";
import type { StarTier } from "@/shared/lib/progress-stars";

export type CollectedSeal = {
  subjectId: string;
  subjectName: string;
  star: number;
  reachedAt: string;
};

/**
 * LA COLLECTION DE SCEAUX (étude 34, lot 4 · D-7).
 *
 * Elle est à part des familles de badges, et ce n'est pas une préférence de mise
 * en page : 94 matières × 4 sceaux ne rentreraient ni dans le patron
 * `Record<BadgeCode, …>` — la garantie `tsc` qui exige un libellé par code et par
 * langue — ni dans le budget de 12 KB du chunk `i18n-badges`. Un composant
 * générique compose « Sceau ⭐⭐ — Mathématiques », et trois méta-badges seulement
 * rejoignent le système de badges.
 *
 * Chaque sceau est DATÉ. C'est ce qui le distingue d'un compteur : un sceau se
 * relit l'an prochain comme le souvenir d'un moment, pas comme une jauge de
 * l'instant. Rien n'est affiché tant que l'élève n'en a aucun — une vitrine vide
 * ne donne envie de rien, et la vraie promesse est faite au hub matière.
 */
export function SubjectSealCollection({ seals }: { seals: CollectedSeal[] }) {
  const t = useProgressT();
  // La date se rend dans la LANGUE de l'élève, comme sa voisine la collection de
  // badges : un sceau daté « 14/09/2026 » à côté d'un badge daté « ٢٠٢٦/٠٩/١٤ »
  // n'a pas l'air de la même vitrine.
  const { locale } = useI18n();
  if (seals.length === 0) return null;

  return (
    <section className="mb-6" data-testid="seal-collection" aria-label={t.progress.seal.heading}>
      <h3 className="mb-3 font-display text-sm font-bold uppercase tracking-[0.14em] text-muted-foreground">
        {t.progress.seal.heading}
      </h3>
      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
        {seals.map((seal) => (
          <div
            key={seal.subjectId}
            data-testid="seal-card"
            data-star={seal.star}
            className="flex items-center gap-3 rounded-xl border border-(--gold)/35 bg-card p-3"
          >
            <SealMark
              star={Math.min(4, Math.max(1, seal.star)) as StarTier}
              earned
              size="sm"
              label={t.progress.seal.title.replace("{stars}", "⭐".repeat(seal.star))}
            />
            <div className="min-w-0">
              <div className="truncate font-display text-sm font-bold">{seal.subjectName}</div>
              <div className="text-2xs text-muted-foreground">
                {t.progress.seal.earnedOn.replace(
                  "{date}",
                  new Date(seal.reachedAt).toLocaleDateString(locale),
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

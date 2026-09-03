import { Lock } from "lucide-react";

import { BadgeMedal } from "@/components/game/badge-medal";
import { useI18n } from "@/lib/i18n";
import { useBadgeT } from "@/lib/i18n/badges";
import {
  BADGE_FAMILIES,
  badgeFamilyRank,
  isKnownBadgeCode,
  type BadgeFamily,
} from "@/shared/constants/badges";
import type { BadgeCollectionEntry } from "@/shared/types/gamification";

/**
 * La COLLECTION de badges (étude 31 lot 2 — US-3, R-13).
 *
 * Avant : la page ne montrait que les badges DÉJÀ obtenus. Un élève qui en avait
 * quatre voyait quatre cartes, et rien ne lui disait qu'il en existait douze, ni
 * comment décrocher les autres. Une vitrine qui ne montre que le passé ne donne
 * aucune raison de revenir — et c'est la moitié manquante du constat n° 4.
 *
 * Trois partis pris :
 *
 *   * **le verrouillé est présent, pas grisé au loin.** Il porte sa CONDITION en
 *     clair (é22 R-30) : « Tenir 30 jours consécutifs » est un objectif ; une
 *     silhouette anonyme n'est qu'une frustration.
 *   * **groupé par familles**, dans un ordre de lecture (premiers pas → saison),
 *     avec le compteur de chacune : on voit d'un coup où il reste à faire.
 *   * **jamais de vocabulaire d'échec** (R-8) : « à débloquer », pas « raté »,
 *     pas « perdu ».
 *
 * Les libellés viennent de l'i18n (FR/EN/AR, R-22), pas de la base — la base
 * porte le français seul. Un badge semé hors de la liste connue retombe sur son
 * nom et sa description de base : il s'affiche, non traduit, plutôt que de
 * disparaître.
 */
export function BadgeCollection({ collection }: { collection: BadgeCollectionEntry[] }) {
  const { locale } = useI18n();
  const t = useBadgeT();

  const label = (entry: BadgeCollectionEntry): { name: string; condition: string } =>
    isKnownBadgeCode(entry.code)
      ? t.badgeCollection.labels[entry.code]
      : { name: entry.name, condition: entry.description ?? t.dashboard.badgeDefaultReason };

  const familyName = (family: string): string =>
    (t.badgeCollection.families as Record<string, string>)[family] ?? family;

  // Un badge obtenu passe devant dans sa famille ; à égalité, l'ordre de la base.
  const families = [...new Set(collection.map((b) => b.family))].sort(
    (a, b) => badgeFamilyRank(a) - badgeFamilyRank(b),
  );
  const earned = collection.filter((b) => b.awardedAt !== null).length;

  if (collection.length === 0) {
    return (
      <p className="text-sm text-muted-foreground" data-testid="badge-collection-empty">
        {t.dashboard.badgesEmpty}
      </p>
    );
  }

  return (
    <div className="space-y-6" data-testid="badge-collection">
      <p className="text-sm text-muted-foreground" data-testid="badge-collection-progress">
        {t.badgeCollection.collectionProgress
          .replace("{n}", String(earned))
          .replace("{total}", String(collection.length))}
      </p>

      {families.map((family) => {
        const items = collection.filter((b) => b.family === family);
        const done = items.filter((b) => b.awardedAt !== null).length;
        return (
          <section key={family} data-testid="badge-family" data-family={family}>
            <h3 className="mb-3 flex items-center gap-2 font-display text-lg font-bold">
              {familyName(family)}
              <span className="text-xs font-normal uppercase tracking-widest text-muted-foreground">
                {t.badgeCollection.familyProgress
                  .replace("{n}", String(done))
                  .replace("{total}", String(items.length))}
              </span>
            </h3>
            <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
              {items
                .slice()
                .sort((a, b) => Number(b.awardedAt !== null) - Number(a.awardedAt !== null))
                .map((badge) => {
                  const { name, condition } = label(badge);
                  const unlocked = badge.awardedAt !== null;
                  return (
                    <div
                      key={badge.code}
                      data-testid="badge-card"
                      data-code={badge.code}
                      data-unlocked={unlocked}
                      className={
                        unlocked
                          ? "rounded-2xl border border-border/50 bg-surface-3 p-5 backdrop-blur-md"
                          : "rounded-2xl border border-dashed border-border/50 bg-surface-2 p-5 opacity-80"
                      }
                    >
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex min-w-0 items-center gap-3">
                          <BadgeMedal
                            iconName={badge.iconName}
                            rarity={unlocked ? badge.rarity : "common"}
                            className={unlocked ? undefined : "grayscale"}
                          />
                          <div className="min-w-0">
                            <div className="font-display text-lg font-bold">{name}</div>
                            <div
                              className="text-xs uppercase tracking-widest"
                              style={{ color: `var(--rarity-${badge.rarity})` }}
                            >
                              {(t.dashboard.rarities as Record<string, string>)[badge.rarity] ??
                                badge.rarity}
                            </div>
                          </div>
                        </div>
                        {unlocked ? (
                          <div className="rounded-full bg-neon-gold/15 px-3 py-1 text-xs font-bold text-neon-gold">
                            {t.dashboard.badgeTag}
                          </div>
                        ) : (
                          <div className="inline-flex items-center gap-1 rounded-full bg-surface-1 px-3 py-1 text-xs font-bold text-muted-foreground">
                            <Lock className="h-3 w-3" aria-hidden="true" />
                            {t.badgeCollection.locked}
                          </div>
                        )}
                      </div>
                      {/* La CONDITION, toujours — obtenue, elle explique pourquoi ;
                          verrouillée, elle dit quoi faire. */}
                      <div className="mt-3 text-sm text-muted-foreground">{condition}</div>
                      {unlocked && (
                        <div className="mt-3 text-xs uppercase tracking-widest text-muted-foreground">
                          {t.dashboard.badgeEarnedOn} ·{" "}
                          {new Date(badge.awardedAt as string).toLocaleDateString(locale)}
                        </div>
                      )}
                    </div>
                  );
                })}
            </div>
          </section>
        );
      })}
    </div>
  );
}

/** Exporté pour le test d'ordre : la collection s'ouvre sur les premiers pas. */
export const BADGE_FAMILY_ORDER: readonly BadgeFamily[] = BADGE_FAMILIES;

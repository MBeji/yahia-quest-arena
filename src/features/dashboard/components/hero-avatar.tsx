import { Sparkles } from "lucide-react";

import { avatarEmojiForSlug } from "@/shared/lib/avatar";
import { useT } from "@/lib/i18n";
import { AVATAR_TIER_MAX, clampAvatarTier, isHeroFrame } from "@/shared/constants/hero-identity";

/**
 * L'avatar de l'en-tête du tableau de bord.
 *
 * é31 lot 7 (US-11) — deux choses qui existaient sans se voir :
 *
 *   * **le PALIER D'AVATAR** (`profiles.avatar_tier`) était calculé à chaque gain
 *     d'XP par `award_xp`, et rendu NULLE PART. Un élève montait de palier sans
 *     jamais l'apprendre. Il se lit désormais comme une progression (1 à 6), pas
 *     comme un nombre perdu dans une table ;
 *   * **le CADRE** acheté en boutique entoure l'avatar. C'est le premier
 *     cosmétique qui se voit sans ouvrir l'inventaire — donc le premier qui
 *     donne envie d'en acheter un.
 */

/** Un cadre = une couleur de bordure, en tokens (jamais une image à charger). */
const FRAME_RING: Record<string, string> = {
  bronze: "ring-2 ring-[color:var(--rarity-common)]",
  gold: "ring-2 ring-[color:var(--gold)]",
  neon: "ring-2 ring-[color:var(--neon-gold)] animate-pulse-neon",
};

export function HeroAvatar({
  avatarSlug,
  frameSlug,
  avatarTier,
}: {
  avatarSlug: string | null;
  frameSlug?: string | null;
  avatarTier?: number | null;
}) {
  const t = useT();
  const emoji = avatarEmojiForSlug(avatarSlug);
  const ring = isHeroFrame(frameSlug) ? FRAME_RING[frameSlug] : "";
  const tier = clampAvatarTier(avatarTier);

  return (
    <div className="flex flex-col items-center gap-1">
      <div
        data-testid="hero-avatar"
        data-frame={isHeroFrame(frameSlug) ? frameSlug : undefined}
        className={`grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)] shadow-gold animate-pulse-neon ${ring}`}
      >
        {emoji ? (
          <span className="text-4xl leading-none" role="img" aria-label={avatarSlug ?? "avatar"}>
            {emoji}
          </span>
        ) : (
          <Sparkles className="h-9 w-9 text-primary-foreground" />
        )}
      </div>
      {/* Le palier, enfin visible — et borné : `award_xp` le plafonne à 6. */}
      <span
        data-testid="hero-avatar-tier"
        className="text-2xs uppercase tracking-widest text-muted-foreground"
      >
        {t.dashboard.avatarTierLabel
          .replace("{n}", String(tier))
          .replace("{max}", String(AVATAR_TIER_MAX))}
      </span>
    </div>
  );
}

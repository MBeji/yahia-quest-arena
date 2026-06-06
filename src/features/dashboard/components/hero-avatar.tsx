import { Sparkles } from "lucide-react";
import { avatarEmojiForSlug } from "@/shared/lib/avatar";

/**
 * Dashboard hero-header avatar. Renders the equipped cosmetic skin's emoji
 * glyph (`profiles.avatar_slug`) when one is equipped, otherwise falls back to
 * the default Sparkles glyph.
 */
export function HeroAvatar({ avatarSlug }: { avatarSlug: string | null }) {
  const emoji = avatarEmojiForSlug(avatarSlug);

  return (
    <div className="grid h-20 w-20 place-items-center rounded-2xl bg-[image:var(--gradient-gold)] shadow-gold animate-pulse-neon">
      {emoji ? (
        <span className="text-4xl leading-none" role="img" aria-label={avatarSlug ?? "avatar"}>
          {emoji}
        </span>
      ) : (
        <Sparkles className="h-9 w-9 text-black" />
      )}
    </div>
  );
}

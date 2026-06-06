/**
 * Maps an equipped cosmetic skin's `avatar_slug` (from a shop item's
 * `effect_payload.avatarSlug`, set by the `equip_inventory_skin` RPC on
 * `profiles.avatar_slug`) to a visible emoji glyph.
 *
 * Slugs are seeded in `supabase/migrations/*` shop_items inserts. We use emoji
 * (no new image assets) so an equipped skin visibly changes the avatar.
 *
 * Returns `null` when no skin is equipped (slug null/empty) or the slug is
 * unknown, so callers can gracefully fall back to the existing visual
 * (initials / hero glyph).
 */
const AVATAR_SLUG_EMOJI: Record<string, string> = {
  samurai: "⚔️",
  "samurai-neon": "⚔️",
  ninja: "🥷",
  mage: "🧙",
  dragon: "🐲",
  pharaoh: "👑",
};

export function avatarEmojiForSlug(slug: string | null | undefined): string | null {
  if (!slug) return null;
  return AVATAR_SLUG_EMOJI[slug] ?? null;
}

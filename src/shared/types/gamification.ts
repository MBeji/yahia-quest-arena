// Shared types for gamification server functions.

export type UnlockedBadge = {
  code: string;
  name: string;
  rarity: string;
  iconName: string | null;
};

export type DashboardShopItem = {
  code: string;
  name: string;
  itemType: string;
  description: string | null;
  priceCoins: number;
  isOwned: boolean;
  isEquipped: boolean;
  quantity: number;
  /** Cosmetic skin slug (from `effect_payload.avatarSlug`); null for non-skins. */
  avatarSlug: string | null;
  /** True for owned multiplier potions that can be armed ("Activer"). */
  isArmable: boolean;
  /** True when this owned consumable is currently armed for the next quest. */
  isActive: boolean;
};

export type BadgeRow = {
  awarded_at: string;
  awarded_reason: string | null;
  badge: {
    code: string;
    name: string;
    rarity: string;
    icon_name: string | null;
  } | null;
};

export type InventoryRow = {
  quantity: number;
  is_equipped: boolean;
  is_active: boolean;
  acquired_at: string;
  item: {
    id: string;
    code: string;
    name: string;
    item_type: string;
    description: string | null;
    price_coins: number;
    /** Supabase `Json`; narrow to a record before reading multiplier keys. */
    effect_payload: unknown;
  } | null;
};

export type InventoryItemWithShop = {
  id: string;
  shop_item_id: string;
  item: {
    code: string;
    name: string;
    item_type: string;
    effect_payload: Record<string, unknown> | null;
  } | null;
};

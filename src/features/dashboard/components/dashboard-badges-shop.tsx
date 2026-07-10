import { Loader2, Shield, ShoppingBag } from "lucide-react";
import { EmptyState } from "@/components/ui/empty-state";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { avatarEmojiForSlug } from "@/shared/lib/avatar";
import { useI18n } from "@/lib/i18n";

type Badge = {
  code: string;
  name: string;
  rarity: string;
  awardedAt: string;
  awardedReason: string | null;
};

type ShopItem = {
  code: string;
  name: string;
  description: string | null;
  itemType: string;
  priceCoins: number;
  isOwned: boolean;
  isEquipped: boolean;
  quantity: number;
  avatarSlug: string | null;
  isArmable: boolean;
  armSlot: "next-quest" | "passive" | null;
  isActive: boolean;
};

type DashboardBadgesShopProps = {
  badges: Badge[];
  shopItems: ShopItem[];
  availableCoins: number;
  isPurchasePending: boolean;
  isEquipPending: boolean;
  isActivatePending: boolean;
  onPurchase: (itemCode: string) => void;
  onEquip: (itemCode: string) => void;
  onActivate: (itemCode: string) => void;
};

export function DashboardBadgesShop({
  badges,
  shopItems,
  availableCoins,
  isPurchasePending,
  isEquipPending,
  isActivatePending,
  onPurchase,
  onEquip,
  onActivate,
}: DashboardBadgesShopProps) {
  const { t, locale } = useI18n();
  /** Armed-badge label per arming slot (passive streak shield vs next-quest item). */
  const armedLabel = (armSlot: "next-quest" | "passive" | null): string =>
    armSlot === "passive" ? t.dashboard.armedPassive : t.dashboard.armedQuest;
  // Localized labels for the technical enum strings, with a graceful fallback to
  // the raw value so an unmapped type/rarity still renders (just untranslated).
  const itemTypeLabel = (type: string): string =>
    (t.dashboard.itemTypes as Record<string, string>)[type] ?? type;
  const rarityLabel = (rarity: string): string =>
    (t.dashboard.rarities as Record<string, string>)[rarity] ?? rarity;

  return (
    <>
      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <Shield className="h-5 w-5 text-neon-gold" /> {t.dashboard.badgesTitle}
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {badges.length > 0 ? (
            badges.map((badge) => (
              <div
                key={`${badge.code}-${badge.awardedAt}`}
                className="rounded-2xl border border-border/50 bg-black/60 p-5 backdrop-blur-md"
              >
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <div className="font-display text-lg font-bold">{badge.name}</div>
                    <div className="text-xs uppercase tracking-widest text-neon-gold">
                      {rarityLabel(badge.rarity)}
                    </div>
                  </div>
                  <div className="rounded-full bg-neon-gold/15 px-3 py-1 text-xs font-bold text-neon-gold">
                    {t.dashboard.badgeTag}
                  </div>
                </div>
                <div className="mt-3 text-sm text-muted-foreground">
                  {badge.awardedReason ?? t.dashboard.badgeDefaultReason}
                </div>
                <div className="mt-3 text-xs uppercase tracking-widest text-muted-foreground">
                  {t.dashboard.badgeEarnedOn} ·{" "}
                  {new Date(badge.awardedAt).toLocaleDateString(locale)}
                </div>
              </div>
            ))
          ) : (
            <EmptyState icon={Shield} title={t.dashboard.badgesEmpty} />
          )}
        </div>
      </section>

      <section className="mt-8" data-testid="shop">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <ShoppingBag className="h-5 w-5 text-gold" /> {t.dashboard.shopTitle}
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {shopItems.map((item) => {
            const canEquip = item.itemType === "skin" && item.isOwned && !item.isEquipped;
            const canActivate = item.isArmable && !item.isActive;
            const canBuy = !item.isOwned || item.itemType !== "skin";
            const isBusy = isPurchasePending || isEquipPending || isActivatePending;
            const skinEmoji = avatarEmojiForSlug(item.avatarSlug);

            return (
              <div
                key={item.code}
                data-testid="shop-item"
                data-item-code={item.code}
                data-owned={item.isOwned}
                className="rounded-2xl border border-border/50 bg-black/60 p-5 backdrop-blur-md"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex min-w-0 items-center gap-3">
                    {skinEmoji && (
                      <Avatar className="h-10 w-10 border border-gold/40">
                        <AvatarFallback
                          className="bg-[image:var(--gradient-gold)] text-lg text-black"
                          aria-label={item.avatarSlug ?? "avatar"}
                        >
                          {skinEmoji}
                        </AvatarFallback>
                      </Avatar>
                    )}
                    <div className="min-w-0">
                      <div className="truncate font-display text-lg font-bold">{item.name}</div>
                      <div className="text-xs uppercase tracking-widest text-gold">
                        {itemTypeLabel(item.itemType)}
                      </div>
                    </div>
                  </div>
                  <div className="shrink-0 rounded-full bg-gold/10 px-3 py-1 text-xs font-bold text-gold">
                    {item.priceCoins} {t.quest.coinsLabel}
                  </div>
                </div>
                <p className="mt-3 text-sm text-muted-foreground">
                  {item.description ?? t.dashboard.shopDefaultDesc}
                </p>
                <div className="mt-4 flex flex-wrap gap-2">
                  {item.isOwned && (
                    <div className="rounded-full bg-success/15 px-3 py-1 text-xs font-bold text-success">
                      {item.itemType === "skin"
                        ? item.isEquipped
                          ? t.dashboard.shopEquipped
                          : t.dashboard.shopOwned
                        : t.dashboard.shopInStock.replace("{n}", String(item.quantity))}
                    </div>
                  )}
                  {item.isActive && (
                    <div className="rounded-full bg-gold/15 px-3 py-1 text-xs font-bold text-gold">
                      {armedLabel(item.armSlot)}
                    </div>
                  )}
                </div>
                <div className="mt-4 flex flex-wrap gap-2">
                  <button
                    disabled={!canBuy || isBusy || availableCoins < item.priceCoins}
                    onClick={() => onPurchase(item.code)}
                    aria-label={`${t.dashboard.shopBuy} ${item.name}`}
                    className="min-h-11 flex-1 rounded-lg border border-border bg-black/50 px-4 py-2.5 text-sm font-semibold disabled:opacity-40"
                  >
                    {isPurchasePending ? (
                      <Loader2 className="mx-auto h-4 w-4 animate-spin" />
                    ) : (
                      t.dashboard.shopBuy
                    )}
                  </button>
                  {canEquip && (
                    <button
                      disabled={isBusy}
                      onClick={() => onEquip(item.code)}
                      aria-label={`${t.dashboard.shopEquip} ${item.name}`}
                      className="min-h-11 flex-1 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2.5 text-sm font-bold text-black shadow-gold disabled:opacity-40"
                    >
                      {isEquipPending ? (
                        <Loader2 className="mx-auto h-4 w-4 animate-spin" />
                      ) : (
                        t.dashboard.shopEquip
                      )}
                    </button>
                  )}
                  {canActivate && (
                    <button
                      disabled={isBusy}
                      onClick={() => onActivate(item.code)}
                      aria-label={`${t.dashboard.shopActivate} ${item.name}`}
                      className="min-h-11 flex-1 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2.5 text-sm font-bold text-black shadow-gold disabled:opacity-40"
                    >
                      {isActivatePending ? (
                        <Loader2 className="mx-auto h-4 w-4 animate-spin" />
                      ) : (
                        t.dashboard.shopActivate
                      )}
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </section>
    </>
  );
}

import { Loader2, Shield, ShoppingBag } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { avatarEmojiForSlug } from "@/shared/lib/avatar";

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
  return (
    <>
      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <Shield className="h-5 w-5 text-[color:var(--neon-gold)]" /> Hero Badges
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
                    <div className="text-xs uppercase tracking-widest text-[color:var(--neon-gold)]">
                      {badge.rarity}
                    </div>
                  </div>
                  <div className="rounded-full bg-[color:var(--neon-gold)]/15 px-3 py-1 text-xs font-bold text-[color:var(--neon-gold)]">
                    Badge
                  </div>
                </div>
                <div className="mt-3 text-sm text-muted-foreground">
                  {badge.awardedReason ?? "Reward unlocked."}
                </div>
                <div className="mt-3 text-xs uppercase tracking-widest text-muted-foreground">
                  Earned · {new Date(badge.awardedAt).toLocaleDateString("en-US")}
                </div>
              </div>
            ))
          ) : (
            <div className="rounded-2xl border border-dashed border-border/50 bg-card/40 p-6 text-sm text-muted-foreground">
              No badges unlocked yet. Keep completing quests to fill your collection.
            </div>
          )}
        </div>
      </section>

      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <ShoppingBag className="h-5 w-5 text-[color:var(--gold)]" /> Academy Shop
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
                className="rounded-2xl border border-border/50 bg-black/60 p-5 backdrop-blur-md"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex items-center gap-3">
                    {skinEmoji && (
                      <Avatar className="h-10 w-10 border border-[color:var(--gold)]/40">
                        <AvatarFallback
                          className="bg-[image:var(--gradient-gold)] text-lg text-black"
                          aria-label={item.avatarSlug ?? "avatar"}
                        >
                          {skinEmoji}
                        </AvatarFallback>
                      </Avatar>
                    )}
                    <div>
                      <div className="font-display text-lg font-bold">{item.name}</div>
                      <div className="text-xs uppercase tracking-widest text-[color:var(--gold)]">
                        {item.itemType}
                      </div>
                    </div>
                  </div>
                  <div className="rounded-full bg-[color:var(--gold)]/10 px-3 py-1 text-xs font-bold text-[color:var(--gold)]">
                    {item.priceCoins} Coins
                  </div>
                </div>
                <p className="mt-3 text-sm text-muted-foreground">
                  {item.description ?? "Academy item."}
                </p>
                <div className="mt-4 flex flex-wrap gap-2">
                  {item.isOwned && (
                    <div className="rounded-full bg-[color:var(--success)]/15 px-3 py-1 text-xs font-bold text-[color:var(--success)]">
                      {item.itemType === "skin"
                        ? item.isEquipped
                          ? "Equipped"
                          : "Owned"
                        : `In stock x${item.quantity}`}
                    </div>
                  )}
                  {item.isActive && (
                    <div className="rounded-full bg-[color:var(--gold)]/15 px-3 py-1 text-xs font-bold text-[color:var(--gold)]">
                      Actif · prochaine quête
                    </div>
                  )}
                </div>
                <div className="mt-4 flex gap-2">
                  <button
                    disabled={!canBuy || isBusy || availableCoins < item.priceCoins}
                    onClick={() => onPurchase(item.code)}
                    aria-label={`Buy ${item.name}`}
                    className="flex-1 rounded-lg border border-border bg-black/50 px-4 py-2.5 text-sm font-semibold disabled:opacity-40"
                  >
                    {isPurchasePending ? (
                      <Loader2 className="mx-auto h-4 w-4 animate-spin" />
                    ) : (
                      "Buy"
                    )}
                  </button>
                  {canEquip && (
                    <button
                      disabled={isBusy}
                      onClick={() => onEquip(item.code)}
                      aria-label={`Equip ${item.name}`}
                      className="flex-1 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2.5 text-sm font-bold text-black shadow-gold disabled:opacity-40"
                    >
                      {isEquipPending ? (
                        <Loader2 className="mx-auto h-4 w-4 animate-spin" />
                      ) : (
                        "Equip"
                      )}
                    </button>
                  )}
                  {canActivate && (
                    <button
                      disabled={isBusy}
                      onClick={() => onActivate(item.code)}
                      aria-label={`Activer ${item.name}`}
                      className="flex-1 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2.5 text-sm font-bold text-black shadow-gold disabled:opacity-40"
                    >
                      {isActivatePending ? (
                        <Loader2 className="mx-auto h-4 w-4 animate-spin" />
                      ) : (
                        "Activer"
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

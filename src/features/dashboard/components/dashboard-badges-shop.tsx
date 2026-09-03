import { Loader2, Shield, ShoppingBag } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { avatarEmojiForSlug } from "@/shared/lib/avatar";
import { useI18n } from "@/lib/i18n";
import { BadgeCollection } from "@/features/dashboard/components/badge-collection";
import type { BadgeCollectionEntry } from "@/shared/types/gamification";

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
  /** é31 lot 2 — la collection ENTIÈRE (obtenus + verrouillés), plus la seule vitrine. */
  collection: BadgeCollectionEntry[];
  shopItems: ShopItem[];
  availableCoins: number;
  isPurchasePending: boolean;
  isEquipPending: boolean;
  isActivatePending: boolean;
  onPurchase: (itemCode: string) => void;
  onEquip: (itemCode: string) => void;
  onActivate: (itemCode: string) => void;
};

/** Les trois emplacements cosmétiques (é31 lot 7) — chacun indépendant des autres. */
const EQUIPPABLE_TYPES = new Set(["skin", "frame", "title"]);

export function DashboardBadgesShop({
  collection,
  shopItems,
  availableCoins,
  isPurchasePending,
  isEquipPending,
  isActivatePending,
  onPurchase,
  onEquip,
  onActivate,
}: DashboardBadgesShopProps) {
  const { t } = useI18n();
  /** Armed-badge label per arming slot (passive streak shield vs next-quest item). */
  const armedLabel = (armSlot: "next-quest" | "passive" | null): string =>
    armSlot === "passive" ? t.dashboard.armedPassive : t.dashboard.armedQuest;
  // Localized labels for the technical enum strings, with a graceful fallback to
  // the raw value so an unmapped type/rarity still renders (just untranslated).
  const itemTypeLabel = (type: string): string =>
    (t.dashboard.itemTypes as Record<string, string>)[type] ?? type;

  return (
    <>
      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <Shield className="h-5 w-5 text-neon-gold" /> {t.dashboard.badgesTitle}
        </h2>
        {/* é31 lot 2 — la collection COMPLÈTE remplace la vitrine des seuls badges
            obtenus : c'est la carte verrouillée, avec sa condition, qui donne une
            raison de revenir (US-3, R-13). */}
        <BadgeCollection collection={collection} />
      </section>

      <section className="mt-8" data-testid="shop">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <ShoppingBag className="h-5 w-5 text-gold" /> {t.dashboard.shopTitle}
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {shopItems.map((item) => {
            // é31 lot 7 — trois emplacements cosmétiques s'équipent, pas un seul.
            const canEquip =
              EQUIPPABLE_TYPES.has(item.itemType) && item.isOwned && !item.isEquipped;
            const canActivate = item.isArmable && !item.isActive;
            // Un cosmétique ne se rachète pas : il est unique par élève.
            const canBuy = !item.isOwned || !EQUIPPABLE_TYPES.has(item.itemType);
            const isBusy = isPurchasePending || isEquipPending || isActivatePending;
            const skinEmoji = avatarEmojiForSlug(item.avatarSlug);

            return (
              <div
                key={item.code}
                data-testid="shop-item"
                data-item-code={item.code}
                data-owned={item.isOwned}
                className="rounded-2xl border border-border/50 bg-surface-3 p-5 backdrop-blur-md"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex min-w-0 items-center gap-3">
                    {skinEmoji && (
                      <Avatar className="h-10 w-10 border border-gold/40">
                        <AvatarFallback
                          className="bg-[image:var(--gradient-gold)] text-lg text-primary-foreground"
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
                    className="min-h-11 flex-1 rounded-lg border border-border bg-surface-2 px-4 py-2.5 text-sm font-semibold disabled:opacity-40"
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
                      className="min-h-11 flex-1 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2.5 text-sm font-bold text-primary-foreground shadow-gold disabled:opacity-40"
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
                      className="min-h-11 flex-1 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2.5 text-sm font-bold text-primary-foreground shadow-gold disabled:opacity-40"
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

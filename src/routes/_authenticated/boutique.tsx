import { createFileRoute } from "@tanstack/react-router";
import { lazy, Suspense } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { getDashboard, getDashboardSecondary } from "@/features/dashboard";
import { purchaseShopItem, equipInventorySkin, activateInventoryItem } from "@/features/shop";
import { Sparkles } from "lucide-react";
import { PageShell } from "@/components/ui/page-shell";
import { BackLink } from "@/components/ui/back-link";
import { LoadingState } from "@/components/ui/loading-state";
import { useT } from "@/lib/i18n";
import { useSound } from "@/lib/sound";

// Radar + inventory and the badges/shop grids are lazy — heavy (recharts / many
// cards). They used to live at the very bottom of the dashboard; étude 15 lot 6
// (D-5 / Q-4) moves them to this dedicated route so the dashboard stays a tight QG.
const DashboardRadarInventory = lazy(() =>
  import("@/features/dashboard/components/dashboard-radar-inventory").then((mod) => ({
    default: mod.DashboardRadarInventory,
  })),
);
const DashboardBadgesShop = lazy(() =>
  import("@/features/dashboard/components/dashboard-badges-shop").then((mod) => ({
    default: mod.DashboardBadgesShop,
  })),
);

export const Route = createFileRoute("/_authenticated/boutique")({
  head: () => ({ meta: [{ title: "Boutique · Na9ra Nal3ab" }] }),
  component: BoutiquePage,
});

function BoutiquePage() {
  const t = useT();
  const { play } = useSound();
  const queryClient = useQueryClient();
  const fetchDashboard = useServerFn(getDashboard);
  const fetchSecondary = useServerFn(getDashboardSecondary);
  const purchaseItem = useServerFn(purchaseShopItem);
  const equipSkin = useServerFn(equipInventorySkin);
  const activateItem = useServerFn(activateInventoryItem);

  // Primary carries the profile (coins, avatar) + subjects/stats for the radar;
  // secondary carries badges/inventory/shop. Same two reads the dashboard did.
  const { data, isLoading } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });
  const { data: secondary } = useQuery({
    queryKey: ["dashboard", "secondary"],
    queryFn: () => fetchSecondary(),
  });

  const purchaseMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => purchaseItem({ data: payload }),
    onSuccess: (res) => {
      play("purchase");
      toast.success(t.dashboard.purchaseSuccess.replace("{name}", res.purchasedItemName));
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : t.dashboard.purchaseFailed),
  });
  const equipMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => equipSkin({ data: payload }),
    onSuccess: (res) => {
      play("unlock");
      toast.success(t.dashboard.equipSuccess.replace("{name}", res.itemName));
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : t.dashboard.equipFailed),
  });
  const activateMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => activateItem({ data: payload }),
    onSuccess: (res) => {
      const template =
        res.slot === "passive" ? t.dashboard.itemArmedPassive : t.dashboard.itemArmedQuest;
      toast.success(template.replace("{name}", res.itemName));
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : t.dashboard.activationFailed),
  });

  if (isLoading || !data?.profile) {
    return <LoadingState label={t.common.loading} className="min-h-[60dvh]" />;
  }

  const { profile, subjects, stats } = data;
  const radarData = subjects.map((s) => ({
    subject: s.attribute,
    value: Math.round(stats[s.id]?.avg ?? 0),
  }));
  const badges = secondary?.badges ?? [];
  const inventory = secondary?.inventory ?? [];
  const shopItems = secondary?.shopItems ?? [];

  return (
    <PageShell width="wide" className="py-8">
      <BackLink to="/dashboard">{t.layout.heroesHall}</BackLink>
      <header className="mb-6 mt-3 flex flex-wrap items-end justify-between gap-3">
        <div>
          <h1 className="font-display text-3xl font-bold sm:text-4xl">
            {t.dashboard.boutiqueTitle}
          </h1>
          <p className="mt-2 text-muted-foreground">{t.dashboard.boutiqueSubtitle}</p>
        </div>
        {/* Your spendable balance — visible where you spend it (the shop never
            showed it before). Same testid the dashboard hero chip used, so the
            shop e2e reads the balance here after the shop moved (lot 6). */}
        <div
          data-testid="stat-coins"
          className="inline-flex items-center gap-2 rounded-full border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/10 px-4 py-2 font-display text-lg font-bold text-[color:var(--gold)]"
        >
          <Sparkles className="h-5 w-5" />
          {(profile.yahia_coins ?? 0).toLocaleString()} {t.quest.coinsLabel}
        </div>
      </header>

      <Suspense fallback={<LoadingState label={t.common.loading} className="py-8" />}>
        <div className="space-y-8">
          <DashboardRadarInventory
            radarData={radarData}
            inventory={inventory}
            avatarSlug={profile.avatar_slug}
            displayName={profile.display_name}
            isActivatePending={activateMutation.isPending}
            onActivate={(itemCode) => activateMutation.mutate({ itemCode })}
          />
          <DashboardBadgesShop
            badges={badges}
            shopItems={shopItems}
            availableCoins={profile.yahia_coins ?? 0}
            isPurchasePending={purchaseMutation.isPending}
            isEquipPending={equipMutation.isPending}
            isActivatePending={activateMutation.isPending}
            onPurchase={(itemCode) => purchaseMutation.mutate({ itemCode })}
            onEquip={(itemCode) => equipMutation.mutate({ itemCode })}
            onActivate={(itemCode) => activateMutation.mutate({ itemCode })}
          />
        </div>
      </Suspense>
    </PageShell>
  );
}

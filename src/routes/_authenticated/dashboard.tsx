import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { Flame, Zap, Trophy, Swords, Sword, BookOpen, Scroll, Leaf, Globe, ChevronRight, Sparkles, Shield, Backpack, ShoppingBag, Crown } from "lucide-react";
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, ResponsiveContainer } from "recharts";
import { toast } from "sonner";
import { equipInventorySkin, getDashboard, purchaseShopItem } from "@/lib/gamification.functions";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Hall des héros · YahiaAcademy" }] }),
  component: Dashboard,
});

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  Sword, BookOpen, Scroll, Leaf, Globe,
} as never;

function Dashboard() {
  const queryClient = useQueryClient();
  const fetchDashboard = useServerFn(getDashboard);
  const purchaseItem = useServerFn(purchaseShopItem);
  const equipSkin = useServerFn(equipInventorySkin);
  const { data, isLoading } = useQuery({ queryKey: ["dashboard"], queryFn: () => fetchDashboard() });

  const purchaseMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => purchaseItem({ data: payload }),
    onSuccess: (res) => {
      toast.success(`${res.purchasedItemName} ajouté à l'inventaire.`);
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : "Achat impossible"),
  });

  const equipMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => equipSkin({ data: payload }),
    onSuccess: (res) => {
      toast.success(`${res.itemName} équipé.`);
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : "Équipement impossible"),
  });

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Chargement de ton héros…</div>;
  }

  const { profile, subjects, stats, badges, inventory, shopItems } = data;
  if (!profile) return <div className="p-8 text-center text-muted-foreground">Profil introuvable.</div>;

  const xpInLevel = profile.xp % 200;
  const xpPct = (xpInLevel / 200) * 100;

  const radarData = subjects.map((s) => ({
    subject: s.attribute,
    value: Math.round(stats[s.id]?.avg ?? 0),
  }));

  return (
    <div className="mx-auto max-w-7xl px-6 py-8">
      {/* HERO HEADER */}
      <motion.div
        initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
        className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-violet)]/30 bg-card/40 p-6 backdrop-blur-xl shadow-card sm:p-8"
      >
        <div className="absolute -right-10 -top-10 h-48 w-48 rounded-full bg-[color:var(--neon-violet)]/30 blur-3xl" />
        <div className="absolute -bottom-10 -left-10 h-48 w-48 rounded-full bg-[color:var(--neon-cyan)]/20 blur-3xl" />
        <div className="relative grid gap-6 sm:grid-cols-[auto,1fr,auto] sm:items-center">
          <div className="grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon animate-pulse-neon">
            <Sparkles className="h-9 w-9 text-primary-foreground" />
          </div>
          <div>
            <div className="text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">{profile.hero_class}</div>
            <h1 className="font-display text-3xl font-bold sm:text-4xl">{profile.display_name}</h1>
            <div className="mt-3 flex flex-wrap items-center gap-3">
              <div className="rounded-full bg-[color:var(--neon-violet)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-violet)]">Lvl {profile.level}</div>
              <div className="flex items-center gap-1 rounded-full bg-[color:var(--flame)]/20 px-3 py-1 text-sm font-bold text-[color:var(--flame)]">
                <Flame className="h-4 w-4 animate-flame" /> {profile.current_streak} {profile.current_streak > 1 ? "jours" : "jour"}
              </div>
              <div className="flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-gold)]">
                <Zap className="h-4 w-4" /> {profile.xp} XP
              </div>
              <div className="flex items-center gap-1 rounded-full border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/10 px-3 py-1 text-sm font-bold text-[color:var(--neon-cyan)]">
                <Sparkles className="h-4 w-4" /> {profile.yahia_coins ?? 0} YC
              </div>
            </div>
            <div className="mt-4">
              <div className="mb-1 flex justify-between text-xs text-muted-foreground">
                <span>Niveau {profile.level}</span><span>{xpInLevel} / 200 XP</span>
              </div>
              <div className="h-2.5 overflow-hidden rounded-full bg-secondary">
                <div
                  className="h-full rounded-full bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon transition-all"
                  style={{ width: `${xpPct}%` }}
                />
              </div>
            </div>
          </div>
          <div className="hidden sm:block">
            <div className="text-right text-xs uppercase tracking-widest text-muted-foreground">Plus longue flamme</div>
            <div className="text-right font-display text-2xl font-bold text-[color:var(--flame)]">{profile.longest_streak}j</div>
          </div>
        </div>
      </motion.div>

      <div className="mt-8 grid gap-6 lg:grid-cols-[1fr,360px]">
        {/* SUBJECTS GRID */}
        <section>
          <div className="mb-4 flex items-center justify-between">
            <h2 className="flex items-center gap-2 font-display text-xl font-bold">
              <Swords className="h-5 w-5 text-[color:var(--neon-violet)]" /> Les voies à conquérir
            </h2>
            <Link
              to="/leaderboard"
              className="flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20"
            >
              <Crown className="h-3.5 w-3.5" /> Classement
            </Link>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            {subjects.map((s, i) => {
              const Icon = ICONS[s.icon] ?? Sword;
              const st = stats[s.id];
              return (
                <motion.div
                  key={s.id}
                  initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05 }}
                >
                  <Link
                    to="/subject/$subjectId" params={{ subjectId: s.id }}
                    className="group relative block overflow-hidden rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-md transition hover:-translate-y-1 hover:border-[color:var(--neon-violet)]/60"
                  >
                    <div
                      className="absolute -right-8 -top-8 h-28 w-28 rounded-full blur-2xl opacity-50 transition-opacity group-hover:opacity-90"
                      style={{ background: `var(--${s.color_token === 'math' ? 'subject-math' : s.color_token === 'french' ? 'subject-french' : s.color_token === 'arabic' ? 'subject-arabic' : s.color_token === 'svt' ? 'subject-svt' : 'subject-english'})` }}
                    />
                    <div className="relative flex items-start justify-between">
                      <Icon className="h-8 w-8" style={{ color: `var(--subject-${s.color_token})` }} />
                      <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
                    </div>
                    <div className="relative mt-4">
                      <div className="font-display text-lg font-bold">{s.name_fr}</div>
                      <div className="text-xs uppercase tracking-wider text-muted-foreground">Attribut · {s.attribute}</div>
                    </div>
                    <div className="relative mt-4 flex items-center justify-between text-xs">
                      <span className="text-muted-foreground">{st ? `${st.count} quête${st.count > 1 ? "s" : ""}` : "Pas encore tentée"}</span>
                      <span className="font-bold" style={{ color: `var(--subject-${s.color_token})` }}>
                        {st ? `${Math.round(st.avg)}%` : "—"}
                      </span>
                    </div>
                  </Link>
                </motion.div>
              );
            })}
          </div>
        </section>

        {/* RADAR */}
        <section>
          <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
            <Trophy className="h-5 w-5 text-[color:var(--neon-gold)]" /> Radar du succès
          </h2>
          <div className="rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
            <div className="h-72 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <RadarChart data={radarData}>
                  <PolarGrid stroke="oklch(0.66 0.27 295 / 0.25)" />
                  <PolarAngleAxis dataKey="subject" tick={{ fill: "oklch(0.72 0.04 270)", fontSize: 11 }} />
                  <Radar
                    name="Maîtrise"
                    dataKey="value"
                    stroke="oklch(0.66 0.27 295)"
                    fill="oklch(0.66 0.27 295)"
                    fillOpacity={0.4}
                  />
                </RadarChart>
              </ResponsiveContainer>
            </div>
            <p className="px-2 pb-2 text-center text-xs text-muted-foreground">Tes scores moyens par attribut.</p>
          </div>

          <div className="mt-6 rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
            <h3 className="mb-3 flex items-center gap-2 font-display text-lg font-bold">
              <Backpack className="h-4 w-4 text-[color:var(--neon-cyan)]" /> Inventaire
            </h3>
            <div className="space-y-3">
              {inventory.length > 0 ? inventory.slice(0, 4).map((item) => (
                <div key={item.code} className="rounded-xl bg-background/40 p-3">
                  <div className="flex items-center justify-between gap-3">
                    <div>
                      <div className="font-semibold">{item.name}</div>
                      <div className="text-xs uppercase tracking-widest text-muted-foreground">{item.itemType}</div>
                    </div>
                    <div className="text-right">
                      <div className="font-display text-lg font-bold text-[color:var(--neon-cyan)]">x{item.quantity}</div>
                      {item.isEquipped && <div className="text-xs uppercase tracking-widest text-[color:var(--success)]">Équipé</div>}
                    </div>
                  </div>
                </div>
              )) : (
                <div className="rounded-xl bg-background/30 p-4 text-sm text-muted-foreground">Ton inventaire est encore vide.</div>
              )}
            </div>
          </div>
        </section>
      </div>

      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <Shield className="h-5 w-5 text-[color:var(--neon-gold)]" /> Badges du héros
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {badges.length > 0 ? badges.map((badge) => (
            <div key={`${badge.code}-${badge.awardedAt}`} className="rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-md">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <div className="font-display text-lg font-bold">{badge.name}</div>
                  <div className="text-xs uppercase tracking-widest text-[color:var(--neon-gold)]">{badge.rarity}</div>
                </div>
                <div className="rounded-full bg-[color:var(--neon-gold)]/15 px-3 py-1 text-xs font-bold text-[color:var(--neon-gold)]">
                  Badge
                </div>
              </div>
              <div className="mt-3 text-sm text-muted-foreground">{badge.awardedReason ?? "Récompense débloquée."}</div>
              <div className="mt-3 text-xs uppercase tracking-widest text-muted-foreground">
                Obtenu · {new Date(badge.awardedAt).toLocaleDateString("fr-FR")}
              </div>
            </div>
          )) : (
            <div className="rounded-2xl border border-dashed border-border/50 bg-card/40 p-6 text-sm text-muted-foreground">
              Aucun badge débloqué pour le moment. Continue tes quêtes pour remplir ta collection.
            </div>
          )}
        </div>
      </section>

      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <ShoppingBag className="h-5 w-5 text-[color:var(--neon-cyan)]" /> Boutique de l'académie
        </h2>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {shopItems.map((item) => {
            const canEquip = item.itemType === "skin" && item.isOwned && !item.isEquipped;
            const canBuy = !item.isOwned || item.itemType !== "skin";
            const isBusy = purchaseMutation.isPending || equipMutation.isPending;

            return (
              <div key={item.code} className="rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-md">
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <div className="font-display text-lg font-bold">{item.name}</div>
                    <div className="text-xs uppercase tracking-widest text-[color:var(--neon-cyan)]">{item.itemType}</div>
                  </div>
                  <div className="rounded-full bg-[color:var(--neon-cyan)]/10 px-3 py-1 text-xs font-bold text-[color:var(--neon-cyan)]">
                    {item.priceCoins} YC
                  </div>
                </div>
                <p className="mt-3 text-sm text-muted-foreground">{item.description ?? "Item de l'académie."}</p>
                <div className="mt-4 flex flex-wrap gap-2">
                  {item.isOwned && (
                    <div className="rounded-full bg-[color:var(--success)]/15 px-3 py-1 text-xs font-bold text-[color:var(--success)]">
                      {item.itemType === "skin" ? (item.isEquipped ? "Équipé" : "Possédé") : `En stock x${item.quantity}`}
                    </div>
                  )}
                </div>
                <div className="mt-4 flex gap-2">
                  <button
                    disabled={!canBuy || isBusy || (profile.yahia_coins ?? 0) < item.priceCoins}
                    onClick={() => purchaseMutation.mutate({ itemCode: item.code })}
                    className="flex-1 rounded-lg border border-border bg-background/50 px-4 py-2.5 text-sm font-semibold disabled:opacity-40"
                  >
                    Acheter
                  </button>
                  {canEquip && (
                    <button
                      disabled={isBusy}
                      onClick={() => equipMutation.mutate({ itemCode: item.code })}
                      className="flex-1 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-4 py-2.5 text-sm font-bold text-primary-foreground shadow-neon disabled:opacity-40"
                    >
                      Équiper
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </section>
    </div>
  );
}

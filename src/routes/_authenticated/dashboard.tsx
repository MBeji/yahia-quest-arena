import { createFileRoute, Link, useRouter } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import { useEffect } from "react";
import { Flame, Zap, Trophy, Swords, Sword, BookOpen, Scroll, Leaf, Globe, ChevronRight, Sparkles, Shield, Backpack, ShoppingBag, Crown, Play } from "lucide-react";
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, ResponsiveContainer } from "recharts";
import { toast } from "sonner";
import { equipInventorySkin, getDashboard, purchaseShopItem } from "@/lib/gamification.functions";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Heroes Hall · XP Scholars" }] }),
  component: Dashboard,
});

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  Sword, BookOpen, Scroll, Leaf, Globe,
} as never;

function Dashboard() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const fetchDashboard = useServerFn(getDashboard);
  const purchaseItem = useServerFn(purchaseShopItem);
  const equipSkin = useServerFn(equipInventorySkin);
  const { data, isLoading } = useQuery({ queryKey: ["dashboard"], queryFn: () => fetchDashboard() });

  // Redirect first-time users to onboarding
  useEffect(() => {
    if (data && data.recent && data.recent.length === 0) {
      // No attempts = first-time user
      router.navigate({ to: "/onboarding" });
    }
  }, [data, router]);

  const purchaseMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => purchaseItem({ data: payload }),
    onSuccess: (res) => {
      toast.success(`${res.purchasedItemName} added to inventory.`);
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : "Purchase failed"),
  });

  const equipMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => equipSkin({ data: payload }),
    onSuccess: (res) => {
      toast.success(`${res.itemName} equipped.`);
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : "Equip failed"),
  });

  if (isLoading || !data) {
    return <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">Loading your hero…</div>;
  }

  const { profile, subjects, stats, badges, inventory, shopItems, nextExerciseId } = data;
  if (!profile) return <div className="p-8 text-center text-muted-foreground">Profile not found.</div>;

  const xpInLevel = profile.xp % 200;
  const xpPct = (xpInLevel / 200) * 100;

  // Find the best "continue" target: last attempted subject or first subject with no attempts
  const lastSubjectId = data.recent?.[0]?.subject_id;
  const continueSubject = subjects.find((s) => s.id === lastSubjectId) ?? subjects.find((s) => !stats[s.id]) ?? subjects[0];

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
                <Flame className="h-4 w-4 animate-flame" /> {profile.current_streak} {profile.current_streak > 1 ? "days" : "day"}
              </div>
              <div className="flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-gold)]">
                <Zap className="h-4 w-4" /> {profile.xp} XP
              </div>
              <div className="flex items-center gap-1 rounded-full border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/10 px-3 py-1 text-sm font-bold text-[color:var(--neon-cyan)]">
                <Sparkles className="h-4 w-4" /> {profile.yahia_coins ?? 0} XP Coins
              </div>
            </div>
            <div className="mt-4">
              <div className="mb-1 flex justify-between text-xs text-muted-foreground">
                <span>Level {profile.level}</span><span>{xpInLevel} / 200 XP</span>
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
            <div className="text-right text-xs uppercase tracking-widest text-muted-foreground">Longest streak</div>
            <div className="text-right font-display text-2xl font-bold text-[color:var(--flame)]">{profile.longest_streak}d</div>
          </div>
        </div>
      </motion.div>

      {/* QUICK START SECTION */}
      <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }} className="mt-6 space-y-3">
        {/* Retry incomplete button - highest priority */}
        {nextExerciseId && (
          <Link
            to="/quest/$exerciseId" params={{ exerciseId: nextExerciseId }}
            className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/8 p-4 backdrop-blur-md transition hover:border-[color:var(--neon-gold)]/70 hover:bg-[color:var(--neon-gold)]/12 sm:p-5"
          >
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--neon-gold)]/25">
                <Zap className="h-6 w-6 text-[color:var(--neon-gold)]" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-gold)] font-bold">⚡ Retenter</div>
                <div className="font-display text-lg font-bold">Ton dernier exercice</div>
              </div>
            </div>
            <ChevronRight className="h-6 w-6 text-[color:var(--neon-gold)] transition group-hover:translate-x-1" />
          </Link>
        )}
        {/* Continue subject button - secondary */}
        {continueSubject && (
          <Link
            to="/subject/$subjectId" params={{ subjectId: continueSubject.id }}
            className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/5 p-4 backdrop-blur-md transition hover:border-[color:var(--neon-cyan)]/60 hover:bg-[color:var(--neon-cyan)]/10 sm:p-5"
          >
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--neon-cyan)]/20">
                <Play className="h-6 w-6 text-[color:var(--neon-cyan)]" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-cyan)]">Continuer</div>
                <div className="font-display text-lg font-bold">{continueSubject.name_fr}</div>
              </div>
            </div>
            <ChevronRight className="h-6 w-6 text-[color:var(--neon-cyan)] transition group-hover:translate-x-1" />
          </Link>
        )}
      </motion.div>

      {/* DAILY OBJECTIVES & WEEKLY QUESTS SECTION */}
      <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="mt-8 grid gap-6 sm:grid-cols-2">
        {/* Daily Objectives */}
        <div className="rounded-2xl border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/5 p-5 backdrop-blur-md">
          <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
            <Trophy className="h-5 w-5 text-[color:var(--neon-cyan)]" /> Daily Quests
          </div>
          <div className="space-y-3">
            <div className="rounded-xl bg-background/40 p-3">
              <div className="flex items-center justify-between">
                <div className="text-sm font-semibold">3 exercises</div>
                <div className="text-xs text-[color:var(--neon-cyan)]">50 XP</div>
              </div>
              <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                <div className="h-full w-1/3 bg-gradient-to-r from-[color:var(--neon-cyan)] to-[color:var(--neon-magenta)]" />
              </div>
              <div className="mt-1 text-xs text-muted-foreground">1/3 completed</div>
            </div>
            <div className="rounded-xl bg-background/40 p-3 opacity-50">
              <div className="flex items-center justify-between">
                <div className="text-sm font-semibold">15 min study</div>
                <div className="text-xs text-[color:var(--neon-gold)]">75 XP</div>
              </div>
              <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                <div className="h-full w-1/4 bg-gradient-to-r from-[color:var(--neon-gold)] to-[color:var(--neon-magenta)]" />
              </div>
              <div className="mt-1 text-xs text-muted-foreground">5/15 minutes</div>
            </div>
          </div>
        </div>

        {/* Weekly Quests */}
        <div className="rounded-2xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/5 p-5 backdrop-blur-md">
          <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
            <Flame className="h-5 w-5 text-[color:var(--neon-gold)]" /> Weekly Quests
          </div>
          <div className="space-y-3">
            <div className="rounded-xl bg-background/40 p-3">
              <div className="flex items-center justify-between">
                <div className="text-sm font-semibold">Maintain 5-day streak</div>
                <div className="text-xs text-[color:var(--neon-gold)]">150 XP</div>
              </div>
              <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                <div className="h-full w-3/5 bg-gradient-to-r from-[color:var(--neon-gold)] to-[color:var(--neon-magenta)]" />
              </div>
              <div className="mt-1 text-xs text-muted-foreground">3/5 days</div>
            </div>
            <div className="rounded-xl bg-background/40 p-3 opacity-50">
              <div className="flex items-center justify-between">
                <div className="text-sm font-semibold">Beat 2 boss exercises</div>
                <div className="text-xs text-[color:var(--neon-violet)]">200 XP</div>
              </div>
              <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                <div className="h-full w-0 bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)]" />
              </div>
              <div className="mt-1 text-xs text-muted-foreground">0/2 bosses defeated</div>
            </div>
          </div>
        </div>
      </motion.div>

      <div className="mt-8 grid gap-6 lg:grid-cols-[1fr,360px]">
        {/* SUBJECTS GRID */}
        <section>
          <div className="mb-4 flex items-center justify-between">
            <h2 className="flex items-center gap-2 font-display text-xl font-bold">
              <Swords className="h-5 w-5 text-[color:var(--neon-violet)]" /> Paths to conquer
            </h2>
            <Link
              to="/leaderboard"
              className="flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20"
            >
              <Crown className="h-3.5 w-3.5" /> Leaderboard
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
                      <div className="text-xs uppercase tracking-wider text-muted-foreground">Attribute · {s.attribute}</div>
                    </div>
                    <div className="relative mt-4 flex items-center justify-between text-xs">
                      <span className="text-muted-foreground">{st ? `${st.count} quest${st.count > 1 ? "s" : ""}` : "Not attempted yet"}</span>
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
            <Trophy className="h-5 w-5 text-[color:var(--neon-gold)]" /> Success Radar
          </h2>
          <div className="rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
            <div className="h-72 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <RadarChart data={radarData}>
                  <PolarGrid stroke="oklch(0.66 0.27 295 / 0.25)" />
                  <PolarAngleAxis dataKey="subject" tick={{ fill: "oklch(0.72 0.04 270)", fontSize: 11 }} />
                  <Radar
                    name="Mastery"
                    dataKey="value"
                    stroke="oklch(0.66 0.27 295)"
                    fill="oklch(0.66 0.27 295)"
                    fillOpacity={0.4}
                  />
                </RadarChart>
              </ResponsiveContainer>
            </div>
            <p className="px-2 pb-2 text-center text-xs text-muted-foreground">Your average scores by attribute.</p>
          </div>

          <div className="mt-6 rounded-2xl border border-border/50 bg-card/60 p-4 backdrop-blur-md">
            <h3 className="mb-3 flex items-center gap-2 font-display text-lg font-bold">
              <Backpack className="h-4 w-4 text-[color:var(--neon-cyan)]" /> Inventory
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
                      {item.isEquipped && <div className="text-xs uppercase tracking-widest text-[color:var(--success)]">Equipped</div>}
                    </div>
                  </div>
                </div>
              )) : (
                <div className="rounded-xl bg-background/30 p-4 text-sm text-muted-foreground">Your inventory is still empty.</div>
              )}
            </div>
          </div>
        </section>
      </div>

      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <Shield className="h-5 w-5 text-[color:var(--neon-gold)]" /> Hero Badges
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
              <div className="mt-3 text-sm text-muted-foreground">{badge.awardedReason ?? "Reward unlocked."}</div>
              <div className="mt-3 text-xs uppercase tracking-widest text-muted-foreground">
                Earned · {new Date(badge.awardedAt).toLocaleDateString("en-US")}
              </div>
            </div>
          )) : (
            <div className="rounded-2xl border border-dashed border-border/50 bg-card/40 p-6 text-sm text-muted-foreground">
              No badges unlocked yet. Keep completing quests to fill your collection.
            </div>
          )}
        </div>
      </section>

      <section className="mt-8">
        <h2 className="mb-4 flex items-center gap-2 font-display text-xl font-bold">
          <ShoppingBag className="h-5 w-5 text-[color:var(--neon-cyan)]" /> Academy Shop
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
                    {item.priceCoins} XP Coins
                  </div>
                </div>
                <p className="mt-3 text-sm text-muted-foreground">{item.description ?? "Academy item."}</p>
                <div className="mt-4 flex flex-wrap gap-2">
                  {item.isOwned && (
                    <div className="rounded-full bg-[color:var(--success)]/15 px-3 py-1 text-xs font-bold text-[color:var(--success)]">
                      {item.itemType === "skin" ? (item.isEquipped ? "Equipped" : "Owned") : `In stock x${item.quantity}`}
                    </div>
                  )}
                </div>
                <div className="mt-4 flex gap-2">
                  <button
                    disabled={!canBuy || isBusy || (profile.yahia_coins ?? 0) < item.priceCoins}
                    onClick={() => purchaseMutation.mutate({ itemCode: item.code })}
                    className="flex-1 rounded-lg border border-border bg-background/50 px-4 py-2.5 text-sm font-semibold disabled:opacity-40"
                  >
                    Buy
                  </button>
                  {canEquip && (
                    <button
                      disabled={isBusy}
                      onClick={() => equipMutation.mutate({ itemCode: item.code })}
                      className="flex-1 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-4 py-2.5 text-sm font-bold text-primary-foreground shadow-neon disabled:opacity-40"
                    >
                      Equip
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

import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useEffect, useState } from "react";
import { motion } from "motion/react";
import { Flame, Zap, Trophy, Swords, Sword, BookOpen, Scroll, Leaf, Globe, ChevronRight, Sparkles, Shield, Backpack, ShoppingBag, Crown, Play, Skull, Loader2, Copy, Check } from "lucide-react";
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, ResponsiveContainer } from "recharts";
import { toast } from "sonner";
import { getDashboard, getSprint2Dashboard } from "@/lib/gamification.dashboard";
import { purchaseShopItem, equipInventorySkin } from "@/lib/gamification.shop";
import { formatStudentAllianceCode } from "@/lib/family-link";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Heroes Hall · XP Scholars" }] }),
  component: Dashboard,
});

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  Sword, BookOpen, Scroll, Leaf, Globe,
} as never;

function formatObjectiveType(type: string): string {
  const map: Record<string, string> = {
    "3_exercises": "Complete 3 exercises",
    "15_min_study": "15 min study time",
    "perfect_score": "Get a perfect score",
  };
  return map[type] ?? type.replace(/_/g, " ");
}

function formatQuestType(type: string): string {
  const map: Record<string, string> = {
    "5_day_streak": "Maintain 5-day streak",
    "2_boss_exercises": "Beat 2 boss exercises",
    "10_exercises": "Complete 10 exercises",
    "all_subjects": "Practice all subjects",
  };
  return map[type] ?? type.replace(/_/g, " ");
}

function resolveDailyAction(type: string): "retry" | "subject" | "dungeon" {
  if (type === "perfect_score") return "retry";
  if (type === "15_min_study") return "subject";
  return "subject";
}

function resolveWeeklyAction(type: string): "retry" | "subject" | "dungeon" {
  if (type === "beat_2_bosses" || type === "2_boss_exercises") return "dungeon";
  if (type === "all_subjects") return "subject";
  return "subject";
}

function Dashboard() {
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const fetchDashboard = useServerFn(getDashboard);
  const fetchSprint2 = useServerFn(getSprint2Dashboard);
  const purchaseItem = useServerFn(purchaseShopItem);
  const equipSkin = useServerFn(equipInventorySkin);
  const { data, isLoading, isError } = useQuery({ queryKey: ["dashboard"], queryFn: () => fetchDashboard() });
  const { data: sprint2 } = useQuery({ queryKey: ["sprint2"], queryFn: () => fetchSprint2() });
  const [copiedCode, setCopiedCode] = useState(false);

  // Redirect admin/parent users to their report page
  useEffect(() => {
    if (data?.profile?.role === "admin" || data?.profile?.role === "parent") {
      navigate({ to: "/parent-report" });
    }
  }, [data?.profile?.role, navigate]);

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

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20 text-center">
        <div className="rounded-2xl border border-destructive/30 bg-destructive/5 p-8">
          <Skull className="mx-auto h-10 w-10 text-destructive" />
          <h2 className="mt-4 font-display text-xl font-bold">Failed to load dashboard</h2>
          <p className="mt-2 text-sm text-muted-foreground">Something went wrong. Please try again.</p>
          <button onClick={() => queryClient.invalidateQueries({ queryKey: ["dashboard"] })} className="mt-4 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground">
            Retry
          </button>
        </div>
      </div>
    );
  }

  if (isLoading || !data) {
    return (
      <div className="mx-auto max-w-7xl px-6 py-8 space-y-6">
        <div className="h-48 animate-pulse rounded-3xl bg-card/40" />
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="h-20 animate-pulse rounded-2xl bg-card/30" />
          <div className="h-20 animate-pulse rounded-2xl bg-card/30" />
        </div>
        <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-5">
          {[1,2,3,4,5].map(i => <div key={i} className="h-28 animate-pulse rounded-2xl bg-card/30" />)}
        </div>
      </div>
    );
  }

  const { profile, subjects, stats, badges, inventory, shopItems, nextExerciseId } = data;
  if (!profile) return <div className="p-8 text-center text-muted-foreground">Profile not found.</div>;
  const studentAllianceCode = profile.role === "student" ? formatStudentAllianceCode(profile.id) : "";

  const xpInLevel = profile.xp % 200;
  const xpPct = (xpInLevel / 200) * 100;

  // Find the best "continue" target: last attempted subject or first subject with no attempts
  const lastSubjectId = data.recent?.[0]?.subject_id;
  const continueSubject = subjects.find((s) => s.id === lastSubjectId) ?? subjects.find((s) => !stats[s.id]) ?? subjects[0];

  const radarData = subjects.map((s) => ({
    subject: s.attribute,
    value: Math.round(stats[s.id]?.avg ?? 0),
  }));

  function runQuestAction(action: "retry" | "subject" | "dungeon") {
    if (action === "dungeon") {
      navigate({ to: "/dungeon" });
      return;
    }

    if (action === "retry" && nextExerciseId) {
      navigate({ to: "/quest/$exerciseId", params: { exerciseId: nextExerciseId } });
      return;
    }

    if (continueSubject) {
      navigate({ to: "/subject/$subjectId", params: { subjectId: continueSubject.id } });
      return;
    }

    toast.info("No quest target available yet. Complete one subject quest first.");
  }

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
              <div className="h-2.5 overflow-hidden rounded-full bg-secondary" role="progressbar" aria-label="XP Progress" aria-valuenow={Math.round(xpPct)} aria-valuemin={0} aria-valuemax={100}>
                <div
                  className="h-full rounded-full bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon transition-all"
                  style={{ width: `${xpPct}%` }}
                />
              </div>
            </div>
            {studentAllianceCode && (
              <div className="mt-4 rounded-xl border border-[color:var(--neon-cyan)]/35 bg-[color:var(--neon-cyan)]/8 p-3">
                <div className="text-[11px] uppercase tracking-[0.2em] text-[color:var(--neon-cyan)]">Alliance Code</div>
                <div className="mt-1 flex items-center justify-between gap-2">
                  <div className="font-mono text-xs sm:text-sm text-foreground/90">{studentAllianceCode}</div>
                  <button
                    type="button"
                    onClick={async () => {
                      await navigator.clipboard.writeText(studentAllianceCode);
                      setCopiedCode(true);
                      setTimeout(() => setCopiedCode(false), 1200);
                    }}
                    className="inline-flex items-center gap-1 rounded-md border border-[color:var(--neon-cyan)]/40 px-2 py-1 text-xs text-[color:var(--neon-cyan)] hover:bg-[color:var(--neon-cyan)]/10"
                  >
                    {copiedCode ? <Check className="h-3.5 w-3.5" /> : <Copy className="h-3.5 w-3.5" />}
                    {copiedCode ? "Copied" : "Copy"}
                  </button>
                </div>
                <p className="mt-1 text-xs text-muted-foreground">Share this code with your parent to unlock mentor tracking.</p>
              </div>
            )}
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
        {/* Dungeon mode - infinite survival */}
        <Link
          to="/dungeon"
          className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--neon-magenta)]/30 bg-[color:var(--neon-magenta)]/5 p-4 backdrop-blur-md transition hover:border-[color:var(--neon-magenta)]/60 hover:bg-[color:var(--neon-magenta)]/10 sm:p-5"
        >
          <div className="flex items-center gap-3">
            <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--neon-magenta)]/20">
              <Skull className="h-6 w-6 text-[color:var(--neon-magenta)]" />
            </div>
            <div>
              <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-magenta)] font-bold">Infinite Dungeon</div>
              <div className="font-display text-lg font-bold">Toutes matières mélangées</div>
            </div>
          </div>
          <ChevronRight className="h-6 w-6 text-[color:var(--neon-magenta)] transition group-hover:translate-x-1" />
        </Link>
      </motion.div>

      {/* DAILY OBJECTIVES & WEEKLY QUESTS SECTION */}
      <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }} className="mt-8 grid gap-6 sm:grid-cols-2">
        {/* Daily Objectives */}
        <div className="rounded-2xl border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/5 p-5 backdrop-blur-md">
          <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
            <Trophy className="h-5 w-5 text-[color:var(--neon-cyan)]" /> Daily Quests
          </div>
          <div className="space-y-3">
            {(sprint2?.dailyObjectives ?? []).length === 0 && (
              <p className="text-xs text-muted-foreground">Complete exercises to unlock daily objectives.</p>
            )}
            {(sprint2?.dailyObjectives ?? []).map((obj) => {
              const pct = obj.target_value > 0 ? Math.min(100, Math.round((obj.current_value / obj.target_value) * 100)) : 0;
              const done = obj.status === "completed";
              const action = resolveDailyAction(obj.objective_type);
              return (
                <div key={obj.id} className={`rounded-xl bg-background/40 p-3 ${done ? "opacity-60" : ""}`}>
                  <div className="flex items-center justify-between">
                    <div className="text-sm font-semibold">{formatObjectiveType(obj.objective_type)}</div>
                    <div className="text-xs text-[color:var(--neon-cyan)]">{obj.xp_reward} XP</div>
                  </div>
                  <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                    <div className="h-full bg-gradient-to-r from-[color:var(--neon-cyan)] to-[color:var(--neon-magenta)] transition-all" style={{ width: `${pct}%` }} />
                  </div>
                  <div className="mt-1 text-xs text-muted-foreground">{obj.current_value}/{obj.target_value} {done ? "✓" : ""}</div>
                  <button
                    type="button"
                    disabled={done}
                    onClick={() => runQuestAction(action)}
                    className="mt-2 rounded-md border border-[color:var(--neon-cyan)]/40 bg-[color:var(--neon-cyan)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--neon-cyan)] transition hover:bg-[color:var(--neon-cyan)]/25 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {done ? "Completed" : "Continue"}
                  </button>
                </div>
              );
            })}
          </div>
        </div>

        {/* Weekly Quests */}
        <div className="rounded-2xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/5 p-5 backdrop-blur-md">
          <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
            <Flame className="h-5 w-5 text-[color:var(--neon-gold)]" /> Weekly Quests
          </div>
          <div className="space-y-3">
            {(sprint2?.weeklyQuests ?? []).length === 0 && (
              <p className="text-xs text-muted-foreground">Weekly quests appear as you progress.</p>
            )}
            {(sprint2?.weeklyQuests ?? []).map((q) => {
              const pct = q.target_value > 0 ? Math.min(100, Math.round((q.current_value / q.target_value) * 100)) : 0;
              const done = q.status === "completed";
              const action = resolveWeeklyAction(q.quest_type);
              return (
                <div key={q.id} className={`rounded-xl bg-background/40 p-3 ${done ? "opacity-60" : ""}`}>
                  <div className="flex items-center justify-between">
                    <div className="text-sm font-semibold">{formatQuestType(q.quest_type)}</div>
                    <div className="text-xs text-[color:var(--neon-gold)]">{q.xp_reward} XP</div>
                  </div>
                  <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                    <div className="h-full bg-gradient-to-r from-[color:var(--neon-gold)] to-[color:var(--neon-magenta)] transition-all" style={{ width: `${pct}%` }} />
                  </div>
                  <div className="mt-1 text-xs text-muted-foreground">{q.current_value}/{q.target_value} {done ? "✓" : ""}</div>
                  <button
                    type="button"
                    disabled={done}
                    onClick={() => runQuestAction(action)}
                    className="mt-2 rounded-md border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/25 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {done ? "Completed" : "Continue"}
                  </button>
                </div>
              );
            })}
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
                    aria-label={`Buy ${item.name}`}
                    className="flex-1 rounded-lg border border-border bg-background/50 px-4 py-2.5 text-sm font-semibold disabled:opacity-40"
                  >
                    {purchaseMutation.isPending ? <Loader2 className="mx-auto h-4 w-4 animate-spin" /> : "Buy"}
                  </button>
                  {canEquip && (
                    <button
                      disabled={isBusy}
                      onClick={() => equipMutation.mutate({ itemCode: item.code })}
                      aria-label={`Equip ${item.name}`}
                      className="flex-1 rounded-lg bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] px-4 py-2.5 text-sm font-bold text-primary-foreground shadow-neon disabled:opacity-40"
                    >
                      {equipMutation.isPending ? <Loader2 className="mx-auto h-4 w-4 animate-spin" /> : "Equip"}
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

import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { lazy, Suspense, useEffect, useState } from "react";
import { motion } from "motion/react";
import {
  Flame,
  Zap,
  Trophy,
  Swords,
  Sword,
  BookOpen,
  Scroll,
  Leaf,
  Globe,
  ChevronRight,
  Sparkles,
  Crown,
  Play,
  Skull,
  Copy,
  Check,
} from "lucide-react";
import { toast } from "sonner";
import {
  getDashboard,
  getSprint2Dashboard,
  formatObjectiveType,
  formatQuestType,
  resolveDailyAction,
  resolveWeeklyAction,
} from "@/features/dashboard";
import { purchaseShopItem, equipInventorySkin } from "@/features/shop";
import { recoverStreak } from "@/features/progression";
import { formatStudentAllianceCode } from "@/features/parent-report";
import { useT } from "@/lib/i18n";
import { LanguageSwitcher } from "@/components/ui/language-switcher";

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

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Heroes Hall · XP Scholars" }] }),
  component: Dashboard,
});

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  Sword,
  BookOpen,
  Scroll,
  Leaf,
  Globe,
} as never;

function DailyXpWidget({
  xpToday,
  dailyGoal,
  streak,
}: {
  xpToday: number;
  dailyGoal: number;
  streak: number;
}) {
  const t = useT();
  const pct = Math.min(100, Math.round((xpToday / dailyGoal) * 100));
  const circumference = 2 * Math.PI * 40;
  const dashOffset = circumference - (pct / 100) * circumference;
  const isComplete = pct >= 100;

  return (
    <div className="flex items-center gap-5 rounded-2xl border border-[color:var(--neon-violet)]/30 bg-card/40 p-5 backdrop-blur-md">
      <div className="relative h-24 w-24 shrink-0">
        <svg className="h-full w-full -rotate-90" viewBox="0 0 96 96">
          <circle
            cx="48"
            cy="48"
            r="40"
            fill="none"
            stroke="currentColor"
            strokeWidth="6"
            className="text-secondary"
          />
          <circle
            cx="48"
            cy="48"
            r="40"
            fill="none"
            strokeWidth="6"
            strokeLinecap="round"
            stroke={isComplete ? "var(--neon-gold)" : "var(--neon-violet)"}
            strokeDasharray={circumference}
            strokeDashoffset={dashOffset}
            className="transition-all duration-700"
          />
        </svg>
        <div className="absolute inset-0 flex flex-col items-center justify-center">
          <span className="font-display text-lg font-bold">{pct}%</span>
        </div>
      </div>
      <div>
        <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-violet)]">
          {t.dashboard.dailyGoalLabel}
        </div>
        <div className="mt-1 font-display text-2xl font-bold">
          {xpToday} <span className="text-base text-muted-foreground">/ {dailyGoal} XP</span>
        </div>
        {isComplete ? (
          <div className="mt-1 text-sm font-semibold text-[color:var(--neon-gold)]">
            {t.dashboard.dailyGoalReached}
          </div>
        ) : (
          <div className="mt-1 text-sm text-muted-foreground">
            {dailyGoal - xpToday} {t.dashboard.dailyGoalRemaining}
          </div>
        )}
        {streak > 0 && (
          <div className="mt-2 flex items-center gap-1 text-xs text-[color:var(--flame)]">
            <Flame className="h-3 w-3 animate-flame" /> {streak} {t.dashboard.consecutiveDays}
          </div>
        )}
      </div>
    </div>
  );
}

function MotivationalQuote() {
  const t = useT();
  const dayIndex = new Date().getDate() % t.quotes.length;
  const quote = t.quotes[dayIndex];

  return (
    <div className="flex flex-col justify-center rounded-2xl border border-[color:var(--neon-cyan)]/20 bg-card/40 p-5 backdrop-blur-md">
      <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-cyan)] mb-3">
        {t.dashboard.quoteLabel}
      </div>
      <blockquote className="font-display text-base font-medium italic leading-relaxed">
        «&nbsp;{quote.text}&nbsp;»
      </blockquote>
      <cite className="mt-2 text-xs not-italic text-muted-foreground">— {quote.author}</cite>
    </div>
  );
}

function Dashboard() {
  const t = useT();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const fetchDashboard = useServerFn(getDashboard);
  const fetchSprint2 = useServerFn(getSprint2Dashboard);
  const purchaseItem = useServerFn(purchaseShopItem);
  const equipSkin = useServerFn(equipInventorySkin);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });
  const { data: sprint2 } = useQuery({ queryKey: ["sprint2"], queryFn: () => fetchSprint2() });
  const [copiedCode, setCopiedCode] = useState(false);
  const [deferSecondarySections, setDeferSecondarySections] = useState(false);

  useEffect(() => {
    const timer = window.setTimeout(() => setDeferSecondarySections(true), 350);
    return () => window.clearTimeout(timer);
  }, []);

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

  const recoverStreakFn = useServerFn(recoverStreak);
  const streakRecoveryMutation = useMutation({
    mutationFn: () => recoverStreakFn(),
    onSuccess: (res) => {
      toast.success(
        `🔥 Streak recovered! You now have ${res.newStreak} ${res.newStreak > 1 ? t.dashboard.days : t.dashboard.day}.`,
      );
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : "Recovery failed"),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20 text-center">
        <div className="rounded-2xl border border-destructive/30 bg-destructive/5 p-8">
          <Skull className="mx-auto h-10 w-10 text-destructive" />
          <h2 className="mt-4 font-display text-xl font-bold">{t.dashboard.failedLoad}</h2>
          <p className="mt-2 text-sm text-muted-foreground">{t.dashboard.failedLoadDesc}</p>
          <button
            onClick={() => queryClient.invalidateQueries({ queryKey: ["dashboard"] })}
            className="mt-4 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground"
          >
            {t.common.retry}
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
          {[1, 2, 3, 4, 5].map((i) => (
            <div key={i} className="h-28 animate-pulse rounded-2xl bg-card/30" />
          ))}
        </div>
      </div>
    );
  }

  const { profile, subjects, stats, badges, inventory, shopItems, nextExerciseId } = data;
  if (!profile)
    return <div className="p-8 text-center text-muted-foreground">Profile not found.</div>;
  const studentAllianceCode =
    profile.role === "student" ? formatStudentAllianceCode(profile.id) : "";

  const xpInLevel = profile.xp % 200;
  const xpPct = (xpInLevel / 200) * 100;

  // Find the best "continue" target: last attempted subject or first subject with no attempts
  const lastSubjectId = data.recent?.[0]?.subject_id;
  const continueSubject =
    subjects.find((s) => s.id === lastSubjectId) ??
    subjects.find((s) => !stats[s.id]) ??
    subjects[0];

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
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="relative overflow-hidden rounded-3xl border border-[color:var(--neon-violet)]/30 bg-card/40 p-6 backdrop-blur-xl shadow-card sm:p-8"
      >
        <div className="absolute -right-10 -top-10 h-48 w-48 rounded-full bg-[color:var(--neon-violet)]/30 blur-3xl" />
        <div className="absolute -bottom-10 -left-10 h-48 w-48 rounded-full bg-[color:var(--neon-cyan)]/20 blur-3xl" />
        <div className="relative grid gap-6 sm:grid-cols-[auto,1fr,auto] sm:items-center">
          <div className="grid h-20 w-20 place-items-center rounded-2xl bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon animate-pulse-neon">
            <Sparkles className="h-9 w-9 text-primary-foreground" />
          </div>
          <div>
            <div className="text-xs uppercase tracking-[0.3em] text-[color:var(--neon-cyan)]">
              {profile.hero_class}
            </div>
            <h1 className="font-display text-3xl font-bold sm:text-4xl">{profile.display_name}</h1>
            <div className="mt-3 flex flex-wrap items-center gap-3">
              <div className="rounded-full bg-[color:var(--neon-violet)]/20 px-3 py-1 text-sm font-bold text-[color:var(--neon-violet)]">
                Lvl {profile.level}
              </div>
              <div className="flex items-center gap-1 rounded-full bg-[color:var(--flame)]/20 px-3 py-1 text-sm font-bold text-[color:var(--flame)]">
                <Flame className="h-4 w-4 animate-flame" /> {profile.current_streak}{" "}
                {profile.current_streak > 1 ? t.dashboard.days : t.dashboard.day}
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
                <span>Level {profile.level}</span>
                <span>{xpInLevel} / 200 XP</span>
              </div>
              <div
                className="h-2.5 overflow-hidden rounded-full bg-secondary"
                role="progressbar"
                aria-label="XP Progress"
                aria-valuenow={Math.round(xpPct)}
                aria-valuemin={0}
                aria-valuemax={100}
              >
                <div
                  className="h-full rounded-full bg-gradient-to-r from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon transition-all"
                  style={{ width: `${xpPct}%` }}
                />
              </div>
            </div>
            {studentAllianceCode && (
              <div className="mt-4 rounded-xl border border-[color:var(--neon-cyan)]/35 bg-[color:var(--neon-cyan)]/8 p-3">
                <div className="text-[11px] uppercase tracking-[0.2em] text-[color:var(--neon-cyan)]">
                  {t.dashboard.allianceCode}
                </div>
                <div className="mt-1 flex items-center justify-between gap-2">
                  <div className="font-mono text-xs sm:text-sm text-foreground/90">
                    {studentAllianceCode}
                  </div>
                  <button
                    type="button"
                    onClick={async () => {
                      await navigator.clipboard.writeText(studentAllianceCode);
                      setCopiedCode(true);
                      setTimeout(() => setCopiedCode(false), 1200);
                    }}
                    className="inline-flex items-center gap-1 rounded-md border border-[color:var(--neon-cyan)]/40 px-2 py-1 text-xs text-[color:var(--neon-cyan)] hover:bg-[color:var(--neon-cyan)]/10"
                  >
                    {copiedCode ? (
                      <Check className="h-3.5 w-3.5" />
                    ) : (
                      <Copy className="h-3.5 w-3.5" />
                    )}
                    {copiedCode ? t.dashboard.allianceCopied : t.dashboard.allianceCopy}
                  </button>
                </div>
                <p className="mt-1 text-xs text-muted-foreground">{t.dashboard.allianceHint}</p>
              </div>
            )}
          </div>
          <div className="hidden sm:block">
            <div className="text-right text-xs uppercase tracking-widest text-muted-foreground">
              {t.dashboard.longestStreak}
            </div>
            <div className="text-right font-display text-2xl font-bold text-[color:var(--flame)]">
              {profile.longest_streak}d
            </div>
          </div>
        </div>
      </motion.div>

      {/* TODAY'S PROGRESS + MOTIVATION */}
      <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="mt-6 grid gap-4 sm:grid-cols-2"
      >
        <DailyXpWidget
          xpToday={(sprint2?.dailyObjectives ?? [])
            .filter((o) => o.status === "completed")
            .reduce((sum, o) => sum + (o.xp_reward ?? 0), 0)}
          dailyGoal={100}
          streak={profile.current_streak}
        />
        <MotivationalQuote />
      </motion.div>

      {/* STREAK RECOVERY BANNER */}
      {profile.current_streak === 0 && (profile.longest_streak ?? 0) > 0 && (
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.12 }}
          className="mt-4 flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--flame)]/40 bg-[color:var(--flame)]/8 p-4 backdrop-blur-md"
        >
          <div className="flex items-center gap-3">
            <div className="grid h-10 w-10 place-items-center rounded-xl bg-[color:var(--flame)]/25">
              <Flame className="h-5 w-5 text-[color:var(--flame)]" />
            </div>
            <div>
              <div className="font-display text-sm font-bold">{t.dashboard.streakLostTitle}</div>
              <div className="text-xs text-muted-foreground">
                {t.dashboard.streakLostDesc.replace("{n}", String(profile.longest_streak))}
              </div>
            </div>
          </div>
          <button
            type="button"
            disabled={streakRecoveryMutation.isPending || (profile.yahia_coins ?? 0) < 15}
            onClick={() => streakRecoveryMutation.mutate()}
            className="shrink-0 rounded-lg bg-[color:var(--flame)] px-4 py-2 text-sm font-bold text-primary-foreground transition hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {streakRecoveryMutation.isPending ? "..." : t.dashboard.streakRecover}
          </button>
        </motion.div>
      )}

      {/* QUICK START SECTION */}
      <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15 }}
        className="mt-6 space-y-3"
      >
        {/* Retry incomplete button - highest priority */}
        {nextExerciseId && (
          <Link
            to="/quest/$exerciseId"
            params={{ exerciseId: nextExerciseId }}
            className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/8 p-4 backdrop-blur-md transition hover:border-[color:var(--neon-gold)]/70 hover:bg-[color:var(--neon-gold)]/12 sm:p-5"
          >
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--neon-gold)]/25">
                <Zap className="h-6 w-6 text-[color:var(--neon-gold)]" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-gold)] font-bold">
                  {t.dashboard.retryLabel}
                </div>
                <div className="font-display text-lg font-bold">{t.dashboard.retryTitle}</div>
              </div>
            </div>
            <ChevronRight className="h-6 w-6 text-[color:var(--neon-gold)] transition group-hover:translate-x-1" />
          </Link>
        )}
        {/* Continue subject button - secondary */}
        {continueSubject && (
          <Link
            to="/subject/$subjectId"
            params={{ subjectId: continueSubject.id }}
            className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/5 p-4 backdrop-blur-md transition hover:border-[color:var(--neon-cyan)]/60 hover:bg-[color:var(--neon-cyan)]/10 sm:p-5"
          >
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--neon-cyan)]/20">
                <Play className="h-6 w-6 text-[color:var(--neon-cyan)]" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-cyan)]">
                  {t.dashboard.continueLabel}
                </div>
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
              <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--neon-magenta)] font-bold">
                {t.dashboard.dungeonLabel}
              </div>
              <div className="font-display text-lg font-bold">{t.dashboard.dungeonDesc}</div>
            </div>
          </div>
          <ChevronRight className="h-6 w-6 text-[color:var(--neon-magenta)] transition group-hover:translate-x-1" />
        </Link>
      </motion.div>

      {/* DAILY OBJECTIVES & WEEKLY QUESTS SECTION */}
      <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        className="mt-8 grid gap-6 sm:grid-cols-2"
      >
        {/* Daily Objectives */}
        <div className="rounded-2xl border border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/5 p-5 backdrop-blur-md">
          <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
            <Trophy className="h-5 w-5 text-[color:var(--neon-cyan)]" /> {t.dashboard.dailyQuests}
          </div>
          <div className="space-y-3">
            {(sprint2?.dailyObjectives ?? []).length === 0 && (
              <p className="text-xs text-muted-foreground">{t.dashboard.dailyEmpty}</p>
            )}
            {(sprint2?.dailyObjectives ?? []).map((obj) => {
              const pct =
                obj.target_value > 0
                  ? Math.min(100, Math.round((obj.current_value / obj.target_value) * 100))
                  : 0;
              const done = obj.status === "completed";
              const action = resolveDailyAction(obj.objective_type);
              return (
                <div
                  key={obj.id}
                  className={`rounded-xl bg-background/40 p-3 ${done ? "opacity-60" : ""}`}
                >
                  <div className="flex items-center justify-between">
                    <div className="text-sm font-semibold">
                      {formatObjectiveType(obj.objective_type)}
                    </div>
                    <div className="text-xs text-[color:var(--neon-cyan)]">{obj.xp_reward} XP</div>
                  </div>
                  <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                    <div
                      className="h-full bg-gradient-to-r from-[color:var(--neon-cyan)] to-[color:var(--neon-magenta)] transition-all"
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  <div className="mt-1 text-xs text-muted-foreground">
                    {obj.current_value}/{obj.target_value} {done ? "✓" : ""}
                  </div>
                  <button
                    type="button"
                    disabled={done}
                    onClick={() => runQuestAction(action)}
                    className="mt-2 rounded-md border border-[color:var(--neon-cyan)]/40 bg-[color:var(--neon-cyan)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--neon-cyan)] transition hover:bg-[color:var(--neon-cyan)]/25 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {done ? t.common.completed : t.common.continue}
                  </button>
                </div>
              );
            })}
          </div>
        </div>

        {/* Weekly Quests */}
        <div className="rounded-2xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/5 p-5 backdrop-blur-md">
          <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
            <Flame className="h-5 w-5 text-[color:var(--neon-gold)]" /> {t.dashboard.weeklyQuests}
          </div>
          <div className="space-y-3">
            {(sprint2?.weeklyQuests ?? []).length === 0 && (
              <p className="text-xs text-muted-foreground">{t.dashboard.weeklyEmpty}</p>
            )}
            {(sprint2?.weeklyQuests ?? []).map((q) => {
              const pct =
                q.target_value > 0
                  ? Math.min(100, Math.round((q.current_value / q.target_value) * 100))
                  : 0;
              const done = q.status === "completed";
              const action = resolveWeeklyAction(q.quest_type);
              return (
                <div
                  key={q.id}
                  className={`rounded-xl bg-background/40 p-3 ${done ? "opacity-60" : ""}`}
                >
                  <div className="flex items-center justify-between">
                    <div className="text-sm font-semibold">{formatQuestType(q.quest_type)}</div>
                    <div className="text-xs text-[color:var(--neon-gold)]">{q.xp_reward} XP</div>
                  </div>
                  <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                    <div
                      className="h-full bg-gradient-to-r from-[color:var(--neon-gold)] to-[color:var(--neon-magenta)] transition-all"
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  <div className="mt-1 text-xs text-muted-foreground">
                    {q.current_value}/{q.target_value} {done ? "✓" : ""}
                  </div>
                  <button
                    type="button"
                    disabled={done}
                    onClick={() => runQuestAction(action)}
                    className="mt-2 rounded-md border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/25 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {done ? t.common.completed : t.common.continue}
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
              <Swords className="h-5 w-5 text-[color:var(--neon-violet)]" />{" "}
              {t.dashboard.pathsTitle}
            </h2>
            <Link
              to="/leaderboard"
              className="flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20"
            >
              <Crown className="h-3.5 w-3.5" /> {t.common.leaderboard}
            </Link>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            {subjects.map((s, i) => {
              const Icon = ICONS[s.icon] ?? Sword;
              const st = stats[s.id];
              return (
                <motion.div
                  key={s.id}
                  initial={{ opacity: 0, y: 12 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05 }}
                >
                  <Link
                    to="/subject/$subjectId"
                    params={{ subjectId: s.id }}
                    className="group relative block overflow-hidden rounded-2xl border border-border/50 bg-card/60 p-5 backdrop-blur-md transition hover:-translate-y-1 hover:border-[color:var(--neon-violet)]/60"
                  >
                    <div
                      className="absolute -right-8 -top-8 h-28 w-28 rounded-full blur-2xl opacity-50 transition-opacity group-hover:opacity-90"
                      style={{
                        background: `var(--${s.color_token === "math" ? "subject-math" : s.color_token === "french" ? "subject-french" : s.color_token === "arabic" ? "subject-arabic" : s.color_token === "svt" ? "subject-svt" : "subject-english"})`,
                      }}
                    />
                    <div className="relative flex items-start justify-between">
                      <Icon
                        className="h-8 w-8"
                        style={{ color: `var(--subject-${s.color_token})` }}
                      />
                      <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
                    </div>
                    <div className="relative mt-4">
                      <div className="font-display text-lg font-bold">{s.name_fr}</div>
                      <div className="text-xs uppercase tracking-wider text-muted-foreground">
                        Attribute · {s.attribute}
                      </div>
                    </div>
                    <div className="relative mt-4 flex items-center justify-between text-xs">
                      <span className="text-muted-foreground">
                        {st
                          ? `${st.count} quest${st.count > 1 ? "s" : ""}`
                          : t.dashboard.notAttempted}
                      </span>
                      <span
                        className="font-bold"
                        style={{ color: `var(--subject-${s.color_token})` }}
                      >
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
          {deferSecondarySections ? (
            <Suspense
              fallback={
                <div className="space-y-4">
                  <div className="h-8 w-40 animate-pulse rounded bg-card/40" />
                  <div className="h-80 animate-pulse rounded-2xl bg-card/40" />
                  <div className="h-52 animate-pulse rounded-2xl bg-card/40" />
                </div>
              }
            >
              <DashboardRadarInventory radarData={radarData} inventory={inventory} />
            </Suspense>
          ) : (
            <div className="space-y-4">
              <div className="h-8 w-40 animate-pulse rounded bg-card/40" />
              <div className="h-80 rounded-2xl bg-card/40" />
              <div className="h-52 rounded-2xl bg-card/40" />
            </div>
          )}
        </section>
      </div>

      {deferSecondarySections ? (
        <Suspense
          fallback={
            <div className="mt-8 space-y-6">
              <div className="h-8 w-48 animate-pulse rounded bg-card/40" />
              <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {[1, 2, 3].map((item) => (
                  <div
                    key={`badges-skeleton-${item}`}
                    className="h-44 animate-pulse rounded-2xl bg-card/40"
                  />
                ))}
              </div>
              <div className="h-8 w-48 animate-pulse rounded bg-card/40" />
              <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
                {[1, 2, 3].map((item) => (
                  <div
                    key={`shop-skeleton-${item}`}
                    className="h-52 animate-pulse rounded-2xl bg-card/40"
                  />
                ))}
              </div>
            </div>
          }
        >
          <DashboardBadgesShop
            badges={badges}
            shopItems={shopItems}
            availableCoins={profile.yahia_coins ?? 0}
            isPurchasePending={purchaseMutation.isPending}
            isEquipPending={equipMutation.isPending}
            onPurchase={(itemCode) => purchaseMutation.mutate({ itemCode })}
            onEquip={(itemCode) => equipMutation.mutate({ itemCode })}
          />
        </Suspense>
      ) : (
        <div className="mt-8 space-y-6">
          <div className="h-8 w-48 rounded bg-card/40" />
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {[1, 2, 3].map((item) => (
              <div
                key={`initial-badges-skeleton-${item}`}
                className="h-44 rounded-2xl bg-card/40"
              />
            ))}
          </div>
          <div className="h-8 w-48 rounded bg-card/40" />
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
            {[1, 2, 3].map((item) => (
              <div key={`initial-shop-skeleton-${item}`} className="h-52 rounded-2xl bg-card/40" />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

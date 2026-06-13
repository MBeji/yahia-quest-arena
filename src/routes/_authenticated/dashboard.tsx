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
  getDashboardSecondary,
  getSprint2Dashboard,
  formatObjectiveType,
  formatQuestType,
  resolveDailyAction,
  resolveWeeklyAction,
} from "@/features/dashboard";
import { purchaseShopItem, equipInventorySkin, activateInventoryItem } from "@/features/shop";
import { recoverStreak } from "@/features/progression";
import { SubjectPathCard } from "@/features/dashboard/components/subject-path-card";
import { useIsMobile } from "@/hooks/use-mobile";
import { useReducedMotion } from "motion/react";

const GoldAmbientCanvas = lazy(() => import("@/components/visual/gold-ambient-canvas"));
import { formatStudentAllianceCode } from "@/features/parent-report";
import { useT, useI18n } from "@/lib/i18n";
import { filterSubjectsByLocale } from "@/shared/lib/subject-locale";
import { xpToNextLevel, xpWithinLevel } from "@/shared/lib/level";
import { HeroAvatar } from "@/features/dashboard/components/hero-avatar";
import { HeroStatChips } from "@/features/dashboard/components/hero-stat-chips";

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
  head: () => ({ meta: [{ title: "Hall des Héros · XP Scholars" }] }),
  component: Dashboard,
});

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
    <div className="flex items-center gap-5 rounded-2xl border border-[color:var(--gold)]/30 bg-black/40 p-5 backdrop-blur-md">
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
            stroke={isComplete ? "var(--neon-gold)" : "var(--gold)"}
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
        <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--gold)]">
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
    <div className="flex flex-col justify-center rounded-2xl border border-[color:var(--gold)]/20 bg-black/40 p-5 backdrop-blur-md">
      <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--gold)] mb-3">
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
  const { locale } = useI18n();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const fetchDashboard = useServerFn(getDashboard);
  const fetchDashboardSecondary = useServerFn(getDashboardSecondary);
  const fetchSprint2 = useServerFn(getSprint2Dashboard);
  const purchaseItem = useServerFn(purchaseShopItem);
  const equipSkin = useServerFn(equipInventorySkin);
  const activateItem = useServerFn(activateInventoryItem);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });
  const { data: sprint2 } = useQuery({ queryKey: ["sprint2"], queryFn: () => fetchSprint2() });
  const [copiedCode, setCopiedCode] = useState(false);
  const [deferSecondarySections, setDeferSecondarySections] = useState(false);

  // Light 3D gold ambient — only after mount, never on mobile or reduced-motion
  // (the CSS gold ambient from the shell remains as the fallback).
  const isMobile = useIsMobile();
  const prefersReduced = useReducedMotion();
  const [ambient3dReady, setAmbient3dReady] = useState(false);
  useEffect(() => setAmbient3dReady(true), []);
  const showAmbient3d = ambient3dReady && !prefersReduced && !isMobile;

  // #15: badges/inventory/shop come from a separate server fn, fetched only once
  // the deferred secondary sections are about to render.
  const { data: secondary } = useQuery({
    queryKey: ["dashboard", "secondary"],
    queryFn: () => fetchDashboardSecondary(),
    enabled: deferSecondarySections,
  });

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
      toast.success(t.dashboard.purchaseSuccess.replace("{name}", res.purchasedItemName));
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : t.dashboard.purchaseFailed),
  });

  const equipMutation = useMutation({
    mutationFn: (payload: { itemCode: string }) => equipSkin({ data: payload }),
    onSuccess: (res) => {
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

  const recoverStreakFn = useServerFn(recoverStreak);
  const streakRecoveryMutation = useMutation({
    mutationFn: () => recoverStreakFn(),
    onSuccess: (res) => {
      toast.success(
        t.dashboard.streakRecovered
          .replace("{n}", String(res.newStreak))
          .replace("{unit}", res.newStreak > 1 ? t.dashboard.days : t.dashboard.day),
      );
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : t.dashboard.recoveryFailed),
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
        <div className="h-48 animate-pulse rounded-3xl bg-black/40" />
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="h-20 animate-pulse rounded-2xl bg-black/30" />
          <div className="h-20 animate-pulse rounded-2xl bg-black/30" />
        </div>
        <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-5">
          {[1, 2, 3, 4, 5].map((i) => (
            <div key={i} className="h-28 animate-pulse rounded-2xl bg-black/30" />
          ))}
        </div>
      </div>
    );
  }

  const { profile, subjects, stats, nextExerciseId } = data;
  const otherSubjects = filterSubjectsByLocale(data.otherSubjects ?? [], locale);
  // School subjects flagged as locked by the server (premium parcours, no entitlement).
  const lockedSet = new Set(data.premiumLockedSubjectIds ?? []);
  // #15: badges/inventory/shop now come from the deferred secondary query.
  const badges = secondary?.badges ?? [];
  const inventory = secondary?.inventory ?? [];
  const shopItems = secondary?.shopItems ?? [];
  if (!profile)
    return <div className="p-8 text-center text-muted-foreground">Profile not found.</div>;
  const studentAllianceCode =
    profile.role === "student" ? formatStudentAllianceCode(profile.id) : "";

  // #5: derive within-level XP / remaining XP via shared helpers instead of hardcoded 200.
  const xpInLevel = xpWithinLevel(profile.xp);
  const xpToNext = xpToNextLevel(profile.xp);
  const xpPct = (xpInLevel / (xpInLevel + xpToNext)) * 100;

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

    // TODO(review #32): hardcoded English toast — needs an i18n key (e.g.
    // t.dashboard.noQuestTarget) added to the i18n files before it can use useT().
    toast.info("No quest target available yet. Complete one subject quest first.");
  }

  return (
    <>
      {showAmbient3d && (
        <div className="pointer-events-none fixed inset-0 z-0 opacity-70">
          <Suspense fallback={null}>
            <GoldAmbientCanvas />
          </Suspense>
        </div>
      )}
      <div className="relative z-10 mx-auto max-w-7xl px-6 py-8">
        {/* HERO HEADER */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/30 bg-black/40 p-6 backdrop-blur-xl shadow-card sm:p-8"
        >
          <div className="absolute -right-10 -top-10 h-48 w-48 rounded-full bg-[color:var(--gold)]/30 blur-3xl" />
          <div className="absolute -bottom-10 -left-10 h-48 w-48 rounded-full bg-[color:var(--gold)]/20 blur-3xl" />
          <div className="relative grid gap-6 sm:grid-cols-[auto,1fr,auto] sm:items-center">
            <HeroAvatar avatarSlug={profile.avatar_slug} />
            <div>
              <h1 className="font-display text-3xl font-bold sm:text-4xl">
                {profile.display_name}
              </h1>
              <HeroStatChips
                level={profile.level}
                currentStreak={profile.current_streak}
                xp={profile.xp}
                coins={profile.yahia_coins ?? 0}
                heroClass={profile.hero_class}
              />
              <div className="mt-4">
                <div className="mb-1 flex justify-between text-xs text-muted-foreground">
                  <span>Level {profile.level}</span>
                  <span>
                    {xpInLevel} / {xpInLevel + xpToNext} XP
                  </span>
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
                    className="h-full rounded-full bg-gradient-to-r from-[color:var(--gold)] to-[color:var(--gold-bright)] shadow-gold transition-all"
                    style={{ width: `${xpPct}%` }}
                  />
                </div>
              </div>
              {studentAllianceCode && (
                <div className="mt-4 rounded-xl border border-[color:var(--gold)]/35 bg-[color:var(--gold)]/8 p-3">
                  <div className="text-[11px] uppercase tracking-[0.2em] text-[color:var(--gold)]">
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
                      className="inline-flex items-center gap-1 rounded-md border border-[color:var(--gold)]/40 px-2 py-1 text-xs text-[color:var(--gold)] hover:bg-[color:var(--gold)]/10"
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
              className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/60 hover:bg-[color:var(--gold)]/10 sm:p-5"
            >
              <div className="flex items-center gap-3">
                <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--gold)]/20">
                  <Play className="h-6 w-6 text-[color:var(--gold)]" />
                </div>
                <div>
                  <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--gold)]">
                    {t.dashboard.continueLabel}
                  </div>
                  <div className="font-display text-lg font-bold">{continueSubject.name_fr}</div>
                </div>
              </div>
              <ChevronRight className="h-6 w-6 text-[color:var(--gold)] transition group-hover:translate-x-1" />
            </Link>
          )}
          {/* Dungeon mode - infinite survival */}
          <Link
            to="/dungeon"
            className="group flex items-center justify-between gap-4 rounded-2xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/60 hover:bg-[color:var(--gold)]/10 sm:p-5"
          >
            <div className="flex items-center gap-3">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-[color:var(--gold)]/20">
                <Skull className="h-6 w-6 text-[color:var(--gold)]" />
              </div>
              <div>
                <div className="text-xs uppercase tracking-[0.2em] text-[color:var(--gold)] font-bold">
                  {t.dashboard.dungeonLabel}
                </div>
                <div className="font-display text-lg font-bold">{t.dashboard.dungeonDesc}</div>
              </div>
            </div>
            <ChevronRight className="h-6 w-6 text-[color:var(--gold)] transition group-hover:translate-x-1" />
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
          <div className="rounded-2xl border border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-5 backdrop-blur-md">
            <div className="mb-4 flex items-center gap-2 font-display text-lg font-bold">
              <Trophy className="h-5 w-5 text-[color:var(--gold)]" /> {t.dashboard.dailyQuests}
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
                    className={`rounded-xl bg-black/40 p-3 ${done ? "opacity-60" : ""}`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="text-sm font-semibold">
                        {formatObjectiveType(obj.objective_type)}
                      </div>
                      <div className="text-xs text-[color:var(--gold)]">{obj.xp_reward} XP</div>
                    </div>
                    <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                      <div
                        className="h-full bg-gradient-to-r from-[color:var(--gold)] to-[color:var(--gold-bright)] transition-all"
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
                      className="mt-2 rounded-md border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/25 disabled:cursor-not-allowed disabled:opacity-50"
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
                    className={`rounded-xl bg-black/40 p-3 ${done ? "opacity-60" : ""}`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="text-sm font-semibold">{formatQuestType(q.quest_type)}</div>
                      <div className="text-xs text-[color:var(--neon-gold)]">{q.xp_reward} XP</div>
                    </div>
                    <div className="mt-2 h-2 overflow-hidden rounded-full bg-secondary">
                      <div
                        className="h-full bg-gradient-to-r from-[color:var(--gold)] to-[color:var(--gold-bright)] transition-all"
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
                <Swords className="h-5 w-5 text-[color:var(--gold)]" /> {t.dashboard.pathsTitle}
              </h2>
              <Link
                to="/leaderboard"
                className="flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20"
              >
                <Crown className="h-3.5 w-3.5" /> {t.common.leaderboard}
              </Link>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              {subjects.map((s, i) => (
                <motion.div
                  key={s.id}
                  initial={{ opacity: 0, y: 12 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.05 }}
                >
                  <SubjectPathCard
                    subject={s}
                    stat={stats[s.id]}
                    premiumLocked={lockedSet.has(s.id)}
                  />
                </motion.div>
              ))}
            </div>
          </section>

          {otherSubjects.length > 0 && (
            <section>
              <div className="mb-4 flex items-center gap-2">
                <h2 className="flex items-center gap-2 font-display text-xl font-bold">
                  <Sparkles className="h-5 w-5 text-[color:var(--gold)]" />{" "}
                  {t.dashboard.otherThemesTitle}
                </h2>
              </div>
              <div className="grid gap-4 sm:grid-cols-2">
                {otherSubjects.map((s, i) => (
                  <motion.div
                    key={s.id}
                    initial={{ opacity: 0, y: 12 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: i * 0.05 }}
                  >
                    <SubjectPathCard subject={s} stat={stats[s.id]} premiumLocked={false} />
                  </motion.div>
                ))}
              </div>
            </section>
          )}

          {/* RADAR */}
          <section>
            {deferSecondarySections ? (
              <Suspense
                fallback={
                  <div className="space-y-4">
                    <div className="h-8 w-40 animate-pulse rounded bg-black/40" />
                    <div className="h-80 animate-pulse rounded-2xl bg-black/40" />
                    <div className="h-52 animate-pulse rounded-2xl bg-black/40" />
                  </div>
                }
              >
                <DashboardRadarInventory
                  radarData={radarData}
                  inventory={inventory}
                  avatarSlug={profile.avatar_slug}
                  displayName={profile.display_name}
                  isActivatePending={activateMutation.isPending}
                  onActivate={(itemCode) => activateMutation.mutate({ itemCode })}
                />
              </Suspense>
            ) : (
              <div className="space-y-4">
                <div className="h-8 w-40 animate-pulse rounded bg-black/40" />
                <div className="h-80 rounded-2xl bg-black/40" />
                <div className="h-52 rounded-2xl bg-black/40" />
              </div>
            )}
          </section>
        </div>

        {deferSecondarySections ? (
          <Suspense
            fallback={
              <div className="mt-8 space-y-6">
                <div className="h-8 w-48 animate-pulse rounded bg-black/40" />
                <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
                  {[1, 2, 3].map((item) => (
                    <div
                      key={`badges-skeleton-${item}`}
                      className="h-44 animate-pulse rounded-2xl bg-black/40"
                    />
                  ))}
                </div>
                <div className="h-8 w-48 animate-pulse rounded bg-black/40" />
                <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
                  {[1, 2, 3].map((item) => (
                    <div
                      key={`shop-skeleton-${item}`}
                      className="h-52 animate-pulse rounded-2xl bg-black/40"
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
              isActivatePending={activateMutation.isPending}
              onPurchase={(itemCode) => purchaseMutation.mutate({ itemCode })}
              onEquip={(itemCode) => equipMutation.mutate({ itemCode })}
              onActivate={(itemCode) => activateMutation.mutate({ itemCode })}
            />
          </Suspense>
        ) : (
          <div className="mt-8 space-y-6">
            <div className="h-8 w-48 rounded bg-black/40" />
            <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
              {[1, 2, 3].map((item) => (
                <div
                  key={`initial-badges-skeleton-${item}`}
                  className="h-44 rounded-2xl bg-black/40"
                />
              ))}
            </div>
            <div className="h-8 w-48 rounded bg-black/40" />
            <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
              {[1, 2, 3].map((item) => (
                <div
                  key={`initial-shop-skeleton-${item}`}
                  className="h-52 rounded-2xl bg-black/40"
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </>
  );
}

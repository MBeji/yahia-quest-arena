import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { lazy, Suspense, useEffect, useState } from "react";
import { motion } from "motion/react";
import {
  Flame,
  Trophy,
  Swords,
  Crown,
  Skull,
  Copy,
  Check,
  ShoppingBag,
  Compass,
  ChevronRight,
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
import { recoverStreak } from "@/features/progression";
import { EnablePushCard } from "@/features/notifications";
import { SubjectPathCard } from "@/features/dashboard/components/subject-path-card";
import { FamilyGoalCard } from "@/features/dashboard/components/family-goal-card";
import { MotivationalQuote } from "@/features/dashboard/components/motivational-quote";
import { DashboardFocus } from "@/features/dashboard/components/dashboard-focus";
import { useIsMobile } from "@/hooks/use-mobile";
import { useReducedMotion } from "motion/react";
import { entrance } from "@/shared/lib/motion";
import { PageShell } from "@/components/ui/page-shell";
import { GoldProgress } from "@/components/game/gold-progress";

const GoldAmbientCanvas = lazy(() => import("@/components/visual/gold-ambient-canvas"));
import { formatStudentAllianceCode } from "@/features/parent-report";
import { useT } from "@/lib/i18n";
import { xpToNextLevel, xpWithinLevel } from "@/shared/lib/level";
// (subject-locale filtering moved out with the « Autres thèmes » grid — lot 6.)
import { HeroAvatar } from "@/features/dashboard/components/hero-avatar";
import { HeroStatChips } from "@/features/dashboard/components/hero-stat-chips";

export const Route = createFileRoute("/_authenticated/dashboard")({
  head: () => ({ meta: [{ title: "Hall des Héros · Na9ra Nal3ab" }] }),
  component: Dashboard,
});

function Dashboard() {
  const t = useT();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const fetchDashboard = useServerFn(getDashboard);
  const fetchSprint2 = useServerFn(getSprint2Dashboard);
  const { data, isLoading, isError } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });
  const { data: sprint2 } = useQuery({ queryKey: ["sprint2"], queryFn: () => fetchSprint2() });
  const [copiedCode, setCopiedCode] = useState(false);

  // Light 3D gold ambient — only after mount, never on mobile or reduced-motion
  // (the CSS gold ambient from the shell remains as the fallback).
  const isMobile = useIsMobile();
  const prefersReduced = useReducedMotion();
  const [ambient3dReady, setAmbient3dReady] = useState(false);
  useEffect(() => setAmbient3dReady(true), []);
  const showAmbient3d = ambient3dReady && !prefersReduced && !isMobile;

  // Redirect admin/parent users to their report page
  useEffect(() => {
    if (data?.profile?.role === "admin" || data?.profile?.role === "parent") {
      navigate({ to: "/parent-report" });
    }
  }, [data?.profile?.role, navigate]);

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
      <PageShell width="wide" className="space-y-6">
        <div className="h-48 animate-pulse rounded-3xl bg-foreground/10" />
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="h-20 animate-pulse rounded-2xl bg-foreground/10" />
          <div className="h-20 animate-pulse rounded-2xl bg-foreground/10" />
        </div>
        <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-5">
          {[1, 2, 3, 4, 5].map((i) => (
            <div key={i} className="h-28 animate-pulse rounded-2xl bg-foreground/10" />
          ))}
        </div>
      </PageShell>
    );
  }

  const { profile, subjects, stats, nextExerciseId } = data;
  // School subjects flagged as locked by the server (premium parcours, no entitlement).
  const lockedSet = new Set(data.premiumLockedSubjectIds ?? []);
  if (!profile)
    return <div className="p-8 text-center text-muted-foreground">Profile not found.</div>;
  const studentAllianceCode =
    profile.role === "student" ? formatStudentAllianceCode(profile.id) : "";
  // First-run (D-7 / audit §A-5): a brand-new account (no attempt yet) is welcomed,
  // not greeted with « Bon retour » over a column of zeros. `recent` is the
  // attempts feed — empty means the student has never played.
  const isFirstRun = (data.recent ?? []).length === 0;

  // #5: derive within-level XP / remaining XP via shared helpers instead of hardcoded 200.
  const xpInLevel = xpWithinLevel(profile.xp);
  const xpToNext = xpToNextLevel(profile.xp);
  const xpPct = (xpInLevel / (xpInLevel + xpToNext)) * 100;

  // La cible est désormais choisie par `resolveNextAction` (R-31) côté serveur. Il ne reste ici
  // qu'à NOMMER la matière quand l'action en désigne une (chemin délégué ou découverte) : le
  // moteur renvoie un id, l'écran a besoin d'un libellé.
  const actionSubjectId =
    data.nextAction?.kind === "continue-subject" || data.nextAction?.kind === "discover"
      ? data.nextAction.subjectId
      : null;
  const continueSubject = subjects.find((s) => s.id === actionSubjectId) ?? undefined;

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
      navigate({ to: "/matiere/$subjectId", params: { subjectId: continueSubject.id } });
      return;
    }

    toast.info(t.dashboard.noQuestTarget);
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
      <PageShell width="wide" className="relative z-10">
        {/* HERO HEADER */}
        <motion.div
          {...entrance(prefersReduced, "rise")}
          className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/30 bg-black/40 p-6 backdrop-blur-xl shadow-card sm:p-8"
        >
          {/* Refined premium hairline: a single gold filet across the top edge. */}
          <div className="absolute inset-x-8 top-0 h-px bg-gradient-to-r from-transparent via-[color:var(--gold)]/50 to-transparent" />
          <div className="absolute -end-10 -top-10 h-48 w-48 rounded-full bg-[color:var(--gold)]/30 blur-3xl" />
          <div className="absolute -bottom-10 -start-10 h-48 w-48 rounded-full bg-[color:var(--gold)]/20 blur-3xl" />
          <div className="relative grid gap-6 sm:grid-cols-[auto_1fr_auto] sm:items-center">
            <HeroAvatar avatarSlug={profile.avatar_slug} />
            <div className="min-w-0">
              <div className="text-sm text-muted-foreground">
                {isFirstRun ? t.dashboard.firstRunWelcome : t.dashboard.welcomeBack}
              </div>
              <h1 className="font-display text-2xl font-bold break-words sm:text-3xl md:text-4xl">
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
                  <span>
                    {t.dashboard.levelLabel} {profile.level}
                  </span>
                  <span>
                    {xpInLevel} / {xpInLevel + xpToNext} XP
                  </span>
                </div>
                <GoldProgress value={xpPct} aria-label={t.dashboard.xpProgress} />
              </div>
              {studentAllianceCode && (
                <div className="mt-4 rounded-xl border border-[color:var(--gold)]/35 bg-[color:var(--gold)]/8 p-3">
                  <div className="text-2xs uppercase tracking-[0.2em] text-[color:var(--gold)]">
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
                      className="inline-flex min-h-11 shrink-0 items-center gap-1 rounded-md border border-[color:var(--gold)]/40 px-2.5 py-1 text-xs text-[color:var(--gold)] hover:bg-[color:var(--gold)]/10"
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
              <div className="text-end text-xs uppercase tracking-widest text-muted-foreground">
                {t.dashboard.longestStreak}
              </div>
              <div className="text-end font-display text-2xl font-bold text-[color:var(--flame)]">
                {profile.longest_streak}d
              </div>
            </div>
          </div>
        </motion.div>

        {/* FOCUS BAND — the redesign's centrepiece: promote ONE prioritised action
            ("Reprendre") to hero prominence beside the daily-objective ring, then two
            calm secondary tiles (Donjon · Duel). Replaces the old stacked Quick Start. */}
        <DashboardFocus
          nextAction={data.nextAction}
          continueSubject={continueSubject}
          xpToday={(sprint2?.dailyObjectives ?? [])
            .filter((o) => o.status === "completed")
            .reduce((sum, o) => sum + (o.xp_reward ?? 0), 0)}
          dailyGoal={100}
          streak={profile.current_streak}
        />

        {/* Push opt-in — self-hides when push is unavailable in this browser. */}
        <EnablePushCard />

        {/* STREAK RECOVERY BANNER */}
        {profile.current_streak === 0 && (profile.longest_streak ?? 0) > 0 && (
          <motion.div
            {...entrance(prefersReduced, "rise", 0.12)}
            className="mt-4 flex flex-col gap-3 rounded-2xl border border-[color:var(--flame)]/40 bg-[color:var(--flame)]/8 p-4 backdrop-blur-md sm:flex-row sm:items-center sm:justify-between sm:gap-4"
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

        {/* DAILY OBJECTIVES & WEEKLY QUESTS SECTION */}
        <motion.div
          {...entrance(prefersReduced, "rise", 0.2)}
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
                        {formatObjectiveType(obj.objective_type, t.dashboard.objectiveTypes)}
                      </div>
                      <div className="text-xs text-[color:var(--gold)]">{obj.xp_reward} XP</div>
                    </div>
                    <GoldProgress
                      value={pct}
                      size="sm"
                      className="mt-2"
                      aria-label={formatObjectiveType(
                        obj.objective_type,
                        t.dashboard.objectiveTypes,
                      )}
                    />
                    <div className="mt-1 text-xs text-muted-foreground">
                      {obj.current_value}/{obj.target_value} {done ? "✓" : ""}
                    </div>
                    <button
                      type="button"
                      disabled={done}
                      onClick={() => runQuestAction(action)}
                      className="mt-2 rounded-md border border-[color:var(--gold)]/40 bg-[color:var(--gold)]/15 px-2.5 py-1 text-xs font-semibold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/25 disabled:cursor-not-allowed disabled:opacity-50 [@media(pointer:coarse)]:min-h-11"
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
              {/* Quête famille — l'objectif fixé par le parent lié (null sinon). */}
              <FamilyGoalCard />
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
                      <div className="text-sm font-semibold">
                        {formatQuestType(q.quest_type, t.dashboard.questTypes)}
                      </div>
                      <div className="text-xs text-[color:var(--neon-gold)]">{q.xp_reward} XP</div>
                    </div>
                    <GoldProgress
                      value={pct}
                      size="sm"
                      className="mt-2"
                      aria-label={formatQuestType(q.quest_type, t.dashboard.questTypes)}
                    />
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

        {/* Daily rotating motivation — relocated here as a slim full-width strip so the
            focus band above stays uncluttered. */}
        <div className="mt-6">
          <MotivationalQuote />
        </div>

        {/* SUBJECTS GRID — now full-width (radar/inventory/badges/shop moved to
            the dedicated /boutique route, D-5 / Q-4). */}
        <section className="mt-8">
          <div className="mb-4 flex items-center justify-between">
            <h2 className="flex items-center gap-2 font-display text-xl font-bold">
              <Swords className="h-5 w-5 text-[color:var(--gold)]" /> {t.dashboard.pathsTitle}
            </h2>
            <Link
              to="/leaderboard"
              className="flex items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20 [@media(pointer:coarse)]:min-h-11"
            >
              <Crown className="h-3.5 w-3.5" /> {t.common.leaderboard}
            </Link>
          </div>
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {subjects.map((s, i) => (
              <motion.div key={s.id} {...entrance(prefersReduced, "rise", i * 0.05)}>
                <SubjectPathCard
                  subject={s}
                  stat={stats[s.id]}
                  premiumLocked={lockedSet.has(s.id)}
                />
              </motion.div>
            ))}
          </div>
        </section>

        {/* Two calm destination cards replacing the inline shop/other-themes
            walls (audit §A-4): a personal space (/boutique) and a gateway to the
            wider catalogue (/programme) — no more ~25 flat cards on the QG. */}
        <div className="mt-8 grid gap-4 sm:grid-cols-2">
          <Link
            to="/boutique"
            className="group flex items-center gap-4 rounded-2xl border border-[color:var(--gold)]/25 bg-black/40 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/50 [@media(pointer:coarse)]:min-h-11"
          >
            <div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/15">
              <ShoppingBag className="h-6 w-6 text-[color:var(--gold)]" />
            </div>
            <div className="min-w-0 flex-1">
              <div className="font-display text-base font-bold">{t.dashboard.boutiqueCard}</div>
              <p className="text-sm text-muted-foreground">{t.dashboard.boutiqueCardDesc}</p>
            </div>
            <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:text-[color:var(--gold)] rtl:-scale-x-100" />
          </Link>
          <Link
            to="/programme"
            className="group flex items-center gap-4 rounded-2xl border border-border bg-card/60 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/40 [@media(pointer:coarse)]:min-h-11"
          >
            <div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/10">
              <Compass className="h-6 w-6 text-[color:var(--gold)]" />
            </div>
            <div className="min-w-0 flex-1">
              <div className="font-display text-base font-bold">{t.dashboard.discoverTitle}</div>
              <p className="text-sm text-muted-foreground">{t.dashboard.discoverDesc}</p>
            </div>
            <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:text-[color:var(--gold)] rtl:-scale-x-100" />
          </Link>
        </div>
      </PageShell>
    </>
  );
}

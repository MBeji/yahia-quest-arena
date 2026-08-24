import { createFileRoute, Link, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { lazy, Suspense, useEffect, useState } from "react";
import { motion } from "motion/react";
import {
  Flame,
  TrendingUp,
  Swords,
  Crown,
  Skull,
  ShoppingBag,
  Compass,
  History,
  GraduationCap,
  ChevronRight,
} from "lucide-react";
import { toast } from "sonner";
import { getDashboard, getSprint2Dashboard } from "@/features/dashboard";
// Import direct, même raison que sur le lecteur de chapitre : le barrel de
// la feature IA tirerait la console parent et la Forge dans ce chunk.
import { ForgeEntry } from "@/features/ai/components/forge-entry";
// Import direct, même raison que ci-dessus : le barrel de `tutor` tirerait le
// panneau de correction et ses server fns dans le chunk du tableau de bord,
// alors que ces deux composants-ci sont purs et sans appel réseau.
import { TutorCoachLine, TutorGreeting } from "@/features/tutor/components/tutor-coach";
import { TutorPracticeEntry } from "@/features/tutor/components/tutor-practice-entry";
import { TutorDigestCard } from "@/features/tutor/components/tutor-digest";
import { daysAwayFrom } from "@/features/tutor/coaching";
import { appLocalDate } from "@/shared/lib/app-day";
import { DailyReviewPanel, recoverStreak } from "@/features/progression";
import { hubRouteForRole, shouldLeaveDashboard } from "@/features/auth";
import { EnablePushCard } from "@/features/notifications";
import { SubjectPathCard } from "@/features/dashboard/components/subject-path-card";
import { MotivationalQuote } from "@/features/dashboard/components/motivational-quote";
import { DashboardGoalsSkeleton } from "@/features/dashboard/components/dashboard-goals-skeleton";
import { DashboardFocus } from "@/features/dashboard/components/dashboard-focus";
import { BackToSchoolBanner } from "@/features/dashboard/components/back-to-school-banner";
import { DashboardSkeleton } from "@/features/dashboard/components/dashboard-skeleton";
import { useIsMobile } from "@/hooks/use-mobile";
import { useReducedMotion } from "motion/react";
import { entrance } from "@/shared/lib/motion";
import { PageShell } from "@/components/ui/page-shell";
import { SectionHeading } from "@/components/ui/section-heading";
import { GoldProgress } from "@/components/game/gold-progress";

const GoldAmbientCanvas = lazy(() => import("@/components/visual/gold-ambient-canvas"));
// « Carte de compétences » (étude 07 lot 4) : lazy comme les sections lourdes du dashboard —
// son code (groupement + interaction « S'entraîner ») et le glue de la server fn sortent ainsi
// du chunk eager, qui reste sous budget. Les données, elles, sont déjà chargées par getDashboard.
const CompetencyMapPanel = lazy(() =>
  import("@/features/progression/components/competency-map-panel").then((m) => ({
    default: m.CompetencyMapPanel,
  })),
);
// « Tes points faibles » (étude 04 lot A2.1) : lazy pour la même raison que la carte —
// son code embarque le geste « S'entraîner » et la glue de la server fn.
const WeaknessesPanel = lazy(() =>
  import("@/features/progression/components/weaknesses-panel").then((m) => ({
    default: m.WeaknessesPanel,
  })),
);
// Objectifs & quêtes : même raison, budget de chunk. Voir l'en-tête du composant —
// c'est le `lazy()` qui déplace les octets, pas l'extraction seule.
const DashboardGoals = lazy(() =>
  import("@/features/dashboard/components/dashboard-goals").then((m) => ({
    default: m.DashboardGoals,
  })),
);
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

  // Light 3D gold ambient — only after mount, never on mobile or reduced-motion
  // (the CSS gold ambient from the shell remains as the fallback).
  const isMobile = useIsMobile();
  const prefersReduced = useReducedMotion();
  const [ambient3dReady, setAmbient3dReady] = useState(false);
  useEffect(() => setAmbient3dReady(true), []);
  const showAmbient3d = ambient3dReady && !prefersReduced && !isMobile;

  // A parent has no game profile — send them to their own space (Suivi). An ADMIN
  // stays here: /dashboard is the return target of the whole shell, so bouncing
  // them off it looped the navigation and made the Hall unreachable (hub-route.ts).
  useEffect(() => {
    if (shouldLeaveDashboard(data?.profile?.role)) {
      navigate({ to: hubRouteForRole(data?.profile?.role) });
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
    return <DashboardSkeleton />;
  }

  const { profile, subjects, stats, nextExerciseId } = data;
  // School subjects flagged as locked by the server (premium parcours, no entitlement).
  const lockedSet = new Set(data.premiumLockedSubjectIds ?? []);
  if (!profile)
    return <div className="p-8 text-center text-muted-foreground">Profile not found.</div>;
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
          className="relative overflow-hidden rounded-3xl border border-[color:var(--gold)]/30 bg-surface-2 p-6 backdrop-blur-xl shadow-card sm:p-8"
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
            </div>
            <div className="hidden sm:block">
              <div className="text-end text-xs uppercase tracking-widest text-muted-foreground">
                {t.dashboard.longestStreak}
              </div>
              <div className="text-end font-display text-2xl font-bold text-flame-ink">
                {profile.longest_streak}d
              </div>
            </div>
          </div>
        </motion.div>

        {/* Bannière de rentrée (étude 22, R-4) — proposée, jamais imposée : elle n'apparaît que
            dans la fenêtre du 1ᵉʳ septembre au 31 octobre, et seulement si le choix de classe
            précède cette rentrée. Aucune promotion automatique n'existe (D-6). */}
        {data.promotionSuggestion && (
          <BackToSchoolBanner
            suggestion={data.promotionSuggestion}
            currentClassName={data.currentParcoursName ?? ""}
          />
        )}

        {/* ZONE 1 — « Aujourd'hui » (levier 04). Les trois zones ne changent NI l'ordre
            NI le contenu des blocs : elles leur donnent des points d'ancrage. Le constat
            de l'audit n'était pas qu'il manquait ou surabondait quelque chose, c'est que
            douze blocs de même volume se lisaient comme une liste — donc comme du travail. */}
        <div className="mt-8">
          <SectionHeading icon={Flame} title={t.dashboard.zoneToday} />
        </div>

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

        {/* « Révision du jour » (étude 04, lot A1.1) — juste sous la bande focus, parce que
            c'est la même urgence détaillée : la bande promeut UNE action (la tête du plan),
            le panneau montre les trois. Le composant vit dans la feature `progression` et ses
            données viennent de `getDashboard`, qui n'appelle `get_daily_plan` qu'une fois. */}
        {/* La VOIX d'El Ostedh sur ce plan (étude 11 lot 2, US-5 et US-15). Zéro
            appel de modèle, zéro énergie : une clé i18n choisie par une fonction
            pure à partir de faits déjà chargés — c'est l'étage 0 de §3.7, celui
            qui rend gratuite l'essentiel de la personnalisation perçue (R-10).

            Le tuteur ne s'importe pas depuis `progression` : c'est la route qui
            compose, par un slot, comme `renderTutor` sur l'écran de correction. */}
        <TutorGreeting
          state={{
            daysAway: daysAwayFrom(profile.last_active_date, appLocalDate(new Date())),
            streakDays: profile.current_streak,
            planEmpty: (data.dailyPlan ?? []).length === 0,
          }}
        />
        <DailyReviewPanel
          items={data.dailyPlan ?? []}
          renderCoach={(item, index) => <TutorCoachLine item={item} index={index} />}
        />

        {/* Le BILAN DE LA SEMAINE (étude 11 lot 6, US-13) — dernier de la voix
            d'El Ostedh, et volontairement APRÈS le plan du jour : la journée
            passe avant la rétrospective. Un enfant qui ouvre son hall vient
            jouer, pas lire un bilan ; celui-ci l'attend une fois le plan lu.

            La carte ne s'affiche pleine QUE le dimanche venu — les autres jours
            elle se réduit à une ligne (« ton bilan arrive dimanche »), qui est
            le seul endroit du produit où l'élève apprend que la chose existe.
            C'est aussi la seule surface générée du tableau de bord : la voix du
            coach juste au-dessus, elle, sort d'une bibliothèque (R-10). */}
        <TutorDigestCard />

        {/* ZONE 2 — « Ta progression ». */}
        <div className="mt-8">
          <SectionHeading icon={TrendingUp} title={t.dashboard.zoneProgress} />
        </div>

        {/* « Carte de compétences » (étude 07, lot 4) — la progression PÉDAGOGIQUE sous la
            révision : où en est vraiment l'élève, par compétence, et ce qui le bloque (R-5).
            Données via `getDashboard` (une lecture de la carte, une des blocages) ; le composant
            est lazy (voir le budget bundle du dashboard). */}
        <Suspense fallback={null}>
          <CompetencyMapPanel
            map={data.competencyMap ?? []}
            blockers={data.competencyBlockers ?? []}
            blockedSlug={data.competencyBlockedSlug ?? null}
          />
        </Suspense>

        {/* « Tes points faibles » (étude 04, lot A2.1) — l'erreur NOMMÉE, sous la carte qui
            dit, elle, le pourcentage. Le panneau ne rend rien tant qu'aucune erreur n'est
            active : c'est l'état normal d'un compte neuf, et une absence vaut mieux qu'un
            encadré vide. */}
        {/* Le geste d'entraînement d'El Ostedh (étude 11 lot 5, US-11/US-12),
            posé par la ROUTE dans le panneau de `progression` : il cible par le
            TAG autant que par la compétence, et bascule vers des questions
            écrites pour l'occasion quand le stock ne suffit pas (Q-8). Il
            REMPLACE le bouton « S'entraîner » du panneau — un seul chemin de
            remédiation (A12). Même motif que `renderCoach` ci-dessus : aucune
            feature n'en importe une autre. */}
        <Suspense fallback={null}>
          <WeaknessesPanel
            weaknesses={data.weaknesses ?? []}
            renderPractice={(weakness) => <TutorPracticeEntry weakness={weakness} />}
          />
        </Suspense>

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

        {/* Objectifs & quêtes — extrait ET chargé paresseusement (le budget du chunk
            `dashboard` n'avait plus que 0,24 ko de marge). Le repli est une
            silhouette de la vraie section, pas `null` : un `null` ferait sauter la
            page au moment où la section arrive. */}
        <Suspense fallback={<DashboardGoalsSkeleton />}>
          <DashboardGoals
            dailyObjectives={sprint2?.dailyObjectives ?? []}
            weeklyQuests={sprint2?.weeklyQuests ?? []}
            onAction={runQuestAction}
          />
        </Suspense>

        {/* SUBJECTS GRID — now full-width (radar/inventory/badges/shop moved to
            the dedicated /boutique route, D-5 / Q-4). */}
        {/* ZONE 3 — « Explorer ». La grille de matières portait DÉJÀ le seul intertitre
            de l'écran ; il devient celui de la zone, et son action (classement) le suit. */}
        <section className="mt-8">
          <SectionHeading
            icon={Swords}
            title={t.dashboard.zoneExplore}
            action={
              <Link
                to="/leaderboard"
                className="flex shrink-0 items-center gap-1.5 rounded-lg border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20 [@media(pointer:coarse)]:min-h-11"
              >
                <Crown className="h-3.5 w-3.5" /> {t.common.leaderboard}
              </Link>
            }
          />
          <h3 className="mb-4 text-sm font-semibold uppercase tracking-wider text-muted-foreground">
            {t.dashboard.pathsTitle}
          </h3>
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
            className="group flex items-center gap-4 rounded-2xl border border-[color:var(--gold)]/25 bg-surface-2 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/50 [@media(pointer:coarse)]:min-h-11"
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
          {/* « Changer de classe » — la seule porte PERMANENTE vers son vrai niveau (#776).
              La bannière de rentrée ne s'ouvre que du 1ᵉʳ septembre au 31 octobre (R-4) et le
              catalogue, lui, s'appelle « Découvrir d'autres thèmes » : hors fenêtre, un élève
              inscrit en 8ᵉ qui veut rejoindre sa 9ᵉ n'avait plus aucun libellé à suivre. Un
              LIEN, pas une promotion automatique : l'élève choisit toujours (D-6). */}
          {data.currentParcoursName && (
            <Link
              to="/programme"
              data-testid="change-class"
              className="group flex items-center gap-4 rounded-2xl border border-border bg-card/60 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/40 [@media(pointer:coarse)]:min-h-11"
            >
              <div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/10">
                <GraduationCap className="h-6 w-6 text-[color:var(--gold)]" />
              </div>
              <div className="min-w-0 flex-1">
                <div className="font-display text-base font-bold">{t.dashboard.changeClass}</div>
                <p className="text-sm text-muted-foreground">
                  {t.dashboard.changeClassHint.replace("{name}", data.currentParcoursName)}
                </p>
              </div>
              <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:text-[color:var(--gold)] rtl:-scale-x-100" />
            </Link>
          )}
          {/* Passerelle « Réviser » (étude 22, R-17) — un LIEN vers la classe précédente, pas un
              changement de parcours : l'ancre ne bouge pas (R-1), et les acquis y sont intacts
              puisque la progression par matière n'est jamais effacée (R-3). */}
          {data.reviseGateway && (
            <Link
              to="/niveau/$parcoursId"
              params={{ parcoursId: data.reviseGateway.parcoursId }}
              data-testid="revise-gateway"
              className="group flex items-center gap-4 rounded-2xl border border-border bg-card/60 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/40 [@media(pointer:coarse)]:min-h-11"
            >
              <div className="grid h-12 w-12 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/10">
                <History className="h-6 w-6 text-[color:var(--gold)]" />
              </div>
              <div className="min-w-0 flex-1">
                <div className="font-display text-base font-bold">
                  {t.dashboard.reviseGateway.replace("{name}", data.reviseGateway.name)}
                </div>
                <p className="text-sm text-muted-foreground">{t.dashboard.reviseGatewayHint}</p>
              </div>
              <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:text-[color:var(--gold)] rtl:-scale-x-100" />
            </Link>
          )}
        </div>

        {/* La Forge, seconde porte d'entrée demandée par l'étude 29 §2.1 (« depuis
            le hub d'un chapitre ET depuis le dashboard élève »). Sans chapitre :
            d'ici on relit ses quiz existants, on en forge un depuis un chapitre.
            Invisible tant que la Forge n'est pas activée pour cet élève (R-1). */}
        <ForgeEntry chapterId={null} authenticated />

        {/* ZONE CALME — ce qui accompagne sans réclamer : la citation du jour et
            l'opt-in aux notifications. L'opt-in descend d'ici (il était coincé entre
            deux blocs de contenu) : c'est un réglage, pas une étape du parcours. */}
        <div className="mt-8 space-y-4 opacity-90">
          <MotivationalQuote />
          <EnablePushCard />
        </div>
      </PageShell>
    </>
  );
}

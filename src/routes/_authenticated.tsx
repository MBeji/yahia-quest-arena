import { createFileRoute, Outlet, Link, useNavigate, useLocation } from "@tanstack/react-router";
import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  useAuth,
  useMyRole,
  shouldRedirectToOnboarding,
  hubRouteForRole,
  useProfileLocaleSync,
} from "@/features/auth";
import { getPendingBetaCount } from "@/features/subscription";
import { getOpenReportsCount } from "@/features/content-report";
import { BetaBadge, BugReportLauncher, getOpenBugsCount } from "@/features/bug-report";
import { AiLauncher } from "@/features/ai/components/ai-launcher";
import {
  Sparkles,
  LayoutDashboard,
  Map,
  Compass,
  Swords,
  ClipboardList,
  Shield,
} from "lucide-react";
import { supabase } from "@/shared/integrations/supabase/client";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import { SettingsMenu } from "@/components/ui/settings-menu";
import { GoldAmbient } from "@/components/visual/gold-ambient";
import { AccountHud } from "@/components/account-hud";

const NAV_LINK =
  "flex min-h-11 items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground transition hover:bg-[color:var(--gold)]/10 hover:text-champagne";
const NAV_ACTIVE = { className: "text-[color:var(--gold)] bg-[color:var(--gold)]/12" };

export const Route = createFileRoute("/_authenticated")({
  component: AuthenticatedLayout,
});

function AuthenticatedLayout() {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const t = useT();

  // User role + active parcours for conditional nav and the onboarding guard.
  // Shared with every /admin guard via useMyRole — see that hook for why a single
  // shared query definition is required (cache-key collision otherwise locked
  // admins out of their consoles).
  const { role: userRole, currentParcoursId, hasProfile, isLoaded: meLoaded } = useMyRole();

  // é31 lot 4 (R-17) — la langue d'interface descend dans le profil, pour que les
  // notifications du soir parlent celle de l'élève. Ici parce que c'est le seul
  // endroit qui sait à la fois qui est connecté et quelle langue est affichée.
  useProfileLocaleSync(Boolean(user) && hasProfile);

  // Pending beta-access requests count for the admin nav badge.
  const fetchBetaCount = useServerFn(getPendingBetaCount);
  const { data: betaCount } = useQuery({
    queryKey: ["beta-pending-count"],
    enabled: userRole === "admin",
    staleTime: 60_000,
    queryFn: () => fetchBetaCount(),
  });
  const pendingBeta = betaCount?.count ?? 0;

  // Open content-error reports count for the admin nav badge.
  const fetchReportsCount = useServerFn(getOpenReportsCount);
  const { data: reportsCount } = useQuery({
    queryKey: ["open-reports-count"],
    enabled: userRole === "admin",
    staleTime: 60_000,
    queryFn: () => fetchReportsCount(),
  });
  const openReports = reportsCount?.count ?? 0;

  // Open bug reports count for the admin nav badge.
  const fetchBugsCount = useServerFn(getOpenBugsCount);
  const { data: bugsCount } = useQuery({
    queryKey: ["open-bugs-count"],
    enabled: userRole === "admin",
    staleTime: 60_000,
    queryFn: () => fetchBugsCount(),
  });
  const openBugs = bugsCount?.count ?? 0;
  // Une seule pastille pour les trois files : l'entrée « Console » remplace six
  // liens, elle doit porter leur signal cumulé sans le détailler.
  const adminPending = pendingBeta + openReports + openBugs;

  // Redirect unauthenticated users via effect (not during render)
  useEffect(() => {
    if (!loading && !user) {
      navigate({ to: "/auth", search: { mode: "login" } });
    }
  }, [loading, user, navigate]);

  // Profile-first onboarding guard: a signed-in STUDENT with no active parcours is
  // sent to /onboarding. Gated on the profile query having loaded (no flash) and
  // the user not already being on /onboarding (no redirect loop). Parents and
  // admins never enrol in a parcours (onboarding is the student track picker), so
  // they must be exempt — otherwise a parent who signs in / links a child via
  // their code is trapped in the student onboarding loop and can never reach
  // /parent-report (their whole feature set is unreachable).
  useEffect(() => {
    if (!user || !meLoaded) return;
    if (
      shouldRedirectToOnboarding({
        hasProfile,
        role: userRole,
        currentParcoursId,
        pathname: location.pathname,
      })
    ) {
      navigate({ to: "/onboarding" });
    }
  }, [user, meLoaded, hasProfile, userRole, currentParcoursId, location.pathname, navigate]);

  if (loading) {
    return (
      <div className="app-shell grid min-h-[100dvh] place-items-center bg-black-deep">
        <div className="font-display text-sm uppercase tracking-widest text-champagne/70">
          {t.common.loading}
        </div>
      </div>
    );
  }
  if (!user) {
    return null;
  }

  async function signOut() {
    await supabase.auth.signOut();
    toast.success(t.layout.logoutToast);
    navigate({ to: "/" });
  }

  // Single source of truth for the primary STUDENT destinations — rendered both
  // inline in the desktop top nav and in the mobile bottom tab bar. Étude 15,
  // lot 5 (D-4): the three competitive screens (Donjon · Duels · Classement) are
  // grouped under a single « Arène » entry (the /arene pole), so the bar drops
  // from 6 to 4 items — no more desktop overflow, no more crowded phone tab bar.
  const primaryNav = [
    { to: "/dashboard", Icon: LayoutDashboard, label: t.layout.heroesHall },
    { to: "/parcours", Icon: Map, label: t.layout.parcours },
    { to: "/programme", Icon: Compass, label: t.layout.themes },
    { to: "/arene", Icon: Swords, label: t.layout.arena },
  ] as const;
  // The parent gets a dedicated, minimal shell (D-4 / audit §F-1): its ONLY
  // destination (Suivi) — never the game nav, never a crowded bottom bar.
  const isParent = userRole === "parent";
  const showPrimaryNav = !isParent;
  // Where "home" is for this user — the logo and the account chip both aim at it.
  const hub = hubRouteForRole(userRole);
  // Hide the bottom tab bar on immersive play/flow screens so it never overlaps
  // an in-screen sticky CTA (quiz submit, lesson nav, onboarding). The Dungeon
  // LOBBY is no longer immersive (D-4 / audit §E-1): the nav stays until a run
  // actually starts — consistent with duel matches, which already keep the nav.
  // `examen/` porte sa barre oblique à dessein : seule la PASSATION
  // (`/examen/$examId`, avec sa barre de rendu collée en bas) est immersive.
  // Sans elle, `/examens` — la liste — perdrait aussi ses onglets de navigation.
  const immersive = /^\/(quest|lesson|onboarding|examen\/)/.test(location.pathname);

  return (
    <div className="app-shell relative min-h-[100dvh] bg-black-deep">
      <GoldAmbient />
      {/* z-30 (above <main>'s z-10): the header hosts inline pop-overs (language
          menu) that open over the page content. At equal z-index the later <main>
          painted on top and the dashboard grid intercepted the dropdown clicks. */}
      <header className="relative z-30 border-b border-[color:var(--gold)]/15 bg-surface-2 pt-[env(safe-area-inset-top)] backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
          {/* The logo goes to the user's OWN hub: a parent has no Heroes' Hall, and
              pointing them at /dashboard only to bounce them back to /parent-report
              made the header look like it looped. */}
          <Link to={hub} className="flex items-center gap-2">
            <div className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-[image:var(--gradient-gold)] shadow-gold">
              <Sparkles className="h-4 w-4 text-primary-foreground" />
            </div>
            <span className="hidden font-display text-base font-bold tracking-wider sm:inline">
              Na9ra <span className="text-gradient-gold">Nal3ab</span>
            </span>
          </Link>
          <span className="hidden shrink-0 sm:inline-flex">
            <BetaBadge />
          </span>
          <nav className="flex min-w-0 flex-1 items-center gap-1 overflow-x-auto sm:gap-2 [-webkit-overflow-scrolling:touch] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
            {/* Primary destinations: inline on desktop; on mobile/tablet they
                live in the fixed bottom tab bar (rendered below the shell).
                Parents don't get the game nav — their shell is Suivi-only. */}
            <div className="hidden items-center gap-1 sm:gap-2 lg:flex">
              {showPrimaryNav &&
                primaryNav.map(({ to, Icon, label }) => (
                  <Link
                    key={to}
                    to={to}
                    className={NAV_LINK}
                    activeProps={NAV_ACTIVE}
                    aria-label={label}
                    title={label}
                  >
                    <Icon className="h-4 w-4 shrink-0" /> <span>{label}</span>
                  </Link>
                ))}
            </div>
            {isParent && (
              <Link
                to="/parent-report"
                className={NAV_LINK}
                activeProps={NAV_ACTIVE}
                aria-label={t.layout.parentReport}
                title={t.layout.parentReport}
              >
                {/* Parent shell: Suivi is the ONLY destination, so it stays
                    labelled at every width (audit §F-1: no icon-only nav). */}
                <ClipboardList className="h-4 w-4 shrink-0" /> <span>{t.layout.parentReport}</span>
              </Link>
            )}
            {userRole === "admin" && (
              // Les six consoles (+ « Économie », que rien ne liait) vivent
              // désormais dans le pôle /console. La pastille agrège leurs files
              // d'attente : l'admin garde le signal d'un coup d'œil, pour une
              // entrée au lieu de six.
              <Link
                to="/console"
                className={NAV_LINK}
                activeProps={NAV_ACTIVE}
                aria-label={t.layout.console}
                title={t.layout.console}
              >
                <Shield className="h-4 w-4 shrink-0" />{" "}
                <span className="hidden lg:inline">{t.layout.console}</span>
                {adminPending > 0 && (
                  <span className="ms-1 rounded-full bg-[image:var(--gradient-gold)] px-1.5 py-0.5 text-[10px] font-bold text-primary-foreground">
                    {adminPending}
                  </span>
                )}
              </Link>
            )}
          </nav>
          {/* Compte + réglages, épinglés HORS de la nav scrollable. Langue, thème,
              son et déconnexion — quatre contrôles permanents — ont fondu dans UN
              engrenage : le cluster ne peut plus élargir le document sur un
              téléphone de 360 px (débordement iPhone 13), et le réglage reste à un
              tap. `min-w-0` : la puce AccountHud garde le droit de se tronquer. */}
          <div className="flex min-w-0 items-center gap-1 sm:gap-2">
            <AccountHud to={hub} />
            <SettingsMenu onSignOut={signOut} />
          </div>
        </div>
      </header>
      <main
        className={
          immersive || !showPrimaryNav
            ? "relative z-10 pb-[env(safe-area-inset-bottom)]"
            : "relative z-10 pb-[calc(4.5rem+env(safe-area-inset-bottom))] lg:pb-[env(safe-area-inset-bottom)]"
        }
      >
        <Outlet />
      </main>
      {/* Beta-phase bug launcher — floats above the content. Hidden on immersive
          screens (quest/dungeon/lesson/onboarding) so it never overlaps an
          in-screen sticky CTA. */}
      {!immersive && <BugReportLauncher />}
      {/* La bulle IA — permanente, y compris grisée (arbitrage du 2026-08-27,
          qui renverse R-1 d'é29). Elle se tait d'elle-même sur les épreuves
          notées : l'autre moitié de R-1 est une règle d'anti-triche, pas de
          découverte. `authenticated` vient de la ROUTE, comme pour la Forge —
          une feature n'importe pas `@/features/auth`. */}
      <AiLauncher authenticated />
      {/* Mobile/tablet bottom tab bar — primary navigation for touch. Hidden on
          desktop (lg) where the top nav carries the same destinations, on
          immersive screens to avoid overlapping their in-screen CTAs, and for
          parents (their Suivi-only shell lives in the top bar — D-4). */}
      {!immersive && showPrimaryNav && (
        <nav className="fixed inset-x-0 bottom-0 z-30 flex items-stretch justify-around border-t border-[color:var(--gold)]/15 bg-surface-3 pb-[env(safe-area-inset-bottom)] backdrop-blur-xl lg:hidden">
          {primaryNav.map(({ to, Icon, label }) => (
            <Link
              key={to}
              to={to}
              aria-label={label}
              title={label}
              className="flex min-h-[52px] flex-1 flex-col items-center justify-center gap-0.5 px-1 py-1.5 text-[10px] font-semibold leading-tight text-muted-foreground transition"
              activeProps={{ className: "text-[color:var(--gold)]" }}
            >
              <Icon className="h-5 w-5 shrink-0" />
              <span className="max-w-full truncate">{label}</span>
            </Link>
          ))}
        </nav>
      )}
    </div>
  );
}

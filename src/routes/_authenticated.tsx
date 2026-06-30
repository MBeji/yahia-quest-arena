import { createFileRoute, Outlet, Link, useNavigate, useLocation } from "@tanstack/react-router";
import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useAuth, useMyRole } from "@/features/auth";
import { getPendingBetaCount } from "@/features/subscription";
import { getOpenReportsCount } from "@/features/content-report";
import {
  Sparkles,
  LayoutDashboard,
  Map,
  Compass,
  LogOut,
  Swords,
  Crown,
  ClipboardList,
  CreditCard,
  FlaskConical,
  Flag,
  TrendingUp,
} from "lucide-react";
import { supabase } from "@/shared/integrations/supabase/client";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { ThemeSwitcher } from "@/components/ui/theme-switcher";
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

  // Redirect unauthenticated users via effect (not during render)
  useEffect(() => {
    if (!loading && !user) {
      navigate({ to: "/auth", search: { mode: "login" } });
    }
  }, [loading, user, navigate]);

  // Profile-first onboarding guard: a signed-in user with no active parcours is
  // sent to /onboarding. Gated on the profile query having loaded (no flash) and
  // the user not already being on /onboarding (no redirect loop).
  useEffect(() => {
    if (!user || !meLoaded) return;
    if (hasProfile && currentParcoursId == null && location.pathname !== "/onboarding") {
      navigate({ to: "/onboarding" });
    }
  }, [user, meLoaded, hasProfile, currentParcoursId, location.pathname, navigate]);

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

  // Single source of truth for the primary student destinations — rendered both
  // inline in the desktop top nav and in the mobile bottom tab bar.
  const primaryNav = [
    { to: "/dashboard", Icon: LayoutDashboard, label: t.layout.heroesHall },
    { to: "/parcours", Icon: Map, label: t.layout.parcours },
    { to: "/programme", Icon: Compass, label: t.layout.themes },
    { to: "/dungeon", Icon: Swords, label: t.layout.dungeon },
    { to: "/leaderboard", Icon: Crown, label: t.layout.ranking },
  ] as const;
  // Hide the bottom tab bar on immersive play/flow screens so it never overlaps
  // an in-screen sticky CTA (quiz submit, lesson nav, dungeon HUD, onboarding).
  const immersive = /^\/(quest|dungeon|lesson|onboarding)/.test(location.pathname);

  return (
    <div className="app-shell relative min-h-[100dvh] bg-black-deep">
      <GoldAmbient />
      {/* z-30 (above <main>'s z-10): the header hosts inline pop-overs (language
          menu) that open over the page content. At equal z-index the later <main>
          painted on top and the dashboard grid intercepted the dropdown clicks. */}
      <header className="relative z-30 border-b border-[color:var(--gold)]/15 bg-black/40 pt-[env(safe-area-inset-top)] backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-3 px-4 py-3 sm:px-6">
          <Link to="/dashboard" className="flex items-center gap-2">
            <div className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-[image:var(--gradient-gold)] shadow-gold">
              <Sparkles className="h-4 w-4 text-black" />
            </div>
            <span className="hidden font-display text-base font-bold tracking-wider sm:inline">
              Na9ra <span className="text-gradient-gold">Nal3ab</span>
            </span>
          </Link>
          <nav className="flex min-w-0 flex-1 items-center gap-1 overflow-x-auto sm:gap-2 [-webkit-overflow-scrolling:touch] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
            {/* Primary destinations: inline on desktop; on mobile/tablet they
                live in the fixed bottom tab bar (rendered below the shell). */}
            <div className="hidden items-center gap-1 sm:gap-2 lg:flex">
              {primaryNav.map(({ to, Icon, label }) => (
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
            {userRole === "parent" && (
              <Link
                to="/parent-report"
                className={NAV_LINK}
                activeProps={NAV_ACTIVE}
                aria-label={t.layout.parentReport}
                title={t.layout.parentReport}
              >
                <ClipboardList className="h-4 w-4 shrink-0" />{" "}
                <span className="hidden lg:inline">{t.layout.parentReport}</span>
              </Link>
            )}
            {userRole === "admin" && (
              <>
                <Link
                  to="/parent-report"
                  className={NAV_LINK}
                  activeProps={NAV_ACTIVE}
                  aria-label={t.layout.admin}
                  title={t.layout.admin}
                >
                  <ClipboardList className="h-4 w-4 shrink-0" />{" "}
                  <span className="hidden lg:inline">{t.layout.admin}</span>
                </Link>
                <Link
                  to="/admin/subscriptions"
                  className={NAV_LINK}
                  activeProps={NAV_ACTIVE}
                  aria-label={t.layout.subscriptions}
                  title={t.layout.subscriptions}
                >
                  <CreditCard className="h-4 w-4 shrink-0" />{" "}
                  <span className="hidden lg:inline">{t.layout.subscriptions}</span>
                </Link>
                <Link
                  to="/admin/beta-requests"
                  className={NAV_LINK}
                  activeProps={NAV_ACTIVE}
                  aria-label={t.layout.betaRequests}
                  title={t.layout.betaRequests}
                >
                  <FlaskConical className="h-4 w-4 shrink-0" />{" "}
                  <span className="hidden lg:inline">{t.layout.betaRequests}</span>
                  {pendingBeta > 0 && (
                    <span className="ml-1 rounded-full bg-[image:var(--gradient-gold)] px-1.5 py-0.5 text-[10px] font-bold text-black">
                      {pendingBeta}
                    </span>
                  )}
                </Link>
                <Link
                  to="/admin/content-reports"
                  className={NAV_LINK}
                  activeProps={NAV_ACTIVE}
                  aria-label={t.layout.contentReports}
                  title={t.layout.contentReports}
                >
                  <Flag className="h-4 w-4 shrink-0" />{" "}
                  <span className="hidden lg:inline">{t.layout.contentReports}</span>
                  {openReports > 0 && (
                    <span className="ml-1 rounded-full bg-[image:var(--gradient-gold)] px-1.5 py-0.5 text-[10px] font-bold text-black">
                      {openReports}
                    </span>
                  )}
                </Link>
                <Link
                  to="/admin/parcours-interest"
                  className={NAV_LINK}
                  activeProps={NAV_ACTIVE}
                  aria-label={t.layout.parcoursInterest}
                  title={t.layout.parcoursInterest}
                >
                  <TrendingUp className="h-4 w-4 shrink-0" />{" "}
                  <span className="hidden lg:inline">{t.layout.parcoursInterest}</span>
                </Link>
              </>
            )}
          </nav>
          {/* Account actions are pinned OUTSIDE the scrollable nav (shrink-0) so the
              language / theme / sign-out controls stay in view even when the link
              list overflows — e.g. the admin nav, where sign-out used to scroll off
              the right edge and become unreachable. */}
          <div className="flex shrink-0 items-center gap-1 sm:gap-2">
            <AccountHud />
            <LanguageSwitcher />
            <ThemeSwitcher />
            <button onClick={signOut} className={NAV_LINK} aria-label={t.layout.signOut}>
              <LogOut className="h-4 w-4 shrink-0" />{" "}
              <span className="hidden lg:inline">{t.layout.signOut}</span>
            </button>
          </div>
        </div>
      </header>
      <main
        className={
          immersive
            ? "relative z-10 pb-[env(safe-area-inset-bottom)]"
            : "relative z-10 pb-[calc(4.5rem+env(safe-area-inset-bottom))] lg:pb-[env(safe-area-inset-bottom)]"
        }
      >
        <Outlet />
      </main>
      {/* Mobile/tablet bottom tab bar — primary navigation for touch. Hidden on
          desktop (lg) where the top nav carries the same destinations, and on
          immersive screens to avoid overlapping their in-screen CTAs. */}
      {!immersive && (
        <nav className="fixed inset-x-0 bottom-0 z-30 flex items-stretch justify-around border-t border-[color:var(--gold)]/15 bg-black/80 pb-[env(safe-area-inset-bottom)] backdrop-blur-xl lg:hidden">
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

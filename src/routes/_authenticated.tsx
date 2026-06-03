import { createFileRoute, Outlet, Link, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useAuth } from "@/features/auth";
import { getPendingBetaCount } from "@/features/subscription";
import { getOpenReportsCount } from "@/features/content-report";
import {
  Sparkles,
  LayoutDashboard,
  LogOut,
  Swords,
  Crown,
  ClipboardList,
  CreditCard,
  FlaskConical,
  Flag,
} from "lucide-react";
import { supabase } from "@/shared/integrations/supabase/client";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { GoldAmbient } from "@/components/visual/gold-ambient";

const NAV_LINK =
  "flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground transition hover:bg-[color:var(--gold)]/10 hover:text-champagne";
const NAV_ACTIVE = { className: "text-[color:var(--gold)] bg-[color:var(--gold)]/12" };

export const Route = createFileRoute("/_authenticated")({
  component: AuthenticatedLayout,
});

function AuthenticatedLayout() {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const t = useT();

  // Fetch user role for conditional nav. Cached so it is not refetched on every
  // navigation within the authenticated layout.
  const { data: userRole = null } = useQuery({
    queryKey: ["me-role", user?.id],
    enabled: !!user,
    staleTime: 5 * 60_000,
    queryFn: async () => {
      const { data } = await supabase.from("profiles").select("role").eq("id", user!.id).single();
      return data?.role ?? null;
    },
  });

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

  if (loading) {
    return (
      <div className="grid min-h-screen place-items-center bg-black-deep">
        <div className="font-display text-sm uppercase tracking-widest text-champagne/70">
          Loading…
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

  return (
    <div className="relative min-h-screen bg-black-deep">
      <GoldAmbient />
      <header className="relative z-10 border-b border-[color:var(--gold)]/15 bg-black/40 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-4 px-6 py-3">
          <Link to="/dashboard" className="flex items-center gap-2">
            <div className="grid h-9 w-9 place-items-center rounded-lg bg-[image:var(--gradient-gold)] shadow-gold">
              <Sparkles className="h-4 w-4 text-black" />
            </div>
            <span className="font-display text-base font-bold tracking-wider">
              XP <span className="text-gradient-gold">SCHOLARS</span>
            </span>
          </Link>
          <nav className="flex items-center gap-2 text-sm">
            <Link to="/dashboard" className={NAV_LINK} activeProps={NAV_ACTIVE}>
              <LayoutDashboard className="h-4 w-4" /> {t.layout.heroesHall}
            </Link>
            <Link to="/dungeon" className={NAV_LINK} activeProps={NAV_ACTIVE}>
              <Swords className="h-4 w-4" /> {t.layout.dungeon}
            </Link>
            <Link to="/leaderboard" className={NAV_LINK} activeProps={NAV_ACTIVE}>
              <Crown className="h-4 w-4" /> {t.layout.ranking}
            </Link>
            {userRole === "parent" && (
              <Link to="/parent-report" className={NAV_LINK} activeProps={NAV_ACTIVE}>
                <ClipboardList className="h-4 w-4" /> {t.layout.parentReport}
              </Link>
            )}
            {userRole === "admin" && (
              <>
                <Link to="/parent-report" className={NAV_LINK} activeProps={NAV_ACTIVE}>
                  <ClipboardList className="h-4 w-4" /> {t.layout.admin}
                </Link>
                <Link to="/admin/subscriptions" className={NAV_LINK} activeProps={NAV_ACTIVE}>
                  <CreditCard className="h-4 w-4" /> {t.layout.subscriptions}
                </Link>
                <Link to="/admin/beta-requests" className={NAV_LINK} activeProps={NAV_ACTIVE}>
                  <FlaskConical className="h-4 w-4" /> {t.layout.betaRequests}
                  {pendingBeta > 0 && (
                    <span className="ml-1 rounded-full bg-[image:var(--gradient-gold)] px-1.5 py-0.5 text-[10px] font-bold text-black">
                      {pendingBeta}
                    </span>
                  )}
                </Link>
                <Link to="/admin/content-reports" className={NAV_LINK} activeProps={NAV_ACTIVE}>
                  <Flag className="h-4 w-4" /> {t.layout.contentReports}
                  {openReports > 0 && (
                    <span className="ml-1 rounded-full bg-[image:var(--gradient-gold)] px-1.5 py-0.5 text-[10px] font-bold text-black">
                      {openReports}
                    </span>
                  )}
                </Link>
              </>
            )}
            <LanguageSwitcher />
            <button onClick={signOut} className={NAV_LINK}>
              <LogOut className="h-4 w-4" /> {t.layout.signOut}
            </button>
          </nav>
        </div>
      </header>
      <main className="relative z-10">
        <Outlet />
      </main>
    </div>
  );
}

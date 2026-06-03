import { createFileRoute, Outlet, Link, useNavigate } from "@tanstack/react-router";
import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { useAuth } from "@/features/auth";
import { Sparkles, LayoutDashboard, LogOut, Swords, Crown, ClipboardList } from "lucide-react";
import { supabase } from "@/shared/integrations/supabase/client";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import { LanguageSwitcher } from "@/components/ui/language-switcher";

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

  // Redirect unauthenticated users via effect (not during render)
  useEffect(() => {
    if (!loading && !user) {
      navigate({ to: "/auth", search: { mode: "login" } });
    }
  }, [loading, user, navigate]);

  if (loading) {
    return (
      <div className="grid min-h-screen place-items-center bg-hero">
        <div className="font-display text-sm uppercase tracking-widest text-muted-foreground">
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
    <div className="min-h-screen bg-hero">
      <div className="absolute inset-0 bg-grid opacity-40 pointer-events-none" />
      <header className="relative z-10 border-b border-border/40 bg-background/40 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-4 px-6 py-3">
          <Link to="/dashboard" className="flex items-center gap-2">
            <div className="grid h-9 w-9 place-items-center rounded-lg bg-linear-to-br from-neon-violet to-neon-magenta shadow-neon">
              <Sparkles className="h-4 w-4 text-primary-foreground" />
            </div>
            <span className="font-display text-base font-bold tracking-wider">
              XP <span className="text-gradient-cyan">SCHOLARS</span>
            </span>
          </Link>
          <nav className="flex items-center gap-2 text-sm">
            <Link
              to="/dashboard"
              className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground"
              activeProps={{ className: "text-foreground bg-card" }}
            >
              <LayoutDashboard className="h-4 w-4" /> {t.layout.heroesHall}
            </Link>
            <Link
              to="/dungeon"
              className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground"
              activeProps={{ className: "text-foreground bg-card" }}
            >
              <Swords className="h-4 w-4" /> {t.layout.dungeon}
            </Link>
            <Link
              to="/leaderboard"
              className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground"
              activeProps={{ className: "text-foreground bg-card" }}
            >
              <Crown className="h-4 w-4" /> {t.layout.ranking}
            </Link>
            {userRole === "parent" && (
              <Link
                to="/parent-report"
                className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground"
                activeProps={{ className: "text-foreground bg-card" }}
              >
                <ClipboardList className="h-4 w-4" /> {t.layout.parentReport}
              </Link>
            )}
            {userRole === "admin" && (
              <Link
                to="/parent-report"
                className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground"
                activeProps={{ className: "text-foreground bg-card" }}
              >
                <ClipboardList className="h-4 w-4" /> {t.layout.admin}
              </Link>
            )}
            <LanguageSwitcher />
            <button
              onClick={signOut}
              className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground"
            >
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

import { createFileRoute, Outlet, redirect, Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { useAuth } from "@/hooks/use-auth";
import { Sparkles, LayoutDashboard, LogOut, Swords, Crown, ClipboardList } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import {
  getGuestSignInErrorMessage,
  GUEST_ACCESS_COPY,
  PUBLIC_GUEST_ACCESS_ENABLED,
  signInGuestUser,
} from "@/lib/guest-access";

export const Route = createFileRoute("/_authenticated")({
  component: AuthenticatedLayout,
});

function AuthenticatedLayout() {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const [bootstrappingGuest, setBootstrappingGuest] = useState(false);
  const [guestAttempted, setGuestAttempted] = useState(false);
  const [userRole, setUserRole] = useState<string | null>(null);

  // Fetch user role for conditional nav
  useEffect(() => {
    if (!user) return;
    supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .single()
      .then(({ data }) => {
        if (data) setUserRole(data.role);
      });
  }, [user]);

  useEffect(() => {
    if (!PUBLIC_GUEST_ACCESS_ENABLED || loading || user || guestAttempted) return;

    let active = true;
    setGuestAttempted(true);
    setBootstrappingGuest(true);

    signInGuestUser(supabase).then((res) => {
      if (!active) return;

      if (!res.ok) {
        toast.error(getGuestSignInErrorMessage(res));
        navigate({ to: "/auth", search: { mode: "login" } });
      }
    }).finally(() => {
      if (active) setBootstrappingGuest(false);
    });

    return () => {
      active = false;
    };
  }, [guestAttempted, loading, navigate, user]);

  // Redirect unauthenticated users via effect (not during render)
  useEffect(() => {
    if (!loading && !bootstrappingGuest && !user) {
      navigate({ to: "/auth", search: { mode: "login" } });
    }
  }, [loading, bootstrappingGuest, user, navigate]);

  if (loading || bootstrappingGuest) {
    return (
      <div className="grid min-h-screen place-items-center bg-hero">
        <div className="font-display text-sm uppercase tracking-widest text-muted-foreground">
          {bootstrappingGuest ? GUEST_ACCESS_COPY.loading : "Loading…"}
        </div>
      </div>
    );
  }
  if (!user) {
    return null;
  }

  async function signOut() {
    await supabase.auth.signOut();
    toast.success(PUBLIC_GUEST_ACCESS_ENABLED ? GUEST_ACCESS_COPY.signOutToast : "See you soon, warrior.");
    navigate({ to: "/" });
  }

  return (
    <div className="min-h-screen bg-hero">
      <div className="absolute inset-0 bg-grid opacity-40 pointer-events-none" />
      <header className="relative z-10 border-b border-border/40 bg-background/40 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between gap-4 px-6 py-3">
          <Link to="/dashboard" className="flex items-center gap-2">
            <div className="grid h-9 w-9 place-items-center rounded-lg bg-gradient-to-br from-[color:var(--neon-violet)] to-[color:var(--neon-magenta)] shadow-neon">
              <Sparkles className="h-4 w-4 text-primary-foreground" />
            </div>
            <span className="font-display text-base font-bold tracking-wider">XP <span className="text-gradient-cyan">SCHOLARS</span></span>
          </Link>
          <nav className="flex items-center gap-2 text-sm">
            <Link to="/dashboard" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <LayoutDashboard className="h-4 w-4" /> Heroes Hall
            </Link>
            <Link to="/dungeon" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <Swords className="h-4 w-4" /> Dungeon
            </Link>
            <Link to="/leaderboard" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
              <Crown className="h-4 w-4" /> Ranking
            </Link>
            {userRole === "parent" && (
              <Link to="/parent-report" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
                <ClipboardList className="h-4 w-4" /> Suivi
              </Link>
            )}
            {userRole === "admin" && (
              <Link to="/parent-report" className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground" activeProps={{ className: "text-foreground bg-card" }}>
                <ClipboardList className="h-4 w-4" /> Admin
              </Link>
            )}
            <button onClick={signOut} className="flex items-center gap-1.5 rounded-md px-3 py-1.5 text-muted-foreground hover:bg-card hover:text-foreground">
              <LogOut className="h-4 w-4" /> Sign out
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

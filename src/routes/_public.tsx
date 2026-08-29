import { createFileRoute, Outlet } from "@tanstack/react-router";
import { PublicHeader } from "@/components/public/public-header";
import { PublicFooter } from "@/components/public/public-footer";
import { PrintMark } from "@/components/public/print-mark";
import { CanonicalLink } from "@/components/public/canonical-link";
import { usePublicContentProtection } from "@/shared/lib/content-protection";
import { useAuth } from "@/features/auth";
import { AiLauncher } from "@/features/ai/components/ai-launcher";

/**
 * Public coquille — NO auth guard: its content (courses, catalogue, exercises) is
 * readable by anyone, no login. The visual skin is the user's GLOBAL theme (set on
 * `<html>` via the ThemeSwitcher, default « Référence »), NOT pinned by this layout
 * — so moving between the public and connected worlds never changes the theme. The
 * `.public-shell` class is a structural hook for public-only concerns (print
 * watermark, IP image guard, lesson typography), independent of the active theme.
 */
export const Route = createFileRoute("/_public")({
  component: PublicLayout,
});

function PublicLayout() {
  usePublicContentProtection();
  // La bulle IA vit AUSSI ici : le lecteur de chapitre est une page publique, et
  // c'est la page où le chat existe. Un élève connecté qui lit son cours doit y
  // trouver la même bulle que partout ailleurs. Un visiteur anonyme n'en voit
  // rien — `AiLauncher` rend `null` sans session.
  const { user } = useAuth();
  return (
    <div className="public-shell flex min-h-[100dvh] flex-col bg-background text-foreground">
      {/* Hoisted into <head> by React 19 — the indexable origin, stated outright. */}
      <CanonicalLink />
      <PublicHeader />
      <main className="flex-1">
        <Outlet />
      </main>
      <PublicFooter />
      <PrintMark />
      <AiLauncher authenticated={!!user} />
    </div>
  );
}

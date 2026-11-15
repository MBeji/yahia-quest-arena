import { createFileRoute, Outlet, useLocation } from "@tanstack/react-router";
import { PublicHeader } from "@/components/public/public-header";
import { PublicFooter } from "@/components/public/public-footer";
import { NetworkBanner } from "@/components/ui/network-banner";
import { PrintMark } from "@/components/public/print-mark";
import { CanonicalLink } from "@/components/public/canonical-link";
import { usePublicContentProtection } from "@/shared/lib/content-protection";
import { useAuth, useMyRole } from "@/features/auth";
import { StudentTabBar } from "@/components/student-tab-bar";
import { TAB_BAR_CLEARANCE } from "@/components/student-nav";
import { isImmersivePublicPath } from "@/shared/lib/immersive-paths";
import { AiLauncher } from "@/features/ai/components/ai-launcher";
// é40 lot 3 (R-13) — importé pour son EFFET : le module retient `beforeinstallprompt`, que le
// navigateur n'émet qu'une fois par page, bien avant l'écran de résultat qui s'en servira.
import "@/shared/lib/install-signals";

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
  // La barre d'onglets d'un ÉLÈVE CONNECTÉ le suit sur le catalogue (arbitrage du
  // propriétaire, 2026-11-15) : ces pages lui sont servies par cette coquille, et en ouvrant
  // une matière ou un cours depuis son Hall il perdait ses onglets. Trois conditions :
  //   - une session : un visiteur sans compte n'en voit jamais rien, pas plus que le rendu
  //     serveur (R-6 de l'étude 38 — rien ne devine l'état du compte) ;
  //   - son rôle LU, et ce n'est pas un parent : un parent n'a pas la navigation de jeu
  //     (étude 15, D-4), et la monter avant de le savoir la ferait disparaître sous son doigt ;
  //   - pas un écran immersif : le lecteur d'entraînement et la passation du test de niveau
  //     ont leur bouton en bas d'écran.
  const { role, isLoaded: roleLoaded } = useMyRole();
  const pathname = useLocation({ select: (location) => location.pathname });
  const showTabBar =
    user != null && roleLoaded && role !== "parent" && !isImmersivePublicPath(pathname);
  return (
    <div
      className={`public-shell flex min-h-[100dvh] flex-col bg-background text-foreground ${
        showTabBar ? TAB_BAR_CLEARANCE : ""
      }`}
    >
      {/* Hoisted into <head> by React 19 — the indexable origin, stated outright. */}
      <CanonicalLink />
      <PublicHeader />
      {/* é38 lot 4 — collé sous l'en-tête collant, dont la hauteur est mesurée. */}
      <NetworkBanner className="sticky top-[var(--public-header-h,0px)] z-20" />
      <main className="flex-1">
        <Outlet />
      </main>
      <PublicFooter />
      <PrintMark />
      <AiLauncher authenticated={!!user} />
      {showTabBar && <StudentTabBar />}
    </div>
  );
}

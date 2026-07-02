import { createFileRoute, Outlet } from "@tanstack/react-router";
import { PublicHeader } from "@/components/public/public-header";
import { PublicFooter } from "@/components/public/public-footer";
import { PrintMark } from "@/components/public/print-mark";
import { usePublicContentProtection } from "@/shared/lib/content-protection";

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
  return (
    <div className="public-shell flex min-h-[100dvh] flex-col bg-background text-foreground">
      <PublicHeader />
      <main className="flex-1">
        <Outlet />
      </main>
      <PublicFooter />
      <PrintMark />
    </div>
  );
}

import { createFileRoute, Outlet } from "@tanstack/react-router";
import { PublicHeader } from "@/components/public/public-header";
import { PublicFooter } from "@/components/public/public-footer";
import { PrintMark } from "@/components/public/print-mark";
import { usePublicContentProtection } from "@/shared/lib/content-protection";

/**
 * Public coquille — the « Référence » register (chantier C8). UNLIKE
 * `_authenticated`, this layout has NO auth guard: its content (courses,
 * catalogue, exercises) is readable by anyone, no login. The `.register-reference`
 * wrapper pins the light + teal palette by CONTEXT, independent of the visitor's
 * game-theme (dark/light) toggle.
 */
export const Route = createFileRoute("/_public")({
  component: PublicLayout,
});

function PublicLayout() {
  usePublicContentProtection();
  return (
    <div className="register-reference flex min-h-screen flex-col bg-background text-foreground">
      <PublicHeader />
      <main className="flex-1">
        <Outlet />
      </main>
      <PublicFooter />
      <PrintMark />
    </div>
  );
}

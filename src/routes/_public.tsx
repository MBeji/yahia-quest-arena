import { createFileRoute, Outlet } from "@tanstack/react-router";
import { PublicHeader } from "@/components/public/public-header";
import { PublicFooter } from "@/components/public/public-footer";

/**
 * Public coquille. UNLIKE `_authenticated`, this layout has NO auth guard: its
 * content (courses, catalogue, exercises) is readable by anyone, no login. The
 * public pages now follow the SAME dark (noir/gold) / light game theme as the rest
 * of the app, driven by the global theme switcher in the header — there is no longer
 * a separate, context-pinned palette here.
 */
export const Route = createFileRoute("/_public")({
  component: PublicLayout,
});

function PublicLayout() {
  return (
    <div className="flex min-h-screen flex-col bg-background text-foreground">
      <PublicHeader />
      <main className="flex-1">
        <Outlet />
      </main>
      <PublicFooter />
    </div>
  );
}

import { createFileRoute, redirect } from "@tanstack/react-router";

/**
 * « Découvrir » converged onto the public official-programme catalogue
 * (`/programme`) — chantier L2.A (GAP-046). The circular hub (ProgramHub) and its
 * category page were removed; this legacy path is a permanent (301) redirect so
 * old links/bookmarks and in-app navigation resolve. `beforeLoad` runs before the
 * `_authenticated` guard (a component-level effect), so an anonymous visitor lands
 * on the public catalogue, not on login.
 */
export const Route = createFileRoute("/_authenticated/themes")({
  beforeLoad: () => {
    throw redirect({ to: "/programme", statusCode: 301, replace: true });
  },
});

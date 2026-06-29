import { createFileRoute, redirect } from "@tanstack/react-router";

/**
 * Legacy program-family category page — converged onto the public catalogue
 * (`/programme`) in chantier L2.A (GAP-046). The 5-family granularity is dropped
 * (the public IA is programme + extras), so every family slug now resolves to the
 * single catalogue via a permanent (301) redirect. `beforeLoad` runs before the
 * `_authenticated` guard, so it never bounces an anonymous visitor to login.
 */
export const Route = createFileRoute("/_authenticated/themes_/$familyId")({
  beforeLoad: () => {
    throw redirect({ to: "/programme", statusCode: 301, replace: true });
  },
});

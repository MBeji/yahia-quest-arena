import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Flame, Loader2 } from "lucide-react";
import { BackLink } from "@/components/ui/back-link";

import { useMyRole } from "@/features/auth";
import {
  getEngagementOverview,
  getReturnOverview,
  EngagementAdmin,
  ReturnBlock,
} from "@/features/dashboard";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/admin/engagement")({
  head: () => ({ meta: [{ title: "Engagement · Na9ra Nal3ab" }] }),
  component: AdminEngagementPage,
});

/**
 * Console « Engagement » (étude 31 lot 1) — read-only, admin seulement.
 *
 * Le `isAdmin` client n'est PAS le contrôle d'accès : il évite d'afficher un écran
 * qui échouera. La porte autoritaire est `admin_engagement_overview()`, SECURITY
 * DEFINER, qui refuse tout non-admin côté serveur. Même câblage que
 * `/admin/economie`.
 */
function AdminEngagementPage() {
  const t = useT();
  const { role, isAdmin } = useMyRole();
  const fetchOverview = useServerFn(getEngagementOverview);

  const overviewQuery = useQuery({
    queryKey: ["admin-engagement-overview"],
    enabled: isAdmin,
    queryFn: () => fetchOverview(),
  });

  // Étude 40 lot 0 — lecture SÉPARÉE : le bloc « Le retour » a ses propres états, et sa panne
  // n'emporte pas le reste de la console.
  const fetchReturn = useServerFn(getReturnOverview);
  const returnQuery = useQuery({
    queryKey: ["admin-return-overview"],
    enabled: isAdmin,
    queryFn: () => fetchReturn(),
  });

  if (role !== null && !isAdmin) {
    return (
      <div className="mx-auto max-w-2xl px-6 py-12 text-center">
        <h1 className="font-display text-2xl font-bold">{t.subscription.accessDenied}</h1>
        <Link
          to="/dashboard"
          className="mt-4 inline-block text-sm text-[color:var(--gold)] hover:underline"
        >
          {t.common.backToHall}
        </Link>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-6 py-10">
      <BackLink to="/dashboard">{t.common.backToHall}</BackLink>

      <h1 className="flex items-center gap-2 font-display text-2xl font-bold">
        <Flame className="h-6 w-6 text-[color:var(--gold)]" aria-hidden="true" />
        Engagement
      </h1>
      <p className="mt-1 text-sm text-muted-foreground">
        Qui revient, et ce que ça coûte à l'apprentissage. Lecture seule — cette page mesure, elle
        ne règle rien.
      </p>

      <div className="mt-8">
        {overviewQuery.isPending && (
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <Loader2 className="h-4 w-4 animate-spin" /> Calcul des indicateurs…
          </div>
        )}
        {overviewQuery.isError && (
          <p className="text-sm text-destructive" data-testid="eng-error">
            Impossible de charger les indicateurs d'engagement.
          </p>
        )}
        {overviewQuery.data && (
          <EngagementAdmin
            data={overviewQuery.data}
            returnBlock={
              <ReturnBlock
                data={returnQuery.data}
                isPending={returnQuery.isPending}
                isError={returnQuery.isError}
              />
            }
          />
        )}
      </div>
    </div>
  );
}

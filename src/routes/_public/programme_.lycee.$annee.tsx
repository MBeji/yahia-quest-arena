import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff, Compass } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { useT } from "@/lib/i18n";
import { getParcours, lyceeYearOf, useParcoursInterest } from "@/features/dashboard";
import { useAuth } from "@/features/auth";
import {
  LyceeYearSections,
  type CatalogueParcours,
} from "@/features/dashboard/components/parcours-catalogue";

/**
 * Public lycée year page — the sections of ONE secondary year (étude 16 D-5,
 * R-2: one tree level per screen; the catalogue's Lycée block links here).
 * Thin: fetches the same anon-capable `getParcours` catalogue (shared query
 * key) and hands the year's sections to <LyceeYearSections/>. The interest
 * counts are public (D-7); voting from here requires an account (→ /auth).
 * The `programme_` file-name segment opts OUT of nesting under `/programme`
 * (that route is a leaf, not a layout).
 */
const YEARS = ["2eme", "3eme", "bac"] as const;
type Year = (typeof YEARS)[number];

export const Route = createFileRoute("/_public/programme_/lycee/$annee")({
  head: () => ({ meta: [{ title: "Lycée · Na9ra Nal3ab" }] }),
  component: LyceeYearPage,
});

function LyceeYearPage() {
  const t = useT();
  const navigate = useNavigate();
  const { annee } = Route.useParams();
  const { user } = useAuth();
  const fetchParcours = useServerFn(getParcours);

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
  });

  const interest = useParcoursInterest({
    canVote: user != null,
    onRequireAuth: () => navigate({ to: "/auth", search: { mode: "login" } }),
  });

  if (!YEARS.includes(annee as Year)) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState icon={Compass} title={t.errors.notFoundTitle} />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.programmeLoadFailed}
          action={
            <Button variant="outline" onClick={() => refetch()}>
              {t.common.retry}
            </Button>
          }
        />
      </div>
    );
  }

  if (isLoading || !data) {
    return <LoadingState label={t.common.loading} className="min-h-[60dvh]" />;
  }

  const rows = data.parcours as CatalogueParcours[];
  const sections = rows.filter(
    (p) =>
      p.theme_id === "ecole-tn" &&
      p.grade_selectable !== false &&
      lyceeYearOf(p.grade_slug) === annee,
  );

  return <LyceeYearSections year={annee as Year} sections={sections} interest={interest} />;
}

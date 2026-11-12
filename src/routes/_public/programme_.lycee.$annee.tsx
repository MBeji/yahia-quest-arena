import { createFileRoute, notFound, useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff } from "lucide-react";
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
import { publicPageHead, seedOnServer } from "@/shared/lib/public-page-seo";
import { CatalogueNotFound } from "./-catalogue-not-found";

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

/** Le nom de chaque année, pour le `<title>` et la description de sa page. */
const YEAR_HEAD: Record<Year, string> = {
  "2eme": "2ème année secondaire",
  "3eme": "3ème année secondaire",
  bac: "Baccalauréat (4ème année secondaire)",
};

export const Route = createFileRoute("/_public/programme_/lycee/$annee")({
  // Une année qui n'existe pas (`/programme/lycee/xyz`) : HTTP 404, tranché sans
  // lecture. Sinon, rendu serveur des sections de l'année (`public-page-seo.ts`) :
  // cette page partait du serveur avec « Chargement… » — or c'est par elle seule
  // que le catalogue mène aux 15 niveaux du lycée. Derrière `import.meta.env.SSR`,
  // le préchargement sort du bundle client.
  loader: ({ params }) => {
    if (!YEARS.includes(params.annee as Year)) throw notFound();
    return import.meta.env.SSR ? seedLycee() : null;
  },
  // Un titre et une description PAR ANNÉE : les trois pages portaient le même
  // « Lycée · Na9ra Nal3ab », sans description propre.
  head: ({ params }) => {
    const year = YEAR_HEAD[params.annee as Year];
    if (!year) return { meta: [{ title: "Lycée · Na9ra Nal3ab" }] };
    return publicPageHead({
      title: `${year} — toutes les sections du lycée`,
      description: `${year} du lycée tunisien, section par section : cours, résumés et exercices corrigés, gratuits et sans inscription.`,
      path: `/programme/lycee/${params.annee}`,
    });
  },
  component: LyceeYearPage,
  notFoundComponent: () => <CatalogueNotFound />,
});

/** SSR seulement : le catalogue anonyme des niveaux. `null` en cas de panne (le client recharge). */
function seedLycee() {
  return seedOnServer("programme-lycee", async () => {
    const server = await import("@/features/dashboard/dashboard.server");
    return server.getParcours();
  });
}

function LyceeYearPage() {
  const t = useT();
  const navigate = useNavigate();
  const { annee } = Route.useParams();
  const { user } = useAuth();
  const fetchParcours = useServerFn(getParcours);

  const seed = Route.useLoaderData();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours", "catalogue"],
    queryFn: () => fetchParcours(),
    placeholderData: seed ?? undefined,
  });

  const interest = useParcoursInterest({
    canVote: user != null,
    onRequireAuth: () => navigate({ to: "/auth", search: { mode: "login" } }),
  });

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

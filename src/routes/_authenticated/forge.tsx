import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { PageShell } from "@/components/ui/page-shell";
import { EmptyState } from "@/components/ui/empty-state";
import { useT } from "@/lib/i18n";
import { getAiStudentSurfaces } from "@/features/ai/ai-access.server";
import { ForgePanel } from "@/features/ai/components/forge-panel";

/**
 * La Forge — étude 29 lot 4, US-6.
 *
 * R-1 tenue au niveau de la ROUTE : un élève dont la Forge n'est pas activée ne
 * voit pas un écran vide ni un message « demande à tes parents », il est renvoyé
 * chez lui. La page n'existe pas pour lui, exactement comme son entrée n'existe
 * pas dans le lecteur de chapitre.
 *
 * `?chapitre=` est OPTIONNEL : la page se visite depuis le tableau de bord sans
 * chapitre (on y relit ses quiz existants) ou depuis un chapitre (on en forge un
 * nouveau). C'est la double entrée que demande le §2.3.
 */
export const Route = createFileRoute("/_authenticated/forge")({
  // `validateSearch` écrit à la main, SANS zod : le validateur d'une route vit
  // dans l'arbre de routes, donc dans le chunk d'index — un `z.object()` ici y
  // fait entrer zod tout entier (+58 Ko mesurés, budget dépassé). Motif de
  // `examen.$examId` et de `quest.$exerciseId`, appris avant nous.
  validateSearch: (search: Record<string, unknown>): { chapitre?: string } =>
    typeof search.chapitre === "string" ? { chapitre: search.chapitre } : {},
  head: () => ({ meta: [{ title: "La Forge · Na9ra Nal3ab" }] }),
  component: ForgePage,
});

function ForgePage() {
  const t = useT();
  const navigate = useNavigate();
  const { chapitre } = Route.useSearch();
  const fetchSurfaces = useServerFn(getAiStudentSurfaces);

  const { data, isLoading } = useQuery({
    queryKey: ["ai-surfaces"],
    queryFn: () => fetchSurfaces(),
    staleTime: 60_000,
  });

  const allowed = data?.enabled === true && data.features.includes("forge");

  if (!isLoading && !allowed) {
    void navigate({ to: "/dashboard", replace: true });
    return null;
  }

  return (
    <PageShell width="reading" className="py-8">
      {isLoading ? (
        <EmptyState title={t.ai.forgeTitle} description={t.ai.forgeWorking} />
      ) : (
        <ForgePanel chapterId={chapitre ?? null} />
      )}
    </PageShell>
  );
}

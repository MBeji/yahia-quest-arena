import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getParcours } from "@/features/dashboard";
import type { ProgramParcours } from "@/features/dashboard";
import { ProgramHub } from "@/features/dashboard/components/program-hub";

export const Route = createFileRoute("/_authenticated/themes")({
  head: () => ({ meta: [{ title: "Découvrir · Na9ra Nal3ab" }] }),
  component: ExplorerPage,
});

/**
 * Découvrir — the circular hub of the 5 root programs, built from `getParcours`.
 * The hub is navigation-only: clicking a program opens its dedicated category
 * page (`/themes/$familyId`), where the sub-programs become interactive (enter
 * an available one, or vote for a coming-soon one). The route stays thin: data
 * here, presentation in `<ProgramHub />`.
 */
function ExplorerPage() {
  const navigate = useNavigate();
  const fetchParcours = useServerFn(getParcours);

  const { data, isPending, isError } = useQuery({
    queryKey: ["explorer-parcours"],
    queryFn: () => fetchParcours(),
  });

  const parcours = (data?.parcours as ProgramParcours[]) ?? [];

  return (
    <ProgramHub
      parcours={parcours}
      isPending={isPending}
      isError={isError}
      onOpen={(familyId) => navigate({ to: "/themes/$familyId", params: { familyId } })}
    />
  );
}

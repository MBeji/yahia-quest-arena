import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { getParcours, useParcoursInterest } from "@/features/dashboard";
import type { ProgramParcours } from "@/features/dashboard";
import { ProgramHub } from "@/features/dashboard/components/program-hub";
import { setCurrentParcours } from "@/features/auth";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/themes")({
  head: () => ({ meta: [{ title: "Découvrir · Na9ra Nal3ab" }] }),
  component: ExplorerPage,
});

/**
 * Découvrir — the circular hub of the 5 root programs, built from `getParcours`.
 * Selecting an available (sub-)parcours switches the student's active parcours
 * (`setCurrentParcours`) and lands them on the dashboard; coming-soon programs
 * (e.g. IB, not-yet-built classes) offer an interest vote instead. The route
 * stays thin: data + mutation here, presentation in `<ProgramHub />`.
 */
function ExplorerPage() {
  const t = useT();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const fetchParcours = useServerFn(getParcours);
  const saveParcours = useServerFn(setCurrentParcours);

  const { data, isPending, isError } = useQuery({
    queryKey: ["explorer-parcours"],
    queryFn: () => fetchParcours(),
  });

  const parcours = (data?.parcours as ProgramParcours[]) ?? [];
  const interest = useParcoursInterest();

  const switchMutation = useMutation({
    mutationFn: (parcoursId: string) => saveParcours({ data: { parcoursId } }),
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
        queryClient.invalidateQueries({ queryKey: ["me-role"] }),
      ]);
      navigate({ to: "/dashboard" });
    },
    onError: () => {
      toast.error(t.explorer.switchError);
    },
  });

  return (
    <ProgramHub
      parcours={parcours}
      isPending={isPending}
      isError={isError}
      isSwitching={switchMutation.isPending}
      onSelect={(id) => switchMutation.mutate(id)}
      interest={interest}
    />
  );
}

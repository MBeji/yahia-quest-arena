import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { getParcours, useParcoursInterest } from "@/features/dashboard";
import { ParcoursHub, type ParcoursHubItem } from "@/features/dashboard/components/parcours-hub";
import { setCurrentParcours } from "@/features/auth";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/themes")({
  head: () => ({ meta: [{ title: "Explorer · Na9ra Nal3ab" }] }),
  component: ExplorerPage,
});

/**
 * Explorer — the parcours hub. Lists concours prep + free exploration parcours
 * built from `getParcours`. Selecting an available card switches the student's
 * active parcours (`setCurrentParcours`) and lands them on the dashboard; this
 * doubles as the parcours switcher the app previously lacked. The route stays
 * thin: data + mutation here, presentation in `<ParcoursHub />`.
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

  const parcours = (data?.parcours as ParcoursHubItem[]) ?? [];
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
    <ParcoursHub
      parcours={parcours}
      isPending={isPending}
      isError={isError}
      isSwitching={switchMutation.isPending}
      onSelect={(id) => switchMutation.mutate(id)}
      interest={interest}
    />
  );
}

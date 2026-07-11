import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { CloudOff, Compass as CompassIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { getParcoursSubjects } from "@/features/dashboard";
import { setCurrentParcours, useAuth } from "@/features/auth";
import { ParcoursSubjects } from "@/features/dashboard/components/parcours-subjects";
import { useT } from "@/lib/i18n";

/**
 * Public level page — the subjects of one parcours/level (« Référence » register,
 * chantier C8, L1.3). Thin: fetches the parcours + its subjects (anon-capable
 * `getParcoursSubjects`). No auth guard. When signed in, it also offers to make
 * this the active parcours (`setCurrentParcours` → dashboard) — the converged
 * replacement for the removed `/themes` switch (chantier L2.A, GAP-046).
 */
export const Route = createFileRoute("/_public/niveau/$parcoursId")({
  head: () => ({ meta: [{ title: "Niveau · Na9ra Nal3ab" }] }),
  component: NiveauPage,
});

function NiveauPage() {
  const t = useT();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { parcoursId } = Route.useParams();
  const { user } = useAuth();
  const fetchParcoursSubjects = useServerFn(getParcoursSubjects);
  const saveParcours = useServerFn(setCurrentParcours);

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["parcours-subjects", parcoursId],
    queryFn: () => fetchParcoursSubjects({ data: { parcoursId } }),
  });

  // Signed-in: make this level the active parcours, then land on the dashboard
  // (same effect the removed /themes "enter" had). Anonymous: button not shown.
  const chooseMutation = useMutation({
    mutationFn: () => saveParcours({ data: { parcoursId } }),
    onSuccess: async () => {
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
        queryClient.invalidateQueries({ queryKey: ["me-role"] }),
      ]);
      navigate({ to: "/dashboard" });
    },
    onError: () => toast.error(t.explorer.switchError),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.parcoursLoadFailed}
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

  if (!data.parcours) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState icon={CompassIcon} title={t.errors.parcoursNotFound} />
      </div>
    );
  }

  return (
    <ParcoursSubjects
      parcours={data.parcours}
      subjects={data.subjects}
      isAuthenticated={user != null}
      onChoose={() => chooseMutation.mutate()}
      isChoosing={chooseMutation.isPending}
    />
  );
}

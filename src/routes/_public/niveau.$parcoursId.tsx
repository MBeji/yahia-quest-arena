import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
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

  const { data, isLoading, isError } = useQuery({
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
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Impossible de charger ce niveau.
      </div>
    );
  }

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center">
        <div className="h-9 w-9 animate-spin rounded-full border-2 border-primary border-t-transparent" />
      </div>
    );
  }

  if (!data.parcours) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Ce niveau est introuvable.
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

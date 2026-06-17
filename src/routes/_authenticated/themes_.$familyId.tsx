import { createFileRoute, redirect, useNavigate } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import {
  getParcours,
  useParcoursInterest,
  buildPrograms,
  PROGRAM_FAMILIES,
} from "@/features/dashboard";
import type { ProgramParcours } from "@/features/dashboard";
import { ProgramCategory } from "@/features/dashboard/components/program-category";
import { setCurrentParcours } from "@/features/auth";
import { useT } from "@/lib/i18n";

const FAMILY_IDS = new Set(PROGRAM_FAMILIES.map((f) => f.id));

export const Route = createFileRoute("/_authenticated/themes_/$familyId")({
  // Unknown program slug → back to the hub (no broken page).
  beforeLoad: ({ params }) => {
    if (!FAMILY_IDS.has(params.familyId)) throw redirect({ to: "/themes" });
  },
  head: () => ({ meta: [{ title: "Découvrir · Na9ra Nal3ab" }] }),
  component: CategoryPage,
});

/**
 * Dedicated category page for one root program (`/themes/$familyId`) — step 2 of
 * "Découvrir". Reuses the cached `getParcours` catalogue, rebuilds the program
 * via `buildPrograms`, and lets the student enter an available sub-parcours
 * (switches the active parcours → dashboard) or vote for a coming-soon one. Thin
 * route: data + mutation here, presentation in `<ProgramCategory />`.
 */
function CategoryPage() {
  const t = useT();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { familyId } = Route.useParams();
  const fetchParcours = useServerFn(getParcours);
  const saveParcours = useServerFn(setCurrentParcours);

  const { data, isPending, isError } = useQuery({
    queryKey: ["explorer-parcours"],
    queryFn: () => fetchParcours(),
  });

  const parcours = (data?.parcours as ProgramParcours[]) ?? [];
  const interest = useParcoursInterest();
  const program = buildPrograms(parcours).find((p) => p.id === familyId) ?? null;

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

  if (isPending) {
    return (
      <div className="mx-auto max-w-3xl p-6">
        <div className="h-64 animate-pulse rounded-2xl border border-border/50 bg-black/40" />
      </div>
    );
  }
  if (isError || !program) {
    return (
      <div className="mx-auto max-w-3xl p-6 text-center text-sm text-muted-foreground">
        {t.explorer.failedLoad}
      </div>
    );
  }

  return (
    <ProgramCategory
      program={program}
      onSelect={(id) => switchMutation.mutate(id)}
      onBack={() => navigate({ to: "/themes" })}
      interest={interest}
      isSwitching={switchMutation.isPending}
    />
  );
}

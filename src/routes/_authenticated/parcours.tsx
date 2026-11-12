import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDashboard } from "@/features/dashboard";
import { useT } from "@/lib/i18n";
import { BackLink } from "@/components/ui/back-link";
import { LoadError } from "@/components/ui/load-error";
import { JourneyMap, JourneySkeleton, buildSubjectNodes } from "@/features/parcours";
import { WaitingForNetwork, isWaitingForNetwork } from "@/components/ui/query-wait-state";

export const Route = createFileRoute("/_authenticated/parcours")({
  head: () => ({ meta: [{ title: "Parcours · Na9ra Nal3ab" }] }),
  component: ParcoursPage,
});

type ProfileRow = {
  level?: number | null;
  xp?: number | null;
  hero_class?: string | null;
};

function ParcoursPage() {
  const t = useT();
  const fetchDashboard = useServerFn(getDashboard);
  const { data, isLoading, isError, refetch, fetchStatus } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });

  // Un échec n'est pas un chargement : le squelette restait affiché sans fin.
  if (isError) {
    return (
      <LoadError title={t.dashboard.failedLoad} onRetry={() => refetch()}>
        <BackLink to="/dashboard" className="mb-0">
          {t.common.backToHall}
        </BackLink>
      </LoadError>
    );
  }

  // é38 lot 4 (R-9) : sans réseau la lecture est en PAUSE, pas en cours — le dire,
  // au lieu d'un chargement qui ne finira pas. Elle repart seule à son retour.
  if (isWaitingForNetwork({ fetchStatus, data })) {
    return <WaitingForNetwork onRetry={() => refetch()} />;
  }

  if (isLoading || !data) {
    return <JourneySkeleton />;
  }

  const profile = data.profile as ProfileRow | null;
  // `recent` arrive trié par `completed_at` décroissant : sa première ligne désigne la matière
  // la plus récemment travaillée, donc le nœud `current` (étude 22, R-11).
  const lastActivitySubjectId = data.recent?.[0]?.subject_id ?? null;
  const nodes = buildSubjectNodes(
    data.subjects,
    data.stats,
    new Set(data.premiumLockedSubjectIds ?? []),
    { starsBySubject: data.progress, lastActivitySubjectId },
  );

  return (
    <JourneyMap
      nodes={nodes}
      profile={{
        level: profile?.level ?? 1,
        xp: profile?.xp ?? 0,
        heroClass: profile?.hero_class ?? "Novice",
      }}
    />
  );
}

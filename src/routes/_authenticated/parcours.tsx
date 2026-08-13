import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDashboard } from "@/features/dashboard";
import { JourneyMap, JourneySkeleton, buildSubjectNodes } from "@/features/parcours";

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
  const fetchDashboard = useServerFn(getDashboard);
  const { data, isLoading } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });

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
    { progressBySubject: data.progress, lastActivitySubjectId },
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

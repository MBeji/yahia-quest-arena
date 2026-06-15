import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDashboard } from "@/features/dashboard";
import { JourneyMap, buildSubjectNodes } from "@/features/parcours";
import { useT } from "@/lib/i18n";

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
  const { data, isLoading } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => fetchDashboard(),
  });

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">
        {t.common.loading}
      </div>
    );
  }

  const profile = data.profile as ProfileRow | null;
  const nodes = buildSubjectNodes(
    data.subjects,
    data.stats,
    new Set(data.premiumLockedSubjectIds ?? []),
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

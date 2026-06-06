import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getDashboard } from "@/features/dashboard";
import { getSubject } from "@/features/quest";
import { SubjectPath, buildChapterNodes } from "@/features/parcours";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/parcours/$subjectId")({
  head: () => ({ meta: [{ title: "Parcours · XP Scholars" }] }),
  component: SubjectParcoursPage,
});

type ProfileRow = { level?: number | null; xp?: number | null; hero_class?: string | null };

function SubjectParcoursPage() {
  const { subjectId } = Route.useParams();
  const t = useT();
  const fetchSubject = useServerFn(getSubject);
  const fetchDashboard = useServerFn(getDashboard);

  const subjectQ = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
  });
  const dashboardQ = useQuery({ queryKey: ["dashboard"], queryFn: () => fetchDashboard() });

  if (subjectQ.isLoading || !subjectQ.data) {
    return (
      <div className="grid min-h-[60vh] place-items-center text-sm text-muted-foreground">
        {t.common.loading}
      </div>
    );
  }

  const { subject, chapters, exercises, quizPassedByChapter, bestByExercise } = subjectQ.data;
  const profile = (dashboardQ.data?.profile ?? null) as ProfileRow | null;
  const nodes = buildChapterNodes(chapters, exercises, quizPassedByChapter, bestByExercise);

  return (
    <SubjectPath
      subjectName={subject.name_fr}
      chapters={nodes}
      profile={{
        level: profile?.level ?? 1,
        xp: profile?.xp ?? 0,
        heroClass: profile?.hero_class ?? "Novice",
      }}
    />
  );
}

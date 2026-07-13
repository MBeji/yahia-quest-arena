import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { useT } from "@/lib/i18n";
import { getSubject } from "@/features/quest";
import { useAuth } from "@/features/auth";
import { SubjectHub } from "@/features/quest/components/subject-hub";

/**
 * Public subject page — « Référence » register (chantier C8). Thin: fetches the
 * subject (anon-capable) and hands it to <SubjectHub/>. No auth guard (under the
 * public `_public` coquille).
 */
export const Route = createFileRoute("/_public/matiere/$subjectId")({
  head: () => ({ meta: [{ title: "Matière · Na9ra Nal3ab" }] }),
  component: MatierePage,
});

function MatierePage() {
  const { subjectId } = Route.useParams();
  const { user } = useAuth();
  const fetchSubject = useServerFn(getSubject);
  const t = useT();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.subjectLoadFailed}
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

  return (
    <SubjectHub
      subject={data.subject}
      chapters={data.chapters}
      exercises={data.exercises}
      bestByExercise={data.bestByExercise}
      quizPassedByChapter={data.quizPassedByChapter}
      parcours={data.parcours}
      isAuthenticated={!!user}
    />
  );
}

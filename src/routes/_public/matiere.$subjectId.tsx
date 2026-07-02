import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
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
  const { data, isLoading, isError } = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-3xl px-6 py-20 text-center text-muted-foreground">
        Impossible de charger cette matière.
      </div>
    );
  }

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60dvh] place-items-center">
        <div className="h-9 w-9 animate-spin rounded-full border-2 border-primary border-t-transparent" />
      </div>
    );
  }

  return (
    <SubjectHub
      subject={data.subject}
      chapters={data.chapters}
      exercises={data.exercises}
      isAuthenticated={!!user}
    />
  );
}

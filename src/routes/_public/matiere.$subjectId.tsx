import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { SubjectHubSkeleton } from "@/features/quest/components/subject-hub-skeleton";
import { useT } from "@/lib/i18n";
import { getSubject } from "@/features/quest";
import { useAuth } from "@/features/auth";
import { SubjectHub } from "@/features/quest/components/subject-hub";
import { publicPageHead, seedOnServer } from "@/shared/lib/public-page-seo";

/**
 * Public subject page — « Référence » register (chantier C8). Thin: fetches the
 * subject (anon-capable) and hands it to <SubjectHub/>. No auth guard (under the
 * public `_public` coquille).
 */
export const Route = createFileRoute("/_public/matiere/$subjectId")({
  // Rendu serveur de la page publique (`public-page-seo.ts`) : le loader ne tourne
  // utilement qu'au SSR, où il précharge la version ANONYME de la page et calcule
  // son <head> ; le composant la montre en `placeholderData` jusqu'à ce que sa
  // propre requête réponde. Derrière `import.meta.env.SSR`, ce code (et son
  // `<head>`) sort du bundle client — le loader y rend `null`.
  loader: ({ params }) => (import.meta.env.SSR ? seedMatiere(params.subjectId) : null),
  head: ({ loaderData }) => loaderData?.head ?? { meta: [{ title: "Matière · Na9ra Nal3ab" }] },
  component: MatierePage,
});

/** SSR seulement : le sommaire anonyme de la matière et son <head>. */
async function seedMatiere(subjectId: string) {
  const data = await seedOnServer("matiere", async () => {
    const server = await import("@/features/quest/quest.server");
    return server.getSubject({ data: { subjectId } });
  });
  if (!data?.subject) return null;
  const { subject, parcours, chapters } = data;
  const chapterTitles = chapters.map((c) => c.title).join(" · ");
  const head = publicPageHead({
    title: parcours ? `${subject.name_fr} — ${parcours.name_fr}` : subject.name_fr,
    description:
      subject.description || `Cours, résumés et exercices corrigés, gratuits : ${chapterTitles}`,
    path: `/matiere/${subjectId}`,
  });
  return { data, head };
}

function MatierePage() {
  const { subjectId } = Route.useParams();
  const { user } = useAuth();
  const fetchSubject = useServerFn(getSubject);
  const t = useT();
  const seed = Route.useLoaderData();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["subject", subjectId],
    queryFn: () => fetchSubject({ data: { subjectId } }),
    placeholderData: seed?.data,
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
    return <SubjectHubSkeleton />;
  }

  return (
    <SubjectHub
      subject={data.subject}
      chapters={data.chapters}
      exercises={data.exercises}
      progress={data.progress}
      quizPassedByChapter={data.quizPassedByChapter}
      parcours={data.parcours}
      recall={data.recall}
      isAuthenticated={!!user}
      unrestricted={data.viewer.unrestricted}
    />
  );
}

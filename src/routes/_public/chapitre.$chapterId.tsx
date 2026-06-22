import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { getChapterLesson } from "@/features/quest";
import { LessonReader } from "@/features/quest/components/lesson-reader";

/**
 * Public course reader route — « Référence » register (chantier C8). Thin: fetches
 * the chapter (anon-capable) and hands it to <LessonReader/>. No auth guard — it
 * lives under the public `_public` coquille.
 */
export const Route = createFileRoute("/_public/chapitre/$chapterId")({
  head: () => ({ meta: [{ title: "Cours · Na9ra Nal3ab" }] }),
  component: ChapitrePage,
});

function ChapitrePage() {
  const { chapterId } = Route.useParams();
  const fetchLesson = useServerFn(getChapterLesson);
  const { data, isLoading } = useQuery({
    queryKey: ["lesson", chapterId],
    queryFn: () => fetchLesson({ data: { chapterId } }),
  });

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center">
        <div className="h-9 w-9 animate-spin rounded-full border-2 border-primary border-t-transparent" />
      </div>
    );
  }

  return (
    <LessonReader chapterId={chapterId} chapter={data.chapter} allChapters={data.allChapters} />
  );
}

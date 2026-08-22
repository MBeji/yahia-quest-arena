import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useEffect, useState } from "react";
import { CloudOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { LoadingState } from "@/components/ui/loading-state";
import { useT } from "@/lib/i18n";
import { getChapterLesson } from "@/features/quest";
import { hasPassedChapterQuiz } from "@/features/quest/anon-quiz-gate";
import { useAuth } from "@/features/auth";
// Import DIRECT, pas via le barrel : `@/features/ai` réexporte la console
// parent et le lecteur de quiz forgé, et cette route est PUBLIQUE — passer
// par le barrel les ferait entrer dans le chunk d'entrée, que tout visiteur
// télécharge (budget `index-`, +58 Ko mesurés).
import { ForgeEntry } from "@/features/ai/components/forge-entry";
import { PageShell } from "@/components/ui/page-shell";
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
  const { user, loading: authLoading } = useAuth();
  const fetchLesson = useServerFn(getChapterLesson);
  const t = useT();
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["lesson", chapterId],
    queryFn: () => fetchLesson({ data: { chapterId } }),
  });

  // Anonymous pass state lives in sessionStorage (anon-quiz-gate) — read it
  // after mount only, so SSR and the first client render agree.
  const [anonQuizPassed, setAnonQuizPassed] = useState(false);
  useEffect(() => {
    if (!user && data?.quizGated) setAnonQuizPassed(hasPassedChapterQuiz(chapterId));
  }, [user, data?.quizGated, chapterId]);

  if (isError) {
    return (
      <div className="mx-auto max-w-md px-6 py-20">
        <EmptyState
          icon={CloudOff}
          title={t.errors.chapterLoadFailed}
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

  // While the chapter's comprehension quiz is still to pass for THIS visitor
  // (signed-in: server truth; anonymous: session state), the reader's single
  // CTA targets the quiz — never a locked exercise (étude 15, audit §D-4).
  const quizPassed = user ? data.quizPassed === true : anonQuizPassed;
  const quizCta =
    data.quizGated && !quizPassed && data.quizExerciseId
      ? { exerciseId: data.quizExerciseId }
      : null;

  return (
    <>
      <LessonReader
        chapterId={chapterId}
        chapter={data.chapter}
        allChapters={data.allChapters}
        practiceExerciseId={data.practiceExerciseId}
        quizCta={quizCta}
        isAuthenticated={!!user}
        authLoading={authLoading}
      />
      {/* La Forge, atteignable « depuis le hub d'un chapitre » (étude 29 §2.1).
          L'entrée est montée ici, dans la ROUTE, et non dans `LessonReader` :
          une feature n'en importe pas une autre, et c'est la route qui sait déjà
          qui regarde. Elle rend `null` pour un visiteur anonyme comme pour un
          élève dont la Forge n'est pas activée (R-1) — pas de bouton grisé, pas
          de « bientôt ». */}
      <PageShell width="reading" className="pb-8">
        <ForgeEntry chapterId={chapterId} authenticated={!!user} />
      </PageShell>
    </>
  );
}

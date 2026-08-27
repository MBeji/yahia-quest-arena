import { createFileRoute } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { useCallback, useEffect, useState } from "react";
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
// Même raison, même précaution : import direct du seul composant utilisé.
import { TutorChatPanel } from "@/features/tutor/components/tutor-chat-panel";
import { PageShell } from "@/components/ui/page-shell";
import { LessonReader } from "@/features/quest/components/lesson-reader";

/**
 * Public course reader route — « Référence » register (chantier C8). Thin: fetches
 * the chapter (anon-capable) and hands it to <LessonReader/>. No auth guard — it
 * lives under the public `_public` coquille.
 */
export const Route = createFileRoute("/_public/chapitre/$chapterId")({
  // `validateSearch` écrit à la main, SANS zod : le validateur vit dans l'arbre
  // de routes, donc dans le chunk d'index — un `z.object()` ici y ferait entrer
  // zod tout entier. Motif de `forge` et de `quest.$exerciseId`.
  //
  // `?chat=1` vient de la bulle IA : elle amène l'élève ici POUR discuter, et le
  // panneau s'ouvre donc déplié au lieu de lui demander un second clic. C'est une
  // INTENTION — le panneau la prend, puis `dropChatIntent` la retire de l'URL.
  validateSearch: (search: Record<string, unknown>): { chat?: boolean } =>
    search.chat === 1 || search.chat === "1" || search.chat === true ? { chat: true } : {},
  head: () => ({ meta: [{ title: "Cours · Na9ra Nal3ab" }] }),
  component: ChapitrePage,
});

function ChapitrePage() {
  const { chapterId } = Route.useParams();
  const { chat: openChat } = Route.useSearch();
  const navigate = Route.useNavigate();
  const { user, loading: authLoading } = useAuth();

  /**
   * `?chat=1` est une INTENTION, pas un état : elle vaut une fois, et le panneau
   * la consomme. On la retire donc de l'URL dès qu'il l'a prise — sans quoi le
   * clic SUIVANT sur la bulle produirait une adresse identique, donc aucune
   * navigation, donc plus rien du tout (c'est la panne du 2026-08-27, un cran
   * plus loin). `resetScroll: false` parce que ce retrait ne déplace personne :
   * le panneau vient précisément d'amener l'élève jusqu'à lui.
   *
   * C'est le PANNEAU qui déclenche ce retrait, jamais un effet d'ici : tant que
   * la session n'est pas résolue il n'est pas monté, et une intention retirée
   * avant qu'il existe serait une intention perdue.
   */
  const dropChatIntent = useCallback(() => {
    void navigate({ search: {}, replace: true, resetScroll: false });
  }, [navigate]);
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
        {/* Le chat du tuteur (é11 lot 3, US-8). Monté ici pour la même raison
            que la Forge juste au-dessus : c'est la ROUTE qui sait qui regarde,
            et une feature n'en importe pas une autre. Un visiteur anonyme n'a
            pas de tuteur et n'en voit pas la trace (R-1) ; un élève dont la
            porte est fermée par une épreuve en cours lit POURQUOI, en une
            phrase — le panneau ne disparaît plus sans un mot. */}
        {user ? (
          <TutorChatPanel
            chapterId={chapterId}
            openIntent={openChat === true}
            onIntentHandled={dropChatIntent}
          />
        ) : null}
      </PageShell>
    </>
  );
}

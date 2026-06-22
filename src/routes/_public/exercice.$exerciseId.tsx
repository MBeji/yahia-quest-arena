import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ArrowLeft } from "lucide-react";
import { getExercise, checkAnswersPublic } from "@/features/quest";
import { useAuth } from "@/features/auth";
import {
  PracticeExercise,
  type PracticeQuestion,
} from "@/features/quest/components/practice-exercise";
import type { BaseOption } from "@/shared/lib/question-utils";

/**
 * Public practice page — « mode entraînement » (Référence register, chantier C8,
 * L1.5). Thin: loads the exercise + questions (anon-capable `getExercise`), and
 * hands the public `checkAnswersPublic` caller to <PracticeExercise/>. No auth
 * guard (under `_public`). The comprehension quiz is the connected gate — it is
 * NOT practiceable here (the RPC refuses it); shown as an account prompt.
 */
export const Route = createFileRoute("/_public/exercice/$exerciseId")({
  head: () => ({ meta: [{ title: "Entraînement · Na9ra Nal3ab" }] }),
  component: ExercicePage,
});

function ExercicePage() {
  const { exerciseId } = Route.useParams();
  const { user } = useAuth();
  const fetchExercise = useServerFn(getExercise);
  const check = useServerFn(checkAnswersPublic);

  const { data, isLoading, isError } = useQuery({
    queryKey: ["exercise", exerciseId],
    queryFn: () => fetchExercise({ data: { exerciseId } }),
  });

  if (isError) {
    return (
      <div className="mx-auto max-w-2xl px-6 py-20 text-center text-muted-foreground">
        Impossible de charger cet exercice.
      </div>
    );
  }

  if (isLoading || !data) {
    return (
      <div className="grid min-h-[60vh] place-items-center">
        <div className="h-9 w-9 animate-spin rounded-full border-2 border-primary border-t-transparent" />
      </div>
    );
  }

  const ex = data.exercise;
  const subjectId = (ex.subject_id as string | null) ?? null;

  // The comprehension quiz is the connected gate (the public RPC refuses to
  // correct it). Invite to play it with an account rather than fake-practice it.
  if ((ex.mode as string) === "quiz") {
    return (
      <div className="mx-auto max-w-xl px-6 py-16 text-center">
        <h1 className="font-display text-2xl font-bold">Quiz de compréhension</h1>
        <p className="mt-3 text-sm text-muted-foreground">
          Ce quiz fait partie du parcours de jeu. Crée un compte pour le passer et débloquer les
          quêtes de ce chapitre.
        </p>
        <Link
          to="/signup"
          className="mt-5 inline-flex items-center gap-1.5 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
        >
          Créer mon compte
        </Link>
        {subjectId && (
          <div className="mt-4">
            <Link
              to="/matiere/$subjectId"
              params={{ subjectId }}
              className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
            >
              <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> Retour à la matière
            </Link>
          </div>
        )}
      </div>
    );
  }

  const questions: PracticeQuestion[] = data.questions.map((q) => ({
    id: q.id,
    prompt: q.prompt,
    options: (q.options as BaseOption[]) ?? [],
  }));

  return (
    <PracticeExercise
      exercise={{
        id: ex.id,
        title: ex.title,
        subject_id: subjectId,
        subjects: (ex.subjects as { content_language?: string | null } | null) ?? null,
      }}
      questions={questions}
      isAuthenticated={!!user}
      checkAnswers={(payload) => check({ data: payload })}
    />
  );
}

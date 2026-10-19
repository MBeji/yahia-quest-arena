import { Link } from "@tanstack/react-router";
import { BookOpen, Brain, HelpCircle, Lock } from "lucide-react";
import type { ReactNode } from "react";

import { ChapterSteps } from "@/components/guide/chapter-steps";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { useGuideT } from "@/lib/i18n/guide";
import { QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { LOCKED_CHAPTER_STEPS, fillGuideText } from "@/shared/lib/guide";
import type { exerciseRouteFor } from "../exercise-route";

/**
 * Une mission encore fermée par le quiz de compréhension du chapitre.
 *
 * Avant : un `<li>` muet — cadenas, titre, « — ». Un élève (ou un parent) qui
 * touchait la ligne ne voyait rien se passer et ne savait pas pourquoi. La ligne
 * est désormais un bouton : elle dit POURQUOI elle est fermée, montre les 3
 * étapes, et mène en un tap au cours ou au quiz qui l'ouvrira.
 */
export function LockedMissionRow({
  exerciseId,
  title,
  titleNode,
  chapterId,
  quizExerciseId,
  exerciseTo,
}: {
  exerciseId: string;
  /** Le titre en texte brut, pour le lecteur d'écran. */
  title: string;
  /** Le titre tel que la liste l'affiche (direction, troncature). */
  titleNode: ReactNode;
  chapterId: string;
  quizExerciseId: string | null;
  exerciseTo: ReturnType<typeof exerciseRouteFor>;
}) {
  const t = useGuideT();
  return (
    <li>
      <Popover>
        <PopoverTrigger asChild>
          <button
            type="button"
            data-testid={`locked-mission-${exerciseId}`}
            aria-label={fillGuideText(t.guide.locked.aria, { title })}
            // Pas d'opacité sur muted-foreground : le jeton EST déjà le cran
            // atténué, le diluer faisait tomber le texte sous le contraste AA.
            className="flex w-full items-center gap-2 py-2.5 text-start text-sm text-muted-foreground transition hover:text-foreground [@media(pointer:coarse)]:min-h-11"
          >
            <Lock className="h-3.5 w-3.5 shrink-0" aria-hidden="true" />
            {titleNode}
            <span className="inline-flex shrink-0 items-center gap-1 text-xs font-semibold text-primary">
              <HelpCircle className="h-3.5 w-3.5" aria-hidden="true" />
              {t.guide.locked.why}
            </span>
          </button>
        </PopoverTrigger>
        <PopoverContent className="w-80 text-sm" data-testid="locked-mission-explainer">
          <p className="font-display font-bold">🔒 {t.guide.locked.title}</p>
          <p className="mt-1.5 leading-relaxed text-muted-foreground">
            {fillGuideText(t.guide.locked.body, { pct: QUIZ_PASS_THRESHOLD_PCT })}
          </p>
          <ChapterSteps states={LOCKED_CHAPTER_STEPS} className="mt-3" />
          <div className="mt-3 grid gap-2">
            <Link
              to="/chapitre/$chapterId"
              params={{ chapterId }}
              className="flex items-center justify-center gap-2 rounded-lg border border-primary/40 px-3 py-2 font-semibold text-primary transition hover:bg-primary/10 [@media(pointer:coarse)]:min-h-11"
            >
              <BookOpen className="h-4 w-4" aria-hidden="true" /> {t.guide.locked.readCourse}
            </Link>
            {quizExerciseId && (
              <Link
                to={exerciseTo}
                params={{ exerciseId: quizExerciseId }}
                data-testid="locked-mission-take-quiz"
                className="flex items-center justify-center gap-2 rounded-lg bg-primary px-3 py-2 font-semibold text-primary-foreground transition hover:opacity-90 [@media(pointer:coarse)]:min-h-11"
              >
                <Brain className="h-4 w-4" aria-hidden="true" /> {t.guide.locked.takeQuiz}
              </Link>
            )}
          </div>
        </PopoverContent>
      </Popover>
    </li>
  );
}

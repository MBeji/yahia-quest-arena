import { Link } from "@tanstack/react-router";
import { BookOpen, Lock } from "lucide-react";

/**
 * Shown when a chapter's comprehension quiz must be passed before its exercises
 * unlock — the gate is enforced server-side in `startExerciseSession`, the route
 * just reflects the rejection. Purely presentational: the route owns the trigger
 * condition and supplies already-localized copy so this stays i18n-agnostic.
 */
export function QuizLockScreen({
  title,
  body,
  reviewLabel,
  backLabel,
  chapterId,
  subjectId,
  rtl,
}: {
  title: string;
  body: string;
  reviewLabel: string;
  backLabel: string;
  chapterId: string | null;
  subjectId: string | null;
  rtl: boolean;
}) {
  return (
    <div className="mx-auto max-w-md px-6 py-16 text-center" dir={rtl ? "rtl" : undefined}>
      <div className="rounded-3xl border border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/5 p-8">
        <Lock className="mx-auto h-12 w-12 text-[color:var(--neon-gold)]" />
        <h1 className="mt-4 font-display text-2xl font-bold">{title}</h1>
        <p className="mt-3 text-sm text-muted-foreground">{body}</p>
        <div className="mt-6 flex flex-wrap justify-center gap-3">
          {chapterId && (
            <Link
              to="/chapitre/$chapterId"
              params={{ chapterId }}
              className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-5 py-2.5 text-sm font-bold text-black shadow-gold hover:scale-105"
            >
              <BookOpen className="h-4 w-4" /> {reviewLabel}
            </Link>
          )}
          {subjectId && (
            <Link
              to="/subject/$subjectId"
              params={{ subjectId }}
              className="rounded-lg border border-border bg-black/50 px-5 py-2.5 text-sm font-semibold hover:bg-black/80"
            >
              {backLabel}
            </Link>
          )}
        </div>
      </div>
    </div>
  );
}

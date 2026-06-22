import { Link } from "@tanstack/react-router";
import { BookOpen, ChevronRight, Zap } from "lucide-react";
import { isRtlText } from "@/shared/lib/utils";

export type SubjectHubSubject = {
  name_fr: string;
  attribute: string | null;
  description: string | null;
  content_language?: string | null;
};

export type SubjectHubChapter = {
  id: string;
  title: string;
  description: string | null;
};

export type SubjectHubExercise = {
  id: string;
  chapter_id: string;
  mode: string;
  title: string;
  difficulty: number;
  xp_reward: number;
};

/**
 * Public subject hub — « Référence » register (chantier C8). Presentational: the
 * route fetches the subject (anon-capable `getSubject`, L0.4b). Lists chapters
 * (each → its public course reader) and their exercises. No gameplay progress
 * (stars/streaks are the connected Jeu register, L2) and no premium locks (the
 * pivot is free; anon `getSubject` already returns `hasEntitlement: true`).
 * Exercise links are auth-aware (L1.5): a signed-in visitor goes to the scored
 * quest (`/quest`, XP); an anonymous one goes to free practice (`/exercice`).
 * The comprehension quiz is always the connected gate (`/quest`).
 * i18n keys land in the L1.6 sweep; copy is FR literals here.
 */
export function SubjectHub({
  subject,
  chapters,
  exercises,
  isAuthenticated,
}: {
  subject: SubjectHubSubject;
  chapters: SubjectHubChapter[];
  exercises: SubjectHubExercise[];
  isAuthenticated: boolean;
}) {
  const isRtl = subject.content_language === "ar";

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6" dir={isRtl ? "rtl" : "ltr"}>
      <header className="mb-8">
        {subject.attribute && (
          <div className="text-xs font-semibold uppercase tracking-[0.2em] text-primary">
            {subject.attribute}
          </div>
        )}
        <h1
          className="mt-1 font-display text-3xl font-bold leading-tight sm:text-4xl"
          dir={isRtlText(subject.name_fr) ? "rtl" : "ltr"}
        >
          {subject.name_fr}
        </h1>
        {subject.description && <p className="mt-2 text-muted-foreground">{subject.description}</p>}
      </header>

      <div className="space-y-6">
        {chapters.map((c, ci) => {
          const chapEx = exercises.filter((e) => e.chapter_id === c.id);
          return (
            <section key={c.id} className="rounded-2xl border border-border bg-card p-5">
              <div className="text-xs font-bold uppercase tracking-wider text-primary">
                Chapitre {ci + 1}
              </div>
              <h2
                className="mt-1 font-display text-xl font-bold"
                dir={isRtlText(c.title) ? "rtl" : "ltr"}
              >
                {c.title}
              </h2>
              {c.description && (
                <p
                  className="mt-1 text-sm text-muted-foreground"
                  dir={isRtlText(c.description) ? "rtl" : "ltr"}
                >
                  {c.description}
                </p>
              )}
              <Link
                to="/chapitre/$chapterId"
                params={{ chapterId: c.id }}
                className="mt-3 inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition hover:opacity-90"
              >
                <BookOpen className="h-4 w-4" /> Lire le cours
              </Link>

              {chapEx.length > 0 && (
                <ul className="mt-4 divide-y divide-border border-t border-border">
                  {chapEx.map((ex) => {
                    // Auth-aware: signed-in → scored quest (XP); anon → free
                    // practice. The comprehension quiz stays the connected gate.
                    const exerciseTo =
                      ex.mode === "quiz" || isAuthenticated
                        ? "/quest/$exerciseId"
                        : "/exercice/$exerciseId";
                    return (
                      <li key={ex.id}>
                        <Link
                          to={exerciseTo}
                          params={{ exerciseId: ex.id }}
                          className="flex items-center justify-between gap-3 py-2.5 text-sm transition hover:text-primary"
                        >
                          <span className="truncate" dir={isRtlText(ex.title) ? "rtl" : "ltr"}>
                            {ex.mode === "quiz" ? "🧠 " : ""}
                            {ex.title}
                          </span>
                          <span className="flex shrink-0 items-center gap-2 text-xs text-muted-foreground">
                            <span>Niv. {ex.difficulty}</span>
                            <span className="flex items-center gap-0.5 text-primary">
                              <Zap className="h-3 w-3" />
                              {ex.xp_reward}
                            </span>
                            <ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
                          </span>
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              )}
            </section>
          );
        })}
      </div>
    </div>
  );
}

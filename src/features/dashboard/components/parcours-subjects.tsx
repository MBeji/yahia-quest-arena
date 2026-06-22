import { Link } from "@tanstack/react-router";
import { ArrowLeft, BookOpen, ChevronRight } from "lucide-react";
import { isRtlText } from "@/shared/lib/utils";

/**
 * Public level page — « Référence » register (chantier C8, L1.3). Presentational: the
 * route fetches a parcours + its subjects (anon `getParcoursSubjects`). Lists the
 * subjects of one level/track, each → its public subject hub (`/matiere/$subjectId`).
 * A `coming_soon` (or otherwise empty) parcours shows a "bientôt" state. No gameplay
 * and no premium lock (free pivot). FR literals here → i18n sweep in L1.6.
 */

export type ParcoursSubjectsParcours = {
  name_fr: string;
  status: string;
  kind: string;
};

export type ParcoursSubjectsSubject = {
  id: string;
  name_fr: string;
  attribute: string | null;
  description: string | null;
  content_language?: string | null;
};

export function ParcoursSubjects({
  parcours,
  subjects,
}: {
  parcours: ParcoursSubjectsParcours;
  subjects: ParcoursSubjectsSubject[];
}) {
  const isExtra = parcours.kind === "libre";

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link
        to={isExtra ? "/extras" : "/programme"}
        className="inline-flex items-center gap-1.5 text-sm font-medium text-muted-foreground transition hover:text-primary"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {isExtra ? "Extras" : "Programme"}
      </Link>

      <header className="mb-8 mt-3">
        <h1
          className="font-display text-3xl font-bold leading-tight sm:text-4xl"
          dir={isRtlText(parcours.name_fr) ? "rtl" : "ltr"}
        >
          {parcours.name_fr}
        </h1>
        <p className="mt-2 text-muted-foreground">
          Choisis une matière pour lire le cours, réviser le résumé et t’entraîner.
        </p>
      </header>

      {subjects.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border bg-card p-8 text-center">
          <p className="font-display text-lg font-bold">Contenu bientôt disponible</p>
          <p className="mt-1 text-sm text-muted-foreground">
            Ce niveau est en cours de préparation. Reviens bientôt&nbsp;!
          </p>
        </div>
      ) : (
        <ul className="grid gap-3 sm:grid-cols-2">
          {subjects.map((s) => (
            <li key={s.id}>
              <Link
                to="/matiere/$subjectId"
                params={{ subjectId: s.id }}
                className="flex h-full items-center gap-3 rounded-2xl border border-border bg-card p-4 transition hover:border-primary/60 hover:shadow-sm"
              >
                <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-secondary text-primary">
                  <BookOpen className="h-5 w-5" />
                </span>
                <span className="min-w-0 flex-1">
                  <span
                    className="block truncate font-display text-base font-bold"
                    dir={isRtlText(s.name_fr) ? "rtl" : "ltr"}
                  >
                    {s.name_fr}
                  </span>
                  {s.attribute && (
                    <span className="block truncate text-xs text-muted-foreground">
                      {s.attribute}
                    </span>
                  )}
                </span>
                <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground rtl:-scale-x-100" />
              </Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

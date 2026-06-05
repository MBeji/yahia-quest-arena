import { createFileRoute, Link } from "@tanstack/react-router";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { motion } from "motion/react";
import {
  GraduationCap,
  Globe,
  Brain,
  HeartPulse,
  Languages,
  Sword,
  BookOpen,
  Scroll,
  Leaf,
  Calculator,
  Atom,
  Trophy,
  ChevronRight,
  ChevronLeft,
} from "lucide-react";
import { getThemes, getGradesByTheme, getSubjects } from "@/features/dashboard";

export const Route = createFileRoute("/_authenticated/themes")({
  head: () => ({ meta: [{ title: "Thèmes · XP Scholars" }] }),
  component: ThemesPage,
});

type Theme = {
  id: string;
  name_fr: string;
  description: string | null;
  icon: string;
  color_token: string;
  content_language: string;
  has_grades: boolean;
};

type Grade = {
  id: string;
  slug: string;
  name_fr: string;
  cycle: string | null;
  is_concours_national: boolean;
};

type Subject = {
  id: string;
  name_fr: string;
  icon: string;
  color_token: string;
  theme_id: string;
  grade_id: string | null;
};

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  GraduationCap,
  Globe,
  Brain,
  HeartPulse,
  Languages,
  Sword,
  BookOpen,
  Scroll,
  Leaf,
  Calculator,
  Atom,
};

/** Resolve a CSS colour variable from a stored `color_token` (e.g. "subject-math"
 * or bare "math") → always "--subject-<base>", matching SubjectPathCard. */
const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;

function PanelSkeleton() {
  return (
    <div className="grid gap-3 sm:grid-cols-2">
      {[0, 1, 2, 3].map((i) => (
        <div
          key={i}
          className="h-24 animate-pulse rounded-2xl border border-border/50 bg-black/50"
        />
      ))}
    </div>
  );
}

function ThemesPage() {
  const fetchThemes = useServerFn(getThemes);
  const fetchGrades = useServerFn(getGradesByTheme);
  const fetchSubjects = useServerFn(getSubjects);

  const [theme, setTheme] = useState<Theme | null>(null);
  const [grade, setGrade] = useState<Grade | null>(null);

  const themesQuery = useQuery({
    queryKey: ["themes"],
    queryFn: () => fetchThemes(),
  });

  const gradesQuery = useQuery({
    queryKey: ["theme-grades", theme?.id],
    queryFn: () => fetchGrades({ data: { themeId: theme!.id } }),
    enabled: !!theme && theme.has_grades,
  });

  // Subjects load once a leaf is reached: a theme without grades, or a chosen grade.
  const subjectsReady = !!theme && (!theme.has_grades || !!grade);
  const subjectsQuery = useQuery({
    queryKey: ["theme-subjects", theme?.id, grade?.id ?? null],
    queryFn: () =>
      fetchSubjects({
        data: { themeId: theme!.id, ...(grade ? { gradeId: grade.id } : {}) },
      }),
    enabled: subjectsReady,
  });

  const themes: Theme[] = (themesQuery.data?.themes as Theme[]) ?? [];
  const grades: Grade[] = (gradesQuery.data?.grades as Grade[]) ?? [];
  const subjects: Subject[] = (subjectsQuery.data?.subjects as Subject[]) ?? [];

  const resetToThemes = () => {
    setTheme(null);
    setGrade(null);
  };

  return (
    <div className="mx-auto max-w-5xl p-6">
      {/* Breadcrumb */}
      <div className="mb-6 flex items-center gap-2 text-sm text-muted-foreground">
        <button onClick={resetToThemes} className="transition hover:text-foreground">
          Thèmes
        </button>
        {theme && (
          <>
            <ChevronRight className="h-3 w-3" />
            <button
              onClick={() => setGrade(null)}
              className={theme.has_grades ? "transition hover:text-foreground" : ""}
            >
              {theme.name_fr}
            </button>
          </>
        )}
        {grade && (
          <>
            <ChevronRight className="h-3 w-3" />
            <span className="text-foreground">{grade.name_fr}</span>
          </>
        )}
      </div>

      {/* Level 1 — themes */}
      {!theme && (
        <section className="space-y-6">
          <div>
            <h1 className="font-display text-3xl font-bold">Explore les thèmes</h1>
            <p className="mt-2 text-muted-foreground">
              Choisis un univers d'apprentissage pour commencer.
            </p>
          </div>
          {themesQuery.isPending ? (
            <PanelSkeleton />
          ) : themesQuery.isError ? (
            <p className="text-sm text-muted-foreground">Impossible de charger les thèmes.</p>
          ) : (
            <div className="grid gap-4 sm:grid-cols-2">
              {themes.map((th) => {
                const Icon = ICONS[th.icon] ?? Globe;
                const color = colorVar(th.color_token);
                return (
                  <motion.button
                    key={th.id}
                    onClick={() => {
                      setTheme(th);
                      setGrade(null);
                    }}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    className="group relative overflow-hidden rounded-2xl border border-border/50 bg-black/60 p-5 text-left backdrop-blur-md transition hover:-translate-y-1 hover:border-[color:var(--gold)]/60"
                  >
                    <div
                      className="absolute -right-8 -top-8 h-28 w-28 rounded-full opacity-50 blur-2xl transition-opacity group-hover:opacity-90"
                      style={{ background: color }}
                    />
                    <div className="relative flex items-start justify-between">
                      <Icon className="h-8 w-8" style={{ color }} />
                      <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
                    </div>
                    <div className="relative mt-4 font-display text-lg font-bold">{th.name_fr}</div>
                    {th.description && (
                      <p className="relative mt-1 text-sm text-muted-foreground">
                        {th.description}
                      </p>
                    )}
                  </motion.button>
                );
              })}
            </div>
          )}
        </section>
      )}

      {/* Level 2 — grades (school-program theme only) */}
      {theme && theme.has_grades && !grade && (
        <section className="space-y-6">
          <div className="flex items-center gap-3">
            <button
              onClick={resetToThemes}
              className="rounded-lg border border-border/50 p-2 transition hover:border-[color:var(--gold)]/60"
            >
              <ChevronLeft className="h-4 w-4" />
            </button>
            <h1 className="font-display text-2xl font-bold">Choisis ton niveau</h1>
          </div>
          {gradesQuery.isPending ? (
            <PanelSkeleton />
          ) : (
            <div className="grid gap-3 sm:grid-cols-3">
              {grades.map((g) => (
                <motion.button
                  key={g.id}
                  onClick={() => setGrade(g)}
                  whileHover={{ scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                  className="flex items-center justify-between gap-2 rounded-xl border border-border/50 bg-black/60 p-4 text-left transition hover:border-[color:var(--gold)]/60"
                >
                  <span className="flex items-center gap-2 font-display font-bold">
                    <GraduationCap className="h-5 w-5 text-[color:var(--gold)]" />
                    {g.name_fr}
                  </span>
                  {g.is_concours_national && (
                    <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-xs font-semibold text-[color:var(--gold)]">
                      <Trophy className="h-3 w-3" /> Concours
                    </span>
                  )}
                </motion.button>
              ))}
            </div>
          )}
        </section>
      )}

      {/* Level 3 — subjects */}
      {subjectsReady && (
        <section className="space-y-6">
          <div className="flex items-center gap-3">
            <button
              onClick={() => (theme!.has_grades ? setGrade(null) : resetToThemes())}
              className="rounded-lg border border-border/50 p-2 transition hover:border-[color:var(--gold)]/60"
            >
              <ChevronLeft className="h-4 w-4" />
            </button>
            <h1 className="font-display text-2xl font-bold">Matières</h1>
          </div>
          {subjectsQuery.isPending ? (
            <PanelSkeleton />
          ) : subjects.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              Aucune matière disponible pour ce niveau pour le moment.
            </p>
          ) : (
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {subjects.map((s) => {
                const Icon = ICONS[s.icon] ?? Sword;
                const color = colorVar(s.color_token);
                return (
                  <Link
                    key={s.id}
                    to="/subject/$subjectId"
                    params={{ subjectId: s.id }}
                    className="group relative overflow-hidden rounded-2xl border border-border/50 bg-black/60 p-5 backdrop-blur-md transition hover:-translate-y-1 hover:border-[color:var(--gold)]/60"
                  >
                    <div
                      className="absolute -right-8 -top-8 h-24 w-24 rounded-full opacity-50 blur-2xl transition-opacity group-hover:opacity-90"
                      style={{ background: color }}
                    />
                    <div className="relative flex items-start justify-between">
                      <Icon className="h-8 w-8" style={{ color }} />
                      <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
                    </div>
                    <div className="relative mt-4 font-display text-lg font-bold">{s.name_fr}</div>
                  </Link>
                );
              })}
            </div>
          )}
        </section>
      )}
    </div>
  );
}

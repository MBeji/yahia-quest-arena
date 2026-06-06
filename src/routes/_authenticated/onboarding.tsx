import { createFileRoute, useRouter, Link } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import {
  ChevronRight,
  ChevronLeft,
  Play,
  Award,
  Brain,
  Flame,
  GraduationCap,
  Trophy,
} from "lucide-react";
import { getDashboard, getGradesByTheme } from "@/features/dashboard";
import { setCurrentGrade } from "@/features/auth";

/** Root theme that carries the Tunisian school grade ladder. */
const SCHOOL_THEME_ID = "ecole-tn";

type DifficultyLevel = "easy" | "hard" | "challenge";

type OnboardingSubject = {
  id: string;
  name_fr: string;
  description: string;
  color_token: string;
};

type Grade = {
  id: string;
  slug: string;
  name_fr: string;
  cycle: string | null;
  is_concours_national: boolean;
};

function OnboardingGradeStep({
  grades,
  isPending,
  isError,
  selectedId,
  onSelect,
  onNext,
  isSaving,
}: {
  grades: Grade[];
  isPending: boolean;
  isError: boolean;
  selectedId: string | null;
  onSelect: (id: string) => void;
  onNext: () => void;
  isSaving: boolean;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Quelle est ta classe ?</h2>
        <p className="mt-2 text-muted-foreground">
          Programme scolaire tunisien — tu pourras explorer les autres thèmes ensuite.
        </p>
      </div>

      {isPending ? (
        <div className="grid gap-3 sm:grid-cols-2">
          {[0, 1, 2, 3, 4, 5].map((i) => (
            <div
              key={i}
              className="h-16 animate-pulse rounded-xl border-2 border-[color:var(--gold)]/30 bg-black/50"
            />
          ))}
        </div>
      ) : isError ? (
        <div className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-8 text-center text-sm text-muted-foreground">
          Impossible de charger les niveaux. Réessaie plus tard.
        </div>
      ) : grades.length === 0 ? (
        <div className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-8 text-center text-sm text-muted-foreground">
          Aucun niveau disponible pour le moment.
        </div>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2">
          {grades.map((grade) => {
            const isSelected = selectedId === grade.id;
            return (
              <motion.button
                key={grade.id}
                onClick={() => onSelect(grade.id)}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className={`flex items-center justify-between gap-2 rounded-xl border-2 p-4 text-left transition-all ${
                  isSelected
                    ? "border-[color:var(--gold)] bg-[color:var(--gold)]/10"
                    : "border-[color:var(--gold)]/30 bg-black/50 hover:border-[color:var(--gold)]/60"
                }`}
              >
                <span className="flex items-center gap-2 font-display font-bold">
                  <GraduationCap className="h-5 w-5 text-[color:var(--gold)]" />
                  {grade.name_fr}
                </span>
                {grade.is_concours_national && (
                  <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-xs font-semibold text-[color:var(--gold)]">
                    <Trophy className="h-3 w-3" /> Concours
                  </span>
                )}
              </motion.button>
            );
          })}
        </div>
      )}

      <div className="flex gap-3">
        <Button onClick={onNext} disabled={!selectedId || isSaving} className="ml-auto gap-2">
          {isSaving ? "Enregistrement…" : "Suivant"} <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </motion.div>
  );
}

interface SubjectCardProps {
  id: string;
  name: string;
  description: string;
  color: string;
  icon: React.ReactNode;
  onClick: () => void;
  isSelected: boolean;
}

function SubjectCard({
  id,
  name,
  description,
  color,
  icon,
  onClick,
  isSelected,
}: SubjectCardProps) {
  return (
    <motion.button
      onClick={onClick}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      className={`relative rounded-2xl border-2 p-6 text-left transition-all ${
        isSelected
          ? ""
          : "border-[color:var(--gold)]/30 bg-black/50 hover:border-[color:var(--gold)]/60"
      }`}
      style={
        isSelected
          ? {
              borderColor: color,
              background: `color-mix(in oklab, ${color} 15%, transparent)`,
            }
          : undefined
      }
    >
      <div className="flex items-start gap-4">
        <div
          className="rounded-xl p-3"
          style={{ background: `color-mix(in oklab, ${color} 20%, transparent)` }}
        >
          {icon}
        </div>
        <div className="flex-1">
          <h3 className="font-display text-lg font-bold">{name}</h3>
          <p className="mt-1 text-sm text-muted-foreground">{description}</p>
        </div>
      </div>
      {isSelected && (
        <motion.div
          layoutId="selected"
          className="absolute inset-0 rounded-2xl border-2"
          style={{ borderColor: color }}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
        />
      )}
    </motion.button>
  );
}

function OnboardingStep1({
  subjects,
  isPending,
  isError,
  selectedId,
  onSelect,
  onNext,
  onPrev,
}: {
  subjects: OnboardingSubject[];
  isPending: boolean;
  isError: boolean;
  selectedId: string | null;
  onSelect: (id: string) => void;
  onNext: () => void;
  onPrev: () => void;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Choisis ta matière préférée</h2>
        <p className="mt-2 text-muted-foreground">Commence par ce qui t'intéresse le plus!</p>
      </div>

      {isPending ? (
        <div className="grid gap-4 sm:grid-cols-2">
          {[0, 1, 2, 3].map((i) => (
            <div
              key={i}
              className="h-[104px] animate-pulse rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50"
            />
          ))}
        </div>
      ) : isError ? (
        <div className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-8 text-center text-sm text-muted-foreground">
          Impossible de charger les matières. Réessaie plus tard.
        </div>
      ) : subjects.length === 0 ? (
        <div className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-8 text-center text-sm text-muted-foreground">
          Aucune matière disponible pour le moment.
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2">
          {subjects.map((subject) => (
            <SubjectCard
              key={subject.id}
              id={subject.id}
              name={subject.name_fr}
              description={subject.description}
              color={`var(--${subject.color_token})`}
              icon={<Play className="h-6 w-6" />}
              onClick={() => onSelect(subject.id)}
              isSelected={selectedId === subject.id}
            />
          ))}
        </div>
      )}

      <div className="flex gap-3">
        <Button onClick={onPrev} variant="outline" className="gap-2">
          <ChevronLeft className="h-4 w-4" /> Retour
        </Button>
        <Button onClick={onNext} disabled={!selectedId} className="ml-auto gap-2">
          Suivant <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </motion.div>
  );
}

function OnboardingStep2({
  onPrev,
  onNext,
}: {
  onPrev: () => void;
  onNext: (difficulty: DifficultyLevel) => void;
}) {
  const [difficulty, setDifficulty] = useState<DifficultyLevel | null>(null);

  const difficulties = [
    {
      id: "easy",
      label: "Facile",
      description: "Parfait pour commencer",
      icon: <Brain className="h-8 w-8" />,
      color: "var(--gold)",
    },
    {
      id: "hard",
      label: "Difficile",
      description: "Mets-toi au défi!",
      icon: <Flame className="h-8 w-8" />,
      color: "var(--neon-gold)",
    },
    {
      id: "challenge",
      label: "Extrême",
      description: "Pour les champions",
      icon: <Award className="h-8 w-8" />,
      color: "var(--gold)",
    },
  ] as const;

  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Quel est ton niveau?</h2>
        <p className="mt-2 text-muted-foreground">Tu peux toujours changer après!</p>
      </div>

      <div className="grid gap-4">
        {difficulties.map((diff) => (
          <motion.button
            key={diff.id}
            onClick={() => setDifficulty(diff.id)}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className={`rounded-2xl border-2 p-6 text-left transition-all ${
              difficulty === diff.id
                ? ""
                : "border-[color:var(--gold)]/30 bg-black/50 hover:border-[color:var(--gold)]/60"
            }`}
            style={
              difficulty === diff.id
                ? {
                    borderColor: diff.color,
                    background: `color-mix(in oklab, ${diff.color} 15%, transparent)`,
                  }
                : undefined
            }
          >
            <div className="flex items-center gap-4">
              <div style={{ color: diff.color }}>{diff.icon}</div>
              <div>
                <h3 className="font-display text-xl font-bold">{diff.label}</h3>
                <p className="text-sm text-muted-foreground">{diff.description}</p>
              </div>
            </div>
          </motion.button>
        ))}
      </div>

      <div className="flex gap-3">
        <Button onClick={onPrev} variant="outline" className="gap-2">
          <ChevronLeft className="h-4 w-4" /> Retour
        </Button>
        <Button
          onClick={() => difficulty && onNext(difficulty)}
          disabled={!difficulty}
          className="ml-auto gap-2"
        >
          Suivant <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </motion.div>
  );
}

function OnboardingStep3({
  selectedSubject,
  difficulty,
  onPrev,
}: {
  selectedSubject?: OnboardingSubject;
  difficulty: DifficultyLevel | null;
  onPrev: () => void;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Prêt à commencer?</h2>
        <p className="mt-2 text-muted-foreground">Ton premier exercice t'attend!</p>
      </div>

      <Card className="border-[color:var(--gold)]/30 bg-[color:var(--gold)]/5 p-8">
        <div className="space-y-4 text-center">
          <div className="text-4xl">🚀</div>
          <div>
            <h3 className="font-display text-xl font-bold">{selectedSubject?.name_fr}</h3>
            <p className="mt-1 text-sm text-muted-foreground">
              Niveau:{" "}
              {difficulty === "easy" ? "Facile" : difficulty === "hard" ? "Difficile" : "Extrême"}
            </p>
          </div>
        </div>
      </Card>

      <p className="text-center text-sm text-muted-foreground">
        Tu gagneras des points XP, des pièces, et tu débloquereras des badges au fur et à mesure! 🎮
      </p>

      <div className="flex gap-3">
        <Button onClick={onPrev} variant="outline" className="gap-2">
          <ChevronLeft className="h-4 w-4" /> Retour
        </Button>
        <Link
          to="/dashboard"
          className="ml-auto inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-6 py-2 font-semibold text-black transition hover:opacity-90"
        >
          Commencer <Play className="h-4 w-4" />
        </Link>
      </div>
    </motion.div>
  );
}

export const Route = createFileRoute("/_authenticated/onboarding")({
  component: OnboardingComponent,
});

function OnboardingComponent() {
  const router = useRouter();
  const [step, setStep] = useState(1);
  const [selectedGrade, setSelectedGrade] = useState<string | null>(null);
  const [selectedSubject, setSelectedSubject] = useState<string | null>(null);
  const [difficulty, setDifficulty] = useState<DifficultyLevel | null>(null);

  const fetchDashboard = useServerFn(getDashboard);
  const fetchGrades = useServerFn(getGradesByTheme);
  const saveGrade = useServerFn(setCurrentGrade);

  // Step 1: school grades (Tunisian ladder).
  const {
    data: gradesData,
    isPending: gradesPending,
    isError: gradesError,
  } = useQuery({
    queryKey: ["onboarding-grades", SCHOOL_THEME_ID],
    queryFn: () => fetchGrades({ data: { themeId: SCHOOL_THEME_ID } }),
  });

  // Step 2: subjects.
  const {
    data: dashboardData,
    isPending: subjectsPending,
    isError: subjectsError,
  } = useQuery({
    queryKey: ["dashboard-onboarding"],
    queryFn: () => fetchDashboard(),
  });

  const gradeMutation = useMutation({
    mutationFn: (gradeId: string) => saveGrade({ data: { gradeId } }),
  });

  const grades: Grade[] = (gradesData?.grades as Grade[]) ?? [];
  const subjects: OnboardingSubject[] = (dashboardData?.subjects as OnboardingSubject[]) ?? [];

  const handleGradeNext = async () => {
    if (selectedGrade) {
      // Persist the chosen grade; non-blocking so a transient failure never traps
      // the student in onboarding.
      try {
        await gradeMutation.mutateAsync(selectedGrade);
      } catch {
        /* swallow — proceed regardless */
      }
    }
    setStep(2);
  };

  const handleNext = (val?: DifficultyLevel) => {
    if (step === 2) {
      setStep(3);
    } else if (step === 3) {
      setDifficulty(val ?? null);
      setStep(4);
    }
  };

  const handlePrev = () => {
    if (step > 1) setStep(step - 1);
  };

  return (
    <div className="min-h-screen bg-black-deep p-6">
      <div className="mx-auto max-w-2xl">
        {/* Progress indicator */}
        <div className="mb-12 flex gap-2">
          {[1, 2, 3, 4].map((i) => (
            <motion.div
              key={i}
              className={`h-1 flex-1 rounded-full transition-colors ${
                i <= step ? "bg-[color:var(--gold)]" : "bg-muted/50"
              }`}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
            />
          ))}
        </div>

        {/* Content */}
        <AnimatePresence mode="wait">
          {step === 1 && (
            <OnboardingGradeStep
              key="grade"
              grades={grades}
              isPending={gradesPending}
              isError={gradesError}
              selectedId={selectedGrade}
              onSelect={setSelectedGrade}
              onNext={handleGradeNext}
              isSaving={gradeMutation.isPending}
            />
          )}
          {step === 2 && (
            <OnboardingStep1
              key="step1"
              subjects={subjects}
              isPending={subjectsPending}
              isError={subjectsError}
              selectedId={selectedSubject}
              onSelect={setSelectedSubject}
              onNext={() => handleNext()}
              onPrev={handlePrev}
            />
          )}
          {step === 3 && <OnboardingStep2 key="step2" onPrev={handlePrev} onNext={handleNext} />}
          {step === 4 && (
            <OnboardingStep3
              key="step3"
              selectedSubject={subjects.find((s) => s.id === selectedSubject)}
              difficulty={difficulty}
              onPrev={handlePrev}
            />
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

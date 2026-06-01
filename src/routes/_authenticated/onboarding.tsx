import { createFileRoute, useRouter, Link } from "@tanstack/react-router";
import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { ChevronRight, ChevronLeft, Play, Award, Brain, Flame } from "lucide-react";
import { getDashboard } from "@/lib/gamification.dashboard";

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
      className={`relative rounded-2xl p-6 text-left transition-all ${
        isSelected
          ? `border-2 border-[${color}] bg-[${color}]/15`
          : "border-2 border-slate-700 bg-slate-800/50 hover:border-slate-600"
      }`}
    >
      <div className="flex items-start gap-4">
        <div className={`rounded-xl bg-[${color}]/20 p-3`}>{icon}</div>
        <div className="flex-1">
          <h3 className="font-display text-lg font-bold">{name}</h3>
          <p className="mt-1 text-sm text-slate-400">{description}</p>
        </div>
      </div>
      {isSelected && (
        <motion.div
          layoutId="selected"
          className={`absolute inset-0 rounded-2xl border-2 border-[${color}]`}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
        />
      )}
    </motion.button>
  );
}

function OnboardingStep1({ subjects, selectedId, onSelect, onNext }: any) {
  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Choisis ta matière préférée</h2>
        <p className="mt-2 text-slate-400">Commence par ce qui t'intéresse le plus!</p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        {subjects.map((subject: any) => (
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

      <div className="flex gap-3">
        <Button onClick={onNext} disabled={!selectedId} className="ml-auto gap-2">
          Suivant <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </motion.div>
  );
}

function OnboardingStep2({ selectedSubject, onPrev, onNext }: any) {
  const [difficulty, setDifficulty] = useState<"easy" | "hard" | "challenge" | null>(null);

  const difficulties = [
    {
      id: "easy",
      label: "Facile",
      description: "Parfait pour commencer",
      icon: <Brain className="h-8 w-8" />,
      color: "var(--neon-cyan)",
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
      color: "var(--neon-violet)",
    },
  ];

  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Quel est ton niveau?</h2>
        <p className="mt-2 text-slate-400">Tu peux toujours changer après!</p>
      </div>

      <div className="grid gap-4">
        {difficulties.map((diff: any) => (
          <motion.button
            key={diff.id}
            onClick={() => setDifficulty(diff.id)}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className={`rounded-2xl border-2 p-6 text-left transition-all ${
              difficulty === diff.id
                ? `border-[${diff.color}] bg-[${diff.color}]/15`
                : "border-slate-700 bg-slate-800/50 hover:border-slate-600"
            }`}
          >
            <div className="flex items-center gap-4">
              <div style={{ color: diff.color }}>{diff.icon}</div>
              <div>
                <h3 className="font-display text-xl font-bold">{diff.label}</h3>
                <p className="text-sm text-slate-400">{diff.description}</p>
              </div>
            </div>
          </motion.button>
        ))}
      </div>

      <div className="flex gap-3">
        <Button onClick={onPrev} variant="outline" className="gap-2">
          <ChevronLeft className="h-4 w-4" /> Retour
        </Button>
        <Button onClick={() => onNext(difficulty)} disabled={!difficulty} className="ml-auto gap-2">
          Suivant <ChevronRight className="h-4 w-4" />
        </Button>
      </div>
    </motion.div>
  );
}

function OnboardingStep3({ selectedSubject, difficulty, onPrev, onComplete }: any) {
  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">Prêt à commencer?</h2>
        <p className="mt-2 text-slate-400">Ton premier exercice t'attend!</p>
      </div>

      <Card className="border-[color:var(--neon-cyan)]/30 bg-[color:var(--neon-cyan)]/5 p-8">
        <div className="space-y-4 text-center">
          <div className="text-4xl">🚀</div>
          <div>
            <h3 className="font-display text-xl font-bold">{selectedSubject?.name_fr}</h3>
            <p className="mt-1 text-sm text-slate-400">
              Niveau:{" "}
              {difficulty === "easy" ? "Facile" : difficulty === "hard" ? "Difficile" : "Extrême"}
            </p>
          </div>
        </div>
      </Card>

      <p className="text-center text-sm text-slate-400">
        Tu gagneras des points XP, des pièces, et tu débloquereras des badges au fur et à mesure! 🎮
      </p>

      <div className="flex gap-3">
        <Button onClick={onPrev} variant="outline" className="gap-2">
          <ChevronLeft className="h-4 w-4" /> Retour
        </Button>
        <Link
          to="/dashboard"
          className="ml-auto inline-flex items-center gap-2 rounded-lg bg-[color:var(--neon-cyan)] px-6 py-2 font-semibold text-slate-950 transition hover:bg-[color:var(--neon-cyan)]/90"
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
  const [selectedSubject, setSelectedSubject] = useState<string | null>(null);
  const [difficulty, setDifficulty] = useState<"easy" | "hard" | "challenge" | null>(null);

  // Fetch subjects for step 1
  const fetchDashboard = useServerFn(getDashboard);
  const { data: dashboardData } = useQuery({
    queryKey: ["dashboard-onboarding"],
    queryFn: () => fetchDashboard(),
  });

  const subjects = dashboardData?.subjects ?? [];

  const handleNext = (val?: any) => {
    if (step === 1) {
      setStep(2);
    } else if (step === 2) {
      setDifficulty(val);
      setStep(3);
    }
  };

  const handlePrev = () => {
    if (step > 1) setStep(step - 1);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 p-6">
      <div className="mx-auto max-w-2xl">
        {/* Progress indicator */}
        <div className="mb-12 flex gap-2">
          {[1, 2, 3].map((i) => (
            <motion.div
              key={i}
              className={`h-1 flex-1 rounded-full transition-colors ${
                i <= step ? "bg-[color:var(--neon-cyan)]" : "bg-slate-700"
              }`}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
            />
          ))}
        </div>

        {/* Content */}
        <AnimatePresence mode="wait">
          {step === 1 && (
            <OnboardingStep1
              key="step1"
              subjects={subjects}
              selectedId={selectedSubject}
              onSelect={setSelectedSubject}
              onNext={handleNext}
            />
          )}
          {step === 2 && (
            <OnboardingStep2
              key="step2"
              selectedSubject={selectedSubject}
              onPrev={handlePrev}
              onNext={handleNext}
            />
          )}
          {step === 3 && (
            <OnboardingStep3
              key="step3"
              selectedSubject={subjects.find((s: any) => s.id === selectedSubject)}
              difficulty={difficulty}
              onPrev={handlePrev}
            />
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  ChevronRight,
  ChevronLeft,
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
  Compass,
  Clock,
} from "lucide-react";
import { getParcours, useParcoursInterest, ParcoursInterestButton } from "@/features/dashboard";
import type { ParcoursInterestState } from "@/features/dashboard";
import { setCurrentParcours } from "@/features/auth";
import { useT } from "@/lib/i18n";

type Parcours = {
  id: string;
  name_fr: string;
  kind: string;
  is_premium: boolean;
  status: string;
  display_order: number;
  icon: string;
  color: string;
  theme_id: string;
  grade_id: string | null;
  grade_cycle: string | null;
  grade_order: number | null;
};

/** Order school cycles primaire → collège → secondaire for display. */
const CYCLE_ORDER = ["primaire", "college", "secondaire"] as const;

type Intent = "concours" | "explorer";

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

/** Resolve a CSS colour variable from a stored `color` token (e.g. "subject-math"
 * or bare "math") → always "--subject-<base>", matching the rest of the app. */
const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;

// ---------------------------------------------------------------------------
// Step 0 — "Que veux-tu faire ?": pick an intent.
// ---------------------------------------------------------------------------
function IntentStep({ onSelect }: { onSelect: (intent: Intent) => void }) {
  const t = useT();
  const choices: {
    id: Intent;
    title: string;
    description: string;
    icon: React.ReactNode;
    color: string;
  }[] = [
    {
      id: "concours",
      title: t.onboarding.concoursTitle,
      description: t.onboarding.concoursDesc,
      icon: <Trophy className="h-8 w-8" />,
      color: "var(--gold)",
    },
    {
      id: "explorer",
      title: t.onboarding.exploreTitle,
      description: t.onboarding.exploreDesc,
      icon: <Compass className="h-8 w-8" />,
      color: "var(--gold)",
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
        <h2 className="font-display text-3xl font-bold">{t.onboarding.intentTitle}</h2>
        <p className="mt-2 text-muted-foreground">{t.onboarding.intentSubtitle}</p>
      </div>

      <div className="grid gap-4">
        {choices.map((choice) => (
          <motion.button
            key={choice.id}
            onClick={() => onSelect(choice.id)}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-6 text-start transition-all hover:border-[color:var(--gold)]/60"
          >
            <div className="flex items-center gap-4">
              <div
                className="rounded-xl p-3"
                style={{ background: `color-mix(in oklab, ${choice.color} 20%, transparent)` }}
              >
                <span style={{ color: choice.color }}>{choice.icon}</span>
              </div>
              <div className="flex-1">
                <h3 className="font-display text-xl font-bold">{choice.title}</h3>
                <p className="mt-1 text-sm text-muted-foreground">{choice.description}</p>
              </div>
              <ChevronRight className="h-5 w-5 text-[color:var(--gold)] rtl:-scale-x-100" />
            </div>
          </motion.button>
        ))}
      </div>
    </motion.div>
  );
}

// ---------------------------------------------------------------------------
// Step 1 — pick a specific parcours filtered by the chosen intent.
// ---------------------------------------------------------------------------
function ParcoursCard({
  parcours,
  isSaving,
  onSelect,
  interest,
}: {
  parcours: Parcours;
  isSaving: boolean;
  onSelect: () => void;
  interest?: ParcoursInterestState;
}) {
  const t = useT();
  const Icon = ICONS[parcours.icon] ?? Sword;
  const color = colorVar(parcours.color);
  const isComingSoon = parcours.status === "coming_soon";

  const header = (
    <div className="flex items-start gap-4">
      <div
        className="rounded-xl p-3"
        style={{ background: `color-mix(in oklab, ${color} 20%, transparent)` }}
      >
        <Icon className="h-6 w-6" style={{ color }} />
      </div>
      <div className="flex-1">
        <div className="flex flex-wrap items-center gap-2">
          <h3 className="font-display text-lg font-bold">{parcours.name_fr}</h3>
          {isComingSoon && (
            <span className="inline-flex items-center gap-1 rounded-full bg-muted/40 px-2 py-0.5 text-xs font-semibold text-muted-foreground">
              <Clock className="h-3 w-3" /> {t.parcoursInterest.underConstruction}
            </span>
          )}
        </div>
      </div>
      {!isComingSoon && (
        <ChevronRight className="h-5 w-5 shrink-0 text-[color:var(--gold)] rtl:-scale-x-100" />
      )}
    </div>
  );

  // Coming-soon: a non-selectable <div> hosting the interest <button> (valid
  // markup — a real button can't nest inside the selectable motion.button).
  if (isComingSoon) {
    return (
      <div className="relative rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-6 text-start">
        {header}
        {interest && (
          <ParcoursInterestButton
            count={interest.counts[parcours.id] ?? 0}
            interested={interest.mine.has(parcours.id)}
            isPending={interest.togglingId === parcours.id}
            onToggle={() => interest.onToggle(parcours.id)}
          />
        )}
      </div>
    );
  }

  return (
    <motion.button
      onClick={onSelect}
      disabled={isSaving}
      whileHover={isSaving ? undefined : { scale: 1.02 }}
      whileTap={isSaving ? undefined : { scale: 0.98 }}
      aria-label={parcours.name_fr}
      className="relative w-full rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-6 text-start transition-all hover:border-[color:var(--gold)]/60 disabled:opacity-60"
    >
      {header}
    </motion.button>
  );
}

function ParcoursStep({
  intent,
  parcours,
  isPending,
  isError,
  isSaving,
  onSelect,
  onPrev,
  interest,
}: {
  intent: Intent;
  parcours: Parcours[];
  isPending: boolean;
  isError: boolean;
  isSaving: boolean;
  onSelect: (id: string) => void;
  onPrev: () => void;
  interest: ParcoursInterestState;
}) {
  const t = useT();
  const cycleLabel = (cycle: string) =>
    cycle === "primaire"
      ? t.cycles.primaire
      : cycle === "college"
        ? t.cycles.college
        : t.cycles.secondaire;

  // School intent → the full ladder (concours + regular years), grouped by cycle
  // and ordered 1ère année → Bac. Explore intent → free libre themes (flat).
  const isSchool = intent === "concours";
  const school = parcours
    .filter((p) => p.kind === "concours" || p.kind === "scolaire")
    .sort((a, b) => (a.grade_order ?? 0) - (b.grade_order ?? 0));
  const libre = parcours.filter((p) => p.kind === "libre" && p.status === "available");
  const visible = isSchool ? school : libre;

  const schoolByCycle = CYCLE_ORDER.map((cycle) => ({
    cycle,
    items: school.filter((p) => p.grade_cycle === cycle),
  })).filter((g) => g.items.length > 0);

  return (
    <motion.div
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="space-y-6"
    >
      <div>
        <h2 className="font-display text-3xl font-bold">
          {isSchool ? t.onboarding.parcoursTitleConcours : t.onboarding.parcoursTitleLibre}
        </h2>
        <p className="mt-2 text-muted-foreground">
          {isSchool ? t.onboarding.parcoursSubtitleConcours : t.onboarding.parcoursSubtitleLibre}
        </p>
      </div>

      {isPending ? (
        <div className="grid gap-4">
          {[0, 1, 2].map((i) => (
            <div
              key={i}
              className="h-[88px] animate-pulse rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50"
            />
          ))}
        </div>
      ) : isError ? (
        <div className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-8 text-center text-sm text-muted-foreground">
          {t.explorer.failedLoad}
        </div>
      ) : visible.length === 0 ? (
        <div className="rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-8 text-center text-sm text-muted-foreground">
          {t.explorer.empty}
        </div>
      ) : isSchool ? (
        <div className="space-y-6">
          {schoolByCycle.map((group) => (
            <div key={group.cycle} className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                {cycleLabel(group.cycle)}
              </h3>
              <div className="grid gap-4">
                {group.items.map((p) => (
                  <ParcoursCard
                    key={p.id}
                    parcours={p}
                    isSaving={isSaving}
                    onSelect={() => onSelect(p.id)}
                    interest={interest}
                  />
                ))}
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="grid gap-4">
          {visible.map((p) => (
            <ParcoursCard
              key={p.id}
              parcours={p}
              isSaving={isSaving}
              onSelect={() => onSelect(p.id)}
              interest={interest}
            />
          ))}
        </div>
      )}

      <div className="flex gap-3">
        <Button onClick={onPrev} variant="outline" className="min-h-11 gap-2" disabled={isSaving}>
          <ChevronLeft className="h-4 w-4" /> {t.common.back}
        </Button>
        {isSaving && (
          <span className="ml-auto self-center text-sm text-muted-foreground">
            {t.onboarding.saving}
          </span>
        )}
      </div>
    </motion.div>
  );
}

export const Route = createFileRoute("/_authenticated/onboarding")({
  component: OnboardingComponent,
});

function OnboardingComponent() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const t = useT();
  const [step, setStep] = useState<0 | 1>(0);
  const [intent, setIntent] = useState<Intent | null>(null);

  const fetchParcours = useServerFn(getParcours);
  const saveParcours = useServerFn(setCurrentParcours);

  const {
    data: parcoursData,
    isPending: parcoursPending,
    isError: parcoursError,
  } = useQuery({
    queryKey: ["onboarding-parcours"],
    queryFn: () => fetchParcours(),
  });

  const parcours: Parcours[] = (parcoursData?.parcours as Parcours[]) ?? [];
  const interest = useParcoursInterest();

  const selectMutation = useMutation({
    mutationFn: (parcoursId: string) => saveParcours({ data: { parcoursId } }),
    onSuccess: async () => {
      // Refresh dashboard + profile-bearing queries so the new scope is reflected,
      // then land on the dashboard.
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
        queryClient.invalidateQueries({ queryKey: ["me-role"] }),
        queryClient.invalidateQueries({ queryKey: ["me-parcours"] }),
      ]);
      navigate({ to: "/dashboard" });
    },
    onError: () => {
      // Graceful: never trap the aspirant in onboarding.
      toast.error(t.onboarding.saveError);
    },
  });

  const handleIntent = (chosen: Intent) => {
    setIntent(chosen);
    setStep(1);
  };

  return (
    <div className="min-h-[100dvh] bg-black-deep p-6">
      <div className="mx-auto max-w-2xl">
        {/* Progress indicator */}
        <div className="mb-12 flex gap-2">
          {[0, 1].map((i) => (
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
          {step === 0 && <IntentStep key="intent" onSelect={handleIntent} />}
          {step === 1 && intent && (
            <ParcoursStep
              key="parcours"
              intent={intent}
              parcours={parcours}
              isPending={parcoursPending}
              isError={parcoursError}
              isSaving={selectMutation.isPending}
              onSelect={(id) => selectMutation.mutate(id)}
              onPrev={() => setStep(0)}
              interest={interest}
            />
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useState } from "react";
import { motion, AnimatePresence, useReducedMotion } from "motion/react";
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
  Sparkles,
  Rocket,
  ArrowRight,
} from "lucide-react";
import {
  getParcours,
  useParcoursInterest,
  ParcoursInterestButton,
  buildLyceeYears,
} from "@/features/dashboard";
import type { LyceeYearGroup, ParcoursInterestState } from "@/features/dashboard";
import { setCurrentParcours } from "@/features/auth";
import { LanguageSwitcher } from "@/components/ui/language-switcher";
import { useEntrance } from "@/shared/lib/motion";
import { parcoursName } from "@/shared/lib/parcours-locale";
import { useI18n, useT } from "@/lib/i18n";

/**
 * Slide-in/out of a wizard step (AnimatePresence needs an `exit`, which the
 * shared entrance presets deliberately don't carry). Under reduced motion the
 * step renders in place and is removed instantly (no exit prop → no animation).
 */
function useStepSlide() {
  const reduced = useReducedMotion();
  if (reduced) return { initial: false as const };
  return {
    initial: { opacity: 0, x: 20 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: -20 },
  };
}

type Parcours = {
  id: string;
  name_fr: string;
  name_en?: string | null;
  name_ar?: string | null;
  kind: string;
  is_premium: boolean;
  hasEntitlement: boolean;
  status: string;
  display_order: number;
  icon: string;
  color: string;
  theme_id: string;
  grade_id: string | null;
  grade_cycle: string | null;
  grade_order: number | null;
  grade_slug: string | null;
  grade_selectable: boolean;
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
  const stepSlide = useStepSlide();
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
    <motion.div {...stepSlide} className="space-y-6">
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
  const { locale } = useI18n();
  const Icon = ICONS[parcours.icon] ?? Sword;
  const color = colorVar(parcours.color);
  const isComingSoon = parcours.status === "coming_soon";
  const label = parcoursName(parcours, locale);

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
          <h3 className="font-display text-lg font-bold">{label}</h3>
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
        {/* Option A (Q-6) : une classe en construction reste CHOISISSABLE — la RPC
            l'autorise ; l'élève atterrit sur un accueil dédié « ta classe arrive ». */}
        <button
          type="button"
          onClick={onSelect}
          disabled={isSaving}
          className="mt-3 inline-flex min-h-11 w-full items-center justify-center gap-1.5 rounded-lg border border-[color:var(--gold)]/40 py-2.5 text-xs font-bold text-[color:var(--gold)] transition hover:bg-[color:var(--gold)]/10 disabled:opacity-60"
        >
          {t.onboarding.chooseAnyway} <ArrowRight className="h-3.5 w-3.5 rtl:-scale-x-100" />
        </button>
      </div>
    );
  }

  return (
    <motion.button
      onClick={onSelect}
      disabled={isSaving}
      whileHover={isSaving ? undefined : { scale: 1.02 }}
      whileTap={isSaving ? undefined : { scale: 0.98 }}
      aria-label={label}
      className="relative w-full rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-6 text-start transition-all hover:border-[color:var(--gold)]/60 disabled:opacity-60"
    >
      {header}
    </motion.button>
  );
}

/**
 * Drill-down year card of the Secondaire cycle (étude 16 R-2): opens the
 * year's section list as a wizard sub-step — never 17 flat lycée cards.
 */
function LyceeYearCard({ group, onOpen }: { group: LyceeYearGroup; onOpen: () => void }) {
  const t = useT();
  const label =
    group.year === "2eme" ? t.lycee.year2 : group.year === "3eme" ? t.lycee.year3 : t.lycee.yearBac;
  const meta = `${t.lycee.sections.replace("{n}", String(group.sections.length))} · ${t.lycee.available.replace("{n}", String(group.available))}`;
  const Icon = group.year === "bac" ? Trophy : GraduationCap;
  return (
    <motion.button
      onClick={onOpen}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      aria-label={label}
      className="w-full rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-6 text-start transition-all hover:border-[color:var(--gold)]/60"
    >
      <div className="flex items-center gap-4">
        <div className="rounded-xl bg-[color:var(--gold)]/15 p-3">
          <Icon className="h-6 w-6 text-[color:var(--gold)]" />
        </div>
        <div className="flex-1">
          <h3 className="font-display text-lg font-bold">{label}</h3>
          <p className="mt-0.5 text-xs text-muted-foreground">{meta}</p>
        </div>
        <ChevronRight className="h-5 w-5 shrink-0 text-[color:var(--gold)] rtl:-scale-x-100" />
      </div>
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
  const stepSlide = useStepSlide();
  const cycleLabel = (cycle: string) =>
    cycle === "primaire"
      ? t.cycles.primaire
      : cycle === "college"
        ? t.cycles.college
        : t.cycles.secondaire;

  // School intent → the full ladder (concours + regular years), grouped by cycle
  // and ordered 1ère année → Bac. Explore intent → free libre themes (flat).
  // R-1 (étude 16): the flat legacy secondary nodes (grade_selectable=false)
  // never reach the picker.
  const isSchool = intent === "concours";
  const school = parcours
    .filter((p) => (p.kind === "concours" || p.kind === "scolaire") && p.grade_selectable !== false)
    .sort((a, b) => (a.grade_order ?? 0) - (b.grade_order ?? 0));
  const libre = parcours.filter((p) => p.kind === "libre" && p.status === "available");
  const visible = isSchool ? school : libre;

  const schoolByCycle = CYCLE_ORDER.map((cycle) => ({
    cycle,
    items: school.filter((p) => p.grade_cycle === cycle),
  })).filter((g) => g.items.length > 0);

  // Lycée drill-down (étude 16 R-2): the Secondaire cycle lists the 1ère
  // (direct) + one card per year; tapping a year opens its sections as a
  // wizard sub-step — one tree level per screen, mobile-first.
  const [lyceeYear, setLyceeYear] = useState<"2eme" | "3eme" | "bac" | null>(null);
  const lyceeYears = buildLyceeYears(school.filter((p) => p.grade_cycle === "secondaire"));
  const lyceeGroup = lyceeYear ? (lyceeYears.find((g) => g.year === lyceeYear) ?? null) : null;
  const lyceeYearLabel = (year: "2eme" | "3eme" | "bac") =>
    year === "2eme" ? t.lycee.year2 : year === "3eme" ? t.lycee.year3 : t.lycee.yearBac;

  return (
    <motion.div {...stepSlide} className="space-y-6">
      <div>
        <h2 className="font-display text-3xl font-bold">
          {lyceeGroup
            ? t.lycee.pickSection
            : isSchool
              ? t.onboarding.parcoursTitleConcours
              : t.onboarding.parcoursTitleLibre}
        </h2>
        <p className="mt-2 text-muted-foreground">
          {lyceeGroup
            ? lyceeYearLabel(lyceeGroup.year as "2eme" | "3eme" | "bac")
            : isSchool
              ? t.onboarding.parcoursSubtitleConcours
              : t.onboarding.parcoursSubtitleLibre}
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
      ) : isSchool && lyceeGroup ? (
        <div className="grid gap-4">
          {lyceeGroup.sections.map((p) => (
            <ParcoursCard
              key={p.id}
              parcours={p}
              isSaving={isSaving}
              onSelect={() => onSelect(p.id)}
              interest={interest}
            />
          ))}
        </div>
      ) : isSchool ? (
        <div className="space-y-6">
          {schoolByCycle.map((group) => (
            <div key={group.cycle} className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                {cycleLabel(group.cycle)}
              </h3>
              <div className="grid gap-4">
                {group.cycle === "secondaire"
                  ? lyceeYears.map((g) => {
                      const direct = g.direct;
                      return direct ? (
                        <ParcoursCard
                          key={direct.id}
                          parcours={direct}
                          isSaving={isSaving}
                          onSelect={() => onSelect(direct.id)}
                          interest={interest}
                        />
                      ) : (
                        <LyceeYearCard
                          key={g.year}
                          group={g}
                          onOpen={() => setLyceeYear(g.year as "2eme" | "3eme" | "bac")}
                        />
                      );
                    })
                  : group.items.map((p) => (
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
        <Button
          onClick={() => (lyceeGroup ? setLyceeYear(null) : onPrev())}
          variant="outline"
          className="min-h-11 gap-2"
          disabled={isSaving}
        >
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

// ---------------------------------------------------------------------------
// Step 2 — celebration + guided landing (lot 10). A coming-soon pick gets its
// own « ta classe arrive » welcome (Q-6 option A) pointing to the extras.
// ---------------------------------------------------------------------------
export function CelebrationStep({
  parcours,
  landing,
  onGo,
}: {
  parcours: Parcours | null;
  landing: string;
  onGo: (to: string) => void;
}) {
  const t = useT();
  const { locale } = useI18n();
  const stepSlide = useStepSlide();
  const isComingSoon = parcours?.status === "coming_soon";
  const label = parcours ? parcoursName(parcours, locale) : "";

  return (
    <motion.div {...stepSlide} className="space-y-6 text-center">
      <motion.div
        initial={{ scale: 0.6, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ type: "spring", stiffness: 200, damping: 15 }}
        className="mx-auto grid h-20 w-20 place-items-center rounded-3xl bg-[color:var(--gold)]/15"
      >
        {isComingSoon ? (
          <Sparkles className="h-10 w-10 text-[color:var(--gold)]" />
        ) : (
          <Rocket className="h-10 w-10 text-[color:var(--gold)]" />
        )}
      </motion.div>
      <div>
        <h2 className="font-display text-3xl font-bold">
          {isComingSoon ? t.onboarding.celebrateSoonTitle : t.onboarding.celebrateTitle}
        </h2>
        <p className="mx-auto mt-2 max-w-md text-muted-foreground">
          {(isComingSoon ? t.onboarding.celebrateSoonDesc : t.onboarding.celebrateDesc).replace(
            "{parcours}",
            label,
          )}
        </p>
      </div>
      <div className="flex flex-col gap-3">
        {isComingSoon ? (
          <>
            <Button onClick={() => onGo("/extras")} className="min-h-12 gap-2 text-base">
              {t.onboarding.celebrateExtrasCta} <ArrowRight className="h-4 w-4 rtl:-scale-x-100" />
            </Button>
            <Button onClick={() => onGo(landing)} variant="outline" className="min-h-11">
              {t.onboarding.celebrateDashboardCta}
            </Button>
          </>
        ) : (
          <Button onClick={() => onGo(landing)} className="min-h-12 gap-2 text-base">
            {t.onboarding.celebrateDashboardCta} <ArrowRight className="h-4 w-4 rtl:-scale-x-100" />
          </Button>
        )}
      </div>
    </motion.div>
  );
}

export const Route = createFileRoute("/_authenticated/onboarding")({
  // Deep-link restoration (lot 10): where to land after onboarding. Sanitised to an
  // internal path (single leading slash) so a crafted `?redirect=` can't open-redirect.
  validateSearch: (s: Record<string, unknown>): { redirect?: string } => {
    const r = typeof s.redirect === "string" ? s.redirect : "";
    return r.startsWith("/") && !r.startsWith("//") ? { redirect: r } : {};
  },
  component: OnboardingComponent,
});

function OnboardingComponent() {
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const t = useT();
  const { redirect } = Route.useSearch();
  const landing = redirect ?? "/dashboard";
  const fadeIn = useEntrance("fade");
  const [step, setStep] = useState<0 | 1 | 2>(0);
  const [intent, setIntent] = useState<Intent | null>(null);
  const [selected, setSelected] = useState<Parcours | null>(null);

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
      // then celebrate + guide the landing (lot 10) rather than a silent jump.
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: ["dashboard"] }),
        queryClient.invalidateQueries({ queryKey: ["me-role"] }),
        queryClient.invalidateQueries({ queryKey: ["me-parcours"] }),
      ]);
      setStep(2);
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
  const handleSelect = (id: string) => {
    setSelected(parcours.find((p) => p.id === id) ?? null);
    selectMutation.mutate(id);
  };

  return (
    <div className="min-h-[100dvh] bg-black-deep p-6">
      <div className="mx-auto max-w-2xl">
        {/* Promise + explicit language (lot 10): a short welcome and a language
            switch up front — a parent can set their language before choosing. */}
        <div className="mb-6 flex items-center justify-between gap-3">
          <p className="text-sm text-muted-foreground">{t.onboarding.promise}</p>
          <LanguageSwitcher />
        </div>

        {/* Progress indicator */}
        <div className="mb-10 flex gap-2">
          {[0, 1, 2].map((i) => (
            <motion.div
              key={i}
              {...fadeIn}
              className={`h-1 flex-1 rounded-full transition-colors ${
                i <= step ? "bg-[color:var(--gold)]" : "bg-muted/50"
              }`}
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
              onSelect={handleSelect}
              onPrev={() => setStep(0)}
              interest={interest}
            />
          )}
          {step === 2 && (
            <CelebrationStep
              key="celebrate"
              parcours={selected}
              landing={landing}
              onGo={(to) => navigate({ to })}
            />
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

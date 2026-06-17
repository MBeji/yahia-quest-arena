import React, { useState } from "react";
import { motion, useReducedMotion } from "motion/react";
import {
  GraduationCap,
  Languages,
  Globe,
  Brain,
  Award,
  Sparkles,
  ChevronRight,
  ChevronLeft,
  ArrowRight,
  Crown,
  Lock,
  Clock,
} from "lucide-react";
import { useT } from "@/lib/i18n";
import { useIsMobile } from "@/hooks/use-mobile";
import { buildPrograms, type Program, type ProgramParcours } from "../program-families";
import type { ParcoursInterestState } from "../use-parcours-interest";
import { ParcoursInterestButton } from "./parcours-interest-button";

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  GraduationCap,
  Languages,
  Globe,
  Brain,
  Award,
};

const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;

/** Node centres on a circle, in stage-percentage coordinates (first node at top). */
function nodePositions(n: number, radius = 34): { x: number; y: number }[] {
  return Array.from({ length: n }, (_, i) => {
    const a = ((-90 + i * (360 / n)) * Math.PI) / 180;
    return { x: 50 + radius * Math.cos(a), y: 50 + radius * Math.sin(a) };
  });
}

function ProgramNode({
  program,
  label,
  hint,
  pos,
  isActive,
  disabled,
  onActivate,
  onHover,
}: {
  program: Program;
  label: string;
  hint: string;
  pos: { x: number; y: number };
  isActive: boolean;
  disabled: boolean;
  onActivate: () => void;
  onHover: () => void;
}) {
  const Icon = ICONS[program.icon] ?? Globe;
  const color = colorVar(program.color);
  const soon = program.comingSoon;
  return (
    <motion.button
      type="button"
      onClick={disabled ? undefined : onActivate}
      onMouseEnter={disabled ? undefined : onHover}
      disabled={disabled}
      aria-label={label}
      aria-expanded={program.kind === "enter" ? undefined : isActive}
      whileHover={disabled ? undefined : { scale: 1.05 }}
      whileTap={disabled ? undefined : { scale: 0.96 }}
      className="absolute flex w-[26%] -translate-x-1/2 -translate-y-1/2 flex-col items-center gap-1.5 text-center disabled:opacity-60"
      style={{ left: `${pos.x}%`, top: `${pos.y}%` }}
    >
      <span
        className={`grid aspect-square w-[68%] place-items-center rounded-full border-2 backdrop-blur-md transition ${
          isActive ? "border-[color:var(--gold)]" : "border-border/50"
        } ${soon ? "border-dashed" : ""}`}
        style={{ background: `color-mix(in oklab, ${color} 22%, rgba(0,0,0,0.55))` }}
      >
        <Icon className="h-1/2 w-1/2" style={{ color: soon ? undefined : color }} />
      </span>
      <span className="font-display text-xs font-bold leading-tight sm:text-sm">{label}</span>
      <span className="inline-flex items-center gap-0.5 text-[10px] text-muted-foreground">
        {soon ? <Clock className="h-2.5 w-2.5" /> : null}
        {hint}
        {program.kind !== "enter" && !soon ? <ChevronRight className="h-2.5 w-2.5" /> : null}
      </span>
    </motion.button>
  );
}

/** A selectable / votable sub-parcours row inside the disclosure panel. */
function SubCard({
  parcours,
  isSwitching,
  onSelect,
  interest,
}: {
  parcours: ProgramParcours;
  isSwitching: boolean;
  onSelect: (id: string) => void;
  interest: ParcoursInterestState;
}) {
  const t = useT();
  const soon = parcours.status === "coming_soon";
  const lockedPremium = parcours.is_premium && !parcours.hasEntitlement;

  if (soon) {
    return (
      <div className="rounded-xl border border-border/50 bg-black/40 p-4">
        <div className="flex flex-wrap items-center gap-2">
          <span className="font-display text-sm font-bold">{parcours.name_fr}</span>
          <span className="inline-flex items-center gap-1 rounded-full bg-muted/40 px-2 py-0.5 text-[11px] font-semibold text-muted-foreground">
            <Clock className="h-3 w-3" /> {t.parcoursInterest.underConstruction}
          </span>
        </div>
        <ParcoursInterestButton
          count={interest.counts[parcours.id] ?? 0}
          interested={interest.mine.has(parcours.id)}
          isPending={interest.togglingId === parcours.id}
          onToggle={() => interest.onToggle(parcours.id)}
        />
      </div>
    );
  }

  return (
    <button
      type="button"
      onClick={() => onSelect(parcours.id)}
      disabled={isSwitching}
      className="flex items-center justify-between gap-2 rounded-xl border border-border/50 bg-black/40 p-4 text-left transition hover:border-[color:var(--gold)]/60 disabled:opacity-60"
    >
      <span className="flex flex-wrap items-center gap-2">
        <span className="font-display text-sm font-bold">{parcours.name_fr}</span>
        {lockedPremium ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/15 px-2 py-0.5 text-[11px] font-semibold text-[color:var(--neon-gold)]">
            <Lock className="h-3 w-3" /> {t.explorer.premium}
          </span>
        ) : parcours.is_premium ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-[11px] font-semibold text-[color:var(--gold)]">
            <Crown className="h-3 w-3" /> {t.explorer.unlocked}
          </span>
        ) : null}
      </span>
      <span className="inline-flex shrink-0 items-center gap-1 text-xs text-[color:var(--gold)]">
        {t.discover.enter} <ArrowRight className="h-4 w-4 rtl:-scale-x-100" />
      </span>
    </button>
  );
}

/** Disclosure panel: the active program's sub-parcours (languages / cycles → classes / vote). */
function DisclosurePanel({
  program,
  label,
  cycle,
  setCycle,
  isSwitching,
  onSelect,
  interest,
}: {
  program: Program;
  label: string;
  cycle: string | null;
  setCycle: (c: string | null) => void;
  isSwitching: boolean;
  onSelect: (id: string) => void;
  interest: ParcoursInterestState;
}) {
  const t = useT();
  const cycleLabel = (c: string) =>
    c === "primaire" ? t.cycles.primaire : c === "college" ? t.cycles.college : t.cycles.secondaire;

  const selectedCycle = program.cycles.find((c) => c.cycle === cycle) ?? null;

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      className="mx-auto mt-6 max-w-3xl rounded-2xl border border-[color:var(--gold)]/30 bg-black/50 p-5 backdrop-blur-md"
    >
      <div className="mb-4 flex items-center gap-2">
        {program.kind === "school" && selectedCycle ? (
          <button
            type="button"
            onClick={() => setCycle(null)}
            className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground"
          >
            <ChevronLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.discover.back}
          </button>
        ) : null}
        <h2 className="font-display text-lg font-bold">
          {label}
          {program.kind === "school" && selectedCycle
            ? ` · ${cycleLabel(selectedCycle.cycle)}`
            : ""}
        </h2>
      </div>

      {program.kind === "languages" ? (
        <div className="grid gap-3 sm:grid-cols-3">
          {program.languages.map((p) => (
            <SubCard
              key={p.id}
              parcours={p}
              isSwitching={isSwitching}
              onSelect={onSelect}
              interest={interest}
            />
          ))}
        </div>
      ) : null}

      {program.kind === "coming_soon" && program.parcours ? (
        <SubCard
          parcours={program.parcours}
          isSwitching={isSwitching}
          onSelect={onSelect}
          interest={interest}
        />
      ) : null}

      {program.kind === "school" && !selectedCycle ? (
        <div className="grid gap-3 sm:grid-cols-3">
          {program.cycles.map((c) => (
            <button
              key={c.cycle}
              type="button"
              onClick={() => setCycle(c.cycle)}
              className="flex items-center justify-between gap-2 rounded-xl border border-border/50 bg-black/40 p-4 text-left transition hover:border-[color:var(--gold)]/60"
            >
              <span className="font-display text-sm font-bold">{cycleLabel(c.cycle)}</span>
              <span className="text-xs text-muted-foreground">
                {c.classes.length} <ChevronRight className="inline h-3.5 w-3.5" />
              </span>
            </button>
          ))}
        </div>
      ) : null}

      {program.kind === "school" && selectedCycle ? (
        <div className="grid gap-3 sm:grid-cols-2">
          {selectedCycle.classes.map((p) => (
            <SubCard
              key={p.id}
              parcours={p}
              isSwitching={isSwitching}
              onSelect={onSelect}
              interest={interest}
            />
          ))}
        </div>
      ) : null}
    </motion.div>
  );
}

/**
 * "Découvrir nos programmes" — a circular hub of the 5 root programs with
 * progressive disclosure. Hover (desktop) / tap (mobile) a program to reveal its
 * sub-parcours; click an available one to enter (switches the active parcours),
 * or vote for a coming-soon one. Pure presentation: data + mutations come from the
 * route (`themes.tsx`).
 */
export function ProgramHub({
  parcours,
  isPending,
  isError,
  isSwitching,
  onSelect,
  interest,
}: {
  parcours: ProgramParcours[];
  isPending: boolean;
  isError: boolean;
  isSwitching: boolean;
  onSelect: (id: string) => void;
  interest: ParcoursInterestState;
}) {
  const t = useT();
  const isMobile = useIsMobile();
  const reduce = useReducedMotion();
  const [activeId, setActiveId] = useState<string | null>(null);
  const [cycle, setCycle] = useState<string | null>(null);

  const programs = buildPrograms(parcours);
  const positions = nodePositions(programs.length);
  const active = programs.find((p) => p.id === activeId) ?? null;

  const familyLabel = (id: string) => t.discover.families[id as keyof typeof t.discover.families];
  const familyHint = (p: Program) =>
    p.kind === "school"
      ? t.discover.hintClasses.replace("{count}", String(p.total))
      : p.kind === "languages"
        ? t.discover.hintLanguages.replace("{count}", String(p.total))
        : p.comingSoon
          ? t.discover.hintSoon
          : t.discover.hintExplore;

  const activate = (p: Program) => {
    if (p.kind === "enter" && p.parcours) {
      onSelect(p.parcours.id);
      return;
    }
    setCycle(null);
    setActiveId((prev) => (prev === p.id ? null : p.id));
  };

  return (
    <div className="mx-auto max-w-5xl p-6">
      <div className="mb-6 text-center">
        <h1 className="font-display text-3xl font-bold">{t.discover.heading}</h1>
        <p className="mt-2 text-muted-foreground">{t.discover.subtitle}</p>
        {isSwitching ? (
          <p className="mt-2 text-sm text-[color:var(--gold)]">{t.explorer.switching}</p>
        ) : null}
      </div>

      {isPending ? (
        <div className="mx-auto aspect-square w-full max-w-[460px] animate-pulse rounded-full border border-border/50 bg-black/40" />
      ) : isError ? (
        <p className="text-center text-sm text-muted-foreground">{t.explorer.failedLoad}</p>
      ) : programs.every((p) => p.total === 0) ? (
        <p className="text-center text-sm text-muted-foreground">{t.explorer.empty}</p>
      ) : (
        <>
          <div className="relative mx-auto aspect-square w-full max-w-[460px]">
            <motion.div
              aria-hidden
              className="absolute inset-[6%] rounded-full border border-dashed border-[color:var(--gold)]/25"
              animate={reduce || isMobile || active ? { rotate: 0 } : { rotate: 360 }}
              transition={{ duration: 60, ease: "linear", repeat: Infinity }}
            />
            <div
              aria-hidden
              className="absolute inset-[28%] grid place-items-center rounded-full border border-[color:var(--gold)]/20 bg-black/40 text-center backdrop-blur-md"
            >
              <span className="px-2">
                <Sparkles className="mx-auto h-5 w-5 text-[color:var(--gold)]" />
                <span className="mt-1 block font-display text-[11px] font-bold leading-tight text-champagne/80">
                  {t.discover.center}
                </span>
              </span>
            </div>
            {programs.map((p, i) => (
              <ProgramNode
                key={p.id}
                program={p}
                label={familyLabel(p.id)}
                hint={familyHint(p)}
                pos={positions[i]}
                isActive={activeId === p.id}
                disabled={isSwitching}
                onActivate={() => activate(p)}
                onHover={() => {
                  if (!isMobile && p.kind !== "enter") {
                    setCycle(null);
                    setActiveId(p.id);
                  }
                }}
              />
            ))}
          </div>

          {active ? (
            <DisclosurePanel
              program={active}
              label={familyLabel(active.id)}
              cycle={cycle}
              setCycle={setCycle}
              isSwitching={isSwitching}
              onSelect={onSelect}
              interest={interest}
            />
          ) : null}
        </>
      )}
    </div>
  );
}

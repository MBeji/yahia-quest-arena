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
  ArrowRight,
  Crown,
  Lock,
  Clock,
  Heart,
  Loader2,
} from "lucide-react";
import { useT } from "@/lib/i18n";
import { useIsMobile } from "@/hooks/use-mobile";
import { buildPrograms, type Program, type ProgramParcours } from "../program-families";
import type { ParcoursInterestState } from "../use-parcours-interest";

const ICONS: Record<string, React.ComponentType<React.SVGProps<SVGSVGElement>>> = {
  GraduationCap,
  Languages,
  Globe,
  Brain,
  Award,
};

const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;

type Pt = { x: number; y: number };

/** Program-node centres on a circle, in stage-percentage coords (first at top). */
function nodePositions(n: number, radius = 28): Pt[] {
  return Array.from({ length: n }, (_, i) => {
    const a = ((-90 + i * (360 / n)) * Math.PI) / 180;
    return { x: 50 + radius * Math.cos(a), y: 50 + radius * Math.sin(a) };
  });
}

/** Sub-item ("petal") centres, fanned in a star around the active node, facing out. */
function petalPositions(node: Pt, count: number, distance = 15): Pt[] {
  if (count <= 0) return [];
  const out = Math.atan2(node.y - 50, node.x - 50);
  const step = count > 1 ? Math.min((150 * Math.PI) / 180 / (count - 1), (44 * Math.PI) / 180) : 0;
  const start = out - (step * (count - 1)) / 2;
  return Array.from({ length: count }, (_, j) => {
    const a = start + step * j;
    return { x: node.x + distance * Math.cos(a), y: node.y + distance * Math.sin(a) };
  });
}

/** What the active program currently fans out as petals. */
type Petal =
  | { kind: "enter"; key: string; label: string; parcours: ProgramParcours }
  | { kind: "vote"; key: string; label: string; parcours: ProgramParcours }
  | { kind: "drill"; key: string; label: string; cycle: string; count: number };

function ProgramNode({
  program,
  label,
  hint,
  pos,
  isActive,
  dimmed,
  disabled,
  onActivate,
  onHover,
}: {
  program: Program;
  label: string;
  hint: string;
  pos: Pt;
  isActive: boolean;
  dimmed: boolean;
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
      animate={{ opacity: dimmed ? 0.35 : 1 }}
      className="absolute z-10 flex w-[24%] -translate-x-1/2 -translate-y-1/2 flex-col items-center gap-1 text-center"
      style={{ left: `${pos.x}%`, top: `${pos.y}%` }}
    >
      <span
        className={`grid aspect-square w-[64%] place-items-center rounded-full border-2 backdrop-blur-md transition ${
          isActive ? "border-[color:var(--gold)]" : "border-border/50"
        } ${soon ? "border-dashed" : ""}`}
        style={{ background: `color-mix(in oklab, ${color} 22%, rgba(0,0,0,0.55))` }}
      >
        <Icon className="h-1/2 w-1/2" style={{ color: soon ? undefined : color }} />
      </span>
      <span className="font-display text-[11px] font-bold leading-tight sm:text-sm">{label}</span>
      <span className="inline-flex items-center gap-0.5 text-[10px] text-muted-foreground">
        {soon ? <Clock className="h-2.5 w-2.5" /> : null}
        {hint}
        {program.kind !== "enter" && !soon ? <ChevronRight className="h-2.5 w-2.5" /> : null}
      </span>
    </motion.button>
  );
}

function PetalButton({
  petal,
  pos,
  interest,
  isSwitching,
  onEnter,
  onDrill,
}: {
  petal: Petal;
  pos: Pt;
  interest: ParcoursInterestState;
  isSwitching: boolean;
  onEnter: (id: string) => void;
  onDrill: (cycle: string) => void;
}) {
  const t = useT();
  const base =
    "absolute z-20 max-w-[150px] -translate-x-1/2 -translate-y-1/2 rounded-full border bg-black/70 px-3 py-1.5 text-center text-[11px] font-bold backdrop-blur-md transition disabled:opacity-60";
  const style = { left: `${pos.x}%`, top: `${pos.y}%` } as const;

  if (petal.kind === "vote") {
    const interested = interest.mine.has(petal.parcours.id);
    const pending = interest.togglingId === petal.parcours.id;
    return (
      <motion.button
        type="button"
        initial={{ opacity: 0, scale: 0.6 }}
        animate={{ opacity: 1, scale: 1 }}
        onClick={() => interest.onToggle(petal.parcours.id)}
        disabled={pending}
        aria-pressed={interested}
        aria-label={`${interested ? t.parcoursInterest.interested : t.parcoursInterest.cta} — ${petal.label}`}
        title={petal.label}
        className={`${base} inline-flex items-center gap-1 ${
          interested
            ? "border-[color:var(--gold)]/70 text-[color:var(--gold)]"
            : "border-border/60 text-champagne hover:border-[color:var(--gold)]/60"
        }`}
        style={style}
      >
        {pending ? (
          <Loader2 className="h-3.5 w-3.5 animate-spin" />
        ) : (
          <Heart className={`h-3.5 w-3.5 ${interested ? "fill-current" : ""}`} />
        )}
        {interest.counts[petal.parcours.id] ?? 0}
      </motion.button>
    );
  }

  if (petal.kind === "drill") {
    return (
      <motion.button
        type="button"
        initial={{ opacity: 0, scale: 0.6 }}
        animate={{ opacity: 1, scale: 1 }}
        onClick={() => onDrill(petal.cycle)}
        aria-label={petal.label}
        className={`${base} inline-flex items-center gap-1 border-border/60 text-champagne hover:border-[color:var(--gold)]/60`}
        style={style}
      >
        {petal.label} <span className="text-muted-foreground">{petal.count}</span>
      </motion.button>
    );
  }

  // enter
  const soon = petal.parcours.status === "coming_soon";
  const locked = petal.parcours.is_premium && !petal.parcours.hasEntitlement;
  return (
    <motion.button
      type="button"
      initial={{ opacity: 0, scale: 0.6 }}
      animate={{ opacity: 1, scale: 1 }}
      onClick={() => onEnter(petal.parcours.id)}
      disabled={isSwitching || soon}
      aria-label={petal.label}
      title={petal.label}
      className={`${base} inline-flex items-center gap-1 border-border/60 text-champagne hover:border-[color:var(--gold)]/60`}
      style={style}
    >
      {locked ? <Lock className="h-3 w-3 shrink-0 text-[color:var(--neon-gold)]" /> : null}
      {!locked && petal.parcours.is_premium ? (
        <Crown className="h-3 w-3 shrink-0 text-[color:var(--gold)]" />
      ) : null}
      <span className="min-w-0 truncate">{petal.label}</span>
      <ArrowRight className="h-3 w-3 shrink-0 text-[color:var(--gold)] rtl:-scale-x-100" />
    </motion.button>
  );
}

/**
 * "Découvrir nos programmes" — a circular hub of the 5 root programs with
 * progressive disclosure. Hover (desktop) / tap (mobile) a program to fan its
 * sub-parcours out as a STAR of petals around its node; click an available one
 * to enter (switches the active parcours), or vote for a coming-soon one. Pure
 * presentation: data + mutations come from the route (`themes.tsx`).
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
  const activeIndex = programs.findIndex((p) => p.id === activeId);
  const active = activeIndex >= 0 ? programs[activeIndex] : null;

  const familyLabel = (id: string) => t.discover.families[id as keyof typeof t.discover.families];
  const familyHint = (p: Program) =>
    p.kind === "school"
      ? t.discover.hintClasses.replace("{count}", String(p.total))
      : p.kind === "languages"
        ? t.discover.hintLanguages.replace("{count}", String(p.total))
        : p.comingSoon
          ? t.discover.hintSoon
          : t.discover.hintExplore;
  const cycleLabel = (c: string) =>
    c === "primaire" ? t.cycles.primaire : c === "college" ? t.cycles.college : t.cycles.secondaire;
  // Compact petal label: short language name, or the class name minus its long
  // "année de base / secondaire / Préparation" boilerplate so pills stay small.
  const shortLabel = (p: ProgramParcours) =>
    p.theme_id === "anglais"
      ? t.discover.langShort.anglais
      : p.theme_id === "francais"
        ? t.discover.langShort.francais
        : p.theme_id === "arabe"
          ? t.discover.langShort.arabe
          : p.name_fr
              .replace(/^Préparation\s+/i, "")
              .replace(/\s+année de base$/i, "")
              .replace(/\s+année secondaire$/i, " sec.");

  // Petals the active program currently fans out.
  const petals: Petal[] = !active
    ? []
    : active.kind === "languages"
      ? active.languages.map(
          (p): Petal => ({ kind: "enter", key: p.id, label: shortLabel(p), parcours: p }),
        )
      : active.kind === "coming_soon" && active.parcours
        ? [
            {
              kind: "vote",
              key: active.parcours.id,
              label: shortLabel(active.parcours),
              parcours: active.parcours,
            },
          ]
        : active.kind === "school"
          ? cycle
            ? (active.cycles.find((c) => c.cycle === cycle)?.classes ?? []).map(
                (p): Petal =>
                  p.status === "coming_soon"
                    ? { kind: "vote", key: p.id, label: shortLabel(p), parcours: p }
                    : { kind: "enter", key: p.id, label: shortLabel(p), parcours: p },
              )
            : active.cycles.map(
                (c): Petal => ({
                  kind: "drill",
                  key: c.cycle,
                  label: cycleLabel(c.cycle),
                  cycle: c.cycle,
                  count: c.classes.length,
                }),
              )
          : [];

  const petalPos = active ? petalPositions(positions[activeIndex], petals.length) : [];

  const activate = (p: Program) => {
    if (p.kind === "enter" && p.parcours) {
      onSelect(p.parcours.id);
      return;
    }
    if (p.id === activeId) {
      // Clicking the open program steps back: school cycle → cycles, else collapse.
      if (p.kind === "school" && cycle) setCycle(null);
      else setActiveId(null);
      return;
    }
    setCycle(null);
    setActiveId(p.id);
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
        <div className="relative mx-auto aspect-square w-full max-w-[480px] overflow-visible">
          {active && petalPos.length > 0 ? (
            <svg
              className="pointer-events-none absolute inset-0 h-full w-full overflow-visible"
              viewBox="0 0 100 100"
              preserveAspectRatio="none"
              aria-hidden
            >
              {petalPos.map((pt, i) => (
                <line
                  key={petals[i].key}
                  x1={positions[activeIndex].x}
                  y1={positions[activeIndex].y}
                  x2={pt.x}
                  y2={pt.y}
                  stroke="var(--gold)"
                  strokeWidth={0.35}
                  opacity={0.4}
                />
              ))}
            </svg>
          ) : null}

          <motion.div
            aria-hidden
            className="absolute inset-[6%] rounded-full border border-dashed border-[color:var(--gold)]/25"
            animate={reduce || isMobile || active ? { rotate: 0 } : { rotate: 360 }}
            transition={{ duration: 60, ease: "linear", repeat: Infinity }}
          />
          <div
            aria-hidden
            className="absolute inset-[30%] grid place-items-center rounded-full border border-[color:var(--gold)]/20 bg-black/40 text-center backdrop-blur-md"
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
              dimmed={active !== null && activeId !== p.id}
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

          {petals.map((petal, i) => (
            <PetalButton
              key={petal.key}
              petal={petal}
              pos={petalPos[i]}
              interest={interest}
              isSwitching={isSwitching}
              onEnter={onSelect}
              onDrill={setCycle}
            />
          ))}
        </div>
      )}
    </div>
  );
}

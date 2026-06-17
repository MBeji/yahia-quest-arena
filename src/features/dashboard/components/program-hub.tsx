import { useState } from "react";
import { motion, useReducedMotion } from "motion/react";
import { Sparkles, ChevronRight, Clock } from "lucide-react";
import { useT } from "@/lib/i18n";
import { useIsMobile } from "@/hooks/use-mobile";
import {
  buildPrograms,
  flagshipConcours,
  type Program,
  type ProgramParcours,
} from "../program-families";
import { PROGRAM_ICONS, colorVar } from "./program-visuals";
import { FlagshipCrown } from "./flagship-crown";

type Pt = { x: number; y: number };

/** Program-node centres on a circle, in stage-percentage coords (first at top). */
function nodePositions(n: number, radius = 28): Pt[] {
  return Array.from({ length: n }, (_, i) => {
    const a = ((-90 + i * (360 / n)) * Math.PI) / 180;
    return { x: 50 + radius * Math.cos(a), y: 50 + radius * Math.sin(a) };
  });
}

/** Preview-chip centres, fanned in a star around a node, facing out. */
function previewPositions(node: Pt, count: number, distance = 17): Pt[] {
  if (count <= 0) return [];
  const out = Math.atan2(node.y - 50, node.x - 50);
  const step = count > 1 ? Math.min((150 * Math.PI) / 180 / (count - 1), (44 * Math.PI) / 180) : 0;
  const start = out - (step * (count - 1)) / 2;
  return Array.from({ length: count }, (_, j) => {
    const a = start + step * j;
    return { x: node.x + distance * Math.cos(a), y: node.y + distance * Math.sin(a) };
  });
}

/**
 * One of the 5 root program nodes — the ONLY interactive element on the hub.
 * Click navigates to the program's dedicated category page (`onOpen`); hovering
 * (desktop) reveals its non-interactive sub-menu previews around it.
 */
function ProgramNode({
  program,
  label,
  hint,
  pos,
  hovered,
  dimmed,
  flagship,
  onOpen,
  onHover,
  onLeave,
}: {
  program: Program;
  label: string;
  hint: string;
  pos: Pt;
  hovered: boolean;
  dimmed: boolean;
  flagship: boolean;
  onOpen: () => void;
  onHover: () => void;
  onLeave: () => void;
}) {
  const Icon = PROGRAM_ICONS[program.icon] ?? PROGRAM_ICONS.Globe;
  const color = colorVar(program.color);
  const soon = program.comingSoon;
  return (
    <motion.button
      type="button"
      onClick={onOpen}
      onMouseEnter={onHover}
      onMouseLeave={onLeave}
      onFocus={onHover}
      onBlur={onLeave}
      aria-label={label}
      whileHover={{ scale: 1.06 }}
      whileTap={{ scale: 0.96 }}
      animate={{ opacity: dimmed ? 0.4 : 1 }}
      className="absolute z-10 flex w-[24%] -translate-x-1/2 -translate-y-1/2 cursor-pointer flex-col items-center gap-1 text-center"
      style={{ left: `${pos.x}%`, top: `${pos.y}%` }}
    >
      <span
        className={`relative grid aspect-square w-[64%] place-items-center rounded-full border-2 backdrop-blur-md transition ${
          hovered
            ? "border-[color:var(--gold)] shadow-gold"
            : flagship
              ? "border-[color:var(--gold)]/70 shadow-gold"
              : "border-border/50"
        } ${soon ? "border-dashed" : ""}`}
        style={{ background: `color-mix(in oklab, ${color} 22%, rgba(0,0,0,0.55))` }}
      >
        <Icon className="h-1/2 w-1/2" style={{ color: soon ? undefined : color }} />
        {flagship ? (
          <FlagshipCrown className="absolute -right-1.5 -top-1.5 h-7 w-7 sm:h-9 sm:w-9" />
        ) : null}
      </span>
      <span className="font-display text-[11px] font-bold leading-tight sm:text-sm">{label}</span>
      <span className="inline-flex items-center gap-0.5 text-[10px] text-muted-foreground">
        {soon ? <Clock className="h-2.5 w-2.5" /> : null}
        {hint}
        <ChevronRight className="h-2.5 w-2.5 rtl:-scale-x-100" />
      </span>
    </motion.button>
  );
}

/** A non-interactive sub-menu preview chip (illustration only — never clickable). */
function PreviewChip({ label, pos }: { label: string; pos: Pt }) {
  return (
    <motion.span
      aria-hidden
      initial={{ opacity: 0, scale: 0.7 }}
      animate={{ opacity: 1, scale: 1 }}
      className="pointer-events-none absolute z-0 max-w-[120px] -translate-x-1/2 -translate-y-1/2 truncate rounded-full border border-border/40 bg-black/55 px-2.5 py-1 text-center text-[10px] font-semibold text-champagne/70 backdrop-blur-md"
      style={{ left: `${pos.x}%`, top: `${pos.y}%` }}
    >
      {label}
    </motion.span>
  );
}

/**
 * "Découvrir nos programmes" — a calm circular hub of the 5 root programs. Only
 * the 5 nodes are interactive: clicking one opens its dedicated category page
 * (`onOpen`), where the sub-programs become fully interactive (enter / vote).
 * Hovering a node (desktop) reveals its sub-menu previews as non-clickable chips,
 * purely for illustration. Pure presentation: data comes from the route
 * (`themes.tsx`), navigation is delegated via `onOpen`.
 */
export function ProgramHub({
  parcours,
  isPending,
  isError,
  onOpen,
}: {
  parcours: ProgramParcours[];
  isPending: boolean;
  isError: boolean;
  onOpen: (familyId: string) => void;
}) {
  const t = useT();
  const isMobile = useIsMobile();
  const reduce = useReducedMotion();
  const [hoveredId, setHoveredId] = useState<string | null>(null);

  const programs = buildPrograms(parcours);
  const positions = nodePositions(programs.length);
  const hoveredIndex = programs.findIndex((p) => p.id === hoveredId);
  const hovered = hoveredIndex >= 0 ? programs[hoveredIndex] : null;

  // Flag the school node that carries the flagship concours (6ème, 9ème) so it
  // stands out with the animated gold crown the moment Découvrir opens.
  const flagshipIds = new Set(flagshipConcours(parcours).map((p) => p.id));
  const hasFlagship = (p: Program) =>
    p.kind === "school" && p.cycles.some((c) => c.classes.some((x) => flagshipIds.has(x.id)));

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
  const langLabel = (p: ProgramParcours) =>
    p.theme_id === "anglais"
      ? t.discover.langShort.anglais
      : p.theme_id === "francais"
        ? t.discover.langShort.francais
        : p.theme_id === "arabe"
          ? t.discover.langShort.arabe
          : p.name_fr;

  // Sub-menu preview labels for a program — language names, school cycles, or a
  // "soon" chip. Single-entry programs (culture/cerveau) show none (the node hint
  // already says "Explore"). Shown on hover only (desktop) to keep the hub airy.
  const previewLabels = (p: Program): string[] =>
    p.kind === "languages"
      ? p.languages.map(langLabel)
      : p.kind === "school"
        ? p.cycles.map((c) => cycleLabel(c.cycle))
        : p.comingSoon
          ? [t.discover.hintSoon]
          : [];

  const previews = !isMobile && hovered ? previewLabels(hovered) : [];
  const previewPos = hovered ? previewPositions(positions[hoveredIndex], previews.length) : [];

  return (
    <div className="mx-auto max-w-5xl p-6">
      <div className="mb-6 text-center">
        <h1 className="font-display text-3xl font-bold">{t.discover.heading}</h1>
        <p className="mt-2 text-muted-foreground">{t.discover.subtitle}</p>
      </div>

      {isPending ? (
        <div className="mx-auto aspect-square w-full max-w-[520px] animate-pulse rounded-full border border-border/50 bg-black/40" />
      ) : isError ? (
        <p className="text-center text-sm text-muted-foreground">{t.explorer.failedLoad}</p>
      ) : programs.every((p) => p.total === 0) ? (
        <p className="text-center text-sm text-muted-foreground">{t.explorer.empty}</p>
      ) : (
        <div className="relative mx-auto aspect-square w-full max-w-[520px] overflow-visible">
          {previews.length > 0 ? (
            <svg
              className="pointer-events-none absolute inset-0 h-full w-full overflow-visible"
              viewBox="0 0 100 100"
              preserveAspectRatio="none"
              aria-hidden
            >
              {previewPos.map((pt, i) => (
                <line
                  key={`${hoveredId}-${i}`}
                  x1={positions[hoveredIndex].x}
                  y1={positions[hoveredIndex].y}
                  x2={pt.x}
                  y2={pt.y}
                  stroke="var(--gold)"
                  strokeWidth={0.3}
                  opacity={0.3}
                />
              ))}
            </svg>
          ) : null}

          <motion.div
            aria-hidden
            className="absolute inset-[6%] rounded-full border border-dashed border-[color:var(--gold)]/25"
            animate={reduce || isMobile || hovered ? { rotate: 0 } : { rotate: 360 }}
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
              hovered={hoveredId === p.id}
              dimmed={hovered !== null && hoveredId !== p.id}
              flagship={hasFlagship(p)}
              onOpen={() => onOpen(p.id)}
              onHover={() => {
                if (!isMobile) setHoveredId(p.id);
              }}
              onLeave={() => {
                if (!isMobile) setHoveredId((cur) => (cur === p.id ? null : cur));
              }}
            />
          ))}

          {previews.map((label, i) => (
            <PreviewChip key={`${hoveredId}-${label}-${i}`} label={label} pos={previewPos[i]} />
          ))}
        </div>
      )}
    </div>
  );
}

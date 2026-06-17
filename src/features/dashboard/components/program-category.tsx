import type React from "react";
import { ArrowLeft, ArrowRight, Crown, Lock, Clock, Sparkles } from "lucide-react";
import { useT } from "@/lib/i18n";
import {
  flagshipConcours,
  flagshipLabel,
  type Program,
  type ProgramParcours,
} from "../program-families";
import type { ParcoursInterestState } from "../use-parcours-interest";
import { ParcoursInterestButton } from "./parcours-interest-button";
import { PROGRAM_ICONS, colorVar } from "./program-visuals";
import { FlagshipCrown } from "./flagship-crown";

const CARD =
  "relative w-full rounded-2xl border-2 border-[color:var(--gold)]/30 bg-black/50 p-5 text-left";

/** An available sub-parcours: a card that enters it (switches the active track). */
function EnterCard({
  parcours,
  label,
  isSwitching,
  onSelect,
}: {
  parcours: ProgramParcours;
  label: string;
  isSwitching: boolean;
  onSelect: (id: string) => void;
}) {
  const t = useT();
  const locked = parcours.is_premium && !parcours.hasEntitlement;
  return (
    <button
      type="button"
      onClick={() => onSelect(parcours.id)}
      disabled={isSwitching}
      aria-label={label}
      className={`${CARD} flex items-center justify-between gap-3 transition-all hover:scale-[1.02] hover:border-[color:var(--gold)]/60 disabled:opacity-60`}
    >
      <span className="flex min-w-0 items-center gap-2">
        {parcours.is_premium ? (
          locked ? (
            <Lock className="h-4 w-4 shrink-0 text-[color:var(--neon-gold)]" />
          ) : (
            <Crown className="h-4 w-4 shrink-0 text-[color:var(--gold)]" />
          )
        ) : null}
        <span className="truncate font-display text-base font-bold">{label}</span>
      </span>
      <span className="inline-flex shrink-0 items-center gap-1 text-sm font-semibold text-[color:var(--gold)]">
        {t.discover.enter}
        <ArrowRight className="h-4 w-4 rtl:-scale-x-100" />
      </span>
    </button>
  );
}

/** A coming-soon sub-parcours: a non-interactive card hosting the interest vote. */
function ComingSoonCard({
  parcours,
  label,
  interest,
}: {
  parcours: ProgramParcours;
  label: string;
  interest: ParcoursInterestState;
}) {
  const t = useT();
  return (
    <div className={CARD}>
      <div className="flex flex-wrap items-center gap-2">
        <span className="font-display text-base font-bold">{label}</span>
        <span className="inline-flex items-center gap-1 rounded-full bg-muted/40 px-2 py-0.5 text-xs font-semibold text-muted-foreground">
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

/** Pick the right card for a sub-parcours by its availability. */
function ParcoursCard(props: {
  parcours: ProgramParcours;
  label: string;
  interest: ParcoursInterestState;
  isSwitching: boolean;
  onSelect: (id: string) => void;
}) {
  return props.parcours.status === "coming_soon" ? (
    <ComingSoonCard parcours={props.parcours} label={props.label} interest={props.interest} />
  ) : (
    <EnterCard
      parcours={props.parcours}
      label={props.label}
      isSwitching={props.isSwitching}
      onSelect={props.onSelect}
    />
  );
}

/** A flagship concours (6ème / 9ème): a prominent, crowned hero card. */
function FlagshipCard({
  parcours,
  label,
  interest,
  isSwitching,
  onSelect,
}: {
  parcours: ProgramParcours;
  label: string;
  interest: ParcoursInterestState;
  isSwitching: boolean;
  onSelect: (id: string) => void;
}) {
  const t = useT();
  const soon = parcours.status === "coming_soon";
  const locked = parcours.is_premium && !parcours.hasEntitlement;
  return (
    <div className="rounded-2xl border-2 border-[color:var(--gold)]/60 bg-gradient-to-br from-[color:var(--gold)]/15 to-black/50 p-5 shadow-gold">
      <div className="flex items-start gap-3">
        <FlagshipCrown className="h-14 w-14 shrink-0" />
        <div className="min-w-0 flex-1">
          <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[color:var(--gold)]">
            <Crown className="h-3 w-3" /> {t.flagship.badge}
          </span>
          <h3 className="mt-1.5 font-display text-xl font-bold leading-tight">{label}</h3>
        </div>
      </div>
      {soon ? (
        <ParcoursInterestButton
          count={interest.counts[parcours.id] ?? 0}
          interested={interest.mine.has(parcours.id)}
          isPending={interest.togglingId === parcours.id}
          onToggle={() => interest.onToggle(parcours.id)}
        />
      ) : (
        <button
          type="button"
          onClick={() => onSelect(parcours.id)}
          disabled={isSwitching}
          aria-label={label}
          className="mt-4 inline-flex w-full items-center justify-center gap-2 rounded-full bg-[image:var(--gradient-gold)] px-6 py-2.5 font-display font-bold text-black shadow-gold transition hover:scale-[1.02] disabled:opacity-60"
        >
          {locked ? <Lock className="h-4 w-4" /> : <Crown className="h-4 w-4" />}
          {t.discover.start}
          <ArrowRight className="h-4 w-4 rtl:-scale-x-100" />
        </button>
      )}
    </div>
  );
}

/**
 * Dedicated category page for one root program — the second step of "Découvrir".
 * Presents the program's sub-programs clearly and fully interactively: enter an
 * available one (switches the active parcours → dashboard) or vote for a
 * coming-soon one. Single-entry programs (culture/cerveau) show a focused
 * "start" hero; a fully coming-soon program (IB) shows an elegant teaser + vote.
 * Pure presentation — data + mutations come from the route.
 */
export function ProgramCategory({
  program,
  onSelect,
  onBack,
  interest,
  isSwitching,
}: {
  program: Program;
  onSelect: (parcoursId: string) => void;
  onBack: () => void;
  interest: ParcoursInterestState;
  isSwitching: boolean;
}) {
  const t = useT();
  const Icon = PROGRAM_ICONS[program.icon] ?? PROGRAM_ICONS.Globe;
  const color = colorVar(program.color);
  const label = t.discover.families[program.id as keyof typeof t.discover.families];
  const desc = t.discover.familyDesc[program.id as keyof typeof t.discover.familyDesc];

  const langLabel = (p: ProgramParcours) =>
    p.theme_id === "anglais"
      ? t.discover.langShort.anglais
      : p.theme_id === "francais"
        ? t.discover.langShort.francais
        : p.theme_id === "arabe"
          ? t.discover.langShort.arabe
          : p.name_fr;
  const cycleLabel = (c: string) =>
    c === "primaire" ? t.cycles.primaire : c === "college" ? t.cycles.college : t.cycles.secondaire;

  const empty = <p className="text-center text-sm text-muted-foreground">{t.explorer.empty}</p>;
  const target = program.parcours;

  let body: React.ReactNode;
  if (program.kind === "languages") {
    body =
      program.languages.length === 0 ? (
        empty
      ) : (
        <div className="grid gap-3 sm:grid-cols-3">
          {program.languages.map((p) => (
            <ParcoursCard
              key={p.id}
              parcours={p}
              label={langLabel(p)}
              interest={interest}
              isSwitching={isSwitching}
              onSelect={onSelect}
            />
          ))}
        </div>
      );
  } else if (program.kind === "school") {
    // Pin the flagship concours (6ème, 9ème) at the top, big & crowned, then list
    // the remaining classes by cycle (flagships removed so they appear only once).
    const flagships = flagshipConcours(program.cycles.flatMap((c) => c.classes));
    const flagshipIds = new Set(flagships.map((p) => p.id));
    const cycles = program.cycles
      .map((c) => ({ cycle: c.cycle, classes: c.classes.filter((p) => !flagshipIds.has(p.id)) }))
      .filter((c) => c.classes.length > 0);
    body =
      flagships.length === 0 && cycles.length === 0 ? (
        empty
      ) : (
        <div className="space-y-8">
          {flagships.length > 0 && (
            <section>
              <h2 className="mb-3 flex items-center gap-2 font-display text-sm font-bold uppercase tracking-wider text-[color:var(--gold)]">
                <Crown className="h-4 w-4" /> {t.flagship.sectionTitle}
              </h2>
              <div className="grid gap-4 sm:grid-cols-2">
                {flagships.map((p) => (
                  <FlagshipCard
                    key={p.id}
                    parcours={p}
                    label={flagshipLabel(p.name_fr)}
                    interest={interest}
                    isSwitching={isSwitching}
                    onSelect={onSelect}
                  />
                ))}
              </div>
            </section>
          )}
          {cycles.map((c) => (
            <section key={c.cycle}>
              <h2 className="mb-3 font-display text-sm font-bold uppercase tracking-wider text-champagne/70">
                {cycleLabel(c.cycle)}
              </h2>
              <div className="grid gap-3 sm:grid-cols-2">
                {c.classes.map((p) => (
                  <ParcoursCard
                    key={p.id}
                    parcours={p}
                    label={p.name_fr}
                    interest={interest}
                    isSwitching={isSwitching}
                    onSelect={onSelect}
                  />
                ))}
              </div>
            </section>
          ))}
        </div>
      );
  } else if (program.kind === "enter") {
    body = target ? (
      <div className="flex justify-center">
        <button
          type="button"
          onClick={() => onSelect(target.id)}
          disabled={isSwitching}
          className="inline-flex items-center gap-2 rounded-full bg-[image:var(--gradient-gold)] px-8 py-3 font-display text-lg font-bold text-black shadow-gold transition hover:scale-[1.03] disabled:opacity-60"
        >
          {t.discover.start}
          <ArrowRight className="h-5 w-5 rtl:-scale-x-100" />
        </button>
      </div>
    ) : (
      empty
    );
  } else {
    // coming_soon (e.g. IB): an elegant teaser + interest vote (if a target exists).
    body = (
      <div className="rounded-2xl border-2 border-dashed border-[color:var(--gold)]/30 bg-black/40 p-8 text-center">
        <Sparkles className="mx-auto mb-3 h-8 w-8 text-[color:var(--gold)]" />
        <h2 className="font-display text-xl font-bold">{t.discover.comingSoonTitle}</h2>
        <p className="mx-auto mt-2 max-w-md text-sm text-muted-foreground">
          {t.discover.comingSoonDesc}
        </p>
        {target ? (
          <div className="mx-auto mt-4 max-w-xs">
            <ParcoursInterestButton
              count={interest.counts[target.id] ?? 0}
              interested={interest.mine.has(target.id)}
              isPending={interest.togglingId === target.id}
              onToggle={() => interest.onToggle(target.id)}
            />
          </div>
        ) : null}
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-3xl p-6">
      <button
        type="button"
        onClick={onBack}
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground transition hover:text-champagne"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" />
        {t.discover.backToPrograms}
      </button>

      <header className="mb-8 flex flex-col items-center gap-3 text-center">
        <span
          className="grid h-16 w-16 place-items-center rounded-2xl border-2 border-[color:var(--gold)]/40 backdrop-blur-md"
          style={{ background: `color-mix(in oklab, ${color} 22%, rgba(0,0,0,0.55))` }}
        >
          <Icon className="h-8 w-8" style={{ color: program.comingSoon ? undefined : color }} />
        </span>
        <h1 className="font-display text-3xl font-bold">{label}</h1>
        <p className="max-w-xl text-muted-foreground">{desc}</p>
        {isSwitching ? (
          <p className="text-sm text-[color:var(--gold)]">{t.explorer.switching}</p>
        ) : null}
      </header>

      {body}
    </div>
  );
}

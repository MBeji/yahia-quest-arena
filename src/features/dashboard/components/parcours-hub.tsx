import React from "react";
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
  ChevronRight,
  Crown,
  Lock,
  Clock,
} from "lucide-react";
import { useT } from "@/lib/i18n";

/** Shape of a parcours row enriched by `getParcours` (with `hasEntitlement`). */
export type ParcoursHubItem = {
  id: string;
  name_fr: string;
  kind: string;
  is_premium: boolean;
  status: string;
  icon: string;
  color: string;
  hasEntitlement: boolean;
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

/** Resolve a CSS colour variable from a stored `color` token (e.g. "subject-math"
 * or bare "math") → always "--subject-<base>", matching the rest of the app. */
const colorVar = (token: string) => `var(--subject-${token.replace(/^subject-/, "")})`;

function ParcoursCard({
  parcours,
  isSwitching,
  onSelect,
}: {
  parcours: ParcoursHubItem;
  isSwitching: boolean;
  onSelect: (id: string) => void;
}) {
  const t = useT();
  const Icon = ICONS[parcours.icon] ?? Sword;
  const color = colorVar(parcours.color);
  const isComingSoon = parcours.status === "coming_soon";
  const isLockedPremium = parcours.is_premium && !parcours.hasEntitlement;
  const disabled = isComingSoon || isSwitching;

  return (
    <motion.button
      type="button"
      onClick={isComingSoon ? undefined : () => onSelect(parcours.id)}
      disabled={disabled}
      aria-disabled={isComingSoon || undefined}
      whileHover={disabled ? undefined : { scale: 1.02 }}
      whileTap={disabled ? undefined : { scale: 0.98 }}
      aria-label={parcours.name_fr}
      className="group relative overflow-hidden rounded-2xl border border-border/50 bg-black/60 p-5 text-left backdrop-blur-md transition hover:-translate-y-1 hover:border-[color:var(--gold)]/60 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0"
    >
      <div
        className="absolute -right-8 -top-8 h-28 w-28 rounded-full opacity-50 blur-2xl transition-opacity group-hover:opacity-90"
        style={{ background: color }}
      />
      <div className="relative flex items-start justify-between">
        <Icon className="h-8 w-8" style={{ color }} />
        <ChevronRight className="h-5 w-5 text-muted-foreground transition group-hover:translate-x-1 group-hover:text-foreground" />
      </div>
      <div className="relative mt-4 flex flex-wrap items-center gap-2">
        <span className="font-display text-lg font-bold">{parcours.name_fr}</span>
        {isComingSoon ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-muted/40 px-2 py-0.5 text-xs font-semibold text-muted-foreground">
            <Clock className="h-3 w-3" /> {t.explorer.comingSoon}
          </span>
        ) : isLockedPremium ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--neon-gold)]/15 px-2 py-0.5 text-xs font-semibold text-[color:var(--neon-gold)]">
            <Lock className="h-3 w-3" /> {t.explorer.premium}
          </span>
        ) : parcours.is_premium ? (
          <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-xs font-semibold text-[color:var(--gold)]">
            <Crown className="h-3 w-3" /> {t.explorer.unlocked}
          </span>
        ) : null}
      </div>
    </motion.button>
  );
}

/**
 * Presentational Explorer parcours hub: two groups (concours prep + free
 * exploration) of parcours cards. Selecting an available card switches the
 * active parcours via the `onSelect` callback supplied by the route. Pure
 * (no server fns / query) so it stays unit-testable.
 */
export function ParcoursHub({
  parcours,
  isPending,
  isError,
  isSwitching,
  onSelect,
}: {
  parcours: ParcoursHubItem[];
  isPending: boolean;
  isError: boolean;
  isSwitching: boolean;
  onSelect: (id: string) => void;
}) {
  const t = useT();
  const concours = parcours.filter((p) => p.kind === "concours");
  const libre = parcours.filter((p) => p.kind === "libre" && p.status === "available");

  return (
    <div className="mx-auto max-w-5xl p-6">
      <div className="mb-8">
        <h1 className="font-display text-3xl font-bold">{t.explorer.heading}</h1>
        <p className="mt-2 text-muted-foreground">{t.explorer.subtitle}</p>
        {isSwitching && (
          <p className="mt-2 text-sm text-[color:var(--gold)]">{t.explorer.switching}</p>
        )}
      </div>

      {isPending ? (
        <div className="grid gap-4 sm:grid-cols-2">
          {[0, 1, 2, 3].map((i) => (
            <div
              key={i}
              className="h-24 animate-pulse rounded-2xl border border-border/50 bg-black/50"
            />
          ))}
        </div>
      ) : isError ? (
        <p className="text-sm text-muted-foreground">{t.explorer.failedLoad}</p>
      ) : concours.length === 0 && libre.length === 0 ? (
        <p className="text-sm text-muted-foreground">{t.explorer.empty}</p>
      ) : (
        <div className="space-y-10">
          {concours.length > 0 && (
            <section className="space-y-4">
              <h2 className="font-display text-xl font-bold">« {t.explorer.concoursTitle} »</h2>
              <div className="grid gap-4 sm:grid-cols-2">
                {concours.map((p) => (
                  <ParcoursCard
                    key={p.id}
                    parcours={p}
                    isSwitching={isSwitching}
                    onSelect={onSelect}
                  />
                ))}
              </div>
            </section>
          )}
          {libre.length > 0 && (
            <section className="space-y-4">
              <h2 className="font-display text-xl font-bold">« {t.explorer.libreTitle} »</h2>
              <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {libre.map((p) => (
                  <ParcoursCard
                    key={p.id}
                    parcours={p}
                    isSwitching={isSwitching}
                    onSelect={onSelect}
                  />
                ))}
              </div>
            </section>
          )}
        </div>
      )}
    </div>
  );
}

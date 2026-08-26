import { Minus, TrendingDown, TrendingUp } from "lucide-react";
import { useParentT } from "@/lib/i18n/parent";
import type { IndexBand } from "../insights";
import { BAND_STYLES, useBandLabel } from "./daily-band";

/**
 * Les briques visuelles du tableau de bord quotidien.
 *
 * Elles portent une seule règle de fond : **une valeur absente n'est pas zéro**.
 * Un écart non comparable s'affiche « — », pas « 0 % » ; un niveau sans assez de
 * tentatives s'affiche « — », pas « faible ». Un parent qui lit un chiffre doit
 * pouvoir s'y fier.
 */

export function SectionCard({
  title,
  subtitle,
  icon,
  action,
  children,
}: {
  title: string;
  subtitle?: string;
  icon?: React.ReactNode;
  action?: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <section className="rounded-xl border border-border/50 bg-surface-2 p-4">
      <div className="mb-3 flex flex-wrap items-start justify-between gap-2">
        <div>
          <h3 className="flex items-center gap-2 font-semibold text-foreground">
            {icon}
            {title}
          </h3>
          {subtitle && <p className="mt-1 text-xs text-muted-foreground">{subtitle}</p>}
        </div>
        {action}
      </div>
      {children}
    </section>
  );
}

export function BigStat({
  label,
  value,
  hint,
  tone = "neutral",
}: {
  label: string;
  value: string;
  hint?: string;
  tone?: "neutral" | "primary" | "gold";
}) {
  const valueTone =
    tone === "primary" ? "text-primary" : tone === "gold" ? "text-gold" : "text-foreground";
  return (
    <div className="rounded-lg border border-border/50 bg-surface-3 p-3 text-center">
      <div className={`text-xl font-bold tabular-nums ${valueTone}`}>{value}</div>
      <div className="mt-0.5 text-xs text-muted-foreground">{label}</div>
      {hint && <div className="mt-1 text-2xs text-muted-foreground/80">{hint}</div>}
    </div>
  );
}

/**
 * Un écart chiffré. `null` signifie « pas de point de comparaison » et s'affiche
 * en tiret neutre — surtout pas en « 0 », qui se lirait « aucune évolution ».
 */
export function DeltaChip({
  value,
  suffix = "",
  invert = false,
}: {
  value: number | null;
  suffix?: string;
  /** Pour les métriques où baisser est BON (ex. tentatives avant réussite). */
  invert?: boolean;
}) {
  const t = useParentT();

  if (value === null) {
    return (
      <span className="inline-flex items-center gap-1 text-xs text-muted-foreground">
        <Minus className="h-3.5 w-3.5" />
        {t.parentDaily.noComparison}
      </span>
    );
  }

  const good = invert ? value < 0 : value > 0;
  const bad = invert ? value > 0 : value < 0;
  const tone = good ? "text-success" : bad ? "text-destructive" : "text-muted-foreground";
  const Icon = value > 0 ? TrendingUp : value < 0 ? TrendingDown : Minus;

  return (
    <span className={`inline-flex items-center gap-1 text-xs font-semibold ${tone}`}>
      <Icon className="h-3.5 w-3.5" />
      {value > 0 ? "+" : ""}
      {value}
      {suffix}
    </span>
  );
}

/** Barre de proportion simple, lisible à l'impression (`print-fill`). */
export function Meter({
  value,
  max = 100,
  className = "bg-[image:var(--gradient-gold)]",
  label,
}: {
  value: number;
  max?: number;
  className?: string;
  label?: string;
}) {
  const pct = max > 0 ? Math.min(100, Math.max(0, Math.round((value / max) * 100))) : 0;
  return (
    <div
      className="h-2.5 w-full overflow-hidden rounded-full bg-muted/50"
      role="img"
      aria-label={label}
    >
      <div className={`print-fill h-full rounded-full ${className}`} style={{ width: `${pct}%` }} />
    </div>
  );
}

export function BandPill({ band }: { band: IndexBand }) {
  const label = useBandLabel()(band);
  const style = BAND_STYLES[band];
  return (
    <span className={`rounded-md px-2 py-0.5 text-xs font-bold ${style.bg} ${style.text}`}>
      {label}
    </span>
  );
}

/** État creux honnête : « rien ce jour-là » n'est pas une erreur de chargement. */
export function EmptyRow({ label }: { label: string }) {
  return (
    <p className="rounded-lg border border-dashed border-border/60 px-3 py-6 text-center text-sm text-muted-foreground">
      {label}
    </p>
  );
}

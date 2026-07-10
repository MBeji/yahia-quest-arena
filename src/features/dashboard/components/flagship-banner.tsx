import { ArrowRight } from "lucide-react";
import { useT } from "@/lib/i18n";
import { flagshipLabel, type ProgramParcours } from "../program-families";
import { FlagshipCrown } from "./flagship-crown";

/**
 * Dashboard banner spotlighting the flagship national-concours parcours (6ème,
 * 9ème) right after login, so they're "détectables dès la connexion". The site's
 * animated gold crown anchors a single tap target → the "Programme tunisien"
 * category page. Renders nothing when there are no flagship parcours. Pure
 * presentation — the dashboard route owns the data + navigation.
 */
export function FlagshipBanner({
  flagships,
  onOpen,
}: {
  flagships: ProgramParcours[];
  onOpen: () => void;
}) {
  const t = useT();
  if (flagships.length === 0) return null;
  return (
    <button
      type="button"
      onClick={onOpen}
      aria-label={`${t.flagship.bannerTitle} — ${flagships.map((f) => flagshipLabel(f.name_fr)).join(", ")}`}
      className="group mt-6 flex w-full items-center gap-4 rounded-3xl border-2 border-[color:var(--gold)]/50 bg-gradient-to-r from-[color:var(--gold)]/12 to-black/40 p-5 text-start shadow-gold backdrop-blur-md transition hover:border-[color:var(--gold)]/80 sm:gap-5 sm:p-6"
    >
      <FlagshipCrown className="h-16 w-16 sm:h-20 sm:w-20" />
      <div className="min-w-0 flex-1">
        <span className="inline-flex items-center gap-1 rounded-full bg-[color:var(--gold)]/20 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[color:var(--gold)]">
          {t.flagship.badge}
        </span>
        <h2 className="mt-1 font-display text-xl font-bold sm:text-2xl">
          {t.flagship.bannerTitle}
        </h2>
        <p className="mt-0.5 truncate text-sm text-muted-foreground">{t.flagship.bannerSubtitle}</p>
        <div className="mt-2 flex flex-wrap gap-2">
          {flagships.map((f) => (
            <span
              key={f.id}
              className="inline-flex items-center rounded-full border border-[color:var(--gold)]/40 px-2.5 py-0.5 text-xs font-bold text-champagne"
            >
              {flagshipLabel(f.name_fr)}
            </span>
          ))}
        </div>
      </div>
      <ArrowRight className="h-6 w-6 shrink-0 text-[color:var(--gold)] transition group-hover:translate-x-1 rtl:-scale-x-100" />
    </button>
  );
}

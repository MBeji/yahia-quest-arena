import { Link } from "@tanstack/react-router";
import { Flame, Zap } from "lucide-react";

import { useMyStats } from "@/features/auth";
import { useT } from "@/lib/i18n";

/** Compact XP formatter ("12.3k") — keeps the header chip narrow on phones. */
const COMPACT_XP = new Intl.NumberFormat("en", { notation: "compact", maximumFractionDigits: 1 });

/**
 * Persistent, compact account HUD — daily streak (🔥) + XP (⚡) — rendered for a
 * signed-in user in BOTH shells (the public « Référence » header and the connected
 * shell). It keeps the value of the account visible on shared content, not only on
 * the dashboard (audit reco #1/#6). The whole chip is the link back to the
 * dashboard, so it replaces the plain « Mon espace » button.
 *
 * Theme-safety (cf. GAP-047): the figures use `text-foreground` over an opaque
 * `bg-card` — the one contrast pair guaranteed readable in all three themes — and
 * the accent tokens (`--flame`, `--gold`) tint only the decorative `aria-hidden`
 * icons. Until stats load it still renders the « Mon espace » label so the account
 * entry never flashes out.
 */
export function AccountHud() {
  const t = useT();
  const { xp, currentStreak, hasStats } = useMyStats();

  const streak = currentStreak ?? 0;
  // Compact the XP figure (e.g. 12 345 → "12.3k") so a large value never widens the
  // shrink-0 header cluster past the 360px phone viewport (multi-device audit S1/overflow).
  const xpDisplay = COMPACT_XP.format(xp ?? 0);

  return (
    <Link
      to="/dashboard"
      aria-label={t.public.header.account}
      data-testid="account-hud"
      className="flex min-w-0 max-w-[9rem] items-center gap-2 overflow-hidden rounded-lg border border-[color:var(--gold)]/40 bg-card px-2.5 py-1.5 text-sm font-semibold text-foreground shadow-sm transition hover:border-[color:var(--gold)]/70 sm:max-w-none sm:px-3"
    >
      {hasStats ? (
        <>
          <span
            className="flex shrink-0 items-center gap-1"
            title={`${streak} ${streak > 1 ? t.dashboard.days : t.dashboard.day}`}
          >
            <Flame className="h-4 w-4 text-[color:var(--flame)]" aria-hidden="true" />
            {streak}
          </span>
          <span aria-hidden="true" className="shrink-0 text-muted-foreground">
            ·
          </span>
          <span className="flex min-w-0 items-center gap-1">
            <Zap className="h-4 w-4 shrink-0 text-[color:var(--gold)]" aria-hidden="true" />
            <span className="truncate">{xpDisplay}</span>
            <span className="shrink-0 text-muted-foreground">XP</span>
          </span>
        </>
      ) : (
        t.public.header.account
      )}
    </Link>
  );
}

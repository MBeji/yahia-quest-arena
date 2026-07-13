import type { TranslationKeys } from "@/lib/i18n/types";
import type { DuelLastAward, DuelLeagueRow } from "../duel.server";
import { tierLabel } from "../duel-tiers";

type DuelLabels = TranslationKeys["duel"];

/**
 * US-7: the weekly league — championship-points standings (win 3 / draw 1) plus
 * a banner for last week's end-of-season coin award. Pure presentational.
 */
export function DuelLeague({
  rows,
  lastAward,
  labels,
}: {
  rows: DuelLeagueRow[];
  lastAward: DuelLastAward;
  labels: DuelLabels;
}) {
  return (
    <section className="space-y-2">
      <h2 className="font-display text-xl font-bold">{labels.leagueTitle}</h2>
      <p className="text-xs text-muted-foreground">{labels.leagueSubtitle}</p>

      {lastAward ? (
        <p className="rounded-lg border border-gold/30 bg-gold/10 px-3 py-2 text-sm text-gold">
          {labels.lastAward
            .replace("{tier}", tierLabel(lastAward.tier, labels))
            .replace("{coins}", String(lastAward.coins))}
        </p>
      ) : null}

      {rows.length === 0 ? (
        <p className="text-sm text-muted-foreground">{labels.leagueEmpty}</p>
      ) : (
        <ul className="divide-y divide-border/50 rounded-xl border border-border/50 bg-black/40 backdrop-blur-md">
          {rows.map((r) => (
            <li
              key={`${r.rank}-${r.displayName ?? "?"}`}
              className={`flex items-center justify-between px-3 py-2 text-sm ${
                r.isMe ? "bg-gold/10 font-semibold" : ""
              }`}
            >
              <span className="flex items-center gap-2">
                <span className="w-6 tabular-nums text-muted-foreground">{r.rank}</span>
                <span>{r.displayName ?? "—"}</span>
                <span className="rounded bg-muted px-1.5 py-0.5 text-xs text-muted-foreground">
                  {tierLabel(r.tier, labels)}
                </span>
              </span>
              <span className="tabular-nums">
                {labels.leaguePts.replace("{n}", String(r.points))}
              </span>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

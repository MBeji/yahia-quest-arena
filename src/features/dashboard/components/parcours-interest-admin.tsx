import { useT } from "@/lib/i18n";
import type { ParcoursInterestCount } from "../parcours-interest.server";

/**
 * Admin priority ranking: coming-soon programs ordered by how many users
 * registered interest (busiest first). Drives "build the most-wanted class next".
 * Presentational — data comes from `getParcoursInterestCounts`.
 */
export function ParcoursInterestAdmin({ counts }: { counts: ParcoursInterestCount[] }) {
  const t = useT();

  if (counts.length === 0) {
    return (
      <div className="rounded-2xl border border-border/50 bg-card/30 p-8 text-center text-sm text-muted-foreground">
        {t.parcoursInterest.empty}
      </div>
    );
  }

  return (
    <div className="overflow-hidden rounded-2xl border border-border/50">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-border/50 bg-card/40 text-left text-xs uppercase tracking-wider text-muted-foreground">
            <th className="w-12 px-4 py-3">#</th>
            <th className="px-4 py-3">{t.parcoursInterest.colProgram}</th>
            <th className="px-4 py-3 text-right">{t.parcoursInterest.colInterest}</th>
          </tr>
        </thead>
        <tbody>
          {counts.map((c, i) => (
            <tr key={c.parcoursId} className="border-b border-border/30 last:border-0">
              <td className="px-4 py-3 text-muted-foreground">{i + 1}</td>
              <td className="px-4 py-3 font-semibold">{c.name}</td>
              <td className="px-4 py-3 text-right font-bold text-[color:var(--gold)]">{c.count}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

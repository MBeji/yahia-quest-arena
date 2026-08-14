import type { EconomyOverview } from "../economy.server";

/**
 * Le tableau de bord économique (étude 09 lot 1, US-1…US-4) — read-only.
 *
 * Deux partis pris de lecture, tous deux issus de RISK-1 (« métriques vaniteuses ») :
 *
 *   * **jamais une moyenne seule** — p50/p90/max partout. Une moyenne d'XP flatte
 *     le tableau en noyant l'élève qui décroche, or c'est lui qu'on cherche ;
 *   * **une estimation se présente comme telle** — les sources de coins sont
 *     RECONSTRUITES (D-5 : `attempts` ne persiste pas les coins gagnés). Le mot
 *     « estimé » est sur l'écran, pas seulement dans un commentaire que personne ne
 *     lit. Un chiffre approximatif affiché comme un relevé est pire que pas de
 *     chiffre du tout : on décide dessus.
 *
 * Page admin FR uniquement, comme les autres consoles — RTL sans objet.
 */

const nf = new Intl.NumberFormat("fr-FR");
const fmt = (n: number | null | undefined, unit = ""): string =>
  n === null || n === undefined ? "—" : `${nf.format(Math.round(n * 100) / 100)}${unit}`;

function Card({
  title,
  hint,
  children,
}: {
  title: string;
  hint?: string;
  children: React.ReactNode;
}) {
  return (
    <section className="rounded-2xl border border-border/50 bg-surface-1 p-5">
      <h2 className="font-display text-lg font-bold">{title}</h2>
      {hint && <p className="mt-1 text-xs text-muted-foreground">{hint}</p>}
      <div className="mt-4">{children}</div>
    </section>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-xl bg-surface-2 p-3">
      <div className="text-xs uppercase tracking-widest text-muted-foreground">{label}</div>
      <div className="mt-1 font-mono text-lg tabular-nums">{value}</div>
    </div>
  );
}

export function EconomyAdmin({ data }: { data: EconomyOverview }) {
  const { xp_daily, level_velocity, coin_flows, consumables, premium_funnel } = data;

  // Le ratio de puits : sous 1, les coins s'accumulent plus vite qu'ils ne se
  // dépensent — la boutique cesse d'avoir de la valeur. NULL quand rien n'a été
  // gagné : on n'invente pas un pourcentage sur une économie à l'arrêt.
  const sinkPct = coin_flows.sink_ratio === null ? null : coin_flows.sink_ratio * 100;

  return (
    <div className="space-y-5">
      <Card
        title="Rythme d'XP (30 jours)"
        hint="Par élève et par jour actif. Percentiles, jamais une moyenne : c'est l'écart qui informe."
      >
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4" data-testid="econ-xp">
          <Stat label="médiane (p50)" value={fmt(xp_daily.p50, " XP")} />
          <Stat label="p90" value={fmt(xp_daily.p90, " XP")} />
          <Stat label="max" value={fmt(xp_daily.max, " XP")} />
          <Stat label="jours actifs" value={fmt(xp_daily.active_days)} />
        </div>
      </Card>

      <Card
        title="Vitesse de progression"
        hint="Jours réels entre la première tentative et chaque palier."
      >
        {level_velocity.length === 0 ? (
          <p className="text-sm text-muted-foreground" data-testid="econ-levels-empty">
            Aucun élève n'a encore franchi un palier — rien à mesurer pour l'instant.
          </p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm" data-testid="econ-levels">
              <thead>
                <tr className="text-xs uppercase tracking-widest text-muted-foreground">
                  <th className="p-2 text-start">Niveau</th>
                  <th className="p-2 text-end">Élèves</th>
                  <th className="p-2 text-end">p50 (jours)</th>
                  <th className="p-2 text-end">p90 (jours)</th>
                </tr>
              </thead>
              <tbody>
                {level_velocity.map((row) => (
                  <tr key={row.level_reached} className="border-t border-border/30">
                    <td className="p-2 font-semibold">{row.level_reached}</td>
                    <td className="p-2 text-end tabular-nums">{fmt(row.students)}</td>
                    <td className="p-2 text-end tabular-nums">{fmt(row.p50_days)}</td>
                    <td className="p-2 text-end tabular-nums">{fmt(row.p90_days)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      <Card
        title="Flux de coins (30 jours)"
        hint="Sources et puits sont RÉELS : une tentative récompensée (xp_earned > 0) verse le forfait de son exercice. Seul écart connu — un multiplicateur de potion n'est stocké nulle part, donc les sources sont un plancher."
      >
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-3" data-testid="econ-coins">
          <Stat label="sources versées" value={fmt(coin_flows.sources_earned)} />
          <Stat label="puits — boutique" value={fmt(coin_flows.sinks_shop)} />
          <Stat label="puits / sources" value={sinkPct === null ? "—" : `${fmt(sinkPct)} %`} />
        </div>
        {sinkPct !== null && sinkPct < 60 && (
          <p
            className="mt-3 text-xs text-[color:var(--flame)]"
            data-testid="econ-inflation-warning"
          >
            Les puits absorbent moins de 60 % des sources : les coins s'accumulent, la boutique perd
            de sa valeur.
          </p>
        )}
      </Card>

      <Card
        title="Consommables"
        hint="Un objet acquis et jamais consommé n'est pas un bug : c'est un signal de design."
      >
        <div className="overflow-x-auto">
          <table className="w-full text-sm" data-testid="econ-consumables">
            <thead>
              <tr className="text-xs uppercase tracking-widest text-muted-foreground">
                <th className="p-2 text-start">Objet</th>
                <th className="p-2 text-end">Prix</th>
                <th className="p-2 text-end">Acquis</th>
                <th className="p-2 text-end">Encore armés</th>
                <th className="p-2 text-end">Consommés</th>
              </tr>
            </thead>
            <tbody>
              {consumables.map((c) => (
                <tr key={c.code} className="border-t border-border/30">
                  <td className="p-2">
                    {c.name}
                    <span className="ms-2 text-xs text-muted-foreground">{c.item_type}</span>
                  </td>
                  <td className="p-2 text-end tabular-nums">{fmt(c.price_coins)}</td>
                  <td className="p-2 text-end tabular-nums">{fmt(c.acquired)}</td>
                  <td className="p-2 text-end tabular-nums">{fmt(c.still_armed)}</td>
                  <td className="p-2 text-end tabular-nums">{fmt(c.consumed)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>

      <Card
        title="Funnel d'accès"
        hint="Dormant pendant la phase gratuite : aucun parcours n'est payant, ces compteurs doivent donc être à zéro. La section existe pour le jour où la phase change."
      >
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4" data-testid="econ-funnel">
          <Stat label="actifs (30 j)" value={fmt(premium_funnel.active_30d)} />
          <Stat label="avec accès" value={fmt(premium_funnel.entitled_total)} />
          <Stat label="actifs × accès" value={fmt(premium_funnel.active_entitled)} />
          <Stat label="parcours payants" value={fmt(premium_funnel.premium_parcours)} />
        </div>
      </Card>
    </div>
  );
}

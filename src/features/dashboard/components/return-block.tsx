import {
  readReturnCohort,
  ratePct,
  sumReturnCohorts,
  type ReturnOverview,
} from "../return-overview";

/**
 * Bloc « Le retour » de la console Engagement (étude 40 lot 0, US-1) — read-only.
 *
 * Trois lectures, chacune avec sa réserve écrite à côté du chiffre :
 *
 *   * **la première quête et le retour, par cohorte d'inscription.** « Mesurable » (la fenêtre
 *     de sept jours est écoulée) est distingué de « perdu » (mesurable, et n'a pas joué). Un
 *     compte d'hier est « en attente » : il n'apparaît ni dans les perdus, ni dans un taux.
 *   * **la portée du push** — combien de personnes le seul canal de rappel peut atteindre.
 *   * **les jamais-joué** — avec leur dénominateur, toujours.
 *
 * Le bloc a SA lecture (`admin_return_overview`), donc SES états : chargement, erreur, vide. Sa
 * panne n'emporte pas le reste de la console.
 *
 * Le retour des visiteurs SANS compte ne se lit pas ici : il part vers PostHog (`visit_first`,
 * `visit_returned`), et le bloc le dit plutôt que de laisser croire que ces chiffres le couvrent.
 */

const nf = new Intl.NumberFormat("fr-FR");
const pct = (n: number | null): string => (n === null ? "—" : `${nf.format(n)} %`);
const ratio = (part: number, base: number): string =>
  base > 0 ? `${nf.format(part)}/${nf.format(base)}` : "—";

/** Un lundi en jj/mm — lu dans la chaîne, sans passer par un fuseau. */
const shortDay = (iso: string): string => {
  const [, m, d] = iso.slice(0, 10).split("-");
  return m && d ? `${d}/${m}` : iso;
};

function Figure({ label, value, hint }: { label: string; value: string; hint?: string }) {
  return (
    <div className="rounded-xl bg-surface-2 p-3">
      <div className="text-xs uppercase tracking-widest text-muted-foreground">{label}</div>
      <div className="mt-1 font-mono text-lg tabular-nums">{value}</div>
      {hint && <div className="mt-1 text-xs text-muted-foreground">{hint}</div>}
    </div>
  );
}

export function ReturnBlock({
  data,
  isPending,
  isError,
}: {
  data: ReturnOverview | undefined;
  isPending: boolean;
  isError: boolean;
}) {
  return (
    <section
      className="rounded-2xl border border-border/50 bg-surface-1 p-5"
      data-testid="eng-return"
    >
      <h2 className="font-display text-lg font-bold">Le retour</h2>
      <p className="mt-1 text-xs text-muted-foreground">
        Côté comptes. Première quête = au moins un jour d'activité dans les sept jours qui suivent
        l'inscription, jour de l'inscription compris. Retour = au moins un jour entre J+1 et J+7.
        Une cohorte n'est jugée que sur ses comptes dont les sept jours sont écoulés : les autres
        sont « en attente », ni perdus ni gagnés. Le retour des visiteurs sans compte se lit dans
        PostHog (<code className="font-mono">visit_first</code>,{" "}
        <code className="font-mono">visit_returned</code>).
      </p>

      <div className="mt-4">
        {isError ? (
          <p className="text-sm text-destructive" data-testid="eng-return-error">
            Impossible de charger la mesure du retour. Le reste de la console n'est pas touché.
          </p>
        ) : isPending || !data ? (
          <p className="text-sm text-muted-foreground" data-testid="eng-return-loading">
            Calcul de la mesure du retour…
          </p>
        ) : (
          <ReturnFigures data={data} />
        )}
      </div>
    </section>
  );
}

function ReturnFigures({ data }: { data: ReturnOverview }) {
  const total = sumReturnCohorts(data.cohorts);
  const { push } = data;

  return (
    <div className="space-y-4">
      {total.signups === 0 ? (
        <p className="text-sm text-muted-foreground" data-testid="eng-return-empty">
          Aucune inscription sur les huit dernières semaines : il n'y a ni première quête ni retour
          à mesurer.
        </p>
      ) : (
        <>
          <p className="text-sm">
            Première quête, huit semaines cumulées :{" "}
            <span className="font-mono font-bold tabular-nums" data-testid="eng-return-first-quest">
              {ratio(total.played, total.playedBase)}
            </span>{" "}
            <span className="text-muted-foreground">
              ({pct(ratePct(total.played, total.playedBase))}) — retour à sept jours :{" "}
              {ratio(total.back, total.backBase)} ({pct(ratePct(total.back, total.backBase))}).{" "}
              {nf.format(total.pending)} compte(s) en attente.
            </span>
          </p>
          <div className="overflow-x-auto">
            <table className="w-full text-sm" data-testid="eng-return-cohorts">
              <thead>
                <tr className="text-xs uppercase tracking-widest text-muted-foreground">
                  <th className="p-2 text-start">Cohorte</th>
                  <th className="p-2 text-end">Inscrits</th>
                  <th className="p-2 text-end">Confirmés</th>
                  <th className="p-2 text-end">Mesurables</th>
                  <th className="p-2 text-end">En attente</th>
                  <th className="p-2 text-end">1ʳᵉ quête</th>
                  <th className="p-2 text-end">Revenus</th>
                  <th className="p-2 text-end">Perdus</th>
                </tr>
              </thead>
              <tbody>
                {data.cohorts.map((cohort) => {
                  const reading = readReturnCohort(cohort);
                  // Sans compte mesurable, « perdus » et les taux n'ont pas de sens : un tiret.
                  const judged = reading.measurable > 0;
                  return (
                    <tr key={cohort.week} className="border-t border-border/30">
                      <td className="p-2 font-semibold">{shortDay(cohort.week)}</td>
                      <td className="p-2 text-end tabular-nums">{nf.format(cohort.signups)}</td>
                      <td className="p-2 text-end tabular-nums">{nf.format(cohort.confirmed)}</td>
                      <td className="p-2 text-end tabular-nums">{nf.format(reading.measurable)}</td>
                      <td className="p-2 text-end tabular-nums">{nf.format(reading.pending)}</td>
                      <td className="p-2 text-end tabular-nums">
                        {judged
                          ? `${nf.format(cohort.played_7d)} (${pct(reading.playedPct)})`
                          : "—"}
                      </td>
                      <td className="p-2 text-end tabular-nums">
                        {judged ? `${nf.format(cohort.back_7d)} (${pct(reading.backPct)})` : "—"}
                      </td>
                      <td className="p-2 text-end tabular-nums">
                        {judged ? nf.format(reading.lost) : "—"}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </>
      )}

      <div className="grid grid-cols-2 gap-3 sm:grid-cols-3" data-testid="eng-return-reach">
        <Figure
          label="élèves joignables par push"
          value={nf.format(push.students_reachable)}
          hint={`${nf.format(push.students_active_30d)} actif(s) sur 30 jours`}
        />
        <Figure
          label="parents joignables par push"
          value={nf.format(push.parents_reachable)}
          hint={`${nf.format(push.parents_linked)} parent(s) lié(s) à un élève`}
        />
        <div data-testid="eng-return-never">
          <Figure
            label="jamais joué"
            value={ratio(data.never_played, data.students)}
            hint="élèves sans aucun jour d'activité"
          />
        </div>
      </div>
    </div>
  );
}

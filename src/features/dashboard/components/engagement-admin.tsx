import type { EngagementOverview } from "../engagement.server";
import { PRODUCT_EVENT_CATALOGUE } from "@/shared/lib/product-events";

/**
 * Console « Engagement » (étude 31 lot 1, US-13) — read-only.
 *
 * Trois partis pris de lecture, tous les trois issus des lignes rouges :
 *
 *   * **R-1 — la métrique de garde est SUR LA MÊME PAGE.** Précision et
 *     progression ouvrent l'écran, avant la rétention. Un engagement qui monte
 *     pendant que l'apprentissage baisse est un échec de l'étude ; le mettre
 *     dans un autre onglet reviendrait à ne jamais le lire.
 *   * **« pas encore mesurable » ≠ « personne n'est revenu ».** Une cohorte dont
 *     la fenêtre n'est pas écoulée affiche « — », jamais 0 %. Un zéro inventé
 *     déclenche des décisions ; un tiret déclenche de la patience.
 *   * **l'instrumentation se voit** (§3.7) : la dernière carte liste la liste
 *     fermée des événements produit et dit lesquels ne sont pas encore câblés.
 *
 * Page admin FR uniquement, comme les autres consoles — RTL sans objet.
 */

const nf = new Intl.NumberFormat("fr-FR");
const num = (n: number | null | undefined, unit = ""): string =>
  n === null || n === undefined ? "—" : `${nf.format(Math.round(n * 100) / 100)}${unit}`;
const pct = (n: number | null | undefined): string =>
  n === null || n === undefined ? "—" : `${nf.format(n)} %`;

/** Une semaine ISO en jj/mm — l'année n'apporte rien sur une série de 8 semaines. */
const shortDay = (iso: string): string => {
  const d = new Date(iso);
  return Number.isNaN(d.getTime())
    ? iso
    : d.toLocaleDateString("fr-FR", { day: "2-digit", month: "2-digit" });
};

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

export function EngagementAdmin({ data }: { data: EngagementOverview }) {
  const { curr, cohorts, activity, streaks, push, learning, notes } = data;

  // KPI-A publiable : la dernière semaine dont la CURR est calculable.
  const latestCurr = [...curr].reverse().find((w) => w.curr_pct !== null) ?? null;
  const maxDaily = Math.max(1, ...activity.daily.map((d) => d.actives));
  const kpiC =
    streaks.weekly_active > 0
      ? Math.round((1000 * streaks.weekly_active_7plus) / streaks.weekly_active) / 10
      : null;

  return (
    <div className="space-y-5">
      {/* R-1 EN PREMIER — l'engagement n'a le droit d'être lu qu'à côté de ça. */}
      <Card
        title="Métrique de garde — l'apprentissage (KPI-E)"
        hint="R-1 : aucun chiffre d'engagement ne se lit seul. Si la précision ou la progression baissent pendant que le reste monte, l'étude a échoué. Aucun objectif de « temps passé » n'existe ici."
      >
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4" data-testid="eng-learning">
          <Stat label="précision moyenne" value={pct(learning.accuracy_avg_pct)} />
          <Stat label="précision médiane" value={pct(learning.accuracy_p50_pct)} />
          <Stat label="chapitres / actif" value={num(learning.chapters_per_active)} />
          <Stat label="tentatives (30 j)" value={num(learning.attempts_30d)} />
        </div>
      </Card>

      <Card
        title="Rétention hebdomadaire — CURR (KPI-A)"
        hint="Part des élèves actifs en semaine N revenus en semaine N+1. Semaines ISO, fuseau Tunis. La semaine en cours et la précédente ne sont pas mesurables (leur suite n'est pas finie) — elles ne figurent pas."
      >
        {latestCurr === null ? (
          <p className="text-sm text-muted-foreground" data-testid="eng-curr-empty">
            Aucune semaine ne compte encore d'élève actif : la CURR n'a rien à mesurer. C'est l'état
            attendu tant que l'acquisition (KPI-1) n'a pas ouvert de canal.
          </p>
        ) : (
          <>
            <p className="mb-3 text-sm">
              Dernière semaine mesurable ({shortDay(latestCurr.week_start)}) :{" "}
              <span className="font-mono font-bold tabular-nums" data-testid="eng-curr-latest">
                {pct(latestCurr.curr_pct)}
              </span>{" "}
              <span className="text-muted-foreground">
                ({latestCurr.returned}/{latestCurr.active} élèves)
              </span>
            </p>
            <div className="overflow-x-auto">
              <table className="w-full text-sm" data-testid="eng-curr">
                <thead>
                  <tr className="text-xs uppercase tracking-widest text-muted-foreground">
                    <th className="p-2 text-start">Semaine</th>
                    <th className="p-2 text-end">Actifs</th>
                    <th className="p-2 text-end">Revenus</th>
                    <th className="p-2 text-end">CURR</th>
                  </tr>
                </thead>
                <tbody>
                  {curr.map((w) => (
                    <tr key={w.week_start} className="border-t border-border/30">
                      <td className="p-2 font-semibold">{shortDay(w.week_start)}</td>
                      <td className="p-2 text-end tabular-nums">{num(w.active)}</td>
                      <td className="p-2 text-end tabular-nums">{num(w.returned)}</td>
                      <td className="p-2 text-end tabular-nums">{pct(w.curr_pct)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        )}
      </Card>

      <Card
        title="Rétention par cohorte d'inscription (KPI-B)"
        hint="D-N = revenu au moins une fois dans les N jours qui suivent l'inscription (le jour de l'inscription ne compte pas). « — » = la fenêtre n'est pas écoulée, donc rien n'est mesurable — ce n'est pas un zéro. Cible : D7 ≥ 25-30 %, D30 ≥ 15 % ; alerte sous 15 % à D7."
      >
        {cohorts.length === 0 ? (
          <p className="text-sm text-muted-foreground" data-testid="eng-cohorts-empty">
            Aucune inscription sur les 8 dernières semaines.
          </p>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm" data-testid="eng-cohorts">
              <thead>
                <tr className="text-xs uppercase tracking-widest text-muted-foreground">
                  <th className="p-2 text-start">Cohorte</th>
                  <th className="p-2 text-end">Inscrits</th>
                  <th className="p-2 text-end">D1</th>
                  <th className="p-2 text-end">D7</th>
                  <th className="p-2 text-end">D30</th>
                </tr>
              </thead>
              <tbody>
                {cohorts.map((c) => (
                  <tr key={c.cohort_week} className="border-t border-border/30">
                    <td className="p-2 font-semibold">{shortDay(c.cohort_week)}</td>
                    <td className="p-2 text-end tabular-nums">{num(c.size)}</td>
                    <td className="p-2 text-end tabular-nums">{pct(c.d1_pct)}</td>
                    <td className="p-2 text-end tabular-nums">{pct(c.d7_pct)}</td>
                    <td className="p-2 text-end tabular-nums">{pct(c.d30_pct)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      <Card
        title="Activité"
        hint="Actif = au moins une tentative terminée ou un pouls d'apprentissage sur la journée (la navigation seule ne compte pas). Jours en fuseau Tunis."
      >
        <div className="grid grid-cols-3 gap-3" data-testid="eng-activity">
          <Stat label="DAU (aujourd'hui)" value={num(activity.dau)} />
          <Stat label="WAU (7 j)" value={num(activity.wau)} />
          <Stat label="MAU (30 j)" value={num(activity.mau)} />
        </div>
        <div className="mt-4 flex h-16 items-end gap-1" data-testid="eng-daily">
          {activity.daily.map((d) => (
            <div
              key={d.day}
              className="flex-1 rounded-t bg-[color:var(--gold)]/70"
              style={{ height: `${Math.max(4, (100 * d.actives) / maxDaily)}%` }}
              title={`${shortDay(d.day)} — ${d.actives} actif(s)`}
            />
          ))}
        </div>
      </Card>

      <Card
        title="Séries (KPI-C)"
        hint="Série EFFECTIVE : la colonne `current_streak` n'est réécrite que quand l'élève gagne de l'XP, donc un élève parti depuis dix jours y porte encore sa vieille valeur. Elle est remise à zéro ici dès que la dernière activité a plus d'un jour."
      >
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4" data-testid="eng-streaks">
          <Stat label="série éteinte" value={num(streaks.b0)} />
          <Stat label="1 à 6 jours" value={num(streaks.b1_6)} />
          <Stat label="7 à 29 jours" value={num(streaks.b7_29)} />
          <Stat label="30 jours et +" value={num(streaks.b30_plus)} />
        </div>
        <p className="mt-3 text-sm text-muted-foreground">
          Actifs de la semaine tenant une série ≥ 7 jours :{" "}
          <span className="font-mono tabular-nums text-foreground" data-testid="eng-kpi-c">
            {pct(kpiC)}
          </span>{" "}
          ({streaks.weekly_active_7plus}/{streaks.weekly_active}) — référence interne à établir.
        </p>
      </Card>

      <Card
        title="Notifications (KPI-D)"
        hint="Garde-fou R-4 : opt-out mensuel sous 5 % des opt-in. Le désabonnement supprime la ligne d'abonnement — c'est le journal de consentement qui le rend comptable."
      >
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4" data-testid="eng-push">
          <Stat label="élèves abonnés" value={num(push.optin_students)} />
          <Stat
            label="taux d'opt-in"
            value={
              push.students_total > 0
                ? pct(Math.round((1000 * push.optin_students) / push.students_total) / 10)
                : "—"
            }
          />
          <Stat label="coupures (30 j)" value={num(push.optout_30d)} />
          <Stat label="taux d'opt-out" value={pct(push.optout_pct)} />
        </div>
        {push.optout_pct !== null && push.optout_pct >= 5 && (
          <p className="mt-3 text-xs text-flame-ink" data-testid="eng-optout-warning">
            Le garde-fou R-4 est franchi : plus de 5 % des abonnés ont coupé les notifications sur
            30 jours. C'est le signal de RISK-2 (sur-notification), pas un chiffre à commenter.
          </p>
        )}
      </Card>

      <Card
        title="Instrumentation produit"
        hint="La liste FERMÉE des événements envoyés à PostHog (§3.6). Zéro PII, profils de personne désactivés : PostHog compte des passages, la rétention ci-dessus compte des personnes (Postgres). Les volumes se lisent dans PostHog — cette carte dit ce qui est branché, pas combien."
      >
        <ul className="space-y-1.5 text-sm" data-testid="eng-events">
          {PRODUCT_EVENT_CATALOGUE.map((e) => (
            <li key={e.name} className="flex flex-wrap items-baseline gap-x-2">
              <code className="font-mono text-xs">{e.name}</code>
              <span className="text-muted-foreground">— {e.fires}</span>
              {!e.live && (
                <span className="text-xs text-flame-ink">
                  (pas encore émis{e.note ? ` : ${e.note}` : ""})
                </span>
              )}
            </li>
          ))}
        </ul>
      </Card>

      <p className="text-xs text-muted-foreground" data-testid="eng-notes">
        Semaines et jours : {notes.week_timezone}. Séries : {notes.streak_clock}. Activité :{" "}
        {notes.activity_rule}. Calcul du {new Date(notes.generated_at).toLocaleString("fr-FR")}.
      </p>
    </div>
  );
}

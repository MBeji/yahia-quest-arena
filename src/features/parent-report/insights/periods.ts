/**
 * Les périodes du tableau de bord parental — aujourd'hui, hier, 7 jours,
 * 30 jours, cette semaine, ce mois, ou une plage choisie.
 *
 * Tout est calculé dans le fuseau du RAPPORT, pas dans celui du navigateur : le
 * SQL découpe les journées en heure tunisienne, et un parent en déplacement à
 * Paris ou à Montréal doit voir exactement les mêmes journées que son enfant.
 * Un « aujourd'hui » calculé côté client dériverait d'un jour.
 *
 * Les dates circulent en `YYYY-MM-DD` : c'est ce que la RPC attend, et c'est
 * ordonnable lexicographiquement — donc comparable sans reparser.
 */

/** Doit rester aligné sur `c_tz` dans `get_student_daily_report`. */
export const REPORT_TIMEZONE = "Africa/Tunis";

/** Miroir de `c_max_days` côté SQL — au-delà, le serveur tronque de toute façon. */
export const MAX_RANGE_DAYS = 92;

export type PeriodPresetKey =
  "today" | "yesterday" | "last7" | "last30" | "thisWeek" | "thisMonth" | "custom";

export type DateRange = { from: string; to: string };

/** La date du jour DANS le fuseau du rapport, au format `YYYY-MM-DD`. */
export function todayInReportTz(now: Date = new Date(), timeZone = REPORT_TIMEZONE): string {
  // `en-CA` rend nativement l'ISO court — pas de reconstruction manuelle.
  return new Intl.DateTimeFormat("en-CA", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(now);
}

/** Décale une date ISO de `delta` jours (négatif = vers le passé). */
export function shiftDays(iso: string, delta: number): string {
  const ms = Date.parse(`${iso}T00:00:00Z`);
  if (Number.isNaN(ms)) return iso;
  return new Date(ms + delta * 86_400_000).toISOString().slice(0, 10);
}

/** Nombre de jours couverts par la plage, bornes incluses (1 minimum). */
export function rangeLengthDays(range: DateRange): number {
  const from = Date.parse(`${range.from}T00:00:00Z`);
  const to = Date.parse(`${range.to}T00:00:00Z`);
  if (Number.isNaN(from) || Number.isNaN(to)) return 1;
  return Math.max(1, Math.round((to - from) / 86_400_000) + 1);
}

/** Jour de la semaine ISO (1 = lundi … 7 = dimanche). */
function isoWeekday(iso: string): number {
  const day = new Date(`${iso}T00:00:00Z`).getUTCDay();
  return day === 0 ? 7 : day;
}

/**
 * Remet la plage dans l'ordre et la borne à `MAX_RANGE_DAYS`, comme le fait le
 * serveur. Le client applique la même règle pour que l'intitulé affiché
 * (« 92 derniers jours ») corresponde vraiment aux données reçues.
 */
export function clampRange(range: DateRange): DateRange {
  const from = range.from <= range.to ? range.from : range.to;
  const to = range.from <= range.to ? range.to : range.from;
  const length = rangeLengthDays({ from, to });
  return length > MAX_RANGE_DAYS
    ? { from: shiftDays(to, -(MAX_RANGE_DAYS - 1)), to }
    : { from, to };
}

/**
 * Traduit un choix de période en plage de dates.
 *
 * « 7 derniers jours » inclut aujourd'hui (J-6 → J) : c'est la lecture naturelle
 * d'un parent le soir, qui veut voir la journée en cours dans le total.
 */
export function resolvePeriod(
  preset: PeriodPresetKey,
  options: { today?: string; custom?: DateRange } = {},
): DateRange {
  const today = options.today ?? todayInReportTz();

  switch (preset) {
    case "today":
      return { from: today, to: today };
    case "yesterday": {
      const y = shiftDays(today, -1);
      return { from: y, to: y };
    }
    case "last7":
      return { from: shiftDays(today, -6), to: today };
    case "last30":
      return { from: shiftDays(today, -29), to: today };
    case "thisWeek":
      // Semaine à la française/tunisienne : elle commence le lundi.
      return { from: shiftDays(today, -(isoWeekday(today) - 1)), to: today };
    case "thisMonth":
      return { from: `${today.slice(0, 7)}-01`, to: today };
    case "custom":
      return clampRange(options.custom ?? { from: today, to: today });
  }
}

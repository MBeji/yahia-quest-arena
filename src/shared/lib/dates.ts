/** UTC date helpers. Pure — never mutate the input Date. */

/** Format a Date as 'YYYY-MM-DD' using its UTC fields. */
function toUtcDateString(date: Date): string {
  return date.toISOString().slice(0, 10);
}

/** Current UTC date as 'YYYY-MM-DD'. */
export function getTodayUtc(now: Date = new Date()): string {
  return toUtcDateString(now);
}

/** UTC date ('YYYY-MM-DD') of the day before `now`. */
export function getYesterdayUtc(now: Date = new Date()): string {
  const yesterday = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() - 1),
  );
  return toUtcDateString(yesterday);
}

/** ISO date ('YYYY-MM-DD') of Monday of the current UTC week. */
export function getCurrentWeekStartUtc(now: Date = new Date()): string {
  // getUTCDay(): Sunday = 0 ... Saturday = 6. Shift so Monday = 0.
  const dayFromMonday = (now.getUTCDay() + 6) % 7;
  const monday = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() - dayFromMonday),
  );
  return toUtcDateString(monday);
}

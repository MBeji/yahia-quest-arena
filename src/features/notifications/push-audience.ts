/**
 * Pure helpers for scheduled push: who receives a notification, and what it says.
 * No I/O here — the cron sender supplies the rows and the clock, so every branch
 * is trivially unit-testable (see __tests__/push-audience.test.ts).
 */

/** App timezone — all streak "day" boundaries are Tunisia-local. */
export const APP_TIME_ZONE = "Africa/Tunis";

export type PushPayload = { title: string; body: string; url: string; tag: string };

/** Minimal profile shape the streak-at-risk selection needs. */
export type StreakProfileRow = {
  id: string;
  current_streak: number;
  last_active_date: string | null;
};

/**
 * The civil date (YYYY-MM-DD) in the app timezone for a given instant.
 * `en-CA` formats as ISO-style YYYY-MM-DD; `timeZone` shifts to the Tunisia-local
 * calendar day so the comparison below is correct regardless of server UTC offset.
 */
export function appLocalDate(now: Date): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: APP_TIME_ZONE,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(now);
}

/**
 * A streak is "at risk" when the user still has a live streak (> 0) but has not
 * been active *today* (Tunisia-local) — it will reset at midnight unless they
 * return. `last_active_date` is a civil date string, so a lexicographic compare
 * is also chronological. A null date with a live streak is treated as at-risk.
 */
export function isStreakAtRisk(profile: StreakProfileRow, todayLocal: string): boolean {
  return profile.current_streak > 0 && (profile.last_active_date ?? "") < todayLocal;
}

export function selectStreakAtRiskUserIds(
  profiles: StreakProfileRow[],
  todayLocal: string,
): string[] {
  return profiles.filter((p) => isStreakAtRisk(p, todayLocal)).map((p) => p.id);
}

/**
 * v1 ships a single French copy: there is no per-user locale stored server-side
 * yet (the UI locale lives in a cookie). Per-locale push is a later increment.
 */
export function streakReminderPayload(): PushPayload {
  return {
    title: "🔥 Ton streak est en danger !",
    body: "Reviens vite faire une quête aujourd'hui pour sauver ta série. Ne laisse pas le boss reprendre l'avantage !",
    url: "/dashboard",
    tag: "streak-at-risk",
  };
}

/** The short weekday name ("Sun", "Mon", …) in the app timezone for a given instant. */
export function appLocalWeekday(now: Date): string {
  return new Intl.DateTimeFormat("en-US", {
    timeZone: APP_TIME_ZONE,
    weekday: "short",
  }).format(now);
}

/**
 * The weekly family digest goes out on Sunday evening (the daily cron fires at
 * 18:00 UTC → ~19:00 Tunis): parents open the week's report right before the
 * school week starts on Monday.
 */
export const PARENT_DIGEST_WEEKDAY = "Sun";

export function isParentDigestDay(now: Date): boolean {
  return appLocalWeekday(now) === PARENT_DIGEST_WEEKDAY;
}

/** Same single-copy convention as the streak reminder (per-locale is a later increment). */
export function weeklyParentDigestPayload(): PushPayload {
  return {
    title: "📋 Le bilan famille de la semaine est prêt",
    body: "Points forts, chapitres à revoir et le conseil de la semaine : ouvrez le suivi de votre enfant.",
    url: "/parent-report",
    tag: "weekly-family-report",
  };
}

/**
 * Pure helpers for scheduled push: who receives a notification, and what it says.
 * No I/O here — the cron sender supplies the rows and the clock, so every branch
 * is trivially unit-testable (see __tests__/push-audience.test.ts).
 */

// La journée de l'application a quitté ce fichier pour `shared/` (étude 11
// lot 2) : le tableau de bord en a besoin lui aussi, pour saluer un retour après
// absence, et une feature n'en importe pas une autre. Réexporté ici pour que les
// appelants existants — et leurs tests — ne bougent pas.
import { APP_TIME_ZONE } from "@/shared/lib/app-day";

export { APP_TIME_ZONE, appLocalDate } from "@/shared/lib/app-day";

export type PushPayload = { title: string; body: string; url: string; tag: string };

/** Minimal profile shape the streak-at-risk selection needs. */
export type StreakProfileRow = {
  id: string;
  current_streak: number;
  last_active_date: string | null;
};

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

/**
 * Le rappel du plan du jour — étude 11 US-7.
 *
 * « 1/jour max » est tenu par la SÉLECTION, pas par cette fonction : le rappel
 * de série vise exactement la même population (élève inactif aujourd'hui), et
 * le cron retire donc de cette audience-ci tous ceux qui viennent d'être
 * appelés. Deux notifications le même soir pour la même raison seraient la
 * meilleure façon de faire couper les notifications.
 *
 * Même convention de copie unique en français que les deux payloads voisins :
 * aucune locale n'est stockée côté serveur (elle vit dans un cookie). Le nombre
 * de révisions dues est interpolé, parce qu'un rappel qui dit COMBIEN se lit
 * comme un service, et un rappel qui dit « tu as du retard » comme un reproche.
 */
export function planReminderPayload(dueCount: number): PushPayload {
  return {
    title: "🎓 El Ostedh a préparé ton plan",
    body:
      dueCount === 1
        ? "Une seule révision t'attend aujourd'hui — cinq minutes et c'est réglé."
        : `${dueCount} révisions t'attendent aujourd'hui. On commence par la plus utile ?`,
    url: "/dashboard",
    tag: "tutor-daily-plan",
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

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

// é31 lot 4 — les TEXTES vivent dans `push-copy.ts` (trois langues, R-17) ; ce
// module garde ce qu'il a toujours gardé : QUI reçoit quoi, et quand.
export {
  PUSH_PRIORITY,
  PARENT_DIGEST_TAG,
  payloadFor,
  parentDigestPayload,
  safeLocale,
  type PushTag,
  type PushPayload,
} from "./push-copy";
import { PUSH_PRIORITY, type PushTag } from "./push-copy";

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

/**
 * ⭐ LE PIPELINE DE PRIORITÉ (R-4, R-16) — au plus UN push par élève et par jour.
 *
 * Avant ce lot, la règle tenait par une exclusion écrite à la main entre DEUX
 * audiences (é11 US-7 retirait de son audience ceux que le rappel de série
 * venait d'appeler). À six audiences, il faudrait quinze exclusions deux à deux,
 * et il suffirait d'en oublier une pour qu'un élève reçoive trois notifications
 * le même soir — c'est-à-dire pour qu'il les coupe (RISK-2).
 *
 * La règle devient donc STRUCTURELLE : la base rend des CANDIDATS, et cette
 * fonction n'en garde qu'un par élève, le plus prioritaire. Un tag ajouté demain
 * hérite de la garantie sans qu'on y pense — il lui suffit d'entrer dans
 * `PUSH_PRIORITY`.
 *
 * L'ordre (R-16) va du FAIT ACQUIS à la RELANCE : un résultat de ligue est une
 * nouvelle, une série perdue est une occasion de revenir, un plan est un
 * service, un « reviens » est le dernier recours.
 */
export type PushCandidate = {
  userId: string;
  tag: PushTag;
  locale: string | null;
  arg: number | null;
};

export function resolveDailyPushPlan(candidates: PushCandidate[]): PushCandidate[] {
  const rank = new Map<PushTag, number>(PUSH_PRIORITY.map((tag, index) => [tag, index]));
  const best = new Map<string, PushCandidate>();

  for (const candidate of candidates) {
    // Un tag hors liste ne peut pas être classé : on l'écarte plutôt que de le
    // faire gagner par accident (un rang inconnu vaudrait -1 ou +∞ selon le tri).
    if (!rank.has(candidate.tag)) continue;
    const current = best.get(candidate.userId);
    if (!current || (rank.get(candidate.tag) ?? 0) < (rank.get(current.tag) ?? 0)) {
      best.set(candidate.userId, candidate);
    }
  }

  return [...best.values()];
}

/**
 * Regroupe le plan par (tag, langue, nombre) : un envoi par groupe plutôt qu'un
 * par élève. Le transport prend une liste d'identifiants et UN payload.
 */
export function groupPushPlan(
  plan: PushCandidate[],
): { tag: PushTag; locale: string | null; arg: number | null; userIds: string[] }[] {
  const groups = new Map<
    string,
    { tag: PushTag; locale: string | null; arg: number | null; userIds: string[] }
  >();
  for (const candidate of plan) {
    const key = `${candidate.tag}|${candidate.locale ?? "fr"}|${candidate.arg ?? ""}`;
    const group = groups.get(key) ?? {
      tag: candidate.tag,
      locale: candidate.locale,
      arg: candidate.arg,
      userIds: [],
    };
    group.userIds.push(candidate.userId);
    groups.set(key, group);
  }
  return [...groups.values()];
}

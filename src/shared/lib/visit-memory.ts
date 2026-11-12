// LA MÉMOIRE DE VISITE — deux jours civils que l'APPAREIL retient (étude 40, lot 0, R-1 à R-3).
//
// CE QU'ELLE REND LISIBLE. « Revenu après une première visite » ne se lisait nulle part : PostHog
// ne sait pas dire qui est revenu (profils de personne désactivés — protection des mineurs), et
// Postgres ne compte que les comptes. Le visiteur sans compte, l'audience principale, n'avait donc
// aucun retour mesurable. Cette mémoire dit à l'appareil lui-même s'il est déjà venu.
//
// CE QUI EST RETENU, ET RIEN D'AUTRE (R-1). Une clé de `localStorage`, deux jours civils de Tunis :
//   `na9ra.visit` = { first: "AAAA-MM-JJ", last: "AAAA-MM-JJ" }
// Ni heure, ni page, ni identifiant. Elle n'est JAMAIS envoyée : ce module n'importe RIEN — ni
// client Supabase, ni server fn, ni mesure. Le test du module vérifie cette absence d'import. Ce
// qui part vers la mesure, c'est le VERDICT, émis par `visit-beacon.ts` : « première visite » ou
// « revenu, dans telle tranche de jours ».
//
// LE JOUR EST REÇU, PAS CALCULÉ ICI. L'appelant (`__root.tsx`) passe le jour civil de Tunis
// (`appLocalDate`, le seul calcul de jour du produit). Raison mesurée : importé d'ici, `app-day`
// devenait un chunk partagé de plus, donc une requête de plus sur chaque page — le budget
// runtime des pages publiques (`perf/runtime/budget.mjs`) compte les requêtes une à une.
//
// LE SENS SÛR (R-1). Stockage indisponible, plein, illisible ou incohérent ⇒ AUCUN événement de
// visite. On sous-compte, on ne sur-compte jamais : un navigateur en navigation privée qui
// émettrait `visit_first` à chaque page ferait mentir le dénominateur de KPI-1.
//
// Même discipline défensive que `anon-continuity.ts` (étude 38 lot 5) ; pas la même forme :
// ici tout est injecté (le jour, le stockage), parce que chaque règle a son test nommé.

/** La clé. Sans limite de durée ; effacée avec les données du site. */
export const VISIT_KEY = "na9ra.visit";

/** Les deux jours civils de Tunis que l'appareil retient. */
export type VisitMemory = { readonly first: string; readonly last: string };

/** R-3 — la tranche, jamais le nombre exact, jamais la date. */
export type DaysBucket = "1" | "2-7" | "8-30" | "31+";

/**
 * Ce que la visite du jour EST, pour la mesure :
 *   - `first`    : l'appareil n'avait aucune mémoire, elle vient d'être écrite ;
 *   - `returned` : il était déjà venu un AUTRE jour — c'est le retour ;
 *   - `none`     : déjà compté aujourd'hui, ou rien de fiable à dire (sens sûr).
 */
export type VisitVerdict =
  | { readonly kind: "first" }
  | { readonly kind: "returned"; readonly daysBucket: DaysBucket }
  | { readonly kind: "none" };

/** Le strict nécessaire d'un `Storage` — ce qui permet de l'injecter dans les tests. */
export type VisitStorage = Pick<Storage, "getItem" | "setItem">;

const NONE: VisitVerdict = { kind: "none" };
const DAY_MS = 24 * 60 * 60 * 1000;
const CIVIL_DAY = /^(\d{4})-(\d{2})-(\d{2})$/;

/** Le rang d'un jour civil (jours depuis l'époque), ou `null` si ce n'en est pas un. */
function dayIndex(value: unknown): number | null {
  if (typeof value !== "string") return null;
  const match = CIVIL_DAY.exec(value);
  if (!match) return null;
  const [, y, m, d] = match;
  const ms = Date.UTC(Number(y), Number(m) - 1, Number(d));
  // `Date.UTC` normalise un 31 février en 3 mars : on refuse ce qui ne se relit pas à l'identique.
  return new Date(ms).toISOString().slice(0, 10) === value ? ms / DAY_MS : null;
}

/** R-3 — la tranche d'un écart en jours (≥ 1). */
export function bucketDays(days: number): DaysBucket {
  if (days <= 1) return "1";
  if (days <= 7) return "2-7";
  if (days <= 30) return "8-30";
  return "31+";
}

/** La mémoire relue, ou `null` si elle n'a pas la forme que ce module écrit. */
export function parseVisitMemory(raw: string | null): VisitMemory | null {
  if (!raw) return null;
  let value: unknown;
  try {
    value = JSON.parse(raw);
  } catch {
    return null;
  }
  if (typeof value !== "object" || value === null) return null;
  const { first, last } = value as { first?: unknown; last?: unknown };
  const firstIndex = dayIndex(first);
  const lastIndex = dayIndex(last);
  if (firstIndex === null || lastIndex === null || firstIndex > lastIndex) return null;
  return { first: first as string, last: last as string };
}

/**
 * R-2, en PUR : ce que vaut la visite d'aujourd'hui, et ce que la mémoire doit devenir
 * (`next === null` ⇒ ne rien écrire).
 */
export function classifyVisit(
  memory: VisitMemory | null,
  today: string,
): { readonly verdict: VisitVerdict; readonly next: VisitMemory | null } {
  if (memory === null) return { verdict: { kind: "first" }, next: { first: today, last: today } };
  const todayIndex = dayIndex(today);
  const lastIndex = dayIndex(memory.last);
  // Même jour ⇒ rien (au plus un événement par jour et par appareil). `last` dans le FUTUR
  // (horloge reculée) ⇒ rien non plus, et on n'écrit pas : l'horloge se corrigera d'elle-même.
  if (todayIndex === null || lastIndex === null || lastIndex >= todayIndex) {
    return { verdict: NONE, next: null };
  }
  return {
    verdict: { kind: "returned", daysBucket: bucketDays(todayIndex - lastIndex) },
    next: { first: memory.first, last: today },
  };
}

/** Le `localStorage` du navigateur, ou `null` : rendu serveur, accès refusé (navigation privée). */
function browserStorage(): VisitStorage | null {
  try {
    return typeof window === "undefined" ? null : window.localStorage;
  } catch {
    return null;
  }
}

/**
 * Lit la mémoire, la met à jour, rend le verdict du jour. Ne lève jamais.
 *
 * ⚠️ Le verdict n'est rendu QUE si l'écriture a tenu : un stockage qui refuse d'écrire (quota,
 * navigation privée) relirait « absente » à chaque page et produirait un `visit_first` par
 * chargement. Une mémoire ILLISIBLE est réécrite à aujourd'hui sans verdict — on ne sait pas si
 * l'appareil est neuf, donc on ne le dit pas.
 */
export function recordVisit(options: {
  /** Le jour civil de Tunis, `AAAA-MM-JJ` (`appLocalDate`). */
  today: string;
  storage?: VisitStorage | null;
}): VisitVerdict {
  try {
    const storage = options.storage === undefined ? browserStorage() : options.storage;
    if (!storage) return NONE;
    const { today } = options;
    // Un « jour » qui n'en est pas un n'entre jamais dans la mémoire.
    if (dayIndex(today) === null) return NONE;
    const raw = storage.getItem(VISIT_KEY);
    const memory = parseVisitMemory(raw);
    if (raw !== null && memory === null) {
      storage.setItem(VISIT_KEY, JSON.stringify({ first: today, last: today }));
      return NONE;
    }
    const { verdict, next } = classifyVisit(memory, today);
    if (next === null) return NONE;
    storage.setItem(VISIT_KEY, JSON.stringify(next));
    return verdict;
  } catch {
    return NONE;
  }
}

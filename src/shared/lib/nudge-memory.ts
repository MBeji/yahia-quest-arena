// LA MÉMOIRE COMMUNE DES INVITATIONS — étude 40, R-12.
//
// CE QU'ELLE EMPÊCHE. Trois invitations vont se partager les mêmes écrans : le rappel (`push`,
// lot 2), l'installation (`install`, lot 3), inviter son parent (`parent`, lot 5). Chacune avec sa
// propre mémoire, un élève en verrait trois sur un écran de résultat, puis les mêmes le lendemain.
// Une seule mémoire, une seule règle :
//
//   `na9ra.nudge` = { [kind]: { shown: "AAAA-MM-JJ", dismissed: n } }
//
//   - pas deux fois la même invitation en 14 jours (7 pour `push`) ;
//   - deux refus ⇒ plus jamais ;
//   - UNE SEULE invitation par écran, dans l'ordre rappel → installation → parent (`chooseNudge`) ;
//   - stockage indisponible ⇒ AUCUNE invitation.
//
// CE QUI EST RETENU, ET RIEN D'AUTRE. Un jour civil de Tunis et un compteur de refus par genre
// d'invitation. Ni heure, ni page, ni identifiant. Jamais envoyé : ce module n'importe RIEN — son
// test vérifie cette absence d'import.
//
// LE SENS SÛR. Une invitation de trop coûte plus qu'une invitation manquée : dans le doute
// (stockage refusé, jour illisible, horloge reculée, écriture qui échoue) on ne montre rien.
// Une mémoire ABÎMÉE, elle, est lue comme vide et réécrite au premier affichage : elle ne doit
// pas faire taire l'invitation pour toujours.
//
// Même discipline que `visit-memory.ts` : pur, le jour et le stockage sont injectés.

/** La clé. Sans limite de durée ; effacée avec les données du site. */
export const NUDGE_KEY = "na9ra.nudge";

/** R-12 — la liste fermée des invitations. */
export type NudgeKind = "push" | "install" | "parent";

/** R-12 — l'ordre dans lequel un écran les considère : la première proposable gagne. */
export const NUDGE_ORDER: readonly NudgeKind[] = ["push", "install", "parent"];

/** R-12 — le délai avant de reproposer, en jours civils. */
export const NUDGE_QUIET_DAYS: Readonly<Record<NudgeKind, number>> = {
  push: 7,
  install: 14,
  parent: 14,
};

/** R-12 — à ce nombre de refus, l'invitation ne revient plus. */
export const NUDGE_MAX_DISMISSALS = 2;

/** Ce que l'appareil retient d'une invitation. */
export type NudgeEntry = { readonly shown: string; readonly dismissed: number };
export type NudgeMemory = Partial<Record<NudgeKind, NudgeEntry>>;

/** Le strict nécessaire d'un `Storage` — ce qui permet de l'injecter dans les tests. */
export type NudgeStorage = Pick<Storage, "getItem" | "setItem">;

const DAY_MS = 24 * 60 * 60 * 1000;
const CIVIL_DAY = /^(\d{4})-(\d{2})-(\d{2})$/;

/** Le rang d'un jour civil (jours depuis l'époque), ou `null` si ce n'en est pas un. */
function dayIndex(value: unknown): number | null {
  if (typeof value !== "string") return null;
  const match = CIVIL_DAY.exec(value);
  if (!match) return null;
  const [, y, m, d] = match;
  const ms = Date.UTC(Number(y), Number(m) - 1, Number(d));
  return new Date(ms).toISOString().slice(0, 10) === value ? ms / DAY_MS : null;
}

function parseEntry(value: unknown): NudgeEntry | null {
  if (typeof value !== "object" || value === null) return null;
  const { shown, dismissed } = value as { shown?: unknown; dismissed?: unknown };
  if (dayIndex(shown) === null) return null;
  if (typeof dismissed !== "number" || !Number.isInteger(dismissed) || dismissed < 0) return null;
  return { shown: shown as string, dismissed };
}

/** La mémoire relue. Tout ce qui n'a pas la forme que ce module écrit est ignoré, genre par genre. */
export function parseNudgeMemory(raw: string | null): NudgeMemory {
  if (!raw) return {};
  let value: unknown;
  try {
    value = JSON.parse(raw);
  } catch {
    return {};
  }
  if (typeof value !== "object" || value === null) return {};
  const memory: NudgeMemory = {};
  for (const kind of NUDGE_ORDER) {
    const entry = parseEntry((value as Record<string, unknown>)[kind]);
    if (entry) memory[kind] = entry;
  }
  return memory;
}

/** R-12, en PUR : cette invitation est-elle proposable aujourd'hui, au vu de la mémoire ? */
export function isNudgeDue(memory: NudgeMemory, kind: NudgeKind, today: string): boolean {
  const todayIndex = dayIndex(today);
  if (todayIndex === null) return false;
  const entry = memory[kind];
  if (!entry) return true;
  if (entry.dismissed >= NUDGE_MAX_DISMISSALS) return false;
  const shownIndex = dayIndex(entry.shown);
  // `shown` dans le FUTUR (horloge reculée) ⇒ écart négatif ⇒ rien : l'horloge se corrigera.
  return shownIndex !== null && todayIndex - shownIndex >= NUDGE_QUIET_DAYS[kind];
}

/** Le `localStorage` du navigateur, ou `null` : rendu serveur, accès refusé (navigation privée). */
function browserStorage(): NudgeStorage | null {
  try {
    return typeof window === "undefined" ? null : window.localStorage;
  } catch {
    return null;
  }
}

function resolve(storage: NudgeStorage | null | undefined): NudgeStorage | null {
  return storage === undefined ? browserStorage() : storage;
}

/** Réécrit l'entrée d'un genre. `true` seulement si l'écriture a tenu. */
function update(
  kind: NudgeKind,
  today: string,
  storage: NudgeStorage | null | undefined,
  next: (entry: NudgeEntry | undefined) => NudgeEntry,
): boolean {
  try {
    const store = resolve(storage);
    if (!store || dayIndex(today) === null) return false;
    const memory = parseNudgeMemory(store.getItem(NUDGE_KEY));
    store.setItem(NUDGE_KEY, JSON.stringify({ ...memory, [kind]: next(memory[kind]) }));
    return true;
  } catch {
    return false;
  }
}

/**
 * R-12 — cette invitation peut-elle être montrée aujourd'hui ? Ne lève jamais ; stockage
 * indisponible ⇒ `false`.
 *
 * @param today le jour civil de TUNIS (`appLocalDate(new Date())`), `AAAA-MM-JJ`.
 */
export function canShow(kind: NudgeKind, today: string, storage?: NudgeStorage | null): boolean {
  try {
    const store = resolve(storage);
    if (!store) return false;
    return isNudgeDue(parseNudgeMemory(store.getItem(NUDGE_KEY)), kind, today);
  } catch {
    return false;
  }
}

/**
 * Retient que l'invitation a été montrée aujourd'hui (le compteur de refus est conservé).
 *
 * ⚠️ Rend `false` si l'écriture n'a pas tenu, et l'appelant ne montre alors RIEN : un stockage qui
 * refuse d'écrire (quota, navigation privée) relirait « jamais montrée » à chaque écran.
 */
export function markShown(kind: NudgeKind, today: string, storage?: NudgeStorage | null): boolean {
  return update(kind, today, storage, (entry) => ({
    shown: today,
    dismissed: entry?.dismissed ?? 0,
  }));
}

/** Retient un refus de plus (« Plus tard », ou la fenêtre du navigateur refermée). */
export function markDismissed(
  kind: NudgeKind,
  today: string,
  storage?: NudgeStorage | null,
): boolean {
  return update(kind, today, storage, (entry) => ({
    shown: today,
    dismissed: (entry?.dismissed ?? 0) + 1,
  }));
}

/**
 * L'invitation a ABOUTI (application installée, rappel activé…) : elle ne revient plus jamais.
 * La forme de la mémoire ne change pas — le compteur est porté à son plafond, qui dit déjà
 * « plus jamais ».
 */
export function markSettled(
  kind: NudgeKind,
  today: string,
  storage?: NudgeStorage | null,
): boolean {
  return update(kind, today, storage, () => ({ shown: today, dismissed: NUDGE_MAX_DISMISSALS }));
}

/**
 * R-12 — UNE SEULE invitation par écran : parmi celles que l'écran sait proposer, la première
 * dans l'ordre rappel → installation → parent que la mémoire autorise aujourd'hui, ou `null`.
 */
export function chooseNudge(
  candidates: readonly NudgeKind[],
  today: string,
  storage?: NudgeStorage | null,
): NudgeKind | null {
  return (
    NUDGE_ORDER.find((kind) => candidates.includes(kind) && canShow(kind, today, storage)) ?? null
  );
}

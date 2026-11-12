// LA CONTINUITÉ DU VISITEUR — ce que SON appareil retient de lui, trente jours (étude 38, lot 5).
//
// LA RUPTURE QU'IL FERME. Le visiteur sans compte est l'audience principale, et rien ne peut le
// relancer : pas de compte, donc pas de notification. S'il revenait le lendemain sur le même
// téléphone, le site ne savait plus rien — ni le cours qu'il lisait, ni les quiz de compréhension
// qu'il avait réussis (leurs portes se refermaient avec l'onglet, la réussite vivant en
// `sessionStorage`).
//
// CE QUI EST RETENU, ET RIEN D'AUTRE (Q-1, arbitrée le 2026-10-30). Deux faits, chacun sous sa clé
// versionnée de `localStorage` :
//   - le DERNIER CHAPITRE lu : identifiant, titre tel qu'il a été lu, langue du contenu, date ;
//   - les QUIZ DE COMPRÉHENSION RÉUSSIS : identifiant de chapitre → date de la réussite.
// Jamais un score, jamais une réponse, jamais un identifiant de personne. Trente jours, puis plus
// rien ; « oublier » efface les deux à la demande.
//
// LE STOP-POINT, RENDU MÉCANIQUE. Ce module n'importe RIEN — ni client Supabase, ni server fn, ni
// mesure : ce qu'il lit et écrit ne peut pas atteindre le serveur. `localStorage` n'est pas un
// cookie, le navigateur ne le joint à aucune requête. Le test du module vérifie cette absence
// d'import.
//
// LA CONFIANCE. La porte du quiz d'un visiteur est une confiance CLIENT, comme avant : il ne gagne
// aucun XP et rien n'est enregistré. La porte d'un élève connecté reste décidée par le serveur
// (`start_exercise_session`), que cette mémoire n'influence pas.

/** Trente jours — la durée arbitrée (Q-1). Au-delà, l'appareil a oublié. */
export const ANON_CONTINUITY_TTL_MS = 30 * 24 * 60 * 60 * 1000;

/** Les deux clés. Le suffixe de version permet de changer la forme sans lire l'ancienne de travers. */
export const LAST_CHAPTER_KEY = "na9ra.anon.lastChapter.v1";
export const QUIZ_PASSED_KEY = "na9ra.anon.quizPassed.v1";

/** Au-delà, on garde les réussites les plus récentes : une mémoire de confort n'a pas à grossir sans fin. */
const MAX_QUIZ_ENTRIES = 200;
const MAX_TITLE_LENGTH = 200;

/**
 * Un identifiant de catalogue : lettres, chiffres, tiret, souligné (UUID et slugs). Tout le reste
 * est refusé — cet identifiant finit dans un lien, et il vient d'un stockage qu'une autre page de
 * la même origine a pu écrire.
 */
const CATALOGUE_ID = /^[A-Za-z0-9_-]{1,64}$/;
/** Une étiquette de langue courte (`fr`, `ar`, `en`, `fr-TN`) — elle finit dans un attribut `lang`. */
const LANG_TAG = /^[A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})?$/;

/** Le chapitre à reprendre, tel que la carte le montre. */
export type ResumeChapter = {
  readonly id: string;
  /** Le titre TEL QU'IL A ÉTÉ LU — dans la langue du contenu, pas dans celle de l'interface. */
  readonly title: string;
  /** Langue du contenu (`fr`, `ar`, `en`), ou `null` si elle n'était pas connue. */
  readonly lang: string | null;
  /** Date de la dernière lecture (ms). */
  readonly at: number;
};

// Toutes les lectures et écritures sont défensives : `localStorage` n'existe pas au rendu serveur,
// lève en navigation privée sur certains navigateurs, peut être plein, et peut contenir n'importe
// quoi. Une mémoire qui casse la page qu'elle sert n'aurait aucun sens — sans elle, le site se
// comporte comme avant ce lot : pas de carte, et une porte de quiz qui se referme.

function storage(): Storage | null {
  try {
    return typeof window === "undefined" ? null : window.localStorage;
  } catch {
    return null;
  }
}

function readRaw(key: string): string | null {
  try {
    return storage()?.getItem(key) ?? null;
  } catch {
    return null;
  }
}

function writeRaw(key: string, value: string): boolean {
  try {
    const store = storage();
    if (!store) return false;
    store.setItem(key, value);
    return true;
  } catch {
    // Quota plein ou stockage refusé : rien n'est retenu, et c'est tout.
    return false;
  }
}

function removeRaw(key: string): void {
  try {
    storage()?.removeItem(key);
  } catch {
    // Un stockage qu'on ne peut pas vider ne peut pas non plus être relu.
  }
}

/** Une date écrite par nous : un nombre fini, pas dans le futur, vieux de trente jours au plus. */
function isFresh(at: unknown, now: number): at is number {
  return (
    typeof at === "number" && Number.isFinite(at) && at <= now && now - at <= ANON_CONTINUITY_TTL_MS
  );
}

function parse(raw: string | null): unknown {
  if (!raw) return null;
  try {
    return JSON.parse(raw) as unknown;
  } catch {
    return null;
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

// ---------------------------------------------------------------------------------------------
// Les abonnés. La carte lit la mémoire par `useSyncExternalStore` : elle doit apprendre un
// « oublier » fait ici, et une écriture faite dans un autre onglet (événement `storage`).
// ---------------------------------------------------------------------------------------------

const listeners = new Set<() => void>();

function emit(): void {
  for (const listener of listeners) listener();
}

function onStorageEvent(event: StorageEvent): void {
  // `key === null` : le stockage entier a été vidé.
  if (event.key === null || event.key === LAST_CHAPTER_KEY || event.key === QUIZ_PASSED_KEY) emit();
}

/** S'abonne aux changements de la mémoire ; rend la fonction de désabonnement. */
export function subscribeAnonContinuity(listener: () => void): () => void {
  listeners.add(listener);
  if (listeners.size === 1 && typeof window !== "undefined") {
    window.addEventListener("storage", onStorageEvent);
  }
  return () => {
    listeners.delete(listener);
    if (listeners.size === 0 && typeof window !== "undefined") {
      window.removeEventListener("storage", onStorageEvent);
    }
  };
}

// ---------------------------------------------------------------------------------------------
// Le dernier chapitre lu
// ---------------------------------------------------------------------------------------------

function toResumeChapter(value: unknown, now: number): ResumeChapter | null {
  if (!isRecord(value)) return null;
  const { id, title, lang, at } = value;
  if (typeof id !== "string" || !CATALOGUE_ID.test(id)) return null;
  if (typeof title !== "string") return null;
  const cleanTitle = title.trim();
  if (cleanTitle.length === 0 || cleanTitle.length > MAX_TITLE_LENGTH) return null;
  if (!isFresh(at, now)) return null;
  return {
    id,
    title: cleanTitle,
    lang: typeof lang === "string" && LANG_TAG.test(lang) ? lang : null,
    at,
  };
}

/** Le dernier instantané rendu, pour que deux lectures de la même mémoire rendent le MÊME objet. */
let cached: { raw: string; chapter: ResumeChapter } | null = null;

/**
 * Le chapitre à reprendre, ou `null` : jamais lu, périmé, illisible, stockage indisponible.
 *
 * Rend le même objet tant que la mémoire n'a pas changé — c'est ce qu'exige
 * `useSyncExternalStore` d'un instantané.
 */
export function readLastChapter(now: number = Date.now()): ResumeChapter | null {
  const raw = readRaw(LAST_CHAPTER_KEY);
  if (raw === null) {
    cached = null;
    return null;
  }
  if (cached?.raw === raw) return isFresh(cached.chapter.at, now) ? cached.chapter : null;
  const chapter = toResumeChapter(parse(raw), now);
  cached = chapter ? { raw, chapter } : null;
  return chapter;
}

/** Retient le chapitre qu'un visiteur vient d'ouvrir. Rend `true` s'il a été gardé. */
export function rememberLastChapter(
  chapter: { id: string; title: string; lang?: string | null },
  now: number = Date.now(),
): boolean {
  const entry = toResumeChapter({ ...chapter, at: now }, now);
  if (!entry) return false;
  const kept = writeRaw(LAST_CHAPTER_KEY, JSON.stringify(entry));
  if (kept) emit();
  return kept;
}

/**
 * Oublie le chapitre retenu SI c'est celui-ci — il a disparu du catalogue, et une carte qui
 * ramène à une page introuvable serait pire que pas de carte. Les quiz réussis ne bougent pas.
 */
export function dropLastChapter(chapterId: string): void {
  if (readLastChapter()?.id !== chapterId) return;
  removeRaw(LAST_CHAPTER_KEY);
  cached = null;
  emit();
}

// ---------------------------------------------------------------------------------------------
// Les quiz de compréhension réussis
// ---------------------------------------------------------------------------------------------

/** Les réussites encore valables : chapitre → date. Ce qui est périmé ou illisible n'y est pas. */
function readQuizPasses(now: number): Map<string, number> {
  const parsed = parse(readRaw(QUIZ_PASSED_KEY));
  const passes = new Map<string, number>();
  if (!isRecord(parsed)) return passes;
  for (const [chapterId, at] of Object.entries(parsed)) {
    if (CATALOGUE_ID.test(chapterId) && isFresh(at, now)) passes.set(chapterId, at);
  }
  return passes;
}

/** Le visiteur a-t-il réussi le quiz de ce chapitre, sur cet appareil, dans les trente jours ? */
export function hasPassedQuizOnDevice(
  chapterId: string | null | undefined,
  now: number = Date.now(),
): boolean {
  if (!chapterId) return false;
  return readQuizPasses(now).has(chapterId);
}

/**
 * Retient qu'un quiz de compréhension est réussi — la RÉUSSITE et sa date, jamais le score.
 * Réussir à nouveau repousse l'échéance de trente jours.
 */
export function rememberQuizPassed(
  chapterId: string | null | undefined,
  now: number = Date.now(),
): boolean {
  if (!chapterId || !CATALOGUE_ID.test(chapterId)) return false;
  const passes = readQuizPasses(now);
  passes.set(chapterId, now);
  const kept = [...passes.entries()].sort((a, b) => b[1] - a[1]).slice(0, MAX_QUIZ_ENTRIES);
  return writeRaw(QUIZ_PASSED_KEY, JSON.stringify(Object.fromEntries(kept)));
}

// ---------------------------------------------------------------------------------------------
// Oublier
// ---------------------------------------------------------------------------------------------

/**
 * « Oublier » : efface TOUT ce que ce module retient — le chapitre et les quiz réussis. Un bouton
 * qui n'effacerait que la moitié visible de la mémoire mentirait à celui qui rend un téléphone
 * emprunté.
 */
export function forgetAnonContinuity(): void {
  removeRaw(LAST_CHAPTER_KEY);
  removeRaw(QUIZ_PASSED_KEY);
  cached = null;
  emit();
}

/** Le nombre de jours pleins depuis `at` — la seule chose que la mesure dit de cette mémoire. */
export function daysSince(at: number, now: number = Date.now()): number {
  return Math.max(0, Math.floor((now - at) / (24 * 60 * 60 * 1000)));
}

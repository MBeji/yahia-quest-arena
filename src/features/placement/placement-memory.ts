// LA MÉMOIRE DE L'APPAREIL (étude 39 R-15) — les tests que CET appareil a passés, et le brouillon
// du test en cours.
//
// POURQUOI UNE MÉMOIRE. Un test anonyme n'a qu'un jeton (R-14) : s'il n'est retenu nulle part,
// fermer l'onglet perd le bilan, et créer un compte ensuite n'a rien à rattacher (R-16). On le
// retient donc ici — dans `localStorage`, trente jours, cinq tests au plus — comme `/suivi`
// retient le code d'alliance : sur un choix implicite cette fois, parce qu'un bilan sans nom ne
// dit rien sur personne.
//
// Module pur et défensif : `localStorage` n'existe pas au SSR et peut lever (navigation privée,
// quota, politique). Toute erreur dégrade en « rien de mémorisé » — le test marche, seule la
// commodité saute.

import {
  PLACEMENT_MEMORY_MAX,
  PLACEMENT_MEMORY_TTL_MS,
  type PlacementBand,
} from "@/shared/constants/placement";

export const PLACEMENT_MEMORY_KEY = "na9ra.placement.v1";
const DRAFT_KEY_PREFIX = "na9ra.placement.draft.";

/** Un test retenu : de quoi le rouvrir, le rattacher, et dire « ton dernier résultat ». */
export type RememberedPlacement = {
  id: string;
  token: string;
  subjectId: string;
  subjectName: string;
  /** Quand il a été ouvert (ms) — c'est l'horloge de la durée de vie. */
  at: number;
  /** Le résultat, une fois le test fini ; absent pour un test en cours. */
  scoreOn20?: number;
  band?: PlacementBand;
  finished?: boolean;
};

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function isRemembered(value: unknown): value is RememberedPlacement {
  if (!value || typeof value !== "object") return false;
  const v = value as Record<string, unknown>;
  return (
    typeof v.id === "string" &&
    UUID.test(v.id) &&
    typeof v.token === "string" &&
    UUID.test(v.token) &&
    typeof v.subjectId === "string" &&
    v.subjectId.length > 0 &&
    typeof v.at === "number" &&
    Number.isFinite(v.at)
  );
}

function readAll(now: number): RememberedPlacement[] {
  if (typeof window === "undefined") return [];
  try {
    const raw = window.localStorage.getItem(PLACEMENT_MEMORY_KEY);
    if (!raw) return [];
    const parsed: unknown = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed
      .filter(isRemembered)
      .filter((p) => now - p.at <= PLACEMENT_MEMORY_TTL_MS && p.at <= now)
      .map((p) => ({
        id: p.id,
        token: p.token,
        subjectId: p.subjectId,
        subjectName: typeof p.subjectName === "string" ? p.subjectName : "",
        at: p.at,
        ...(typeof p.scoreOn20 === "number" ? { scoreOn20: p.scoreOn20 } : {}),
        ...(typeof p.band === "string" ? { band: p.band } : {}),
        ...(p.finished === true ? { finished: true } : {}),
      }));
  } catch {
    return [];
  }
}

function writeAll(list: RememberedPlacement[]): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.setItem(PLACEMENT_MEMORY_KEY, JSON.stringify(list));
  } catch {
    // Quota plein ou écriture refusée : le test marche, sans la mémoire.
  }
}

/** Les tests retenus, du plus récent au plus ancien, périmés exclus. */
export function readRememberedPlacements(now: number = Date.now()): RememberedPlacement[] {
  return readAll(now).sort((a, b) => b.at - a.at);
}

/** Retient (ou met à jour) un test ; garde les `PLACEMENT_MEMORY_MAX` plus récents. */
export function rememberPlacement(entry: RememberedPlacement, now: number = Date.now()): void {
  if (!isRemembered(entry)) return;
  const others = readAll(now).filter((p) => p.id !== entry.id);
  writeAll([entry, ...others].sort((a, b) => b.at - a.at).slice(0, PLACEMENT_MEMORY_MAX));
}

/** Le jeton d'un test retenu, ou `null` — la seule façon de rouvrir un test anonyme. */
export function rememberedToken(id: string, now: number = Date.now()): string | null {
  return readAll(now).find((p) => p.id === id)?.token ?? null;
}

/** Le dernier test FINI de l'appareil (l'écran d'entrée : « ton dernier résultat »). */
export function lastFinishedPlacement(now: number = Date.now()): RememberedPlacement | null {
  return readRememberedPlacements(now).find((p) => p.finished === true) ?? null;
}

/** Oublie des tests — après leur rattachement à un compte (R-16), ils ne sont plus à l'appareil. */
export function forgetPlacements(ids: readonly string[], now: number = Date.now()): void {
  const keep = new Set(ids);
  writeAll(readAll(now).filter((p) => !keep.has(p.id)));
}

/** Les jetons encore à l'appareil — ce que le rattachement envoie. */
export function rememberedTokens(now: number = Date.now()): string[] {
  return readAll(now).map((p) => p.token);
}

// ---------------------------------------------------------------------------
// Le brouillon du test en cours (US-8) : réponses et position, en `sessionStorage` — recharger
// l'onglet les garde, fermer le navigateur les perd, ce qui est le contrat annoncé (R-15).
// ---------------------------------------------------------------------------

export type PlacementDraft = { answers: Record<string, string>; index: number };

export function readPlacementDraft(id: string): PlacementDraft | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = window.sessionStorage.getItem(DRAFT_KEY_PREFIX + id);
    if (!raw) return null;
    const parsed: unknown = JSON.parse(raw);
    const d = parsed as Partial<PlacementDraft> | null;
    if (!d || typeof d !== "object" || !d.answers || typeof d.answers !== "object") return null;
    const answers: Record<string, string> = {};
    for (const [k, v] of Object.entries(d.answers)) {
      if (typeof v === "string" && v.length > 0 && v.length <= 512) answers[k] = v;
    }
    const index = typeof d.index === "number" && d.index >= 0 ? Math.floor(d.index) : 0;
    return { answers, index };
  } catch {
    return null;
  }
}

export function writePlacementDraft(id: string, draft: PlacementDraft): void {
  if (typeof window === "undefined") return;
  try {
    window.sessionStorage.setItem(DRAFT_KEY_PREFIX + id, JSON.stringify(draft));
  } catch {
    // Idem : la reprise saute, pas le test.
  }
}

export function clearPlacementDraft(id: string): void {
  if (typeof window === "undefined") return;
  try {
    window.sessionStorage.removeItem(DRAFT_KEY_PREFIX + id);
  } catch {
    // Rien à faire.
  }
}

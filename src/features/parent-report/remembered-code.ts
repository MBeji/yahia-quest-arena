/**
 * « Se souvenir de ce code sur cet appareil » — mémoire locale du suivi public.
 *
 * `/suivi` s'ouvre sans compte : le code d'alliance est une clé AU PORTEUR, donc
 * rien n'était persisté et le parent le ressaisissait à chaque visite. On le
 * retient ici, mais sur un choix visible (case à cocher) et réversible en un
 * clic (« oublier ce code ») : sur un appareil partagé, garder le code revient
 * à laisser le bilan de l'enfant ouvert.
 *
 * Module pur et défensif : `localStorage` n'existe pas au SSR et peut lever
 * (navigation privée, stockage bloqué, quota). Toute erreur dégrade en « rien
 * de mémorisé » — la page marche, seule la commodité saute.
 */

export const SUIVI_CODE_STORAGE_KEY = "xp-scholars-suivi-code";

/** Bornes du code, alignées sur l'`inputValidator` de `getStudentReportByCode`. */
const MIN_CODE_LENGTH = 8;
const MAX_CODE_LENGTH = 64;

/**
 * Garde-fou de longueur, pas de validité : seul un code ayant RÉELLEMENT ouvert
 * un bilan est mémorisé, donc un stockage hors bornes ne peut venir que d'une
 * altération manuelle — on l'ignore au lieu de le renvoyer au serveur.
 */
function isStorableCode(value: string): boolean {
  return value.length >= MIN_CODE_LENGTH && value.length <= MAX_CODE_LENGTH;
}

/** Le code mémorisé sur cet appareil — `null` au SSR, si absent ou illisible. */
export function readRememberedCode(): string | null {
  if (typeof window === "undefined") return null;
  try {
    const stored = window.localStorage.getItem(SUIVI_CODE_STORAGE_KEY)?.trim() ?? "";
    return isStorableCode(stored) ? stored : null;
  } catch {
    // Stockage bloqué par la politique du navigateur : rien de mémorisé.
    return null;
  }
}

/** Retient le code sur cet appareil (no-op si hors bornes ou stockage indisponible). */
export function rememberCode(code: string): void {
  if (typeof window === "undefined") return;
  const trimmed = code.trim();
  if (!isStorableCode(trimmed)) return;
  try {
    window.localStorage.setItem(SUIVI_CODE_STORAGE_KEY, trimmed);
  } catch {
    // Quota plein ou écriture refusée : le suivi marche, sans la mémoire.
  }
}

/** Efface le code mémorisé — l'appareil redevient anonyme. */
export function forgetRememberedCode(): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.removeItem(SUIVI_CODE_STORAGE_KEY);
  } catch {
    // Idem : rien à faire de plus, l'oubli est déjà effectif côté écran.
  }
}

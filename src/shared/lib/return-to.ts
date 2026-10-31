// LE RETOUR AU POINT DE DÉPART — où ramener quelqu'un qui vient de se connecter.
//
// LA RUPTURE QU'IL FERME (étude 38, lot 1). Un visiteur lit un chapitre, décide de créer un compte,
// et se retrouve au Hall des Héros — puis dans un assistant de trois écrans. Il a perdu son
// chapitre au pic de son envie, et l'écran de connexion lui promet pourtant « Reprends là où tu
// t'étais arrêté ». La page de départ n'était retenue nulle part : l'inscription, la connexion et
// le lien de confirmation d'e-mail naviguaient tous EN DUR vers /dashboard.
//
// POURQUOI UNE MÉMOIRE ET PAS SEULEMENT L'URL. Un `?returnTo=` dans l'adresse meurt dès que la page
// est rechargée : la confirmation d'e-mail ouvre /auth sans paramètre, l'aller-retour chez Google
// aussi. La décision se prend donc sur une mémoire de l'appareil (`localStorage`, vingt-quatre
// heures) ; l'URL n'y fait qu'ÉCRIRE, ce qui garde un lien d'invitation partageable.
//
// CE QUI EN FAIT UN MODULE DE SÉCURITÉ. Ce chemin finit dans `router.history.push(...)`, donc il
// vient d'une source qu'on ne contrôle pas (une URL, un stockage qu'une autre page a pu écrire).
// `isSafeReturnPath` est la seule porte : tout ce qui n'est pas un chemin INTERNE est ignoré en
// silence, jamais corrigé, jamais renvoyé tel quel.

const STORAGE_KEY = "na9ra.returnTo.v1";

/** Au-delà, l'envie de revenir là est périmée — et une confirmation d'e-mail se fait en quelques heures. */
export const RETURN_TO_TTL_MS = 24 * 60 * 60 * 1000;

const MAX_LENGTH = 512;

/** La page publique du suivi parental : sa requête peut porter un code d'alliance (voir `rememberCurrentPage`). */
const SUIVI_PATH = /^\/suivi\/?$/i;

/**
 * Le tunnel lui-même : y « revenir » boucle. Insensible à la casse : le routeur apparie `/AUTH` et
 * `/Auth` au même écran que `/auth`, donc les laisser passer ferait un saut de plus par le tunnel.
 */
const FUNNEL_PATH = /^\/(?:auth|login|signup)(?:[/?]|$)/i;

/**
 * Y a-t-il un caractère de contrôle ? Tabulation et saut de ligne compris : un navigateur les ôte d'une
 * URL, donc « /<tab>/evil.tn » s'y lit « //evil.tn ». Une boucle sur les codes plutôt qu'une expression
 * régulière : celle-ci obligerait à désactiver `no-control-regex`, et un contrôle de sécurité qui
 * s'écrit en éteignant le linter n'inspire pas confiance.
 */
function hasControlChar(text: string): boolean {
  for (let i = 0; i < text.length; i += 1) {
    const code = text.charCodeAt(i);
    if (code <= 0x1f || code === 0x7f) return true;
  }
  return false;
}

const ORIGIN_PROBE = "https://return-to.invalid";

/**
 * Le chemin INTERNE sûr qu'on peut garder, ou `null`.
 *
 * Refuse : tout ce qui ne commence pas par un seul « / » (donc les adresses absolues, les schémas
 * `javascript:`, les « // » protocole-relatif), tout « \\ » (un navigateur le lit comme « / »), les
 * caractères de contrôle, plus de 512 caractères, et le tunnel (`/auth`, `/login`, `/signup`).
 * Le fragment est retiré : c'est là que Supabase dépose ses jetons au retour d'une connexion.
 */
export function isSafeReturnPath(raw: unknown): string | null {
  if (typeof raw !== "string" || raw.length === 0 || raw.length > MAX_LENGTH) return null;
  if (!raw.startsWith("/") || raw.startsWith("//")) return null;
  if (raw.includes("\\") || hasControlChar(raw)) return null;

  const withoutFragment = raw.split("#", 1)[0];
  let url: URL;
  try {
    url = new URL(withoutFragment, ORIGIN_PROBE);
  } catch {
    return null;
  }
  // Ceinture : quoi que la chaîne ait pu contenir, elle doit rester sur NOTRE origine.
  if (url.origin !== ORIGIN_PROBE) return null;

  const path = url.pathname + url.search;
  // Seconde moitié de la ceinture. Le « // » est refusé plus haut sur la chaîne d'ORIGINE, mais la
  // normalisation de l'URL peut en FAIRE apparaître un : `/.//evil.tn`, `/a/..//evil.tn` et
  // `/%2e//evil.tn` deviennent `//evil.tn`, un chemin protocole-relatif — le contraire de ce que
  // cette fonction promet. Le routeur le ramènerait sur notre origine, mais c'est lui qui nous
  // sauverait, pas le contrôle : on refuse ici, sur le résultat.
  if (path.startsWith("//")) return null;
  return FUNNEL_PATH.test(path) ? null : path;
}

/**
 * POURQUOI on ramène quelqu'un (é38 lot 3, R-7). Absent : l'envie ordinaire de revenir — une invitation,
 * la garde d'un écran de compte. `"expired"` : sa session est morte sous ses doigts ; `/auth` le lui dit
 * et la mesure le sépare d'une connexion ordinaire.
 */
export type ReturnReason = "expired";

type Stored = { path: string; at: number; reason?: ReturnReason };

// Toutes les lectures et écritures sont défensives : `localStorage` n'existe pas au SSR, lève en
// navigation privée sur certains navigateurs, et peut être plein. Une mémoire qui casse la page
// qu'elle sert n'aurait aucun sens — sans elle, on retombe sur le Hall, comme avant.

function read(now: number): Stored | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    const parsed: unknown = JSON.parse(raw);
    const entry = parsed as Partial<Stored> | null;
    const path = isSafeReturnPath(entry?.path);
    const at = entry?.at;
    if (path === null || typeof at !== "number" || !Number.isFinite(at)) return null;
    if (now - at > RETURN_TO_TTL_MS || at > now) return null;
    // Une raison inconnue n'invalide pas le chemin : elle est simplement ignorée, comme tout ce que
    // le stockage contient et que nous n'avons pas écrit.
    return entry?.reason === "expired" ? { path, at, reason: "expired" } : { path, at };
  } catch {
    return null;
  }
}

function clear(): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.removeItem(STORAGE_KEY);
  } catch {
    // Rien à faire : un stockage qu'on ne peut pas vider ne peut pas non plus nous ramener nulle part.
  }
}

/**
 * Retient `path` comme retour. Rend `true` s'il a été gardé, `false` s'il a été refusé ou n'a pas pu l'être.
 * Un retour écrit SANS raison remplace un retour d'expiration : c'est la dernière intention qui compte.
 */
export function rememberReturnTo(
  path: unknown,
  now: number = Date.now(),
  reason?: ReturnReason,
): boolean {
  const safe = isSafeReturnPath(path);
  if (safe === null || typeof window === "undefined") return false;
  try {
    const entry: Stored = reason ? { path: safe, at: now, reason } : { path: safe, at: now };
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(entry));
    return true;
  } catch {
    return false;
  }
}

/**
 * Retient la page où l'on est — sauf l'accueil public : y « revenir » après une inscription
 * ramènerait à la vitrine, alors que le Hall est ce qu'on veut montrer à quelqu'un qui vient d'arriver.
 *
 * `/suivi` est retenu SANS sa requête : `?code=` y porte le code d'alliance d'un enfant, une clé au
 * porteur que la page ne garde sur l'appareil que si le parent a laissé « se souvenir » coché.
 * La mémoire du retour vit vingt-quatre heures et « oublier » ne la vide pas : y glisser le code
 * contournerait le choix du parent. Revenir sur `/suivi` suffit — un parent connecté y est renvoyé
 * sur son espace, un visiteur y retrouve le code qu'il a choisi de garder.
 */
export function rememberCurrentPage(reason?: ReturnReason): boolean {
  if (typeof window === "undefined") return false;
  const { pathname, search } = window.location;
  if (pathname === "/") return false;
  return rememberReturnTo(
    SUIVI_PATH.test(pathname) ? pathname : pathname + search,
    Date.now(),
    reason,
  );
}

/** Le retour gardé, sans le consommer — pour le MESURER avant de s'en servir. */
export function peekReturnTo(now: number = Date.now()): string | null {
  return read(now)?.path ?? null;
}

/** Pourquoi le retour gardé existe, sans le consommer — `null` pour une invitation ordinaire ou sans retour. */
export function peekReturnReason(now: number = Date.now()): ReturnReason | null {
  return read(now)?.reason ?? null;
}

/**
 * Le retour gardé, et on l'oublie : il ne sert QU'UNE FOIS, quoi qu'il arrive ensuite. Un retour
 * périmé ou illisible est effacé au passage plutôt que laissé à traîner.
 */
export function consumeReturnTo(now: number = Date.now()): string | null {
  const path = read(now)?.path ?? null;
  clear();
  return path;
}

/**
 * LE STOCKAGE QUI NE LÈVE JAMAIS (#1307).
 *
 * `localStorage` peut lever à l'ACCÈS — `SecurityError` : cookies et données de site bloqués,
 * certains modes de navigation privée, navigateurs intégrés verrouillés — ou à l'USAGE —
 * `QuotaExceededError` : quota plein. Une exception levée au démarrage d'une page remonte jusqu'à
 * la frontière d'erreur de la racine : le visiteur voyait « Quelque chose s'est mal passé » à la
 * place du site. Une préférence (thème, langue) qui ne se retient pas n'est qu'un confort perdu :
 * on lit `null`, on n'écrit rien, et la page s'affiche.
 *
 * Dans le chunk d'entrée : rien de plus que ces deux fonctions. Les mémoires d'appareil qui ont
 * déjà leur garde (`visit-memory`, `nudge-memory`, `anon-continuity`, `guide-storage`…) la
 * gardent : elles injectent leur stockage dans leurs tests.
 */

/** La valeur retenue, ou `null` — y compris en rendu serveur et quand le navigateur refuse. */
export function readLocal(key: string): string | null {
  try {
    return typeof window === "undefined" ? null : window.localStorage.getItem(key);
  } catch {
    return null;
  }
}

/** Retient la valeur si le navigateur l'accepte ; rend `false` sinon, sans lever. */
export function writeLocal(key: string, value: string): boolean {
  try {
    if (typeof window === "undefined") return false;
    window.localStorage.setItem(key, value);
    return true;
  } catch {
    return false;
  }
}

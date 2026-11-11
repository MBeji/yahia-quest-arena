import type { Query } from "@tanstack/react-query";

/**
 * Seuil de REPRISE d'une query au retour d'onglet ou de réseau (2026-10-31, data-02).
 *
 * Distinct de la `staleTime` de navigation (30 s dans `router.tsx`) : celle-ci dit
 * quand une donnée mérite d'être relue au prochain MONTAGE, celui-ci quand une
 * absence a duré assez pour qu'une page restée ouverte vaille d'être rafraîchie
 * sans que l'élève ait rien touché. Les deux n'ont pas la même échelle : un détour
 * de 40 s par la calculatrice ou WhatsApp est un `visibilitychange` comme un
 * autre, et avec le défaut de query-core (`refetchOnWindowFocus: true`, c'est-à-dire
 * « dès que périmée ») il relançait les 9 server fns du tableau de bord — dont une
 * ÉCRITURE SQL, `ensure_daily_weekly_goals` — ou getExercise + getSubject en pleine
 * mission, sans rien changer à l'écran. Mesuré sur 9 queries montées, retours à
 * +31 s, +62 s et une reconnexion à +93 s : 36 appels de queryFn avant, 9 après.
 *
 * Cinq minutes : au-delà, la PWA rouverte le lendemain retrouve l'anneau, les
 * missions et l'événement du jour comme avant ; en deçà, rien ne bouge que la
 * soumission de l'élève n'ait déjà invalidé explicitement.
 */
export const RESUME_REFETCH_AFTER_MS = 5 * 60_000;

/**
 * Forme fonction de `refetchOnWindowFocus` / `refetchOnReconnect` : ne relance la
 * query que si sa donnée a plus de `ms`. Une query SANS donnée (`dataUpdatedAt`
 * à 0 — jamais résolue, ou en erreur) est relancée comme aujourd'hui, c'est la
 * guérison attendue d'un retour de réseau. `refetchOnMount` n'est pas concerné :
 * une navigation garde sa `staleTime`.
 */
export function refetchOnlyIfOlderThan(ms: number) {
  return (query: Query): boolean => Date.now() - query.state.dataUpdatedAt >= ms;
}

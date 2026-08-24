/**
 * LA JOURNÉE DE L'APPLICATION — un seul fuseau, un seul calcul.
 *
 * Toutes les frontières de « jour » du produit sont celles de Tunis : la série
 * se casse à minuit là-bas, le rappel de série vise « pas venu aujourd'hui », et
 * depuis l'étude 11 le rappel du plan vise la même population. Deux définitions
 * de « aujourd'hui » dans le même cron finiraient par diverger un soir d'été.
 *
 * Ces deux valeurs vivaient dans `features/notifications/push-audience.ts`, où
 * elles étaient nées. Elles remontent ici pour la même raison que le transport
 * push à l'étude 29 lot 3 : une deuxième feature en a besoin, et une feature
 * n'en importe pas une autre (AGENTS.md).
 */

/** Fuseau de l'application. Toute frontière de jour s'y réfère. */
export const APP_TIME_ZONE = "Africa/Tunis";

/**
 * La date civile (YYYY-MM-DD) dans le fuseau de l'application, pour un instant
 * donné. `en-CA` formate en ISO ; `timeZone` décale vers le calendrier tunisien,
 * pour que la comparaison soit juste quel que soit le décalage UTC du serveur.
 */
export function appLocalDate(now: Date): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: APP_TIME_ZONE,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(now);
}

/**
 * Étude 31 lot 1 — LA LISTE FERMÉE des événements produit (§3.6).
 *
 * Avant ce lot, PostHog recevait TROIS événements (`$pageview`, `video_open`,
 * `dungeon_pool_scope`) : de quoi compter des visites, pas de quoi lire un
 * parcours. Le funnel qui compte — s'inscrire, finir l'onboarding, jouer une
 * quête, monter de niveau, gagner un badge, revenir — n'avait aucune trace.
 *
 * **Pourquoi une liste FERMÉE et non un `captureProductEvent` libre.** Un mur
 * d'événements ad hoc devient illisible en trois mois, et surtout chaque nom
 * libre est une occasion d'y glisser une propriété de trop. Ici l'ensemble des
 * noms est un type : envoyer autre chose ne compile pas. C'est le stop-point du
 * lot 1 (« aucun événement au-delà de la liste fermée ») rendu mécanique plutôt
 * que confié à la vigilance.
 *
 * **ZÉRO PII, et ce n'est pas négociable** (D-1) : aucune propriété ne porte
 * d'e-mail, de nom, ni d'identifiant Supabase. Les profils de personne restent
 * désactivés côté PostHog — c'est une décision de protection des mineurs, pas un
 * réglage de confort. Conséquence assumée : **PostHog ne sait pas dire qui est
 * revenu**, et c'est pour ça que la rétention se calcule dans Postgres
 * (`admin_engagement_overview`, é31 §3.8 D-1). PostHog compte des passages ;
 * Postgres compte des personnes.
 *
 * **La méta-mesure** (§3.7) : `PRODUCT_EVENT_CATALOGUE` est lu par
 * `/admin/engagement`, qui affiche l'instrumentation elle-même — quel événement
 * existe, où il part, et lequel n'est pas encore câblé. Une instrumentation
 * qu'on ne voit pas est une instrumentation qu'on croit avoir.
 */

import { captureProductEvent } from "@/shared/lib/product-analytics";

/** Les 12 événements produit de la liste fermée (é31 §3.6). Rien d'autre ne part. */
export type ProductEventName =
  | "signup"
  | "onboarding_completed"
  | "quest_completed"
  | "level_up"
  | "badge_earned"
  | "daily_missions_completed"
  | "duel_finished"
  | "league_awarded"
  | "shop_purchase"
  | "streak_recovered"
  | "push_optin"
  | "push_optout";

export type ProductEventEntry = {
  readonly name: ProductEventName;
  /** Où il part, en clair — la colonne que lit l'admin. */
  readonly fires: string;
  /**
   * `false` = déclaré mais pas encore émis, avec le lot qui le câblera. On
   * préfère l'écrire que le taire : un événement absent qu'on croit présent
   * produit un funnel faux, et personne ne va vérifier le code.
   */
  readonly live: boolean;
  readonly note?: string;
};

export const PRODUCT_EVENT_CATALOGUE: readonly ProductEventEntry[] = [
  { name: "signup", fires: "Création de compte réussie (formulaire d'inscription)", live: true },
  {
    name: "onboarding_completed",
    fires: "Fin du parcours d'accueil (choix de parcours enregistré)",
    live: true,
  },
  { name: "quest_completed", fires: "Écran de résultat d'une quête terminée", live: true },
  { name: "level_up", fires: "Écran de résultat, quand le niveau change", live: true },
  { name: "badge_earned", fires: "Écran de résultat, un par badge débloqué", live: true },
  {
    name: "daily_missions_completed",
    fires: "Tableau de bord, quand toutes les missions du jour sont finies",
    live: true,
  },
  { name: "duel_finished", fires: "Fin d'un duel (écran de résultat)", live: true },
  {
    name: "league_awarded",
    fires: "Découverte du résultat de ligue de la semaine close (podium)",
    live: true,
  },
  { name: "shop_purchase", fires: "Achat d'un objet en boutique", live: true },
  { name: "streak_recovered", fires: "Rachat de série réussi", live: true },
  { name: "push_optin", fires: "Activation des notifications", live: true },
  { name: "push_optout", fires: "Désactivation des notifications", live: true },
] as const;

/**
 * Propriétés autorisées : uniquement des faits techniques déjà publics
 * (identifiants de catalogue, paliers, compteurs). Le type interdit d'y mettre
 * un objet arbitraire par inadvertance.
 */
export type ProductEventProps = Record<string, string | number | boolean | undefined>;

/**
 * Émet un événement de la liste fermée. Sans clé PostHog, sans navigateur ou
 * hors build de production, c'est un no-op complet — comme tout le module
 * `product-analytics`.
 */
export function trackProductEvent(name: ProductEventName, props?: ProductEventProps): void {
  captureProductEvent(name, props);
}

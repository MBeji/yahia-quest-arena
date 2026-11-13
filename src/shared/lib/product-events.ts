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
 * **La méta-mesure** (§3.7) : `PRODUCT_EVENT_CATALOGUE` (`product-events-catalogue.ts`, à part
 * pour ne pas descendre sur les pages publiques) est lu par
 * `/admin/engagement`, qui affiche l'instrumentation elle-même — quel événement
 * existe, où il part, et lequel n'est pas encore câblé. Une instrumentation
 * qu'on ne voit pas est une instrumentation qu'on croit avoir.
 */

import { captureProductEvent } from "@/shared/lib/product-analytics";

/**
 * La liste fermée des événements produit (é31 §3.6), amendée par écrit : deux par é34 (la
 * progression), trois par é38 lot 0 (le tunnel sans compte → compte), quatre par é39 (le test de niveau), un par
 * é38 lot 5 (le retour du visiteur), deux par le relevé « première visite » du 2026-11-12 (la
 * première réponse, la porte du quiz), quatre par é40 lot 0 (la mesure du retour). Rien d'autre ne
 * part.
 */
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
  | "push_optout"
  // Étude 34 — ce que la progression fait tomber. Deux événements, pas un de plus :
  // l'étoile est le geste fréquent, le sceau est le jalon rare, et mesurer les deux
  // dit si la reconnaissance arrive assez tôt pour motiver (KPI-3 de l'étude).
  | "chapter_star_earned"
  | "subject_seal_earned"
  // Étude 38 lot 0 (R-16) — le tunnel « sans compte → compte », aveugle avant `signup` alors que
  // le visiteur sans compte est l'audience principale. Trois événements, pas un de plus :
  // l'entraînement terminé SANS compte, l'invitation cliquée, la connexion. Leurs consommateurs
  // sont datés : KPI-1, KPI-2 et KPI-3 de l'étude 38, lus dans PostHog dès la mise en ligne.
  | "public_practice_completed"
  | "account_invite_clicked"
  | "login"
  // Étude 39 (R-21) — le test de niveau, premier canal d'acquisition mesurable. Quatre événements,
  // pas un de plus, chacun avec son consommateur daté : commencé (KPI-1), fini (KPI-2, avec la bande
  // et le bâclage), partagé (KPI-1, la part partagée), rattaché à un compte (KPI-3 — la conversion
  // test → compte, que le tunnel de l'étude 38 ne savait pas nommer).
  | "placement_started"
  | "placement_completed"
  | "placement_shared"
  | "placement_claimed"
  // Étude 38 lot 5 — la continuité du visiteur. UN événement, pas un de plus : le clic sur la carte
  // « Reprendre ». Il dit d'où (accueil ou programme) et depuis combien de jours l'appareil n'avait
  // pas lu — `days_since >= 1` est un RETOUR, la chose que ce lot existe pour produire. Ni le
  // chapitre ni rien de la personne : la mémoire reste sur l'appareil, seul le clic se compte.
  | "resume_card_clicked"
  // Relevé « première visite » du 2026-11-12 (docs/audit-premiere-visite-2026-11-12.md, §7) —
  // l'entonnoir sans compte était aveugle entre la page vue et la FIN d'un entraînement : un
  // visiteur qui répondait à deux questions puis partait n'avait jamais existé, et rien ne disait
  // combien butaient sur la porte du quiz (85 % des pages d'exercice publiées). Deux événements,
  // pas un de plus. Consommateur daté : la fiche D-1 du relevé (« essai d'une mission scolaire
  // avant le quiz »), que `public_gate_shown` rapproché de `public_practice_started` tranche.
  | "public_practice_started"
  | "public_gate_shown"
  // Étude 40 lot 0 — la mesure du retour. Quatre événements, pas un de plus, chacun avec son
  // consommateur daté. `visit_first` est le dénominateur de KPI-1 (un navigateur neuf),
  // `visit_returned` son numérateur (le même appareil, un AUTRE jour) — lu par `entry` pour juger
  // les lots 3, 4 et 5. Les deux autres sont DÉCLARÉS ici et câblés par leur lot : `install_invite`
  // (KPI-5, lot 3) et `content_shared` (lots 4 et 5, rapproché de `visit_returned{entry}`).
  // Aucune propriété ne porte d'identifiant de compte, de chapitre, de score ou de texte saisi :
  // des étiquettes fermées, des tranches de jours, des booléens (é40 R-3, R-4).
  | "visit_first"
  | "visit_returned"
  | "install_invite"
  | "content_shared"
  // Étude 40 lot 5 — décision du propriétaire du 2026-11-13 : compter aussi l'AFFICHAGE de la carte
  // « Inviter mon parent » de l'écran de résultat. `content_shared{intent:"parent"}` ne compte que
  // l'envoi ; sans dénominateur, on ne sait pas si l'invitation convainc ou si elle n'est pas vue.
  // Une étiquette fermée (`action` : montrée, écartée), rien sur l'élève — c'est un mineur.
  | "parent_invite";

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

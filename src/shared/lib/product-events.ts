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
  | "content_shared";

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
  {
    name: "chapter_star_earned",
    fires: "à la fin d'une mission qui fait monter l'étoile d'un chapitre (étude 34)",
    live: true,
  },
  {
    name: "subject_seal_earned",
    fires: "quand tous les chapitres d'une matière atteignent la même étoile (étude 34)",
    live: true,
  },
  {
    name: "public_practice_completed",
    fires:
      "Entraînement terminé SANS compte : correction d'une mission, ou quiz de compréhension (étude 38)",
    live: true,
  },
  {
    name: "account_invite_clicked",
    fires:
      "Clic sur une invitation à créer un compte : lecteur de cours, résultat d'entraînement, accueil, en-tête (étude 38)",
    live: true,
  },
  {
    name: "login",
    fires:
      "Connexion réussie : mot de passe, ou retour de Google — une inscription Google y compte aussi, le client ne la distingue pas (étude 38)",
    live: true,
  },
  {
    name: "placement_started",
    fires:
      "Test de niveau commencé : matière, audience (élève/parent), avec ou sans compte, depuis un lien partagé ou non (étude 39)",
    live: true,
  },
  {
    name: "placement_completed",
    fires:
      "Test de niveau fini : matière, bande de niveau, bâclé ou non, avec ou sans compte (étude 39)",
    live: true,
  },
  {
    name: "placement_shared",
    fires: "Résultat du test de niveau partagé : feuille de partage ou copie (étude 39)",
    live: true,
  },
  {
    name: "placement_claimed",
    fires:
      "Tests de niveau de l'appareil rattachés au compte qui vient de se connecter — la conversion test → compte (étude 39)",
    live: true,
  },
  {
    name: "resume_card_clicked",
    fires:
      "Clic sur la carte « Reprendre » d'un visiteur sans compte : accueil ou programme, et le nombre de jours depuis sa dernière lecture (étude 38 lot 5)",
    live: true,
  },
  {
    name: "public_practice_started",
    fires:
      "Première réponse validée d'un entraînement SANS compte, mission ou quiz (relevé « première visite » du 2026-11-12)",
    live: true,
  },
  {
    name: "public_gate_shown",
    fires:
      "La porte du quiz s'affiche à un visiteur sans compte qui ouvre une mission scolaire (relevé « première visite » du 2026-11-12)",
    live: true,
  },
  {
    name: "visit_first",
    fires:
      "Première ouverture d'un navigateur sans mémoire de visite : le genre de page d'arrivée, installée ou non (étude 40 lot 0)",
    live: true,
  },
  {
    name: "visit_returned",
    fires:
      "Réouverture un AUTRE jour sur le même appareil, au plus une par jour : tranche de jours, session ou non, source d'entrée, installée ou non (étude 40 lot 0)",
    live: true,
  },
  {
    name: "install_invite",
    fires:
      "Invitation à installer l'application : montrée, acceptée ou écartée, par plateforme et par audience (étude 40)",
    live: true,
  },
  {
    name: "content_shared",
    fires:
      "Partage d'un contenu par la personne : intention (reprise, réussite, parent), surface et méthode (étude 40)",
    live: true,
  },
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

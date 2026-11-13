/**
 * Le CATALOGUE de la liste fermée des événements produit — où chacun part, en clair, et s'il est
 * câblé. Lu par l'écran admin « Engagement » et par les tests de la liste ; jamais par une page
 * publique.
 *
 * Pourquoi un fichier à part (2026-11-13, étude 40 lot 5) : rangé avec `trackProductEvent`, ce
 * tableau de phrases descendait sur CHAQUE page qui émet un événement — c'est-à-dire toutes. Une
 * ligne de plus pour `parent_invite` suffisait à faire dépasser `/programme` de son plafond de
 * JavaScript (`perf:budget`). Ici, il ne part qu'avec l'admin.
 *
 * Le NOM des événements reste un type dans `product-events.ts` : c'est lui qui rend la liste
 * fermée à la compilation. Ce fichier le décrit ; le test vérifie que les deux disent la même chose.
 */
import type { ProductEventName } from "@/shared/lib/product-events";

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
  {
    name: "parent_invite",
    fires:
      "Carte « Inviter mon parent » de l'écran de résultat : montrée ou écartée — l'envoi, lui, est `content_shared{intent:\"parent\"}` (étude 40 lot 5)",
    live: true,
  },
] as const;

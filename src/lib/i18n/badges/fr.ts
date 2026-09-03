import type { BadgeTranslations } from "../badge.types";

export const frBadges: BadgeTranslations = {
  badgeCollection: {
    families: {
      debut: "Premiers pas",
      serie: "Séries",
      maitrise: "Maîtrise",
      arene: "Arène",
      saison: "Saison",
    },
    labels: {
      first_quest: { name: "Première Quête", condition: "Terminer son premier exercice" },
      level_10: { name: "Rang 10", condition: "Atteindre le niveau 10" },
      streak_7: { name: "Flamme de 7 Jours", condition: "Tenir 7 jours consécutifs" },
      streak_30: { name: "Flamme Légendaire", condition: "Tenir 30 jours consécutifs" },
      perfect_score: { name: "Score Parfait", condition: "Obtenir 100 % sur un exercice" },
      speed_demon: {
        name: "Démon de Vitesse",
        condition: "Terminer un exercice réussi en moins de 60 secondes",
      },
      math_blitz: {
        name: "Foudre de Calcul",
        condition: "Obtenir 95 % ou plus sur un exercice de mathématiques",
      },
      math_master: {
        name: "Maître des Maths",
        condition: "Réussir 10 exercices de mathématiques à 80 % ou plus",
      },
      polyglot: {
        name: "Polyglotte",
        condition: "Réussir un exercice dans trois langues de contenu différentes",
      },
      boss_slayer: { name: "Tueur de Boss", condition: "Franchir 10 étages de donjon au total" },
      collector: { name: "Collectionneur", condition: "Posséder 5 objets différents" },
      rich_kid: { name: "Riche Héritier", condition: "Atteindre 500 pièces" },
      league_podium: {
        name: "Podium de Ligue",
        condition: "Terminer une semaine de ligue en or, platine ou diamant",
      },
      event_rentree: {
        name: "Rentrée 2026",
        condition: "Relever le défi de la rentrée pendant sa fenêtre",
      },
      event_synthese: {
        name: "Devoirs de synthèse",
        condition: "Réussir 3 missions à 90 % pendant la quinzaine des devoirs de synthèse",
      },
      event_ramadan: {
        name: "Ramadan 1448",
        condition: "Jouer 3 missions pendant la quinzaine du Défi Ramadan",
      },
      event_revisions: {
        name: "Révisions de mai",
        condition: "Réussir 5 missions à 90 % pendant la quinzaine des révisions de mai",
      },
    },
    familyProgress: "{n}/{total}",
    locked: "À débloquer",
    collectionProgress: "{n} badges sur {total}",
  },
};

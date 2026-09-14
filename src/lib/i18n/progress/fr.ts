import type { ProgressTranslations } from "../progress.types";

export const frProgress: ProgressTranslations = {
  progress: {
    chapterStars: {
      tier1: "socle",
      tier2: "pratique",
      tier3: "boss",
      tier4: "élite",
      gaugeLabel: "{star} étoile(s) sur {total}",
      mastered: "Maîtrisé ✓",
      masteredWithNew: "Maîtrisé ✓ · ✨ {n} nouveauté(s)",
      rungCount: "{done}/{total}",
      legend: "Gagne l'étoile {star} en réussissant toutes les missions jusqu'à {tier}.",
      countedRule: "Une mission compte à partir de 60 %, en prenant ton temps.",
      none: "Aucune étoile pour l'instant",
      // Note de traduction : « acquise » et « à gagner » — jamais « perdue »,
      // « retard » ni « régression » (R-1). Une étoile ne redescend pas, donc la
      // langue n'a aucune raison de porter un verbe de perte.
    },
    newMissions: "✨ {n} nouvelle(s) mission(s)",
    newChapter: "✨ Nouveau chapitre",
    familyMissions: "Missions de la famille {done}/{total}",
    familyMissionsHint: "Elles rapportent des XP ; les étoiles restent celles du programme.",
    seal: {
      heading: "Sceaux de la matière",
      title: "Sceau {stars}",
      none: "Pas encore de sceau",
      earnedOn: "obtenu le {date}",
      next: "Prochain sceau {stars} : {ready}/{total} chapitres prêts",
      nextWithNew: "Prochain sceau {stars} : {ready}/{total} chapitres prêts, dont {n} nouveaux",
      rule: "Un sceau tombe quand TOUS les chapitres de la matière ont l'étoile.",
    },
    effort: {
      heading: "Ton travail ici",
      missions: "{n} missions réussies",
      xp: "{n} XP",
      chaptersStarted: "{started} chapitres commencés",
      chaptersMastered: "{mastered} maîtrisés",
    },
    celebration: {
      starTitle: "Étoile du chapitre !",
      starTitlePlural: "{n} étoiles d'un coup !",
      starBody: "Tu tiens l'étoile {star} de ce chapitre. Elle est à toi, définitivement.",
      starMastered: "Chapitre maîtrisé : il ne te reste plus rien à y faire.",
      sealTitle: "Sceau {stars}",
      sealBody:
        "Tous les chapitres de cette matière portent l'étoile. C'est daté, et ça ne s'efface pas.",
      sealHint: "Touche pour revenir à ton résultat.",
    },
    anonPromise: "Connecte-toi pour garder tes étoiles.",
  },
};

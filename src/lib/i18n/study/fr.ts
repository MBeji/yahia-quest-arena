import type { StudyTranslations } from "../study.types";

export const frStudy: StudyTranslations = {
  study: {
    title: { student: "Mon bilan", parent: "Bilan et programme" },
    goal: {
      title: "Objectif du jour",
      progress: "{done} min sur {target}",
      reached: "Objectif du jour atteint 🎉",
      week: "7 derniers jours : {minutes} min, {days} jour(s) de travail",
    },
    plan: {
      title: "Programme du jour",
      minutes: "≈ {n} min",
      stepMinutes: "{n} min",
      start: "Commencer",
      seeReport: "Voir le bilan complet",
      doneTitle: "Fait aujourd'hui",
      doneScore: "{score} %",
      emptyGoalReached: {
        student:
          "Tu as fait ton temps de travail du jour. À demain — ou continue si tu en as envie.",
        parent: "Le temps de travail du jour est fait.",
      },
      emptyUpToDate: {
        student:
          "Tu es à jour sur ce que tu as vu en classe. Coche tes nouveaux chapitres pour la suite.",
        parent:
          "Tout ce qui a été vu en classe est travaillé. Cochez les nouveaux chapitres pour la suite.",
      },
      kind: {
        retry: "À reprendre",
        quiz: "Quiz du chapitre",
        start: "Chapitre vu en classe",
        advance: "On avance",
      },
    },
    levels: {
      title: "Niveau par matière",
      level: {
        "non-evalue": "Pas encore évalué",
        "a-renforcer": "À renforcer",
        "en-progres": "En progrès",
        solide: "Solide",
      },
      recent: "{score} % de réussite sur {n} mission(s) récente(s)",
      noRecent: "Pas assez de missions récentes pour juger",
      seen: "{done} chapitre(s) acquis sur {seen} vu(s) en classe",
      exam: "Dernière épreuve : {mark}/20",
    },
    work: {
      title: "À travailler",
      empty: "Rien en attente dans les chapitres vus en classe.",
      status: {
        "non-commence": "Pas encore travaillé",
        fragile: "Fragile",
        "en-cours": "En cours",
        acquis: "Acquis",
        maitrise: "Maîtrisé",
      },
      missing: "{n} étape(s) avant l'étoile {star}",
    },
    classChapters: {
      title: { student: "Mes chapitres vus en classe", parent: "Chapitres vus en classe" },
      hint: {
        student: "Coche ce que tu as déjà fait en classe : ton programme ne te proposera que ça.",
        parent: "Cochez ce qui a été fait en classe : le programme ne proposera que cela.",
      },
      estimated: "Estimation d'après le calendrier scolaire — à corriger d'un geste.",
      declared: "{seen} chapitre(s) coché(s) sur {total}",
      through: "J'en suis là",
      error: "Enregistrement impossible. Réessaie.",
    },
    unavailable: "Le bilan n'est pas disponible pour l'instant.",
  },
};

import type { GuideTranslations } from "../guide.types";

export const frGuide: GuideTranslations = {
  guide: {
    sheetTitle: "Comment ça marche ?",
    sheetSubtitle: "Le mode d'emploi de cet écran, en mots simples.",
    onThisScreen: "Les boutons de cet écran",
    rule: {
      title: "La règle d'or : dans l'ordre",
      intro: "Chaque chapitre se travaille en 3 étapes. Chaque étape ouvre la suivante.",
      lesson: {
        title: "1. Lire le cours",
        text: "Lis le cours et son résumé. Ils sont toujours ouverts : tu peux y revenir quand tu veux.",
      },
      quiz: {
        title: "2. Valider ta compréhension",
        text: "Passe le petit quiz 🧠 du chapitre. Il vérifie que tu as compris : vise {pct} % de bonnes réponses, en prenant au moins {sec} secondes par question.",
      },
      missions: {
        title: "3. Attaquer les missions",
        text: "Quiz réussi : toutes les missions du chapitre s'ouvrent d'un coup. Commence par ⭐ (facile), puis monte vers ⭐⭐⭐ (boss).",
      },
    },
    stepper: {
      label: "Les 3 étapes du chapitre",
      lesson: "Cours",
      quiz: "Quiz",
      missions: "Missions",
      done: "fait",
      current: "à faire maintenant",
      next: "ensuite",
      locked: "fermé pour l'instant",
    },
    locked: {
      title: "Pourquoi cette mission est fermée ?",
      body: "Les missions s'ouvrent quand tu as montré que tu as compris le cours. Lis le cours, puis réussis le quiz de compréhension à {pct} % : toutes les missions de ce chapitre s'ouvriront.",
      aria: "Mission fermée : {title}. Touche pour savoir pourquoi.",
      why: "Pourquoi ?",
      readCourse: "Lire le cours",
      takeQuiz: "Passer le quiz",
    },
    tips: {
      toggleLabel: "Bulles d'aide « ? »",
      toggleHint:
        "Un petit « ? » doré apparaît à côté des boutons importants. Touche-le pour savoir à quoi sert le bouton.",
      aria: "Aide : {label}",
      readCourse:
        "Commence toujours par ici : le cours explique la leçon avec des exemples. Il est toujours ouvert.",
      quizRow:
        "Ce petit quiz vérifie que tu as compris le cours. Réussis-le à {pct} % (au moins {sec} secondes par question) et toutes les missions du chapitre s'ouvrent.",
      lessonQuizCta:
        "Tu as lu le cours ? Ce bouton lance le quiz de compréhension. Une fois réussi, les missions s'ouvrent.",
      lessonPracticeCta:
        "Le quiz est déjà réussi : ce bouton t'emmène directement aux missions pour t'entraîner.",
      parentLink:
        "Le code se trouve dans le compte de votre enfant : engrenage ⚙️ › « Tous les paramètres » › « Mon compte » › « Code Alliance ». Il le copie et vous le donne.",
    },
    intro: {
      badge: "Première visite",
      gotIt: "J'ai compris",
      more: "Voir toute l'aide",
    },
    footer: "Perdu ? Le bouton « Aide » en haut de l'écran est toujours là.",
    screens: {
      dashboard: {
        title: "Ton Hall des Héros",
        intro: "C'est ta page d'accueil. Elle te dit quoi faire maintenant.",
        items: [
          {
            icon: "▶️",
            label: "Le grand bouton « Continuer »",
            text: "Il t'emmène directement à la prochaine chose à faire. Dans le doute, touche-le.",
          },
          {
            icon: "🎯",
            label: "L'objectif du jour",
            text: "L'anneau se remplit avec les XP gagnés aujourd'hui. Les XP sont des points : tu en gagnes en réussissant des missions.",
          },
          {
            icon: "🔥",
            label: "Les pastilles sous ton nom",
            text: "Niveau, série de jours, XP et pièces. Touche une pastille pour savoir ce qu'elle veut dire.",
          },
          {
            icon: "🧭",
            label: "Les 4 boutons de navigation",
            text: "Hall des Héros = l'accueil · Parcours = la carte de tes matières · Découvrir = tout le programme · Arène = les défis contre les autres.",
          },
        ],
      },
      parcours: {
        title: "La carte de l'aventure",
        intro: "Toutes les matières de ta classe, sur une carte.",
        items: [
          {
            icon: "📍",
            label: "Les étapes de la carte",
            text: "Chaque étape est une matière. « Conseillé » montre celle par où commencer.",
          },
          {
            icon: "👆",
            label: "Toucher une matière",
            text: "Elle s'ouvre avec la liste de ses chapitres. Dans chaque chapitre : cours, puis quiz, puis missions.",
          },
          {
            icon: "⭐",
            label: "Les étoiles et les sceaux",
            text: "Tu gagnes des étoiles en réussissant les missions. Toutes les étoiles d'une matière = un sceau.",
          },
        ],
      },
      programme: {
        title: "Découvrir le programme",
        intro: "Toutes les classes et toutes les matières. Tout est gratuit.",
        items: [
          {
            icon: "🏫",
            label: "Choisir une classe",
            text: "Touche ta classe pour voir ses matières.",
          },
          {
            icon: "📚",
            label: "Choisir une matière",
            text: "Elle s'ouvre avec ses chapitres. Commence par le premier chapitre et suis l'ordre.",
          },
        ],
      },
      arena: {
        title: "L'Arène",
        intro: "Des défis pour t'amuser une fois tes chapitres travaillés.",
        items: [
          {
            icon: "🏰",
            label: "Donjon",
            text: "Des questions contre la montre, étage par étage.",
          },
          {
            icon: "⚔️",
            label: "Duels",
            text: "Affronte un autre élève sur les mêmes questions.",
          },
          {
            icon: "🏆",
            label: "Classement",
            text: "Ta place parmi les élèves, grâce à tes XP.",
          },
        ],
      },
      subject: {
        title: "Une matière, chapitre par chapitre",
        intro: "Ouvre un chapitre, puis suis ses 3 étapes dans l'ordre.",
        items: [
          {
            icon: "📂",
            label: "« Chapitre 1, 2, 3… »",
            text: "Touche la ligne d'un chapitre pour l'ouvrir ou le fermer.",
          },
          {
            icon: "📖",
            label: "« Lire le cours »",
            text: "La première étape. Le cours est toujours ouvert.",
          },
          {
            icon: "🧠",
            label: "Le quiz du chapitre",
            text: "La deuxième étape : il vérifie que tu as compris et ouvre les missions.",
          },
          {
            icon: "🔒",
            label: "Les missions avec un cadenas",
            text: "Elles attendent que le quiz soit réussi. Touche une mission fermée pour savoir quoi faire.",
          },
          {
            icon: "⭐",
            label: "Les étoiles à côté des missions",
            text: "La difficulté : ⭐ facile, ⭐⭐ moyen, ⭐⭐⭐ boss, ⭐⭐⭐⭐ défi.",
          },
        ],
      },
      lesson: {
        title: "Le cours",
        intro: "Lis tranquillement, puis passe au quiz en bas de la page.",
        items: [
          {
            icon: "📖",
            label: "Le cours et le résumé",
            text: "Lis-les dans l'ordre. Tu peux revenir ici quand tu veux.",
          },
          {
            icon: "🔍",
            label: "Les figures",
            text: "Touche une figure pour l'agrandir.",
          },
          {
            icon: "🧠",
            label: "Le bouton en bas de page",
            text: "Il lance le quiz de compréhension. Une fois réussi, il t'emmène aux missions.",
          },
          {
            icon: "↔️",
            label: "Chapitre précédent / suivant",
            text: "Tout en bas, pour passer d'un chapitre à l'autre.",
          },
        ],
      },
      quest: {
        title: "Une mission",
        intro: "Une question à la fois. Prends ton temps.",
        items: [
          {
            icon: "👆",
            label: "Choisir une réponse",
            text: "Touche la réponse que tu crois juste, puis valide.",
          },
          {
            icon: "⏱️",
            label: "Prendre son temps",
            text: "Réponds trop vite et la mission ne compte pas : au moins quelques secondes par question.",
          },
          {
            icon: "✅",
            label: "Le résultat",
            text: "À partir de 60 % de bonnes réponses, la mission compte et tu gagnes des XP. Tu peux la refaire pour battre ton score.",
          },
        ],
      },
      parent: {
        title: "Suivre votre enfant",
        intro: "Trois étapes suffisent pour voir ce que fait votre enfant.",
        items: [
          {
            icon: "1️⃣",
            label: "Demander le code de votre enfant",
            text: "Dans son compte : engrenage ⚙️ › « Tous les paramètres » › « Mon compte » › « Code Alliance ».",
          },
          {
            icon: "2️⃣",
            label: "« Associer un élève via Alliance Code »",
            text: "Tapez le code dans la case, puis touchez le bouton doré.",
          },
          {
            icon: "3️⃣",
            label: "Lire le bilan",
            text: "Chaque jour : le temps passé, les chapitres travaillés, les réussites et les difficultés.",
          },
          {
            icon: "📤",
            label: "Partager / Imprimer",
            text: "Envoyez le bilan par message ou imprimez-le.",
          },
        ],
      },
      suivi: {
        title: "Le suivi sans compte",
        intro: "Vous n'avez pas besoin de compte : le code de votre enfant suffit.",
        items: [
          {
            icon: "🔑",
            label: "Le code de votre enfant",
            text: "Dans son compte : engrenage ⚙️ › « Tous les paramètres » › « Mon compte » › « Code Alliance ».",
          },
          {
            icon: "⌨️",
            label: "Taper le code",
            text: "Collez-le dans la case et validez : le bilan s'affiche.",
          },
          {
            icon: "💾",
            label: "« Se souvenir de ce code »",
            text: "Cochez-la pour ne pas retaper le code à chaque visite (évitez sur un ordinateur partagé).",
          },
        ],
      },
      settings: {
        title: "Le paramétrage",
        intro: "Tout ce qui se règle, au même endroit.",
        items: [
          {
            icon: "🔑",
            label: "« Code Alliance »",
            text: "Le code à donner à ton parent pour qu'il suive tes progrès. Touche « Copier ».",
          },
          {
            icon: "🎒",
            label: "Ta classe",
            text: "Tu peux changer de classe ou de parcours ici.",
          },
          {
            icon: "⚙️",
            label: "L'engrenage en haut",
            text: "Langue, thème clair ou sombre, son, déconnexion.",
          },
        ],
      },
      general: {
        title: "Bienvenue sur Na9ra Nal3ab",
        intro: "Apprendre en jouant, à ton rythme. Tout est gratuit.",
        items: [
          {
            icon: "📚",
            label: "« Programme »",
            text: "Choisis une classe puis une matière pour commencer.",
          },
          {
            icon: "👨‍👩‍👧",
            label: "« Suivi parent »",
            text: "Pour les parents : suivez votre enfant avec son code, sans compte.",
          },
          {
            icon: "⚙️",
            label: "L'engrenage en haut",
            text: "Langue (français, anglais, arabe), thème et son.",
          },
        ],
      },
    },
  },
};

/**
 * LE GUIDE INTÉGRÉ — le mode d'emploi dans le site lui-même (2026-10-19).
 *
 * Public visé : l'élève ET le parent peu à l'aise avec le numérique. Chaque écran
 * a sa fiche (« à quoi sert chaque bouton »), la règle d'or « cours → quiz →
 * missions » est dite partout où une mission peut être fermée, et des bulles
 * « ? » se posent à côté des boutons importants.
 *
 * ⚠️ Même statut que `progress.types.ts` : cette microcopy ne sert que des
 * surfaces chargées dynamiquement (la fiche s'ouvre par `React.lazy`, les cartes
 * et bulles vivent dans des routes paresseuses). Elle a donc son catalogue
 * (`guide/{fr,en,ar}.ts`) et son budget (`i18n-guide-`) — seul le libellé du
 * bouton « Aide » reste app-wide (`layout.help`), parce que les deux en-têtes le
 * montrent à tout le monde.
 *
 * RÈGLES D'ÉCRITURE — le lecteur n'a jamais vu l'application :
 *   - une phrase = une idée, verbes à l'impératif, pas de jargon (« XP » s'explique) ;
 *   - un bouton se désigne par le libellé EXACT qu'il porte à l'écran — si l'écran
 *     change, la fiche change dans la même PR (journal 2026-08-20 : un mode
 *     d'emploi qui désigne un écran vidé fait chercher) ;
 *   - « tu » pour l'élève, « vous » pour les fiches parent ;
 *   - gratuité de phase : jamais « premium / abonnement / payant ».
 */

/** Les écrans qui ont une fiche. `general` sert de repli. */
export type GuideScreenKey =
  | "dashboard"
  | "parcours"
  | "programme"
  | "arena"
  | "subject"
  | "lesson"
  | "quest"
  | "parent"
  | "suivi"
  | "settings"
  | "general";

/** Une ligne de fiche : un repère visuel, le nom du bouton, ce qu'il fait. */
export interface GuideItem {
  icon: string;
  label: string;
  text: string;
}

export interface GuideScreenCopy {
  title: string;
  intro: string;
  items: GuideItem[];
}

export interface GuideTranslations {
  guide: {
    sheetTitle: string;
    sheetSubtitle: string;
    onThisScreen: string;
    rule: {
      title: string;
      intro: string;
      /** {pct} = seuil du quiz, {sec} = secondes minimum par question. */
      lesson: { title: string; text: string };
      quiz: { title: string; text: string };
      missions: { title: string; text: string };
    };
    stepper: {
      label: string;
      lesson: string;
      quiz: string;
      missions: string;
      done: string;
      current: string;
      next: string;
      locked: string;
    };
    locked: {
      title: string;
      /** {pct} = seuil du quiz. */
      body: string;
      /** {title} = titre de la mission. */
      aria: string;
      /** Le mot posé sur la ligne fermée, à la place du « — » muet d'avant. */
      why: string;
      readCourse: string;
      takeQuiz: string;
    };
    tips: {
      toggleLabel: string;
      toggleHint: string;
      /** {label} = ce que la bulle explique. */
      aria: string;
      readCourse: string;
      /** {pct} et {sec} comme `rule.quiz`. */
      quizRow: string;
      lessonQuizCta: string;
      lessonPracticeCta: string;
      parentLink: string;
    };
    intro: {
      badge: string;
      gotIt: string;
      more: string;
    };
    footer: string;
    screens: Record<GuideScreenKey, GuideScreenCopy>;
  };
}

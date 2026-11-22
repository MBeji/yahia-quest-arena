/**
 * BILAN ET PROGRAMME DU JOUR — le namespace partagé par l'élève et son parent
 * (commande du 2026-11-22). Sorti de `TranslationKeys` avec ses valeurs
 * (`study/{fr,en,ar}.ts`), pour la même raison que `progress.types.ts` : cette
 * microcopy ne sert que des surfaces chargées paresseusement (la carte du
 * tableau de bord, l'écran « Mon bilan », le suivi parental). Elle prend donc
 * son catalogue et son budget (`i18n-study-`).
 *
 * DEUX LECTEURS, UN TEXTE. Le même composant sert l'élève et son parent : les
 * rares phrases qui s'adressent au lecteur existent en deux versions
 * (`student` / `parent`), tout le reste est un constat qui se lit pareil.
 *
 * VOCABULAIRE — celui de `progress.types.ts` reste normatif : « maîtrisé » est
 * réservé à l'étoile 4, aucune formule de perte (« en retard », « régression »).
 * « Niveau » désigne ici la réussite d'une MATIÈRE, jamais une étoile.
 */
type ByAudience = { student: string; parent: string };

export type StudyTranslations = {
  study: {
    title: ByAudience;
    goal: {
      title: string;
      /** `{done}` minutes mesurées sur `{target}`. */
      progress: string;
      reached: string;
      /** `{minutes}` minutes sur `{days}` jour(s), sept derniers jours. */
      week: string;
      /** Le réglage de l'objectif — son titre, et une option de `{n}` minutes. */
      choose: string;
      option: string;
    };
    plan: {
      title: string;
      /** `{n}` minutes estimées pour ce qui reste. */
      minutes: string;
      /** Durée d'une étape — `{n}` minutes. */
      stepMinutes: string;
      start: string;
      seeReport: string;
      doneTitle: string;
      /** Score d'une mission faite aujourd'hui — `{score}`. */
      doneScore: string;
      emptyGoalReached: ByAudience;
      emptyUpToDate: ByAudience;
      kind: { retry: string; quiz: string; start: string; advance: string };
    };
    levels: {
      title: string;
      level: {
        "non-evalue": string;
        "a-renforcer": string;
        "en-progres": string;
        solide: string;
      };
      /** `{score}` % sur `{n}` missions récentes. */
      recent: string;
      noRecent: string;
      /** `{done}` chapitres acquis sur `{seen}` vus en classe. */
      seen: string;
      /** `{mark}` = la note déjà écrite « 13,5/20 », isolée en LTR. */
      exam: string;
    };
    work: {
      title: string;
      empty: string;
      status: {
        "non-commence": string;
        fragile: string;
        "en-cours": string;
        acquis: string;
        maitrise: string;
      };
      /** `{n}` étapes avant l'étoile `{star}`. */
      missing: string;
    };
    classChapters: {
      title: ByAudience;
      hint: ByAudience;
      estimated: string;
      /** `{seen}` chapitres cochés sur `{total}`. */
      declared: string;
      through: string;
      error: string;
    };
    focus: {
      /** Le bouton d'une matière, et son état quand elle est prioritaire. */
      toggle: string;
      active: string;
      hint: ByAudience;
      error: string;
    };
    unavailable: string;
  };
};

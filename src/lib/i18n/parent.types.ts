/**
 * Suivi parental — les deux namespaces du **tableau de bord parent**, sortis de
 * `types.ts` avec leurs valeurs (`parent/{fr,en,ar}.ts`).
 *
 * ⚠️ Ce fichier ne se lit PAS comme `duel.types.ts` / `tutor.types.ts` /
 * `adaptive.types.ts` : ceux-là sont sortis pour garder `types.ts` sous son
 * plafond de lignes, et restent membres de `TranslationKeys`. Ces deux-ci sont
 * sortis de `TranslationKeys` **tout court**, pour que leurs ~13 KB ne soient
 * plus téléchargés par les élèves — voir `parent/index.ts` et le budget
 * `i18n-parent-` dans `scripts/check-bundle-budget.mjs`.
 *
 * Ajouter une clé ici l'ajoute au chunk parent, pas au catalogue app-wide.
 */
export type ParentTranslations = {
  // Parent / admin follow-up report
  parentReport: {
    adminTitle: string;
    title: string;
    adminSubtitle: string;
    subtitle: string;
    linkTitle: string;
    codePlaceholder: string;
    relationPlaceholder: string;
    linkCta: string;
    linking: string;
    linkHint: string;
    // Mémoire locale du code sur la page publique /suivi (sans compte, sans session).
    rememberCode: string;
    rememberHint: string;
    forgetCode: string;
    linkSuccess: string;
    linkFailed: string;
    // Alliance-code errors, keyed by the server's stable ParentCodeErrorCode
    // ("generic" splits by context: link vs public report).
    codeErrors: {
      not_parent: string;
      invalid_code: string;
      self_link: string;
      not_student: string;
      not_found: string;
      generic_link: string;
      generic_report: string;
    };
    defaultStudentName: string;
    adminEmptyTitle: string;
    adminEmptyDesc: string;
    linkFirstHint: string;
    prevPage: string;
    nextPage: string;
    pageLabel: string;
    classLabel: string;
    classNone: string;
    memberSince: string;
    timeTotal: string;
    exercisesLabel: string;
    avgScore: string;
    activeDays: string;
    trendPrefix: string;
    trendSuffix: string;
    activityTitle: string;
    today: string;
    perSubjectTitle: string;
    exSuffix: string;
    lastActivity: string;
    noActivity: string;
    seriousness: string;
    verdictExcellent: string;
    verdictExcellentDesc: string;
    verdictGood: string;
    verdictGoodDesc: string;
    verdictAverage: string;
    verdictAverageDesc: string;
    verdictNeedsImprovement: string;
    verdictNeedsImprovementDesc: string;
    verdictInactive: string;
    verdictInactiveDesc: string;
    weekCompareTitle: string;
    weekMinutes: string;
    insightsTitle: string;
    insightsSubtitle: string;
    strengthsTitle: string;
    weaknessesTitle: string;
    strengthsEmpty: string;
    weaknessesEmpty: string;
    // Étude 04 A2.2 : les erreurs NOMMÉES, distinctes des chapitres « à renforcer ».
    namedErrorsTitle: string;
    namedErrorsSubtitle: string;
    /** `{n}` = le nombre d'occurrences. */
    namedErrorsCount: string;
    namedErrorsImproving: string;
    namedErrorsWorsening: string;
    namedErrorsStable: string;
    /**
     * Étude 11 lot 4 (Q-5) — CE QUE LE PARENT VOIT DE L'AIDE DU TUTEUR.
     *
     * Des compteurs et des THÈMES, jamais une phrase de la conversation. Le
     * sous-titre le DIT au parent, et ce n'est pas une précaution juridique :
     * un parent qui croit lire les échanges de son enfant les cherchera, et un
     * enfant qui croit être rapporté mot à mot se taira.
     */
    tutorHelpTitle: string;
    tutorHelpSubtitle: string;
    /** `{n}` = le nombre de demandes sur 7 jours. */
    tutorHelp7d: string;
    /** `{n}` = le nombre de demandes sur 30 jours. */
    tutorHelp30d: string;
    tutorHelpThemesTitle: string;
    insightAttempts: string;
    adviceTitle: string;
    adviceReviewCta: string;
    adviceWeakness: string;
    adviceKeepUp: string;
    adviceInactive: string;
    printCta: string;
    shareCta: string;
    printTitle: string;
    printGenerated: string;
    pushTitle: string;
    pushDesc: string;
    goalTitle: string;
    goalHint: string;
    goalSave: string;
    goalSaving: string;
    goalSaved: string;
    goalProgress: string;
    goalUnit: string;
    coverageShort: string;
  };
  // Suivi parental « jour par jour » — tableau de bord d'activité quotidienne.
  // Les libellés d'alerte portent des paramètres entre accolades, remplis par
  // `alertMessage` depuis les règles pures de `insights/alerts.ts`.
  parentDaily: {
    tabSummary: string;
    tabDaily: string;
    // Sélecteur de période
    periodToday: string;
    periodYesterday: string;
    periodLast7: string;
    periodThisWeek: string;
    periodLast30: string;
    periodThisMonth: string;
    periodCustom: string;
    periodFrom: string;
    periodTo: string;
    periodMaxHint: string;
    // Les quatre questions (§11)
    q1Works: string;
    q1Yes: string;
    q1No: string;
    q2Serious: string;
    q3Progress: string;
    q3Answer: string;
    q4Efficient: string;
    unknown: string;
    noComparison: string;
    none: string;
    measuredSinceNotice: string;
    // Résumé de la journée / période
    summaryTitleDay: string;
    summaryTitlePeriod: string;
    appTime: string;
    appTimeHint: string;
    learningTime: string;
    learningTimeHint: string;
    activities: string;
    firstActivity: string;
    lastActivity: string;
    sessions: string;
    activeDays: string;
    // Répartition du temps par type d'activité
    breakdownTitle: string;
    breakdownSubtitle: string;
    breakdownEmpty: string;
    typeLesson: string;
    typeExercise: string;
    typeQuiz: string;
    typeRecall: string;
    typeArena: string;
    typeBrowse: string;
    // Cours consultés
    lessonsTitle: string;
    lessonsSubtitle: string;
    lessonsEmpty: string;
    lessonStudied: string;
    lessonOpened: string;
    lessonViews: string;
    lessonProgressAria: string;
    // Exercices réalisés
    exercisesTitle: string;
    exercisesSubtitle: string;
    exercisesEmpty: string;
    attemptNo: string;
    rightWrong: string;
    showMore: string;
    modePractice: string;
    modeQuiz: string;
    modeBoss: string;
    modeRecall: string;
    // Détail d'une tentative
    attemptDetailTitle: string;
    attemptDetailFailed: string;
    attemptReviewHidden: string;
    attemptNoAnswers: string;
    questionLabel: string;
    childAnswer: string;
    expectedAnswer: string;
    // KPI
    performanceTitle: string;
    performanceSubtitle: string;
    kpiAccuracy: string;
    kpiSuccess: string;
    kpiTriesToPass: string;
    kpiPerQuestion: string;
    kpiPerExercise: string;
    kpiLessonCompletion: string;
    kpiExerciseCompletion: string;
    kpiRegularity: string;
    kpiStreak: string;
    // Progression
    progressionTitle: string;
    progressionByTime: string;
    progressionByActivity: string;
    dayTooltip: string;
    compareHint: string;
    // Indices explicables
    engagementTitle: string;
    engagementSubtitle: string;
    efficiencyTitle: string;
    efficiencySubtitle: string;
    indexNotEnoughData: string;
    indexScoreOutOf: string;
    indexDrivers: string;
    indexHolders: string;
    bandExcellent: string;
    bandGood: string;
    bandFair: string;
    bandWeak: string;
    factorRegularity: string;
    factorLearningTime: string;
    factorActivityVolume: string;
    factorLessonCompletion: string;
    factorPerseverance: string;
    factorProgress: string;
    factorRevision: string;
    factorAccuracy: string;
    factorTimeToResult: string;
    factorRetrySuccess: string;
    factorPace: string;
    factorRevisionGain: string;
    unitDays: string;
    unitPoints: string;
    unitTries: string;
    unitMinutesPerSuccess: string;
    unitSecondsPerQuestion: string;
    // Matières
    subjectsTitle: string;
    subjectsSubtitle: string;
    subjectsEmpty: string;
    colSubject: string;
    colCoverage: string;
    scopeLabel: string;
    scopeClass: string;
    scopeClassHint: string;
    scopeAll: string;
    scopeExcluded: string;
    coverageAria: string;
    colTime: string;
    colLessons: string;
    colExercises: string;
    colSuccess: string;
    colProgress: string;
    colLevel: string;
    subjectsStrong: string;
    subjectsFragile: string;
    subjectsNeglected: string;
    subjectsImproving: string;
    // Alertes et recommandations
    alertsTitle: string;
    alertsSubtitle: string;
    alertsEmpty: string;
    alertNoActivity: string;
    alertPerformanceDrop: string;
    alertTimeWithoutProgress: string;
    alertTimeLowYield: string;
    alertChapterStruggle: string;
    alertSubjectNeglected: string;
    alertAbandonedExercises: string;
    alertLowRegularity: string;
    alertRevisionNeeded: string;
    alertImprovement: string;
    alertGoalReached: string;
    alertStrongSubject: string;
  };
};

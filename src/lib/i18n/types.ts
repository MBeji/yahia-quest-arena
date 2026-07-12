import type { DuelTranslations } from "./duel.types";

export type Locale = "en" | "fr" | "ar";

export type TranslationKeys = {
  // Meta
  meta: {
    title: string;
    description: string;
    ogTitle: string;
    ogDescription: string;
  };
  // Common
  common: {
    backToHall: string;
    back: string;
    /** Accessible label for DifficultyStars — {n}/{max} placeholders. */
    difficulty: string;
    loading: string;
    retry: string;
    home: string;
    continue: string;
    completed: string;
    leaderboard: string;
    signIn: string;
    signUp: string;
  };
  // 404 / Error
  errors: {
    notFoundTitle: string;
    notFoundDesc: string;
    notFoundAction: string;
    errorTitle: string;
    errorFallback: string;
    /** Route-level load failures (public tier included) — étude 14, R-6. */
    subjectLoadFailed: string;
    programmeLoadFailed: string;
    parcoursLoadFailed: string;
    parcoursNotFound: string;
    chapterLoadFailed: string;
    extrasLoadFailed: string;
    sessionStartFailed: string;
  };
  // Auth screen (login / signup)
  auth: {
    titleSignup: string;
    titleLogin: string;
    subtitleSignup: string;
    subtitleLogin: string;
    googleCta: string;
    sessionRemembered: string;
    or: string;
    roleLabel: string;
    roleStudent: string;
    roleParent: string;
    heroNameLabel: string;
    allianceCodeLabel: string;
    allianceCodeHint: string;
    emailLabel: string;
    passwordLabel: string;
    submitSignup: string;
    submitLogin: string;
    hasAccountPrompt: string;
    noAccountPrompt: string;
    switchToSignup: string;
    toastSignupSuccess: string;
    toastLoginSuccess: string;
    toastLinked: string;
    googleNotConfigured: string;
    googleFailed: string;
    // Error messages (friendlyAuthError + form validation)
    passwordTooShort: string;
    errorInvalidLogin: string;
    errorEmailNotConfirmed: string;
    errorAccountExists: string;
    errorRateLimit: string;
    errorSignupDisabled: string;
    errorGeneric: string;
    oauthErrorPrefix: string;
    googleCallbackIncomplete: string;
    // Email-confirmation interstitial
    emailSentTitle: string;
    emailSentBody1: string;
    emailSentBody2: string;
    emailSentSpam: string;
    emailSentEdit: string;
  };
  // Dashboard
  dashboard: {
    title: string;
    heroClass: string;
    days: string;
    day: string;
    longestStreak: string;
    levelLabel: string;
    noQuestTarget: string;
    xpProgress: string;
    allianceCode: string;
    allianceCopy: string;
    allianceCopied: string;
    allianceHint: string;
    dailyGoalLabel: string;
    dailyGoalReached: string;
    dailyGoalRemaining: string;
    consecutiveDays: string;
    quoteLabel: string;
    streakLostTitle: string;
    streakLostDesc: string;
    streakRecover: string;
    retryTitle: string;
    continueLabel: string;
    dungeonDesc: string;
    dailyQuests: string;
    weeklyQuests: string;
    // Raw daily-objective / weekly-quest type codes → student-facing labels.
    objectiveTypes: Record<string, string>;
    questTypes: Record<string, string>;
    dailyEmpty: string;
    weeklyEmpty: string;
    pathsTitle: string;
    boutiqueTitle: string;
    boutiqueSubtitle: string;
    boutiqueCard: string;
    boutiqueCardDesc: string;
    discoverTitle: string;
    discoverDesc: string;
    notAttempted: string;
    failedLoad: string;
    failedLoadDesc: string;
    // Badges & Academy Shop (dashboard sections)
    badgesTitle: string;
    badgeTag: string;
    badgeDefaultReason: string;
    badgeEarnedOn: string;
    badgesEmpty: string;
    shopTitle: string;
    shopDefaultDesc: string;
    shopEquipped: string;
    shopOwned: string;
    shopInStock: string;
    shopBuy: string;
    shopEquip: string;
    shopActivate: string;
    armedPassive: string;
    armedQuest: string;
    itemTypes: { skin: string; potion: string; booster: string; shield: string };
    rarities: { common: string; rare: string; epic: string; legendary: string };
    radarTitle: string;
    radarCaption: string;
    inventoryTitle: string;
    inventoryEmpty: string;
    // Shop / streak action toasts
    purchaseSuccess: string;
    purchaseFailed: string;
    equipSuccess: string;
    equipFailed: string;
    itemArmedPassive: string;
    itemArmedQuest: string;
    activationFailed: string;
    streakRecovered: string;
    recoveryFailed: string;
    familyGoalTitle: string;
    familyGoalProgress: string;
    familyGoalReached: string;
    familyGoalHint: string;
    welcomeBack: string;
    firstRunWelcome: string;
    resumeSubtitle: string;
  };
  // Quest
  quest: {
    title: string;
    preparing: string;
    leaveQuest: string;
    bossFight: string;
    bossHp: string;
    bossStrike: string;
    questionOf: string;
    feedbackMsg: string;
    selectedAnswer: string;
    nextQuestion: string;
    finishQuest: string;
    bossAttack: string;
    bossFinalBlow: string;
    keyboardHint: string;
    victoryTitle: string;
    niceTriTitle: string;
    xpLabel: string;
    coinsLabel: string;
    levelLabel: string;
    streakLabel: string;
    badgesUnlocked: string;
    retryShieldUsed: string;
    revealHint: string;
    hintRevealed: string;
    noHintsLeft: string;
    hintUnavailable: string;
    hintUseInQuest: string;
    replayQuest: string;
    nextQuest: string;
    backToSubject: string;
    questReview: string;
    passed: string;
    needsWork: string;
    yourAnswer: string;
    correctAnswer: string;
    resultScore: string;
    serverValidatedTime: string;
    timeSpent: string;
    quizContract: string;
    questionN: string;
    potionXpApplied: string;
    potionCoinsApplied: string;
  };
  // Level up
  levelUp: {
    title: string;
    tapContinue: string;
  };
  // Dungeon
  dungeon: {
    heroesHall: string;
    title: string;
    desc: string;
    xpPerFloor: string;
    coinsPerFloors: string;
    life: string;
    enterDungeon: string;
    collapsed: string;
    fellAt: string;
    fatalQuestion: string;
    yourAnswer: string;
    correctAnswer: string;
    floors: string;
    xp: string;
    coins: string;
    correct: string;
    backToHall: string;
    retryDungeon: string;
    descending: string;
    leaveDungeon: string;
    floor: string;
    oneHp: string;
    warning: string;
    validate: string;
    correctMsg: string;
    wrongMsg: string;
    depth: string;
    // Run lifecycle error toasts
    errorSavingRun: string;
    noMoreQuestions: string;
    failedLoadQuestions: string;
    failedStartRun: string;
    failedValidateAnswer: string;
    loadAccessError: string;
    enterDungeonAria: string;
    locked: string;
    dailyLimitReached: string;
    levelLocked: string;
    prereqLocked: string;
    subjectsStarted: string;
    chaptersStarted: string;
    keepTraining: string;
    runsToday: string;
  };
  // Duels 1v1 (étude 05) — keys in ./duel.types.ts (keeps this file under max-lines).
  duel: DuelTranslations;
  // Subscription / premium
  subscription: {
    premiumTitle: string;
    premiumDesc: string;
    contactTitle: string;
    statusActive: string;
    statusInactive: string;
    none: string;
    perpetual: string;
    colUser: string;
    colStatus: string;
    colParcours: string;
    colSource: string;
    colExpires: string;
    colActions: string;
    // Entitlement sources
    purchase: string;
    beta: string;
    gift: string;
    family: string;
    adminTitle: string;
    adminDesc: string;
    accessDenied: string;
    grantTitle: string;
    grantUserId: string;
    grantUserIdPlaceholder: string;
    grantParcours: string;
    grantSource: string;
    grantMonths: string;
    grantMonthsPlaceholder: string;
    grant: string;
    revoke: string;
    granted: string;
    revoked: string;
    entitlementsEmpty: string;
    updateError: string;
  };
  // Beta tester free premium access
  betaAccess: {
    cta: string;
    title: string;
    desc: string;
    nameLabel: string;
    emailLabel: string;
    motivationLabel: string;
    motivationPlaceholder: string;
    submit: string;
    submitting: string;
    sentTitle: string;
    sentDesc: string;
    statusLabel: string;
    statusPending: string;
    statusApproved: string;
    statusRejected: string;
    pendingDesc: string;
    approvedDesc: string;
    rejectedDesc: string;
    cancel: string;
    error: string;
    adminTitle: string;
    adminDesc: string;
    pendingCount: string;
    empty: string;
    colName: string;
    colEmail: string;
    colMotivation: string;
    colDate: string;
    colStatus: string;
    colActions: string;
    approve: string;
    reject: string;
    approveOk: string;
    rejectOk: string;
    reviewError: string;
  };
  // Content error reports ("Signaler une erreur")
  contentReport: {
    cta: string;
    label: string;
    placeholder: string;
    send: string;
    cancel: string;
    sent: string;
    error: string;
    adminTitle: string;
    adminDesc: string;
    openCount: string;
    empty: string;
    unknownExercise: string;
    statusOpen: string;
    statusResolved: string;
    statusDismissed: string;
    resolve: string;
    dismiss: string;
    updated: string;
    updateError: string;
  };
  // Beta badge ("phase de test")
  betaBanner: {
    badge: string;
    tooltip: string;
  };
  // Bug reports ("Signaler un bug")
  bugReport: {
    launcherLabel: string;
    title: string;
    desc: string;
    label: string;
    placeholder: string;
    send: string;
    cancel: string;
    sent: string;
    error: string;
    adminTitle: string;
    adminDesc: string;
    openCount: string;
    empty: string;
    unknownPage: string;
    statusOpen: string;
    statusResolved: string;
    statusDismissed: string;
    resolve: string;
    dismiss: string;
    updated: string;
    updateError: string;
  };
  // Push notifications (enable card)
  pushNotifications: {
    cardTitle: string;
    cardDesc: string;
    enable: string;
    enabling: string;
    enabled: string;
    disable: string;
    blocked: string;
    errorGeneric: string;
  };
  // Layout
  layout: {
    heroesHall: string;
    parcours: string;
    themes: string;
    dungeon: string;
    arena: string;
    ranking: string;
    parentReport: string;
    admin: string;
    subscriptions: string;
    betaRequests: string;
    contentReports: string;
    bugReports: string;
    parcoursInterest: string;
    signOut: string;
    logoutToast: string;
  };
  // Theme picker (visual skin)
  theme: {
    label: string;
    reference: string;
    dark: string;
  };
  // Sound & music controls
  sound: {
    label: string;
    effects: string;
    music: string;
    enable: string;
    disable: string;
  };
  // Encouraging combo / streak micro-messages
  encouragement: {
    combo: string;
    nice: string;
    onFire: string;
    unstoppable: string;
    legendary: string;
  };
  // Adventure path / journey map
  parcours: {
    worldTitle: string;
    worldSubtitle: string;
    level: string;
    xpToNext: string;
    maxLevel: string;
    start: string;
    continueLabel: string;
    review: string;
    locked: string;
    lockedHint: string;
    done: string;
    current: string;
    xpToEarn: string;
    chapters: string;
    backToMap: string;
    empty: string;
  };
  // Explorer parcours hub (/themes route)
  explorer: {
    heading: string;
    subtitle: string;
    concoursTitle: string;
    libreTitle: string;
    unlocked: string;
    comingSoon: string;
    switching: string;
    switchError: string;
    failedLoad: string;
    empty: string;
  };
  // Onboarding (intent + parcours pick)
  onboarding: {
    intentTitle: string;
    intentSubtitle: string;
    concoursTitle: string;
    concoursDesc: string;
    exploreTitle: string;
    exploreDesc: string;
    parcoursTitleConcours: string;
    parcoursTitleLibre: string;
    parcoursSubtitleConcours: string;
    parcoursSubtitleLibre: string;
    saving: string;
    saveError: string;
  };
  // School cycle group labels (programme scolaire)
  cycles: {
    primaire: string;
    college: string;
    secondaire: string;
  };
  // Lycée year → section drill-down (étude 16 D-5/R-2) — shared by the
  // onboarding picker and the public catalogue. {n} placeholders.
  lycee: {
    year2: string;
    year3: string;
    yearBac: string;
    /** "{n} sections" */
    sections: string;
    /** "{n} disponibles" */
    available: string;
    pickSection: string;
  };
  // Interest votes on coming-soon parcours (+ admin ranking)
  parcoursInterest: {
    cta: string;
    interested: string;
    count: string;
    underConstruction: string;
    toggleError: string;
    loadError: string;
    adminTitle: string;
    adminDesc: string;
    colProgram: string;
    colInterest: string;
    empty: string;
  };
  // "Découvrir" hub (circular catalogue of the 5 root programs)
  discover: {
    heading: string;
    subtitle: string;
    center: string;
    enter: string;
    back: string;
    families: {
      tunisien: string;
      langues: string;
      culture: string;
      cerveau: string;
      ib: string;
    };
    langShort: {
      anglais: string;
      francais: string;
      arabe: string;
    };
    hintClasses: string;
    hintLanguages: string;
    hintSoon: string;
    hintExplore: string;
    // Category page (one dedicated page per root program)
    backToPrograms: string;
    start: string;
    comingSoonTitle: string;
    comingSoonDesc: string;
    familyDesc: {
      tunisien: string;
      langues: string;
      culture: string;
      cerveau: string;
      ib: string;
    };
  };
  // Leaderboard page chrome
  arena: {
    title: string;
    subtitle: string;
    dungeonReward: string;
    duelReward: string;
    rankingDesc: string;
    rankingReward: string;
  };
  leaderboard: {
    titleGradient: string;
    titleRest: string;
    globalTab: string;
    subtitleGlobal: string;
    subtitleSubject: string;
    loading: string;
    youChip: string;
    lvl: string;
    emptyGlobal: string;
    emptySubject: string;
  };
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
    insightAttempts: string;
    adviceTitle: string;
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
  };
  // Playful explainability hover hints
  explain: {
    xp: string;
    level: string;
    streak: string;
    coins: string;
    heroClass: string;
    questResultXp: string;
    questResultScore: string;
    lockedChapter: string;
  };
  // Public « Référence » register (chantier C8): landing, catalogue, level page,
  // course reader, subject hub, anonymous practice + shared public chrome.
  public: {
    header: {
      homeAria: string;
      navAria: string;
      programme: string;
      extras: string;
      parentTracking: string;
      login: string;
      signup: string;
      account: string;
    };
    footer: { tagline: string; rights: string; legalLink: string };
    landing: {
      freeBadge: string;
      heroTitle: string;
      heroSubtitle: string;
      ctaProgramme: string;
      ctaExtras: string;
      personaStudentTitle: string;
      personaStudentDesc: string;
      personaParentTitle: string;
      personaParentDesc: string;
      personaTeacherTitle: string;
      personaTeacherDesc: string;
      personaCta: string;
      cyclesTitle: string;
      cyclesSubtitle: string;
      proofCoursesTitle: string;
      proofCoursesDesc: string;
      proofExercisesTitle: string;
      proofExercisesDesc: string;
      proofConformTitle: string;
      proofConformDesc: string;
      gameKicker: string;
      gameTitle: string;
      gameDesc: string;
      gameFeatXp: string;
      gameFeatBadges: string;
      gameFeatRanking: string;
      gameCta: string;
      gameCtaAuthed: string;
      languesKicker: string;
      languesTitle: string;
      languesSubtitle: string;
      languesCta: string;
      languesFrName: string;
      languesFrStandard: string;
      languesEnName: string;
      languesEnStandard: string;
      familleKicker: string;
      familleTitle: string;
      familleSubtitle: string;
      familleFeatTrack: string;
      familleFeatInsights: string;
      familleFeatAdvice: string;
      familleFeatPrint: string;
      familleStepsTitle: string;
      familleStep1: string;
      familleStep2: string;
      familleStep3: string;
      familleCta: string;
      familleCtaAuthed: string;
    };
    cycles: {
      primaire: string;
      college: string;
      lycee: string;
      primaireYears: string;
      collegeYears: string;
      lyceeYears: string;
      concours6: string;
      concours9: string;
      bac: string;
    };
    catalogue: {
      programmeKicker: string;
      programmeTitle: string;
      programmeDesc: string;
      programmeEmpty: string;
      extrasLinkQuestion: string;
      extrasLinkCta: string;
      extrasKicker: string;
      extrasTitle: string;
      extrasDesc: string;
      extrasEmpty: string;
      cardComingSoon: string;
      cardContent: string;
      cardConcoursBadge: string;
      /** Sober description of a lycée year page (public register). */
      lyceeYearDesc: string;
    };
    niveau: {
      backProgramme: string;
      backExtras: string;
      chooseSubject: string;
      comingSoonTitle: string;
      comingSoonDesc: string;
      choose: string;
      choosing: string;
      /** R-6 étude 16 — honest note under the « choose » switch button. */
      switchNote: string;
    };
    reader: {
      defaultSubject: string;
      courseTab: string;
      summaryTab: string;
      print: string;
      courseSoon: string;
      practiceCta: string;
      quizFirstCta: string;
      inviteTitle: string;
      inviteDesc: string;
      inviteCta: string;
      manuelTitle: string;
      manuelHint: string;
      manuelPage: string;
      manuelOpen: string;
      manuelPrev: string;
      manuelNext: string;
    };
    subject: {
      chapter: string;
      readCourse: string;
      resumeHere: string;
      missionsProgress: string;
      quizToPass: string;
      todo: string;
      unlocksChapter: string;
      quizContract: string;
    };
    practice: {
      back: string;
      reviewCourse: string;
      modeKicker: string;
      subtitle: string;
      scoreCorrect: string;
      questionN: string;
      correctAria: string;
      yourAnswerAria: string;
      checkError: string;
      checkCta: string;
      answerAllHint: string;
      restart: string;
      questCta: string;
      continueCta: string;
      inviteDesc: string;
      inviteCta: string;
    };
    print: { copyrightNotice: string };
    legal: {
      title: string;
      intro: string;
      ipTitle: string;
      ipBody: string;
      useTitle: string;
      useBody: string;
      brandTitle: string;
      brandBody: string;
      contactTitle: string;
      contactBody: string;
      lawTitle: string;
      lawBody: string;
      updated: string;
    };
  };
  // Motivational quotes
  quotes: Array<{ text: string; author: string }>;
};

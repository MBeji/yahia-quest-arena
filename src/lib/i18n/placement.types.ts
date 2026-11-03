/**
 * LE TEST DE NIVEAU — le namespace `placement.*` (étude 39, §2.3). Sorti de
 * `TranslationKeys` avec ses valeurs (`placement/{fr,en,ar}.ts`).
 *
 * ⚠️ Même statut que `progress.types.ts` et pour la même raison : cette microcopy ne sert que
 * des surfaces atteintes par des routes paresseuses (`/test-de-niveau`, la carte du Hall chargée
 * en `lazy()`, la fin de l'accueil). La laisser dans le catalogue app-wide la ferait descendre
 * chez tout le monde alors que `i18n-` est à son plafond. Elle prend donc son catalogue et son
 * budget (`i18n-placement-`). La seule clé app-wide du test est l'entrée de l'en-tête public
 * (`public.header.placement`), parce que l'en-tête n'est pas paresseux.
 *
 * VOCABULAIRE NORMATIF (étude 39 §2.3) — ne pas improviser : **test de niveau** · **bilan** ·
 * **tenu ✓** / **à revoir ↻** · les quatre bandes (`solide`, `en-route`, `consolider`,
 * `reprendre`). Interdits : « diagnostic », « examen », « évaluation », tout mot de perte
 * (é34 R-1), « premium / abonnement / payant ».
 */
export type PlacementTranslations = {
  placement: {
    /** L'entrée publique : le titre, la promesse, les trois faits. */
    entry: {
      kicker: string;
      title: string;
      subtitle: string;
      /** Les trois faits — `{n}` questions. */
      factQuestions: string;
      factMinutes: string;
      factBilan: string;
      /** « Je suis… » */
      audienceLabel: string;
      audienceStudent: string;
      audienceParent: string;
      audienceParentHint: string;
      pickGrade: string;
      pickSubject: string;
      /** Aucune matière testable pour cette classe. */
      noSubject: string;
      start: string;
      starting: string;
      /** Un test déjà passé sur cet appareil — `{score}`, `{subject}`. */
      lastResultTitle: string;
      lastResultBody: string;
      lastResultOpen: string;
      /** Le message quand le départ échoue. */
      startFailed: string;
      busy: string;
      notEnough: string;
      /** Le connecté : « tes bilans sont dans ton Hall ». */
      signedInHint: string;
    };
    runner: {
      /** `{n}` sur `{total}`. */
      progress: string;
      previous: string;
      next: string;
      finish: string;
      finishing: string;
      /** Rappel : pas de correction en cours de route. */
      noFeedbackHint: string;
      /** Reprise : « on reprend où tu en étais ». */
      resumed: string;
      leave: string;
      loading: string;
      /** La question n'est pas répondue — pour « Terminer » avec des trous. */
      unanswered: string;
      finishFailed: string;
    };
    summary: {
      title: string;
      /** « Ta note » / « Note ». */
      scoreLabel: string;
      /** `{correct}` bonnes réponses sur `{total}`. */
      correctOf: string;
      /** Les quatre bandes : le nom, puis la phrase. */
      band: Record<
        "solide" | "en-route" | "consolider" | "reprendre",
        { name: string; line: string }
      >;
      /** R-10 : répondu trop vite. */
      tooFast: string;
      /** « Mieux que {pct} % des élèves ». */
      percentile: string;
      /** Sous le seuil : « le rang s'affiche à partir de {n} participants ». */
      percentilePending: string;
      /** Ce qui tient / à revoir. */
      heldTitle: string;
      reviewTitle: string;
      held: string;
      toReview: string;
      /** Rien à revoir. */
      allHeld: string;
      /** Par où commencer — `{chapter}`. */
      startWithTitle: string;
      startWithLesson: string;
      startWithSubject: string;
      /** La correction. */
      correctionTitle: string;
      yourAnswer: string;
      noAnswer: string;
      correctAnswer: string;
      explanationLabel: string;
      misconceptionLabel: string;
      /** D-5 : ce que le compte ouvre, annoncé. */
      lockedTitle: string;
      lockedBody: string;
      lockedCta: string;
      /** Le parent : sa suite. */
      parentTitle: string;
      parentBody: string;
      parentTracking: string;
      parentCreate: string;
      /** Partage. */
      shareTitle: string;
      shareBody: string;
      share: string;
      copy: string;
      copied: string;
      /** Le texte partagé — `{score}`, `{subject}`, `{grade}`, `{url}`. */
      shareText: string;
      /** Idem, sans le chiffre (sous le plancher) — `{subject}`, `{grade}`, `{url}`. */
      shareTextNoScore: string;
      /** « Mieux que {pct} % des élèves » dans le texte partagé. */
      sharePercentile: string;
      retake: string;
      otherSubject: string;
      /** Le connecté : voir dans le Hall. */
      seeInHall: string;
      /** Chargement / erreur du bilan. */
      loading: string;
      loadFailed: string;
      notFound: string;
    };
    hall: {
      title: string;
      /** Aucun bilan encore : l'invitation. */
      emptyBody: string;
      emptyCta: string;
      /** `{score}` sur 20 · `{band}`. */
      scoreLine: string;
      toReviewLine: string;
      allHeld: string;
      retake: string;
      open: string;
      /** La fin de l'accueil : « ou commence par ton test ». */
      onboardingCta: string;
    };
  };
};

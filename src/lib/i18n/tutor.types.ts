/**
 * Tuteur « El Ostedh » (étude 11 lot 1) — clés de microcopy, dans leur propre
 * fichier pour la même raison que `duel.types.ts` : garder `types.ts` sous le
 * plafond de lignes. Référencé là-bas comme `tutor: TutorTranslations`.
 *
 * ⚠️ R-4 : cette microcopy suit le ton élève UNIQUE de l'étude 15 (tutoiement,
 * dès 8 ans) et la langue de l'INTERFACE. Le contenu pédagogique généré, lui,
 * est calibré par bande d'âge et rendu dans la langue de la MATIÈRE. Les deux
 * ne se confondent pas — c'est la règle « chrome-UI vs langue-contenu ».
 */
export interface TutorTranslations {
  /** Le bouton, sur une question ratée de l'écran de correction. */
  ask: string;
  panelTitle: string;
  thinking: string;
  /** « Explique autrement » — le registre suivant (R-7). */
  again: string;
  /** Quand les trois registres sont épuisés. */
  againExhausted: string;
  gotIt: string;
  helpful: string;
  notHelpful: string;
  rated: string;
  close: string;
  /** Servi depuis le pot commun : aucune énergie dépensée (R-15.2). */
  fromCache: string;
  /**
   * Les états dégradés (R-15). Jamais une erreur brute : un enfant lit
   * « El Ostedh revient demain », pas un code fournisseur.
   */
  offTitle: string;
  offBody: string;
  noEnergyTitle: string;
  noEnergyBody: string;
  pausedTitle: string;
  pausedBody: string;
  /** R-1 — les refus de la porte, dits en langage d'élève. */
  lockedSession: string;
  lockedDungeon: string;
  lockedDuel: string;
  lockedNotAttempted: string;

  /**
   * LA BIBLIOTHÈQUE DE COACHING (lot 2, US-5 / US-15) — R-10.
   *
   * Ces phrases ne sont PAS générées, et c'est une décision d'architecture, pas
   * une économie : « les phrases de coach quotidiennes viennent de la
   * bibliothèque ; seule la rédaction des bilans hebdo est générée ». Un élève
   * qui ouvre son tableau de bord chaque matin déclencherait sinon un appel de
   * modèle par jour et par item — pour dire « cinq minutes et c'est réglé ».
   *
   * Deux variantes par registre : trois items d'affilée ne disent pas la même
   * chose, et le choix tourne sur la POSITION (jamais sur un hasard, qui
   * changerait à chaque re-rendu).
   */
  coach: {
    /** Le nom qui signe la phrase, dans la langue de l'interface. */
    signature: string;
    /** Une misconception active vit dans ce chapitre : c'est ÇA qu'il faut dire. */
    weak1: string;
    weak2: string;
    /** Sept jours de retard ou plus : ce n'est plus « à revoir », ça part. */
    late1: string;
    late2: string;
    due1: string;
    due2: string;
    today1: string;
    today2: string;
    /** US-15 — les moments clés. Jamais culpabilisants (étude 15). */
    comeback1: string;
    comeback2: string;
    streak1: string;
    streak2: string;
    clear1: string;
    clear2: string;
    steady1: string;
    steady2: string;
  };

  /** US-7 — le rappel du plan du jour, armé par l'élève. */
  planPushTitle: string;
  planPushDesc: string;

  /**
   * LE CHAT CADRÉ (lot 3, US-8 à US-10).
   *
   * ⚠️ Ce sont des libellés d'INTERFACE, dans la langue de l'interface. Les
   * réponses du tuteur, elles, arrivent dans la langue de la MATIÈRE (R-3) et
   * ne passent jamais par ce catalogue — y compris la réponse fixe de la
   * catégorie bien-être, qui vit côté serveur pour cette raison exacte.
   */
  chat: {
    open: string;
    title: string;
    /** Les intentions fermées — le chemin principal, et le seul en primaire (Q-6). */
    intentExplain: string;
    intentExample: string;
    intentSummarize: string;
    /** Le champ libre, à partir du collège. */
    placeholder: string;
    send: string;
    /** Les refus de bornage (R-5), dits sans jargon. */
    tooLong: string;
    noLinks: string;
    rateLimited: string;
    /** Le fil vide, avant la première question. */
    empty: string;
    you: string;
    historyTitle: string;
    historyEmpty: string;
    /** La sortie a été rejetée par le validateur en cours de flux (§3.4). */
    outputRejected: string;
  };

  /**
   * LE MINI-CHECK (lot 4, US-4) — « Vérifions ensemble ».
   *
   * Une question du stock, servie APRÈS une explication, sur la même erreur.
   * Le ton de la réussite est SOBRE et celui de l'échec n'est jamais un reproche
   * (étude 15) : le mini-check ne rapporte rien (R-11), il ne peut donc pas non
   * plus « coûter » quelque chose. Un enfant qui se sent noté au mini-check
   * cessera d'y répondre honnêtement, et le signal R-8 se tarira avec lui.
   */
  miniCheck: {
    title: string;
    /** Le bouton qui demande la question de vérification. */
    start: string;
    /** L'attente pendant la sélection. */
    loading: string;
    /** Valider son choix. */
    submit: string;
    correctTitle: string;
    correctBody: string;
    wrongTitle: string;
    wrongBody: string;
    /**
     * Aucune question du stock ne convient (`NO_CANDIDATE`). Dit sans excuse
     * technique : l'élève n'a pas à savoir qu'un vivier était vide.
     */
    unavailable: string;
  };

  /**
   * L'ESCALADE (lot 4, R-8) — ce qu'El Ostedh propose quand ça ne passe pas.
   *
   * Une clé par marche, dans l'ordre de `escalation.ts`. Ce sont des PROPOSITIONS
   * à l'élève, jamais des constats sur lui : « on va regarder le cours » et non
   * « tu n'as pas compris ». La dernière marche est la seule qui mentionne le
   * parent, et elle l'annonce à l'élève — on ne rapporte pas dans son dos (Q-5).
   */
  escalation: {
    reteach: string;
    lesson: string;
    prerequisite: string;
    plan: string;
    parentDigest: string;
    /** Le bouton qui suit la proposition. */
    cta: string;
  };

  /**
   * L'ENTRAÎNEMENT CIBLÉ (lot 5, US-11 / US-12) — « Entraîne-moi là-dessus ».
   *
   * ⚠️ CES PHRASES NE DOIVENT JAMAIS PROMETTRE PLUS QUE CE QUI EST SERVI.
   * La sélection distingue deux qualités de matériel : les questions qui
   * portent VRAIMENT l'erreur, et le repli (même chapitre, difficulté voisine).
   * `onTargetHint` annonce les premières, `offTargetHint` avoue les secondes.
   * Les confondre — une seule phrase « sur ton erreur » pour les deux cas —
   * serait le genre de petit mensonge qu'un enfant repère au premier énoncé, et
   * qui lui apprend à ne plus croire l'écran.
   *
   * Le mot « Forge » n'apparaît dans AUCUNE de ces clés : l'élève ne pilote pas
   * une usine, on lui écrit des questions. Le nom du sous-système est une
   * affaire d'ingénierie (étude 15 — le ton élève ne nomme pas la plomberie).
   */
  practice: {
    /** Le geste, sur une ligne de « Tes points faibles ». */
    cta: string;
    /** L'attente pendant la sélection. */
    loading: string;
    /** Le stock couvre l'erreur : on joue des questions du catalogue. */
    onTargetHint: string;
    /** Rien d'assez ciblé : on joue du proche, et on le DIT. */
    offTargetHint: string;
    /** Le stock ne suffit pas et on part en écrire — le renvoi vers la Forge. */
    forgingHint: string;
    /**
     * On ne sait pas dans quel chapitre vit cette erreur : ni stock à cibler,
     * ni cible à écrire. `chapter_id` est nullable dans `get_my_weaknesses` —
     * c'est un cas réel, pas un cas limite.
     */
    noChapter: string;
    /** On sait où, mais il n'y a rien à jouer et rien ne peut être écrit. */
    noMaterial: string;
  };

  /**
   * LE BILAN DE LA SEMAINE (lot 6, US-13 / US-14) — R-10, Q-5.
   *
   * ⚠️ IL N'Y A PAS DE CLÉ « SEMAINE VIDE », ET C'EST VOULU.
   * `TutorDigestView` ne rend que quatre états : un bilan, `not-yet`,
   * `not-linked`, `unavailable`. Une semaine sans mission ne produit AUCUNE
   * ligne (le batch s'arrête sur `hasActivity` avant de dépenser), elle arrive
   * donc à l'écran comme `not-yet` — la même phrase, et la bonne : « le bilan
   * arrive dimanche » est vrai dans les deux cas. Écrire une phrase pour un
   * état que la couche serveur ne sait pas produire, c'est de la microcopy
   * morte qu'un traducteur entretiendra sans jamais la voir.
   *
   * ⚠️ LE CORPS DU BILAN N'EST PAS ICI. Il est GÉNÉRÉ, dans la langue de la
   * matière dominante de la semaine (R-3), et il peut donc être arabe sur une
   * interface française. Ces clés-ci sont le CADRE — titre, semaine, états
   * dégradés — et suivent la langue de l'INTERFACE. C'est la règle
   * « chrome-UI vs langue-contenu » du haut de ce fichier, et c'est ici qu'elle
   * se voit le mieux.
   */
  digest: {
    /** Le titre côté élève — tutoyé, c'est SON bilan. */
    title: string;
    /** Le titre côté parent — vouvoyé, et sobre : ce n'est pas un bulletin. */
    parentTitle: string;
    /** « Semaine du {date} » — la fenêtre, toujours nommée. */
    weekLabel: string;
    /**
     * Pas encore écrit. Cas NOMINAL du lundi au samedi, et de tout compte neuf :
     * le batch écrit le dimanche. Ce n'est donc jamais une panne, et la phrase
     * ne doit pas s'en excuser.
     */
    notYet: string;
    parentNotYet: string;
    /**
     * On n'a pas su lire (R-15). Distinct de `notYet` : il y a peut-être un
     * bilan, on n'y accède pas. La phrase élève rassure sur ce qui compte —
     * les progrès sont enregistrés, c'est le RÉCIT qui manque.
     */
    unavailable: string;
    /**
     * Le lien parent est coupé ou inactif. SÉPARÉ de `parentNotYet`, parce que
     * les deux demandent des gestes opposés : rétablir le lien, ou attendre
     * dimanche. Les confondre ferait attendre indéfiniment un parent qui n'a
     * qu'un code à ressaisir.
     */
    notLinked: string;
  };

  /**
   * LE COMPTEUR D'ÉNERGIE (lot 7) — R-12, D-14, R-11.
   *
   * ⚠️ D-14 EST UNE CONTRAINTE DE RÉDACTION, PAS SEULEMENT DE VOCABULAIRE.
   * Les mots « premium », « abonnement » et « payant » sont bannis de toute
   * surface élève — mais la règle va plus loin : AUCUNE de ces phrases ne peut
   * laisser entendre qu'on obtiendrait de l'énergie autrement qu'en JOUANT.
   * `noItem` doit donc nommer le seul chemin qui existe (« tu en gagnes en
   * jouant des quêtes »), sans quoi un enfant qui n'a pas de tilmih conclura
   * qu'il en manque une qu'on lui vend ailleurs.
   *
   * ⚠️ `{n}` PORTE DEUX SENS SELON LA CLÉ, et les traductions doivent le savoir :
   * dans `rechargeCta` / `recharged` / `rechargedWithItem` c'est le GAIN d'un
   * échange (`TUTOR_ENERGY_PER_HINT`) ; dans `bonus` c'est le CUMUL regagné
   * aujourd'hui. Une tournure qui marche pour l'un peut mentir pour l'autre.
   *
   * L'état « vide » réutilise `noEnergyTitle` / `noEnergyBody` du lot 1 — les
   * mêmes mots que le refus `AI_NO_ENERGY` servi par `degradedCopy`. Deux
   * jumelles finiraient par diverger, et l'élève lirait deux vérités du même
   * fait selon l'écran où il se trouve.
   */
  energy: {
    title: string;
    hint: string;
    /** Ce que les indices échangés ont déjà rendu AUJOURD'HUI. */
    bonus: string;
    rechargeCta: string;
    rechargeBusy: string;
    recharged: string;
    /** L'objet a été nommé par la RPC : on le cite, il a été consommé. */
    rechargedWithItem: string;
    /** Refus au plafond du jour — et l'indice n'a PAS été pris. Il faut le dire. */
    atCap: string;
    /** Aucune charge à échanger. Le seul autre chemin est le jeu (D-14). */
    noItem: string;
    /** Panne (R-15). Jamais un code fournisseur, jamais un reproche. */
    failed: string;
  };

  /**
   * LES DEUX MESURES DU CACHE ET DU REBUT (lot 7) — surface ADMIN.
   *
   * Elle vit sous `tutor` parce que le composant vit dans `features/tutor` et
   * que la RPC est celle du tuteur ; le lecteur, lui, est un administrateur.
   * C'est le seul bloc de ce fichier qui ne s'adresse pas à un enfant.
   *
   * ⚠️ `window` DOIT NOMMER LA NATURE DE LA FENÊTRE, pas seulement sa durée.
   * `get_tutor_cache_stats` mesure une COHORTE — les explications *créées*
   * dans la fenêtre — parce que `serve_count` est cumulatif et non daté. Écrire
   * « sur 30 jours » laisserait croire à une fenêtre glissante sur les
   * SERVICES, et ferait lire le chiffre comme une réfutation quand il
   * sous-estime par construction.
   */
  cacheStats: {
    title: string;
    hitTitle: string;
    /** « {hits} resservies · {misses} écrites ». */
    hitDetail: string;
    /**
     * é29 R-15.3 — la SORTIE du pot commun : deux voix distinctes en 👎 retirent
     * une explication du service. Se lit toujours à côté du hit-rate, jamais
     * seul : un pot qui se remplit vite et se vide autant dit que la condition
     * d'entrée ne suffit plus.
     */
    evictTitle: string;
    /** « {evicted} évincées · {shared} entrées au pot ». */
    evictDetail: string;
    discardTitle: string;
    /** « {discarded} rejetées · {kept} gardées ». */
    discardDetail: string;
    /** La fenêtre ET sa nature de cohorte — voir l'avertissement ci-dessus. */
    window: string;
    /** Repli si le SQL rebascule un jour sur le cumul à vie (`lifetimeHitRate`). */
    lifetime: string;
    unavailable: string;
  };
}

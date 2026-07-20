# Étude 19 — Questions & exercices illustrés : doctrine visuelle & campagne

> **Statut** : validée — Q-1…Q-4 arbitrées le 2026-07-20 par Mohamed (§7) : trois tranchées sur
> les recommandations, Q-4 déléguée au démarrage du lot 3 ; le lot 1 est immédiatement exécutable
> **Priorité** : 19 · **Valeur** : une question de géométrie sans figure est aussi bancale qu'un cours de géométrie sans figure — l'étude 18 a réglé les cours, celle-ci règle les 18 708 questions · **Complexité** : moyenne (le rendu existe déjà) — mais **campagne longue**
> **Architecte** : Opus 4.8 / 2026-07-14 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : é18 (cours vivants, livrée — doctrine d'illustration + axe 5 + `course-figures.md`) · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/xss-rendering-policy.md`,
> `content-engine/references/{quality-bar,course-figures,math-and-notation,content-schema,interactive-formats}.md`

---

## 1. Contexte & objectif produit

### Le problème

L'étude 18 a illustré les **cours** : elle a ajouté un axe « Illustration » à la barre qualité des
leçons, ouvert le gate `content:qa` aux `cours.md`/`resume.md`, et lancé une campagne (maths 9ᵉ,
1ère sec, 6ᵉ — 83 figures). Mais **les questions et les exercices sont restés à l'écart**. Or le
reproche d'origine — « un cours de géométrie sans illustration n'a aucun sens » — vaut **mot pour
mot** pour une question : « Quelle est l'aire de ce triangle rectangle de côtés 3 et 4 ? » sans
figure demande à l'élève de construire le triangle dans sa tête avant même de commencer à calculer.

### L'état réel, mesuré sur le dépôt (2026-07-14)

| mesure                                | valeur          |
| ------------------------------------- | --------------- |
| questions (quiz + exercices) au total | **18 708**      |
| questions portant au moins un `<svg>` | **780** (4,2 %) |
| fichiers quiz/exercices scannés       | 3 204           |

Les 780 figures existantes se concentrent **exactement là où celles des cours se concentraient** :
`arabic-1ere` (formes de lettres, 47 fichiers), les maths du **primaire** (`math-4eme` 40,
`math-6eme` 36, `math-5eme` 21, `math-3eme` 17), l'`eveil-scientifique` (schémas, 34+30+25+…), et
`iq-training` (visuel par nature, 60). Le contenu **académique des années hautes** (collège, lycée,
années de concours en matières abstraites) est quasiment vide de figures.

### Ce qui existe DÉJÀ (et qui rend cette étude plus petite que l'étude 18)

Contrairement aux cours, **le moteur de rendu des figures de question est complet et livré** :

1. **`SvgFigure`** (`src/components/ui/svg-figure.tsx`) dessine toute figure de question sur une
   planche « papier » claire, dimensionnée par `viewBox`, assainie par `sanitizeSvg` (profil SVG
   DOMPurify). Une question porte une figure dans son `prompt`, dans le `text` d'une option, ou dans
   son `explanation` — le contrat est spécifié dans `content-schema.md` § « Figures (inline SVG) in
   questions ». **Rien à construire côté rendu.**
2. **Le gate inspecte déjà les figures de question** : `auditRenderedFields` (dans
   `scripts/content/qa-checks.ts`) vérifie `viewBox`, la fragilité bidi (radical arabe), la virgule
   arabe dans une notation — sur `prompt`, options et `explanation`, pour **tous** les types de
   questions (QCM, numeric, board). La **notation** des figures de question est donc déjà tenue.
3. **Le gate attrape déjà la référence EXPLICITE à une figure absente** : `FIGURE_REFERENCE`
   (« ci-dessous », « الشكل المجاور »…) sur un `prompt` sans `<svg>` → `[error]` « figure-dependent
   prompt with no figure shipped → unanswerable ». C'est le contrôle le plus dur, et il tourne déjà.
4. **Des skills authorent déjà des questions visuelles** : `content-iq-training` (matrices, séquences
   de formes en SVG), `content-interactif` (format « QCM visuel SVG », `interactive-formats.md`), et
   les figures d'énoncé de géométrie primaire.

### Les DEUX trous, précisément

Ce qui manque n'est ni le rendu ni la notation, mais **la doctrine et sa détection** :

- **Trou A — la barre qualité des questions est muette sur les figures.**
  `content-engine/references/quality-bar.md` — la barre des **questions** (l'équivalent de
  `course-quality.md` pour les leçons) — ne dit **rien** de « une question à énoncé spatial testée
  sans figure est une non-conformité ». Le mot « figure » n'y apparaît qu'en passant (l'enrichissement
  « le savais-tu ? »). Aucun skill d'écriture n'a donc reçu la consigne d'illustrer une question de
  géométrie, de lecture de graphique, de schéma scientifique.

- **Trou B — le gate ne détecte que la référence EXPLICITE, pas le manque IMPLICITE.**
  Le gate signale « le prompt dit _ci-dessous_ mais il n'y a pas de figure ». Il **ne signale pas**
  « cette question porte sur l'aire d'un triangle / la lecture d'un angle / un circuit électrique, et
  gagnerait décisivement une figure » quand le texte ne contient pas de déictique. C'est l'analogue
  exact du « chapitre spatial sans figure » de l'étude 18 (axe 5) — mais **bien plus difficile** :

  > **La difficulté centrale de cette étude.** Pour les cours, « spatial » était un **regex sur le
  > slug** de 541 chapitres (`isSpatialChapter`). Pour les questions, « spatial » est une propriété
  > **par question** sur **18 708** items : dans le même chapitre « fractions », « calcule l'aire de
  > ce rectangle » veut une figure et « calcule 3/4 + 1/2 » n'en veut pas. La détection ne peut donc
  > **pas** être déterministe ; ce sera une **heuristique de haute précision** (mots-clés de forme +
  > absence de figure) qui **acceptera de manquer des cas** — et devra **journaliser** ce qu'elle ne
  > peut pas voir, jamais faire croire à une couverture totale.

### Résultat attendu

1. La barre qualité des questions gagne une exigence visuelle explicite (l'analogue de l'axe 5) :
   une question à énoncé **spatial/visuel** est illustrée, et sa figure est **vraie**.
2. Le gate `content:qa` remonte en `[warn]` les questions **candidates** à une figure manquante
   (heuristique haute précision), et ce signalement devient le **backlog** de la campagne — comme
   l'axe 5 a produit celui des cours.
3. Les skills d'écriture (`content-interactif`, `content-iq-training`, `content-ecole-tn`, les
   `prof-*`) reçoivent la consigne d'illustrer les items spatiaux, adossée à `course-figures.md`
   (les gabarits SVG y sont déjà — triangle, cercle, repère, solides — et servent aux deux).
4. Campagne d'illustration des questions, **année de concours et matières spatiales d'abord**, lot
   par lot, chaque lot **borné** pour que ses figures soient vérifiables **à l'œil**.

### Indicateurs de succès

| KPI                                                                        | avant   | cible                                 |
| -------------------------------------------------------------------------- | ------- | ------------------------------------- |
| Barre qualité des **questions** couvrant l'illustration                    | non     | **oui** (règle normative)             |
| Gate signalant les questions candidates à une figure manquante             | non     | **oui** (`[warn]`, haute précision)   |
| Questions à énoncé spatial illustrées, sur le périmètre de campagne traité | — %     | **≥ 90 %** du périmètre de chaque lot |
| Figures de question **fausses** livrées (contredisent leur énoncé)         | inconnu | **0** (double-résolution + œil)       |

### Ce que l'epic ne cherche PAS à faire

- **Pas de refonte du rendu.** `SvgFigure` reste tel quel — aucune touche au composant, au
  sanitizer, ni au contrat `content-schema.md` (voir D-1).
- **Pas de photo/bitmap.** SVG inline uniquement, comme l'étude 18 (D-8 de é18). Même raison :
  versionné, thémable, net, imprimable, zéro stockage, zéro droits.
- **Pas d'illustration « décorative ».** Une figure n'est ajoutée que si elle **sert la résolution**
  (l'énoncé est spatial/visuel). Un QCM d'arithmétique pure ne reçoit pas de dessin « pour faire
  joli » — ce serait du bruit cognitif (R-2).
- **Pas de campagne exhaustive en une passe.** 18 708 questions ne s'illustrent ni ne se vérifient
  en un lot. La campagne est **longue, bornée, priorisée** — et l'étude l'assume (RISK-1).
- **Pas de nouvelle base de données.** Aucune migration de schéma ; seulement les migrations de
  **contenu** que la campagne régénère par matière (DoD §7).

---

## 2. Spécification fonctionnelle

### Acteurs & parcours

Les questions sont jouées par l'élève (quiz de compréhension, missions, donjon, duel) **et**
consultables en aperçu public (practice anonyme). Une figure d'énoncé profite à tous ces surfaces
d'un coup, puisqu'elle vit dans le champ de la question, rendu partout par `SvgFigure`.

- **US-1** — En tant qu'élève, quand une question porte sur une forme (aire, angle, triangle,
  solide, repère, graphique, circuit, schéma), **je vois la figure** au lieu de devoir l'imaginer.
- **US-2** — En tant qu'élève, la figure de l'énoncé est **exacte** : les longueurs, angles et
  positions qu'elle montre sont ceux que la question utilise (une figure fausse fait rater une
  question juste).
- **US-3** — En tant qu'auteur (skill), je sais **quand** une question doit être illustrée et
  **comment** (gabarits SVG partagés avec les cours), et le gate me **signale** les questions
  spatiales que j'ai laissées sans figure.
- **US-4** — En tant qu'auditeur (`content-audit`), j'évalue la présence **et la justesse** des
  figures d'énoncé au même titre que la clé de réponse.

### Règles métier

- **R-1 — Une question à énoncé SPATIAL/VISUEL est illustrée.** Familles (identiques à
  `course-figures.md`, plus les familles propres aux questions) : géométrie plane, cercle & angles,
  repère & vecteurs, solides, trigonométrie, mesure de formes (aire/périmètre/volume **d'une figure
  donnée**), lecture de graphique/diagramme, schéma scientifique (SVT/physique), frise, **lecture de
  document visuel**. Une règle sur une forme _testée_ sans la montrer est une non-conformité.

- **R-2 — Une figure ne s'ajoute QUE si elle sert la résolution.** Contre-exemple normatif :
  « calcule 3/4 + 1/2 » ne reçoit **pas** de figure ; « quelle fraction de ce disque est colorée ? »
  en reçoit une. L'illustration décorative est un défaut, pas une qualité (bruit cognitif). Ce point
  distingue cette étude de « tout illustrer ».

- **R-3 — La figure doit être VRAIE.** La règle cardinale de l'étude 18 s'applique intégralement :
  points annoncés sur un segment réellement dessus, parallèles réellement parallèles, angle droit à
  90°, longueurs cohérentes avec l'énoncé. **Une figure qui contredit son énoncé fait rater une
  question juste** — c'est pire que pas de figure. Vérification par **double-résolution** (résoudre
  la question _sur la figure_) et **contrôle visuel** (R-9 de la stratégie de test).

- **R-4 — La clé de réponse ne fuit jamais par la figure.** Invariant de sécurité du contenu : une
  figure d'énoncé ne doit pas trahir la bonne option (ex. cocher visuellement la réponse). Une figure
  peut légitimement vivre **dans une option** (QCM visuel : « quelle pièce complète la suite ? ») —
  auquel cas les quatre options portent une figure comparable, aucune marquée.

- **R-5 — Notation standard dans la figure** (déjà tenue par le gate, rappelée ici) : chiffres
  occidentaux, unités SI, équations LTR ; **le nommage des sommets suit le cycle** — lettres arabes
  au primaire (أ، ب، ج، م، ر، ق), latines dès le collège (`course-figures.md`, corrigé le 2026-07-14
  en illustrant maths 6ᵉ). Jamais de prose (arabe ou autre) dans le dessin.

- **R-6 — Le gate signale les CANDIDATES, il ne bloque pas.** La détection d'une figure manquante est
  une **heuristique haute précision** → sévérité `[warn]`, jamais `[error]` (contrairement à la
  référence explicite déjà en `[error]`). Un `[warn]` est un candidat à revoir par un humain/skill,
  pas un couperet — parce qu'il y aura des faux positifs (une question qui _mentionne_ un triangle
  sans en avoir besoin) et des faux négatifs (un énoncé spatial sans mot-clé).

- **R-7 — Aucune couverture silencieuse.** Le gate et chaque lot **journalisent** ce qu'ils ne
  couvrent pas : nombre de candidats signalés, nombre traités, et la mention explicite que
  l'heuristique **manque des cas** (elle n'est pas exhaustive). Interdit de laisser croire « toutes
  les questions spatiales sont illustrées » quand seule une partie l'est.

### i18n / RTL

Aucune chaîne d'UI nouvelle (le rendu existe). Les **libellés dans les figures** suivent la langue du
contenu et le cycle (R-5). Les figures restent LTR isolées dans un énoncé RTL — comportement déjà en
place (`SvgFigure` + `bidi.ts`).

### Hors périmètre (v1)

- Le rendu, le sanitizer, le contrat de schéma : inchangés (D-1).
- Photo/bitmap (SVG seul).
- Illustration décorative (R-2).
- Détection déterministe exhaustive : impossible (voir §1, RISK-1) — l'heuristique est assumée
  partielle.
- Génération **automatique** de figures par script : hors sujet — une figure doit être authorée et
  **vérifiée** (R-3), pas produite en masse par gabarit aveugle (une figure fausse est pire que rien).

---

## 3. Architecture technique (décisions fermées)

### Modèle de données & serveur

**Aucun changement.** Ni table, ni colonne, ni RPC, ni server fn, ni composant. Une figure d'énoncé
est du `<svg>` dans une chaîne de contenu déjà rendue par `SvgFigure`. Le DoD §7 ne s'applique
qu'aux **migrations de contenu** que la campagne régénère par matière (`content:build --subject`).

### Gate — `scripts/content/qa-checks.ts`

Ajout d'un contrôle `auditVisualQuestion(q, where)` appelé depuis `qa.ts` pour **chaque** question,
en complément des audits existants (jamais à leur place) :

- **Détecte** : le `prompt` (ou une option) contient un **marqueur de notion spatiale/visuelle**
  (`VISUAL_QUESTION` — un lexique fr/en/ar : aire, périmètre, volume, triangle, cercle, angle,
  droite, parallèle, perpendiculaire, repère, coordonnées, vecteur, graphique, diagramme, schéma,
  figure, solide, cube, prisme, مساحة، محيط، مثلّث، دائرة، زاوية، مبيان، رسم…) **et** la question ne
  porte **aucun** `<svg>` (ni prompt, ni option, ni explanation).
- **Émet** : `[warn]` « visual question likely missing a figure — the statement is about a shape/
  graph/diagram but ships no `<svg>` (quality-bar, visual rule) ». **Jamais `[error]`** (R-6).
- **Haute précision d'abord** : le lexique est **étroit et sûr** (un mot ambigu comme « figure de
  style » ou « angle mort » en français hors maths est exclu par contexte). Mieux vaut manquer un cas
  que noyer l'auteur de faux positifs — l'exhaustivité n'est pas le but, la précision l'est (R-6/R-7).
- **Compte et journalise** (R-7) : `qa.ts` affiche en fin de run « N questions candidates à une
  figure (heuristique — non exhaustif) ».

Le contrôle **explicite** existant (`FIGURE_REFERENCE` + pas de `<svg>` → `[error]`) est **conservé
tel quel** : il attrape le cas certain (« ci-dessous » sans figure), l'heuristique attrape le cas
probable (énoncé spatial sans déictique).

### Doctrine — skills & barre qualité

- **`content-engine/references/quality-bar.md`** gagne une section **« Visual — illustrate what the
  question is about »** (l'analogue de l'axe 5 de `course-quality.md`), qui renvoie à
  `course-figures.md` pour les familles, les gabarits SVG et les règles de dessin (déjà écrits pour
  l'étude 18 — **ré-utilisés, pas dupliqués**). Sévérités pour `content-audit` : question spatiale
  sans figure = `[MAJOR]` ; **figure qui contredit l'énoncé = `[BLOCKER]`** ; figure sans utilité
  (décorative) ou clé qui fuit = `[MINOR]`/`[MAJOR]` selon le cas.
- **`content-engine/references/course-figures.md`** : son titre et son intro sont élargis de
  « course figures » à « **content figures** (courses AND questions) » — le corps (familles,
  gabarits, règle « la figure doit être vraie », nommage par cycle) vaut déjà pour les deux.
- **`content-interactif`** : l'étape « illustrer » devient explicite pour le format « QCM visuel SVG »
  et « lecture de document » (elle l'est déjà en partie).
- **`content-iq-training`** : déjà centré figures — un simple renvoi à `course-figures.md` pour la
  cohérence de palette/dessin.
- **`content-ecole-tn`** et les **`prof-*`** (surtout maths/physique/SVT × niveaux) : gagnent la
  consigne « une question spatiale s'illustre » adossée à `course-figures.md`.
- **`content-audit`** : audite la présence **et la justesse** des figures d'énoncé (double-résolution).

### Sécurité

Inchangée. `SvgFigure`/`sanitizeSvg` non touchés (D-1). Invariant neuf **de contenu** : la clé ne
fuit pas par la figure (R-4) — vérifié par `content-audit`, pas par un gate déterministe.

### Décisions d'architecture (ADR)

- **D-1 — Zéro touche au rendu.** `SvgFigure`, `sanitizeSvg`, `content-schema.md` § Figures restent
  intacts : ils sont livrés, vettés, et suffisent. Cette étude est **doctrine + détection + contenu**,
  pas ingénierie de rendu. C'est ce qui la distingue de l'étude 18 (qui a dû refaire le renderer).
- **D-2 — La détection est une heuristique, pas un oracle.** Impossible de décider par règle
  déterministe si une question de 18 708 « devrait » avoir une figure. On choisit la **haute
  précision** (`[warn]`, lexique étroit) plutôt que le rappel exhaustif — et on **journalise le
  manque** (R-7). _Alternative rejetée_ : un classifieur exhaustif (fragile, faux positifs en masse,
  faux sentiment de complétude).
- **D-3 — La figure doit être vraie, donc la campagne ne s'automatise pas.** On ne génère pas 18 000
  figures par gabarit : chaque figure est authorée **contre son énoncé** et **vérifiée** (double-
  résolution + œil, R-3/R-9). C'est ce qui borne le débit et fait de la campagne un effort **long**,
  lot par lot — assumé, pas caché.
- **D-4 — On réutilise l'appareil de l'étude 18.** `course-figures.md` (gabarits, familles, « figure
  vraie », nommage par cycle) devient la référence **commune** cours+questions. Pas de doctrine
  parallèle à maintenir.
- **D-5 — SVG seul** (hérité de é18 D-8) et **illustration utile seulement** (R-2) : deux garde-fous
  contre le bruit.

---

## 4. Plan d'exécution en lots

| lot    | contenu (résumé)                                                                   | fichiers / objets                                                                                                                                                                                                           | tests exigés                                | dépend de |
| ------ | ---------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | --------- |
| **1**  | Doctrine + gate (détection des candidates) — **0 fichier de contenu**              | `quality-bar.md`, `course-figures.md` (titre élargi), `content-interactif`/`content-iq-training`/`content-ecole-tn`/`content-audit` SKILL, `scripts/content/qa-checks.ts` (+`auditVisualQuestion`), `scripts/content/qa.ts` | `qa-checks.test.ts` étendu (précision !)    | é18       |
| **2**  | Pilote : illustrer les questions spatiales d'**une** matière d'année de concours   | `content/math-9eme/**` (ou `math/`) exercices+quiz, migration `content:build --subject`                                                                                                                                     | `content:check` + `content:qa:strict` + œil | 1         |
| **3+** | Campagne, **une matière × niveau par lot**, priorité concours → matières spatiales | idem, un `--subject` par lot                                                                                                                                                                                                | idem                                        | 1         |

- [ ] **Lot 1 — Doctrine + détection.**
      _Périmètre_ : R-1, R-2, R-5, R-6, R-7. Écrire `auditVisualQuestion` (haute précision), le
      brancher dans `qa.ts` pour toutes les questions, compter+journaliser les candidates. Élargir
      `quality-bar.md` (section visuelle) et le titre de `course-figures.md` ; ajouter la consigne aux
      skills d'écriture et à `content-audit`. **Aucun fichier sous `content/` modifié.**
      _Acceptation_ : US-3, US-4 ; `content:qa:strict` reste **vert** (les nouveaux signaux sont des
      `[warn]`, pas des `[error]`) ; le run affiche le compte de candidates. Le test de
      `auditVisualQuestion` doit prouver la **précision** (un QCM d'arithmétique pure, une « figure de
      style » en français, un « angle mort » ne déclenchent PAS ; une question d'aire de triangle sans
      `<svg>` déclenche).
      _Stop-point_ : **ne toucher à aucune question**. Ne pas passer le `[warn]` en `[error]`.

- [ ] **Lot 2 — Pilote (une matière de concours).**
      _Périmètre_ : illustrer les questions spatiales signalées d'**une seule** matière (recommandé :
      maths 9ᵉ — année de concours, déjà auditée pour les cours). Chaque figure authorée **contre son
      énoncé**, double-résolue, **regardée** (rendu Chromium). Régénérer la migration
      (`content:build --subject`).
      _Acceptation_ : US-1, US-2 ; ≥ 90 % des candidates de la matière traitées ; **0 figure fausse** ;
      gates verts ; migration ordonnée (DoD §7). Journaliser : candidates trouvées / traitées /
      laissées (avec raison).
      _Stop-point_ : **une seule matière**. Ne pas enchaîner dans la même PR.

- [ ] **Lot 3+ — Campagne.**
      Une matière × niveau par lot, dans l'ordre §7 (concours d'abord). Chaque lot **borné** (si le
      volume de candidates dépasse une PR raisonnable, scinder par chapitre et le dire). Même DoD que
      le lot 2. La campagne s'arrête quand le backlog `[warn]` des matières prioritaires est résorbé —
      le reste (faux positifs, matières non spatiales) est laissé et **documenté**.

---

## 5. Stratégie de test

- **Unit (lot 1)** — `src/shared/content/__tests__/qa-checks.test.ts` étendu : `auditVisualQuestion`
  déclenche sur des fixtures spatiales sans figure (aire de triangle, lecture de graphique, schéma) ;
  **ne déclenche pas** sur de l'arithmétique pure, une figure de style, un item déjà illustré, un QCM
  visuel dont la figure vit dans les options. La **précision** est l'objet du test, pas le rappel.
- **Gate contenu** — `content:qa:strict` reste vert (les candidates sont `[warn]`). Le lot 1 ne doit
  **jamais** rendre le gate rouge.
- **Campagne (lots 2+)** — `content:check` + `content:qa:strict` verts ; **contrôle visuel obligatoire**
  (rendu des figures du lot dans Chromium, regardées une par une — méthode éprouvée sur les 83 figures
  de cours de l'étude 18) ; **double-résolution** de chaque question illustrée (la figure permet-elle
  de répondre, et donne-t-elle la bonne réponse ?).
- **Non-régression** — le diff du lot 1 ne contient aucun fichier sous `content/` ; les audits de
  question existants (clé, distracteurs, notation) restent verts et inchangés.
- **`smoke:shell`** — non requis (aucun code client touché) sauf si le lot 1 modifie par erreur un
  fichier de `src/` (il ne doit pas).

## 6. Risques & mitigations

- **RISK-1 — Volume ingérable.** 18 708 questions, campagne potentiellement énorme.
  _Mitigation_ : priorité stricte (concours + matières spatiales), lot = 1 matière×niveau borné,
  arrêt quand le backlog prioritaire est résorbé (pas d'objectif « 100 % de 18 708 »). Le débit est
  **volontairement** limité par l'exigence de vérification (D-3).
- **RISK-2 — Figure fausse (fait rater une question juste).** _Prob. moyenne / impact fort._
  _Mitigation_ : R-3 + double-résolution + contrôle visuel obligatoire par lot ; `content-audit`
  note `[BLOCKER]` une figure qui contredit son énoncé ; le balayage `content-audit.yml` repasse.
- **RISK-3 — Heuristique bruyante (faux positifs).** _Prob. forte si le lexique est large._
  _Mitigation_ : lexique **étroit et sûr** (D-2), sévérité `[warn]` seulement (R-6), test de
  précision au lot 1. On préfère manquer que noyer.
- **RISK-4 — Fuite de la clé par la figure.** _Prob. faible / impact fort._
  _Mitigation_ : R-4 ; `content-audit` vérifie qu'une figure d'énoncé ne marque pas la réponse et
  qu'un QCM visuel porte des figures comparables sur les 4 options.
- **RISK-5 — Dérive « tout illustrer ».** _Prob. moyenne._ _Mitigation_ : R-2 (utile seulement) +
  contre-exemple normatif dans la doctrine ; l'audit sanctionne la figure décorative.

## 7. Questions ouvertes (pour l'humain)

> **Section arbitrée le 2026-07-20 (Mohamed) — les trois décisions de périmètre ont suivi les
> recommandations.** Q-4 n'est pas laissée ouverte : elle est explicitement **déléguée** à la
> session qui ouvrira le lot 3, dans le cadre fermé par Q-2. L'étude est passée `validée`.

- **Q-1 — Médium & cadrage.** Confirmer que les arbitrages de l'étude 18 se transposent : **SVG
  inline seul** (pas de bitmap) et **étude→lots** (une PR par lot). _Défaut proposé : oui aux deux._
  **Arbitrage : oui aux deux, recommandation retenue** — **SVG inline seul** (aucun bitmap, aucune
  photo) : la D-5 est confirmée comme héritage direct de la D-8 de l'étude 18 ; et cadrage **étude
  → lots, une PR par lot**. Conséquence : le **lot 1** (doctrine + gate, **0 fichier de contenu**)
  est ferme et immédiatement exécutable.
- **Q-2 — Ambition de la campagne.** Jusqu'où va-t-on ? _Recommandation architecte : (a) années de
  concours d'abord (9ᵉ, 6ᵉ, bac quand il existera), (b) puis matières intrinsèquement spatiales
  (maths, physique, SVT) collège→lycée, (c) STOP sur les matières non spatiales._ La cible n'est pas
  « 18 708 » mais « les questions spatiales des parcours prioritaires ».
  **Arbitrage : recommandation retenue** — (a) années de concours d'abord (9ᵉ, 6ᵉ, bac quand il
  existera), (b) puis matières intrinsèquement spatiales (maths, physique, SVT) collège→lycée,
  (c) **STOP** sur les matières non spatiales. La cible n'est **pas** « 18 708 » mais « les
  questions spatiales des parcours prioritaires » : la campagne s'arrête quand le backlog `[warn]`
  des matières prioritaires est résorbé, le reste étant laissé et **documenté** (R-7). Cet
  arbitrage **est** la mitigation de RISK-1.
- **Q-3 — Profondeur de vérification à l'échelle.** Le contrôle visuel + double-résolution de chaque
  figure est incompressible (D-3) et borne le débit. Accepte-t-on ce coût (garant du « 0 figure
  fausse »), ou tolère-t-on un échantillonnage au-delà d'un certain volume par lot ? _Recommandation :
  vérification intégrale tant que les lots restent bornés ; si un lot dépasse ~40 figures, le scinder
  plutôt que d'échantillonner._
  **Arbitrage : recommandation retenue** — **vérification intégrale** (contrôle visuel +
  double-résolution de chaque figure) tant que les lots restent bornés ; **si un lot dépasse ~40
  figures, il est scindé — jamais échantillonné**. Le KPI « 0 figure fausse » est tenu tel quel :
  le débit s'ajuste par la **taille des lots**, pas par la profondeur du contrôle. Cet arbitrage
  fixe le DoD de vérification des lots 2 et 3+.
- **Q-4 — Ordre exact des matières** (dépend de Q-2) : à figer au démarrage du lot 3.
  **Arbitrage : différée par construction**, comme l'étude le prévoit — elle dépend de Q-2
  (désormais tranchée) et se fige **au démarrage du lot 3**. Ce n'est pas une question laissée
  ouverte : c'est une décision d'**exécution déléguée** à la session qui ouvrira le lot 3, dans le
  cadre fixé par Q-2 (concours d'abord). Elle ne bloque **ni le lot 1 ni le lot 2**.

Une étude passe `validée` quand cette section est arbitrée : c'est fait le **2026-07-20**. Les
lots 1 et 2 sont exécutables ; l'ordre des matières du lot 3+ se fige à son démarrage (Q-4).

## 8. Journal d'exécution

| date       | lot | PR  | écarts acceptés / dettes notées                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ---------- | --- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-07-14 | —   | —   | Étude rédigée (Opus 4.8), adossée à l'étude 18 livrée. État mesuré : 780 / 18 708 questions illustrées (4,2 %). Différence clé vs é18 : le rendu existe (SvgFigure), la difficulté est la détection par-question à l'échelle. Q-1…Q-4 ouvertes.                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 2026-07-20 | —   | —   | **Validation — Q-1…Q-4 arbitrées** (Mohamed) → §7, sur les recommandations. Q-1 : SVG inline seul (D-5 = héritage de é18 D-8) + cadrage étude→lots, une PR par lot → le **lot 1 est ferme**. Q-2 : campagne bornée aux parcours prioritaires (concours d'abord, puis matières spatiales, **STOP** ailleurs), cible = « les questions spatiales des parcours prioritaires », pas « 18 708 » — c'est la mitigation de RISK-1. Q-3 : **vérification intégrale**, un lot > ~40 figures est **scindé, jamais échantillonné** — fixe le DoD de vérification des lots 2 et 3+. Q-4 : ordre des matières **délégué** au démarrage du lot 3, dans le cadre fixé par Q-2. Statut `brouillon` → `validée`. Aucun lot commencé. |

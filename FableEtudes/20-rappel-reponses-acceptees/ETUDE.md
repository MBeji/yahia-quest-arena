# Étude 20 — Réponses acceptées : rappel tolérant & questions libres natives (zéro question exclue)

> **Statut** : validée (Q-1…Q-5 arbitrées par Mohamed — Q-1/Q-3 le 2026-07-15, Q-2/Q-4/Q-5 le
> 2026-07-16, toutes sur les recommandations) — prête pour l'exécuteur (lot 1)
> **Priorité** : 20 · **Valeur** : rend les **12 349** missions Rappel (étude 17) réellement
> jouables — une réponse **correcte mais formulée autrement** cesse d'être refusée, **sans retirer
> une seule question** du mode — **et** dote le moteur de son premier type natif de **réponse
> libre** (`short_answer`) : la question **sans réponses proposées** devient authorable, corrigée
> par le même jeu de réponses acceptées · **Complexité** : moyenne+
> **Architecte** : Opus 4.8 / 2026-07-15 · **amendée** Fable 5 / 2026-07-16 (volet B « questions
> libres sans réponses proposées » + renommage `recallAnswers` → `acceptedAnswers`) ·
> **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : étude 17 (Rappel actif — **livrée** : `normalize_recall_text`,
> `is_question_recall_eligible`, `score_recall_answer`, colonnes `variant`, `RecallInput`/
> `RecallCharBar`) · étude 03 (types natifs — **livrée** : la seam `score_answer`,
> `answer_key`/`question_type`, `<QuestionInput>` unifié — le volet B est un type de plus dans ce
> cadre) · s'articule avec l'étude 04-A0 (télémétrie misconceptions), l'étude 12 (studio
> d'ingestion — même posture « génération hors-ligne → fichiers → compilation ») et le canal
> `content_reports` (boucle d'auto-correction) · **Bloque** : —
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/interactive-question-types.md`
> (que le lot 7 amende — sa clôture « no more Tier-B types » est levée par la présente étude),
> `content/README.md`, `content-engine/references/math-and-notation.md`,
> `docs/content-voice-and-composition.md`

## 1. Contexte & objectif produit

### Problème A — le Rappel refuse des réponses justes (constaté en production, 2026-07-15)

Le mode Rappel de l'étude 17 compare la réponse **tapée** à l'unique **texte de la bonne option**
du QCM, après normalisation (`normalize_recall_text`), par **égalité stricte tout-ou-rien** (R-4).
Or une même question a souvent **plusieurs réponses correctes formulées différemment**. Une session
réelle sur la mission « التموقع في الفضاء » (positionnement dans l'espace, 1re année de base —
6 ans) l'a rendu visible :

| #   | Prompt (résumé)                    | Bonne option | Réponse tapée  | Verdict moteur | Réalité pédagogique                                          |
| --- | ---------------------------------- | ------------ | -------------- | -------------- | ------------------------------------------------------------ |
| Q1  | « أين الطائر ؟ » (où est l'oiseau) | فوقها        | فوق الشجرة     | ❌ À revoir    | **juste** — « au-dessus d'elle » = « au-dessus de l'arbre »  |
| Q4  | « أين الكرة ؟ » (où est la balle)  | داخل الصندوق | في جوف الصندوق | ❌ À revoir    | **juste** — synonymes (« dans » / « dans le creux de »)      |
| Q2  | « أيّ حيوان أصغر ؟ »               | النملة       | NAMLA          | ❌ À revoir    | translittération latine — clavier arabe indisponible à 6 ans |
| Q5  | « نأكل ونكتب باليد… »              | اليمنى       | DROITE         | ❌ À revoir    | réponse en français                                          |
| Q6  | « أيّ شيء أقصر ؟ »                 | القلم        | ALKALAM        | ❌ À revoir    | translittération de « al-qalam »                             |

Deux familles de faux négatifs distinctes :

1. **Variabilité de formulation** (Q1, Q4) : la bonne réponse est une **phrase** (prépositionnelle,
   positionnelle, définie) qui admet des paraphrases exactes. La règle d'éligibilité R-2(g) de
   l'étude 17 exclut « lequel/parmi/… » mais **pas** les questions de position (« أين / où /
   where ») ni les réponses multi-mots — elles restent proposées, puis refusent des paraphrases
   justes. **Cause racine : le moteur ne connaît qu'UNE réponse acceptable là où il en existe
   plusieurs.**
2. **Écriture hors-registre** (Q2, Q5, Q6) : l'élève tape une **translittération latine** ou une
   **traduction** de la réponse arabe (à 6 ans, le clavier arabe est hors de portée). La
   normalisation ne translittère pas — refus légitime au sens strict, mais expérience punitive.
   Cas voisin non illustré ici mais mesuré : en arabe, taper le mot **sans l'article défini
   « ال »** (« نملة » au lieu de « النملة ») est aussi refusé — `normalize_recall_text` ne plie pas
   l'article.

**Ce que la mesure exhaustive (§9) tranche** — 18 669 QCM, éligibilité calculée par portage 1:1 de
la règle SQL déployée : **12 349 questions éligibles (66,1 %)**. Surtout, elle **cadre la nature du
problème** : le portail d'éligibilité et `normalize_recall_text` neutralisent **déjà** tout le
typographique (espaces, accents, hamza/ة/ى, tashkeel, ponctuation, chiffres arabes-indics). **Le
faux négatif résiduel est donc exclusivement lexical/morphologique/syntaxique**, et se concentre en
trois gisements : (a) **réponses ≥ 2 mots — 57,8 % des éligibles** (reformulations, synonymes) ;
(b) **article défini** — arabe « ال » sur **21,4 % des éligibles ar (1 833 questions)**, plus son
équivalent français `le/la/l'` et les contractions anglaises `they're`/`can't` ; (c) **positionnels
— 385** (peu nombreux mais quasi tous à risque). Ce cadrage oriente directement la génération (§3) :
le gisement (b) est **mécanique** (déterministe, sans IA) ; les gisements (a)/(c) demandent une passe
sémantique relue.

### Problème B — la question libre sans réponses proposées n'est pas authorable

Symétrique du problème A, côté **autorat**. Le catalogue texte est **100 % QCM** (18 669 questions,
§9) : hors les ~39 natives `numeric`/`ordering`/`matching`/`multi` (étude 03), **il n'existe aucun
moyen d'écrire une question dont la réponse est un texte court tapé librement** — pas d'options,
pas de devinette. Conséquences pédagogiques mesurables :

- des questions dont la forme naturelle est la **production** (« Comment appelle-t-on… ? »,
  « أين… ؟ », vocabulaire, conjugaison, terminologie) sont **dégradées en reconnaissance** : 4
  propositions dont 3 fausses, éliminables, avec 25 % de réussite au hasard — exactement la
  faiblesse que l'étude 17 documentait (le rappel actif consolide, le re-choix non) ;
- le mode Rappel n'y répond qu'**après coup et sous condition** : il faut d'abord maîtriser le QCM
  à 100 %, et seules les questions **éligibles** (66,1 %) sont rejouables. La saisie libre n'est
  jamais la forme **première** d'une question ;
- les auteurs (skills `prof-*`, `content-*`) inventent des distracteurs pour des questions qui
  n'en méritent pas — coût de génération et parfois distracteurs artificiels, relevés par
  `content-audit`.

Le non-goal historique de la spec Tier B (« free-text / essay grading », pas de correcteur fiable)
visait la correction **subjective**. L'étude 17 a montré qu'une **égalité déterministe normalisée**
sur réponse courte est fiable ; le volet A la dote d'un **ensemble de réponses acceptées**. À ce
point, la question libre native n'exige **aucun moteur nouveau** : c'est un **consommateur de plus
du même socle** — un `question_type` de plus dans la seam `score_answer` (étude 03), corrigé par le
même test d'appartenance. Ne pas la spécifier ici recréerait plus tard une machinerie parallèle.

### Décision produit

**Arbitrage Mohamed, 2026-07-15 (volet A).** **On n'exclut AUCUNE question** du mode Rappel. On
garde tout le catalogue éligible et on rend chaque question **réellement répondable en saisie
libre** en dotant le moteur du **jeu des réponses acceptées** de chaque question — ce que l'étude 17
avait explicitement renvoyé à une « extension v2 naturelle » (nom de travail `recallAnswers`, hors
périmètre v1, §Hors-périmètre étude 17). Cette étude EST cette v2, élargie.

**Demande Mohamed, 2026-07-16 (volet B).** L'étude prend en charge les **questions libres sans
réponses proposées** : le jeu de réponses acceptées devient la clé de correction d'un **type natif
`short_answer`** authorable directement dans le pipeline de contenu — la saisie libre comme forme
première d'une question, pas seulement comme rejeu d'un QCM maîtrisé.

**Résultat attendu.**

- **Volet A (rappel tolérant).** Pour chaque question éligible, le moteur compare la saisie
  normalisée non plus à une seule chaîne mais à un **ensemble fermé de réponses acceptées** (la
  bonne option **plus** ses variantes valides : paraphrases, synonymes, formes morphologiques —
  avec/sans article, genre, pluriel —, positions équivalentes, et pour l'arabe — tous niveaux
  (Q-1) — translittérations latines usuelles). L'ensemble est **produit hors-ligne** (passe de
  génération outillée + revue), stocké dans le contenu versionné, **compilé** comme le reste, et
  **jamais envoyé au client** (même posture server-only que la clé). Le scoring **reste 100 %
  déterministe au runtime** (test d'appartenance normalisé) — aucun jugement IA, aucune latence,
  aucun coût par réponse, aucun oracle exposé.
- **Volet B (questions libres natives).** Un auteur écrit une question `short_answer` : un énoncé,
  une **réponse canonique** (`answerKey.text`), ses **variantes acceptées** (`acceptedAnswers` — le
  même champ que le volet A) et, optionnellement, des **erreurs attendues taguées**
  (`expectedMistakes` — le pendant télémétrique des distracteurs). Aucune option n'est proposée à
  l'élève : il tape sa réponse dès la **première rencontre**, dans le player classique — et partout
  où les types natifs sont jouables (quiz, catalogue public, Donjon, duels), car le scoring passe
  par la **même seam** `score_answer` et le rendu par le **même** `<QuestionInput>`. La correction
  est le même test d'appartenance déterministe que le volet A (helper SQL commun).

**Ce que l'étude ne cherche PAS à faire** : introduire un correcteur flou/Levenshtein en base
(la comparaison reste exacte, sur un ensemble élargi) · appeler un LLM au moment de répondre ·
noter du texte libre **subjectif** (essai, rédaction — le non-goal de la spec Tier B reste entier :
`short_answer` est une réponse **courte fermée**, jamais une production ouverte) · **exclure des
questions** ou introduire un réglage d'éligibilité par niveau qui masquerait du contenu ·
**convertir en masse** les QCM existants en `short_answer` (Q-5 — le type vise le contenu nouveau)
· modifier les RPCs de quiz/Donjon/duels (la seam `score_answer` les sert sans réécriture).

**État réel du code (base études 17 + 03, livrées).**

- Étude 17 : `normalize_recall_text(text)` (IMMUTABLE, SQL pur, 9 étapes),
  `is_question_recall_eligible(q)` (R-2 a–i, listes closes), `score_recall_answer(q,choice)`
  (STABLE, égalité normalisée simple) — les trois `REVOKE`d d'anon/authenticated. La clé n'atteint
  jamais le client (`getExercise` whitelist ses colonnes ; `get_recall_questions` renvoie prompt
  seul). `exercise_sessions.variant` / `attempts.variant` discriminent classique vs rappel. Côté
  UI : `RecallInput` (champ libre RTL-aware, autocomplete/correct/spellcheck off) et
  `RecallCharBar` (chips d'appoint par langue, R-12 étude 17) vivent dans `question-input.tsx`.
- Étude 03 : `questions.question_type` (CHECK fermé `('mcq','numeric','ordering','matching',
'multi')` — à étendre), `questions.answer_key` (JSONB server-only, **jamais** de GRANT SELECT ;
  `question_type` seul est client-readable, GRANT par colonne), la contrainte
  `(mcq AND correct_option NOT NULL) OR (non-mcq AND answer_key NOT NULL)` (une `short_answer` la
  satisfait telle quelle), la seam `score_answer(q, choice)` (« unknown types score false, never
  crash ») appelée par **six** sites : `submit_exercise_attempt`, `get_attempt_review`,
  `check_answers`, `score_quiz`, `submit_dungeon_answer`, `submit_duel_answer` — et le helper de
  révélation `answer_key_display(q)`. Côté UI, `<QuestionInput>` est rendu par le player, le
  Donjon et l'arène de duel.
- **Aucune de ces signatures n'est cassée par cette étude** — on ajoute une source de vérité
  (l'ensemble accepté), on élargit un corps de fonction (`score_recall_answer`), on ajoute une
  branche à la seam (`short_answer`) et une entrée à l'union du schéma de contenu.

**KPI de succès.**

- **Taux « réponse juste refusée » < 1 %** des sessions Rappel (mesuré via signalements + revue
  d'échantillons) — c'était déjà la cible R-4 de l'étude 17 ; c'est ici l'objectif primaire.
- **Couverture** : ≥ 95 % des questions éligibles disposent d'un `acceptedAnswers` généré **et
  validé** (le reste = la bonne option seule, comportement étude 17 — jamais pire qu'aujourd'hui).
- **Volet B** : le pilote (lot 8) livre ≥ 1 chapitre témoin avec des `short_answer` nées complètes
  (ensemble + revue), **zéro** signalement `recall_false_negative` fondé sur ces questions pendant
  le pilote ; après doctrine, les nouvelles campagnes utilisent le type là où le QCM dégraderait la
  question (adoption vérifiée par `content-audit`).
- **Non-régression** : le scoring reste déterministe (pgTAP table-driven), la clé et l'ensemble
  accepté ne fuient pas (smoke + test de whitelist), et une saisie fausse reste fausse (l'ensemble
  n'entre jamais en collision avec un élément déclaré faux — R-4 généralisée).

## 2. Spécification fonctionnelle

### Acteurs & parcours

Élève **connecté** (jeu du Rappel, inchangé étude 17) et, pour le volet B, **tout joueur des
surfaces existantes** (le type natif est jouable partout où `numeric` l'est — y compris le
catalogue public anonyme) ; **auteur/architecte** (génère et valide les ensembles, authore les
questions libres, hors-ligne) ; **admin** (triage des « refus contestés », lot 6). L'anonyme voit
la mission Rappel verrouillée (override R-9 du 2026-07-15) mais ne joue pas ce mode.

- **US-1 — ma paraphrase juste est acceptée.** Élève : en Rappel, si je tape une **formulation
  correcte** de la réponse (« فوق الشجرة » là où l'option disait « فوقها »), elle est **validée** ;
  je ne suis plus pénalisé pour avoir dit juste autrement.
- **US-2 — l'arabe est équitable.** Élève (contenu ar) : je tape le mot **avec ou sans l'article
  défini**, avec la variante orthographique usuelle (hamza approximative déjà pliée étude 17), et —
  **quel que soit mon niveau** (Q-1 arbitrée « tout ») — une **translittération latine courante** est
  acceptée si je n'ai pas de clavier arabe ; la barre de caractères d'appoint (R-12 étude 17) reste
  offerte.
- **US-3 — aucune question ne disparaît.** Élève : toutes les missions Rappel de l'étude 17 restent
  présentes ; aucune n'est retirée sous prétexte qu'elle « admet plusieurs réponses » — elle est au
  contraire **mieux corrigée**.
- **US-4 — une vraie erreur reste une erreur.** Élève : si je tape un **distracteur** (Rappel), une
  **erreur attendue** (`short_answer`) ou une réponse hors-sujet, c'est **faux** (l'ensemble accepté
  ne contient jamais un élément déclaré faux) — la valeur pédagogique du rappel est préservée.
- **US-5 — je peux signaler un refus injuste.** Élève : à la correction, si une de mes réponses
  refusées me semble juste, le bouton « Signaler une erreur » (existant, `content_reports`) me
  permet de la remonter ; elle alimente la file de revue (lot 6). Vaut pour le Rappel **et** pour
  les `short_answer`.
- **US-6 — auteur : je génère et je relis.** Auteur/architecte : je lance la passe de génération sur
  une matière ; elle produit un `acceptedAnswers` par question éligible ; `content:qa` le valide
  (typabilité, non-collision) ; je relis le diff avant compilation — **aucune** mise en base d'un
  ensemble non relu.
- **US-7 — élève : je réponds librement dès la première rencontre.** Élève : dans une mission
  classique, une question `short_answer` m'affiche l'énoncé et un champ de saisie — **aucune
  proposition à éliminer**. Je tape ma réponse ; toute formulation de l'ensemble accepté est juste ;
  à la correction je vois ma réponse tapée, la réponse canonique et l'explication — comme en Rappel.
- **US-8 — auteur : j'écris une question libre née complète.** Auteur (skill) : quand la forme
  naturelle d'une question est la production (pas le choix), je l'authore en `short_answer` : énoncé
  auto-suffisant, réponse canonique courte et tapable, **ensemble accepté livré à la naissance**
  (article, synonymes exacts, translittération ar), erreurs attendues taguées si le diagnostic a de
  la valeur. `content:qa` m'impose les contraintes du type (R-12) ; la revue de diff reste
  obligatoire.

**Flux écran (élève).**

- **Rappel (volet A)** : inchangé vs étude 17 (bandeau « Mode Rappel · sans options · XP ×1,5 »,
  input texte, char-bar R-12, correction réponse-tapée vs réponse-attendue). **Seul le verdict
  change** de justesse : des paraphrases correctes passent désormais au vert. À la correction, la
  « réponse attendue » affichée reste le **texte de la bonne option** (canonique) — on n'expose pas
  tout l'ensemble accepté (bruit + fuite de la richesse du gabarit).
- **Question libre native (volet B)** : dans le player **classique** (et Donjon/duels), une
  question `short_answer` rend le **même champ de saisie** que le Rappel (composant partagé, lot 7)
  avec la même char-bar par langue — mais **sans** bandeau de mode ni multiplicateur : c'est une
  question normale de la mission, au barème normal. La correction affiche la réponse canonique
  (`answer_key_display`) + l'explication, comme pour tout type natif. Aucun écran nouveau.

### Règles métier

- **R-1 — ensemble accepté server-only.** `acceptedAnswers` d'une question est stocké dans une
  colonne **jamais lisible par le client** (même posture que `correct_option` / `answer_key` /
  `distractor_tags`). La comparaison est exclusivement serveur (helper d'appartenance + scorers,
  `REVOKE`d). Aucune route ne le sélectionne ; `get_recall_questions` continue de ne renvoyer que
  le prompt ; `getExercise` sert une `short_answer` comme une `numeric` (prompt + type, jamais la
  clé).
- **R-2 — définition de l'ensemble accepté.** Pour une question corrigée en saisie libre, l'ensemble
  des réponses acceptées est : `{ réponse canonique }` **∪** `{ chaque entrée de acceptedAnswers }`,
  chaque membre passé par `normalize_recall_text`. La **réponse canonique** est le texte de la bonne
  option (`mcq` rejoué en Rappel) ou `answerKey.text` (`short_answer`) ; elle est **toujours
  implicitement acceptée** (jamais besoin de la répéter). Le champ `acceptedAnswers` est
  **optionnel** : absent ⇒ canonique seule (comportement étude 17 pour le Rappel), jamais une
  régression.
- **R-3 — scoring (déterministe, tout-ou-rien, ensemble élargi).** Le verdict est vrai ssi
  `normalize(choice)` **∈** l'ensemble accepté normalisé **et** `choice` non vide/blanc. Pas de
  crédit partiel, pas de distance d'édition. La normalisation est celle de l'étude 17
  (`normalize_recall_text`), inchangée par défaut (voir R-8). **Une seule implémentation** de ce
  test (helper SQL commun, §3) sert le mode Rappel (`score_recall_answer`) et le type natif (branche
  `short_answer` de `score_answer`) — clé malformée ⇒ faux, jamais d'exception (posture étude 03).
- **R-4 — invariant anti-collision (précision d'abord, généralisé).** Un membre de l'ensemble
  accepté **ne doit jamais** égaler (normalisé) un élément **déclaré faux** de la même question :
  un **distracteur** (`mcq`) ou une **erreur attendue** (`short_answer`, `expectedMistakes`).
  `content:qa` **rejette** (erreur) tout `acceptedAnswers` qui collisionne, qui duplique la
  canonique, ou qui duplique un autre membre — et symétriquement toute erreur attendue qui égalerait
  un membre accepté. Rationale : mieux vaut refuser une paraphrase rare que d'accepter une réponse
  ambiguë et détruire la valeur pédagogique (US-4). C'est l'extension à tout l'ensemble de la règle
  R-2(h) de l'étude 17.
- **R-5 — typabilité de chaque membre.** Chaque membre de `acceptedAnswers` (et la canonique d'une
  `short_answer`), une fois normalisé, doit respecter le charset tapable au clavier de l'étude 17
  R-2(i) : `^[a-z0-9.ء-ي]+$`. Un membre qui se normalise en vide, ou qui contient un caractère
  hors-charset, est **rejeté** par `content:qa` (erreur). (Une translittération latine d'un mot
  arabe est donc naturellement autorisée — lettres latines de base.)
- **R-6 — éligibilité Rappel : on ne RETIRE rien, on peut ÉLARGIR.** L'ensemble accepté rendant les
  questions à formulation variable **corrigeables**, la justification des exclusions R-2(f/g) de
  l'étude 17 (marqueurs composites, énoncés « dépendants des options ») **s'assouplit** mais **ne se
  durcit jamais**. v1 : `is_question_recall_eligible` **reste identique** (aucune question éligible
  aujourd'hui ne devient inéligible ; elle continue d'exiger `question_type='mcq'` — voir R-11 pour
  les `short_answer`). Élargir l'éligibilité aux questions aujourd'hui exclues est une **extension
  explicitement hors-v1** (annexe §9, candidate lot ultérieur) — car elle demande de générer des
  ensembles pour des questions encore jamais servies en Rappel.
- **R-7 — génération hors-ligne, revue obligatoire, zéro IA au runtime.** Les ensembles sont produits
  par une passe outillée (skill dédié, §3) **avant** toute mise en base, écrits en **fichiers**
  contenu, validés par `content:qa`/`content:qa:strict`, **relus** dans le diff, puis compilés
  (UUIDv5 idempotent). Aucun appel modèle n'a lieu pendant une session élève. C'est la même doctrine
  que le reste du moteur de contenu (fichiers → compilation) et que l'étude 12. Vaut à l'identique
  pour l'autorat des `short_answer` (US-8).
- **R-8 — normalisation : extensions minimales et sûres (décision fermée).** On **préfère porter les
  variantes dans l'ensemble généré** plutôt que d'assouplir `normalize_recall_text` (une règle de
  normalisation trop large — p. ex. plier l'article « ال » globalement — risque de créer des
  collisions distracteur invisibles sur tout le catalogue). v1 : **aucune modification** de
  `normalize_recall_text`. L'article défini arabe, les paraphrases, les translittérations sont gérés
  **comme membres de l'ensemble** (contrôlés par R-4/R-5, donc sûrs question par question).
- **R-9 — télémétrie (étude 04-A0) étendue, jamais appauvrie.** En Rappel, une réponse tapée qui
  égale (normalisé) un **distracteur** résout toujours son `misconception_tag` (R-7 étude 17). Une
  réponse acceptée via l'ensemble n'est pas un distracteur (R-4) ⇒ pas de tag, cohérent. Pour une
  `short_answer`, le même appariement de texte s'applique aux **erreurs attendues** : saisie
  normalisée ≡ `mistake.text` normalisé ⇒ son `tag` (sinon NULL) — même mécanique, dans les deux
  RPCs télémétriques (`submit_exercise_attempt`, `submit_dungeon_answer`). `question_attempts`
  continue de logguer `choice` = texte tapé.
- **R-10 — périmètre du MODE Rappel.** Quiz de compréhension, Donjon, duels : jamais de **variante
  Rappel** (comme étude 17). Ne pas confondre avec le **TYPE** `short_answer` (R-11), qui y est
  jouable par construction — sans modifier `check_answers`, `score_quiz`, `submit_dungeon_answer`
  ni `submit_duel_answer` (ils appellent déjà la seam).
- **R-11 — type natif `short_answer` (volet B).** Nouveau `question_type` dans le cadre exact de
  l'étude 03 : `options` vides (comme `numeric`), clé typée
  `answer_key = {"text": string, "mistakes"?: [{"text": string, "tag": string}]}` server-only,
  réponse wire `choice` = texte tapé (borne 512 existante), scoring par la branche `short_answer`
  de `score_answer` (R-3), révélation par `answer_key_display` = `answer_key->>'text'`. Jouable
  partout où la seam et `<QuestionInput>` opèrent : exercices, quiz, catalogue public, Donjon,
  duels. **Jamais éligible au mode Rappel** (`is_question_recall_eligible` exige `mcq`, inchangé) :
  une question déjà en saisie libre EST du rappel actif — le rejeu n'ajouterait rien ; dans un
  exercice mixte, le compte « ≥ 3 questions éligibles » ne compte que les `mcq`, par construction.
  **Aucun multiplicateur XP** : le type est la forme normale de la question (le ×1,5 récompense le
  MODE Rappel, pas la saisie libre en soi) ; l'équité de vitesse de saisie au Donjon/duels est le
  même compromis que `numeric`, accepté.
- **R-12 — contraintes d'autorat du type (gate QA, erreurs).** Miroir, côté naissance, des critères
  d'éligibilité R-2 de l'étude 17 (qui filtraient le stock au rejeu) : `answerKey.text` fait 1–60
  caractères, ≤ 6 mots, une seule ligne ; sans contenu riche (`<svg`, `<img`, `![`, `$$`, `http`)
  ni symbole mathématique de structure ; s'il se normalise en nombre pur ⇒ erreur « utiliser
  `numeric` » ; charset tapable R-5 ; énoncé **auto-suffisant** — les motifs « dépendants des
  options » (liste close R-2(g) étude 17) sont des **erreurs** d'autorat pour ce type (« lequel des
  suivants » sans options n'a pas de sens) ; réponse dans la **langue d'instruction** de la matière.
  `expectedMistakes` : optionnels, chaque `tag` appartient au registre fermé
  `content/misconceptions.json`, chaque `text` non vide une fois normalisé et non collisionnant
  (R-4) ; ≤ 6 entrées.
- **R-13 — né-complet (doctrine d'autorat, revue humaine).** Toute `short_answer` **naît avec son
  ensemble** : l'auteur (skill) livre `acceptedAnswers` à l'écriture — expansion morphologique
  (article, contraction), synonymes exacts, translittération latine pour l'arabe (Q-1 « tout ») —
  au lieu d'attendre une campagne de rattrapage. Le double-solve et la revue de diff s'appliquent
  (R-7). La QA ne peut pas exiger un minimum (une réponse peut légitimement n'avoir aucune variante) :
  cette règle vit dans les skills et la revue, pas dans le gate.
- **R-14 — doctrine d'usage (où authorer le type).** Le moteur n'impose aucune restriction de
  surface (CHECK de type uniquement). La **doctrine v1** portée par les skills : `short_answer`
  s'authore dans les **exercices** de tous les thèmes, et dans les quiz des thèmes **non scolaires**
  avec parcimonie ; **jamais dans un `quiz.json` du thème école** en v1 (le quiz y gate la
  progression du chapitre — on n'y met pas la forme la plus exigeante avant d'avoir les mesures du
  pilote). Une mission reste **mixte** : la saisie libre complète le QCM, elle ne le remplace pas
  (recommandation ≤ ~1/3 des questions d'une mission). Révisable après le lot 8.

### i18n

Aucune nouvelle surface élève obligatoire (le mode Rappel existe déjà ; le player rend déjà les
types natifs — la review `short_answer` réutilise « Ta réponse » et l'affichage texte du Rappel).
Extensions possibles (lot 5) : libellés de la barre de saisie arabe / clavier d'appoint pour les
petites classes, sous `t.quest.*`. Les champs `acceptedAnswers`/`answerKey.text`/`expectedMistakes`
sont du **contenu** (dans la langue d'instruction de la matière), pas de l'i18n applicatif.
Notation standard maintenue (chiffres occidentaux, LTR pour les équations) —
`content-engine/references/math-and-notation.md`.

### Hors périmètre (v1)

Correcteur flou/Levenshtein · LLM au runtime · crédit partiel · notation d'essai/texte libre
subjectif (le non-goal Tier B demeure) · élargissement de l'éligibilité Rappel aux questions
aujourd'hui exclues (R-6) · **variante Rappel** sur quiz/Donjon/duels (R-10) · **conversion de
masse** des QCM existants en `short_answer` (Q-5) · réglage per-question de l'éligibilité par les
auteurs · clavier arabe complet à l'écran (v1 = char-bar R-12 + translittérations générées ;
clavier riche = lot 5 si les KPI l'exigent) · traduction inter-langues des réponses (une réponse
française à une question arabe reste fausse — c'est la langue d'instruction qui prime ; seule la
**translittération** de la réponse arabe est un aménagement) · `expectedMistakes` obligatoires
(optionnels, R-12).

## 3. Architecture technique (décisions fermées)

### Modèle de données (migrations additives, lots 1 et 7)

**Lot 1 — l'ensemble accepté**, une seule colonne **server-only** sur `questions`, peuplée par le
compilateur de contenu :

```sql
-- Ensemble des réponses acceptées EN PLUS de la réponse canonique, tel qu'authored
-- (l'auteur écrit du texte lisible ; le scoring normalise). JSONB = array de text.
ALTER TABLE public.questions
  ADD COLUMN accepted_answers jsonb NOT NULL DEFAULT '[]'::jsonb;

-- Invariant de forme (le contenu de l'array est validé plus finement par content:qa côté build).
ALTER TABLE public.questions
  ADD CONSTRAINT questions_accepted_answers_is_array
  CHECK (jsonb_typeof(accepted_answers) = 'array');
```

**Aucun grant nouveau, et surtout aucun grant de lecture** : `accepted_answers` suit exactement la
posture de `correct_option`/`answer_key`/`distractor_tags` — la colonne existe mais **n'est jamais
dans une whitelist client**. Le SELECT RLS public sur `questions` (lecture du catalogue) **doit
exclure cette colonne** partout où il liste des colonnes explicites ; auditer `getExercise`,
`get_recall_questions` et toute vue/politique qui `SELECT *` sur `questions` (si une politique fait
`SELECT *`, ajouter une vue projetée ou passer par la RPC DEFINER — **stop-point sécurité du
lot 1**).

**Lot 7 — le type natif** : aucune colonne nouvelle. Étendre le CHECK fermé de l'étude 03 :

```sql
ALTER TABLE public.questions
  DROP CONSTRAINT IF EXISTS questions_question_type_check;
ALTER TABLE public.questions
  ADD CONSTRAINT questions_question_type_check
  CHECK (question_type IN ('mcq', 'numeric', 'ordering', 'matching', 'multi', 'short_answer'));
```

La contrainte existante `(mcq AND correct_option NOT NULL) OR (non-mcq AND answer_key NOT NULL)`
couvre déjà le nouveau type (une `short_answer` porte toujours `answer_key`). La clé typée :

```jsonc
// questions.answer_key d'une short_answer (server-only, comme tout answer_key)
{
  "text": "فوق الشجرة", // réponse canonique — affichée à la correction
  "mistakes": [
    // optionnel : erreurs attendues taguées (pendant des distracteurs)
    { "text": "تحت الشجرة", "tag": "ar.espace.sur-sous-confusion" },
  ],
}
```

Les **variantes acceptées** d'une `short_answer` ne vivent PAS dans `answer_key` : elles vont dans
`accepted_answers`, la **même colonne** que le volet A (D-8) — une seule source, un seul jeu de
règles QA, une seule passe de génération pour les deux volets.

### Fonctions de scoring (lots 1 et 7) — un helper commun, deux consommateurs

**Lot 1.** Le test d'appartenance vit dans **une** fonction (nouvelle), et `score_recall_answer`
devient son premier consommateur. Signatures, postures `SECURITY`/`STABLE` et `REVOKE` inchangées
(D-3 étude 17 : `score_answer` classique n'est pas touchée par ce lot) :

```sql
-- L'UNIQUE implémentation du verdict « saisie libre » : appartenance normalisée
-- à { canonique } ∪ accepted_answers. REVOKEd (pas d'oracle client).
CREATE FUNCTION public.is_accepted_free_answer(q public.questions, p_choice text)
RETURNS boolean
STABLE
LANGUAGE sql
SET search_path = public
AS $$
  SELECT btrim(coalesce(p_choice, '')) <> ''
     AND public.normalize_recall_text(p_choice) IN (
       -- la réponse canonique, toujours acceptée
       SELECT public.normalize_recall_text(
         CASE
           WHEN q.question_type = 'short_answer' THEN q.answer_key ->> 'text'
           ELSE (SELECT opt ->> 'text' FROM jsonb_array_elements(q.options) opt
                  WHERE opt ->> 'id' = q.correct_option)
         END)
       UNION
       -- les variantes acceptées authored/générées
       SELECT public.normalize_recall_text(x)
       FROM jsonb_array_elements_text(q.accepted_answers) AS x
     );
$$;

-- Le scorer du MODE Rappel délègue (comportement à ensemble vide = étude 17 à l'identique).
CREATE OR REPLACE FUNCTION public.score_recall_answer(q public.questions, p_choice text)
RETURNS boolean STABLE LANGUAGE sql SET search_path = public
AS $$ SELECT COALESCE(public.is_accepted_free_answer(q, p_choice), false); $$;
```

**Lot 7.** La seam `score_answer` (recréée verbatim + une branche, pattern B1→B3) gagne le TYPE :

```sql
-- branche ajoutée à score_answer (plpgsql), avant le fallback « unknown → false »
IF q.question_type = 'short_answer' THEN
  IF q.answer_key IS NULL OR NOT (q.answer_key ? 'text') THEN
    RETURN false;   -- clé malformée = réponse fausse, jamais d'exception (posture étude 03)
  END IF;
  RETURN COALESCE(public.is_accepted_free_answer(q, p_choice), false);
END IF;
```

`answer_key_display(q)` (recréée verbatim) gagne `WHEN 'short_answer' THEN q.answer_key ->> 'text'`
— les RPCs de révélation (review, correction publique) n'ont **aucune** modification. Idempotent,
déterministe, aucun élargissement de surface d'attaque (colonnes server-only, fonctions `REVOKE`d).
pgTAP table-driven (lots 1 et 7) : canonique, chaque variante, un élément déclaré faux (faux), vide
(faux), variantes casse/espaces/tashkeel, clé malformée (faux), `accepted_answers = '[]'` (identique
étude 17).

### Pipeline contenu (lots 1 et 7) — champs `acceptedAnswers`, type `short_answer`

**Lot 1** — nouveau champ **optionnel** au schéma zod des questions
(`src/shared/content/schema.ts`), porté par `questionCoreSchema` mais **validé par type** (QA) :

```ts
// question schema — ajout (mcq : variantes du Rappel ; short_answer : variantes du type)
acceptedAnswers: z.array(z.string().min(1).max(512)).max(24).optional(),
```

**Lot 7** — nouvelle entrée de l'union discriminée (même gabarit que `numeric`) :

```ts
const shortAnswerQuestionSchema = questionCoreSchema.extend({
  type: z.literal("short_answer"),
  answerKey: z.object({ text: z.string().min(1).max(60) }),
  // erreurs attendues taguées (pendant des distracteurs — étude 04) ; server-only à la compilation
  expectedMistakes: z
    .array(z.object({ text: z.string().min(1).max(512), misconceptionTag: z.string().min(1) }))
    .max(6)
    .optional(),
});
```

Le **builder** (`scripts/content/build.ts` / `sql-builder.ts`) émet la colonne `accepted_answers`
(array JSONB, tous types texte concernés) et, pour `short_answer`, `question_type` +
`answer_key = {text, mistakes?}` (mêmes chemins que les types B1–B3) ; **la normalisation et le
dédoublonnage restent en base** (le builder écrit le texte brut lisible ; le scoring normalise —
source unique de la normalisation, évite toute divergence TS/SQL). Les champs voyagent dans la
migration idempotente par sujet (UUIDv5 stable, pas de backfill : les questions sans
`acceptedAnswers` gardent `'[]'`).

**QA (`content:qa` + `content:qa:strict`)** — nouvelles vérifications (erreurs, pas warnings) :

1. chaque entrée `acceptedAnswers`, normalisée (mêmes règles que le SQL, portées en TS dans
   `src/shared/content/` — **avec un test qui prouve la parité TS↔SQL** sur un corpus fixe), est
   **non vide** et respecte le charset R-5 ;
2. **aucune collision** avec un élément déclaré faux normalisé — distracteur (`mcq`) ou
   `expectedMistakes` (`short_answer`) — ni doublon de la canonique, ni doublon interne (R-4) ;
3. `acceptedAnswers` n'est autorisé **que** sur une question qui le consomme : `mcq` **éligible**
   (`is_question_recall_eligible` vraie — sinon warning « ensemble ignoré ») ou `short_answer`
   (toujours actif) ; erreur sur `numeric`/`ordering`/`matching`/`multi` ;
4. taille bornée (≤ 24 entrées) pour éviter les ensembles ballonnés ;
5. **(lot 7)** contraintes d'autorat R-12 sur toute `short_answer` (longueur/mots/ligne, pas de
   riche/math, « nombre pur ⇒ `numeric` », charset, motifs dépendants-des-options, tags
   `expectedMistakes` ∈ registre `content/misconceptions.json`).

### Génération des ensembles (lot 2+) — DEUX tiers (la mesure §9 les sépare nettement)

**Tier A — expansion morphologique déterministe (SANS IA, ~cœur du gisement « article »).** Une
passe **mécanique** (fonction pure, testable) génère les variantes morphologiques sûres, langue par
langue — c'est le plus gros gisement mesuré (article défini : 21,4 % des éligibles ar + équivalents
fr/en) et il ne nécessite **aucun modèle** :

- **arabe** : réponse avec ⇄ sans article « ال » en tête (`النبات الأخضر` ⇄ `نبات أخضر`) ;
- **français** : article de tête `le/la/les/l'` ajouté ⇄ retiré (`Afrique` ⇄ `l'Afrique`) ;
- **anglais** : contractions usuelles étendues ⇄ contractées (`they're` ⇄ `they are`, `can't` ⇄
  `cannot`, `it's` ⇄ `it is`), article `the/a/an` de tête.

Chaque variante produite passe la **garde anti-collision R-4** (si elle égale un élément déclaré
faux normalisé, elle est **écartée** — la question reste, seule la variante tombe : c'est ce qui
préserve le « zéro exclusion », contrairement à un pliage global en normalisation qui exclurait la
question par collision, D-2). Tier A est **exécutable au build** ou pré-généré en fichiers ; sans
IA, il est quasi-gratuit et couvre mécaniquement le gisement (b). La même fonction pure sert de
**filet à l'autorat** des `short_answer` (R-13) : le skill l'applique à la canonique avant revue.

**Tier B — génération sémantique (IA + double-solve + revue humaine), gisements (a)/(c).** Le skill
`.claude/skills/content-accepted-answers/` (déféré à `content-engine` : schéma, barre qualité,
notation) produit pour chaque question éligible **à réponse ≥ 2 mots ou positionnelle** les
**paraphrases / synonymes exacts / positions équivalentes** validés (« فوقها » ↔ « فوق الشجرة » ↔
« في الأعلى ») — bornés (≤ 24), jamais un quasi-synonyme qui changerait le sens. Le skill
**re-résout** chaque question et vérifie que chaque variante est bien **une** bonne réponse **et**
ne matche aucun élément déclaré faux (miroir de la garde `content:qa`) avant de l'écrire. Il
produit **des fichiers uniquement**, puis lance `content:check` + `content:qa:strict`.

**Translittérations latines** (arabe, **tous niveaux** — Q-1 arbitrée « tout ») : ajoutées par Tier
A/B, par défaut pour les réponses **mono-mot** (« النملة » → « namla »/« nemla ») ; le multi-mot
n'est ajouté que s'il est **non ambigu** (une seule romanisation raisonnable) et non collisionnant
(R-4).

La campagne (lot 4) suit la **priorité produit** — petites classes d'abord (public le plus fragile,
problème le plus aigu, cf. la mission constatée), puis concours — **une matière par PR** (règle
anti-troncature + `content:build --subject <id>` du repo), revue de diff avant compilation. Tier A
peut être appliqué **à tout le corpus d'un coup** (déterministe, peu risqué) ; Tier B est batché.

### UI (lot 7) — un composant de saisie partagé, zéro écran nouveau

`question-input.tsx` : la branche `variant === "recall"` et la nouvelle branche
`question_type === "short_answer"` rendent le **même** champ libre — extraire l'actuel
`RecallInput` en **`FreeTextInput`** partagé (mêmes attributs R-8 étude 17 : `dir` = langue du
contenu, `autoComplete/autoCorrect/spellCheck` off, Entrée = valider, `data-testid` conservé) avec
la **même** `RecallCharBar` (palette statique par langue, R-12 étude 17 — jamais dérivée de la
réponse). `answer-formats.ts` : type effectif `short_answer` = mêmes règles que `recall` (non vide,
≤ 120 c. UI ; wire 512 inchangé). Review (`quest-review-list.tsx`) : réponse tapée vs
`answer_key_display` — le chemin texte du Rappel, réutilisé. Le Donjon et l'arène de duel rendent
`<QuestionInput>` : ils héritent du type **sans modification** (comme pour B1–B3). Aucun bandeau,
aucun multiplicateur, aucune capability nouvelle (l'indice reste offert en mode classique — R-11 de
l'étude 17 ne concerne que la variante Rappel ; `explanation` d'une `short_answer` ne doit pas
contenir la réponse littérale — lint `content:qa` existant sur les indices, à étendre si absent).

### Boucle d'auto-correction (lot 6, optionnel) — « refus contesté »

Un élève qui signale une réponse refusée-mais-juste (US-5, via `content_reports` avec un type
`recall_false_negative`) alimente une **file de revue admin** (`/admin/content-reports` filtré). Un
auteur confirme ⇒ la variante est **ajoutée à `acceptedAnswers`** (fichier → compilation). Le
système **apprend** ses angles morts au lieu de les répéter ; c'est la mitigation vivante du KPI
« < 1 % ». Couvre le Rappel **et** les `short_answer` (mêmes fichiers, même champ). Aucune écriture
automatique en base : la boucle reste **humaine-dans-la-boucle** (pas d'oracle auto-modifiable).

### Sécurité & anti-triche

- `accepted_answers` et `answer_key` **server-only** (jamais whitelistés client) — invariant vérifié
  par un test de whitelist + `smoke:shell` (le bundle prod ne doit jamais recevoir ces colonnes).
  `question_type` seul reste client-readable (GRANT par colonne, étude 03 — nécessaire au rendu).
- L'ensemble accepté ne peut pas ouvrir un oracle : `is_accepted_free_answer`,
  `score_recall_answer` et `score_answer` restent `REVOKE`d d'anon/authenticated (appelées
  uniquement par les RPCs DEFINER de soumission).
- R-4 (anti-collision) garantit qu'élargir l'acceptation **ne rend jamais juste un élément déclaré
  faux** — la triche « je tape n'importe quelle option » reste fausse.
- Génération hors-ligne ⇒ aucune surface d'injection au runtime.
- `check_answers` (catalogue public, anonyme) sert les `short_answer` comme les `numeric` : le
  verdict après soumission, jamais la clé avant (posture inchangée).

### Décisions d'architecture (ADR)

- **D-1 — ensemble authored/généré plutôt que correcteur flou.** Rejeté : Levenshtein/embeddings au
  runtime (non-déterministe, coût, faux positifs incontrôlables, oracle). Choisi : ensemble fermé,
  déterministe, contrôlé question par question. L'intelligence est déplacée à la **génération
  hors-ligne**, revue par un humain — le runtime reste bête et sûr.
- **D-2 — variantes dans l'ensemble, pas dans la normalisation (argument décisif : le zéro-exclusion).**
  Rejeté : plier l'article « ال » (ou d'autres classes) globalement dans `normalize_recall_text`.
  Raison dirimante : `is_question_recall_eligible` utilise **la même** normalisation pour son test
  d'anti-collision (h) ; un pliage global qui ferait coïncider une bonne réponse et un distracteur
  rendrait la question **inéligible** — donc la **retirerait** du Rappel. Un pliage global peut ainsi
  **exclure** du contenu, ce que la directive humaine interdit. Choisi : chaque variante est un membre
  **explicite** de l'ensemble, gardé par R-4/R-5 **par question** — en cas de collision on écarte **la
  variante**, jamais la question. `normalize_recall_text` reste **inchangée** (v1). Bonus : les variantes
  morphologiques (article, contraction) sont **déterministes** (Tier A, sans IA), donc ce choix n'a même
  pas de surcoût de génération.
- **D-3 — normalisation en base, texte lisible en fichier.** Le fichier contenu porte du texte
  **lisible** (relecture humaine possible) ; la **normalisation est faite par le SQL** au scoring —
  source unique, pas de risque de divergence TS/SQL. Un test de **parité** TS↔SQL protège le gate QA.
- **D-4 — zéro exclusion (directive humaine).** On ne durcit jamais l'éligibilité (R-6). Le contenu à
  formulation variable est **mieux corrigé**, pas retiré. Escape hatch éventuel (per-grade) explicitement
  **refusé** en v1.
- **D-5 — nouvelle étude plutôt qu'amendement de 17.** L'étude 17 est livrée ; cette évolution ajoute
  un champ contenu, une passe de génération, une campagne et un changement de scoring — assez pour un
  dossier propre (comme 18→19). L'étude 17 reste la référence du **mode** ; 20 est la référence de la
  **correction en saisie libre** (tolérance du Rappel + type natif).
- **D-6 — renommage `recallAnswers` → `acceptedAnswers` (2026-07-16).** Le jeu de réponses acceptées
  sert désormais **deux** consommateurs : le mode Rappel (mcq rejoués) et le type `short_answer` —
  qui n'est **pas** éligible au Rappel (R-11) ; un nom `recall*` sur ses questions serait durablement
  trompeur. Rien n'étant implémenté (lot 1 non démarré), le renommage est gratuit aujourd'hui et
  coûteux après. Champ contenu `acceptedAnswers`, colonne `accepted_answers`, skill
  `content-accepted-answers`. (« recallAnswers » reste le nom de travail historique dans l'étude 17
  §Hors-périmètre.)
- **D-7 — nom du type : `short_answer` (pas `free_text`).** Le nom dit la contrainte : une réponse
  **courte fermée** (R-12 : ≤ 60 c., ≤ 6 mots), corrigée par appartenance exacte — pas un champ de
  texte libre à noter. `free_text` évoquerait le non-goal « essay grading » de la spec Tier B, que
  cette étude ne rouvre pas.
- **D-8 — les variantes d'une `short_answer` vivent dans `accepted_answers`, pas dans `answer_key`.**
  Rejeté : `answer_key.accepted` (clé autoportante par type). Raison : les variantes sont le **même
  concept** que celles du volet A — une seule colonne ⇒ un seul jeu de règles QA (R-4/R-5), une seule
  passe Tier A/B, un seul point d'audit whitelist, et le skill traite les deux populations
  uniformément. `answer_key` ne porte que ce qui est **spécifique** au type : la canonique (`text`)
  et les erreurs attendues (`mistakes` — server-only par construction, comme `distractor_tags`).
- **D-9 — un helper d'appartenance unique (`is_accepted_free_answer`).** Rejeté : dupliquer le test
  ensembliste dans `score_recall_answer` ET dans la branche seam (deux corps à faire dériver).
  Choisi : une fonction REVOKEd, deux consommateurs — le verdict « saisie libre » a UNE définition.
  Le lot 1 la crée (consommateur Rappel) ; le lot 7 la branche dans la seam sans la modifier.
- **D-10 — le type vise le contenu NOUVEAU ; pas de conversion de masse (renvoi Q-5).** Convertir
  in-place un `mcq` joué en `short_answer` détruirait ses distracteurs authored (et leur télémétrie
  04-A0), changerait la nature d'attempts historiques comparés au même `question_id`, et
  re-calibrerait la difficulté d'exercices déjà notés. Une conversion sélective, si Mohamed la
  souhaite (Q-5), se fait par **remplacement authored** (nouvelle question, l'ancienne retirée du
  fichier — la compilation prune), jamais par mutation de type.

## 4. Plan d'exécution en lots

| lot      | contenu (résumé)                                                                                                                                                                                                                                                                                                                                                                                 | fichiers/objets créés                                                                                                                            | tests exigés                                                                                          | dépend de                           |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- | ----------------------------------- |
| 1        | Socle : colonne `accepted_answers` server-only + helper `is_accepted_free_answer` + `score_recall_answer` ensembliste + champ schéma `acceptedAnswers` + builder + QA (collision/typabilité/parité) + **cadrage du type `content_reports.recall_false_negative`** (enum/schéma + acceptation serveur, sans file admin — Q-3)                                                                     | migration `2026…_accepted_answers_set.sql` ; `schema.ts`, `sql-builder.ts` ; QA rules ; pgTAP ; unit build/QA                                    | pgTAP scoring ; unit QA (collision, charset, parité TS↔SQL) ; test whitelist                          | étude 17 (livrée)                   |
| 2        | **Tier A** — expansion morphologique **déterministe** (article ar « ال », article fr, contractions en) appliquée **au corpus entier** (gisement le plus gros, sans IA), gardée anti-collision                                                                                                                                                                                                    | fonction pure `recall-morph-expand` ; fichiers `acceptedAnswers` (Tier A) tous sujets ; migrations sujets                                        | unit table-driven (par langue) ; `content:qa:strict` ; before/after faux négatifs « article »         | lot 1                               |
| 3        | **Tier B** — skill `content-accepted-answers` (paraphrases/synonymes/positions) + **pilote** : petites classes arabes (dont la mission constatée) + 2-3 témoins fr/en                                                                                                                                                                                                                            | `.claude/skills/content-accepted-answers/…` ; `acceptedAnswers` (Tier B) matières pilotes                                                        | `content:qa:strict` ; échantillon re-solvé ; before/after                                             | lot 1 (Tier A recommandé avant)     |
| 4        | Campagne Tier B corpus (priorité petites classes → concours → reste), **une matière par PR**                                                                                                                                                                                                                                                                                                     | `acceptedAnswers` par matière ; migrations sujets                                                                                                | `content:qa:strict` par matière ; sweep `content-audit`                                               | lot 3                               |
| 5        | Aides à la saisie arabe petites classes (translittérations + éventuel clavier d'appoint) + i18n                                                                                                                                                                                                                                                                                                  | extension char-bar R-12 / mini-clavier ar ; clés `t.quest.*`                                                                                     | unit composant ; e2e saisie ar                                                                        | lot 3                               |
| 6 (opt.) | Boucle « refus contesté » : type `content_reports.recall_false_negative` + file admin + ajout de variante                                                                                                                                                                                                                                                                                        | server fn + filtre `/admin/content-reports`                                                                                                      | unit + e2e triage                                                                                     | lot 1 ; canal content-reports       |
| 7        | **Type natif `short_answer` (volet B — moteur)** : CHECK étendu + branche seam `score_answer` + `answer_key_display` ; union zod (`answerKey.text`, `expectedMistakes`) + builder + QA autorat (R-12) ; UI `FreeTextInput` partagé + `answer-formats` + review ; télémétrie appariement erreurs attendues (R-9) ; amendement `docs/interactive-question-types.md` + `content-schema.md` (skills) | migration `2026…_short_answer_type.sql` ; `schema.ts`/`sql-builder.ts`/`qa.ts` ; `question-input.tsx` (extraction `FreeTextInput`) ; docs/skills | pgTAP branche seam (clé malformée, mistakes, vide, `[]`) ; unit QA autorat ; unit UI ; test whitelist | lot 1 (parallélisable aux lots 2–6) |
| 8        | **Pilote contenu `short_answer`** : 1 chapitre témoin ar petites classes + 1 témoin fr/en, questions nées complètes (R-13) via skills mis à jour ; mesure ; doctrine d'usage validée (R-14) puis ouverte aux campagnes normales                                                                                                                                                                  | fichiers contenu (1 matière/PR) ; migrations sujets ; doctrine dans `content-engine`/`content-interactif`/`prof-*`                               | `content:qa:strict` ; e2e player (répondre une `short_answer`) ; sweep `content-audit` du pilote      | lot 7                               |

- [ ] **Lot 1 — Socle scoring ensembliste + colonne server-only + QA.** Périmètre : migration
      additive (`accepted_answers` + CHECK), helper `is_accepted_free_answer` (REVOKEd),
      `CREATE OR REPLACE score_recall_answer` (délégation), champ `acceptedAnswers` au schéma zod,
      émission builder, règles `content:qa` (R-4/R-5 + parité TS↔SQL), pgTAP. **Critères** :
      R-1..R-5, R-8. **Stop-point** : ne génère AUCUN contenu, ne touche PAS
      `is_question_recall_eligible` ni `normalize_recall_text` ni la seam `score_answer` (lot 7),
      ne modifie pas les RPCs de soumission (elles appellent déjà `score_recall_answer`). Inclut le
      **cadrage du type `content_reports.recall_false_negative`** (enum + acceptation serveur) —
      **sans** la file admin (lot 6, Q-3). Sécurité : prouver que `accepted_answers` n'est jamais
      côté client (audit whitelist + smoke) **avant** de clore le lot.
- [ ] **Lot 2 — Tier A : expansion morphologique déterministe (corpus entier).** Périmètre : une
      fonction **pure** (article ar/fr, contractions en), appliquée à toutes les questions éligibles,
      chaque variante gardée par R-4. Gros gain, faible risque, **sans IA**. **Critères** : US-2/R-2/
      R-4/R-5. **Stop-point** : Tier A ne produit QUE des variantes morphologiques mécaniques — aucune
      paraphrase sémantique (c'est le Tier B) ; mesurer le recul du gisement « article ».
- [ ] **Lot 3 — Tier B : skill de génération + pilote petites classes.** Périmètre : le skill
      `content-accepted-answers`, puis génération (paraphrases/synonymes/positions) sur la mission
      « التموقع في الفضاء » + arabes 1re–2e année + 2-3 témoins fr/en. **Critères** : US-1/US-6/R-2/
      R-4/R-5/R-7. **Stop-point** : pas de campagne globale ; mesurer et remonter avant d'étendre.
- [ ] **Lot 4 — Campagne Tier B (1 matière/PR).** Priorité produit. **Stop-point** : une matière par
      PR, jamais `content:build` nu (`--subject <id>`), revue de diff obligatoire.
- [ ] **Lot 5 — Aides de saisie arabe (petites classes).** **Stop-point** : livrable indépendant de la
      campagne complète.
- [ ] **Lot 6 (opt.) — Boucle refus contesté.** **Stop-point** : aucune écriture auto en base ;
      humain-dans-la-boucle.
- [ ] **Lot 7 — Type natif `short_answer` (moteur).** Périmètre : migration (CHECK étendu — aucune
      colonne nouvelle), branche seam `score_answer` + `answer_key_display` (recréations verbatim,
      pattern B1→B3), union zod + builder + QA autorat (R-12), extraction `FreeTextInput` +
      `answer-formats` + review, appariement télémétrique `expectedMistakes` (R-9) dans
      `submit_exercise_attempt`/`submit_dungeon_answer`, amendement de
      `docs/interactive-question-types.md` (le type rejoint le tableau, la clôture « no more Tier-B
      types » pointe vers la présente étude) et du `content-schema.md` de `content-engine`.
      **Critères** : US-7/R-3/R-4/R-9/R-11/R-12. **Stop-points** : ne réécrit AUCUNE des six RPCs de
      scoring hors le pattern verbatim+branche télémétrie ; ne convertit AUCUN QCM existant (D-10) ;
      n'authore aucun contenu (lot 8) ; migration d'abord (DoD §7) ; `is_question_recall_eligible`
      strictement inchangée (les `short_answer` n'entrent jamais en Rappel).
- [ ] **Lot 8 — Pilote contenu `short_answer` + doctrine skills.** Périmètre : autoriser le type
      dans les skills (doctrine R-13/R-14 : né-complet, mix ≤ ~1/3, jamais quiz école v1), authorer
      les chapitres témoins (une matière par PR), mesurer (signalements, `content-audit`).
      **Stop-point** : pas d'ouverture aux campagnes larges avant la mesure du pilote et l'accord de
      Mohamed sur la doctrine.

## 5. Stratégie de test

- **pgTAP** (lots 1 et 7) : `is_accepted_free_answer`/`score_recall_answer`/branche
  `short_answer` de `score_answer`, table-driven — canonique ✓, chaque variante de
  `accepted_answers` ✓, un distracteur / une erreur attendue ✗, vide/blanc ✗, variantes
  casse/espaces/tashkeel/chiffres ✓, clé malformée (`answer_key` sans `text`) ✗ sans exception, et
  le **cas défaut** `accepted_answers = '[]'` (identique étude 17). Choix documenté :
  l'anti-collision (R-4) est garantie **à la compilation** (`content:qa`), **pas** au scoring — le
  scoring fait confiance à l'ensemble déjà validé ; il n'existe donc aucune défense SQL runtime
  contre un ensemble empoisonné, ce qui **impose** que la garde QA soit bloquante
  (`content:qa:strict` en CI) et la revue humaine obligatoire (R-7). C'est le pendant exact de
  `correct_option`, elle aussi crue par le scoring et garantie juste en amont.
- **Unit (Vitest)** : règles `content:qa` (collision — distracteurs ET erreurs attendues —,
  charset, doublon, taille, contraintes d'autorat R-12, « nombre pur ⇒ numeric ») ; **parité
  TS↔SQL** de la normalisation sur un corpus fixe (le test qui garantit D-3) ; builder émet bien
  `accepted_answers` / `question_type='short_answer'` / `answer_key.mistakes` ; UI :
  `FreeTextInput` rendu par les deux branches (variant recall, type short_answer), char-bar, review.
- **Whitelist/sécurité** : test que `getExercise`/`get_recall_questions` ne renvoient jamais
  `accepted_answers` ni `answer_key` ; `smoke:shell` (bundle prod) inchangé vert.
- **e2e (TEST project)** : (volet A) rejouer une mission Rappel dont une question a
  `acceptedAnswers`, taper une **paraphrase** listée → session réussie ; taper un **distracteur** →
  faux (étend `e2e/authed/recall-mode.spec.ts`). (volet B, lot 8) jouer une mission classique
  contenant une `short_answer` : taper une variante acceptée → juste ; review affiche la canonique.
- **Non-régression** : les questions sans `acceptedAnswers` scorent exactement comme étude 17
  (défaut `'[]'`), prouvé par un cas pgTAP dédié ; les cinq types existants de la seam sont
  re-testés inchangés (suite pgTAP B1→B3 verte).

## 6. Risques & mitigations

- **RISK-1 — l'ensemble accepte une réponse en fait fausse (sur-tolérance).** Impact fort (détruit la
  valeur pédagogique). Mitigation : R-4 (anti-collision généralisée, erreur QA), double-solve du skill,
  revue de diff humaine obligatoire (R-7), ensemble borné (≤24). Précision toujours prioritaire sur le
  rappel (comme R-2 étude 17).
- **RISK-2 — divergence normalisation TS (QA) ↔ SQL (scoring).** Impact : une variante validée par la
  QA mais refusée en base (ou l'inverse). Mitigation : **normalisation faite uniquement en SQL au
  scoring** (D-3) ; la QA porte une réplique TS **testée pour parité** sur corpus fixe — CI casse à la
  moindre dérive.
- **RISK-3 — coût/qualité de génération à l'échelle (~12 400 questions).** Mitigation : passe
  **hors-ligne**, batchée par matière, priorisée (petites classes d'abord), non bloquante (défaut =
  canonique seule, jamais pire qu'aujourd'hui) ; couverture montée incrémentalement, mesurée.
- **RISK-4 — translittération latine ambiguë en arabe.** Mitigation : translittérations **mono-mot
  par défaut**, gardées par R-4 (pas de collision) ; multi-mot seulement si non ambigu ; sinon
  exclues de l'ensemble. Q-1 a tranché la portée (« tout », gardes maintenues).
- **RISK-5 — fuite de `accepted_answers`/`answer_key` au client.** Impact : oracle partiel.
  Mitigation : colonnes server-only, audit whitelist + smoke, `REVOKE` maintenu sur les trois
  fonctions de verdict — invariant testé aux lots 1 et 7.
- **RISK-6 — la campagne prend du retard et le mode reste punitif entre-temps.** Mitigation : lot 2
  traite **en premier** la population la plus touchée (petites classes) ; lot 6 (boucle refus
  contesté) amortit les angles morts résiduels ; KPI suivi.
- **RISK-7 — une `short_answer` mal dotée frustre dès la PREMIÈRE rencontre.** Plus aigu que le
  Rappel (qui vient après maîtrise du QCM) : l'élève n'a jamais vu la réponse. Mitigation : R-12
  (contraintes d'autorat bloquantes), R-13 (né-complet : ensemble livré à l'écriture, Tier A en
  filet), pilote mesuré avant doctrine large (lot 8), boucle refus contesté (lot 6) couvrant le
  type, et US-4 : l'explication reste affichée à la correction.
- **RISK-8 — sur-usage du type par les skills (missions entières en saisie libre, quiz gate école).**
  Impact : lassitude mobile, gate scolaire durci sans mesure. Mitigation : doctrine R-14 (mix
  ≤ ~1/3, jamais `quiz.json` école v1), revue de diff, `content-audit` vérifie la composition ;
  révision de doctrine seulement après le pilote.

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — translittérations latines des réponses arabes. ✅ ARBITRÉE 2026-07-15 : « tout ».** Portée =
  **tous les niveaux** (pas seulement les petites classes) et **toutes les langues arabes** du
  catalogue. La sûreté ne repose pas sur une limite de portée mais sur les **gardes correctionnelles
  maintenues** : chaque translittération générée passe l'anti-collision R-4 (écartée si elle égale un
  élément déclaré faux normalisé) et le double-solve du skill. Par défaut mono-mot ; le multi-mot
  n'est ajouté que lorsqu'il est **non ambigu** (une seule romanisation raisonnable) et non
  collisionnant — sinon écarté. Impacte Tier A/B (lots 2/3/4) et l'autorat `short_answer` (R-13).
- **Q-2 — budget/modèle de génération (Tier B seulement). ✅ ARBITRÉE 2026-07-16 : exécuteur +
  double-solve.** Le **Tier A** (article/contraction, gisement le plus gros) est **déterministe et
  gratuit** — aucun modèle. Seul le **Tier B** (paraphrases/synonymes sur les ~7 100 réponses
  ≥ 2 mots + 385 positionnels) consomme un modèle : **exécuteur bon marché (Sonnet ou équiv.) +
  double-solve**, batché une matière par PR, priorisé (petites classes d'abord), non bloquant
  (défaut = canonique seule) — la doctrine skills du repo ; la qualité est gardée par le
  double-solve, la QA anti-collision et la revue de diff, pas par le modèle. Le volet B n'ajoute
  **rien** à ce budget : les `short_answer` naissent complètes à l'autorat (R-13), dans le flux de
  génération normal des campagnes de contenu.
- **Q-3 — boucle « refus contesté » (lot 6) : maintenant ou différée ? ✅ ARBITRÉE 2026-07-15.** Cadrer
  le **type `content_reports.recall_false_negative`** dès le **lot 1** (schéma/enum + acceptation
  serveur) ; livrer la **file admin** (`/admin/content-reports` filtré) et la procédure d'ajout de
  variante **après la campagne pilote** (lot 6), quand le volume réel est connu.
- **Q-4 — élargir l'éligibilité Rappel (R-6) aux questions aujourd'hui exclues ? ✅ ARBITRÉE
  2026-07-16 : non — hors-v1 confirmé.** `is_question_recall_eligible` reste strictement identique
  (aucune question éligible ne disparaît, R-6). À rouvrir seulement si les KPI de couverture et de
  satisfaction de la campagne le justifient (nécessiterait de générer des ensembles pour des
  questions jamais servies en Rappel).
- **Q-5 — conversion sélective de QCM existants en `short_answer` ? ✅ ARBITRÉE 2026-07-16 : non en
  v1.** Le volet B vise le contenu **nouveau** (D-10) ; on mesure d'abord le pilote (lot 8). Si une
  campagne de conversion ciblée est souhaitée ensuite (les QCM dont `content-audit` juge les
  distracteurs artificiels, à réauthorer en questions libres), elle se fera uniquement par
  **remplacement authored** (nouvelle question dans le fichier, l'ancienne retirée — la compilation
  prune), jamais par mutation de type in-place, pour préserver distracteurs/télémétrie/historique
  d'attempts.

## 8. Journal d'exécution

- 2026-07-16 — amendement de l'étude (demande Mohamed) : **volet B « questions libres sans réponses
  proposées »** — type natif `short_answer` corrigé par le même jeu de réponses acceptées (helper
  commun D-9, seam étude 03, contraintes d'autorat R-12, né-complet R-13, doctrine R-14, lots 7–8) ;
  **renommage** `recallAnswers` → `acceptedAnswers` / `recall_answers` → `accepted_answers` / skill
  `content-accepted-answers` (D-6) ; R-4 généralisée aux `expectedMistakes` ; Q-5 ouverte ; annexe
  §9 complétée (volet B). Aucun lot démarré — le renommage est sans coût. PR #444.
- 2026-07-16 — **Q-2, Q-4, Q-5 arbitrées par Mohamed** (toutes sur les recommandations : Tier B =
  exécuteur bon marché + double-solve ; éligibilité Rappel inchangée, élargissement hors-v1 ;
  aucune conversion de QCM en v1, remplacement authored seulement si rouvert plus tard) → statut
  **validée**, prête pour l'exécuteur (lot 1). Aucun lot démarré.

_(à remplir lot par lot par l'exécuteur : date, lot, PR, écarts acceptés, dettes.)_

## 9. Annexe — mesure du corpus (recensement exhaustif, 2026-07-15)

**Méthode** : recensement **exhaustif** (pas d'échantillon) des 3 204 fichiers `quiz.json` +
`exercices/*.json` (76 sujets, ar/fr/en, tous niveaux) = **18 669 questions QCM**. Éligibilité
calculée par **portage fidèle 1:1 en JS de la fonction SQL déployée**
`is_question_recall_eligible` (a→i) + `normalize_recall_text` (`…/scratchpad/recall_exact.mjs`,
aucun fichier du dépôt modifié).

### Volumétrie

| Mesure                                  | Valeur     | %                        |
| --------------------------------------- | ---------- | ------------------------ |
| Questions QCM totales                   | **18 669** | 100 %                    |
| **Éligibles Rappel** (règle SQL exacte) | **12 349** | 66,1 % des QCM           |
| — prompt positionnel/localisation       | 385        | 3,1 % des éligibles      |
| — bonne réponse **≥ 2 mots**            | **7 137**  | **57,8 %** des éligibles |
| — bonne réponse 1 mot                   | 5 212      | 42,2 % des éligibles     |

| Langue | QCM    | Éligibles | Taux   | Positionnels | ≥2 mots | réponse en « ال »  |
| ------ | ------ | --------- | ------ | ------------ | ------- | ------------------ |
| **ar** | 12 435 | 8 556     | 68,8 % | 300          | 5 219   | **1 833 (21,4 %)** |
| **fr** | 3 636  | 2 145     | 59,0 % | 43           | 1 101   | —                  |
| **en** | 2 598  | 1 648     | 63,4 % | 42           | 817     | —                  |

### Lecture décisive pour l'architecture

Le portail d'éligibilité **et** la normalisation neutralisent DÉJÀ tout ce qui est typographique :
espacement, accents latins, hamza/ة/ى, tashkeel, ponctuation, système de chiffres. **Le faux
négatif résiduel est donc PUREMENT LEXICAL / MORPHOLOGIQUE / SYNTAXIQUE** — c'est exactement ce que
l'ensemble accepté doit couvrir. Trois gisements, par ordre de volume :

1. **Réponses ≥ 2 mots (7 137 ; 57,8 % des éligibles)** — reformulations multiples (synonyme, ordre,
   mot-outil ajouté/omis). Cible de la **génération sémantique (Tier B, IA + revue)**.
2. **Article défini (systématique)** — arabe « ال » : **1 833 réponses ar (21,4 % des éligibles ar)**,
   dont 1 004 aussi ≥ 2 mots ; **équivalent français** `le/la/l'` ajouté/omis (ex. 7-8 ci-dessous) ;
   **contractions anglaises** `they're`/`can't` vs formes pleines (ex. 10-11). Cible de la **génération
   morphologique déterministe (Tier A, SANS IA)** — voir §3.
3. **Positionnels (385 ; 3,1 %)** — peu nombreux mais **quasi tous à risque** (locution prépositionnelle
   à formulations concurrentes `في`/`داخل`, `on/in`, `dans/à`) ; échappent à la condition (g) d'éligibilité.

### Exemples concrets de faux négatifs (extraits — 12 relevés au total)

| #   | Fichier                                                                            | Bonne réponse          | Reformulations JUSTES refusées       |
| --- | ---------------------------------------------------------------------------------- | ---------------------- | ------------------------------------ |
| 2   | `math-1ere/07-reperage-espace/exercices/01-pratique.json` (ar)                     | داخل الصندوق           | في الصندوق · الصندوق                 |
| 4   | `eveil-scientifique-6eme/05-milieu-chaines-alimentaires/quiz.json` (ar)            | النبات الأخضر          | نبات أخضر (sans article)             |
| 5   | `culture-generale-politique-ar/01-institutions-et-regimes/exercices/02-boss.json`  | السلطة القضائية        | القضائية · سلطة قضائية               |
| 7   | `culture-generale-dungeon-fr/01-donjon-multi-themes/exercices/01-donjon-boss.json` | Afrique                | l'Afrique (article ajouté)           |
| 8   | idem                                                                               | Le Conseil de sécurité | Conseil de sécurité (sans article)   |
| 10  | `anglais-a1/01-verb-to-be/exercices/04-defi.json`                                  | They're on the table.  | They are on the table · On the table |
| 11  | `anglais-c1/03-modals-deduction/exercices/02-revision.json`                        | can't have             | cannot have                          |
| 12  | `english/09-reading-comprehension-writing/exercices/01-pratique.json`              | very clean             | clean · extremely clean (synonymes)  |

**Réserve** : la règle d'éligibilité est exacte (1:1 SQL) ; les axes positionnel/≥2 mots/« ال » sont
des **heuristiques de repérage de risque**, pas la logique de scoring — le taux réel de refus
dépendra des réponses effectivement tapées par les élèves (d'où le lot 6, boucle d'apprentissage).

### Volet B — l'offre de types côté saisie libre (constat, 2026-07-16)

Le même recensement éclaire le problème B : les 18 669 questions **texte** sont **100 % QCM** — la
saisie libre n'existe dans le catalogue que pour les nombres et la manipulation (~39 questions
natives `numeric`/`ordering`/`matching`/`multi` au recensement de l'étude 17, §9). Il n'y a **aucune
voie d'autorat** pour une question à réponse textuelle courte sans propositions ; le mode Rappel n'en
tient lieu qu'après maîtrise du QCM et pour les 66,1 % éligibles. Le volet B ne crée **pas un moteur
de plus** : il branche un consommateur de plus (la seam `score_answer`, 6 sites ; `<QuestionInput>`,
3 surfaces) sur le socle du volet A — normalisation (étude 17), ensemble accepté + anti-collision +
QA + skill (présente étude). Les contraintes d'autorat R-12 reprennent une à une les bornes
mesurées de l'éligibilité R-2 (≤ 60 c., ≤ 6 mots, charset tapable, auto-suffisance) : ce que le
rejeu filtrait a posteriori, l'autorat le garantit à la naissance.

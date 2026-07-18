# Étude 22 — Parcours élève & progression pédagogique (doctrine de navigation, déblocage, cohortes)

> **Statut** : validée — Q-1…Q-5 arbitrées le 2026-07-18 par Mohamed, toutes sur les
> recommandations (§7) ; les lots 1–6 sont exécutables
> **Priorité** : 22 · **Valeur** : un parcours élève cohérent, lisible et motivant — la doctrine
> unique qui répond à « qu'est-ce qui est ouvert, qu'est-ce qui est verrouillé, et pourquoi » ·
> **Complexité** : moyenne
> **Architecte** : Fable, 2026-07-17 · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : études 15 (livrée — composition des écrans), 16 (lots 0-3 livrés — sections
> lycée), 17 (livrée — Rappel) ; **s'articule avec** 04 (adaptatif), 05 (duels/ligues), 07
> (knowledge graph) sans les redéfinir · **Bloque** : rien de dur — informe 02 (examen blanc)
> et 08 (analytics familles)
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `docs/content-voice-and-composition.md`
> (gabarits d'écrans), `docs/lycee-architecture.md`, `docs/guide-duels-et-ligues.md`,
> `docs/guide-rappel-actif.md`

## 1. Contexte & objectif produit

### 1.1 Le problème

Les règles de progression de la plateforme **existent mais ne forment pas une doctrine** : elles
sont éclatées entre quatre études (15, 17, 05, 04), des constantes (`gamification.ts`), des RPC
SQL et des choix d'UI implicites. Résultat mesuré sur le code (cartographie complète en annexe A) :

1. **Une incohérence frontale** : la carte `/parcours` (`src/features/parcours/journey.ts`,
   `buildSubjectNodes`) verrouille visuellement chaque matière tant que la précédente n'est pas
   « commencée » (≥ 1 tentative) — alors que le hub matière, le catalogue `/programme` et le
   serveur n'imposent **aucun** verrou de ce type. Le même contenu est « verrouillé » sur un
   écran et librement jouable sur l'écran d'à côté. Une carte qui ment détruit la confiance
   dans tous les vrais verrous.
2. **Une boucle de révision cassée** : `spaced_repetition_schedule` reçoit des items à J+1/J+3/J+7
   après chaque échec (< 60 %), mais (a) **aucune ligne ne passe jamais à `completed`** — rejouer
   l'exercice n'y touche pas — et (b) le dashboard calcule `pendingSpacedReps` côté serveur
   (`getSprint2Dashboard`) **sans jamais l'afficher**. La révision est promise par les données et
   absente du produit.
3. **Un donjon pédagogiquement incohérent** : `get_dungeon_questions` tire ses questions de
   **tout le catalogue, tous niveaux confondus** (seul filtre : la difficulté par étage). Un
   élève de 3ᵉ année de base peut recevoir une question de bac ; un bachelier, une question de
   primaire. Le duel, lui, est correctement scopé au parcours.
4. **Aucune notion de cohorte scolaire** : le classement global mélange une 6ᵉ année et un
   bachelier sur l'XP cumulée ; la ligue hebdo est un classement unique global. « Être bien
   classé parmi les élèves de ma classe » — la comparaison la plus motivante et la plus légitime
   pour un élève et un parent — n'existe nulle part.
5. **Aucune gestion du passage d'année** : rien ne fait passer un élève de 7ᵉ en 8ᵉ à la rentrée.
   Avec le jalon « rentrée sept. 2026 », chaque compte actif pointera silencieusement sur sa
   classe de l'an dernier.
6. **Des scories** : objectifs `10_min` / `maintain_streak_5` déclarés en constantes mais jamais
   créés ni incrémentés par le serveur ; constantes de scoring mortes (`SPEED_FACTOR_*`,
   `HALF_COIN_THRESHOLD_PCT`, `IDEAL_TIME_PER_QUESTION_S`) survivant au durcissement anti-rush.

À l'inverse, **ce qui marche est solide** : le quiz de compréhension (≥ 80 % non précipité) est
un verrou serveur propre et compris ; l'accès au contenu est libre et public (pivot 2026-06-21) ;
le Rappel (étude 17) et les duels (étude 05) ont des règles nettes ; la composition des écrans
est normée (étude 15). L'étude 22 ne réinvente pas : elle **formalise la doctrine, répare les
incohérences et comble les trous** (cohortes, rentrée, révision).

### 1.2 Objectif & indicateurs

**Objectif produit** : qu'un élève (et son parent) puisse répondre en une phrase à « où j'en
suis, qu'est-ce que je fais maintenant, pourquoi ceci est verrouillé » — et que la réponse soit
la même sur tous les écrans.

KPI mesurables (instrumentation : logger structuré + `question_attempts` existants) :

- **Rétention J7 / J30** des nouveaux inscrits (la doctrine sert d'abord la rétention).
- **Taux de passage du quiz de compréhension** au 1ᵉʳ essai et au ≤ 3ᵉ essai (santé du verrou :
  s'il s'effondre, le contenu ou le seuil est mal calibré — pas la doctrine).
- **% d'élèves avec ≥ 1 session de révision/semaine** (item SM-2 clos ou mission d'une classe
  antérieure) — aujourd'hui non mesurable, la boucle étant cassée.
- **% de comptes actifs promus** dans la fenêtre de rentrée (cible : > 80 % avant le 31 oct.).
- **Profondeur de la cohorte** : médiane d'élèves classés par grade (déclenche Q-1/Q-5).

### 1.3 Réponses de l'étude aux questions posées (contrat de lecture)

| #   | Question                                                        | Réponse (résumé)                                                                                                                                                                                                                                                                                                                                                            | Où                  |
| --- | --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| 1   | L'élève : niveau fixe ou liberté totale ?                       | **Les deux, hiérarchisés** : un élève = un **parcours actif** (ancre pédagogique et sociale, choisi à l'inscription) + une **liberté totale de navigation** sur tout le catalogue. L'ancre définit le foyer (dashboard, carte, duels, donjon, cohorte) ; elle ne restreint jamais l'accès.                                                                                  | D-1, R-1…R-4        |
| 2   | Choix du niveau à l'inscription → parcours par défaut ?         | **Oui — déjà le cas** (onboarding → parcours → grade dérivé). L'étude fixe le sens du choix : « **la classe que tu prépares cette année** » (pas celle qu'on vient de finir), avec le micro-texte qui lève l'ambiguïté « j'entre en 7ᵉ, j'ai fini la 6ᵉ » → choisir 7ᵉ. Pas de test de placement en v1.                                                                     | R-2, US-1           |
| 3   | Réviser les niveaux précédents tout en explorant le supérieur ? | **Oui aux deux, sans switch** : toute classe est consultable et praticable (XP comprise) sans changer de parcours actif. La révision gagne une surface dédiée (bloc « Réviser » + révision du jour) ; l'avance reste possible mais non promue.                                                                                                                              | R-17…R-21           |
| 4   | Accès libre à tout, ou conditions de déblocage ?                | **Accès libre par défaut** ; exactement **trois verrous**, tous serveur : quiz de compréhension (pédagogique), verrous d'arène du donjon (engagement), maîtrise 100 % pour le Rappel (dépassement). Rien d'autre — et la carte cesse de simuler un 4ᵉ verrou.                                                                                                               | R-5…R-12            |
| 5   | Prérequis avant d'ouvrir une mission ?                          | **Un seul prérequis pédagogique** : le quiz du chapitre ≥ 80 % non précipité (thème scolaire uniquement). Ni ordre de chapitres, ni score minimal sur la mission précédente, ni prérequis de compétences (doctrine étude 07 : diagnostic, jamais blocage).                                                                                                                  | R-7, R-10           |
| 6   | L'ordre des exercices est-il important ?                        | **Recommandé, jamais imposé** : quiz d'abord (verrou), puis échelle ⭐ → ⭐⭐⭐⭐ affichée et triée — mais toute mission déverrouillée est jouable dans n'importe quel ordre.                                                                                                                                                                                               | R-12…R-15           |
| 7   | Jusqu'où autoriser la liberté ?                                 | Principe unique : **« on verrouille un geste pédagogique précis, jamais le programme »**. La liberté s'arrête aux trois verrous de la réponse 4 ; tout le reste est du guidage (chemin visible, « Reprendre ici », révision du jour).                                                                                                                                       | D-2, R-10           |
| 8   | Révisions, rattrapage, avance ?                                 | Révision : accès libre + boucle SM-2 **réparée** + « Révision du jour » (étude 04-A1, priorité réaffirmée). Rattrapage : rejouer (anti-farm improved-only) + remédiation 04-A2/07. Avance : libre, jamais automatique, le parcours actif ne bouge que par choix explicite (ou bannière de rentrée).                                                                         | R-17…R-21, D-6, D-7 |
| 9   | Classements, ligues, duels : organisés par quoi ?               | **Duels : par parcours** (existant, inchangé). **Classement : + cohorte de classe** (nouvel onglet « Ma classe » par grade) à côté du global et du par-matière. **Ligues : globales par centile v1** (équitables par construction), segmentation par classe = évolution conditionnée au volume. **Donjon : scopé au parcours actif** (fallback élargi si pool insuffisant). | R-22…R-26, D-8      |
| 10  | Impact gamification / motivation / rétention ?                  | Analysé règle par règle en §2.6 : l'autonomie (liberté) nourrit la motivation intrinsèque, le quiz gate protège le sentiment de compétence, les cohortes créent l'appartenance — les trois piliers de l'autodétermination. La boucle quotidienne (streak + ring + objectifs + révision due) et hebdo (quêtes + ligue) sont explicitées.                                     | §2.6                |

### 1.4 Ce que l'epic ne cherche PAS à faire

- **Pas de nouveau moteur adaptatif** : la sélection intelligente d'exercices reste l'étude 04
  (A1 : révision du jour ; A2 : points faibles ; A3 : gelé) et la maîtrise par compétence
  l'étude 07. L'étude 22 leur prépare la place (priorités, surfaces) sans les implémenter.
- **Pas de refonte d'écrans** : la composition (blocs, budgets, registres) reste la charte de
  l'étude 15 ; on ajoute des blocs conformes aux gabarits, on n'en réordonne pas.
- **Pas de changement d'économie** : barèmes XP/pièces, anti-farm, seuils 60/80/100 inchangés
  (étude 09 instrumente, étude 15 R-10 verrouille `gamification.ts`).
- **Pas de communautés** (chat, groupes, classes virtuelles d'enseignant) : hors périmètre v1 ;
  les surfaces sociales restent le classement, la ligue, les duels et le lien famille.

## 2. Spécification fonctionnelle

### 2.1 Analyse comparative — quel modèle de progression ?

Quatre modèles types, évalués contre les contraintes réelles du produit (plateforme **publique
et gratuite** consultable sans compte ; catalogue **inégalement peuplé** — la 9ᵉ dense, d'autres
classes `coming_soon` ; 13 niveaux + sections lycée ; 3 audiences élève/parent/anonyme ;
doctrine déjà arbitrée « le quiz est le seul verrou de l'app », étude 15 US-3) :

| Modèle                                       | Description                                                                                  | Références                                      | Avantages                                                                                                                                                     | Inconvénients                                                                                                                                                                                                      | Verdict ici                                                                    |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| **A. Libre total**                           | Tout ouvert, zéro verrou, zéro chemin                                                        | Wikipédia, YouTube                              | Zéro friction, sert le SEO et la consultation                                                                                                                 | Aucune promesse pédagogique ; l'élève faible se perd ; « théorie avant pratique » non garanti ; gamification sans colonne vertébrale                                                                               | ❌ Abandonne le contrat pédagogique (le quiz gate existant a fait ses preuves) |
| **B. Guidé strict**                          | Chemin unique, chaque étape déverrouille la suivante                                         | Duolingo (path 2022), Kumon                     | Progression limpide, « next action » évidente, forte complétion                                                                                               | Frustration (un blocage = un mur) ; incompatible avec un usage « référence » sans compte ; punit la révision ciblée (« je veux juste réviser Thalès ») ; exige un contenu 100 % complet partout — faux aujourd'hui | ❌ Incompatible avec le pivot public/gratuit et l'état du catalogue            |
| **C. Semi-guidé à verrous multiples**        | Verrous par score/ordre/prérequis à chaque étage                                             | Beaucoup d'EdTech scolaires                     | Contrôle fin                                                                                                                                                  | Multiplicité de règles = illisibilité (« pourquoi c'est fermé ? ») ; coût serveur/UI de chaque verrou ; contredit l'étude 07 (diagnostic sans blocage)                                                             | ❌ La complexité des règles est le problème n° 1 actuel, pas la solution       |
| **D. Hybride « ancre + liberté + guidage »** | Un foyer par défaut, accès libre, verrous **rares et justifiés**, guidage par recommandation | Khan Academy (mastery non bloquante), Brilliant | Autonomie ET direction ; chaque verrou est explicable en une phrase ; robuste au contenu incomplet ; le guidage s'améliore sans migration (04/07 branchables) | Demande une discipline : chaque nouvel écran doit choisir « recommander » et non « verrouiller » ; la lisibilité repose sur la cohérence inter-écrans                                                              | ✅ **Retenu (D-1)** — c'est le modèle _de facto_ actuel, formalisé et réparé   |

**Modèle retenu (D-1)** — trois principes qui gouvernent toute décision future :

- **P1 — L'ancre** : tout élève a exactement un parcours actif — son foyer. Le foyer
  personnalise (dashboard, carte, duels, donjon, cohorte) ; il ne restreint jamais.
- **P2 — Les verrous rares** : un verrou n'existe que s'il protège un geste pédagogique précis,
  s'énonce en une phrase, et est tenu **côté serveur**. Il y en a trois (quiz, arène, Rappel).
  Tout écran qui « verrouille » sans RPC derrière est un bug de doctrine.
- **P3 — Le guidage par recommandation** : l'ordre est montré (chemin, ⭐, « Reprendre ici »,
  révision du jour), jamais imposé. La punition n'est jamais un outil de guidage.

### 2.2 Acteurs & parcours utilisateurs

Acteurs : **élève connecté** (rôle `student`, cœur de l'étude) · **visiteur anonyme**
(consultation + pratique publique, conversion) · **parent** (lecture seule via lien famille,
étude 08) · **admin** (consoles existantes, hors périmètre).

- **US-1 — Le nouvel inscrit.** À l'onboarding je choisis **la classe que je prépare cette
  année** (« J'entre en 7ᵉ » → je choisis 7ᵉ, même si je viens de finir la 6ᵉ — le libellé le
  dit explicitement). J'arrive sur mon dashboard : la bande focus me propose le **quiz du
  premier chapitre** de la première matière de ma classe. Je comprends en un écran : ma classe,
  mes matières, ma première action. (Fondé sur l'onboarding existant à 3 étapes ; ajout : copy
  R-2 + mention discrète « tu pourras réviser la 6ᵉ à tout moment ».)
- **US-2 — L'élève qui revient.** La bande focus m'offre, dans l'ordre de priorité R-31 : ma
  **révision due** s'il y en a une, sinon **reprendre** là où j'étais (dernier exercice raté ou
  prochaine mission du dernier chapitre travaillé), sinon le prochain jalon de mon chemin.
- **US-3 — L'élève en difficulté.** J'ai raté une mission (< 60 %) : je peux la rejouer
  immédiatement (seul un score amélioré paie — anti-farm existant) ; elle revient en révision à
  J+1/J+3/J+7 (boucle réparée R-19) ; le rejeu réussi **clôt** la révision. Les « Points
  faibles » (étude 04-A2) s'afficheront ici plus tard.
- **US-4 — L'élève en avance.** Je termine les chapitres disponibles de ma classe : je peux
  librement pratiquer la classe supérieure depuis `/programme` (le quiz gate s'y applique
  chapitre par chapitre, comme partout). Mon parcours actif ne change pas tout seul ; ma
  cohorte de classement reste ma classe. (R-20)
- **US-5 — L'élève qui révise.** Depuis le dashboard, le bloc « Réviser » me propose ma classe
  précédente (un lien, pas un switch) ; j'y pratique normalement, j'y gagne XP et pièces
  (R-21). Ma progression dans ces matières est conservée si j'y reviens.
- **US-6 — La rentrée.** Entre le 1ᵉʳ sept. et le 31 oct., une bannière me demande « Tu passes
  en 8ᵉ ? » : un clic met à jour mon parcours actif (mécanique `set_current_parcours`
  existante) ; « Je reste en 7ᵉ » la ferme pour l'année (redoublement respecté, R-4). Rien
  n'est jamais changé silencieusement. Au lycée, la bannière m'amène au choix de section
  (drill-down étude 16 R-2).
- **US-7 — Le compétiteur.** Dans l'Arène : mes duels m'apparient à ma classe (existant) ; le
  donjon me sert des questions **de ma classe** (R-25, réparé) ; le classement m'offre « Ma
  classe » / « Global » / par matière (R-23) ; la ligue hebdo reste toutes classes confondues,
  équitable par centile (R-24).
- **US-8 — L'anonyme.** Je consulte tout (cours, résumés), je pratique via le flux public, le
  quiz gate s'applique en parité (`sessionStorage`) ; les surfaces de progression me montrent
  leur promesse verrouillée (« connecte-toi pour… », modèle étude 17 R-9). Aucune régression :
  cette étude n'ajoute **aucun** verrou à l'expérience publique.
- **US-9 — Le parent.** Je lis la progression réelle (chapitres complétés R-15/R-16 — enfin
  définis formellement, ce qui donne à l'étude 08 sa métrique de « progression » honnête).

### 2.3 Règles métier

#### Identité & ancrage

- **R-1 (existant, réaffirmé)** : tout élève a exactement **un parcours actif**
  (`profiles.current_parcours_id`, garde d'onboarding existante). Le parcours actif détermine :
  le dashboard et la carte (existant), le pool de duel (existant), **le pool du donjon
  (nouveau, R-25)** et **la cohorte de classement (nouveau, R-23)**. Il ne conditionne
  **aucun accès**.
- **R-2 (nouveau — copy normatif)** : le choix d'inscription et de changement de classe est
  toujours formulé « **la classe que tu prépares cette année** ». L'onboarding (étape
  Parcours) et `/niveau/$parcoursId` portent ce libellé (i18n §2.4). Pas de test de placement
  en v1 (évolution possible post-étude 07).
- **R-3 (existant étendu)** : changer de parcours est **libre, immédiat et sans perte**, à tout
  moment, via `/niveau/$parcoursId` (« choisir ce niveau »). Les acquis de profil (XP, niveau
  de héros, pièces, badges, série, inventaire) sont **globaux et conservés** ; la progression
  par matière (tentatives, quiz passés, Rappel) est **propre à chaque matière et jamais
  effacée** — on la retrouve intacte en revenant. Généralise l'étude 16 US-5/R-6 à tous les
  changements de parcours, pas seulement les sections.
- **R-4 (nouveau)** : **la promotion de rentrée est proposée, jamais imposée.** Fenêtre :
  du 1ᵉʳ septembre au 31 octobre (Q-3, arbitrée). Condition d'affichage : parcours actif scolaire ou
  concours avec grade non terminal, ET dernier choix de parcours antérieur au 1ᵉʳ septembre de
  l'année scolaire courante (`profiles.current_parcours_set_at`, §3). Actions : « Passer en
  \<classe suivante> » (un clic, RPC existante) · « Je reste en \<classe> » (ferme la bannière
  pour l'année — persistant côté client par saison, pas de colonne dédiée). Grade suivant =
  grade de `display_order` immédiatement supérieur du même thème ; entrée au lycée ou année à
  sections → la bannière route vers le drill-down année → section (étude 16 R-2). Bac terminal :
  pas de bannière v1 (Q-3).

#### Navigation & verrous

- **R-5 (existant, réaffirmé)** : la **consultation** (catalogue, cours, résumés, manuel) est
  libre pour tous, sans compte ni condition — c'est le pivot « plateforme de référence ». Seule
  une classe `coming_soon` est non cliquable (avec vote d'intérêt, existant).
- **R-6 (existant, formalisé)** : la **pratique** (missions, quiz) est libre sur **tout le
  catalogue disponible**, y compris hors parcours actif — toute classe antérieure ou
  supérieure — et récompensée normalement (R-21), sous les seuls verrous R-7/R-8/R-9.
- **R-7 (existant — LE verrou pédagogique)** : dans un **thème scolaire** (`grade_id` non
  nul), les missions d'un chapitre sont verrouillées tant que le **quiz de compréhension** du
  chapitre n'est pas réussi à **≥ 80 %** (`QUIZ_PASS_THRESHOLD_PCT`) **sans précipitation**
  (≥ 4 s/question). Serveur autoritaire (`start_exercise_session`), parité anonyme
  (`sessionStorage` + `score_quiz`). Les thèmes sans grade ne sont jamais quiz-gatés. Aucun
  changement — l'étude le consacre comme **l'unique** prérequis d'ouverture d'une mission.
- **R-8 (existant)** : les verrous du **donjon** sont des verrous d'**engagement d'arène**, pas
  de pédagogie : ≥ 2 matières et ≥ 3 chapitres tentés (`PREREQ`), niveau de héros ≥ 1
  (`LEVEL`), `min(niveau, 5)` runs/jour (`DAILY_LIMIT`). Inchangés.
- **R-9 (existant)** : le mode **Rappel** d'une mission s'ouvre à 100 % classique non précipité
  (étude 17 R-3). C'est un verrou de **dépassement** (contenu bonus), pas d'accès.
- **R-10 (nouveau — la clôture doctrinale)** : **aucun autre verrou n'existe ni ne sera ajouté
  sans amender cette étude** : pas d'ordre imposé entre chapitres, pas d'ordre entre missions,
  pas de score minimal pour « passer au suivant », pas de blocage par prérequis de compétences
  (doctrine étude 07 R-5 : le graphe **explique et recommande**, il ne bloque jamais), pas de
  gating par niveau de héros ou par XP sur le contenu. Tout verrou affiché doit correspondre à
  un refus serveur réel (P2).
- **R-11 (nouveau — réparation)** : la carte `/parcours` **cesse de verrouiller** : l'état
  `locked` (nœud non cliquable + cadenas si la matière précédente n'est pas « commencée ») est
  supprimé. États cibles d'un nœud : `done` / `current` (matière la plus récemment travaillée)
  / `next` (première matière du chemin sans tentative — halo « recommandé ») / `open`. Tous
  cliquables. L'état `premium-locked` (couronne) reste câblé mais dormant (phase gratuite).
- **R-12 (nouveau)** : **l'ordre recommandé est toujours visible, jamais contraignant** : ordre
  des matières sur la carte (`display_order`), ordre des chapitres dans le hub (accordéons,
  existant), échelle de difficulté des missions (R-13). Le guidage actif (bande focus,
  « Reprendre ici ») pointe toujours vers **une** action (étude 15 R-1 « action n° 1 »).

#### Ordre & états de complétion

- **R-13 (nouveau — affichage)** : dans le hub matière, chaque mission affiche sa **difficulté
  en étoiles** via un composant dédié (réutiliser `DifficultyStars`, aujourd'hui réservé au
  donjon) — plus seulement le ⭐ textuel du titre. Tri d'affichage dans un chapitre : le quiz
  d'abord, puis missions par (`difficulty`, `display_order`). Progression recommandée : quiz →
  ⭐ → ⭐⭐ → ⭐⭐⭐ (boss) → ⭐⭐⭐⭐ (défi). Libre choix parmi les missions déverrouillées.
- **R-14 (existant, formalisé — vocabulaire)** : une mission est **réussie** à ≥ 60 %
  (`PASS_THRESHOLD_PCT` — récompense, sous anti-farm) ; **maîtrisée** à 100 % non précipité
  (→ débloque son Rappel, étude 17). Ces deux mots sont le vocabulaire produit officiel (i18n).
- **R-15 (nouveau — définition)** : un **chapitre est complété** quand son quiz est passé (si
  le chapitre est quiz-gaté) **et** toutes ses missions `source='admin'` (hors quiz, hors
  variantes Rappel) sont **réussies** (≥ 60 %). Le hub affiche déjà `x/y` ; « complété »
  ajoute le jalon binaire (✓ de chapitre). Purement calculé — aucun verrou, aucune table.
- **R-16 (nouveau — définition)** : la **progression d'une matière** = chapitres complétés /
  chapitres publiés (pourcentage). La carte remplace son critère `done` actuel (moyenne de
  scores ≥ 80 %) par **progression = 100 %** ; l'anneau/pourcentage affiché sur le nœud et le
  hub utilisent cette même valeur. C'est la métrique de progression **officielle** — celle que
  le rapport parent (étude 08) et l'examen blanc (étude 02, remédiation) doivent consommer.

#### Révision, rattrapage, avance

- **R-17 (nouveau — surface)** : le dashboard porte un bloc passerelle « **Réviser** » (sous la
  passerelle « Découvrir » existante, gabarit QG de la charte) : lien vers la classe
  précédente (`/niveau/<parcours de la classe précédente>`) quand elle existe et a du contenu
  `available`. Un lien, pas un switch — le parcours actif ne bouge pas (R-1).
- **R-18 (articulation)** : la « **Révision du jour** » (sélecteur 1–3 exercices dus/faibles sur
  le dashboard) **est l'étude 04-A1** — l'étude 22 ne la duplique pas mais la **mandate** comme
  prochaine brique du parcours (§4, hors-lot) et lui réserve sa place dans la bande focus
  (R-31 priorité 1). Quand 07-lot 5 livrera `get_daily_plan` compétence-aware, il alimentera
  la même surface (couture officielle, étude 07).
- **R-19 (nouveau — réparation serveur)** : **la boucle SM-2 se referme** : quand un élève
  **réussit** (≥ 60 %, non précipité) un exercice ayant des lignes `spaced_repetition_schedule`
  en `pending`, `submit_exercise_attempt` les passe à `completed` (`completed_at = now()`,
  `retry_score_pct = score`). Un nouvel échec ultérieur ré-ouvre normalement un cycle (logique
  d'insertion existante inchangée, y compris le bouclier de re-tentative).
- **R-20 (nouveau — politique d'avance)** : l'avance sur le programme est **libre et
  silencieuse** : aucune UI ne pousse à sauter sa classe (pas de CTA « explore la suite »), mais
  rien ne l'empêche (R-6). Le parcours actif ne change **jamais** implicitement — ni par la
  navigation, ni par la pratique hors classe (seuls l'onboarding, `/niveau/$parcoursId` et la
  bannière de rentrée appellent `set_current_parcours`).
- **R-21 (existant, formalisé)** : **une seule économie** : XP, pièces, badges, série et niveau
  de héros sont gagnés à l'identique sur toute mission du catalogue, dans ou hors parcours
  actif (l'anti-farm improved-only borne l'abus ; risque résiduel → RISK-4).

#### Cohortes & compétition

- **R-22 (existant — étude 05, inchangé)** : les **duels** s'apparient strictement
  **intra-parcours** (même thème × même classe) ; le jeu de 5 questions est tiré du pool du
  parcours partagé.
- **R-23 (nouveau)** : le classement gagne un onglet « **Ma classe** » : cohorte = élèves de
  même `current_grade_id` (tous parcours de ce grade confondus — un « Concours 9ᵉ » et une
  « 9ᵉ » sont la même cohorte scolaire), classés sur l'XP totale, même shape et même RPC-modèle
  que le global (top 50 + ma ligne, filtre `xp > 0`, exclusion triche R-26). Élève sans grade
  (parcours libre) : l'onglet est masqué. État creux : narratif d'invitation (« sois le
  premier de ta classe », cold-start étude 15 D-7) — jamais de faux profils. Onglet par
  défaut (Q-1, arbitrée) : « Ma classe » dès que la cohorte compte ≥ 10 classés
  (`GRADE_TAB_DEFAULT_MIN_RANKED = 10`, à ajouter dans `gamification.ts` au lot 4), sinon
  « Global » — bascule automatique, silencieuse.
- **R-24 (existant, consacré v1)** : la **ligue hebdo de duels reste globale**, à paliers par
  **centile** (top 10 % diamant, etc.) — équitable par construction quel que soit le mélange
  de classes, car elle mesure l'activité et la réussite en duels (eux-mêmes appariés par
  classe), pas le niveau académique. Segmentation par classe = évolution de l'étude 05,
  conditionnée au volume (Q-5) — pas redéfinie ici.
- **R-25 (nouveau — réparation)** : le **donjon sert des questions du parcours actif** de
  l'élève (thème × grade, missions non-quiz), difficulté par étage inchangée. **Fallback de
  profondeur** (pool insuffisant à l'échelon courant) : < 60 questions distinctes non vues →
  élargir aux grades du même **cycle** (primaire/collège/lycée) ; < 30 → catalogue entier
  (comportement actuel). Le lobby énonce le pool (« Donjon de la 7ᵉ »), charte « enjeu avant
  le clic ».
- **R-26 (existant — étude 10, réaffirmé)** : toute surface classante (classements R-23,
  ligues, percentiles à venir de l'étude 02) applique l'exclusion silencieuse des comptes
  triche confirmés.

#### Gamification & lisibilité

- **R-27 (nouveau — vocabulaire)** : le **niveau de héros** (XP/200, classes de héros) et la
  **classe scolaire** (grade) sont deux notions **jamais confondues à l'écran** : « niveau »
  seul est banni des surfaces où l'ambiguïté est possible ; les dictionnaires FR/EN/AR fixent
  les termes (§2.4). Le niveau de héros est global et ne se « réinitialise » jamais (R-3).
- **R-28 (existant, formalisé)** : la **boucle quotidienne** = série (streak) + anneau du jour
  (100 XP) + objectif « 3 exercices » + (à venir, R-18) révision du jour ; la **boucle hebdo**
  = quête « 2 boss » + ligue de duels. L'étude 22 n'y ajoute rien — elle interdit d'y ajouter
  sans passer par l'étude 09 (économie).
- **R-29 (nouveau — hygiène)** : les objectifs déclarés mais jamais matérialisés (`10_min`,
  `maintain_streak_5` dans `DEFAULT_DAILY_OBJECTIVES`/`DEFAULT_WEEKLY_QUESTS`) et les
  constantes de scoring mortes (`SPEED_FACTOR_MIN/MAX`, `IDEAL_TIME_PER_QUESTION_S`,
  `HALF_COIN_THRESHOLD_PCT`, `SPEED_DEMON_THRESHOLD_S` étant, lui, vivant — vérifier) sont
  **purgés** (constantes + types + tests), pas implémentés. Décision : un objectif « minutes »
  exigerait un suivi de temps de session inexistant ; le supprimer est le choix DoD §3.
- **R-30 (nouveau — invariant UX)** : **tout verrou affiché énonce sa condition et son
  action** (« Réussis le quiz du chapitre → Passer le quiz » ; « Niveau de héros 1 requis →
  Gagne de l'XP » ; « 100 % en classique → Rejouer la mission ») — jamais de cadenas muet
  (charte étude 15, « enjeu avant le clic »). S'applique aux trois verrous R-7/R-8/R-9 et à
  l'état anonyme (promesse + connexion).
- **R-31 (nouveau — moteur de « prochaine action »)** : la bande focus du dashboard et le
  « Reprendre ici » du hub matière consomment **une même logique de priorité**, côté serveur :
  1. révision due (04-A1/`get_daily_plan` quand livrés ; d'ici là : plus ancien item SM-2
     `pending` échu),
  2. dernier exercice raté rejouable (`nextExerciseId` existant),
  3. prochaine mission du chemin recommandé (chapitre le plus avancé non complété : quiz si
     non passé, sinon première mission non réussie par ordre R-13),
  4. découverte (première matière sans tentative).
     Un seul CTA à la fois (étude 15 R-1). Implémentation : helper TS partagé (§3), pas de RPC.

### 2.4 i18n

- Langues : FR/EN/AR sur toutes les nouvelles clés ; RTL respecté (les nouveaux blocs héritent
  des primitives existantes ; la bannière de rentrée et l'onglet « Ma classe » sont du chrome
  UI → langue de l'UI ; les noms de classes réutilisent `name_fr/en/ar` des grades/parcours).
- Clés nouvelles (préfixes indicatifs, dictionnaires `src/lib/i18n/`) : `journey.nodeNext`,
  `hub.chapterComplete`, `hub.missionMastered`, `dashboard.reviseGateway`,
  `dashboard.backToSchool.*` (titre, corps, cta, stay), `leaderboard.myClassTab`,
  `leaderboard.myClassEmpty`, `dungeon.poolLabel`, copy onboarding R-2
  (`onboarding.parcoursThisYear`).
- Lexique (R-27) : FR « classe » (scolaire) vs « niveau de héros » ; EN « class/grade » vs
  « hero level » ; AR « القسم/المستوى الدراسي » vs « مستوى البطل ». Conforme au lexique
  trilingue de la charte (étude 15) — l'amender si un terme y manque.

### 2.5 Hors périmètre (v1)

Test de placement adaptatif à l'inscription (attend l'étude 07) · assemblage dynamique de
missions de révision (04-A3, gelé) · mode « discipline » parental verrouillant l'ordre (Q-4,
v2 éventuelle avec l'étude 08) · ligues par classe (Q-5, extension étude 05) · multi-parcours
actifs simultanés (l'ancre reste unique ; les thèmes libres restent accessibles sans switch
via `otherSubjects`/`/extras`) · notifications de révision due (s'ajoutera naturellement à
04-A1 ; l'infra push existe) · communautés/chat · examen blanc (étude 02).

### 2.6 Impact motivation / rétention (analyse, non normative)

- **Autonomie** (le besoin le plus fort de l'adolescent) : le modèle D préserve le choix à
  chaque instant — matière, chapitre, difficulté, réviser ou avancer. Les modèles B/C
  l'auraient sacrifié. La liberté totale (A) aurait sacrifié la **compétence perçue** : le quiz
  gate garantit qu'on n'échoue pas des missions faute d'avoir vu la théorie — l'échec reste
  attribuable à l'effort, pas à l'organisation de l'app.
- **Compétence** : l'échelle ⭐ visible (R-13) + les jalons de complétion (R-15/R-16) donnent
  des paliers atteignables et une progression « vraie » (chapitres complétés, pas une moyenne
  abstraite). Le Rappel (R-9) offre le dépassement aux plus forts sans rien fermer aux autres.
- **Appartenance** : la cohorte de classe (R-23) transforme le classement d'une échelle
  intimidante (un bachelier au sommet) en une comparaison légitime (« mes pairs ») — c'est
  aussi l'argument parent n° 1. Les duels intra-classe l'incarnaient déjà.
- **Boucles** : la quotidienne (R-28) crée l'habitude ; la révision due (R-18/R-19) lui donne
  un **motif pédagogique** de retour (aujourd'hui le retour n'est motivé que par le streak —
  fragile) ; l'hebdo (ligue, quête boss) structure la semaine ; la rentrée (R-4) est le moment
  de ré-engagement annuel — silencieuse aujourd'hui, ritualisée demain.
- **Risques motivationnels évités** : pas de mur de blocage (churn des modèles B/C) ; pas de
  « carte mensongère » (perte de confiance) ; pas de double économie ; pas de classement
  humiliant pour les petites classes (cohorte + centiles).

## 3. Architecture technique (décisions fermées)

### Modèle de données

**Une seule colonne nouvelle** (migration additive) :

```sql
-- 2026XXXX_parcours_set_at.sql — R-4 (bannière de rentrée)
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS current_parcours_set_at timestamptz;

COMMENT ON COLUMN public.profiles.current_parcours_set_at IS
  'Dernier set_current_parcours (R-4 étude 22) : la bannière de rentrée ne s''affiche que si ce choix précède le 1er septembre de l''année scolaire courante. NULL = jamais choisi depuis la migration (traité comme antérieur).';
```

Pas de nouvelle table. Pas de grant nouveau (colonne de `profiles`, RLS existante ; écriture
uniquement via la RPC ci-dessous). Complétion de chapitre/matière (R-15/R-16) : **calculée**,
jamais stockée.

### Server (RPC SQL + server fns)

1. **`set_current_parcours`** (patch, `CREATE OR REPLACE` — recopier la dernière version) :
   ajoute `current_parcours_set_at = now()` à l'UPDATE du profil. Aucun changement de
   signature.
2. **`submit_exercise_attempt`** (patch — recopier la **dernière** version,
   `20260714130000_recall_mode_rpcs.sql`, discipline du repo) : dans la branche « attempt
   réussi » (score ≥ 60 % et non précipité, variante `classic`), ajouter la clôture R-19 :

   ```sql
   UPDATE public.spaced_repetition_schedule
      SET status = 'completed', completed_at = now(), retry_score_pct = v_score_pct
    WHERE user_id = v_user AND exercise_id = p_exercise_id AND status = 'pending';
   ```

   (Avant le bloc d'insertion-sur-échec existant, qui reste inchangé.)

3. **`get_grade_leaderboard()`** (nouvelle RPC, `SECURITY DEFINER`, `GRANT EXECUTE TO
authenticated`) : même shape de sortie que `get_global_leaderboard` (rank, display_name,
   hero_class, level, xp, streak, avatar_tier, is_me), filtrée sur
   `profiles.current_grade_id = (grade de l'appelant)`, `xp > 0`, exclusion triche quand
   l'étude 10 livrera son mécanisme (même jointure que le global alors). Refuse (retour vide)
   si l'appelant n'a pas de grade. Limite `LEADERBOARD_LIMIT` + ligne de l'appelant.
4. **`get_dungeon_questions`** (patch R-25) : filtre du pool sur le `(theme_id, grade_id)` du
   parcours actif de l'appelant (résolu serveur, comme `match_duel`) ; compte les questions
   distinctes non vues éligibles au palier courant : `>= 60` → pool classe ; sinon `>= 30` au
   cycle (groupes de `display_order` des grades : 1–6 primaire, 7–9 collège, ≥ 10 lycée) →
   pool cycle ; sinon catalogue entier (comportement actuel). Renvoie aussi le niveau de pool
   servi (`pool_scope text` : `grade|cycle|all`) pour le libellé lobby (R-30) et le log.
5. **Server fns** (`createServerFn` existants, patchs) :
   - `getDashboard` : + `promotionSuggestion` (R-4 : `{ nextParcoursId, nextName, isSectionDrilldown }
| null`, calculé depuis grades/parcours + `current_parcours_set_at`), + `reviseGateway`
     (R-17 : parcours de la classe précédente `available`, sinon null). Fenêtre de rentrée :
     constante `BACK_TO_SCHOOL_WINDOW = { startMonth: 9, startDay: 1, endMonth: 10, endDay: 31 }`
     dans `gamification.ts` (fuseau Tunis, comme les semaines de ligue).
   - Helper partagé **`resolveNextAction`** (R-31) dans `src/features/quest/next-action.ts`
     (pur, testé unitairement), consommé par `getDashboard` (bande focus) et `getSubject`
     (« Reprendre ici ») — remplace la logique éclatée `nextExerciseId`/`continueSubject`/
     reprise du hub. Entrées : données déjà chargées par ces fns (aucun round-trip
     supplémentaire).
   - Helper partagé **`chapterCompletion`** (R-15/R-16) dans
     `src/features/quest/completion.ts` : `isChapterComplete(chapter, bestScores)` /
     `subjectProgressPct(chapters, …)` — consommé par `getSubject`, `getDashboard`
     (cartes matières), `journey.ts` (carte) et, plus tard, le rapport parent (étude 08).
6. **Aucun changement** à : `resolve_exercise_access` (gate premium dormant), quiz gate,
   `get_dungeon_access`, RPC duels/ligues, RPC Rappel.

### Client

- `src/features/parcours/journey.ts` — `buildSubjectNodes` : suppression du flag `unlocked`
  séquentiel ; états `done` (progression 100 % — R-16) / `current` / `next` / `open` /
  `premium-locked` (inchangé, dormant) ; tous les nœuds non-premium cliquables.
  `journey-map.tsx`/`path-node.tsx` : rendu de `next` (halo « recommandé »), suppression du
  cadenas hors premium ; sous-libellé = `progressionPct`.
- `src/features/quest/components/subject-hub.tsx` : ⭐ par mission (`DifficultyStars`
  déplacé vers `src/components/game/` partagé — il l'est déjà — importé ici), ✓ de chapitre
  complété (R-15), « Reprendre ici » branché sur `resolveNextAction`.
- `src/routes/_authenticated/dashboard.tsx` : bannière de rentrée (dismiss persistant
  `localStorage` `na9ra.backToSchoolDismissed.<annéeScolaire>`), bloc « Réviser » (passerelle,
  gabarit QG), bande focus branchée sur `resolveNextAction`.
- `src/routes/_authenticated/leaderboard.tsx` : onglet « Ma classe » (masqué si
  `current_grade_id` nul), empty-state narratif.
- `src/routes/_authenticated/onboarding.tsx` : copy R-2 (étape Parcours) + mention révision
  (US-1). `src/routes/_authenticated/dungeon.tsx` : libellé du pool (R-25/R-30).
- i18n : clés §2.4 dans les trois dictionnaires.

### Sécurité & anti-triche

Rien de nouveau n'est exposé : `get_grade_leaderboard` renvoie le même shape public que le
global (display_name, jamais d'UUID d'autrui — même politique) ; le scoping donjon et la
clôture SM-2 sont `SECURITY DEFINER` self-scoped comme leurs versions actuelles ; la bannière
de rentrée n'appelle que la RPC existante `set_current_parcours` (validation d'existence du
parcours inchangée). Aucun verrou client-only n'est ajouté (P2) ; aucune clé de réponse ne
change de surface.

### Observabilité

`logger` structuré : `journey.promotion_suggested` / `journey.promotion_accepted` /
`journey.promotion_declined` (rentrée, avec grades from→to) ; `dungeon.pool_scope` (grade/
cycle/all — mesure la profondeur réelle des pools) ; `leaderboard.grade_tab_viewed` ;
`review.sm2_closed` (compteur de clôtures R-19 — le KPI « révision » de §1.2).

### Décisions d'architecture (ADR)

- **D-1 — Modèle hybride « ancre + liberté + guidage »** (§2.1). Alternatives rejetées :
  libre total (A — abandonne le contrat pédagogique), guidé strict (B — incompatible
  public/gratuit/catalogue partiel), verrous multiples (C — illisible, contredit l'étude 07).
- **D-2 — Le quiz de compréhension reste l'unique verrou pédagogique** ; l'étude 22 le
  consacre (R-7/R-10) au lieu d'en ajouter. Alternative rejetée : verrou de palier ⭐⭐⭐
  (« réussir une ⭐⭐ avant le boss ») — séduisant côté RPG mais troisième régime de verrou à
  expliquer, contraire à P2/P3 et à l'arbitrage étude 15 US-3 (« le quiz est le seul verrou de
  l'app ») ; le tri + les étoiles (R-13) obtiennent le même guidage sans mur. Rouvrable
  uniquement par amendement de cette étude (Q-4 pour la variante parentale).
- **D-3 — La carte ne verrouille pas** (R-11) : un verrou purement visuel sans refus serveur
  est un mensonge d'interface. Alternative rejetée : « aligner le serveur sur la carte »
  (créer un vrai verrou séquentiel de matières) — contraire à D-2, et pédagogiquement faux
  (l'ordre des matières d'une classe est un choix d'affichage, pas une dépendance).
- **D-4 — La complétion se calcule, ne se stocke pas** (R-15/R-16) : dérivable des
  `attempts` en une requête déjà payée par `getSubject`/`getDashboard` ; une table de
  complétion créerait un cache à invalider sans bénéfice à l'échelle actuelle.
- **D-5 — La cohorte est le `grade`, pas le parcours** (R-23) : « ma classe » au sens
  scolaire (un élève « Concours 9ᵉ » et un « 9ᵉ » sont pairs) ; le parcours reste l'unité
  d'appariement des duels (pool de questions identique requis — étude 05). Alternative
  rejetée : cohorte par parcours — fragmenterait les 9ᵉ en deux files de classement.
- **D-6 — La promotion est un choix, jamais un batch** (R-4) : pas de job de septembre qui
  promeut tout le monde (redoublants, sections lycée et comptes dormants le rendent faux par
  construction) ; une bannière + la RPC existante suffisent. Alternative rejetée : champ
  « année scolaire d'inscription » + promotion calculée — complexité sans vérité terrain.
- **D-7 — Le donjon se scope par la donnée, pas par un verrou** (R-25) : on répare la
  pertinence du contenu servi (filtre + fallback), on ne touche pas aux verrous d'arène (R-8).
  Alternative rejetée : donjon par matière au choix — fragmenterait les pools et l'identité
  « boss rush toutes matières » du mode.
- **D-8 — Un seul moteur de « prochaine action »** (R-31), en TS partagé et non en RPC : les
  données nécessaires sont déjà chargées par les server fns appelantes ; une RPC dédiée
  ajouterait un aller-retour et un point de divergence. `get_daily_plan` (études 04/07) s'y
  branchera comme **source de la priorité 1**, pas comme remplaçant.

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                                                                                                                         | fichiers/objets principaux                                                                     | tests exigés                                                           | dépend de                       |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------- |
| 1   | Doctrine visible : carte sans faux verrou, états `next`/`done` par complétion, ⭐ dans le hub, ✓ chapitre, helpers complétion                            | `journey.ts`, `journey-map.tsx`, `path-node.tsx`, `subject-hub.tsx`, `quest/completion.ts`     | unit (journey, completion, hub)                                        | —                               |
| 2   | Boucle SM-2 refermée (R-19)                                                                                                                              | migration `CREATE OR REPLACE submit_exercise_attempt`                                          | pgTAP (clôture, non-régression insertion/shield)                       | —                               |
| 3   | Rentrée & copy d'ancrage (R-2, R-4, R-17) : colonne `current_parcours_set_at`, patch `set_current_parcours`, bannière, bloc « Réviser », copy onboarding | migration additive + patch RPC, `dashboard.tsx`, `dashboard.server.ts`, `onboarding.tsx`, i18n | pgTAP (RPC), unit (fenêtre, suggestion, gateway), e2e léger (bannière) | —                               |
| 4   | Cohorte de classe (R-23) : RPC `get_grade_leaderboard` + onglet « Ma classe »                                                                            | migration RPC + grants, `dashboard.server.ts`, `leaderboard.tsx`, i18n                         | pgTAP (RPC, shape, filtre, vide sans grade), unit (onglet)             | —                               |
| 5   | Donjon scopé (R-25) : patch `get_dungeon_questions` + fallback + libellé lobby                                                                           | migration RPC, `dungeon.tsx`, i18n                                                             | pgTAP (scoping, fallbacks 60/30, `pool_scope`)                         | —                               |
| 6   | Moteur « prochaine action » unifié (R-31) + hygiène (R-29)                                                                                               | `quest/next-action.ts`, `dashboard.server.ts`, `quest.server.ts`, purge `gamification.ts`      | unit (priorités 1–4, purge sans référence morte)                       | lots 1–2 (états qu'il consomme) |

- [ ] Lot 1 — Doctrine visible (carte + hub + complétion)
- [ ] Lot 2 — Boucle SM-2 refermée
- [ ] Lot 3 — Rentrée & copy d'ancrage
- [ ] Lot 4 — Cohorte de classe
- [ ] Lot 5 — Donjon scopé au parcours
- [ ] Lot 6 — Prochaine action unifiée + hygiène

Chaque lot : périmètre fermé ci-dessus, critères d'acceptation = les R-x référencées, DoD
intégral (migrations additives avant le code dépendant, grants explicites — seule la RPC du
lot 4 en crée). **Stop-points** : lot 1 ne touche pas au serveur ; lot 2 recopie la dernière
version de la RPC (jamais une antérieure — vérifier `recall_mode_rpcs` ou plus récent) ; lot 3
n'implémente **aucune** promotion automatique ; lot 4 n'invente pas de périodicité hebdo
(XP totale seulement) ; lot 5 ne touche pas à `get_dungeon_access` ; lot 6 ne crée pas de RPC.

**Hors-lot (mandat de programme)** : après ces six lots, la prochaine brique du parcours élève
est **l'étude 04-A1 (« Révision du jour »)**, qui remplit la priorité 1 de R-31 — recommandation
d'ordonnancement à l'index FableEtudes, pas un lot de cette étude.

## 5. Stratégie de test

- **Unit (Vitest, co-localisés)** : `journey.ts` (états sans verrou, `next` unique, premium
  intact), `completion.ts` (chapitre complété avec/sans quiz gate, matières vides),
  `next-action.ts` (les 4 priorités + absences), fenêtre de rentrée (bornes, fuseau, dismiss),
  onglet classement (masquage sans grade).
- **pgTAP** (toute logique SQL — DoD) : clôture SM-2 (pending→completed au succès, intact sur
  échec/rush, ré-ouverture après nouvel échec, shield inchangé) ; `get_grade_leaderboard`
  (filtre grade, `xp > 0`, vide sans grade, `is_me`) ; `get_dungeon_questions` (scope classe,
  fallback cycle à < 60, fallback all à < 30, difficulté par étage inchangée) ;
  `set_current_parcours` (timestamp posé, comportement existant intact).
- **e2e (projet TEST)** : parcours US-2 (focus → mission), bannière de rentrée (affichée/
  fermée), onglet « Ma classe ». Les specs publiques existantes prouvent la non-régression de
  l'expérience anonyme (aucun verrou ajouté — R-5/US-8).
- **Non-régression clé** : les specs quiz-gate existantes (serveur + hub + anonyme) doivent
  passer **inchangées** — preuve que la doctrine n'a pas bougé le verrou central.
- `smoke:shell` si le bundle prod est touché (lots 1/3/4/6 — routes).

## 6. Risques & mitigations

- **RISK-1 — Cohortes creuses en bêta** (peu d'élèves par classe) : empty-states narratifs
  (jamais de podium vide), onglet par défaut arbitré Q-1, log `grade_tab_viewed` pour mesurer
  avant de promouvoir l'onglet.
- **RISK-2 — La carte « perd sa quête »** (le déverrouillage séquentiel donnait un but) :
  compensé par l'état `next` (halo recommandé), le ✓ de complétion (R-15) et la progression
  honnête (R-16) — la carte gagne un **objectif** (compléter) en perdant un **mur**.
- **RISK-3 — Pools de donjon insuffisants** dans les petites classes : fallback à double
  palier (R-25) + log `pool_scope` ; si `all` domine sur une classe, c'est un signal de
  contenu (backlog génération), pas un retour en arrière.
- **RISK-4 — Farm d'XP sur les classes faciles** (R-21 : tout paie) : borné par
  l'improved-only (rejouer sans progresser = 0) et le pool fini de missions ; la cohorte R-23
  n'aggrave rien (le farmeur reste classé dans sa classe). Surveillance : étude 09
  (instrumentation), sanction : étude 10. Pas de nerf préventif.
- **RISK-5 — Bannière de rentrée à contretemps** (redoublement, inscription tardive) :
  jamais d'action silencieuse, « Je reste en X » en un clic, condition `current_parcours_set_at`
  (un choix fait pendant la fenêtre ne re-déclenche rien), fenêtre bornée (Q-3).
- **RISK-6 — Collision avec les lots 04-A1/07-5** s'ils livrent en parallèle : la couture est
  définie (R-18, D-8 : `get_daily_plan` = priorité 1 de `resolveNextAction`) ; le lot 6
  garde l'interface prête (priorité 1 pluggable). Divergence → STOP & escalade (règle
  FableEtudes).

## 7. Questions ouvertes (pour l'humain)

> **Section arbitrée le 2026-07-18 (Mohamed) — toutes les décisions ont suivi les
> recommandations.** L'étude est passée `validée` ; aucune question n'est plus ouverte.

- **Q-1 — Onglet de classement par défaut** : « Ma classe » ou « Global » ? Recommandation :
  « Ma classe » par défaut dès qu'elle compte ≥ 10 classés, sinon « Global » (bascule
  automatique, silencieuse).
  **Arbitrage : recommandation retenue** — seuil ≥ 10 classés (`xp > 0`) dans la cohorte du
  grade ; sous le seuil, « Global » reste le défaut et l'onglet classe montre son état
  d'invitation. R-23/lot 4 appliquent ce seuil (constante `GRADE_TAB_DEFAULT_MIN_RANKED = 10`
  dans `gamification.ts`).
- **Q-2 — Donjon scopé (R-25)** : confirmer l'abandon du tirage toutes-classes actuel (un
  élève ne recevra plus de questions très au-dessus/au-dessous de sa classe hors fallback).
  Recommandation : oui — c'est un défaut de pertinence, pas une feature de découverte.
  **Arbitrage : oui** — R-25 confirmée telle quelle (scope parcours, fallbacks 60/30,
  `pool_scope` affiché et loggé). Le lot 5 est ferme.
- **Q-3 — Fenêtre de rentrée** : bornes exactes (recommandation : 1ᵉʳ sept. → 31 oct., fuseau
  Tunis) et comportement pour un bac terminal (recommandation v1 : aucune bannière ;
  félicitations post-bac = idée étude 02/08).
  **Arbitrage : recommandation retenue** — fenêtre du 1ᵉʳ septembre au 31 octobre, fuseau
  Tunis ; aucune bannière pour un bac terminal en v1. R-4 et `BACK_TO_SCHOOL_WINDOW` sont
  fermes. Le lot 3 est ferme.
- **Q-4 — « Mode discipline » parental** (un parent verrouille l'ordre des chapitres pour son
  enfant) : hors périmètre v1 (D-2). À réétudier avec l'étude 08 ? Recommandation : non tant
  qu'aucune demande utilisateur documentée n'existe.
  **Arbitrage : non** — hors périmètre confirmé ; la doctrine D-2/R-10 (« trois verrous, rien
  d'autre ») reste entière. Ré-ouverture uniquement sur demande utilisateur documentée, via
  l'étude 08.
- **Q-5 — Ligues par classe** : seuil de volume pour segmenter la ligue hebdo par grade
  (extension étude 05). Recommandation : ne rien faire sous ~200 duellistes actifs/semaine ;
  re-évaluer au signal.
  **Arbitrage : recommandation retenue** — aucune segmentation sous ~200 duellistes actifs
  par semaine ; réévaluation au signal, comme extension de l'étude 05 (R-24 inchangée).

## 8. Journal d'exécution

- **2026-07-18 — Validation.** Q-1…Q-5 arbitrées par Mohamed (toutes sur les
  recommandations) ; statut `brouillon` → `validée`. Aucun lot commencé.

_(à remplir par l'exécuteur, lot par lot : date, lot, PR, écarts acceptés, dettes notées)_

---

## Annexe A — État des lieux exhaustif (cartographie du code, 2026-07-17)

Base factuelle de l'étude, vérifiée sur le code et les **dernières** versions des RPC
(`CREATE OR REPLACE` successifs suivis jusqu'à la définition active).

### A.1 Les verrous réellement en vigueur

| Verrou                | Portée                                                                     | Condition exacte                                                                                              | Où (serveur)                                                                                                   |
| --------------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Quiz de compréhension | missions d'un chapitre, **thème scolaire uniquement** (`grade_id` non nul) | attempt du quiz `score ≥ 80 %` ET `durée ≥ 4 s × questions`                                                   | `start_exercise_session` (dernière déf. : migration `20260714130000`) ; constante `QUIZ_PASS_THRESHOLD_PCT`    |
| Donjon — accès        | mode arène                                                                 | ≥ 2 matières ET ≥ 3 chapitres tentés ; niveau de héros ≥ 1 ; `min(niveau, 5)` runs/jour                       | `get_dungeon_access` (dernière déf. : `20260711100000` — branche `SUBSCRIPTION` neutralisée en phase gratuite) |
| Rappel                | variante par mission                                                       | attempt classique `= 100 %` non précipité ; ≥ 3 questions éligibles ; `mode ≠ quiz`, `source = admin`         | `start_exercise_session` branche `recall` (`20260714130000`)                                                   |
| Premium par parcours  | missions d'un parcours premium                                             | **DORMANT** : `is_premium = false` partout depuis `20260711100000` ; sinon entitlement ou préview (quiz + ⭐) | `resolve_exercise_access` (`20260608121000`)                                                                   |

**Aucun autre verrou serveur n'existe** : ni ordre entre chapitres (`display_order` = tri
d'affichage pur), ni ordre entre missions, ni prérequis de compétences, ni verrou par niveau
de héros sur le contenu.

### A.2 Incohérences et boucles ouvertes constatées

1. **Carte `/parcours`** (`journey.ts`, `buildSubjectNodes`) : verrou séquentiel **client-only**
   — matière non cliquable tant que la précédente non-premium n'est pas « commencée » (≥ 1
   tentative) ; contredit le hub/le catalogue/le serveur (libres). → R-11/D-3.
2. **SM-2 sans clôture** : `submit_exercise_attempt` insère 3 échéances (J+1/3/7) sur échec
   < 60 % ; **aucun chemin ne passe `pending → completed`** ; le dashboard calcule
   `pendingSpacedReps` (limit 3) **jamais consommé par l'UI**. → R-19 (serveur) + R-18
   (surface = étude 04-A1).
3. **Donjon non scopé** : `get_dungeon_questions` (migration `20260705170000`) filtre
   uniquement `difficulty ≤ min(3, ⌈étage/5⌉)` + non-vues — toutes matières, **tous grades**.
   → R-25/D-7.
4. **Classements sans cohorte** : `get_global_leaderboard` = XP cumulée toutes classes ;
   onglets par matière scopés au parcours actif (GAP-018) ; ligue hebdo duels = classement
   unique global à paliers par centile. → R-23/R-24/D-5.
5. **Rentrée absente** : seuls l'onboarding et `/niveau/$parcoursId` appellent
   `set_current_parcours` ; aucun timestamp du choix ; aucun mécanisme de promotion. → R-4/D-6.
6. **Constantes/objectifs fantômes** : `10_min`, `maintain_streak_5` (jamais créés par
   `ensure_daily_weekly_goals`, qui ne crée que `3_exercises` + `beat_2_bosses`) ;
   `SPEED_FACTOR_*`, `IDEAL_TIME_PER_QUESTION_S`, `HALF_COIN_THRESHOLD_PCT` morts depuis le
   durcissement `20260604220000`. → R-29.
7. **Difficulté invisible** : `exercises.difficulty` (1–4) n'est rendue en étoiles que dans le
   donjon (`DifficultyStars`) ; le hub ne l'affiche que si le titre la contient en texte. → R-13.

### A.3 Mécanismes sains (socle inchangé)

- **Anti-farm** (`submit_exercise_attempt`) : récompense ssi `non-rushé` ET `score ≥ 60 %` ET
  `score > meilleur précédent (même variante)` ; XP = `xp_reward × score % × (1,5 si Rappel)` ;
  consommables appliqués seulement sur attempt récompensé.
- **Économie** : niveau de héros = `XP/200 + 1` ; 6 classes de héros par paliers de niveau ;
  streak avec bouclier (1 jour manqué) et récupération payante (15 pièces) ; adaptation de
  difficulté par matière **écrite mais jamais lue** (fenêtre 10, +1 si moy. > 75, −1 si < 40).
- **Parcours** : ~35 parcours en 3 kinds (`concours` 6ᵉ/9ᵉ/bac · `scolaire` par classe ·
  `libre` par thème), résolution `(theme, grade)` unique, `set_current_parcours` synchronise
  `current_grade_id` (NULL pour libre), sélection `coming_soon` permise (foyer d'attente).
- **Onboarding** : 3 étapes (intention → parcours → célébration), garde bloquante tant qu'aucun
  parcours actif, grade toujours dérivé (jamais choisi seul), classe de héros jamais choisie
  (dérivée du niveau).
- **Navigation** : nav élève 4 pôles (`/dashboard`, `/parcours`, `/programme`, `/arene`) ; hub
  matière public partagé connecté/anonyme ; parité anonyme du quiz gate (`sessionStorage` +
  `score_quiz` sans fuite de correction).
- **Duels/ligues** (étude 05) et **Rappel** (étude 17) : voir leurs guides — rien à changer.
- **Socles inertes en attente** (ne pas dupliquer) : télémétrie misconceptions (étude 04-A0,
  write-only), graphe de compétences (étude 07 lot 1, catalogue sans table de maîtrise).

### A.4 Positionnement vis-à-vis des études connexes

| Étude                | Ce qu'elle possède                                                            | Ce que 22 en fait                                                                        |
| -------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| 15 (livrée)          | Composition des écrans, « le quiz est le seul verrou », cold-start, registres | Socle normatif — 22 s'y conforme (R-30, gabarits) et étend le QG (blocs Réviser/rentrée) |
| 17 (livrée)          | Règles du Rappel                                                              | Intégré tel quel comme verrou de dépassement (R-9)                                       |
| 05 (livrée)          | Duels intra-parcours, ligue centile                                           | Consacré (R-22/R-24) ; extensions = Q-5 chez elle                                        |
| 16 (en exécution)    | Sections lycée, drill-down, progression par section                           | La bannière de rentrée route vers son drill-down (R-4) ; R-3 généralise son US-5         |
| 04 (en exécution)    | Révision du jour (A1), Points faibles (A2)                                    | Mandatées, non dupliquées (R-18) ; place réservée priorité 1 de R-31                     |
| 07 (en exécution)    | Maîtrise par compétence, diagnostic sans blocage                              | Doctrine reprise (R-10) ; `get_daily_plan` = source future de R-31                       |
| 02 / 08 (brouillons) | Examen blanc / rapport parent                                                 | Consommeront la progression officielle R-15/R-16                                         |
| 09 / 10 (brouillons) | Économie / anti-fraude                                                        | Garde-fous de R-21/R-26 (surveillance et exclusion)                                      |

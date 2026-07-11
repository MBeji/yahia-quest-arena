# Étude 15 — Contenu & composition des écrans

> **Statut** : validée (arbitrages Q-1…Q-6 rendus le 2026-07-10 ; Q-3 = validation sur maquette au lot 5)
> **Priorité** : transverse · **Valeur** : conversion, rétention J1, confiance parent, lisibilité de l'offre · **Complexité** : moyenne+ (large surface, risque unitaire faible)
> **Architecte** : Fable / 2026-07-10 · **Exécuteur cible** : Sonnet (ou équiv.) — sauf charte & maquettes (architecte)
> **Dépend de** : étude 14 (lots 1-2 mergés ; dépendances par écran, §4) · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, docs/guide-duels-et-ligues.md, docs/guide-types-questions-natifs.md ; annexe factuelle : [AUDIT-CONTENU-2026-07.md](./AUDIT-CONTENU-2026-07.md)

## 1. Contexte & objectif produit

L'étude 14 (en exécution) normalise **comment c'est peint** : tokens, 2 thèmes, primitives,
RTL, états système. Elle exclut explicitement l'architecture d'information, le contenu et la
composition des écrans. Cette étude 15 est sa **complémentaire** : **ce que chaque écran dit,
montre et fait faire** — hiérarchie, guidage, microcopy, récits, navigation (incluse au
périmètre par arbitrage du 2026-07-10).

**Pivot produit (arbitrage Q-2, 2026-07-10).** Dans cette phase, l'application est **100 %
gratuite** : pas de paiement, pas de premium, tout le programme tunisien accessible à tous les
niveaux ; le « focus concours » est l'ancienne offre. La proposition : _réviser le cours et
pratiquer des exercices en jouant_ ; _les parents voient ce que fait leur enfant, son niveau,
ses points faibles (suivi)_ ; _une compétition nationale par XP et niveaux_. L'infrastructure
d'entitlements reste en place côté serveur mais devient **dormante** — l'étude 01 (paiement en
ligne) la réactivera.

L'audit phase 0 (66 captures TEST réelles compte neuf + revue de code, 5 groupes d'écrans —
[AUDIT-CONTENU-2026-07.md](./AUDIT-CONTENU-2026-07.md)) établit que le problème n'est ni le
contenu pédagogique (excellent) ni le style (étude 14), mais **des récits cassés et une
hiérarchie absente** :

- **l'offre raconte des histoires contradictoires** (carte « Abonnement requis » partout / hub
  sans aucun verrou / paywall « pas d'abonnement » / footer « 100 % gratuit ») — le pivot Q-2
  tranche : UNE histoire, « tout est gratuit », et le seul verrou restant est pédagogique (le
  quiz de compréhension) (audit §A-3) ;
- **la boucle cœur a perdu sa couche gameplay** au chantier C8 (hub matière sans état, ni
  verrou-quiz, ni reprise — le « L2 » promis n'a jamais été fait) et traverse deux coquilles de
  navigation (§A-2, §B-3) ;
- **le dashboard est six écrans en un** (~30 hauteurs mobile), l'action n°1 sous le pli,
  derrière l'identité et un cross-sell concours (§A-4, §B-1) ;
- **le first-run n'existe pas** (« Bon retour » + zéros + classement « tu es #1 » à 0 XP) et
  l'enjeu des modes (récompenses duel, règles donjon) est invisible (§A-5, §E) ;
- **le parent vit dans une app d'élève** (« Classe : Candidat Civil », nav Donjon/Duels) alors
  que sa promesse — activité, niveau, points faibles, suivi — est le cœur de l'offre (§F) ;
- **des trous de flux durs** : aucun « mot de passe oublié », onboarding avec 19/29 cartes
  « en construction » et un dead-end lycée, invite « crée ton compte » servie aux connectés et
  mensongère pour les anonymes (§C-2, §G, §B-4, §D-4).

**Résultat attendu** : chaque écran a UN job, UNE action n°1 au-dessus du pli mobile, des états
vides qui racontent, UN récit d'offre (« 100 % gratuit — apprends en jouant, tes parents te
suivent, la nation te classe »), un registre par audience (élève RPG dosé / parent & public
sobre), un catalogue réellement trilingue — refondu **par lots d'une PR**, chaque recomposition
validée **visuellement dans Claude Design avant implémentation**.

**Indicateurs de succès** (reviewables par PR, pas subjectifs) :

- 100 % des écrans refondus : action n°1 visible sur le fold mobile 375 px (preuve : capture
  `--fold` du harness R-5) ;
- 0 état vide/first-run muet sur les écrans refondus (chaque vide = message + action) ;
- 0 cul-de-sac (chaque écran propose la suite) ; 0 clé user-facing FR-only ;
- **0 mention user-facing d'« abonnement », « premium », de paywall ou de verrou payant**
  (vérifiable par grep i18n) — le « 100 % gratuit » du footer devient vrai partout ;
- catalogue (parcours, matières, tabs) localisé dans les 3 locales avec fallback ;
- funnel signup → première mission mesuré en taps au lot 10 (base : audit §G) ;
- gate verte à chaque lot, budgets bundle inchangés, coverage non régressée.

**Ce que l'epic ne fait PAS** : pas de changement des mécaniques/économie du jeu (on AFFICHE
les règles de `gamification.ts`, on ne les change pas — seule exception cadrée : l'ouverture
des portes premium, D-3), pas de monétisation (reportée — étude 01 réactivera l'infra
entitlements dormante), pas de volet légal signup (**reporté**, arbitrage Q-5 du 2026-07-10),
pas de nouveau branding ni de refonte des tokens/primitives (étude 14), pas de moteur adaptatif
(étude 04), pas d'analytics famille avancées (étude 08), pas de réécriture du contenu
pédagogique.

## 2. Spécification fonctionnelle

- **Acteurs** : élève (6-19 ans, FR/AR/EN), parent (non-joueur), visiteur anonyme (élève ou
  parent/enseignant), admin.
- **US-1** — En tant qu'élève neuf, après le signup je comprends la promesse, je choisis ma
  classe sans bruit, et j'arrive à MA première mission en ≤ 3 écrans, accueilli comme un
  nouveau (jamais « Bon retour » + zéros).
- **US-2** — En tant qu'élève, sur chaque écran je vois d'un coup d'œil QUOI faire maintenant
  (une action prioritaire au-dessus du pli mobile), et je ne perds jamais la navigation
  principale pendant la boucle apprendre→s'entraîner.
- **US-3** — En tant qu'élève, je sais AVANT de cliquer ce qui est fait, à faire, ou verrouillé
  par le quiz de compréhension — et un verrou m'explique toujours comment le lever (le quiz est
  le SEUL verrou de l'app dans cette phase).
- **US-4** — En tant qu'élève, l'écran d'entrée de chaque mode compétitif (donjon, duel,
  classement) me dit les règles, l'enjeu et mes récompenses — y compris quand tout est vide
  (cold-start raconté, jamais « tu es #1 » à 0 XP).
- **US-5** — En tant que parent, le bilan répond d'abord à « mon enfant travaille-t-il,
  progresse-t-il ? » dans MES mots (classe scolaire, pas classe RPG), me montre ses points
  faibles et me dit quoi faire pour l'aider (réviser tel chapitre) — sans jargon gamer.
- **US-6** — En tant qu'arabophone, le catalogue entier (niveaux, parcours, matières, tabs) est
  en arabe ; le mélange UI/contenu est assumé et signalé, jamais accidentel.
- **US-7** — En tant qu'anonyme, on me propose un compte aux bons moments avec des arguments
  VRAIS (XP, sauvegarde, déblocages conservés, classement) — jamais « crée un compte pour
  t'entraîner » (faux) ni d'invite quand je suis déjà connecté.
- **US-8** — En tant qu'utilisateur, je peux récupérer mon mot de passe.
- **Règles** (l'exécuteur les référence dans ses tests) :
  - **R-1** : action n°1 au-dessus du pli mobile 375 px sur tout écran refondu (preuve :
    capture fold du harness).
  - **R-2** : zéro cul-de-sac — tout écran/état (vide, verrouillé, erreur, résultat) propose au
    moins une suite contextuelle.
  - **R-3** : tout état vide/first-run est raconté : message + action, jamais un widget vide ni
    un classement fictif.
  - **R-4** : l'enjeu avant le clic — verrou quiz, gains (XP/pièces depuis
    `shared/constants/gamification.ts`), règles et seuils annoncés sur la surface d'ENTRÉE,
    pas après l'engagement.
  - **R-5** : captures avant/après par PR via le harness committé
    (`scripts/design/dev-server-test.mjs` + `capture-screens.mjs`), FR + AR × mobile/desktop —
    même règle que l'étude 14.
  - **R-6** : microcopy trilingue dans la même PR (aucune clé FR-only) ; données de catalogue
    localisées (`name_ar`/`name_en` peuplés + sélectionnés) avec fallback `name_fr`.
  - **R-7** : registre par audience — élève : tutoiement, RPG dosé (registre Arène) ; parent et
    tier public : sobre, vouvoyé, zéro jargon gamer non traduit ; un lexique trilingue unique
    (lot 3) fait foi ; les mots « abonnement », « premium », « payant » sont bannis de toute
    surface utilisateur (phase gratuite).
  - **R-8** : tout lot qui RECOMPOSE un écran implémente la maquette Claude Design validée par
    l'humain — pas de maquette validée = STOP, pas d'implémentation.
  - **R-9** : divulgation progressive — toute liste > ~8 items se replie (accordéon, « top
    10 + toi », pagination) ; jamais deux fois la même information sur une ligne (Niv. n +
    étoiles).
  - **R-10** : aucun changement de mécanique serveur, à deux exceptions près, **énumérées et
    cadrées** : (a) le lot 2 « gratuité de phase » (D-3 : migration data parcours + porte
    donjon, pgTAP) ; (b) élargissements de SELECT (colonnes existantes), champs calculés en
    lecture et migrations **additives** de données (name_ar/name_en, textes). Jamais de
    changement de scoring, d'anti-farm, de RLS ou d'économie.
- **i18n** : nouvelles clés FR/EN/AR par lot ; lexique unifié (lot 3) ; erreurs serveur
  user-facing passées par l'i18n (parent-report §F-1). Notation math standard inchangée.
- **Hors périmètre (v1)** : monétisation & réactivation premium (étude 01), volet légal signup
  (reporté Q-5), app mobile native, emails transactionnels, page « à propos » complète (une
  section landing suffit), high-contrast, refonte des SVG pédagogiques.

## 3. Architecture technique (décisions fermées)

Tout est client/copy/composition + les exceptions serveur cadrées par R-10.

- **D-1 — Charte de contenu (lot 3, fichier normatif `docs/content-voice-and-composition.md`).**
  Formalise : les gabarits de composition par type d'écran (hub, mode, formulaire, rapport,
  player) avec leur budget de blocs ; les règles R-1→R-9 opérationnalisées ; le lexique
  trilingue (dont : « série » pour streak, « pièces » pour coins ; nom AR du Donjon :
  **« القبو اللانهائي »** — « الزنزانة » banni [arbitrage Q-1] ; « abonnement/premium » bannis) ;
  le registre par audience (R-7) ; la règle chrome-UI vs langue-contenu (l'écran système suit
  l'UI, le contenu sa langue, le mélange `QL.*`/`t.*` sur un même bandeau est interdit — audit
  §D-5). Ton élève **unique** (tutoiement, compréhensible dès 8 ans, RPG dosé côté Arène) — pas
  de variation par cycle (arbitrage Q-1). Le dashboard #345 (bande focus) est l'étalon du
  pattern « une action prioritaire ».
- **D-2 — Maquettes Claude Design (prolonge D-6/Q-3 de l'étude 14, jamais exécuté).** Un projet
  Design System claude.ai/design : d'abord le socle (tokens + 8 primitives du lot 1 é14, cards
  `@dsCard`), puis `screens/<écran>/` — 1-2 variantes max par écran recomposé, mobile-first,
  FR + AR, construites sur le CSS réel. Bundle versionné dans le repo (`design/ds/`), sync
  incrémentale composant par composant (outil DesignSync). Le projet DS est l'outil de
  décision ; le code reste la source de vérité. La validation humaine d'une maquette = le
  contrat du lot (R-8).
- **D-3 — Gratuité de phase (arbitrage Q-2) : UN récit, une bascule technique réversible.**
  Le récit : « **100 % gratuit** — révise le cours, entraîne-toi en jouant, gagne des XP,
  grimpe au classement national ; tes parents suivent ta progression. » Plus aucun focus
  concours (ancienne offre) : la préparation aux examens redevient un ATOUT du niveau concerné,
  pas le produit. Bascule technique (lot 2, la seule exception serveur de l'étude) :
  (a) migration additive `UPDATE parcours SET is_premium = false` (les ids `concours-9eme` /
  `concours-6eme` sont notés dans la migration pour la ré-activation par l'étude 01) — le
  premium gate existant (« a FREE parcours is always open ») ouvre alors toutes les missions
  sans autre changement ; (b) la porte donjon perd sa raison SUBSCRIPTION (CREATE OR REPLACE de
  la RPC de gate : on conserve PREREQ/LEVEL/DAILY_LIMIT — verrous d'engagement, pas de
  paiement), pgTAP mis à jour ; (c) purge UI : `SubscriptionPaywall` et la demande bêta ne sont
  plus atteignables côté élève, `premiumHint` supprimé, usages de `PremiumBadge` retirés (la
  primitive é14 reste, dormante), bannière « Prépare ton concours national » retirée du
  dashboard, mention « Premium » du donjon retirée ; (d) les specs e2e premium-gate/free-user
  sont réalignées sur le monde gratuit (le harnais TEST garde un compte « premium » seedé
  dormant pour l'étude 01) ; (e) écrans admin entitlements/beta conservés tels quels
  (outillage dormant, admin-only). RLS, RPCs d'accès et tables : **inchangées**.
- **D-4 — Coquille unifiée auth-aware (navigation).** Une seule nav qui s'adapte à la session,
  fin du flip-flop (§A-2) : connecté, les pages catalogue/hub/lecteur (`_public`) affichent la
  nav du jeu (QG, Parcours, Découvrir, Arène, chips) ; anonyme, la nav publique actuelle. Le
  débordement desktop (§E-4 : « Duels » tronqué, « Classement » invisible) est résolu par
  regroupement : **« Arène »** devient une entrée unique (Donjon · Duels · Classement) — page
  hub légère ou menu — et les trois écrans se maillent entre eux. `/dungeon` cesse d'être
  « immersif » au lobby (tab-bar visible tant qu'on ne joue pas). Le rôle parent reçoit une
  coquille dédiée minimale : nav = Suivi (+ déconnexion), zéro entrée gamer. **Q-3 : la
  maquette de nav (lot 4) est validée par l'humain avant l'implémentation (lot 5).**
- **D-5 — Dashboard dégroupé (arbitrage Q-4 : validé).** Le dashboard redevient un QG : bande
  focus EN PREMIER (v2 de #345 : accueil first-run dédié, « Bon retour » réservé aux comptes
  avec progression), puis quêtes du jour/semaine condensées, puis les matières du parcours
  (cartes avec état réel), et c'est tout. Déménagent : boutique + inventaire + badges →
  nouvelle route **`/boutique`** ; le radar rejoint la section badges ; « Autres thèmes »
  (25 cartes) → supprimé, remplacé par UNE carte « Découvrir d'autres thèmes → /programme » ;
  le code alliance → une carte compacte « Famille » en bas de dashboard avec état (lié ✓ / à
  lier). La bannière concours disparaît (D-3). Validation via maquettes.
- **D-6 — Hub matière connecté (le « L2 » différé du C8, cadré ici).** `/matiere` et
  `/chapitre` restent des pages publiques partagées (pas de nouvelle route), mais reçoivent la
  couche session : ancrage niveau (kicker = classe, pas « FORCE ») + remontée vers
  `/niveau/$parcoursId` ; « Reprendre ici » (dernier chapitre travaillé) ; par chapitre :
  progression x/y + accordéon (replié une fois fait) ; par mission : badge tri-état (fait ✓ /
  à faire / 🔒 quiz) + gain XP (connecté seulement) ; le CTA du lecteur pointe le QUIZ tant que
  le chapitre n'est pas débloqué (`hasPassedChapterQuiz`/`quizPassedByChapter` — données déjà
  servies, audit §D-3/§D-4) ; l'invite compte disparaît pour les connectés et dit la vérité aux
  anonymes (« garde tes déblocages », §D-4/§D-5) ; le player public affiche « Continuer vers le
  1er exercice » après un quiz réussi (§D-5). Le quiz annonce son contrat sur l'écran même
  (« Réussis ≥ 60 % pour déverrouiller les missions », `QUIZ_PASS_THRESHOLD_PCT`).
- **D-7 — First-run & cold-start racontés.** Un helper partagé « première fois » (profil sans
  attempts) pilote : hero dashboard en mode accueil, leaderboard « Le classement démarre —
  gagne tes premiers XP » (+ « top 10 + toi », suppression du #1 fictif — ne jamais afficher de
  rang sans XP), duel « premier arrivé » raconté AVANT le clic + récompenses affichées
  (60/40/20 XP — participer paie), donjon : prérequis expliqués (« entame 2 matières ») +
  record personnel au lobby. Constantes lues depuis `gamification.ts`, jamais dupliquées.
- **D-8 — Flux manquants (nouveaux écrans autorisés dans cette étude).** (a) « Mot de passe
  oublié » : `resetPasswordForEmail` Supabase + route `/auth/reset` (formulaire nouveau mot de
  passe), lien sur `/auth` ; (b) sélecteur de langue sur `/auth` (le volet légal/consentement
  est **reporté** — Q-5) ; (c) fix du bug de rôle parent (metadata du signUp +
  `handle_new_user` — migration additive, audit §G) ; (d) onboarding v2 : étape promesse
  courte, langue explicite, picker école propre (lecture de `grades.is_selectable`, doublons
  legacy masqués, « en construction » repliées) ; **arbitrage Q-6 = option A** : une classe
  « en construction » est SÉLECTIONNABLE (la RPC l'autorise déjà par design) avec un accueil
  dédié (« ta classe arrive — en attendant : les extras + vote ») ; récap + célébration +
  atterrissage guidé, deep-link restauré.
- **D-9 — Parent.** Rapport re-hiérarchisé : verdict + conseil d'abord (mobile), outils
  (liaison, objectif) repliés après liaison ; classe scolaire réelle (SELECT élargi
  grade/parcours) ; points faibles et conseil **cliquables** vers `/chapitre`/`/matiere` (c'est
  LE cœur de l'offre parent — activité, niveau, points faibles, suivi) ; erreurs serveur i18n ;
  `/suivi` : promesse (« sans compte ») + contenu du bilan + entrée header/footer publics.
  (Plus d'étage commercial — phase gratuite, D-3.)
- **D-10 — Admin (efficacité, petit).** Recherche utilisateur par email pour les gestes admin ;
  lien direct exercice/question sur les signalements + regroupement par cible ; « Approuver »
  (bêta) affiche ce qui sera accordé (écran dormant mais fonctionnel).
- **Alternatives rejetées** : refondre l'IA en rapatriant hub/lecteur sous `_authenticated`
  (duplique ce que C8 a unifié ; la couche session suffit) ; un ton par cycle d'âge (rejeté en
  Q-1) ; supprimer les tables/RPCs entitlements (l'étude 01 en a besoin — on bascule les
  données, pas le schéma) ; déplacer la boutique dans une modale (D-5 lui donne une vraie
  page).

## 4. Plan d'exécution en lots

Chaque lot = une PR mergeable, gate verte, captures R-5, maquette validée si recomposition
(R-8). Un lot d'écran ne touche ni les primitives (retour étude 14) ni un autre écran.

| lot | contenu (résumé)                                                                                                                                                                                                                                                                                                                                                                                                                                                  | fichiers/objets principaux                                                                                                           | tests exigés                             | dépend de               |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------- | ----------------------- |
| 0   | Étude + audit + harness captures (PR #355)                                                                                                                                                                                                                                                                                                                                                                                                                        | `FableEtudes/15-*`, `scripts/design/*`                                                                                               | —                                        | —                       |
| 1   | **Quick-wins de vérité** (copy/one-liners, sans recomposition) : invite lecteur conditionnée `!isAuthenticated` + texte véridique ; CTA lecteur → quiz si non débloqué ; « Continuer » post-quiz anonyme ; méta `/auth` (positionnement gratuit) ; sous-titre leaderboard ; `formatQuestType`/« beat 2 bosses » i18n ; « Temps validé côté serveur » corrigé ; hygiène seed e2e (révoquer les entitlements des comptes non premium) ; CLAUDE.md — IA réelle (A-1) | `lesson-reader.tsx`, `fr/en/ar*.ts`, `quest.server.ts:360`, `exercice.$exerciseId.tsx`, `scripts/e2e/seed-test-users.mjs`, CLAUDE.md | unit ciblés + i18n                       | 0                       |
| 2   | **Gratuité de phase (D-3)** : migration `parcours.is_premium=false` + porte donjon sans SUBSCRIPTION (pgTAP) + purge UI (paywall/bêta côté élève, `premiumHint`, usages `PremiumBadge`, bannière concours, mention « Premium » donjon) + e2e premium réalignés                                                                                                                                                                                                    | migration, RPC gate donjon, `journey.ts`, `dashboard.tsx`, `dungeon.tsx`, e2e                                                        | pgTAP gate, unit UI, e2e réalignés       | 1                       |
| 3   | Fondations éditoriales : charte D-1 (doc normatif), lexique trilingue (dont Donjon AR), migration additive `name_ar`/`name_en` des parcours + selects élargis + fallback, i18n des erreurs parent-report                                                                                                                                                                                                                                                          | `docs/content-voice-and-composition.md`, migration, `dashboard.server.ts`, i18n                                                      | unit fallback locale, pgTAP si migration | 0                       |
| 4   | Publication Claude Design : socle (tokens + primitives é14) + gabarits, puis maquettes des lots 5-12 au fil de l'eau (dont maquette nav pour Q-3)                                                                                                                                                                                                                                                                                                                 | `design/ds/**` (bundle versionné)                                                                                                    | — (revue humaine)                        | é14 lot 1 (fait)        |
| 5   | Navigation & coquilles (D-4) : nav unifiée auth-aware, pôle Arène, fix débordement desktop, dungeon non-immersif au lobby, coquille parent, `/suivi` dans header/footer — **implémente la maquette Q-3 validée**                                                                                                                                                                                                                                                  | `_authenticated.tsx`, `public-header/footer`, routes                                                                                 | unit nav par rôle, captures              | 3, 4 ; é14 lot 2 (fait) |
| 6   | Dashboard dégroupé (D-5, arbitré Q-4) + nouvelle route `/boutique`                                                                                                                                                                                                                                                                                                                                                                                                | `dashboard.tsx`, `routes/boutique.tsx`, `features/dashboard`, `features/shop`                                                        | unit existants verts + first-run         | 5 ; é14 lot 5           |
| 7   | Hub matière connecté + lecteur + player public (D-6) — le lot le plus lourd                                                                                                                                                                                                                                                                                                                                                                                       | `subject-hub.tsx`, `lesson-reader.tsx`, `exercice.$exerciseId.tsx`, `quest.server.ts` (lectures)                                     | unit gate/badges/reprise, captures A/A   | 2, 3 ; é14 lots 3, 6    |
| 8   | Funnel public : landing (récit gratuit Q-2, preuve : chiffres réels compilés du contenu, lien « voir un exemple de cours », porte enseignant honorée), programme (volumétrie + intérêt public + lycée compacté), extras différenciés                                                                                                                                                                                                                              | `public-landing.tsx`, `parcours-catalogue.tsx`, `fr/en/ar-public.ts`                                                                 | unit, captures                           | 2, 3 ; é14 lot 3        |
| 9   | Auth v2 (D-8 a-b) : registre par audience (R-7), mot de passe oublié, sélecteur de langue (légal reporté Q-5)                                                                                                                                                                                                                                                                                                                                                     | `auth.tsx`, route reset, i18n                                                                                                        | unit + e2e auth-flows                    | 3 ; é14 lot 4           |
| 10  | Onboarding v2 (D-8 c-d, option A arbitrée Q-6) : promesse, picker propre, classes « en construction » sélectionnables + accueil dédié, fix rôle parent (migration), célébration, deep-link                                                                                                                                                                                                                                                                        | `onboarding.tsx`, `onboarding-guard.ts`, migration metadata rôle                                                                     | unit guard + e2e onboarding              | 9                       |
| 11  | Arène (D-7) : donjon (prérequis racontés + record), duel (règles + récompenses + file racontée + historique lisible — SELECT outcome/adversaire élargi), leaderboard (cold-start + top 10 + toi)                                                                                                                                                                                                                                                                  | `dungeon.tsx`, `features/duel`, `leaderboard.tsx`, `duel.server.ts` (lecture)                                                        | unit cold-start/récompenses, captures    | 2, 5 ; é14 lots 7-9     |
| 12  | Parent (D-9) : rapport re-hiérarchisé (verdict/points faibles d'abord, liens actionnables) + `/suivi` enrichie                                                                                                                                                                                                                                                                                                                                                    | `features/parent-report`, `suivi.tsx`                                                                                                | unit, captures parent                    | 3, 5 ; é14 lot 10       |
| 13  | Admin (D-10) : recherche par email, liens signalements, approbation explicite                                                                                                                                                                                                                                                                                                                                                                                     | `routes/admin.*`, features admin                                                                                                     | unit                                     | é14 lot 10              |

Stop-points : maquette non validée = STOP (R-8) ; toute envie de nouvelle mécanique = hors
périmètre ; divergence étude↔code = STOP et remontée (règle FableEtudes).

- [x] Lot 0 — étude + audit + harness (PR #355)
- [x] Lot 1 — quick-wins de vérité
- [x] Lot 2 — gratuité de phase
- [x] Lot 3 — fondations éditoriales
- [~] Lot 4 — Claude Design (socle + gabarits publiés ; maquettes nav Q-3 + dashboard Q-4 en attente de validation humaine ; autres écrans au fil de l'eau)
- [ ] Lot 5 — navigation & coquilles
- [ ] Lot 6 — dashboard + `/boutique`
- [ ] Lot 7 — hub matière connecté
- [ ] Lot 8 — funnel public
- [ ] Lot 9 — auth v2
- [ ] Lot 10 — onboarding v2
- [ ] Lot 11 — arène
- [ ] Lot 12 — parent
- [ ] Lot 13 — admin

## 5. Stratégie de test

- **Unit (Vitest)** : chaque condition de contenu nouvelle (invite `!isAuthenticated`, badges
  d'état, first-run helper, fallback de locale, nav par rôle) avec tests co-localisés ; les
  tests existants des écrans refondus restent verts sans affaiblissement.
- **pgTAP** : lot 2 (porte donjon, data parcours), lot 3 (name_ar/en), lot 10 (metadata rôle).
- **e2e** : les specs touchées suivent dans la même PR (premium-gate → monde gratuit au lot 2 ;
  onboarding — le page-object documente une étape « confirm » fantôme à réaligner ; auth-flows
  pour le reset ; navigation). Hygiène seed (lot 1) fiabilise les états capturés/testés.
- **Visuel** : harness R-5 (`scripts/design/capture-screens.mjs`) avant/après par PR — FR + AR,
  mobile + desktop, fold inclus ; les états non capturables statiquement (résultat, verrou
  donjon) sont capturés manuellement au lot concerné (liste : audit §G « à capturer »).
- **smoke:shell** obligatoire à chaque lot (bundle prod touché partout).

## 6. Risques & mitigations

- **RISK-1 — Collision avec les lots 3-11 de l'étude 14** (mêmes fichiers). Prob. moyenne,
  impact moyen. Mitigation : dépendances par écran (§4) — un écran n'est recomposé (15)
  qu'après son rattachement (14) ; lots courts, rebase fréquent.
- **RISK-2 — Recomposition sans maquette validée** (exécuteur qui « voit bien »). Impact haut.
  Mitigation : R-8 est un stop-point dur ; la maquette validée est jointe au lot dans le
  journal.
- **RISK-3 — Scope creep vers des features** (« tant qu'on refait le duel, ajoutons le
  rematch »). Mitigation : hors-périmètre §1 + R-10 ; toute envie = ligne au journal, pas au
  lot.
- **RISK-4 — Réversibilité de la gratuité.** L'étude 01 doit pouvoir réactiver le premium sans
  archéologie. Mitigation : D-3 ne touche NI le schéma NI les RPCs d'accès (data flip + une
  seule RPC de gate donjon, ids concernés notés dans la migration) ; les écrans admin restent
  fonctionnels ; le compte e2e « premium » reste seedé.
- **RISK-5 — Selects élargis / types Supabase**. Mitigation : régénérer les types, tests de
  fallback, aucun changement de RLS (R-10).
- **RISK-6 — Qualité de l'arabe** (lexique, registre). Mitigation : le lexique trilingue (lot 3) est arbitré par Mohamed ; toute nouvelle clé AR est relue humainement avant merge du lot.

## 7. Questions ouvertes (pour l'humain)

Toutes arbitrées le 2026-07-10 — l'étude passe « validée ». Décisions consignées :

- **Q-1 — ARBITRÉ : validé.** Ton élève unique (tutoiement, dès 8 ans, RPG dosé côté Arène) +
  registre parent/public sobre vouvoyé. Nom AR du Donjon : « القبو اللانهائي » (« الزنزانة »
  banni) — révisable à la relecture du lexique (lot 3).
- **Q-2 — ARBITRÉ : pivot gratuité de phase.** Application **100 % gratuite** dans cette
  phase : pas de paiement, pas de premium, tout accessible (tous les niveaux du programme
  tunisien). Plus de focus concours (ancienne offre). Proposition : réviser + pratiquer en
  jouant, suivi parental (activité, niveau, points faibles), compétition nationale (XP,
  niveaux). → D-3 réécrit, lot 2 dédié, R-7/R-10 amendés, étage commercial parent retiré
  (D-9). L'infra entitlements devient dormante jusqu'à l'étude 01.
- **Q-3 — ARBITRÉ dans son principe, validation sur maquette.** La direction D-4 (nav unifiée
  auth-aware + pôle Arène + coquille parent) est actée ; la maquette produite au lot 4 doit
  être validée par Mohamed avant l'implémentation au lot 5 (R-8).
- **Q-4 — ARBITRÉ : validé.** Dashboard simplifié/dégroupé (D-5) : `/boutique` dédiée,
  suppression « Autres thèmes », carte Famille compacte.
- **Q-5 — ARBITRÉ : reporté.** Pas de volet légal signup dans cette phase (retiré du lot 9,
  consigné en hors-périmètre).
- **Q-6 — ARBITRÉ : option A.** Une classe « en construction » est sélectionnable à
  l'onboarding, avec un accueil dédié (« ta classe arrive — en attendant : extras + vote »).

## 8. Journal d'exécution

- 2026-07-10 — Lot 0 : audit phase 0 livré (66 captures TEST compte neuf via le harness
  committé `scripts/design/`, 5 groupes d'écrans audités en parallèle + boucle cœur par
  l'architecte, 0 erreur console). Étude rédigée. Prérequis Q-2 de l'étude 14 levé au passage :
  `.env.test` opérationnel en local (e2e:doctor 7/7). Corrigé en chemin (commit dédié, même
  PR) : garde-fou RTL cassé sur Windows (`D:\D:\…`) et gate unitaire non hermétique au
  `.env.test` local (fuite dotenv de `scripts/e2e/_env.mjs` via les tests de scripts →
  timeouts réseau) — `npm run verify` était rouge sur tout checkout Windows configuré pour
  l'e2e.
- 2026-07-10 — Arbitrages humains Q-1…Q-6 rendus (§7), statut → **validée**. Impact scope
  majeur (Q-2, gratuité de phase) : D-3 réécrit, nouveau lot 2 « gratuité », renumérotation des
  lots 3-13, volet légal retiré (Q-5), option A onboarding (Q-6). Q-3 se valide sur maquette au
  lot 4 (gate du lot 5).
- 2026-07-11 — Lot 1 livré (quick-wins de vérité) : invite du lecteur réservée aux anonymes +
  copy véridique (« garder tes chapitres débloqués », plus de faux « pour t'entraîner ») ; le
  CTA du lecteur cible le quiz de compréhension tant que le chapitre est verrouillé
  (`getChapterLesson` expose `quizExerciseId`/`quizGated`/`quizPassed` — même règle de passage
  que `getSubject` ; anonyme résolu via sessionStorage) ; « Continuer vers le premier
  exercice » sur le résultat d'un quiz anonyme réussi ; « Temps validé côté serveur » réservé à
  la stratégie connectée (clé `timeSpent` sinon) ; types de quêtes/objectifs i18n FR/EN/AR
  (fin de « beat 2 bosses ») ; sous-titre leaderboard « de l'Académie » ; méta `/auth` sur le
  positionnement gratuit ; hygiène seed e2e (révocation des entitlements des comptes non
  premium) ; CLAUDE.md aligné sur l'IA réelle (redirects C8/L2.A). Écart accepté : pour un
  connecté, le CTA lecteur→quiz s'appuie sur l'état serveur ; pour un anonyme l'état
  sessionStorage n'est lu qu'après montage (SSR = quiz par défaut sur chapitre non débloqué —
  cohérent et sans mismatch d'hydratation).
- 2026-07-11 — Lot 2 livré (gratuité de phase, D-3/Q-2) : migration
  `20260711100000_free_phase_all_parcours.sql` — `parcours.is_premium = false` partout (ids
  `concours-9eme`/`concours-6eme` notés pour la ré-activation étude 01) + `get_dungeon_access()`
  sans raison SUBSCRIPTION (forme OUT inchangée, `has_subscription` = true ; verrous
  PREREQ/LEVEL/DAILY_LIMIT conservés). Purge UI : branche paywall du donjon retirée,
  `premiumHint` supprimé (carte de l'aventure + i18n ×3 + types), bannière « Prépare ton
  concours national » supprimée du dashboard avec son trio de composants flagship
  (banner/concours-banner/crown), ses helpers (`flagshipConcours`/`flagshipLabel`), sa section
  i18n et son keyframe CSS. E2e réalignés phase gratuite : premium-gate (les deux comptes
  ouvrent une mission d≥2 sans paywall), dungeon (les deux comptes → verrou de progression),
  free-user, premium-user (compte à entitlement dormant conservé pour é01),
  `premiumConcoursParcours()` filtre par kind. Infra entitlements/RLS/paywall quest intacte et
  dormante. Écart accepté : aucun pgTAP dédié n'existait pour `get_dungeon_access` (la suite
  applique la migration sur DB fraîche) — la RPC est couverte indirectement par les specs e2e
  donjon.
- 2026-07-11 — Lot 3 livré (fondations éditoriales, D-1) — **PR laissée en DRAFT pour relecture
  humaine du lexique AR et des 35 traductions (RISK-5)**. Charte normative
  `docs/content-voice-and-composition.md` (registres par audience, lexique trilingue, 6 règles
  de composition, gabarits + budgets par type d'écran, erreurs en codes stables, checklist de
  PR) référencée depuis CLAUDE.md. Migration `20260711120000_parcours_names_i18n.sql` : les 35
  parcours reçoivent `name_en`/`name_ar` (+ pgTAP `21_parcours_names_i18n.test.sql`) ; helper
  `parcoursName()` (`shared/lib/parcours-locale`, fallback FR) branché sur le catalogue
  (programme + extras), `/niveau` (H1) et l'onboarding ; selects de `getParcours`/
  `getParcoursSubjects` élargis. Erreurs du tunnel code-alliance passées en codes stables
  (`parent-code-errors.ts`, préfixes `PARENT_LINK_ERROR:`/`REPORT_CODE_ERROR:`) traduits côté
  client en FR **vouvoyé**/EN/AR (audit §F-1). Sweep lexique appliqué : FR « série »/« pièces »
  (fin de « Streak »/« Coins »), AR « القبو اللانهائي » (fin de « الزنزانة », accords refaits).
  Écart accepté (corrige un effet de bord du lot 2) : le surlignage « Concours » du catalogue
  s'appuyait sur `is_premium` (désormais false partout) → il suit `kind === "concours"` ;
  `flagshipLabel` restauré (utilisé par le catalogue public, seul `flagshipConcours` a disparu).
- 2026-07-11 — Lot 4 (Claude Design, D-2) — publication initiale. Le socle (fondations
  couleurs/typo + 8 primitives) préexistait dans le projet DS « Na9ra Nal3ab — Design System ».
  Ajoutées : deux maquettes d'écran **gating** — `ecrans/navigation.html` (Q-3 : nav unifiée
  auth-aware, pôle « Arène » regroupant Donjon/Duels/Classement, coquille parent dédiée) et
  `ecrans/dashboard.html` (Q-4 : QG dégroupé, bande focus en tête, boutique/inventaire/badges →
  `/boutique`, suppression « Autres thèmes », carte Famille compacte, first-run). Sur les vrais
  tokens (2 thèmes), avec avant/après annoté. Bundle versionné dans le repo (`design/ds/ecrans/`)
  et poussé dans le projet DS via DesignSync. **En attente de validation humaine de Q-3 et Q-4** —
  gate des lots 5 (navigation) et 6 (dashboard) (R-8). Les maquettes des écrans suivants seront
  ajoutées au fil de l'eau, une par lot d'écran.

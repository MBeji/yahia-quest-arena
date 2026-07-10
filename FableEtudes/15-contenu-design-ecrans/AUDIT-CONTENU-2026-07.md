# Audit contenu & composition des écrans — état des lieux (phase 0, 2026-07)

> Annexe factuelle de l'[étude 15](./ETUDE.md). Complémentaire de
> [l'audit de l'étude 14](../14-refonte-ux-design/AUDIT-2026-07.md) (style/système — tokens,
> registres, RTL, primitives) : ici on audite **ce que chaque écran dit, montre et fait faire** —
> hiérarchie de l'information, contenu, guidage, microcopy, architecture d'information.
> Chaque affirmation est vérifiable : capture nommée et/ou `fichier:ligne`.

## Méthode

- **66 captures d'écrans réels** contre le projet Supabase TEST seedé (compte élève **neuf** —
  0 XP, aucune tentative — c'est l'état le plus important du produit), via le harness committé
  `scripts/design/dev-server-test.mjs` + `scripts/design/capture-screens.mjs` (réutilisable pour
  la règle R-5 : captures avant/après de chaque lot). Matrice : rôles anon/free/premium/parent/
  admin × FR-desktop/FR-mobile/AR-mobile (+ thème sombre sur landing/auth/dashboard), avec
  découverte des routes dynamiques à la volée et collecte des erreurs console (**0 erreur de
  page sur les 66 captures**). Manifest : artefact de session (`captures-phase0/manifest.json`).
- **Grille standard par écran** : job-to-be-done & moment · action n°1 (visible sans scroll
  mobile ?) · blocs affichés (ordre réel) · ce qui manque · ce qui est en trop · microcopy ·
  cul-de-sac · constats sévérisés [MAJEUR]/[MOYEN]/[MINEUR].
- **Limites assumées** : pas de compte « riche » (progression avancée) — le seed e2e remet la
  progression à zéro ; l'onboarding authentifié n'a pas pu être capturé (comptes déjà onboardés,
  la route redirige) → audité **sur code** (§G) ; les états _résultat/récompense_ de mission et
  le _paywall_ exigent de jouer une session → à capturer manuellement au lot concerné — d'autant
  que le compte « free » seedé portait un **entitlement résiduel** d'un ancien run e2e (ni purgé
  par `reset-gameplay.mjs` ni révoqué par `seed-test-users.mjs` pour les comptes non premium) :
  les captures donjon « free » montrent le verrou prérequis, jamais le paywall — hygiène de
  seed à corriger ; le fold AR-mobile du dashboard présente un artefact de screenshot (bande
  étroite) non confirmé par la pleine page — à revérifier à la main, non compté comme constat.

## A. Constats transverses (architecture d'information & récits)

- **A-1 — L'IA réelle a convergé sur le registre public, les docs ne le savent pas.** Quatre
  routes authentifiées sont des redirects 301 : `/themes` → `/programme` et
  `/themes/$familyId` → `/programme` (`routes/_authenticated/themes.tsx:11`,
  `themes_.$familyId.tsx:10`, chantier L2.A/GAP-046), `/lesson/$chapterId` →
  `/chapitre/$chapterId` (`lesson.$chapterId.tsx:11`), `/subject/$subjectId` →
  `/matiere/$subjectId` (chantier C8). Le hub matière et le lecteur de cours sont des pages
  **publiques partagées** anonyme/connecté. CLAUDE.md décrit encore « the Explorer (/themes) »
  et « Every map node routes to /subject/$subjectId » — à corriger (dette doc, pas UX).
- **A-2 — La boucle cœur traverse deux coquilles.** Dashboard (nav jeu : Hall des Héros /
  Parcours / Découvrir / Donjon / Duels / Classement) → hub matière et lecteur (**nav publique** :
  Programme / Extras — la nav jeu disparaît) → mission `/quest` (nav jeu de retour). Le retour
  existe (logo et HUD → `/dashboard`, `public-header.tsx:29`, issue #312) mais Donjon/Duels/
  Classement/Parcours disparaissent pendant l'apprentissage ; l'élève change de monde deux fois
  par mission. C'est la conséquence non traitée du C8 : le hub public n'a jamais reçu sa couche
  « connectée » (le commentaire d'e2e `subject.page.ts:9-14` documente explicitement que l'état
  visuel gameplay — verrous quiz, verrous premium, badge « ✓ réussi » — a été **retiré** et
  « deferred to L2 (re-enrichment of the connected hub) » — jamais fait).
- **A-3 — Trois récits premium contradictoires + le gratuit invisible.** (a) La carte de
  l'aventure affiche sous CHAQUE nœud « Abonnement requis pour débloquer cette voie »
  (`fr.ts:465 premiumHint`) — vocabulaire périmé (le modèle est l'entitlement par parcours,
  « pas d'abonnement mensuel » dit le paywall lui-même) et **faux** : le quiz de compréhension et
  les missions difficulté 1 sont gratuits (free preview) ; (b) le hub matière n'affiche **aucun**
  verrou ni badge gratuit/premium — 100+ missions toutes cliquables, le mur se découvre après le
  clic sur `/quest` ; (c) le paywall (`subscription-paywall.tsx`) dit « accordé par
  l'administrateur (pas d'abonnement mensuel). Contacte-le… » (`fr.ts:288-291`) — un élève
  (mineur !) est invité à téléphoner à « l'administrateur », sans proposition de valeur, sans
  prix, sans mention du parent-payeur ni du free preview. (d) Le footer public affiche « 100 %
  gratuit · toute l'école tunisienne » sur les mêmes écrans. Aucun de ces quatre récits ne
  raconte le vrai modèle : _lire est gratuit, s'entraîner d1 + quiz est gratuit, le concours
  complet est premium par parcours_.
- **A-4 — Le dashboard essaie d'être six écrans à la fois** (détail §B-1) : identité + lien
  parent + cross-sell concours + action du jour + donjon/duels + quêtes quotidiennes/hebdo +
  citation + **catalogue complet du parcours** (= doublon de `/parcours`) + **tous les sujets
  des autres thèmes** (~25 cartes à plat = doublon dégradé de `/programme`) + radar + inventaire +
  badges + **boutique entière** (13 articles). ~30 hauteurs d'écran mobile pour un compte neuf.
- **A-5 — Le first-run n'existe pas.** Un compte neuf reçoit « Bon retour » (`welcomeBack`),
  quatre pastilles à zéro, une barre 0/200, un radar vide, « Ton inventaire est encore vide »,
  « Aucun badge débloqué », un classement où il n'est nulle part — l'app s'affiche à J1 comme un
  tableau de zéros au lieu d'un début d'aventure. Aucun état « première fois » nulle part.
- **A-6 — Frontières linguistiques non pensées au niveau contenu.** Chrome UI dans la locale
  (FR/AR/EN) autour d'un CONTENU dans sa langue d'enseignement (ex. quiz math 9ème en arabe sous
  bandeau « QUESTION 1/5 · Valider » français) — assumé mais jamais signalé à l'élève ; chips de
  la bannière concours en français dans l'UI arabe (« Bac Sciences expérimentales »… — noms de
  parcours non localisés, capture `dashboard--ar-mobile`) ; classe de héros « Candidat Civil »
  jamais traduite ; en locale AR, la liste « autres thèmes » montre des sujets FR/EN (« Culture
  générale – Histoire (FR) », …) — filtrage `filterSubjectsByLocale` à vérifier.
- **A-7 — L'enjeu est rarement annoncé avant le clic.** Le quiz de compréhension ne dit pas
  qu'il **déverrouille les missions du chapitre** (le contrat pédagogique central du produit
  est invisible, §B-5) ; les missions du hub n'affichent ni gain XP ni état (fait/à refaire) ;
  les quêtes hebdo affichent des types bruts non traduits (« beat 2 bosses », §B-1).

## B. Boucle cœur connectée (auditée sur captures + code par l'architecte)

### B-1 Dashboard — « Hall des Héros » (`/dashboard`)

- **Job & moment** : le QG quotidien — « où j'en suis, que faire maintenant » ; ouvert à chaque
  session.
- **Action n°1** : reprendre/démarrer la mission du jour. **Non visible sans scroll mobile** :
  le premier viewport est consommé par le hero (identité, 4 pastilles à zéro, barre XP, **code
  alliance de 36 caractères** avec bouton Copier) puis la bannière concours ; la bande d'action
  (`DashboardFocus`, la pièce maîtresse du redesign #345) n'arrive qu'en 3e bloc
  (`dashboard.tsx:252-356` : HERO → `FlagshipConcoursBanner` → `DashboardFocus`). Capture :
  `dashboard--fr-mobile--fold.png`.
- **Blocs (ordre réel)** : hero+alliance → bannière concours (8 chips, y c. 6 variantes Bac
  pour un élève de 9ème) → bande focus (Reprendre + objectif du jour + Donjon/Duels) → opt-in
  push → quotidiennes/hebdo → citation → « Voies à conquérir » (6 matières) + « Autres thèmes »
  (~25 cartes) → radar → inventaire → badges → boutique (13 articles). ~30 hauteurs d'écran
  mobile (`dashboard--fr-mobile.png`).
- **Ce qui manque** : un mode first-run (accueil, pas « Bon retour » ; guider vers LA première
  mission) ; l'état du free preview sur les cartes matières (toutes marquées PREMIUM sans
  nuance) ; un accès « boutique/inventaire/badges » comme destinations propres.
- **Ce qui est en trop** : les doublons de `/parcours` et `/programme` (A-4) ; le code alliance
  en position 2 du hero pour TOUT élève à CHAQUE session (jamais réduit une fois le parent lié —
  et l'état « parent lié » n'est même pas affiché) ; la boutique complète inline.
- **Microcopy** : « Bon retour » à un compte neuf ; « CANDIDAT CIVIL » (classe de héros)
  cryptique et non traduit ; « ATTRIBUTE - AGILITÉ » semi-anglais sur les cartes sujets ;
  types de quêtes bruts non traduits (« beat 2 bosses » rendu tel quel via
  `formatQuestType`) ; « PLUS LONG STREAK 0d » (« 0d » anglicisme) ; « Partage ce code avec ton
  parent pour activer le suivi mentor » (« suivi mentor » jargon, AR « مع والدك » = « ton père »).
- **Cul-de-sac** : non (trop de sorties, c'est l'inverse — 15+ CTA concurrents).
- **Constats** :
  - [MAJEUR] L'action prioritaire est sous la ligne de flottaison mobile, derrière l'identité
    et un cross-sell — inversion exacte de l'intention #345 (« one prioritized action front and
    center »).
  - [MAJEUR] Six écrans en un (A-4) : catalogue ×2, boutique, inventaire, badges, stats sur la
    même page ; aucune hiérarchie possible à cette densité.
  - [MAJEUR] First-run absent (A-5).
  - [MOYEN] Code alliance : mauvaise cible (l'élève, à chaque session) pour un job du parent,
    au mauvais moment (avant toute action d'apprentissage) ; pas d'état « lié/non lié ».
  - [MOYEN] Bannière concours au-dessus de l'action du jour + chips non pertinentes pour le
    parcours actif de l'élève ; en AR les chips restent en français (A-6).
  - [MOYEN] « Autres thèmes » : ~25 cartes à plat, tous niveaux CEFR mélangés, zéro
    regroupement par thème — inutilisable comme navigation, redondant avec Découvrir.
  - [MINEUR] « Signaler un bug » (launcher flottant) chevauche la bande focus sur desktop
    (`dashboard--fr-desktop.png`).
  - [MINEUR] Le bouton « CLASSEMENT » est posé dans l'en-tête de la section matières — hors
    sujet (le classement a déjà sa place en nav).

### B-2 Carte de l'aventure (`/parcours`)

- **Job & moment** : vue « progression dans mon parcours » — où j'en suis, où aller ensuite.
- **Action n°1** : ouvrir la matière du moment. Non visible d'emblée : le premier viewport
  mobile est un en-tête qui **re-duplique le niveau/XP du dashboard** (« Niveau 1 · CANDIDAT
  CIVIL · 0/200 XP · 200 XP avant le niveau suivant ») ; le premier nœud arrive au scroll
  (`parcours--fr-mobile--fold.png`).
- **Blocs** : carte-titre (« Carte de l'aventure — Choisis ta voie, débloque les régions et
  deviens une légende ») + niveau/XP → nœuds matières en zigzag (~1,5 nœud par écran mobile,
  beaucoup de vide) → (bug-launcher flottant qui chevauche les libellés).
- **Ce qui manque** : par nœud, TOUTE information de contenu (nb de chapitres, missions
  faites/total, prochaine étape) — le nœud n'affiche que nom + état verrou ; un « continuer
  ici » ; la notion de « régions » promise par le sous-titre n'existe pas à l'écran.
- **Ce qui est en trop** : la re-duplication niveau/XP ; le message de verrou répété sous
  chaque nœud.
- **Microcopy** : « Abonnement requis pour débloquer cette voie » sous chaque nœud pour un
  compte free (A-3a — périmé ET faux) ; « déviens une légende » ok registre RPG.
- **Cul-de-sac** : non (chaque nœud → `/matiere/$id`), mais la promesse est trompeuse : le
  nœud dit « verrouillé » puis la page matière ouvre tout (A-3b).
- **Constats** :
  - [MAJEUR] Le récit premium de la carte contredit le hub ET le vrai modèle (A-3).
  - [MOYEN] Densité d'information quasi nulle par nœud : la carte n'aide pas à décider où
    aller ; 6 nœuds occupent ~4 écrans mobile.
  - [MINEUR] En-tête redondant avec le dashboard ; bug-launcher chevauche un nœud
    (`parcours--fr-mobile--fold.png`).

### B-3 Hub matière (`/matiere/$subjectId`, page publique partagée — capturé connecté free & premium)

- **Job & moment** : LE sommaire d'une matière — choisir chapitre, lire le cours, lancer une
  mission. C'est l'écran pivot de tout l'apprentissage.
- **Action n°1** : pour un compte neuf, « commence le chapitre 1 : lis le cours puis passe le
  quiz ». Rien ne la désigne : 14 cartes chapitres égales, ~9 hauteurs d'écran desktop
  (`matiere-authed--fr-desktop.png`), aucune poursuite (« reprendre ici »), aucun état.
- **Blocs** : titre matière + une ligne de description → 14 cartes chapitre identiques (titre,
  description, bouton « Lire le cours », puis la liste plate de TOUTES les missions du chapitre :
  quiz ⭐ puis missions ⭐→⭐⭐⭐⭐ avec XP).
- **Ce qui manque** (le « L2 » différé du C8, documenté dans `e2e/pages/subject.page.ts:9-14`) :
  état par mission (faite/score/à refaire), verrous quiz-gate et premium AVEC le récit du free
  preview, progression par chapitre (x/y missions), « continuer ici », et — connecté — la nav
  jeu (A-2) + un fil retour vers `/parcours`.
- **Ce qui est en trop** : rien à retirer, mais TOUT est au même niveau (aucun accordéon/
  hiérarchie) — 100+ lignes de mission d'un coup.
- **Microcopy** : correcte (titres de missions ⭐ conformes au style contenu) ; chrome FR sur
  contenu AR (A-6) ; footer « 100 % gratuit » sous un parcours premium (A-3d).
- **Cul-de-sac** : non (chaque ligne est un lien), mais pour un free les liens d2+ mènent au
  mur sans avertissement (A-3b).
- **Constats** :
  - [MAJEUR] L'écran pivot n'a AUCUN état de gameplay : ni progression, ni verrous, ni reprise —
    la promesse gamifiée s'arrête à la porte de l'apprentissage (régression C8 assumée puis
    oubliée).
  - [MAJEUR] Free preview invisible au moment exact de la décision (A-3).
  - [MOYEN] 14 chapitres × ~8 missions à plat sans reprise ni hiérarchie de lecture.
  - [MOYEN] Coquille publique pendant l'apprentissage connecté (A-2).

### B-4 Lecteur de cours (`/chapitre/$chapterId`, page publique partagée — capturé connecté)

- **Job & moment** : lire/réviser la leçon ; l'étape « théorie » avant le quiz.
- **Action n°1** : lire, puis « S'entraîner sur ce chapitre » — le CTA existe, en bas de page,
  auth-aware (`lesson-reader.tsx:153-159`). Bon.
- **Blocs** : fil d'ariane (matière · 1/14) → titre → onglets Cours/Résumé + Imprimer → leçon
  (registre riche et soigné, RPG assumé) → CTA s'entraîner → chapitre suivant → **invite
  « Apprends en jouant — Crée ton compte gratuit… »** → footer public.
- **Ce qui manque** : position dans le parcours du chapitre (le quiz à venir n'est pas
  annoncé : « après la lecture, passe le quiz pour déverrouiller les missions ») ; sommaire/
  progression de lecture pour les longues leçons (~4400 px).
- **Ce qui est en trop** : l'invite de création de compte **affichée à un élève connecté** —
  l'`<aside>` (`lesson-reader.tsx:193-197`, clés `t.public.reader.inviteTitle/inviteCta`,
  `fr-public.ts:118-121`) est rendue sans condition alors que le composant REÇOIT
  `isAuthenticated` (`chapitre.$chapterId.tsx:49`) — « sauvegarder ta progression » dit à un
  élève qui A un compte de s'en créer un (`chapitre-authed--fr-desktop.png`).
- **Microcopy** : leçon exemplaire (callouts, ton RPG dosé) ; chrome FR sur contenu AR (A-6).
- **Cul-de-sac** : non (s'entraîner + chapitre suivant). Bonne base.
- **Constats** :
  - [MAJEUR] Invite « Crée ton compte gratuit » servie aux connectés (bug de contenu, confiance).
  - [MOYEN] Le contrat quiz-gate n'est pas annoncé à la fin de la lecture (l'élève ne sait pas
    que le quiz est LA prochaine étape attendue).
  - [MINEUR] Pas de repère de progression de lecture ; « 1/14 » cryptique.

### B-5 Mission / quiz (`/quest/$exerciseId` — capturé : quiz de compréhension, free & premium)

- **Job & moment** : répondre — le moment de concentration maximale du produit.
- **Action n°1** : répondre à la question. Visible et focalisée. Le player est sain : question
  centrée, options A-D, « Valider » désactivé tant que rien n'est choisi, « Quitter la quête »,
  raccourcis clavier annoncés, compteur « QUESTION 1/5 » (`quest-free--fr-desktop.png`).
- **Ce qui manque** : le CONTEXTE et l'ENJEU — ni matière/chapitre, ni « ce quiz déverrouille
  les missions du chapitre » (A-7), ni seuil de réussite, ni gain annoncé ; pour une mission
  premium verrouillée, le paywall arrive à nu (A-3c). Les états résultat/récompense n'ont pas pu
  être capturés (à faire au lot).
- **Ce qui est en trop** : rien — c'est l'écran le plus propre de l'app.
- **Microcopy** : « تم تسجيل إجابتك. ستظهر نتيجتك في نهاية الاختبار » placé sous la question
  AVANT toute réponse (explication de mode affichée au mauvais moment) ; chrome FR sur contenu
  AR (A-6).
- **Constats** :
  - [MAJEUR] Le contrat pédagogique du quiz-gate est invisible sur l'écran du quiz lui-même
    (A-7) — l'élève ne sait ni pourquoi il passe ce quiz ni ce que la réussite débloque.
  - [MOYEN] Aucun contexte (matière/chapitre/étoiles/gain) dans l'en-tête de mission.
  - [MINEUR] Explication de mode placée avant la première réponse.

## C. Coquille publique de conversion + auth (audit délégué, revu par l'architecte)

### C-1 Landing (`/`)

- **Job & moment** : vitrine d'entrée ; trois audiences simultanées (élève, parent sceptique,
  enseignant) au premier contact. Doit prouver la crédibilité ET router chaque persona.
- **Action n°1** : « Explorer le programme » — visible sans scroll mobile : **oui** (badge
  gratuit + H1 + 2 CTA au-dessus du pli, `landing--fr-mobile--fold.png`).
- **Blocs (ordre réel)** : header 2-3 rangées mobile → hero (badge « 100 % gratuit · sans
  inscription », H1, 2 CTA) → 3 portes persona → 3 cartes cycles → 2 cartes langues CECRL →
  bandeau preuve ×3 → Espace Famille (4 bénéfices + 3 étapes + CTA) → bloc Jeu doré + image
  manga → footer. **~17 écrans de scroll mobile**, tout en 1 colonne (`landing--fr-mobile.png`).
- **Ce qui manque** : toute preuve tangible — aucun chiffre (cours/exercices/niveaux), aucun
  « voir un exemple de cours » cliquable, ni à-propos, ni contact, ni FAQ ; « Conforme au
  programme officiel tunisien » affirmé deux fois, jamais démontré. La porte enseignant promet
  « prêtes à imprimer » mais route vers le même `/programme` que l'élève
  (`public-landing.tsx:160`).
- **Ce qui est en trop** : 4 des 5 premiers liens → `/programme` ; CTA hero n°2 « Les extras »
  (jargon interne) ; cartes cycles répètent le H1.
- **Microcopy** : bon ton global (vouvoiement parent / tutoiement élève, AR idiomatique).
  Faibles : « Les extras » / « الإضافات », « Un atout transverse » (`fr-public.ts:50`),
  « Découvrir » ×3 identiques. Récit famille contradictoire : les 3 étapes exigent un compte
  parent (`fr-public.ts:69`) mais le CTA principal ouvre `/suivi` sans compte
  (`public-landing.tsx:335-341`).
- **Cul-de-sac** : non, mais le footer est une impasse de crédibilité (ni contact, ni à-propos,
  ni lien Suivi — `public-footer.tsx`).
- **Constats** :
  - [MAJEUR] Zéro preuve vérifiable pour le sceptique ; la seule image du site est un guerrier
    manga au sabre — brouille le signal « sérieux, conforme » (`landing--fr-desktop.png`).
  - [MOYEN] Récit Espace Famille incohérent (compte requis vs CTA sans compte).
  - [MOYEN] Portes élève/enseignant indifférenciées (même destination, même CTA) ; la promesse
    enseignant n'a aucune page qui l'honore.
  - [MOYEN] ~17 écrans mobile ; le bloc Jeu (seul argument « enfant ») au 15e écran.
  - [MINEUR] Header mobile 3 rangées (~14 % du viewport) ; marque en latin seul en AR mobile
    (نقرا نلعب masqué sous `sm`, `public-header.tsx:40`).

### C-2 Auth (`/auth` — cibles de `/login` et `/signup`)

- **Job & moment** : convertir le clic « Créer mon compte » (élève OU parent via
  `?role=parent`) et reconnecter l'existant. Moment de confiance maximale (email d'un mineur ou
  d'un parent payeur).
- **Action n°1** : soumettre le formulaire — visible sans scroll mobile en login
  (`auth--fr-mobile.png`) ; en signup le bouton passe vraisemblablement sous le pli (rôle + nom
  - code Alliance en plus).
- **Blocs** : logo → carte unique : titre → Google → note « session mémorisée » → « ou » →
  [signup : rôle → nom (→ code Alliance parent)] → email → mot de passe → submit → bascule.
- **Ce qui manque** : **« Mot de passe oublié »** — aucun flux de récupération dans tout `src/`
  (grep `oubli|forgot|reset` : 0 hit hors i18n de test) : mot de passe perdu = compte et
  progression définitivement perdus. Aucune mention CGU/confidentialité/consentement mineurs au
  signup (pas de footer légal sur cette page). Aucun rappel de la promesse gratuite. Pas de
  sélecteur de langue (`auth.tsx` ne rend pas `LanguageSwitcher`).
- **Ce qui est en trop** : la note technique « Session mémorisée… » avant même la connexion
  (`fr.ts:39-40`).
- **Microcopy** : **rupture de registre totale** avec la coquille publique sobre : « Forge ton
  héros », « Quelques secondes pour entrer dans l'arène », « Choisis ton rôle dans la guilde »,
  « Parent · Mentor », champ « Nom de héros » même quand le rôle Parent est sélectionné
  (`auth.tsx:349`), « Forger mon héros », « Déjà un héros ? » ; AR idem (« اصنع بطلك »,
  « ادخل الحلبة »). Tutoiement systématique, y compris pour l'adulte payeur. À préserver : les
  messages d'erreur actionnables (`fr.ts:60-69`) et l'écran « Confirme ton email » bien raconté.
- **Cul-de-sac** : happy path fluide ; mot de passe perdu = cul-de-sac absolu ; aucun chemin
  « continuer sans compte » vers le contenu public.
- **Constats** :
  - [MAJEUR] Registre RPG sur l'écran de conversion, pire cas : le tunnel parent
    (`auth.tsx:269-352`, `fr.ts:34-53`, `signup--fr-desktop.png`). La refonte visuelle de
    l'auth est le lot 4 de l'étude 14 ; le REGISTRE DU TEXTE par audience est à décider ici.
  - [MAJEUR] Aucun flux « mot de passe oublié ».
  - [MAJEUR] Aucun consentement/lien légal au signup (mineurs + parent payeur).
  - [MOYEN] Méta de la route sur l'ancien pitch payant : « …commence ta préparation aux
    concours nationaux » (`auth.tsx:29-33`) — contredit le pivot gratuit pour partage/SEO.
  - [MOYEN] Pas de sélecteur de langue sur `/auth` (lien partagé AR → page FR sans issue).

### C-3 Extras (`/extras`)

- **Job & moment** : catalogue des parcours hors programme (langues, culture G, logique) —
  exploration secondaire.
- **Action n°1** : ouvrir un parcours — visible sans scroll mobile : oui.
- **Blocs** : kicker + H1 « Extras » + 1 phrase → 5 cartes uniformes → footer. Page creuse
  desktop (~60 % de blanc, `extras--fr-desktop.png`).
- **Ce qui manque** : différenciation des cartes (toutes portent « Cours · résumés ·
  exercices ») ; bénéfice/volume/badge CECRL (la landing vend le CECRL, la page ne le montre
  pas) ; toute suite après les cartes (pas de retour `/programme`, pas d'invitation compte).
- **Ce qui est en trop** : carte « IB » annoncée « Bientôt », titre tronqué desktop.
- **Microcopy** : « Extras » titre-jargon sans valeur. **Noms de parcours non localisés** : FR
  affiché en AR/EN (`parcours-catalogue.tsx:214` rend `p.name_fr` en dur ;
  `dashboard.server.ts:343` ne sélectionne pas `name_ar`/`name_en` qui existent en base).
- **Cul-de-sac** : oui — après les 5 cartes, rien.
- **Constats** :
  - [MAJEUR] Noms de parcours non localisés (colonnes localisées déjà en base, non
    sélectionnées).
  - [MOYEN] Cartes indifférenciées — la page n'aide pas à choisir.
  - [MOYEN] Cul-de-sac total en bas de page.
  - [MINEUR] Carte IB « Bientôt » tronquée, valeur nulle aujourd'hui.

### C-4 Suivi parent sans compte (`/suivi`)

- **Job & moment** : LE produit-parent sans friction : coller le code de l'enfant → voir le
  bilan, sans compte. Parent souvent peu technophile, sur mobile.
- **Action n°1** : saisir le code — visible sans scroll mobile : oui.
- **Blocs** : titre « Rapport de suivi » → carte formulaire (« Associer un élève via Alliance
  Code », champ « Code élève », bouton « Associer » désactivé) → **~70 % de page vide**
  (`suivi--fr-desktop.png`).
- **Ce qui manque** : la promesse « sans compte, sans connexion » (seule la méta le dit) ; ce
  que contient le bilan ; un aperçu/exemple ; l'aide concrète pour trouver le code ; le plan B
  « votre enfant n'a pas de compte → créez-le » ; la note de confidentialité (accès au porteur
  du code). L'état vide n'est pas raconté : c'est un blanc.
- **Microcopy** : vocabulaire de la page parent authentifiée réutilisé tel quel : « Associer »
  / « ربط » pour une simple consultation ; trois noms pour le même code dans un même tunnel
  (« code Alliance » landing, « Alliance Code » titre, « Code élève » placeholder,
  `fr.ts:575-576`) ; « L'élève trouve son code dans son **dashboard** » (anglicisme adressé au
  parent le moins technophile, `fr.ts:580`).
- **Cul-de-sac** : avant saisie, oui ; l'erreur affiche le message serveur sans rattrapage.
- **Constats** :
  - [MAJEUR] Page-clé du persona payeur réduite à un formulaire nu, muette sur sa propre
    promesse (`suivi.tsx:72-144`).
  - [MAJEUR] `/suivi` est **orpheline** : absente du header ET du footer publics (unique lien :
    le bloc famille de la landing, `public-landing.tsx:336` ; `public-header.tsx:49-61` ne
    liste que Programme/Extras).
  - [MOYEN] Terminologie du code incohérente + verbe « Associer » erroné.
  - [MINEUR] Bouton désactivé (< 8 caractères) sans explication du format. À préserver :
    deep-link `?code=`, partage WhatsApp/natif, impression (`suivi.tsx:52-59,147-157`).

## D. Chaîne catalogue → pratique anonyme (audit délégué, revu par l'architecte)

> Limite de capture actée : les 6 captures `/exercice/$exerciseId` montrent toutes le même état
> « quiz-gate verrouillé » — jamais le player en jeu ni le résultat (audités sur code). C'est en
> soi un signal : l'exercice « au hasard » tombe sur le mur, comme le fera tout anonyme frais.

### D-1 Programme (`/programme` — catalogue officiel, aussi cible des redirects « Découvrir »)

- **Job & moment** : trouver **sa classe** parmi 13 niveaux + sections ; première impression.
- **Action n°1** : choisir sa carte de classe — visible sans scroll mobile : oui.
- **Blocs** : header → kicker + H1 « Toute l'école tunisienne » → Primaire (6 cartes) →
  Collège (3) → Lycée (**16 cartes dont 15 « Bientôt disponible »**) → carte Extras → footer.
  ~25 cartes empilées mobile (`programme--ar-mobile.png`, ~9 260 px).
- **Ce qui manque** : toute différenciation de richesse (chaque carte porte le même « Cours ·
  résumés · exercices », `fr-public.ts:99` — aucun volume ; la 9ème, produit phare, n'est promue
  que par un badge) ; une **capture d'intérêt** sur les 15 cartes mortes du lycée — le vote
  `parcours_interest` existe côté serveur mais n'est pas exposé au public
  (`parcours-catalogue.tsx:96-102`) : levier de conversion perdu.
- **Ce qui est en trop** : le mur lycée (15/16 désactivées) dilue la moitié basse de la page.
- **Microcopy** : sous UI arabe, **tous les noms de niveaux restent en français** (« 1ère année
  de base », « 2ème Sciences »…) — `label={p.name_fr}` (`parcours-catalogue.tsx:160`),
  `name_ar`/`name_en` existent en base, ni peuplés ni sélectionnés (`dashboard.server.ts:343`) ;
  titres tronqués sans recours (« 2ème Technologies de l'infor… », `parcours-catalogue.tsx:73`).
- **Constats** : [MAJEUR] catalogue FR-only sous UI AR ; [MOYEN] 15 cartes mortes sans capture
  d'intérêt ni compactage ; [MOYEN] cartes indifférenciées sans volumétrie ; [MINEUR]
  troncature des noms de sections.

### D-2 Niveau (`/niveau/$parcoursId`)

- **Job** : choisir une matière ; écran de transit, décision < 5 s. Action n°1 visible : oui.
- **Blocs** : retour Programme → H1 = nom du parcours → sous-titre → (bouton « Choisir ce
  parcours » si connecté) → grille matières (nom + **attribut RPG** + chevron).
- **Constats** :
  - [MAJEUR] (partagé D-1) H1 = `name_fr` sous UI AR (`parcours-subjects.tsx:61`).
  - [MOYEN] L'**attribut RPG comme unique métadonnée** de carte (« Force », « Esprit », « قيم » —
    jargon du registre Jeu dans le registre public, mono-FR + incohérences d'accents
    « Vitalite »/« Agilite » dans `content/*/subject.json`) au lieu d'une info utile (nb de
    chapitres, langue d'enseignement) ; `getParcoursSubjects` ne remonte aucune volumétrie
    (`dashboard.server.ts:399`).
  - [MINEUR] État vide « Reviens bientôt ! » sans action (même levier de vote manqué).

### D-3 Hub matière (`/matiere/$subjectId` — vu côté anonyme ; complément du §B-3)

- **Action n°1** : « Lire le cours » du chapitre 1 — visible mobile : de justesse (~55 % du
  fold).
- **Ce qui manque** (en plus du §B-3) : **ancrage de niveau** — le kicker affiche l'attribut
  RPG « FORCE » au lieu de « 1ère année de base » : un arrivant par lien direct ne sait pas de
  quelle classe est la matière (`subject-hub.tsx:59-72`) ; **aucune remontée** vers
  `/niveau/$parcoursId` (seul écran de la chaîne sans lien retour) ; **le gate quiz est
  invisible en amont** alors que la donnée est déjà servie — `getSubject` retourne
  `quizPassedByChapter` (`quest.server.ts:219-246,300`) et `SubjectHub` l'ignore : toutes les
  lignes se ressemblent, le parcours réel de tout anonyme est clic → mur.
- **Ce qui est en trop** : « ⚡ 20/50/120/300 XP » par ligne pour un anonyme qui ne peut pas en
  gagner et à qui personne n'a expliqué l'XP ; **difficulté en double** « Niv. 3 » (UI) +
  « ⭐⭐⭐ » (titre contenu) sur la même ligne, la troncature mobile avalant le titre au profit
  des métadonnées (`subject-hub.tsx:115-127`).
- **Constats** : [MAJEUR] gate quiz invisible en amont (donnée ignorée) ; [MAJEUR] pas
  d'ancrage niveau ni de remontée ; [MOYEN] ~12 150 px mobile sans divulgation progressive ;
  [MOYEN] XP aux anonymes sans explication + difficulté en double.

### D-4 Lecteur (`/chapitre/$chapterId` — vu côté anonyme ; complément du §B-4)

- **Bon** : l'écran le mieux maillé de la chaîne (breadcrumb, Cours/Résumé, Imprimer,
  prev/next, CTA pratique).
- **Constats** :
  - [MAJEUR] **L'invite de conversion ment sur l'offre** : « Crée ton compte gratuit **pour
    t'entraîner sur les exercices**… Lire le cours reste toujours libre »
    (`fr-public.ts:119-121`, idem AR) alors que la pratique est **gratuite sans compte** — la
    landing promet « Entraîne-toi… sans compte » (`fr-public.ts:38`) et le CTA voisin lance
    l'entraînement sans compte. À recentrer sur les vrais gains (XP, sauvegarde, déblocages
    conservés, classement) — l'invite du résultat d'exercice, elle, est correcte
    (`fr-public.ts:148-149`).
  - [MAJEUR] Le CTA « S'entraîner sur ce chapitre » pointe le 1er exercice **non-quiz**
    (`quest.server.ts:360`) ⇒ tout frais arrivant atterrit sur « 🔒 Exercice verrouillé » ; il
    devrait mener au quiz tant que le chapitre n'est pas débloqué.
  - [MINEUR] Pas de sommaire/ancres sur cours longs (~7 200 px mobile).

### D-5 Practice player anonyme (`/exercice/$exerciseId` — capturé : état verrouillé ; player audité sur code)

- **Bon** : le gate verrouillé est le meilleur état d'erreur de la chaîne (pourquoi + 3 sorties
  hiérarchisées : passer le quiz / relire le cours / retour matière).
- **Constats** :
  - [MAJEUR] **Happy-path rompu après le quiz réussi** : pas de « Continuer vers le 1er
    exercice » pour l'anonyme (`capabilities.next: false`, `exercice.$exerciseId.tsx:46`) — au
    pic de motivation (« ✅ Bravo ! … débloqués »), retour manuel sur une page matière de
    12 000 px ; la machinerie `computeNextExerciseId` existe déjà pour le connecté.
  - [MOYEN] **Deux systèmes de langue sur le même écran** : les libellés `QL.*` suivent la
    langue du CONTENU (`quest-labels.ts`) quand `t.quest.*` suit la langue UI → « Victoire ! »
    (FR) + « ✅ تهانينا! » (AR) mélangés sur un même résultat ; + registre RPG (« Bien essayé,
    guerrier », « Préparation de l'arène… ») exposé au public sobre (`fr.ts:149-164`).
  - [MOYEN] « Temps validé côté serveur » **inexact en anonyme** (durée mesurée côté client,
    `fr.ts:185`, `exercise-player.tsx:166,323-326`).
  - [MOYEN] L'invite signup du résultat n'exploite pas le bénéfice le plus concret : les
    déblocages anonymes vivent en `sessionStorage` (`anon-quiz-gate.ts:19-43`) — « garde tes
    chapitres débloqués » n'est jamais dit.
  - [MINEUR] Doublons icône+emoji sur le gate (Lock + 🔒, Brain + 🧠,
    `quiz-lock-screen.tsx:40,48`).

## E. Arène — donjon, duel, classement (audit délégué, revu par l'architecte)

> Deux caveats de protocole actés : (1) les captures donjon free/premium sont **identiques**
> (verrou PREREQ) — le compte « free » seedé porte un entitlement résiduel (les grants d'un
> ancien run e2e ne sont ni purgés par `reset-gameplay` ni révoqués par le seed pour le compte
> free) → l'état **paywall** et l'état **débloqué** du donjon n'ont pas été capturés, audités
> sur code ; (2) les cadres vides en bas des captures leaderboard = artefact
> `content-visibility: auto` en screenshot pleine page, pas un bug.

### E-1 Donjon (`/dungeon` — capturé : état verrou prérequis « Matières entamées : 0/2 »)

- **Job & moment** : le mode compétitif solo à enjeu (survival, 1 vie) ; l'écran de verrou fait
  office de first-run.
- **Action n°1** : « Continuer à m'entraîner » (→ dashboard) — visible mobile : oui, en toute
  limite basse du fold.
- **Blocs** : retour « Hall des Héros » → carte héro (pitch 3 phrases) → 3 tuiles règles
  (15 XP/étage · 5 coins/5 étages · 1 vie — **bon modèle** règle+chiffre+icône) → carte d'état
  verrou (compteurs 0/2, 0/3 + bouton).
- **Ce qui manque** : le **record personnel** (« Jusqu'où peux-tu aller ? » sans mémoire ni
  objectif à battre) ; le **modèle à double porte raconté en entier** — le paywall générique ne
  nomme ni le Donjon ni les prérequis (`subscription-paywall.tsx:14-34`, `fr.ts:288-291`),
  l'écran prérequis ne confirme jamais l'accès premium acquis : **un acheteur neuf est
  accueilli par un verrou sur le privilège qu'il vient de payer** (ordre RPC
  SUBSCRIPTION → PREREQ → LEVEL → DAILY_LIMIT,
  `20260608123000_dungeon_parcours_gate.sql:87-97`) ; la règle « runs quotidiens = niveau
  (max 5) » invisible ; le CTA de sortie renvoie au dashboard générique au lieu de LA prochaine
  action qui débloque (entamer un 1er chapitre).
- **Microcopy** : « Matières **entamées** » (registre adulte pour 6-12 ans) ; **rupture FR↔AR
  sur le nom du mode** : « Le Donjon Infini » vs « **الزنزانة اللانهائية** » (= la cellule de
  prison infinie — champ lexical carcéral, `ar.ts:194`) ; « **Courses** aujourd'hui » ambigu
  (l'AR « الجولات » est plus clair). Bon : « Une mauvaise réponse et c'est fini. »
- **Constats** :
  - [MAJEUR] Le modèle premium+prérequis n'est jamais raconté en entier — chaque état ne montre
    qu'une porte.
  - [MAJEUR] Aucun record personnel / high-score au lobby.
  - [MOYEN] AR « الزنزانة » contredit le ton RPG.
  - [MOYEN] `/dungeon` classé « immersif » (`_authenticated.tsx:143`) : la tab-bar mobile
    disparaît **dès le lobby verrouillé** — un élève bloqué perd la navigation principale.
  - [MINEUR] Règle niveau→runs/jour invisible ; « Courses » ambigu.

### E-2 Duel (`/duel` — lobby, historique et ligue vides)

- **Job & moment** : hub du 1-contre-1 asynchrone + ligue hebdo ; premier contact — l'écran
  doit vendre le mode.
- **Action n°1** : « Trouver un adversaire » — visible mobile : oui, net.
- **Blocs** : h1 → carte file d'attente (1 phrase + CTA) → historique (vide : « Aucun duel pour
  l'instant. Lance-toi ! ») → ligue (« victoire 3 pts, nul 1 pt » + vide). Tout tient en un
  écran.
- **Ce qui manque** (mesuré contre `docs/guide-duels-et-ligues.md`) : **aucune récompense
  affichée nulle part** — victoire 60 XP/12 pièces, nul 40/8, **défaite 20/4 (participer paie
  toujours)** (`gamification.ts:141-144`), paliers de ligue 100→5 pièces : silence complet sur
  « qu'est-ce que je gagne ? » ; **aucune règle du format** (5 questions, 24 h, rythme libre,
  3 duels actifs max, 5 récompensés/jour) avant de s'engager ; le fonctionnement asynchrone
  expliqué **seulement après le clic** (`duel-queue-card.tsx:30`) — la file vide, état le plus
  probable au lancement, est le moins raconté (recherche en boucle sans borne ni alternative) ;
  la ligue sans échéance (« se termine lundi ») ni finalité ; l'historique sans adversaire, ni
  date, ni verdict V/N/D — « Terminé — 3/5 » (`duel.tsx:158-174`, le serveur ne remonte ni nom
  ni outcome, `duel.server.ts:350-388`).
- **Microcopy** : AR cohérent et de bon ton (pas d'écart FR-AR notable).
- **Constats** :
  - [MAJEUR] Enjeu invisible (récompenses duel + ligue jamais affichées).
  - [MAJEUR] Règles du format absentes du lobby — engagement à l'aveugle.
  - [MOYEN] File vide non racontée ; historique illisible comme palmarès.
  - [MINEUR] Ligue sans échéance ; pas de lien retour (le donjon et le classement en ont un —
    patron incohérent).

### E-3 Classement (`/leaderboard` — base quasi vierge, comptes seed à 0 XP)

- **Job & moment** : se situer (global + par matière). Capturé en cold-start — le cas le plus
  important.
- **Action n°1** : aucune — consultation pure, aucun CTA.
- **Blocs** : retour → titre + sous-titre → 7 tabs (Global + 6 matières) → carte « mon rang »
  (**#1 — 0 XP**) → podium top 3 (0 XP) → 50 lignes.
- **Ce qui manque** : toute narration du cold-start — avec les égalités à 0 XP, `RANK()` donne
  **rang 1 à tout le monde** : « tu es #1 » à un élève qui n'a rien fait (faux ET démotivant —
  aucune raison de jouer si on est déjà premier), podium médaillé arbitraire à 0 XP, aucune
  passerelle d'action (« gagne tes premiers XP », lien duel/quêtes) ; période et assiette non
  dites (all-time, académie entière — `dashboard.server.ts:293-326`).
- **Ce qui est en trop** : 50 lignes identiques sans coupe (« top 10 + toi » suffirait) —
  ~5,7 écrans mobile ; le podium consomme un écran pour célébrer 0 XP.
- **Microcopy** : sous-titre « Les héros les plus puissants **du concours** » (`fr.ts:562`)
  **inexact** — le board couvre l'académie entière, le titre dit d'ailleurs « de l'Académie » ;
  tabs matières toujours en `name_fr` (`leaderboard.tsx:118`, `dashboard.server.ts:441`) →
  rangée bi-scripts non localisée en AR ; « Retour au hall » vs « Hall des Héros » — deux noms
  pour la même destination dans le même groupe.
- **Constats** :
  - [MAJEUR] Cold-start contre-productif (tous #1, podium à 0 XP, zéro narration ni CTA).
  - [MOYEN] Sous-titre inexact ; tabs mono-`name_fr` ; 50 lignes sans coupe.
  - [MINEUR] Période/assiette non explicitées.

### E-4 Constat transversal arène

- [MAJEUR] **Nav desktop 1280 px : « Duels » tronqué en « Du », « Classement » hors écran** —
  la nav du shell est un ruban `overflow-x-auto` à scrollbar masquée
  (`_authenticated.tsx:164-180`), sans affordance de scroll ; deux écrans du groupe sont quasi
  introuvables au desktop (toutes captures desktop). « Hall des Héros » casse sur 3 lignes.
  (Mobile OK : 6 items en tab-bar.)
- [MOYEN] **Les trois écrans compétitifs s'ignorent** : aucun lien croisé (classement ↛ duel,
  duel ↛ « où j'en suis », donjon ↛ rien) — le « pôle arène » n'existe que dans la nav.

## F. Parent & admin (audit délégué, revu par l'architecte)

### F-1 Rapport de suivi parent (`/parent-report` — capturé : 1 enfant lié, 100 % inactif)

- **Job & moment** : le payeur, souvent non-joueur, vient répondre à UNE question — « mon
  enfant travaille-t-il, que dois-je faire ? » — le soir, sur mobile. C'est de fait le seul
  écran « commercial » côté payeur.
- **Action n°1** : lire le verdict d'assiduité + le conseil. **Non visible sans scroll
  mobile** : le premier viewport est consommé par le header élève (chips XP/flamme du compte
  parent !), le titre, Partager/Imprimer, le formulaire « Associer un élève » (**déjà lié**) et
  « Objectif de la semaine » — le verdict « Inactif » arrive sous la flottaison
  (`parent-report.tsx:159-309`).
- **Blocs (ordre réel)** : retour au hall → titre + partage/impression → formulaire de liaison
  → objectif hebdo → carte élève (« Classe : Candidat Civil · Membre depuis… », chips Niveau/
  Streak) → verdict assiduité + jauge → conseil de la semaine → 4 métriques → semaine vs
  précédente → forces/faiblesses → tendance → activité 30 j → dernière activité.
- **Ce qui manque** : la **classe scolaire réelle** de l'enfant (grade/parcours jamais
  sélectionnés côté serveur, `parent-report.server.ts:226,303`) ; tout étage commercial (statut
  Gratuit/Premium de l'enfant, **pack famille** — jamais expliqué nulle part dans l'app —,
  chemin d'achat) ; des liens actionnables (conseil « Faites réviser {chapter} » et faiblesses
  non cliquables) ; un état vide raconté du graphe 30 j (barres grises à 4 % qui semblent
  cassées, `report-content.tsx:206-227`) ; la gestion du lien (voir/retirer) ; un vrai guidage
  premier-lien (l'état sans enfant = une ligne, `fr.ts:586`).
- **Ce qui est en trop** : la coquille élève entière (nav Donjon/Duels/Classement + bottom-bar
  gamer pour le rôle parent, « Suivi » icône sans libellé — `_authenticated.tsx:133-323`) ; le
  formulaire de liaison en tête même quand l'enfant est lié ; champ « relation » pré-rempli
  `"parent"` en dur, affiché en latin dans l'UI AR (`parent-report.tsx:43`).
- **Microcopy** : « **Associer un élève via Alliance Code** », « **Alliance réussie avec
  {name}** » — jargon RPG en anglais pour un parent FR (l'AR, lui, traduit → registre
  incohérent) ; « **Classe : Candidat Civil** » (classe RPG non traduite là où le parent lit
  « classe scolaire ») ; « **Streak 0j** » (`fr.ts:168`) ; « dans son **dashboard** »
  (`fr.ts:580`) ; « **Aucune lacune détectée ce mois-ci. Bravo !** » (`fr.ts:623`) sous un
  bandeau rouge « Inactif » ; erreurs de liaison **hardcodées en français tutoyé** non i18n
  (`parent-report.server.ts:18-36`) ; toast de déconnexion « À bientôt, guerrier. » adressé
  aussi au parent (`fr.ts:433`).
- **Cul-de-sac** : verdict rouge sans CTA ; conseil/faiblesses sans lien vers le contenu ;
  aucun chemin premium/pack famille ; « Retour au hall » ramène le parent au dashboard élève.
- **Constats** :
  - [MAJEUR] La réponse à la question n°1 du parent est enterrée sous deux blocs « outils »
    (mobile).
  - [MAJEUR] « Classe : Candidat Civil » — et la classe scolaire absente du rapport.
  - [MAJEUR] Écran payeur sans aucun contenu commercial (statut, pack famille, chemin d'achat).
  - [MAJEUR] Coquille de navigation 100 % élève pour le rôle parent.
  - [MAJEUR] Jargon gamer non traduit + erreurs serveur FR tutoyées non i18n.
  - [MOYEN] « Bravo ! » contradictoire à activité nulle ; graphe 30 j sans état vide raconté.
  - [MINEUR] Champ « relation » libre en dur, non expliqué.

### F-2 Admin (5 écrans, audit condensé)

- **`/admin/subscriptions` (accès parcours)** : [MAJEUR] l'octroi exige un **UUID brut**
  introuvable dans l'app (pas de recherche par email/nom, le tableau n'affiche pas l'UUID —
  `parcours-entitlements-admin.tsx:96-104`) — friction sur LE geste de vente ; [MOYEN]
  révocation sans confirmation (`:210-223`) ; [MINEUR] la bannière téléphone du paywall élève
  affichée à l'admin lui-même ; date d'octroi récupérée mais non affichée.
- **`/admin/beta-requests`** : [MOYEN] « Approuver » n'affiche ni quel parcours ni quelle durée
  sera accordée (`beta-access.server.ts:160-179`) — décision aveugle ; [MINEUR] pas de filtre
  par statut.
- **`/admin/content-reports`** : [MAJEUR] triage à l'unité sans lien vers l'exercice/question
  signalés (`exerciseId`/`questionId` retournés mais jamais exploités,
  `content-reports-admin.tsx:110-119`), sans regroupement des doublons, ni filtre ni pagination
  — inutilisable à quelques dizaines de signalements (capture : ~60 cartes, 8 400 px) ;
  [MINEUR] « Résolu » (état) à côté de « Rejeter » (action).
- **`/admin/bug-reports`** : [MOYEN] pas d'identité du rapporteur (impossible de recontacter),
  date sans heure ; mêmes absences de filtre/pagination.
- **`/admin/parcours-interest`** : [MINEUR] à zéro partout l'écran affiche un faux classement
  1→20 au lieu d'un état vide ; pas de dimension temporelle.

## G. Onboarding (`/onboarding` — audité sur code ; captures à faire au lot concerné)

- **Entrée/sortie réelles** : on n'y arrive QUE par le guard (`_authenticated.tsx:98-110` +
  `onboarding-guard.ts:12-22` : student sans `current_parcours_id`). Une seule sortie : taper
  une carte disponible → `set_current_parcours` → `/dashboard` codé en dur (le deep link
  intercepté n'est jamais restauré). Pas de skip. Un élève onboardé peut y revenir par URL
  (non lié depuis l'UI). Le header desktop reste cliquable pendant l'onboarding — chaque clic
  rebondit silencieusement (`_authenticated.tsx:143,167-180` ne masquent que la bottom-bar).
- **Flux réel (2 étapes, aucun autre input)** : Étape 0 « Que veux-tu faire ? » (2 cartes :
  « Suis le programme scolaire » / « J'explore librement » — voix incohérente impératif vs 1ʳᵉ
  personne, `fr.ts:488,490`). Étape 1a école « Quelle est ta classe ? » : **29 cartes dont 19
  « En construction » (66 %)** + doublons hérités (« 2ème/3ème année secondaire », « Préparation
  Concours Bac » cohabitent avec les 16 cartes sections ; `grades.is_selectable` n'est **lu
  nulle part** dans src/) ; la seule option lycée sélectionnable (« Préparation Bac
  Mathématiques ») est noyée en ~15ᵉ position. Étape 1b explorer : 5 cartes libres (IB
  coming_soon invisible ici, votable ailleurs — asymétrie). Fin sèche : pas de récap, pas de
  célébration, pas de première action suggérée (l'e2e page-object documente une étape
  « confirm » qui n'existe pas, `e2e/pages/onboarding.page.ts:3`).
- **Ce qui manque** : une étape promesse/éducation (XP, pièces, héros, série — jamais
  mentionnés avant le dashboard) ; un choix de langue explicite (défaut FR — un enfant
  arabophone de 1ère année tombe sur un écran français) ; une issue pour l'élève de classe
  « En construction » (tout lycéen hors bac-math : carte non cliquable alors que la RPC
  autorise ce choix par design, `20260608120000_parcours_entity.sql:221-222`) — **dead-end du
  funnel lycée** ; l'aperçu des matières avant engagement (la page publique
  `/niveau/$parcoursId` le fait mieux que l'onboarding) ; le signal premium/gratuit
  (`is_premium` transporté, jamais rendu) ; âge/consentement parental (cible 6-19 ans — sujet
  légal à trancher).
- **Constats** :
  - [MAJEUR] Picker école pollué : 19/29 coming_soon + doublons legacy + `is_selectable` non lu
    (`onboarding.tsx:243-252`).
  - [MAJEUR] Dead-end lycée (carte en construction non sélectionnable, pas de skip).
  - [MAJEUR] Noms de parcours `name_fr` dans les 3 locales (`onboarding.tsx:167,205`,
    `dashboard.server.ts:343` — `name_en`/`name_ar` ni peuplés ni sélectionnés).
  - [MAJEUR] Zéro pédagogie/promesse/célébration (sélection → dashboard sans transition).
  - [MOYEN] **Bug de rôle** : parent inscrit avec confirmation email → le rôle n'est pas dans
    les metadata du signUp (`auth.tsx:132-139`) et `bootstrapProfile` ne tourne pas sans
    session → profil créé `role='student'` par défaut → **parent piégé dans l'onboarding
    élève** (`onboarding-guard.ts:20`).
  - [MOYEN] Deep link perdu ; nav desktop cliquable en boucle ; pas d'aperçu matières.
  - [MINEUR] « Intéressé·e ✓ » (écriture inclusive peu adaptée à la cible) ; pas de h1 ; seed
    TEST/pgTAP incohérent avec prod sur la 7ème (migration d'ouverture supprimée du repo par
    #282).
- **À capturer au lot** : les 2 étapes FR+AR desktop/mobile, le groupe Secondaire complet
  (doublons), une carte « En construction » avant/après vote, l'état « Enregistrement… »,
  l'atterrissage dashboard post-choix, le funnel complet signup→première quête (nb de taps).

## H. Ce qui est déjà bon (à préserver)

- **Le player de mission** (B-5) : focalisé, sobre, raccourcis clavier, état désactivé propre —
  la primitive `QuestionInput` partagée quest/donjon/duel est le modèle à suivre.
- **Le contenu pédagogique lui-même** (leçons riches, callouts, missions étoilées ⭐→⭐⭐⭐⭐
  au vocabulaire homogène) — le problème est l'écrin, pas le contenu.
- **La bande focus du dashboard** (#345, `DashboardFocus`) : la bonne idée (UNE action + objectif
  du jour + 2 tuiles calmes) — elle est juste enterrée sous le hero et le cross-sell.
- **Le retour public→jeu par le logo/HUD** (issue #312) et la bottom-nav mobile 6 items claire.
- **La grammaire « étoiles de difficulté »** (Q-4 étude 14) déjà cohérente dans les titres de
  missions.

## I. Inventaire des captures

66 captures (55 + 11 après correction IA du harness), 0 erreur console/page, produites le
2026-07-10 contre TEST seedé, archivées en artefact de session (`captures-phase0/`) avec
`manifest.json`. Détail : landing/programme/niveau/matière/chapitre/exercice/extras/suivi/auth/
login/signup (anon, FR desktop+mobile, AR mobile, dark sur landing+auth) ; dashboard/parcours/
matière/chapitre/quête/donjon/duel/leaderboard/programme (free) ; matière/quête/donjon (premium) ;
parent-report (parent) ; 5 écrans admin. Les `--fold.png` capturent le premier viewport mobile
(test « action n°1 sans scroll »).

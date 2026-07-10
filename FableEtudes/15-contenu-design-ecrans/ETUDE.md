# Étude 15 — Contenu & composition des écrans

> **Statut** : brouillon (audit phase 0 livré ; questions §7 à arbitrer → validée)
> **Priorité** : transverse · **Valeur** : conversion, rétention J1, confiance parent-payeur, lisibilité de l'offre · **Complexité** : moyenne+ (large surface, risque unitaire faible)
> **Architecte** : Fable / 2026-07-10 · **Exécuteur cible** : Sonnet (ou équiv.) — sauf charte & maquettes (architecte)
> **Dépend de** : étude 14 (lots 1-2 mergés ; dépendances par écran, §4) · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, docs/guide-duels-et-ligues.md, docs/guide-types-questions-natifs.md ; annexe factuelle : [AUDIT-CONTENU-2026-07.md](./AUDIT-CONTENU-2026-07.md)

## 1. Contexte & objectif produit

L'étude 14 (en exécution) normalise **comment c'est peint** : tokens, 2 thèmes, primitives,
RTL, états système. Elle exclut explicitement l'architecture d'information, le contenu et la
composition des écrans. Cette étude 15 est sa **complémentaire** : **ce que chaque écran dit,
montre et fait faire** — hiérarchie, guidage, microcopy, récits, navigation (incluse au
périmètre par arbitrage du 2026-07-10).

L'audit phase 0 (66 captures TEST réelles compte neuf + revue de code, 5 groupes d'écrans —
[AUDIT-CONTENU-2026-07.md](./AUDIT-CONTENU-2026-07.md)) établit que le problème n'est ni le
contenu pédagogique (excellent) ni le style (étude 14), mais **des récits cassés et une
hiérarchie absente** :

- **le premium raconte 3 histoires contradictoires** (carte « Abonnement requis » partout / hub
  sans aucun verrou / paywall « pas d'abonnement » qui fait téléphoner un mineur à
  « l'administrateur ») pendant que le gratuit réel (lecture + quiz + d1) n'est raconté nulle
  part (audit §A-3) ;
- **la boucle cœur a perdu sa couche gameplay** au chantier C8 (hub matière sans état, ni
  verrou, ni reprise — le « L2 » promis n'a jamais été fait) et traverse deux coquilles de
  navigation (§A-2, §B-3) ;
- **le dashboard est six écrans en un** (~30 hauteurs mobile), l'action n°1 sous le pli,
  derrière l'identité et un cross-sell (§A-4, §B-1) ;
- **le first-run n'existe pas** (« Bon retour » + zéros + classement « tu es #1 » à 0 XP) et
  l'enjeu des modes (récompenses duel, règles donjon) est invisible (§A-5, §E) ;
- **le parent vit dans une app d'élève** (« Classe : Candidat Civil », nav Donjon/Duels, zéro
  étage commercial sur l'écran du payeur) (§F) ;
- **des trous de flux durs** : aucun « mot de passe oublié », pas de consentement légal au
  signup, onboarding avec 19/29 cartes « en construction » et un dead-end lycée, invite « crée
  ton compte » servie aux connectés et mensongère pour les anonymes (§C-2, §G, §B-4, §D-4).

**Résultat attendu** : chaque écran a UN job, UNE action n°1 au-dessus du pli mobile, des états
vides qui racontent, un récit gratuit/premium unique et vrai, un registre par audience (élève
RPG dosé / parent & public sobre), un catalogue réellement trilingue — refondu **par lots d'une
PR**, chaque recomposition validée **visuellement dans Claude Design avant implémentation**.

**Indicateurs de succès** (reviewables par PR, pas subjectifs) :

- 100 % des écrans refondus : action n°1 visible sur le fold mobile 375 px (preuve : capture
  `--fold` du harness R-5) ;
- 0 état vide/first-run muet sur les écrans refondus (chaque vide = message + action) ;
- 0 cul-de-sac (chaque écran propose la suite) ; 0 clé user-facing FR-only ;
- catalogue (parcours, matières, tabs) localisé dans les 3 locales avec fallback ;
- 1 seul récit premium (mêmes mots sur carte, hub, paywall, parent-report) ;
- funnel signup → première mission mesuré en taps au lot 9 (base : audit §G) ;
- gate verte à chaque lot, budgets bundle inchangés, coverage non régressée.

**Ce que l'epic ne fait PAS** : pas de changement des mécaniques/économie du jeu (on AFFICHE
les règles de `gamification.ts`, on ne les change pas), pas de nouveau branding ni de refonte
des tokens/primitives (étude 14), pas de moteur adaptatif (étude 04), pas d'analytics famille
avancées (étude 08), pas de paiement en ligne (étude 01 — le canal actuel téléphone/bêta reste,
mais mieux raconté), pas de réécriture du contenu pédagogique.

## 2. Spécification fonctionnelle

- **Acteurs** : élève (6-19 ans, FR/AR/EN), parent (payeur, non-joueur), visiteur anonyme
  (élève ou parent/enseignant), admin.
- **US-1** — En tant qu'élève neuf, après le signup je comprends la promesse, je choisis ma
  classe sans bruit, et j'arrive à MA première mission en ≤ 3 écrans, accueilli comme un
  nouveau (jamais « Bon retour » + zéros).
- **US-2** — En tant qu'élève, sur chaque écran je vois d'un coup d'œil QUOI faire maintenant
  (une action prioritaire au-dessus du pli mobile), et je ne perds jamais la navigation
  principale pendant la boucle apprendre→s'entraîner.
- **US-3** — En tant qu'élève, je sais AVANT de cliquer ce qui est gratuit, ce qui est
  verrouillé et pourquoi (quiz à passer / accès Concours), et ce que chaque mission me
  rapporte.
- **US-4** — En tant qu'élève, l'écran d'entrée de chaque mode compétitif (donjon, duel,
  classement) me dit les règles, l'enjeu et mes récompenses — y compris quand tout est vide
  (cold-start raconté, jamais « tu es #1 » à 0 XP).
- **US-5** — En tant que parent, le bilan répond d'abord à « mon enfant progresse-t-il ? » dans
  MES mots (classe scolaire, pas classe RPG), me dit quoi faire, et me présente l'offre
  (statut de mon enfant, pack famille, comment débloquer).
- **US-6** — En tant qu'arabophone, le catalogue entier (niveaux, parcours, matières, tabs) est
  en arabe ; le mélange UI/contenu est assumé et signalé, jamais accidentel.
- **US-7** — En tant qu'anonyme, on me propose un compte aux bons moments avec des arguments
  VRAIS (XP, sauvegarde, déblocages conservés) — jamais « crée un compte pour t'entraîner »
  (faux) ni d'invite quand je suis déjà connecté.
- **US-8** — En tant qu'utilisateur, je peux récupérer mon mot de passe, et le signup m'informe
  des conditions (mineurs/parents).
- **Règles** (l'exécuteur les référence dans ses tests) :
  - **R-1** : action n°1 au-dessus du pli mobile 375 px sur tout écran refondu (preuve :
    capture fold du harness).
  - **R-2** : zéro cul-de-sac — tout écran/état (vide, verrouillé, erreur, résultat) propose au
    moins une suite contextuelle.
  - **R-3** : tout état vide/first-run est raconté : message + action, jamais un widget vide ni
    un classement fictif.
  - **R-4** : l'enjeu avant le clic — verrous, gains (XP/pièces depuis
    `shared/constants/gamification.ts`), règles et seuils annoncés sur la surface d'ENTRÉE,
    pas après l'engagement.
  - **R-5** : captures avant/après par PR via le harness committé
    (`scripts/design/dev-server-test.mjs` + `capture-screens.mjs`), FR + AR × mobile/desktop —
    même règle que l'étude 14.
  - **R-6** : microcopy trilingue dans la même PR (aucune clé FR-only) ; données de catalogue
    localisées (`name_ar`/`name_en` peuplés + sélectionnés) avec fallback `name_fr`.
  - **R-7** : registre par audience — élève : tutoiement, RPG dosé (registre Arène) ; parent et
    tier public : sobre, vouvoyé, zéro jargon gamer non traduit ; un lexique trilingue unique
    (lot 2) fait foi pour les termes du jeu (série, pièces, Donjon, Accès Concours…).
  - **R-8** : tout lot qui RECOMPOSE un écran implémente la maquette Claude Design validée par
    l'humain — pas de maquette validée = STOP, pas d'implémentation.
  - **R-9** : divulgation progressive — toute liste > ~8 items se replie (accordéon, « top
    10 + toi », pagination) ; jamais deux fois la même information sur une ligne (Niv. n +
    étoiles).
  - **R-10** : aucun changement de mécanique serveur. Sont autorisés, énumérés par lot :
    élargissements de SELECT (colonnes existantes), nouveaux champs calculés en lecture,
    migrations **additives** de données (peupler `name_ar`/`name_en`, textes) — jamais de
    changement de règle de jeu, de RLS ou de scoring.
- **i18n** : nouvelles clés FR/EN/AR par lot ; lexique unifié (lot 2) ; erreurs serveur
  user-facing passées par l'i18n (parent-report §F-1). Notation math standard inchangée.
- **Hors périmètre (v1)** : app mobile native, emails transactionnels, page « à propos »
  complète (une section landing suffit en v1), high-contrast (étude 14 l'a exclu aussi),
  refonte des SVG pédagogiques.

## 3. Architecture technique (décisions fermées)

Aucun changement de mécanique. Tout est client/copy/composition + selects élargis + migrations
additives de données (R-10).

- **D-1 — Charte de contenu (lot 2, fichier normatif `docs/content-voice-and-composition.md`).**
  Formalise : les gabarits de composition par type d'écran (hub, mode, formulaire, rapport,
  player) avec leur budget de blocs ; les règles R-1→R-9 opérationnalisées ; le lexique
  trilingue (dont : « série » pour streak, « pièces » pour coins, « Accès Concours » pour
  l'offre premium — le mot « abonnement » est banni ; nom AR du Donjon à trancher en Q-1b,
  « الزنزانة » [cellule de prison] est exclu) ; le registre par audience (R-7) ; la règle
  chrome-UI vs langue-contenu (l'écran système suit l'UI, le contenu sa langue, le mélange
  `QL.*`/`t.*` sur un même bandeau est interdit — audit §D-5). Le dashboard #345 (bande focus)
  est l'étalon du pattern « une action prioritaire ».
- **D-2 — Maquettes Claude Design (prolonge D-6/Q-3 de l'étude 14, jamais exécuté).** Un projet
  Design System claude.ai/design : d'abord le socle (tokens + 8 primitives du lot 1 é14, cards
  `@dsCard`), puis `screens/<écran>/` — 1-2 variantes max par écran recomposé, mobile-first,
  FR + AR, construites sur le CSS réel. Bundle versionné dans le repo (`design/ds/`), sync
  incrémentale composant par composant (outil DesignSync). Le projet DS est l'outil de
  décision ; le code reste la source de vérité. Ta validation d'une maquette = le contrat du
  lot (R-8).
- **D-3 — Le récit gratuit/premium unique.** Une seule histoire, dans les mêmes mots partout :
  « Lire est gratuit. Le quiz et les missions ⭐ sont gratuits. Le parcours Concours complet
  (⭐⭐+, Donjon) se débloque avec l'Accès Concours — demandé par ton parent. » Concrètement :
  badges tri-état sur les missions du hub (fait ✓ / gratuit / 🔒 quiz / 👑 Concours), le nœud
  de la carte dit « Aperçu gratuit — Accès Concours pour tout débloquer » (remplace
  `premiumHint`), le paywall devient une page « Accès Concours » qui parle à l'élève ET au
  parent (bénéfices, statut, le canal actuel : demande bêta + contact — prix/canal = Q-2), le
  parent-report affiche le statut de l'enfant + pack famille. Le footer public « 100 %
  gratuit » est requalifié (« Cours et résumés 100 % gratuits »).
- **D-4 — Coquille unifiée auth-aware (navigation — arbitrage « périmètre 15 » du
  2026-07-10).** Une seule nav qui s'adapte à la session, fin du flip-flop (§A-2) : connecté,
  les pages catalogue/hub/lecteur (`_public`) affichent la nav du jeu (QG, Parcours, Découvrir,
  Arène, chips) ; anonyme, la nav publique actuelle. Le débordement desktop (§E-4 : « Duels »
  tronqué, « Classement » invisible) est résolu par regroupement : **« Arène »** devient une
  entrée unique (Donjon · Duels · Classement) — page hub légère ou menu — et les trois écrans
  se maillent entre eux. `/dungeon` cesse d'être « immersif » au lobby (tab-bar visible tant
  qu'on ne joue pas). Le rôle parent reçoit une coquille dédiée minimale : nav = Suivi (+
  déconnexion), zéro entrée gamer, redirection actuelle conservée. Maquette de nav = partie du
  lot 4, validée en Q-3.
- **D-5 — Dashboard dégroupé.** Le dashboard redevient un QG : bande focus EN PREMIER (v2 de
  #345 : accueil first-run dédié, « Bon retour » réservé aux comptes avec progression), puis
  quêtes du jour/semaine condensées, puis les matières du parcours (cartes avec état réel et
  free-preview), et c'est tout. Déménagent : boutique + inventaire + badges → nouvelle route
  **`/boutique`** (l'onglet Arène/nav l'expose ; le radar rejoint le futur écran profil ou la
  section badges) ; « Autres thèmes » (25 cartes) → supprimé, remplacé par UNE carte
  « Découvrir d'autres thèmes → /programme » ; le code alliance → une carte compacte « Famille »
  en bas de dashboard avec état (lié ✓ / à lier), détaillée dans le profil ; la bannière
  concours passe SOUS la bande focus et devient contextuelle (la classe de l'élève d'abord).
  Validation via maquettes (Q-4).
- **D-6 — Hub matière connecté (le « L2 » différé du C8, cadré ici).** `/matiere` et
  `/chapitre` restent des pages publiques partagées (pas de nouvelle route), mais reçoivent la
  couche session : ancrage niveau (kicker = classe, pas « FORCE ») + remontée vers
  `/niveau/$parcoursId` ; « Reprendre ici » (dernier chapitre travaillé) ; par chapitre :
  progression x/y + accordéon (replié une fois fait) ; par mission : badge tri-état D-3 +
  gain XP (connecté seulement) ; le CTA du lecteur pointe le QUIZ tant que le chapitre n'est
  pas débloqué (`hasPassedChapterQuiz`/`quizPassedByChapter` — données déjà servies, audit
  §D-3/§D-4) ; l'invite compte disparaît pour les connectés et dit la vérité aux anonymes
  (« garde tes déblocages », §D-4/§D-5) ; le player public affiche « Continuer vers le 1er
  exercice » après un quiz réussi (§D-5). Le quiz annonce son contrat sur l'écran même
  (« Réussis ≥ 60 % pour déverrouiller les missions », `QUIZ_PASS_THRESHOLD_PCT`).
- **D-7 — First-run & cold-start racontés.** Un helper partagé « première fois » (profil sans
  attempts) pilote : hero dashboard en mode accueil, leaderboard « Le classement démarre —
  gagne tes premiers XP » (+ « top 10 + toi », suppression du #1 fictif — ne jamais afficher de
  rang sans XP), duel « premier arrivé » raconté AVANT le clic + récompenses affichées
  (60/40/20 XP — participer paie), donjon : récit double-porte complet (accès Concours ✓/✗ +
  prérequis + record personnel au lobby). Constantes lues depuis `gamification.ts`, jamais
  dupliquées en dur.
- **D-8 — Flux manquants (nouveaux écrans autorisés dans cette étude).** (a) « Mot de passe
  oublié » : `resetPasswordForEmail` Supabase + route `/auth/reset` (formulaire nouveau mot de
  passe), lien sur `/auth` ; (b) mentions légales + case de consentement au signup (texte
  fourni en Q-5) + sélecteur de langue sur `/auth` ; (c) fix du bug de rôle parent
  (metadata du signUp + `handle_new_user` — migration additive, audit §G) ; (d) onboarding v2 :
  étape promesse courte, langue explicite, picker école propre (lecture de
  `grades.is_selectable`, doublons legacy masqués, « en construction » repliées derrière « Ma
  classe n'est pas là »), issue lycée (Q-6), récap + célébration + atterrissage guidé, deep-link
  restauré.
- **D-9 — Parent.** Rapport re-hiérarchisé : verdict + conseil d'abord (mobile), outils
  (liaison, objectif) repliés après liaison ; classe scolaire réelle (SELECT élargi
  grade/parcours) ; conseil et faiblesses cliquables vers `/chapitre`/`/matiere` ; étage
  commercial D-3 ; erreurs serveur i18n ; `/suivi` : promesse + contenu du bilan + entrée
  header/footer publics.
- **D-10 — Admin (efficacité, petit).** Recherche utilisateur par email (RPC admin existante à
  élargir ou vue) pour l'octroi ; lien direct exercice/question sur les signalements +
  regroupement par cible ; « Approuver » affiche parcours/durée accordés.
- **Alternatives rejetées** : refondre l'IA en rapatriant hub/lecteur sous `_authenticated`
  (duplique ce que C8 a unifié ; la couche session suffit) ; un ton par cycle d'âge (coût i18n
  ×3 registres — tranché en Q-1 avec recommandation « non ») ; déplacer la boutique dans une
  modale (ferme la porte à l'économie, D-5 lui donne une vraie page).

## 4. Plan d'exécution en lots

Chaque lot = une PR mergeable, gate verte, captures R-5, maquette validée si recomposition
(R-8). Un lot d'écran ne touche ni les primitives (retour étude 14) ni un autre écran.

| lot | contenu (résumé)                                                                                                                                                                                                                                                                                                                                                                                                                                                     | fichiers/objets principaux                                                                                                           | tests exigés                             | dépend de               |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------- | ----------------------- |
| 0   | Étude + audit + harness captures (cette PR)                                                                                                                                                                                                                                                                                                                                                                                                                          | `FableEtudes/15-*`, `scripts/design/*`                                                                                               | —                                        | —                       |
| 1   | **Quick-wins de vérité** (copy/one-liners, sans recomposition) : invite lecteur conditionnée `!isAuthenticated` + texte véridique ; `premiumHint` → récit D-3 ; CTA lecteur → quiz si non débloqué ; « Continuer » post-quiz anonyme ; méta `/auth` ; sous-titre leaderboard ; `formatQuestType`/« beat 2 bosses » i18n ; « Temps validé côté serveur » corrigé ; hygiène seed e2e (révoquer les entitlements des comptes non premium) ; CLAUDE.md — IA réelle (A-1) | `lesson-reader.tsx`, `fr/en/ar*.ts`, `quest.server.ts:360`, `exercice.$exerciseId.tsx`, `scripts/e2e/seed-test-users.mjs`, CLAUDE.md | unit ciblés + i18n                       | 0 validé                |
| 2   | Fondations éditoriales : charte D-1 (doc normatif), lexique trilingue, migration additive `name_ar`/`name_en` des parcours + selects élargis + fallback, i18n des erreurs parent-report                                                                                                                                                                                                                                                                              | `docs/content-voice-and-composition.md`, migration, `dashboard.server.ts`, i18n                                                      | unit fallback locale, pgTAP si migration | 0                       |
| 3   | Publication Claude Design : socle (tokens + primitives é14) + gabarits, puis maquettes des lots 4-11 au fil de l'eau                                                                                                                                                                                                                                                                                                                                                 | `design/ds/**` (bundle versionné)                                                                                                    | — (revue humaine)                        | é14 lot 1 (fait)        |
| 4   | Navigation & coquilles (D-4) : nav unifiée auth-aware, pôle Arène, fix débordement desktop, dungeon non-immersif au lobby, coquille parent, `/suivi` dans header/footer                                                                                                                                                                                                                                                                                              | `_authenticated.tsx`, `public-header/footer`, routes                                                                                 | unit nav par rôle, captures              | 2, 3 ; é14 lot 2 (fait) |
| 5   | Dashboard dégroupé (D-5) + nouvelle route `/boutique`                                                                                                                                                                                                                                                                                                                                                                                                                | `dashboard.tsx`, `routes/boutique.tsx`, `features/dashboard`, `features/shop`                                                        | unit existants verts + first-run         | 4 ; é14 lot 5           |
| 6   | Hub matière connecté + lecteur + player public (D-6) — le lot le plus lourd                                                                                                                                                                                                                                                                                                                                                                                          | `subject-hub.tsx`, `lesson-reader.tsx`, `exercice.$exerciseId.tsx`, `quest.server.ts` (lectures)                                     | unit gate/badges/reprise, captures A/A   | 2 ; é14 lots 3, 6       |
| 7   | Funnel public : landing (preuve : chiffres réels compilés du contenu, lien « voir un exemple de cours », porte enseignant honorée), programme (volumétrie + intérêt public + lycée compacté), extras différenciés                                                                                                                                                                                                                                                    | `public-landing.tsx`, `parcours-catalogue.tsx`, `fr/en/ar-public.ts`                                                                 | unit, captures                           | 2 ; é14 lot 3           |
| 8   | Auth v2 (D-8 a-b) : registre par audience (R-7), mot de passe oublié, légal + langue                                                                                                                                                                                                                                                                                                                                                                                 | `auth.tsx`, route reset, i18n                                                                                                        | unit + e2e auth-flows                    | 2 ; é14 lot 4           |
| 9   | Onboarding v2 (D-8 c-d) : promesse, picker propre, fix rôle parent (migration), célébration, deep-link                                                                                                                                                                                                                                                                                                                                                               | `onboarding.tsx`, `onboarding-guard.ts`, migration metadata rôle                                                                     | unit guard + e2e onboarding              | 8                       |
| 10  | Arène (D-7) : donjon (double-porte + record), duel (règles + récompenses + file racontée + historique lisible — SELECT outcome/adversaire élargi), leaderboard (cold-start + top 10 + toi)                                                                                                                                                                                                                                                                           | `dungeon.tsx`, `features/duel`, `leaderboard.tsx`, `duel.server.ts` (lecture)                                                        | unit cold-start/récompenses, captures    | 4 ; é14 lots 7-9        |
| 11  | Parent (D-9) : rapport re-hiérarchisé + étage commercial + `/suivi` enrichie                                                                                                                                                                                                                                                                                                                                                                                         | `features/parent-report`, `suivi.tsx`                                                                                                | unit, captures parent                    | 2, 4 ; é14 lot 10       |
| 12  | Admin (D-10) : recherche par email, liens signalements, approbation explicite                                                                                                                                                                                                                                                                                                                                                                                        | `routes/admin.*`, features admin                                                                                                     | unit                                     | é14 lot 10              |

Stop-points : maquette non validée = STOP (R-8) ; toute envie de nouvelle mécanique = hors
périmètre ; divergence étude↔code = STOP et remontée (règle FableEtudes).

- [x] Lot 0 — étude + audit + harness (cette PR)
- [ ] Lot 1 — quick-wins de vérité
- [ ] Lot 2 — fondations éditoriales
- [ ] Lot 3 — Claude Design (socle + gabarits)
- [ ] Lot 4 — navigation & coquilles
- [ ] Lot 5 — dashboard + `/boutique`
- [ ] Lot 6 — hub matière connecté
- [ ] Lot 7 — funnel public
- [ ] Lot 8 — auth v2
- [ ] Lot 9 — onboarding v2
- [ ] Lot 10 — arène
- [ ] Lot 11 — parent
- [ ] Lot 12 — admin

## 5. Stratégie de test

- **Unit (Vitest)** : chaque condition de contenu nouvelle (invite `!isAuthenticated`, badges
  tri-état, first-run helper, fallback de locale, nav par rôle) avec tests co-localisés ; les
  tests existants des écrans refondus restent verts sans affaiblissement.
- **e2e** : les specs touchées suivent dans la même PR (onboarding — le page-object documente
  déjà une étape « confirm » fantôme à réaligner ; auth-flows pour le reset ; navigation).
  Hygiène seed (lot 1) fiabilise les états capturés/testés.
- **Visuel** : harness R-5 (`scripts/design/capture-screens.mjs`) avant/après par PR — FR + AR,
  mobile + desktop, fold inclus ; les états non capturables statiquement (résultat, paywall)
  sont capturés manuellement au lot concerné (liste : audit §G « à capturer »).
- **pgTAP** : uniquement si migration (lot 2 données localisées, lot 9 metadata rôle).
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
- **RISK-4 — Selects élargis / types Supabase**. Mitigation : régénérer les types, tests de
  fallback, aucun changement de RLS (R-10).
- **RISK-5 — Qualité de l'arabe** (lexique, registre). Mitigation : le lexique trilingue (lot 2) est arbitré par Mohamed (Q-1b inclus) ; toute nouvelle clé AR est relue humainement avant
  merge du lot.
- **RISK-6 — Le récit commercial dépend de décisions produit non prises** (prix, canal).
  Mitigation : D-3 est rédigé pour le canal ACTUEL (bêta + contact) ; Q-2 ne bloque que le
  paywall final, pas les badges/verrous.

## 7. Questions ouvertes (pour l'humain)

- **Q-1 — Ton par âge.** Recommandation : UN ton élève unique (tutoiement, compréhensible dès
  8 ans, RPG dosé côté Arène) + registre parent/public sobre vouvoyé — pas de variation par
  cycle en v1. **Q-1b** : nom arabe du Donjon (proposition : « القبو اللانهائي » ou
  « المتاهة » — « الزنزانة » exclu). Valides-tu ?
- **Q-2 — Récit commercial.** Nom public de l'offre (« Accès Concours » ?), afficher un prix
  dans l'app ou rester « demande + contact », et qui contacte (parent via WhatsApp ?). Le
  paywall v2 (lot 6/11) a besoin de ces trois réponses.
- **Q-3 — Navigation cible (D-4).** Valider sur maquette : nav unifiée auth-aware + pôle
  « Arène » regroupé + coquille parent dédiée.
- **Q-4 — Dashboard (D-5).** Valider sur maquette : dégroupage (boutique/inventaire/badges →
  `/boutique`), suppression de la liste « Autres thèmes », code alliance en carte Famille
  compacte.
- **Q-5 — Légal signup.** Texte des mentions/consentement (mineurs, données) à fournir — ou
  décision de reporter le volet légal (le lien mentions légales existe déjà côté public).
- **Q-6 — Lycéen sans classe ouverte (audit §G).** La RPC autorise déjà de choisir un parcours
  « en construction ». Option A (recommandée) : autoriser la sélection avec un accueil dédié
  (« ta classe arrive — en attendant : extras + vote ») ; option B : garder le blocage + CTA
  vers l'exploration libre. Trancher.

## 8. Journal d'exécution

- 2026-07-10 — Lot 0 : audit phase 0 livré (66 captures TEST compte neuf via le harness
  committé `scripts/design/`, 5 groupes d'écrans audités en parallèle + boucle cœur par
  l'architecte, 0 erreur console). Étude rédigée, statut **brouillon** — en attente des
  arbitrages Q-1…Q-6. Prérequis Q-2 de l'étude 14 levé au passage : `.env.test` opérationnel
  en local (e2e:doctor 7/7), captures authentifiées désormais possibles.

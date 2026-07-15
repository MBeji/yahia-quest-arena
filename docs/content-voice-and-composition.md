# Charte de contenu & de composition des écrans

> **Doc normatif** (étude 15, D-1 — lot 3). Il fait foi pour tout texte visible par un
> utilisateur et pour la composition de tout écran refondu. Il complète CLAUDE.md /
> ARCHITECTURE.md (qui gagnent en cas de conflit) et l'étude
> [`FableEtudes/15-contenu-design-ecrans/ETUDE.md`](../FableEtudes/15-contenu-design-ecrans/ETUDE.md)
> (US/R/lots). Le style visuel (tokens, thèmes, primitives, RTL) relève de l'étude 14 —
> ici on norme **ce que l'écran dit, montre et fait faire**.

## 1. Les registres — qui parle à qui

| Audience                                         | Registre                          | Adresse                       | RPG                                | Exemples                                           |
| ------------------------------------------------ | --------------------------------- | ----------------------------- | ---------------------------------- | -------------------------------------------------- |
| **Élève** (6-19 ans)                             | jeu, énergique, bienveillant      | **tutoiement**                | dosé, côté Arène surtout           | « Reprends ta quête », « Série de 5 jours ! »      |
| **Parent**                                       | sobre, rassurant, concret         | **vouvoiement**               | **zéro** jargon gamer              | « Votre enfant a travaillé 3 jours cette semaine » |
| **Public anonyme** (landing, catalogue, lecteur) | « Référence » : crédible, factuel | vouvoiement (adulte) / neutre | zéro sur les surfaces de confiance | « Cours conformes au programme officiel »          |
| **Admin**                                        | outil interne, direct             | neutre                        | zéro                               | « 12 signalements à traiter »                      |

Règles d'application :

- **Un ton élève UNIQUE** (arbitrage Q-1) : compréhensible dès 8 ans — phrases courtes, un
  verbe d'action, pas de subordonnées empilées ; pas de variation par cycle d'âge.
- Le **RPG est un assaisonnement, pas la langue** : autorisé dans les titres et célébrations du
  monde connecté (« Hall des Héros », « Quête », « Donjon »), interdit dans les instructions,
  les erreurs, tout ce que lit un parent, et le registre public. Un écran système reste lisible
  si on retire ses mots RPG.
- **Jamais de jargon non traduit** : un terme du lexique (§2) s'écrit dans la langue de l'UI,
  partout. « Streak », « dashboard », « Alliance Code » en français sont des bugs.
- **L'interdit commercial (phase gratuite, Q-2)** : « abonnement », « premium », « payant »,
  « paywall » sont bannis de toute surface utilisateur tant que la phase gratuite dure
  (l'étude 01 rouvrira ce chapitre avec son propre vocabulaire).

## 2. Le lexique trilingue

Un concept = un mot par langue, partout (écrans, toasts, erreurs, e-mails futurs). Toute
nouvelle clé i18n le respecte ; toute dérive est un bug de PR.

| Concept               | FR                               | EN                         | AR                                      | Notes                                                                                      |
| --------------------- | -------------------------------- | -------------------------- | --------------------------------------- | ------------------------------------------------------------------------------------------ |
| streak                | **série**                        | streak                     | **سلسلة**                               | jamais « streak » en FR ; format « série de {n} jours » / « {n} j »                        |
| coins                 | **pièces**                       | coins                      | **عملات**                               | la monnaie du jeu ; « {n} pièces »                                                         |
| XP                    | XP                               | XP                         | **نقاط الخبرة** (prose) / XP (compteur) | sigle conservé dans les chips                                                              |
| niveau (jeu)          | niveau {n}                       | level {n}                  | المستوى {n}                             | ne pas confondre avec la classe scolaire                                                   |
| classe (école)        | classe                           | class/grade                | **القسم**                               | registre scolaire tunisien (« ما هو قسمك؟ »)                                               |
| quête / mission       | quête (jeu) · mission (contenu)  | quest · mission            | مهمة                                    | « mission » pour les exercices du contenu                                                  |
| donjon                | le Donjon Infini                 | the Infinite Dungeon       | **القبو اللانهائي**                     | « الزنزانة » (cellule de prison) est **banni** (Q-1b)                                      |
| duel                  | duel                             | duel                       | مبارزة                                  |                                                                                            |
| classement            | classement                       | leaderboard                | الترتيب                                 | assiette : l'Académie entière, jamais « du concours »                                      |
| parcours              | parcours                         | track                      | مسار                                    | le produit-track choisi à l'onboarding                                                     |
| code alliance         | code alliance                    | alliance code              | رمز التحالف                             | UN seul nom par langue sur tout le tunnel parent (fin de « Alliance Code »/« Code élève ») |
| suivi parental        | suivi                            | monitoring/report          | المتابعة                                | verbe côté parent : « voir/ouvrir le bilan », jamais « associer » pour une consultation    |
| quiz de compréhension | quiz de compréhension            | comprehension quiz         | اختبار الفهم                            | LE seul verrou de l'app en phase gratuite                                                  |
| rappel actif          | **Rappel** (mode) · rappel actif | **Recall** · active recall | **استرجاع**                             | mode de réactivation (étude 17) ; jamais « quiz Rappel » ; chip « 🧠 Rappel »              |
| boutique              | boutique                         | shop                       | المتجر                                  |                                                                                            |
| classe de héros       | classe de héros                  | hero class                 | رتبة البطل                              | les intitulés de rangs seront localisés au lot des écrans qui les affichent                |

Compléments de langue :

- **AR** : registre وضوح إداري tunisien pour l'école (السنة … أساسي/ثانوي، مناظرة، باكالوريا) ;
  prose MSA simple pour le jeu ; notation math standard (chiffres 0-9, équations LTR — règle
  `content-engine/math-and-notation.md`). Le parent est adressé au pluriel de politesse.
- **FR** : pas d'écriture inclusive à point médian (cible 6-19 ans) — préférer une formulation
  épicène (« Intéressé·e » → « Ça m'intéresse ✓ »).
- **Données localisées** : les noms de PARCOURS viennent de `name_fr/name_en/name_ar` (migration
  `20260711120000`) via `parcoursName()` (`@/shared/lib/parcours-locale`) — fallback FR. Les
  noms de MATIÈRES school restent dans la langue d'enseignement (modèle monolingue assumé).

## 3. Composition — les 6 règles d'écran

Opérationnalisation des règles R-1→R-9 de l'étude 15 (l'exécuteur les référence dans ses PR) :

1. **Une action n°1** par écran, au-dessus du pli mobile 375 px (preuve : capture `--fold` du
   harness `scripts/design/capture-screens.mjs`). Tout le reste est secondaire et se hiérarchise
   après elle. Étalon : la bande focus du dashboard (#345).
2. **Zéro cul-de-sac** : chaque écran ET chaque état (vide, verrouillé, erreur, résultat)
   propose au moins une suite contextuelle — la plus utile, pas un simple « retour ».
3. **Les états vides racontent** : un vide = (a) ce que c'est, (b) pourquoi c'est vide,
   (c) l'action qui le remplit. Jamais un widget muet, jamais une donnée fictive (un
   classement à 0 XP n'affiche pas « #1 »).
4. **L'enjeu avant le clic** : verrou (quiz), règles, gains (XP/pièces depuis
   `shared/constants/gamification.ts`, jamais dupliqués en dur) s'annoncent sur la surface
   d'ENTRÉE d'un mode, pas après l'engagement.
5. **Divulgation progressive** : liste > ~8 items → repli (accordéon, « top 10 + toi »,
   pagination). Jamais deux fois la même information sur une ligne (« Niv. 3 » + ⭐⭐⭐ = une
   seule écriture : les étoiles).
6. **Chrome vs contenu** : le chrome (boutons, compteurs, erreurs) parle la langue de l'UI ; le
   contenu pédagogique parle sa langue d'enseignement. Les deux ne se mélangent jamais dans une
   MÊME phrase/bannière (« Victoire ! » + « تهانينا » sur un même bandeau est un bug).

## 4. Gabarits par type d'écran (budgets de blocs)

Le gabarit dit ce que l'écran a le DROIT d'empiler. Dépasser le budget = retirer, pas tasser.

| Type                              | Rôle                     | Budget (ordre imposé)                                                                                                                                                                                |
| --------------------------------- | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **QG** (dashboard)                | « que faire maintenant » | action n°1 → objectifs du jour/semaine (condensés) → matières du parcours → 1 passerelle Découvrir → 1 carte Famille. **Pas** de catalogue externe, boutique, inventaire ou stats détaillées inline. |
| **Hub** (matière)                 | choisir chapitre/mission | ancrage (classe + remontée) → « reprendre ici » → chapitres (accordéon, progression x/y) → missions avec état (✓ / à faire / 🔒 quiz)                                                                |
| **Lecteur** (cours)               | lire puis enchaîner      | fil d'ariane → Cours/Résumé → texte → UNE suite (quiz tant que verrouillé, sinon s'entraîner) → prev/next                                                                                            |
| **Player** (mission)              | répondre                 | contexte 1 ligne (matière · chapitre · enjeu) → question → réponse → validation ; résultat = score → gains → correction → UNE continuation primaire                                                  |
| **Mode** (donjon/duel/classement) | donner envie + cadrer    | pitch 1 phrase → règles+gains (tuile « règle+chiffre+icône ») → mon état (record/rang) → action n°1 ; cold-start raconté                                                                             |
| **Formulaire** (auth, liaison)    | convertir sans friction  | promesse 1 ligne → champs minimum → action → issues de secours (mot de passe oublié, « continuer sans compte »)                                                                                      |
| **Rapport** (parent)              | répondre à « ça va ? »   | verdict + conseil D'ABORD → métriques → détail ; outils (liaison, objectif) repliés une fois configurés                                                                                              |
| **Admin**                         | trier vite               | compteur à traiter → liste filtrable → action par ligne avec effet EXPLICITE                                                                                                                         |

## 5. Erreurs & messages système

- Une erreur dit **quoi** a échoué + **quoi faire**, dans la langue de l'UI, au registre de
  l'audience. Les erreurs serveur user-facing voyagent en **codes stables** traduits côté
  client (modèle : `parent-code-errors.ts` — préfixe + code, fallback générique) ; le français
  en dur dans un `throw` destiné à l'écran est un bug.
- Les toasts de succès célèbrent au registre de l'écran (élève : « 🔥 Série récupérée ! ») ;
  les toasts d'erreur restent sobres partout.
- Aucune affirmation fausse : pas de « validé côté serveur » quand c'est mesuré client, pas de
  « crée un compte pour t'entraîner » quand l'entraînement est libre. En cas de doute, la
  phrase la plus modeste et vraie gagne.

## 6. Checklist de revue (à cocher dans chaque PR d'écran)

- [ ] Action n°1 visible sur la capture `--fold` mobile FR **et** AR
- [ ] Aucune clé user-facing FR-only ; AR relu (registre + pluriel de politesse parent)
- [ ] Lexique §2 respecté (grep « streak », « abonnement », « premium », « الزنزانة » = 0)
- [ ] États vides/erreur/verrouillé racontés (règles 2-3) ; enjeu avant le clic (règle 4)
- [ ] Budget du gabarit §4 respecté ; listes longues repliées (règle 5)
- [ ] Chrome/langue-contenu non mélangés (règle 6) ; captures avant/après jointes (R-5)

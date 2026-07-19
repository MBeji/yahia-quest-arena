# Étude 26 — Doctrine verticale : profondeur avant largeur (briques d'excellence, IA-native)

> **Statut** : brouillon
> **Priorité** : transverse (gouvernance de portefeuille — elle séquence les autres études) ·
> **Valeur** : 🎯 chaque capacité livrée devient une **brique d'excellence** — complète, robuste,
> mesurée, cohérente, différenciante — au lieu d'un front de plus ; les trois boucles
> d'intelligence déjà collectées mais jamais montrées à l'élève sont refermées avant toute
> ouverture de périmètre · **Complexité** : faible (exécution documentaire) — portée stratégique
> majeure
> **Architecte** : Fable (claude-fable-5), 2026-07-19 · **Exécuteur cible** : Sonnet (ou équiv.)
> pour les lots ; les arbitrages et amendements d'études restent à l'architecte
> **Dépend de** : rien (exécutable immédiatement) · **Bloque** : le séquencement de toute étude
> non lancée et l'ouverture de toute nouvelle capacité produit
> **Docs normatifs liés** : AGENTS.md (canonique depuis é25 lot 1, livré le 2026-07-19 — son
> « Definition of Done » gagne ici un pendant produit, la DoE), ARCHITECTURE.md, STATUS.md
> (§3 état des features), `FableEtudes/README.md` (ordre d'exécution),
> `docs/content-voice-and-composition.md` (é15), étude 22 (doctrine du parcours élève),
> étude 11 v2 (principe « le déterministe décide, le LLM rédige »)

## 1. Contexte & objectif produit

### 1.1 La commande humaine (mandat du 2026-07-19)

Mohamed fixe l'orientation stratégique du projet : **priorité à l'approche verticale** —
construire des fonctionnalités et des expériences extrêmement abouties avant d'élargir le
périmètre. Le mandat, dans ses termes :

- pour chaque évolution, privilégier **la profondeur, la qualité d'exécution, la robustesse,
  l'expérience utilisateur, la valeur ajoutée réelle, la cohérence globale** ;
- ne pas accumuler de fonctionnalités superficielles : chaque capacité est un élément
  stratégique, pensé pour un niveau de maturité élevé ;
- pour chaque fonctionnalité identifiée, construire **la meilleure version possible**
  (meilleures pratiques du marché, approches innovantes, opportunités IA, impacts UX,
  scalabilité, maintenabilité, cohérence d'écosystème) — chaque brique doit pouvoir devenir
  **une référence et un avantage compétitif** ;
- l'**IA est un composant fondamental** de la plateforme, pas une couche additionnelle : pour
  chaque fonctionnalité, évaluer systématiquement ce que l'IA peut améliorer, personnaliser,
  automatiser, rendre plus intelligent ;
- **qualité avant expansion** : les fondations atteignent l'excellence avant tout
  élargissement ;
- **règle d'arbitrage** : entre ajouter une capacité et améliorer significativement une
  capacité existante, l'amélioration profonde gagne.

Cette étude transforme ce mandat en **doctrine opérationnelle** : définitions, principes,
grille de maturité, règle de décision, application mesurée au portefeuille actuel, et
séquencement. Elle est à la stratégie produit ce que l'étude 22 est au parcours élève : une
formalisation qui répare et ordonne, sans réécrire les études d'exécution existantes.

### 1.2 Le problème mesuré (audit du 2026-07-19)

Le projet n'est pas horizontal par accident de méthode — quand l'effort a été concentré, le
résultat est profond : étude 03 (types natifs, 12 lots), étude 05 (duels temps réel, 5 lots,
Realtime + fallback), étude 17 (rappel actif), étude 18 (cours vivants : 517 cours structurés,
3 827 cartes). **La méthode verticale fonctionne déjà quand elle est appliquée.** Mais trois
dérives horizontales sont mesurables aujourd'hui :

**(a) La dispersion de portefeuille.** 25 études : 6 livrées, **6 en exécution simultanée**
(04, 07, 15, 16, 24, 25), 2 validées en attente (20, 22), **10 brouillons ouverts**, 1 gelée.
L'« ordre d'exécution recommandé » actuel (`FableEtudes/README.md`) est une file
essentiellement additive (`… 08 → 02 → 09 → 10 → 12 → 06`) : elle empile des ouvertures de
périmètre sans critère de fermeture. Rien ne dit « on n'ouvre pas X tant que Y n'est pas
excellent ».

**(b) Le produit collecte une intelligence qu'il ne montre jamais.** Trois boucles mortes,
vérifiées sur le code ce jour (annexe A) :

1. **Révision espacée** : `spaced_repetition_schedule` (SM-2) est alimentée à chaque échec ;
   `getSprint2Dashboard` calcule `pendingSpacedReps` et l'envoie au client **à chaque
   chargement du dashboard** — et aucun composant ne le rend. La donnée traverse le réseau
   puis est jetée (`src/features/dashboard/dashboard.server.ts` l.591-614 vs
   `src/routes/_authenticated/dashboard.tsx`).
2. **Misconceptions** : `user_misconceptions` (agrégat par élève × erreur-type, trigger de
   l'étude 04-A0) est écrite en production depuis la migration `20260706120000` — et **aucune
   surface élève, parent ou admin ne la lit**.
3. **Adaptativité** : `difficulty_adaptation` (niveau 1-4 par matière, mis à jour à chaque
   soumission) n'est **consommée par aucun sélecteur** : `computeNextExerciseId` est purement
   statique (`display_order`), le donjon tire au hasard filtré par étage.

**(c) Le moment pédagogique n° 1 est le plus pauvre de l'app.** Quand l'élève se trompe —
l'instant où la recherche situe le levier d'apprentissage maximal (feedback élaboré :
d ≈ 0,99, annexe B) — l'app d'aujourd'hui : n'affiche **rien** en cours de session (le player
enchaîne à la question suivante, `exercise-player.tsx` l.438-459) ; relègue bonne réponse et
explication au récapitulatif de fin (exercices seulement — jamais les quiz, choix anti-triche
assumé) ; **vend l'explication en cours de run comme un indice payant** (`consume_hint`) ;
n'offre **aucun lien « revoir le cours »** depuis une erreur de pratique ; ne montre jamais la
misconception pourtant diagnostiquée en base. L'étude 22, qui répare la moitié de ces
incohérences (carte menteuse, SM-2, donjon non scopé, cohortes), est **validée depuis le
2026-07-18 avec 0/6 lots exécutés**.

Le paradoxe se résume ainsi : **la profondeur existe déjà en base ; elle n'existe pas encore
pour l'élève.** Le coût du travail dur (télémétrie, agrégats, algorithmes SM-2, graphe de
compétences lot 1) est payé ; la valeur utilisateur, elle, n'est pas encaissée. Pendant ce
temps, la file d'études pousse vers de nouveaux fronts (PWA, anti-fraude, studio d'ingestion).

### 1.3 Objectif & indicateurs de succès

**Objectif** : que chaque capacité visible de l'app soit une brique d'excellence — et que le
portefeuille d'études s'exécute **verticale par verticale**, en refermant les boucles avant
d'en ouvrir de nouvelles.

KPI mesurables :

- **KPI-1 — zéro boucle morte** : les 3 boucles collecte-sans-surface de §1.2(b) sont
  refermées (données affichées OU collecte justifiée par un consommateur daté) à l'issue du
  pipeline V1 (§3.2). Mesure : revue de code — la liste de l'annexe A.1 est vide.
- **KPI-2 — maturité de la verticale cœur** : chaque maillon de V1 (§3.2) atteint **M3**
  (grille §2.3) avant la rentrée de septembre 2026 ; les maillons signature visent M4.
  Mesure : scorecard STATUS.md (D-3).
- **KPI-3 — discipline de portefeuille** : ≤ 3 études « en exécution » simultanées en régime
  courant (aujourd'hui : 6) ; **aucune** nouvelle capacité produit ouverte sans passage par la
  règle de décision §2.4. Mesure : index FableEtudes.
- **KPI-4 — la rétention devient pilotable** : une métrique de retour maison (part des élèves
  actifs de la semaine N revenus en semaine N+1 — la « CURR » locale, annexe B.1) est définie,
  calculable sur les données existantes (`attempts`), et publiée dans la scorecard. C'est le
  juge de paix de l'excellence de V1 — sans elle, « excellent » reste une opinion.

### 1.4 Ce que cette étude n'est PAS

- **Pas un gel du contenu.** La largeur _catalogue_ (classes, matières, chapitres) n'est pas
  la largeur _capacités_ (D-6) : la campagne lycée (é16), l'illustration (é18/é19), la
  valorisation des manuels (é21) continuent — elles approfondissent l'actif n° 1 (le contenu
  corrigé) et sont gouvernées par leur propre barre de qualité (axe 5, gates).
- **Pas une réécriture des études d'exécution.** 04, 07, 20, 22, 23 gardent leurs périmètres
  et leurs décisions ; cette étude les **séquence** et leur donne un critère d'arrivée (DoE).
  Quand un trou n'a pas d'étude propriétaire (correction in-session, §3.2), elle le nomme et
  propose un rattachement — l'arbitrage reste humain (Q-4).
- **Pas une bureaucratie.** Aucun gate CI, aucun processus nouveau : la doctrine s'applique
  aux frontières qui existent déjà (création d'étude, validation humaine, revue de lot) via
  une fiche de 4 lignes (D-2).
- **Pas un désaveu.** Le portefeuille d'études est riche parce que l'exploration était
  nécessaire ; la doctrine arrive au bon moment : les briques du cœur sont étudiées, il faut
  maintenant les **finir dans l'ordre**.

## 2. La doctrine (spécification)

### 2.1 Définitions

- **Capacité** : une fonctionnalité du point de vue utilisateur (le player d'exercice, la
  correction, la révision, le donjon, le rapport parent…). L'unité de la scorecard.
- **Verticale** : une **chaîne de valeur complète** pour un utilisateur — plusieurs capacités
  qui, ensemble, tiennent une promesse de bout en bout (« j'apprends une notion et je la
  maîtrise »). L'excellence se juge **sur la verticale**, pas sur la capacité isolée : un
  excellent player avec une révision absente est une verticale cassée.
- **Profondeur** : degré d'achèvement d'une capacité/verticale — le job utilisateur est
  complet, les boucles de données sont refermées, l'UX couvre tous les états, la valeur est
  mesurée. Mesurée par la grille M0-M4 (§2.3).
- **Largeur capacités** : ajouter une capacité ou une verticale nouvelle. Gouvernée par cette
  doctrine (règle §2.4).
- **Largeur catalogue** : ajouter du contenu (classes, matières, chapitres) dans les capacités
  existantes. Gouvernée par la barre de qualité contenu (é18 axe 5, gates `content:qa`,
  audits) — **pas** par cette doctrine (D-6).

### 2.2 Principes (P-1 … P-7)

- **P-1 — Profondeur avant largeur.** Entre approfondir une capacité existante et en ouvrir
  une nouvelle, l'approfondissement gagne **par défaut** ; l'ouverture exige une décision
  humaine explicite motivée (règle §2.4). C'est la transcription directe du mandat.
- **P-2 — Toute boucle se referme.** Une donnée collectée doit nourrir une surface utilisateur
  ou une décision produit **datée** ; sinon on ne la collecte pas (ou on documente le
  consommateur prévu et son échéance). Une télémétrie orpheline est de la largeur déguisée :
  du coût sans valeur encaissée. (Constat fondateur : les 3 boucles mortes de §1.2.)
- **P-3 — Le job complet, pas la feature.** Une capacité n'est « livrée » que si l'utilisateur
  accomplit la promesse de bout en bout, états dégradés compris. Le critère d'arrivée est la
  DoE (§2.3), le pendant **produit** du DoD technique d'AGENTS.md — le DoD garantit que le
  code est sain, la DoE que l'expérience est complète.
- **P-4 — Brique d'excellence.** Chaque capacité visée doit pouvoir devenir une référence de
  son marché : conçue contre les meilleures pratiques documentées (annexe B), pas contre le
  minimum viable. M3 est le plancher de tout ce qui est LIVE ; M4 est réservé aux capacités
  **signature** désignées (D-7) — l'excellence ciblée, pas le gold-plating uniforme.
- **P-5 — IA-native systématique, IA disciplinée.** Pour chaque capacité, la question « que
  peut l'IA ici ? » reçoit une réponse écrite (fiche D-2) — y compris « rien pour
  l'instant ». Le principe d'architecture de l'étude 11 devient un principe **produit**
  transverse : **le déterministe décide, le LLM rédige** (§2.5) — c'est la configuration de
  fait de tous les produits leaders examinés, et la condition de coûts bornés et de sécurité
  pédagogique.
- **P-6 — Mesurer ou ne pas prétendre.** « Excellent » est un état mesuré, pas déclaré : toute
  capacité M3+ nomme ses 1-3 métriques de valeur et l'endroit où on les lit. Tant que la
  mesure produit n'existe pas (é09 non exécutée, monitoring C4 non câblé), la scorecard
  l'affiche comme dette de fondation — pas comme excuse.
- **P-7 — Dire non par défaut.** Le réflexe face à une bonne idée nouvelle est le gel motivé,
  pas le brouillon d'étude. Le portefeuille matérialise les « non » (statut
  `gelée (doctrine verticale)`) pour qu'ils restent visibles et réversibles — dire non à la
  Apple/Linear : quotidiennement, sans culpabilité, par écrit.

### 2.3 Grille de maturité (M0-M4) et Definition of Excellence (DoE)

La maturité d'une **capacité** :

| Niveau | Nom           | Critère discriminant                                                                                                                                       |
| ------ | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **M0** | Absente       | Étude/idée seulement — rien en prod.                                                                                                                       |
| **M1** | Squelette     | La mécanique ou la donnée existe (table, RPC, collecte) mais **l'expérience n'existe pas** : boucle ouverte, aucune surface, ou surface incohérente.       |
| **M2** | Fonctionnelle | Le job utilisateur passe de bout en bout, **sans excellence** : états incomplets, incohérences tolérées, scories, valeur non mesurée.                      |
| **M3** | Aboutie       | La **DoE est tenue intégralement** (ci-dessous). Plancher de toute capacité LIVE.                                                                          |
| **M4** | Référence     | M3 **+** différenciation défendable sur le marché local (souvent IA-native) : la version qu'un concurrent citerait. Réservé aux capacités signature (D-7). |

**La DoE — 8 critères, tous vérifiables** (l'exécuteur les coche comme il coche le DoD) :

1. **Job complet** : la promesse utilisateur est tenue de bout en bout, cas dégradés compris
   (déconnecté, contenu vide, erreur serveur).
2. **Boucles refermées** : toute donnée que la capacité collecte est affichée ou consommée
   (P-2) ; toute donnée qu'elle devrait montrer existe et arrive.
3. **États UX complets** : vide / chargement / erreur / verrouillé-avec-raison, mobile-first,
   conformes aux registres et gabarits de l'é15.
4. **Trilingue réel** : FR/EN/AR (quand la surface est trilingue), RTL vérifié au rendu.
5. **Cohérente** : zéro contradiction avec les autres écrans (le contre-exemple canonique : la
   carte `/parcours` qui verrouille ce que `/matiere` laisse jouer) ; constantes centralisées.
6. **Mesurée** : 1-3 métriques de valeur nommées + où on les lit (P-6).
7. **Robuste** : tests co-localisés (DoD §5), anti-abus/anti-triche pensés, pas de scories
   (déclaré-jamais-créé, constantes mortes).
8. **IA évaluée** : la fiche de verticalité (D-2) documente l'apport IA retenu ou son rejet
   motivé.

### 2.4 La règle de décision (l'arbre d'arbitrage)

Avant d'ouvrir **toute** nouvelle capacité (nouvelle étude, nouveau lot hors étude, nouveau
front) :

1. **La verticale stratégique en cours a-t-elle atteint sa cible ?** (V1 → M3, §3.2). NON →
   la nouvelle capacité attend, sauf décision humaine explicite qui assume l'exception par
   écrit (index FableEtudes).
2. **La proposition approfondit-elle une verticale existante ou en ouvre-t-elle une ?**
   Approfondissement (elle referme une boucle, complète un job, élève une capacité d'un
   niveau M) → elle entre dans la file de sa verticale, priorisée par la valeur.
   Ouverture → **gel par défaut** (P-7), statut `gelée (doctrine verticale)`, dégelable par
   arbitrage humain uniquement.
3. **Arbitrage résiduel** (deux approfondissements en concurrence) : gagne celui qui (a)
   referme une boucle déjà payée (P-2), puis (b) sert la capacité signature (D-7), puis (c) a
   le meilleur ratio valeur/effort.

Cas particuliers : les **fondations** (mesure é09, monitoring/domaine C4, légal GAP-003/024,
harness é24/é25) ne sont ni profondeur ni largeur — elles conditionnent tout et s'exécutent en
parallèle sans passer par l'arbre. La **largeur catalogue** suit sa propre gouvernance (D-6).

### 2.5 Doctrine IA-native

L'état de l'art (annexe B.2) est sans ambiguïté : chez tous les leaders examinés (Duolingo,
Khan Academy, Carnegie Learning), **un moteur déterministe choisit** (l'exercice, la
progression, la difficulté — Birdbrain est une IRT/Elo, pas un LLM) et **le LLM parle**
(explications, conversation, synthèses). Les modèles de knowledge tracing classiques battent
les LLM en prédiction de maîtrise pour un coût par décision incomparablement inférieur ; et le
chatbot sans garde-fous **nuit** à l'apprentissage (Bastani, PNAS : −17 % à l'examen après
usage libre). L'étude 11 v2 avait déjà posé ce principe pour le tuteur ; la doctrine l'élève
au rang **produit** :

- **P-5a** — le learner model du produit est et reste déterministe : SM-2, EWMA de maîtrise
  (é07), `difficulty_adaptation`, misconceptions. Aucun LLM ne décide d'une progression, d'un
  déblocage ou d'une récompense.
- **P-5b** — le LLM intervient là où le langage est la valeur : expliquer, reformuler,
  converser, synthétiser — **ancré** sur des données vérifiées fournies dans le prompt
  (l'explication canonique, la clé, le tag de misconception), jamais en calcul libre.
- **P-5c** — la génération de **contenu** reste offline + gates + revue (l'usine
  `content-*`/`prof-*` actuelle est exactement l'état de l'art — le fiasco des 148 cours
  Duolingo d'avril 2025 documente l'anti-pattern inverse).
- **P-5d** — toute capacité LLM runtime passe par **une seule porte** : le socle é11 lot 0
  (adaptateur, comptabilité `ai_usage_events`, quotas/énergie, kill-switch). Pas de deuxième
  intégration LLM parallèle.
- **P-5e** — garde-fous mineurs non négociables (standard Khanmigo, annexe B.2) : jamais le
  nom de l'élève dans un prompt, conversations journalisées et visibles des parents, quotas,
  pas d'entraînement sur les données élèves.

Application par capacité (les études propriétaires spécifient ; classement valeur/risque en
annexe B.2) :

| Capacité              | Apport IA retenu (par qui)                                                                                  | Rang B.2 |
| --------------------- | ----------------------------------------------------------------------------------------------------------- | -------- |
| Correction à l'échec  | Explication personnalisée ancrée sur l'item + le distracteur choisi + le tag (é11, « expliquer ce ratage ») | 1        |
| Usine de contenu      | Génération offline gated + revue (déjà en place ; consolider : auto-consistance, solveurs)                  | 2        |
| Tuteur / chat cadré   | Indices progressifs qui ne donnent jamais la réponse (é11, pattern « GPT Tutor » de Bastani)                | 3        |
| Sélection/progression | **Aucun LLM** — le déterministe décide (P-5a) ; c'est un apport « négatif » mais structurant                | 4        |
| Rapport parent        | Digest hebdo en langage naturel FR/AR sur agrégats déterministes (é08 re-scopée / é11 bilans)               | 5        |
| Banque d'exercices    | Variantes paramétriques vérifiées par solveur, batch (é04-A3 gelé — plus tard)                              | 6        |
| Pistes langues        | Conversation/roleplay écrit puis oral (après V1 — coût et modération supérieurs)                            | 7        |

**Fenêtre de marché** (annexe B.2 Q8) : aucun tuteur IA aligné sur le programme tunisien FR/AR
n'existe ; le leader local (TakiAcademy) n'a pas d'IA documentée. La combinaison « corpus
corrigé propriétaire + télémétrie de misconceptions + graphe de compétences + LLM discipliné »
est exactement l'actif que personne d'autre n'a localement — c'est la matérialisation du
« avantage compétitif » du mandat, et la raison stratégique de finir le socle V1 d'abord :
**c'est lui qui rend l'IA non-gadget.**

### 2.6 Hors périmètre (v1)

- Aucune implémentation produit dans cette étude (les lots sont documentaires ; le code reste
  dans les études propriétaires).
- Pas de refonte des études existantes ni de leurs décisions.
- Pas de gate CI de doctrine (D-5) ; pas de processus de comité.
- La politique de largeur catalogue (rythme des campagnes de contenu) — gouvernée par é16/é18/
  é21 et l'arbitrage humain de Q-2.

## 3. Application au portefeuille (analyse)

### 3.1 Scorecard de verticalité (état au 2026-07-19)

Notation par la grille §2.3, preuves détaillées en annexe A. Seules les capacités **auditées
ce jour** sont notées ; les autres seront évaluées au lot 2.

| Capacité                         | M      | Le trou principal (s'il y a)                                                                           |
| -------------------------------- | ------ | ------------------------------------------------------------------------------------------------------ |
| Player d'exercice (types natifs) | M2+    | Riche en mécanique (é03) ; **aucun feedback in-session**, explication payante en run (annexe A.2)      |
| Correction post-session          | M2     | Review complète (hors quiz) mais : pas de lien cours, pas de misconception, pas de média               |
| Révision espacée                 | **M1** | Collectée + calculée + envoyée + **jamais rendue** (`pendingSpacedReps`) — boucle morte n° 1           |
| Diagnostic (misconceptions)      | **M1** | Écrit par trigger, **lu par personne** — boucle morte n° 2                                             |
| Adaptativité (sélection)         | **M1** | `difficulty_adaptation` jamais consommée ; sélection statique `display_order` — boucle morte n° 3      |
| Rappel actif                     | M2+    | Livré profond (é17) mais faux négatifs en prod → é20 validée non exécutée                              |
| Carte `/parcours` & guidage      | M2−    | **Incohérence frontale** : verrou séquentiel visuel que rien d'autre n'impose (é22 lot 1)              |
| Hub matière `/matiere`           | M3−    | Riche (accordéons, gate quiz, Rappel, manuel) ; étoiles de difficulté é22 R-13 absentes                |
| Dashboard                        | M2+    | Focus « prochaine action » existe (heuristique ad hoc) ; objectifs avec scories (`10_min` jamais créé) |
| Donjon                           | M2     | Jouable, mais pool **non scopé** au niveau de l'élève (une 3ᵉ année peut tirer une question de bac)    |
| Duels & ligues                   | M3     | Profond (é05) ; s'arrête à la cohorte : pas de « Ma classe »                                           |
| Leaderboard                      | M2     | Global + par matière ; **aucune cohorte de classe** — la comparaison la plus légitime n'existe pas     |
| Boutique & consommables          | M3−    | Mécanique complète et testée ; usage **non mesuré** (é09)                                              |
| Rapport parent (`/suivi`)        | M3     | 11 sections, accès public par code — sans misconceptions ni révision (é04-A2.2)                        |
| Cours (lecture)                  | M3     | é18 livrée (structure, cartes, figures) ; campagne illustration en cours                               |
| Contenu (l'actif)                | M3     | 566 chapitres, ~18 700 questions, gates + audits ; profondeur inégale par classe (largeur catalogue)   |
| Harness d'ingénierie             | M3+    | CI/CD zéro-geste, gates, skills — é24/é25 en cours le rendent portable et protégé                      |
| Mesure produit (fondation)       | **M0** | é09 non lancée, monitoring C4 non câblé, domaine non câblé : **l'excellence n'est pas observable**     |

Lecture : **le cœur pédagogique de l'app (comprendre son erreur, réviser, être guidé) est la
zone la plus basse de la scorecard** — M1-M2 — alors que les capacités périphériques (duels,
boutique, rapport parent) sont à M3. Le produit est littéralement plus profond sur ses
périphéries que sur son centre. C'est l'inverse du mandat, et c'est réparable vite : les
données et les études existent.

### 3.2 Les verticales stratégiques (proposition, arbitrage Q-1)

**V1 — Apprendre & maîtriser (la boucle cœur) — LA priorité.**
Promesse : « je travaille une notion, je comprends mes erreurs, je révise au bon moment, je
vois ma maîtrise monter, je sais toujours quoi faire ensuite. »
Capacités : player → correction → révision → diagnostic → maîtrise → guidage.
Cible : M3 partout avant la rentrée ; **signature M4** : le duo correction-révision (c'est le
différenciateur défendable — annexe B : feedback élaboré d ≈ 0,99, mastery +0,26 SD mesuré).
**Pipeline mandaté** (chaque item reste dans son étude propriétaire ; ordre d'exécution) :

1. **é22 lots 1-6** (validée, prête) — répare les incohérences : carte honnête, boucle SM-2
   refermée, donjon scopé, « Ma classe », rentrée, « prochaine action » unifiée.
2. **é04-A1.1** — « Révision du jour » jouable (é22 la mandate déjà comme brique suivante).
3. **Correction riche à l'échec** — le trou sans propriétaire (Q-4) : feedback in-session,
   lien « revoir le cours » par question ratée, misconception affichée en langage élève.
4. **é07 lots 2-5** — maîtrise par compétence (EWMA), panneau « ce qui te bloque », plan
   compétence-aware.
5. **é04-A2** — « Points faibles » élève + rapport parent enrichi.
6. **é20 lot 1+** (validée) — le Rappel cesse de refuser des réponses justes.
7. **é23 lots 1-4** (brouillon, Q-1 é23 à trancher) — la vidéo du prof dans le cours et au
   moment de l'échec.
8. **é19 lot 1** — doctrine + gate figures sur les questions spatiales.
9. **é11 (tuteur)** — l'étage IA, une fois le socle vivant : ses Q-1…Q-9 s'arbitrent alors
   (elle-même recommande é04-A1.1 + é07 lots 2/4 comme prérequis souples).

**V2 — Réussir son concours (6ᵉ / 9ᵉ / bac).** Examen blanc (é02 re-scopée), annales
(`NN-annales-bac`), percentile, préparation guidée. S'ouvre quand V1 ≥ M3 (l'examen blanc
sans révision intelligente serait une coquille). Différenciation locale maximale à terme (M4).

**V3 — Jouer ensemble (l'arène).** Donjon scopé + « Ma classe » (déjà dans é22/V1), ligues
(é05 ✅) ; é10 (anti-fraude) s'active quand le volume le justifie. Cible M3 — pas signature.

**V4 — Accompagner mon enfant (parent).** Rapport ✅ M3 → é08 re-scopée (post 04-A2/07) +
digest IA rédigé (rang 5 de B.2). Cible M3-M4.

**Fondations transverses** (hors verticales, exécutables en parallèle — règle §2.4) :
**mesure** (é09 lots 1-2 + monitoring/domaine C4 — condition du KPI-4 et de P-6), qualité
contenu (campagnes é16/é18/é21, gouvernance D-6), légal (GAP-003/024), harness (é24/é25 à
finir).

### 3.3 Le re-séquencement du portefeuille (proposition, arbitrages Q-1/Q-3)

| Mouvement                 | Études                                                                                                                                                                                                     |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **File V1 (prioritaire)** | é22 → é04-A1.1 → [correction riche, Q-4] → é07 (2-5) → é04-A2 → é20 → é23 → é19 lot 1 → é11                                                                                                                |
| **Fondations parallèles** | é09 (lots 1-2, tôt — faible complexité, débloque P-6/KPI-4) · C4 (Mohamed : domaine, monitoring) · é24/é25 (finir) · é15 (clore — lots cochés jusqu'au 13)                                                 |
| **Contenu (fil continu)** | é16 vague A (lycée) · campagnes illustration · é21 lot 1 (doctrine manuels) · é19 campagne — cadence arbitrée en Q-2                                                                                       |
| **File V2 (après V1≥M3)** | é02 (re-scopée gratuite : « examen blanc » sans wording premium)                                                                                                                                           |
| **File V4**               | é08 (re-scopée, après é04-A2)                                                                                                                                                                              |
| **Gels proposés (Q-3)**   | é06 (PWA offline — besoin non documenté), é10 (anti-fraude — s'active au volume), é12 (studio in-app — le canal opéré é13 suffit) → statut `gelée (doctrine verticale)` ; é01 reste gelée (phase gratuite) |

Effet net : le nombre d'études « en exécution » converge vers ≤ 3 (KPI-3) — typiquement une
de la file V1, une fondation, le fil contenu.

### 3.4 Ce que dit le marché (synthèse — sources et réserves en annexe B)

- **Le modèle** : Duolingo a passé ~10 ans sur une seule verticale avant Math (2022) et Music
  (2023) ; sa croissance a été relancée non par des features mais par l'optimisation
  obsessionnelle de la rétention de la boucle existante (CURR +21 % → DAU ×4,5 ; 600+
  expériences sur le seul streak). Sa doctrine publique (« Take the Long View », « Raise the
  Bar ») est le mandat de cette étude, appliqué depuis 2012.
- **Le contre-modèle** : BYJU'S a acheté la largeur (2,5-3,6 Md$ d'acquisitions) en négligeant
  un cœur produit décrié — valorisation 22 Md$ → quasi zéro en 2 ans. La largeur sans
  profondeur ne protège rien.
- **La profondeur qui paie est pédagogique, pas volumétrique** : l'apprentissage actif vaut
  +0,47 SD (Freeman/PNAS), le mastery learning par compétence +0,26 SD mesuré à 30 min/semaine
  (Khan/MAP) — exactement les paris é03 (types actifs) et é07 (maîtrise).
- **La rétention est le juge de paix** : médiane edtech D30 ≈ 2-3 % ; les leaders s'en
  détachent par l'habitude quotidienne (streak 7 j → 2,4× retour lendemain) et la raison
  personnalisée de revenir demain — précisément « Révision du jour » (é04-A1.1).
- **Feature fatigue** : la recherche (JMR 2005/HBR 2006) prouve que l'accumulation de
  fonctions séduit avant l'usage et dégrade la satisfaction après — la base scientifique de
  P-7.

## 4. Architecture de gouvernance (décisions fermées)

> Aucun runtime, aucune table, aucun secret. Les « objets » de cette étude sont des documents
> normatifs et des règles de process.

- **D-1 — Où vit la doctrine.** Un doc normatif **`docs/doctrine-verticale.md`** (les principes
  P-1…P-7, grille M0-M4, DoE, règle de décision, doctrine IA-native — §2 de cette étude,
  format doc de référence) + un **ancrage court dans AGENTS.md** (le doc canonique depuis é25
  lot 1 — 3-5 lignes près du « Definition of Done » : la règle d'arbitrage + le renvoi), pour
  que toute session le lise sans charger l'étude ; les pointeurs d'outils (CLAUDE.md, Copilot,
  Gemini) suivent sans édition. _Rejeté_ : doctrine uniquement dans l'étude (invisible des
  sessions d'exécution).
- **D-2 — La fiche de verticalité.** `FableEtudes/_TEMPLATE.md` gagne 4 lignes dans
  l'en-tête : `Verticale : <V1…/fondation/catalogue>` · `Maturité visée : <M2/M3/M4>` ·
  `Boucles : <ce que l'étude referme / ce qu'elle ouvre et qui le consommera>` ·
  `Apport IA : <retenu ou rejeté motivé>`. Toute **nouvelle** étude la remplit ; les études
  existantes ne sont pas rétro-modifiées (le §3 de cette étude les positionne déjà).
  _Rejeté_ : un processus de revue séparé (bureaucratie, RISK-1).
- **D-3 — La scorecard vit dans STATUS.md.** Le tableau §3 de STATUS.md (« état réel des
  features ») gagne une colonne **« M »** (M0-M4, datée) alimentée par §3.1/annexe A puis
  maintenue aux jalons (règle de maintenance §0 de STATUS.md inchangée). _Rejeté_ : un fichier
  `VERTICALITE.md` séparé (fragmentation du topo central).
- **D-4 — Le séquencement vit dans l'index.** La section « Ordre d'exécution recommandé » de
  `FableEtudes/README.md` est réécrite selon §3.3 (files par verticale + fondations + fil
  contenu + gels). L'humain reste l'arbitre de l'ordre ; l'index reste l'instantané.
- **D-5 — Pas de gate CI de doctrine.** La doctrine s'applique aux frontières humaines
  existantes : création d'étude (fiche D-2), validation (l'humain vérifie la fiche), revue de
  lot (la DoE complète le DoD). _Rejeté_ : un lint `doctrine:check` — indécidable
  mécaniquement, friction sans valeur.
- **D-6 — Largeur catalogue ≠ largeur capacités.** Le contenu (classes/matières/chapitres)
  continue sous sa propre gouvernance (barre é18 axe 1-5, gates, registre de suivi, é21) ; la
  règle §2.4 ne s'applique qu'aux **capacités**. Un déséquilibre assumé : le contenu est
  l'actif dont la largeur EST de la profondeur de catalogue (un élève de 8ᵉ sans sa classe n'a
  rien à approfondir) — la cadence reste arbitrée par l'humain (Q-2).
- **D-7 — Signature M4.** Capacités signature proposées (Q-5) : **correction-révision**
  (V1), **tuteur é11** (V1, étage IA), **examen blanc é02** (V2, à terme). Tout le reste vise
  M3 et s'y arrête — l'anti-gold-plating est une règle, pas un vœu (RISK-2).
- **D-8 — Une seule porte LLM runtime.** Reprise produit de é11 lot 0 : adaptateur unique,
  comptabilité `ai_usage_events`, quotas, kill-switch. Aucune capacité IA runtime hors de
  cette porte (P-5d).

### Observabilité

Les métriques de la doctrine sont celles des KPI §1.3, lues dans : la scorecard STATUS.md
(KPI-1/2), l'index FableEtudes (KPI-3), et — dès é09/C4 livrés — la métrique de retour
hebdomadaire (KPI-4, calculable en attendant par requête sur `attempts`).

## 5. Plan d'exécution en lots

| lot | contenu (résumé)                                                                                                                                                                                              | fichiers/objets créés                                                                   | tests exigés                                            | dépend de      |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------- | -------------- |
| 1   | **Doctrine normative** : `docs/doctrine-verticale.md` (P-1…7, M0-4, DoE, règle, IA) + ancrage canonique (AGENTS.md) + fiche D-2 dans `_TEMPLATE.md` + règle de création d'étude dans `FableEtudes/README.md`  | `docs/doctrine-verticale.md` ; édits AGENTS.md, `_TEMPLATE.md`, `FableEtudes/README.md` | `npm run verify` vert (aucun code) ; liens/refs valides | validation Q-1 |
| 2   | **Portefeuille re-séquencé + scorecard** : « Ordre d'exécution recommandé » réécrit (§3.3) ; statuts gelés actés (Q-3) dans l'index + en-têtes des études gelées ; colonne « M » dans STATUS.md §3 (annexe A) | édits `FableEtudes/README.md`, `06/10/12-*/ETUDE.md` (en-tête statut), `STATUS.md`      | idem ; cohérence index ↔ en-têtes vérifiée              | lot 1, Q-1/Q-3 |

- [ ] Lot 1 — doctrine normative (docs + template + ancrage)
- [ ] Lot 2 — portefeuille re-séquencé + scorecard STATUS.md

**Stop-points** : le lot 1 ne modifie AUCUNE étude existante (seulement le template et
l'index) ; le lot 2 ne gèle que ce que Q-3 a arbitré, et ne touche pas au contenu des études
gelées (en-tête statut uniquement). **Hors lots** (travail d'architecte, post-arbitrage) :
l'amendement de l'étude propriétaire retenue en Q-4 pour la « correction riche » ; les
re-scopages é02/é08 au moment où leurs files s'ouvrent.

## 6. Stratégie de test

Étude documentaire : pas de code produit. Par lot : `npm run verify` doit rester vert
(prouve zéro impact build/lint) ; revue humaine des documents (c'est le vrai test — la
doctrine est validée par celui qui l'arbitre) ; vérification des liens/références croisées
(chaque doc cité existe, chaque étude référencée porte le bon statut). La **preuve d'usage**
de la doctrine est différée aux études suivantes : la première étude créée après le lot 1 doit
porter la fiche D-2 (contrôle à la validation humaine).

## 7. Risques & mitigations

- **RISK-1 — La doctrine devient une bureaucratie.** Probabilité moyenne, impact moyen.
  _Mitigation_ : D-2 = 4 lignes, D-5 = zéro gate ; la doctrine s'applique aux frontières qui
  existent déjà. Si la fiche prend plus de 10 minutes, c'est un bug de la doctrine.
- **RISK-2 — Le perfectionnisme (gold-plating) : « profondeur » devient « on ne livre plus ».**
  Probabilité moyenne, impact fort. _Mitigation_ : la DoE est une **check-list finie** (8
  points vérifiables), pas un idéal ; M3 est la cible par défaut et M4 une liste fermée
  (D-7) ; la leçon Linear s'applique aux lots : scope petit, mais **fini**.
- **RISK-3 — « Excellent » invérifiable sans mesure produit.** Certain aujourd'hui (M0),
  impact fort sur P-6/KPI-4. _Mitigation_ : é09 promue fondation parallèle (§3.3) ; C4
  (domaine, monitoring) listé comme prérequis humain ; en attendant, proxys DB assumés comme
  tels dans la scorecard.
- **RISK-4 — Conflit avec la rentrée (largeur catalogue nécessaire).** Les élèves de septembre
  doivent trouver leur classe. _Mitigation_ : D-6 sort le catalogue de la règle §2.4 ; Q-2
  arbitre explicitement la couverture minimale visée — le conflit devient un choix daté, pas
  une tension sourde.
- **RISK-5 — La doctrine est ignorée par les sessions.** Probabilité faible-moyenne, impact
  moyen. _Mitigation_ : ancrage dans le doc canonique (D-1) — le seul fichier que toute
  session lit ; fiche dans le template (D-2) ; scorecard sous les yeux dans STATUS.md (D-3).
- **RISK-6 — Perception « on n'innove plus »**. Faible. _Mitigation_ : la file V1 **livre du
  visible** (Révision du jour, Points faibles, Ma classe, correction riche, vidéos, tuteur) —
  la verticalisation n'est pas de la maintenance, c'est la partie la plus différenciante du
  produit qui attendait son tour.

## 8. Questions ouvertes (pour l'humain)

- **Q-1 — Les verticales et leur ordre.** Valider le découpage V1→V4 + fondations (§3.2) et
  **V1 en priorité absolue** avec son pipeline mandaté (é22 → é04-A1.1 → correction riche →
  é07 → é04-A2 → é20 → é23 → é19 → é11). _Recommandation : oui — c'est la traduction directe
  du mandat sur l'état mesuré du code._
- **Q-2 — L'objectif rentrée (largeur catalogue).** Quelle couverture de classes est
  **non négociable** pour septembre 2026 (statu quo : primaire + collège + 9ᵉ complets, 1ère
  sec ouverte, reste du lycée en cours) — et quelle part de l'effort de sessions va au fil
  contenu vs à la file V1 ? _Recommandation : V1 prioritaire côté ingénierie produit ; le fil
  contenu continue en parallèle au rythme des sessions de campagne dédiées (les deux ne se
  cannibalisent que sur le budget de sessions) ; pas de nouvelle classe « vitrine » si sa
  qualité ne tient pas la barre é18._
- **Q-3 — Les gels.** Acter `gelée (doctrine verticale)` pour é06 (PWA), é10 (anti-fraude),
  é12 (studio in-app) — réversible par arbitrage. _Recommandation : oui pour les trois ; é10
  se dégèle d'elle-même quand V3 a du volume réel._
- **Q-4 — Le propriétaire de la « correction riche à l'échec ».** Le trou n° 1 de la boucle
  cœur (feedback in-session, lien cours par erreur, misconception affichée) n'a pas d'étude
  propriétaire. Options : (a) **amendement de l'étude 04** (nouvelle phase A1.2 « correction
  riche », rédigée par l'architecte à la validation — recommandé : c'est le même socle
  télémétrie/tags et la même surface que A1.1) ; (b) mini-étude dédiée. _Recommandation : (a)._
- **Q-5 — Les capacités signature (M4).** Valider la liste D-7 : correction-révision, tuteur
  (é11), examen blanc (é02, à terme). _Recommandation : oui ; tout le reste s'arrête à M3._

Une étude passe `validée` quand cette section est arbitrée. Les Q-1…Q-9 de l'étude 11 et les
questions propres de é23/é19/é21 restent à arbitrer **dans leurs études** — cette étude ne les
court-circuite pas, elle fixe seulement leur rang.

## 9. Journal d'exécution

_(rempli au fil des lots)_

---

## Annexe A — Scorecard détaillée (audit code du 2026-07-19)

Audit mené sur le worktree courant (branche à jour de `main` au 2026-07-19). Chaque constat a
été vérifié sur le fichier cité.

### A.1 Les trois boucles mortes (collecte payée, valeur non encaissée)

1. **SM-2 / révision espacée** — `spaced_repetition_schedule` alimentée à chaque échec < 60 %
   (INSERT dans `submit_exercise_attempt`, dernière définition
   `supabase/migrations/20260714130000_recall_mode_rpcs.sql`) ; `getSprint2Dashboard`
   (`src/features/dashboard/dashboard.server.ts` l.563-616) lit les lignes dues
   (`status='pending'`, `scheduled_for <= now`, limit 3) et renvoie `pendingSpacedReps`
   (l.614) ; **aucun composant client ne le rend** (grep exhaustif : uniquement serveur +
   tests). De plus, **aucune ligne ne passe jamais à `completed`** (aucun
   `UPDATE … SET status='completed'` sur cette table dans les migrations) — constat déjà porté
   par é22 §1.1, lot 2.
2. **Misconceptions** — `user_misconceptions` (agrégat trigger, migration `20260706120000`,
   RLS SELECT owner-only correcte) : **zéro lecteur** dans `src/` hors pipeline de contenu et
   types générés. Ni le dashboard, ni la progression, ni le rapport parent
   (`src/features/parent-report/`) ne l'affichent.
3. **Adaptativité** — `difficulty_adaptation` écrite à chaque soumission (±1 par moyenne
   récente, `harden_scoring_anti_rush.sql` l.236-283) ; **aucun sélecteur ne la lit** (les 8
   occurrences `FROM difficulty_adaptation` sont l'auto-mise-à-jour de la RPC).
   `computeNextExerciseId` (`src/features/quest/next-exercise.ts` l.11-31) est statique
   (`display_order`) ; `get_dungeon_questions` filtre par difficulté d'étage puis
   `ORDER BY random()` — sans grade ni thème (é22 lot 5).

### A.2 Le moment de l'erreur (la capacité la plus pauvre)

- **In-session : rien.** `exercise-player.tsx` : `advanceWithChoice` (l.438-454) et `validate`
  (l.456-459) enchaînent immédiatement ; pas d'état correct/faux par question ; sons
  victoire/échec seulement à l'écran final.
- **Post-session : correcte mais isolée.** `QuestReviewList` (exercices non-quiz uniquement) :
  énoncé, ta réponse, bonne réponse, explication (`RichField`). **Absents** : lien « revoir le
  cours » par question (le lien n'existe que sur l'écran d'échec d'un **quiz**), tag de
  misconception, média. Les quiz masquent toute review (anti-mémorisation, serveur, assumé).
- **Pendant le run, l'explication est un consommable** : `QuestHintButton` → `consume_hint`
  (une charge) révèle `questions.explanation` — en phase gratuite, le levier d'apprentissage
  n° 1 (feedback élaboré) est donc monnayé en coins pendant la pratique. Tension à trancher
  dans l'étude propriétaire de la correction riche (Q-4) : l'indice **pendant** la question
  (anti-triche, garde sa friction) n'est pas l'explication **après** l'erreur (pédagogie,
  devrait être gratuite et immédiate).
- **Anonyme** : `check_answers` renvoie `explanation: null` pour `auth.uid() IS NULL` — le
  visiteur voit la clé mais jamais le pourquoi (choix de conversion à réexaminer dans é23/Q-4 ;
  cohérent avec l'esprit « contenu public », discutable au moment de l'erreur).

### A.3 Incohérences & scories (profondeur négative)

- **La carte qui ment** : `buildSubjectNodes` (`src/features/parcours/journey.ts` l.61-93)
  verrouille visuellement chaque matière tant que la précédente n'a pas ≥ 1 tentative — verrou
  qu'aucun autre écran ni le serveur n'impose (é22 lot 1 ; `NodeState` n'a pas l'état `next`).
- **Objectifs fantômes** : `DEFAULT_DAILY_OBJECTIVES`/`DEFAULT_WEEKLY_QUESTS`
  (`gamification.ts` l.72-81) déclarent `10_min` et `maintain_streak_5` que
  `ensure_daily_weekly_goals` (migration `20260604200000` l.63-71) **ne crée jamais** ; les
  récompenses TS et SQL divergent (75/15 vs 50/10 pour `3_exercises`) — le SQL fait foi, les
  constantes mentent (é22 lot 6).
- **Leaderboard sans cohorte** : global + par matière du parcours ; pas de « Ma classe »
  (`get_grade_leaderboard` de é22 R-23 inexistante).
- **é22 : 0/6 lots implémentés** (vérifié lot par lot sur le code — verrou carte présent, pas
  d'`UPDATE completed`, pas de `current_parcours_set_at`, pas de RPC grade, donjon non scopé,
  pas de `resolveNextAction`).

### A.4 Les points hauts (la preuve que la verticalité paie)

- **Écrans riches** : résultat de quête (récompenses, badges, potion, bouclier, déblocage
  Rappel, review) ; hub `/matiere` (fil d'Ariane, manuel officiel, reprise, accordéons
  chapitre, gate quiz avec contrat, rangs de missions tri-état, lignes Rappel) ; rapport
  parent 11 sections servi aussi en public par code d'alliance (`/suivi`).
- **Zéro dette annotée** : aucun TODO/FIXME/HACK dans `src/features` + `src/shared` — la dette
  vit dans les études, pas en commentaires. (Revers : les boucles mortes sont invisibles à la
  lecture du code seul — d'où la scorecard D-3.)
- **~33 routes** dont 13 gameplay authentifié, 9 publiques, 5 admin : le périmètre de
  _surfaces_ est déjà large — un argument de plus pour refermer avant d'ouvrir.

## Annexe B — Benchmark marché & état de l'art IA (recherche du 2026-07-19, sourcée)

Deux recherches indépendantes, croisées ; seuls les faits recoupés ou de source primaire sont
repris ici. ⚠ signale les chiffres à manier avec précaution (source secondaire ou marketing).

### B.1 La stratégie verticale chez les référents

| Fait                                                                                                                                                                                         | Source (primaire quand possible)                                       |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Duolingo : lancement public 19/06/2012 ; première extension hors langues (Math) **27/08/2022** ; Music 10/2023 — **~10 ans mono-verticale**                                                  | Wikipedia ; communiqué investisseurs Duolingo                          |
| 2012→2017 : pas de monétisation — seulement « mieux enseigner » + rétention (von Ahn)                                                                                                        | Tim Ferriss Show #607 (transcript) ; Quartr                            |
| Relance de la croissance par la rétention de la boucle existante : CURR +21 % → **DAU ×4,5** en ~4 ans ; leaderboards +17 % de temps d'apprentissage                                         | Jorge Mazal (ex-CPO), Lenny's Newsletter                               |
| **600+ expériences sur la seule mécanique de streak** ; streak 7 j → 2,4× plus de retour le lendemain ; >50 % des DAU en streak ≥ 7 j ; DAU/MAU ~37 % (Q3 2025)                              | Blog Duolingo ; SEC (8-K, lettres actionnaires)                        |
| Doctrine publique : « Take the Long View », « Raise the Bar », « Make It Fun » ; flywheel « meilleur produit → bouche-à-oreille »                                                            | Handbook Duolingo (02/2025) ; page stratégie officielle                |
| BYJU'S : ~20-25 sociétés achetées pour **2,5-3,6 Md$** (fourchette selon périmètre ⚠) ; pic 22 Md$ (2022) → ~-99 % (2024) ; cœur produit décrié + gouvernance                                | CNBC ; Cornell Business ; Zerodha Daily Brief (post-mortems croisés)   |
| Brilliant : zéro vidéo, « challenge first », la motivation comme problème n° 1 (Sue Khim) ; ancrage indépendant : apprentissage actif **+0,47 SD**                                           | Interviews fondatrice ; Freeman et al. 2014, PNAS                      |
| Khan Academy : mastery learning par compétence ; **+0,26 SD** à 30 min/semaine (MAP Accelerator, ~400 k élèves ⚠ étude maison) ; mythe des « 2 sigmas » surestimé (critique VanLehn ~0,8 SD) | Papier EDM 2022 ; blog Khan ; Bloom 1984 + critique                    |
| Photomath : UNE capacité (photo → résolution pas à pas), ~300 M téléchargements → rachat Google (finalisé 2023)                                                                              | Wikipedia ; presse d'acquisition                                       |
| Feature fatigue : les utilisateurs choisissent le produit riche **avant** usage et sont plus satisfaits du produit simple **après**                                                          | Thompson/Hamilton/Rust, JMR 2005 ; HBR 02/2006                         |
| Rétention edtech : médiane D30 ≈ **2-3 %** (⚠ sources secondaires) — l'écart leader/médiane est la profondeur de la boucle, pas la taille du catalogue                                       | Agrégats Adjust/AppsFlyer via secondaires ; Lenny/Casey (bench 6 mois) |

**Transposition (les 5 enseignements retenus)** : (1) la phase gratuite actuelle est la
fenêtre Duolingo 2012-2017 — tout mettre sur « mieux enseigner + retenir », d'où KPI-4 ; (2)
dominer un territoire étroit à enjeu (les années de concours) vaut mieux qu'étaler ; (3) la
profondeur défendable est **pédagogique** (actif, mastery, feedback) — é03/é07/é04 sont les
bons paris ; (4) tenir une quality bar écrite et dire non (P-4/P-7, DoE) ; (5) l'habitude
quotidienne est le produit — streak, objectif court, raison personnalisée de revenir demain
(é04-A1.1).

### B.2 L'état de l'art IA-native (2024-2026)

**Le pattern gagnant est établi** : explication personnalisée **au moment de l'échec, ancrée
sur l'item raté** — Duolingo « Explain My Answer » (GPT-4, 2023 ; ⚠ passé au gratuit début
2026 selon une source secondaire — signal : cette capacité devient un standard, plus un
premium), Khanmigo (socratique forcé, **groundé sur les exercices/solutions humains** — leur
mise à jour d'architecture documentée), Carnegie LiveHint (LLM par-dessus 25 ans de données
MATHia). Contre-signal : Quizlet Q-Chat, chatbot générique plaqué, **retiré en 2025**.

**La science** : feedback élaboré **d ≈ 0,99** vs simple correct/incorrect (Wisniewski/Zierer/
Hattie 2020, 435 études) — le fondement du rang 1 ; tuteur IA scénarisé > classe active
(Kestin/Miller, Scientific Reports 2025, ⚠ 2 leçons, population Harvard) ; +0,3 SD en 6
semaines avec enseignant dans la boucle (Banque mondiale, Nigeria 2024 ⚠ working paper) ; et
le garde-fou décisif : **ChatGPT nu = −17 % à l'examen** vs +0 (neutralisé) avec guardrails
« indices sans réponse + erreurs fréquentes dans le prompt » (Bastani et al., PNAS 2025). Le
design pédagogique, pas le modèle, fait le résultat.

**Le learner model** : consensus de facto chez 100 % des leaders — **le déterministe décide
(IRT/Elo Birdbrain, moteurs adaptatifs), le LLM parle**. Les modèles de knowledge tracing
classiques battent les LLM fine-tunés en prédiction de maîtrise (EDM 2024, +0,04-0,13 AUC)
pour un coût par décision très inférieur. La doctrine é11 est donc l'état de l'art, pas une
prudence locale.

**Génération de contenu** : offline + revue humaine + gates = le standard sérieux (le pipeline
`content-*`/`prof-*` actuel) ; la génération runtime non vérifiée en maths est l'anti-pattern
documenté (hallucinations ; fiasco qualité des 148 cours IA Duolingo, 04/2025). Parades
éprouvées si besoin d'échelle : auto-consistance (majorité de N générations), vérification par
solveur.

**Coûts** (⚠ ordres de grandeur, source ibl.ai + prix publics) : ~0,002-0,025 $ la session de
tutorat selon modèle ; un élève actif à 30 explications/mois ≈ **0,06-0,75 $/mois** ; cache et
petits modèles au primaire rendent le poste marginal — cohérent avec le chiffrage énergie/
quotas de é11 annexe A. Khanmigo est passé de 9 à 4 $/mois en deux ans (déflation tokens).

**Garde-fous mineurs (standard Khanmigo, à répliquer)** : compte lié au parent, modération
avec alerte adulte, historique visible des parents (l'enfant le sait), limite quotidienne,
zéro entraînement sur les données élèves, minimisation (jamais le nom dans le prompt).

**Marché FR/AR** : France — MIA Seconde (adaptatif déterministe d'État, 800 k élèves),
Evulpo/GoStudent/Kartable (chatbots d'aide, profondeur variable) ; monde arabe — Alef
Education (B2G, 2 M élèves, IA réelle), Noon/Abwaab (social/vidéo, IA non documentée) ;
**Tunisie — TakiAcademy (leader, centaines de milliers d'élèves) : aucune IA documentée ;
aucun tuteur IA aligné programme tunisien FR/AR n'existe**. La fenêtre est ouverte ; le socle
V1 (misconceptions + maîtrise + révision) est ce qui la transformera en avantage défendable.

### B.3 Réserves de fiabilité

Faits Duolingo (chronologie, DAU, streak) : SEC + blog officiel + ex-dirigeants — solides.
BYJU'S : totaux M&A divergents (périmètres) — fourchette citée. Rétention edtech : sources
secondaires — ordres de grandeur seulement. Efficacité Khan/Brilliant : études maison ou
marketing (biais pro domo signalé) — les ancrages indépendants sont Freeman 2014 et
Wisniewski 2020. Adoption Duolingo Max : chiffres marketing écartés. Prix Khanmigo districts :
contradictoires selon la date (15-60 $/élève/an) — seule la trajectoire (÷4 en 2 ans) est
retenue.

# ROADMAP — ordre d'exécution du reste-à-faire (études, lots, contenu)

> **Instantané du 2026-07-20 (révisé le soir même)** — déclinaison opérationnelle de l'**étude 26
> (doctrine verticale : profondeur avant largeur)**. Les Q-1…Q-5 de l'étude 26 ayant été
> **arbitrées le 2026-07-20**, cet ordre n'est plus une recommandation d'architecte : il est
> **officiel**. La même session a rendu **tous les arbitrages en attente** (A1→A5) — plus aucune
> ligne de ce fichier n'est bloquée par une décision humaine. Ce fichier est un instantané daté,
> à resynchroniser quand un lot est livré (cocher la case dans la même PR) — l'état de référence
> reste [STATUS.md](../STATUS.md) + l'[index des études](./README.md).
> **Jalon produit : rentrée scolaire, 1ᵉʳ septembre 2026** (§7).

## 0. Mode d'emploi (comment exécuter cette roadmap)

1. **Une ligne = une session = un lot = une PR** (règles FableEtudes inchangées : cadre fermé,
   DoD intégral, la session suit sa PR jusqu'au merge).
2. **Trois files parallèles** : PRODUIT (§3), FONDATIONS (§4), CONTENU (§5). Elles ne se
   bloquent pas entre elles — une session prend **la première ligne non cochée de sa file**
   dont les dépendances sont satisfaites.
3. **Plus aucun arbitrage humain n'est en attente** (tous rendus le 2026-07-20, §2). Les
   entrées autrefois marquées ⚖️ portent désormais leur décision entre parenthèses.
4. Priorité inter-files en cas de choix : finir l'en-vol (§1) > PRODUIT > FONDATIONS >
   CONTENU nouveau (les corrections qualité contenu passent, elles, avant tout — P-4).

## 1. En vol aujourd'hui (à finir avant d'ouvrir autre chose)

- [x] **Étude 25 lot 2** (gate `harness:check` + rôles de modèles) : **mergé le 2026-07-20**
      (#530, porté par sa session d'origine ; les doublons de sauvetage #523/#529/#534 sont
      fermés).
- [x] **Session « resynchroniser l'index »** : é15/é17 passées `livrée` le 2026-07-20 (#536) ;
      l'**étude 23** — en-tête « brouillon » alors que ses lots 1-4 étaient mergés — est
      resynchronisée par la session d'arbitrages du 2026-07-20 (`en exécution`, lots 1-4 cochés,
      PRs #524/#527 inscrites au journal).
- [ ] **Reverdir `main`** : une session dédiée — préalable de confiance pour tout le reste.
      **État vérifié le 2026-07-20** : la CI **requise** est verte sur `main` (CI, CodeQL,
      Auto-merge) ; ce sont les suites **hors gate requis** qui sont rouges — `Nightly tests`
      (#250) échoue **tous les jours** (dernier run 2026-07-20 04:38, rouge au moins depuis le
      18/07) et `E2E (authenticated)` (#363, 12 échecs préexistants) n'a plus tourné vert sur
      `main` depuis le 2026-07-11.
      **Diagnostic du volet pgTAP de #250** (constaté le 2026-07-20 en lançant `db-tests.yml`
      sur une branche de lot) : ce sont **7 tests d'entitlements premium**, tous dormants depuis
      le pivot gratuit — `05_parcours_entitlements` (4, 6-7, 9, 11-12) et `08_quiz_gate` (5).
      Ils vérifient qu'un parcours premium sans grant est refusé, alors que
      `20260711100000_free_phase_all_parcours` a mis `is_premium = false` partout. Ce n'est pas
      une régression : ce sont des tests devenus faux par la décision produit. La session
      « reverdir » doit donc les **re-scoper** (fixtures qui posent explicitement leur premium),
      pas « réparer » du code. Le volet e2e (#363) reste, lui, à instruire.
      ⚠️ **Au passage** : `db-tests.yml` (pgTAP) ne tourne **pas** sur les PR — nightly et
      `workflow_dispatch` seulement. Toute PR portant une migration doit la dispatcher sur sa
      branche AVANT de promouvoir, sinon rien ne prouve qu'elle s'applique avant que le merge ne
      la pousse en prod.
- [x] ~~**Trancher les PRs legacy**~~ — **sans objet** : vérifié le 2026-07-20, #374 (français
      3ᵉ), #376 (transcription 2ᵉ sec) et #348 (transcriptions ScribeKit) sont **toutes les
      trois mergées** les 12-13/07. Le contenu « coffre-fort » qu'elles ont sauvé est sur `main` ;
      son exploitation relève du fil contenu (§5), pas d'un arbitrage.

## 2. Arbitrages — TOUS RENDUS le 2026-07-20

> Session de décision unique (Mohamed, 2026-07-20). **Aucun arbitrage n'est plus en attente** :
> toute ligne de ce fichier est exécutable dès qu'une session la prend. Le détail de chaque
> décision, avec sa conséquence sur les lots, vit dans le §7 (ou §8) de l'étude concernée —
> ce tableau n'en est que le sommaire.

| #   | Arbitrage                                                                                                                                | Décision rendue                                                                                                                                                                                                                                                                        |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A1  | **é26 Q-1…Q-5** (verticales & pipeline V1 · cible catalogue rentrée · gels 06/10/12 · propriétaire « correction riche » · signatures M4) | ✅ Pipeline V1 adopté **tel quel** · cible rentrée = **statu quo consolidé à la barre é18** (aucune classe vitrine), V1 prioritaire et contenu en parallèle · **gel des trois** (é06/é10/é12) · correction riche → **é04 phase A1.2** · M4 fermé à 3 capacités. é26 → `validée`        |
| A2  | **é24 — les 4 écarts du lot 3b** (volumétrie, critère d'inventaire, garde orpheline, ordre repair-revert)                                | ✅ Critère de **provenance** ratifié · les **17 migrations manuelles restent au public** (KPI + gate anti-fuite amendés pour les exclure nommément) · contrainte **reposée en migration de schéma publique** · **ordre inversé** + dégraissage remonté dans le lot 3b. **3b débloqué** |
| A3  | **é19 Q-1…Q-4**                                                                                                                          | ✅ SVG inline seul + une PR par lot · concours → matières spatiales → **STOP** sur le non spatial · **vérification intégrale**, un lot > ~40 figures est scindé, jamais échantillonné. é19 → `validée`, lot 1 exécutable                                                               |
| A4  | **é21 Q-1…Q-4** (verbatim/droits des manuels)                                                                                            | ✅ Verbatim toléré pour les **énoncés techniques courts non créatifs**, adaptation ailleurs (posture de risque, **pas un avis juridique**) · **provenance NON affichée à l'élève → lot 3 abandonné** · pilote `math-1ere-sec` · manipulations hors périmètre v1. é21 → `validée`       |
| A5  | **é11 Q-1…Q-9** (tuteur IA)                                                                                                              | ✅ Exécution **dégelée pour les lots 0-2**, pilote **math 9ᵉ** · énergie 10/j (plafond dur 30) · budget **5 $/j** (≤ 150 $/mois) · **le tuteur s'appelle « El Ostedh » (الأستاذ)**, sans mascotte · pas de verbatim parent · champ libre dès le collège · GO coordonné avec é04-A1.1   |
| A6  | ~~PRs legacy #374 / #376 / #348~~                                                                                                        | **Sans objet** — les trois sont mergées depuis les 12-13/07 (voir §1)                                                                                                                                                                                                                  |
| A7  | _(rendus antérieurement, pour mémoire)_ é23 Q-1/Q-2/Q-5 le 2026-07-19 (#531) ; é22 Q-1…Q-5 le 2026-07-18 ; é20 Q-1…Q-5 le 2026-07-16     | é23 lot 5, é22 lots 1-6, é20 lots 1-8 : **exécutables**                                                                                                                                                                                                                                |

**Ce qui reste à la main de Mohamed** (hors lots, sans blocage de file) : é23 Q-3 (self-désigner
l'app child-directed auprès de Google + paragraphe « vidéos YouTube » de la politique de
confidentialité — la page n'existe pas encore) · é24 Q-4 (démarche OTDAV/INNORPI) · F4 (domaine,
monitoring, sitemap) · F5 (légal avant rentrée).

## 3. FILE PRODUIT — la verticale V1 « apprendre & maîtriser » (ordre strict)

> Objectif : refermer les trois boucles mortes (SM-2, misconceptions, adaptativité) et porter
> la boucle d'apprentissage à M3 avant la rentrée. ~15-18 sessions-lots au total.

**Étape A — réparer le parcours (étude 22, validée — 6 lots prêts)**

- [x] 1. **é22 lot 1 — la carte honnête** (`/parcours` : plus de faux verrou séquentiel, états `next`/`done`)
- [x] 2. **é22 lot 2 — la boucle SM-2 refermée** (`submit_exercise_attempt` passe les révisions à `completed`)
- [ ] 3. **é22 lot 5 — le donjon scopé** au parcours (fallback cycle → catalogue, `pool_scope`)
- [ ] 4. **é22 lot 4 — cohorte « Ma classe »** (`get_grade_leaderboard` + onglet par défaut dès ≥ 10 classés)
- [ ] 5. **é22 lot 6 — « prochaine action » unifiée** (`resolveNextAction`) + purge des objectifs fantômes (`10_min`, `maintain_streak_5`)
- [ ] 6. **é22 lot 3 — la rentrée** (bannière 1ᵉʳ sept → 31 oct, `current_parcours_set_at`, bloc « Réviser ») — **à livrer avant mi-août**

**Étape B — la révision devient un produit (étude 04)**

- [ ] 7. **é04 lot A1.1 — « Révision du jour »** (RPC `get_daily_plan` + panneau dashboard, consomme SM-2 refermée en 2)
- [ ] 8. **amendement é04-A1.2 « correction riche à l'échec »** _(A1 rendu : rattachée à l'étude 04)_ (architecte : feedback in-session, lien « revoir le cours » par erreur, misconception affichée, explication post-erreur non monnayée) — puis :
- [ ] 9. **é04 lot A1.2 — exécution de la correction riche** (1-2 PRs)

**Étape C — le Rappel cesse de refuser des réponses justes (étude 20, validée)**

- [ ] 10. **é20 lot 1 — socle scoring ensembliste** (`accepted_answers` server-only + QA) — indépendant, peut s'intercaler dès maintenant
- [ ] 11. **é20 lot 7 — type natif `short_answer`** (moteur ; parallélisable avec l'étape D)

**Étape D — la maîtrise devient visible (étude 07 puis 04-A2)**

- [ ] 12. **é07 lot 2 — DB de maîtrise** (`user_competency_mastery` EWMA + oubli, trigger sur télémétrie)
- [ ] 13. **é07 lot 4 — panneau compétences** (« ce qui te bloque », RPCs map/blockers) — dépend de 12 + du tagging C4 (fil contenu)
- [ ] 14. **é07 lot 5 — plan compétence-aware** (`get_daily_plan` priorise par compétence) — dépend de 7 + 13
- [ ] 15. **é04 lot A2.1 — « Points faibles »** (misconceptions en langage élève + « S'entraîner »)
- [ ] 16. **é04 lot A2.2 — rapport parent enrichi** (3 points faibles majeurs + tendance)

**Étape E — l'étage IA (étude 11) — A5 rendu le 2026-07-20 : exécution dégelée pour les lots 0-2**

> ⚠️ **Tension à arbitrer par le calendrier, pas par une décision** : A5 dégèle é11, mais A1
> lui assigne le **rang 9** du pipeline V1. Les lots 0-1 ne seront donc à la rentrée que si une
> session s'y consacre **hors de la file PRODUIT** ; sinon la cible reste octobre (§7), sans
> impact sur la rentrée.

- [ ] 17. **é11 lot 0 — socle IA** (adaptateur unique, comptabilité `ai_usage_events`, quotas/énergie, kill-switch) — la **porte LLM unique** (é26 D-8)
- [ ] 18. **é11 lot 1 — explication personnalisée post-review** (la brique signature : ancrée sur l'item + distracteur + tag)
- [ ] 19. **é11 lots 2 → 7** dans l'ordre de l'étude (plan du jour · chat cadré · boucle de compréhension · exercices ciblés · bilans hebdo · énergie UI) — une PR par lot, cadence selon usage/coûts observés

## 4. FILE FONDATIONS (parallèle — ne bloque pas la file produit)

- [ ] F1. **é25 lots restants** (lots 1-2 livrés #519/#530 ; **lot 4 livré le 2026-07-20** — politique déclarative `harness/policy.json` + hook externalisé + invariant anti-dérive des vues générées). Reste, dans cet ordre : **L5** gardes CI portables + épinglage SHA + CODEOWNERS (Q-6) · **L6** mémoire multi-têtes (`docs/agents/`) · **L3** miroir skills `.agents/skills/` · **L7** drill de portabilité (**avec Mohamed**).
      ⚠️ **L3 est volontairement repoussé APRÈS [F2] é24 lot 3b** : créer un miroir des 45 skills dans le repo public dupliquerait l'actif que le « dégraissage public » d'é24 est justement en train d'en retirer. Le miroir se fera sur le périmètre de skills qui subsiste après la scission. (é25 §6 déclare L3/L4/L5/L6 indépendants — l'ordre « 3 → 7 » n'était qu'un raccourci d'écriture.)
- [ ] F2. **é24 lots 3b → 4 → 5 → 6** _(A2 rendu : 3b débloqué, dégraissage remonté dans 3b)_ (découplage SQL + dégraissage public + gate anti-fuite + purge d'historique + e2e TEST/régularisation) — **prérequis de la campagne lycée massive** (§5-C9)
- [ ] F3. **é09 lots 1-2 — la mesure** (page admin « Économie » + simulateur `economy:check`) — condition du KPI-4 é26 (« excellent » mesurable) ; lot 3 conditionnel ensuite
- [ ] F4. **C4 côté Mohamed (~45 min + suivi)** : câbler le domaine `na9ranal3ab.tn` · monitoring (UptimeRobot/Sentry/PostHog) · ruleset — puis soumettre le sitemap (débloque le SEO, 🟠 depuis juin)
- [ ] F5. **Légal avant rentrée** : GAP-003 (conformité mineurs INPDP) + GAP-024 (pages légales)
- [ ] F6. **Ops récurrent** : activer le triage hebdo des signalements (`/admin/content-reports`, `/admin/bug-reports`, skill `report-triage`) — le maillon manquant est opérationnel, pas technique
- [ ] F7. **Dépendances majeures** #233/#234/#236 : une PR par major via `upgrade-guard`, quand une fenêtre calme le permet

## 5. FIL CONTENU (parallèle — sessions de campagne dédiées)

> Règle é26 D-6 : la largeur _catalogue_ continue sous sa propre barre de qualité (é18 axe 5,
> gates, audits). **A1-Q2 rendu** : la cible de couverture pour la rentrée est le **statu quo
> consolidé à la barre é18** — aucune nouvelle classe « vitrine » sous cette barre.

- [ ] C1. **Corrections qualité ouvertes d'abord** (P-4) : `french-8eme` (2 BLOCKER #336/#337 + 6 MAJOR) · `math-bac-math` (#344)
- [ ] C2. **é23 lot 5 — campagne vidéos maths 9ᵉ** (débloquée : Q-1 arbitrée, skill `content-videos` + health-check livrés #527/#531) — puis extension aux autres matières concours au fil de l'eau
- [ ] C3. **é16 vague A — les 4 matières restantes de 1ère secondaire** (base fidèle au programme + overlay `prof-*-lycee` d3/d4 ; une matière = une session ; génération native fr, décision 2026-07-13)
- [ ] C4. **é07 lot 3 — tagging compétences vague 1** (questions math 9ᵉ + 6ᵉ, registre `content/competences/math.json`) — condition de l'étape D produit (ligne 13)
- [ ] C5. **é20 lots 2 → 4 — réponses acceptées** : Tier A morphologique déterministe (corpus entier) → skill Tier B + pilote petites classes ar → campagne (1 matière/PR, priorité petites classes → concours) ; puis lot 5 (saisie arabe) et lot 8 (pilote `short_answer`)
- [ ] C6. **Illustration — backlog é18 (ordre petites-classes-d'abord)** : 4ᵉ puis 5ᵉ année (toutes matières visuelles) → maths 7ᵉ (5 ch.) → maths 9ᵉ fonctions+stats (2) → iq-training (3) → français (1)
- [ ] C7. **é19 lot 1 — doctrine + gate figures questions** _(A3 rendu : SVG seul, vérification intégrale, lots ≤ ~40 figures)_,, puis campagne questions illustrées (concours d'abord : 6ᵉ/9ᵉ/bac)
- [ ] C8. **é21 lot 1 — doctrine manuels** _(A4 rendu : verbatim court non créatif toléré ; provenance NON affichée à l'élève, lot 3 abandonné)_, puis pilote `math-1ere-sec` (exercices tracés `manuel_ref`, rapport de couverture)
- [ ] C9. **Transcriptions secondaire (fil continu, METHODE-GENERATION-CONTENU)** : finir `math-2eme-sec-sciences` (12/19 ch. transcrits) · `3eme-sec-anglais` (wip) · suite du lycée — **la campagne de GÉNÉRATION lycée massive (2ᵉ sec+) attend é24 lots 4-6 (F2)** ; la vague A 1ère sec déjà entamée continue, elle, normalement

## 6. FILES DIFFÉRÉES (ne rien lancer avant leur porte d'entrée)

| File                                                             | Porte d'entrée                                                      | Contenu                                                                           |
| ---------------------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **V2 — concours**                                                | V1 ≥ M3 (étapes 1-16) **et** annales transcrites (`NN-annales-bac`) | é02 re-scopée (« examen blanc » sans wording premium), percentiles                |
| **V4 — parent**                                                  | é04-A2.2 livré (ligne 16)                                           | é08 re-scopée + digest hebdo IA (é11 lot 6 la sert aussi)                         |
| **Gels — actés (A1-Q3, 2026-07-20)** ; application par é26 lot 2 | Dégel par décision humaine explicite uniquement                     | é06 (PWA offline) · é10 (anti-fraude — se dégèle au volume) · é12 (studio in-app) |
| **Gelée (phase)**                                                | Sortie de la phase gratuite (décision humaine)                      | é01 (paiement en ligne — véhicule de réactivation du premium)                     |

## 7. Vue jalon — ce qui doit être vrai le 1ᵉʳ septembre 2026

| Axe        | Cible rentrée                                                                                                                                                                                                  |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Produit    | File V1 étapes **1-16** livrées (é22 complet dont bannière rentrée · Révision du jour · correction riche · Rappel tolérant lot 1 · maîtrise visible · points faibles + rapport parent)                         |
| IA         | A5 **rendu le 2026-07-20** : é11 dégelée (lots 0-2, pilote math 9ᵉ, budget 5 $/j, tuteur « El Ostedh »). Lots 0-1 à la rentrée **seulement si une session les prend hors file V1** — sinon octobre             |
| Contenu    | Classes existantes à la barre é18 · 1ère sec complète (5 matières) · vidéos 9ᵉ · Tier A `acceptedAnswers` corpus entier · cible arbitrée (A1-Q2) = **statu quo consolidé à la barre é18**, sans classe vitrine |
| Fondations | Domaine câblé + monitoring + sitemap (F4) · légal F5 · triage ops F6 en route · `main` verte (§1)                                                                                                              |

## 8. Journal de la roadmap

| Date       | Événement                                                                                                                                                                                                                                                                                                                                                                                            |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-07-20 | Création (déclinaison de l'étude 26, état consolidé post #525/#526/#527/#529/#531)                                                                                                                                                                                                                                                                                                                   |
| 2026-07-20 | **Session d'arbitrages — A1→A5 tous rendus** (Mohamed). é26, é19, é21, é11 → `validée` ; les 4 écarts de é24 tranchés (lot 3b débloqué) ; é23 resynchronisée en `en exécution`. **Corrections d'état** : A6 sans objet (PRs legacy mergées les 12-13/07), `main` — CI requise verte, `Nightly`/`E2E auth` rouges. Le tuteur IA est renommé **« El Ostedh »**. La roadmap devient officielle (A1-Q1). |

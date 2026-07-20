# ROADMAP — ordre d'exécution du reste-à-faire (études, lots, contenu)

> **Instantané du 2026-07-20** — déclinaison opérationnelle de l'**étude 26 (doctrine
> verticale : profondeur avant largeur)**. Tant que les Q-1…Q-5 de l'étude 26 ne sont pas
> arbitrées, cet ordre est la **recommandation de l'architecte** ; les entrées marquées **⚖️**
> exigent un arbitrage humain AVANT d'être lancées. Ce fichier est un instantané daté, à
> resynchroniser quand un lot est livré (cocher la case dans la même PR) — l'état de référence
> reste [STATUS.md](../STATUS.md) + l'[index des études](./README.md).
> **Jalon produit : rentrée scolaire, 1ᵉʳ septembre 2026** (§7).

## 0. Mode d'emploi (comment exécuter cette roadmap)

1. **Une ligne = une session = un lot = une PR** (règles FableEtudes inchangées : cadre fermé,
   DoD intégral, la session suit sa PR jusqu'au merge).
2. **Trois files parallèles** : PRODUIT (§3), FONDATIONS (§4), CONTENU (§5). Elles ne se
   bloquent pas entre elles — une session prend **la première ligne non cochée de sa file**
   dont les dépendances sont satisfaites.
3. **⚖️ = arbitrage humain requis avant de lancer la ligne.** Tous les arbitrages en attente
   sont consolidés en §2 — une seule session de décision suffit à tout débloquer.
4. Priorité inter-files en cas de choix : finir l'en-vol (§1) > PRODUIT > FONDATIONS >
   CONTENU nouveau (les corrections qualité contenu passent, elles, avant tout — P-4).

## 1. En vol aujourd'hui (à finir avant d'ouvrir autre chose)

- [x] **Étude 25 lot 2** (gate `harness:check` + rôles de modèles) : **mergé le 2026-07-20**
      (#530, porté par sa session d'origine ; les doublons de sauvetage #523/#529/#534 sont
      fermés).
- [ ] **Session « resynchroniser l'index (é15, é17) »** — lancée le 2026-07-20 (chip). À
      étendre ou compléter : l'**étude 23 est aussi désynchronisée** (en-tête « brouillon »
      alors que ses lots 1-4 sont mergés — #507/#510/#524/#527 — et Q-1/Q-2/Q-5 arbitrées
      le 2026-07-19, #531) ; l'étude 15 a ses 14 cases cochées (candidate « livrée »).
- [ ] **Reverdir `main`** : e2e-auth (#363, 12 échecs préexistants) + nightly (#250). Une
      session dédiée — c'est un préalable de confiance pour tout le reste.
- [ ] **Trancher les PRs legacy** (décision humaine ⚖️, §2-A6) : #374 (français 3ᵉ), #376
      (transcription 2ᵉ sec), #348 (transcriptions ScribeKit + commit local `busy-raman`).

## 2. Arbitrages à rendre (une session de décision — chaque item dit ce qu'il débloque)

| #   | Arbitrage                                                                                                                                | Débloque                                                                    |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| A1  | **é26 Q-1…Q-5** (verticales & pipeline V1 · cible catalogue rentrée · gels 06/10/12 · propriétaire « correction riche » · signatures M4) | Officialise cette roadmap ; é26 lots 1-2 ; l'amendement é04-A1.2 ; les gels |
| A2  | **é24 § 4.3 — les 4 écarts du lot 3b** (volumétrie 227/17/102, critère d'inventaire, garde orpheline, ordre repair-revert)               | é24 lots 3b → 4 → 5 → 6 (prérequis de la campagne lycée massive)            |
| A3  | **é19 Q-1…Q-4** (au minimum Q-1 — doctrine figures questions)                                                                            | é19 lot 1 (gate) puis campagne questions illustrées                         |
| A4  | **é21 Q-1** (verbatim/droits des manuels) — Q-2…Q-4 peuvent suivre                                                                       | é21 lot 1 (doctrine manuels) puis pilote `math-1ere-sec`                    |
| A5  | **é11 Q-1…Q-9** (tuteur IA — périmètre pilote, budget, modèles…)                                                                         | é11 lot 0 puis 1-7. À rendre **début août** pour viser la rentrée (§7)      |
| A6  | **PRs legacy** #374 / #376 / #348 : relire-merger ou fermer                                                                              | Nettoie §1 ; récupère (ou clôt) du contenu déjà produit                     |
| A7  | _(déjà rendus, pour mémoire)_ é23 Q-1/Q-2/Q-5 le 2026-07-19 (#531) ; é22 Q-1…Q-5 le 2026-07-18 ; é20 Q-1…Q-5 le 2026-07-16               | é23 lot 5, é22 lots 1-6, é20 lots 1-8 : **déjà exécutables**                |

## 3. FILE PRODUIT — la verticale V1 « apprendre & maîtriser » (ordre strict)

> Objectif : refermer les trois boucles mortes (SM-2, misconceptions, adaptativité) et porter
> la boucle d'apprentissage à M3 avant la rentrée. ~15-18 sessions-lots au total.

**Étape A — réparer le parcours (étude 22, validée — 6 lots prêts)**

- [ ] 1. **é22 lot 1 — la carte honnête** (`/parcours` : plus de faux verrou séquentiel, états `next`/`done`)
- [ ] 2. **é22 lot 2 — la boucle SM-2 refermée** (`submit_exercise_attempt` passe les révisions à `completed`)
- [ ] 3. **é22 lot 5 — le donjon scopé** au parcours (fallback cycle → catalogue, `pool_scope`)
- [ ] 4. **é22 lot 4 — cohorte « Ma classe »** (`get_grade_leaderboard` + onglet par défaut dès ≥ 10 classés)
- [ ] 5. **é22 lot 6 — « prochaine action » unifiée** (`resolveNextAction`) + purge des objectifs fantômes (`10_min`, `maintain_streak_5`)
- [ ] 6. **é22 lot 3 — la rentrée** (bannière 1ᵉʳ sept → 31 oct, `current_parcours_set_at`, bloc « Réviser ») — **à livrer avant mi-août**

**Étape B — la révision devient un produit (étude 04)**

- [ ] 7. **é04 lot A1.1 — « Révision du jour »** (RPC `get_daily_plan` + panneau dashboard, consomme SM-2 refermée en 2)
- [ ] 8. ⚖️(A1) **amendement é04-A1.2 « correction riche à l'échec »** (architecte : feedback in-session, lien « revoir le cours » par erreur, misconception affichée, explication post-erreur non monnayée) — puis :
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

**Étape E — l'étage IA (étude 11) — ⚖️(A5) puis :**

- [ ] 17. **é11 lot 0 — socle IA** (adaptateur unique, comptabilité `ai_usage_events`, quotas/énergie, kill-switch) — la **porte LLM unique** (é26 D-8)
- [ ] 18. **é11 lot 1 — explication personnalisée post-review** (la brique signature : ancrée sur l'item + distracteur + tag)
- [ ] 19. **é11 lots 2 → 7** dans l'ordre de l'étude (plan du jour · chat cadré · boucle de compréhension · exercices ciblés · bilans hebdo · énergie UI) — une PR par lot, cadence selon usage/coûts observés

## 4. FILE FONDATIONS (parallèle — ne bloque pas la file produit)

- [ ] F1. **é25 lots 3 → 7** dans l'ordre (lot 2 livré, #530) : miroir skills `.agents/skills/` · politique déclarative + hook externalisé · gardes CI portables + épinglage SHA · mémoire multi-têtes · drill de portabilité (lot 7 **avec Mohamed**)
- [ ] F2. ⚖️(A2) **é24 lots 3b → 4 → 5 → 6** (découplage SQL + dégraissage public + gate anti-fuite + purge d'historique + e2e TEST/régularisation) — **prérequis de la campagne lycée massive** (§5-C9)
- [ ] F3. **é09 lots 1-2 — la mesure** (page admin « Économie » + simulateur `economy:check`) — condition du KPI-4 é26 (« excellent » mesurable) ; lot 3 conditionnel ensuite
- [ ] F4. **C4 côté Mohamed (~45 min + suivi)** : câbler le domaine `na9ranal3ab.tn` · monitoring (UptimeRobot/Sentry/PostHog) · ruleset — puis soumettre le sitemap (débloque le SEO, 🟠 depuis juin)
- [ ] F5. **Légal avant rentrée** : GAP-003 (conformité mineurs INPDP) + GAP-024 (pages légales)
- [ ] F6. **Ops récurrent** : activer le triage hebdo des signalements (`/admin/content-reports`, `/admin/bug-reports`, skill `report-triage`) — le maillon manquant est opérationnel, pas technique
- [ ] F7. **Dépendances majeures** #233/#234/#236 : une PR par major via `upgrade-guard`, quand une fenêtre calme le permet

## 5. FIL CONTENU (parallèle — sessions de campagne dédiées)

> Règle é26 D-6 : la largeur _catalogue_ continue sous sa propre barre de qualité (é18 axe 5,
> gates, audits). ⚖️(A1-Q2) fixe la cible de couverture pour la rentrée.

- [ ] C1. **Corrections qualité ouvertes d'abord** (P-4) : `french-8eme` (2 BLOCKER #336/#337 + 6 MAJOR) · `math-bac-math` (#344)
- [ ] C2. **é23 lot 5 — campagne vidéos maths 9ᵉ** (débloquée : Q-1 arbitrée, skill `content-videos` + health-check livrés #527/#531) — puis extension aux autres matières concours au fil de l'eau
- [ ] C3. **é16 vague A — les 4 matières restantes de 1ère secondaire** (base fidèle au programme + overlay `prof-*-lycee` d3/d4 ; une matière = une session ; génération native fr, décision 2026-07-13)
- [ ] C4. **é07 lot 3 — tagging compétences vague 1** (questions math 9ᵉ + 6ᵉ, registre `content/competences/math.json`) — condition de l'étape D produit (ligne 13)
- [ ] C5. **é20 lots 2 → 4 — réponses acceptées** : Tier A morphologique déterministe (corpus entier) → skill Tier B + pilote petites classes ar → campagne (1 matière/PR, priorité petites classes → concours) ; puis lot 5 (saisie arabe) et lot 8 (pilote `short_answer`)
- [ ] C6. **Illustration — backlog é18 (ordre petites-classes-d'abord)** : 4ᵉ puis 5ᵉ année (toutes matières visuelles) → maths 7ᵉ (5 ch.) → maths 9ᵉ fonctions+stats (2) → iq-training (3) → français (1)
- [ ] C7. ⚖️(A3) **é19 lot 1 — doctrine + gate figures questions**, puis campagne questions illustrées (concours d'abord : 6ᵉ/9ᵉ/bac)
- [ ] C8. ⚖️(A4) **é21 lot 1 — doctrine manuels**, puis pilote `math-1ere-sec` (exercices tracés `manuel_ref`, rapport de couverture)
- [ ] C9. **Transcriptions secondaire (fil continu, METHODE-GENERATION-CONTENU)** : finir `math-2eme-sec-sciences` (12/19 ch. transcrits) · `3eme-sec-anglais` (wip) · suite du lycée — **la campagne de GÉNÉRATION lycée massive (2ᵉ sec+) attend é24 lots 4-6 (F2)** ; la vague A 1ère sec déjà entamée continue, elle, normalement

## 6. FILES DIFFÉRÉES (ne rien lancer avant leur porte d'entrée)

| File               | Porte d'entrée                                                      | Contenu                                                                           |
| ------------------ | ------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **V2 — concours**  | V1 ≥ M3 (étapes 1-16) **et** annales transcrites (`NN-annales-bac`) | é02 re-scopée (« examen blanc » sans wording premium), percentiles                |
| **V4 — parent**    | é04-A2.2 livré (ligne 16)                                           | é08 re-scopée + digest hebdo IA (é11 lot 6 la sert aussi)                         |
| **Gels ⚖️(A1-Q3)** | Décision humaine explicite uniquement                               | é06 (PWA offline) · é10 (anti-fraude — se dégèle au volume) · é12 (studio in-app) |
| **Gelée (phase)**  | Sortie de la phase gratuite (décision humaine)                      | é01 (paiement en ligne — véhicule de réactivation du premium)                     |

## 7. Vue jalon — ce qui doit être vrai le 1ᵉʳ septembre 2026

| Axe        | Cible rentrée                                                                                                                                                                          |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Produit    | File V1 étapes **1-16** livrées (é22 complet dont bannière rentrée · Révision du jour · correction riche · Rappel tolérant lot 1 · maîtrise visible · points faibles + rapport parent) |
| IA         | é11 lots 0-1 si A5 rendu début août (sinon cible octobre, sans impact rentrée)                                                                                                         |
| Contenu    | Classes existantes à la barre é18 · 1ère sec complète (5 matières) · vidéos 9ᵉ · Tier A `acceptedAnswers` corpus entier · cible exacte = ⚖️(A1-Q2)                                     |
| Fondations | Domaine câblé + monitoring + sitemap (F4) · légal F5 · triage ops F6 en route · `main` verte (§1)                                                                                      |

## 8. Journal de la roadmap

| Date       | Événement                                                                          |
| ---------- | ---------------------------------------------------------------------------------- |
| 2026-07-20 | Création (déclinaison de l'étude 26, état consolidé post #525/#526/#527/#529/#531) |

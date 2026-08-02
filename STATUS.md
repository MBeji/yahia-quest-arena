# STATUS — état du projet (topo central)

> **Instantané daté du 2026-08-02** (`main` à #703 ; exécution V1 « Apprendre & maîtriser » de
> la doctrine verticale, é26). Ce fichier est le **point d'entrée unique** pour savoir où en est
> le projet : phase produit, décisions qui gouvernent, état réel des features, études,
> chantiers, travaux en vol. Il complète — sans les dupliquer — les documents normatifs :
> [AGENTS.md](./AGENTS.md) (conventions, gagne en cas de conflit — CLAUDE.md est un pointeur
> Claude Code vers ce fichier), [ARCHITECTURE.md](./ARCHITECTURE.md), l'index des études
> (`FableEtudes/README.md`) et le programme go-live (`FableEtudes/go-live/`) — ces deux derniers
> dans le **dépôt privé** `MBeji/yahia-quest-content`.
>
> **Règles de maintenance** : (1) toute session qui livre un jalon structurant met à jour ce
> fichier (comme le master plan go-live) ; (2) en cas de doute sur l'état d'une feature, le
> code et les migrations font foi, pas ce fichier ; (3) les décisions se **journalisent** dans
> [`docs/journal-decisions.md`](./docs/journal-decisions.md) (append-only), elles ne se
> réécrivent pas — §2 ne garde que celles qui gouvernent encore.
>
> **Ce fichier pesait 176 KB au 2026-08-02** — il en fait 40. Le journal des décisions et le
> détail des lots d'études en occupaient les trois quarts, et il annonçait `main` à #641 quand
> elle était à #703. Un topo se lit d'un coup d'œil ou n'en est pas un : **ne pas y recopier ce
> qui a déjà un fichier** (les lots vivent dans la ROADMAP privée, les décisions dans le
> journal, la dette dans `docs/dette-technique.md`).

---

## 1. Identité & phase actuelle

|                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Produit / marque** | **Na9ra Nal3ab** — académie d'apprentissage gamifiée, programme scolaire tunisien (13 niveaux + lycée en ouverture) + pistes libres (culture G, muscle-cerveau, langues)                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **Repo**             | `yahia-quest-arena` — le **moteur**, public. Le corpus, les études et le programme go-live sont dans `MBeji/yahia-quest-content` (privé) ; le moteur de transcription dans `MBeji/ScribeKit`. Le dossier parent `YahiaAcademy/` reste un wrapper hors git : sources CNP, outils portables, prompts de campagne                                                                                                                                                                                                                                                                                                                               |
| **Prod**             | **`https://www.na9ranal3ab.tn`** — **seul hôte qui répond 200** : l'apex y redirige en 308, `na9ranal3ab.vercel.app` en 301 (constat 2026-07-20, resondé 2026-07-27). Push sur `main` = déploiement + auto-application des migrations. Domaine **câblé**, propriété Search Console **vérifiée**, `sitemap.xml` joignable. ⚠️ Deux pièges pour qui sonde la prod : sans `-L` on lit la redirection et on conclut à une panne ; sur une page HTML il faut **aussi** un User-Agent non bloqué (le bot guard refuse `curl/` en 403 — la sonde `/api/health`, elle, passe avant le guard). Arbitrage SEO ouvert en §8 (`SITE_URL` déclare l'apex) |
| **Phase**            | **Bêta publique 100 % gratuite** — contenu consultable et praticable **sans compte** ; aucun paiement, aucun premium actif. L'infrastructure premium (entitlements, paywall, gate) existe mais est **dormante et réversible** (voir §2 et l'étude 01, gelée)                                                                                                                                                                                                                                                                                                                                                                                 |
| **Jalon visé**       | Rentrée scolaire sept. 2026 (« Porte 1 » du go-live)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

---

## 2. Décisions structurantes

> **Le journal complet est sorti d'ici le 2026-08-02.** Les 34 entrées datées du 2026-06-13 au
> 2026-07-31 vivent dans [`docs/journal-decisions.md`](./docs/journal-decisions.md), toujours
> **append-only**, rien n'a été retiré au passage. Elles pesaient 120 KB des 176 de ce fichier :
> un topo qu'on ne peut plus parcourir d'un coup d'œil a cessé d'être un topo.
>
> **Où écrire** : une nouvelle décision va dans le journal ; si elle change l'état courant
> (phase, feature, étude, chantier), elle met **aussi** à jour la section concernée d'ici.
> Ci-dessous : seulement ce qui gouverne encore le travail d'aujourd'hui.

| Décision                                                 | Depuis                  | Ce qu'elle impose au quotidien                                                                                                                                                                                                                                                                        |
| -------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Gratuité de phase**                                    | 2026-06-21              | Tout parcours a `is_premium = false`, aucune mission n'est gatée, et **aucune surface visible ne dit « premium / abonnement / payant »**. La machinerie (entitlements, paywall, `resolve_exercise_access`) reste en place mais **dormante** ; son véhicule de dégel est l'étude 01, gelée.            |
| **Doctrine verticale — profondeur avant largeur**        | 2026-07-20 (é26)        | On approfondit avant d'ouvrir. La verticale **V1 « Apprendre & maîtriser »** passe avant l'expansion du catalogue ; é06 (PWA), é10 (anti-fraude) et é12 (studio d'ingestion) sont **gelées** par arbitrage réversible.                                                                                |
| **Le corpus n'est plus ici**                             | 2026-07-20 (é24)        | `content/`, les 41 skills pédagogiques et `FableEtudes/` vivent dans `MBeji/yahia-quest-content` (privé). Ce dépôt garde le **moteur**. `npm run leak:check` fait échouer le gate si du corpus réapparaît au tip. Le contenu ne voyage **plus en migrations** — il se compile en `sql/content/*.sql`. |
| **`AGENTS.md` est canonique, le harness est déclaratif** | 2026-07-19 (é25)        | En cas de conflit entre docs, `AGENTS.md` gagne — on corrige l'autre. `CLAUDE.md` et les fichiers par outil sont des **pointeurs**, jamais des copies de règles. `harness/policy.json` est la source ; les vues par outil sont générées (`harness:sync`) et `harness:check` échoue sur dérive.        |
| **La prod est live, la chaîne est automatique**          | 2026-06-22 → 2026-07-27 | Push sur `main` = déploiement Vercel + **auto-application des migrations**. Personne ne lit, ne ready ni ne merge une PR à la main : la session qui pousse reste de garde jusqu'au merge réel. Jamais de `supabase db push` sur la prod.                                                              |
| **Le français du lycée est natif, pas traduit**          | 2026-07-13              | Les matières francophones du lycée sont écrites directement en français, dans le jargon des manuels officiels — aucun pont fr↔ar.                                                                                                                                                                     |
| **R-5 se lit au chapitre, pas à la fiche**               | 2026-07-29              | Une fiche de programme `partielle` ne bloque plus toute la matière : on génère chapitre par chapitre, sur les sections réellement transcrites à profondeur de génération.                                                                                                                             |
| **Sonder, pas déduire**                                  | 2026-07-27              | L'état d'une action qui se joue **hors du repo** (DNS, secret, console tierce) se vérifie de l'extérieur avant d'être écrit. « Pas écrit fait » ne vaut pas « pas fait » — quatre « à faire » l'étaient depuis des semaines.                                                                          |

## 3. État réel des features (vérifié code + migrations, 2026-07-11 ; §§ features moteur/compétences/progression revues le 2026-07-21)

**Légende** : 🟢 LIVE (en prod, fonctionnel) · 🟠 PARTIEL · 💤 DORMANT (code intact, inerte par la donnée/la phase) · ⬜ ABSENT (étude seulement).

| Feature                                                                              | État | Preuve / note                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------------------------------------------------------------------------ | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Boucle quête (QCM, XP, badges, streaks, boutique, consommables)                      | 🟢   | cœur historique ; `submit_exercise_attempt`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Types de questions natifs (numeric, ordering, matching, multi)                       | 🟢   | étude 03 livrée (12 lots, PRs #295→#307)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Donjon (boss mode)                                                                   | 🟢   | **plus un avantage premium** : verrous restants = progression (PREREQ/LEVEL/DAILY_LIMIT)                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Duels temps réel & ligues hebdo                                                      | 🟢   | étude 05 livrée (5 lots, PRs #313→#323) ; pg_cron `expire-duels` + `award-duel-league-week` ; Realtime + fallback polling                                                                                                                                                                                                                                                                                                                                                                                                         |
| Navigation « Arène » (Donjon·Duels·Classement) + coquille parent                     | 🟢   | étude 15 lot 5 (PR #368, route `/arene`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Plateforme publique sans login (catalogue → cours → pratique corrigée)               | 🟢   | pivot C8 (PR #180/#181), trilingue fr/en/ar                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Suivi parent (lien famille + **rapport public par code alliance**)                   | 🟢   | PR #335                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Signalement d'erreur de contenu (`content_reports`)                                  | 🟢   | bouton élève monté (fin de quête) + console `/admin/content-reports` + skill `report-triage`. **Le maillon manquant est opérationnel, pas technique** : le triage hebdo prévu (go-live E3) n'a jamais démarré ; améliorable : signalement au niveau question (aujourd'hui exercice)                                                                                                                                                                                                                                               |
| Signalement de bug (`bug_reports`)                                                   | 🟢   | lanceur global + `/admin/bug-reports`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Notifications push                                                                   | 🟢   | service worker + souscriptions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| SEO (sitemap dynamique, robots.txt, meta)                                            | 🟢   | code livré (PRs #201/#202/#205) ; le domaine est câblé, `sitemap.xml` répond 200 à Googlebot et la propriété Search Console est vérifiée (TXT sur l'apex) — constat 2026-07-27. L'indexation réelle se lit dans Search Console, pas ici                                                                                                                                                                                                                                                                                           |
| Moteur adaptatif — télémétrie A0 + « Révision du jour » (A1.1)                       | 🟠   | étude 04 : A0 livré ; **A1.1 « Révision du jour » livrée et surfacée** (dashboard `DailyReviewPanel`, RPC `get_daily_plan`, ≤ 3 items triés SM-2 + priorité misconceptions ; PR #581, 2026-07-20). **Reste dormant** : la difficulté adaptative (`difficulty_adaptation`, lue par aucun sélecteur) ; pas de vue « Points faibles » dédiée (seul le flag « point faible repéré » sur une carte de révision). La **« correction riche à l'échec »** est rattachée en nouvelle phase **A1.2** (arbitrage 2026-07-20, étude 26)       |
| PWA / offline                                                                        | 🟠   | socle seulement : manifest + SW (cache assets, page offline, push). **Pas de lecture offline du contenu** (cible étude 06, brouillon — **gel décidé le 2026-07-20** par l'étude 26, application en attente de son lot 2)                                                                                                                                                                                                                                                                                                          |
| Gate premium (`resolve_exercise_access`, entitlements, family pack)                  | 💤   | code vivant mais **inerte** : `is_premium=false` sur ~35 parcours. Réactivation = `UPDATE` inverse (étude 01)                                                                                                                                                                                                                                                                                                                                                                                                                     |
| Paywall quête + formulaire beta-access utilisateur                                   | 💤   | `SubscriptionPaywall` câblé mais indéclenchable en phase gratuite                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Consoles admin (entitlements, beta, content-reports, bug-reports, parcours-interest) | 🟢   | 5 routes `/admin/*`, gardées `is_admin`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| Examen blanc / simulation concours                                                   | ⬜   | étude 02 (brouillon) ; seul un placeholder `'exam'` existe dans un CHECK                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Knowledge graph / compétences                                                        | 🟢   | étude 07 **en exécution** : lot 1 graphe de compétences seedé (#366), lot 2 maîtrise EWMA + oubli entretenue à l'écriture (`user_competency_mastery`, trigger-only, #579), lot 4 carte « ce qui te bloque » + « s'entraîner » sur le dashboard (#588), **lot 5 le 2026-07-25 : « Révision du jour » priorise par compétence faible** (#616). Maîtrise 0-100 par (élève, compétence). Reste le lot 3 (tagging du corpus, chantier contenu au privé) — sans lui la priorisation du lot 5 est inerte par construction, jamais fausse |
| Parcours élève & progression (carte honnête, cohorte « Ma classe », rentrée)         | 🟢   | étude 22 **livrée le 2026-07-21** (6 lots) : carte sans faux verrou (chapitre ✓ / mission ⭐), donjon scopé au parcours (fallback cycle → catalogue), classement « Ma classe » par niveau, « prochaine action » unifiée (révision → retry → continuer → découvrir), bannière de rentrée (promotion proposée, jamais imposée) ; boucle SM-2 refermée à la réussite                                                                                                                                                                 |
| Réponses acceptées / saisie libre native (`short_answer`)                            | 🟠   | étude 20 : **lot 1 (socle) livré le 2026-07-21** — `questions.accepted_answers` server-only + `is_accepted_free_answer` (juge unique du verdict), parité de normalisation TS↔SQL. **Pas encore surfacé** : corpus `acceptedAnswers` à remplir, type `short_answer` à câbler côté auteur (lots suivants)                                                                                                                                                                                                                           |
| Rappel actif (rejouer les QCM maîtrisés en saisie libre, XP ×1,5)                    | 🟢   | étude 17 livrée (5 lots, PRs #412/#414/#416/#427 + docs/e2e) ; unlock 100 % non-rushé, chip hub 3 états, saisie libre normalisée server-side (R-4), best score scindé par variante, misconception typée. 67 % des questions / 76 % des exercices éligibles                                                                                                                                                                                                                                                                        |
| Paiement en ligne                                                                    | ⬜   | étude 01 **gelée** (phase gratuite) — c'est le futur véhicule de réactivation du premium                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Tuteur IA « El Ostedh »                                                              | ⬜   | étude 11 **validée le 2026-07-20** (v2 du 2026-07-17, Q-1…Q-9 arbitrées) : accompagnement personnalisé piloté par l'IA — profil d'apprentissage, explications adaptées, plan de révision, chat cadré, exercices ciblés, bilans ; **exécution dégelée pour les lots 0-2**, pilote **math 9ᵉ** (`TUTOR_ENABLED` global, entrée UI limitée au pilote), énergie 10/jour (plafond dur 30/jour), budget plateforme **5 $/jour** (≤ 150 $/mois) ; **ne dépend plus de l'étude 01**                                                       |

---

## 4. Études (FableEtudes) — instantané

> **Ce tableau donne l'ÉTAT, pas le « comment ».** La source de vérité est l'index
> `FableEtudes/README.md` + l'en-tête de chaque `ETUDE.md`, et l'ordre d'exécution est
> `FableEtudes/ROADMAP.md` — tous **dans le dépôt privé `MBeji/yahia-quest-content`** depuis
> l'étude 24. Les citations `FableEtudes/…` d'ici y renvoient, elles ne sont pas cliquables.
> **Ne pas recopier le détail des lots ici** : c'est ce qui a fait diverger ce fichier de la
> réalité (constat du 2026-08-02 — il annonçait `main` à #641 quand elle était à #703).

| État               | Études                                                                                                                                                                                                                                                                            |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Livrées**        | **03** types de questions natifs · **05** duels & ligues · **13** moteur de transcription (**ScribeKit**, dépôt autonome) · **14** refonte UX/design · **15** contenu & composition des écrans · **17** rappel actif · **18** cours vivants · **22** parcours élève & progression |
| **Scission faite** | **24** protection IP du contenu — le corpus, les 41 skills pédagogiques et `FableEtudes/` sont partis au privé ; le gate anti-fuite tient l'invariant                                                                                                                             |
| **En exécution**   | **04** moteur adaptatif (jusqu'au lot A1.2b, #695) · **07** knowledge graph / compétences · **09** économie du jeu (lot 1 : console admin, #703) · **16** ouverture lycée · **20** réponses acceptées · **23** vidéos explicatives · **25** harness AI-native & model-agnostic    |
| **Validées**       | **11** tuteur IA « El Ostedh » (exécution dégelée pour les lots 0-2) · **19** questions & exercices illustrés · **21** valorisation des manuels officiels · **26** doctrine verticale                                                                                             |
| **Brouillons**     | **02** examen blanc\* · **08** analytics familles\*                                                                                                                                                                                                                               |
| **Gelées**         | **01** paiement en ligne (pivot gratuité — véhicule de dégel du premium) · **06** PWA offline, **10** anti-fraude, **12** studio d'ingestion (doctrine verticale é26, réversible ; 10 se dégèle au volume réel de V3)                                                             |

\* 02 et 08 gardent une justification rédigée « premium », à re-scoper au moment de leur validation.

**Deux backlogs d'illustration, à ne pas confondre** : l'étude **18** illustre les **cours**
(`cours.md` / `resume.md`), l'étude **19** illustre les **questions & exercices**. Leurs
campagnes — quelles classes, dans quel ordre, à quel reste-à-faire — sont suivies dans la
**ROADMAP privée** (§5 fil contenu), pas ici : c'est un backlog de contenu, il vit avec le corpus.

---

## 5. Programme go-live

> **Le programme a déménagé le 2026-08-02.** Il vivait dans le wrapper `../go-live/`, **hors de
> tout dépôt git** ; il est désormais dans le dépôt **privé** `MBeji/yahia-quest-content`, sous
> **`FableEtudes/go-live/`** — même nature de travail que les études, donc même endroit, même
> revue, même historique. Entrée : `FableEtudes/go-live/README.md`.

État au 2026-08-02 :

- **Clos** : C1 (audit fonctionnel) · C2 (audit technique, radar 3,31/4) · C3 (cybersécurité,
  0 P0) · C5 (marketing — volet premium caduc, réorienté SEO) · C7 (gouvernance, Go/No-Go à
  2 portes) · C4 (architecture prod, **soldé côté infrastructure le 2026-07-27**).
- **Supersédé** : C6 (modèle économique) — remplacé par le pivot gratuit du 2026-06-21 ;
  conservé comme archive de dégel pour l'étude 01.
- **Live** : C8 (plateforme publique) — MVP en prod depuis le 2026-06-22, SEO livré, domaine
  joignable. Reste le post-MVP L3 (enseignant) et le revert de l'override bêta avant tout
  retour du premium.
- **Backlog 90** : **34 ouverts / 20 soldés** sur 54 émis · **0 P0** · **3 P1**.

**Ce qui bloque encore la Porte 1 n'est plus technique** : GAP-003 (conformité mineurs /
INPDP), GAP-024 (**droits des personnes — à moitié fait** : les pages légales sont livrées
par #701, la suppression de compte et l'export de données n'existent pas) et le test à blanc
de `rollback-prod.yml`, dont les secrets n'ont été posés que le 2026-07-27.

---

## 6. Travaux en vol

**Au 2026-08-02 : rien en vol.** Vérifié sur les deux dépôts — **aucune PR ouverte** ni ici ni
au privé, arbre propre, `main` à **#703**.

**Issues ouvertes (3 ici, 1 au privé)** :

| Issue            | Quoi                                                                                                                                                                             |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **#673** (arena) | Triage des signalements du 2026-07-29. ⚠️ **Ne pas la fermer sans traiter la file** : ses UUID canoniques tiennent les signalements hors du chemin « fresh reports » du pré-gate |
| **#660** (arena) | Major `typescript` v7.0.2 — gate rouge, `typescript-eslint` bloquant (remplace #593)                                                                                             |
| **#595** (arena) | Aligner `@types/node` (v26) sur le runtime CI (Node 24)                                                                                                                          |
| **#81** (privé)  | Garde d'audit de contenu en panne                                                                                                                                                |

**Soldé** — pour couper court à la relecture des vieilles alertes de ce fichier : les PRs de
sauvetage #374 / #376 et les transcriptions #348 sont **mergées** depuis les 12-13/07 ; #366
(étude 07 lot 1) est résolu depuis le 2026-07-21 ; les 9 issues de contenu, #363 (e2e-auth),
#250 (nightly), #614, #574 et #293 sont **closes**. L'inventaire de la passe du 2026-07-11
(checkout sale, ~150 branches, WIP non commités) est entièrement traité — son détail est au
[journal](./docs/journal-decisions.md), il n'a plus à occuper le topo.

---

## 7. Carte de la documentation (qui fait foi pour quoi)

| Document                                                                             | Rôle                                                                                                                        | Statut                           |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| [AGENTS.md](./AGENTS.md)                                                             | **Canonique** : commandes, conventions, DoD, gotchas. Gagne sur tout autre doc — lu nativement par la plupart des outils IA | vivant                           |
| [CLAUDE.md](./CLAUDE.md)                                                             | Pointeur Claude Code (`@AGENTS.md`) + machinerie propre à cet outil                                                         | vivant                           |
| [ARCHITECTURE.md](./ARCHITECTURE.md)                                                 | Compagnon architecture (stack, flux, modèle de données)                                                                     | vivant                           |
| **STATUS.md** (ce fichier)                                                           | Topo central : phase, décisions qui gouvernent, état features/études/chantiers                                              | vivant, daté                     |
| [docs/journal-decisions.md](./docs/journal-decisions.md)                             | **Mémoire** : les 34 décisions structurantes datées, append-only (sorties d'ici le 2026-08-02)                              | vivant                           |
| [docs/dette-technique.md](./docs/dette-technique.md)                                 | La dette de code encore ouverte, chaque ligne re-lue dans le code avant d'être inscrite                                     | vivant (2026-08-02)              |
| [docs/](./docs)                                                                      | Specs normatives, guides joueur et runbooks par sujet (liste dans AGENTS.md)                                                | vivant                           |
| [docs/archive/](./docs/archive/README.md)                                            | Audits one-shot datés et dépassés — historique, jamais un backlog                                                           | archive                          |
| [docs/content-generation-pipeline.md](./docs/content-generation-pipeline.md)         | Spec du pipeline de contenu (FR) — le moteur est ici, le corpus au privé                                                    | vivant                           |
| [docs/agents/](./docs/agents/README.md)                                              | Playbooks d'exploitation : poste Windows, collaboration multi-agents, campagnes de contenu, gardes                          | vivant                           |
| [docs/agents/etude-ia-vs-deterministe.md](./docs/agents/etude-ia-vs-deterministe.md) | Étude d'outillage : remplacer les surfaces agent mécaniques par des scripts déterministes — **publique** (harness)          | **close** (6/6 lots, 2026-07-25) |
| [docs/guide-utilisateur.html](./docs/guide-utilisateur.html)                         | Guide utilisateur illustré (features, parcours, conditions de passage)                                                      | vivant (2026-07-21)              |
| [e2e/README.md](./e2e/README.md)                                                     | Runbook Playwright (projet TEST dédié)                                                                                      | vivant                           |
| `FableEtudes/` (dépôt **privé**)                                                     | Études d'architecture (contrats architecte → exécuteur) + `ROADMAP.md` — parties au privé avec le corpus (é24)              | vivant, hors ce dépôt            |
| `FableEtudes/go-live/` (dépôt **privé**)                                             | Programme POC → production : master plan, backlog GAP-NNN, actions humaines, passation, journal                             | vivant, hors ce dépôt            |
| `MBeji/ScribeKit` (dépôt **autonome**)                                               | Moteur de transcription (étude 13)                                                                                          | vivant, hors ce dépôt            |

---

## 8. Prochaines actions

> **L'ordre fait foi dans la ROADMAP privée** (`FableEtudes/ROADMAP.md`, 3 files déclinées de
> l'étude 26). Ce qui suit en est le sommet, pas une seconde liste.

**Fil directeur — poursuivre V1 « Apprendre & maîtriser »** (pipeline é26). Livrés depuis :
é22, é04-A1.1, é04-A1.2a/b, é07 lots 1/2/4, é20 lots 1/2/3/5/7, é09 lot 1. **Prochaines
briques** : é07 lot 3, é23 lot 5 (pilote vidéos maths 9ᵉ), campagnes d'illustration é19 / é21,
é11 lots 0-2 (tuteur « El Ostedh », pilote math 9ᵉ).

**Ce qui attend un humain** (aucun agent ne peut le faire à sa place) :

1. **Conformité mineurs (GAP-003)** et **droits des personnes (GAP-024, à moitié)** — les deux
   prérequis légaux du lancement, quel que soit le modèle gratuit.
2. **Trancher le canonique SEO** : l'hôte servi en 200 est `www`, mais
   [`SITE_URL`](./src/shared/lib/sitemap.ts) déclare l'apex **sans `www`** — chaque `<loc>` du
   sitemap pointe donc vers une redirection. Choisir l'un des deux et s'y tenir.
3. **Jouer le test à blanc de `rollback-prod.yml`** (`freeze-only` puis `unfreeze`).
4. **Démarrer le rituel de triage** hebdomadaire des signalements (`/admin/content-reports` +
   `/admin/bug-reports`, skill `report-triage`).

> **▶ Reprise pour une session vierge** — `main` à **#703** au 2026-08-02, **zéro PR en vol**.
>
> 1. **Les contrats d'exécution sont au privé.** La ROADMAP ordonnée et les `ETUDE.md`
>    (requirements R-N, décisions D-N, stop-points par lot) vivent dans
>    **`MBeji/yahia-quest-content`** (partis avec l'étude 24), avec désormais le programme
>    go-live. Démarrer la session **sur ce dépôt privé** et y ajouter celui-ci en second
>    checkout pour le moteur — même point de départ que les campagnes de contenu. Ce fichier
>    donne **l'état** ; le privé donne le **« comment »**.
> 2. **Réservé — ne pas empiéter** : les études **24** (lot 5, purge de l'historique git) et
>    **25** (lots restants, harness portable) peuvent être en cours ailleurs. Une session V1 ne
>    touche ni au harness/skills ni à l'historique git.
> 3. **Discipline** (AGENTS.md, DoD) : un lot = une PR à file set distinct ; migration additive
>    avant le code, destructive dans un merge séparé ; **pgTAP tourne sur les PR** touchant
>    `supabase/migrations/**` ou `supabase/tests/**` depuis #563 — mais **n'est pas requis**,
>    donc un rouge n'arrête pas l'auto-merge : il faut aller le lire (e2e-auth, lui, reste sur
>    dispatch). Savepoint = **préfixe de branche** `wip/`, jamais `[wip]` dans le sujet de
>    commit (ça fuit dans `main`). Suivre ses checks jusqu'au merge réel, puis faire le sweep.
> 4. **Un statut se constate, il ne se déduit pas.** Avant de traiter une issue « ouverte » ou
>    un GAP « à faire », vérifier sur `main` : la passe du 2026-08-02 a trouvé trois statuts
>    d'études faux et un GAP réputé clos dont la moitié n'existait pas.

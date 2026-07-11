# STATUS — état du projet (topo central)

> **Instantané daté du 2026-07-11.** Ce fichier est le **point d'entrée unique** pour savoir
> où en est le projet : phase produit, décisions structurantes, état réel des features,
> études, chantiers, travaux en vol. Il complète — sans les dupliquer — les documents
> normatifs : [CLAUDE.md](./CLAUDE.md) (conventions, gagne en cas de conflit),
> [ARCHITECTURE.md](./ARCHITECTURE.md) (architecture), l'index des études
> ([FableEtudes/README.md](./FableEtudes/README.md)) et le programme go-live
> (`../go-live/00-MASTER-PLAN.md`, hors repo).
>
> **Règles de maintenance** : (1) toute session qui livre un jalon structurant met à jour ce
> fichier (comme le master plan go-live) ; (2) en cas de doute sur l'état d'une feature, le
> code et les migrations font foi, pas ce fichier ; (3) les décisions se **journalisent**
> (append-only, §2), elles ne se réécrivent pas.

---

## 1. Identité & phase actuelle

|                      |                                                                                                                                                                                                                                                              |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Produit / marque** | **Na9ra Nal3ab** — académie d'apprentissage gamifiée, programme scolaire tunisien (13 niveaux + lycée en ouverture) + pistes libres (culture G, muscle-cerveau, langues)                                                                                     |
| **Repo**             | `yahia-quest-arena` (le dossier parent `YahiaAcademy/` est un wrapper hors git : corpus sources, go-live, outils)                                                                                                                                            |
| **Prod**             | Vercel `na9ranal3ab.vercel.app` — push sur `main` = déploiement + auto-application des migrations. ⚠️ Domaine `na9ranal3ab.tn` acheté mais **non câblé** (308, constat 2026-06-27) → SEO/sitemap bloqués                                                     |
| **Phase**            | **Bêta publique 100 % gratuite** — contenu consultable et praticable **sans compte** ; aucun paiement, aucun premium actif. L'infrastructure premium (entitlements, paywall, gate) existe mais est **dormante et réversible** (voir §2 et l'étude 01, gelée) |
| **Jalon visé**       | Rentrée scolaire sept. 2026 (« Porte 1 » du go-live)                                                                                                                                                                                                         |

---

## 2. Décisions structurantes (journal daté, append-only)

| Date          | Décision                                                                                                                                                                                                                 | Trace                                                                                |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| 2026-06-13    | Marque **Na9ra Nal3ab** ; conception initiale du modèle économique (freemium par parcours, ~69-79 DT) — **supersédée le 21/06**                                                                                          | go-live C5/C6                                                                        |
| 2026-06-15    | Sortie du boilerplate d'origine (méta-plugin Vite de-vendorisé → config inline), **Vite 8**, bun → **npm**                                                                                                               | go-live journal, PR #110                                                             |
| 2026-06-21    | **Pivot stratégique : plateforme de référence publique 100 % gratuite**, contenu sans login, « supersède C6 (monétisation retirée v1) », C5 réorienté SEO                                                                | go-live `08-refonte-plateforme-publique.md` (décisions actées) + master plan journal |
| 2026-06-22    | **Premium retiré de l'UI mais réversible** (« un premium pourra revenir un jour ») : machinerie serveur conservée dormante. MVP public live (PR #180)                                                                    | go-live C8 (L0.6)                                                                    |
| 2026-07-04→05 | Création du corpus d'études **FableEtudes** (16 études, architecte → exécuteurs)                                                                                                                                         | PR #285                                                                              |
| 2026-07-10    | **Arbitrage Q-2 étude 15 : « gratuité de phase »** — 100 % gratuit, mots « premium/abonnement/payant » bannis de toute surface utilisateur, entitlements dormants, l'étude 01 (paiement) est le véhicule de réactivation | `FableEtudes/15-contenu-design-ecrans/ETUDE.md` (D-3, Q-2)                           |
| 2026-07-11    | Gratuité **appliquée en base** : migration `20260711100000_free_phase_all_parcours.sql` (`is_premium = false` partout, ids concours notés pour réactivation) + donjon dé-gaté (plus de raison `SUBSCRIPTION`)            | PR #362, commit `3db87829`                                                           |
| 2026-07-11    | **Passe de rationalisation documentaire** : ce fichier créé, docs canoniques réalignées sur la gratuité, statuts d'études resynchronisés, go-live rafraîchi                                                              | cette PR                                                                             |

---

## 3. État réel des features (vérifié code + migrations, 2026-07-11)

**Légende** : 🟢 LIVE (en prod, fonctionnel) · 🟠 PARTIEL · 💤 DORMANT (code intact, inerte par la donnée/la phase) · ⬜ ABSENT (étude seulement).

| Feature                                                                              | État | Preuve / note                                                                                                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------ | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Boucle quête (QCM, XP, badges, streaks, boutique, consommables)                      | 🟢   | cœur historique ; `submit_exercise_attempt`                                                                                                                                                                                                                                         |
| Types de questions natifs (numeric, ordering, matching, multi)                       | 🟢   | étude 03 livrée (12 lots, PRs #295→#307)                                                                                                                                                                                                                                            |
| Donjon (boss mode)                                                                   | 🟢   | **plus un avantage premium** : verrous restants = progression (PREREQ/LEVEL/DAILY_LIMIT)                                                                                                                                                                                            |
| Duels temps réel & ligues hebdo                                                      | 🟢   | étude 05 livrée (5 lots, PRs #313→#323) ; pg_cron `expire-duels` + `award-duel-league-week` ; Realtime + fallback polling                                                                                                                                                           |
| Navigation « Arène » (Donjon·Duels·Classement) + coquille parent                     | 🟢   | étude 15 lot 5 (PR #368, route `/arene`)                                                                                                                                                                                                                                            |
| Plateforme publique sans login (catalogue → cours → pratique corrigée)               | 🟢   | pivot C8 (PR #180/#181), trilingue fr/en/ar                                                                                                                                                                                                                                         |
| Suivi parent (lien famille + **rapport public par code alliance**)                   | 🟢   | PR #335                                                                                                                                                                                                                                                                             |
| Signalement d'erreur de contenu (`content_reports`)                                  | 🟢   | bouton élève monté (fin de quête) + console `/admin/content-reports` + skill `report-triage`. **Le maillon manquant est opérationnel, pas technique** : le triage hebdo prévu (go-live E3) n'a jamais démarré ; améliorable : signalement au niveau question (aujourd'hui exercice) |
| Signalement de bug (`bug_reports`)                                                   | 🟢   | lanceur global + `/admin/bug-reports`                                                                                                                                                                                                                                               |
| Notifications push                                                                   | 🟢   | service worker + souscriptions                                                                                                                                                                                                                                                      |
| SEO (sitemap dynamique, robots.txt, meta)                                            | 🟠   | code livré (PRs #201/#202/#205) mais **domaine non câblé** → injoignable de Google                                                                                                                                                                                                  |
| Moteur adaptatif — télémétrie A0 (`question_attempts`, `user_misconceptions`)        | 🟠   | étude 04 : A0 livré (3/6 lots) ; **rien n'est encore surfacé à l'élève** (pas de « Révision du jour » / « Points faibles »)                                                                                                                                                         |
| PWA / offline                                                                        | 🟠   | socle seulement : manifest + SW (cache assets, page offline, push). **Pas de lecture offline du contenu** (cible étude 06, brouillon)                                                                                                                                               |
| Gate premium (`resolve_exercise_access`, entitlements, family pack)                  | 💤   | code vivant mais **inerte** : `is_premium=false` sur ~35 parcours. Réactivation = `UPDATE` inverse (étude 01)                                                                                                                                                                       |
| Paywall quête + formulaire beta-access utilisateur                                   | 💤   | `SubscriptionPaywall` câblé mais indéclenchable en phase gratuite                                                                                                                                                                                                                   |
| Consoles admin (entitlements, beta, content-reports, bug-reports, parcours-interest) | 🟢   | 5 routes `/admin/*`, gardées `is_admin`                                                                                                                                                                                                                                             |
| Examen blanc / simulation concours                                                   | ⬜   | étude 02 (brouillon) ; seul un placeholder `'exam'` existe dans un CHECK                                                                                                                                                                                                            |
| Knowledge graph / compétences                                                        | ⬜   | étude 07 (brouillon) ; **lot 1 en PR draft #366 — hors cycle, à arbitrer** (voir §6)                                                                                                                                                                                                |
| Paiement en ligne                                                                    | ⬜   | étude 01 **gelée** (phase gratuite) — c'est le futur véhicule de réactivation du premium                                                                                                                                                                                            |
| Tuteur IA « Prof Yahia »                                                             | ⬜   | étude 11 **gelée** (se finançait par l'étude 01)                                                                                                                                                                                                                                    |

---

## 4. Études (FableEtudes) — instantané

Source de vérité : [FableEtudes/README.md](./FableEtudes/README.md) (index) + l'en-tête de chaque `ETUDE.md`.

- **Livrées** : 03 (types natifs) · 05 (duels/ligues) · 13 (moteur de transcription **ScribeKit**, repo externe ; pilote d'usage en cours via PR #348) · 14 (refonte UX/design, close 2026-07-11).
- **En exécution** : 04 (adaptatif — A0 fait, A1+ à venir) · 15 (contenu & composition — lots 0-5 livrés / 14).
- **Validée, en attente d'exécution** : 16 (ouverture lycée — lot 0 fait).
- **Brouillons** (non validées) : 02 (examen blanc*) · 06 (PWA) · 07 (knowledge graph*) · 08 (analytics familles*) · 09 (économie du jeu) · 10 (anti-fraude) · 12 (studio d'ingestion).
- **Gelées (pivot gratuité)** : 01 (paiement en ligne) · 11 (tuteur IA).

\* 02 et 08 gardent une justification rédigée « premium » à re-scoper à la validation ; 07 a un lot 1 implémenté hors cycle (PR draft #366).

---

## 5. Programme go-live (wrapper `../go-live/`, hors repo)

Entrée : `go-live/00-MASTER-PLAN.md`. État au 2026-07-11 :

- **Clos** : C1 (audit fonctionnel) · C2 (audit technique, radar 3,31/4) · C3 (cybersécurité, 0 P0) · C5 (marketing — volet premium caduc, réorienté SEO) · C7 (gouvernance, Go/No-Go 2 portes).
- **Supersédé** : C6 (modèle économique) — remplacé par le pivot gratuit du 2026-06-21 ; conservé comme archive de travail pour une future étude 01.
- **Ouvert — technique** : C4 (architecture prod) : reste le câblage monitoring (UptimeRobot/Sentry/PostHog), le ruleset `main`, l'auth hardening (~45 min côté Mohamed) et **le câblage du domaine** `na9ranal3ab.tn`.
- **Actif — produit** : C8 (plateforme publique) : MVP live ; fils ouverts = SEO (bloqué domaine), post-MVP L3, revert de l'override bêta avant tout retour premium.
- **Backlog 90** : 54 GAP au total — 16 🟢 · 12 🟡 · 26 🔴 ; **0 P0 ouvert** ; 7 P1 ouverts (monitoring GAP-002, conformité mineurs INPDP GAP-003, pages légales GAP-024, contenu 13 niveaux GAP-040, QA contenu en CI GAP-048, skills GAP-051 ; GAP-001 « paiement » requalifié gelé → étude 01).

---

## 6. Travaux en vol & sessions à clôturer (constat 2026-07-11)

**PRs ouvertes** :

- **#348** — transcriptions first-pass ScribeKit (collège FR/EN + 1ère-sec, 10/11) — ouverte depuis le 2026-07-10 ; du travail non commité traîne aussi sur son worktree (`busy-raman`).
- **#366 (draft)** — étude 07 lot 1 : implémenté alors que l'étude est en `brouillon` (viole le cycle brouillon → validée → en exécution). **À arbitrer : valider l'étude 07, ou fermer la PR.**

**Arbres de travail à trier** (aucune suppression faite — validation Mohamed requise) :

- **Checkout principal `yahia-quest-arena/`** : resté sur `feat/seo-public-metadata` (branche **déjà mergée**, PR #182) avec ~155 modifs locales + 14 fichiers non suivis accumulés depuis le 22/06 → à trier puis remettre sur `main` propre.
- **Worktree `silly-curran-9dcdfd`** : lot « Méta » GAP-048→055 (hook garde des fichiers générés, `content/CATALOGUE.md`, catalogue.mjs…) — 18 fichiers **jamais commités**.
- **Worktree wrapper `_wt-french-3eme`** : contenu `content/french-3eme/` **non commité** (seul `_wt-*` avec du travail à sauver).
- Worktrees dont la PR est **mergée** (jetables après vérif) : `_wt-nav` (#209), `_wt-theme` (#206), `_wt-programme` (#211), `_wt-islamique-3eme` (#199), `_wt-islamique-4eme` (#223), `distracted-dirac` (#332), `lycee-section-structure` (#367), `ux-design-refactor` (#368).
- 6 dossiers `_wt-*` **orphelins** (plus de `.git`) dans le wrapper + ~95 branches distantes / ~60 locales → session d'hygiène dédiée recommandée (comme le tri D3 du 12/06).

**Issues ouvertes (17)** : 9 contenu (`content-audit` : 2 BLOCKER #336/#337 + 6 MAJOR sur `french-8eme`, 1 MAJOR `math-bac-math` #344) · #363 e2e-auth (12 échecs préexistants sur main) · #250 nightly rouge · 3 dépendances majeures (#233/#234/#236) · 2 enhancements produit (#293 bilan visible élèves, #294 vue par matière) · #316 preview Vercel.

---

## 7. Carte de la documentation (qui fait foi pour quoi)

| Document                                 | Rôle                                                                           | Statut                       |
| ---------------------------------------- | ------------------------------------------------------------------------------ | ---------------------------- |
| [CLAUDE.md](./CLAUDE.md)                 | **Canonique** : commandes, conventions, DoD, gotchas. Gagne sur tout autre doc | vivant                       |
| [ARCHITECTURE.md](./ARCHITECTURE.md)     | Compagnon architecture (stack, flux, modèle de données)                        | vivant                       |
| **STATUS.md** (ce fichier)               | Topo central : phase, décisions, état features/études/chantiers                | vivant, daté                 |
| [FableEtudes/](./FableEtudes/README.md)  | Études d'architecture des epics (contrats d'exécution architecte → exécuteur)  | vivant                       |
| [docs/](./docs)                          | Specs normatives + guides + runbooks par sujet (voir la liste dans CLAUDE.md)  | vivant                       |
| [docs/archive/](./docs/archive)          | Audits one-shot dépassés (conservés pour l'historique)                         | archive                      |
| [content/README.md](./content/README.md) | Spec du pipeline de contenu (FR)                                               | vivant                       |
| [e2e/README.md](./e2e/README.md)         | Runbook Playwright (projet TEST dédié)                                         | vivant                       |
| `../go-live/00-MASTER-PLAN.md`           | Programme POC → production (chantiers, Go/No-Go, journal) — **hors repo**      | vivant                       |
| `../go-live/PASSATION.md`                | Dossier de passation global                                                    | vivant (réaligné 2026-07-11) |
| `../go-live/90-backlog-remediation.md`   | Backlog transverse GAP-NNN                                                     | vivant                       |
| `../ScribeKit/`                          | Moteur de transcription (étude 13) — **repo git autonome**                     | vivant                       |

---

## 8. Prochaines actions recommandées (priorisées)

1. **Corriger le contenu `french-8eme`** (2 BLOCKER + 6 MAJOR ouverts) — qualité pédagogique visible.
2. **Reverdir `main`** : e2e-auth (#363, 12 échecs) + nightly (#250).
3. **C4 / mise en prod sérieuse** : câbler le domaine `na9ranal3ab.tn`, monitoring + ruleset (~45 min Mohamed), puis soumettre le sitemap.
4. **Activer le processus de triage** des signalements (`/admin/content-reports` + `/admin/bug-reports`, skill `report-triage`) — cadence hebdo légère.
5. **Trancher les travaux en vol** (§6) : PR #348, PR draft #366, lot Méta `silly-curran`, WIP `_wt-french-3eme`, checkout principal.
6. **Conformité mineurs** (GAP-003 INPDP) + pages légales (GAP-024) — prérequis légaux du lancement.
7. Session d'**hygiène branches/worktrees** (~95 distantes, ~60 locales, 6 dossiers orphelins).

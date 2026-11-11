# Audit global du projet — 2026-09-12

> **Instantané daté** — `main` à **#1022** (`19e5fa5`, 2026-09-12 15:25 UTC), corpus privé à
> `f048b4e` (#388) puis #390. Audit one-shot : il **constate** et **propose**, il ne décide rien.
> Quand ses lignes sont traitées ou dépassées, il descend dans `docs/archive/` avec sa date
> (règle de [`docs/archive/README.md`](./archive/README.md)). Les items de dette qu'il confirme
> ont vocation à être **inscrits ou corrigés** dans [`dette-technique.md`](./dette-technique.md),
> pas à vivre ici : ce fichier n'est pas un backlog.
>
> **Méthode.** Rien n'est recopié d'un document : chaque chiffre a été **mesuré dans cette session**
> (le gate complet `ci:verify` rejoué sous Node 24, les gates de contenu rejoués sur le corpus
> privé, la prod sondée, l'API GitHub interrogée, des scripts de comptage sur `src/`,
> `supabase/migrations/` et `.github/workflows/`). Chaque constat porte sa preuve
> (fichier:ligne, sortie de commande) et son statut : **NOUVEAU** (jamais écrit nulle part),
> **CONNU** (déjà dans `dette-technique.md`, STATUS.md, une issue — la référence est donnée) ou
> **PÉRIMÉ** (le document dit une chose, le code en dit une autre).
> Sévérités : 🟠 Élevé · 🟡 Moyen · 🟢 Faible. **Aucun constat Critique** : la prod est saine,
> le gate est vert, la posture de sécurité tient.

---

## 0. Verdict en une page

**Le moteur est en excellente santé technique ; ses automatismes, eux, se bloquent entre eux.**
Le gate complet est vert de bout en bout (11 étapes, 4 181 tests, 90 % de couverture,
0 vulnérabilité, budgets tenus), la base rejoue sur une base vierge, RLS et `search_path` sont
posés partout, la prod répond en 1,5 s avec ses six en-têtes de sécurité. Ce que l'audit trouve
n'est pas du code cassé : ce sont **quatre couplages** qui font que des gardes bien conçues
s'annulent, et une **dérive documentaire** que le projet connaît déjà (#994) mais ne mesure pas.

<!-- prettier-ignore -->
| Ce que l'audit a mesuré                                        | Valeur                                                  |
| -------------------------------------------------------------- | ------------------------------------------------------- |
| Gate `ci:verify` (Node 24.21 / npm 11.19)                      | **11/11 vert** en 5 min 03 s                            |
| Tests unitaires                                                | 332 fichiers · **4 181 tests** · 180 s (jsdom = 67 %)   |
| Couverture (seuils 80 %)                                       | lignes **90,9 %** · branches 81,8 %                     |
| Code (hors tests, hors générés)                                | 769 fichiers · **56 317 LOC** · 45 157 LOC de tests     |
| Server fns                                                     | 137 · **100 %** avec middleware d'auth et validateur    |
| Base                                                           | 213 migrations · 68 tables · 239 fonctions (196 SD)     |
| pgTAP                                                          | 100 fichiers · ≈ 1 901 assertions · vert ce jour        |
| RPC vivantes absentes de `types.ts`                            | **28** (dont 21 nées en septembre)                      |
| Bundle client                                                  | 816 kB gz / 121 chunks · 4 budgets à < 2 % du plafond   |
| Prod (`www.na9ranal3ab.tn`)                                    | 200 en 1,5 s · health OK · commit = `main`              |
| Nightly                                                        | rouge **9 nuits** (04→12/09) · vert au run de 15:28     |
| Dépendances                                                    | 0 vuln · **38** mineures en retard · Dependabot bloqué  |
| Corpus (privé)                                                 | 119 sujets · 999 chap. · 4 208 ex. · **25 414 quest.**  |
| STATUS.md                                                      | 250 KB dont **68 % de padding** · 3 « main à #N »       |

**Les dix gestes qui rapportent le plus, dans l'ordre** (détail et preuves au §6) :

<!-- prettier-ignore -->
| #   | Geste                                                                                                   | Effort | Qui     |
| --- | ------------------------------------------------------------------------------------------------------- | ------ | ------- |
| 1   | Remplacer `vite-tsconfig-paths` par `resolve.tsconfigPaths` natif de Vite 8 → débloque Dependabot       | S      | session |
| 2   | Régénérer `types.ts` **depuis la chaîne** et poser un gate `types:check`                                | M      | session |
| 3   | Relancer `upgrade-guard` (nightly vert ce soir) puis le **découpler** du nightly entier                 | S      | session |
| 4   | Ménage : 8 branches mortes, #260 re-sondée (48 avertissements, pas 2 154), STATUS en-tête               | S      | session |
| 5   | Gate `status:check` + sortir les grandes cellules des tableaux (tue le padding)                        | M      | session |
| 6   | Trancher `ai/` (service partagé) et poser la règle ESLint de frontière entre features                   | M      | session |
| 7   | Scinder `exercise-player.tsx` (747/750) et `quest.server.ts` (738/750) **avant** le prochain lot       | M      | session |
| 8   | Rate-limit durable devant les 8 RPC anonymes `SECURITY DEFINER` (reste de l'audit de juillet)          | M      | session |
| 9   | Hook de session cloud : dire « Node 22 servi » quand nvm manque, et un fallback sans nvm               | S      | session |
| 10  | Chunk i18n par locale (−40 kB gz au premier rendu) + budget « premier rendu » + Lighthouse CI           | M      | session |

Et ce qui n'attend **que** l'humain : GAP-003 (INPDP), le PAT qui expire le **2026-10-04**
(#1002), l'arbitrage A16, la lecture du verdict du pilote Q-9 (≈ 15/09).

---

## 1. Périmètre et méthode

- **Périmètre** : les deux dépôts — moteur public (`src/`, `supabase/`, `scripts/`,
  `.github/`, `docs/`, harness) et corpus privé (`content/`, 43 skills, `FableEtudes/`,
  ses 11 workflows) — plus la prod sondée en lecture et l'état GitHub (PR, issues, runs).
- **Hors périmètre** : l'exactitude pédagogique question par question (c'est le sweep
  `content-audit`), l'exécution E2E Playwright (projet TEST dédié, joué par le nightly — lu, pas
  rejoué), la lecture des tables de prod (aucun accès en écriture ni en lecture directe).
- **Outils** : `ci:verify` étape par étape (durées relevées) ; `programme:etat`, `content:check`,
  `content:qa[:strict]`, `content:audit:strict`, `programme:check`, `content:catalogue`,
  `content:figures:check` sur un clone du moteur lié au corpus ; scripts Python/Node de comptage
  (LOC hors blancs/commentaires, imports inter-features, `createServerFn`, casts, tables/RLS/
  fonctions/policies depuis les migrations, dérive `types.ts`, parité des 1 279 clés i18n via un
  bundle esbuild des trois dictionnaires) ; `npm outdated`, `npm ls` ; API GitHub (runs, jobs,
  logs, issues, PR) ; `curl` sur quatre URL de prod.
- **Limite assumée** : les 12 agents d'audit parallèles prévus ont été coupés par une limite de
  session avant de produire ; l'audit a été refait **en direct**, axe par axe, avec les mêmes
  mesures. Aucun chiffre ci-dessous ne vient d'un agent.

---

## 2. Constat mesuré

### 2.1 Le gate, rejoué sous Node 24 (commit `19e5fa5`)

<!-- prettier-ignore -->
| Étape                  | Résultat | Durée | Ce que dit la sortie                                                           |
| ---------------------- | -------- | ----- | ------------------------------------------------------------------------------ |
| `eol:check`            | ✅       | 1 s   | 1 441 fichiers, aucun CRLF                                                     |
| `leak:check`           | ✅       | 0 s   | aucun corpus, skill pédagogique ni migration générée au tip                    |
| `db:check-chain`       | ✅       | 0 s   | 213 migrations rejouées, 100 fichiers pgTAP ; 18 ids de fixture partagés (note) |
| `harness:check`        | ✅       | 4 s   | pointeurs, budget AGENTS.md, Unicode, Actions épinglées, YAML strict           |
| `perf:check`           | ✅       | 1 s   | scripts k6 valides, constantes synchronisées                                   |
| `lint`                 | ✅       | 35 s  | 0 avertissement (`--max-warnings=0`) + RTL + tokens                            |
| `typecheck`            | ✅       | 36 s  | app + scripts                                                                  |
| `test:coverage`        | ✅       | 183 s | 332 fichiers · 4 181 tests · `environment 120,6 s` sur 180 s                   |
| `build:check`          | ✅       | 19 s  | 11 budgets tenus                                                               |
| `smoke:shell`          | ✅       | 23 s  | `/` et `/programme` rendent sans erreur dans Chromium                          |
| `audit:deps`           | ✅       | 1 s   | 0 vulnérabilité                                                                |

Couverture : lignes 90,86 % (6 194/6 817), branches 81,76 % (4 533/5 544), fonctions 90,04 %,
statements 89,83 % — périmètre `features/`, `shared/`, `lib/`, `hooks/`, hors `components/`,
`index.ts` et `types.ts` (`vitest.config.ts:80-93`). Trois fichiers du périmètre sont à **0 %**
(`locale-sync.ts`, `report-source.ts`, `quest-outbox.ts`) et quatre sous 30 % (`training.ts`
12,5 %, `events.server.ts` 23 %, un `*-reports.server.ts` 22,7 %, `content-protection.ts` 26 %).

⚠️ **Node.** La VM sert Node **22.22.2** / npm 10.9.7 ; `CLAUDE_CODE_REMOTE=true` mais
`CLAUDE_ENV_FILE` est vide et nvm est absent (`/root/.nvm`, `/opt/nvm`), donc le hook
`session-start.mjs` n'a pas pu poser Node 24. Le gate a été rejoué sous un Node 24.21.0 téléchargé
en 20 s depuis `nodejs.org` (voir §3.12).

### 2.2 La prod, sondée en lecture

<!-- prettier-ignore -->
| URL             | Code | Temps  | Note                                                                   |
| --------------- | ---- | ------ | ---------------------------------------------------------------------- |
| `/`             | 200  | 1,50 s | 38 kB de HTML                                                          |
| `/api/health`   | 200  | 1,93 s | `{status: ok, database: ok, commit: 19e5fa5}` — **la prod EST `main`** |
| `/sitemap.xml`  | 200  | 5,00 s | 200 kB, **1 938 URL** (1 541 le 2026-08-03)                            |
| `/robots.txt`   | 200  | 0,93 s |                                                                        |

Six en-têtes de sécurité présents : CSP à nonce (`script-src 'self' 'nonce-…'
https://www.googletagmanager.com`), HSTS 2 ans `includeSubDomains; preload`,
`X-Frame-Options: DENY`, `nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`,
`Permissions-Policy`. `Cache-Control: public, max-age=0, must-revalidate`, `x-vercel-cache: MISS`.
Fonction SSR : région `arn1`, runtime `nodejs22.x`, `maxDuration: 300`
(`scripts/build-vercel.mjs:107,122,128`).

### 2.3 GitHub, au moment de l'audit

- **Moteur** : 2 PR ouvertes — #1016 (Dependabot, **CI rouge**) et #932 (`draft/`, savepoint
  volontaire). Issues ouvertes après les fermetures automatiques de l'après-midi : **#660, #937,
  #962, #979, #994, #1002**. Les trois issues de garde (#967 nightly, #1008 checkpoint, #1020
  garde-rouge) se sont **refermées seules** à 15:34, 15:39 et 15:51 UTC sur le run nightly
  relancé (`34702337311`, tout vert, y compris `E2E (authenticated)`). Ce run est le **premier vert
  depuis le 2026-09-03** : neuf nuits rouges sur une seule spec (#1015, corrigée par #1021).
- **11 branches distantes** : `main`, la Dependabot, `draft/regression-guard-20260901` (#932) et
  **8 sans PR** (`claude/etude-22-lot-5-donjon-scope`, `claude/report-fix-lesson-print-dark`,
  `claude/report-fix-rtl-parens-parent-report`, `claude/upgrade-patch-minor-2026-07-21`,
  `docs/ref-pr-787`, `feat/seo-public-metadata`, `fix/french-8eme-latex-338`,
  `fix/migration-timestamp-20260731120001`) — le compte que STATUS §6 donne « inchangé depuis le
  2026-08-26 » l'est toujours.
- **Corpus** : PR #390 (correctif `auto-pr.yml`, ouverte **et** mergée par `github-actions[bot]`
  en 82 s), Content CI verte, une seule issue ouverte (#260).
- **26 workflows** au moteur, **0 action non épinglée** (SHA), 3 sans bloc `permissions`
  (`db-backup`, `e2e`, `e2e-auth`), 3 sans `timeout-minutes` sur certains jobs (`migration-gate`
  0/2, `nightly` 0/5, `release` 0/1), 2 sans `concurrency` (`migration-gate`, `nightly`).
  Cadence programmée : `db-migrate-prod` **toutes les heures**, `freeze-watch` /3 h,
  `client-errors-watch` et `guard-watch` /6 h, `report-triage` /4 h, `report-apply` et
  `db-backup` quotidiens, `nightly` 01:00, `codeql`/`checkpoint`/`engagement` hebdo,
  `regression-guard` lun. + jeu., `tutor-digests` dim. — ≈ 1 500 runs/mois, gratuits (dépôt
  public), mais c'est autant de lignes dans `gh run list`.

### 2.4 Le corpus, rejoué

`content:check` valide **119 sujets · 999 chapitres · 4 208 exercices · 25 414 questions**,
62 compétences, 241 tags ; le catalogue compte 94 sujets sur 6 thèmes, 0 stub ; 773 dossiers de
chapitre portent chacun `cours.md` + `resume.md` + `chapter.json` ; 0 fichier `.svg` (figures
inline) ; **`content/videos.json` : 0 entrée**. `content:qa` (strict ou non) : **0 erreur,
48 avertissements** — 18 « explication cite une option par sa lettre », 13 méta-options
(« aucune/toutes »), 6 valeurs de réponse non reprises dans l'explication, 6 chapitres spatiaux
sans figure, 4 rattachements de domaine, **1 clé contredite par son explication**
(`math-bac-math/18-probabilites/04-defi`, Q5 : l'explication désigne « e », la clé dit « d »).
`content:audit:strict` : 296 constats sur 27 niveaux, dominés par R-9 « chapitre sans `manuel` »
(dont `technologie-bac-techniques`, 25 chapitres). `programme:check` : registre cohérent,
36 avertissements — tous des manuels **mutualisés** déclarés sous `bac-math` (français, philo,
anglais). `programme:etat` : 57 fiches dont 36 exploitables, **81/86** sujets du programme
présents, 0 fiche sans lien, 153 œuvres à rattacher, **0 parcours à ouvrir**.
`content:overflow:check` n'a pas pu tourner ici (le clone n'a pas les navigateurs Playwright).

### 2.5 Les documents, comptés

- `STATUS.md` : 250 716 octets sur 662 lignes ; **81 208 octets** une fois les suites d'espaces
  réduites — **68 % du fichier est du padding de tableaux**, produit par `prettier --write` sur
  `*.md` dans lint-staged (`package.json`, `.prettierrc` sans `proseWrap`) : chaque cellule longue
  élargit toute sa colonne. Le fichier cite **trois** positions de `main` : `#970`
  (en-tête et §6, 2026-09-04), `#1010` (§8, 2026-09-09), et la réalité est `#1022`. Il dit « 41
  skills pédagogiques » (§2) ; il y en a **43** (`ls .claude/skills` au privé, AGENTS.md dit 43).
- `docs/` : 11 577 lignes ; `performance-audit.md` 1 000 lignes, `content-generation-pipeline.md`
  948 ; `dette-technique.md` re-vérifiée le 2026-08-26.
- `ROADMAP.md` privé §5 liste encore F10 (geste opérateur de triage) et F11 (gabarits d'e-mail)
  « à la main de Mohamed », que STATUS §8 donne **tranchés le 2026-08-24** (F10 mécanisé par
  `report-apply.yml`, F11 « les e-mails restent en anglais »). La dérive n'est donc plus à sens
  unique : le privé porte deux lignes mortes.
- `docs/environment-variables.md` documente 32 variables ; les secrets d'Actions (`PROD_SUPABASE_*`,
  `TEST_SUPABASE_*`, `VERCEL_*`, `GH_AUTOMATION_PAT`, `CLAUDE_CODE_OAUTH_TOKEN`, `OPENAI_API_KEY`,
  `CRON_SECRET`, `MERGE_FREEZE`) sont documentés **ailleurs** (`ci-cd-and-branch-protection.md`,
  runbooks) — dispersé, pas absent.

---

## 3. Findings par axe

### 3.1 Architecture & qualité de code

Mesuré : 769 fichiers TS/TSX ; 56 317 LOC hors tests et hors générés ; 45 157 LOC de tests ;
137 `createServerFn`, **0** sans middleware, **0** handler lisant `data` sans `.inputValidator`
(heuristique sur 900 caractères) ; `as any` **1**, `as unknown as` **43** en `src/` (472 dans les
tests), `@ts-expect-error` 0 (1 en test), `@ts-ignore` 0, `eslint-disable` 4, `console.` 6 (tous
dans `logger.ts`, `client.ts`, `client.server.ts`, `start.ts`), TODO/FIXME 0.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                                                        | Preuve                                                                                                                                                                                                                             | Action                                                                                                                                                                                                              | Effort | Statut       |
| ---- | ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------ |
| A-1  | 🟡   | **Deux fichiers sont à 3 et 12 lignes du plafond `max-lines: 750`** : `exercise-player.tsx` **747**, `quest.server.ts` **738**. Le prochain lot é20/é30 qui les touche casse `lint`. La dette annonçait `dashboard.server.ts` 1 084 → il est à **623** (scindé), `tutor.server.ts` à 700.                                                       | comptage LOC hors blancs/commentaires ; `eslint.config.js:59`                                                                                                                                                                      | Scinder avant le prochain lot : le lecteur d'exercice a déjà `use-exercise-session.ts` ; extraire le rendu par type de question ; côté serveur, sortir les server fns « session » de `quest.server.ts`               | M      | PÉRIMÉ/CONNU |
| A-2  | 🟡   | **La frontière « une feature n'importe jamais une autre » est violée 7 fois, pas 5** : `tutor → ai` ×3 (`tutor.stream.server.ts:34`, `digest.server.ts:58`, `tutor.server.ts:47`), `duel → quest` ×3 (`league-podium.tsx:4`, `duel-arena.tsx:2-3`) + 1 test. `exam` n'importe plus rien. Aucun gate.                                            | grep `from "@/features/<x>"` depuis `src/features/<y>`                                                                                                                                                                             | Trancher d'abord (dette) : `ai/` est un **service partagé** → ses appelants passent par `shared/integrations/ai/` (qui existe déjà) ; les 2 composants `quest` consommés par `duel` montent dans `shared/` ; puis `no-restricted-imports` par feature | M      | PÉRIMÉ/CONNU |
| A-3  | 🟢   | **31 des 55 primitives `components/ui` n'ont aucun importeur** (la dette dit 34), dont `sidebar.tsx` **680 lignes** — le 8ᵉ plus gros fichier du dépôt ne sert à rien. Trois dépendances sans référence : `date-fns`, `lenis`, `@hookform/resolvers` ; `@types/web-push` est en `dependencies`.                                                | script d'importeurs sur `@/components/ui/<x>` ; `package.json:71,89,91,112`                                                                                                                                                       | Lot soustractif prouvé par `tsc` + `build:check` (déjà décrit dans la dette) ; déplacer `@types/web-push` en dev                                                                                                     | S      | CONNU        |
| A-4  | 🟢   | **43 `as unknown as` en `src/`**, dans 12 fichiers — `progression.server.ts` 4, `dashboard/*` 8, `ai/*` 4, `auth.server.ts` 2, `notifications.cron.server.ts` 2, `shared/*` 5. La ligne de dette (« restent dashboard 7, progression 2, quest 1 ») ne décrit plus la répartition : `ai/` et `auth/` en portent alors qu'ils sont donnés soldés. | grep par fichier                                                                                                                                                                                                                   | Re-qualifier chaque cast (vue d'ombre RPC vs autre) **après** D-2 (types régénérés) : la moitié tombera d'elle-même                                                                                                 | S      | PÉRIMÉ       |
| A-5  | 🟢   | Les dictionnaires i18n (1 264 / 1 246 / 1 236 lignes + `types.ts` 1 153) sont exemptés de `max-lines` — choix documenté et sain.                                                                                                                                                                                                                | `eslint.config.js:69-76`                                                                                                                                                                                                          | Rien                                                                                                                                                                                                                | —      | —            |

### 3.2 Sécurité

Mesuré : 68 tables, **RLS activé sur toutes** ; 96 policies, 14 `USING (true)` (le catalogue
public — `themes`, `grades`, `subjects`, `chapters`, `exercises`, `questions`, `parcours` —, les
registres de compétences, `app_events`, `ai_admin_state` restreinte à `authenticated` ; la
policy « Profiles are viewable by everyone » de mai est **remplacée** en `20260522153000`) ;
239 fonctions (dernière définition), **196 `SECURITY DEFINER`, toutes avec `SET search_path`** ;
**8** fonctions `SECURITY DEFINER` exécutables par `anon` : `check_answers`, `score_quiz`,
`get_active_event`, `get_recall_availability`, `get_student_report_by_code`,
`get_student_daily_report_by_code`, `get_student_attempt_detail_by_code`,
`parcours_interest_counts`. Aucun `.env` suivi (`.env.test.example` seul). Session Supabase en
`localStorage` (`client.ts:33-35`). Le rate-limit est une `Map` en mémoire (`rate-limit.ts:14`).
Les 10 findings de l'audit de juillet : #3, #6, #9 corrigés à l'époque ; **#2 et #4 toujours
ouverts** (RPC anonymes lourdes sans borne durable) ; #5, #7, #8 sont des acceptations.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                                        | Preuve                                                                                                              | Action                                                                                                                                                                                               | Effort | Statut       |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------ |
| S-1  | 🟡   | **Huit RPC anonymes `SECURITY DEFINER` sans borne durable.** Le rate-limit vit dans une `Map` par instance Vercel (per-instance, clé `x-forwarded-for`) : `check_answers` (récolte de la clé de correction, finding #1 de juillet) et les trois `*_by_code` (rapports parent, lourdes) restent appelables en boucle via PostgREST. | `rate-limit.ts:14` ; grants dans `20260621181000`, `20260705190000` et suivantes                                    | Fenêtre glissante **en SQL** (table `rate_limits` + fonction `assert_rate_limit(key, n, window)` appelée en tête des 8 RPC) — durable, sans service tiers ; garder la `Map` comme premier étage | M      | CONNU (arch.) |
| S-2  | 🟢   | **Le triage IA autonome applique des correctifs** (`report-apply.yml`, `report-triage.yml` avec `CLAUDE_CODE_OAUTH_TOKEN` + `GH_AUTOMATION_PAT`). Le skill `report-triage` impose un screening d'injection de prompt ; la PR reste derrière les checks requis. Posture acceptable **tant que** l'automerge exige `verify`.        | `.github/workflows/report-apply.yml`, `.claude/skills/report-triage/SKILL.md`                                      | Tracer dans `docs/agents/gardes.md` la ligne « ce qu'un signalement ne peut PAS déclencher » (pas de migration destructive, pas de `harness/`, pas de `.github/`) et la faire vérifier par `precommit-checks.mjs` | S      | NOUVEAU      |
| S-3  | 🟢   | **Le compte admin franchit toutes les portes de progression** (`20260905150000`) — voulu (compte de test), tenu par pgTAP 97. Mais `is_admin()` devient un « super-élève » : rien n'empêche un admin d'apparaître au classement ou de fausser `admin_engagement_overview`.                                                       | `20260905150000_admin_unrestricted_access.sql`                                                                      | Exclure `role = 'admin'` des agrégats d'engagement et des classements (une clause, un test pgTAP)                                                                                                     | S      | NOUVEAU      |
| S-4  | 🟢   | Chaîne à jour : CSP à nonce, HSTS preload, CodeQL requis, 0 vulnérabilité, `handle_new_user` non escaladant + `prevent_role_escalation`. Rien à faire.                                                                                                                                                                         | §2.2 ; `20260602*`                                                                                                  | —                                                                                                                                                                                                    | —      | —            |

### 3.3 Base de données & migrations

Mesuré : 213 migrations ; 69 tables créées, 1 tombée (`difficulty_adaptation`, #911) ;
9 triggers, 89 index, 10 vues ; churn : `submit_exercise_attempt` **16** réémissions,
`get_attempt_review` 6, `award_xp` 5, `submit_dungeon_answer` 5, `start_exercise_session` 5 ;
`db:check-chain` : base vierge → 5 sujets, 41 chapitres, 135 exercices, 244 questions de fixture ;
pgTAP : 100 fichiers, ≈ 1 901 assertions — `submit_exercise_attempt` cité par 10 fichiers,
`handle_new_user` 9, `resolve_exercise_access` 6, `start_exercise_session` 6, `award_xp` 5,
`check_answers` 4 ; **0** pour `sweep_ai_reservations` et `set_profile_locale`.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                                                                                                                                         | Preuve                                                                                                     | Action                                                                                                                                                                                                                                                 | Effort | Statut  |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | ------- |
| D-1  | 🟠   | **`types.ts` est en retard de 28 RPC vivantes et 3 tables** (`app_events`, `client_errors`, `push_consent_events`). 21 des 28 sont nées en **septembre** : les 15 RPC d'é31 (`20260902*` — `set_daily_xp_goal`, `get_weekly_recap`, `claim_welcome_pack`, `export_user_data`…), `student_chapter_gaps` (0904), `chapter_quiz_cleared`/`gated` (0905). Le dernier commit sur le fichier date du 2026-09-03 et n'était pas une régénération complète. | script de dérive migrations ↔ `types.ts` ; `git log -- types.ts`                                           | **Générer depuis la chaîne, pas depuis la prod** : `db:test:local` rejoue déjà les 213 migrations sur un Postgres jetable → `supabase gen types --db-url` sur ce cluster, `git diff --exit-code` = gate `types:check` dans `verify`. Fait tomber aussi le pont `client_errors` (dette) | M      | NOUVEAU |
| D-2  | 🟡   | **`submit_exercise_attempt` a été réémise 16 fois** — la fonction la plus critique du produit est aussi la plus retouchée ; la règle « on substitue, on ne retape pas » (STATUS §6) n'a pas de gate : rien ne compare la nouvelle révision à la vivante.                                                                                                                                                                         | comptage `CREATE OR REPLACE FUNCTION` par nom                                                              | Script `db:fn-diff <fn>` (diff de la dernière révision contre la précédente, en lignes) appelé par `migration-gate.yml` quand une PR réémet une fonction de plus de 100 lignes — le diff est posté en commentaire de PR                              | M      | NOUVEAU |
| D-3  | 🟢   | **Deux fonctions sans pgTAP** : `sweep_ai_reservations` (celle dont la dette dit qu'elle ne rend pas l'énergie — confirmé : son corps ne touche que `ai_spend_ledger` et `ai_platform_ledger`, `ai_energy_ledger` n'est que purgée) et `set_profile_locale`.                                                                                                                                                                     | `20260823110000` lignes 8-15 vs 31 ; grep `supabase/tests/`                                                | Écrire le test qui **échoue** aujourd'hui (énergie non rendue après 5 min), puis corriger — le test d'abord, c'est la seule façon que la ligne de dette se ferme sur un fait                                                                            | S      | CONNU   |
| D-4  | 🟢   | 18 ids de fixture existent dans **deux tables** différentes (note de `db:check-chain`) — inoffensif aujourd'hui, fragile si l'une bouge.                                                                                                                                                                                                                                                                                        | sortie `db:check-chain`                                                                                    | Renuméroter les fixtures (`--verbose` les liste)                                                                                                                                                                                                       | S      | NOUVEAU |
| D-5  | 🟢   | `db-tests.yml` (pgTAP) tourne sur les PR touchant `supabase/**` mais **n'est pas requis** : un rouge n'arrête pas l'automerge. Il est vert ce jour, et le nightly le rejoue.                                                                                                                                                                                                                                                     | `docs/ci-cd-and-branch-protection.md` ; STATUS §8 ¶3                                                       | Le rendre requis **conditionnellement** n'existe pas sur GitHub ; l'alternative est de l'appeler depuis `ci.yml` (`workflow_call`) quand le diff touche `supabase/**` — un seul check requis, deux contenus                                             | M      | CONNU   |

### 3.4 Tests & couverture

Mesuré : 290 fichiers de test en `src/`, 42 en `scripts/` ; 5 `test.skip` conditionnels (tous
e2e, sur l'état du projet TEST) ; 42 specs Playwright (26 authentifiées, publiques, anonymes) ;
5 `waitForTimeout` ; `@axe-core/playwright` sur **3 pages** (dashboard, classement, matière)
en nightly seulement + un test unitaire de contraste des tokens ; ratio tests/code 0,8.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                         | Preuve                                                                        | Action                                                                                                                                                                                                  | Effort | Statut  |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| T-1  | 🟡   | **jsdom coûte encore 67 % du temps mural** (120,6 s sur 180 s ; la dette mesurait 486/516 s sur Windows). Sur cette VM Linux la suite entière tient en 3 min — le gate pré-push est supportable, mais chaque fichier sans DOM paie l'environnement.                               | sortie Vitest `environment 120.59s`                                           | `test.projects` node/jsdom (dette, inchangé) — gain attendu ≈ 100 s ici, bien plus sur un poste Windows                                                                                                 | M      | CONNU   |
| T-2  | 🟡   | **Trois fichiers du périmètre couvert à 0 %** (`locale-sync.ts`, `report-source.ts`, `quest-outbox.ts`) et quatre sous 30 % — dont `quest-outbox.ts`, la file de soumission qui protège « le travail de l'élève est écrit avant d'être envoyé » (STATUS §6). Le seuil global (80 %) ne les voit pas. | rapport v8 du gate                                                            | Ajouter un seuil **par fichier** (`perFile: true` en Vitest 4) à 50 % pour ne plus laisser un fichier neuf entrer nu ; couvrir `quest-outbox.ts` en premier                                              | S      | NOUVEAU |
| T-3  | 🟢   | Les composants (`features/**/components/**`) sont **hors couverture par choix** ; l'E2E ne les touche qu'en nightly, et `a11y` ne voit que 3 pages. L'exercise-player (6 types natifs, drag-and-drop dnd-kit) n'a pas de passe axe.                                              | `vitest.config.ts:86-93` ; `e2e/authed/a11y.spec.ts:12-25`                    | Une 4ᵉ page sous axe : le lecteur d'exercice sur une mission `ordering`/`matching` (alternative clavier au drag-and-drop à vérifier)                                                                     | S      | NOUVEAU |
| T-4  | 🟢   | `describe/it.only` : 0 ; `.skip` inconditionnels : 0 ; `waitForTimeout` : 5 — hygiène bonne.                                                                                                                                                                                    | grep                                                                          | —                                                                                                                                                                                                       | —      | —       |

### 3.5 CI/CD, gardes et automatismes

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Preuve                                                                                                                                                   | Action                                                                                                                                                                                                                                                                                | Effort | Statut       |
| ---- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------ |
| C-1  | 🟠   | **Un test e2e a gelé trois automatismes pendant neuf jours.** `#1015` (une spec, aucun défaut produit) a rougi le nightly du 04 au 12/09 ; or `upgrade-guard.yml` ne part que sur `workflow_run … conclusion == 'success'` (`:59-61`) et `checkpoint-tag.yml` exige « verify vert + nightly vert » : **0 montée de dépendance, 0 checkpoint de rollback vérifié** (#1008) et une garde-rouge (#1020) pendant que la prod, elle, allait bien. Le nightly agrège 4 suites de nature différente en un seul verdict. | `.github/workflows/upgrade-guard.yml:38-61` ; #1008 ; commentaires de #967 (« E2E auth ❌ » × 8 nuits) ; run `34675988786` skipped                       | Découpler : `upgrade-guard` se déclenche sur **`verify` vert de `main`** (son propre `ci:verify` en session est le vrai filet) ; `checkpoint-tag` se contente de `CI` + pgTAP verts (l'E2E auth mesure le projet TEST, pas la prod) ; et une règle écrite : **nightly rouge > 48 h = rang 0**, pas une issue qui vieillit | S      | NOUVEAU      |
| C-2  | 🟠   | **Chaque PR Dependabot est morte à l'arrivée.** #1016 échoue au canari npm 10 (`Missing: typescript@5.9.3 from lock file`) — même mécanisme que #716. Cause racine mesurée : `tsconfck@3.1.6` (via `vite-tsconfig-paths`) a un peer `typescript ^5.0.0` **invalide** avec TS 6.0.3 (`npm ls` : « typescript@6.0.3 deduped invalid: ^5.0.0 from …/tsconfck »), et npm 10 et 11 ne résolvent pas ce conflit pareil. `dependabot.yml` n'ouvre que des PR de **sécurité** (`open-pull-requests-limit: 0`) : ce sont donc précisément les correctifs de sécurité qui ne passent pas. | logs du job `verify` du run `34702179213` ; `npm ls tsconfck typescript` ; `.github/dependabot.yml:7`                                                     | **Vite 8 sait lire `paths` nativement** (`resolve.tsconfigPaths`, `node_modules/vite/dist/node/index.d.ts:2016`) : retirer `vite-tsconfig-paths` (`vite.config.ts:3`) et `tsconfck` disparaît du lock avec son peer — le lock redevient identique sous npm 10 et 11, le canari cesse de mordre, #1016 passe après rebase. Vérifier Vitest (même config Vite) | S      | NOUVEAU      |
| C-3  | 🟡   | **38 dépendances mineures/patch en retard** (dont `@supabase/supabase-js` 2.111 → 2.116, `zod` 4.4 → 4.6, `vite` 8.2 → 8.3, `eslint` 10.8 → 10.10, `@playwright/test` 1.62 → 1.63, `react` 19.2.8 → 19.3.0) et 5 majeures (`vitest` 5, `@vitest/coverage-v8` 5, `motion` 13, TS 7 bloquée #660). C'est la conséquence directe de C-1 : neuf nuits sans `upgrade-guard`.                                                                                    | `npm outdated` (§annexe B)                                                                                                                                | Dès le nightly vert (ce soir) : dispatcher `upgrade-guard` à la main ; les majeures `vitest`/`coverage-v8` 5 en un lot isolé                                                                                                                                                             | S      | NOUVEAU      |
| C-4  | 🟢   | 3 workflows sans bloc `permissions` (héritent du défaut du dépôt) : `db-backup`, `e2e`, `e2e-auth` ; `nightly` sans `timeout-minutes` ni `concurrency`.                                                                                                                                                                                                                                                                                                       | tableau §annexe A                                                                                                                                         | Poser `permissions: contents: read` explicite + `timeout-minutes` (un E2E qui pend = 6 h de runner)                                                                                                                                                                                       | S      | NOUVEAU      |
| C-5  | 🟢   | `second-opinion.yml` tourne (`skipped`) sur **chaque** PR depuis sa mise en dormance — 5 runs dans les 60 derniers, tous sautés.                                                                                                                                                                                                                                                                                                                                | liste des runs                                                                                                                                            | Passer en `workflow_dispatch` seul tant qu'il est dormant                                                                                                                                                                                                                                | S      | NOUVEAU      |
| C-6  | 🟢   | `db-migrate-prod.yml` tourne **toutes les heures** (réconciliation) — 720 runs/mois avec `PROD_SUPABASE_DB_URL` en main, pour attraper un cas (une migration mergée sans push) qui n'a pas de trace récente.                                                                                                                                                                                                                                                    | `.github/workflows/db-migrate-prod.yml` (`7 * * * *`)                                                                                                     | Toutes les 6 h suffit ; ou mieux : ne réconcilier que si `supabase migration list` diverge (déjà un guard ?) — à lire avant de toucher                                                                                                                                                    | S      | NOUVEAU      |

### 3.6 Dépendances & stack

Mesuré : 62 dépendances runtime, 519 paquets au total, `npm ls` propre, 0 vulnérabilité ;
`overrides.esbuild ^0.28.1` ; Node 24 en `.nvmrc`, dans `ci.yml:39` **et** dans la Content CI
privée (`content-ci.yml:87`) ; `nodejs22.x` sur Vercel ; Node 22 sur les VM cloud ; TS 6.0.3
(TS 7 bloquée par `typescript-eslint`, #660 — attendre l'amont, CONNU).

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                           | Preuve                                        | Action                                                                                                             | Effort | Statut  |
| ---- | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------ | ------- |
| P-1  | 🟡   | Voir C-2 : le peer `tsconfck` ↔ TS 6 est la **seule** raison pour laquelle le lock diffère entre npm 10 et 11 ; le canari A17 protège encore les postes en Node 22/npm 10 (poste Windows, VM cloud par défaut).   | `npm ls` ; `docs/agents/poste-windows.md`      | Retirer `vite-tsconfig-paths` (C-2) ; garder le canari                                                             | S      | NOUVEAU |
| P-2  | 🟢   | `@types/dompurify` est déclaré alors que `dompurify` 3 embarque ses types (le registre annonce `latest` = 3.0.5, en arrière de la version installée : paquet gelé).                                                | `npm outdated`                                | Retirer `@types/dompurify`                                                                                         | S      | NOUVEAU |
| P-3  | 🟢   | `@cloudflare/vite-plugin` + `wrangler.jsonc` sont présents alors que le déploiement est Vercel ; `workerd` (1.20260908) s'installe avec un script post-install à chaque `npm ci`.                                   | `package.json:107` ; log du job `verify`       | Confirmer l'usage (préview locale ?) ou retirer — un runtime de moins dans le lock                                  | S      | NOUVEAU |

### 3.7 Performance & bundle

Mesuré : client 2 729 kB brut / **816 kB gzip** / 121 chunks ; CSS 152 kB / 23 kB gz ;
`vendor-three` 224,7 kB gz (chargé **lazy**, landing seulement, coupé par
`prefers-reduced-motion` — `public-landing.tsx:40,105,499`), `index` 139,4 kB gz, `i18n`
64,4 kB gz (**les trois langues dans un seul chunk**, `vite.config.ts:71`), `vendor-supabase`
52,0, `vendor-motion` 39,6, `vendor-radix` 26,3 ; `public/` 272 K (polices 184 K) ; service
worker : assets en cache, HTML réseau-seul avec page hors-ligne (`public/sw.js:5-17`) ;
RUM `web-vitals.ts` → PostHog ; pas de budget LCP (dette, inchangé) ; `/sitemap.xml` en **5 s**.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                       | Preuve                                                            | Action                                                                                                                                                                                                                                       | Effort | Statut  |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| F-1  | 🟡   | **Quatre budgets sont à moins de 2 % de leur plafond** (`index` 450,1/456, `i18n` 186,1/188, `dashboard` 34,4/36, `vendor-icons` 30,3/32) : le prochain lot qui ajoute une clé i18n ou une icône renégocie un budget — le gate mesure la **négociation**, plus la régression.                                    | sortie `build:check`                                              | Remettre 10 % de marge et ajouter un budget **« premier rendu »** (somme gz des chunks chargés sur `/` et `/dashboard`) : c'est ce chiffre qui compte pour un Android modeste en 3G, pas chaque chunk pris seul                               | S      | NOUVEAU |
| F-2  | 🟡   | **Chaque visiteur télécharge les trois dictionnaires** (64 kB gz) pour n'en lire qu'un. Le commentaire du `manualChunks` explique pourquoi ils sont regroupés (cycle i18n ⇄ index, crash TDZ) — la solution est le chargement **dynamique par locale**, pas trois chunks statiques.                            | `vite.config.ts:64-82`                                            | `import(\`./i18n/${locale}.ts\`)` derrière le provider, FR en statique (langue par défaut) : ≈ −40 kB gz au premier rendu                                                                                                                   | M      | NOUVEAU |
| F-3  | 🟡   | **Pas de budget de performance runtime** — connu. Le RUM existe, rien ne bloque. `/sitemap.xml` (1 938 URL) répond en 5 s à chaque hit, sans cache.                                                                                                                                                           | dette ; sonde §2.2                                                | Lighthouse CI dans le nightly sur `/`, `/programme`, `/dashboard` (LCP ≤ 2,5 s sur profil « Moto G / 4G lente ») ; `Cache-Control: s-maxage=3600` sur le sitemap                                                                              | M      | CONNU   |
| F-4  | 🟢   | Région SSR `arn1` (Stockholm) pour un public tunisien ; la latence Tunis–Stockholm ajoute ~40-60 ms par aller-retour SSR, et la base est ailleurs encore. Sans mesure RUM par pays, on ne sait pas ce que ça coûte.                                                                                            | `build-vercel.mjs:128`                                            | Lire dans PostHog le TTFB par pays avant de changer quoi que ce soit (« sonder, pas déduire ») ; `fra1`/`cdg1` sont plus proches si la base Supabase est en Europe de l'Ouest                                                                   | S      | NOUVEAU |

### 3.8 i18n, RTL, accessibilité

Mesuré (bundle esbuild des trois dictionnaires) : **1 279 clés, 0 manquante** en EN et en AR
(contrat typé `types.ts`) ; 56 valeurs EN identiques au FR — des mots partagés (`Parent`,
`Email`, `Badge`, `Novice`, `Potion`), légitimes ; AR : **1** valeur identique au FR
(`Anthropic`), 2 sans écriture arabe (préfixe OAuth, nom de fournisseur). RTL : 5 règles de lint
(marges/paddings, `text-left/right`, `left-/right-`, `rounded-l/r`, `border-l/r`), 0 violation.
a11y : 0 `div`/`span` cliquable sans rôle ; 8 `aria-live` ; 33 usages de `prefers-reduced-motion` ;
axe sur 3 pages en nightly ; test unitaire de contraste des tokens. Chaînes en dur visibles :
**31**, toutes dans les pages légales (`_public/confidentialite.tsx:74-114`…), en français seul.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                  | Preuve                                                | Action                                                                                                            | Effort | Statut  |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| I-1  | 🟡   | **Les pages légales n'existent qu'en français** (confidentialité, mentions) alors que le public est arabophone et mineur, et que GAP-003 (INPDP) exige une information **compréhensible** par le parent qui consent.      | grep JSX ; `confidentialite.tsx`                      | Passer les pages légales par les dictionnaires (clés `legal.*`) — FR/AR au minimum ; l'EN peut attendre           | M      | NOUVEAU |
| I-2  | 🟢   | Le lecteur d'exercice (types `ordering`/`matching` en drag-and-drop dnd-kit) n'a **aucune passe axe** ni test clavier — voir T-3.                                                                                         | `e2e/authed/a11y.spec.ts`                             | Une page de plus sous axe + un test « ordering au clavier »                                                       | S      | NOUVEAU |
| I-3  | 🟢   | Les mots de phase gratuite (« premium », « abonnement ») existent dans `fr.ts:689-758,831` — portés par les surfaces **dormantes** (`SubscriptionPaywall`, beta-access, console admin « Abonnements »), non atteignables. | grep ; `routeTree.gen.ts` (aucune route `/beta`)      | Rien tant que le paywall est indéclenchable ; un test d'intégration « aucune route publique ne rend ces clés » fige l'invariant | S      | NOUVEAU |

### 3.9 UX front & routes

Mesuré : 51 fichiers de route ; `errorComponent` et `notFoundComponent` **globaux** dans
`__root.tsx:171-172` ; `beforeLoad` dans 6 routes ; `defaultPreloadStaleTime` 30 s ; aucun
`pendingComponent` (SSR + Suspense) ; PWA : manifest + SW + `offline.html` (socle, M1 — connu) ;
formulaires : validation zod, refus d'auth centralisés dans `auth-refusals.ts` (invariant `Record`
tenu par `tsc`) ; file de soumission `outbox.ts` (le travail de l'élève est écrit avant d'être
envoyé). Les trois audits archivés de juin (écrans, fluidité, multi-devices) ont été supersédés par
les études 14/15 ; leurs items n'ont pas été re-vérifiés un par un ici (ils ne sont plus un backlog).

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                   | Preuve                                            | Action                                                                                                        | Effort | Statut  |
| ---- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| U-1  | 🟡   | **La soirée d'exercices perdue (#979) n'est toujours pas élucidée** — l'instrumentation (#977) est posée, la garde a un seuil, mais le critère de clôture (« une occurrence datée ou deux semaines de silence ») arrive à échéance le **2026-09-18** sans que personne ne soit chargé de lire. | #979 ; `client-errors-watch.yml` (/6 h)           | Mettre la date du 18/09 dans STATUS §8 (horloge), et faire lire `client_errors` par le relevé d'engagement du lundi | S      | CONNU   |
| U-2  | 🟢   | Le SW ne met **jamais** le HTML en cache (choix documenté) : hors ligne, un élève qui a un chapitre ouvert perd tout à la navigation — c'est le périmètre gelé d'é06, cohérent avec la doctrine.            | `public/sw.js:6`                                  | Rien avant le dégel d'é06                                                                                     | —      | CONNU   |

### 3.10 Produit & Definition of Excellence

Constaté (STATUS §1bis/§3, ROADMAP privée §2, code) : la doctrine « profondeur avant largeur »
est **écrite** (é26, `docs/doctrine-verticale.md`) et la colonne M dit ce qu'elle a à dire :
**2 capacités sur 30 à M3**, 23 à M2. Le goulot est **humain** (KPI-1 zéro canal ; D-5 n'attend
que GAP-003). Le pilote IA Q-9 tourne depuis le 2026-09-01, verdict ≈ 15/09. `economy:check`
est **rouge** (G-4 : le rachat de série couvrirait 53 % des jours manqués) — A16, arbitrage
humain en attente, hors gate par choix.

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                                     | Preuve                                                 | Action                                                                                                                                                                                 | Effort | Statut  |
| ---- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| X-1  | 🟡   | **La largeur a continué de gagner sur la profondeur pendant que la doctrine s'écrivait** : 94 sujets au catalogue, 119 validés, et le 8ᵉ commit du privé sur 8 jours ouvre `technologie-bac-techniques` (7 chapitres) et `math-2eme-sec` — pendant que `french-6eme` (classe de **concours**, fiche transcrite) reste vide et que `videos.json` est à **0** après 4 lots de code d'é23. | `git log` privé ; `programme:etat` ; `content/videos.json` | Appliquer l'ordre déjà écrit au §8 de STATUS : french-6eme **avant** toute nouvelle matière ; et une règle de campagne : « une matière ouverte = cours + résumé + quiz + ≥ 1 vidéo par chapitre » | —      | CONNU   |
| X-2  | 🟡   | **Les six types natifs pèsent 1,2 % du corpus** (297 questions sur 25 090 — STATUS §3) : la capacité signature « ici on s'entraîne » est portée à 98,8 % par du QCM. C'est un chantier de **contenu**, pas de code.                                                                                                          | STATUS §3 ligne « Réponses acceptées »                  | Fixer un plancher par chapitre neuf (ex. 20 % de non-QCM) dans `content:qa` en `warn`, puis en `error` sur les matières de concours                                                     | S      | CONNU   |
| X-3  | 🟢   | **`user_misconceptions` n'a pas été re-sondée en prod depuis le 2026-08-23** (STATUS §1bis ligne 3) — l'étage adaptatif est « armé, pas prouvé » depuis trois semaines, alors que la rentrée est passée.                                                                                                                      | STATUS §1bis                                           | Faire compter la table par `engagement-report.yml` (une ligne de plus dans le relevé du lundi) — supprimer le besoin de la sonde manuelle                                                 | S      | CONNU   |

### 3.11 Corpus & pipeline de contenu

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                    | Preuve                                      | Action                                                                                                                                              | Effort | Statut  |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| K-1  | 🟡   | **Une clé de réponse contredite par son explication** est en `warn`, pas en `error` : `math-bac-math/18-probabilites/04-defi` Q5 (« l'explication désigne e, la clé dit d »). Un élève de bac lit une correction fausse.                    | `content:qa:strict`                         | Corriger la question ; passer cette règle en **erreur** (une clé et son explication qui divergent ne sont jamais un « à revoir »)                    | S      | NOUVEAU |
| K-2  | 🟡   | **L'issue #260 est périmée** : elle annonce 2 154 avertissements « option citée par lettre » ; `content:qa` en compte **18** (48 avertissements toutes règles confondues).                                                                    | `content:qa` ce jour                        | Fermer #260 avec le chiffre, traiter les 18 dans une passe                                                                                          | S      | PÉRIMÉ  |
| K-3  | 🟢   | 296 constats `audit:strict` dominés par R-9 (chapitre sans `manuel`) sur les matières techniques du bac, et 36 avertissements de mutualisation de manuels sous `bac-math` — du **registre**, pas du contenu.                                 | `content:audit:strict`, `programme:check`   | Déclarer la mutualisation dans le manifeste plutôt que la tolérer en warn                                                                           | S      | NOUVEAU |
| K-4  | 🟢   | Les 43 skills pèsent **43 948 mots** ; `content-audit` (3 433) et `campagne` (3 057) dépassent ce qu'une session lit sans le résumer. `harness:check --corpus` tient le budget par fichier, pas le total.                                    | `wc -w`                                     | Rien d'urgent ; surveiller que les `prof-*` (1 200-1 400 mots) ne dupliquent pas `content-engine`                                                   | —      | NOUVEAU |
| K-5  | 🟢   | `content:overflow:check` exige les navigateurs Playwright du moteur ; dans une session cloud liée par symlink il tombe sur « npx playwright install ».                                                                                      | sortie du gate                              | Lire `PLAYWRIGHT_BROWSERS_PATH` (déjà posé sur la VM) ou sauter avec un message explicite                                                           | S      | NOUVEAU |

### 3.12 Docs, gouvernance, DX & session cloud

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                                                                                                                                  | Preuve                                                                                                        | Action                                                                                                                                                                                                                                                                                                                                             | Effort | Statut       |
| ---- | ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------ |
| G-1  | 🟡   | **STATUS.md dérive encore, et dans les deux sens** : trois « `main` à #N » dans le même fichier (#970, #1010, réel #1022), « 41 skills » pour 43, §6 « re-sondé le 2026-09-09 » sous un en-tête daté du 04 ; et la ROADMAP privée garde F10/F11 « à la main de Mohamed » que STATUS déclare tranchés. #994 le dit : **rien ne garde ce fichier**.                                       | §2.5                                                                                                          | Gate `status:check` **mécanique** (pas sémantique) : l'en-tête doit citer un `#N` à ≤ 10 PR de `main` ; tout chiffre marqué `<!-- count: ls src/features -->` est recalculé ; toute issue citée `#N` ouverte est re-sondée par l'API. Rouge = la PR qui touche `src/` doit toucher STATUS. Et n'écrire les compteurs qu'**une fois** (§6 renvoie à §1) | M      | CONNU (#994) |
| G-2  | 🟡   | **68 % de STATUS.md est du padding** : prettier aligne les tableaux, et des cellules de 3 000 caractères font 250 KB d'un fichier de 81 KB. C'est ce qui rend le topo illisible « d'un coup d'œil » et cher à lire pour une session (≈ 60 k tokens bruts).                                                                                                                                | `sed -E 's/ {2,}/ /g'` → 81 208 o                                                                              | Réécrire §1bis, §3 et §6 en **listes** (une capacité = un titre + 3 puces), garder les tableaux pour les cellules courtes ; ou `.prettierignore` STATUS.md si le format doit rester tabulaire                                                                                                                                                         | M      | NOUVEAU      |
| G-3  | 🟡   | **Le hook de session cloud n'a pas posé Node 24 ici, et ne l'a pas dit en tête.** `CLAUDE_ENV_FILE` vide, nvm absent : la session a tourné en Node 22/npm 10, exactement le piège « Node trop vieux » du pre-push. `etude-cloud-first.md:325-326` affirme « Node 24 par nvm en 6 s, PATH exporté » — vrai sur la surface mesurée, faux sur celle-ci. Le rapport du hook n'a pas été vu dans le contexte. | `env` de la session ; `session-start.mjs:179-184` (cherche `NVM_DIR`, `/opt/nvm`, `~/.nvm`)                     | (1) Première ligne du rapport = version de Node **réellement servie** et si le PATH a pu être exporté ; (2) fallback sans nvm : tarball `nodejs.org` (20 s, marché ici) posé dans `$HOME/.node24` et préfixé au PATH ; (3) l'étude note que la surface SDK/remote n'est pas celle de Claude Code web                                                | S      | NOUVEAU      |
| G-4  | 🟢   | **8 branches distantes sans PR** depuis le 26/08 (contenu vérifié comme sans perte à l'époque) ; deux `report-fix-*` sont sur `main`.                                                                                                                                                                                                                                                    | `git ls-remote`                                                                                               | Supprimer les 8 (un `git push --delete` par nom) — et laisser `auto-pr` + `guard-watch` refuser qu'une branche vive sans PR plus de 7 jours                                                                                                                                                                                                          | S      | CONNU        |
| G-5  | 🟢   | `docs/performance-audit.md` (1 000 lignes) n'est vivant que par son §0 (STATUS §6 le dit) ; `guide-utilisateur.html` date du 2026-07-21, avant é31, é30, é11.                                                                                                                                                                                                                             | STATUS §6 ; §7                                                                                                | Archiver le corps de l'audit perf (garder §0 dans `dette-technique.md`) ; dater le guide dans STATUS §7 comme « à rafraîchir après le pilote Q-9 »                                                                                                                                                                                                  | S      | NOUVEAU      |
| G-6  | 🟢   | Pas de `CONTRIBUTING.md` ni de gabarit de PR/issue dans `.github/` — le protocole vit dans `CONTRIBUER.md` **au privé** et dans AGENTS.md. Pour un dépôt public, un contributeur externe n'a aucune porte d'entrée.                                                                                                                                                                       | `ls .github`                                                                                                  | Un `CONTRIBUTING.md` de 20 lignes qui pointe AGENTS.md et dit que le corpus est privé                                                                                                                                                                                                                                                                 | S      | NOUVEAU      |

### 3.13 Exploitation, observabilité, coûts

<!-- prettier-ignore -->
| #    | Sév. | Constat                                                                                                                                                                                                                                                                    | Preuve                                                          | Action                                                                                                                                                      | Effort | Statut  |
| ---- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------- |
| O-1  | 🟡   | **Le modèle « une issue par garde » n'a pas de lecteur garanti.** Les gardes ouvrent et ferment des issues (5 aujourd'hui), mais rien ne dit qui les lit ni quand : le nightly a été rouge 9 jours **avec** son issue ouverte. Une alerte que personne ne lit rassure.          | #967 (8 commentaires quotidiens identiques) ; #1008             | Un seul canal humain : le relevé du lundi (`engagement-report.yml`) agrège les issues de garde ouvertes > 48 h et **notifie** (mail via `notifications` push ou une issue épinglée) | S      | NOUVEAU |
| O-2  | 🟡   | **`GH_AUTOMATION_PAT` expire le 2026-10-04** (#1002) — il porte `auto-pr`, `automerge`, `regression-guard`, `report-triage`, `rollback-prod`, `upgrade-guard`. Le jour J, la chaîne de merge s'arrête sans rouge (les PR ne s'ouvrent plus). Geste humain, aucune session ne peut le faire. | `.github/workflows/*.yml` (6 usages) ; #1002                    | Poser la date dans STATUS §8 rang 0 ; `guard-watch` peut sonder l'expiration (`GET /user` renvoie `github-authentication-token-expiration`) et ouvrir l'issue 14 jours avant | S      | CONNU   |
| O-3  | 🟢   | Sauvegardes : `db-backup` quotidien 02:30, checkpoint hebdo, rollback testé (9 dispatches verts), `MERGE_FREEZE` sondé /3 h. Solide. Ce qui manque est un **test de restauration** daté dans le runbook.                                                                     | `docs/backup-restore-runbook.md`                                | Une restauration à blanc par trimestre sur le projet TEST, datée dans le runbook                                                                            | S      | NOUVEAU |
| O-4  | 🟢   | Coût Actions : ≈ 1 500 runs/mois, gratuits (dépôt public) ; coût IA plafonné dans le chemin de requête (2 $/j, 20 $/mois BYOK) et journalisé ; PostHog sans quota lu ici.                                                                                                    | §2.3 ; STATUS §3                                                | Rien                                                                                                                                                        | —      | —       |

---

## 4. La dette connue, relue dans le code

`docs/dette-technique.md` (re-vérifié le 2026-08-26), ligne par ligne, contre `main` #1022 :

<!-- prettier-ignore -->
| Ligne de la dette                                            | Ce que le code dit le 2026-09-12                                                                                                              | Verdict          |
| ------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| Trois gros fichiers (dashboard 1 084 · tutor 1 051 · quest 1 005) | `dashboard.server.ts` **623**, `tutor.server.ts` 700, `quest.server.ts` **738** ; le plus proche du plafond est `exercise-player.tsx` **747** | PÉRIMÉ (chiffres) |
| Pas de budget de perf runtime                                | Toujours vrai ; RUM présent, rien ne bloque                                                                                                   | toujours vrai    |
| L'énergie IA n'est jamais rendue par le sweep                | Confirmé dans le corps de `sweep_ai_reservations` (`20260823110000:8-15`) ; **0 pgTAP** sur la fonction                                        | toujours vrai    |
| 10 vues d'ombre RPC restantes (dashboard 7, progression 2, quest 1) | 43 `as unknown as` dans 12 fichiers, dont `ai/` 4, `auth/` 2, `notifications/` 2 — la répartition écrite ne tient plus                       | PÉRIMÉ (à requalifier après D-1) |
| `maxDuration: 300` recopié à trois endroits                  | 6 occurrences sur les 3 fichiers cités                                                                                                        | toujours vrai    |
| jsdom global : 81 % du temps                                 | **67 %** ici (120,6 s / 180 s) — même levier, mesure plus douce sous Linux                                                                    | toujours vrai    |
| 34 des 55 primitives `ui` sans importeur                     | **31** des 55 ; `date-fns`, `lenis`, `@hookform/resolvers` toujours sans référence                                                            | toujours vrai (chiffre à jour) |
| Pont de types `client_errors`                                | Toujours vrai — et 27 autres objets sont dans le même cas (D-1)                                                                               | toujours vrai, sous-estimé |
| Frontière features sans gate, violée 5 fois (ai/exam/tutor)  | **7** violations, `exam` n'y est plus, `duel → quest` est apparu                                                                              | PÉRIMÉ (chiffres) |
| Latent : N+1 `has_parcours_entitlement`                      | Non re-vérifié (dormant par la phase gratuite)                                                                                                | —                |

---

## 5. Ce qui est solide (et qu'il ne faut pas toucher pour « faire mieux »)

- **Le gate est complet et vert**, sous le Node exigé, en 5 minutes : 11 étapes, 4 181 tests,
  90 % de couverture, 0 vulnérabilité, chaîne de migrations rejouable sur base vierge, budgets de
  bundle tenus, coquille prod rendue dans un vrai Chromium. Peu de projets solo ont ça.
- **La base est disciplinée** : RLS sur 68/68 tables, `SET search_path` sur 196/196 fonctions
  `SECURITY DEFINER`, la clé de correction jamais accordée à `anon`, 100 fichiers pgTAP.
- **La sécurité de surface est en place et sondée** : CSP à nonce, HSTS preload, CodeQL requis,
  Actions épinglées au SHA sur les 26 workflows, `handle_new_user` non escaladant.
- **L'i18n est un contrat typé**, pas une convention : 1 279 clés, parité 100 %, arabe traduit à
  100 %, RTL gardé par le lint. C'est rare.
- **Les gardes savent se refermer seules** — trois issues fermées sans geste humain cet
  après-midi. Le défaut n'est pas leur conception, c'est leur **couplage** (C-1) et leur lecture (O-1).
- **La doctrine est écrite et outillée** : DoD, DoE, zero-intervention, journal des décisions,
  dette re-vérifiée, `harness:check` qui refuse la dérive des vues générées.

---

## 6. Plan d'action proposé

Le cadrage de STATUS §8 s'applique : **horloges** (coût calendaire) d'abord, **chantiers**
(coût d'effort) ensuite, et rien qui ouvre de la largeur avant que la profondeur ne soit servie.
Tout ce qui suit est **proposé** ; l'ordre est une préconisation, le propriétaire arbitre.

### ⏱️ Rang 0 — cette semaine (horloges et gestes S)

1. **Débloquer les montées de version** (C-2, C-3) : retirer `vite-tsconfig-paths` au profit de
   `resolve.tsconfigPaths: true` ; rebaser #1016 ; dispatcher `upgrade-guard` sur le nightly vert
   du soir ; un lot isolé pour `vitest`/`@vitest/coverage-v8` 5.
2. **`types.ts` depuis la chaîne + `types:check`** (D-1) — 28 RPC et 3 tables rentrent dans les
   types, le pont `client_errors` tombe, et la moitié des 43 casts avec lui (A-4).
3. **Découpler les automatismes du nightly entier** (C-1) : `upgrade-guard` sur `verify` vert de
   `main`, `checkpoint-tag` sur `CI` + pgTAP ; règle écrite « nightly rouge > 48 h = rang 0 ».
4. **Ménage** : 8 branches distantes (G-4) ; #260 fermée avec le chiffre 18/48 (K-2) ; la clé de
   `math-bac-math/18-probabilites/04-defi` Q5 corrigée au privé (K-1) ; STATUS : en-tête à
   `#1022`, « 43 skills », la date du 18/09 (#979) et celle du 04/10 (#1002) au rang 0 (G-1, U-1, O-2).

### 🎯 Rang 1 — les deux semaines suivantes (chantiers M)

5. **`status:check`** mécanique (G-1) et **dé-tabulariser** STATUS (G-2) : le topo redevient un topo.
6. **Frontière des features** (A-2) : trancher `ai/`, remonter les composants partagés, poser
   `no-restricted-imports` — puis la dette peut fermer la ligne.
7. **Scinder** `exercise-player.tsx` et `quest.server.ts` (A-1) avant qu'un lot ne casse `lint`.
8. **Rate-limit durable** en SQL devant les 8 RPC anonymes (S-1) ; exclure les admins des
   agrégats (S-3).
9. **Hook cloud honnête + fallback Node** (G-3) ; `content:overflow:check` conscient de
   `PLAYWRIGHT_BROWSERS_PATH` (K-5).
10. **Premier rendu mobile** (F-1, F-2, F-3) : chunk i18n par locale, budget « premier rendu »
    avec marge, Lighthouse CI en nightly, cache sur le sitemap.
11. **Tests** : seuil de couverture par fichier (T-2), `test.projects` node/jsdom (T-1), le
    lecteur d'exercice sous axe (T-3/I-2), pgTAP sur `sweep_ai_reservations` (D-3).

### 🔨 Rang 2 — produit, dans l'ordre de la doctrine

12. **`french-6eme`** (X-1) — déjà rang 0 de STATUS §8, toujours vide : c'est la seule ligne de
    contenu que cet audit ose ordonner, parce qu'elle est déjà ordonnée.
13. **M2 → M3 sur le chemin de l'élève** : types natifs, donjon, rappel actif, plan du jour,
    rapport parent — cinq capacités, un critère DoE manquant nommé par capacité avant tout
    nouveau lot ; et une **règle de campagne** « une matière ouverte = cours + résumé + quiz +
    ≥ 1 vidéo par chapitre » (é23 lot 5, 0 vidéo à ce jour).
14. **Plancher de non-QCM** par chapitre neuf dans `content:qa` (X-2).
15. **Pages légales trilingues** (I-1) — c'est aussi la moitié lisible de GAP-003.
16. **Lecture automatique** de `user_misconceptions` et des issues de garde par le relevé du
    lundi (X-3, O-1) — supprimer le besoin de la sonde manuelle.

### 🧑 Ce qui n'attend que l'humain

- **GAP-003 / INPDP** — le dépôt de la déclaration ; la part Claude est livrée.
- **`GH_AUTOMATION_PAT`** à renouveler avant le **2026-10-04** (#1002), et dater
  `CLAUDE_CODE_OAUTH_TOKEN`.
- **A16** (rachat de série à 53 %) — `economy:check` restera rouge tant que ce n'est pas tranché.
- **Lire le verdict du pilote Q-9** vers le 15/09 — c'est une lecture, pas un lot.
- é23 Q-3 (app child-directed chez Google), é24 Q-4 (OTDAV/INNORPI), drill de portabilité é25 L7.

---

## Annexe A — Les 26 workflows du moteur

<!-- prettier-ignore -->
| Workflow                | Déclencheurs                                    | Cron (UTC)      | `permissions` | Timeout | Secrets                                                     |
| ----------------------- | ----------------------------------------------- | --------------- | ------------- | ------- | ----------------------------------------------------------- |
| auto-pr                 | push                                            | —               | oui           | 1/1     | GH_AUTOMATION_PAT, GITHUB_TOKEN                             |
| automerge               | pull_request, push                              | —               | oui           | 2/2     | GH_AUTOMATION_PAT, GITHUB_TOKEN                             |
| checkpoint-tag          | schedule, dispatch                              | lun. 06:00      | oui           | 1/1     | VERCEL_*                                                    |
| ci                      | pull_request, push, dispatch                    | —               | oui           | 1/1     | —                                                           |
| client-errors-watch     | schedule, dispatch                              | /6 h            | oui           | 1/1     | PROD_SUPABASE_SERVICE_ROLE_KEY                              |
| codeql                  | pull_request, push, schedule, dispatch          | lun. 03:17      | oui (job)     | 1/1     | —                                                           |
| db-backup               | schedule, dispatch                              | 02:30           | **non**       | 1/1     | PROD_SUPABASE_DB_URL, TEST_SUPABASE_DB_URL                  |
| db-migrate-prod         | push, schedule, dispatch                        | **toutes les h** | oui           | 1/1     | PROD_SUPABASE_DB_URL                                        |
| db-tests                | pull_request, call, dispatch                    | —               | oui           | 1/1     | —                                                           |
| e2e-auth                | call, dispatch                                  | —               | **non**       | 1/1     | E2E_USER_PASSWORD, TEST_SUPABASE_*                          |
| e2e                     | call, dispatch                                  | —               | **non**       | 1/1     | —                                                           |
| engagement-report       | schedule, dispatch                              | lun. 06:41      | oui           | 1/1     | PROD_SUPABASE_DB_URL                                        |
| freeze-watch            | schedule, dispatch                              | /3 h            | oui           | 1/1     | —                                                           |
| guard-watch             | schedule, dispatch                              | /6 h            | oui           | 1/1     | —                                                           |
| migration-gate          | pull_request, dispatch                          | —               | oui           | **0/2** | —                                                           |
| nightly                 | schedule, dispatch                              | 01:00           | oui (job)     | **0/5** | —                                                           |
| perf                    | call, dispatch                                  | —               | oui           | 2/2     | LOAD_*                                                      |
| regression-guard        | schedule, dispatch                              | lun./jeu. 23:00 | oui           | 1/1     | CLAUDE_CODE_OAUTH_TOKEN, GH_AUTOMATION_PAT                  |
| release                 | push, dispatch                                  | —               | oui           | **0/1** | —                                                           |
| report-apply            | schedule, dispatch                              | 06:37           | oui           | 1/1     | PROD_SUPABASE_SERVICE_ROLE_KEY                              |
| report-close            | pull_request                                    | —               | oui           | 1/1     | PROD_SUPABASE_SERVICE_ROLE_KEY                              |
| report-triage           | repository_dispatch, schedule, dispatch         | /4 h            | oui           | 1/1     | CLAUDE_CODE_OAUTH_TOKEN, GH_AUTOMATION_PAT, PROD_SUPABASE_* |
| rollback-prod           | dispatch                                        | —               | oui           | 1/1     | GH_AUTOMATION_PAT, VERCEL_*                                 |
| second-opinion          | pull_request, dispatch                          | —               | oui           | 1/1     | OPENAI_API_KEY (dormant, `skipped` à chaque PR)             |
| tutor-digests           | schedule, dispatch                              | dim. 05:00      | oui           | 1/1     | CRON_SECRET                                                 |
| upgrade-guard           | workflow_run (Nightly **success**), dispatch    | —               | oui (job)     | 1/5     | CLAUDE_CODE_OAUTH_TOKEN, GH_AUTOMATION_PAT                  |

Toutes les actions sont épinglées au SHA (0 exception, `harness:check` le garantit).

## Annexe B — `npm outdated` (2026-09-12)

Majeures : `typescript` 6.0.3 → 7.0.2 (bloquée, #660) · `vitest` 4.1.10 → 5.0.0 ·
`@vitest/coverage-v8` 4.1.10 → 5.0.0 · `motion` 12.43.0 → 13.2.0 · (`@types/node` : tag
`latest` = 22.x, non pertinent).
Mineures/patch (38) : `@anthropic-ai/sdk` 0.120 → 0.125 · `@supabase/supabase-js` 2.111 → 2.116 ·
`@tanstack/react-query` 5.101.4 → 5.102.8 · `@tanstack/react-router` 1.170.18 → 1.170.35 ·
`@tanstack/react-start` 1.168.34 → 1.168.52 · `@playwright/test` 1.62.1 → 1.63.0 ·
`react`/`react-dom` 19.2.8 → 19.3.0 · `zod` 4.4.3 → 4.6.2 · `vite` 8.2.0 → 8.3.0 · `eslint`
10.8 → 10.10 · `typescript-eslint` 8.65 → 8.70 · `lucide-react` 1.28 → 1.45 · `dompurify` 3.4.13
→ 3.4.15 · `three` 0.185.1 → 0.186.0 (majeure de fait, 0.x) · `@cloudflare/vite-plugin` 1.49 →
1.54 · `lint-staged` 17.2 → 17.5 · et 21 autres de moindre portée.

## Annexe C — Volumétrie du corpus (agrégats, sans extrait)

- `content:check` : 119 sujets validés · 999 chapitres · 4 208 exercices · 25 414 questions ·
  62 compétences (1 famille) · 241 tags de misconception.
- Catalogue : 94 sujets · 6 thèmes · 0 stub · 773 dossiers de chapitre avec cours + résumé.
- Programme : 57 fiches (36 exploitables) · 81/86 sujets présents · 153 œuvres à rattacher ·
  0 parcours à ouvrir.
- Qualité : `content:qa` 0 erreur / 48 avertissements ; `content:audit:strict` 296 constats sur
  27 niveaux ; `programme:check` 36 avertissements ; figures OK ; vidéos : 0.
- Skills : 43 (43 948 mots) ; workflows privés : 11.

## Annexe D — Reproduire les mesures

```bash
# gate, étape par étape, sous Node 24 (voir scratch/gate/run-gate.sh de la session)
for s in eol:check leak:check db:check-chain harness:check perf:check lint typecheck \
         test:coverage build:check smoke:shell audit:deps; do npm run -s "$s"; done
# gates de contenu, depuis un clone du moteur lié au corpus privé
npm run programme:etat && npm run content:check && npm run content:qa:strict \
  && npm run content:audit:strict && npm run programme:check && npm run content:catalogue
# dérive types.ts ↔ migrations : comparer les `CREATE FUNCTION` vivants aux clés
# de `Database.public.Functions` ; imports inter-features : grep `@/features/<x>` hors de `<x>`
```

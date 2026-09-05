# AGENTS.md — yahia-quest-arena (Na9ra Nal3ab)

> **This file is the single canonical source of truth for every contributor — human or AI
> agent, whichever tool.** When it disagrees with any other doc, this file wins — fix the
> other doc. [`ARCHITECTURE.md`](./ARCHITECTURE.md) is the deeper architecture companion;
> `docs/*.md` are topic-specific normative specs; the epic design studies (`FableEtudes/`)
> moved to the private content repo with the corpus (étude 24); per-tool files (`CLAUDE.md`,
> `.github/copilot-instructions.md`, `.gemini/settings.json`)
> are thin pointers to this one — never duplicate rules there. **Project state** (current
> phase, dated decisions, real feature/étude status) lives in [`STATUS.md`](./STATUS.md) —
> read it before trusting any "is X live?" claim.

## What this is

Gamified learning **academy** — a broad catalogue, not a single course. Students do "quests"
(QCM exercises), earn XP/coins, unlock badges, level up hero classes, compete on a leaderboard,
and tackle a timed "dungeon" boss mode. Shonen/RPG manga aesthetic, trilingual (FR/EN/AR, RTL).

**Catalogue hierarchy**: `themes` → `grades` (school theme only, 13 Tunisian levels) →
`subjects` → `chapters` → `exercises` → `questions`. A **parcours** is the student's enrolled
track (`(theme, grade)` pair) — ~35 total, kinds `concours`/`scolaire`/`libre`.
**Free phase (current)**: since the 2026-06-21 pivot, the app is **100 % free** — every
parcours has `is_premium = false`, no mission is gated. The entitlement/paywall machinery
stays in code but **dormant** (étude 01, gelée, is the re-activation vehicle). No user-facing
surface may say "premium/abonnement/payant" during this phase.

**Stack**: Vite 8 · TanStack Start (SSR + file routing + server fns) · React 19 · TanStack
Query 5 · Supabase (Postgres + Auth + RLS) · Tailwind 4 / Radix-shadcn · deploys to **Vercel**
(push to `main` = prod). npm (**Node 24** — `.nvmrc` + les 10 workflows ; ce fichier a longtemps
annoncé 22, et la Content CI privée l'a suivi). Tests: Vitest 4 + Testing Library, Playwright (e2e).

## Essential commands

```bash
npm run dev          # Vite dev server (SSR)
npm run build        # production build
npm run build:check  # build + bundle-budget check
npm run smoke:shell  # prod-bundle browser smoke: public shell must render crash-free
npm test              # vitest run
npm run lint          # eslint src --max-warnings=0  (zero-warning policy)
npm run typecheck     # DEUX programmes : l'app (src/**) ET les scripts (tsconfig.scripts.json)
npm run verify         # les 4 gates à ~2 s d'abord (eol/leak/db:check-chain/harness), puis lint + typecheck + test
npm run ci:verify      # verify en surensemble : + perf:check, coverage au lieu de test, build:check, audit:deps en dernier
npm run harness:check                    # anti-drift harness (pointers, size, hidden Unicode, model ids) + YAML strict de .github/**
npm run leak:check                       # gate anti-fuite : aucun corpus ni skill pédago au tip (étude 24)
npm run db:check-chain                   # rejeu statique des migrations : une base VIERGE se reconstruit
npm run eol:check / eol:fix              # CRLF invisibles dans l'arbre (piège Windows, docs/agents/poste-windows.md)
npm run db:inventory-content             # inventaire des migrations de contenu (provenance)
npm run programme:etat                   # état des lieux campagne : fiche × programme × contenu × ouverture prod (rapport, pas un gate)
```

⚠️ Les commandes `content:*` / `programme:*` existent toujours (le moteur est ici) mais n'ont
plus de données ici — elles tournent depuis le repo privé. E2E vise un projet Supabase TEST dédié
([`e2e/README.md`](./e2e/README.md)), jamais la prod. Hooks husky : `pre-commit` lance
lint-staged, `pre-push` lance `verify` — jamais de `--no-verify`.

## Data model & access

Modèle complet, table par table : [`ARCHITECTURE.md`](./ARCHITECTURE.md) §8. La colonne
vertébrale est `profiles` + la hiérarchie `themes → grades → subjects → chapters → exercises →
questions`, plus `attempts`. La logique serveur vit en SQL (`handle_new_user`, `award_xp`,
`submit_exercise_attempt` — les deux privilégiées sont `REVOKE`d de anon/authenticated).
**L'accès se décide côté serveur, uniquement**, par `resolve_exercise_access` : la clé de réponse
(`correct_option`, `distractor_tags`) n'est **jamais** envoyée au client, phase gratuite ou non.
Seuils de gameplay : `src/shared/constants/gamification.ts` (c'est là qu'on change les règles).

## Content pipeline — le corpus n'est PAS dans ce repo (étude 24)

Depuis la scission du 2026-07-20, **le corpus et l'usine qui le produit vivent dans le repo privé
[`MBeji/yahia-quest-content`](https://github.com/MBeji/yahia-quest-content)** : `content/`, les
43 skills pédagogiques, `FableEtudes/` (dont la ROADMAP) et les workflows de contenu. Ne reste
ici que le **moteur**, générique et sans corpus (`scripts/content/**`, `src/shared/content/**`),
les 5 skills techniques et `STATUS.md`. Le moteur est public et testé ici ; c'est lui que la
Content CI privée checkout — y compris pour `harness:check --corpus`, qui garde le corpus avec
les invariants d'ici (étude 32).

**Pour écrire du contenu** : ouvrir la session sur le repo **privé** et y ajouter celui-ci
(`add_repo`). Les gates de contenu tournent dans la Content CI privée, plus ici.

⚠️ **Ne re-commite jamais de corpus ici.** `npm run leak:check` fait **échouer** le gate si
`content/**`, `sql/content/**`, un skill `content-*`/`prof-*` ou une migration de contenu
**générée** réapparaît au tip. Le contenu ne voyage plus en migrations : il se compile en
`sql/content/<subject>.sql` et s'applique par le workflow privé `apply-content.yml`.

Tout le reste — le miroir `.agents/skills/`, les 17 migrations de contenu écrites à la main, le
gate `check-roadmap-sync` qui vérifie que la roadmap privée connaît les lots livrés ici —
est dans [`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md).

## Conventions

- Feature-based: `src/features/{name}/` (16 — ai, auth, bug-report, content-report, dashboard,
  dungeon, duel, exam, notifications, parcours, parent-report, progression, quest, shop,
  subscription, tutor ; `harness:check` échoue si cette liste dérive de `src/features/`).
  Each has `index.ts` (barrel), `{name}.server.ts`, `__tests__/`.
  **Features never import other features** — share via `src/shared/`. Routes stay thin.
- Import aliases: `@/features/{name}`, `@/shared/lib|constants|types|integrations/...`.
  UI primitives: `@/components/ui/*` (no `@/shared/ui`). i18n: `@/lib/i18n`. Mobile hook:
  `@/hooks/use-mobile`. `useAuth`: `@/features/auth`.
- Every server fn carries an auth middleware — `requireSupabaseAuth`, ou `optionalSupabaseAuth`
  pour une lecture publique assumée ; c'est ce que la règle `local/require-server-fn-auth` exige.
  Un `.inputValidator` zod dès qu'il y a une entrée (non gaté : sans lui `data` est `undefined`).
  Sanitize HTML with DOMPurify (`src/shared/lib/markdown.ts`).
- Naming: kebab-case files, server fns are verbs. Structured logging via
  `@/shared/lib/logger` (redacts secrets) — never raw `console`.

## Definition of Done

A change is **done** only when ALL of these hold — non-negotiable:

1. **Gate is green.** `npm run verify` (release-grade: `npm run ci:verify`). Never report done
   on a red gate.
2. **No weakening the gate.** No `@ts-ignore`/`as any` to dodge types, no inline ESLint
   disables, no lowered coverage thresholds, no `--no-verify` without explicit sign-off.
3. **No new tech debt.** No compat shims, no dead code. Respect feature/shared boundaries.
4. **Types are real.** `tsc` passes. Supabase types are generated — prefer regenerating.
5. **Tests travel with code.** Co-located in the feature's `__tests__/`. Coverage never regresses.
6. **Small, reviewable commits.** Branch off `main`; conventional-commit messages.
7. **DB ↔ code coordinated — prod migrations auto-apply, never by hand.** Merging to `main`
   auto-applies `supabase/migrations/**` via `db-migrate-prod.yml` (backup + guard + `db push`;
   hourly reconciliation catches anything missed). Never run `supabase db push`/`db reset`
   against prod manually. Additive migrations land before the code that uses them; ship
   **destructive** migrations (DROP/REVOKE) in a separate merge, after the old code path is gone.
8. **A pushed branch is the session's PR to land.** The push opens the PR ready with auto-merge
   armed; it merges alone once required checks are green on an up-to-date head — nobody reads,
   readies, or merges by hand. The session that pushed **stays on duty until the merge is real**:
   watch checks, fix reds, confirm the merge, then **close the session clean** (checklist below).
   Savepoint = **préfixe de branche** `wip/`/`draft/`/`rescue/`, jamais `[wip]` dans le sujet de
   commit (ça fuit dans `main`, deux fois le 2026-07-20 : un squash titre sur le sujet de `HEAD`,
   et l'auto-merge fige le message en s'armant). Vérifier `git log -1 --pretty=%s` avant de
   pousser ([`collaboration.md`](./docs/agents/collaboration.md)).

Full detail on §7/§8: [`docs/ci-cd-and-branch-protection.md`](./docs/ci-cd-and-branch-protection.md), [`docs/passation.md`](./docs/passation.md) — its §7 is the session-close checklist.

**Definition of Excellence — le pendant PRODUIT du DoD** (étude 26). Le DoD dit que le code est
sain, la **DoE** que l'expérience est complète. **Profondeur avant largeur** : approfondir
l'emporte **par défaut** sur ouvrir, et une ouverture se gèle par écrit faute d'arbitrage humain.
Ses 8 critères, la grille M0-M4, la doctrine IA : [`docs/doctrine-verticale.md`](./docs/doctrine-verticale.md).

## Execution policy

Règle qui gouverne cette section : **zéro intervention technique du propriétaire**
([`docs/agents/zero-intervention.md`](./docs/agents/zero-intervention.md)) — une demande de
permission est une validation manuelle.

**Source de vérité : [`harness/policy.json`](./harness/policy.json)**, qui porte les règles PAR
FAMILLE, une raison sur chaque famille et sur chaque déni. `npm run harness:sync` la compile en
vues par outil (jamais éditées à la main) ; `harness:check` fait échouer la CI sur une dérive ou
sur une famille sans raison. Le **journal daté** des élargissements — pourquoi `rebase` est
dehors, pourquoi `apply-content` est l'exception assumée, pourquoi `gh secret delete` est dénié —
vit dans `zero-intervention.md` § « Le journal des élargissements ».

En deux lignes : depuis le **2026-09-05, tout est autorisé** (arbitrage du propriétaire, option C
de l'étude cloud-first — famille `cloud-autonomy` : `Bash`, tout le serveur MCP `github`, les
sessions cloud, Google Drive ; « je prends le risque », écrit au journal) ; les familles nommées
restent la carte de ce qu'une session fait, et les dénis gagnent toujours. Les sessions démarrent
en `acceptEdits` (`permissions.defaultMode`) : sans classifieur, ce sont ces règles qui décident. **Jamais** :
`supabase db push`/`db reset`, `node scripts/db/push-prod.mjs`, `gh secret delete`, et par `gh`
le dispatch de `db-migrate-prod.yml` ou `release.yml` — en cloud, l'outil MCP de dispatch ne
connaît pas les noms : là, c'est la règle écrite qui tient, pas la policy.

⚠️ Ceci lève les demandes **du dépôt**, pas les refus du classifieur d'auto-mode de l'outil. Pour
les outils sans fichier de permissions, cette section est une indication : le filet dur reste les
hooks husky, les checks requis, et l'absence de credentials de prod en local.

## Multi-agent collaboration

Several AI agents (and humans) may work this repo concurrently. Branch prefix identifies the
author (`claude/…`, `codex/…`, `humain/<pseudo>/…`); one lot/task = one PR touching a distinct
file set — see `FableEtudes/CONTRIBUER.md` **in the private content repo** for the reservation
protocol. The PR is the only coordination point: no side-channel memory, no private state.
Any project-relevant knowledge discovered in a session (a gotcha, a process rule) belongs in
this repo (this file, `STATUS.md`, `docs/agents/`) — not only in a tool's private memory.

## Documentation map

| Doc                                                                            | Role                                                                                                                                                                                                                                                                                                                                         |
| ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`ARCHITECTURE.md`](./ARCHITECTURE.md)                                         | Stack, directory structure, data model, deployment — the deep companion to this file                                                                                                                                                                                                                                                         |
| [`STATUS.md`](./STATUS.md)                                                     | Central topo: phase, dated decisions, real feature/étude status                                                                                                                                                                                                                                                                              |
| [`docs/doctrine-verticale.md`](./docs/doctrine-verticale.md)                   | **Doctrine produit** (étude 26) : profondeur avant largeur, grille M0-M4, Definition of Excellence, règle d'arbitrage, doctrine IA-native                                                                                                                                                                                                    |
| `FableEtudes/` (repo **privé**)                                                | Epic design studies (architect → executor contracts) — parties au privé avec le corpus (étude 24)                                                                                                                                                                                                                                            |
| [`docs/content-generation-pipeline.md`](./docs/content-generation-pipeline.md) | Content pipeline spec (French) — le moteur est ici, le corpus est au privé                                                                                                                                                                                                                                                                   |
| [`e2e/README.md`](./e2e/README.md)                                             | Playwright runbook (dedicated TEST project)                                                                                                                                                                                                                                                                                                  |
| [`docs/prod-rollback-runbook.md`](./docs/prod-rollback-runbook.md)             | **Incident prod**: geler la chaîne (`MERGE_FREEZE`), rollback Vercel, revert, checkpoints hebdo, l'axe base de données                                                                                                                                                                                                                       |
| [`docs/baseline-snapshot-runbook.md`](./docs/baseline-snapshot-runbook.md)     | **Bascule système**: figer les 3 dépôts + l'état vivant (base, déploiement, config) en un point de retour daté `baseline/*`                                                                                                                                                                                                                  |
| [`docs/journal-decisions.md`](./docs/journal-decisions.md)                     | Registre **append-only** des décisions datées — STATUS.md ne garde que celles qui gouvernent encore                                                                                                                                                                                                                                          |
| [`docs/dette-technique.md`](./docs/dette-technique.md)                         | Code debt still genuinely open — chaque item re-lu dans le code avant d'être listé (re-vérifié 2026-08-26)                                                                                                                                                                                                                                   |
| [`docs/performance-audit.md`](./docs/performance-audit.md)                     | Perf findings + phased roadmap; its load harness is [`perf/README.md`](./perf/README.md)                                                                                                                                                                                                                                                     |
| `docs/*.md`                                                                    | Topic specs: CI/CD, dependency cadence, env vars, logging, XSS policy, **surfaces & couleurs** (`design-surfaces.md`), content voice, release tagging, lycée architecture, question types, suivi parental quotidien; player guides (`guide-duels-et-ligues`, `guide-rappel-actif`, `guide-types-questions-natifs`, `guide-utilisateur.html`) |
| [`docs/agents/`](./docs/agents/README.md)                                      | **Operational playbooks**: **zero manual intervention by the owner** (`zero-intervention.md` — the rule, and the walls it names), Windows-workstation traps, multi-agent collaboration, content-campaign conduct                                                                                                                             |
| [`docs/archive/`](./docs/archive/README.md)                                    | Dated one-shot audits, kept for the record — never a backlog. A one-shot lands there the day it is handled or outdated                                                                                                                                                                                                                       |
| `harness/*.json`                                                               | Model roles, execution policy (source of truth for the generated per-tool views)                                                                                                                                                                                                                                                             |

## Known gotchas / traps

- **Fichiers générés, jamais édités à la main** : `src/routeTree.gen.ts`,
  `src/shared/integrations/supabase/types.ts`, `.agents/skills/**`, `.claude/settings.json`.
- **Migrations** : une table neuve a besoin de ses `GRANT` explicites ; une migration doit trier
  **après** la plus récente sur `main` ; et **la prod n'est pas le juge de la
  reconstructibilité** — `db:check-chain` rejoue la chaîne, `db-tests.yml` tourne sur les PR mais
  **n'est pas requis**. Les trois pièges en détail :
  [`docs/agents/pieges-du-code.md`](./docs/agents/pieges-du-code.md).
- **Un refus d'auth se déclare dans `auth-refusals.ts`, jamais ailleurs** — message ET conduite
  client. Le `Record<AuthFailure, …>` fait échouer `tsc` sur un refus sans sa ligne ; deux listes
  tenues à la main ont divergé deux fois (#931 ; #914/#915). Jamais de message en dur.
- **E2E ≠ unit gate.** Playwright vise un projet Supabase TEST dédié, pas des mocks ; hors de
  `verify`/`ci:verify` ; jamais pointé sur la prod.
- **La CI n'est pas exactement `verify`** : elle ajoute `build:check` et `smoke:shell` (seul étage
  qui exécute le bundle prod dans Chromium) et n'a pas `eol:check`. Un gate local vert ne
  garantit pas une CI verte ; `ci:verify` en est le miroir le plus proche.
- **Les dépendances mentent de deux façons** : `audit:deps` interroge le registre au moment du
  run, donc à lockfile constant le même commit passe le matin et échoue l'après-midi — et c'est
  **toute la file** qui bloque ; et le titre d'une PR Dependabot peut mentir sur son diff (#716 :
  « bump undici · indirect » montait une majeure et une alpha). Les deux sont mécanisés et
  expliqués dans [`docs/dependency-maintenance.md`](./docs/dependency-maintenance.md).
- **La couverture est cadrée sur le code possédé** (`features/`, `shared/`, `lib/`, `hooks/`) —
  UI vendue, glue de route, fichiers générés et tout `features/**/components/**` sont exclus par
  choix ; ne pas élargir `include` pour diluer.

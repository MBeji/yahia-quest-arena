---
name: upgrade-guard
description: >-
  Nightly stack-upgrade sweep for yahia-quest-arena. From a KNOWN-GREEN baseline
  (runs after the nightly build passes), it detects available upgrades across the
  whole stack — npm runtime + dev dependencies, the language (TypeScript), the Node
  toolchain, the pinned Supabase CLI, and GitHub Actions — splits them by risk, and
  applies them: patch/minor as ONE lot (auto-merged by the workflow only when the
  full gate + E2E + pgTAP are green), and each MAJOR in isolation on its own branch
  (one PR per major, never bundled — or a tracking issue when its gate stays red).
  It runs `npm run ci:verify` in-session, never weakens the gate, and never merges
  anything itself. Use when asked to "monter la stack", "mettre à jour les
  dépendances", "migrer vers les dernières versions", "check des versions à jour",
  or on a schedule after the nightly. Defers to `verify` (the gate), `code-review`
  (is the upgrade change correct?), and `regression-guard` (which keeps the tests
  honest earlier in the night).
---

# Upgrade guard — keep the stack current, safely, every night

This skill is the **stack-upgrade counterpart** of `regression-guard`. Where the
regression guard keeps the _tests_ honest with the day's code, the upgrade guard
keeps the _dependencies and toolchain_ current with upstream — without ever
trading away a green gate or a human review of a breaking change.

It produces reviewable artifacts only:

- a **patch/minor PR** whose in-session gate is green (the workflow then runs the
  slow suites and auto-merges it if they pass too);
- **one PR per major** that it could make green (labelled `needs-review`, never
  auto-merged — a human reads the changelog and merges);
- a **tracking issue** for every major it could _not_ make green, instead of a
  broken PR.

> **The rules that must never bend.**
>
> 1. **Never weaken the gate to go green.** No `// @ts-ignore` / `as any`, no
>    disabling ESLint inline, no lowering coverage thresholds, no `--no-verify`,
>    no removing a failing test. If an upgrade breaks the gate, you either fix it
>    _properly_ (codemod / config / call-site change the changelog prescribes) or
>    you back that package out of the lot. (CLAUDE.md Definition of Done.)
> 2. **Never merge, never push to `main`.** You only push `claude/upgrade-*`
>    branches and open PRs/issues — exactly like `regression-guard`. The
>    deterministic auto-merge of a fully-green patch/minor PR is done by the
>    workflow's `automerge` job, never by you.
> 3. **One major per PR. Never bundle two majors.** That is the hard-won lesson of
>    the risk-split dependabot lots (PR #124 dev-tooling vs #125 runtime). A bundled
>    major lot fails as a unit and tells you nothing.
> 4. **Only ever from a green baseline.** This runs _after_ a successful nightly,
>    on a clean `main`. If `main` isn't green / clean, stop and report — don't
>    build upgrades on a red base.

## When this runs

- **Scheduled (primary):** the `upgrade-guard.yml` workflow triggers on
  `workflow_run` _after_ the **Nightly tests** workflow completes **successfully**
  (≈01:00 UTC / 02:00 Tunisia). So it only ever upgrades from a night that already
  passed E2E + pgTAP — "juste après la CI et les tests E2E complets".
- **On demand:** `workflow_dispatch`, or invoke `/upgrade-guard` locally. Run
  locally, you stop after opening the PR(s)/issue(s); let CI/the nightly run the
  slow suites, or run them yourself (`npm run test:e2e`, `e2e:setup` + `test:e2e:auth`,
  `supabase test db`).

In CI the workflow exports a result file (`$UPGRADE_GUARD_RESULT`, JSON) that
downstream jobs read to decide what to validate and auto-merge — write it (schema
at the end). When the env var is unset (local run), skip the file.

> **En CI, le lot patch/minor ne t'appartient plus** (étude « IA → déterministe »,
> lot L4). C'est une procédure fermée, donc un **script** :
> `scripts/deps/apply-patch-minor.mjs` détecte, applique dans les ranges, passe le
> gate et ouvre la PR — sans agent et sans jeton. Le workflow ne te réveille que
> pour ce qui demande un jugement :
>
> 1. **les majors** — lire un changelog, migrer un breaking change (§3, §5) ;
> 2. **un lot patch/minor rouge** — corriger proprement _ou_ écarter le paquet
>    fautif (`--hold`), l'arbitrage que le script ne peut pas rendre (§4).
>
> Le script écrit un **plan** (`upgrade-plan.json`) : `majorGroups` te donne tout ce
> que les ranges déclarés n'atteignent pas, **déjà groupé** (le set TanStack = un
> groupe, un runtime avec ses `@types`) — majors franches comme lignes 0.x, le champ
> `boundary` de chaque paquet fait la différence ; `patchMinor`/`excluded` sont du
> contexte. En session locale, tu peux piloter le script toi-même (§4) — c'est le
> même chemin.

## Workflow (do these in order)

### 1. Confirm the baseline is green and clean

- You are on `main`, post-nightly-success. Verify: `git status --porcelain` is empty,
  `git rev-parse --abbrev-ref HEAD` is `main`, and `npm ci` then `npm run verify`
  is green on the untouched tree. If the baseline is already red, **stop** and open
  an issue saying so — do not stack upgrades on a broken base.
- Confirm the toolchain: **`npm -v` must be 10.x** (the lockfile trap — npm 11
  rewrites native bindings and breaks `npm ci` on Linux CI). If it isn't,
  `npm i -g npm@10` before touching the lockfile. Node is 22 (matches CI).

### 2. Detect available upgrades across the whole stack

Gather, don't apply yet. Classify each into **patch**, **minor**, or **major**.

- **npm dependencies (runtime + dev) — the bulk.** In CI, **déjà fait** : lis
  `upgrade-plan.json`, écrit par le script (§4). La sémantique, pour la comprendre ou
  la refaire en local (`npm outdated --json || true` — il sort non-zéro dès qu'un
  paquet est en retard, c'est normal) : chaque paquet reporte `current`, `wanted` (le
  max autorisé par le range `^` = dernier patch/minor) et `latest` (le plus récent
  dans l'absolu) :
  - **patch/minor lot** = tout amener à `wanted` — exactement ce que fait
    `npm update` dans les ranges existants. **C'est le périmètre du script.**
  - **majors** = tout paquet dont `latest` dépasse `wanted`, c'est-à-dire que le range
    déclaré ne peut pas l'atteindre sans éditer `package.json` : franchissement de major
    (`^1.9.0` n'atteint pas 2.0.0) **ou ligne 0.x** — la règle caret de npm borne
    `^0.185.0` à `<0.186.0`, donc un `three` 0.186 est major-class malgré son numéro de
    minor (idem pour un range `~` ou un pin exact). **C'est ton périmètre**, et le script
    te les livre groupées, chacune avec son `boundary` (`major`/`minor`/`patch`) pour
    dimensionner la lecture du changelog.
- **Language — TypeScript.** It's the `typescript` devDep, so it rides the npm
  grouping above (a TS minor is in the patch/minor lot; a TS major is its own major PR).
- **Node toolchain.** Compare the CI `node-version: 22` (in the workflows) and any
  `engines`/`.nvmrc` against the current Node LTS line. A new LTS is **major-class** —
  never silently bump the CI Node in the patch/minor lot; open a dedicated PR/issue.
- **Supabase CLI pin.** It is **pinned** to `2.106.0` in `db-tests.yml` and
  `e2e-auth.yml` for a reason (an unpinned bump silently dropped local-stack grants
  for 5 nights). Treat a newer CLI as a **major** with its own PR that must show a
  green pgTAP run. See the trap list.
- **GitHub Actions.** Every `uses:` is **pinned to a commit SHA**, with its version as a
  trailing comment (`actions/checkout@9c091bb… # v7`) — étude 25 lot 5b. Read the current
  majors from the comments rather than from this list, which would rot; resolve a new SHA
  with `gh api repos/<owner>/<repo>/commits/<tag> --jq .sha`. Bumping an action means
  replacing **both** the SHA and its comment — never revert a `uses:` to a moving tag.
  A new action **major** is its own PR (read its migration notes); patch/minor of an
  action you may fold into the patch/minor lot. Note that Dependabot covers npm only:
  Actions are a separate supply chain, and this sweep is what keeps them current.

If nothing is outdated anywhere: write `has_patch_minor=false`, open nothing, and
emit a short "stack already up to date — here's what was checked" summary. Silence
is not a pass. (En CI, le script émet déjà ce constat dans le résumé du job pour le
périmètre npm — reste à ta charge le hors-npm : Node, CLI Supabase, Actions.)

### 3. Read the changelogs before you touch anything risky

For every **major** (and any minor with a known-spicy history), fetch and read the
upstream release notes / migration guide (WebFetch / WebSearch) and note the
breaking changes and prescribed codemods. You will paste that summary into the PR
(or the issue, if it ends up red). Don't upgrade a major you can't find notes for —
report it for human review instead.

### 4. Le lot patch/minor : un script, pas toi

**En CI, cette étape est déjà faite quand tu démarres** — par
`scripts/deps/apply-patch-minor.mjs` (lot L4). Ce qu'il fait, à l'identique chaque
nuit : `npm outdated` → `npm update` vers `wanted` (dans les ranges, aucun
franchissement de major) → **full** `npm install` pour normaliser
`package-lock.json` (jamais `--package-lock-only`) → `npm run ci:verify` → une PR
titrée `chore(deps): patch & minor upgrades <date>`, labellée `dependencies`, avec
le tableau de tous les bumps.

Deux pièges du dépôt ne sont plus des consignes mais des **assertions** dans le
script (il s'arrête plutôt que de produire un lockfile cassé) : **npm 10, jamais
11**, et le bloc `overrides` (le pin de sécurité esbuild global) **inchangé**.

En **session locale**, pilote-le au lieu de refaire les gestes à la main :

```bash
node scripts/deps/apply-patch-minor.mjs detect --out /tmp/plan.json --pr-body /tmp/body.md --date $(date +%F)
node scripts/deps/apply-patch-minor.mjs apply --plan /tmp/plan.json
npm run ci:verify
```

**Ce qui reste ton arbitrage — le lot rouge.** Si `ci:verify` échoue sur le lot, le
workflow a poussé la branche en **PR draft `needs-review`** (`has_patch_minor=false`,
donc aucun auto-merge) et t'a réveillé. Deux issues, jamais une troisième :

- l'ajustement est correct et prescrit par le changelog → **corrige proprement**,
  pousse, puis `gh pr ready` + retire `needs-review` et écris
  `has_patch_minor=true` + branche + PR dans le fichier de résultat (les suites
  lentes et l'auto-merge reprennent la main) ;
- le paquet est risqué ou incompris → **écarte-le du lot** et garde le reste :
  `detect --hold <pkg>` puis `apply` sur un arbre propre, en consignant
  « held back: <pkg>, raison » dans le corps de la PR.

Ne jamais affaiblir le gate pour passer au vert. Si même en écartant des paquets le
lot ne passe pas, laisse la PR en draft `needs-review` avec l'explication : un humain
reprend.

> **Type-defs** : `npm update` garde `react`+`react-dom`+`@types/react`(+`-dom`) et
> `three`+`@types/three` alignés dans le même lot ; le script les groupe aussi côté
> majors (`majorGroupOf`). Vérifie quand même qu'ils ne se sont pas séparés.

### 5. Apply each major in isolation → one PR each, or an issue

For **every** major, independently (never two in one branch):

- Branch `claude/upgrade-major-<pkg>-v<to>-$(date +%F)`.
- Install just that major (`npm install <pkg>@<latest>`; full lockfile install),
  apply the codemod / call-site changes the changelog prescribes (step 3), keeping
  type-defs and tightly-coupled siblings together — **the TanStack set
  (`@tanstack/react-router` + `react-start` + `router-plugin` + `react-query`) moves
  as one logical major PR**, not four.
- Run `npm run ci:verify` in-session.
  - **Green →** push, open a PR `chore(deps): upgrade <pkg> v<from> → v<to>`, labelled
    `dependencies` + `major` + `needs-review`. Body: the breaking-changes summary, the
    code changes you made, and the in-session gate result. State clearly: **majeur —
    revue de changelog requise, NON auto-mergé** — and tell the reviewer how to run the
    full non-regression suite on the branch before merging (Actions → run **E2E** /
    **E2E (authenticated)** / **DB integration tests** via "Run workflow" on this branch),
    since a bot-opened PR doesn't auto-trigger those slow suites. Record it in `majors_pr`.
  - **Red after a reasonable effort →** do **NOT** open a broken PR. Open a tracking
    **issue** `⬆️ Major dispo: <pkg> v<to> (gate rouge)` with the breaking changes,
    exactly what failed (assertion / type error / build error), and a recommendation
    to schedule a dedicated upgrade session. Discard the branch. Record it in
    `majors_issue`.

### 6. Summarise

Emit a short job-log summary: what was checked, the patch/minor outcome, each major's
disposition (PR # / issue #), and anything held back. Write the result file (step 7).

## Known traps (this repo) — honour every one

These are paid-for lessons; violating them re-breaks production or the gate.

- **npm 10, not 11, for the lockfile; full install.** npm 11 rewrites cross-platform
  native bindings → `npm ci` fails on Linux CI. Regenerate with npm 10 and a real
  `npm install`, never `--package-lock-only`. Validate `npm ci` succeeds afterwards.
- **Keep the esbuild override; make it _global_ on Vite 8.** Today it's
  `overrides.vite.esbuild` (Vite 7). If you take **Vite to v8**, the security pin must
  become a **top-level** `overrides.esbuild` or it won't apply. Never drop it.
- **eslint-plugin-react-hooks v7:** its `recommended` config now bundles the React
  Compiler rules. Don't spread `recommended` — set the classic hook rules explicitly,
  or the whole `src/**` lights up. (Major: handle in its own PR.)
- **eslint-plugin-react-refresh on routes:** newer versions stop treating
  `export const Route = createFileRoute(...)` as a component → `only-export-components`
  errors across `src/routes/**`. The fix is to **disable that rule for `src/routes/**`**
  — NOT `allowExportNames: ["Route"]`(that reclassifies`Route` and trips the same
  error; that path was a closed dead-end, PR #122).
- **Do NOT "optimise" `motion` here.** Swapping `motion` → `m` + `LazyMotion` shrinks
  the bundle but creates a circular vendor chunk = **prod-crash risk**. A plain
  `motion` version bump is fine; the `m`/LazyMotion refactor is out of scope and needs
  dedicated chunking, not this nightly.
- **The inline Vite config (ex-meta-plugin).** The vendored meta-plugin was de-vendored
  (2026-06-15) into a hand-composed `vite.config.ts` (Vite/TanStack-Start/Cloudflare/Tailwind
  scaffold + hand-tuned `manualChunks`). Never reintroduce a meta-plugin or add a plugin
  that's already wired, and treat any Vite / `@vitejs/plugin-react` /
  `@tailwindcss/vite` / `@tanstack/router-plugin` / `@cloudflare/vite-plugin` major as
  **high-risk, own-PR, needs-review** — they can break the hand-composed plugin order or
  the Worker build, and duplicate/reshaped plugins (incl. `manualChunks`) can create a
  circular vendor chunk (prod-crash risk). Re-run `build:check`.
- **New Supabase CLI = validate pgTAP.** Bumping `supabase/setup-cli` version can drop
  default table grants on the local stack. If you bump it, the major PR must show a
  green pgTAP run (`db-tests.yml`) and keep the explicit `baseline_table_grants` intact.
- **`content:qa:strict` lives in `ci:verify`, not `ci.yml`.** The in-session
  `ci:verify` you run already covers it — don't assume the PR's `ci.yml` did.
- **Upgrades never re-author content.** If a bump touches the content pipeline
  (`src/shared/content/**`, `scripts/content/**`, the Zod schema), keep behaviour
  identical: the **combined-source rule** for school content — official CNP =
  **teacher guide + manuel élève** (student textbook = indispensable complement;
  one source ⇒ reference, several ⇒ combine all), defined in `content-ecole-tn`
  and its `programmes-officiels/` README — must still hold. A migration that would
  weaken or drop it is **out of scope** for an upgrade; flag it, don't absorb it.

## Division of labour (skill vs workflow)

- **Le script (`scripts/deps/apply-patch-minor.mjs`)** : tout le lot patch/minor —
  détection, split patch/minor vs majors groupées, application dans les ranges, puis le
  plan et le corps de PR. Zéro token, aucun jeton Claude requis, verdict identique à
  chaque exécution (lot L4).
- **You (the skill):** the parts that need judgement — the **majors** (changelog,
  migration, one PR per group) and a **red patch/minor lot** (fix properly vs hold
  back). You run the **fast** gate (`ci:verify`), open PRs/issues, write the result
  file. You never run the slow suites in CI and you never merge.
- **The workflow (`upgrade-guard.yml`):** on the patch/minor branch you produced, runs
  **E2E (public) + E2E (authenticated) + pgTAP** by reusing `e2e.yml` / `e2e-auth.yml` /
  `db-tests.yml`, then the `automerge` job squash-merges the patch/minor PR **only if all
  three are green**. Majors are never touched by `automerge`.

## Result file schema (`$UPGRADE_GUARD_RESULT`, write only when the env var is set)

```json
{
  "has_patch_minor": true,
  "patch_minor_branch": "claude/upgrade-patch-minor-2026-06-16",
  "patch_minor_pr": 130,
  "held_back": [{ "package": "some-dep", "reason": "broke typecheck, needs follow-up" }],
  "majors_pr": [{ "package": "vite", "from": "7.3.1", "to": "8.0.0", "pr": 131 }],
  "majors_issue": [
    {
      "package": "react",
      "from": "19",
      "to": "20",
      "issue": 88,
      "reason": "RSC change breaks router SSR"
    }
  ],
  "summary": "1 patch/minor lot (green), 1 major PR (vite), 1 major issue (react)."
}
```

`has_patch_minor` is `true` **only** when you produced a patch/minor branch whose
`ci:verify` is green and opened its PR — that is the single signal the workflow uses
to run the slow suites and consider auto-merge.

## Guardrails (recap)

- Green baseline only; never weaken the gate; never merge/push to `main`.
- One major per PR; type-defs and tightly-coupled siblings (TanStack set) move together.
- Honour every repo trap above. When an upgrade's required change is non-trivial, lean
  on `code-review` to confirm the change is correct, and `verify` for the gate.
- When unsure whether a failure is "my upgrade is wrong" vs "a real latent bug surfaced",
  treat it like `regression-guard` does: report it, don't paper over it.

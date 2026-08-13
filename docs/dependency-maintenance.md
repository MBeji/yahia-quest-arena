# Dependency Maintenance Cadence

## Goal

Keep runtime and dev dependencies secure and up to date with predictable operational risk.

## Cadence

- **Twice-weekly (automated): the upgrade guard** (Tue + Fri UTC) — see "Automation"
  below. This is the **single owner of routine version bumps**; the manual cadence
  below is the fallback / oversight layer.
- **Dependabot is security-only.** `.github/dependabot.yml` sets
  `open-pull-requests-limit: 0` on both ecosystems, which disables Dependabot's
  routine _version_-update PRs (now owned by the guard, to stop the duplicate,
  lockfile-conflicting PRs of #225/#226) while leaving Dependabot _security_ updates
  on — the fast lane for vulnerability advisories that shouldn't wait for a green
  nightly.
- Monthly: review outdated packages and security advisories.
- Weekly: triage any guard PRs/issues and Dependabot security PRs.
- Immediate: patch high/critical vulnerabilities (Dependabot security PR or manual).

## Automation (twice-weekly upgrade guard)

The `.claude/skills/upgrade-guard` skill, run by `.github/workflows/upgrade-guard.yml`,
performs this Process automatically **on Tue + Fri (UTC), after the Nightly tests pass**
(so it only upgrades from a known-green baseline). It was throttled from nightly to
2×/week to keep the agent's runner time + PR/issue noise reasonable — the agent holds a runner for many minutes; a
manual `workflow_dispatch` runs it any other day. It covers npm runtime + dev deps,
TypeScript, the Node toolchain, the pinned Supabase CLI, and the GitHub Actions.

- **Patch + minor** are applied as one lot, the full gate + E2E (public + authed) +
  pgTAP are run on the branch, and the PR is **auto-merged only when all of them are
  green** (a graceful-skipped suite is not "green" → the PR is left for manual merge).
- **Each major** is attempted in isolation — **one PR per major, never bundled** — with
  a changelog summary; a major whose gate stays red becomes a **tracking issue**, not a
  broken PR. Majors are **never auto-merged** (human changelog review).
- The guard **never weakens the gate** and **never pushes to `main`** itself; the
  deterministic `automerge` job is the only thing that merges, and only the fully-green
  patch/minor PR. The repo-specific upgrade traps (npm 10 lockfile, global esbuild
  override on Vite 8, react-hooks 7 `recommended`, react-refresh on `src/routes/**`, the
  do-not-touch `motion`/LazyMotion refactor, the inline Vite config (ex-meta-plugin,
  de-vendored), the Supabase CLI
  pin → validate pgTAP) live in the skill and must be honoured.

Prereq: the `CLAUDE_CODE_OAUTH_TOKEN` secret (shared with `regression-guard`); without
it the workflow skips gracefully.

## Process

1. Run `npm outdated`.
2. Run `npm run audit:deps`.
3. Group upgrades by risk: patch, minor, major.
4. Prefer patch/minor first, then major with dedicated validation.
5. Validate with `npm run lint`, `npm run test:coverage`, `npm run build:check`.
6. Document notable upgrades in release notes.

## Le piège des deux npm (incident #716 → #718, 2026-08-09/10)

**Ce dépôt et la Content CI privée ne tournent pas sur le même Node**, et cette asymétrie rend le
gate d'ici structurellement aveugle à une classe entière de pannes de lockfile.

|                                            | Node | npm    | comportement                   |
| ------------------------------------------ | ---- | ------ | ------------------------------ |
| moteur (ici) — `.nvmrc` + les 10 workflows | 24   | 11     | **installe** un lock incomplet |
| Content CI (dépôt privé)                   | 22   | 10.9.8 | **refuse** ce même lock        |

Un `package-lock.json` régénéré par un npm récent peut **omettre l'entrée imbriquée d'une peer
dependency optionnelle** que npm 10 exige quand la version racine ne la satisfait pas. Le fichier
est alors parfaitement valide pour npm 11 et mortel pour npm 10.

**Ce qui s'est passé.** #716, intitulée « bump undici … `dependency-type: indirect` », faisait en
réalité passer `@cloudflare/vite-plugin` de `^1.40.2` à `^1.51.1`, entraînant `miniflare 4 →
5.20260801.1-alpha`, `workerd` et `wrangler` — deux majeures et une **alpha** dans la chaîne de
build sous un titre de bump indirect. Sa régénération du lock a supprimé
`node_modules/vite-tsconfig-paths/node_modules/typescript@5.9.3`, exigée par la peer optionnelle
`typescript: ^5.0.0` de `tsconfck` (le `typescript@6.0.3` racine ne la satisfait pas).

Résultat : `npm ci` mort sur npm 10 ⇒ **Content CI privée rouge 33 h, `main` comprise**, pendant
que le gate d'ici serait resté vert. Aggravant : **`ci.yml` n'a pas tourné sur le commit fautif**
(dernier run sur `main` à 07:08:53Z, merge de #716 à 07:13:09Z) — aucun signal du tout.

**Réflexes à en tirer.**

1. Une panne « `npm ci` ne casse que là-bas » se reproduit **avec la version de npm de l'autre
   CI**, pas avec celle qu'on a sous la main. `npm ci --dry-run` suffit et coûte quelques secondes.
2. **Ne pas réparer un lock désynchronisé par une simple re-synchro** sans regarder ce que le bump
   a fait entrer. `npm install --package-lock-only` faisait repasser `npm ci` ici — en consolidant
   l'alpha et les deux majeures que personne n'avait arbitrées. Le **revert** (#718) était la bonne
   réponse : règle ci-dessous, une majeure = une PR isolée.
3. **Se méfier du titre d'une PR Dependabot.** « bump `<transitive>` … indirect » peut cacher une
   montée de majeure du parent. Lire le diff de `package.json`, pas l'intitulé.
4. Un revert de bump n'est pas forcément une régression de sécurité : ici `undici` était une
   transitive d'une **devDependency**, et `audit:deps` (qui tourne en `--omit=dev`) rendait
   `0 vulnerabilities` après revert.

## Rules

- Never merge dependency updates without CI green.
- For major upgrades, require explicit changelog review.
- Keep lockfile committed and reviewed.
- **GitHub Actions are pinned to a commit SHA** (étude 25 lot 5b), with the version kept as a
  trailing comment — `uses: actions/checkout@9c091bb… # v7`. npm deps and Actions are two
  separate supply chains: Dependabot/`upgrade-guard` cover the first, this rule the second.
  Bumping an Action means replacing **both** the SHA and its comment; resolve the new SHA with
  `gh api repos/<owner>/<repo>/commits/<tag> --jq .sha`. Never revert a `uses:` to a moving tag.
  **Enforced mechanically** since 2026-07-20 by `harness:check` (invariant 7, in the CI `verify`
  job): any `uses:` that is not a 40-hex commit SHA fails the gate. Local reusable workflows
  (`./.github/workflows/…`) and `docker://` refs are exempt. The gate exists because the rule
  alone was not enough — two workflows added hours after the pinning landed reintroduced four
  moving tags and merged green (#553 → fixed in #554).

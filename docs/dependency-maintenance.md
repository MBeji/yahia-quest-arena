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

⚠️ **Correction du 2026-08-13 — cette section (et le gotcha d'AGENTS.md qui y renvoie)
décrivait l'asymétrie au présent. Elle n'existe plus, et la formulation inversait la leçon.**
Au moment de l'incident, ce dépôt était sur **Node 24 / npm 11** et la Content CI privée sur
**Node 22 / npm 10.9.8**. La PR **#150 du dépôt privé a aligné ses six workflows sur Node 24** :
les deux côtés tournent désormais sur le même Node.

|                                                           | Node (pendant l'incident) | npm    | face au lock de #716                                    |
| --------------------------------------------------------- | ------------------------- | ------ | ------------------------------------------------------- |
| moteur (ici) — `.nvmrc` + les 10 workflows                | 24                        | 11     | **installe** un lock incomplet → gate **vert**          |
| Content CI (privée) — **alignée sur 24 depuis leur #150** | 22                        | 10.9.8 | **refuse** ce même lock → **seul détecteur du système** |

**Et c'est l'inverse d'une cause.** Le côté strict n'était pas mal configuré : il avait raison.
En alignant les deux, #150 a **supprimé le seul détecteur** qui ait attrapé une majeure et une
alpha entrées sous un titre de bump indirect. L'alignement se défend pour lui-même — exécuter les
scripts du moteur sur un Node qu'il n'utilise pas est un risque, et le `.nvmrc` dit 24 — et la
propriété perdue était **accidentelle** (la sévérité de npm 10, pas une intention) : s'y fier
était fragile. Mais elle a coûté quelque chose, et l'arbitrage **A17** de la roadmap privée
tranche ce qui la remplace. Le vrai manque n'est pas une version de Node, c'est **une garde qui
refuse une PR de dépendance dont le diff dépasse ce que son titre annonce**.

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
   ✅ **Ce réflexe est devenu un gate le 2026-08-24** (arbitrage A17) : l'étape « Canari npm 10 »
   du job `verify` rejoue la résolution du lockfile sous **npm 10** à chaque PR. Elle est dans un
   check **requis** — un canari qui ne bloque pas est un canari qu'on lit après coup.
   **Éprouvée dans les deux sens avant livraison**, en reproduisant cet incident sur une copie du
   lock (suppression de l'entrée imbriquée `vite-tsconfig-paths/node_modules/typescript`, ce que
   la régénération fautive avait fait) : **npm 11 → « added 511 packages », vert** ; **npm 10 →
   « Missing: typescript@5.9.3 from lock file », rouge**. Le différentiel est mesuré, pas supposé.
   ⚠️ En cas d'échec, lire le **début** de la sortie de npm : il affiche sa bannière d'aide après
   l'erreur, et un `| tail` fait croire à un drapeau refusé alors que la cause (`EUSAGE`, avec le
   paquet manquant nommé) est en tête. Le piège a coûté une fausse piste le jour même.
2. **Ne pas réparer un lock désynchronisé par une simple re-synchro** sans regarder ce que le bump
   a fait entrer. `npm install --package-lock-only` faisait repasser `npm ci` ici — en consolidant
   l'alpha et les deux majeures que personne n'avait arbitrées. Le **revert** (#718) était la bonne
   réponse : règle ci-dessous, une majeure = une PR isolée.
3. **Se méfier du titre d'une PR Dependabot.** « bump `<transitive>` … indirect » peut cacher une
   montée de majeure du parent. Lire le diff de `package.json`, pas l'intitulé.
   ✅ **Ce réflexe est devenu un gate le 2026-09-03** — c'est la SECONDE moitié de A17, et celle
   que le canari ne couvrait pas. `scripts/ci/check-dependency-pr.mjs`, étape « Garde de diff de
   dépendance » du job `verify`, confronte le titre au diff sur toute PR qui touche
   `package.json`/`package-lock.json` :

   | règle  | ce qu'elle refuse                                                                                                                     | titre requis                                                                                                                                                   |
   | ------ | ------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
   | **A1** | une **préversion** qui ENTRE dans le lockfile — l'alpha de #716                                                                       | aucun : elle vaut pour toute PR, humaine comprise. Échappatoire assumée et visible : `[allow-prerelease]` dans le titre, qui suit le squash jusque dans `main` |
   | **B1** | un titre qui dit « indirect » alors que le **manifeste** bouge — une bump indirecte ne touche pas `package.json`, c'est sa définition | oui                                                                                                                                                            |
   | **B2** | une **majeure** qui traverse sous un titre patch/minor/indirect                                                                       | oui                                                                                                                                                            |
   | **B3** | un titre qui nomme un paquet et un diff qui en bouge un **autre**                                                                     | oui                                                                                                                                                            |

   **Pourquoi les deux moitiés, et pas une.** Le canari juge une propriété _mécanique_ — ce
   lockfile s'installe-t-il ailleurs ? Il aurait attrapé #716 **par accident**, parce que sa
   régénération était cassée, et il ne dira jamais rien d'un bump parfaitement installable qui
   fait entrer une majeure non arbitrée. La propriété perdue avec npm 10 était accidentelle ;
   celle-ci est **intentionnelle** : le titre d'une PR est une promesse, et le diff doit la tenir.

   **Éprouvée dans les deux sens avant livraison**, sur de vrais commits git, comme le canari
   l'avait été : **#716 rejoué** (titre « bump undici · indirect », manifeste qui monte
   `@cloudflare/vite-plugin ^1.40.2 → ^1.51.1`, `miniflare 5.20260801.1-alpha` au lock) sort
   **rouge par trois règles indépendantes** (A1, B1, B3) ; une bump indirecte honnête (le lock
   bouge, le manifeste non), une majeure **annoncée** comme telle, et le correctif `fast-uri`
   du 2026-09-02 sortent **verts**. Le faux positif est le risque principal d'une garde
   pareille — bloquer la file coûte plus qu'elle ne rapporte — donc toute plage qu'elle ne sait
   pas lire (`workspace:*`, un alias `npm:`, une plage composite) est **ignorée** plutôt
   qu'interprétée.

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

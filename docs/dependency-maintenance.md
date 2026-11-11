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

✅ **La cause est supprimée le 2026-09-13** : `vite-tsconfig-paths` est retiré — le seul mapping
de `tsconfig.json` (`@/*`) était déjà déclaré en dur dans `resolve.alias` de `vite.config.ts` —,
donc plus de `tsconfck`, plus de peer `typescript ^5` invalide, plus d'entrée imbriquée
`vite-tsconfig-paths/node_modules/typescript` : le lock se résout à l'identique sous npm 10 et
npm 11, et la PR Dependabot #1016 cessait d'échouer pour cette raison. **Le canari reste** : il
garde la propriété pour la prochaine peer optionnelle qu'une majeure ferait entrer.

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

## Une transitive épinglée par son parent : l'override ciblé (2026-11-05)

Quand un paquet tiré par un parent est épinglé **exactement** par ce parent, `npm update <transitive>`
ne bouge rien : la seule version de l'arbre est celle du parent. C'est le cas de `undici` sous
`miniflare 4`, épinglé à `7.28.0`.

La PR Dependabot #1016 (« bump undici 7.28.0 → 7.29.0 ») ne pouvait donc pas être sauvée par un
rebase : pour atteindre `7.29.0`, elle montait `@cloudflare/vite-plugin` au manifeste et faisait
entrer `miniflare 5-alpha`, le motif de #716 à l'identique. Son titre mentait sur son diff. Elle a
été fermée au profit de #1063.

Le geste juste est un **override ciblé**, au niveau du parent :

```json
"overrides": {
  "miniflare": { "undici": "7.29.0" }
}
```

Ciblé, et jamais global : un override global basculerait aussi le `jsdom` de l'arbre, qui porte
`undici 8`. C'est une dépendance de développement (`audit:deps` tourne en `--omit=dev` et ne la
voit pas) : elle se vérifie par le canari npm 10, la garde de diff et `build:check`.

**Le même geste, rejoué le 2026-11-11** pour la PR Dependabot #1135 (« bump `@vitest/mocker` et
`sharp` »). `sharp` est épinglé à `0.35.2` par `miniflare 4`, exactement comme `undici` ; pour
l'atteindre, Dependabot montait là encore `@cloudflare/vite-plugin` au manifeste (`^1.40.2` →
`^1.62.2`), donc `miniflare 5-alpha`. La PR a été fermée au profit de l'override :

```json
"overrides": {
  "miniflare": { "sharp": "0.35.5", "undici": "7.30.2" }
}
```

Les deux versions sont les premières hors des avis ouverts ce jour-là (`sharp` ≤ 0.35.5-rc.1,
`undici` 7.0.0 – 7.30.0) ; `npm audit` **dev inclus** passe de 4 avis « high » à 0. Un override
épinglé vieillit comme le pin qu'il remplace : c'est `npm audit` sans `--omit=dev` qui dit quand
le remonter, puisque `audit:deps` ne regarde pas cette chaîne.

⚠️ Un commentaire `@dependabot rebase` ne peut pas être posté par une session : le connecteur GitHub
neutralise la mention (`·@·d·ependabot r·ebase`). Seul un humain le tape. Un override ciblé rend
souvent ce geste inutile.

## Les écartés du lot — `scripts/deps/held-back.json` (2026-11-11)

Une montée **dans les ranges** peut être refusée par le gate pour une raison qui ne se corrige pas
dans la PR du lot : elle fait entrer une préversion, ou elle fait déborder un budget de bundle.
L'écarter à la main (`--hold`) ne durait qu'une commande : le run suivant la retrouvait et la
re-refusait. `react` 19.3 et `lucide-react` ont ainsi été écartés pour le budget de bundle
trois fois (2026-09-25, 09-29, 10-02), mesures refaites à chaque fois, puis réembarqués par les
cinq lots suivants, restés rouges. Onze lots de suite, du 2026-09-25 au 2026-11-10, n'ont jamais
mergé
([`agents/gardes.md`](./agents/gardes.md)).

[`scripts/deps/held-back.json`](../scripts/deps/held-back.json) est la mémoire de ces refus. Une
entrée = **une raison**, pour un ou plusieurs paquets qui montent ensemble :

| champ      | ce qu'il porte                                                                  |
| ---------- | ------------------------------------------------------------------------------- |
| `packages` | les paquets écartés — un groupe (`react` et ses `@types`) reste dans une entrée |
| `since`    | la date de l'écart                                                              |
| `reason`   | le refus, **mesuré** : la préversion nommée, ou le chunk et ses deux tailles    |
| `liftWhen` | ce qui lèvera l'écart — sans cette ligne, un écart est un gel                   |

Le script refuse une entrée sans `reason` ni `liftWhen`, et chaque PR de lot réaffiche la liste :
un écart qu'on ne relit jamais ne se lève jamais. Un écart **sans objet** (le paquet n'a plus rien à
monter dans son range) est signalé dans la PR, pour être retiré.

État au 2026-11-11, chiffres pris sur `main` :

| paquet                               | ce qui le retient                                                                                  |
| ------------------------------------ | -------------------------------------------------------------------------------------------------- |
| `@cloudflare/vite-plugin` ≥ 1.49.1   | dépend de `miniflare 5` (alpha puis bêta). 1.49.0 est la dernière version sur `miniflare 4`        |
| `vite` 8.3                           | `rolldown` ≥ 1.2.16 : son binding wasm32-wasi (optionnel) dépend de `@emnapi/core 2.0.0-beta.2`    |
| `react` 19.3 (et `react-dom`, types) | `react-dom-client` grossit en amont (536 → 625 kB) : chunk d'entrée 454,53 → 482,54 kB, budget 456 |
| `lucide-react` 1.72                  | `vendor-icons` 30,78 → 37,42 kB, budget 32, à imports inchangés                                    |

**Une préversion ne passe plus par accident.** Le script rejoue la règle A1 sur le lot qu'il vient
d'appliquer ; si une préversion entre, il remonte le lockfile jusqu'au paquet du lot qui la **tire**
(`dependencies` et `optionalDependencies`, jamais les peers — presque tout l'outillage a `vite` en
peer), l'écarte, le nomme dans la PR et applique le reste. L'assumer reste un geste à part : une PR
dédiée, `[allow-prerelease]` dans son titre.

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

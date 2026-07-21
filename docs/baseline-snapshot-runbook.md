# Runbook — bascule système (baseline snapshot)

> **Figer l'intégralité du système à un instant T, pour pouvoir y revenir vite.** Un _baseline_
> coordonne les trois dépôts — `yahia-quest-arena`, `yahia-quest-content`, `ScribeKit` — **et**
> l'état vivant de la production (base, déploiement, configuration) en un point de retour unique
> et daté. Il se **planifie** — on le pose quand le système est vert et stable, avant un chantier
> à risque — là où le [rollback](./prod-rollback-runbook.md) se subit dans l'urgence.
>
> Compagnons : [`release-tagging-policy.md`](./release-tagging-policy.md) (les familles de tags),
> [`prod-rollback-runbook.md`](./prod-rollback-runbook.md) (revenir en incident),
> [`backup-restore-runbook.md`](./backup-restore-runbook.md) (l'axe données),
> [`ci-cd-and-branch-protection.md`](./ci-cd-and-branch-protection.md) (la chaîne qui déploie).

---

## 1. Ce qu'un baseline fige — et ce qu'un tag ne figera jamais

Règle d'or, héritée du runbook de rollback : **un tag git fige le code, jamais l'état vivant.**
« Revenir à un tag est une opération sur le code — le schéma, lui, ne recule jamais. » Un
baseline complet est donc un **bundle de cinq pièces**, pas un tag :

| #   | Pièce                                                    | Où elle vit                         | Ce qu'elle fige                                                     |
| --- | -------------------------------------------------------- | ----------------------------------- | ------------------------------------------------------------------- |
| 1   | **3 tags git** `baseline/AAAA-MM-JJ`                     | les 3 remotes                       | code, migrations-as-code, seed, CI/CD, harness, scripts infra, docs |
| 2   | **Dump de prod** `pg_dump -Fc`                           | stockage durable **hors git** (PII) | les données vivantes (profils, tentatives, XP, badges…)             |
| 3   | **Tête de migration** + **`content_releases.git_sha`**   | annotation du tag                   | l'état exact schéma + contenu réellement appliqué en prod           |
| 4   | **Déploiement Vercel servi** + **inventaire env** (noms) | annotation du tag                   | le runtime et sa configuration                                      |
| 5   | **Le manifeste**                                         | = l'annotation des tags (§4)        | le lien immuable entre les quatre autres                            |

**Frontière de sécurité — non négociable.** Les _valeurs_ de secrets (clés Supabase, tokens
Vercel, PAT) ne vont **jamais** dans un tag ni un manifeste. On y met l'inventaire documenté
([`environment-variables.md`](./environment-variables.md) figé au tag) et les _noms_
(`vercel env ls`), pas les valeurs. Un dump contient des données utilisateur : il s'archive dans
un stockage à accès restreint, jamais sur une surface publique (release asset, artefact partagé).

---

## 2. La famille de tags `baseline/*`

Trois familles coexistent — détail dans [`release-tagging-policy.md`](./release-tagging-policy.md) :

| Famille                   | Portée           | Exemple               | Auteur                      | Rôle                                                |
| ------------------------- | ---------------- | --------------------- | --------------------------- | --------------------------------------------------- |
| `vMAJ.MIN.CORR`           | 1 dépôt          | `v0.2.0`              | `release.yml` (auto)        | « quelle version ? »                                |
| `checkpoint/AAAA-Wnn`     | arena            | `checkpoint/2026-W30` | `checkpoint-tag.yml` (auto) | retour arrière **prouvé** (arena seul)              |
| **`baseline/AAAA-MM-JJ`** | **les 3 dépôts** | `baseline/2026-07-21` | **manuel (ce runbook)**     | **bascule système complète : code + base + config** |

- **Daté, pas SemVer** : la date est la seule clé commune aux trois dépôts —
  `yahia-quest-content` n'a aucun SemVer. Le même nom sur les trois remotes rend la corrélation
  triviale. Suffixe de raison optionnel : `baseline/2026-07-21-pre-videos`.
- **Annoté** (`git tag -a`), **jamais déplacé ni supprimé** une fois poussé, **un par snapshot**.
- **Option numéro de version** (découplée) : si tu veux un SemVer lisible, bumpe `package.json`
  d'arena (`release.yml` coupe `v0.2.0` seul) et tagge ScribeKit `v0.2.0` ; reporte les deux dans
  le manifeste. Le baseline ne dépend pas de ce bump.

---

## 3. Reproductibilité — ce qui est garanti, ce qui ne l'est pas

Un baseline ne vaut que si on peut **rejouer** l'état depuis le tag. L'épinglage conditionne cette
garantie.

**✅ Garanti — la chaîne CI d'arena.** Toutes les Actions de `.github/workflows/**` d'arena sont
épinglées à un SHA de commit, et la règle est **auto-portante** : `npm run harness:check` échoue
sur toute Action non épinglée (`findUnpinnedActions`, étude 25 lot 5b, PR #568). Rejouer la CI
d'arena au tag est donc déterministe.

**⚠️ Angle mort 1 — le moteur n'est pas épinglé côté contenu.** Dans le repo `yahia-quest-content`,
`apply-content.yml`, `content-ci.yml` et `content-audit.yml` checkout `MBeji/yahia-quest-arena`
**sans `ref:`** (branche flottante, `path: engine`). Reconstruire le contenu au baseline impose
donc de **forcer le moteur à `arena@baseline`** à la main (§7).

**⚠️ Angle mort 2 — les Actions du repo content ne sont pas épinglées** (leurs `uses:` sont en
`@vN`). Le gate `harness:check` est un script d'arena : il ne franchit pas la frontière du repo
privé.

> **Reco** (dans l'esprit du gate #568) : épingler le `ref:` du moteur au commit dans les trois
> workflows contenu, et porter un gate d'épinglage côté `yahia-quest-content`. Tant que ce n'est
> pas fait, le manifeste **doit** noter le SHA du moteur, faute de quoi le contenu n'est pas
> reproductible par construction.

---

## 4. Le manifeste = l'annotation du tag

L'annotation d'un tag est **immuable et auto-portante** : c'est elle la source de vérité du
baseline, pas un fichier qui dérive. Modèle pour arena :

```
Baseline système 2026-07-21 — <raison>

DÉPÔTS (code + migrations + CI + harness + infra + docs)
  arena     MBeji/yahia-quest-arena     <sha servi en prod>      v0.1.0
  content   MBeji/yahia-quest-content   <git_sha appliqué>       (no semver)
  scribekit MBeji/ScribeKit             <sha origin/main>        v0.1.0

BASE (état vivant — hors git)
  tête de migration        : <ex. 20260721140000_competency_map_rpcs>
  content_releases git_sha : <dernier appliqué en prod>
  dump prod                : db-prod-<stamp>.dump (pg_dump -Fc, PG17)
    run     : <url run db-backup.yml>
    sha256  : <checksum>
    archivé : <emplacement durable, accès restreint — PII>

RUNTIME
  déploiement Vercel servi : https://na9ranal3ab-XXXX.vercel.app (commit <sha>)
  env (noms uniquement)    : environment-variables.md @ tag + snapshot `vercel env ls`

PREUVES (au gel)
  ci:verify <run>  ·  harness:check épinglage OK  ·  nightly e2e+pgTAP <run>
  /api/health commit == <sha arena>
```

Une copie lisible peut être commitée ensuite dans `docs/baselines/2026-07-21.md` via une PR
normale (après dégel) — mais **l'autorité reste l'annotation**.

> ⚠️ **Taguer l'état RÉEL de la prod, pas le tip.** Arena se tagge au commit **servi**
> (`/api/health` → `commit`, normalement `== origin/main`). Le contenu se tagge au **`git_sha`
> réellement appliqué** (dernier `content_releases`, qui peut être en retard sur `origin/main` si
> du contenu est commité mais pas encore appliqué). ScribeKit (pas de prod) se tagge à
> `origin/main`.

---

## 5. Checklist de validation avant de couper les tags

Discipline #554 : **chaque case se coche en relisant l'état à la source, jamais un signal** (§8).

- [ ] Les 3 arbres de travail sont **propres et à jour** (`git fetch && git status`).
- [ ] **`main == prod`** : `curl -s https://na9ranal3ab.vercel.app/api/health` → `status:"ok"`,
      `checks.database:"ok"`, et `commit` == SHA arena visé.
- [ ] `npm run ci:verify` **vert** sur ce commit d'arena (ou un run CI vert y existe déjà).
- [ ] `npm run harness:check` **vert** — l'épinglage des Actions tient (garantie de repro, §3).
- [ ] Un **nightly vert** (Playwright e2e + pgTAP) existe sur ce commit ; sinon baseline
      « verify-only », **écrit tel quel** dans l'annotation.
- [ ] Chaîne **gelée**, aucune PR en cours de merge (`gh pr list`, `gh variable list`).
- [ ] Dump prod **pris, téléchargé, `sha256` calculé, archivé durablement** (hors des 14 j
      d'artefacts GitHub, accès restreint PII).
- [ ] **Tête de migration** prod relue (`gh workflow run db-migrate-prod.yml -f mode=list`) et notée.
- [ ] Dernier **`content_releases.git_sha`** prod relu et noté ; tag contenu posé sur CE sha.
- [ ] Inventaire env capturé (`vercel env ls`, **noms**) ; `environment-variables.md` à jour au tag.
- [ ] Le nom `baseline/AAAA-MM-JJ` **n'existe sur aucun** des 3 remotes (`git ls-remote --tags`).
- [ ] Annotation rédigée : 3 SHAs + tête migration + stamp/`sha256` du dump + déploiement Vercel.
- [ ] **Aucune valeur de secret** dans le tag ou le manifeste (revue anti-fuite).

---

## 6. Procédure de création

Le dump et le tag arena doivent correspondre au **même instant**. La chaîne auto-merge pouvant
faire bouger `main` à tout moment, on **gèle** le temps du snapshot (~15 min).

```bash
# 0. Aucune PR en train de merger ? (sinon attendre / geler)
gh pr list --state open

# 1. Geler la chaîne (empêche main de bouger) — puis RELIRE que c'est bien posé
gh variable set MERGE_FREEZE --body 1
gh variable list | grep MERGE_FREEZE

# 2. Figer les SHAs (relire origin, PAS le worktree local). Idem content et scribekit.
git -C <arena> fetch origin main && git -C <arena> rev-parse origin/main

# 3. Snapshot base : dump prod, puis ARCHIVER hors GitHub (rétention 14 j sinon)
gh workflow run db-backup.yml -f target=prod
#   → attendre le run, télécharger l'artifact db-prod-<stamp>, sha256sum, archiver durablement

# 4. Relire l'état schéma + contenu vivants (lecture seule)
gh workflow run db-migrate-prod.yml -f mode=list           # tête de migration prod
#   + dernier content_releases.git_sha (log du dernier apply-content, ou SELECT en lecture)

# 5. Relever le runtime servi + inventaire env (noms)
curl -s https://na9ranal3ab.vercel.app/api/health          # status / database / commit
vercel env ls                                              # NOMS uniquement, jamais les valeurs

# 6. Tag annoté (même nom, annotation = manifeste §4) au BON sha de chaque repo
git -C <arena>     tag -a baseline/2026-07-21 <sha-servi>        -F manifeste-arena.txt
git -C <content>   tag -a baseline/2026-07-21 <git_sha-appliqué> -F manifeste-content.txt
git -C <scribekit> tag -a baseline/2026-07-21 origin/main        -F manifeste-scribekit.txt

# 7. Pousser les 3 tags — puis RELIRE qu'ils ont atterri (un push via pipe peut mentir, §8)
git -C <arena> push origin baseline/2026-07-21             # idem content, scribekit
git -C <arena> ls-remote --tags origin | grep baseline/2026-07-21

# 8. Dégeler (réarme les PR éligibles)
gh workflow run rollback-prod.yml -f mode=unfreeze -f reason="baseline 2026-07-21 posé"

# 9. Vérifier à la source : relire l'annotation sur chaque repo
git -C <arena> show baseline/2026-07-21
```

_(Le gel est optionnel si aucune session concurrente ne tourne — mais recommandé, la chaîne étant
100 % automatique.)_

---

## 7. Procédure de restauration

On combine les leviers existants, **axe par axe** — détail dans
[`prod-rollback-runbook.md`](./prod-rollback-runbook.md) et
[`backup-restore-runbook.md`](./backup-restore-runbook.md).

| Axe                          | Action                                                                                                      | Référence                      |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------ |
| **Code servi** (le + rapide) | Repromouvoir le déploiement Vercel noté au manifeste                                                        | rollback levier 1 (~30 s)      |
| **`main` == baseline**       | `git revert baseline/AAAA-MM-JJ..origin/main` sur `revert/…` (jamais de force-push)                         | rollback levier 2/3            |
| **Base — schéma**            | Comparer tête de migration courante vs baseline : additif depuis → rien ; destructif/données → dump archivé | backup-restore A ; rebuild = B |
| **Base — contenu**           | Ré-appliquer le contenu au tag content, **moteur forcé à `arena@baseline`** (§3 angle mort 1)               | `apply-content.yml`            |
| **Configuration**            | Remettre les env Vercel à l'inventaire figé, **redéployer sans cache** (`VITE_*` inlinées)                  | manifeste + doc env            |
| **Vérification**             | `/api/health` `commit` == baseline + parcours de fumée (accueil, une matière, un exercice soumis)           | sonde #569                     |

---

## 8. Vérifier l'état, jamais le signal (rappel #554, appliqué au baseline)

En pose de baseline comme en incident, chaque « c'est fait » se relit **à la source**. Les signaux
mentent, presque toujours dans le sens rassurant.

| Piège                         | Ce qu'on croit       | La vérité — et le contrôle réel                                                              |
| ----------------------------- | -------------------- | -------------------------------------------------------------------------------------------- |
| `git push … \| tail`          | la poussée du tag    | code de sortie = celui de `tail` ; un push rejeté ressort en succès → `git ls-remote --tags` |
| `gh variable set` renvoyé     | le gel est posé      | relire `gh variable list \| grep MERGE_FREEZE`                                               |
| HTTP 200 sur `/`              | la prod tourne       | lire `curl /api/health` : `commit` (quel code) + `checks.database` (base vivante)            |
| « le run db-backup est vert » | le dump existe       | télécharger l'artifact, `sha256sum`, l'archiver — un job vert peut avoir **sauté** l'étape   |
| `origin/main`                 | l'état servi en prod | après un rollback Vercel, `main` ≠ prod ; taguer le `commit` de `/api/health`                |

---

## 9. Ce qui reste à outiller

| Gap                                       | Effet sur le baseline                                           | Piste                                               |
| ----------------------------------------- | --------------------------------------------------------------- | --------------------------------------------------- |
| Dumps `db-backup` en rétention **14 j**   | l'axe données d'un baseline plus vieux repose sur le schéma git | archiver le dump hors GitHub à la pose (§6 étape 3) |
| **Moteur non épinglé** dans la CI contenu | contenu non reproductible par construction                      | épingler le `ref:` au commit (esprit #568)          |
| **Actions du repo content** non épinglées | chaîne contenu non déterministe                                 | gate d'épinglage côté `yahia-quest-content`         |
| **Aucun `checkpoint/*` posé** à ce jour   | pas encore de filet de retour automatique                       | laisser `checkpoint-tag.yml` tourner                |
| **Personne n'interroge `/api/health`**    | le délai de détection domine le RTO                             | monitor externe (UptimeRobot / Better Stack)        |

# Runbook — retour arrière production

> **Quand un merge ou un déploiement fait tomber la prod.** Ce fichier se lit dans l'urgence :
> les trois premières minutes sont en haut, le raisonnement en dessous.
> Compagnons : [`backup-restore-runbook.md`](./backup-restore-runbook.md) (l'axe données),
> [`ci-cd-and-branch-protection.md`](./ci-cd-and-branch-protection.md) (la chaîne qui déploie),
> [`release-tagging-policy.md`](./release-tagging-policy.md) (les tags).

---

## Les trois premières minutes

```bash
# 1. Geler la chaîne + revenir au déploiement production précédent (~30 s côté Vercel)
gh workflow run rollback-prod.yml -f mode=rollback -f reason="<ce qui est cassé>"

# 2. Regarder ce que ça a donné (le workflow ouvre une issue d'incident avec la suite à faire)
gh run watch "$(gh run list --workflow rollback-prod.yml --limit 1 --json databaseId --jq '.[0].databaseId')"

# 3. Vérifier à la main : page d'accueil, une matière, un exercice soumis
```

Pas de secrets Vercel configurés, ou le workflow échoue ? **Dashboard Vercel → Deployments →
le dernier déploiement vert → `…` → Promote to Production.** Puis, immédiatement :

```bash
gh variable set MERGE_FREEZE --body 1   # sinon la prochaine PR redéploie le code cassé
```

---

## Pourquoi le gel passe AVANT tout le reste

C'est la particularité de ce dépôt, et le piège n°1 d'un rollback ici. La chaîne
`push → PR → checks → merge → déploiement` est **entièrement automatique et sans geste humain**
(`auto-pr.yml`, `automerge.yml`, décision du 2026-07-12). Une PR ouverte par n'importe quelle
session merge toute seule dès que ses checks sont verts, et Vercel déploie dans la foulée.

Conséquence : **un rollback qui ne gèle pas la chaîne dure jusqu'au prochain merge.** On
remet la prod debout, et dix minutes plus tard une PR sans rapport se merge, redéploie `main`
— qui contient toujours le code fautif — et la prod retombe. Sans que personne n'ait rien fait.

Le gel est la variable de dépôt **`MERGE_FREEZE`**. À `1` :

|                                     | Effet                                                                                                      |
| ----------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `auto-pr.yml`                       | toute branche poussée ouvre sa PR en **draft**, rien ne s'arme                                             |
| `automerge.yml` (`arm`)             | désarme au lieu d'armer                                                                                    |
| `automerge.yml` (`keep-up-to-date`) | ne rapproche plus aucune PR du merge                                                                       |
| `rollback-prod.yml`                 | désarme en plus, tout de suite, les PR déjà armées (elles ne reçoivent aucun événement quand le gel tombe) |

**Exemption : `hotfix/*` et `revert/*`.** Sans elle, le gel bloquerait le correctif qui met fin
à l'incident. Ces branches passent **le même gate complet** que d'habitude — on gèle le flux
ordinaire, on n'affaiblit aucun contrôle.

---

## L'invariant à garder en tête

En régime normal : **`main` == ce qui tourne en prod.** Un rollback Vercel casse volontairement
cet invariant — la prod sert un déploiement plus ancien pendant que `main` porte encore le code
fautif. C'est un état **transitoire et surveillé** : le gel le rend sûr, le revert le referme.

> Tant que `main` ≠ prod, la seule chose qui empêche la panne de revenir est `MERGE_FREEZE`.
> Ne dégelez pas avant que le revert soit mergé.

---

## Arbre de décision

```
La prod est cassée
│
├─ On sait quel merge l'a cassée, et il est récent ?
│   ├─ OUI → levier 1 (rollback Vercel) puis levier 2 (revert git)
│   └─ NON, ou plusieurs merges depuis le dernier état sain
│           → levier 1 puis levier 3 (revenir au dernier checkpoint)
│
├─ La prod répond mais les données sont fausses / perdues ?
│      → ce n'est pas un rollback de code : levier 4 (backup-restore-runbook.md)
│
└─ Le rollback Vercel n'a rien changé ?
       → la panne n'est pas dans le code déployé : voir « Si le rollback ne suffit pas »
```

---

## Les quatre leviers

| #   | Levier                                                               | Délai                | Ce qu'il répare                  | Ce qu'il ne répare pas       |
| --- | -------------------------------------------------------------------- | -------------------- | -------------------------------- | ---------------------------- |
| 1   | **Rollback Vercel** (`rollback-prod.yml`, ou Promote to Production)  | ~30 s                | le code servi en prod            | ni `main`, ni le schéma      |
| 2   | **Revert git** (branche `revert/…`)                                  | 15–25 min (cycle CI) | l'invariant `main` == prod       | ni le schéma, ni les données |
| 3   | **Checkpoint** (`checkpoint/AAAA-Wnn`)                               | idem                 | ramène à un état **prouvé** vert | idem                         |
| 4   | **Restauration base** ([runbook dédié](./backup-restore-runbook.md)) | ~1 h                 | données / schéma                 | le code                      |

Les leviers 1 et 2 se **combinent** : 1 arrête l'hémorragie, 2 referme l'invariant. Ne vous
arrêtez jamais à 1.

---

## Procédure complète — cas nominal (un merge a cassé la prod)

### 1. Geler + rollback

```bash
gh workflow run rollback-prod.yml -f mode=rollback -f reason="crash au chargement du dashboard depuis #5xx"
```

Le workflow gèle, désarme les PR armées, note le déploiement en cours, repromeut le précédent,
revérifie que la prod répond, et ouvre une **issue d'incident** portant la checklist du reste.

Pour viser un déploiement précis plutôt que « le précédent » :
`-f target=https://na9ranal3ab-xxxx.vercel.app`.

### 2. Identifier le merge fautif

```bash
git fetch origin main
git log --oneline origin/main -10
gh pr list --state merged --limit 10 --json number,title,mergedAt,mergeCommit
```

Recoupez avec l'heure de bascule : le déploiement Vercel remplacé (l'issue d'incident le note)
porte le SHA du commit fautif.

### 3. Reverter

⚠️ **Ce dépôt squash-merge.** Les commits de `main` sont des commits ordinaires, **pas** des
commits de merge : c'est `git revert <sha>` **sans** `-m 1` (le `-m 1` échouera en disant que
ce n'est pas un merge — dix minutes perdues sous stress).

```bash
git switch -c revert/<sujet-court> origin/main
git revert <sha-fautif>            # PAS de -m 1 : squash merge
npm run verify                     # le gate local avant de pousser
git push -u origin HEAD
```

Le préfixe `revert/` est **exempté du gel** : la PR s'ouvre ready, s'arme, passe les checks
requis, merge seule et redéploie. Suivez-la jusqu'au merge (DoD §8).

### 4. Vérifier l'axe base — obligatoire

Voir la section suivante. Ne sautez pas cette étape parce que « la prod remarche ».

### 5. Dégeler

Seulement une fois le revert mergé et `main` == prod :

```bash
gh workflow run rollback-prod.yml -f mode=unfreeze -f reason="revert #NNN mergé, prod stable"
```

Le mode `unfreeze` remet `MERGE_FREEZE=0` **et réarme** les PR éligibles (le gel les avait
désarmées ; elles ne recevraient sinon aucun événement pour se réarmer seules).

### 6. Fermer proprement

- Ajouter le test de non-régression qui aurait attrapé la panne (skill `regression-guard`).
  Une panne prod sans test ajouté reviendra.
- Compléter et clore l'issue d'incident.

---

## L'axe base de données — le piège

**Les migrations sont forward-only et déjà appliquées.** `db-migrate-prod.yml` les applique à
la production **au merge**, avant même que le code arrive. Revenir en arrière sur le code ne
revient **jamais** en arrière sur le schéma.

Que le merge fautif contenait-il ?

| Cas                                                        | Risque après rollback du code                                                                                       | Action                                                                |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Aucune migration**                                       | aucun                                                                                                               | rien à faire                                                          |
| **Migration additive** (CREATE, ADD COLUMN, nouvelle RPC)  | aucun — l'ancien code ignore ce qu'il ne connaît pas ; c'est exactement pourquoi la DoD §7 impose l'additif d'abord | rien à faire, noter dans l'issue                                      |
| **Migration destructive** (DROP, REVOKE, RENAME, NOT NULL) | **élevé** — le code restauré peut appeler un objet qui n'existe plus                                                | restaurer depuis le dump pré-migration (ci-dessous)                   |
| **Migration de données** (UPDATE/DELETE en masse)          | données déjà transformées                                                                                           | [`backup-restore-runbook.md`](./backup-restore-runbook.md) scénario A |

La DoD §7 impose de livrer une migration destructive **dans un merge séparé, après** que le
code dépendant a disparu. Respectée, elle rend ce piège rare — mais c'est précisément le merge
qui l'enfreint qui vous amènera ici.

**Le filet** : `db-migrate-prod.yml` prend un `pg_dump` de la prod **avant chaque application**
et l'uploade en artifact `prod-pre-migration-<stamp>` (rétention **14 jours**).

```bash
# retrouver le run qui a appliqué la migration fautive, puis :
gh run download <run-id> -n prod-pre-migration-<stamp>
```

Restauration : [`backup-restore-runbook.md`](./backup-restore-runbook.md) § « Real restore ».

Vérifier où en est la prod côté schéma, sans rien modifier :

```bash
gh workflow run db-migrate-prod.yml -f mode=list   # lecture seule
```

---

## Les checkpoints — à quoi ils servent, comment les lire

Chaque lundi 06:00 UTC, `checkpoint-tag.yml` pose un tag annoté **`checkpoint/AAAA-Wnn`** sur le
commit de `main` le plus récent qui réunit **`verify` vert ET un nightly vert** (Playwright E2E +
pgTAP) **sur ce commit exact**.

Pourquoi pas simplement le tip du lundi : le tip ne prouve que `verify` (lint, types, unit,
build, smoke shell). Les suites qui attrapent « l'app est morte dans un navigateur » ou « une
migration ne s'applique pas » tournent la nuit, sur le commit que `main` désignait à 01:00 UTC.
Un point de retour adossé à la moitié des preuves est une supposition déguisée en tag. La
sélection remonte donc les nightlies récents et retient le premier commit sur lequel **les deux
signaux sont d'accord** — jamais le calendrier.

**Aucune semaine verte ⇒ aucun tag**, et une issue `checkpoint-missing` dit pourquoi. Une
semaine sans checkpoint est un fait à voir ; un checkpoint qui ment est une seconde panne
pendant la première.

Lire un checkpoint :

```bash
git fetch --tags
git tag -l 'checkpoint/*' --sort=-creatordate | head -5
git show checkpoint/2026-W30            # l'annotation : commit, version, TÊTE DE SCHÉMA, déploiement, preuves
```

L'annotation porte la **tête de migration à ce commit**. C'est le nombre à comparer à la prod
avant de décider qu'un retour à ce checkpoint est sûr : tout ce qui a été appliqué depuis est
un delta que le code du checkpoint ne connaît pas.

Revenir à un checkpoint (levier 3, quand on ne sait pas quel merge a cassé) :

```bash
git switch -c revert/retour-checkpoint-<date> origin/main
git revert --no-commit checkpoint/2026-W30..origin/main   # défait tout depuis le checkpoint
git commit -m "revert: retour au checkpoint 2026-W30 (incident prod du <date>)"
npm run verify && git push -u origin HEAD
```

> On **reverte vers** le checkpoint, on ne force-push pas `main` dessus : le ruleset interdit
> le force-push, et l'historique d'un incident doit rester lisible.

Le déploiement Vercel noté dans l'annotation permet aussi de repromouvoir exactement l'artefact
qui a été prouvé vert : `-f target=<url du déploiement>`.

---

## Si le rollback ne suffit pas

Le levier 1 n'a rien changé ⇒ la panne n'est pas dans le code déployé. Regardez, dans cet ordre :

1. **La base.** Une migration destructive appliquée casse aussi bien l'ancien code que le
   nouveau. `gh workflow run db-migrate-prod.yml -f mode=list`, puis l'axe base ci-dessus.
2. **Supabase.** Projet en pause (offre gratuite), quota atteint, incident fournisseur —
   dashboard Supabase + [status.supabase.com](https://status.supabase.com).
3. **Les variables d'environnement Vercel.** Une clé changée casse toutes les versions d'un
   coup. `docs/environment-variables.md`. ⚠️ Les `VITE_*` sont **inlinées au build** : les
   changer impose un redéploiement **sans cache**, un rollback ne suffit pas.
4. **Vercel lui-même** — [vercel-status.com](https://www.vercel-status.com).

---

## Détection — le trou connu

**Il n'y a aujourd'hui ni endpoint de santé, ni monitor d'uptime, ni Sentry** (suivi au backlog
qualité, voir `ci-cd-and-branch-protection.md`). En pratique la panne se découvre par un
signalement, ou parce que quelqu'un ouvre le site.

Ce que ça implique : **le délai de détection domine le RTO**, et aucun outil ne le raccourcit
aujourd'hui. La contre-mesure disponible est de regarder la prod après chaque merge notable
(le `smoke:shell` de la CI attrape déjà la classe de panne du 2026-07-01, mais sur le bundle,
pas sur la prod réelle).

---

## Objectifs de temps

| Étape                                       | Cible                                                           |
| ------------------------------------------- | --------------------------------------------------------------- |
| Détection                                   | non outillée — voir ci-dessus                                   |
| Décision → prod restaurée (levier 1)        | **< 5 min**                                                     |
| `main` == prod (levier 2, cycle CI complet) | **< 30 min**                                                    |
| Restauration base (levier 4)                | ~1 h, RPO ≈ 24 h ([runbook dédié](./backup-restore-runbook.md)) |

---

## Ce qui doit être configuré (une fois)

| Élément             | Où                  | Rôle                                                                       | État                              |
| ------------------- | ------------------- | -------------------------------------------------------------------------- | --------------------------------- |
| `VERCEL_TOKEN`      | Secrets → Actions   | rollback scripté                                                           | **à créer**                       |
| `VERCEL_PROJECT_ID` | Secrets → Actions   | idem (Vercel → Project Settings → Project ID)                              | **à créer**                       |
| `VERCEL_ORG_ID`     | Secrets → Actions   | idem, scope équipe                                                         | **à créer**                       |
| `GH_AUTOMATION_PAT` | Secrets → Actions   | doit aussi porter **Variables: read and write** pour écrire `MERGE_FREEZE` | ✅ existe (permission à vérifier) |
| `MERGE_FREEZE`      | Variables → Actions | le gel. Absente = normal                                                   | créée à la volée par le workflow  |
| `PROD_URL`          | Variables → Actions | facultatif, défaut `https://na9ranal3ab.vercel.app`                        | —                                 |

Sans les secrets Vercel, `rollback-prod.yml` **échoue avec le mode d'emploi du dashboard** : le
levier manuel reste disponible, mais il n'est plus mesuré en secondes.

---

## Exercice (à faire une fois, puis après tout changement de la chaîne)

Un runbook non répété est une fiction. Le cycle complet, hors incident :

1. `gh workflow run rollback-prod.yml -f mode=freeze-only -f reason="exercice"` — vérifier
   qu'une branche ordinaire poussée ouvre bien une PR **draft**, et qu'une branche `revert/…`
   s'ouvre bien ready et armée.
2. `gh workflow run rollback-prod.yml -f mode=unfreeze -f reason="fin d'exercice"` — vérifier
   que les PR éligibles se réarment.
3. Vérifier qu'un `checkpoint/*` récent existe et que `git show` affiche bien sa tête de schéma.
4. Le rollback Vercel lui-même se répète sur une fenêtre calme : repromouvoir le déploiement
   précédent, vérifier la prod, repromouvoir le courant.

L'exercice de restauration base a son propre rythme (mensuel) —
[`backup-restore-runbook.md`](./backup-restore-runbook.md).

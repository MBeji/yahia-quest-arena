`MERGE_FREEZE` est **actif** : `automerge.yml` désarme toute PR ordinaire, et la
chaîne ne merge plus. Seules les branches `hotfix/*` et `revert/*` passent — avec
le gate complet, comme d'habitude.

**Si c'est un incident en cours** : rien à faire. Cette issue se fermera d'elle-même
au dégel. Elle est là pour que le gel reste visible, pas pour vous presser.

**Si c'est un exercice, ou un oubli** — le cas le plus fréquent, et il a déjà coûté
trois heures le 2026-07-27 :

```bash
gh workflow run rollback-prod.yml -f mode=unfreeze -f reason="fin d'exercice"
```

Le symptôme d'un gel oublié est trompeur : les PR affichent `CLEAN`, tous les checks
verts, `mergeable=MERGEABLE` — et ne partent jamais, parce qu'`automerge.yml` les
désarme derrière vous.

⚠️ **Le gel n'est pas opposable** : il agit sur l'armement de l'auto-merge, pas sur
le ruleset. Une PR armée à la main passe malgré lui. Vérifiez donc l'état du gel
**avant** d'armer quoi que ce soit.

Procédure complète : `docs/prod-rollback-runbook.md`, § « Le gel ».

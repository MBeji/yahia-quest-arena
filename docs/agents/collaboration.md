# Collaboration multi-agents — conventions opérationnelles

> Playbook (étude 25 D-7 / §5.4). Plusieurs sessions IA — et des humains — travaillent ce dépôt
> **en même temps**. Ce fichier dit comment ne pas se marcher dessus. La règle-mère est dans
> AGENTS.md : **la PR est le seul point de rendez-vous**, aucune coordination par mémoire d'outil
> ou canal privé.

## Identifier qui fait quoi

- **Préfixe de branche = auteur** : `claude/…`, `codex/…`, `humain/<pseudo>/…`. La chaîne
  auto-PR est agnostique au préfixe (seuls `wip/`, `draft/`, `rescue/` changent le comportement,
  en ouvrant une PR _draft_).
- **Réservation d'une étude** : la cellule « statut » de l'index porte `en exécution (<pseudo>)`
  — procédure dans `FableEtudes/CONTRIBUER.md` §4, **dans le dépôt privé** `yahia-quest-content`
  (les études y ont migré avec le corpus, étude 24).
- **Un lot = une session = une PR**, sur un jeu de fichiers **disjoint** des lots actifs. Si deux
  lots doivent toucher les mêmes fichiers, ils ne sont pas parallélisables : en séquencer un.

## Vérifier l'ordre réel avant de prendre un lot

L'ordre écrit dans `FableEtudes/ROADMAP.md` (dépôt privé) est un **raccourci**.
L'étude fait foi sur les dépendances entre ses lots. Avant de démarrer :

1. lire le §« plan d'exécution » de l'étude (quels lots sont réellement indépendants) ;
2. regarder ce que les **autres files** livrent en ce moment (`gh pr list`, worktrees actifs) ;
3. si un lot d'une autre étude **contredit** le tien, ne pas l'exécuter en force : prendre un
   lot frère indépendant, et **amender la ROADMAP** pour que la session suivante voie la
   contrainte.

_Cas vécu (2026-07-20)_ : é25 lot 3 (miroir des skills dans `.agents/skills/`) aurait dupliqué
dans le dépôt public exactement les skills que é24 lot 3b (« dégraissage public ») en retirait.
Conflit de **doctrine**, invisible dans un diff. Lot 4 pris à la place, ROADMAP amendée.

## Congestion : quand `main` avance plus vite que tes checks

Sur ce dépôt, une dizaine de PR peuvent merger en une heure, alors qu'un cycle de checks dure
~4 min. Une PR peut donc devenir `behind` **pendant** que ses checks tournent.

Ce que l'automatisation fait toute seule (`automerge.yml`) — **la laisser faire** :

- merger `main` dans ta branche pour la remettre à jour ;
- au besoin, fermer la PR et en **rouvrir une autre (numéro différent)** sur le nouveau head ;
- poser le label `needs-rebase` quand la mise à jour échoue sur un conflit.

Ce que la session doit faire :

- **ré-identifier la PR courante à chaque contrôle** : `gh pr list --head <branche> --state all`
  — le numéro noté dix minutes plus tôt peut être périmé ;
- avant de rebaser à la main, `git fetch` et comparer : si un merge-commit de l'automatisation
  existe déjà, faire `git reset --hard origin/<branche>` plutôt que rebaser en double ;
- ne **jamais** conclure « c'est mergé » sur un champ d'API seul — le prouver par un fait :
  `git fetch origin main && git ls-tree origin/main --name-only <chemin livré>` ;
- attention aux boucles d'attente : `until [ "$(gh pr view N --json mergedAt --jq .mergedAt)" != "null" ]`
  **sort aussi sur une réponse vide** (erreur réseau) et annonce un faux merge. Traiter
  explicitement `null | "" | erreur` comme « continuer ».

## Le titre de squash est figé au push — et c'est le sujet de `HEAD`

`auto-pr.yml` compose le titre de la PR avec `git log -1 --pretty=%s "$HEAD_SHA"` (étape
« Create the PR if none is open ») puis **arme l'auto-merge dans la même exécution du même job**
(étape « Arm auto-merge »). Le message de squash est donc figé à cet instant : renommer la PR
ensuite ne change plus rien à ce qui atterrira sur `main`.

Ce n'est pas un accident, c'est la procédure documentée qui y mène. La § « Execution policy »
d'AGENTS.md met `git rebase` hors jeu et autorise `git merge origin/main` pour rattraper `main` :
une session qui suit la consigne à la lettre se retrouve avec un **commit de merge en tête**, et
`main` reçoit un squash intitulé « Merge remote-tracking branch 'origin/main' into claude/… ».
Le cas est encore lisible dans l'historique — `b88ff517` (PR #844, 2026-08-24) ; mécanisme
re-constaté le 2026-08-26 sur la PR #881.

Le geste, juste avant chaque push :

```bash
git log -1 --pretty=%s
```

Si la réponse commence par `Merge`, replier la branche en un seul commit dont le sujet est celui
qu'on veut voir sur `main` :

```bash
git reset --soft origin/main && git commit
```

Deux garde-fous :

- les hooks restent **actifs** — `pre-commit` (lint-staged) et `pre-push` (`verify`) rejouent
  normalement ; jamais de `--no-verify` (DoD §2) ;
- prouver que l'arbre n'a pas bougé : `git diff <ancien-HEAD> HEAD` doit être **vide**. Noter le
  SHA avant le `reset` — après, il ne se retrouve que par `git reflog`.

## Doublons de sauvetage

Le sweep de fin de session (DoD §8) invite à rescaper les PR en `needs-rebase`. Une autre session
peut donc créer une branche `…-rebased` portant **le même travail** que la tienne. Si les deux PR
sont identiques : en garder une (celle dont l'historique est continu), fermer l'autre avec un
commentaire qui dit où vit le travail. Souvent inutile de se précipiter — quand la jumelle merge,
le doublon devient un diff vide et se ferme seul.

## Reprendre une branche dont la PR a déjà mergé

`auto-pr.yml` merge en **squash** puis **supprime la branche** (`--delete-branch`). Deux
conséquences qui coûtent une heure quand on les découvre en direct (vécu le 2026-08-22, é29) :

**1. Le nom de branche est libre, l'historique ne l'est plus.** Une session à qui on assigne une
branche nommée (`claude/<sujet>`) et dont la PR vient de merger doit **repartir de `main`** :

```bash
git fetch origin main && git checkout -B claude/<sujet> origin/main
```

Puis pousser normalement — la branche n'existe plus côté remote, le push la recrée, `auto-pr`
ouvre une **nouvelle** PR. Ne jamais empiler la suite sur l'ancien historique.

**2. Si la branche distante existe ENCORE (suppression non faite, ou push arrivé avant le merge),
ne pas la « réconcilier ».** Le réflexe — merger l'ancienne branche dans la nouvelle pour éviter un
push forcé — produit une volée de conflits `add/add` : la base de fusion précède la PR mergée, donc
git voit chaque fichier livré comme ajouté **des deux côtés**. On peut résoudre en gardant `--ours`
partout, mais la PR qui en sort embarque tout l'ancien historique, affiche un diff énorme, et
**retombe en conflit** au premier merge concurrent. Le bon geste est
`git push --force-with-lease` : la branche ne contient que de l'historique déjà sur `main`, il n'y
a rien à perdre. Si l'outil refuse le `--force-with-lease`, demander plutôt que contourner.

**3. La ref de suivi LOCALE survit à la suppression distante — et fait mentir tout ce qui compare
`HEAD` à `origin/<branche>`.** `origin/claude/<sujet>` reste figée sur le dernier push d'avant le
merge. Un outil qui répond à « qu'est-ce qui n'est pas poussé ? » en lisant cette ref voit alors
les commits de `main` **eux-mêmes** comme en attente — vécu deux fois le 2026-09-04, où trois
commits annoncés « non poussés » étaient les squashes de trois PR déjà mergées. Le test qui
tranche, et le remède :

```bash
git ls-remote origin <branche>   # aucune ligne ⇒ la branche n'existe plus côté serveur
git remote prune origin          # retire les refs de suivi périmées
```

⚠️ `git rev-list --count origin/main..HEAD` valant `0` ne dit **pas** `HEAD == origin/main` :
il dit « rien à pousser », ce qui reste vrai quand `main` a avancé sans nous. Lu comme une égalité, il
fait passer un `main` en retard de trois commits pour un arbre à jour — et, au moment où l'on
compare enfin les SHA, pour un merge fantôme. La vérité serveur est `git ls-remote`, pas une ref
locale.

⚠️ Et **ne jamais relancer un second `git push` par-dessus un premier encore en cours** : le hook
`pre-push` rejoue `verify` (~2 min), deux pushes concurrents se marchent dessus et le second meurt
sur `cannot lock ref … unable to resolve reference`, en laissant croire à un rejet du serveur.

## Fichiers à forte contention

Ici : **`STATUS.md`**. Dans le dépôt privé : `FableEtudes/README.md` (index) et
`FableEtudes/ROADMAP.md`. Presque toutes les sessions les modifient → conflit fréquent.
Résolution type : **prendre la version de `main`** (structure à jour, lignes des autres études)
et **y réappliquer sa seule ligne**. Ne jamais écraser le bloc entier avec sa propre version.

⚠️ **Depuis la scission (étude 24), le suivi d'une étude et le code qu'elle produit peuvent vivre
dans deux dépôts différents.** Un lot de l'étude 25, par exemple, livre du harness **ici** mais
coche sa case et écrit son journal **là-bas**. Prévoir les deux gestes, et dire dans la PR
publique où est allé le suivi — sinon le travail paraît non tracé.

## Le numéro d'étude se réserve au merge

Deux sessions peuvent rédiger « l'étude 26 » en parallèle. Re-vérifier `origin/main` juste avant
de pousser ; si le numéro est pris, renuméroter partout (dossier, titre, index, renvois).

## Drill de portabilité (étude 25 lot 7)

Protocole rejouable pour mesurer les KPI de l'étude 25 — **nécessite Mohamed** (installation
d'une 2ᵉ tête) :

1. Choisir un lot calibré (petit, testable, sans DB) parmi les lots ouverts.
2. Le confier à une tête **non-Claude** (Codex CLI ou Gemini CLI) sur un worktree neuf, sans
   aucun fichier d'instructions écrit pour elle — elle ne doit lire que `AGENTS.md` et les
   skills du dépôt.
3. Chronométrer le setup et noter **chaque** friction (fichier manquant, règle non comprise,
   commande refusée).
4. Le lot est réussi si sa PR passe le DoD **sans qu'on ait touché au harness** pour l'aider.
5. Chaque friction devient une issue ; le rapport va au journal de l'étude 25.

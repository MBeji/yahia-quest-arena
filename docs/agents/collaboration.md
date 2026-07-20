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
  — procédure dans [`FableEtudes/CONTRIBUER.md`](../../FableEtudes/CONTRIBUER.md) §4.
- **Un lot = une session = une PR**, sur un jeu de fichiers **disjoint** des lots actifs. Si deux
  lots doivent toucher les mêmes fichiers, ils ne sont pas parallélisables : en séquencer un.

## Vérifier l'ordre réel avant de prendre un lot

L'ordre écrit dans [`FableEtudes/ROADMAP.md`](../../FableEtudes/ROADMAP.md) est un **raccourci**.
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

## Doublons de sauvetage

Le sweep de fin de session (DoD §8) invite à rescaper les PR en `needs-rebase`. Une autre session
peut donc créer une branche `…-rebased` portant **le même travail** que la tienne. Si les deux PR
sont identiques : en garder une (celle dont l'historique est continu), fermer l'autre avec un
commentaire qui dit où vit le travail. Souvent inutile de se précipiter — quand la jumelle merge,
le doublon devient un diff vide et se ferme seul.

## Fichiers à forte contention

`FableEtudes/README.md` (index), `STATUS.md` et `FableEtudes/ROADMAP.md` sont modifiés par presque
toutes les sessions → conflit fréquent. Résolution type : **prendre la version de `main`**
(structure à jour, lignes des autres études) et **y réappliquer sa seule ligne**. Ne jamais
écraser le bloc entier avec sa propre version.

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

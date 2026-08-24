# Zéro intervention technique — la règle, et ce qu'elle interdit d'écrire

> **Règle du propriétaire, posée le 2026-08-23.** Elle vaut pour les trois dépôts —
> `yahia-quest-arena`, `yahia-quest-content` (privé), `ScribeKit` — et pour toute tête
> d'exécution, quel que soit l'outil. En cas de conflit avec un autre document,
> [`AGENTS.md`](../../AGENTS.md) tranche ; sur ce sujet précis, c'est ce fichier qui dit
> l'intention.

## L'énoncé

Mohamed n'intervient **à aucun moment** dans l'exécution technique. Il ne valide pas d'action,
ne relit pas de PR, ne lance pas de commande, ne modifie pas de code, ne touche pas la base, ne
manipule pas d'outil, ne fait ni déploiement ni configuration ni migration ni maintenance.

Son rôle tient en cinq verbes : **commander** (le besoin fonctionnel), **prioriser**,
**choisir** (quand plusieurs options existent), **arbitrer**, **borner** (les contraintes et le
risque acceptable). Il est le décideur, pas l'exécutant.

Tout le reste appartient à la session : analyser, écrire le code, lancer les commandes, gérer
les dépôts et la base, jouer les tests, lire les résultats, corriger, vérifier, mener les PR
jusqu'au merge, poser les garde-fous, garantir la non-régression, automatiser.

**Objectif final : zéro intervention technique manuelle de sa part.**

## Le test, quand on hésite

Une seule question : **est-ce une décision, ou est-ce de l'exécution ?**

- « Faut-il ouvrir la 2ᵉ sec avant la 1ʳᵉ ? » → décision. Elle remonte.
- « Le secret est mal formé, il faut le reposer » → exécution. Elle ne remonte pas — on le fait,
  ou on supprime le besoin (voir plus bas).

Le piège est la question d'exécution **déguisée en décision** : « veux-tu que je lance le
test à blanc du rollback ? » n'est pas un arbitrage, c'est une permission — et la demander,
c'est déjà violer la règle. Si l'action est autorisée par [`harness/policy.json`](../../harness/policy.json),
on la fait et on rend compte.

## Ce qu'on fait d'une étape qui « demande un humain »

Dans l'ordre, et on ne descend d'un cran que si le précédent est impossible :

1. **La faire.** C'est le cas par défaut.
2. **Supprimer le besoin.** Souvent la meilleure réponse, et la moins cherchée. Exemple vécu le
   2026-08-23 : le triage des signalements était mort depuis 25 jours parce qu'un secret GitHub
   avait perdu son `https://`, et rien dans le dépôt ne pouvait le réparer. La réponse n'était
   pas « demander à Mohamed de reposer le secret » — c'était de constater que **cette URL n'est
   pas un secret** (elle part dans chaque bundle client) et de la faire dériver de
   `PROD_SUPABASE_API_URL` ([`scripts/shared/prod-targets.mjs`](../../scripts/shared/prod-targets.mjs)).
   Une valeur dérivée ne dérive pas ; une entrée qui vit dans le dépôt se répare par une PR.
3. **L'intégrer au harness** : un workflow, un gate, une entrée `ops-dispatch` argumentée dans
   `policy.json`. Le geste devient reproductible et relu.
4. **La rendre visible**, à défaut de l'automatiser : une garde programmée qui rougit doit
   ouvrir une issue. Un rouge que personne ne regarde n'est pas une alerte — c'est la panne
   de 25 jours ci-dessus, que seul un audit fortuit a trouvée.
5. **La remonter** — en dernier recours, en nommant le mur (liste ci-dessous) et l'action
   exacte, jamais « il faudrait que tu regardes ».

## Les murs — ce qu'aucun harness ne lèvera

Les nommer honnêtement fait partie de la règle : une liste de blocages faux la fait pourrir
plus vite qu'une liste courte et vraie.

| Mur                                    | Pourquoi il tient                                                                                                                                                                               | Ce qui le lèverait                                                     |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| **Le classifieur d'auto-mode**         | Il vit chez l'éditeur de l'outil, pas dans le dépôt : une commande peut être `allow` dans `policy.json` et refusée quand même (vécu sur `harness:sync`, puis sur `gh secret set` le 2026-08-23) | Rien côté dépôt. Une règle de permission côté poste                    |
| **Les secrets et réglages hors dépôt** | Secrets GitHub, variables Vercel, console Supabase : la session n'a pas les identifiants de prod, **par conception** — c'est le filet, pas un oubli                                             | Voir l'étape 2 : supprimer le besoin du secret                         |
| **GitHub Free sur le dépôt privé**     | Rulesets et protection de branche sont réservés aux dépôts publics sur ce compte : aucun check _requis_, donc pas d'auto-merge natif. La Content CI privée est **indicative**                   | **Rien — arbitré le 2026-08-24 : on reste en gratuit.** Ne pas rouvrir |
| **Les décisions non codables**         | Conformité mineurs, équilibrage de gameplay, arbitrage éditorial : elles dépendent de choses qu'aucun registre ne porte                                                                         | Rien. C'est son métier, pas le nôtre                                   |

## Règle de maintenance de ce fichier

Toute ligne « en attente d'un humain », où qu'elle soit écrite — [`STATUS.md`](../../STATUS.md),
une ROADMAP, un en-tête de workflow — **doit citer un mur du tableau ci-dessus**. Sinon elle est
fausse par défaut, et se traite comme un bug : on la vérifie sur `main`, on fait le geste, on
raye la ligne.

Ce n'est pas de la théorie. Le 2026-08-23, la liste « Ce qui attend un humain » de `STATUS.md`
comptait cinq entrées : **deux étaient fausses** — le test à blanc du rollback avait été joué le
2026-07-27 (huit dispatches verts), et le « rituel de triage à démarrer » tournait déjà six fois
par jour… en échec depuis 25 jours. Une liste de blocages ne se relit pas, elle se **constate**
— même règle que pour les statuts d'études.

Et la règle mord son auteur : le lendemain, dans ce fichier même, j'ai écrit que huit branches
du dépôt de corpus portaient du travail « jamais livré ». C'était faux — les huit étaient
livrées. L'erreur venait d'avoir **déduit** au lieu de constater : `git rev-list origin/main..<branche>`
ne prouve rien sur un dépôt qui merge en **squash**, où les commits d'origine ne sont jamais des
ancêtres de `main`, livrés ou non. Le seul test valable est le **contenu** — le fichier est-il
sur `main`, et à quelle version. Un chiffre spectaculaire mérite une vérification proportionnée
à ce qu'il va justifier.

## Ce que le mur « GitHub Free » coûte vraiment, et ce qu'on a construit dessous

L'arbitrage du 2026-08-24 (rester en gratuit) ne rend pas le dépôt de corpus manuel : il
interdit seulement de rendre le gate **opposable**. Tout le reste s'automatise, et l'a été.

- **`auto-pr.yml`** y ouvre désormais la PR de toute branche poussée. Sans lui, une branche
  poussée par une session qui s'arrête reste sans PR : **8 branches `claude/*` traînaient ainsi,
  jusqu'à cinq semaines.** ⚠️ J'ai d'abord écrit qu'elles portaient du travail « jamais livré » —
  **c'était faux**, le tri a montré que les huit étaient livrées, et elles ont été supprimées.
  Le vrai problème n'est donc pas la perte, c'est que **rien ne permettait de distinguer** une
  branche livrée-mais-non-nettoyée d'un lot réellement perdu : il a fallu un audit forensique un
  mois plus tard. Une PR ouverte à la poussée rend la distinction visible sur le moment.
- **`guard-watch.yml`** (les deux dépôts) ouvre une issue dès qu'un workflow programmé rougit.
  Il existe parce que ce dépôt-ci a laissé `report-triage.yml` mourir 26 jours en criant dans
  un onglet que personne n'ouvrait.
- **Trois pièges propres au gratuit**, tous rencontrés en une journée et tous documentés dans
  les fichiers concernés : une PR ouverte par le `GITHUB_TOKEN` n'émet pas d'événement
  `pull_request` (il faut dispatcher ses checks) ; la **fin** d'un run ainsi dispatché n'émet
  pas de `workflow_run` (il faut réveiller `automerge` explicitement) ; et les runs
  `pull_request` d'une PR de robot restent en `action_required`.
- **Ce qui reste vrai** : rien n'**empêche** de merger une PR rouge au privé. La parade n'est
  pas technique, elle est dans cette règle — personne ne merge à la main, ni Mohamed ni une
  session.

Corollaire pour les gardes : ce qui coûte cher sur un dépôt **privé**, c'est le `schedule` —
chaque job est facturé à la minute entamée, sur 2 000 mensuelles. Un filet se branche sur
l'événement qui manque, jamais sur un balayage périodique « au cas où ».

Voir aussi [`collaboration.md`](./collaboration.md) (la PR comme seul point de coordination),
[`gardes.md`](./gardes.md) (les workflows de garde) et la DoD §8 d'`AGENTS.md` (la session qui
pousse reste de garde jusqu'au merge réel — le versant CI/CD de cette règle, posé le 2026-07-12).

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

## Le journal des élargissements de la politique

`harness/policy.json` dit **ce que** la session peut lancer ; cette section dit **pourquoi**, et
depuis quand. Les deux vivaient dans le même fichier — 7 300 caractères d'histoire au-dessus de
92 lignes de JSON — jusqu'à l'étude 32 (D-7). Un fichier de règles n'est pas un journal : on y
cherche « pourquoi `git rebase` est-il dehors ? », pas un récit. Le fichier garde une ligne de
raison par famille (`allow.$why`, exigée par `harness:check`) ; le récit est ici.

**Règle qui vaut pour toute la section** : ouvrir une famille n'ouvre jamais ce que la liste de
dénis protégeait. Chaque élargissement ci-dessous s'est accompagné du déni qui le borne.

### 2026-07-19 — la politique naît déclarative (étude 25, D-4)

Les ~45 `allow` et 4 `deny` du réglage d'outil deviennent un fichier versionné, avec une raison
sur chaque déni. `ops-dispatch` est la seule exception à `gh-readonly` : les workflows
déclenchables sont nommés **un par un**, jamais `gh workflow run:*` — le joker donnerait aussi
`db-migrate-prod.yml`. La plupart sont réversibles (le gel/dégel de `rollback-prod`) ou en
lecture seule sur la prod (`db-backup` fait un dump, `db-tests` joue pgTAP sur une base jetable).

Les deux entrées `apply-content*` **écrivent** la prod, et c'est l'exception assumée (arbitrage
du propriétaire, 2026-07-28) : une campagne de contenu est prescrite de bout en bout, et publier
était la seule étape qu'elle ne pouvait pas franchir. Ce qui les rend acceptables : elles ne
publient **rien de neuf** — seulement le SQL compilé d'un corpus qu'une PR mergée et les gates de
la Content CI ont déjà validé, de façon idempotente, journalisée dans `content_releases`, sans
aucune migration.

### 2026-08-22 — `e2e-auth` passe de `deny` à `allow`, et c'est le seul mouvement dans ce sens

Il était dénié pour un incident réel : le run pointait le navigateur sur une préviusualisation
Vercel via `PLAYWRIGHT_BASE_URL`, dont la couche SSR porte les secrets Supabase de PROD, et un
spec a déposé une vraie ligne `content_reports` en production **trois nuits de suite** (#614 ;
#638 est le même trou revu, clos NOT_PLANNED une fois #618/#621 livrés).

Trois choses l'ont refermé, et l'entrée repose sur les trois : le workflow ne pose plus du tout
`PLAYWRIGHT_BASE_URL` (Playwright lance son propre serveur local, nourri des secrets
`TEST_SUPABASE_*`) ; son `workflow_dispatch` ne déclare **aucune entrée**, donc un dispatcheur ne
peut pas rediriger le run ; et `findProdTarget` (`scripts/shared/prod-targets.mjs`) refuse depuis
**trois endroits indépendants** si une URL résout vers la référence ou un hôte de prod — un
secret TEST mal réglé échoue bruyamment au lieu d'écrire la prod.

⚠️ Le risque résiduel qu'accepte cette entrée est le même que pour `apply-content` :
`gh workflow run --ref <branche>` exécute le workflow **tel qu'il est défini sur cette branche**,
et les trois garde-fous vivent dans des fichiers que la branche pourrait éditer. Le filet, là,
c'est la revue de PR — pas ce fichier. À re-dénier le jour où ce workflow gagne une entrée
d'URL de base, ou repointe vers un déploiement.

### 2026-08-23 — le plus gros élargissement, et son déclencheur

La règle du propriétaire devient **zéro intervention technique** : une demande de permission EST
une validation manuelle, donc une politique dont le défaut est « demander » était elle-même ce
qu'on voulait supprimer. Quatre familles s'ouvrent, l'option la plus large ayant été choisie avec
ses contreparties nommées :

- **`git-write`** — la boucle de livraison (`add`/`commit`/`push`/`checkout`/`switch`/`restore`),
  plus `git merge origin/main`, la façon documentée de résoudre un fichier contesté. `rebase` et
  `stash` restent **dehors** : le premier parce que la résolution documentée est un merge, le
  second parce que le checkout est partagé entre sessions.
- **`gh-write`** — le cycle PR/issue qu'une session possède déjà sous la DoD §8.
- **`repo-config`** — `gh secret set` / `gh variable set`. C'est celle qui ferait lever un
  sourcil, donc voici son dossier : le 2026-08-23, le triage des signalements a été trouvé mort
  **depuis 25 jours** parce qu'un secret GitHub avait perdu son `https://`, et **rien dans le
  dépôt ne pouvait réparer une valeur qui vit dehors**. Ce trou précis a été refermé mieux que
  par une permission (l'URL n'était pas un secret — elle part dans chaque bundle client — et se
  dérive désormais), mais la classe demeure : un secret qui pourrit est une panne qu'aucune PR ne
  répare. Poser un secret est une réparation avec une cible nommée ; en **supprimer** un ne l'est
  pas, et c'est dénié.
- **`repo-scripts`** — `npm install` (jamais `npm ci` : le checkout est partagé) et
  `node scripts/…`.

`ops-dispatch` gagne au passage le trio `ci`/`migration-gate`/`codeql`, dont un mode de panne
documenté a besoin : `auto-pr.yml` sautait sa dispatch de secours quand un PAT existait, laissant
les checks requis figés en « Expected » — le remède était connu et n'était pas permis.

**Deux dénis nouveaux tiennent l'élargissement honnête**, parce qu'ouvrir une famille ne doit
jamais rouvrir en silence les portes que la liste protégeait : `node scripts/db/push-prod.mjs`
(le schéma de prod, désormais à l'intérieur de la famille ouverte) et `gh secret delete`.

**Un troisième a été écrit puis retiré avant livraison, et la raison mérite d'être gardée** :
dénier `gh pr merge` se lit bien — merger à la main est le geste humain que la chaîne du
2026-07-12 a supprimé — mais une règle de préfixe ne sait pas dire « sauf `--auto` », et
`gh pr merge --auto` est **la façon d'armer** l'auto-merge. Le déni aurait retiré la seule
réparation manuelle d'une PR qu'`auto-pr` n'a pas su armer, pour empêcher ce que la protection
de branche empêche déjà (une PR rouge ne merge pas, à la main ou non). C'est donc une **norme**,
pas une règle : une session surveille ses checks, elle ne merge pas autour d'eux.

### 2026-08-26 — passe de complétude : la liste était incomplète des DEUX côtés

Le trou se mesurait : 22 des 24 workflows portaient `workflow_dispatch`, `ops-dispatch` n'en
nommait que 17. Trois purement internes la rejoignent — `guard-watch` (la garde des gardes :
la relancer n'ouvre ou ne referme qu'une issue), `upgrade-guard` (il ouvre une PR, il ne merge
rien) et `auto-pr` (il arme une branche déjà poussée, et son mode de panne documenté est
justement de ne pas partir).

**Deux restent dehors, et c'est un choix qu'il fallait écrire une fois la liste complète par
ailleurs** : `tutor-digests.yml` frappe `/api/cron/digest` en PRODUCTION et fait rédiger des
bilans envoyés à de vrais élèves et à leurs parents ; `report-apply.yml` écrit des statuts de
signalement en prod, hors du chemin relu qui justifie `apply-content`. Aucun des deux n'est
« non-prod » : leur cron les fait tourner seuls, et un dispatch à la main n'a pas de motif qui
vaille l'ouverture. AGENTS.md disait « tous les non-prod » — la phrase promettait ces deux-là,
corrigée le même jour.

### 2026-09-04 — par familles, et les lectures cessent de demander (étude 32, D-7)

Vingt-et-une entrées `npm run <script>` nommées une à une deviennent `npm run:*` : `node
scripts/:*` ouvrait **déjà** tout ce que ces scripts appellent, donc les énumérer ne coûtait que
des invites — et il en manquait sept (`eol:check`, `harness:sync`, `perf:check`, `programme:*`,
`content:emit`, `content:figures:check`, `economy:check`). La contrepartie est écrite dans
`allow.$why` : **tout script npm qui écrirait la prod se dénie par nom le jour où il naît**,
comme `node scripts/db/push-prod.mjs`.

Une famille **`shell-readonly`** apparaît, et elle répare une incohérence : `cat`, `grep`,
`head`, `jq`, `diff` n'étaient pas listés, donc ils **demandaient** — une validation manuelle sur
des commandes qui ne changent rien, c'est-à-dire exactement ce que la règle en tête de ce fichier
exclut. La liste est **close** et ne contient que des binaires qui ne savent pas écrire : ni
`find` (`-delete`, `-exec`), ni `sed`/`awk` (redirection, `-i`), ni `xargs`. Elle a la même forme
— et le même risque résiduel de commande composée — que `Bash(ls:*)` et `Bash(node scripts/:*)`,
acceptés avant elle.

### 2026-09-05 — tout est autorisé : l'option C de l'étude cloud-first, première exception à la règle de cette section

L'[étude cloud-first](./etude-cloud-first.md) (lot 2) posait un arbitrage : en session cloud, la
surface GitHub est le serveur MCP `github`, dont l'outil de dispatch ne connaît **pas** les noms
de workflows — la granularité « un par un » d'`ops-dispatch` n'existe pas, et il n'y a pas de
troisième chemin (pas de `gh`, REST brut refusé par le proxy). Trois options ont été mises devant
Mohamed avec leurs contreparties : **A** garder le dispatch et descendre la protection des deux
workflows interdits dans les workflows eux-mêmes (une variable de dépôt qu'aucune session cloud ne
peut poser) ; **B** refuser l'outil de dispatch aux sessions cloud, donc un clic humain sur chaque
rollback et chaque publication de corpus ; **C** aucun garde, tout autorisé. Il a choisi **C**, en
ces termes : « tout est autorisé, je veux que Claude soit autonome partout et ait tous les droits,
je prends le risque ».

Fait notable : la tentative d'appliquer A a été **refusée par le classifieur d'auto-mode** —
éditer `db-migrate-prod.yml` et `release.yml` par script a été bloqué. Le mur nommé en tête de ce
fichier s'est dressé devant le garde qui voulait le compléter. Puis, en appliquant C,
`npm run harness:sync` — la commande qui régénère `.claude/settings.json` — a été refusé à son
tour, exactement comme le 2026-08-23 : une famille `allow` dans la policy ne lève pas ce mur. La
seule parade a été de sortir la session du mode auto (« Accept edits », depuis le téléphone) le
temps de régénérer la vue — une règle de permission écrite dans le dépôt ne suffit pas.

Ce que C ouvre : la famille **`cloud-autonomy`** — `Bash` (toute commande), `mcp__github` (tout
l'outillage GitHub, dispatch compris), `mcp__Claude_Code_Remote` (sessions, réveils différés,
abonnements de PR), `mcp__Google_Drive` (les documents de classe B de l'étude). Ce que C ne touche
pas : les **huit dénis** restent et gagnent toujours (`db push`/`db reset`, `push-prod.mjs`,
`gh secret delete`, le dispatch par `gh` des deux workflows de prod) ; les hooks husky sur tout
`git push` ; l'absence d'identifiants de prod en session ; le classifieur.

Ce qui fait tenir C, en pratique, n'est pas la famille : c'est le **mode de démarrage**. La doc
de l'outil est explicite — en mode auto, une règle large comme `Bash` est **suspendue** et le
classifieur juge chaque commande ; et le classifieur ne lit sa configuration que hors du dépôt
(`~/.claude/settings.json`, réglages managés), jamais dans `.claude/settings.json`, précisément
pour qu'un dépôt ne puisse pas l'assouplir. Le levier légitime est `permissions.defaultMode`, que
les sessions cloud honorent : la policy porte donc `mode.default = acceptEdits`, compilé dans la
vue — les sessions de ce dépôt démarrent **sans classifieur**, et ce sont ces règles qui décident.
Dans une session déjà ouverte en mode auto, le sélecteur de mode reste le seul geste.

**C'est la première exception à la règle écrite en tête de cette section** — « ouvrir une
famille n'ouvre jamais ce que la liste de dénis protégeait » — et elle est assumée : depuis une
session cloud, `mcp__github` peut dispatcher `db-migrate-prod.yml` et `release.yml`, merger une PR
à la main (`merge_pull_request`) ou écrire un fichier par l'API sans passer par les hooks
(`push_files`). Rien ne l'interdit plus mécaniquement ; ce qui l'interdit est la **norme** : la
prod migre au merge (DoD §7), personne ne merge à la main (2026-07-12), le seul chemin d'écriture
est `git push`. Le jour où l'une de ces normes cède, la réponse est ici : remettre le garde de
l'option A, ou passer à l'option B — deux lignes de `policy.json` et deux `if:` de workflow.

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

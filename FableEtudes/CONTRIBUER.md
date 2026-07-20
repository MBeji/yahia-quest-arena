# Contribuer à une étude — guide du collaborateur

> **Pour qui ?** Un **développeur humain** qui rejoint le projet pour **prendre une étude de
> `FableEtudes/` et l'implémenter, lot par lot**. Tu joues le rôle **Exécuteur** (voir
> [`README.md`](./README.md) « Rôles ») : tu livres ce que l'étude spécifie, tu ne re-designes
> pas. Ce guide te met en route et te donne les règles du dépôt ; il ne remplace pas
> [`../AGENTS.md`](../AGENTS.md), qui reste **la source canonique** (commandes, conventions,
> Definition of Done — lu nativement par la plupart des outils IA ; `CLAUDE.md` en est un
> pointeur pour Claude Code). En cas de désaccord entre ce guide et AGENTS.md, **AGENTS.md
> gagne**.
>
> Tu veux plutôt **transcrire des sources (CNP, manuels du secondaire, document libre) et
> générer leur contenu** avec ton agent IA, sans rien connaître du projet ? Suis la méthode de
> référence [`METHODE-GENERATION-CONTENU.md`](./METHODE-GENERATION-CONTENU.md) — elle **boucle**
> classe par classe, matière par matière, chapitre par chapitre, et pousse une PR par lot. Ce
> guide-ci n'est pas requis.

## TL;DR (à lire en entier avant de commencer)

1. **Setup** : `npm install` (Node 22), crée ton `.env`, vérifie avec `npm run verify`.
2. **Lis, dans l'ordre** : [`../AGENTS.md`](../AGENTS.md) entier → [`../STATUS.md`](../STATUS.md) →
   l'`ETUDE.md` de ton epic entier → la section du lot qu'on te confie.
3. **Prends une étude `validée`** (pas un `brouillon` ni une `gelée`), **réserve-la** (§4).
4. **Un lot = une PR.** Tu pousses une branche → **une PR s'ouvre et se merge toute seule**
   quand les checks sont verts (§5). Surprise à connaître : **pousser une branche déclenche
   l'auto-merge.** Pour un point de sauvegarde non fini, préfixe ta branche `wip/`.
5. **Doute, ambiguïté, l'étude contredit le code → STOP** et remonte à Mohamed. Ne devine jamais
   (§8).

## 1. Ton rôle : Exécuteur

Le corpus `FableEtudes/` sépare trois rôles (détail dans [`README.md`](./README.md)) :

| rôle           | qui              | fait                                                                  |
| -------------- | ---------------- | --------------------------------------------------------------------- |
| **Architecte** | Mohamed + modèle | décide l'architecture, écrit l'étude, revoit les lots livrés          |
| **Exécuteur**  | **toi**          | implémente **un lot par PR**, tests inclus, gate verte, dans le cadre |
| **Humain**     | **Mohamed**      | valide les études, tranche les questions ouvertes, arbitre les écarts |

> L'étude est un **contrat d'exécution**, pas un ticket : toutes les décisions (tables, RPC, UI,
> sécurité, découpage en lots, tests exigés) y sont déjà prises pour que tu livres **sans
> re-décider l'architecture** et sans relire tout le repo. Quand l'étude et le code divergent, tu
> ne « corriges » pas l'étude : tu t'arrêtes et tu remontes.

## 2. Mise en route

**Prérequis** : Node 22 / npm 10, Git, un accès **collaborateur** (write) au dépôt GitHub
(demande-le à Mohamed — il t'ajoute dans Settings → Collaborators ; c'est ce qui fait fonctionner
l'auto-merge, §5).

```bash
git clone https://github.com/MBeji/yahia-quest-arena.git
cd yahia-quest-arena
npm install         # installe aussi les hooks git (husky) via le script "prepare"
cp env.example .env # puis renseigne les valeurs (voir ci-dessous)
npm run dev         # serveur de dev (SSR) sur http://localhost:...
```

**Variables d'environnement** : copie [`../env.example`](../env.example) en `.env` et renseigne
les **cinq clés Supabase requises** — la paire client `VITE_SUPABASE_URL` /
`VITE_SUPABASE_PUBLISHABLE_KEY` (inlinée au build), la paire serveur `SUPABASE_URL` /
`SUPABASE_PUBLISHABLE_KEY` (runtime SSR) et `SUPABASE_SERVICE_ROLE_KEY` (secret, jamais préfixé
`VITE_`). Sans elles, l'app affiche sa page d'erreur brandée. Le reste (Web Push, GA, Sentry) est
optionnel. Détail : [`../docs/environment-variables.md`](../docs/environment-variables.md).
Demande à Mohamed les identifiants d'un projet Supabase de **dev** — **jamais la prod**.

**Les commandes que tu utiliseras tout le temps** (toutes depuis la racine du repo) :

```bash
npm run verify     # lint + typecheck + tests — LE gate local (aucun backend requis)
npm run ci:verify  # gate complet : + coverage + build + audit + QA contenu (pour un lot release-grade)
npm run lint       # eslint --max-warnings=0 (politique zéro warning)
npm run typecheck  # tsc --noEmit (strict)
npm test           # vitest run
npm run test:watch # tests en watch pendant que tu codes
```

`npm run verify` tourne **sans Supabase** (les tests sont mockés) — c'est le minimum avant chaque
push. La liste complète des commandes (contenu, e2e, migrations) est dans
[`../AGENTS.md`](../AGENTS.md) « Essential commands ».

> **Ne contourne jamais les hooks git** (`--no-verify`) sans raison écrite : le `pre-commit`
> formate/lint les fichiers stagés, le `pre-push` rejoue `npm run verify`. Ils t'évitent de
> pousser du rouge.

## 3. Ordre de lecture obligatoire

Avant d'écrire une ligne de code, dans cet ordre :

1. [`../AGENTS.md`](../AGENTS.md) **en entier** — conventions, frontières features/shared,
   Definition of Done, pièges connus. Non négociable.
2. [`../STATUS.md`](../STATUS.md) — l'état réel du projet (phase gratuite, ce qui est live,
   travaux en vol). Ne fais confiance à aucune affirmation « est-ce que X est en prod ? » sans lui.
3. L'`ETUDE.md` de ton epic **en entier** (pas seulement ton lot) : contexte, règles métier
   (`R-x`), décisions d'architecture (`D-x`), stratégie de test, journal d'exécution.
4. La **section du lot** qui t'est confiée : périmètre exact, critères d'acceptation, tests
   exigés, et le **stop-point** (ce que tu ne dois PAS commencer).
5. Au besoin : [`../ARCHITECTURE.md`](../ARCHITECTURE.md) (approfondissement) et les `docs/*.md`
   que l'étude référence (ex. `docs/lycee-architecture.md`, `docs/interactive-question-types.md`).

## 4. Choisir & réserver une étude (coordination à deux)

Vous êtes deux à exécuter : la coordination évite les collisions.

**Quelles études sont « prenables » ?** Regarde le **statut** dans l'index de
[`README.md`](./README.md) et dans l'en-tête de chaque `ETUDE.md` :

| statut         | prenable ?                                                                              |
| -------------- | --------------------------------------------------------------------------------------- |
| `validée`      | ✅ **oui** — questions ouvertes tranchées, prête à démarrer au lot 1                    |
| `en exécution` | ⚠️ déjà commencée — ne prends un lot que si **personne d'autre** n'est dessus (demande) |
| `brouillon`    | ❌ **non** — l'architecture n'est pas figée ; demande à Mohamed de la **valider** avant |
| `gelée`        | ❌ **non** — bloquée par une décision produit (ex. sortie de la phase gratuite)         |

> Au moment d'écrire ce guide, la seule étude `validée` non commencée est la **17 (rappel actif)** ;
> 04 / 15 / 16 sont `en exécution`. Vérifie toujours l'état courant dans l'index — il bouge.

**Réserver une étude**, en trois gestes, pour que ton binôme voie que tu es dessus :

1. **Préviens Mohamed** (canal convenu) — il confirme que l'étude t'est attribuée.
2. Dans ta **PR du lot 1**, passe l'en-tête de l'`ETUDE.md` à `en exécution` et ajoute une ligne
   `> **Exécuteur** : <ton pseudo GitHub> (depuis AAAA-MM-JJ)`.
3. Dans la **même PR**, mets à jour la cellule « statut » de la ligne d'index dans
   [`README.md`](./README.md) → `en exécution (<ton pseudo>)`. C'est le tableau que ton binôme
   regarde : il devient la source visible de « qui fait quoi ».

**Nommage de branche** : `feat/etude-NN-lot-X-<slug-court>` (ou `fix/…`, `test/…`). Le numéro
d'étude + de lot dans le nom rend l'appartenance lisible et empêche deux branches de se marcher
dessus. ⚠️ **N'utilise pas** les préfixes `wip/`, `draft/`, `rescue/` pour du travail normal :
ils désarment l'auto-merge (§5).

## 5. Le cycle d'un lot : une PR qui se merge toute seule

**Règle d'or : un lot = une PR** sur une branche dédiée. Jamais deux lots dans une PR, jamais un
lot partiel silencieux. Message de commit conventionnel (`feat:`, `fix:`, `test:`, `chore:`…) dont
la description **référence l'étude** : `FableEtudes/NN-<slug>#lot-X`.

**Ce qui se passe quand tu pousses** (automatisation intégrale, décision 2026-07-12 — tu ne
demandes à personne de merger) :

1. Tu pousses une branche non-`main` → une **PR s'ouvre automatiquement, prête, avec l'auto-merge
   armé** (squash + suppression de la branche).
2. Elle **se merge seule** dès que les **checks requis** passent au vert sur une tête à jour :

   | check                | ce qu'il prouve                                                                 |
   | -------------------- | ------------------------------------------------------------------------------- |
   | `verify`             | lint + typecheck + tests + coverage + gate contenu + build + smoke prod + audit |
   | `Migration presence` | informatif : liste les migrations que la PR ajoute (toujours vert)              |
   | `Migration order`    | **bloquant** : refuse une migration horodatée avant la dernière sur `main` (§6) |
   | `CodeQL`             | analyse de sécurité statique (SAST) du code JS/TS                               |

3. Le merge sur `main` **déclenche le déploiement Vercel** et **applique les migrations** en prod.

**Tu possèdes ta PR jusqu'au merge réel** (Definition of Done §8) : surveille les checks
(`gh pr checks <n> --watch`), corrige tout rouge et re-pousse, confirme que le merge a bien eu
lieu, puis nettoie ta branche locale (la distante s'auto-supprime).

**Opt-out volontaire** (travail non fini que tu ne veux PAS voir mergé) : mets `[wip]`, `[draft]`
ou `[no-automerge]` dans le sujet du commit de tête, **ou** préfixe ta branche `wip/`/`draft/`/
`rescue/` → la PR s'ouvre en **draft**. Tu la promeus plus tard avec `gh pr ready`. Le label
`no-automerge` gèle une PR.

**`needs-rebase`** : si `main` avance et que la mise à jour auto de ta branche échoue sur un
conflit, ta PR est étiquetée `needs-rebase` — rebase-la (`git rebase origin/main`, résous, force-push)
et re-pousse. Avant de finir ta session, balaie `gh pr list` pour rattraper une PR `needs-rebase`
ou armée-mais-rouge.

Détail complet du dispositif : [`../docs/ci-cd-and-branch-protection.md`](../docs/ci-cd-and-branch-protection.md).

## 6. Base de données ↔ code (piège classique)

Si ton lot touche la base (nouvelle table, colonne, RPC), respecte l'ordre de
[`../AGENTS.md`](../AGENTS.md) « Definition of Done » §7 :

- Les migrations vivent dans `supabase/migrations/**` et **s'appliquent en prod au merge** (ne les
  applique **jamais** à la main — pas de SQL editor, pas de `db push` local sur la prod).
- **Migration additive** (CREATE/ADD) : elle peut partir **avant** le code qui l'utilise — livre-la,
  elle s'applique au merge, puis livre le code dépendant.
- **Migration destructive** (DROP/REVOKE) : dans un merge **séparé**, **après** que le code qui
  utilisait l'ancienne forme soit en prod.
- **Toute nouvelle table porte ses propres `GRANT`** (le stack CI ne les ajoute plus tout seul) —
  sinon la suite pgTAP casse sur une base fraîche.
- **Horodatage** : le préfixe `AAAAMMJJHHMMSS_` d'une nouvelle migration doit trier **après** la
  plus récente déjà sur `main`, sinon le check `Migration order` (§5) te bloque et la prod se
  fige. En cas de conflit, re-horodate le fichier.
- Toute logique SQL (RPC, trigger, RLS) s'accompagne de tests **pgTAP**.

## 7. Definition of Done (le minimum pour qu'un lot soit « fini »)

Résumé de [`../AGENTS.md`](../AGENTS.md) — lis la version complète, elle fait foi :

- ✅ **Gate verte** : `npm run verify` (et `ci:verify` pour un lot release-grade). Jamais « fini »
  sur un gate rouge.
- ✅ **Zéro affaiblissement du gate** : pas de `@ts-ignore`/`as any` pour esquiver les types, pas
  de règle ESLint désactivée en ligne, pas de seuil de coverage abaissé, pas de `--no-verify`.
- ✅ **Zéro dette** : pas de shim de compat, pas de code mort, pas de module dupliqué. Supprime ce
  que tu remplaces. Respecte les frontières (une feature n'importe jamais une autre feature).
- ✅ **Les tests voyagent avec le code** : tout comportement nouveau/changé a ses tests
  co-localisés dans le `__tests__/` de la feature. La coverage ne régresse pas.
- ✅ **Petits commits revus**, style conventionnel, branche partie de `main`.
- ✅ **Fin de lot** : coche la case du lot dans l'`ETUDE.md` (même PR) et note tout écart accepté
  dans la section « Journal d'exécution » de l'étude.

Il existe un raccourci : la commande `/verify` (skill) lance le gate pour toi.

## 8. STOP & escalade (la règle qui protège le projet)

**Le cadre est fermé** : tu implémentes ce que le lot spécifie — mêmes noms de tables/colonnes/
RPC/fichiers, mêmes frontières, mêmes invariants de sécurité. Si l'étude est **ambiguë,
incomplète, ou contredit le code réel** :

> **STOP.** N'improvise pas, ne re-designe pas en silence. Documente l'écart (commentaire de PR ou
> issue GitHub) et **demande l'arbitrage à Mohamed**. Reprends une fois tranché.

Un exécuteur ne crée jamais d'étude et ne modifie jamais l'architecture décidée. Un doute
sécurité est toujours un STOP + escalade.

## 9. Sécurité (non négociable)

- Toute **clé de réponse / donnée sensible reste server-side** (ex. `questions.correct_option`,
  `distractor_tags` ne sont jamais envoyés au client).
- **RLS** sur toute nouvelle table ; **validation zod** (`.inputValidator`) sur toute server fn.
- **Logging** via `@/shared/lib/logger` (il redacte les secrets) — jamais `console` brut, jamais
  de secret dans un log ou une URL.
- Sanitize le HTML avec DOMPurify (`src/shared/lib/markdown.ts`).

## 10. Où trouver quoi

| tu cherches…                                    | va voir                                                                            |
| ----------------------------------------------- | ---------------------------------------------------------------------------------- |
| Conventions, commandes, DoD (**canonique**)     | [`../AGENTS.md`](../AGENTS.md)                                                     |
| État réel du projet (phase, features, en-cours) | [`../STATUS.md`](../STATUS.md)                                                     |
| Architecture (stack, flux, modèle de données)   | [`../ARCHITECTURE.md`](../ARCHITECTURE.md)                                         |
| L'index des études + les rôles                  | [`README.md`](./README.md)                                                         |
| Le contrat d'exécution de ton epic              | `NN-<slug>/ETUDE.md`                                                               |
| Le format d'une étude                           | [`_TEMPLATE.md`](./_TEMPLATE.md)                                                   |
| Le dispositif CI/CD & auto-merge en détail      | [`../docs/ci-cd-and-branch-protection.md`](../docs/ci-cd-and-branch-protection.md) |
| Les pièges du poste & du travail à plusieurs    | [`../docs/agents/`](../docs/agents/README.md) (playbooks opérationnels)            |
| Les variables d'environnement                   | [`../docs/environment-variables.md`](../docs/environment-variables.md)             |
| Les specs normatives par sujet                  | [`../docs/`](../docs)                                                              |

## Licence & cession des contributions

Le code du dépôt est sous [PolyForm Noncommercial 1.0.0](../LICENSE.md) ; le contenu
pédagogique, les skills de génération et les études sont **tous droits réservés**
([`../LICENSE-CONTENT.md`](../LICENSE-CONTENT.md)). En ouvrant une PR, tu acceptes que ta
contribution (code, contenu, documentation) soit **cédée au projet** (titulaire : Mohamed
Beji) et intégrée sous ces licences — condition pour que le projet puisse défendre et, le cas
échéant, re-licencier l'ensemble.

## Check-list avant d'ouvrir ta PR

- [ ] J'ai lu AGENTS.md, STATUS.md, l'`ETUDE.md` entier et la section de mon lot.
- [ ] Mon périmètre = **exactement** ce lot (ni plus, ni moins) ; aucun écart silencieux.
- [ ] `npm run verify` est **vert** en local (`ci:verify` si lot release-grade).
- [ ] Tests co-localisés ajoutés/à jour ; la coverage ne régresse pas.
- [ ] Migrations (le cas échéant) : additives, horodatées après `main`, grants inclus, pgTAP écrit.
- [ ] La case du lot est cochée dans l'`ETUDE.md` ; le journal d'exécution est à jour.
- [ ] Message conventionnel qui référence `FableEtudes/NN-<slug>#lot-X`.
- [ ] Je surveille ma PR jusqu'au **merge réel**, puis je nettoie ma branche.

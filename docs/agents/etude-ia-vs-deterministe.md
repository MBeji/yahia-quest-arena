# Étude — IA → déterministe : ne dépenser des tokens que là où le jugement compte

> **Statut : étude / proposition** (2026-07-21). Rien ici n'est appliqué ; chaque lot du §6
> est un arbitrage à rendre. Périmètre : ce dépôt (moteur + harness + CI). Le pipeline de
> contenu vit au privé (étude 24) et n'est traité qu'en renvoi (§4.6).

## 0. TL;DR

Le dépôt a déjà la bonne doctrine — les gates sont des scripts (`harness:check`,
`leak:check`, `db:check-chain`, `migration-gate`, hooks `guard-generated`/`format-changed`,
chaîne `auto-pr`/`automerge`/`report-close`) et l'app **ne consomme aucun token au runtime**.
Mais **cinq surfaces** font encore travailler un agent là où tout ou partie du travail est
mécanique :

| #   | Surface                        | Fréquence               | Part remplaçable par du déterministe                 | Priorité |
| --- | ------------------------------ | ----------------------- | ---------------------------------------------------- | -------- |
| 1   | Hook agent pré-commit          | **chaque `git commit`** | ~4 checks sur 5 (patterns/AST/diff)                  | **P1**   |
| 2   | `report-triage.yml`            | 6×/jour + dispatch      | le re-run sur file inchangée + dédup + pré-screening | **P1**   |
| 3   | `regression-guard.yml`         | 2×/semaine              | le chemin « tout est vert, rien à faire »            | P2       |
| 4   | `upgrade-guard.yml`            | 2×/semaine              | tout le lot patch/minor (Renovate ou script)         | P2       |
| 5   | `second-opinion.yml` (dormant) | à l'activation          | le déclenchement (filtre de chemins)                 | P3       |

Le principe : **l'IA écrit le script une fois ; le script tourne ensuite gratuitement,
instantanément et à l'identique pour toujours.** L'agent ne doit rester que là où il faut un
jugement sémantique sur une entrée non bornée (§4.6).

## 1. Le modèle de coût réel

Les gardes tournent sur `CLAUDE_CODE_OAUTH_TOKEN` (abonnement Claude Max), pas en
pay-per-token : il n'y a **pas de facture API à l'usage**. Le coût réel est ailleurs, et il
est bien réel :

1. **Quota partagé.** Chaque run de garde et chaque hook pré-commit consomme le quota de
   l'abonnement — le même que les sessions de développement interactives. Un token brûlé par
   un no-op de garde est un token en moins pour écrire du code.
2. **Latence.** Le hook pré-commit bloque chaque commit jusqu'à 180 s ; un garde monopolise
   un runner « de longues minutes » (leurs propres commentaires). Un script fait le même
   check en < 1 s.
3. **Non-déterminisme.** Un agent peut rater un pattern un jour et le voir le lendemain. Un
   check en regex/AST a un comportement unique, testable unitairement, versionné — c'est
   exactement l'argument déjà acté pour `guard-generated.mjs` vs « demander à l'agent de ne
   pas éditer les fichiers générés ».
4. **Bruit et surface d'attaque.** Moins de runs d'agent = moins de PR/issues de bruit
   (contrainte explicite de `docs/agents/gardes.md`) et moins d'occasions d'injection de
   prompt (les signalements utilisateurs sont des données hostiles).

## 2. Inventaire exhaustif des surfaces IA du dépôt

Constats d'abord, pour cadrer :

- **Runtime applicatif : zéro IA.** Le moteur adaptatif (étude 04), SM-2, l'accès aux
  exercices — tout est SQL/TypeScript. Aucune requête vers un LLM dans `src/**`. Rien à
  faire.
- **Sessions interactives** (Claude Code en local/remote) : hors périmètre — c'est l'outil
  de travail. Une seule règle d'hygiène : ne pas demander à l'agent ce qu'un
  `npm run verify` fait tout seul.

Les surfaces qui consomment, elles :

| Surface                | Déclencheur                        | Modèle (rôle)                      | Ce qu'elle fait                                                                    |
| ---------------------- | ---------------------------------- | ---------------------------------- | ---------------------------------------------------------------------------------- |
| Hook agent pré-commit  | chaque `git commit` (PreToolUse)   | `hook-precommit` (Sonnet)          | passe rapide sur le diff indexé : secrets, affaiblissement du gate, server fn nue… |
| `regression-guard.yml` | lun + jeu 23:00 UTC                | `garde-tests` (Sonnet), ≤40 tours  | réconcilie les suites de tests avec les changements du jour                        |
| `upgrade-guard.yml`    | mar + ven après nightly vert       | `garde-deps` (Sonnet), ≤60 tours   | détecte + applique les montées de version, PR patch/minor + PR par major           |
| `report-triage.yml`    | cron `*/4h` + dispatch + manuel    | `garde-triage` (Sonnet), ≤60 tours | screening sécurité, triage, dédup, reproduction, fix, PR + issue de clôture        |
| `second-opinion.yml`   | chaque push de chaque PR (dormant) | `second-avis` (null)               | second avis d'une autre famille de modèles — coût nul tant que dormant             |

## 3. Grille de décision (quand IA, quand script)

Un check **doit** être un script quand sa règle s'exprime en pattern, AST, diff de fichiers
ou comparaison de nombres — c'est-à-dire quand deux exécutions sur la même entrée doivent
donner le même verdict. Un agent **reste** justifié quand il faut :

- un jugement sémantique (« ce test qui échoue est-il périmé ou attrape-t-il un vrai
  bug ? ») ;
- une entrée non bornée en langage naturel (message d'élève, changelog upstream) ;
- une production de code (écrire le fix, migrer un breaking change).

Cas hybride — le plus fréquent ici : **un pré-filtre déterministe décide s'il y a du travail,
et ne réveille l'agent que s'il y en a.** C'est déjà le pattern de `report-triage.yml`
(l'export compte la file et skippe l'agent à zéro) ; cette étude le généralise.

## 4. Analyse surface par surface

### 4.1 Hook pré-commit agent → hook déterministe (P1 — le plus gros gain)

C'est la surface la plus fréquente : **chaque commit de chaque session**, jusqu'à 180 s de
latence + tokens, pour cinq checks dont quatre sont des patterns :

| Check du prompt actuel                                               | Remplaçable ? | Par quoi                                                                                                                                                           |
| -------------------------------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Secret/clé/token en dur                                              | ✅            | scan du diff indexé par regex à haute précision (patterns `sk-`, `eyJ`, PEM, URL avec credentials…) — ou `gitleaks protect --staged` si l'on accepte la dépendance |
| `@ts-ignore`, `as any`, eslint-disable inline, `--no-verify`, seuils | ✅            | grep des **lignes ajoutées** du diff indexé (`git diff --cached -U0`) — signal exact, zéro faux positif sur du code existant                                       |
| Server fn sans `requireSupabaseAuth` / sans `.inputValidator`        | ✅ et mieux   | **règle ESLint maison (AST)** sur `createServerFn` — tourne alors dans `npm run lint`, donc au pre-push et en CI aussi, pas seulement au commit                    |
| Migration destructive (DROP/REVOKE) + code dans le même commit       | ✅            | check d'ensemble de fichiers : si le diff indexé contient une migration matchant `DROP\|REVOKE` **et** des fichiers `src/**` → bloquer (DoD §7)                    |
| Contournement d'une gate anti-triche/premium/RLS                     | ❌ sémantique | reste couvert par `/code-review` à la PR + la revue humaine — c'est déjà sa place selon le prompt lui-même (« PAS une revue d'architecture »)                      |

**Proposition** : remplacer le hook agent par `node .claude/hooks/precommit-checks.mjs`
(type `command`, comme `guard-generated.mjs`), testé unitairement dans
`scripts/**/__tests__/` comme les autres scripts du harness. La règle ESLint
`createServerFn` se pose à part (lot L1b) car elle profite à toute la chaîne.

**Gain** : latence de commit ~180 s → < 1 s, zéro token, verdict reproductible.
**Perte assumée** : la passe sémantique « fort signal » au commit — redondante avec
`/code-review` PR et la CI, et de toute façon best-effort dans sa forme actuelle (timeout
180 s, autorise par défaut).

### 4.2 `report-triage.yml` — ne réveiller l'agent que sur du NOUVEAU (P1)

Le gate `count != 0` existe déjà, mais il a un angle mort coûteux : **un signalement `open`
non actionnable (ou en attente de `dismissed` par l'opérateur) fait re-tourner l'agent
complet toutes les 4 h sur la même file** — 6×/jour, ≤60 tours, pour re-produire le même
verdict.

Déterminisable, dans l'ordre :

1. **Gate « nouveaux IDs seulement »**. L'export sait déjà lister les IDs ; un script
   compare la file aux IDs déjà traités (lisibles sans état nouveau : trailers `Report-Id:`
   des PR `report-fix` ouvertes/mergées + IDs cités dans les issues « 🛎️ Triage des
   signalements » ouvertes). File ⊆ déjà-traités → **skip l'agent**, en vert.
2. **Dédup par empreinte** avant l'agent : même `exercise_id`/`question_id`, même `page` +
   message quasi identique (normalisation + similarité trigramme) → clusters calculés par
   script ; l'agent reçoit des clusters, pas N doublons — moins de tours, moins de texte
   hostile ingéré.
3. **Pré-screening mécanique** de la phase 0 : longueur, URLs, motifs d'injection connus,
   rafale d'un même utilisateur → pré-marquage `⛔ suspect` par regex. L'agent garde le
   verdict final (sémantique), mais démarre avec le sale déjà étiqueté.

**Gain** : la grande majorité des ~42 crons/semaine deviennent des no-ops sans agent ; et on
réduit l'exposition à l'injection de prompt (moins de texte hostile lu, moins souvent).
**Reste IA** : le verdict de screening final, la reproduction, le fix — le cœur du skill.

### 4.3 `regression-guard.yml` — pré-gate « y a-t-il du travail ? » (P2)

Aujourd'hui l'agent tourne même pour conclure « all green » (le prompt le prévoit
explicitement). Deux pré-checks scripts suffisent à réserver l'agent aux jours utiles :

1. **Fenêtre vide** : `git log --oneline main --since=26h` sans commit (hors merges de
   bruit) → skip.
2. **Vert et couvert** : `npm run verify` + comparaison de couverture vs baseline verte, et
   heuristique diff « du `src/**` touché sans `__tests__/` correspondant » → si gate vert,
   couverture stable et chaque commit de la fenêtre a touché des tests, poster « all green »
   depuis le script et skip.

L'agent n'est invoqué que si quelque chose est rouge, si la couverture recule, ou si des
commits sont arrivés sans tests — c'est-à-dire quand la question « périmé ou vrai bug ? »
se pose vraiment. **Cette question-là reste IA** : c'est le cœur légitime du garde.

### 4.4 `upgrade-guard.yml` — le lot patch/minor n'a pas besoin d'un agent (P2)

Le lot patch/minor est, par construction du skill, une procédure fermée :
`npm outdated` → `npm update` dans les ranges → `npm ci` (npm 10) → `npm run ci:verify` →
PR labellée `dependencies`. **C'est un script** — ou, mieux, **Renovate**, qui fait
exactement ça nativement : groupement patch/minor en un lot, un PR par major, groupes de
paquets liés (le set TanStack = un seul groupe), pins d'actions GitHub par SHA gérés, et
l'auto-merge reste notre chaîne existante (checks requis + suites lentes). Les « traps » du
skill s'encodent en config (`constraints.npm`, groupes, `rangeStrategy`) plutôt qu'en
prompt.

L'agent garde deux rôles, sur déclenchement conditionnel :

- **réparer un major rouge** : quand la PR major de Renovate échoue au gate, un workflow
  invoque l'agent en mode « lis le changelog, migre le code, rends-la verte ou ouvre une
  issue de tracking » — c'est la seule partie qui demandait vraiment WebFetch + jugement ;
- (optionnel) résumer le changelog d'un major dans la PR pour le relecteur humain.

**Gain** : le job « le plus cher du dépôt » (leur propre commentaire) devient token-free
dans le cas nominal ; l'agent ne paie que les breaking changes réels.
**Variante sans dépendance nouvelle** : si l'on ne veut pas de Renovate, un script maison
`scripts/deps/apply-patch-minor.mjs` dans le workflow actuel fait le même lot nominal ; le
choix Renovate vs script est l'arbitrage du lot L4.

### 4.5 `second-opinion.yml` (dormant) — borner avant d'allumer (P3)

Coût nul aujourd'hui. Mais tel que committé, il tournerait sur **chaque push de chaque
PR** (`opened` + `synchronize`). Avant toute activation : filtre déterministe de
déclenchement — chemins à risque uniquement (`src/**` hors tests, `supabase/migrations/**`,
`.github/**`), et/ou un label `second-avis` posé à la demande, et un debounce (pas de re-run
à chaque push d'une même PR). À écrire dans le workflow **avant** de renseigner le secret,
pour que l'économie soit dans la mécanique, pas dans la discipline.

### 4.6 Ce qui doit RESTER de l'IA (et pourquoi)

- **`/code-review` à la PR** : jugement d'architecture, de sécurité sémantique, de
  complétude — non exprimable en règles. C'est précisément là que la passe sémantique
  retirée du hook pré-commit (§4.1) continue d'exister.
- **Regression-guard, le verdict** « test périmé vs vrai bug » — le rater dans un sens cache
  un défaut, dans l'autre casse la CI pour rien.
- **Report-triage, phases 1-4** : screening final d'un texte hostile, reproduction, fix.
- **Upgrade-guard, mode réparation** d'un major rouge.
- **Pipeline de contenu (repo privé)** : la même grille s'y applique déjà — Zod, QA checks
  et `content:emit` sont déterministes ; le double-solve et la voix pédagogique restent IA.
  Toute généralisation de la présente étude au privé se décide là-bas.

## 5. Ce que le dépôt fait déjà bien (ne pas y toucher)

La doctrine « déterministe d'abord » est déjà en place partout ailleurs — cette étude ne
crée pas un principe, elle finit de l'appliquer : `guard-generated.mjs` et
`format-changed.mjs` (hooks commandes, pas agents), `harness:check`, `leak:check`,
`db:check-chain`, `check-migration-order`, `check-bundle-budget`, `check-design-tokens`,
`check-rtl-classes`, la chaîne `auto-pr`/`automerge`/`report-close`, l'export read-only des
signalements avec son gate `count == 0`, et `check-claude-result.py` (c'est un script qui
vérifie l'agent, pas l'inverse — le bon sens de la relation).

## 6. Plan par lots proposé

| Lot     | Contenu                                                                                                     | Effort | Gain tokens/latence                      | Risque                                                                  |
| ------- | ----------------------------------------------------------------------------------------------------------- | ------ | ---------------------------------------- | ----------------------------------------------------------------------- |
| **L1**  | Hook pré-commit déterministe (`precommit-checks.mjs` + tests) ; retirer le hook agent de `policy.json`/sync | S      | **le plus gros** (chaque commit)         | faux négatifs sémantiques → assumés, couverts par PR review             |
| **L1b** | Règle ESLint `createServerFn` (auth middleware + inputValidator obligatoires)                               | S      | indirect (check partout, plus au commit) | faible ; à calibrer sur les server fns publiques légitimes si il y en a |
| **L2**  | `report-triage` : gate « nouveaux IDs », dédup par empreinte, pré-screening regex                           | M      | ~majorité des 42 runs/semaine → no-op    | rater un « nouveau » cas — mitigé par le dispatch instantané inchangé   |
| **L3**  | `regression-guard` : pré-gate fenêtre vide + verify vert + couverture stable                                | S      | ~la moitié des runs (les jours calmes)   | faible (le pré-gate ne peut que skipper un run qui aurait dit « vert ») |
| **L4**  | `upgrade-guard` : Renovate (ou script) pour patch/minor ; agent en mode réparation de major rouge           | M-L    | le job le plus cher → token-free nominal | migration de process ; à faire en gardant l'automerge existant          |
| **L5**  | `second-opinion` : filtre chemins + label + debounce (avant toute activation)                               | S      | préventif                                | nul (dormant)                                                           |

Chaque lot = une PR, gate vert, conforme DoD. L1 et L2 d'abord : fréquence maximale, risque
minimal. Après L1-L4, la consommation nominale de tokens du dépôt tend vers **zéro hors
travail réel** (un fix à écrire, un major à migrer, un arbitrage de test) — exactement là où
l'IA a une valeur que le script n'a pas.

## 7. Risques et garde-fous

- **« Le regex voit moins que l'agent. »** Vrai — mais le hook agent actuel est déjà
  best-effort (180 s, non bloquant en cas de timeout) et la défense réelle est la CI + la
  revue de PR. On échange un filet flou et coûteux contre un filet net et gratuit, sans
  toucher aux vrais gates.
- **Dérive des scripts.** Tout script de remplacement suit le régime existant : co-localisé
  avec tests (`__tests__/`), branché dans `verify`/CI, jamais de logique dupliquée entre
  hook et CI (le hook appelle le même module).
- **Renovate est un tiers.** Si le lot L4 retient Renovate : app GitHub scopée au dépôt,
  config committée et relue, l'automerge reste NOTRE chaîne (checks requis + suites
  lentes) — Renovate ne merge rien.
- **Mesure.** Avant/après chaque lot, noter dans la PR la fréquence de runs agent évitée
  (les logs Actions suffisent) — c'est la métrique de l'étude, et le critère pour décider
  d'aller au lot suivant.

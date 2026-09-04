# Étude — Travail cloud-first : piloter les trois dépôts depuis le téléphone et le web, sans poste de travail

> **Statut : étude OUVERTE** (rédigée le 2026-09-04 — **depuis une session cloud**, c'est-à-dire
> dans les conditions qu'elle décrit ; chaque chiffre du §3 et du §9 y a été **constaté**, pas
> déduit). Commanditaire : Mohamed. **Besoin** : travailler presque exclusivement en sessions
> cloud, depuis le téléphone ou l'accès web, sans l'application Desktop — parce que le PC de
> travail est un poste d'entreprise sans droits admin, et qu'aucune règle d'usage de ce poste ne
> doit être enfreinte. Question jointe : où mettre les documents (corpus CNP officiel, etc.) —
> Google Drive ou ailleurs en ligne. Périmètre : les trois dépôts (`yahia-quest-arena`,
> `yahia-quest-content`, `ScribeKit`) et le wrapper hors git `YahiaAcademy/`. Numéro d'étude :
> **à réserver dans l'index privé au premier lot livré**
> ([collaboration.md](./collaboration.md) § « Le numéro d'étude se réserve au merge ») — ce
> fichier est le contrat d'exécution, l'index privé n'en porte que la ligne.

## 0. TL;DR

**Le besoin est satisfaisable dès aujourd'hui pour l'essentiel du travail, sans rien changer** :
une session cloud clone le dépôt, installe Node 24 en 6 s, les dépendances en 22 s, joue le gate
complet en **211 s (vert, 7 étapes, 3 973 tests)**, pousse, et la chaîne `auto-pr` → `automerge`
fait le reste. Les deux dépôts privés sont visibles avec droit de push, les skills personnels
suivent la session, et toute la famille des pièges Windows disparaît avec le poste.

**Ce qui bloque tient en UN réglage** : l'environnement cloud « Default » est en accès réseau
**Trusted** (liste blanche de registres et de GitHub). Depuis la session, `www.cnp.com.tn`
(les manuels), `www.na9ranal3ab.tn` (la prod) et `*.supabase.co` (projets prod et TEST) répondent
**403** à la connexion. Donc : pas de campagne de contenu, pas de sonde de prod, pas de comptage
REST. Passer l'environnement en **Custom** (liste par défaut + quatre domaines nommés) lève les
trois d'un coup — **dix minutes, une fois, depuis le téléphone** (lot 0, §7). C'est le seul geste
de cette étude qui revient à Mohamed, et il cite un mur : « réglage hors dépôt ».

**Les documents.** Les manuels CNP n'ont **rien à téléverser nulle part** : ils sont publics chez
le CNP, l'application les lie déjà « en lien plutôt qu'en copie » (`manuel-cnp.ts`), et la
[licence](../../LICENSE-CONTENT.md) comme cette doctrine interdisent d'en committer une copie.
Le domaine autorisé, la session les télécharge **par code** et les lit en vision, comme sur le
poste. Google Drive est le bon endroit pour ce que Mohamed collecte ou produit lui-même
(programmes du ministère, circulaires, captures, notes), via le **connecteur Google Drive**
présent dans l'organisation mais pas encore connecté. Les prompts de campagne et les registres,
eux, vivent **dans le dépôt privé** — pas sur Drive : c'est déjà la règle « aucune mémoire
latérale ».

**Le PC de travail sort entièrement de la boucle** : rien d'installé, rien de cloné, aucun
identifiant, et même le navigateur n'est pas nécessaire. Tout est conçu **téléphone d'abord**
(application Claude, onglet Code), le web n'étant qu'un confort quand un écran personnel est
disponible.

**Trois murs restent, nommés au §5** : le réglage de l'environnement vit dans claude.ai (une
fois) ; deux identifiants se renouvellent hors dépôt — le PAT GitHub (expire le 2026-10-04) se
repose depuis un navigateur, mais le jeton des trois gardes agent est né de `claude setup-token`,
une commande CLI **qu'aucune session cloud ni aucun téléphone ne peut jouer** — la parade
structurelle est de porter ces gardes en **routines** (lot 5) ; et la règle d'usage du poste
d'entreprise, que seul Mohamed peut lire — l'étude prend le parti le plus sûr, le poste n'y
touche pas.

## 1. Le besoin, en exigences

| #       | Exigence                                                                                                                                                              | Vérifiable par                                                                             |
| ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| **R-1** | **Zéro empreinte sur le PC de travail** : rien d'installé, rien de cloné, aucun identifiant, aucune synchronisation. Le navigateur y est **optionnel**, jamais requis | Chaque geste du §7 nomme son support : téléphone, ou « n'importe quel navigateur »         |
| **R-2** | **Piloter depuis le téléphone** : lancer une session, répondre à une question, arbitrer, lire le résultat. Le web est un confort, pas une condition                   | Le parcours §3.6 se joue de bout en bout dans l'application Claude                         |
| **R-3** | **Le harness reste entier** : DoD, gates, `policy.json`, zéro intervention — rien n'est affaibli au motif « c'est le cloud »                                          | `npm run verify` vert en session cloud ; hooks husky posés ; `harness:check` couvre la vue |
| **R-4** | **Les sources et documents sont accessibles aux sessions** sans passer par le poste — manuels CNP, documents officiels, notes                                         | Une session lit un manuel par code et un document Drive sans geste humain                  |
| **R-5** | **Rien de ce que le poste faisait n'est perdu** : campagnes de contenu, pgTAP en local, sondes de prod, lecture des études privées                                    | Inventaire §2 : chaque ligne a un équivalent cloud ou un mur nommé                         |
| **R-6** | **Ce qui reste manuel est minimal, nommé et cite un mur** de [zero-intervention.md](./zero-intervention.md) — jamais « il faudrait que tu regardes »                  | §5 et la ligne de `STATUS.md` § « Ce qui attend un humain »                                |

## 2. Ce que le poste fait aujourd'hui — et l'équivalent cloud, constaté

Tout ce qui suit a été **mesuré le 2026-09-04** dans une session cloud sur l'environnement
« Default » (réseau Trusted), sauf mention « doc » (tiré de la documentation de la plateforme) ou
« à constater ».

| #   | Usage sur le poste                                                                               | Dépendance au poste aujourd'hui                                                                                        | En session cloud — constaté                                                                                                                                                                                                                                                                                                               | Verdict                                                                      |
| --- | ------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| 1   | Développer et jouer le gate `verify`                                                             | Node 24 (`.nvmrc`), npm, hooks husky                                                                                   | Node par défaut **22.22.2** (la plateforme livre 20/21/22) ; `nvm install 24` → **v24.20.0 en 6 s** ; `npm install` **523 paquets en 22 s**, husky posé (`core.hooksPath=.husky/_`) ; `verify` **vert en 211 s**, 7 étapes, 321 fichiers, 3 973 tests                                                                                     | ✅ Sans réglage. Lot 1 rend l'amorçage automatique et vérifié                |
| 2   | Pousser, ouvrir la PR, la mener au merge                                                         | git, `gh`                                                                                                              | git via le **proxy GitHub** de la plateforme, qui **limite `git push` à la branche de la session** (doc) — la règle « jamais une autre branche » devient une propriété de la plateforme. `gh` **absent** dans cette session (la doc le dit préinstallé : constaté absent) → surface GitHub = outils MCP, qui répondent (identité `MBeji`) | ✅ — lot 2 pour la vue cloud de la policy                                    |
| 3   | Sessions parallèles                                                                              | Worktrees `.claude/worktrees/*`, checkout, `node_modules` et `stash` **partagés**                                      | **Une VM par session**, clone neuf, 4 vCPU / 15 Go / 30 Go                                                                                                                                                                                                                                                                                | ✅ Mieux qu'avant : tout le § « checkout partagé » de poste-windows.md tombe |
| 4   | Campagne de contenu : lire les manuels CNP                                                       | PDF dans `YahiaAcademy/` hors git, `--add-dir`, `render.sh` (poppler), lecture vision                                  | `www.cnp.com.tn` → **CONNECT 403** (hors liste Trusted) ; `pdftoppm` absent ; `pip install pymupdf` **6 s, OK** (PyPI est dans la liste) ; lecture vision d'images : identique                                                                                                                                                            | ⛔ → lot 0 (domaine) puis lot 3                                              |
| 5   | pgTAP en local (`pgtap-en-local.md`)                                                             | `apt-get install postgresql-16-pgtap` sur le poste                                                                     | `psql` 16 présent, serveur arrêté ; pgTAP **absent** ; `archive.ubuntu.com` **joignable (200)** → installable, et un script d'environnement le met en cache ~7 jours (doc)                                                                                                                                                                | ✅ Lot 4 (indépendant du lot 0)                                              |
| 6   | Sonder la prod (`curl` sur `na9ranal3ab.tn`, comptages REST du playbook campagnes)               | `curl` Windows (schannel, trois options à ne pas oublier)                                                              | `www.na9ranal3ab.tn`, `fasrenmmrkqjoobrztbp.supabase.co`, `pqegdnwdtbjtplcthxyp.supabase.co` → **CONNECT 403**                                                                                                                                                                                                                            | ⛔ → lot 0 (domaines)                                                        |
| 7   | E2E Playwright                                                                                   | Projet TEST, `.env.test`                                                                                               | Chromium présent (`/opt/pw-browsers`) ; le projet TEST est bloqué en Trusted ; et de toute façon `e2e-auth.yml` est **dispatchable** — la spec s'exécute en CI, la session lit le run                                                                                                                                                     | ✅ Par dispatch, comme aujourd'hui                                           |
| 8   | Gardes programmées (`regression-guard`, `upgrade-guard`, `report-triage`, nightly, checkpoints…) | Aucune : GitHub Actions                                                                                                | Inchangé. **Mais** les trois gardes agent tournent avec `CLAUDE_CODE_OAUTH_TOKEN`, né de `claude setup-token` **sur le poste**                                                                                                                                                                                                            | ⚠️ Renouvellement = mur, §5 ; parade = lot 5                                 |
| 9   | Réglages GitHub : PAT, secrets, variables (`gh secret set`, `gh variable set`)                   | `gh` + policy `repo-config`                                                                                            | Pas de `gh`, et **aucun outil MCP** ne pose un secret ou une variable → interface web de GitHub (fonctionne dans le navigateur du téléphone)                                                                                                                                                                                              | ⚠️ §5                                                                        |
| 10  | Dispatcher un workflow (`rollback-prod`, `apply-content`, `e2e-auth`, `db-tests`…)               | `gh workflow run <nom>`, **autorisé un par un** dans `policy.json`, `db-migrate-prod` et `release` refusés **par nom** | Outil MCP `actions_run_trigger` — **un seul outil pour tous les workflows** : la granularité « par nom » n'existe pas. Le REST brut par `curl` est refusé par le proxy (403 « GitHub access is not enabled for this session ») : il n'y a pas de troisième chemin                                                                         | ⚠️ Arbitrage, lot 2                                                          |
| 11  | Drill de portabilité (é25 L7 : une tête Codex/Gemini sur un worktree neuf)                       | Une machine, un compte tiers                                                                                           | Installable dans la VM (registre npm ouvert), mais l'authentification d'un outil tiers est hors périmètre                                                                                                                                                                                                                                 | ⏸ Inchangé — déjà « session avec Mohamed »                                   |
| 12  | Lire les études, la ROADMAP, le programme go-live (dépôt privé), le moteur de transcription      | Second checkout                                                                                                        | Les **trois dépôts** sont visibles avec droit de push (`yahia-quest-arena`, `yahia-quest-content`, `ScribeKit`) ; sélection multi-dépôts au démarrage d'une session ou ajout en cours (`add_repo`)                                                                                                                                        | ✅                                                                           |
| 13  | Skills personnels (`contexte-*`)                                                                 | `~/.claude` du poste                                                                                                   | **Synchronisés** dans la session (constaté sous `/root/.claude/skills/synced/`) ; les skills du dépôt viennent avec le clone                                                                                                                                                                                                              | ✅                                                                           |
| 14  | Les pièges Windows (MSYS, CRLF, `jq`, `/tmp`, `npm.cmd`, symlinks, schannel, RAM, contention)    | Tout [poste-windows.md](./poste-windows.md)                                                                            | Ubuntu 24.04, LF natif, `jq` présent, `/tmp` réel, 15 Go libres, aucune session sœur sur la même machine                                                                                                                                                                                                                                  | ✅ Le playbook devient **hérité** (lot 6)                                    |
| 15  | Rester « de garde » jusqu'au merge réel (DoD §8)                                                 | Une session ouverte sur le poste, ou un `until` fragile                                                                | Deux mécanismes dans la session : l'**abonnement aux événements de la PR** (`subscribe_pr_activity`, exige l'app GitHub « Claude » sur le dépôt — à constater sur cette PR) et le **réveil différé** (`send_later`). Une VM récupérée pour inactivité est **re-provisionnée à la reprise**, conversation restaurée (doc)                  | ✅ À documenter dans passation.md §7 (lot 5)                                 |

**Lecture du tableau** : 11 lignes sur 15 sont vertes sans rien changer ; les deux ⛔ ont la même
cause (le réseau Trusted) et la même parade (lot 0) ; les trois ⚠️ sont des murs ou des
arbitrages, tous au §5 ou au §7.

## 3. L'environnement cloud, mesuré

### 3.1 Ce que la plateforme est

- **Une VM par session** (Ubuntu 24.04 x86_64), clone neuf du ou des dépôts choisis, ~4 vCPU /
  16 Go / 30 Go (doc ; constaté 4 vCPU, 15 Go libres, 30 Go disponibles). La session **survit à
  la fermeture de l'onglet** et se pilote indifféremment depuis claude.ai/code ou l'onglet Code
  de l'application mobile (doc).
- **Un environnement** = un réglage sauvegardé : niveau réseau, variables d'environnement, script
  d'installation, et (Pro/Max) des « API credentials » que le proxy attache aux requêtes sans que
  la session voie la clé. Le compte n'en a **qu'un**, « Default », sans variable ni script.
- **Quatre niveaux réseau** (doc) : `None`, `Trusted` (liste par défaut : registres npm/PyPI/…,
  GitHub, SDK cloud), `Custom` (sa propre liste, avec ou sans la liste par défaut), `Full`.
  GitHub et les **connecteurs MCP** passent **hors** de cette liste — par le proxy GitHub et par
  les serveurs d'Anthropic respectivement.
- **Le proxy GitHub** garde les identifiants hors de la VM et **n'autorise `git push` que vers la
  branche de travail de la session** ; les assets de release ne sont lisibles que pour les dépôts
  attachés à la session ; le REST brut n'est pas crédité (constaté : 403).
- **Script d'installation** : avant le lancement, ~5 min de budget, **mis en cache** (instantané
  du disque, ~7 jours, invalidé quand le script ou la liste de domaines change). **Hook
  `SessionStart`** : après le lancement, à chaque session, **versionné dans le dépôt** — c'est lui
  qui porte ce qui doit être relu et gaté.
- **Modes de permission en cloud** : Auto, Accept edits, Plan (pas de Bypass). Le classifieur
  d'auto-mode reste le mur qu'il est ([zero-intervention.md](./zero-intervention.md)).
- **Expiration** : une session inactive voit sa VM récupérée ; la rouvrir (ou un message
  différé) la re-provisionne, conversation restaurée, tâches de fond perdues (doc). Conséquence
  de conception, déjà la règle des campagnes : **livrer en petits lots poussés**.
- **Routines** (doc) : une configuration sauvegardée (prompt, dépôts, environnement,
  connecteurs) déclenchée par un calendrier (minimum une heure), un appel API ou un événement
  GitHub (PR, release — exige l'app GitHub « Claude » sur le dépôt). Se créent et se gèrent sur
  claude.ai/code/routines — une page web, lisible dans le navigateur du téléphone. Plafond
  quotidien de runs, consommation sur l'abonnement.

### 3.2 Le réseau, sondé depuis la session (Trusted)

| Hôte                                                                                                                                                          | Réponse         | Ce que ça conditionne                                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `api.github.com`, `raw.githubusercontent.com`, `objects`/`release-assets.githubusercontent.com`                                                               | joignables      | clone, PR, lecture de fichiers publics                                                                                                                        |
| `registry.npmjs.org`, `pypi.org`, `nodejs.org`, `archive.ubuntu.com`, `*.googleapis.com`                                                                      | joignables      | `npm install`, `pip`, `nvm install`, `apt install` (pgTAP, poppler)                                                                                           |
| `www.cnp.com.tn`                                                                                                                                              | **CONNECT 403** | **les manuels** — le magasin PDF du CNP (`CNP_MANUEL_BASE_URL`)                                                                                               |
| `www.na9ranal3ab.tn`                                                                                                                                          | **CONNECT 403** | toute sonde de prod (`/api/health`, contrôle post-déploiement, rollback)                                                                                      |
| `fasrenmmrkqjoobrztbp.supabase.co` (prod), `pqegdnwdtbjtplcthxyp.supabase.co` (TEST)                                                                          | **CONNECT 403** | comptages REST en lecture publique (campagnes), `content:manuel:check`, E2E                                                                                   |
| `drive.google.com`                                                                                                                                            | **CONNECT 403** | sans effet : le connecteur Drive passe par Anthropic, pas par ce réseau                                                                                       |
| `vercel.com`, `api.vercel.com`, `www.education.gov.tn`, `api.deepseek.com`, `us.i.posthog.com`, `www.youtube.com`, `cdn.playwright.dev`, `deb.nodesource.com` | **CONNECT 403** | rien d'indispensable à une session : Vercel déploie sur push, PostHog et l'étage IA tournent en prod, les vidéos sont sondées par `video-health.yml` au privé |

Le refus est propre et diagnostiquable : `curl` sort en 56, et l'état du proxy
(`$HTTPS_PROXY/__agentproxy/status`) journalise `connect_rejected … policy denial` avec l'hôte.
Aucune ambiguïté avec une panne du site — exactement la distinction que
`check-manuel-links.test.ts` a dû apprendre à faire sur le poste, avec un intermédiaire TLS qui,
lui, ne disait rien.

### 3.3 Les outils, constatés

| Outil                       | État dans la session                                                                                                          | Conséquence                                                                                              |
| --------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Node                        | 22.22.2 par défaut ; **nvm** présent, `nvm install 24` OK                                                                     | Le hook `SessionStart` du lot 1 pose Node 24 — sans lui, `verify` tombe sur le piège « Node trop vieux » |
| npm                         | 10.9.7 (11.19 avec Node 24)                                                                                                   | `npm install`, jamais `npm ci` — la règle ne change pas, et le cache d'environnement la récompense       |
| `gh`                        | **absent**                                                                                                                    | La policy a besoin d'une vue MCP (lot 2)                                                                 |
| `jq`, `curl`, `git`, `rg`   | présents                                                                                                                      | Les scripts de surveillance qui parsaient avec `jq` refonctionnent tels quels                            |
| `psql` 16                   | présent, serveur arrêté (`service postgresql start`)                                                                          | pgTAP local possible (lot 4)                                                                             |
| pgTAP, poppler (`pdftoppm`) | absents, **installables** (`apt`, Ubuntu joignable)                                                                           | Script d'environnement du lot 4 / lot 3                                                                  |
| Docker                      | client présent, **démon arrêté**                                                                                              | Inutile ici : Postgres tourne nativement                                                                 |
| Python 3.11, pip, uv        | présents ; `pip install pymupdf` en 6 s                                                                                       | Rendu des pages de manuel en images sans poppler (lot 3)                                                 |
| Chromium Playwright         | présent (`/opt/pw-browsers`)                                                                                                  | `smoke:shell` jouable en session                                                                         |
| Connecteurs claude.ai       | Gmail connecté et actif ; **Google Drive** présent à l'org, **non connecté**, inactif dans la session ; Calendar, Notion idem | Lot 0 : connecter Drive ; l'activer dans les sessions qui lisent des documents                           |
| Skills                      | ceux du dépôt (clone) + les personnels (synchronisés)                                                                         | Rien à recopier                                                                                          |

### 3.4 Ce que le cloud fait DÉJÀ mieux que le poste

- **Le contrat de branche est imposé** par le proxy GitHub, plus seulement promis par une règle.
- **Le checkout n'est plus partagé** : fin des `stash` d'autrui, des `git branch -D` refusés, des
  `node_modules` en jonction et des `worktree remove --force` qui détruisent leurs cibles.
- **Le gate est reproductible** : même Ubuntu que la CI, LF natif, pas de contention CPU/RAM
  entre sessions sœurs — les trois diagnostics de « `verify` rougit à tort » du playbook Windows
  n'ont plus d'objet.
- **La session est lisible par n'importe quel appareil** et survit à l'appareil : un lot lancé du
  téléphone se relit sur le web, et inversement.

### 3.5 Ce que le cloud fait moins bien, et comment on le compense

| Moins bien                                                                                    | Compensation                                                                                                                                                |
| --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Rien ne persiste entre deux sessions hors git (pas de `YahiaAcademy/`, pas de `.env`)         | Tout ce qu'une session doit lire est dans un dépôt, sur Drive (connecteur) ou public à la source ; les clés **publiques** vont en variables d'environnement |
| L'amorçage coûte ~30 s par session (Node 24 + `npm install`)                                  | Hook versionné (lot 1), cache d'environnement pour l'`apt`                                                                                                  |
| Une VM inactive est récupérée                                                                 | Petits lots poussés ; réveil différé et abonnement PR pour la garde (lot 5)                                                                                 |
| Le réglage de l'environnement n'est **pas** dans git                                          | Le lot 1 livre une **sonde de session** qui constate l'écart (Node, domaines) et le dit en clair au lieu de laisser une campagne échouer en silence         |
| La granularité « un workflow par nom » de la policy n'existe pas dans l'outil MCP de dispatch | Lot 2 : la protection des deux workflows interdits descend **dans les workflows**                                                                           |

### 3.6 Le parcours depuis le téléphone, tel qu'il se joue

1. **Application Claude → onglet Code → nouvelle session.** Choisir le ou les dépôts (une
   campagne : le privé **et** celui-ci pour le moteur), la branche, l'environnement (« Default »),
   le mode (Auto ou Accept edits). Écrire le **besoin**, pas le « comment » — le dépôt porte le
   comment (`AGENTS.md`, `STATUS.md`, la ROADMAP privée).
2. **Poser le téléphone.** La session travaille, pousse, la chaîne ouvre la PR ready et arme
   l'auto-merge ; la session reste de garde (abonnement PR + réveil différé).
3. **Revenir quand la session le demande** — une question d'arbitrage arrive comme une
   question, avec ses options ; un lot terminé arrive comme un message final qui se suffit. Le
   diff se relit dans l'application, avec commentaires en ligne si besoin.
4. **Les horloges** (relevés hebdomadaires, re-sonde du topo, gardes) sont des **routines** :
   une page web, pas une commande.
5. **Jamais** : ouvrir un terminal, cloner, poser un secret depuis la session. Les trois réglages
   qui vivent hors dépôt (§5) se font dans un navigateur — celui du téléphone suffit.

## 4. Où mettre les documents — la question posée

### 4.1 Trois classes, trois réponses

| Classe                                                                                                                             | Où                                                                                                                                                                                                                                                                                                                | Qui y écrit                                                                           | Comment la session le lit                                                                                                                                                                                                                                                                      |
| ---------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A. Les manuels CNP** (le corpus source des campagnes)                                                                            | **Chez le CNP, et nulle part ailleurs.** Ils y sont publics ; l'application les lie déjà par code (`cnpManuelUrl`) ; la [licence du contenu](../../LICENSE-CONTENT.md) et la doctrine « en lien plutôt qu'en copie » (pipeline, § « Le manuel officiel ») **interdisent d'en committer une copie**, même au privé | Personne                                                                              | Lot 0 autorise `www.cnp.com.tn` ; la session télécharge `<code><tome>.pdf` dans son scratch, rend les pages en images (PyMuPDF, ~150 dpi) et lit en vision — le même geste que `render.sh` sur le poste                                                                                        |
| **B. Ce que Mohamed collecte ou produit** : programmes officiels du ministère, circulaires, captures, notes, consignes ponctuelles | **Google Drive**, dossier `YahiaAcademy/` — le miroir du wrapper hors git, même statut qu'aujourd'hui (cache personnel, hors dépôt)                                                                                                                                                                               | Mohamed, **depuis le téléphone** (application Drive) — jamais depuis le PC de travail | **Connecteur Google Drive**, activé dans la session qui en a besoin ; passe par Anthropic, aucun domaine à autoriser. ⚠️ À constater au lot 3 : si le connecteur ne livre que le **texte** d'un PDF, les documents à lire en vision passent par le dépôt privé (`sources/`, fichiers ≤ 100 Mo) |
| **C. Ce que toute session doit lire et que l'on veut versionné** : prompts de campagne, registres de suivi, scripts, la METHODE    | **Le dépôt privé** — c'est déjà la règle (« aucune mémoire latérale », AGENTS.md § Multi-agent)                                                                                                                                                                                                                   | Les sessions, par PR                                                                  | Clone, comme tout le reste. Les prompts de campagne deviennent des **prompts de routine** ou des commandes du dépôt, jamais un fichier sur un disque                                                                                                                                           |

### 4.2 Ce qu'on ne fait pas, et pourquoi

- **Pas de copie de manuel dans un dépôt**, même privé, même « pour aller plus vite » : licence,
  doctrine du lien, et `leak:check` n'a pas été écrit pour rien.
- **Pas de secret dans les variables d'environnement** : la doc est explicite, quiconque utilise
  l'environnement les lit. Les clés **publiques** (`VITE_SUPABASE_URL`,
  `VITE_SUPABASE_PUBLISHABLE_KEY` — celles de chaque bundle client) y ont leur place ; la clé
  service, jamais, nulle part : l'absence d'identifiants prod en session est **le filet**, pas
  un oubli.
- **Pas de téléversement depuis le PC de travail**, y compris vers Drive : ce serait un usage du
  poste. Les manuels n'en ont pas besoin (classe A) ; le reste (classe B) part du téléphone.
- **Pas de Drive pour ce qui doit être relu et gaté** (classe C) : un document Drive ne passe
  ni par une PR, ni par Prettier, ni par `content:qa`.

### 4.3 La mécanique du connecteur, telle que la plateforme la décrit

Un connecteur est une intégration claude.ai (claude.ai/customize/connectors), disponible dans les
sessions **et** les routines, dont le trafic passe par les serveurs d'Anthropic — donc hors de la
liste blanche réseau. Il s'active **par session** (et par routine), et une routine peut appeler
tous ses outils, écritures comprises, sans demander : on ne laisse actif que ce dont la session a
besoin. Le connecteur Google Drive annonce « rechercher, lire, téléverser ». Ce que « lire »
rend pour un PDF scanné — texte extrait ou octets du fichier — **n'est pas constaté** : c'est la
première mesure du lot 3, et elle décide si la classe B peut porter des documents à lire en vision.

## 5. Les murs — ce qu'aucune session ne lèvera, et ce qu'on met dessous

Même tableau que [zero-intervention.md](./zero-intervention.md), même règle : une ligne « attend
Mohamed » qui ne cite pas l'un de ces murs est fausse par défaut.

| Mur                                        | Pourquoi il tient                                                                                                                                                                                                                                                                                                                                                                            | Ce qu'on construit dessous                                                                                                                                                                                                                                                                          |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Le réglage de l'environnement cloud**    | Niveau réseau, domaines, variables, script, connecteurs vivent **dans claude.ai**, pas dans git : aucune PR ne les pose, aucun gate ne les voit dériver                                                                                                                                                                                                                                      | Lot 0 : une cible **exacte** (une checklist, pas un design), dix minutes, une fois. Lot 1 : la sonde de session qui **constate** l'écart à chaque démarrage et le nomme. Le script d'environnement, s'il y en a un, est une copie d'un fichier **versionné**                                        |
| **Les identifiants qui se renouvellent**   | `GH_AUTOMATION_PAT` expire le **2026-10-04** ([passation.md](../passation.md)) ; aucune session cloud ne pose un secret (pas de `gh`, pas d'outil MCP). `CLAUDE_CODE_OAUTH_TOKEN` des trois gardes agent est né de `claude setup-token`, commande CLI **interactive** : ni une session cloud ni un téléphone ne la jouent, et sa date d'expiration n'est écrite **nulle part** dans le dépôt | PAT : github.com puis « Settings → Secrets » dans le navigateur du téléphone — un geste de dix minutes, à dater. Jeton OAuth : **supprimer le besoin** — porter les trois gardes en routines (lot 5), qui consomment l'abonnement sans jeton. En attendant, une issue qui porte la date à constater |
| **Le classifieur d'auto-mode**             | Inchangé : il vit chez l'éditeur de l'outil. Les sessions cloud offrent Auto, Accept edits, Plan                                                                                                                                                                                                                                                                                             | Rien côté dépôt (c'est le mur d'origine). Accept edits est le mode sans classifieur pour un lot bien borné                                                                                                                                                                                          |
| **La règle d'usage du poste d'entreprise** | Seul Mohamed peut la lire ; l'étude ne la juge pas                                                                                                                                                                                                                                                                                                                                           | Le parti le plus sûr : **le poste n'est pas dans la boucle**, même pas comme navigateur. Tout est conçu téléphone d'abord, donc ce parti ne coûte rien                                                                                                                                              |
| **Une plateforme en « research preview »** | Limites de débit partagées avec tout l'usage du compte, plafond quotidien de runs de routines, expiration des VM inactives, surface API des routines susceptible de changer                                                                                                                                                                                                                  | Pas un mur, une contrainte de conception : petits lots poussés (déjà la règle), horloges plutôt que sessions qui attendent, et **aucune promesse** de l'étude qui repose sur un comportement non constaté                                                                                           |

## 6. Options et recommandation

| Option                                                                                                                                | Ce qu'elle coûte                                                                                                       | Ce qu'elle rapporte                                                                                                     | Verdict                                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A. Cloud-first sur « Default » passé en Custom** (liste par défaut + 4 domaines nommés), amorçage versionné, Drive pour la classe B | Dix minutes de réglage, six lots de session (petits), une dérive possible du réglage — rendue **visible** par la sonde | Tout le §2 en vert ou nommé ; le harness intact ; le poste hors de la boucle ; la liste blanche garde son rôle de filet | ✅ **Recommandée**                                                                                                                                                                                            |
| B. Cloud-first en **Full**                                                                                                            | Zéro liste à tenir                                                                                                     | Idem A…                                                                                                                 | ❌ …mais la session qui **triage des signalements d'élèves** — un canal que `report-triage` screene précisément contre l'injection de prompt — aurait le monde entier pour destination. La liste est le filet |
| C. Remote Control / Dispatch depuis une machine personnelle                                                                           | Une machine allumée quelque part                                                                                       | Le système de fichiers local                                                                                            | ❌ Hors besoin (il n'y a pas de machine), et ça réintroduit un poste                                                                                                                                          |
| D. Environnement auto-hébergé                                                                                                         | Une infrastructure à opérer                                                                                            | Un réseau à soi                                                                                                         | ❌ Disproportionné pour une personne ; rien au §2 ne l'exige                                                                                                                                                  |

**Ce que A ne promet pas** : que le connecteur Drive livre des octets (à constater, lot 3) ; que
l'app GitHub « Claude » soit installée sur les dépôts (à constater sur cette PR — elle conditionne
l'auto-fix et les routines déclenchées par GitHub, pas le travail courant) ; que `gh` soit absent
de **toutes** les sessions (constaté absent dans celle-ci ; la vue cloud de la policy doit tenir
dans les deux cas).

## 7. Plan d'exécution

Un lot = une session = une PR, jeu de fichiers disjoint. Les lots 1, 2 et 4 sont
**indépendants** et prenables dès maintenant ; le lot 3 dépend du lot 0 ; le lot 5 est un
arbitrage puis une exécution ; le lot 6 ferme.

### Lot 0 — Mohamed, depuis le téléphone, une fois (mur « réglage hors dépôt »)

C'est l'unique lot qui lui revient. Cible exacte, dans l'ordre, tout dans un navigateur :

1. **claude.ai/code → icône d'environnement → « Default » → réglages → Network access :
   `Custom`**, cocher « Also include default list of common package managers », et lister :

   ```text
   www.cnp.com.tn
   www.na9ranal3ab.tn
   fasrenmmrkqjoobrztbp.supabase.co
   pqegdnwdtbjtplcthxyp.supabase.co
   ```

   Un par ligne, une raison par ligne : les manuels (classe A) ; la prod, en **lecture** — sonde
   `/api/health`, contrôle post-déploiement, vérification de rollback ; la prod Supabase en
   **REST anonyme** (comptages du playbook campagnes, avec les seules clés publiques) ; le projet
   TEST (`content:manuel:check`, `e2e:doctor`). Rien d'autre : Vercel déploie sur push, PostHog et
   l'étage IA vivent en prod. Enregistrer — le cache d'environnement se reconstruit à la session
   suivante.

2. **Variables d'environnement** du même dialogue, **publiques seulement** : `VITE_SUPABASE_URL`
   et `VITE_SUPABASE_PUBLISHABLE_KEY` (les valeurs du `.env` qui partent dans chaque bundle
   client). Ni clé service, ni jeton, ni rien qui ne soit déjà public.
3. **Script d'installation** : laisser **vide** — le lot 4 livre son contenu, versionné.
4. **claude.ai/customize/connectors → Google Drive → connecter.** Puis, sur le téléphone, créer
   le dossier Drive `YahiaAcademy/` et y déposer ce qui n'est **pas** au CNP (classe B). Les
   manuels n'y vont pas.
5. **github.com → Settings → Applications → Claude** : vérifier que l'app couvre les trois
   dépôts (auto-fix des PR, routines sur événement GitHub). Le résultat de l'abonnement de cette
   PR dira si c'est déjà le cas.
6. **Rien sur le PC de travail.** Ni maintenant, ni pour les lots suivants.

### Lot 1 — L'amorçage de session, versionné et vérifié (session, ce dépôt)

- Un hook `SessionStart` (`.claude/hooks/session-start.mjs`, câblé par `scripts/harness/sync.mjs`
  comme les trois hooks existants — donc couvert par `harness:check`), qui **ne fait rien hors
  cloud** (`CLAUDE_CODE_REMOTE`) et en cloud : pose Node **24** depuis `.nvmrc` via nvm et
  l'exporte dans `$CLAUDE_ENV_FILE` (sans quoi le hook `pre-push` tourne sous Node 22 et rejoue
  le piège « Node trop vieux ») ; `npm install` si `node_modules` manque ou si `package-lock.json`
  a changé ; **la sonde** : version de Node, joignabilité des quatre domaines du lot 0, présence
  de pgTAP — et un message **en clair** pour chaque écart (« `www.cnp.com.tn` refusé : le lot 0
  n'est pas appliqué, aucune campagne ne pourra lire un manuel »). Un test sous
  `scripts/harness/__tests__/`.
- DoD : une session cloud neuve joue `npm run verify` vert **sans aucun geste** ; durée
  d'amorçage mesurée et écrite ici (§9).

### Lot 2 — La policy a une vue cloud (session, ce dépôt) — un arbitrage à l'intérieur

- `harness/policy.json` gagne les règles **par outil MCP**, compilées dans
  `.claude/settings.json` par le sync existant : autoriser la lecture GitHub (`get_me`,
  `list_*`, `pull_request_read`, `issue_read`, `actions_get/list`, `get_job_logs`,
  `get_check_run`) et le cycle PR/issue déjà ouvert à `gh-write` (`create_pull_request`,
  `update_pull_request`, `add_issue_comment`, `issue_write`, `enable_pr_auto_merge`,
  `resolve_review_thread`) ; **refuser** `merge_pull_request` — la règle du 2026-07-12 que le
  préfixe `gh pr merge` ne savait pas exprimer sans casser `--auto` devient **exprimable**, parce
  que l'armement (`enable_pr_auto_merge`) est un outil distinct — ; refuser `push_files`,
  `create_or_update_file`, `delete_file`, `create_repository`, `fork_repository` : des écritures
  **par API** qui contournent les hooks husky, c'est-à-dire le filet.
- **L'arbitrage** : `actions_run_trigger` est **un** outil pour tous les workflows, et il n'y a
  pas de troisième chemin (REST brut refusé, `gh` absent). Le refuser, c'est priver la session
  du rollback et de `apply-content` — donc réintroduire un clic humain sur chaque campagne
  publiée, ce que la règle interdit. **Préconisation** : l'autoriser, et descendre les deux
  interdits **dans les workflows** : `db-migrate-prod.yml` et `release.yml` refusent un
  `workflow_dispatch` tant qu'une variable de dépôt nommée (par exemple `ALLOW_MANUAL_DISPATCH`)
  n'est pas posée — une variable qu'**aucune session cloud ne peut poser** (pas de `gh`, pas
  d'outil), et que la policy locale continue de refuser de supprimer. Le `deny` par nom reste en
  place pour toute session qui a `gh`. La raison s'écrit dans le `$comment`, comme toujours.
- `AGENTS.md` est **au plafond** (250 lignes / 24 279 octets sur 24 576) : la phrase sur la vue
  cloud remplace une phrase existante ou va dans `docs/agents/`, jamais en plus.

### Lot 3 — La campagne de contenu depuis le cloud (session, dépôt privé + celui-ci) — après le lot 0

- **Mesure d'abord** : le connecteur Drive rend-il les octets d'un PDF ? Un `HEAD` sur
  `CNP_MANUEL_BASE_URL/102905P00.pdf` répond-il 200 depuis la session ?
- Un script `content:manuel:fetch <code>` (moteur, ici) qui télécharge dans le scratch de la
  session l'exemplaire nommé par le code — l'URL se **dérive**, jamais ne se saisit (doctrine
  D-10 de l'étude 23) ; le rendu des pages en images par PyMuPDF (`pip`, 6 s) ou poppler (`apt`,
  lot 4) — au choix du script, versionné avec lui ; `render.sh` du wrapper devient inutile.
- [campagnes-contenu.md](./campagnes-contenu.md) § « Le corpus source est hors dépôt » est
  réécrit : le corpus est **à la source** ; « une campagne tourne sur ce poste » n'est plus vrai.
- **Pilote** : un chapitre de bout en bout depuis une session cloud lancée du téléphone sur le
  dépôt privé (+ celui-ci pour le moteur), jusqu'au merge et à `apply-content` — le budget
  « ~4 chapitres par session » se re-mesure en cloud, avec l'expiration de VM comme contrainte.

### Lot 4 — pgTAP en session cloud (session, ce dépôt) — indépendant

- `scripts/cloud/setup-env.sh`, **versionné**, contenu du script d'environnement (`apt-get
install -y postgresql-16-pgtap poppler-utils || true`, sous les cinq minutes) — le champ dans
  claude.ai n'en est qu'une copie, et la sonde du lot 1 dit s'il est appliqué.
- `service postgresql start` à la demande (la recette de [pgtap-en-local.md](./pgtap-en-local.md)
  s'applique telle quelle, hors la ligne `apt`) ; le titre et le préambule du playbook disent
  « en local **ou** en session cloud ».
- DoD : la suite (81 fichiers, 1 139 assertions) verte depuis une session cloud, durée écrite.

### Lot 5 — Les horloges deviennent des routines (arbitrage, puis session)

- **La garde après push** (DoD §8) documentée pour le cloud dans [passation.md](../passation.md)
  §7 : abonnement aux événements de la PR + réveil différé, et ce qu'une VM récupérée restaure.
- **La re-sonde hebdomadaire de `STATUS.md`** : la passe du 2026-09-04 a trouvé **68 PR de
  retard** parce qu'aucun gate ne surveille le topo public. Une routine hebdomadaire qui
  re-constate `main`, les PR ouvertes et les signaux rouges, et ouvre une PR de correction, est
  le mécanisme — pas un rappel de plus.
- **Arbitrage** : porter `regression-guard`, `upgrade-guard` et `report-triage` en routines
  (elles gardent leurs scripts déterministes ; seule la **tête** change de support) supprime le
  jeton `CLAUDE_CODE_OAUTH_TOKEN` et son renouvellement impossible sans CLI. Contrepartie : les
  runs comptent sur l'abonnement et le plafond quotidien, et la partie GitHub Actions (issues,
  labels, dispatch) se fait par outils MCP. À trancher avec le coût mesuré sur une semaine.

### Lot 6 — Décommission du poste (session, ce dépôt)

- [poste-windows.md](./poste-windows.md) reçoit un en-tête « playbook **hérité** — un poste local
  n'est plus le cas nominal depuis le 2026-09-xx ; ces pièges restent vrais pour qui en garde
  un » ; l'index de [README.md](./README.md) le dit.
- `STATUS.md` §1 : « le dossier parent `YahiaAcademy/` reste un wrapper hors git » devient
  « … a été remplacé par le CNP à la source (classe A) et un dossier Drive (classe B) ».
- La date du PAT et celle du jeton OAuth sont portées par une issue datée, avec le geste exact.
- KPI du §8 relevés, étude close.

## 8. KPI — comment on saura que c'est fait

| KPI     | Cible                                                                                  | Relevé                                                                           |
| ------- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **K-1** | 100 % des sessions des 30 jours suivant le lot 0 lancées depuis le téléphone ou le web | La liste des sessions sur claude.ai/code                                         |
| **K-2** | Zéro action sur le PC de travail — pas même un navigateur                              | Déclaratif, par Mohamed, à la clôture                                            |
| **K-3** | `npm run verify` vert en session cloud neuve **sans geste**, en ≤ 4 min                | Lot 1 ; référence de cette étude : 211 s (avec `nvm` et `npm install` à la main) |
| **K-4** | Un chapitre de campagne produit, mergé et appliqué depuis une session cloud            | Lot 3, journal de campagne au privé                                              |
| **K-5** | La suite pgTAP jouée verte en session cloud                                            | Lot 4                                                                            |
| **K-6** | Aucune ligne « attend un humain » nouvelle hors des murs du §5                         | `STATUS.md` § « Ce qui attend un humain », relu à chaque lot                     |

## 9. Journal des mesures (2026-09-04, session cloud, environnement « Default », réseau Trusted)

Reproductibles depuis n'importe quelle session cloud — c'est le point : **une mesure qui ne se
rejoue pas n'est pas une mesure.**

```bash
nproc; free -g; df -h .                    # 4 vCPU · 15 Go libres · 30 Go disponibles (Ubuntu 24.04)
node -v                                    # v22.22.2 par défaut
time nvm install 24                        # v24.20.0 — 5,7 s (nodejs.org est dans la liste Trusted)
time npm install --no-audit --no-fund      # 523 paquets — 22 s ; core.hooksPath=.husky/_ posé par `prepare`
npm run verify                             # exit 0 — 211 s ; 7 étapes ; 321 fichiers / 3 973 tests ; vitest 147 s
pip install pymupdf                        # 6 s (PyPI dans la liste)
for h in www.cnp.com.tn www.na9ranal3ab.tn fasrenmmrkqjoobrztbp.supabase.co \
         pqegdnwdtbjtplcthxyp.supabase.co drive.google.com api.github.com nodejs.org archive.ubuntu.com; do
  curl -sS -o /dev/null -I --max-time 15 -w "$h → HTTP %{http_code}\n" "https://$h/"
done                                       # 403 CONNECT sur les cinq premiers ; 400/200 sur les trois derniers
curl -sS "$HTTPS_PROXY/__agentproxy/status" | jq '.recentRelayFailures[0]'   # connect_rejected · policy denial · www.cnp.com.tn:443
echo "$GH_TOKEN"                           # proxy-injected
curl -sS -o /dev/null -w "%{http_code}\n" -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/MBeji/yahia-quest-content   # 403 : « GitHub access is not enabled for this session »
command -v gh jq psql pdftoppm docker      # gh absent · jq, psql 16, docker (client) présents · pdftoppm absent
```

Constats hors commande : les trois dépôts visibles avec droit de push (`list_repos`) ; les outils
MCP GitHub répondent (`get_me` → `MBeji`) ; connecteurs : Gmail connecté et actif, Google Drive
présent à l'organisation mais non connecté et inactif dans la session ; skills personnels
synchronisés sous `/root/.claude/skills/synced/`. **Cette étude elle-même** est le premier lot
livré dans ces conditions : rédigée, gatée (`verify`, puis le hook `pre-push`) et poussée depuis
une session cloud, sans qu'aucun poste n'ait été touché.

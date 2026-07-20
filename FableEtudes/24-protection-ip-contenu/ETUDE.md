# Étude 24 — Protection de la propriété intellectuelle du contenu (licences + scission corpus privé), repo moteur public conservé

> **Statut** : en exécution — Q-1/Q-2/Q-3/Q-5 arbitrées le 2026-07-19 (Q-4 reste ouverte, démarche humaine)
> **Priorité** : 24 · **Valeur** : 🔒 le corpus corrigé (566 chapitres, ~18 700 questions avec
> clés de réponse) et l'usine de génération (skills prof-\*, taxonomies) cessent d'être clonables
> en un `git clone` — **sans perdre** les avantages gratuits du repo public (Actions illimitées,
> CodeQL, rulesets/automerge) · **Complexité** : moyenne+
> **Architecte** : Fable / 2026-07-19 · **Exécuteur cible** : Sonnet (ou équiv.) — les lots 3 et 5
> touchent la prod et exigent le runbook pas à pas
> **Dépend de** : arbitrages humains Q-1…Q-5 · **Bloque** : recommandée AVANT la prochaine campagne
> massive de contenu (vague A lycée, corpus CNP) — chaque merge public accroît l'exposition
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `content/README.md`,
> `docs/ci-cd-and-branch-protection.md`, `docs/passation.md`,
> `FableEtudes/METHODE-GENERATION-CONTENU.md`

## 1. Contexte & objectif produit

Le repo `MBeji/yahia-quest-arena` est **public** depuis sa création (2026-05-22), pour de bonnes
raisons : minutes GitHub Actions **illimitées** (nightly E2E quotidien, 3 gardes Claude
hebdomadaires, CI multi-jobs par PR), **CodeQL gratuit** (check requis du ruleset
`main-protection`), **rulesets gratuits** (toute la chaîne push→PR→checks→automerge de la
décision 2026-07-12 repose dessus).

Le prix implicite de ce choix : **l'actif n° 1 du projet est publiquement clonable**. Le produit
n'est pas le code (une app de quiz gamifiée est réplicable) — c'est le **corpus pédagogique
corrigé et calibré** (36 Mo, 566 chapitres, ~18 700 questions — instantané étude 19) et
**l'usine qui le produit** (~35 skills `content-*`/`prof-*` avec cartes de chapitres, taxonomies
de pièges et barres de qualité). Aujourd'hui, un concurrent redéploie l'académie complète —
code + corpus + corrigés + usine — en quelques heures avec son propre projet Supabase.

Cas aggravant, indépendant de la concurrence : **les clés de réponse sont lisibles par les
élèves**. L'app applique rigoureusement l'invariant « la clé ne quitte jamais le serveur »
(`correct_option` et `distractor_tags` ne sont jamais envoyés au client), mais les mêmes clés
sont mondialement lisibles sur github.com — dans les fichiers `content/` **et** dans 267 des
345 migrations SQL. L'invariant anti-triche est respecté par l'app et annulé par le repo.

**Nuance de cadrage honnête** : en phase gratuite, l'app elle-même montre les cours et les
questions à tout visiteur (choix produit assumé, STATUS §1). Cette étude ne cherche donc pas à
cacher ce que l'app affiche ; elle protège ce que l'app ne donne **jamais** : le corpus complet
en un seul artefact machine-exploitable, les corrigés, les taxonomies server-only, et le
savoir-faire de génération. L'objectif est de rendre la copie **coûteuse et juridiquement
attaquable**, pas métaphysiquement impossible.

**Résultat attendu (KPI)** :

- après exécution, un clone du repo public contient **0 question, 0 corrigé, 0 skill
  pédagogique, 0 migration de contenu** (tip **et** historique si Q-2 = oui) ;
- la chaîne CI/automerge/déploiement/migrations du repo public reste **inchangée et verte**
  (Actions illimitées, CodeQL, ruleset intacts) ;
- le flux de production de contenu (METHODE-GENERATION-CONTENU) fonctionne à friction
  marginale (≤ 1 étape de setup en plus par session) ;
- le projet a une base juridique **signalée** (LICENSE) opposable et mobilisable (DMCA/OTDAV).

**Hors objectif** : DRM côté client (le contenu affiché reste affiché), fermer le code (le repo
moteur reste public — c'est la contrainte posée), changer de stack/hébergeur, monétisation
(étude 01, gelée).

## 2. État des lieux (audit du 2026-07-19) & modèle de menace

### 2.1 Actifs exposés dans le repo public

| actif                                | où                                                                                         | volume                                                                | sensibilité                                                                                        |
| ------------------------------------ | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Corpus pédagogique **avec corrigés** | `content/`                                                                                 | 36 Mo · 566 `cours.md` · 566 `quiz.json` · 2 713 fichiers d'exercices | **maximale** — clés de réponse, explications, `misconceptionTag` par distracteur                   |
| Le même corpus **compilé en SQL**    | `supabase/migrations/`                                                                     | 267 fichiers sur 345 insèrent dans `questions`                        | **maximale** — `correct_option`, `distractor_tags`, `explanation` en clair (double exposition)     |
| Usine de génération                  | `.claude/skills/` (`content-engine`, 12 `content-*`, ~25 `prof-*`, `curriculum-architect`) | 6,1 Mo                                                                | **maximale** — le savoir-faire qui permet de _régénérer_ un corpus concurrent, pas juste le copier |
| Registres taxonomiques               | `content/misconceptions.json`, `content/competences/`, `content/videos.json`               | —                                                                     | haute — server-only à l'exécution, publics dans le repo                                            |
| Études & stratégie produit           | `FableEtudes/` (23 études + METHODE)                                                       | 1,2 Mo                                                                | haute — arbitrages, roadmap, méthode complète                                                      |
| Code applicatif & pipeline           | `src/`, `scripts/`                                                                         | —                                                                     | moyenne — générique, différenciation faible                                                        |
| Marque                               | « Na9ra Nal3ab »                                                                           | —                                                                     | moyenne — aucune trace de dépôt (Q-4)                                                              |
| Corpus sources CNP / go-live         | wrapper `YahiaAcademy/` **hors git**                                                       | —                                                                     | ✅ déjà hors exposition                                                                            |

### 2.2 Situation juridique actuelle

- **Aucun fichier LICENSE, aucun champ `license`** (`package.json` ne porte que
  `"private": true`, un flag npm anti-publication, sans effet GitHub). Régime par défaut
  (convention de Berne, dont la Tunisie est membre ; loi n° 94-36 du 24-02-1994 modifiée
  2009-33) : le droit d'auteur naît **sans formalité** — « tous droits réservés » implicites.
- **Mais** les conditions d'utilisation GitHub (« License Grant to Other Users ») font qu'un
  repo public accorde à tout utilisateur GitHub le droit de **consulter et forker sur GitHub**.
  Rien de plus : réutiliser, redéployer ou rediffuser le corpus violerait déjà le droit
  d'auteur. Le problème n'est donc pas l'absence de droits, c'est que (a) rien ne les
  **signale** (une LICENSE explicite caractérise la mauvaise foi et arme un takedown DMCA),
  (b) l'opposabilité **pratique** est coûteuse (identifier/joindre un contrefacteur), et
  (c) la voie technique de la copie est à **coût nul** (`git clone`).

### 2.3 Faits techniques qui rendent la scission possible (tous audités sur le code)

1. **Le runtime n'a aucune dépendance à `content/`** : rien sous `src/features/` ni
   `src/routes/` n'importe `src/shared/content/*` ; le build Vercel ne lit pas `content/` ;
   l'app lit exclusivement la DB. Le pipeline (`schema/loader/sql-builder` + `scripts/content/`)
   est un outillage de build **générique**, séparable du corpus.
2. Couplages « gate » restants, tous localisés : `ci.yml` (steps `content:check`/`qa:strict` +
   job `content`), **2 tests unitaires** qui lisent les registres réels
   (`content-pipeline-a0.test.ts`, `content-pipeline-etude07.test.ts` — le reste utilise des
   fixtures temporaires), et `scripts/content/*` qui résolvent `cwd()/content` en dur.
3. Les specs Playwright ne référencent **aucun contenu précis** (grep vide) — à re-confirmer au
   lot 6 pour la tier authentifiée.
4. **Le framework de migrations ne supporte pas deux repos sur une même DB** : `supabase db push`
   échoue quand l'historique distant contient des versions absentes du dossier local (« Remote
   migration versions not found in local migrations directory ») → si les migrations de contenu
   partent au privé **en restant des migrations**, les push des deux repos se bloquent
   mutuellement. C'est le fait fondateur de la décision D-3.
5. **0 fork, 1 star** (API GitHub, 2026-07-19), repo âgé de ~2 mois → une réécriture
   d'historique est réaliste et à faible casse.
6. La purge du dossier n'efface pas le passé : tout l'historique git public contient déjà le
   corpus → la protection du _stock_ actuel passe par la réécriture d'historique (Q-2), celle du
   _flux_ futur (lycée, CNP, annales — la majorité du corpus final) par la scission elle-même.

### 2.4 Modèle de menace

| id  | menace                                                                                                 | gravité | probabilité                      | ce qui la traite                            |
| --- | ------------------------------------------------------------------------------------------------------ | ------- | -------------------------------- | ------------------------------------------- |
| T-1 | **Redéploiement intégral** (clone code+corpus+usine → académie concurrente, éventuellement re-brandée) | ★★★★    | moyenne (marché EdTech TN/MENA)  | scission (C) + licence (A) + marque (Q-4)   |
| T-2 | **Extraction du corpus** (cours/questions/corrigés réinjectés dans un autre produit)                   | ★★★★    | moyenne                          | scission + purge historique (Q-2) + licence |
| T-3 | **Triche élève** — lire `correct_option` des quiz/concours blancs sur github.com                       | ★★★     | élevée dès que l'app a du trafic | scission + purge historique                 |
| T-4 | **Vol de l'usine** (skills `prof-*`, taxonomies, méthode) pour générer un corpus rival                 | ★★★★    | faible-moyenne                   | scission (skills au privé)                  |
| T-5 | **Copie de marque** (nom, identité « Na9ra Nal3ab »)                                                   | ★★      | faible                           | dépôt INNORPI (Q-4)                         |

## 3. Options étudiées

### Option A — armement juridique seul (licences + notices), repo inchangé

Coût ≈ 0, effet immédiat : signale les droits, caractérise la mauvaise foi, arme les takedowns
DMCA GitHub contre les clones re-publiés, fonde un contentieux. Ne change **rien** au coût
technique de la copie. → **Retenue comme socle (lot 1), insuffisante seule.**

Analyse des licences candidates :

| licence                                 | ce qu'elle permettrait aux tiers                                   | verdict                                                                                                    |
| --------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| Aucune (statu quo)                      | consultation + fork GitHub (ToS), zéro signalisation               | rejeté — c'est l'état actuel                                                                               |
| MIT / Apache-2.0                        | réutilisation commerciale libre                                    | rejeté — contraire à l'objectif                                                                            |
| CC BY-NC-ND 4.0 (contenu)               | **rediffusion verbatim** non commerciale avec attribution          | rejeté pour le contenu — un miroir gratuit du corpus tue l'académie ; on n'accorde pas ce droit            |
| BUSL-1.1                                | source-available avec bascule Apache à date fixée                  | rejeté — la bascule programmée n'a aucun sens pour un corpus pédagogique                                   |
| Elastic License 2.0 (code)              | usage/modification, **sauf** service concurrent managé             | candidat sérieux si on veut permettre l'usage interne ; moins protecteur que PolyForm-NC                   |
| **PolyForm Noncommercial 1.0.0** (code) | usage personnel/recherche/éducation **non commerciale** uniquement | **recommandé code** — texte court éprouvé, interdit tout usage commercial tiers ; le titulaire reste libre |
| **« Tous droits réservés » explicite**  | rien au-delà des ToS GitHub                                        | **recommandé contenu/skills/études** (`LICENSE-CONTENT.md`)                                                |

Note : les avantages gratuits GitHub (Actions illimitées, CodeQL, rulesets) tiennent à la
**visibilité publique** du repo, pas à une licence OSI — un repo public sous licence
restrictive les conserve intégralement.

### Option B — passer tout le repo en privé — **rejetée**

- **Minutes Actions** : Free privé = 2 000 min/mois, Pro (4 $/mois) = 3 000. Conso estimée du
  repo : nightly E2E+pgTAP ~20-30 min × 30 ≈ 600-900 ; `regression-guard` 2×30 ≈ 260 ;
  `upgrade-guard` 2×60 ≈ 520 ; `content-audit` 2×40 ≈ 350 ; CI multi-jobs par push/PR
  (~15-25 min × 30-60 événements) ≈ 450-1 500 → **≈ 2 200-3 500+ min/mois** : au-delà des deux
  plafonds, dépassements facturés, arbitrages permanents (couper le nightly ?).
- **CodeQL** : gratuit uniquement en public. En privé il faut GitHub Code Security
  (~30 $/committer/mois, réservé aux organisations Team/Enterprise) — hors de portée d'un compte
  perso. Or `CodeQL` est un **check requis** du ruleset `main-protection` → il faudrait le
  retirer : perte du SAST + refonte du ruleset.
- **Rulesets/branch protection** : indisponibles en privé sous Free → la chaîne automerge
  (décision 2026-07-12) casse ; GitHub Pro requis a minima.
- Vercel et Supabase fonctionnent en privé (non différenciant).
  → Coûts récurrents + démontage de la chaîne CI pour une protection que l'option C obtient
  sans ces pertes.

### Option C — scission moteur public / corpus privé — **recommandée**

Le repo public devient **le moteur** (app + pipeline générique + docs techniques + CI lourde,
qui garde les avantages gratuits). Un nouveau repo **privé** `yahia-quest-content` (même compte,
plan Free) porte le corpus, les SQL de contenu générés, les skills pédagogiques et (Q-3) les
études. La CI privée est légère (~300-600 min/mois, sous le plafond de 2 000 avec marge ×3).
Architecture détaillée en §4.

### Option D — chiffrer `content/` dans le repo public (git-crypt/transcrypt) — **rejetée**

Conserve le monorepo mais : diffs/reviews illisibles (la revue de contenu est un pilier —
`content-audit`), hooks prettier/lint-staged cassés sur blobs binaires, clé à distribuer à
chaque session/CI/collaborateur, l'historique déjà public reste en clair de toute façon, et
36 Mo de blobs chiffrés dans un repo public est un signal étrange sans bénéfice réel.

### Option E — monorepo privé + miroir public expurgé auto-généré — **rejetée**

Pour que le miroir soit sain, toute la CI lourde devrait tourner côté privé (minutes payantes)
→ réintroduit les coûts de l'option B, plus une synchro fragile (PRs ouvertes sur le miroir
impossibles à rapatrier proprement, historique divergent).

### Décisions d'architecture (ADR)

- **D-1** — Stratégie retenue : **A + C en deux phases** — lot 1 (juridique, immédiat, PR
  unique) puis lots 2-6 (scission). B, D, E rejetées (motifs ci-dessus).
- **D-2** — Licences : code public → **PolyForm Noncommercial 1.0.0** (Q-1 si l'humain préfère
  Elastic 2.0) ; contenu, skills pédagogiques, études, migrations de contenu → **« Tous droits
  réservés » explicite** (`LICENSE-CONTENT.md`, FR + EN). Pas de Creative Commons pour le
  corpus (même ND : la rediffusion verbatim gratuite reste une perte sèche).
- **D-3** — **Le corpus sort du framework de migrations Supabase.** Le SQL de contenu — déjà
  idempotent par construction (UUIDv5 stables, upsert, prune scopé par sujet) — n'a pas besoin
  d'un historique ordonné : il est ré-émis par sujet dans le repo privé
  (`sql/content/<subject>.sql`, nom stable, plus de timestamp) et appliqué par un workflow
  `psql` dédié. Motif impératif : §2.3-4 (le CLI refuse les historiques croisés). Bénéfice
  collatéral : la classe de bugs d'ordre de timestamps (#97 → #227 → #229) disparaît pour le
  contenu, et le diff par sujet devient lisible (fini les fichiers horodatés dupliqués).
- **D-4** — **Le repo privé ne duplique pas le moteur.** Sa CI fait un double
  `actions/checkout` (privé + public) et exécute les scripts publics contre le corpus privé.
  Prérequis : paramétrer le répertoire corpus (`--content-dir`, aujourd'hui `cwd()/content` en
  dur) — petit patch du moteur, rétro-compatible.
- **D-5** — **Réécriture de l'historique public** (`git filter-repo`) pour purger le corpus,
  les skills pédagogiques, les études et les 267 migrations de contenu du passé, précédée d'une
  **archive miroir privée** (`yahia-quest-arena-archive`). Conditionnée à Q-2
  (recommandation : oui — 0 fork, ~2 mois d'âge).
- **D-6** — Les registres (`misconceptions.json`, `competences/`, `videos.json`) suivent le
  corpus au privé ; les 2 tests unitaires du moteur qui les lisent basculent sur fixtures.
- **D-7** — Marque et préconstitution de preuve (INNORPI, OTDAV) : piste **humaine** parallèle
  (Q-4), pas un lot exécuteur.

## 4. Architecture cible (option C, décisions fermées)

### 4.1 Répartition des artefacts

| artefact                                                                                                       | repo                            | notes                                                                                      |
| -------------------------------------------------------------------------------------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------------ |
| `src/`, `scripts/` (dont `scripts/content/` — moteur générique), `e2e/`, `docs/`, CLAUDE/ARCHITECTURE/STATUS   | **public** `yahia-quest-arena`  | inchangé                                                                                   |
| `supabase/migrations/` — **schéma + ops uniquement** (78 fichiers restants)                                    | **public**                      | les 267 migrations de contenu sont retirées (lot 3)                                        |
| Skills techniques (`verify`, `code-review`, `regression-guard`, `upgrade-guard`, `report-triage`, …)           | **public**                      | inchangé                                                                                   |
| Workflows CI/CD (moins `content-audit.yml`)                                                                    | **public**                      | `ci.yml` amaigri + **gate anti-fuite** (§4.4)                                              |
| `content/` complet (registres inclus)                                                                          | **privé** `yahia-quest-content` | 36 Mo, arborescence inchangée                                                              |
| `sql/content/<subject>.sql` **générés**                                                                        | **privé**                       | remplacent les migrations de contenu ; un fichier par sujet, régénéré en place             |
| Skills pédagogiques (`content-engine`, `content-*`, `prof-*`, `curriculum-architect`, `content-ingest`, …)     | **privé**                       | déplacés sous `.claude/skills/` du privé                                                   |
| `FableEtudes/` + `METHODE-GENERATION-CONTENU.md`                                                               | **privé** (Q-3)                 | reco : privé (stratégie) ; STATUS.md reste public (état produit, déjà public via l'app)    |
| Workflows privés : `content-ci.yml`, `apply-content.yml` (prod), `apply-content-test.yml`, `content-audit.yml` | **privé**                       | secrets : `PROD_SUPABASE_DB_URL` (copie), URL DB du projet TEST, `CLAUDE_CODE_OAUTH_TOKEN` |

### 4.2 Pipeline de contenu après scission (le fond du flux METHODE ne change pas)

```
auteur (session Claude ouverte sur le repo PRIVÉ, moteur public ajouté via add_repo/checkout)
  → édite content/<subject>/…                                   [inchangé]
  → PR privée → content-ci.yml :
      checkout privé + checkout public (moteur)
      npm ci (moteur) puis content:check / content:qa:strict / content:audit:strict
        avec --content-dir ../yahia-quest-content/content        [patch D-4]
  → merge → apply-content.yml :
      garde « cible = prod » + pg_dump de sauvegarde             [même posture que db-migrate-prod]
      content:build --subject <ids modifiés> → sql/content/<subject>.sql
      psql : application des sujets modifiés (diff du merge)
      journal dans content_releases (sha, sujets, horodatage)
```

- **Idempotence** : rejouer un fichier sujet est sûr par construction (upsert UUIDv5 + prune
  scopé au sujet — mécanique actuelle inchangée, seul le canal d'application change).
- `Migration presence` / `Migration order` (public) ne voient plus le contenu ; le gate d'ordre
  reste pour le schéma. Le nightly pgTAP public reste le prouveur du schéma.
- Le privé gagne un job hebdo **fresh-apply** : schéma public sur DB jetable + tous les
  `sql/content/*.sql` → détecte une dérive schéma ↔ contenu (l'équivalent privé de la garantie
  « toute migration s'applique sur une DB vierge »).
- Table `content_releases` (privée à l'ops, RLS service-role only, grants explicites §DoD) :
  `id, applied_at, git_sha, subjects text[], actor` — le pendant du journal
  `supabase_migrations` que le contenu quitte.

### 4.3 Nettoyage one-shot de l'historique de migrations prod (lot 3 — runbook)

1. Inventorier les versions de contenu (script : migrations qui n'insèrent que dans
   `subjects/chapters/exercises/questions` sans DDL) — attendu ≈ 267.
2. `supabase migration repair --status reverted <versions>` sur prod : ne touche **que** la
   table d'historique `supabase_migrations.schema_migrations` — les données de contenu en base
   restent intactes.
3. Retirer les fichiers correspondants du repo public (tip).
4. Vérifier : `supabase db push --dry-run` (public) = clean ; `db-migrate-prod.yml` inchangé,
   réconciliation horaire comprise.
5. Répéter 1-4 sur le projet TEST **d'abord** (répétition générale), prod ensuite, fenêtre
   calme, backup `pg_dump` frais.

### 4.4 Adaptations du repo public (lot 4)

- `ci.yml` : retirer le job `content` et les steps `content:check`/`qa:strict` du job
  principal ; ajouter un **gate anti-fuite** — step qui **échoue** si le tip contient
  `content/**`, `sql/content/**`, un skill `content-*`/`prof-*`, ou une migration insérant dans
  `questions` (protège contre une future session qui re-commiterait du corpus au public par
  réflexe).
- Tests : fixtures pour les 2 tests registres (D-6) ; le reste du harnais de tests du moteur
  utilise déjà des fixtures temporaires.
- Docs : CLAUDE.md (section « Content pipeline » réécrite : le corpus est privé, le moteur est
  ici), `content/README.md` remplacé par une page pointeur, README, copilot-instructions,
  `docs/content-generation-pipeline.md`, `docs/passation.md`.
- Vercel, e2e, ruleset, automerge : **inchangés**.

### 4.5 Sécurité & invariants après scission

- L'invariant « clé server-only » redevient vrai **de bout en bout** : app inchangée (la clé
  n'est jamais sélectionnée côté client) et plus aucune copie mondialement lisible.
- Repo privé : collaborateurs **nominatifs** uniquement (invitations Free illimitées) ;
  `CONTRIBUER.md` gagne un § cession : toute contribution (code ou contenu) est cédée au
  projet — accepté en ouvrant la PR.
- Les secrets prod restent dans GitHub Actions des deux repos (jamais côté sessions) — posture
  `db-migrate-prod` conservée.
- Défense en profondeur T-1/T-2 : licence (dissuasion + DMCA) **et** scission (coût technique)
  **et** marque (Q-4). Aucune couche seule ne suffit ; ensemble elles rendent la copie
  non-triviale et attaquable.

## 5. Plan d'exécution en lots

| lot | contenu (résumé)                            | fichiers/objets créés                                                                                                  | tests exigés                                                              | dépend de  |
| --- | ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ---------- |
| 1   | Armement juridique (public, 1 PR, immédiat) | `LICENSE.md`, `LICENSE-CONTENT.md`, notices README/content/FableEtudes, § cession CONTRIBUER.md, `package.json`        | gate verte (docs only) ; vérif © footer app (i18n ×3 si ajouté)           | Q-1        |
| 2   | Repo privé + CI contenu                     | repo `yahia-quest-content`, copie corpus+skills(+études Q-3), CLAUDE.md privé, `content-ci.yml`, patch `--content-dir` | `content:check`/`qa:strict`/`audit:strict` verts au privé sur corpus réel | lot 1, Q-3 |
| 3   | Découplage SQL contenu + prod               | émetteur → `sql/content/`, `apply-content.yml`, `apply-content-test.yml`, table `content_releases`, runbook §4.3       | répétition TEST verte, dry-run public clean, apply prod no-op vérifié     | lot 2      |
| 4   | Dégraissage du public                       | retrait tip : `content/`, skills pédago, études (Q-3), 267 migrations ; `ci.yml` + gate anti-fuite ; fixtures ; docs   | `npm run ci:verify` vert SANS corpus ; smoke:shell vert                   | lot 3      |
| 5   | Purge de l'historique public (si Q-2 = oui) | archive miroir privée, exécution `git filter-repo`, force-push, re-tags, runbook post-op                               | PR témoin automerge verte, Vercel OK, `db-migrate` no-op, CI verte        | lot 4, Q-2 |
| 6   | E2E + régularisation                        | apply contenu TEST, vérif tier auth, STATUS.md § décisions (journal daté), index études                                | nightly verte 2 nuits consécutives                                        | lot 3      |

Détail et stop-points :

- **Lot 1** — périmètre : fichiers de licence et notices **uniquement**. `LICENSE.md` = texte
  intégral PolyForm Noncommercial 1.0.0 (ou Elastic 2.0 selon Q-1) avec en-tête de portée « le
  code de ce dépôt » ; `LICENSE-CONTENT.md` (FR+EN) = tous droits réservés couvrant
  `content/`, `supabase/migrations/` de contenu, `.claude/skills/` pédagogiques,
  `FableEtudes/` ; README § « Licence & propriété intellectuelle » ; `package.json` →
  `"license": "SEE LICENSE IN LICENSE.md"`. **Stop-point : ne rien déplacer, ne rien
  supprimer.** Exécutable dès Q-1 tranchée — chaque jour d'attente est un jour d'exposition
  non signalée.
- **Lot 2** — le privé naît par **copie** (le retrait du public attend les lots 4/5, pour ne
  jamais casser la CI publique). Critère d'acceptation : les trois gates contenu passent au
  privé contre le corpus réel via le moteur public checkouté. Stop-point : ne pas toucher à
  la prod ni aux migrations.
- **Lot 3** — LE lot délicat (prod). Suivre §4.3 : TEST d'abord, backup, fenêtre calme, PR
  avec runbook exécuté pas à pas. Réversibilité : ré-insérer les versions dans l'historique
  (`repair --status applied`) et restaurer les fichiers depuis l'archive.
- **Lot 4** — après ce lot, le clone public est « propre » au tip. Le gate anti-fuite est
  obligatoire dans la même PR (il protège l'état qu'elle crée).
- **Lot 5** — uniquement si Q-2 = oui. Archive miroir **avant tout** ; prévenir que tous les
  clones locaux/sessions doivent re-cloner ; re-taguer le tip (release-tagging-policy) ;
  demander à GitHub Support la purge des vues en cache (les objets orphelins peuvent rester
  servis par l'API un temps) ; PR témoin pour prouver la chaîne automerge.
- **Lot 6** — vérifier la tier e2e authentifiée avec le corpus appliqué au projet TEST ;
  journaliser la décision dans STATUS.md §2 (append-only) ; resynchroniser l'index des études.

Cases à cocher :

- [x] Lot 1 — armement juridique (LICENSE + notices) — livré le 2026-07-19
- [x] Lot 2 — repo privé + CI contenu — livré le 2026-07-19
- [ ] Lot 3 — découplage SQL contenu + nettoyage historique migrations
      → **3a livré le 2026-07-19** (outillage & canal, zéro prod : émetteur, inventaire,
      `content_releases`, workflows privés désarmés) · **3b** (runbook §4.3 : TEST puis prod)
      **bloqué** tant que les 4 écarts du journal ne sont pas arbitrés
- [ ] Lot 4 — dégraissage du repo public + gate anti-fuite
- [ ] Lot 5 — purge de l'historique public (si Q-2)
- [ ] Lot 6 — e2e TEST + régularisation documentaire

## 6. Stratégie de test

- **Public** : `npm run ci:verify` (dont build + smoke:shell) vert **sans** `content/` — prouve
  le découplage runtime (§2.3-1) ; gate anti-fuite testé par PR d'essai qui tente de
  re-committer un `quiz.json` (doit échouer) ; PR témoin post-purge pour la chaîne automerge.
- **Privé** : les trois gates contenu sur corpus réel à chaque PR ; job fresh-apply hebdo
  (schéma public + tout le SQL contenu sur DB jetable).
- **DB** : répétition intégrale du lot 3 sur le projet TEST avant prod ; `--dry-run` des deux
  côtés ; pgTAP nightly public inchangé (schéma) ; vérif post-apply `content_releases`.
- **E2E** : tier publique (sans backend) inchangée ; tier auth re-validée au lot 6 après apply
  TEST ; nightly verte 2 nuits consécutives avant de clore.

## 7. Risques & mitigations

- **RISK-1** — Casser l'apply prod pendant le lot 3 (historique migrations). Prob. moyenne /
  impact fort → répétition générale sur TEST, backup pg_dump frais, fenêtre calme, runbook pas
  à pas dans la PR, réversibilité documentée (§5 lot 3).
- **RISK-2** — L'exposition passée n'est pas récupérable à 100 % (clones inconnus, caches,
  archives tierces). Prob. faible (0 fork, 1 star, ~2 mois) / impact moyen → purge + demande
  GitHub Support ; accepter le résiduel ; la protection vaut surtout pour le **flux futur**
  (lycée, CNP, annales = la majorité du corpus final).
- **RISK-3** — Friction du workflow contenu (2 repos par session). Certaine / faible →
  METHODE mise à jour (checklist de démarrage : ouvrir le privé, `add_repo` le public), la
  boucle d'auteur elle-même ne change pas.
- **RISK-4** — La tier e2e auth suppose un catalogue en TEST. Prob. moyenne / impact moyen →
  `apply-content-test.yml` + vérification dédiée au lot 6 (les specs publiques ne référencent
  aucun contenu précis — vérifié).
- **RISK-5** — Dépassement des 2 000 min privées. Faible → conso estimée 300-600 min/mois
  (content-ci ~3-5 min/PR, audit hebdo 40 min ×8) ; si la marge fond : GitHub Pro 4 $/mois
  (+50 %) avant tout retour en arrière.
- **RISK-6** — La protection juridique reste imparfaite (un contrefacteur déterminé copie
  quand même). Certaine / moyen → c'est pour cela que la stratégie est **en profondeur**
  (licence + scission + marque) : rendre la copie coûteuse, tardive (corpus futur invisible)
  et attaquable (DMCA sur les clones GitHub, contentieux sur le reste).
- **RISK-7** — La purge casse des références (permaliens SHA, diffs des anciennes PRs, tags
  réécrits). Certaine / faible → l'archive miroir privée conserve la mémoire complète ;
  re-taguer le tip ; les textes des issues/PRs subsistent.
- **RISK-8** — Une session future re-commit du corpus au public par habitude. Prob. moyenne /
  impact fort → gate anti-fuite CI (échec dur) + note en tête de CLAUDE.md § contenu.

## 8. Questions ouvertes (pour l'humain) — Q-1/Q-2/Q-3/Q-5 arbitrées le 2026-07-19

- **Q-1** — **Licence du code public** : PolyForm Noncommercial 1.0.0 (**reco** — interdit tout
  usage commercial tiers) vs Elastic License 2.0 (permet l'usage interne, interdit le service
  concurrent) ? Rester sans licence est déconseillé (aucune signalisation).
  **Arbitré (2026-07-19) : PolyForm Noncommercial 1.0.0.**
- **Q-2** — **Purge de l'historique public** (lot 5) : oui (**reco** — 0 fork, fenêtre unique,
  archive préalable) ou non (accepter que le corpus de juillet 2026 reste lisible à jamais dans
  l'historique, la scission ne protégeant alors que le futur) ?
  **Arbitré (2026-07-19) : oui — purge (lot 5), archive miroir préalable.**
- **Q-3** — **Périmètre privé exact** : `FableEtudes/` + METHODE au privé (**reco** — c'est le
  savoir-faire) ou maintien public (valeur vitrine / onboarding de collaborateurs externes,
  qui devraient sinon être invités nominativement) ? STATUS.md reste public dans les deux cas
  (état produit, déjà public via l'app).
  **Arbitré (2026-07-19) : FableEtudes + METHODE au privé ; STATUS.md reste public.**
- **Q-4** — **Volet juridique tunisien** (démarches humaines, hors lots) : dépôt du corpus à
  l'OTDAV (préconstitution de preuve de titularité et d'antériorité) et dépôt de la marque
  « Na9ra Nal3ab » à l'INNORPI (classe 41 — éducation) ? Budget de l'ordre de quelques
  centaines de TND (à confirmer auprès des organismes), idéalement avant tout lancement
  marketing (Porte 1, sept. 2026). **Reste ouverte — démarche humaine, hors lots.**
- **Q-5** — **Fenêtre d'exécution** : reco = lot 1 immédiatement après arbitrage de Q-1 ;
  lots 2-6 **avant** la prochaine campagne massive de contenu (vague A lycée / corpus CNP),
  pour que le nouveau corpus naisse directement au privé et que la purge (Q-2) reste petite.
  **Arbitré (2026-07-19) : conforme à la reco — lot 1 immédiat, scission enchaînée dans la foulée.**

## 9. Journal d'exécution

- **2026-07-19 — arbitrages humains** : Q-1 = PolyForm Noncommercial 1.0.0 · Q-2 = purge oui ·
  Q-3 = FableEtudes + METHODE au privé · Q-5 = lot 1 immédiat puis scission enchaînée. Q-4
  (OTDAV/INNORPI) reste ouverte (démarche humaine). Statut → en exécution.
- **2026-07-19 — lot 1 livré** (branche `claude/ip-protection-public-repo-10qu8a`) :
  `LICENSE.md` (PolyForm-NC 1.0.0, texte canonique SPDX + Required Notice), `LICENSE-CONTENT.md`
  (tous droits réservés, FR/EN), § licence dans README, notices en tête de `content/README.md`
  et `FableEtudes/README.md`, § « Licence & cession des contributions » dans CONTRIBUER.md,
  `package.json` → `"license": "SEE LICENSE IN LICENSE.md"`. Écart accepté : le © applicatif
  existait déjà (meta `copyright` dans `__root.tsx` + clé i18n `copyrightNotice`) — aucun code
  applicatif touché, lot purement documentaire.
- **2026-07-19 — lot 2 amorcé, bloqué sur l'étape humaine** : la création du repo privé est
  impossible depuis une session (intégration GitHub scopée au seul repo public — `403`).
  Annexe [`LOT-2-BOOTSTRAP.md`](./LOT-2-BOOTSTRAP.md) livrée : étape humaine (~3 min, créer
  `yahia-quest-content` + secrets), puis import + CI privée exécutables en une passe par
  n'importe quelle session. **D-4 amendée** : symlink du corpus dans le checkout moteur au
  lieu du patch `--content-dir` (zéro modification du moteur).
- **2026-07-19 — lot 3a livré** (outillage & canal, **zéro opération sur une base**) —
  arbitrage humain du jour : livrer d'abord ce qui ne touche pas la prod, l'opération DB (3b)
  attendant la correction du §4.3. Livré côté **public** : l'émetteur du canal contenu
  (`build.ts --sql-dir` → `sql/content/<subject>.sql`, nom stable ; helper canonique
  `contentSqlFileName` + `COMPETENCES_SQL_FILE_NAME` dans `sql-builder.ts` ; script
  `content:emit` ; `sql/content/` gitignoré en attendant le gate anti-fuite du lot 4), le script
  d'inventaire `scripts/db/inventory-content-migrations.mjs` (`db:inventory-content`, remplace
  le critère inopérant du §4.3-1), la migration `content_releases` (ops-private : RLS **sans
  aucune policy**, `REVOKE` anon/authenticated, `GRANT ALL` service_role) et son test pgTAP
  `30_content_releases.test.sql`. Côté **privé** (PR `yahia-quest-content#1`) :
  `apply-content.yml` (prod) et `apply-content-test.yml` (TEST), en `workflow_dispatch`
  **uniquement** — déclencheur automatique volontairement **désarmé** jusqu'au 3b, pour qu'aucun
  merge ne puisse appliquer du contenu. Vérifié : SQL émis **identique** à celui du canal
  migration (même builder), ré-émission stable au même octet, `verify` vert (1 482 tests),
  `content:check` vert (77 sujets / 16 302 questions).
- **2026-07-19 — lot 3b : STOP, 4 écarts étude ↔ code réel à arbitrer** (règle d'exécution n° 3 —
  l'exécuteur ne re-designe pas). Le §4.3 doit être corrigé par l'architecte avant toute
  opération sur une base :
  1. **Volumétrie** — l'étude annonce 267 migrations de contenu et 78 restantes ; l'inventaire
     réel donne **227 générées** (révocables), **17 de contenu écrites à la main** et
     **102 schéma/ops**.
  2. **Critère du §4.3-1 inopérant** — « n'insèrent que dans subjects/chapters/exercises/
     questions sans DDL » ne sélectionne **aucune** migration générée : toutes embarquent un
     garde de contrainte idempotent (`DO $$ … exercises_mode_check … END $$`), toutes purgent
     `dungeon_run_questions` (cascade) et écrivent `question_competencies` (sortie du
     compilateur, étude 07). Critère retenu à la place : la **provenance** (`_generated_*_content`),
     exactement l'ensemble que `content:emit` reproduit. Corollaire de sûreté : les 17 migrations
     manuelles ne sont **jamais** révocables en masse — `20260522170000_seed_content.sql` seede
     aussi `badges` et `shop_items`.
  3. **Effet de bord schéma** — le garde de contrainte voyage avec le corpus vers le privé ;
     une base **fraîche** reconstruite depuis le seul repo public ne le porterait donc plus
     (le pgTAP nightly rejoue tout sur base vierge). À trancher : reposer la contrainte dans une
     migration de schéma publique, ou l'assumer côté canal contenu.
  4. **Ordre du runbook incompatible avec le canal prod** — le §4.3 prescrit « repair reverted (2)
     puis retrait des fichiers (3) », mais le seul canal sanctionné (`db-migrate-prod.yml` mode
     `repair-revert`) enchaîne `repair --status reverted` **puis `db push`** : appliqué dans cet
     ordre, il **ré-appliquerait les 227 migrations**. Le mode est conçu pour des _phantoms_
     distants dont le fichier est déjà retiré — donc l'ordre inverse, avec l'échec attendu (et
     donc à annoncer) de l'auto-apply entre le merge et le dispatch. S'y ajoute le chevauchement
     lot 3/lot 4 : retirer les 227 fichiers tant que `content/` et le job `content` de `ci.yml`
     vivent encore casse `content:check`.
- **2026-07-19 — lot 2 livré** : repo privé `MBeji/yahia-quest-content` créé (étape humaine),
  import initial `d67177a` = miroir de `yahia-quest-arena@ef43487` — `content/` (36 Mo),
  `FableEtudes/`, **40 skills pédagogiques** (l'annexe en comptait 39 par erreur ; les 5
  skills techniques restent au public), seeds (CLAUDE.md privé, README, .gitignore),
  `content-ci.yml` (double checkout + symlink) et `content-audit.yml` adapté (s'active avec
  le secret `CLAUDE_CODE_OAUTH_TOKEN`, recommandé au lot 4). Critère d'acceptation : run
  « Content CI » #1 vert sur le corpus réel. Règle de transition active : le contenu s'édite
  encore au public, le privé est un miroir jusqu'au lot 4.

# Annexe lot 2 — Bootstrap du repo privé `yahia-quest-content`

> **Préparée le 2026-07-19** (session du lot 1). La création d'un repo est **impossible depuis
> une session** (l'intégration GitHub est scopée à `yahia-quest-arena` : erreur 403
> « Resource not accessible by integration », constatée) → **l'étape 0 est humaine (~3 min)**
> ; tout le reste
> est exécutable par une session en une seule passe, sans re-décision, en suivant cette annexe.

## Étape 0 — humaine (une fois, ~3 min)

1. <https://github.com/new> → Owner **MBeji** · nom **`yahia-quest-content`** · visibilité
   **Private** · cocher « Add a README » · **aucun** template de licence ni de `.gitignore`.
2. (Requis au lot 3 seulement, possible dès maintenant) Settings → Secrets and variables →
   Actions : `PROD_SUPABASE_DB_URL` (même valeur que dans le repo public) et
   `TEST_SUPABASE_DB_URL` (projet TEST e2e). Pour la garde `content-audit` déplacée :
   `CLAUDE_CODE_OAUTH_TOKEN` (skip gracieux si absent).
3. Dire à une session Claude : « le repo privé est créé, exécute le lot 2 (annexe
   LOT-2-BOOTSTRAP) ».

## Étape 1 — session : import initial (copie, rien n'est retiré du public)

Ajouter le repo privé à la session (`add_repo MBeji/yahia-quest-content`), le cloner, puis
copier depuis un clone à jour de `yahia-quest-arena` (branche `main`) :

| source (public)                            | destination (privé)                                           | note                                       |
| ------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------ |
| `content/` (intégral, registres inclus)    | `content/`                                                    | 36 Mo                                      |
| `FableEtudes/` (études + METHODE + guides) | `FableEtudes/`                                                | arbitrage Q-3                              |
| les **40 skills pédagogiques** ci-dessous  | `.claude/skills/…`                                            | les 5 skills techniques restent au public  |
| `.github/workflows/content-audit.yml`      | idem                                                          | adapté : double checkout + symlink (ét. 2) |
| — (seed, contenus verbatim au §3)          | `CLAUDE.md`, `.gitignore`, `.github/workflows/content-ci.yml` |                                            |

**Skills à copier (40)** — tout sauf `code-review`, `regression-guard`, `report-triage`,
`upgrade-guard`, `verify` :
`content-audit`, `content-cours`, `content-culture-generale`, `content-ecole-tn`,
`content-engine`, `content-ingest`, `content-interactif`, `content-iq-training`,
`content-langue-anglais`, `content-langue-arabe`, `content-langue-francais`,
`content-muscle-cerveau`, `curriculum-architect`, et les 27 `prof-*` (`prof-anglais-9eme`,
`prof-anglais-college`, `prof-anglais-lycee`, `prof-arabe-9eme`, `prof-arabe-college`,
`prof-arabe-lycee`, `prof-arabe-primaire`, `prof-eco-gestion-lycee`, `prof-eveil-primaire`,
`prof-francais-9eme`, `prof-francais-college`, `prof-francais-lycee`,
`prof-histoire-geo-lycee`, `prof-info-lycee`, `prof-islamique-primaire`, `prof-math-6eme`,
`prof-math-9eme`, `prof-math-college`, `prof-math-lycee`, `prof-math-primaire`,
`prof-philo-lycee`, `prof-physique-9eme`, `prof-physique-college`, `prof-physique-lycee`,
`prof-svt-9eme`, `prof-svt-college`, `prof-svt-lycee`).

Commit initial (`feat: import initial du corpus (étude 24 lot 2)`), push `main`.

> ⚠️ **Règle de transition (lots 2 → 4)** : tant que la scission n'est pas terminée, il existe
> deux copies du corpus. **Le contenu continue de s'éditer dans le repo public** (source de
> vérité inchangée) ; la copie privée est un miroir. Resynchronisation finale juste avant le
> lot 4 (retrait du public), puis inversion définitive : le privé devient l'unique source.

## Étape 2 — CI privée

- `content-ci.yml` (§3) : double checkout (corpus privé + moteur public), `npm ci` côté
  moteur, **symlink** du corpus privé à la place de `engine/content`, puis les trois gates
  (`content:check`, `content:qa:strict`, `content:audit:strict`).
- **Écart accepté vs D-4 (amendée)** : pas de patch `--content-dir` du moteur — le symlink
  suffit puisque les scripts résolvent `cwd()/content`. Zéro modification du moteur public.
- `content:check` compare le SQL généré aux migrations **du moteur** : il reste vert tant que
  le miroir privé est identique au contenu public (état normal du lot 2, cf. règle de
  transition). Au lot 3 (émission vers `sql/content/` du privé), cette étape est remplacée.
- `content-audit.yml` déplacé : même logique qu'au public + double checkout/symlink ;
  `CLAUDE_CODE_OAUTH_TOKEN` en secret du privé (sinon skip gracieux, comme aujourd'hui).

**Critère d'acceptation du lot 2** : `content-ci` verte au privé sur le corpus réel → cocher
le lot 2 dans `ETUDE.md` + journal (même PR côté privé, ou PR doc côté public).

## §3 Fichiers seed (verbatim)

### `CLAUDE.md` (racine du repo privé)

```markdown
# CLAUDE.md — yahia-quest-content (corpus privé)

> Repo **privé** né de l'étude 24 (scission moteur public / corpus privé). Il porte le
> **corpus pédagogique** (`content/`), les **skills de génération** (`.claude/skills/`) et les
> **études** (`FableEtudes/`). Le **moteur** (app, pipeline de build, docs techniques) vit
> dans le repo public [MBeji/yahia-quest-arena](https://github.com/MBeji/yahia-quest-arena) —
> son CLAUDE.md reste canonique pour tout ce qui est code, conventions et DoD.

- **Propriété intellectuelle** : tous droits réservés — le `LICENSE-CONTENT.md` du moteur
  s'applique intégralement à ce dépôt.
- **Authoring** : le flux `FableEtudes/METHODE-GENERATION-CONTENU.md` est inchangé — ouvrir
  la session sur CE repo, ajouter le moteur public (`add_repo MBeji/yahia-quest-arena`),
  éditer `content/`, laisser `content-ci` valider.
- **Gates en local / session** (deux clones côte à côte, `corpus/` et `engine/`) :
  `rm -rf engine/content && ln -s "$PWD/corpus/content" engine/content`, puis depuis
  `engine/` : `npm ci`, `npm run content:check`, `npm run content:qa:strict`,
  `npm run content:audit:strict`.
- ⚠️ **Transition (étude 24, lots 2 → 4)** : tant que le retrait du corpus public n'est pas
  fait, le contenu s'édite **encore dans le repo public** ; ce repo est un miroir. Après le
  lot 4, il devient l'unique source et cette note est supprimée.
```

### `.gitignore`

```gitignore
node_modules/
.env
.env.*
*.log
```

### `.github/workflows/content-ci.yml`

```yaml
name: Content CI

on:
  pull_request:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  gates:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - name: Checkout corpus (ce repo)
        uses: actions/checkout@v4
        with:
          path: corpus

      - name: Checkout moteur (repo public)
        uses: actions/checkout@v4
        with:
          repository: MBeji/yahia-quest-arena
          path: engine

      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: engine/package-lock.json

      - name: Installer les dépendances du moteur
        working-directory: engine
        run: npm ci

      - name: Brancher le corpus privé dans le moteur
        run: |
          rm -rf engine/content
          ln -s "$GITHUB_WORKSPACE/corpus/content" engine/content

      # Reste vert tant que le miroir privé == contenu public (règle de transition).
      # Remplacé au lot 3 par l'émission vers sql/content/ du privé.
      - name: content:check
        working-directory: engine
        run: npm run content:check

      - name: content:qa:strict
        working-directory: engine
        run: npm run content:qa:strict

      - name: content:audit:strict
        working-directory: engine
        run: npm run content:audit:strict
```

## Après ce bootstrap

Le lot 2 est clos. La suite est le **lot 3** (découplage SQL contenu + nettoyage de
l'historique de migrations — runbook §4.3 de l'étude, répétition sur TEST d'abord), puis
lots 4 (dégraissage du public + gate anti-fuite), 5 (purge d'historique — arbitré **oui**)
et 6 (e2e TEST + régularisation).

# PROMPT — Transcrire un document CNP manquant (couche de persistance du programme)

> **Pour qui ?** Un **collaborateur/contributeur équipé d'un agent IA** (Claude Code ou
> équivalent avec vision + accès fichiers + git) qui **ne connaît rien du projet**. Tu n'as
> rien d'autre à lire : copie le bloc « INPUT » ci-dessous, renseigne-le, colle-le avec tout
> le **PROMPT AGENT** dans ton agent, et laisse le workflow se dérouler. L'agent clone ce
> qu'il faut, transcrit, audite, et pousse une PR au bon endroit.
>
> **Ce que ça produit** : la transcription fidèle et enrichie d'un couple (niveau, matière)
> du programme officiel tunisien (corpus CNP) — le « contenu persistant » que toute la
> génération pédagogique consomme ensuite. Études liées :
> [12 — Studio d'ingestion](./12-studio-ingestion/ETUDE.md) (le canal) ·
> [13 — Moteur de transcription ScribeKit](./13-moteur-transcription/ETUDE.md) (le moteur, **livrée**).
> Pour contribuer du **code** (une étude), voir plutôt [`CONTRIBUER.md`](./CONTRIBUER.md).

---

## INPUT (l'unique chose à renseigner)

```
CIBLE    : <niveau> / <matière>     # ex. "3eme-base / eps" — un couple [ ] de programme/_INDEX.md
FICHIERS : <chemins locaux>         # OPTIONNEL — PDF déjà téléchargés (guide enseignant et/ou
                                    # manuel élève), séparés par des espaces. Vide = l'agent
                                    # télécharge depuis le site du CNP (www.cnp.com.tn).
PSEUDO   : <ton pseudo GitHub>      # pour la traçabilité (_INDEX.md + commit)
```

Un accès **collaborateur (write)** au dépôt `MBeji/yahia-quest-arena` est requis pour pousser
(demande-le à Mohamed) ; sans lui, l'agent terminera par un fork + PR classique.

---

## PROMPT AGENT (copier tout ce qui suit, avec l'INPUT rempli)

Tu es un agent chargé de **transcrire fidèlement** un document du programme scolaire officiel
tunisien (corpus CNP — Centre National Pédagogique) vers la **couche de persistance** du projet
`yahia-quest-arena`, puis de pousser le résultat en PR. Tu **transcris, tu ne génères jamais** :
tu n'inventes rien qui ne figure pas dans la source. Suis les étapes dans l'ordre, sans en
sauter. En cas de doute bloquant, applique la section STOP.

### Étape 0 — Mise en place

1. Clone le dépôt applicatif et place-toi sur une branche dédiée :

   ```bash
   git clone https://github.com/MBeji/yahia-quest-arena.git && cd yahia-quest-arena
   git checkout -b feat/transcription-<niveau>-<matiere>
   ```

   ⚠️ Ce dépôt **auto-merge** : pousser une branche ouvre une PR **prête, auto-merge armé**,
   qui se merge seule quand les checks CI sont verts. C'est voulu (les transcriptions sont
   mergées incrémentalement avec le statut « en validation »). Ne pousse donc qu'un travail fini.

2. Clone et build le moteur **ScribeKit** (déterministe, 0 LLM, 0 clé API) :

   ```bash
   git clone https://github.com/MBeji/ScribeKit.git ../ScribeKit
   (cd ../ScribeKit && npm install && npm run build)
   alias scribekit="node $(pwd)/../ScribeKit/dist/bin.js"
   ```

   Prérequis : Node 22 / npm 10.

3. Repère ton **espace de travail** dans le dépôt — tout vit sous :

   ```
   .claude/skills/content-ecole-tn/references/programmes-officiels/
   ├── programme/_INDEX.md          ← work-list (statuts [ ] / [~] / [x]) — TA feuille de route
   ├── programme/_TEMPLATE.md       ← gabarit de la fiche à produire
   ├── programme/README.md          ← spec de la couche (sources combinées, précédence)
   ├── programme/<niveau>/<matière>.md  ← LE livrable Markdown
   └── manifest/<niveau>.json       ← index machine-vérifiable (chapitrage) — livrable JSON
   ```

   Lis **en entier** : `programme/README.md`, `programme/_TEMPLATE.md`, et la section de
   `programme/_INDEX.md` de ta CIBLE. Lis aussi le skill d'orchestration
   `.claude/skills/content-ingest/SKILL.md` (règles R-1…R-7 — elles s'appliquent à toi).
   Un modèle de fiche aboutie : `programme/1ere-sec/mathematiques.md`.

### Étape 1 — Vérifier l'existant (règle R-4, NON NÉGOCIABLE)

Dans `programme/_INDEX.md`, trouve la ligne de ta CIBLE :

- `[x]` ou `[~]` → **STOP, le travail est déjà fait** (`[~]` = « transcrit, en validation »,
  ce n'est PAS un trou à combler). Signale-le au contributeur et termine sans rien pousser.
- `[ ]` → c'est un vrai manquant : continue. Note le **code guide** (6 chiffres) de la ligne.
- Si le fichier `programme/<niveau>/<matière>.md` existe déjà partiellement (fiche
  « first-pass ») : ton travail est de le **compléter**, jamais de le refaire en parallèle.

### Étape 2 — Obtenir les sources

Une transcription **combine les deux sources officielles** quand elles existent :
le **guide enseignant** (الدليل المرجعي / guide méthodologique) = le programme (compétences,
progression, bornes), et le **manuel élève** = le contenu réellement enseigné (leçons,
exemples, exercices). Une seule source disponible ⇒ elle fait référence.

- **Si `FICHIERS` est renseigné** : utilise ces PDF-là. Identifie qui est guide / qui est
  manuel (le code à 6 chiffres du nom de fichier : 1er chiffre `5` = guide enseignant du
  cycle de base, `1` = manuel élève base, `2` = secondaire ; chiffres 2-3 = matière ;
  chiffre 4 = classe).
- **Sinon, télécharge depuis le site du CNP** — motif d'URL :

  ```
  https://www.cnp.com.tn/arabic/PDF/<code>P00.pdf     # parfois P01/P02 (multi-tomes)
  ```

  avec `<code>` = le code guide relevé dans `_INDEX.md` ; cherche aussi le **manuel élève**
  correspondant (même matière × classe, 1er chiffre différent — ex. guide `502304` ↔ manuel
  `102304`). ⚠️ Le site CNP **bloque parfois les requêtes automatisées (403/WAF)** : si le
  téléchargement échoue, demande au contributeur de télécharger les PDF dans son navigateur
  et de te donner les chemins (c'est exactement le rôle du champ `FICHIERS`). **N'invente
  jamais un contenu faute de source.**

- **Droits (R-2)** : le corpus CNP officiel est la source prévue. Tout autre document sans
  autorisation claire ⇒ STOP.

### Étape 3 — PHASE 1 : transcription simple (ScribeKit + ta vision)

1. Lance ScribeKit — il extrait le déterministe, échafaude la fiche au gabarit `_TEMPLATE.md`
   et crée/met à jour le manifeste validé (Zod) :

   ```bash
   scribekit app-cnp <guide.pdf> [<manuel.pdf>] \
     --grade <niveau> --subject <subject-id> --lang <ar|fr|en> \
     -o .claude/skills/content-ecole-tn/references/programmes-officiels
   ```

   (`<subject-id>` : convention dans `programmes-officiels/README.md` § « Convention
   d'identifiants » — ex. `math-3eme`, `arabic-5eme` ; en cas de doute, laisse le champ
   « subject id attendu » de la fiche avec ta meilleure proposition et signale-le.)

2. `scribekit status <dossier programmes-officiels>` liste les unités `pending` (scans à
   couche-texte cassée — le cas général du corpus CNP). Pour chacune : **lis les pages
   toi-même en vision** (outil de lecture de PDF/images de ton agent) et **remplis la
   transcription fidèle** dans `programme/<niveau>/<matière>.md`.

   Règles de fidélité (absolues) :
   - Transcrire **ce qui est imprimé**, rien d'autre. Illisible ⇒ `[?]` + note en
     § « Incertitudes », **jamais** deviné. Coquille source ⇒ `[sic]`.
   - **Chiffres occidentaux (0-9) partout**, y compris dans le texte arabe ; équations LTR ;
     unités SI ; **jamais** de chiffres arabo-indiens (٠١٢٣). Markdown arabe bidi-safe.
   - **Citer les pages, par source** (guide vs manuel) — la fiche doit rester revérifiable.
   - Pas de transcription verbatim d'œuvres sous droits périphériques (chansons, textes
     littéraires longs) : résumer et citer la référence.
   - ⚠️ **Pas de clé API** : l'OCR passe par TA vision d'agent (le `--provider anthropic` de
     ScribeKit est réservé au batch facturé — ne l'utilise que si le contributeur fournit
     explicitement une clé).

3. **Lecture intégrale obligatoire (R-6)** : une session = UNE matière, et tu lis les sources
   **en entier** avant de considérer la phase 1 finie. Si ton budget de contexte ne suffit
   pas, arrête-toi **proprement** à la fin de la dernière section traitée et étiquette
   honnêtement la profondeur atteinte dans la fiche (ex. « modules 1-4 en profondeur, 5-7 en
   first-pass ») — un travail partiel honnête vaut mieux qu'un travail complet bâclé.

### Étape 4 — PHASE 2 : enrichissement (profondeur de génération, R-5)

Une fiche « résumé » ne sert à rien : la cible est la **profondeur de génération** —
le standard qui permet de générer ensuite cours et exercices sans jamais rouvrir les scans.
Complète les sections §1–§6 du gabarit en **combinant guide + manuel** :

- **Chaque activité / exercice du manuel décrit individuellement** : énoncé, données, ce qui
  est demandé (pas « des exercices d'application p.12-15 »).
- **Encadrés de règles/lois officiels reproduits verbatim** (« Retenir », « Repère »,
  l'essentiel du cours…).
- **Vocabulaire et terminologie officielle** relevés tels quels.
- **Bornes de scope** explicites : ✅ INCLUS au niveau / ⛔ EXCLU (relève d'un autre niveau).
- **§4 Chapitrage** rempli (slug, notion, pages du manuel élève par chapitre), puis
  **codifié dans `manifest/<niveau>.json`** (le champ `manuel = { code, pages }` par
  chapitre ; garde le JSON valide — il est validé par le schéma Zod de l'app).
- Divergence guide ↔ manuel : le **guide enseignant fait foi** pour le scope ; signale
  l'écart avec la page (§5).

### Étape 5 — Audit & checks (rien ne part sans ça)

1. **QA ScribeKit** (schéma manifeste, notation, non-vides) — 0 erreur exigé :

   ```bash
   scribekit qa .claude/skills/content-ecole-tn/references/programmes-officiels
   scribekit status .claude/skills/content-ecole-tn/references/programmes-officiels  # plus aucun pending non traité
   ```

2. **Relecture indépendante (R-7)** : lance un **second agent/sous-agent au contexte vierge**
   qui re-vérifie la fiche **contre les PDF sources** (pas contre ton travail) : pages citées
   exactes, rien d'inventé, encadrés verbatim conformes, notation 0-9/LTR. Corrige ce qu'il
   trouve et consigne le verdict dans la fiche (§ Incertitudes) et dans `_INDEX.md`
   (ex. « R-7 vérifiée AAAA-MM-JJ, fidèle, N corrections »).
3. **Gate du dépôt** : `npm install` puis `npm run verify` à la racine (lint + typecheck +
   tests — tourne sans backend). Tes fichiers Markdown/JSON seront formatés par le hook
   pre-commit (Prettier) : laisse-le faire, ne le contourne jamais (`--no-verify` interdit).
4. **Mets à jour `programme/_INDEX.md`** : passe ta ligne à `[~]` (« transcrit, en
   validation » — **jamais `[x]`**, la promotion finale appartient à l'humain), ajoute
   date + PSEUDO + profondeur atteinte, et ajuste la ligne de totaux en bas de section.

### Étape 6 — Push & PR (les livrables, au bon endroit)

À committer — et **rien d'autre** :

| livrable                                       | format   | emplacement                                                                                       |
| ---------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------- |
| la fiche de transcription enrichie             | Markdown | `.claude/skills/content-ecole-tn/references/programmes-officiels/programme/<niveau>/<matière>.md` |
| le chapitrage machine-vérifiable (mis à jour)  | JSON     | `.claude/skills/content-ecole-tn/references/programmes-officiels/manifest/<niveau>.json`          |
| la work-list mise à jour (`[~]`)               | Markdown | `.claude/skills/content-ecole-tn/references/programmes-officiels/programme/_INDEX.md`             |
| sorties génériques éventuelles (profil `yaml`) | YAML     | uniquement si demandé par le contributeur, même dossier `programme/<niveau>/`                     |

⛔ Ne committe **pas** les artefacts de session ScribeKit (`.scribekit/ledger.json`,
`AVANCEMENT.md`), ni les PDF sources, ni quoi que ce soit sous `content/` ou
`supabase/migrations/` (la **génération** de contenu est un autre workflow — étude 12 — qui
consommera ta fiche plus tard). Aucune écriture en base, jamais (R-1).

```bash
git add .claude/skills/content-ecole-tn/references/programmes-officiels/
git commit -m "feat(programme): transcription <matière> <niveau> — CNP <codes sources> (FableEtudes/12#persistance)"
git push -u origin feat/transcription-<niveau>-<matiere>
```

Le push **ouvre la PR automatiquement, auto-merge armé** : surveille les checks
(`gh pr checks <n> --watch` ou l'onglet Checks), corrige tout rouge et re-pousse, et
confirme que le merge a réellement eu lieu avant de terminer. Si tu veux un point de
sauvegarde non mergeable, préfixe la branche `wip/` (la PR s'ouvre alors en draft).
Termine en rapportant au contributeur : couple traité, profondeur atteinte, verdict R-7,
lien de la PR, et toute incertitude laissée en §6 de la fiche.

### STOP (escalade — ne jamais improviser)

- CIBLE déjà `[~]`/`[x]` dans `_INDEX.md` → STOP (étape 1).
- Source introuvable / téléchargement CNP bloqué et pas de `FICHIERS` → STOP, demande les PDF.
- Doute sur les **droits** d'une source hors corpus CNP → STOP.
- Scan **illisible** ou manuscrit → transcris ce qui est lisible, signale le reste, ne devine pas.
- Divergence fiche ↔ programme officiel, ou gabarit/manifeste qui ne colle pas au réel →
  STOP et documente (commentaire de PR ou issue GitHub), n'adapte jamais en silence.
- Budget de contexte insuffisant → arrêt propre + étiquetage honnête (étape 3.3), jamais de bâclage.

---

_Ce prompt applique les règles du skill `content-ingest` (R-1…R-7) et des études 12/13 ;
en cas de désaccord avec `CLAUDE.md` (racine du dépôt), CLAUDE.md gagne._

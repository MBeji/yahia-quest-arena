# PROMPT — Campagne CNP : transcrire les documents manquants **en boucle** et générer le contenu

> **Pour qui ?** Un **collaborateur/contributeur équipé d'un agent IA** (Claude Code ou
> équivalent avec vision + accès fichiers + git) qui **ne connaît rien du projet**. Tu n'as
> rien d'autre à lire : copie le bloc « INPUT » ci-dessous, renseigne-le, colle-le avec tout
> le **PROMPT AGENT** dans ton agent, et laisse la campagne se dérouler. L'agent **boucle** —
> classe par classe, matière par matière, chapitre par chapitre — et pousse **une PR par lot**
> (une matière complète = un lot), jusqu'à épuisement du périmètre demandé.
>
> **Ce que ça produit**, pour chaque couple (niveau, matière) encore manquant :
>
> 1. **Phase 1 — transcription fidèle** (moteur ScribeKit + vision de l'agent) ;
> 2. **Phase 2 — enrichissement** de la fiche à « profondeur de génération » ;
> 3. **Phase 3 — génération du contenu pédagogique** (cours, quiz, missions) **via les skills
>    déjà développés dans le projet** (`content-ecole-tn`, `content-cours`,
>    `content-interactif`, `prof-*`), chapitre par chapitre, avec les gates et audits du dépôt.
>
> Études liées : [12 — Studio d'ingestion](./12-studio-ingestion/ETUDE.md) (le canal) ·
> [13 — Moteur de transcription ScribeKit](./13-moteur-transcription/ETUDE.md) (le moteur, **livrée**).
> Pour contribuer du **code** (une étude), voir plutôt [`CONTRIBUER.md`](./CONTRIBUER.md).

---

## INPUT (l'unique chose à renseigner)

```
PORTEE     : tout                 # défaut — boucle sur TOUS les couples [ ] de programme/_INDEX.md,
                                  # classe par classe (1ere-base → bac) puis matière par matière.
                                  # Restreindre : "3eme-base" (une classe entière) ou
                                  # "3eme-base / eps" (un seul couple).
FICHIERS   : <chemins locaux>     # OPTIONNEL — PDF déjà téléchargés (guide enseignant et/ou manuel
                                  # élève), séparés par des espaces. Vide = l'agent télécharge
                                  # depuis le site du CNP (www.cnp.com.tn), couple par couple.
GENERATION : oui                  # oui (défaut) = après chaque fiche mergée, générer le contenu du
                                  # sujet chapitre par chapitre via les skills du projet ;
                                  # non = s'arrêter à la couche de persistance (fiches seulement).
PSEUDO     : <ton pseudo GitHub>  # pour la traçabilité (_INDEX.md + commits)
```

Un accès **collaborateur (write)** au dépôt `MBeji/yahia-quest-arena` est requis pour pousser
(demande-le à Mohamed) ; sans lui, l'agent terminera chaque lot par un fork + PR classique.

---

## PROMPT AGENT (copier tout ce qui suit, avec l'INPUT rempli)

Tu es un agent chargé de mener une **campagne** sur le programme scolaire officiel tunisien
(corpus CNP — Centre National Pédagogique) pour le projet `yahia-quest-arena` : **transcrire
fidèlement** chaque document manquant (phases 1-2), puis **générer le contenu pédagogique**
correspondant **avec les skills du projet** (phase 3). En transcription tu **n'inventes
jamais** rien qui ne figure pas dans la source ; en génération tu **suis les skills du dépôt**,
jamais ta propre recette. Suis les étapes dans l'ordre, sans en sauter. En cas de doute
bloquant, applique la section STOP.

### La boucle de campagne (vue d'ensemble)

```
pour chaque CLASSE de programme/_INDEX.md (ordre du fichier), dans PORTEE :
  pour chaque MATIÈRE de la classe encore cochée [ ] :
    LOT A — fiche (étapes 1→6) : phase 1 transcription + phase 2 enrichissement
            + audits → 1 commit → 1 push → 1 PR (auto-merge) → attendre le merge
    si GENERATION = oui :
      LOT B — contenu (étape 7) : génération chapitre par chapitre via les skills
            + gates + migration → 1 commit → 1 push → 1 PR → attendre le merge
    repartir de main (branche fraîche) → matière suivante
fin quand la PORTEE est épuisée (ou arrêt propre si le budget ne suffit plus)
```

Règles de la boucle (non négociables) :

- **Un lot = une PR = UNE matière.** Jamais deux matières dans une PR ; jamais un push
  groupé « 10 fiches d'un coup » (c'est le signe qu'on va trop vite — règle R-6).
- **Une matière = un contexte frais.** Si ton harnais le permet (ex. sous-agents/Task de
  Claude Code), **délègue chaque lot à un sous-agent au contexte vierge** et garde le rôle
  d'orchestrateur ; sinon, traite les matières strictement en séquence et, quand ton budget
  de contexte baisse, **arrête-toi proprement** en fin de lot — la campagne est
  **résumable** : relancer ce même prompt reprend exactement où `_INDEX.md` en est.
- **Resynchronise à chaque itération** : avant chaque nouveau lot,
  `git fetch origin main && git checkout -B <branche-du-lot> origin/main`, puis **relis
  `programme/_INDEX.md` depuis main** — un autre contributeur a pu avancer pendant ton lot.
- **Attends le merge réel** d'un lot avant d'entamer le suivant (le lot B dépend de la
  fiche mergée ; deux PR simultanées sur `_INDEX.md` se marchent dessus).

### Étape 0 — Mise en place (une fois par campagne)

1. Clone le dépôt applicatif et installe :

   ```bash
   git clone https://github.com/MBeji/yahia-quest-arena.git && cd yahia-quest-arena
   npm install    # installe aussi les hooks git (Prettier/ESLint au commit, verify au push)
   ```

   ⚠️ Ce dépôt **auto-merge** : pousser une branche ouvre une PR **prête, auto-merge armé**,
   qui se merge seule quand les checks CI sont verts. C'est voulu. Ne pousse donc qu'un
   lot fini.

2. Clone et build le moteur **ScribeKit** (déterministe, 0 LLM, 0 clé API) :

   ```bash
   git clone https://github.com/MBeji/ScribeKit.git ../ScribeKit
   (cd ../ScribeKit && npm install && npm run build)
   alias scribekit="node $(pwd)/../ScribeKit/dist/bin.js"
   ```

   Prérequis : Node 22 / npm 10.

3. Repère l'**espace de travail des fiches** dans le dépôt — tout vit sous :

   ```
   .claude/skills/content-ecole-tn/references/programmes-officiels/
   ├── programme/_INDEX.md          ← work-list (statuts [ ] / [~] / [x]) — TA feuille de route
   ├── programme/_TEMPLATE.md       ← gabarit de la fiche à produire
   ├── programme/README.md          ← spec de la couche + « Recette » de génération (phase 3)
   ├── programme/<niveau>/<matière>.md  ← livrable Markdown du lot A
   └── manifest/<niveau>.json       ← index machine-vérifiable (chapitrage) — livrable JSON
   ```

   Lis **en entier** : `programme/README.md`, `programme/_TEMPLATE.md`, et
   `.claude/skills/content-ingest/SKILL.md` (règles R-1…R-7 — elles s'appliquent à toi).
   Un modèle de fiche aboutie : `programme/1ere-sec/mathematiques.md`.

4. Construis ta **file de travail** : parcours `programme/_INDEX.md` dans l'ordre du fichier
   et retiens tous les couples `[ ]` inclus dans `PORTEE`. Annonce la file au contributeur
   (nombre de lots, ordre), puis démarre la boucle.

---

Les étapes 1 → 6 ci-dessous constituent le **LOT A** et se répètent pour **chaque couple**
(niveau, matière) de la file. L'étape 7 est le **LOT B** (si `GENERATION = oui`).

### Étape 1 — Vérifier l'existant (règle R-4, NON NÉGOCIABLE)

Branche fraîche : `git fetch origin main && git checkout -B feat/transcription-<niveau>-<matiere> origin/main`.
Puis, dans `programme/_INDEX.md` (version fraîche de main), trouve la ligne du couple courant :

- `[x]` ou `[~]` → **le travail est déjà fait** (`[~]` = « transcrit, en validation », ce
  n'est PAS un trou à combler). Si `GENERATION = oui` et que le contenu du sujet n'existe pas
  encore sous `content/` (vérifie `content/CATALOGUE.md`), passe directement au LOT B ;
  sinon **saute au couple suivant** de la file.
- `[ ]` → vrai manquant : continue. Note le **code guide** (6 chiffres) de la ligne.
- Si `programme/<niveau>/<matière>.md` existe déjà partiellement (fiche « first-pass ») :
  ton travail est de le **compléter**, jamais de le refaire en parallèle.

### Étape 2 — Obtenir les sources

Une transcription **combine les deux sources officielles** quand elles existent :
le **guide enseignant** (الدليل المرجعي / guide méthodologique) = le programme (compétences,
progression, bornes), et le **manuel élève** = le contenu réellement enseigné (leçons,
exemples, exercices). Une seule source disponible ⇒ elle fait référence.

- **Si `FICHIERS` est renseigné** : utilise les PDF du couple courant. Identifie qui est
  guide / qui est manuel (le code à 6 chiffres du nom de fichier : 1er chiffre `5` = guide
  enseignant du cycle de base, `1` = manuel élève base, `2` = secondaire ; chiffres 2-3 =
  matière ; chiffre 4 = classe).
- **Sinon, télécharge depuis le site du CNP** — motif d'URL :

  ```
  https://www.cnp.com.tn/arabic/PDF/<code>P00.pdf     # parfois P01/P02 (multi-tomes)
  ```

  avec `<code>` = le code guide relevé dans `_INDEX.md` ; cherche aussi le **manuel élève**
  correspondant (même matière × classe, 1er chiffre différent — ex. guide `502304` ↔ manuel
  `102304`). ⚠️ Le site CNP **bloque parfois les requêtes automatisées (403/WAF)** : si le
  téléchargement échoue, demande au contributeur de télécharger les PDF dans son navigateur
  et de te donner les chemins (c'est exactement le rôle du champ `FICHIERS`), et continue la
  campagne avec les couples suivants en attendant. **N'invente jamais un contenu faute de
  source.**

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

3. **Lecture intégrale obligatoire (R-6)** : un lot = UNE matière, et tu lis les sources
   **en entier** avant de considérer la phase 1 finie. Si ton budget de contexte ne suffit
   pas, arrête-toi **proprement** à la fin de la dernière section traitée et étiquette
   honnêtement la profondeur atteinte dans la fiche (ex. « modules 1-4 en profondeur, 5-7 en
   first-pass ») — un travail partiel honnête vaut mieux qu'un travail complet bâclé. C'est
   précisément pour ça que la boucle traite les matières **une à une** et jamais en batch.

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
  chapitre ; garde le JSON valide — il est validé par le schéma Zod de l'app). Ce chapitrage
  est **l'ossature de la boucle « chapitre par chapitre » de la phase 3**.
- Divergence guide ↔ manuel : le **guide enseignant fait foi** pour le scope ; signale
  l'écart avec la page (§5).

### Étape 5 — Audit & checks du lot A (rien ne part sans ça)

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
3. **Gate du dépôt** : `npm run verify` à la racine (lint + typecheck + tests — tourne sans
   backend). Tes fichiers Markdown/JSON seront formatés par le hook pre-commit (Prettier) :
   laisse-le faire, ne le contourne jamais (`--no-verify` interdit).
4. **Mets à jour `programme/_INDEX.md`** : passe la ligne du couple à `[~]` (« transcrit, en
   validation » — **jamais `[x]`**, la promotion finale appartient à l'humain), ajoute
   date + PSEUDO + profondeur atteinte, et ajuste la ligne de totaux en bas de section.

### Étape 6 — Push du lot A (les livrables, au bon endroit)

À committer — et **rien d'autre** dans ce lot :

| livrable                                       | format   | emplacement                                                                                       |
| ---------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------- |
| la fiche de transcription enrichie             | Markdown | `.claude/skills/content-ecole-tn/references/programmes-officiels/programme/<niveau>/<matière>.md` |
| le chapitrage machine-vérifiable (mis à jour)  | JSON     | `.claude/skills/content-ecole-tn/references/programmes-officiels/manifest/<niveau>.json`          |
| la work-list mise à jour (`[~]`)               | Markdown | `.claude/skills/content-ecole-tn/references/programmes-officiels/programme/_INDEX.md`             |
| sorties génériques éventuelles (profil `yaml`) | YAML     | uniquement si demandé par le contributeur, même dossier `programme/<niveau>/`                     |

⛔ Ne committe **pas** les artefacts de session ScribeKit (`.scribekit/ledger.json`,
`AVANCEMENT.md`), ni les PDF sources, ni — **dans ce lot** — quoi que ce soit sous `content/`
ou `supabase/migrations/` (ça, c'est le lot B). Aucune écriture en base, jamais (R-1).

```bash
git add .claude/skills/content-ecole-tn/references/programmes-officiels/
git commit -m "feat(programme): transcription <matière> <niveau> — CNP <codes sources> (FableEtudes/12#persistance)"
git push -u origin feat/transcription-<niveau>-<matiere>
```

Le push **ouvre la PR automatiquement, auto-merge armé** : surveille les checks
(`gh pr checks <n> --watch` ou l'onglet Checks), corrige tout rouge et re-pousse, et
**confirme que le merge a réellement eu lieu** avant de passer au lot B (ou au couple
suivant). Point de sauvegarde non mergeable : préfixe la branche `wip/` (PR en draft).

### Étape 7 — LOT B / PHASE 3 : génération du contenu **avec les skills du projet**

> Seulement si `GENERATION = oui`, et seulement quand la fiche du couple est **mergée sur
> `main`**. Ici tu changes de casquette : tu ne transcris plus, tu **génères** — et pour ça
> tu **exécutes les skills du dépôt**, qui font foi. Ne réinvente aucune règle.

1. **Branche fraîche** : `git fetch origin main && git checkout -B feat/content-<subject-id> origin/main`.
2. **Lis et suis la recette officielle** :
   `programmes-officiels/README.md` § « 🛠️ Recette de création / réalignement de contenu » —
   c'est la procédure normative de cette étape. Sa règle d'or : la source de scope et de
   contenu est **la fiche `programme/<niveau>/<matière>.md`** (celle que tu viens de merger) —
   **ne rouvre jamais les PDF** en phase de génération.
3. **Charge les skills de génération** (dossiers `.claude/skills/` du dépôt — si ton agent
   est Claude Code ils s'invoquent nativement, sinon lis chaque `SKILL.md` + ses
   `references/` et applique-les à la lettre) :
   - la **carte de sélection** : `content-engine/references/generation-pipeline.md`
     (quel skill pour quelle tâche — commence par elle) ;
   - `content-engine` (le cœur commun : schéma, barre de qualité, récompenses, style RPG,
     notation) + `content-ecole-tn` (fidélité au programme officiel — le wrapper de TOUT
     contenu scolaire) ;
   - `content-cours` pour `cours.md` / `resume.md` ;
   - `content-interactif` pour varier les formats de missions ;
   - l'overlay **`prof-<matière>-<cycle>`** s'il existe pour ton couple (exercices durs
     d3-d4) — vérifie la liste sous `.claude/skills/`.
4. **Génère chapitre par chapitre**, dans l'ordre du chapitrage (§4 de la fiche /
   `manifest/<niveau>.json`) : pour chaque chapitre, `chapter.json`, `cours.md`, `resume.md`,
   `quiz.json`, `exercices/*.json` (ladder standard — voir les skills). Si le sujet n'existe
   pas encore sous `content/`, crée `subject.json` selon la convention d'identifiants
   (vérifie les slugs pris dans `content/CATALOGUE.md`). Termine **toute la matière** avant
   de pousser — le lot B = la matière complète, pas un chapitre isolé.
5. **Gates & audits de contenu** (0 erreur exigé partout) :

   ```bash
   npm run content:check          # validation Zod de tout le contenu
   npm run content:qa:strict      # QA stricte (échoue sur toute [error])
   npm run content:audit          # conformité au programme + couverture vs manifeste
   ```

   Puis **audit pédagogique** : applique le skill `content-audit` sur le sujet généré
   (re-résoudre chaque question à l'aveugle, clés/distracteurs/calibrage) et corrige avant
   de pousser.

6. **Migration SQL** (indispensable — sans elle le contenu n'atteint jamais la base) :

   ```bash
   npm run content:build -- --subject <subject-id>
   ```

   ⚠️ **JAMAIS `npm run content:build` sans `--subject`** (il régénérerait ~60 sujets — des
   migrations parasites à ne pas committer). Garde l'horodatage neuf proposé ; ne réutilise
   jamais l'horodatage d'une migration existante.

7. **Gate finale + push du lot B** : `npm run verify`, puis un commit unique
   (`content/<subject-id>/**` **+ la migration générée**, rien d'autre) :

   ```bash
   git add content/<subject-id> supabase/migrations/<ts>_generated_<subject-id>_content.sql
   git commit -m "feat(content): <subject-id> <niveau> — génération depuis la fiche CNP (FableEtudes/12#generation)"
   git push -u origin feat/content-<subject-id>
   ```

   La PR s'ouvre et s'auto-merge comme au lot A ; **au merge, la migration s'applique en
   prod automatiquement** (ne l'applique jamais à la main). Confirme le merge, vérifie dans
   l'onglet Actions que le run `db-migrate-prod` affiche bien
   `Applying migration <ts>_generated_<subject-id>…`, puis **reprends la boucle** au couple
   suivant.

### Fin de campagne — rapport

Quand la file est épuisée (ou à l'arrêt propre), rapporte au contributeur : couples traités
(avec lien de chaque PR lot A / lot B), profondeur atteinte et verdict R-7 par fiche,
couples sautés et pourquoi (déjà `[~]`, source indisponible…), et ce qui reste dans
`_INDEX.md` pour la prochaine campagne.

### STOP (escalade — ne jamais improviser)

- Couple déjà `[~]`/`[x]` dans `_INDEX.md` → on ne re-transcrit pas (étape 1) ; on saute
  (ou lot B seul si le contenu manque).
- Source introuvable / téléchargement CNP bloqué et pas de `FICHIERS` → demande les PDF au
  contributeur et **continue la campagne** avec les couples suivants.
- Doute sur les **droits** d'une source hors corpus CNP → STOP.
- Scan **illisible** ou manuscrit → transcris ce qui est lisible, signale le reste, ne devine pas.
- Divergence fiche ↔ programme officiel, ou gabarit/manifeste qui ne colle pas au réel →
  STOP et documente (commentaire de PR ou issue GitHub), n'adapte jamais en silence.
- Phase 3 sans fiche mergée, ou fiche restée « first-pass » (pas la profondeur R-5) → **ne
  génère pas** depuis une fiche pauvre ; re-passe par les phases 1-2.
- Un chapitre appelle un **format de contenu inexistant** dans le moteur → signalement
  (issue) vers l'étude 03 / le catalogue de formats, jamais un format ad hoc.
- Budget de contexte insuffisant → arrêt propre **en fin de lot** + étiquetage honnête
  (étape 3.3) ; la campagne reprendra là où `_INDEX.md` en est. Jamais de bâclage.

---

_Ce prompt applique les règles du skill `content-ingest` (R-1…R-7), la « Recette » de
`programmes-officiels/README.md` et les études 12/13 ; en cas de désaccord avec `CLAUDE.md`
(racine du dépôt), CLAUDE.md gagne._

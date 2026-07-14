---
name: content-ingest
description: >-
  Ingest an arbitrary SOURCE document (teacher PDF, polycopié, paper annales, a CNP
  manual/guide, a Word file, a scan) into the content pipeline — WITHOUT leaving the
  gated flow — via the ScribeKit transcription engine plus agent vision OCR. Use
  whenever the user wants to « ingérer un PDF / document source », « transcrire un
  manuel / polycopié / annale et en faire du contenu », « importer une source
  externe / digitaliser un cours ou des exercices depuis un scan », or to run the
  source→content path for the CNP corpus. Orchestrates three layers: ScribeKit
  (deterministic extraction + scaffold + validated manifest + resumable tracking,
  0 LLM / 0 API key) → the AGENT reads & transcribes the scanned pages faithfully
  with the Codex subscription (NO API key) → confront the official CNP program →
  hand off to the generation skills. It TRANSCRIBES, it never GENERATES; output is
  always versioned content/ (or programme/…) files on a branch + gates + human
  review, never a direct DB write. Defers to content-engine (schema / quality bar /
  rewards / style / notation) and content-ecole-tn (program fidelity). Studies:
  FableEtudes/12-studio-ingestion (the channel) + FableEtudes/13 (the ScribeKit engine).
---

# content-ingest — ingestion source → contenu (ScribeKit + vision agent)

**Rôle.** Amener un **document source arbitraire** jusqu'au **pipeline de contenu**, **entièrement à
l'intérieur du flux à gates**. Tu **transcris fidèlement, tu ne génères jamais** ; la génération
pédagogique reste chez les skills existants. Même famille que `curriculum-architect` : tu produis la
**transcription/fiche** + tu **orchestres**, tu ne dupliques pas le cœur de génération.

Docs : [`FableEtudes/12-studio-ingestion`](../../../FableEtudes/12-studio-ingestion/ETUDE.md) (le canal) +
[`FableEtudes/13-moteur-transcription`](../../../FableEtudes/13-moteur-transcription/ETUDE.md) (le moteur
**ScribeKit**, repo `YahiaAcademy/ScribeKit`). Défère à `content-engine` (schéma, barre qualité,
récompenses, style, notation) et à `content-ecole-tn` (fidélité au programme officiel + recette).

## Le partage en 3 couches

1. **Déterministe — ScribeKit (0 LLM, 0 clé)** : extraction des PDF à couche-texte / Word / texte, parcours
   de corpus, **échafaudage** au format app, **manifeste validé** (Zod `program-manifest.ts`), **ledger +
   `AVANCEMENT.md` résumables**, QA. `scribekit` = `node YahiaAcademy/ScribeKit/dist/bin.js` (ou `npm link`).
2. **OCR des scans — l'AGENT (vision d'abonnement, 0 clé)** : pour chaque unité `pending` (couche-texte
   cassée), **toi l'agent** lis les pages (outil **Read** = vision, ou `render.sh`→PNG→Read pour le DPI) et
   **transcris fidèlement** (chiffres 0-9, LTR, jamais d'arabo-indiens ; **signale l'illisible, n'invente
   rien**). ⚠️ **Pas de clé API** : l'API Anthropic est facturée au token et **n'utilise pas l'abonnement**
   — l'OCR passe par TA vision d'agent. Le `--provider anthropic` de ScribeKit existe pour du batch
   non-supervisé mais **exige une clé facturée** : ne l'emploie **que** si l'utilisateur en fournit une et
   le demande explicitement.
3. **Génération — skills existants** : transcription fidèle + fiche prêtes ⇒ hand-off à
   `content-ecole-tn`/wrappers + `content-cours` + `content-interactif` + `prof-*`. Tu ne génères pas
   toi-même.

## Règles (non négociables)

- **R-1 — Rien ne contourne le pipeline.** Sortie = TOUJOURS des fichiers `content/` (ou une transcription
  `programme/…`) sur une branche + gates (`content:check` / `content:qa:strict` / `content:audit`) + revue
  humaine. **Aucune écriture DB**, aucun skip d'audit.
- **R-2 — Provenance & droits.** Chaque source porte auteur / origine / autorisation ; un document sous
  droits sans autorisation est **refusé**. Les `chapter.sources[]` citent le document. Doute ⇒ **STOP**.
- **R-3 — Programme d'abord.** Pour une matière scolaire, confronter la fiche à la **transcription CNP**
  (`programme/<grade>/<matière>.md`) si elle existe ; divergence de scope ⇒ le **programme officiel gagne**,
  signaler l'écart (règle `content-ecole-tn`).
- **R-4 — Vérifie l'existant AVANT toute campagne.** Avant de transcrire quoi que ce soit, lis
  `programme/_INDEX.md` **et** le fichier `programme/<grade>/<matière>.md` s'il existe déjà. Un statut
  `[~]` = **« transcrit, en validation » — déjà fait**, pas un trou à combler. Un incident réel (2026-07-12,
  campagne ScribeKit collège) a produit des fiches redondantes pour 6→9ème FR/EN/AR alors que des fiches
  pré-existantes, plus profondes, couvraient déjà ces matières — seules 1ère-sec FR/EN/chimie étaient de
  vrais trous. En cas de doublon, ne promeus jamais automatiquement le nouveau lot : compare et garde la
  meilleure copie (qualité + complétude), documente la décision dans `_INDEX.md`.
- **R-5 — Standard de fiche : « profondeur de génération », jamais un résumé.** Une fiche destinée à
  alimenter la génération pédagogique doit décrire **chaque activité/exercice individuellement** (énoncé,
  données, ce qui est demandé), reproduire **verbatim** les encadrés de règles/lois officielles, relever le
  vocabulaire officiel, et poser des bornes de scope INCLUS/EXCLU — modèle de référence :
  `programme/1ere-sec/mathematiques.md`. Une fiche « first-pass » (structure + objectifs seulement, sans ce
  niveau de détail) doit être étiquetée comme telle et **jamais confondue avec une fiche prête pour la
  génération** — l'écart de qualité entre les deux est la cause directe d'un contenu généré médiocre.
- **R-6 — Une session = une matière, lecture intégrale obligatoire.** Ne jamais plafonner arbitrairement
  la lecture d'une source (l'incident du 2026-07-10 a lu 15-76 % des sources avant d'écrire, plafonné à
  70 000 caractères par manuel, produisant une fiche truffée d'inventions). Traiter plusieurs matières dans
  la même fenêtre de contexte dilue le budget de lecture par matière et bâcle chaque fiche — un lot batch
  de 10 fiches en une nuit est le signe qu'on va trop vite. Une matière incomplète mais honnêtement étiquetée
  (« profondeur : modules 1-4 faits, 5-7 en first-pass ») vaut mieux qu'un lot complet mais bâclé.
- **R-7 — Vérification indépendante avant promotion.** Une fiche produite par une session/agent ne devient
  la référence canonique (`programme/<grade>/<matière>.md`, cochée dans `_INDEX.md`) qu'après relecture par
  un second agent qui re-vérifie contre la source elle-même (pas contre la fiche) — pas seulement contre son
  propre travail.
- **Fidélité, pas de génération.** ScribeKit et l'OCR agent **transcrivent** ; difficulté / calibrage / QCM
  / cours = **génération** (couche 3), jamais ici.

## Workflow

0. **Cadrage.** Quel document ? Cible (thème / grade / matière) ? Droits (R-2) ? Localiser les PDF sources.
1. **ScribeKit — déterministe + échafaudage.**
   - **Scolaire (CNP)** : `scribekit app-cnp <guide.pdf> <manuel.pdf> --grade <gradeSlug> --subject <id>
--lang <ar|fr|en> [--manuel <code> --pages <plages>] -o <programmes-officiels>` → `programme/<g>/<matière>.md`
     (échafaudage `_TEMPLATE.md` + transcription brute des sources à couche-texte en annexe) + `manifest/<g>.json`
     validé.
   - **Source libre / non scolaire** : `scribekit transcribe <inputs…> -o content/_sources/<theme>/<slug>/
--profile markdown` → transcription fidèle (MD/JSON), résumable.
2. **OCR agent des `pending`.** `scribekit status <cible>` liste les scans `pending`. Pour chacun : **lire en
   vision (abonnement)** et **remplir la transcription fidèle** dans le fichier cible. Rien d'inventé.
3. **Fiche + confrontation CNP (R-3).** Compléter la fiche/transcription (périmètre, notions, exemples,
   exercices du document, bornes) ; pour le scolaire, confronter au `programme/<grade>/<matière>.md`.
4. **QA transcription.** `scribekit qa <cible>` (schéma manifeste, notation, non-vides) — **0 erreur** avant
   le hand-off. `scribekit status <cible>` doit ne plus lister de `pending` non traité.
5. **Hand-off génération.** Invoquer les skills de génération pour produire `cours.md` / `resume.md` /
   `quiz.json` / `exercices/*` à partir de la transcription, puis suivre la recette `content-ecole-tn`
   (`content:check` + `content:qa:strict` + `content:audit` → build de migration `--subject <id>` → PR → revue
   → auto-apply prod au merge).

## STOP (escalade — ne re-designe jamais en silence)

- Doute sur les **droits** d'une source ⇒ STOP (R-2).
- Scan **illisible** / manuscrit ⇒ signaler, **ne pas deviner** (fidélité).
- Divergence transcription ↔ programme officiel ⇒ le **programme gagne**, signaler (R-3).
- Tentation d'utiliser une **clé API** alors que l'abonnement suffit ⇒ ne pas le faire ; rester
  **agent-in-the-loop**.
- Besoin d'un **format de contenu inexistant** ⇒ signalement vers l'étude 03 / le catalogue, jamais un
  format ad hoc.
- Budget de lecture/contexte insuffisant pour finir une matière en profondeur ⇒ **STOP proprement** à la
  fin de la dernière section traitée, étiquette clairement ce qui reste en first-pass (R-6) ; ne bâcle
  jamais le reste pour "finir".

Défère toujours à **AGENTS.md** / **ARCHITECTURE.md** et aux `docs/*.md` normatifs.

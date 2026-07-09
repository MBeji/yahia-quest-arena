# Étude 13 — Moteur de transcription **fidèle** (corpus → format app), OCR compris — « ScribeKit »

> **Statut** : **livrée** (validée le 2026-07-09 ; **tous les lots 0–6 livrés**, 6 PRs mergées, CI verte)
> **Priorité** : 13 · **Valeur** : transcrire **fidèlement** un corpus source (arborescence de PDF texte **et scannés**, images, Word) vers le **format de sortie exigé par l'app** (Markdown / JSON / YAML), de façon **résumable et traçable**, **agnostique du LLM**. OCR **compris** (par LLM vision), **sans jamais générer de contenu** (pas de QCM, rien de subjectif). Remplace le flux manuel `render.sh` + rédaction/lecture-vision à la main · **Complexité** : haute (multi-format + abstraction LLM vision + orchestration corpus + traçabilité + QA)
> **Architecte** : Opus (claude-opus-4-8), 2026-07-09 (réécrite après clarifications : **fidélité, pas déterminisme** ; l'OCR/vision LLM **reste dans le module**, seule la **génération** est exclue) · **Exécuteur cible** : Sonnet (ou équiv.)
> **Dépend de** : rien de bloquant. **Tranchées** : repo GitHub dédié **ScribeKit** (Q-1) ; OCR = vision **Claude Sonnet** (`claude-sonnet-5`) par défaut + tesseract offline optionnel (Q-3) ; schéma partagé = **copie vendorée + test anti-dérive** (Q-2, option A). **Aucune question ouverte bloquante** · **Bloque** : rien
> **Docs normatifs liés** : CLAUDE.md (« content pipeline — files only, never SQL »), `content-ecole-tn/references/programmes-officiels/programme/_TEMPLATE.md` (format de sortie de référence), `src/shared/content/program-manifest.ts` (schéma manifeste), `content-engine/references/math-and-notation.md` (règles de notation, injectées à l'OCR), `FableEtudes/12-studio-ingestion/ETUDE.md` (la **génération** — hors périmètre ici)

---

## 1. Contexte & objectif produit

### La ligne de partage exacte (clarifiée)

Ce module fait de la **transcription fidèle**, y compris l'**OCR de scans par LLM vision**. Il ne fait **aucune génération**. La frontière n'est pas « déterministe vs IA », c'est :

| ✅ Transcription (dans le module)                                                                                 | ⛔ Génération (hors module)                                                                       |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| Lire **ce qui est sur la source** : texte, structure, tableaux, figures, exercices/questions **tels qu'imprimés** | **Ajouter ce qui n'est pas sur la source** : inventer un QCM, des distracteurs, un corrigé absent |
| OCR d'un scan / image via **LLM vision** (lecture fidèle)                                                         | Calibrer une difficulté, poser des `misconceptionTag`, fixer des récompenses                      |
| Extraction déterministe d'un PDF à couche-texte (`pdftotext`)                                                     | Rédiger un cours, reformuler « pédagogiquement »                                                  |

Le LLM est nécessaire — mais **uniquement comme moteur d'OCR/vision fidèle**, jamais comme générateur. Toute génération relève des skills (`content-ecole-tn`, `prof-*`…) et de l'étude 12.

### L'état réel aujourd'hui

La transcription du corpus officiel (CNP) est **manuelle** : `cnp-officiel/render.sh` (poppler) rasterise les scans, un agent **lit en vision** et **écrit à la main** `programme/<grade>/<matière>.md` (gabarit `_TEMPLATE.md`) + `manifest/<grade>.json`, avec `_INDEX.md` coché à la main. Les PDF à couche-texte intacte (secondaire 1ère-sec, `pdfs_9raya/`) sont lus par `pdftotext`. **Aucun outil packagé, aucun client LLM programmatique, aucune résumabilité.** L'OCR « réel » = rasterisation + vision d'un agent.

### Le problème résolu

Packager ce flux en **module autonome, réutilisable, agnostique du LLM** : je pointe une **arborescence** source (ex. le corpus CNP) et un répertoire cible ; le moteur inventorie, **route par coût** (couche-texte → extraction sans LLM ; scan/image → OCR LLM vision), transcrit **fidèlement** au **format de l'app**, **détecte le déjà-fait**, **complète les manquants sans rien refaire**, **trace** tout (ledger + `AVANCEMENT.md`), et **valide** la sortie (QA). Un scan transcrit une fois est enregistré et **jamais re-soumis** au LLM (cache + empreinte).

### KPI de succès

- **Optimisation coût** : % d'unités traitées **sans LLM** (couche-texte) vs via OCR vision ; tokens/coût par unité ; **0 re-soumission** d'une unité déjà transcrite.
- **Résumabilité** : sur un corpus partiel, 0 réécriture inutile, tous les manquants complétés.
- **Traçabilité** : `status` et `AVANCEMENT.md` toujours à jour (fait / à faire / à revoir).
- **Fidélité** : taux de correction manuelle sur échantillon (extraction texte ≈ nul ; OCR vision faible et signalé par confiance).
- **Agnosticité** : mêmes tests verts en substituant un provider stub au provider Claude.
- **Conformité** : 100 % des sorties passent la QA du profil app.

### Non-objectifs (v1)

**Toute génération** (QCM, cours, calibrage, `misconceptionTag`, récompenses — définitivement hors module) ; OCR de **manuscrits** (écriture cursive) ; génération d'images ; UI in-app (étude 12) ; traduction (chaque langue est native) ; réconciliation sémantique avec le programme officiel (tâche de skill, pas de ce moteur) ; formats source ePub/HTML (extensibles plus tard).

---

## 2. Spécification fonctionnelle

### Acteurs & parcours

Bibliothèque + **CLI** (pas d'UI). Acteurs = appelants.

- **US-1 (opérateur, corpus)** : `scribekit transcribe ./cnp-officiel/manuels ./programmes-officiels --profile app-cnp --provider anthropic` → parcourt **toute l'arborescence** (plusieurs répertoires acceptés), **route par coût** chaque unité, transcrit fidèlement au format app **à l'endroit cible**, **saute** le déjà-fait, met à jour ledger + `AVANCEMENT.md`. Idempotent.
- **US-2 (opérateur, suivi)** : `scribekit status ./programmes-officiels` → total, faits, à faire, à revoir (OCR basse confiance), en erreur ; par unité. Depuis le ledger, pas de relecture coûteuse.
- **US-3 (opérateur, QA)** : `scribekit qa ./programmes-officiels` → valide l'arborescence de sortie (conformité schéma profil, notation R-6, non-vides, couverture pages) → rapport ranké, code retour non-zéro si `[error]`.
- **US-4 (développeur/bibliothèque, agnosticité)** : `await transcribe(inputs, { profile, provider, adapters })` → `{ results, ledger }`. On injecte **son propre `LlmProvider`** (autre modèle) et/ou ses adaptateurs source/sortie/rasterizer sans toucher au cœur.
- **US-5 (dry-run + coût)** : `--dry-run` montre exactement ce qui **serait** créé/complété/sauté et **quel chemin** (texte vs LLM) + estimation de coût, sans rien écrire.

### Règles métier

- **R-1 — Fidélité, jamais de génération.** On transcrit **ce qui est dans la source**. On **n'ajoute** rien qui n'y figure (ni QCM, ni distracteur, ni difficulté, ni tag, ni corrigé absent). L'OCR lit fidèlement ; il ne « complète » pas une page illisible en devinant — il **signale** (confiance/`uncertainty`). Un doute = signalement, jamais invention.
- **R-2 — Optimisation coût obligatoire (routage).** Pour un PDF, **sonder la couche-texte avant tout LLM**. Bonne couche-texte → extraction déterministe (`pdftotext`/pdfjs), **0 token**. Sinon (scan/image) → **OCR LLM vision**. La règle porte sur la **qualité** du texte, pas sa présence (scans CNP = couche-texte cassée, mojibake). Heuristique R-7. Forçable (`--pipeline text|vision`).
- **R-3 — Agnosticité du LLM.** Le cœur ne dépend d'**aucun SDK de provider** : il ne connaît que le port **`LlmProvider`** (vision + texte). Adaptateurs (Anthropic d'abord) = entrées séparées. Substituer un stub ne change pas le cœur (test).
- **R-4 — Résumabilité / idempotence.** Chemin de sortie **déterministe** par unité. Unité « à jour » ⟺ sorties présentes **et** `sourceSha256` du ledger == empreinte actuelle. À jour → **sautée** (jamais re-soumise au LLM). Manquante/périmée → (re)produite. `--force` force. **On complète l'existant, on ne le refait pas.**
- **R-5 — Sortie conforme aux exigences de l'app.** Un **profil de sortie** décide structure/format. Profil `app-cnp` (défaut de référence) = `_TEMPLATE.md` (Markdown transcription) + `manifest/<grade>.json` **validé par le Zod réel de l'app** (`program-manifest.ts`, vendoré + garde de drift, D-5). Profils génériques `markdown`/`json`/`yaml` pour l'usage hors app.
- **R-6 — Reproductibilité malgré le LLM.** L'OCR n'est pas déterministe ; on la **stabilise** : cache par empreinte (`sha256(source)+params+model` — R-4/D-7), `confidence` par bloc OCR, `uncertainty[]` par zone douteuse. Les chemins **non-LLM** (texte, DOCX) restent **octet-stables**. Aucun horodatage volatil **dans le contenu** (les dates vivent au ledger).
- **R-7 — Notation standard, RTL-safe.** `math-and-notation.md` **injecté à l'OCR** (consigne) **et** vérifié en QA (linter) : chiffres occidentaux (0–9) partout y compris arabe ; équations LTR ; unités SI ; jamais de chiffres arabo-indiens ; Markdown arabe bidi-safe.
- **R-8 — Traçabilité de première classe.** **Ledger** JSON (vérité machine) par unité : chemin source relatif, `sourceSha256`, statut (`done|pending|needs-review|skipped|error|unsupported`), pipeline emprunté (`pdf-text|vision-ocr|docx|text`), profil, sorties, `usage` (tokens), notes. **`AVANCEMENT.md`** régénéré depuis le ledger (tableau lisible façon `_INDEX.md`).
- **R-9 — Arborescence en entrée.** Un ou plusieurs répertoires (récursif) et/ou fichiers. Parcours stable. Non supporté → `skipped`/`unsupported` avec raison ; manuscrit → `unsupported`.
- **R-10 — Écriture sûre et bornée.** Écrit **uniquement** sous `-o` (+ ledger). Chemins normalisés (pas de `..`). Ne touche jamais un fichier non géré par lui (propriété au ledger) sans `--force`. Jamais de DB.
- **R-11 — Confidentialité explicite.** Envoyer un scan à un provider tiers est un choix de l'appelant : le provider est **explicite** (`--provider`), un mode **sans réseau** est possible (provider local, ou OCR classique tesseract — Q-3), et les logs ne contiennent jamais le contenu du document par défaut.

### i18n / langues

Pas d'UI. Fidélité multilingue : détection de langue par unité (`ar|fr|en|other`), Markdown RTL-safe, notation R-7. La langue alimente l'entête du profil app.

### Hors périmètre (v1)

Génération (définitif) ; OCR manuscrit ; ePub/HTML ; canal in-app (étude 12) ; réconciliation programme.

---

## 3. Architecture technique (décisions fermées)

Package TypeScript/Node **autonome** (repo dédié, publiable), **hexagonal**. Cœur pur (types + orchestration corpus + rendu + ledger, dépend des ports + `zod`/`yaml`) ; ports remplaçables ; **entrée provider LLM séparée** pour que le cœur reste sans SDK.

### Vue d'ensemble

```
inputs (1..n répertoires/fichiers)
   └▶ [Walker] parcours récursif stable → SourceUnit[] (R-9)
        └▶ pour chaque unité :
             [Ledger] à jour ? ──oui──▶ SKIP (R-4, 0 token)
                   │ non
                   ▼
             [SourceAdapter.detect] pdf | docx | text | image
                ├─ pdf ▶ [TextLayerProbe] bonne couche-texte ? (R-2/R-7)
                │        ├─ oui ▶ [PdfTextAdapter]  pdftotext/pdfjs        (0 LLM)
                │        └─ non ▶ [Rasterizer poppler] → [VisionOcr(LlmProvider)]  (OCR fidèle)
                ├─ image ▶ [VisionOcr(LlmProvider)]  (ou [Ocr tesseract] si --ocr-local)
                ├─ docx ▶ [DocxAdapter mammoth]      (0 LLM)
                └─ text ▶ [TextAdapter passthrough]  (0 LLM)
                      │
                      ▼  (cache par empreinte pour l'OCR — R-6)
                 DocumentModel (fidèle ; confidence/uncertainty si OCR)
                      ▼
                 [OutputProfile.render] → OutputFile[] (MD/JSON/YAML, layout app) (R-5)
                      ▼
                 [Writer] sous -o (R-10) + [Ledger.update] + régénère AVANCEMENT.md (R-8)
```

### Ports

```ts
interface SourceAdapter { readonly kind: "pdf"|"docx"|"text"|"image"; detect(u: SourceUnit): boolean;
  extract(u: SourceUnit, ctx: Ctx): Promise<DocumentModel>; }              // texte/docx = déterministe
interface TextLayerProbe { assess(pdf: SourceUnit): Promise<{ hasGoodText: boolean; charsPerPage: number; garbageRatio: number; reason: string }>; }
interface Rasterizer { render(pdf: SourceUnit, pages: number[], dpi: number): Promise<PageImage[]>; }  // poppler
interface LlmProvider {                                    // L'INTERFACE D'ABSTRACTION (message 1), cantonnée à l'OCR/vision
  readonly name: string; readonly caps: { vision: boolean };
  transcribe(req: OcrRequest): Promise<OcrResponse>;       // images + consigne de FIDÉLITÉ (prompt-packs) → texte/blocs
}
interface Ocr { recognize(images: PageImage[]): Promise<PageText[]>; }     // tesseract.js — OPTIONNEL, offline, sans réseau
interface OutputProfile { readonly id: string; targetPaths(u: SourceUnit): string[];
  render(doc: DocumentModel, u: SourceUnit): OutputFile[]; validate(tree: string): QaFinding[]; }
interface Ledger { isUpToDate(u: SourceUnit): boolean; get(id: string): LedgerEntry|undefined;
  upsert(e: LedgerEntry): void; toMarkdown(): string; }
interface Logger { info(m: string, meta?: object): void; warn(...): void; error(...): void; }

interface OcrRequest { images: ImageRef[]; system: string;  // reçoit les prompt-packs skills (fidélité + notation R-7)
  language?: Lang; maxTokens?: number; }
interface OcrResponse { blocks: DocBlock[]; usage: { inputTokens: number; outputTokens: number };
  confidence: number; uncertainties: { page?: number; note: string }[]; }
```

Le cœur ne connaît **que** ces interfaces (R-3). `@…/anthropic` implémente `LlmProvider.transcribe` (Messages API, blocs image, consigne système = prompt-packs).

### DocumentModel (fidèle)

```ts
type Lang = "ar" | "fr" | "en" | "other";
interface Provenance {
  sourceFile: string;
  page?: number;
}

type DocBlock =
  | { kind: "heading"; level: 1 | 2 | 3 | 4 | 5 | 6; text: string; provenance?: Provenance }
  | { kind: "paragraph"; markdown: string; provenance?: Provenance }
  | { kind: "list"; ordered: boolean; items: string[]; provenance?: Provenance }
  | { kind: "table"; rows: string[][]; provenance?: Provenance }
  | {
      kind: "figure";
      id: string;
      svg?: string;
      imageRef?: string;
      caption?: string;
      provenance?: Provenance;
    }
  | {
      kind: "exercise";
      title?: string;
      instructions?: string;
      questions: DocQuestion[];
      provenance?: Provenance;
    }
  | { kind: "pageBreak"; page: number };

interface DocQuestion {
  // capté TEL QU'IMPRIMÉ (R-1) — jamais enrichi/inventé
  prompt: string;
  options?: { id: string; text: string }[]; // uniquement si présentes dans la source
  answer?: string; // uniquement si un corrigé figure dans la source
}

interface DocumentModel {
  schemaVersion: 1;
  language: Lang;
  title?: string;
  source: { type: "pdf" | "image" | "docx" | "text"; file: string; sha256: string };
  pipeline: "pdf-text" | "vision-ocr" | "docx" | "text"; // chemin réel (traçabilité/KPI coût)
  blocks: DocBlock[];
  warnings: string[];
  confidence?: number; // présent si OCR (R-6)
  uncertainties?: { page?: number; note: string }[];
  usage?: { inputTokens: number; outputTokens: number }; // si LLM emprunté
}
```

### Décisions d'architecture (ADR)

- **D-1 — Fidélité, jamais de génération (invariant central).** Le LLM est un **OCR/transcripteur fidèle** (`LlmProvider.transcribe`), pas un générateur : pas de port de « génération », aucune sortie qui ajoute au contenu source. La génération (QCM/cours/calibrage) reste chez les skills / étude 12. _Rejeté_ : projeter la sortie vers le schéma `content/` QCM (c'est de la génération — hors module).
- **D-2 — Routage par coût (R-2/R-7).** `TextLayerProbe` court-circuite le LLM quand la couche-texte est bonne. _Rejeté_ : tout envoyer en vision (coût inutile sur `pdfs_9raya/` / secondaire) ; se fier à la présence d'une couche-texte (scans CNP cassés).
- **D-3 — Abstraction LLM, cœur sans SDK (R-3, message 1).** Port `LlmProvider` vision ; adaptateur Anthropic en **entrée séparée** ; stub pour tests. `npm i` du cœur ne tire aucun SDK. _Rejeté_ : SDK Anthropic dans le cœur (casse l'agnosticité, alourdit le chemin texte).
- **D-4 — Orchestrateur corpus résumable & traçable (cœur de valeur, R-4/R-8/R-9).** `Walker` + `Ledger` par `sha256` → skip/complete ; ledger JSON (vérité) + `AVANCEMENT.md` régénéré. _Rejeté_ : transcodage sans état (refait tout, re-facture le LLM) ; suivi coché à la main (mode `_INDEX.md` actuel, non fiable).
- **D-5 — Profils de sortie ; `app-cnp` = contrat app (R-5).** `OutputProfile` interchangeable ; `app-cnp` vendore `_TEMPLATE.md` + Zod `program-manifest.ts` avec **garde de drift CI**. Génériques `markdown`/`json`/`yaml` pour la réutilisation. _Rejeté_ : format app codé en dur (non réutilisable) ; redéfinir le schéma (dérive — Q-2).
- **D-6 — OCR = vision LLM (défaut) + tesseract offline (option) derrière un même port.** Le défaut suit l'existant (rasterise → vision) et donne la meilleure fidélité ; `--ocr-local` (tesseract) pour le hors-ligne/confidentialité (R-11). _Rejeté_ : tesseract par défaut (fidélité moindre sur maths/mise en page) ; vision comme seule option (confidentialité).
- **D-7 — Cache par empreinte (R-6).** Sorties OCR mises en cache sous `cacheDir` (`sha256+params+model`) : reproductibilité, coût maîtrisé, tests rejouables, **jamais** re-soumettre une unité déjà faite. _Rejeté_ : pas de cache (coût/latence, non-reproductible).
- **D-8 — Réutilisation des skills = prompt-packs de FIDÉLITÉ (R-3/R-7).** L'OCR reçoit en consigne système un sous-ensemble des références `content-engine` (**transcription fidèle** + `math-and-notation.md`), vendoré + checksum CI (source unique = repo app). Ce sont des consignes de **lecture fidèle**, pas de génération. _Rejeté_ : réécrire les règles dans le module (dérive) ; prompts de génération (hors périmètre).
- **D-9 — Écriture sûre et bornée (R-10) + observabilité (usage/pipeline).** Writer confiné à `-o`, chemins normalisés, `--dry-run` complet ; logger injectable, comptage tokens + chemin dans le ledger et `--report` (KPI coût). _Rejeté_ : écrire dans le corpus source ; logs avec contenu de document.

### Intégrations & environnement

- **Runtime** : Node 22 / npm 10. Build `tsup`, tests `vitest`, `eslint`/`prettier` repris de l'app (zéro-warning). CI propre : lint + typecheck + test + coverage + build + `qa` fixtures (OCR mockée/cache, **0 réseau**).
- **Dépendances cœur** : `zod`, `yaml` (+ builtins). Adaptateurs : `pdfjs-dist` et/ou **poppler** CLI (`SCRIBEKIT_POPPLER_BIN`, réutilise `_tools/poppler` : `pdftotext` + `pdftocairo`), `mammoth`, `tesseract.js` (option). Provider : `@anthropic-ai/sdk` **dans l'entrée `@…/anthropic` seulement**.
- **Env (adaptateurs seuls, D-3)** : `ANTHROPIC_API_KEY`, `SCRIBEKIT_MODEL` (modèle vision, défaut `claude-sonnet-5`), seuils R-7, `SCRIBEKIT_POPPLER_BIN`, `SCRIBEKIT_CACHE_DIR`. Documentés dans le README du module.
- **Étude 12 / skills** : consomment la **transcription** produite ici pour **générer** le contenu ; ce module ne génère pas. Il peut tourner **en amont** d'une session agent (il fait tout l'OCR + l'extraction ; l'agent ne fait plus que la génération).

---

## 4. Plan d'exécution en lots

Repo séparé ⇒ « gate verte » = CI propre (lint + typecheck + vitest + coverage + build + `qa` fixtures). Un lot = une PR mergeable, utile seule. **OCR testée via cache commité / provider stub (0 réseau, 0 token en CI).**

| lot | contenu (résumé)                                                                                                                                                                                                                  | objets créés                                                                     | tests exigés                                                                                                                                  | dépend de  |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| 0   | Bootstrap + `DocumentModel` + ports (incl. `LlmProvider`) + `Renderer`/profils génériques (MD/JSON/YAML) + CLI squelette                                                                                                          | repo, build/CI, `core/{model,ports}.ts`, `profiles/{markdown,json,yaml}.ts`, CLI | unit : rendu déterministe (snapshot) ; substitution stub d'un port                                                                            | —          |
| 1   | **Chemin PDF texte** (R-2/R-7, 0 LLM) : `TextLayerProbe` + `PdfTextAdapter` (pdftotext/pdfjs) → DocumentModel                                                                                                                     | `TextLayerProbe`, `PdfTextAdapter`, structuration déterministe de base           | unit : sonde (bon texte `pdfs_9raya/` vs mojibake) ; e2e mono-fichier → MD/JSON                                                               | 0          |
| 2   | **Orchestrateur corpus + Ledger + AVANCEMENT.md + résumabilité** (R-4/R-8/R-9) : arbo multi-répertoires, skip-done, complete-missing, `--dry-run`/`--force`, `status`                                                             | `Walker`, `Ledger`, gen `AVANCEMENT.md`, `transcribe`/`status`                   | unit : idempotence (2ᵉ run = 0 écriture) ; source modifiée → re-fait ; e2e arbo partielle                                                     | 1          |
| 3   | **Profil `app-cnp`** (R-5/D-5) : rendu `_TEMPLATE.md` + `manifest/<grade>.json` validé Zod app (vendoré + drift)                                                                                                                  | `profiles/app-cnp.ts`, `content-schema` vendoré, test de drift                   | unit : sortie valide `program-manifest` ; garde drift ; snapshot `programme/<g>/<m>.md`                                                       | 0, 2       |
| 4   | **DOCX + texte** (0 LLM) : `DocxAdapter` (mammoth) + `TextAdapter`                                                                                                                                                                | `adapters/{docx,text}`                                                           | unit : `.docx` → blocs → MD/JSON ; passthrough                                                                                                | 1          |
| 5   | **Couche QA** (US-3/R-7) : commande `qa` (conformité profil, notation, non-vides, couverture pages) intégrée au gate                                                                                                              | `qa/` checks, commande `qa`, rapport ranké                                       | unit : chaque check (±) ; `qa` code retour non-zéro sur `[error]`                                                                             | 3          |
| 6   | **OCR / vision** (R-1/R-2/R-6/D-3/D-6/D-8) : `Rasterizer` poppler + `LlmProvider` + adaptateur **Anthropic vision** + `VisionOcr` + cache + `confidence`/`uncertainty` + prompt-packs fidélité ; option `--ocr-local` (tesseract) | `Rasterizer`, `providers/anthropic/`, `VisionOcr`, `cache/`, `Ocr` tesseract     | unit : provider **stub** (agnosticité) ; adaptateur mocké (0 réseau) ; e2e 2–3 pages scannées via **cache** commité ; routage texte vs vision | 1, 2       |
| 7   | **Pilote corpus CNP + release** : run sur le répertoire CNP existant → détecte le déjà-fait, extrait le texte, **OCR les scans**, produit `AVANCEMENT.md` + rapport coût ; `v0.1.0`                                               | doc/README, rapport pilote                                                       | dry-run + runs réels ; comparaison à l'état manuel actuel                                                                                     | 2, 3, 5, 6 |

- [x] Lot 0 — bootstrap + modèle + ports + profils génériques + CLI
- [x] Lot 1 — chemin PDF texte (0 LLM)
- [x] Lot 2 — orchestrateur corpus + ledger + AVANCEMENT.md (**cœur de valeur**)
- [x] Lot 3 — profil `app-cnp` (conforme + drift)
- [x] Lot 4 — DOCX + texte
- [x] Lot 5 — couche QA
- [x] Lot 6 — OCR / vision (abstraction LLM + Anthropic + cache + fidélité)
- [ ] Lot 7 — pilote CNP + release

**Stop-points** : D-1 est absolu (fidélité seule — **aucune génération** ; tout ajout non présent dans la source = STOP) ; le lot 6 ne démarre pas sans le stub LLM ni le contrat de fidélité (prompt-packs) ; jamais d'écriture hors `-o` ; une unité à jour n'est **jamais** re-soumise au LLM. Divergence étude↔code = STOP + remontée.

---

## 5. Stratégie de test (QA/tests de première classe)

Gate = **Vitest + typecheck + lint + build + coverage + `qa` fixtures** (seuils app : 80 %). **Aucun appel LLM réel en CI** (stub + cache commité). Deux couches :

- **Tests du moteur** : unit déterministes — rendu (snapshots MD/JSON/YAML), `TextLayerProbe` (fixtures étiquetées), **idempotence** (2ᵉ run = 0 écriture ; source modifiée → re-fait ; jamais de re-soumission LLM d'une unité à jour), sûreté d'écriture (borné `-o`, pas de `..`), **agnosticité** (`FakeLlmProvider` scripté prouve l'indépendance du cœur), adaptateur Anthropic contre **mock HTTP**, gardes de **drift** (schéma + gabarit + notation). Runs vision réels rejoués via **cache** commité (0 token).
- **QA du contenu produit** (commande `qa`, US-3) : valide une **arborescence de sortie** — conformité schéma profil, notation R-7 (chiffres occidentaux, bidi-safe), non-vides, couverture pages (`manuel.pages`), absence de placeholders. Ranké par sévérité ; **dans le gate** (fixtures) et **utilisable en prod** sur le vrai corpus.

Données : petits PDF texte/scan, DOCX, PNG sous `fixtures/` (extraits courts, droits OK ; + `pdfs_9raya/`) ; **caches OCR commités** ; une **arbo partielle** pour prouver resume/complete.

---

## 6. Risques & mitigations

- **RISK-1 — Le LLM « génère » au lieu de transcrire (invente/complète une page).** Probable/majeur (viole D-1). → prompt-packs de **fidélité stricte** (D-8) : « transcris ce que tu vois, ne complète pas, signale l'illisible » ; `confidence`/`uncertainty` (R-1/R-6) ; QA détecte les zones inventées vs pages sources ; revue humaine en aval.
- **RISK-2 — Faux positif de couche-texte (scan mojibake → cru textuel).** Probable/majeur. → **R-7/D-2** heuristique de **qualité** (mojibake + CID sans ToUnicode) ; échantillon-témoin CNP ; forçable ; seuils calibrés lot 1.
- **RISK-3 — Coût/latence LLM à l'échelle.** Possible/moyen. → **R-2** (texte 0 token en priorité), **cache** (D-7), option tesseract offline, comptage tokens (`--report`), **jamais** re-soumettre le déjà-fait (R-4).
- **RISK-4 — Confidentialité (scans envoyés à un tiers).** Possible/majeur selon source. → **R-11** provider explicite, mode offline (tesseract/`--ocr-local`), logs sans contenu, agnosticité (R-3) → provider local possible.
- **RISK-5 — Corruption/écrasement de l'existant (résumabilité).** Possible/majeur. → **R-4/R-10/D-9** propriété au ledger, pas de réécriture d'un fichier à jour, écriture bornée `-o`, `--dry-run` avant gros run.
- **RISK-6 — Dérive schéma/gabarit/notation vs app.** Possible/majeur. → **gardes de drift CI** (D-5/D-8) ; package partagé à terme (Q-2).
- **RISK-7 — Portabilité poppler (binaire système).** Possible/moyen. → repli pdfjs pur-JS ; poppler détecté par env, non requis pour le chemin texte de base.

---

## 7. Questions ouvertes (pour l'humain)

- **Q-1 (tranchée)** — Repo GitHub dédié **ScribeKit**. Package cœur `scribekit`, adaptateur provider en entrée séparée (`scribekit/anthropic` ou `@scribekit/anthropic`). Détail non bloquant restant : scope npm exact + repo public/privé.
- **Q-2 (tranchée — option A)** — Copie vendorée de `program-manifest.ts` dans ScribeKit + **test anti-dérive en CI** (échoue si divergence avec la version app). L'extraction en package publié partagé (option B) est reportée à l'apparition d'un 2ᵉ consommateur du schéma. Ne compte qu'au lot 3.
- **Q-3 (tranchée)** — OCR par **vision Claude Sonnet** par défaut (`SCRIBEKIT_MODEL=claude-sonnet-5`, vision-capable) derrière l'interface agnostique `LlmProvider` ; **tesseract offline en option** (`--ocr-local`). Autres providers (OpenAI/local) en backlog.
- **Q-4 — Profils de sortie v1 (R-5).** `app-cnp` confirmé comme référence. Livrer **aussi** `markdown`/`json`/`yaml` génériques en v1 (quasi gratuits) ? _Reco_ : oui, génériques au lot 0 + `app-cnp` au lot 3.
- **Q-5 — Home de la génération (le relais aval).** La génération (QCM/cours) reste chez les skills / étude 12 : ce module s'arrête à la **transcription**. Confirmer que 13 ne produit **aucun** fichier `content/` QCM. _Reco_ : oui, transcription seulement.
- **Q-6 — Emplacement ledger & `AVANCEMENT.md`.** Sous la cible (`<out>/.scribekit/ledger.json` + `<out>/AVANCEMENT.md`) ? _Reco_ : oui.

---

## 8. Journal d'exécution

- **2026-07-09 — Lot 0 (bootstrap) livré.** Nouveau repo git local `D:\11-coding\YahiaAcademy\ScribeKit`
  (commit racine `118e795`, 25 fichiers ; publié sur GitHub, voir plus bas). Livré : `src/core/model.ts`
  (`DocumentModel` + blocs), `src/core/ports.ts` (tous les ports, dont l'abstraction `LlmProvider`
  cantonnée à l'OCR), profils génériques `markdown`/`json`/`yaml` (rendu déterministe), squelette CLI
  (`cli.ts` pur + testé, `bin.ts` ESM). Gate **verte** : eslint (0 warning) + `tsc` strict + 13 tests
  vitest + build `tsup` (ESM+CJS+dts) ; workflow CI `verify`. Dépendance runtime : `yaml` seule → package
  **indépendant** (aucun lien vers l'app).
  - _Artefact d'environnement (à connaître pour le lot 1)_ : l'outillage npm du bac à sable réinjecte une
    dépendance locale `tanstack_start_ts` (lien `file:` vers le worktree de l'app) à **chaque** `npm install`.
    Elle est retirée des fichiers versionnés (`package.json` + `package-lock.json`) après install ; ScribeKit
    ne doit **jamais** dépendre de l'app. Sans effet en CI (environnement propre). Après tout `npm install`
    local, re-nettoyer avant de committer.
  - _Repo distant_ : **https://github.com/MBeji/ScribeKit** (public), CI `verify` **verte** (commit `960142b`).
    Décision : **pas de `package-lock.json` versionné** (librairie) → contourne npm/cli#4828 (natif Rollup
    non installé sous Linux depuis un lock Windows) + l'injection sandbox ; `setup-node` sans cache npm ;
    CI = `npm install` + lint + typecheck + test + build.
  - _Reste_ : lot 1 = chemin PDF texte (sonde couche-texte + extraction, 0 LLM).
- **2026-07-09 — Lot 1 (chemin PDF texte) livré** (PR #1, squash `acb4f1b`, CI verte). Extraction
  déterministe des PDF à couche-texte, **0 token LLM** : `assessTextQuality` route texte-vs-scan par
  **qualité** (chars/page + ratio mojibake/contrôle, pas par simple présence) ; `extractPdfPages` via
  **unpdf** (wrapper pdfjs Node, sans binaire système) ; `documentFromPages` (blocs fidèles + sauts de
  page + provenance) ; `pdfTextAdapter` (SourceAdapter, pour l'orchestrateur du lot 2) ; `transcribePdf`
  (routage : bon texte → DocumentModel ; scan → `needs-advanced`, OCR au lot 6). CLI `transcribe
<file.pdf> [-o] [--profile markdown|json|yaml]`. 25 tests verts (heuristique, extraction via fixtures
  pdf-lib, intégration CLI). Deps : `unpdf` (runtime), `pdf-lib` (dev).
  - _Reste_ : lot 2 = orchestrateur corpus + ledger + `AVANCEMENT.md` (résumabilité — cœur de valeur).
- **2026-07-09 — Lot 2 (orchestrateur corpus) livré** (PR #2, squash `1e185aa`, CI verte). Le cœur de
  valeur : `walk` (parcours récursif stable, multi-répertoires, ignore les cachés) ; `FileLedger`
  (`.scribekit/ledger.json` = vérité sha256 + `AVANCEMENT.md` régénéré, **écrits seulement si changés**) ;
  `transcribeCorpus` (route .pdf → chemin texte ; scans → `pending`/OCR lot 6 ; .docx/.txt → `pending`/lot
  4 ; `--dry-run` / `--force`). CLI `transcribe <input...>` (corpus) + `status <dir>`. **Résumabilité
  prouvée** : 2ᵉ run sur corpus inchangé = 0 écriture ; source modifiée → re-fait ; nouveau fichier →
  seul lui est produit ; scan → `pending` sans sortie ; dry-run → rien. 36 tests verts.
  - _Reste_ : lot 3 = profil `app-cnp` (rendu `_TEMPLATE.md` + manifest validé par le Zod app, copie
    vendorée + test de drift — Q-2 option A).
- **2026-07-09 — Lot 3 (profil app-cnp) livré** (PR #3, squash `60f65b2`, CI verte). Sortie **conforme à
  l'app** : schéma Zod `program-manifest` **vendoré** (copie verbatim = contrat de `manifest/<grade>.json`) ;
  helpers manifeste (validate/build/upsert/load/write — matières triées, `chapters: []` = non codifié) ;
  `renderAppCnpMarkdown` = **échafaudage `_TEMPLATE.md`** (en-tête + **annexe de transcription fidèle brute**
  - placeholders « à compléter » pour l'analyse programme que ScribeKit **ne génère pas**) + signalement des
    scans ; CLI `app-cnp <input.pdf...> --grade --subject [--name --lang --manuel --pages] -o`. Garde
    anti-dérive `scripts/check-manifest-drift.mjs` (signatures) + contrat comportemental en CI. 48 tests verts.
  * _Décision assumée (écart documenté)_ : app-cnp produit un **échafaudage fidèle** (brut + placeholders),
    pas le `programme/*.md` **curé** final — la curation (compétences, bornes de scope, chapitrage) reste
    humaine/skill (R-1). grade/matière fournis par l'appelant (non dérivables du brut) ; `--lang` requis hors
    arabe. Dérive cross-repo **automatique complète** = option B (package publié), reportée ; en attendant :
    signatures + tests comportementaux.
  * _Reste_ : lot 4 = DOCX + texte (mammoth) ; puis lot 5 = QA ; lot 6 = OCR/vision (Claude Sonnet).
- **2026-07-09 — Lot 6 (OCR / vision) livré** (PR #4, squash `8f56788`, CI verte). Débloque les scans :
  `LlmProvider` (contrat d'agnosticité), `OcrRequest` porte le **PDF source** (Claude lit le PDF nativement
  → **pas de rasteriseur/canvas**), `FIDELITY_SYSTEM_PROMPT` (transcrire, jamais générer/deviner),
  `visionOcrPdf` → DocumentModel `vision-ocr` (confidence/uncertainties/usage), `OcrCache` sha256 (jamais
  de re-soumission), orchestrateur : scan → OCR si `provider` fourni (sinon `pending`), CLI `transcribe
--provider anthropic [--ocr-cache]`. Adaptateur Anthropic en **entrée séparée** `scribekit/anthropic`,
  SDK importé **paresseusement** → `import "scribekit"` et le chemin texte ne chargent jamais le SDK (D-3
  vérifié : 0 réf dans `dist/index.js`) ; `@anthropic-ai/sdk` = peer optionnel. 54 tests verts.
  - _Écart assumé_ : **support PDF natif de Claude** au lieu du rasteriseur poppler + tesseract de l'étude
    (plus simple, sans dép. canvas native, CI propre, meilleure fidélité) ; tesseract-local = option future.
  - _Reste_ : lot 4 (DOCX/texte) + lot 5 (QA) pour finir.
- **2026-07-09 — Lot 4 (DOCX + texte) livré** (PR #5, squash `86adff3`, CI verte). `.docx` (via **mammoth**)
  et `.txt`/`.md` transcrits fidèlement (0 LLM) et routés dans l'orchestrateur (plus de `pending`).
  `core/text-blocks` (helper partagé texte→blocs), `adapters/{docx,text}`, routage unifié par extension.
  57 tests. Dép. : `mammoth` ; dev : `docx` (fixtures).
- **2026-07-09 — Lot 5 (couche QA) livré** (PR #6, squash `f31a288`, CI verte). `scribekit qa <dir>` valide
  une arborescence de sortie (code retour non-zéro si erreur) : cohérence ledger (unités en erreur, sorties
  disparues, `pending`), Markdown non-vide + notation R-7 (chiffres occidentaux, pas d'arabo-indiens),
  conformité manifeste au schéma vendoré. Les placeholders « à compléter » des échafaudages ne sont pas
  signalés (échafaudage fidèle, pas une erreur). 61 tests. `FileLedger.all()` ajouté.
- **2026-07-09 — ÉTUDE LIVRÉE.** Les 8 lots (0–6) sont sur `main` (repo public
  https://github.com/MBeji/ScribeKit), 6 PRs mergées, CI verte à chaque fois, 61 tests, gate propre. Le
  moteur couvre : PDF texte (déterministe, 0 LLM) · scans → OCR vision Claude (agnostique, cache, fidélité) ·
  DOCX/texte · corpus résumable + traçable (ledger + AVANCEMENT.md) · sortie générique MD/JSON/YAML + profil
  app-cnp (échafaudage `_TEMPLATE.md` + manifeste validé) · QA. _Reliquats hors-lot (backlog)_ : image OCR
  autonome, tesseract-local offline, package de schéma partagé (Q-2 option B), release v0.1.0 + tag.
- **2026-07-09 — Audit multi-agents + remédiation** (PR #7, squash `10dc0a6`, CI verte). 4 relecteurs
  indépendants (correctness · agnosticité/D-3 · couverture de tests · sécurité). **Vérifiés PASS** :
  agnosticité du LLM (0 réf SDK dans `dist/index.js`), fidélité-sans-génération (R-1), déterminisme,
  confinement d'écriture sous `-o` pour le chemin `transcribe`. **Bugs réels corrigés** : `parseOcrReply`
  partait du 1er `{` → tronquait la transcription dès qu'elle contenait `{...}`/LaTeX (**bug de fidélité,
  perte de données**) ; collisions de chemins de sortie (`a.pdf`+`a.txt`→`a.md`) écrasées en silence →
  désormais **erreur** ; `--dry-run` appelait quand même le provider OCR (payant) ; `app-cnp --grade` non
  validé → traversal `../` ; un fichier illisible avortait tout le run ; cache corrompu re-échouait. Seuils
  de couverture **rendus effectifs** (80 % toutes métriques, CI `test:coverage`). 70 tests, couverture
  90.9/80.9/81.4. Le port mort `TextLayerProbe` retiré, README remis à jour.

# Étude 21 — Valorisation des manuels élèves officiels (exercices, figures, savoirs, cours)

> **Statut** : validée — Q-1…Q-4 arbitrées le 2026-07-20 par Mohamed ; Q-1/Q-3/Q-4 suivent les
> recommandations de l'architecte, **Q-2 s'en écarte** (la provenance manuel n'est pas affichée à
> l'élève → lot 3 abandonné)
> **Priorité** : 21 · **Valeur** : 📘 le gisement pédagogique n° 1 du programme (267 manuels élève CNP) devient du contenu jouable, traçable et mesurable — au coût marginal le plus bas du catalogue · **Complexité** : moyenne+
> **Architecte** : Fable 5 / 2026-07-17 · **Exécuteur cible** : Sonnet (ou équiv.) — lots 5–6 = campagne de contenu via les skills
> **Dépend de** : é13 ScribeKit (livrée) · é18 cours vivants (livrée) · corpus `cnp-officiel/` + fiches `programme/` (46 transcrites) · **s'articule avec** é12 (canal d'ingestion, brouillon), é19 (questions illustrées, brouillon), é20 (`short_answer`, validée non exécutée) · **Bloque** : rien (la campagne de contenu 16/vague A profite de la doctrine dès le lot 1)
> **Docs normatifs liés** : CLAUDE.md, ARCHITECTURE.md, `content/README.md`, `docs/interactive-question-types.md`, `docs/content-voice-and-composition.md`, `.claude/skills/content-engine/references/{generation-pipeline,quality-bar,course-quality,course-figures,interactive-formats,expert-exercises,math-and-notation}.md`, `FableEtudes/PROMPT-TRANSCRIPTION-CNP.md`

## 1. Contexte & objectif produit

### Le problème

Les manuels élèves officiels du CNP sont la matière pédagogique la plus riche et la plus légitime
du marché : cours, vocabulaire officiel, définitions, théorèmes, encadrés « retenir », exemples
résolus, figures, et surtout **des centaines d'exercices par manuel** — calibrés par les auteurs du
programme, connus des élèves et des parents. Or l'app ne les exploite aujourd'hui que sous deux
formes :

1. **Matière première de transcription** : 46 fiches `programme/<niveau>/<matière>.md` (24 `[x]`,
   22 `[~]` sur 64 couples au work-list) nourrissent la _génération_ de contenu — mais sans
   doctrine par type de contenu : chaque campagne redécide comment traiter un exercice, une
   figure, un encadré.
2. **Affichage documentaire brut** : la carte « Manuel officiel » (PDF complet par matière,
   `subjects.manuel_refs`, bucket privé `manuel-eleve`, connexion requise) et la galerie « Pages
   du manuel » par chapitre (`chapters.manuel_ref {code, pages}`, bucket `manuel-pages`) sont
   livrées — l'élève peut _consulter_ le manuel, pas le _pratiquer_.

Entre les deux, le pont **pédagogique** manque : rien ne dit quels exercices du manuel sont repris
en missions, aucune mission ne sait qu'elle vient du manuel, aucune mesure ne dit « ce manuel est
couvert à X % ». Résultat mesurable : sur 18 708 questions du catalogue, **zéro** est rattachée à
un exercice de manuel, alors que le corpus brut (267 PDF élève + 79 guides, 4 214 pages déjà
rastérisées dans `cnp-officiel/_render/`) est sur le disque et que le moteur d'exercices (5 types
natifs, 10 formats interactifs, figures SVG, misconceptions, compétences) couvre déjà la quasi-
totalité des formes d'exercices imprimées.

### Ce que l'étude installe

Une **doctrine de valorisation par type de contenu du manuel** (le cœur — aucun document ne la
formalise aujourd'hui), une **traçabilité fine** exercice-app ← exercice-manuel avec badge élève,
une **mesure de couverture** par manuel, et une **campagne pilote** qui prouve le coût et la
qualité. L'étude n'invente **ni moteur, ni format, ni canal** : elle spécialise ce que 12/13/18/19
ont déjà posé (voir D-1).

### Indicateurs de succès (KPI)

- **Couverture pilote** : ≥ 60 % des exercices _transposables_ des chapitres pilotes repris en
  missions tracées (rapport de couverture, lot 4).
- **Ancrage chapitre** : 100 % des chapitres de la matière pilote portent `chapter.manuel`
  (aujourd'hui : partiel) ; à terme, toute matière école dont le manuel est au corpus.
- **Usage** : les missions tracées 📘 sont jouées au moins autant que les missions maison de même
  palier (télémétrie `attempts` existante, aucun événement nouveau).
- **Complétude savoirs** : sur le pilote, 100 % des encadrés de savoir du manuel présents en bloc
  typé dans `cours.md` **et** en carte dans `resume.md` (audit lot 6).
- **Coût** : coût marginal d'une mission « reprise manuel » ≤ 50 % d'une mission créée ex nihilo
  (l'énoncé, les données et la calibration préexistent — à vérifier au pilote, journal §8).

### Ce que l'epic ne cherche PAS à faire

- **Pas de nouveau moteur ni de nouveau format de question** (D-4 é12) : tout contenu de manuel se
  mappe sur les formats existants (`mcq`/`numeric`/`ordering`/`matching`/`multi`, Tier A
  interactif, blocs `:::`, cartes) — plus `short_answer` quand é20 sera livrée.
- **Pas de re-transcription** : ScribeKit (é13) et le flux PROMPT-TRANSCRIPTION-CNP restent le
  seul chemin source→fiche ; la génération ne rouvre jamais les PDF (règle d'or phase 3).
- **Pas de reproduction d'images du manuel** dans le contenu versionné : SVG redessiné uniquement
  (D-8 é18, D-5 é19) ; les scans restent dans les buckets privés gated.
- **Pas de notation de rédaction/démonstration libre** (non-goal é20) : une démonstration du
  manuel se _décompose_, elle ne se « corrige » pas par IA.
- **Pas de canal d'ingestion in-app** (é12 lot 3) ni d'exploitation des guides enseignants comme
  contenu élève (ils restent source de transcription).
- **Pas de couverture des matières annexes** (musique, EPS, arts — hors périmètre corpus).

## 2. Spécification fonctionnelle

### Acteurs & parcours

- **Élève (connecté ou anonyme)** — joue les missions ; voit d'où elles viennent.
- **Parent** — cherche la conformité au manuel officiel (argument de confiance n° 1).
- **Auteur de contenu (architecte/exécuteur/skill)** — produit les reprises ; a besoin de savoir
  ce qui est déjà repris et ce qui manque.
- **Admin/ops (Mohamed)** — upload des PDF/pages (out-of-band, `scripts/manuel/upload-pdf.mjs`),
  arbitre la campagne.

User stories :

- **US-1** (élève) : sur le hub matière (`/matiere/$subjectId`), je repère d'un coup d'œil les
  missions issues de mon manuel officiel (badge 📘 sobre sur la ligne mission) — je peux « faire
  les exercices du manuel » dans l'app, corrigés et récompensés.
- **US-2** (élève) : dans une mission tracée, une mention discrète me donne la référence
  (« Manuel officiel · p. 47–49 ») ; connecté, la galerie « Pages du manuel » du chapitre
  (existante) me montre les pages authentiques.
- **US-3** (parent) : la page matière (carte Manuel officiel + missions 📘) me prouve que l'app
  suit le manuel de mon enfant, chapitre par chapitre.
- **US-4** (auteur) : pour un couple (matière, niveau), le rapport de couverture me liste par
  chapitre les exercices du manuel déclarés, ceux repris (avec leur mission), ceux qui restent, et
  ceux jugés non transposables (avec la raison).
- **US-5** (élève) : je révise les définitions/théorèmes du manuel en cartes (onglet Résumé) et je
  les réactive en mode Rappel (é17) — la mémorisation est couverte par l'existant, alimenté
  systématiquement.

États UX : le badge 📘 n'apparaît que si la mission est tracée ; anonyme = même badge (métadonnée
publique, comme la carte manuel) ; la mention du player ne bloque jamais le jeu (une mission
tracée reste auto-suffisante, R-3). Aucun écran nouveau, aucun état de chargement nouveau :
uniquement des enrichissements de surfaces existantes, mobile-first, RTL-safe (le badge suit la
direction du hub, déjà bidi).

### Règles métier

- **R-1 — Fidélité des données.** Une reprise (directe ou adaptée) conserve l'énoncé-substance du
  manuel : mêmes valeurs, mêmes objets, même contexte, même exigence. Changer les données = ce
  n'est plus une reprise mais une **variante** (régime c de D-5), jamais une « reprise corrigée »
  silencieuse. Si le manuel comporte une erreur avérée : la question est reprise corrigée **et**
  l'écart est consigné dans la fiche programme §6 (Incertitudes) — jamais reproduite fausse.
- **R-2 — L'explication est toujours originale.** Mini-leçon conforme à `quality-bar.md` (règle,
  application, piège nommé sur d3+) ; jamais un corrigé recopié (les corrigés des guides
  enseignants ne sont jamais copiés verbatim).
- **R-3 — Auto-suffisance.** Une question reprise se résout entièrement à l'écran. « Voir le
  manuel p. X » n'est jamais une dépendance de résolution — la référence manuel est un plus de
  confiance, pas un support requis.
- **R-4 — Traçabilité déclarée.** Tout exercice app qui reprend ≥ 1 exercice du manuel porte le
  champ `manuel` (D-6) avec ses `items`. Une **variante** (données changées) ne se trace pas :
  elle est du contenu maison inspiré, pas une reprise — le rapport de couverture ne compte que
  les reprises.
- **R-5 — Anti-duplication & cumul.** Avant toute reprise : audit de l'échelle existante du
  chapitre (règles cumulatives de `generation-pipeline.md`) ; une reprise ne doublonne jamais une
  question existante (même maison) ; elle remplit un palier manquant ou s'ajoute au `NN` libre
  suivant — jamais de renommage/renumérotation (UUID v5).
- **R-6 — Calibration sur l'échelle app.** Un exercice repris est re-calibré ⭐1–4 selon la table
  canonique (`rewards-and-modes.md`) : les exercices d'application du manuel peuplent d1–d2, les
  problèmes de synthèse d3 ; le d4 (défi élite, annales) reste le territoire des `prof-*` — la
  reprise ne convertit jamais un palier libre d1–2 en palier plafond.
- **R-7 — Figures.** Toute reprise d'un exercice « sur figure » embarque la figure **redessinée
  en SVG inline** — fidèle à la _fonction_ (mêmes données, mêmes relations), pas au pixel — et
  respecte intégralement la doctrine é18/é19 : figure VRAIE (re-dériver les coordonnées,
  double-solve sur la figure), qui ne fuit jamais la clé, `viewBox` obligatoire, jamais de
  `<image>`/bitmap (interdit par `sanitizeSvg`).
- **R-8 — Complétude des savoirs.** Tout encadré de savoir du manuel (définition, théorème,
  propriété, règle, méthode, « retenir »/« أتذكّر ») du périmètre d'un chapitre doit exister dans
  l'app : bloc typé `::: definition|propriete|methode|retenir` dans `cours.md` **et** carte
  `**Concept**: essence` dans `resume.md` ; s'il est testable, au moins une question d1–2
  l'interroge (quiz ou mission).
- **R-9 — Ancrage chapitre.** Toute matière école dont le manuel élève figure au corpus déclare
  `chapter.manuel {code, pages}` sur chacun de ses chapitres (advisory — c'est ce qui alimente la
  galerie de pages et le rapport de couverture). Les codes viennent du `CATALOGUE.md` du corpus
  (source de vérité des codes CNP).
- **R-10 — Langue & notation.** Contenu école monolingue dans la langue officielle d'instruction
  (règle existante). La reprise **convertit** la typographie du manuel vers le standard app :
  chiffres occidentaux 0–9 (même quand le manuel imprime ٠١٢٣), équations LTR, unités SI, U+00A0
  dans les groupes de chiffres (`math-and-notation.md`) — fidélité au contenu mathématique, pas à
  la typographie.
- **R-11 — Droits.** Jamais de bitmap/scan du manuel dans le contenu versionné ni dans le repo
  (public) ; la consultation des scans passe exclusivement par les buckets privés gated existants
  (`manuel-eleve`, `manuel-pages`). Les **textes tiers cités par les manuels de langue** (extraits
  littéraires des manuels de français/arabe/anglais : œuvres d'auteurs sous droits propres) ne
  sont **jamais repris verbatim** dans le contenu : les questions se réécrivent autour de la
  notion, ou sur des textes originaux maison. La politique de verbatim des _énoncés d'exercices_
  est l'objet de Q-1.
- **R-12 — Registre du badge.** Le wording élève (badge + mention player) suit le registre
  « Référence » de l'é15 (`docs/content-voice-and-composition.md`) : sobre, factuel, trilingue
  UI (fr/en/ar) ; aucun mot du champ « premium/abonnement/payant » (phase gratuite).

### i18n

- **UI** : nouvelles clés dans `src/lib/i18n/{fr,en,ar}-public.ts` — proposition :
  `manuelMissionBadge` (« Manuel »/« Manual »/« الكتاب »), `manuelMissionHint`
  (« D'après le manuel officiel · p. {pages} »), `manuelMissionFrom` (mention player). RTL : le
  chip suit le flux existant des lignes mission (déjà bidi-safe).
- **Contenu** : monolingue par matière (aucune traduction) — un exercice repris d'un manuel arabe
  est authored en arabe, d'un manuel français en français (R-10).

### Hors périmètre (v1)

Deep-link PDF à la page exacte (le viewer navigateur ne garantit pas `#page=` sur mobile ; la
galerie par chapitre suffit) · traçabilité par _question_ (le niveau exercice suffit, D-6) ·
moteur de flashcards dédié avec SRS propre (les cartes résumé + le Rappel é17 couvrent la
mémorisation ; un besoin natif irait à une étude types-natifs) · conversion des activités de
manipulation (découpage, pliage, expérience à réaliser — Q-4) · exploitation des guides
enseignants côté élève · watermarking des PDF (décision 2026-07-16 : hébergés tels quels,
login = la barrière).

## 3. Architecture technique (décisions fermées)

### 3.0 Vue d'ensemble — ce qui existe déjà (rappel de périmètre)

La chaîne source→app est **complète** ; l'étude n'ajoute que la couche doctrine + traçabilité +
mesure :

```
cnp-officiel/ (267 PDF élève · 79 guides · 4 214 renders PNG · CATALOGUE.md = codes)
   │  ScribeKit (é13, livrée — fidèle, resumable, OCR vision, profil app-cnp)
   ▼
programme/<niveau>/<matière>.md (46 fiches · §4 chapitrage code·pages) + manifest/<niveau>.json (11)
   │  skills de génération (content-ecole-tn, content-cours, content-interactif, prof-*)
   │  ◄── LOT 1 : doctrine manuel-valorisation.md (mapping par type de contenu)
   ▼
content/<subject>/NN-<chapitre>/{cours.md, resume.md, quiz.json, exercices/*.json}
   │  content:build --subject (UUID v5, idempotent)   ◄── LOT 2 : exercices/*.json → champ manuel
   ▼
DB : chapters.manuel_ref (✔ existant) · subjects.manuel_refs (✔) · exercises.manuel_ref (LOT 2)
   ▼
Élève : ManuelEleveCard (✔) · ManuelPagesSection (✔) · badge mission 📘 (LOT 3)
Auteur : audit-program (✔) · rapport de couverture manuel (LOT 4)
```

### 3.1 La doctrine de valorisation (lot 1 — le cœur)

Nouveau référentiel **`.claude/skills/content-engine/references/manuel-valorisation.md`**,
référencé par `generation-pipeline.md` (checklist), `content-ecole-tn`, `content-ingest`,
`PROMPT-TRANSCRIPTION-CNP.md` (phases 2–3) et les `prof-*` (via `expert-exercises.md`). Il fixe la
taxonomie et le mapping ci-dessous (normatif).

**Taxonomie fermée des contenus d'un manuel élève (D-3)** — grille alignée sur le
`DocumentModel` ScribeKit (`heading/paragraph/list/table/figure/exercise`) :

| #   | contenu du manuel                                                                | destination app (formats EXISTANTS uniquement)                                                                                                                                                                         |
| --- | -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | leçon, paragraphes de cours                                                      | `cours.md` **réécrit** (voix produit, jargon officiel conservé) — jamais copié ; complétude notionnelle R-8/D-9                                                                                                        |
| 2   | encadré de savoir (définition, théorème, propriété, règle, méthode, « retenir ») | bloc `::: definition\|propriete\|methode\|retenir` + carte `resume.md` + question d1–2 si testable (R-8)                                                                                                               |
| 3   | exemple résolu                                                                   | bloc `::: exemple` / `::: methode` (réécrit, jamais verbatim) ; gisement n° 1 de variantes d1                                                                                                                          |
| 4   | vocabulaire, lexique                                                             | cartes résumé + `matching` terme↔définition + cloze ; `short_answer` quand é20 livrée                                                                                                                                  |
| 5   | figure, schéma, graphique                                                        | **SVG redessiné** (`course-figures.md`) — côté cours (é18) et côté questions (é19)                                                                                                                                     |
| 6   | photo / planche documentaire (SVT, histoire…)                                    | schéma SVG **simplifié** si la notion est schématisable ; sinon la question se rédige auto-suffisante et la planche authentique reste consultable via la galerie « Pages du manuel » (gated) — jamais de bitmap (R-11) |
| 7   | tableau de données                                                               | table markdown (cours) ; format « lecture de document/données » (question)                                                                                                                                             |
| 8   | exercices                                                                        | **tableau de mapping ci-dessous**                                                                                                                                                                                      |
| 9   | activité d'exploration (ouverture de chapitre, manipulation)                     | histoire-problème séquentielle quand elle se raconte ; sinon ⛔ non transposable, documenté (Q-4)                                                                                                                      |
| 10  | exercices de synthèse / annales de fin de manuel                                 | palier d3–d4 des `prof-*` (au lycée : tier `NN-annales-bac`)                                                                                                                                                           |

**Mapping exercice-manuel → format app (D-4)** — classement par _forme de la réponse attendue_ ;
chaque format cible a sa **correction automatique native** (scoring server-side existant,
`score_answer`) :

| forme dans le manuel                          | format app                                                                                           | remarques                                                                                                                |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| QCM imprimé                                   | `mcq`                                                                                                | options du manuel conservées ; complétées à ≥ 3 distracteurs-misconceptions si le manuel n'en a que 2 (`quality-bar.md`) |
| calcul / réponse numérique / mesure           | `numeric` (`{value, tolerance?, unit?}`)                                                             | tolérance selon la grandeur ; unité affichée                                                                             |
| « relie / associe »                           | `matching`                                                                                           | natif (drag & drop)                                                                                                      |
| « ordonne / classe / range »                  | `ordering`                                                                                           | natif                                                                                                                    |
| « coche toutes les bonnes réponses »          | `multi`                                                                                              | sous-ensemble propre 2–5                                                                                                 |
| « complète » (texte à trous)                  | cloze Tier A (`mcq`) → **`short_answer` dès é20 livrée**                                             | la version native supprime la devinette                                                                                  |
| vrai / faux (avec justification)              | vrai/faux motivé (Tier A)                                                                            | la justification vit dans `explanation`                                                                                  |
| exercice sur figure / document                | QCM visuel SVG · lecture de document                                                                 | figure redessinée (R-7) ; jamais « voir p. X »                                                                           |
| problème à sous-questions (a, b, c…)          | histoire-problème séquentielle — 1 question/étape, dans l'ordre de l'énoncé                          | le format le plus fréquent en maths/physique ; chaque étape auto-suffisante (rappel du contexte en 1 ligne)              |
| « démontre / rédige / justifie »              | **décomposition** en jalons (`mcq`/`numeric` : hypothèses → outil → étape clé → conclusion)          | la rédaction libre n'est pas notée (non-goal é20)                                                                        |
| construction géométrique, manipulation réelle | ⛔ non transposable v1 — listé dans la fiche avec la raison (R-4, « aucune couverture silencieuse ») |                                                                                                                          |

**Régimes de reprise (D-5)** :

- **(a) directe** — l'énoncé du manuel est auto-suffisant et se mappe tel quel (données
  identiques, consigne éventuellement reformulée a minima pour la forme cible). Tracée.
- **(b) adaptée** — même substance, mêmes données, mais transformation de forme : décomposition
  en étapes, ajout de distracteurs, cloze-isation, figure redessinée. Tracée. **C'est le régime
  par défaut.**
- **(c) variante** — même notion/structure, **données changées** (pour multiplier les items,
  éviter un support non reproductible, ou contourner Q-1). Non tracée (contenu maison).

L'explication reste toujours originale (R-2) ; la self-verification de `quality-bar.md`
(re-résolution à l'aveugle, double-solve sur figure) s'applique intégralement — reprendre un
exercice n'exonère d'aucun gate.

### 3.2 Modèle de données

**Champ contenu (nouveau, additif)** — `exercices/*.json` (et lui seul : ni `quiz.json` — le quiz
gate la compréhension du cours, ce n'est pas une reprise — ni les questions individuelles) :

```jsonc
// content/<subject>/NN-<chapitre>/exercices/05-exercices-du-manuel.json
{
  "title": "⭐⭐ Les exercices du manuel — Thalès",
  "difficulty": 2,
  "mode": "practice",
  // …champs existants inchangés…
  "manuel": {
    "code": "222104P01", // optionnel — hérite de chapter.json manuel.code si absent
    "pages": "68-71", // optionnel — même grammaire que le chapitre (parseManuelPages)
    "items": ["ex. 12", "ex. 13", "ex. 15a"], // REQUIS, 1..30, libellés courts (≤ 40 chars)
  },
}
```

Zod (`src/shared/content/schema.ts`) : `exerciseManuelSchema` — `code` même pattern que
`manuelVolumeSchema` (`/^[A-Za-z0-9_-]+$/`), `pages` revalidée par `parseManuelPages` (réutilisée),
`items` `z.array(z.string().min(1).max(40)).min(1).max(30)`. Résolution du `code` : au **loader**
(`src/shared/content/loader.ts`) — si `exercise.manuel.code` absent, hériter de
`chapter.manuel.code` ; si aucun des deux → **erreur `content:check`** (une reprise sans manuel
identifiable n'est pas une traçabilité).

**Colonne DB (migration additive)** — `exercises.manuel_ref JSONB NULL`, forme compilée
`{"code","pages"?,"pageNumbers"?,"items"}` (miroir exact du pattern `chapters.manuel_ref`).
Émise par `sql-builder.ts` dans l'INSERT/UPDATE des exercises (upsert idempotent existant).
Client-readable **par design** (métadonnée publique, zéro clé de réponse — même posture que
`manuel_refs`/`manuel_ref` existants) : si la baseline (`20260612221000_baseline_table_grants.sql`
ou une migration ultérieure) granta `exercises` colonne par colonne, étendre le grant ; sinon le
grant table-level existant suffit — l'exécuteur du lot 2 vérifie et documente dans la PR.

**Manifest de programme (extension additive)** — `src/shared/content/program-manifest.ts`,
`manifestChapterSchema` gagne un champ optionnel (le PROMPT-CNP prévoyait déjà `manuel = {code,
pages}` au chapitrage ; le schéma ne l'avait pas encore) :

```jsonc
// manifest/<niveau>.json — par chapitre attendu
{
  "slug": "04-thales",
  "notion": "ثالس / Thalès",
  "manuel": {
    "code": "222104P01",
    "pages": "60-71",
    "exerciseCount": 24, // optionnel — assez pour un TAUX de couverture
    "exerciseItems": ["ex. 1", "ex. 2"], // optionnel — permet le DIFF fin repris/restant
  },
}
```

Trois niveaux de précision assumés : rien → couverture « non mesurable » (listé tel quel) ;
`exerciseCount` → taux ; `exerciseItems` → diff nominal. La transcription enrichit
progressivement (phase 2 du PROMPT-CNP, « profondeur de génération »).

### 3.3 Server

**Aucun RPC nouveau, aucune écriture nouvelle.** Deux projections en lecture s'étendent :

- La server fn qui alimente le hub matière (`getSubject`, `src/features/quest/quest.server.ts`)
  expose `manuel_ref` dans sa projection des missions (champ nullable, anon-safe).
- Le player (`startExerciseSession` / la projection d'en-tête d'exercice) expose de quoi afficher
  la mention (code déjà connu du chapitre ; seuls `pages`/`items` de l'exercice s'ajoutent).

Les buckets, URLs signées, `getSubjectManuels` et `getManuelPageUrls` sont inchangés.

### 3.4 Client

- **`src/features/quest/components/subject-hub.tsx`** : chip 📘 + libellé court
  (`manuelMissionBadge`) sur la ligne mission tracée, `title`/tooltip = `manuelMissionHint` avec
  pages ; aucun changement de layout (le chip rejoint les chips d'état existants), RTL par flux.
- **`src/features/quest/components/exercise-player.tsx`** : mention discrète sous le titre
  (`manuelMissionFrom` + pages) — texte pur, pas d'appel réseau.
- **`src/features/quest/manuel-refs.ts`** : parse défensif de `exercises.manuel_ref` (même
  pattern que `parseManuelRefs`).
- Pas de nouvelle route, pas de changement des états TanStack Query (les données arrivent par les
  queries existantes).

### 3.5 Rapport de couverture (lot 4)

Module **pur** `src/shared/content/manuel-coverage.ts` (même style que `program-manifest.ts` :
zéro I/O, testable) + intégration au CLI existant `scripts/content/audit-program.ts` (section
dédiée du rapport, option `--json`). Croisement, par (matière, chapitre) :

- déclaré : `manifest.chapters[].manuel` (`exerciseItems` sinon `exerciseCount` sinon Ø) ;
- repris : les `manuel.items` agrégés des `exercices/*.json` du chapitre (contenu chargé par le
  loader existant) ;
- sortie : `repris / déclaré` (+ liste nominale des restants quand `exerciseItems` existe), les
  chapitres sans `chapter.manuel` (R-9), les items tracés introuvables dans la plage déclarée
  (`[warn]` typo probable).

**Invariant : advisory only.** La couverture manuel n'entre **jamais** dans `findingCount` (qui
drive `--strict` sur les grades `sealed`) — c'est un tableau de bord de campagne, pas un gate de
régression. `content:qa` gagne un unique check structurel : `[warn]` si `exercise.manuel.pages`
sort de la plage `chapter.manuel.pages` quand les deux existent et portent le même code (typo
probable, jamais bloquant — les exercices de synthèse vivent parfois en fin de tome).

### 3.6 Sécurité & anti-triche

Surface inchangée : `manuel_ref` ne contient aucune clé (les invariants `correct_option`/
`answer_key`/`distractor_tags` server-only ne bougent pas) ; les `items` sont des libellés de
numérotation, jamais des indices de réponse (rappel dans la doctrine). RLS et grants des buckets
inchangés (lecture authentifiée, upload service-role out-of-band). Validation zod à l'authoring
(le seul point d'entrée) ; aucune server fn n'accepte de `manuel` en écriture.

### 3.7 Observabilité

Aucun événement nouveau : l'usage des missions tracées se lit dans `attempts`/
`exercise_sessions` par jointure sur `exercises.manuel_ref IS NOT NULL` (requête ad hoc admin).
Le rapport de couverture est la métrique de production de la campagne (journalisée en §8 à chaque
lot de contenu).

### 3.8 Décisions d'architecture (ADR)

- **D-1 — Doctrine transversale, pas un nouveau canal.** L'étude spécialise le pipeline existant
  (transcription é13 → fiches → skills → gates) par type de contenu du manuel ; elle ne crée ni
  studio (doublon é12), ni import automatique LLM→DB (violerait files-only + fidélité + revue).
  _Rejeté_ : un « importeur de manuel » bout-en-bout — séduisant, mais il court-circuiterait les
  gates et la barre qualité, et l'é12 possède déjà le canal.
- **D-2 — Le manuel élève est la référence de contenu ; le programme reste la référence de
  scope.** En cas de tension (exercice du manuel hors bornes du programme transcrit), le
  programme gagne (R-3 é12) ; l'écart est consigné dans la fiche §6. Le manuel prime en revanche
  sur toute source non officielle.
- **D-3 — Taxonomie fermée** (10 familles, §3.1), alignée sur le `DocumentModel` ScribeKit pour
  que la phase 2 (enrichissement de fiche) et la phase 3 (génération) parlent la même langue.
  _Rejeté_ : classer par matière (la forme de la réponse est le bon discriminant, pas la
  discipline).
- **D-4 — Mapping par forme de réponse** vers les formats existants uniquement (D-4 é12
  réaffirmée). Un besoin de format inédit = signalement vers le catalogue types-natifs, jamais un
  format ad hoc.
- **D-5 — Trois régimes de reprise (directe/adaptée/variante)**, la variante n'étant pas tracée.
  _Rejeté_ : tracer les variantes avec un flag `variant` — gonfle la couverture artificiellement
  et brouille le badge élève (« c'est l'exercice du manuel » doit rester vrai).
- **D-6 — Traçabilité au niveau exercice** (`manuel {code?, pages?, items[]}` → colonne
  `exercises.manuel_ref`), pas au niveau question. Un exercice app regroupe naturellement
  quelques exercices contigus du manuel ; la granularité question doublerait le coût d'authoring
  pour un gain d'usage nul (le badge, la galerie et la couverture opèrent à l'exercice).
  _Rejeté aussi_ : un fichier de mapping séparé hors `content/` (désynchronisable, invisible du
  build).
- **D-7 — La figure du manuel guide le redessin, jamais la copie** (réaffirme D-8 é18/D-5 é19 et
  l'étend aux planches documentaires : famille 6 du tableau — schéma SVG simplifié ou renvoi
  galerie, jamais de bitmap). La galerie « Pages du manuel » est le canal légitime de la planche
  authentique (privée, gated, non redistribuée).
- **D-8 — Les savoirs passent par les blocs é18 + cartes + Rappel é17** — pas de moteur de
  flashcards dédié. Le triplet {bloc typé, carte de résumé, question d1–2} couvre fiche de
  révision, mémorisation et défi ; le Rappel actif fournit déjà la réactivation espacée.
- **D-9 — La complétude vis-à-vis du manuel est un audit, pas un gate.** Le gate déterministe ne
  connaît pas le manuel ; c'est `content-audit` (axe complétude, lot 6) et le rapport de
  couverture (lot 4) qui mesurent — la CI ne casse jamais sur « il manque un exercice du manuel ».
- **D-10 — Priorisation de campagne : profondeur avant largeur.** Une matière × niveau par
  session (leçon PR #348, mémoire « profondeur de génération »), pilote sur la fiche la plus
  riche, extension ensuite par années de concours. Le choix nominal du pilote est Q-3.

## 4. Plan d'exécution en lots

| lot | contenu (résumé)                                                                                 | fichiers/objets créés                                                                                                                                                             | tests exigés                                                                                       | dépend de         |
| --- | ------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ----------------- |
| 1   | Doctrine de valorisation (taxonomie, mapping, régimes) + branchements skills                     | `content-engine/references/manuel-valorisation.md` ; renvois dans `generation-pipeline.md`, `content-ecole-tn/SKILL.md`, `content-ingest/SKILL.md`, `PROMPT-TRANSCRIPTION-CNP.md` | — (docs ; gates inchangés verts)                                                                   | Q-1 tranchée      |
| 2   | Traçabilité pipeline : champ `manuel` exercice + colonne + manifest                              | `schema.ts`, `loader.ts`, `sql-builder.ts`, `program-manifest.ts`, migration `*_exercises_manuel_ref.sql`                                                                         | Vitest schema/loader/sql-builder/manifest ; suite pgTAP (migration propre)                         | —                 |
| 3   | ⛔ **ABANDONNÉ** (arbitrage Q-2, 2026-07-20) — surface élève : badge hub + mention player + i18n | `subject-hub.tsx`, `exercise-player.tsx`, `manuel-refs.ts`, `quest.server.ts` (projection), i18n fr/en/ar                                                                         | Vitest composants (badge présent/absent, RTL, anon)                                                | 2                 |
| 4   | Rapport de couverture (module pur + CLI, advisory)                                               | `src/shared/content/manuel-coverage.ts`, `scripts/content/audit-program.ts` (+ check `[warn]` pages dans `qa-checks.ts`)                                                          | Vitest pur (fixtures 3 niveaux de précision, invariant hors `findingCount`)                        | 2                 |
| 5   | Pilote contenu : reprise des exercices du manuel sur 3 chapitres d'une matière (Q-3)             | fiche/manifest enrichis (items), `content/<subject>/…/exercices/*`, **1** migration `--subject`, rapport de couverture avant/après                                                | gates contenu (`content:check`, `content:qa:strict` 0 erreur) + self-verification `quality-bar.md` | 1–4 ; Q-1/Q-2/Q-3 |
| 6   | Passe savoirs pilote (R-8) + axe « complétude manuel » dans `content-audit`                      | blocs/cartes complétés sur la matière pilote ; `content-audit/SKILL.md` (axe)                                                                                                     | gates contenu ; échantillon d'audit joint à la PR                                                  | 5                 |

- [ ] **Lot 1 — Doctrine.** Rédiger `manuel-valorisation.md` (normatif : §3.1 intégral + R-1→R-12 + régimes D-5 + exemples par matière — 1 maths, 1 SVT, 1 langue) ; brancher les renvois (une
      ligne chacun, pas de duplication). **Stop-point** : aucun code, aucun fichier `content/`.
- [ ] **Lot 2 — Traçabilité.** Schéma + loader (héritage code chapitre, erreur si irrésoluble) +
      sql-builder + migration additive + extension manifest. Critères : `content:check` passe sur
      le contenu existant inchangé (champ optionnel), un fixture avec `manuel` compile la bonne
      colonne, UUID inchangés (aucune régénération de masse). **Stop-point** : ne pas toucher au
      client ni régénérer de migration de subject existant.
- [ ] **Lot 3 — Surface élève — ⛔ ABANDONNÉ (arbitrage Q-2, 2026-07-20).** La provenance manuel
      n'est pas affichée à l'élève : badge 📘 du hub, mention du player et clés i18n
      `manuelMissionBadge`/`manuelMissionHint`/`manuelMissionFrom` sont **abandonnés, pas
      reportés** ; US-1/US-2 tombent, US-3 devra passer par un autre véhicule. La spécification
      d'origine (§2 i18n, §3.3–3.4) reste consignée **pour mémoire seulement** — rien à exécuter,
      la traçabilité `manuel_ref` du lot 2 n'a plus qu'un consommateur, le rapport de couverture
      (lot 4). _Périmètre d'origine, pour référence_ : badge + mention + i18n (US-1/US-2, R-12).
- [ ] **Lot 4 — Couverture.** Module pur + CLI + `--json` + check `[warn]` pages (US-4, D-9,
      §3.5). Critères : les trois niveaux de précision rendent ; `findingCount` inchangé sur tous
      les manifests existants ; `ci:verify` vert sans nouveau finding. **Stop-point** : rien dans
      `content:qa:strict` en niveau error.
- [ ] **Lot 5 — Pilote.** Sur la matière arbitrée en Q-3 (recommandation : `math-1ere-sec`,
      manuels `222104P01/P02`) : enrichir fiche + manifest (liste d'exercices de 3 chapitres — si
      la fiche n'a pas la profondeur, passe vision ciblée sur les renders existants via le flux
      `content-ingest`, coût borné à ces chapitres), reprendre selon la doctrine (missions
      tracées, régimes déclarés dans la PR), publier le rapport avant/après + le coût constaté
      (KPI) au journal §8. **Stop-point** : 3 chapitres maximum, une seule matière, une seule
      migration `--subject`.
- [ ] **Lot 6 — Savoirs.** Passe R-8 sur la matière pilote (encadrés → blocs + cartes + questions
      d1–2 là où testable) ; ajouter l'axe « complétude manuel » à `content-audit` (activable
      seulement quand la fiche programme du couple existe). **Stop-point** : pas de réécriture des
      cours au-delà de l'insertion des blocs manquants (le style relève de `content-cours`).

**Après l'étude** : la campagne continue (une matière × niveau par session, concours en tête selon
Q-3), pilotée par le rapport de couverture — même modèle que la campagne d'illustration é18/é19.

## 5. Stratégie de test

- **Vitest (co-localisés)** : `schema.test` (formes valides/invalides du champ `manuel`, héritage
  du code chapitre, erreur si irrésoluble) ; `sql-builder.test` (émission `manuel_ref`,
  idempotence, stabilité UUID) ; `program-manifest.test` (champ optionnel, rétro-compat des 11
  manifests réels) ; `manuel-coverage.test` (fixtures aux 3 niveaux de précision, agrégation
  items, invariant advisory) ; composants (`subject-hub` badge tracé/non tracé/anon/RTL,
  `exercise-player` mention).
- **pgTAP** : la suite existante prouve l'application propre de la migration sur DB fraîche ;
  aucune logique SQL nouvelle (pas de RPC) donc pas de test pgTAP dédié au-delà.
- **Gates contenu** : `content:check` + `content:qa:strict` = 0 erreur sur l'existant (champ
  optionnel, aucune migration de masse) puis sur le pilote ; `content:audit` inchangé
  (`findingCount` stable — testé).
- **E2E/smoke** : pas de spec Playwright nouvelle (surface mineure) ; `smoke:shell` couvre le
  bundle (le badge est du rendu pur).
- **Non-régression** : le lot 2 est prouvé inoffensif par « contenu existant inchangé → mêmes
  migrations générées » (diff vide sur un `content:build --subject` témoin) ; le lot 3 par les
  tests composants sans `manuel_ref` (chemin nul).

## 6. Risques & mitigations

- **RISK-1 — Droits d'auteur (le plus sérieux).** Le repo est public et l'app sert le contenu
  sans login ; reprendre verbatim des énoncés à grande échelle expose. _Mitigation_ : Q-1 arbitré
  avant le lot 1 ; défaut = régime adapté (reformulation, mêmes données) ; textes tiers jamais
  reproduits (R-11) ; scans confinés aux buckets privés ; la traçabilité `items` reste factuelle
  (numéros, pas le texte source).
- **RISK-2 — Reprise de mauvaise qualité** (un exercice papier mal QCM-isé devient une question
  devinable ou ambiguë). _Mitigation_ : la barre qualité s'applique sans exemption (R-2, R-5,
  self-verification, double-solve) ; le mapping D-4 impose le format le plus proche de la forme
  papier (natifs d'abord, jamais de QCM forcé quand `numeric`/`matching`/`ordering` colle) ;
  `content-audit.yml` (bihebdo) re-résout tout contenu récent.
- **RISK-3 — Doublons avec les 18 708 questions existantes.** _Mitigation_ : R-5 (audit d'échelle
  d'abord) ; le rapport de couverture rend le « déjà couvert par du maison » visible chapitre par
  chapitre avant génération.
- **RISK-4 — Fiches sans profondeur exercices** (la plupart listent le chapitrage, pas chaque
  exercice). _Mitigation_ : enrichissement incrémental par chapitre AU moment de la reprise
  (passe vision ciblée sur les renders existants, flux `content-ingest`) — jamais de campagne de
  re-transcription massive préalable ; les 3 niveaux de précision du manifest absorbent l'état
  intermédiaire.
- **RISK-5 — Dérive de scope** (« tout le manuel dans l'app »). _Mitigation_ : taxonomie fermée
  (D-3), familles ⛔ explicites, hors-périmètre §2, lots 5–6 bornés à 3 chapitres/1 matière, le
  reste = campagne cadencée hors étude.
- **RISK-6 — Codes/tomes instables** (rééditions CNP, multi-tomes). _Mitigation_ : les codes CNP
  du `CATALOGUE.md` local font foi (identité stable du corpus téléchargé) ; `label` par tome déjà
  supporté ; un changement d'édition = nouveau code = nouvelle déclaration, l'ancienne reste
  valide pour l'ancien PDF hébergé.

## 7. Questions ouvertes (pour l'humain)

> **Section arbitrée le 2026-07-20 (Mohamed).** Q-1, Q-3 et Q-4 ont suivi les recommandations de
> l'architecte ; **Q-2 s'en écarte** — la provenance manuel ne sera pas affichée à l'élève.
> L'étude est passée `validée` ; aucune question n'est plus ouverte.

- **Q-1 — Politique de verbatim des énoncés (posture de risque).** Le régime par défaut est
  l'adaptation (reformulation, mêmes données). Autorise-t-on la reprise **mot à mot** d'énoncés
  d'exercices du CNP dans le contenu versionné (repo GitHub public + app publique sans login) ?
  Options : (a) jamais — tout passe par l'adaptation ; (b) verbatim toléré pour les énoncés
  techniques courts non créatifs (consignes de calcul standard), adaptation partout ailleurs —
  **recommandation architecte** ; (c) verbatim libre (posture « documents d'État à diffusion
  publique », cohérente avec l'hébergement des PDF mais juridiquement plus exposée). L'arbitrage
  conditionne le lot 1 (la doctrine l'écrit noir sur blanc).
  **Arbitrage : option (b) — recommandation retenue.** Verbatim toléré pour les **énoncés
  techniques courts non créatifs** (consignes de calcul standard) ; **adaptation — reformulation,
  mêmes données — partout ailleurs**, le régime (b) de D-5 restant le défaut. Cet arbitrage est
  une **posture de risque assumée, pas un avis juridique** : l'étude ne contient aucune analyse de
  droit et n'en tient pas lieu. **R-11 reste entière et n'est pas touchée par Q-1** : jamais de
  bitmap/scan de manuel dans le contenu versionné ni dans le repo public, scans confinés aux
  buckets privés gated (`manuel-eleve`, `manuel-pages`) ; extraits littéraires des manuels de
  langue jamais repris verbatim ; corrigés des guides enseignants jamais copiés verbatim. Fait
  connexe qui **réduit** l'exposition décrite en RISK-1 sans l'annuler : l'**étude 24 sort
  `content/` du repo public** (lots 4–5) — la branche « le repo est public » de RISK-1 s'éteint à
  ce moment-là ; la branche « l'app sert le contenu sans login » demeure. Conséquence : **le lot 1
  (doctrine) est ferme**, et `manuel-valorisation.md` écrit ce régime noir sur blanc.
- **Q-2 — Badge élève « Manuel ».** Afficher la provenance à l'élève (badge 📘 hub + mention
  player — **recommandation** : oui, c'est l'argument de confiance parent) ou garder la
  traçabilité interne (auteurs/rapport seulement) ? Si oui, valider le wording trilingue proposé
  (§2 i18n) au registre Référence.
  **Arbitrage : non — la recommandation de l'architecte n'est PAS retenue.** La provenance
  **n'est pas affichée à l'élève** : la traçabilité reste **interne** (auteurs + rapport de
  couverture). Le champ `manuel` → `exercises.manuel_ref` du lot 2 est **conservé tel quel** —
  c'est son **exposition** qui est refusée, pas son existence. Conséquences :
  - le **lot 3 « Surface élève » devient sans objet** — badge 📘 du hub, mention du player et
    clés i18n `manuelMissionBadge`/`manuelMissionHint`/`manuelMissionFrom` : **abandonnés, pas
    reportés** (le lot est marqué comme tel au §4, il n'est pas supprimé) ;
  - **US-1 et US-2 tombent** ; **US-3** (le parent cherche la conformité au manuel officiel)
    n'est plus servie par une surface élève et devra, si elle est reprise un jour, passer par un
    autre véhicule ;
  - les **KPI d'usage adossés au badge** (« les missions tracées 📘 sont jouées au moins autant
    que les missions maison ») sont sans objet ; le **rapport de couverture (lot 4) devient le
    seul consommateur** de `manuel_ref` ;
  - la dépendance du **lot 5** à « Q-1/Q-2/Q-3 » est **satisfaite** : Q-2 tranchée en « non » ne
    bloque pas le pilote.
- **Q-3 — Matière pilote & ordre de campagne.** Recommandation : pilote `math-1ere-sec` (fiche la
  plus profonde — 16 chapitres, manuels `222104P01/P02` au corpus, matière 16/16 fraîche, vague A
  é16 en cours) puis années de concours (6ᵉ maths — fiche `[~]` ; 9ᵉ maths — fiche à transcrire
  d'abord ; bac) ; alternative : commencer par 6ᵉ/9ᵉ (concours d'abord, cohérent avec é19) au prix
  d'une transcription préalable. Trancher aussi la place des petites classes (la priorité
  « illustration » y reste n° 1 ; la reprise d'exercices y est moins différenciante).
  **Arbitrage : recommandation retenue** — pilote **`math-1ere-sec`** (fiche la plus profonde,
  16 chapitres, manuels `222104P01`/`222104P02` au corpus, matière fraîche, vague A é16 en cours),
  puis les années de concours : 6ᵉ maths, 9ᵉ maths (fiche à transcrire d'abord), bac. Sur la
  sous-question des **petites classes** (laissée sans recommandation par l'architecte) : elles
  restent **derrière** — la priorité « illustration » y demeure n° 1 et la reprise d'exercices y
  est moins différenciante. **Le lot 5 est ferme sur `math-1ere-sec`.**
- **Q-4 — Activités d'exploration/manipulations.** Hors périmètre v1 (**recommandation** : oui —
  famille ⛔ documentée, réévaluée quand le catalogue de formats s'étendra) ou reformulation
  systématique en histoire-problème (coût élevé, fidélité discutable) ?
  **Arbitrage : recommandation retenue** — **hors périmètre v1** : les activités d'exploration et
  de manipulation restent une famille ⛔, **documentée avec sa raison dans la fiche** (R-4,
  « aucune couverture silencieuse »), réévaluée quand le catalogue de formats s'étendra. Cet
  arbitrage vaut mitigation de RISK-5 (dérive de scope).

## 8. Journal d'exécution

- **2026-07-20 — Validation.** Q-1…Q-4 arbitrées par Mohamed ; statut `brouillon` → `validée`.
  Q-1 (verbatim), Q-3 (pilote) et Q-4 (activités d'exploration) suivent les recommandations de
  l'architecte ; **Q-2 s'en écarte** — la provenance reste interne, d'où l'abandon du lot 3
  (surface élève). Lots exécutables : 1, 2, 4, 5, 6. Aucun lot commencé.

_(rempli au fil des lots par l'exécuteur : date, lot, PR, écarts acceptés, dettes notées)_

# MÉTHODE — Génération de contenu : la référence (source → fiche → contenu → prod)

> **LA méthode.** Toute production de contenu pédagogique à partir d'une source — corpus CNP,
> manuel du secondaire, PDF d'enseignant, polycopié, annales papier — suit ce document, de la
> transcription à la mise en prod, quel que soit l'exécutant : session Claude Code interne (le
> skill `content-ingest` l'applique nativement), agent IA d'un contributeur externe, campagne
> opérée. Elle est **générique** (quatre profils de source, § Profils), **résumable** (elle
> reprend exactement où la work-list en est) et **budgétée** (charte tokens T-1…T-10 : le coût
> par chapitre publié est un KPI mesuré, pas un hasard — et rien ne reste longtemps non poussé).
>
> Ce document **remplace** `PROMPT-TRANSCRIPTION-CNP.md` (consolidation du 2026-07-17) et porte
> le processus des études [12 — Studio d'ingestion](./12-studio-ingestion/ETUDE.md) (le canal)
> et [13 — Moteur de transcription ScribeKit](./13-moteur-transcription/ETUDE.md) (le moteur,
> **livrée**).
>
> **Périmètre d'autorité.** Cette méthode est la référence du **processus** : la boucle, les
> lots, les gates, l'économie de tokens. Les règles d'**authoring** (schéma, barre de qualité,
> récompenses, notation, sélection des skills) restent chez les skills — carte canonique :
> `.claude/skills/content-engine/references/generation-pipeline.md`, consommée par le LOT B.
> Hiérarchie en cas de désaccord : **CLAUDE.md → skills & docs normatifs → cette méthode**.
>
> **Pour qui ?** Un agent IA avec vision + accès fichiers + git (Claude Code ou équivalent),
> piloté par un contributeur qui peut ne rien connaître du projet : copier ce document **en
> entier**, INPUT rempli, dans l'agent — et laisser la campagne se dérouler. Un accès
> **collaborateur (write)** au dépôt `MBeji/yahia-quest-arena` est requis pour pousser (le
> demander à Mohamed) ; à défaut, terminer chaque lot par un fork + PR classique.

---

## INPUT (l'unique chose à renseigner)

```
PORTEE     : tout               # défaut — tous les couples manquants, dans l'ordre de priorité
                                # (§ Phase 0.4). Restreindre : "1ere-sec" (une classe/section),
                                # "lycee" (le cycle), "9eme-base / math" (un couple).
PROFIL     : auto               # auto (défaut) = déduit du niveau et des sources ; sinon forcer :
                                # ecole-cnp | ecole-secondaire | document-libre | sans-source
FICHIERS   : <chemins locaux>   # optionnel — PDF déjà en local (guide et/ou manuel élève, ou le
                                # document libre), séparés par des espaces. Vide = téléchargement
                                # depuis le site du CNP, couple par couple.
GENERATION : oui                # oui (défaut) = LOT B (contenu) après chaque fiche mergée ;
                                # non = s'arrêter aux fiches (couche de persistance seule).
PSEUDO     : <pseudo GitHub>    # traçabilité (_INDEX.md + commits).
BUDGET     : <optionnel>        # plafond de la session (tokens ou temps) ; la campagne s'arrête
                                # proprement en fin de lot à l'approche du plafond (T-9).
```

## La boucle (vue d'ensemble)

```
PHASE 0 (une fois par campagne) : setup + cadrage + file de travail (ordre de priorité)
pour chaque UNITÉ de la file (couple niveau × matière, ou document libre) :
  LOT A — LA FICHE   : A1 existant → A2 sources → A3 transcription (ScribeKit + vision)
                       → A4 profondeur de génération → A5 audits (QA, R-7, _INDEX)
                       → A6 push → 1 PR (auto-merge) → merge confirmé
  si GENERATION = oui :
  LOT B — LE CONTENU : B1 brief + skills → puis PAR TRANCHE de ≤4 chapitres complets :
                       B2 génération (commit local par chapitre) → B3 gates + migration
                       + push → 1 PR → merge + prod vérifiée → tranche suivante,
                       jusqu'à la matière complète
  contexte frais → unité suivante
fin : PORTEE épuisée, ou arrêt propre (BUDGET) → rapport de campagne
```

Règles de boucle (non négociables) :

- **Une PR = UNE matière, jamais deux** (ni push groupé « 10 fiches d'un coup » — c'est le
  signe qu'on va trop vite, R-6). Le LOT A tient en une PR ; le LOT B se livre en **plusieurs
  PRs par tranches de chapitres** (T-10, B2/B3) — plusieurs PRs pour une matière, jamais
  plusieurs matières dans une PR.
- **Un lot = un contexte frais** : si le harnais le permet (sous-agents/Task), déléguer chaque
  lot à un sous-agent au contexte vierge et garder le rôle d'orchestrateur mince ; sinon,
  traiter strictement en séquence (T-4).
- **Resynchroniser à chaque lot** : branche fraîche depuis `origin/main` fetchée (commandes
  exactes en A1 / B1), puis relire **depuis main** la ligne `_INDEX.md` du couple — un autre
  contributeur a pu avancer pendant le lot précédent.
- **Attendre le merge réel** d'un lot avant d'entamer le suivant (le LOT B dépend de la fiche
  mergée ; deux PR simultanées sur `_INDEX.md` se marchent dessus). ⚠️ Ce dépôt **auto-merge** :
  pousser une branche ouvre une PR **prête, auto-merge armé**, qui se merge seule quand les
  checks CI sont verts. Ne pousser qu'un lot fini ; point de sauvegarde : branche `wip/…`
  (PR draft).

## Le socle R (hérité du skill `content-ingest` — condensé, non négociable)

- **R-1 — Rien ne contourne le pipeline.** Sortie = TOUJOURS des fichiers versionnés sur une
  branche + gates + revue humaine. Aucune écriture DB directe, aucun skip d'audit.
- **R-2 — Provenance & droits.** Le corpus officiel (CNP / manuels scolaires) est la source
  prévue ; tout autre document porte auteur / origine / autorisation, sinon **refus**. Doute ⇒
  STOP. Pas de verbatim d'œuvres périphériques sous droits (chansons, textes littéraires
  longs) : résumer + citer la référence.
- **R-3 — Programme d'abord.** Pour une matière scolaire, confronter la fiche à la
  transcription CNP du couple si elle existe ; divergence de scope ⇒ le **programme officiel
  gagne**, écart signalé.
- **R-4 — Vérifier l'existant AVANT, dans le REGISTRE.** L'état de la transcription vit dans le
  **registre machine-vérifiable** `programmes-officiels/suivi/` (`corpus-cnp.json` +
  `affectations.json` + `<grade>.json`), validé en CI par `npm run programme:check` —
  `programme/_INDEX.md` n'est qu'une **vue générée** (⛔ ne jamais l'éditer à la main). Une
  entrée `complete`/`validee-r7`/`promue` = **déjà fait** ; `partielle` = **compléter** (les
  plages de pages manquantes sont listées), jamais refaire en parallèle. Un PDF ne peut être
  revendiqué que par UNE fiche — le doublon est une **erreur CI**, plus un risque.
- **R-5 — Profondeur de génération, jamais un résumé.** Chaque activité/exercice décrit
  individuellement, encadrés officiels verbatim, vocabulaire officiel, bornes ✅/⛔. Modèle de
  référence : `programme/1ere-sec/mathematiques.md`. Une « first-pass » s'étiquette comme telle
  et ne se génère pas.
- **R-6 — Une session = une matière, lecture intégrale.** Jamais de plafond arbitraire de
  lecture (l'incident du 2026-07-10 : lectures tronquées à 70 k ⇒ fiches truffées
  d'inventions). Partiel honnêtement étiqueté > complet bâclé.
- **R-7 — Vérification indépendante avant promotion.** Un second agent re-vérifie la fiche
  **contre la source** (jamais contre la fiche) — protocole de sondage dirigé en A5.2.
- **Fidélité ≠ génération.** LOT A : on transcrit ce qui est imprimé, rien d'autre. LOT B : on
  génère **avec les skills du dépôt**, jamais sa propre recette.

## La charte tokens (T-1…T-10) — l'économie de la méthode

Le coût d'une campagne se joue sur une poignée de comportements. Chaque règle T ci-dessous est
aussi contraignante que les règles R : un agent qui les viole gaspille le budget qui aurait
publié le chapitre suivant.

- **T-1 — Le déterministe est gratuit : ne le refais jamais au LLM.** ScribeKit extrait les
  couches-texte, échafaude, valide (`qa`), trace (`status`/ledger) ; les scripts du dépôt
  valident et compilent le contenu. Re-lire en vision un PDF à couche-texte saine, re-vérifier
  à l'œil ce que `scribekit qa`/`content:qa` vérifie, ou écrire du SQL à la main = brûler du
  budget pour rien.
- **T-2 — Une page source n'est lue qu'une fois.** Transcrire **par tranches de 10–20 pages** :
  lire la tranche → écrire immédiatement sa transcription **au format final** (le gabarit) —
  jamais de notes intermédiaires jetables, jamais « tout lire puis rédiger » (c'est la double
  lecture assurée, et la troncature de l'incident 2026-07-10). DPI utile : 150 par défaut, 300
  seulement pour petits caractères / figures denses.
- **T-3 — La fiche est le capital.** Tout le coût vision est capitalisé dans la fiche ; après
  son merge, les PDF ne sont **plus jamais rouverts** — génération, corrections et audits de
  contenu se font depuis la fiche. (Seule re-lecture de source légitime : le R-7 du LOT A.)
- **T-4 — Un lot = une matière = un contexte frais.** Deux matières dans une même fenêtre =
  le budget de lecture de chacune dilué + le cadrage payé deux fois. Sous-agents pour les lots,
  orchestrateur mince pour la boucle.
- **T-5 — En génération, l'unité de travail = le chapitre.** Chaque chapitre est généré avec :
  le **brief matière** (T-6) + **LA section de la fiche** couvrant ce chapitre (le chapitrage
  §4 / le manifeste découpent la fiche exprès pour ça) — jamais la fiche entière (70–200 k)
  dans le contexte de chaque chapitre.
- **T-6 — Le cadrage se paie une fois.** Par **campagne** : les docs de cadrage se lisent en
  Phase 0, pas à chaque lot. Par **matière** : préparer une fois un **brief matière** (~1 page :
  scope exact, terminologie officielle, calibrage âge, langue, pièges connus, conventions du
  sujet) réutilisé par tous les chapitres. Par **lot** : ne relire que la ligne `_INDEX.md` du
  couple + la fiche cible.
- **T-7 — Charger une règle quand elle sert.** La carte (`generation-pipeline.md`) d'abord ;
  chaque `references/*` seulement au besoin réel du chapitre en cours (`interactive-formats.md`
  si mission interactive ; `expert-exercises.md` si d3–4 / `prof-*` ; `course-figures.md` quand
  on illustre).
- **T-8 — R-7 par sondage dirigé, pas par re-lecture intégrale.** 100 % du critique + ≥15 % du
  reste, escalade en re-lecture intégrale dès 3 erreurs substantielles (protocole A5.2). Une
  re-lecture complète par défaut doublerait le coût vision de la campagne ; un skip viderait la
  garantie.
- **T-9 — Budget déclaré, arrêt propre, coût mesuré.** À l'approche du plafond (BUDGET, ou la
  fenêtre de contexte) : finir proprement le lot en cours, étiqueter la profondeur atteinte,
  pousser, s'arrêter — la campagne reprend où `_INDEX.md` / le ledger en sont. Chaque lot
  **rapporte son coût** (tokens in/out si le harnais les expose, sinon pages lues / volume
  écrit) : le coût par chapitre publié est le KPI de l'étude 12 — il se mesure, il ne s'estime
  pas.
- **T-10 — Des livrables courts et fréquents : jamais une longue session sans PR.** Le travail
  d'une session coupée avant son push est perdu à 100 % — la pire dépense token possible. En
  **LOT B** : commit local après **chaque chapitre complet**, push en PR par **tranche de ≤4
  chapitres** (B2/B3) — on ne retient jamais une matière entière non poussée. En **LOT A** :
  quand la session doit finir, la fiche partielle **honnêtement étiquetée se pousse** (arrêt
  propre, A3.4) plutôt que de viser le « tout » dans une session à risque. Interruption
  imminente au milieu d'un chapitre ou d'une tranche ⇒ push de sauvegarde en branche `wip/…`
  (PR draft, pas d'auto-merge), que la session suivante reprend.

## Profils de source

| Profil               | Quand                                                                | Sources                                                                                                                   | Livrable fiche (LOT A)                                                                                                                                                              | Work-list                                                                                                |
| -------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **ecole-cnp**        | cycle de base (`1ere-base` → `9eme-base`)                            | guide enseignant CNP (`5…`) **+** manuel élève (`1…`), **combinés**                                                       | `programme/<niveau>/<matière>.md` + `manifest/<niveau>.json`                                                                                                                        | `programme/_INDEX.md` (couples `[ ]`)                                                                    |
| **ecole-secondaire** | lycée (`1ere-sec` → `bac-*`)                                         | manuel élève du secondaire (`2…`) + programme officiel du ministère s'il est publié ; **manuel seul ⇒ il fait référence** | idem ecole-cnp (les sections sont des nœuds `grades` ; slugs de [`docs/lycee-architecture.md`](../docs/lycee-architecture.md))                                                      | matrice sections × matières de `docs/lycee-architecture.md` ; **créer** la ligne `_INDEX.md` dans le lot |
| **document-libre**   | PDF d'enseignant, polycopié, annales papier — tout doc hors corpus   | le document lui-même (**droits R-2 vérifiés** : auteur, origine, autorisation)                                            | école : `programmes-officiels/sources-externes/<slug>/fiche.md` ; hors école : `content/_sources/<theme>/<slug>/fiche.md` — **même gabarit** `_TEMPLATE.md` + en-tête de provenance | — (la PR trace ; pas de ligne `_INDEX.md`)                                                               |
| **sans-source**      | la fiche existe (`[~]`/`[x]`) mais le contenu manque sous `content/` | aucune (la fiche mergée)                                                                                                  | — (sauter le LOT A)                                                                                                                                                                 | `content/CATALOGUE.md` (sujets existants)                                                                |

Notes par profil :

- **ecole-cnp.** Guide enseignant = le **programme** (scope, compétences, progression, bornes) ;
  manuel élève = le **contenu enseigné** (leçons, exemples, exercices). Divergence ⇒ le guide
  fait foi (signaler §5). Décodage du code à 6 chiffres : 1er chiffre = rôle/cycle (`5` guide
  base, `1` manuel base, `2` secondaire) · chiffres 2-3 = matière · chiffre 4 = classe (guide
  `502304` ↔ manuel `102304`). Téléchargement :
  `https://www.cnp.com.tn/arabic/PDF/<code>P00.pdf` (parfois `P01`/`P02`, multi-tomes) ; corpus
  local déjà téléchargé : `cnp-officiel/CATALOGUE.md`. ⚠️ Le site CNP bloque parfois les
  requêtes automatisées (403/WAF) : demander les PDF au contributeur (champ `FICHIERS`) et
  **continuer la campagne** avec les couples suivants.
- **ecole-secondaire.** Le corpus secondaire n'est pas indexé par les codes guides du cycle de
  base : chercher d'abord `cnp-officiel/CATALOGUE.md`, puis le site CNP, sinon `FICHIERS`.
  Manuel élève seul ⇒ il fait référence — le signaler explicitement dans la fiche. **Aucune
  source officielle trouvable ⇒ STOP** (jamais d'invention). En LOT B, les matières
  scientifiques s'écrivent en **français natif, dans le jargon des manuels officiels — jamais
  une traduction** (décision 2026-07-13) ; sections, slugs et ids : `docs/lycee-architecture.md`.
- **document-libre.** Checklist droits **avant tout token** : auteur identifié, origine,
  autorisation écrite (ou corpus officiel) — sinon refus (R-2). La fiche porte un en-tête de
  provenance (auteur, origine, autorisation, date) ; les `sources[]` du chapitre généré
  citeront le document. R-3 : si une transcription CNP du couple existe, confronter — le
  programme gagne.
- **sans-source.** Vérifier que la fiche est bien à **profondeur de génération** (R-5 — une
  first-pass ne se génère pas), puis dérouler directement le LOT B.

## Phase 0 — bootstrap (une fois par campagne, T-6)

1. **Cloner + installer l'app** :

   ```bash
   git clone https://github.com/MBeji/yahia-quest-arena.git && cd yahia-quest-arena
   npm install   # Node 22 / npm 10 — installe aussi les hooks git (Prettier au commit, verify au push)
   ```

2. **Cloner + builder ScribeKit** (moteur déterministe — 0 LLM, 0 clé API) :

   ```bash
   git clone https://github.com/MBeji/ScribeKit.git ../ScribeKit
   (cd ../ScribeKit && npm install && npm run build)
   alias scribekit="node $(pwd)/../ScribeKit/dist/bin.js"
   ```

3. **Lire le cadrage — maintenant, pas à chaque lot** :
   - `programmes-officiels/programme/README.md` (spec de la couche de persistance + « Recette »
     de génération — la procédure normative du LOT B) ;
   - `programme/_TEMPLATE.md` (le gabarit de fiche) + un modèle abouti :
     `programme/1ere-sec/mathematiques.md` ;
   - `.claude/skills/content-ingest/SKILL.md` (les règles R intégrales — elles s'appliquent à
     toi) ;
   - si `GENERATION: oui` : `.claude/skills/content-engine/references/generation-pipeline.md`
     (la carte des skills du LOT B).

   L'espace de travail des fiches, dans le dépôt :

   ```
   .claude/skills/content-ecole-tn/references/programmes-officiels/
   ├── suivi/corpus-cnp.json                    ← corpus CNP exhaustif (346 PDF — généré, ne pas éditer)
   ├── suivi/affectations.json                  ← catégorie de chaque matière/PDF (décisions)
   ├── suivi/<grade>.json                       ← REGISTRE d'état des fiches (LA source de vérité)
   ├── programme/_INDEX.md                      ← vue GÉNÉRÉE du registre (⛔ ne pas éditer)
   ├── programme/_TEMPLATE.md                   ← gabarit de la fiche
   ├── programme/README.md                      ← spec + « Recette » (LOT B)
   ├── programme/<niveau>/<matière>.md          ← livrable LOT A (profils ecole-*)
   ├── sources-externes/<slug>/fiche.md         ← livrable LOT A (document-libre, école)
   └── manifest/<niveau>.json                   ← chapitrage machine-vérifiable (Zod)
   ```

   Trois commandes gouvernent le registre : `npm run programme:check` (le gate — schémas +
   anti-doublon + cohérence disque↔registre↔index, exécuté en CI), `npm run programme:index`
   (régénère la vue), `npm run programme:corpus` (resynchronise le snapshot corpus depuis
   `cnp-officiel/catalogue.csv`, machine locale uniquement).

4. **Construire la file de travail**, dans l'**ordre de priorité** (décision 2026-07-14 — le
   lycée d'abord : c'est le gros trou du corpus, le cycle de base est largement couvert) :
   1. **`1ere-sec`** — tronc commun, pas de section : le plus fort levier ; la finir avant la
      suite ;
   2. **`2eme-sec-*`**, section par section (`sciences` · `lettres` · `eco-services` · `info`) —
      une section entièrement terminée avant d'ouvrir la suivante ;
   3. **`3eme-sec-*`** (`math` · `sciences-exp` · `lettres` · `eco-gestion` · `techniques` ·
      `info`) ;
   4. **`bac-*`** (`math` · `sciences-exp` · `lettres` · `eco-gestion` · `techniques` · `info`) ;
   5. seulement ensuite, le **reliquat du cycle de base** (`1ere-base` → `9eme-base`).
   - Source de la file : le § « **À transcrire (dérivé du corpus)** » de l'`_INDEX.md` généré —
     la liste **exhaustive** des œuvres principales non rattachées, calculée depuis
     `suivi/corpus-cnp.json` (au secondaire, préciser la section avec la matrice de
     `docs/lycee-architecture.md`) ; les entrées `partielle` du registre (trous listés) font
     aussi partie de la file.
   - **Matières annexes hors périmètre pour le moment** : musique, éducation artistique/dessin,
     EPS/sport, la section sport, les 3èmes langues (allemand, espagnol, italien). Les sauter
     même si leur ligne est `[ ]` ; un `PORTEE` qui les cible explicitement se **refuse** avec
     rappel de cette règle.
   - **Annoncer la file** au contributeur (nombre de lots, ordre retenu, couples sautés et
     pourquoi), puis démarrer la boucle.

---

## LOT A — la fiche (phases 1-2)

### A1 — Vérifier l'existant (R-4)

Branche fraîche :

```bash
git fetch origin main && git checkout -B feat/transcription-<niveau>-<matiere> origin/main
```

Puis, **dans le registre frais** (`suivi/<grade>.json`, complété par la vue `_INDEX.md`
générée) — et en vérifiant qu'**aucune autre session ne travaille déjà le couple** :
`gh pr list --search "<niveau> <matière>"` + branches distantes
`feat/transcription-<niveau>-*` (une PR/branche ouverte sur le couple ⇒ couple pris, passer au
suivant) :

- entrée `complete` / `validee-r7` / `promue` ⇒ **déjà fait**. Si `GENERATION: oui` et que le
  sujet n'existe pas sous `content/` (vérifier `content/CATALOGUE.md`) ⇒ passer directement au
  **LOT B** (profil sans-source) ; sinon couple suivant.
- entrée `partielle` ⇒ la **compléter** — le registre liste les **plages de pages manquantes**
  et la profondeur atteinte ; jamais refaire en parallèle, jamais relire les pages déjà à
  profondeur (T-2/T-3).
- **aucune entrée** (vrai manquant — le § « À transcrire » de l'_INDEX généré liste les PDF
  disponibles du couple) ⇒ continuer ; l'entrée sera créée en A5.4.

### A2 — Obtenir les sources

Selon le profil (§ Profils) : **combiner toutes les sources officielles disponibles** (guide
enseignant + manuel élève) ; une seule disponible ⇒ elle fait référence (le signaler dans la
fiche). `FICHIERS` fournis ⇒ identifier qui est guide / qui est manuel par le code à 6
chiffres. Téléchargement bloqué ⇒ demander les PDF et continuer avec les couples suivants.
**Jamais de contenu inventé faute de source.**

### A3 — Transcrire (phase 1 : ScribeKit + ta vision)

1. **ScribeKit d'abord** (T-1 — il extrait le déterministe, échafaude au gabarit, crée/valide le
   manifeste) :

   ```bash
   # profils ecole-* :
   scribekit app-cnp <guide.pdf> [<manuel.pdf>] --grade <niveau> --subject <subject-id> \
     --lang <ar|fr|en> -o .claude/skills/content-ecole-tn/references/programmes-officiels
   # profil document-libre :
   scribekit transcribe <doc…> -o <emplacement de la fiche> --profile markdown
   ```

   (`<subject-id>` : convention du README programmes-officiels § identifiants — ex. `math-3eme`,
   `arabic-5eme` ; en cas de doute, proposer + signaler dans la fiche.)

2. `scribekit status <cible>` liste les unités **`pending`** (scans à couche-texte cassée — le
   cas général du corpus CNP). Pour chacune : lire les pages **en vision** et transcrire **par
   tranches de 10–20 pages, écriture immédiate au format final** (T-2). DPI 150 par défaut
   (`render.sh` → PNG si besoin de le maîtriser). ⚠️ **Pas de clé API** : l'OCR passe par TA
   vision d'agent (abonnement) ; le `--provider anthropic` de ScribeKit est un mode batch
   **facturé** — uniquement si le contributeur fournit une clé et le demande.

3. **Fidélité absolue** : transcrire **ce qui est imprimé**, rien d'autre. Illisible ⇒ `[?]` +
   note en § Incertitudes, jamais deviné ; coquille source ⇒ `[sic]`. **Chiffres occidentaux
   (0-9) partout** — y compris dans le texte arabe, jamais ٠١٢٣ — équations LTR, unités SI,
   Markdown arabe bidi-safe. **Citer les pages, par source** (guide vs manuel) : la fiche doit
   rester revérifiable. Œuvres périphériques sous droits ⇒ résumer + référencer (R-2).

4. **Lecture intégrale (R-6)** : la source **en entier** avant de clore la phase. Budget court ⇒
   arrêt propre en fin de section + étiquette honnête de profondeur (« modules 1–4 en
   profondeur, 5–7 en first-pass ») — puis **pousser ce palier** (A5→A6 : PR normale, ligne
   `[~]` avec la profondeur) plutôt que de garder des heures de transcription non poussées
   (T-10) ; la session suivante **complète** la fiche, ne la refait pas (R-4).

### A4 — Enrichir (phase 2 : profondeur de génération, R-5)

Une fiche « résumé » ne sert à rien : la cible est le standard qui permet de générer cours et
exercices **sans jamais rouvrir les scans** (T-3). Compléter §1–§6 du gabarit en combinant
guide + manuel :

- **chaque activité / exercice du manuel décrit individuellement** (énoncé, données, ce qui est
  demandé) — jamais « des exercices d'application p.12-15 » ;
- **encadrés de règles/lois officiels verbatim** (« Retenir », « Repère », l'essentiel du
  cours…) ;
- **vocabulaire et terminologie officielle** relevés tels quels ;
- **bornes de scope** explicites : ✅ INCLUS au niveau / ⛔ EXCLU (relève d'un autre niveau) ;
- **§4 Chapitrage** rempli (slug, notion, pages du manuel élève), puis **codifié dans
  `manifest/<niveau>.json`** (champ `manuel = { code, pages }` par chapitre ; JSON valide —
  schéma Zod de l'app). Ce chapitrage est l'ossature du LOT B (T-5) ;
- divergence guide ↔ manuel ⇒ le **guide enseignant fait foi** pour le scope ; signaler l'écart
  avec la page (§5).

### A5 — Auditer (rien ne part sans ça)

1. **QA déterministe** (T-1) — 0 erreur exigé :

   ```bash
   scribekit qa .claude/skills/content-ecole-tn/references/programmes-officiels
   scribekit status .claude/skills/content-ecole-tn/references/programmes-officiels  # plus aucun pending
   ```

2. **R-7 — relecture indépendante par sondage dirigé (T-8)** : un second agent/sous-agent au
   **contexte vierge** re-vérifie la fiche **contre les PDF sources** (pas contre le travail du
   premier) :
   - **100 %** : les encadrés verbatim, le chapitrage/manifeste (existence, ordre, plages de
     pages), toutes les zones `[?]` / § Incertitudes, les titres et la numérotation des
     modules ;
   - **échantillon** : ≥15 % des pages restantes (minimum 10 pages), tirées sur toute l'étendue
     (début / milieu / fin) — re-vérifier fidélité, notation 0-9/LTR, rien d'inventé ;
   - **escalade** : ≥3 erreurs **substantielles** (invention, contresens, omission d'items) ⇒
     la fiche est sous la barre — re-lecture intégrale contre la source. Erreurs de forme
     (typo, notation) ⇒ corriger, pas d'escalade ;
   - **verdict consigné** : fiche § Incertitudes + `_INDEX.md`
     (« R-7 AAAA-MM-JJ, sondage N pages, X corrections »).

3. **Gate du dépôt** : `npm run verify` (lint + typecheck + tests — tourne sans backend). Le
   hook pre-commit formate (Prettier) : le laisser faire, jamais `--no-verify`.

4. **Mettre à jour le REGISTRE `suivi/<grade>.json`** (⛔ jamais `_INDEX.md` à la main — c'est
   une vue générée) : créer/actualiser l'entrée du couple avec le **statut normé** (`partielle`
   si trous de lecture ou de profondeur, `complete` si 100 % + profondeur de génération —
   **jamais `promue`**, réservé à l'humain), la **profondeur** (`first-pass`/`mixte`/
   `generation`), les **sources par code corpus** avec `pagesTotal` et les **plages exactes
   `pagesLues`** (le % est calculé — fini les « ~48 % » déclarés), le verdict `r7`, `maj`/`par`
   (PSEUDO) et des notes courtes. Grade lycée sans fichier de suivi ⇒ créer
   `suivi/<gradeSlug>.json` (slugs de `docs/lycee-architecture.md`). Puis :

   ```bash
   npm run programme:index    # régénère la vue _INDEX.md
   npm run programme:check    # 0 erreur exigé — doublons, plages, cohérence disque↔registre
   ```

### A6 — Pousser le LOT A

À committer — et **rien d'autre** : la fiche, le manifeste, le **registre**
`suivi/<grade>.json` et la vue `_INDEX.md` régénérée (+ sorties YAML du profil générique si
demandées). ⛔ Jamais : `.scribekit/ledger.json`, `AVANCEMENT.md`, les PDF sources, ni quoi que
ce soit sous `content/` ou `supabase/migrations/` (ça, c'est le LOT B) — seule exception : la
fiche `content/_sources/<theme>/<slug>/fiche.md` du profil document-libre non scolaire, qui est
un livrable du LOT A.

```bash
git add .claude/skills/content-ecole-tn/references/programmes-officiels/   # document-libre hors école : content/_sources/<theme>/<slug>/
git commit -m "feat(programme): transcription <matière> <niveau> — <codes sources> (FableEtudes/12#persistance)"
git push -u origin feat/transcription-<niveau>-<matiere>
```

La PR s'ouvre **auto-merge armé** : surveiller les checks (`gh pr checks <n> --watch`),
corriger tout rouge et re-pousser, puis **confirmer que le merge a réellement eu lieu** avant
le LOT B (ou le couple suivant).

---

## LOT B — le contenu (phase 3)

> Seulement si `GENERATION: oui` **et** la fiche du couple mergée sur `main` — une fiche restée
> first-pass ne se génère pas (repasser par A3–A4). Ici on change de casquette : on ne
> transcrit plus, on **génère avec les skills du dépôt**, qui font foi. Ne réinventer aucune
> règle.

### B1 — Brief + skills (T-6, T-7)

1. Branche fraîche : `git fetch origin main`, puis
   `git checkout -B feat/content-<subject-id> origin/main`.
2. La procédure normative de cette phase est la **« Recette »** de
   `programmes-officiels/README.md`. Sa règle d'or (= T-3) : **la fiche
   `programme/<niveau>/<matière>.md` est la source de scope ET de contenu — ne jamais rouvrir
   les PDF.**
3. Préparer le **brief matière** (~1 page, T-6) depuis la fiche : scope exact, terminologie
   officielle, **calibrage âge** (§ « Adapter à l'âge » du README programmes-officiels),
   **langue du contenu** (matière arabe ⇒ tout en arabe, `nameFr` inclus ; lycée scientifique ⇒
   français natif, jargon des manuels — décision 2026-07-13), pièges/erreurs types, conventions
   du sujet (`id`, `themeId`, `gradeSlug` — slugs pris : `content/CATALOGUE.md`).
4. Charger **la carte** (`content-engine/references/generation-pipeline.md`), puis au besoin
   réel (T-7) : `content-ecole-tn` (fidélité programme — le wrapper de tout contenu scolaire),
   `content-cours` (cours/résumé), `content-interactif` (formats variés),
   **`prof-<matière>-<cycle>`** s'il existe (exercices durs d3–4). Sous Claude Code les skills
   s'invoquent nativement ; autre agent : lire chaque `SKILL.md` + la référence utile, et les
   appliquer à la lettre.

### B2 — Générer par tranches de chapitres (T-5, T-10)

Dans l'**ordre du chapitrage** (§4 de la fiche / `manifest/<niveau>.json`), par **tranches de
3 chapitres complets par défaut — jamais plus de 4 non poussés**. Pour chaque chapitre —
contexte : **brief matière + la section de la fiche de CE chapitre** :

- produire `chapter.json`, `cours.md`, `resume.md`, `quiz.json`, `exercices/*.json` (ladder
  standard — voir les skills). Sujet absent de `content/` ⇒ créer `subject.json` dans la
  **première tranche**, selon la convention d'identifiants ;
- **Illustration (axe 5 — s'applique à toute campagne depuis l'étude 18)** : toute notion
  spatiale/visuelle se **dessine** (cours `::: figure` ; question `<svg>` inline), figures
  **vraies** (double-résolues sur la figure) qui ne fuitent pas la clé ; petites classes
  (1ère–3ème) ⇒ presque tout illustré, coloré ;
- auto-vérification par chapitre : re-résolution à l'aveugle, distracteurs = erreurs exécutées,
  équilibre des clés, notation standard (0-9, LTR ; milliers arabes en U+00A0 **cohérent**) ;
- **commit local après chaque chapitre complet** (fichiers `content/` seulement — la migration
  vient en B3). Un chapitre part **complet ou pas du tout** dans une PR ready (cours + résumé +
  quiz + ≥1 mission) : un chapitre entamé mais pas fini reste hors tranche (ou part en `wip/`
  si la session s'interrompt, T-10).

Tranche pleine — ou budget/fenêtre qui approche de sa fin — ⇒ passer en B3 pour la livrer. La
matière est **finie** quand `content:audit` ne signale plus ni chapitre manquant ni chapitre
incomplet pour ce sujet vs le manifeste.

### B3 — Gates, migration, push, prod (à chaque tranche)

```bash
npm run content:check          # validation Zod de tout le contenu
npm run content:qa:strict      # QA stricte — 0 [error]
npm run content:audit          # conformité au programme + couverture vs manifeste
```

(`content:audit` sur une tranche intermédiaire : les chapitres des tranches **suivantes**
apparaissent « manquants » — c'est attendu tant que la matière n'est pas finie ; à la
**dernière** tranche, 0 manquant / 0 incomplet exigé pour ce sujet.)

Puis **audit pédagogique** : appliquer le skill `content-audit` sur les **chapitres de la
tranche** (re-résoudre chaque question à l'aveugle, clés/distracteurs/calibrage) et corriger
avant de pousser.

```bash
npm run content:build -- --subject <subject-id>
```

⚠️ **JAMAIS `content:build` sans `--subject`** (il régénérerait ~60 sujets — migrations
parasites à ne pas committer). **Garder l'horodatage neuf proposé** ; ne jamais réutiliser
celui d'une migration existante (elle serait « up to date » et sautée en prod). Chaque tranche
produit ainsi **une nouvelle migration du sujet** (idempotente, cumulative — le pattern
documenté de `math`/`math-6eme` ; ne jamais supprimer celles des tranches précédentes). Puis
`npm run verify`, et le **commit de tranche** (les chapitres de la tranche **+ la migration
générée**, rien d'autre) :

```bash
git add content/<subject-id> supabase/migrations/<ts>_generated_<subject-id>_content.sql
git commit -m "feat(content): <subject-id> ch.NN-MM — génération depuis la fiche (FableEtudes/12#generation)"
git push -u origin feat/content-<subject-id>-chNN-MM
```

La PR s'auto-merge comme au LOT A ; **au merge, la migration s'applique seule en prod**
(`db-migrate-prod`). Confirmer le merge, vérifier dans l'onglet Actions que le run affiche bien
`Applying migration <ts>_generated_<subject-id>…` (pas « Remote database is up to date »), puis
**tranche suivante** (branche fraîche depuis `origin/main` mergé, B2) — et quand la matière est
finie, **reprendre la boucle** au couple suivant.

---

## Rapport de campagne

Quand la file est épuisée (ou à l'arrêt propre), rapporter au contributeur :

- par couple traité : lien PR LOT A / LOT B, profondeur atteinte, verdict R-7 (taille du
  sondage, corrections), **coût du lot** (T-9 — tokens in/out si exposés, sinon pages lues /
  volume écrit) ;
- couples sautés et pourquoi (déjà `[~]`, source indisponible, matière annexe…) ;
- ce qui reste dans `_INDEX.md` / la matrice lycée pour la campagne suivante.

Le **coût par chapitre publié** est le KPI de l'étude 12 : il se mesure à chaque campagne, il
ne s'estime pas.

## STOP (escalade — ne jamais improviser)

- Couple déjà `[~]`/`[x]` ⇒ on ne re-transcrit pas (A1) ; sauter, ou LOT B seul si le contenu
  manque.
- Source introuvable / téléchargement CNP bloqué sans `FICHIERS` ⇒ demander les PDF au
  contributeur et **continuer la campagne** avec les couples suivants.
- Doute sur les **droits** d'une source hors corpus officiel ⇒ STOP (R-2).
- Scan **illisible** ou manuscrit ⇒ transcrire le lisible, signaler le reste, ne jamais
  deviner.
- Divergence fiche ↔ programme officiel, ou gabarit/manifeste qui ne colle pas au réel ⇒ STOP
  et documenter (commentaire de PR ou issue), jamais d'adaptation silencieuse.
- LOT B sans fiche mergée, ou fiche restée « first-pass » (pas la profondeur R-5) ⇒ **ne pas
  générer** ; repasser par A3–A4.
- Un chapitre appelle un **format de contenu inexistant** dans le moteur ⇒ signalement (issue)
  vers l'étude 03 / le catalogue de formats, jamais un format ad hoc.
- Budget insuffisant ⇒ arrêt propre **au dernier palier poussable** (fin de tranche en LOT B,
  fiche partielle étiquetée en LOT A) + étiquetage honnête (T-9/T-10) ; interruption imminente
  au milieu d'un chapitre ⇒ sauvegarde `wip/…` (PR draft). La campagne reprendra où
  `_INDEX.md` en est. Jamais de bâclage.

---

_Cette méthode applique les règles du skill `content-ingest` (R-1…R-7), la « Recette » de
`programmes-officiels/README.md` et les études 12/13. En cas de désaccord : **CLAUDE.md**
(racine du dépôt) gagne, puis les skills et docs normatifs, puis cette méthode._

# Programmes officiels — index & mode d'emploi

## 🎯 Source de vérité : le programme national CNP

La **référence ultime (single source of truth)** pour le scope des cours et exercices `ecole-tn` est le
**programme national tunisien du CNP**, matérialisé par le **corpus CNP téléchargé** (manuels scolaires
officiels + guides de l'enseignant). Les fichiers d'école (Taybah) servent de **vérification** et de
**complément de détail / séquençage** — **jamais** à contredire ni restreindre le scope CNP.

### Précédence (à suivre par les skills `content-ecole-tn` / `content-cours` / `content-audit`)

Pour un couple **(niveau, matière)** :

1. **Corpus CNP = autorité.** Le **manuel élève** = le contenu/scope ; le **guide enseignant**
   (guide méthodologique / الدليل المرجعي) = le **programme officiel** (compétences, progression).
2. **Fichiers école (Taybah) = vérification + séquençage par trimestre + complément de détail.** Signaler
   les divergences ; ne jamais sortir du scope CNP pour suivre l'école.
3. **Web** (tadris.tn, tunisiecollege.net) seulement pour combler un manque ponctuel.

## 📚 Le corpus CNP (téléchargé)

- **Emplacement** : `YahiaAcademy/cnp-officiel/` — dossier **frère du repo**, **hors git** (~2.8 GB).
- **Contenu** : **346 PDF** — base (1ère→9ème) + secondaire (1ère→4ème), **élève** (manuels) **et**
  **enseignant** (guides méthodologiques / أدلة مرجعية = le programme détaillé).
- **Index** : `cnp-officiel/CATALOGUE.md` (lisible, groupé par niveau/matière) ; bruts :
  `cnp-officiel/catalogue.csv`, `cnp-officiel/index.csv`.
- **Arborescence** : `cnp-officiel/manuels/<asasi|secondaire>/c<classe>/<eleve|enseignant>/<code>P<NN>.pdf`.
- **Décodage du code** (6 chiffres) : chiffre 1 = rôle/cycle (1 = base-élève, 5 = base-enseignant,
  2 = secondaire) · chiffres 2-3 = **matière** (01 arabe, 02 maths, 03 éveil, 05 SVT, 06 géo, 07 histoire,
  08 arts/tech/musique, 11 sociales/islamique/civique, 12 EPS, 21 français, 22 maths-fr, 23 physique,
  24 chimie, 25 SVT, 33 informatique, 41 anglais…) · chiffre 4 = **classe**.
- 📖 **Lire le corpus** : les manuels sont des scans et les guides ont une couche-texte cassée (mojibake)
  → `pdftotext` est **inutile**. On **rasterise en PNG puis on lit en vision** (outil Read). Helper :
  **`bash cnp-officiel/render.sh <pdf> <p_début> <p_fin> [dpi]`** → écrit `cnp-officiel/_render/<nom>-NNN.png`
  à ouvrir avec l'outil Read. (poppler installé sous `YahiaAcademy/_tools/poppler/`.) Le **guide enseignant**
  porte le **programme détaillé** (compétences, progression) — c'est la pièce à lire en priorité pour le scope.
- **Re-télécharger / compléter** : `bash cnp-officiel/_dl-manuels.sh` (résumable, met à jour les index).

## 🏫 Fichiers école (vérification / séquençage) — Taybah Primaire

Transcriptions fidèles des plans trimestriels de l'école — à utiliser **en vérification** et pour le
**découpage par trimestre**, pas comme autorité de scope :

| Niveau             | gradeSlug   | Fichier                                    | Couverture                          |
| ------------------ | ----------- | ------------------------------------------ | ----------------------------------- |
| 1ère année de base | `1ere-base` | [taybah/1ere-base.md](taybah/1ere-base.md) | 6 matières · T1+T2+T3               |
| 2ème année de base | `2eme-base` | [taybah/2eme-base.md](taybah/2eme-base.md) | 6 matières · T1+T2+T3               |
| 3ème année de base | `3eme-base` | [taybah/3eme-base.md](taybah/3eme-base.md) | 6 matières · T1+T2+T3               |
| 5ème année de base | `5eme-base` | [taybah/5eme-base.md](taybah/5eme-base.md) | 6 matières · T1+T3 (⚠️ T2 manquant) |

> ⚠️ **Conflit Taybah vs CNP** : l'audit a montré que le contenu primaire existant (généré ex-CNP
> générique) diverge du plan Taybah sur le **séquençage** — ex. la **soustraction** est une notion de
> **2ème année** dans le programme national, pas de 1ère (vérifié). Règle : **le CNP fait foi pour le
> _quoi_ / le _niveau_** ; Taybah éclaire le **_quand_ / le trimestre**.

## 🆔 Convention d'identifiants de sujets (`subject.json` `id`)

Les `id` sont **uniques dans tout le catalogue** (identité ; renommer = supprimer+recréer). Primaire =
matière **suffixée par le niveau** (les ids bruts `math`/`arabic`/… sont ceux de la 9ème) :

| Matière                | contentLanguage | id 1ère                    | id 2ème        | id 3ème        | id 5ème        |
| ---------------------- | --------------- | -------------------------- | -------------- | -------------- | -------------- |
| الرياضيات (maths)      | `ar`            | `math-1ere`                | `math-2eme`    | `math-3eme`    | `math-5eme`    |
| اللغة العربية (arabe)  | `ar`            | `arabic-1ere`              | `arabic-2eme`  | `arabic-3eme`  | `arabic-5eme`  |
| التربية الإسلامية      | `ar`            | `education-islamique-1ere` | …              | …              | …              |
| الإيقاظ العلمي (éveil) | `ar`            | `eveil-scientifique-1ere`  | …              | …              | …              |
| Français               | `fr`            | `french-1ere`              | `french-2eme`  | `french-3eme`  | `french-5eme`  |
| English                | `en`            | `english-1ere`             | `english-2eme` | `english-3eme` | `english-5eme` |

> ⚠️ `math-1ere..5eme` et `eveil-scientifique-1ere..5eme` **existent déjà sur `main`** (générés ex-CNP
> générique, source à réaligner sur le corpus CNP). `themeId="ecole-tn"`, `gradeSlug="1ere-base"…`,
> notation maths standard même en arabe (chiffres 0-9, LTR).

## 🧒 Adapter à l'âge (primaire)

Niveaux jeunes (1ère ≈ 6-7 ans, souvent non-lecteurs) : privilégier les **figures SVG** (compter, comparer,
associer image↔nombre), énoncés **très courts** ; garder la progression du programme ; RPG dans les
**titres** seulement, énoncés/options/explications sobres.

## ⚠️ Manques connus

- **Programmes officiels « standalone »** : Edunet (`البرامج الرسمية`) **bloque l'accès automatisé** (403,
  WAF). Les **guides enseignant** du corpus CNP couvrent le programme ; pour les booklets formels →
  navigateur (Chrome MCP) ou fourniture manuelle.
- **Taybah** : 5ème T2 manquant ; niveaux 4ème/6ème non fournis.
- Corpus CNP = **scans** (lisibilité par page-range/OCR).

## ➕ Ajouter une source (au fil de l'eau)

1. **CNP** : `bash cnp-officiel/_dl-manuels.sh` (résumable) → puis régénérer `cnp-officiel/CATALOGUE.md`.
2. **École** : `programmes-officiels/<école>/<gradeSlug>.md` (transcription fidèle : terminologie d'origine,
   chiffres latins 0-9 même en arabe, `[sic]`/`[?]`, fichiers source en bas) + ligne dans la table ci-dessus.

## 🧭 Manifeste de programme & audit de conformité (`content:audit`)

Le **manifeste** code, par niveau, le **programme officiel attendu** — c'est lui qui rend la **conformité**
et la **couverture** vérifiables automatiquement (le `content:check` ne sait pas ce qui _devrait_ exister).
Fichier `manifest/<gradeSlug>.json` (validé par Zod, schéma `src/shared/content/program-manifest.ts`) :

- `grade` (= `gradeSlug`) · `sealed` (`false` = rapport conseil ; `true` = niveau déclaré **complet** → le gate
  CI strict s'y applique) · `source`/`note` ;
- `subjects[]` : `id` (matière suffixée par niveau), `contentLanguage`, et `chapters[]` = `{ slug, notion }` en
  **ordre du programme**, transcrits du **guide enseignant CNP**. `chapters: []` = liste **pas encore codifiée**
  (l'audit vérifie alors présence + complétude, sans couverture de chapitres → pas de faux « manquant »).

**Outil** : **`npm run content:audit`** (rapport) · **`npm run content:audit:strict`** (n'échoue **que** sur un
niveau **scellé** ayant des constats — câblé dans `ci:verify`). Il diffe `content/` ↔ manifestes et signale, par
niveau/matière : **matières manquantes**, **chapitres manquants / hors-programme**, **chapitres incomplets**
(cours + résumé + quiz + **≥1 mission**, note si pas de boss), écarts de **langue**. Manifestes seedés :
`1ere-base`, `2eme-base` (seul math codifié ; les autres matières ressortent « manquantes » — c'est voulu).

**Sceller un niveau** : quand toutes les matières + chapitres sont présents et complets, passer `sealed: true`
→ tout écart futur casse la CI (gate **opt-in**).

## 🛠️ Recette de création / réalignement de contenu (méthode à suivre)

Pour créer ou réaligner le contenu d'un couple **(niveau, matière)** sur le CNP — produit `cours.md` +
`resume.md` + `quiz.json` + `exercices/*.json` (les **missions**) :

1. **Isoler le travail** (repo multi-sessions — ne JAMAIS toucher au WIP non commité des autres sessions) :
   worktree sur `main` + jonction `node_modules` (pour que validation et hooks fonctionnent) :
   - `git worktree add -b feat/<sujet>-cnp <chemin> origin/main`
   - jonction (Windows, sans admin, PowerShell) : `New-Item -ItemType Junction -Path <chemin>\node_modules -Target <repo>\node_modules`
2. **Lire le programme CNP** (source de vérité) : repérer le **guide enseignant** du (niveau, matière) dans
   `cnp-officiel/CATALOGUE.md`, puis `bash cnp-officiel/render.sh <guide.pdf> <p1> <p2>` → ouvrir les PNG de
   `cnp-officiel/_render/` avec l'outil **Read** (vision ; les PDF sont des scans). Établir le scope exact
   (notions, terminologie, séquence). `taybah/<gradeSlug>.md` sert de **vérification** / séquençage par trimestre.
   **Codifier** la liste des chapitres (slug + notion, ordre du programme) dans **`manifest/<gradeSlug>.json`** (cf. § Manifeste) — c'est ce qui rend la couverture vérifiable.
3. **Auditer l'existant** (si réalignement) : pour chaque chapitre → **couvert** / **manquant** /
   **hors-programme** (notion d'un autre niveau). Vérifier avant de retirer (ex. soustraction = 2ème, pas 1ère).
4. **Générer / corriger** chapitre par chapitre selon **`content-engine`** :
   - `cours.md` (~50-75 l, style RPG, **figures SVG** pour le primaire, chiffres latins même en arabe),
     `resume.md` (bijection cours↔résumé), `quiz.json` (5 q, d1-2, gate), `exercices/*.json` = **missions**
     (`01-pratique` d1, `02-boss` d3, +`03-revision`/`04-defi`/`05` au besoin).
   - ajouter les chapitres manquants, retirer/flaguer le hors-programme, **réordonner** (`displayOrder`),
     `nameFr` natif (`الرياضيات`…). Auto-vérification (re-solve à l'aveugle, équilibre des clés, notation, golden rule).
     **Chiffres en arabe** : grouper les milliers en **U+00A0** de façon **cohérente** (options ↔ énoncés ↔
     explications) — sinon `content:qa` signale « valeur non reprise » (son extracteur de nombres coupe sur
     l'espace insécable) ; re-scanner `\d \d{3}` **après** écriture (l'outil d'écriture aplatit parfois
     l'U+00A0 → réinjecter). **Difficulté de _question_ ≤ 3** même dans `04-defi` (le palier 4 porte sur
     l'_exercice_, pas la question).
5. **Valider** : `npm run content:check` (Zod) + `npm run content:qa:strict` (**0 erreur**).
   (Worktree sans `node_modules` : jonction de l'étape 1, ou `node --experimental-strip-types <repo>/scripts/content/build.ts --check` avec cwd=worktree.)
   Puis **`npm run content:audit`** : conformité au programme + **couverture** (matières/chapitres) + complétude vs le manifeste (cf. § Manifeste).
6. **Régénérer la migration SQL** ⚠️ **indispensable** — `content:check` _valide mais n'écrit rien_ ; sans
   cette étape le contenu **ne touche jamais la base**. `npm run content:build -- --subject <id>` → écrit
   `supabase/migrations/<ts>_generated_<id>_content.sql` (une migration **idempotente** par sujet, upserts
   déterministes UUIDv5). **Garder l'horodatage par défaut (neuf)** : pour _mettre à jour_ un sujet déjà en
   prod il faut une **nouvelle** version — ne réutilise **jamais** `--timestamp <existant>` (même nom qu'une
   migration déjà appliquée → `db push` la **saute** « up to date » → le contenu n'atteint pas la prod). Ne
   pas supprimer les anciennes migrations générées du sujet (casse l'historique ; `math`/`math-6eme` en
   cumulent déjà plusieurs). La committer **avec** les fichiers `content/`.
7. **Committer + PR** (un commit par sujet, fichiers `content/` **+ migration générée**) :
   `feat(content): <sujet> — réalignement CNP`, push, `gh pr create`.
8. **La migration s'applique en prod automatiquement au merge** (CLAUDE.md §7 / `.github/workflows/db-migrate-prod.yml`) —
   **jamais à la main**, plus de label. Le merge sur `main` déclenche `db-migrate-prod` (backup `pg_dump` →
   `supabase db push`) qui applique les migrations _pending_. **Vérifier le log** du run : il doit afficher
   `Applying migration <ts>_generated_<id>…` — **pas** « Remote database is up to date » (= migration sautée, cf. piège horodatage étape 6).
9. **Nettoyer** : retirer la jonction (`rmdir <chemin>\node_modules`) **avant** `git worktree remove`.

> Références éprouvées : `math-1ere`→`math-4eme` (#161, #162, #167, #174). **Leçon migration** : #167/#174 ont
> régénéré **en place (même horodatage)** → sautés par `db push` ; corrigés par **#175** (horodatage neuf) qui a
> réellement appliqué le contenu en prod — d'où le garde-fou de l'étape 6.

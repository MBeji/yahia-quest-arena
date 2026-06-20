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
3. **Auditer l'existant** (si réalignement) : pour chaque chapitre → **couvert** / **manquant** /
   **hors-programme** (notion d'un autre niveau). Vérifier avant de retirer (ex. soustraction = 2ème, pas 1ère).
4. **Générer / corriger** chapitre par chapitre selon **`content-engine`** :
   - `cours.md` (~50-75 l, style RPG, **figures SVG** pour le primaire, chiffres latins même en arabe),
     `resume.md` (bijection cours↔résumé), `quiz.json` (5 q, d1-2, gate), `exercices/*.json` = **missions**
     (`01-pratique` d1, `02-boss` d3, +`03-revision`/`04-defi`/`05` au besoin).
   - ajouter les chapitres manquants, retirer/flaguer le hors-programme, **réordonner** (`displayOrder`),
     `nameFr` natif (`الرياضيات`…). Auto-vérification (re-solve à l'aveugle, équilibre des clés, notation, golden rule).
5. **Valider** : `npm run content:check` (Zod) + `npm run content:qa:strict` (**0 erreur**).
   (Worktree sans `node_modules` : jonction de l'étape 1, ou `node --experimental-strip-types <repo>/scripts/content/build.ts --check` avec cwd=worktree.)
6. **Régénérer la migration SQL** ⚠️ **indispensable** — `content:check` _valide mais n'écrit rien_ ; sans
   cette étape le contenu **ne touche jamais la base**. `npm run content:build -- --subject <id>` → écrit
   `supabase/migrations/<ts>_generated_<id>_content.sql` (une migration **idempotente** par sujet, upserts
   déterministes UUIDv5). La committer **avec** les fichiers `content/`.
7. **Committer + PR** (un commit par sujet, fichiers `content/` **+ migration générée**) :
   `feat(content): <sujet> — réalignement CNP`, push, `gh pr create`.
8. **Déployer la migration en prod** — **manuel, AVANT le merge** (CLAUDE.md §7 / `.github/workflows/migration-gate.yml`) :
   pousser sur `main` auto-déploie le **code** (Vercel) **mais pas la base**. Appliquer le
   `*_generated_*_content.sql` à la base Supabase de prod (SQL editor ou `supabase db push`), **puis** poser
   le label **`migration-applied`** sur la PR (le gate l'exige). Idempotent → ré-application sans risque.
9. **Nettoyer** : retirer la jonction (`rmdir <chemin>\node_modules`) **avant** `git worktree remove`.

> Références éprouvées : PR #161 (`math-1ere`), #162 (`math-2eme`). ⚠️ Leur migration générée est sur `main`
> mais **n'a pas été appliquée en prod** (label `migration-applied` absent) — à appliquer (cf. étape 8).

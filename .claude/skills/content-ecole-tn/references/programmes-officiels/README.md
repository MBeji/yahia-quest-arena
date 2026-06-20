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

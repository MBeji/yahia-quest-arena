# Programmes officiels des écoles — index & mode d'emploi

Ce dossier contient les **programmes officiels réellement annoncés par les écoles** des élèves, extraits
fidèlement de leurs documents (plans trimestriels, manuels, photos). Ils sont la **source de vérité
prioritaire** pour générer et auditer le contenu `ecole-tn` : on s'aligne sur ce que l'école enseigne
réellement, trimestre par trimestre — pas seulement sur le programme national générique.

> Alimenté **au fil de l'eau** : chaque fois qu'un nouveau programme de classe est fourni, on ajoute /
> complète un fichier ici (voir « Ajouter un programme » en bas).

## Politique de précédence (ce que les skills doivent suivre)

Pour un couple **(grade, matière)** donné, la vérité de scope se lit dans cet ordre :

1. **Programme de l'école** = `programmes-officiels/<école>/<gradeSlug>.md` (ce dossier). **Autoritaire
   quand il existe** : couvre les notions de ce niveau/cette matière, **découpées par trimestre**.
2. **Programme national tunisien (CNP) générique** — `Programme.pdf` / `Programme.docx` (dossier parent)
   - `programme-9eme-annee-tunisie.md` + vérification web (tadris.tn, edunet/CNP). Sert de **repli**
     (grades sans fichier école) et de **complément** (terminologie, exemples), **jamais** pour élargir
     le scope au-delà de ce que l'école annonce.

Règle d'or : **ne pas dépasser le programme de l'école** pour ce niveau. Une notion hors-programme ou
d'un autre trimestre/niveau se signale (rapport), elle ne s'ajoute pas en silence. Voir les skills
`content-ecole-tn`, `content-cours`, `content-audit`.

## Index des programmes disponibles

### École : **Taybah Primaire** (`taybah/`) — année scolaire 2025-2026

| Niveau             | gradeSlug   | Fichier                                    | Couverture            | Statut                                      |
| ------------------ | ----------- | ------------------------------------------ | --------------------- | ------------------------------------------- |
| 1ère année de base | `1ere-base` | [taybah/1ere-base.md](taybah/1ere-base.md) | 6 matières · T1+T2+T3 | ✅ complet                                  |
| 2ème année de base | `2eme-base` | [taybah/2eme-base.md](taybah/2eme-base.md) | 6 matières · T1+T2+T3 | ✅ complet (FR : module 6 absent des plans) |
| 3ème année de base | `3eme-base` | [taybah/3eme-base.md](taybah/3eme-base.md) | 6 matières · T1+T2+T3 | ✅ complet (arabe = قواعد+إنتاج seulement)  |
| 5ème année de base | `5eme-base` | [taybah/5eme-base.md](taybah/5eme-base.md) | 6 matières · T1+T3    | ⚠️ partiel — **T2 manquant**                |

Matières Taybah primaire (mêmes 6 à chaque niveau) : **اللغة العربية** (arabe), **التربية الإسلامية**
(éducation islamique), **الرياضيات** (maths), **الإيقاظ العلمي** (éveil scientifique), **Français**,
**English**. Chaque fichier détaille les notions par matière puis par trimestre, avec une section
« Notes d'extraction » (divergences entre versions, passages OCR incertains `[?]`, coquilles source `[sic]`).

## Convention d'identifiants de sujets (`subject.json` `id`) — IMPORTANT

Les `id` de sujet sont **uniques dans tout le catalogue** et constituent l'identité (renommer = supprimer

- recréer). La colonne « id sujet suggéré » des fichiers de programme donne la **matière**, pas l'id
  final : il faut **suffixer par le niveau** pour éviter la collision avec les sujets déjà en base.

* 9ème (le plus peuplé) utilise les **ids bruts** : `math`, `arabic`, `french`, `english`, `svt`.
* 6ème utilise le suffixe `-6eme` : `math-6eme`, `eveil-scientifique-6eme`.
* **Primaire (ces programmes Taybah)** → suffixe `-1ere` / `-2eme` / `-3eme` / `-5eme` :

| Matière                             | contentLanguage | id 1ère                    | id 2ème        | id 3ème        | id 5ème        |
| ----------------------------------- | --------------- | -------------------------- | -------------- | -------------- | -------------- |
| الرياضيات (maths)                   | `ar`            | `math-1ere`                | `math-2eme`    | `math-3eme`    | `math-5eme`    |
| اللغة العربية (arabe)               | `ar`            | `arabic-1ere`              | `arabic-2eme`  | `arabic-3eme`  | `arabic-5eme`  |
| التربية الإسلامية (éduc. islamique) | `ar`            | `education-islamique-1ere` | …              | …              | …              |
| الإيقاظ العلمي (éveil scientifique) | `ar`            | `eveil-scientifique-1ere`  | …              | …              | …              |
| Français                            | `fr`            | `french-1ere`              | `french-2eme`  | `french-3eme`  | `french-5eme`  |
| English                             | `en`            | `english-1ere`             | `english-2eme` | `english-3eme` | `english-5eme` |

- `themeId` = `"ecole-tn"` ; `gradeSlug` = `"1ere-base"` (etc.) ; `contentLanguage` = colonne ci-dessus
  (jamais trilingue pour l'école). Les grades `1ere-base`…`5eme-base` sont **déjà seedés** côté DB.
- Maths/sciences en arabe : **notation standard** (chiffres 0-9, formules LTR) même en prose arabe
  (`content-engine/references/math-and-notation.md`).
- `education-islamique-*` est un **nouveau sujet** (n'existe pas encore en base) ; `eveil-scientifique-*`
  suit le précédent `eveil-scientifique-6eme`.

## Adapter le contenu à l'âge (primaire)

Ces niveaux sont jeunes (1ère ≈ 6-7 ans) et souvent **non-lecteurs autonomes**. Pour que le format QCM
reste pédagogique :

- privilégier les **figures SVG** (compter des objets, comparer des tailles, associer image↔nombre) plutôt
  que des énoncés textuels longs ; énoncés **très courts**, vocabulaire minimal ;
- garder la **progression du programme** (ex. 1ère T1 maths = nombres 0→9, ensembles, repérage espace) ;
- la touche RPG reste **dans les titres** ; les énoncés/options/explications restent sobres et clairs.

## Ajouter un programme (au fil de l'eau)

1. Créer/compléter `programmes-officiels/<école>/<gradeSlug>.md` (1 fichier par niveau, matières ×
   trimestres) en **transcription fidèle** : terminologie d'origine, chiffres latins 0-9 même en arabe,
   `[sic]` pour les coquilles source, `[?]` pour l'incertain, liste des fichiers source en bas.
2. Ajouter la ligne dans l'index ci-dessus (école / gradeSlug / fichier / couverture / statut).
3. Si nouvelle école : créer le sous-dossier `<école>/` et une nouvelle section d'index.

## Manques connus à compléter (à réclamer aux écoles)

- **Taybah 5ème** : tout le **Trimestre 2** (toutes matières) ; colonnes English « Objectives »/« Skills »
  partielles ; modules français 4-5 (probable T2) ; matières jamais photographiées (éduc. civique,
  histoire-géo, éveil technologique, EPS, arts, informatique).
- **Taybah 2ème** : **Module 6** de français absent des plans (T2 = modules 4-5, T3 = modules 7-8).
- **Niveaux manquants** : 4ème et 6ème année primaire Taybah non fournis.
- Voir la section « Notes d'extraction » de chaque fichier pour les passages OCR `[?]` à revérifier sur
  l'original (notamment 3ème éveil scientifique, et « جذاء » = très probablement « جداء »).

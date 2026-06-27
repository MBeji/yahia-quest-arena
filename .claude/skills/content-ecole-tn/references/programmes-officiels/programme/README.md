# `programme/` — couche de persistance du programme officiel CNP (transcriptions riches)

**But** : figer **une fois pour toutes**, en texte structuré et versionné, le **programme officiel tunisien (CNP)** de chaque couple (niveau, matière), pour que toute génération/audit de contenu le lise **sans relire les scans en vision**. C'est la **couche de persistance réelle** du contenu officiel : complète, riche, réutilisable.

## Pourquoi

Les guides CNP (`YahiaAcademy/cnp-officiel/`) sont des **scans** à couche-texte cassée (`pdftotext` inutile) → ils sont lus en **vision** après rastérisation (`render.sh` → PNG dans `_render/`). Cette lecture-vision est **refaite à chaque run** et **non persistée** comme texte. Ce dossier transcrit ce que la vision extrait, **fidèlement**, en markdown, pour ne plus jamais relire les scans pour un couple déjà transcrit.

## Structure

```
programmes-officiels/
├── programme/
│   ├── README.md              ← ce fichier (spec)
│   ├── _TEMPLATE.md           ← gabarit d'une transcription
│   ├── _INDEX.md              ← work-list : tous les guides + statut (☐/✅)
│   └── <niveau>/<matière>.md  ← UNE transcription par couple (ex. 1ere-base/arabe.md)
└── manifest/<niveau>.json     ← index machine-vérifiable (content:audit) — reste synchronisé
```

- **`<niveau>`** = `gradeSlug` (`1ere-base`…`9eme-base`, `1ere-sec`…`bac`).
- **`<matière>`** = slug court : `arabe`, `maths`, `eveil`, `islamique`, `francais`, `anglais`, `arts-tech-musique`, `eps`, `svt`, `physique`, `informatique`…
- Une transcription = le **guide enseignant** (= le programme : compétences, محاور, progression), transcrit **fidèlement** (pas une réinterprétation), avec **source + pages citées** (traçable, revérifiable sur les scans).

## Précédence (à suivre par `content-ecole-tn` / `content-cours` / `content-audit`)

Pour un couple (niveau, matière), l'ordre de lecture du scope devient :

1. **`programme/<niveau>/<matière>.md`** — s'il existe, **c'est la source de scope de référence** (transcription fidèle du guide). Plus besoin de relire les scans.
2. **Scans CNP** (`cnp-officiel/`, render→vision) — autorité ultime, et **fallback** pour les couples **pas encore transcrits**. Toute transcription doit rester revérifiable ici (d'où les pages citées).
3. **Manifeste** `manifest/<niveau>.json` — index des chapitres (couverture machine-vérifiable).
4. **Taybah** — vérification / séquençage par trimestre.

> Une transcription est **autoritaire en tant que transcription du scan** : si elle diverge du scan, le scan gagne et on corrige la transcription (signaler la page). Ne jamais « enrichir » au-delà du guide.

## Comment produire une transcription

1. Repérer le guide du couple dans `_INDEX.md` (code + cycle).
2. Rastériser si besoin (`bash cnp-officiel/render.sh <guide.pdf> <p1> <p2> 170` ; réutiliser les PNG déjà dans `_render/`) → lire en vision.
3. Remplir `programme/<niveau>/<matière>.md` selon `_TEMPLATE.md` : cadre/compétences, plan annuel (مجال→محور→objectifs/concepts/vocabulaire/progression/exemples/**bornes de scope incl. & excl.**), notes pédagogiques, sources croisées. **Citer les pages.**
4. Synchroniser le chapitre-index dans `manifest/<niveau>.json`.
5. Cocher le couple dans `_INDEX.md` (☐ → ✅, avec date).

## Statut

Chantier suivi dans **`_INDEX.md`**. Construit par vagues d'agents (un par guide), audité (fidélité + structure), mergé incrémentalement. Reprenable à tout moment via `_INDEX.md`.

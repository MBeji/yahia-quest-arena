# `programme/` — couche de persistance du programme officiel CNP (transcriptions riches)

**But** : figer **une fois pour toutes**, en texte structuré et versionné, le **programme officiel tunisien (CNP)** de chaque couple (niveau, matière), pour que toute génération/audit de contenu le lise **sans relire les scans en vision**. C'est la **couche de persistance réelle** du contenu officiel : complète, riche, réutilisable.

## ⭐ Sources combinées : guide enseignant **+** manuel élève (à TOUS les niveaux)

La transcription d'un couple (niveau, matière) **combine toutes les sources officielles disponibles**, pas seulement le guide :

- **Guide enseignant** (الدليل المرجعي / guide méthodologique) = **le programme** : compétences, محاور, progression, séquençage, bornes de scope (incl./excl.).
- **Manuel élève** = **le contenu réellement enseigné** : leçons, exemples, vocabulaire en situation, exercices types, profondeur de traitement. C'est un **complément INDISPENSABLE** du guide — il rend le contenu généré plus complet et de meilleure qualité ; ne **jamais** l'ignorer quand il existe.

**Règle de combinaison des sources** (vaut pour cette couche **et** pour la génération/audit) :

- **Une seule source disponible ⇒ elle fait référence** (on transcrit ce qu'elle donne, sans inventer le manque).
- **Plusieurs sources disponibles ⇒ les combiner TOUTES** : le guide enseignant fixe le **scope/la progression/les bornes**, le manuel élève **enrichit le contenu** (exemples, exercices, profondeur). En cas de divergence de scope, le **guide enseignant fait foi** (le manuel élève ne réduit ni n'étend le programme) ; on **signale** la divergence avec la page.

## Pourquoi

Les sources CNP (`YahiaAcademy/cnp-officiel/`) — **guide enseignant et manuel élève** — sont des **scans** à couche-texte cassée (`pdftotext` inutile) → elles sont lues en **vision** après rastérisation (`render.sh` → PNG dans `_render/`). Cette lecture-vision est **refaite à chaque run** et **non persistée** comme texte. Ce dossier transcrit ce que la vision extrait des **deux** sources, **fidèlement** et **combiné**, en markdown, pour ne plus jamais relire les scans pour un couple déjà transcrit.

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
- Une transcription = le **guide enseignant** (= le programme : compétences, محاور, progression) **combiné au manuel élève** (contenu/exemples/exercices/profondeur), transcrit **fidèlement** (pas une réinterprétation), avec **sources + pages citées par source** (traçable, revérifiable sur les scans). Si une seule des deux sources existe, on transcrit celle-là (cf. règle de combinaison ci-dessus).

## Précédence (à suivre par `content-ecole-tn` / `content-cours` / `content-audit`)

Pour un couple (niveau, matière), l'ordre de lecture du scope devient :

1. **`programme/<niveau>/<matière>.md`** — s'il existe, **c'est la source de scope + de contenu de référence** (transcription fidèle du guide enseignant **et** du manuel élève, combinés). Plus besoin de relire les scans.
2. **Scans CNP** (`cnp-officiel/`, render→vision) — autorité ultime, et **fallback** pour les couples **pas encore transcrits**. Les **deux** sources (guide enseignant + manuel élève) sont à lire et à combiner. Toute transcription doit rester revérifiable ici (d'où les pages citées par source).
3. **Manifeste** `manifest/<niveau>.json` — index des chapitres (couverture machine-vérifiable).
4. **Taybah** — vérification / séquençage par trimestre.

> Une transcription est **autoritaire en tant que transcription des scans** : si elle diverge d'un scan, le scan gagne et on corrige la transcription (signaler la page + la source). Ne jamais « enrichir » au-delà des sources officielles (guide enseignant + manuel élève).

## Comment produire une transcription

1. Repérer **les deux sources** du couple dans `_INDEX.md` (code guide enseignant **+** code manuel élève, par cycle). S'il n'y en a qu'une, transcrire celle-là (règle de combinaison).
2. Rastériser si besoin **chaque source** (`bash cnp-officiel/render.sh <pdf> <p1> <p2> 170` ; réutiliser les PNG déjà dans `_render/`) → lire en vision : le **guide enseignant** pour le scope/la progression/les bornes, le **manuel élève** pour le contenu/les exemples/les exercices/la profondeur.
3. Remplir `programme/<niveau>/<matière>.md` selon `_TEMPLATE.md` en **combinant les deux sources** : cadre/compétences, plan annuel (مجال→محور→objectifs/concepts/vocabulaire/progression/**exemples & exercices du manuel élève**/**bornes de scope incl. & excl.**), notes pédagogiques, sources croisées. **Citer les pages, par source.** En cas de divergence de scope, le **guide enseignant fait foi** ; signaler l'écart.
4. Synchroniser le chapitre-index dans `manifest/<niveau>.json` (dont le mapping `manuel` = pages du manuel élève par chapitre).
5. Cocher le couple dans `_INDEX.md` (☐ → ✅, avec date) — **les deux** sources transcrites (ou la seule disponible).

## Statut

Chantier suivi dans **`_INDEX.md`**. Construit par vagues d'agents (un par guide), audité (fidélité + structure), mergé incrémentalement. Reprenable à tout moment via `_INDEX.md`.

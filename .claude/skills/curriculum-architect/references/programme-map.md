# Programme map — official grade × subject matrix (Tunisian ladder)

The stable planning grid for `curriculum-architect`: which subjects the official Tunisian program
carries at each of the 13 grades, the repo's subject-id convention, and the known naming legacies.
**Scope truth stays with the CNP transcriptions**
(`content-ecole-tn/references/programmes-officiels/programme/<gradeSlug>/`) — this map is the
planning index, not the syllabus; entries marked _(à confirmer CNP)_ must be verified against the
transcription before being planned as real units. Coverage _state_ is never read from this file —
recompute it live (SKILL.md §1).

## The 13 grades (theme `ecole-tn`)

| gradeSlug                 | cycle      | exam year                     |
| ------------------------- | ---------- | ----------------------------- |
| `1ere-base` … `5eme-base` | primaire   | —                             |
| `6eme-base`               | primaire   | **concours** (entrée collège) |
| `7eme-base`, `8eme-base`  | collège    | —                             |
| `9eme-base`               | collège    | **concours** (fin de base)    |
| `1ere-sec` … `3eme-sec`   | secondaire | —                             |
| `bac`                     | secondaire | **concours** (baccalauréat)   |

## Subject-id convention

`<matière>-<grade>` (e.g. `math-7eme`, `arabic-3eme`, `eveil-scientifique-5eme`), theme `ecole-tn`,
`gradeSlug` set. **Legacy exception — 9ème owns the bare ids**: `math`, `arabic`, `french`,
`english`, `sciences-vie-terre`, and `svt`. See Anomalies below. Slugs are identity (UUIDv5):
existing ids are **never renamed**; new subjects always take the grade-suffixed form.

## Primaire (1ère–6ème) — all `ar` unless noted

| matière (subject id base)                     | grades     | notes                                                                                           |
| --------------------------------------------- | ---------- | ----------------------------------------------------------------------------------------------- |
| Arabe (`arabic-*`)                            | 1ère–6ème  | in content 1ère–5ème today; 6ème = gap                                                          |
| Mathématiques (`math-*`)                      | 1ère–6ème  | fully covered 1ère–6ème                                                                         |
| Éveil scientifique (`eveil-scientifique-*`)   | 1ère–6ème  | fully covered 1ère–6ème                                                                         |
| Éducation islamique (`education-islamique-*`) | 1ère–6ème  | in content 1ère–4ème; CNP guides exist at least to 5ème _(à confirmer CNP for 5ème–6ème scope)_ |
| Français (`french-*`, `fr`)                   | 3ème–6ème  | absent from content today _(à confirmer CNP — start year)_                                      |
| Anglais (`english-*`, `en`)                   | ~4ème–6ème | absent from content today _(à confirmer CNP — start year)_                                      |
| Histoire / Géographie / Éd. civique           | 5ème–6ème  | absent; _(à confirmer CNP — split & scope)_                                                     |
| Éd. technologique, arts, sport                | —          | out of the app's current pedagogical perimeter — plan only on product decision                  |

## Collège (7ème–9ème)

Core six (all covered at 7ème and 9ème; 8ème scaffolded empty): Arabe (`ar`), Français (`fr`),
Anglais (`en`), Mathématiques (`ar`), Sciences physiques (`ar`), SVT (`ar`).

Official but absent from the catalogue (gap set for a "toutes les matières" goal):
Histoire-Géographie (`ar`), Éducation civique (`ar`), Éducation islamique (`ar`), Éducation
technologique (`ar`), Informatique (9ème, `ar`) — _(à confirmer CNP: exact grades & weekly slots)_.
New ids would follow the convention (`histoire-geo-7eme`, …).

## Secondaire (1ère sec – Bac) — entirely absent from the catalogue today

Structural warning for planning: from 2ème sec the ladder **branches into sections**
(sciences, lettres, économie & services, technologies de l'informatique …, then bac sections —
math, sciences expérimentales, lettres, économie-gestion, techniques, informatique, sport). The
current data model has **one grade node per year, no section dimension** — planning lycée content
therefore starts with a product/modelling decision (sections as separate subjects? parcours per
section?) to flag via `curriculum-architect` §Boundaries, **before** any authoring campaign.
Language switch: scientific/technical subjects (math, physique, SVT, informatique) are taught in
**French** from secondary on; humanities stay Arabic (see `content-ecole-tn` §Language).

## Non-school themes (no grades — planned by level model instead)

| theme                  | planning model                                                                       |
| ---------------------- | ------------------------------------------------------------------------------------ |
| `anglais` / `francais` | CEFR ladder A1→C2, one subject per level (covered today) + donjon sets               |
| `arabe`                | level ladder (planned by the wrapper; no CEFR standard — see `content-langue-arabe`) |
| `culture-generale`     | topics × 3 language siblings (fr/en/ar)                                              |
| `muscle-cerveau`       | cognitive domains × 3 language siblings                                              |

## Anomalies & legacies (never "fix" these by renaming)

- **`svt` (9ème) is Sciences physiques**, not SVT — the real 9ème SVT is `sciences-vie-terre`.
  Professors: `prof-physique-9eme` → subject `svt`; `prof-svt-9eme` → `sciences-vie-terre`.
- 9ème bare ids (`math`, `arabic`, …) predate the grade-suffix convention. Both legacies are
  frozen: slugs are UUIDv5 identity, renaming = delete+recreate (lost student progress).
- `fr-mastery` (theme `francais`) predates the CEFR ladder; its `isPremium` flag is a dead field
  (premium is per-parcours now).

## Dependency status quick-reference (recompute live — SKILL.md §1)

- CNP transcriptions exist for `1ere-base` → `7eme-base` (as of 2026-07). `8eme-base`,
  `9eme-base` (built pre-transcription-system), and all secondary are **not transcribed** —
  any base-authoring plan for those grades starts with a persistence-layer item.
- Professor overlay: primaire (math/arabe/éveil/islamique), 6ème math, collège 7ème–8ème
  (math/physique/SVT/arabe/français/anglais), 9ème full core. None for lycée (no base to overlay).

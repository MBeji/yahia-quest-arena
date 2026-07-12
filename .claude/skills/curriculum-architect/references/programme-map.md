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

## Secondaire (1ère sec – Bac) — architecture settled, catalogue still empty

The section modelling is **decided and specified in
[`docs/lycee-architecture.md`](../../../../docs/lycee-architecture.md)** (read it before planning any
lycée unit): **sections are grade nodes** under `ecole-tn` — `1ere-sec` (tronc commun, existing) ;
`2eme-sec-{sciences,lettres,eco-services,info}` ; `3eme-sec-{math,sciences-exp,lettres,eco-gestion,
techniques,info}` ; `bac-{math,sciences-exp,lettres,eco-gestion,techniques,info}` (all `bac-*` are
concours). The legacy flat nodes `2eme-sec`/`3eme-sec`/`bac` become non-selectable, never deleted.
Subject id = `<matière>-<gradeSlug>` verbatim (`math-bac-math`, `svt-bac-sciences-exp`,
`philosophie-bac-lettres`; économie & gestion = two subjects). **The L0 seed is merged and live**
(2026-07-05, PR #285: 16 section nodes + `coming_soon` parcours + `is_selectable`). UI grouping,
grade i18n, the shared-content `compileTo` mechanism (tronc commun authored once per year,
compiled per section) and the opening waves are governed by
`FableEtudes/16-ouverture-lycee/ETUDE.md`.

**Language switch (major)**: mathématiques, sciences physiques, SVT, informatique/techniques flip
**ar → fr** at 1ère sec — same matière, new language. The base layer owes every 1ère-sec chapter of
a switched subject the **transition bridge** (lexique fr↔ar in `cours.md`, glossed first uses in
d1, a `NN-pont-linguistique` d1 mission); degressive at 2ème sec, none at bac. Humanities (arabe,
philosophie, histoire-géo) stay `ar`; économie/gestion `ar` _(à confirmer)_; français `fr`,
anglais `en`. Full policy: `docs/lycee-architecture.md` §4 and `content-ecole-tn` §Language.

Dominantes per section (planning weights; coefficients _(à confirmer)_ at transcription):
math → maths+physique · sciences-exp → SVT+physique · lettres → arabe+philo+histoire-géo ·
eco-gestion → économie+gestion · techniques → technologie+maths+physique · info → informatique+maths.
Premium: `bac-*` parcours are concours (national exam year); their PREMIUM status (vs. 1ère→3ème
sec FREE exploration) is a dormant architecture in the current free phase — every parcours is
`is_premium=false` today (see CLAUDE.md "Access gate"); reactivation is the frozen
`FableEtudes/01-paiement-en-ligne`.

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
  any base-authoring plan for those grades starts with a persistence-layer item. For the lycée the
  corpus itself must first be extended with the official **secondary** programmes/manuels
  (`docs/lycee-architecture.md` station L1). Exception pilote : `programme/bac-math/mathematiques.md`
  (transcription 🚧 pilote 2026-07-05, hors corpus, chapitre 1 seul à profondeur de génération — à
  valider avant toute montée en charge).
- Professor overlay: primaire (math/arabe/éveil/islamique), 6ème math, collège 7ème–8ème
  (math/physique/SVT/arabe/français/anglais), 9ème full core, **lycée** (section-aware, 1ère
  sec→bac: math/physique/SVT/français/anglais/arabe/philo/histoire-géo/éco-gestion/info — all
  waiting on the lycée base, which waits on L0–L2).

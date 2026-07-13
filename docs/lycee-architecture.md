# Lycée (secondaire) — architecture, pipeline & workflows

> Design doc for extending the academy to the **Tunisian secondary cycle** (1ère année secondaire →
> Baccalauréat). It settles the two structural questions the lycée forces — **sections** and the
> **Arabic→French language switch** — then lays out the complete content pipeline (cours + base +
> exercices difficiles + interactifs, every mission type and tier) and the phased rollout. Status:
> **L0 live, build-out governed by étude 16** — the §6 seed migration is **merged and applied**
> (`20260704235000_lycee_section_grades_seed.sql`, PR #285: 16 section nodes + `coming_soon`
> parcours + `grades.is_selectable`), and a pilot unit runs the full pipeline end-to-end on
> `bac-math` × mathématiques (chapter `content/math-bac-math/01-continuite-limites`; parcours
> opened free by `20260705100000`/`20260705120000`). The opening itself — UI year→section
> grouping, grade i18n, the shared-content `compileTo` mechanism and the wave plan — is specified
> in [`FableEtudes/16-ouverture-lycee/ETUDE.md`](../FableEtudes/16-ouverture-lycee/ETUDE.md).
> Defers to CLAUDE.md (DoD §7) and to `content-engine/references/generation-pipeline.md` for
> anything that overlaps.

## 1. The two structural facts

1. **Sections.** From 2ème année secondaire the national ladder branches: 2ème = orientation
   branches (sciences, lettres, économie & services, technologies de l'informatique), 3ème + bac =
   sections (mathématiques, sciences expérimentales, lettres, économie & gestion, sciences
   techniques, sciences de l'informatique — sport exists but is out of the initial perimeter).
   The current data model has one grade node per year and no section dimension.
2. **Language switch.** Subjects taught **in Arabic through 9ème** — mathématiques, sciences
   physiques, SVT, informatique/technologie — are taught **in French** at the lycée. Same matière,
   same student, new language: a major didactic discontinuity the pipeline must treat as a
   first-class concern (§4), not a footnote.

## 2. Section modelling — sections are grade nodes (decision)

**A section-year is a `grades` row** under `ecole-tn` (e.g. `bac-math`), exactly like `9eme-base`.

Why this beats the alternatives: `grades` is a light seed table (`UNIQUE(theme_id, slug)`), and the
whole product stack — `(theme, grade) → parcours` resolution (`uq_parcours_theme_grade`), premium
entitlements, onboarding grade pick (`profiles.current_grade_id`), dashboard scoping, subject FK —
works **unchanged** on new grade rows. Encoding sections in subjects would break parcours scoping
(one student would see every section's subjects); adding a real `section` column would ripple
through profiles/parcours/onboarding for no additional expressive power. A Tunisian student says
"أنا باك رياضيات" — the section-year IS their grade.

### Grade slugs (canonical — chosen once, slugs are identity)

| year     | slugs                                                                                                                             | concours |
| -------- | --------------------------------------------------------------------------------------------------------------------------------- | -------- |
| 1ère sec | `1ere-sec` (tronc commun — existing row, unchanged)                                                                               | —        |
| 2ème sec | `2eme-sec-sciences` · `2eme-sec-lettres` · `2eme-sec-eco-services` · `2eme-sec-info`                                              | —        |
| 3ème sec | `3eme-sec-math` · `3eme-sec-sciences-exp` · `3eme-sec-lettres` · `3eme-sec-eco-gestion` · `3eme-sec-techniques` · `3eme-sec-info` | —        |
| bac      | `bac-math` · `bac-sciences-exp` · `bac-lettres` · `bac-eco-gestion` · `bac-techniques` · `bac-info`                               | **yes**  |

**Legacy flat nodes** (`2eme-sec`, `3eme-sec`, `bac`, seeded in `20260605120000`): never deleted
(slugs/UUIDs are identity; a profile might reference them). They become **non-selectable** via a
new `grades.is_selectable` flag (§6) and carry no subjects/parcours. `1ere-sec` stays live — the
tronc commun genuinely has no section.

### Subject-id convention (lycée)

`<matière>-<gradeSlug>` **verbatim** — mechanical, collision-free, self-describing:
`math-1ere-sec`, `math-2eme-sec-sciences`, `math-bac-math`, `svt-bac-sciences-exp`,
`philosophie-bac-lettres`, `informatique-bac-info`. Économie & gestion are **two official
matières → two subjects** (`economie-*`, `gestion-*`). Where two sections share a genuinely
identical programme for a matière (confirmed on the official transcription, station L1), the
content is **authored once and compiled to one subject per section** via the content pipeline's
`compileTo` fan-out (étude 16 D-4 — the compiled ids keep this verbatim convention, so a later
fork to a dedicated dir loses no student progress). Structural divergence (different chapter
list) ⇒ separate dirs from the start; depth-only divergence ⇒ shared dir + per-exercise
`gradeSlugs` filters.

## 3. Programme matrix (sections × matières — planning level)

Tronc présent partout : arabe, français, anglais, philosophie (3ème/bac), histoire-géo, sport/hors
périmètre. Dominantes par section (poids/coefficients **à confirmer** contre les textes officiels
lors de la transcription — station L1) :

| section      | dominantes                                                | fortes aussi                |
| ------------ | --------------------------------------------------------- | --------------------------- |
| math         | mathématiques, sciences physiques                         | informatique                |
| sciences-exp | SVT, sciences physiques                                   | mathématiques               |
| lettres      | arabe, philosophie, histoire-géo                          | français, anglais           |
| eco-gestion  | économie, gestion                                         | histoire-géo, mathématiques |
| techniques   | technologie/sciences techniques, mathématiques, physique  | informatique                |
| info         | informatique (algorithmique, programmation, BD, systèmes) | mathématiques, physique     |

The stable per-grade detail lives in `curriculum-architect/references/programme-map.md`; the
authoritative scope will live in the **secondary programme transcriptions** (station L1).

## 4. Language policy — native-French generation for the switched subjects (the major change)

Per-subject `contentLanguage` at the lycée:

- **`fr`**: mathématiques, sciences physiques, SVT, informatique, sciences techniques — **and**
  français. These four science subjects are the **switched** ones (ar → fr after 9ème).
- **`ar`**: arabe, philosophie, histoire-géo, pensée islamique/éducation civique (if added) —
  et économie/gestion _(langue à confirmer contre les programmes officiels)_.
- **`en`**: anglais.

**Native-French rule (décision 2026-07-13 — replaces the former «pont linguistique»)** — owned by
the **base layer** (`content-ecole-tn`) and enforced by `content-audit`:

1. **No translation, ever**: a `fr` subject is **authored natively in French** — no fr↔ar
   «lexique de transition», no Arabic glosses at first use, no `NN-pont-linguistique` missions.
   The pre-2026-07-13 "transition bridge" apparatus formerly specified here is **withdrawn**.
2. **Official jargon**: the terminology is that of the official French documentation — the CNP
   manuels élève, captured verbatim by the L1 transcriptions
   (`programmes-officiels/programme/<gradeSlug>/`), which are the terminology reference at
   authoring time.
3. **Notation unchanged**: digits/equations were already standard LTR in the Arabic years — the
   deliberate payoff of `math-and-notation.md`; they carry over untouched.
4. **Prose discipline**: a `fr` subject is written in French only — no code-switching in
   stems/options (bidi noise, and the skill QA treats it as language impurity).

## 5. Parcours & premium

One parcours per section-grade node (the `(theme, grade)` unique index guarantees it):

- **`bac-*` = PREMIUM `concours` parcours** (like `concours-9eme`/`concours-6eme`):
  entitlement-gated d3–4, `preview_policy: difficulty_1` (quiz + d1 free), Dungeon perk included.
- **`1ere-sec`, `2eme-sec-*`, `3eme-sec-*` = FREE `scolaire` parcours** (the seeded kind — the
  regular school-year track, CHECK widened by `20260617120000`): d3–4 are the hard tier of the
  free ladder.
- Parcours rows ship `status: 'coming_soon'` in the seed and flip to `available` per section as
  content lands (same mechanism as the existing `open_*_parcours` migrations; opening threshold:
  étude 16 R-8).
- **Free-phase note (étude 15 Q-2, migration `20260711100000`)**: `is_premium = false` everywhere
  for now — the premium design above is the dormant target state, reactivated by étude 01.

## 6. DB migration spec (station L0 — ✅ DONE, merged 2026-07-05, PR #285)

Realized as `20260704235000_lycee_section_grades_seed.sql` (spec kept below for reference). One
seed migration (timestamp after newest; no new table → no new grants beyond the existing
`grades` posture):

1. `ALTER TABLE public.grades ADD COLUMN IF NOT EXISTS is_selectable BOOLEAN NOT NULL DEFAULT true;`
2. `UPDATE public.grades SET is_selectable = false WHERE theme_id='ecole-tn' AND slug IN ('2eme-sec','3eme-sec','bac');`
3. `INSERT INTO public.grades (theme_id, slug, name_fr, cycle, is_concours_national, display_order) VALUES …`
   the 16 section nodes of §2 (`ON CONFLICT (theme_id, slug) DO NOTHING`; `display_order` continues
   after the existing ladder, grouped year by year; `is_concours_national=true` on the six `bac-*`).
4. `INSERT INTO public.parcours …` one row per node per §5 (`coming_soon`).

Code follow-ups (separate PRs, after the migration): onboarding grade picker groups lycée nodes by
year → section (UI only); any `grades` listing filters on `is_selectable`; grade names get
`name_en`/`name_ar` — **all specified as étude 16 lots 2-3** (the flag is read nowhere yet).
**No destructive step**: retiring the flat legacy nodes for real is a later,
separate destructive migration — only after verifying zero `profiles.current_grade_id` references.

## 7. The complete mission ladder (every type & tier, per lycée chapter)

Canonical rewards/gates unchanged (`rewards-and-modes.md`). Per chapter of a lycée subject:

| file                     | tier/mode              | role                                                                          | free on bac-\*? |
| ------------------------ | ---------------------- | ----------------------------------------------------------------------------- | --------------- |
| `quiz.json` (auto)       | quiz 20/5              | comprehension gate (≥80% unlocks — school rule)                               | ✅ preview      |
| `01-pratique`            | d1 practice 50/10      | free intro                                                                    | ✅ preview      |
| `03-revision`            | d2 practice 75/15      | standard free practice                                                        | ❌              |
| `NN-mission-interactive` | d2 practice 75/15      | mixed interactive formats (≥3, `interactive-formats.md`)                      | ❌              |
| `NN-sprint-chrono`       | d2–d3 boss 120/30      | timed automatisms (calcul, conjugaison, vocab, SQL reading)                   | ❌              |
| `02-boss`                | d3 boss 120/30         | chapter boss, exam-question strength (`prof-*-lycee`)                         | ❌              |
| `NN-histoire-<slug>`     | d3 boss / d4 challenge | story-quest scenario (lab, enquête, dossier économique)                       | ❌              |
| `04-defi`                | d4 challenge 300/60    | élite, cross-chapter combinations (`prof-*-lycee`)                            | ❌              |
| `NN-annales-bac`         | d4 challenge 300/60    | **bac-\* only** — annales/session-principale style, top-decile discriminators | ❌              |

Interactive formats especially suited to the lycée: **lecture de document/données** (études de doc
histoire-géo/éco, courbes physique/SVT, traces d'exécution info), **vrai/faux motivé** (thèses philo,
analyses littéraires), **remise en ordre** (démonstrations, algorithmes, chronologies), **QCM visuel
SVG** (courbes, schémas expérimentaux, géométrie de l'espace).

## 8. Pipeline stations & skill hand-off (the lycée workflow end-to-end)

The five stations of `curriculum-architect` §2 apply, with lycée-specific content:

| station              | lycée instantiation                                                                                                                                                                                                                | executing skill / actor                                                                     |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **L0 — product/DB**  | §6 seed migration + onboarding/section UI follow-up                                                                                                                                                                                | human + normal dev flow                                                                     |
| **L1 — persistence** | transcribe the **official secondary programmes** per (section-grade × matière) into `programmes-officiels/programme/<gradeSlug>/` (extend the corpus: secondary sources are ministry programmes + manuels scolaires du secondaire) | dedicated persistence session                                                               |
| **L2 — base**        | `content-ecole-tn`: cours + resume + quiz + d1/d2 ladder (fr subjects: native French, official jargon — §4)                                                                                                                        | `content-ecole-tn` (+ `content-cours`)                                                      |
| **L3 — ceiling**     | d3 boss / d4 défi / `NN-annales-bac` on existing chapters                                                                                                                                                                          | `prof-{math,physique,svt,francais,anglais,arabe,philo,histoire-geo,eco-gestion,info}-lycee` |
| **L4 — interactive** | missions interactives, sprints, histoires, documents                                                                                                                                                                               | `content-interactif`                                                                        |
| **L5 — audit**       | re-solve + language-purity check (no ar/fr code-switching outside the bridge) + program conformance                                                                                                                                | `content-audit`                                                                             |

**Build priority** (defaults — `curriculum-architect` arbitrates live): ① L0 migration; ② L1+L2 for
**`1ere-sec`** (tronc commun: one subject set serves every future section — highest leverage, and
it's where the language bridge lives); ③ **`bac-math` + `bac-sciences-exp`** (the premium concours
products, math/physique/SVT/anglais first); ④ remaining bac sections; ⑤ 2ème/3ème sec fill.
Overlay (L3) and interactive (L4) run per chapter-batch behind the base, as everywhere else.

### Trade-offs accepted (v1)

- **Tronc-commun mutualisation** _(supersedes the earlier "duplication accepted v1" trade-off)_:
  languages/philo/histoire-géo shared across sections are authored **once per (matière × year)**
  and compiled to one subject per section (`compileTo` fan-out — étude 16 D-4, pipeline lot 1).
  Per-section depth differences stay expressible (per-exercise `gradeSlugs`); parcours scoping is
  untouched (still one subject per grade in DB); UUIDs derive from the compiled identity, so
  forking a section out later is loss-free. Share/fork doctrine: étude 16 D-4.b (decided per
  matière at station L1 — the closer to the exam, the less is shared).
- **Sport section, 3èmes langues (allemand/espagnol/italien), pensée islamique**: out of the
  initial perimeter; add via the same conventions when the product asks.

## 9. Open questions (flagged, not guessed)

- Économie/gestion language of instruction _(ar assumed — confirm against official programmes)_.
- Exact coefficients per section (planning weights only — confirm at transcription time).
- Whether 3ème sec should get an exam-prep premium tier ("bac blanc") — product call, the model
  supports it without change (`parcours.kind` stays per-node).
- Source corpus for secondary programmes (ministry publications vs CNP) — settled at station L1.

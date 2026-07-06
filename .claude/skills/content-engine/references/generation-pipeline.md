# Generation pipeline — one map for every content skill

This is the **single, canonical map** of how exercise/content generation works in this repo: which
skill to use for which task (planning vs base vs professor skills), and the **reproducible,
cumulative, non-redundant** workflow for enriching `content/` over time. Every content skill (old and new)
follows it. When this file disagrees with a wrapper skill, this file wins — fix the wrapper.

Read this **before** starting any content-generation task. It sits above `content-engine/SKILL.md`
(the shared authoring core) and the per-program wrappers.

## The three layers (how the skills fit together — no overlap)

Content generation is **a planning layer + two authoring layers**, not competing tracks:

0. **Planning layer — decide what to build.** `curriculum-architect` audits coverage (all 13
   grades × official subjects + non-school themes, live recompute), defines pedagogical objectives
   and chapter progression for a grade×subject, and produces a prioritized, dependency-aware
   backlog (which skill executes what, in which order — CNP transcription → base → professor →
   interactive → audit). It **plans only** — it never writes `content/` files. Its
   `references/programme-map.md` is the official grade×subject matrix. Use it before any
   multi-chapter campaign; skip it for a single well-scoped request.

1. **Base layer — build & complete a chapter.** Creates/edits the whole unit: `subject.json`,
   `cours.md`, `resume.md`, `quiz.json`, and the **free core ladder** (difficulty 1–2, plus the
   standard `02-boss`/`04-defi` when authoring a full chapter). Skills:
   - `content-engine` — the shared core (schema, quality bar, rewards, style, validation). Every
     other content skill defers here.
   - Program wrappers (each adds its program's scope/rules on top of the core):
     `content-ecole-tn` (national school program — the sensitive, high-fidelity track),
     `content-culture-generale`, `content-muscle-cerveau`, `content-iq-training`,
     `content-langue-anglais` / `content-langue-francais` / `content-langue-arabe`.
   - `content-cours` — course/summary text only (`cours.md`/`resume.md`), in place.
   - `content-interactif` — **interactive/innovative missions** beyond the classic QCM (cloze,
     chasse à l'erreur, appariement, remise en ordre, QCM visuel SVG, lecture de document,
     histoire-problème, vrai/faux motivé, sprint chrono), encoded in the current QCM engine —
     format catalogue: `references/interactive-formats.md` (Tier A). Native input types are
     **Tier B** (`docs/interactive-question-types.md`), **all shipped**: `numeric`,
     drag-&-drop `ordering`/`matching`, and `multi` (multi-select) are all authorable
     (shapes: `references/content-schema.md`).
   - `content-audit` — reviews **existing** content (re-solves, grades); fixes only on request.

2. **Professor overlay — raise the ceiling.** Adds **harder** exercises (difficulty 3–4, boss/défi)
   on top of an existing chapter's ladder for a specific **matière × niveau**, like a real subject
   teacher. Skills (`.claude/skills/prof-*`), each carrying a real chapter map + a subject trap
   taxonomy, all deferring to `references/expert-exercises.md` and to `content-ecole-tn` for fidelity:
   - Exam years (dedicated): `prof-math-9eme`, `prof-physique-9eme` (subject id `svt`),
     `prof-svt-9eme` (id `sciences-vie-terre`), `prof-francais-9eme`, `prof-arabe-9eme`,
     `prof-anglais-9eme`, `prof-math-6eme`.
   - Primary cycle (grade-aware, multi-level): `prof-math-primaire` (1ère→5ème),
     `prof-arabe-primaire` (1ère→5ème), `prof-eveil-primaire` (1ère→6ème),
     `prof-islamique-primaire` (1ère→4ème).
   - Collège cycle (grade-aware, 7ème–8ème; 9ème keeps its dedicated professors):
     `prof-math-college`, `prof-physique-college`, `prof-svt-college`, `prof-arabe-college`,
     `prof-francais-college`, `prof-anglais-college`. ⚠ 8ème's base is still empty
     (scaffold only, CNP transcription pending) — a professor only overlays **existing** chapters,
     so 8ème work waits on the base layer.
   - Lycée cycle (section-aware, 1ère sec→bac — sections are grade nodes, see
     `docs/lycee-architecture.md`): `prof-math-lycee`, `prof-physique-lycee`, `prof-svt-lycee`,
     `prof-francais-lycee`, `prof-anglais-lycee`, `prof-arabe-lycee`, `prof-philo-lycee`,
     `prof-histoire-geo-lycee`, `prof-eco-gestion-lycee`, `prof-info-lycee`. They also own the
     `NN-annales-bac` d4 tier on `bac-*` grades. ⚠ The whole lycée base is empty and its stations
     (seed migration → secondary-programme transcriptions → base) come first — lycée professor work
     is queued behind them.

The overlay **never** replaces the base: professors only **add** top-tier files to a chapter that
already exists; they never rewrite the course/quiz or convert a free d1–2 mission to premium d3–4.

## Skill selection map (task → skill)

| You want to…                                                                                   | Use…                                                        |
| ---------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| **Plan coverage / roadmap / objectives & progression** (what's missing, what next)             | `curriculum-architect`                                      |
| Create a **new chapter** (course + quiz + base ladder), school program                         | `content-ecole-tn`                                          |
| Create a new chapter for a non-school theme                                                    | the matching `content-*` wrapper (culture/iq/langue/muscle) |
| Write/rewrite **only the course or summary**                                                   | `content-cours`                                             |
| Write/rewrite **only the quiz** or add **free d1–2** practice                                  | the program wrapper (or `content-engine` base)              |
| Add **interactive/innovative missions** (cloze, appariement, ordre, visuel, histoire, sprint…) | `content-interactif`                                        |
| Add **hard/elite d3–4** exercises for a school matière × niveau                                | the matching **`prof-*`** skill                             |
| **Audit / fix** existing content (wrong keys, weak distractors, …)                             | `content-audit`                                             |
| Understand schema / quality bar / rewards / notation                                           | `content-engine` `references/*`                             |

If a request is "make harder exercises for <school subject> <grade>", prefer the `prof-*` skill; if
it's "add a chapter / write the lesson / fix content", use the base/program skill. When in doubt, the
base skill (`content-ecole-tn`) is the safe default and will point you to the professor for hard tiers.

## Agent roles → skills (the assembly line, mapped)

The pipeline is a virtual editorial team; each classic role maps to a skill or a deliberate
mechanism — don't invent a parallel agent where a station already exists:

| Role                  | Where it lives                                                                                                                                                                                                                |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Curriculum designer   | `curriculum-architect` (objectives, progression, coverage backlog)                                                                                                                                                            |
| Content writer        | `content-cours` (+ the program wrappers for full chapters)                                                                                                                                                                    |
| Exercise designer     | program wrappers (base ladder) · `content-interactif` (formats) · `content-iq-training` (visual reasoning)                                                                                                                    |
| Subject professor     | `prof-*` overlay (hard d3–4, per matière × niveau/cycle)                                                                                                                                                                      |
| Question reviewer     | `content-audit` (re-solve, ambiguity/duplicate hunt) + `content:qa:strict` (structural) + `content-audit.yml` (scheduled correctness net)                                                                                     |
| Translator            | **by design, none**: non-school themes = three sibling subjects authored **natively** per language (never translated); school content is **monolingual** in the official language of instruction (`themes-and-trilingual.md`) |
| Difficulty calibrator | **encoded rules, not an agent**: canonical reward/difficulty table (`rewards-and-modes.md`) + d3/d4 calibration (`expert-exercises.md`); skills apply them, `content:qa` checks them                                          |
| SQL/JSON exporter     | **deterministic script, never an LLM**: `scripts/content/build.ts` (Zod-validated files → idempotent UUIDv5 migrations) — hand-written SQL is forbidden                                                                       |

## Cumulative & non-redundant — the rules that keep enrichment clean over time

The pipeline is **additive**: content grows chapter by chapter, tier by tier, without churn. The
following rules are what make repeated enrichment safe (they all flow from _slugs = identity_, since
row UUIDs are deterministic UUIDv5 of the slugs):

1. **Audit the existing ladder first.** Before adding anything to a chapter, read
   `content/<subject>/<NN-chapter>/exercices/*.json`. Know what tiers and questions already exist.
2. **Fill upward, never sideways.** Add the **missing** tier, or a **new top tier** above the current
   ceiling — never a near-duplicate of an existing exercise. New files take the **next free**
   `NN`/`displayOrder` (e.g. `06-defi-concours.json` above an existing `04-defi`).
3. **Never rename, renumber, or reorder.** Renaming a subject `id`, a chapter folder, an exercise
   filename, or reordering questions by difficulty **re-keys the UUIDs** → delete+recreate instead of
   update (orphaned rows, lost progress). Choose slugs once.
4. **Never duplicate a question** already present elsewhere in the chapter. New tiers must be
   _strictly harder / different_, not a reskin.
5. **Parent-authored content is never touched** by the generator (only admin/`content/` rows are
   upserted and pruned).
6. **One subject = one regenerated migration per change** (see below) — no duplicate migrations for
   unchanged subjects.

## The reproducible build → migration procedure (this is the trap — read it)

Authored files under `content/` are compiled to **idempotent** Supabase migrations by
`scripts/content/build.ts`. The reproducible sequence for a change:

1. **Validate (writes nothing):** `npm run content:check` then `npm run content:qa:strict`
   (must report **0 errors**; the pedagogical self-verification in `quality-bar.md` is what actually
   guarantees correctness — the tools only catch structure).
2. **Regenerate the migration for the changed subject(s) ONLY:**

   ```bash
   npm run content:build -- --subject <subject-id>
   ```

   ⚠️ **The #1 pipeline trap:** bare `npm run content:build` (no `--subject`) regenerates **every**
   subject (~60) with a **fresh timestamp**, producing dozens of new
   `*_generated_<id>_content.sql` files that are byte-for-different-timestamp duplicates of unchanged
   subjects. **Never commit those.** Always scope with `--subject <id>` so exactly **one** migration
   is produced. If several subjects changed, run it once per changed subject.
   - The default fresh timestamp (now) always sorts after existing migrations — correct. Pass
     `--timestamp <YYYYMMDDHHMMSS>` only if you need a deterministic value; it must sort **after** the
     newest existing migration (the `Migration order` gate enforces this).
   - If a stray full-build happened, discard the spurious files: `git clean -f supabase/migrations/`
     (only removes untracked), then rebuild with `--subject`.

3. **Commit the `content/` files together with the single generated migration** for that subject.
   The migration **auto-applies to prod on merge** via `db-migrate-prod.yml` (pre-apply `pg_dump`
   backup; never apply by hand, never hand-edit the generated SQL).
4. **Stop and report** (files, counts, `content:check`/`content:qa:strict` summary). Push/PR only when asked.

`content:check` in CI re-compiles the authored content and proves it still matches — an edit that
forgot the rebuild is caught there.

## End-to-end checklist (copy this)

- [ ] Right skill chosen (base vs professor — selection map above).
- [ ] Existing ladder audited; new work fills upward, no rename/renumber, no duplicate questions.
- [ ] Quality bar + self-verification (re-solve blind; executed-error distractors; notation standard;
      `الخطأ الشائع`/trap named on d3–4 — see `expert-exercises.md`).
- [ ] `npm run content:check` ✓ · `npm run content:qa:strict` → 0 error.
- [ ] `npm run content:build -- --subject <id>` → exactly one new migration; no stray full-build files.
- [ ] `content/` files + the one migration staged together; report written; push/PR only if asked.

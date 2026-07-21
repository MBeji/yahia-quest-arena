/**
 * Seed the self-contained E2E FIXTURE CATALOGUE into the TEST Supabase project.
 *
 * Why this exists (étude 24 aftermath): the pedagogical corpus left this repo for
 * the private one and no longer travels in migrations, so `supabase db push`
 * rebuilds only the legacy `mcq` seed. Every question type the suite exercises
 * (numeric / ordering / matching / multi), the `recall` mode, and the non-school
 * families (`culture-generale`, `muscle-cerveau`) were therefore reproducible
 * ONLY from content frozen in the TEST project before the split — invisible to a
 * fresh reprovision, which would make the matching specs SKIP silently while the
 * suite still reported green (see e2e/public-anon/catalogue-coverage.spec.ts).
 *
 * This script rebuilds that coverage from committed fixtures alone, so a blank
 * TEST project reaches full, honest coverage. It is TEST-ONLY on purpose: a
 * migration would auto-apply to prod (db-migrate-prod.yml) and expose synthetic
 * fixture questions to real students. `_env.mjs` refuses any prod ref on import.
 *
 * Idempotent: every row carries a stable id and is upserted, so re-running is a
 * no-op refresh. The fixture subjects use a high display_order so they never
 * reorder a real catalogue (they sort last where real content still exists, and
 * are simply the only non-school subjects on a blank project).
 *
 *   SUPABASE_URL=...                 (the TEST project URL)
 *   SUPABASE_SERVICE_ROLE_KEY=...
 *   node scripts/e2e/seed-fixture-content.mjs
 *
 * ⚠️ Never run against production. Apply the migrations first (`e2e:db:push`) so
 * the schema (tables, `question_type`/`answer_key`, the theme rows) exists.
 */
import "./_env.mjs";
import { createClient } from "@supabase/supabase-js";

const URL = process.env.SUPABASE_URL ?? process.env.TEST_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!URL || !SERVICE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.");
  process.exit(1);
}

const admin = createClient(URL, SERVICE_KEY, { auth: { persistSession: false } });

// Stable ids. subjects.id is TEXT (a slug); chapters/exercises/questions are
// UUID — hard-code hex-only, deterministic UUIDs so re-seeding is idempotent.
const CULTURE = "e2e-fixture-culture";
const MUSCLE = "e2e-fixture-muscle";
const CH_CULTURE = "e2ec0000-0000-4000-a000-000000000001";
const CH_MUSCLE = "e2ec0000-0000-4000-a000-000000000002";
const EX_MCQ = "e2ee0000-0000-4000-a000-000000000001";
const EX_NUMERIC = "e2ee0000-0000-4000-a000-000000000002";
const EX_BOARD = "e2ee0000-0000-4000-a000-000000000003";
const EX_MULTI = "e2ee0000-0000-4000-a000-000000000004";
const EX_MUSCLE = "e2ee0000-0000-4000-a000-000000000005";
const q = (n) => `e2e90000-0000-4000-a000-0000000000${String(n).padStart(2, "0")}`;

// Non-school (grade_id null) → never quiz-gated, playable by an anonymous
// visitor. A high display_order keeps these out of the way of any real catalogue.
const subjects = [
  {
    id: CULTURE,
    name_fr: "Fixture e2e — Culture générale",
    description: "Catalogue fixture e2e (types de questions natifs + recall).",
    attribute: "Sagesse",
    color_token: "subject-svt",
    icon: "Globe",
    theme_id: "culture-generale",
    grade_id: null,
    is_premium: false,
    display_order: 900,
  },
  {
    id: MUSCLE,
    name_fr: "Fixture e2e — Muscler ton cerveau",
    description: "Catalogue fixture e2e (présence de la famille muscle-cerveau).",
    attribute: "Esprit",
    color_token: "subject-math",
    icon: "Brain",
    theme_id: "muscle-cerveau",
    grade_id: null,
    is_premium: false,
    display_order: 901,
  },
];

const chapters = [
  { id: CH_CULTURE, subject_id: CULTURE, title: "Fixture — types de questions", display_order: 1 },
  { id: CH_MUSCLE, subject_id: MUSCLE, title: "Fixture — logique", display_order: 1 },
];

// `source:'admin'` + `mode:'practice'` (non-quiz) = the anonymous-checkable
// catalogue the native/recall helpers filter on (e2e/helpers/db.ts).
const exBase = { source: "admin", mode: "practice", difficulty: 1, xp_reward: 20, reward_coins: 5 };
const exercises = [
  // display_order 1 → the subject's freeExerciseId (recall + progression-stats target).
  {
    ...exBase,
    id: EX_MCQ,
    subject_id: CULTURE,
    chapter_id: CH_CULTURE,
    title: "QCM (recall)",
    display_order: 1,
  },
  {
    ...exBase,
    id: EX_NUMERIC,
    subject_id: CULTURE,
    chapter_id: CH_CULTURE,
    title: "Numérique",
    display_order: 2,
  },
  {
    ...exBase,
    id: EX_BOARD,
    subject_id: CULTURE,
    chapter_id: CH_CULTURE,
    title: "Ordonner / Associer",
    display_order: 3,
  },
  {
    ...exBase,
    id: EX_MULTI,
    subject_id: CULTURE,
    chapter_id: CH_CULTURE,
    title: "Choix multiples",
    display_order: 4,
  },
  {
    ...exBase,
    id: EX_MUSCLE,
    subject_id: MUSCLE,
    chapter_id: CH_MUSCLE,
    title: "Suite logique",
    display_order: 1,
  },
];

// A helper for the classic-mcq shape (options + correct_option, no answer_key).
const mcq = (id, exercise_id, order, prompt, options, correct) => ({
  id,
  exercise_id,
  prompt,
  options,
  correct_option: correct,
  question_type: "mcq",
  answer_key: null,
  display_order: order,
});
// A helper for the native shape (typed answer_key, correct_option NULL).
const native = (id, exercise_id, order, prompt, type, options, answer_key) => ({
  id,
  exercise_id,
  prompt,
  options,
  correct_option: null,
  question_type: type,
  answer_key,
  display_order: order,
});

const questions = [
  // EX_MCQ — 3 recall-eligible mcq (≥3 options, short keyed text): satisfies
  // recallReadyExercise (RECALL_MIN_QUESTIONS=3) and progression-stats' text match.
  mcq(
    q(1),
    EX_MCQ,
    1,
    "Quelle est la capitale de la France ?",
    [
      { id: "a", text: "Paris" },
      { id: "b", text: "Lyon" },
      { id: "c", text: "Marseille" },
    ],
    "a",
  ),
  mcq(
    q(2),
    EX_MCQ,
    2,
    "Quelle couleur obtient-on en mélangeant du bleu et du jaune ?",
    [
      { id: "a", text: "Vert" },
      { id: "b", text: "Orange" },
      { id: "c", text: "Violet" },
    ],
    "a",
  ),
  mcq(
    q(3),
    EX_MCQ,
    3,
    "Sur quelle planète vivons-nous ?",
    [
      { id: "a", text: "Terre" },
      { id: "b", text: "Mars" },
      { id: "c", text: "Vénus" },
    ],
    "a",
  ),
  // EX_NUMERIC — one numeric question (answer_key.value, no options).
  native(q(10), EX_NUMERIC, 1, "Combien font 40 + 2 ? (réponds par un nombre)", "numeric", [], {
    value: 42,
  }),
  // EX_BOARD — one ordering + one matching (boardExerciseId matches either).
  native(
    q(20),
    EX_BOARD,
    1,
    "Range ces nombres du plus petit au plus grand.",
    "ordering",
    [
      { id: "s1", text: "1" },
      { id: "s2", text: "2" },
      { id: "s3", text: "3" },
    ],
    { order: ["s1", "s2", "s3"] },
  ),
  native(
    q(21),
    EX_BOARD,
    2,
    "Associe chaque pays à sa capitale.",
    "matching",
    [
      { id: "l1", text: "France" },
      { id: "l2", text: "Espagne" },
      { id: "r1", text: "Paris" },
      { id: "r2", text: "Madrid" },
    ],
    {
      pairs: [
        ["l1", "r1"],
        ["l2", "r2"],
      ],
    },
  ),
  // EX_MULTI — one multi (proper subset correct; ≥3 options so one is wrong).
  native(
    q(30),
    EX_MULTI,
    1,
    "Quels de ces nombres sont pairs ? (coche TOUT ce qui s'applique)",
    "multi",
    [
      { id: "a", text: "2" },
      { id: "b", text: "3" },
      { id: "c", text: "4" },
    ],
    { correct: ["a", "c"] },
  ),
  // EX_MUSCLE — one mcq so the muscle-cerveau family has a listed subject.
  mcq(
    q(40),
    EX_MUSCLE,
    1,
    "Suite logique : 2, 4, 6, … ?",
    [
      { id: "a", text: "8" },
      { id: "b", text: "7" },
      { id: "c", text: "9" },
    ],
    "a",
  ),
];

async function upsert(table, rows) {
  const { error } = await admin.from(table).upsert(rows, { onConflict: "id" });
  if (error) throw new Error(`${table}: ${error.message}`);
  console.log(`✓ ${table.padEnd(10)} ${rows.length} row(s)`);
}

async function main() {
  // Order matters for the FKs: subjects → chapters → exercises → questions.
  await upsert("subjects", subjects);
  await upsert("chapters", chapters);
  await upsert("exercises", exercises);
  await upsert("questions", questions);
  console.log(
    `\nSeeded the e2e fixture catalogue: 2 families, ${exercises.length} exercises, ${questions.length} questions ` +
      "(mcq/recall, numeric, ordering, matching, multi).",
  );
}

main().catch((e) => {
  console.error("Fixture seed failed:", e.message ?? e);
  process.exit(1);
});

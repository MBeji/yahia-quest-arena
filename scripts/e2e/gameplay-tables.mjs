/**
 * Tables cleared by reset-gameplay.mjs between E2E runs.
 * Kept in a side-effect-free module so unit tests can import this list
 * without triggering the reset script's DB connection.
 *
 * Order: children before parents (FK constraints). Tolerant reset: a MISSING
 * table is skipped, not fatal — and only a missing table (see `isMissingTableError`).
 *
 * When adding a new mutable gameplay table, add it HERE (not inline in
 * reset-gameplay.mjs). ⚠️ The co-located test spot-checks NAMED tables whose
 * omission has a known cost — it cannot detect a table nobody thought of, so
 * adding the line here is still a human step.
 */
export const GAMEPLAY_TABLES = [
  "attempts",
  // Le grand livre des étoiles et des sceaux (étude 34). Il doit partir avec le
  // reste, et pour une raison que les autres tables n'ont pas : il est
  // **insert-only et monotone** (R-6). Une étoile inscrite ne se retire jamais,
  // donc sans ce nettoyage le premier run laisse le décor DÉFINITIVEMENT acquis —
  // et toute assertion sur un delta (`starAfter > starBefore`, un sceau qui tombe,
  // un badge de maîtrise) passe une fois puis échoue à chaque run suivant, sur un
  // code pourtant sain. `student_badges` est déjà vidé juste en dessous, mais cela
  // ne suffit pas : les trois badges ne se décernent que lorsqu'un sceau est
  // réellement INSÉRÉ, donc un grand livre survivant les rend indécernables.
  "user_subject_seals",
  "user_chapter_stars",
  "dungeon_run_questions",
  "dungeon_runs",
  "spaced_repetition_schedule",
  "daily_objectives",
  "weekly_quests",
  "student_badges",
  "inventory_items",
  "exercise_assignments",
  "rate_limit_events",
  // User-submitted reports: the nightly E2E spec submits one per run; without
  // clearing these they accumulate and pollute the production-triage queue.
  "content_reports",
  "bug_reports",
];

/**
 * Le filtre « toutes les lignes » du reset est `.not(<clé>, "is", null)` : PostgREST
 * refuse un DELETE sans filtre, et la clé doit EXISTER dans la table. Le grand livre n'a
 * pas de colonne `id` — sa clé primaire est composite `(user_id, chapter_id | subject_id,
 * star)` — et le reset l'a sauté en silence dès sa première nuit (2026-09-15) :
 * « column user_chapter_stars.id does not exist », rangé avec les tables absentes.
 * Quatre nuits rouges sur un code sain, très exactement le scénario que le commentaire
 * ci-dessus annonçait (#1047). La clé se déclare ICI, à côté de la table qu'elle sert.
 */
export const ROW_KEY = Object.freeze({
  user_subject_seals: "user_id",
  user_chapter_stars: "user_id",
});

/** La colonne sur laquelle le reset pose son filtre « toutes les lignes ». */
export function rowKey(table) {
  return ROW_KEY[table] ?? "id";
}

/**
 * Seule une table ABSENTE se saute (PostgREST `PGRST205` « Could not find the table … in
 * the schema cache », ou Postgres `42P01`). Toute autre erreur — colonne inconnue, clé
 * étrangère, RLS — est un reset qui n'a pas eu lieu : un run e2e qui partirait sur ce
 * décor sale échouerait plus tard, ailleurs, sur un code sain.
 */
export function isMissingTableError(error) {
  if (!error) return false;
  if (error.code === "PGRST205" || error.code === "42P01") return true;
  return /could not find the table|relation .* does not exist/i.test(String(error.message ?? ""));
}

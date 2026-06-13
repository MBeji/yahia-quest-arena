-- =========================================================
-- Baseline table grants — make the schema self-sufficient on a FRESH database.
-- ---------------------------------------------------------
-- Why this exists (nightly pgTAP regression, 2026-06-07 → 2026-06-12):
-- the repo's migrations were reconstructed from a dump and contain almost no
-- explicit table GRANTs. On Supabase CLOUD (prod + the e2e TEST project) the
-- platform's default privileges granted anon/authenticated/service_role access
-- to every table at creation time, so everything worked. The LOCAL stack used
-- by CI (`supabase db start` in db-tests.yml) stopped applying those default
-- privileges when supabase/postgres moved 17.6.1.132 → 17.6.1.134 (CLI
-- "latest", 2026-06-07): tables created by migrations got NO grants for the
-- client roles, and the pgTAP suite failed with
--   "permission denied for table attempts / parent_student_links".
--
-- Fix: assert the intended END-STATE grants explicitly so a fresh database
-- (CI local stack, a re-provisioned TEST project, a disaster-recovery restore)
-- matches production regardless of the platform's default-privilege behaviour.
-- On prod/TEST this whole file is a no-op (GRANT is idempotent and these
-- grants already exist there).
--
-- Scope rules (do NOT widen):
--   * Writes stay locked: every direct client write revoked by the hardening
--     migrations (20260602120000/130000, 20260606150000, 20260610160000/190000,
--     20260608120000) stays revoked — this file grants NO INSERT/UPDATE/DELETE
--     beyond the ones those migrations explicitly re-granted.
--   * `questions` is intentionally NOT table-level readable: the answer key is
--     hidden via column grants (20260610170000_hide_answer_key) — untouched here.
--   * `rate_limit_events` and `subject_leaderboard_totals` stay client-invisible.
--   * NEW RULE for future migrations: any `CREATE TABLE` must ship its own
--     explicit GRANTs (see CLAUDE.md gotchas) — defaults can no longer be
--     assumed on fresh stacks.
-- =========================================================

-- ----- Catalogue: world-readable by design (RLS policies are USING (true)) ---
GRANT SELECT ON public.subjects,
                public.chapters,
                public.exercises,
                public.themes,
                public.grades,
                public.badges,
                public.shop_items
  TO anon, authenticated;
-- (public.parcours already has its explicit SELECT grant in 20260608120000.)

-- ----- Private, self-scoped tables: SELECT only; rows filtered by RLS --------
-- Reads the app/server fns perform with the USER's JWT (dashboard, quest gate,
-- shop inventory, parent links) + the tables RLS policies subquery
-- (parent_student_links is referenced by the profiles/entitlements policies, so
-- `authenticated` needs SELECT on it for those policies to even evaluate).
GRANT SELECT ON public.profiles,
                public.attempts,
                public.exercise_sessions,
                public.daily_objectives,
                public.weekly_quests,
                public.difficulty_adaptation,
                public.spaced_repetition_schedule,
                public.dungeon_runs,
                public.dungeon_run_questions,
                public.student_badges,
                public.inventory_items,
                public.parent_student_links,
                public.theory_scrolls,
                public.exercise_assignments
  TO authenticated;

-- ----- service_role: full access (cloud parity) ------------------------------
-- The trusted backend role (e2e seeding/reset scripts, admin tooling). RLS does
-- not apply to it on the platform; mirror the cloud default here.
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;

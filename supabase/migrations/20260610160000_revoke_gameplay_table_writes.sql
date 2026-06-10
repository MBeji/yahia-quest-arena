-- Security hardening (GAP-016, GAP-021) — lock direct client writes on gameplay tables.
--
-- These tables are written ONLY by SECURITY DEFINER RPCs:
--   * attempts                    -> submit_exercise_attempt
--   * daily_objectives            -> ensure_daily_weekly_goals / submit_exercise_attempt
--   * weekly_quests               -> ensure_daily_weekly_goals / submit_exercise_attempt
--   * difficulty_adaptation       -> submit_exercise_attempt
--   * spaced_repetition_schedule  -> submit_exercise_attempt
-- Verified: no server fn writes them directly with the user JWT (no
-- `.from("<table>").insert/update/delete` in src/ for these — only RPC calls).
--
-- Their permissive self-owned RLS policies (USING/WITH CHECK auth.uid() = user_id)
-- combined with the default `authenticated` table grants let any authenticated user
-- forge rows directly via PostgREST. Confirmed dynamically (C3): a free student could
-- `POST /rest/v1/attempts` with `xp_earned = 99999` (HTTP 201), inflating the subject
-- leaderboard (SUM attempts.xp_earned), bypassing the school quiz gate (reads attempts
-- >= 80%) and the dungeon prerequisites; and PATCH daily/weekly objectives to completed.
--
-- Fix: revoke the direct write grants from `authenticated`/`anon`. SECURITY DEFINER
-- RPCs run as the function owner and are unaffected, so the legitimate gameplay loop
-- keeps working. SELECT (own rows, for the dashboard) is intentionally preserved.
--
-- Out of scope (require code changes, tracked separately):
--   * exercise_sessions — created by a direct authenticated insert in
--     quest.server.ts (startExerciseSession); locking it needs a SECURITY DEFINER
--     session-creation RPC that also enforces the premium/quiz gate (finding S-3).
--   * questions.correct_option — read client-side by quest.server.ts submitAttempt to
--     build the end-of-quest review; masking it needs the correction moved into the
--     submit RPC first (GAP-020).

revoke insert, update, delete on public.attempts from authenticated, anon;
revoke insert, update, delete on public.daily_objectives from authenticated, anon;
revoke insert, update, delete on public.weekly_quests from authenticated, anon;
revoke insert, update, delete on public.difficulty_adaptation from authenticated, anon;
revoke insert, update, delete on public.spaced_repetition_schedule from authenticated, anon;

-- Synthetic scale seeder for load testing — DEDICATED LOAD-TEST PROJECT ONLY.
--
-- The leaderboard hotspot (audit H1: get_global_leaderboard ranks every student
-- profile per call) and the per-user history aggregates (audit H3/M2/M4) only
-- reveal their cost when the tables are POPULATED. A fresh test project has a
-- handful of rows, so a load run looks deceptively fast. Run this first to
-- simulate a busy platform, then run the k6 suite.
--
-- ⚠️ DESTRUCTIVE-ADJACENT: inserts thousands of synthetic rows. Run ONLY against
--    a throwaway load-test database (Supabase SQL editor or psql). NEVER prod.
--
-- profiles.id references auth.users(id), so we mint synthetic auth.users rows
-- first (service-role / SQL-editor context bypasses RLS). Adjust :n_students.

\set n_students 20000

BEGIN;

-- 1) Synthetic auth users (minimal columns; enough to satisfy the FK + trigger).
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password,
                        email_confirmed_at, created_at, updated_at,
                        raw_app_meta_data, raw_user_meta_data)
SELECT gen_random_uuid(),
       '00000000-0000-0000-0000-000000000000',
       'authenticated', 'authenticated',
       'synth.' || g || '@loadtest.invalid',
       crypt('synthetic', gen_salt('bf')),
       now(), now(), now(),
       '{"provider":"email","providers":["email"]}'::jsonb,
       jsonb_build_object('display_name', 'Synth ' || g, 'load_test', true)
FROM generate_series(1, :n_students) AS g
ON CONFLICT DO NOTHING;

-- 2) If handle_new_user created the profiles, give them a realistic XP spread so
--    RANK() has real work to do; otherwise insert the profiles directly.
INSERT INTO public.profiles (id, display_name, role, xp, level, current_streak, coins, hero_class, avatar_tier)
SELECT u.id,
       u.raw_user_meta_data->>'display_name',
       'student',
       (random() * 50000)::int,
       1 + (random() * 60)::int,
       (random() * 120)::int,
       (random() * 5000)::int,
       (ARRAY['novice','apprenti','chevalier','maitre','legende'])[1 + (random() * 4)::int],
       (random() * 5)::int
FROM auth.users u
WHERE u.email LIKE 'synth.%@loadtest.invalid'
ON CONFLICT (id) DO UPDATE
  SET xp = EXCLUDED.xp,
      level = EXCLUDED.level,
      current_streak = EXCLUDED.current_streak;

COMMIT;

-- 3) (Optional) Inflate attempt history so per-user aggregates (submit_exercise_attempt
--    COUNT/MAX, get_dashboard, get_dungeon_access) scan realistic volumes. Spreads
--    ~50 attempts across a sample of synthetic students against existing exercises.
--    Uncomment and adapt once you have real exercise/subject ids in the test DB.
--
-- INSERT INTO public.attempts (user_id, subject_id, exercise_id, score_pct, xp_earned, completed_at)
-- SELECT p.id, e.subject_id, e.id, (random()*100)::numeric, (random()*100)::int,
--        now() - (random() * interval '90 days')
-- FROM (SELECT id FROM public.profiles WHERE role='student' ORDER BY random() LIMIT 2000) p
-- CROSS JOIN LATERAL (SELECT id, subject_id FROM public.exercises ORDER BY random() LIMIT 50) e;

ANALYZE public.profiles;
-- ANALYZE public.attempts;

SELECT count(*) AS student_profiles FROM public.profiles WHERE role = 'student';

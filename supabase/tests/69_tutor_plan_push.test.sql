-- =========================================================
-- Étude 11 — lot 2 : l'audience du rappel du plan du jour (US-7).
-- ---------------------------------------------------------
-- Trois conditions, et chacune protège quelque chose de différent :
--
--   opt-in armé      → une notification non demandée est une de trop ;
--   révision due     → un rappel sans contenu fait couper les notifications ;
--   pas venu ce jour → celui qui joue n'a pas besoin qu'on l'appelle, et c'est
--                      aussi ce qui tient la promesse « au plus un par jour »,
--                      le rappel de série visant la MÊME population.
--
-- La troisième est celle qu'on oublie : elle ne se voit pas dans l'écran de
-- réglage, seulement dans le fait qu'un élève assidu ne soit jamais dérangé.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(9);

-- ---------------------------------------------------------
-- Décor : quatre élèves, un par branche de la sélection.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
SELECT ('f1000000-0000-4000-8000-00000000000' || n)::uuid,
       'tpp-' || n || '@test.local', 'x', now(),
       '{"display_name":"TPP"}'::jsonb, now(), now(),
       'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'
  FROM generate_series(1, 4) n;

-- `handle_new_user` crée le profil ; on ne fixe ici que ce que le test regarde.
UPDATE public.profiles SET last_active_date = DATE '2026-08-20'
 WHERE id IN ('f1000000-0000-4000-8000-000000000001'::uuid,
              'f1000000-0000-4000-8000-000000000003'::uuid,
              'f1000000-0000-4000-8000-000000000004'::uuid);

-- L'assidu : venu aujourd'hui.
UPDATE public.profiles SET last_active_date = DATE '2026-08-23'
 WHERE id = 'f1000000-0000-4000-8000-000000000002'::uuid;

INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('tpp-theme', 'TPP', 'Brain', 'subject-math', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, content_language)
VALUES ('tpp-subj', 'TPP Maths', 'Esprit', 'subject-math', 'Brain', 'tpp-theme', 'fr');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('f1000000-0000-4000-8000-0000000000c1'::uuid, 'tpp-subj', 'TPP Chapitre');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES
  ('f1000000-0000-4000-8000-0000000000e1'::uuid,
   'f1000000-0000-4000-8000-0000000000c1'::uuid, 'tpp-subj', 'TPP Ex 1', 1, 'practice', 'admin'),
  ('f1000000-0000-4000-8000-0000000000e2'::uuid,
   'f1000000-0000-4000-8000-0000000000c1'::uuid, 'tpp-subj', 'TPP Ex 2', 1, 'practice', 'admin');

-- Opt-in : 1, 2 et 3 l'ont armé ; 4 ne l'a pas.
INSERT INTO public.tutor_prefs (user_id, plan_push)
VALUES
  ('f1000000-0000-4000-8000-000000000001'::uuid, true),
  ('f1000000-0000-4000-8000-000000000002'::uuid, true),
  ('f1000000-0000-4000-8000-000000000003'::uuid, false),
  ('f1000000-0000-4000-8000-000000000004'::uuid, true);

-- Révisions dues : 1 en a deux, 2 en a une, 3 en a une, 4 n'en a aucune.
INSERT INTO public.spaced_repetition_schedule
  (user_id, exercise_id, subject_id, retry_level, scheduled_for, status)
VALUES
  ('f1000000-0000-4000-8000-000000000001'::uuid,
   'f1000000-0000-4000-8000-0000000000e1'::uuid, 'tpp-subj', 1, now() - INTERVAL '2 days', 'pending'),
  ('f1000000-0000-4000-8000-000000000001'::uuid,
   'f1000000-0000-4000-8000-0000000000e2'::uuid, 'tpp-subj', 1, now() - INTERVAL '1 day', 'pending'),
  ('f1000000-0000-4000-8000-000000000002'::uuid,
   'f1000000-0000-4000-8000-0000000000e1'::uuid, 'tpp-subj', 1, now() - INTERVAL '2 days', 'pending'),
  ('f1000000-0000-4000-8000-000000000003'::uuid,
   'f1000000-0000-4000-8000-0000000000e1'::uuid, 'tpp-subj', 1, now() - INTERVAL '2 days', 'pending');

-- =========================================================
-- 1. La sélection.
-- =========================================================
SELECT is(
  (SELECT count(*)::INT FROM public.tutor_plan_push_audience(DATE '2026-08-23')),
  1,
  'US-7 : un seul des quatre élèves remplit les trois conditions'
);

SELECT is(
  (SELECT user_id FROM public.tutor_plan_push_audience(DATE '2026-08-23')),
  'f1000000-0000-4000-8000-000000000001'::uuid,
  'US-7 : c''est bien celui qui a armé, qui a du retard, et qui n''est pas venu'
);

SELECT is(
  (SELECT due_count FROM public.tutor_plan_push_audience(DATE '2026-08-23')),
  2,
  'US-7 : le nombre de révisions dues remonte — le texte du rappel le dit'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.tutor_plan_push_audience(DATE '2026-08-23') a
               WHERE a.user_id = 'f1000000-0000-4000-8000-000000000002'::uuid),
  '⭐ un élève VENU aujourd''hui n''est jamais rappelé — c''est ce qui tient « un par jour »'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.tutor_plan_push_audience(DATE '2026-08-23') a
               WHERE a.user_id = 'f1000000-0000-4000-8000-000000000003'::uuid),
  'sans opt-in, aucun rappel — le défaut est éteint et le reste'
);

SELECT ok(
  NOT EXISTS (SELECT 1 FROM public.tutor_plan_push_audience(DATE '2026-08-23') a
               WHERE a.user_id = 'f1000000-0000-4000-8000-000000000004'::uuid),
  'sans révision due, aucun rappel — un rappel vide fait couper les notifications'
);

-- =========================================================
-- 2. Le réglage, vu par l'élève.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"f1000000-0000-4000-8000-000000000004","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_prefs())->>'verbosity',
  'normale',
  'get_tutor_prefs : l''absence de réglage rend le DÉFAUT, pas un vide'
);

SELECT lives_ok(
  $$SELECT public.set_tutor_plan_push(false)$$,
  'l''élève peut désarmer son rappel'
);

RESET ROLE;

-- =========================================================
-- 3. Droits.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.tutor_plan_push_audience(date)', 'EXECUTE'),
  'l''audience du cron n''est pas une API cliente — un élève ne liste pas les autres'
);

SELECT * FROM finish();
ROLLBACK;

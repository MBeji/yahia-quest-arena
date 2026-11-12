-- =========================================================
-- Audit 2026-09-12, S-1 — LA BORNE DURABLE devant les RPC anonymes SECURITY DEFINER
-- (migration 20261112100000_rpc_rate_limit_durable.sql)
-- ---------------------------------------------------------
-- Les propriétés qui coûtent si elles tombent :
--   ⭐ une source anonyme est arrêtée au seuil, et PT429 (= HTTP 429) est ce qu'elle reçoit ;
--   ⭐ faire tourner la source (ou forger `x-forwarded-for`) bute sur le plafond GLOBAL ;
--   ⭐ les anonymes n'épuisent jamais le seau d'un compte, ni un compte celui d'un autre ;
--   ⭐ le compteur vit en base (il tient d'une instance serverless à l'autre) et se vide
--      avec la fenêtre ;
--   ⭐ CLIQUET : une RPC anonyme SECURITY DEFINER volatile sans l'appel, ou une nouvelle
--      RPC anonyme STABLE non classée, fait échouer ce fichier ;
--   ⭐ `check_rate_limit` : un compte ne peut plus remplir le seau d'un autre.
--
-- Espace de noms des fixtures : préfixe `f108…`.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(35);

-- ---------------------------------------------------------
-- Décor : deux comptes, une mission publique d'une question, des seuils minuscules
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('f1080000-0000-4000-8000-000000000001', 'f108-a@test.local'),
  ('f1080000-0000-4000-8000-000000000002', 'f108-b@test.local');

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('f108-subj', 'Borne', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('f1080000-0000-4000-8000-0000000000c1', 'f108-subj', 'Chapitre');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('f1080000-0000-4000-8000-0000000000e1',
        'f1080000-0000-4000-8000-0000000000c1', 'f108-subj', 'Mission', 'admin', 'practice');
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option)
VALUES ('f1080000-0000-4000-8000-0000000000f1', 'f1080000-0000-4000-8000-0000000000e1',
        'Q', '[{"id":"a"},{"id":"b"}]'::jsonb, 'a');

DELETE FROM public.rate_limit_events;
UPDATE public.rpc_rate_limit_policies
   SET anon_source_max = 3, anon_global_max = 5, user_max = 2, window_seconds = 60;

CREATE FUNCTION pg_temp.check_once() RETURNS INT LANGUAGE sql AS $$
  SELECT count(*)::int FROM public.check_answers(
    'f1080000-0000-4000-8000-0000000000e1',
    '[{"questionId":"f1080000-0000-4000-8000-0000000000f1","choice":"a"}]'::jsonb);
$$;

-- ---------------------------------------------------------
-- 1. Droits : rien de tout cela n'est à portée du client
-- ---------------------------------------------------------
SELECT ok(
  (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.rpc_rate_limit_policies'::regclass),
  'rpc_rate_limit_policies : RLS activée'
);
SELECT ok(
  NOT has_table_privilege('anon', 'public.rpc_rate_limit_policies', 'SELECT,INSERT,UPDATE,DELETE')
  AND NOT has_table_privilege('authenticated', 'public.rpc_rate_limit_policies', 'SELECT,INSERT,UPDATE,DELETE'),
  'rpc_rate_limit_policies : ni anon ni authenticated ne lisent ni n''écrivent les seuils'
);
SELECT ok(
  NOT has_function_privilege('anon', 'public.enforce_rpc_rate_limit(text)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.enforce_rpc_rate_limit(text)', 'EXECUTE'),
  'enforce_rpc_rate_limit est interne : un client ne peut pas l''appeler pour remplir un seau'
);
SELECT ok(
  NOT has_table_privilege('anon', 'public.rate_limit_events', 'SELECT,INSERT,UPDATE,DELETE')
  OR (SELECT relrowsecurity FROM pg_class WHERE oid = 'public.rate_limit_events'::regclass),
  'rate_limit_events : le compteur reste hors de portée d''anon (RLS, aucune policy)'
);

-- ---------------------------------------------------------
-- 2. CLIQUET — la liste des RPC anonymes SECURITY DEFINER est classée, entièrement
-- ---------------------------------------------------------
SELECT is_empty(
  $$
  SELECT p.proname
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
   WHERE n.nspname = 'public'
     AND p.prosecdef
     AND p.prokind = 'f'
     AND p.provolatile = 'v'
     AND p.prorettype <> 'trigger'::regtype
     AND has_function_privilege('anon', p.oid, 'EXECUTE')
     AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = p.oid AND d.deptype = 'e')
     AND p.prosrc !~ 'PERFORM public\.enforce_rpc_rate_limit\('
  $$,
  'toute RPC SECURITY DEFINER VOLATILE exécutable par anon appelle enforce_rpc_rate_limit'
);

SELECT set_eq(
  $$
  SELECT p.proname::text
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
   WHERE n.nspname = 'public'
     AND p.prosecdef
     AND p.prokind = 'f'
     AND p.provolatile <> 'v'
     AND p.prorettype <> 'trigger'::regtype
     AND has_function_privilege('anon', p.oid, 'EXECUTE')
     AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = p.oid AND d.deptype = 'e')
  $$,
  ARRAY[
    -- Lectures de catalogue ou d'agrégat public : exécutées en transaction LECTURE SEULE
    -- par PostgREST (on ne peut pas y compter), et sans donnée qu'un SELECT anonyme ne lise.
    'get_active_event', 'get_recall_availability', 'parcours_interest_counts',
    'list_placement_subjects', 'get_placement_subject',
    -- Porte = le jeton (uuid aléatoire) du test.
    'get_placement_session',
    -- Prédicats de policies RLS.
    'is_admin', 'is_parent_of_student'
  ],
  'les RPC anonymes SECURITY DEFINER NON volatiles sont exactement la liste d''exemptions motivées'
);

SELECT is_empty(
  $$
  SELECT m[1]
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace,
         regexp_matches(p.prosrc, 'enforce_rpc_rate_limit\(''([a-z_]+)''\)', 'g') AS m
   WHERE n.nspname = 'public'
     AND NOT EXISTS (SELECT 1 FROM public.rpc_rate_limit_policies pol WHERE pol.scope = m[1])
  $$,
  'chaque scope appelé a sa ligne de seuils (un scope sans ligne ne limiterait rien)'
);

-- ---------------------------------------------------------
-- 3. Anonyme : palier SOURCE
-- ---------------------------------------------------------
SET LOCAL ROLE anon;
SET LOCAL "request.jwt.claims" = '';
SET LOCAL "request.headers" = '{"cf-connecting-ip":"203.0.113.1","x-forwarded-for":"198.51.100.7"}';

SELECT is(pg_temp.check_once(), 1, 'source 1 — appel 1 : corrigé');
SELECT is(pg_temp.check_once(), 1, 'source 1 — appel 2 : corrigé');
SELECT is(pg_temp.check_once(), 1, 'source 1 — appel 3 : corrigé (seuil atteint)');
SELECT throws_ok(
  'SELECT pg_temp.check_once()', 'PT429', 'RATE_LIMITED',
  '⭐ source 1 — appel 4 : refusé, SQLSTATE PT429 (PostgREST → HTTP 429)'
);

-- `cf-connecting-ip` (posé par la passerelle) prime : forger x-forwarded-for ne change pas de seau.
SET LOCAL "request.headers" = '{"cf-connecting-ip":"203.0.113.1","x-forwarded-for":"192.0.2.99, 10.0.0.1"}';
SELECT throws_ok(
  'SELECT pg_temp.check_once()', 'PT429', 'RATE_LIMITED',
  '⭐ même cf-connecting-ip, x-forwarded-for forgé : toujours refusé'
);

-- ---------------------------------------------------------
-- 4. Anonyme : plafond GLOBAL — faire tourner la source ne passe pas
-- ---------------------------------------------------------
SET LOCAL "request.headers" = '{"x-forwarded-for":"198.51.100.20, 10.0.0.1"}';
SELECT is(pg_temp.check_once(), 1, 'source 2 (x-forwarded-for seul) — son seau est neuf : corrigé');
SELECT is(pg_temp.check_once(), 1, 'source 2 — appel 2 : corrigé (global = 5)');

SET LOCAL "request.headers" = '{"x-forwarded-for":"198.51.100.21"}';
SELECT throws_ok(
  'SELECT pg_temp.check_once()', 'PT429', 'RATE_LIMITED',
  '⭐ source 3, jamais vue : refusée par le plafond global'
);
SET LOCAL "request.headers" = '';
SELECT throws_ok(
  'SELECT pg_temp.check_once()', 'PT429', 'RATE_LIMITED',
  'sans en-tête du tout (source « unknown ») : refusé de même'
);

-- ---------------------------------------------------------
-- 5. Le compteur est EN BASE, et pseudonymisé
-- ---------------------------------------------------------
RESET ROLE;
SELECT is(
  (SELECT count(*)::int FROM public.rate_limit_events WHERE scope_key = 'rpc:check_answers:anon'),
  5,
  '⭐ cinq passages comptés dans rate_limit_events : la borne ne vit pas dans une instance'
);
SELECT is(
  (SELECT count(*)::int FROM public.rate_limit_events
    WHERE scope_key LIKE '%203.0.113.1%' OR scope_key LIKE '%198.51.100.%'),
  0,
  'aucune IP en clair dans les clés (md5)'
);

-- ---------------------------------------------------------
-- 6. Un compte a SON seau : les anonymes ne l'épuisent pas, un autre compte non plus
-- ---------------------------------------------------------
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claims" = '{"sub":"f1080000-0000-4000-8000-000000000001","role":"authenticated"}';
SELECT is(pg_temp.check_once(), 1, '⭐ compte A corrigé alors que le plafond anonyme est atteint');
SELECT is(pg_temp.check_once(), 1, 'compte A — appel 2 : corrigé (seuil atteint)');
SELECT throws_ok(
  'SELECT pg_temp.check_once()', 'PT429', 'RATE_LIMITED',
  '⭐ compte A — appel 3 : refusé (un compte gratuit ne boucle pas non plus sur PostgREST)'
);
SET LOCAL "request.jwt.claims" = '{"sub":"f1080000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT is(pg_temp.check_once(), 1, '⭐ compte B n''est pas touché par le seau de A');

-- Le serveur de confiance n'est pas borné.
RESET ROLE;
SET LOCAL ROLE service_role;
SET LOCAL "request.jwt.claims" = '{"role":"service_role"}';
SELECT lives_ok(
  $$SELECT public.enforce_rpc_rate_limit('check_answers') FROM generate_series(1, 8)$$,
  'service_role : jamais limité'
);

-- ---------------------------------------------------------
-- 7. La fenêtre glisse : passé le délai, la source repasse
-- ---------------------------------------------------------
RESET ROLE;
UPDATE public.rate_limit_events SET created_at = created_at - interval '61 seconds';
SET LOCAL ROLE anon;
SET LOCAL "request.jwt.claims" = '';
SET LOCAL "request.headers" = '{"cf-connecting-ip":"203.0.113.1"}';
SELECT is(pg_temp.check_once(), 1, '⭐ 61 s plus tard : la source 1 est de nouveau corrigée');

-- ---------------------------------------------------------
-- 8. Les sept autres RPC portent bien l'appel EN TÊTE : seau plein → PT429 avant tout le reste
-- ---------------------------------------------------------
RESET ROLE;
INSERT INTO public.rate_limit_events (scope_key)
SELECT 'rpc:' || s.scope || ':anon'
  FROM (VALUES ('score_quiz'), ('report_by_code'), ('placement_start'), ('placement_finish')) AS s(scope),
       generate_series(1, 5);
SET LOCAL ROLE anon;
SET LOCAL "request.headers" = '{"cf-connecting-ip":"203.0.113.50"}';

SELECT throws_ok(
  $$SELECT * FROM public.score_quiz('f1080000-0000-4000-8000-0000000000e1', '[]'::jsonb)$$,
  'PT429', 'RATE_LIMITED', 'score_quiz est borné'
);
SELECT throws_ok(
  $$SELECT public.get_student_report_by_code('pas-un-code')$$,
  'PT429', 'RATE_LIMITED', 'get_student_report_by_code est borné (avant même de lire le code)'
);
SELECT throws_ok(
  $$SELECT public.get_student_daily_report_by_code('pas-un-code', current_date, current_date)$$,
  'PT429', 'RATE_LIMITED', 'get_student_daily_report_by_code (3 arguments) est borné'
);
SELECT throws_ok(
  $$SELECT public.get_student_daily_report_by_code('pas-un-code', current_date, current_date, 'all')$$,
  'PT429', 'RATE_LIMITED', 'get_student_daily_report_by_code (4 arguments) est borné'
);
SELECT throws_ok(
  $$SELECT public.get_student_attempt_detail_by_code('pas-un-code', gen_random_uuid())$$,
  'PT429', 'RATE_LIMITED', 'get_student_attempt_detail_by_code est borné'
);
SELECT throws_ok(
  $$SELECT public.start_placement_session('f108-subj', 'student')$$,
  'PT429', 'RATE_LIMITED', 'start_placement_session est borné'
);
SELECT throws_ok(
  $$SELECT public.finish_placement_session(gen_random_uuid(), gen_random_uuid(), '{}'::jsonb, 0)$$,
  'PT429', 'RATE_LIMITED', 'finish_placement_session est borné'
);

-- ---------------------------------------------------------
-- 9. check_rate_limit : la clé appartient à l'appelant
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL ROLE authenticated;
-- B, malveillant, vise le seau « submit_<A> » que la server fn utilise pour A.
SET LOCAL "request.jwt.claims" = '{"sub":"f1080000-0000-4000-8000-000000000002","role":"authenticated"}';
SELECT is(
  (SELECT bool_or(public.check_rate_limit('submit_f1080000-0000-4000-8000-000000000001', 2, 60000))
     FROM generate_series(1, 3)),
  true,
  'B atteint le seuil sur la clé « submit_<A> »…'
);
SET LOCAL "request.jwt.claims" = '{"sub":"f1080000-0000-4000-8000-000000000001","role":"authenticated"}';
SELECT is(
  public.check_rate_limit('submit_f1080000-0000-4000-8000-000000000001', 2, 60000),
  false,
  '⭐ …et A n''est pas limité : B n''a rempli que son propre seau'
);
SELECT throws_ok(
  format('SELECT public.check_rate_limit(%L, 5, 60000)', repeat('k', 201)),
  'P0001', 'Rate limit key is too long',
  'une clé démesurée est refusée'
);
SELECT is(
  (SELECT bool_or(public.check_rate_limit('gonfle', 2000000000, 60000))
     FROM generate_series(1, 1001)),
  true,
  '⭐ un plafond démesuré est ramené à 1 000 : un compte ne gonfle pas la table sans borne'
);

SELECT * FROM finish();
ROLLBACK;

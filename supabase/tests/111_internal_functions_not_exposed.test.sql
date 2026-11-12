-- =========================================================
-- Une fonction SECURITY DEFINER interne n'est pas une RPC
-- (migration 20261112150000_revoke_internal_functions_from_authenticated.sql)
-- ---------------------------------------------------------
-- Sur Supabase, `REVOKE … FROM PUBLIC, anon` ne suffit pas : `authenticated` garde le droit
-- reçu des privilèges par défaut. Le shim local les rejoue (supabase-shim.sql), ce fichier
-- échoue donc sans la migration.
--   ⭐ un compte connecté ne peut pas s'attribuer un badge ;
--   ⭐ CLIQUET : toute fonction SECURITY DEFINER exécutable par un client et dont le corps
--      ne contrôle pas l'appelant est soit révoquée, soit nommée ici avec sa raison.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(7);

INSERT INTO auth.users (id, email) VALUES
  ('f1100000-0000-4000-8000-000000000001', 'f110-eleve@test.local');

SELECT ok(
  NOT has_function_privilege('authenticated', 'public.award_badge_if_new(uuid,text,text)', 'EXECUTE')
  AND NOT has_function_privilege('anon', 'public.award_badge_if_new(uuid,text,text)', 'EXECUTE'),
  '⭐ award_badge_if_new : ni anon ni authenticated'
);
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.resolve_ai_access(uuid,text)', 'EXECUTE'),
  'resolve_ai_access : pas authenticated (le serveur l''appelle avec la clé service)'
);
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.app_daily_mission_pool(uuid)', 'EXECUTE'),
  'app_daily_mission_pool : pas authenticated'
);
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.cleanup_rate_limit_events(integer)', 'EXECUTE'),
  'cleanup_rate_limit_events : pas authenticated'
);

-- L'exploitation, telle qu'un élève la tenterait depuis la console du navigateur.
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claims" = '{"sub":"f1100000-0000-4000-8000-000000000001","role":"authenticated"}';
SELECT throws_ok(
  $$SELECT public.award_badge_if_new('f1100000-0000-4000-8000-000000000001',
      (SELECT code FROM public.badges LIMIT 1), 'auto-attribution')$$,
  '42501', NULL,
  '⭐ un élève qui s''attribue un badge par PostgREST est refusé'
);
RESET ROLE;
SELECT is(
  (SELECT count(*)::int FROM public.student_badges
    WHERE student_user_id = 'f1100000-0000-4000-8000-000000000001'),
  0,
  'et aucun badge n''a été écrit'
);

SELECT set_eq(
  $$
  SELECT p.proname::text
    FROM pg_proc p
   WHERE p.pronamespace = 'public'::regnamespace
     AND p.prosecdef
     AND p.prokind = 'f'
     AND p.prorettype <> 'trigger'::regtype
     AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = p.oid AND d.deptype = 'e')
     AND (has_function_privilege('authenticated', p.oid, 'EXECUTE')
          OR has_function_privilege('anon', p.oid, 'EXECUTE'))
     AND p.prosrc !~ 'auth\.uid|auth\.role|is_admin|assert_can_read|enforce_rpc_rate_limit'
  $$,
  ARRAY[
    -- Catalogue public ou agrégat sans personne dedans.
    'list_placement_subjects', 'get_placement_subject', 'parcours_interest_counts',
    'chapter_quiz_gated', 'resolve_subject_parcours', 'tutor_age_band',
    -- Prédicats de policies RLS : ils doivent rester exécutables par le rôle qui lit.
    'is_parent_of_student', 'is_duel_participant',
    -- Appelées par le client avec SON identifiant ; pour celui d'un autre elles ne rendent
    -- qu'un booléen ou un compteur (0 à 3) — noté dans le rapport du 2026-11-12, accepté.
    'has_parcours_entitlement', 'has_parcours_entitlement_for_subject',
    'can_play_open_questions', 'ai_forge_quota_left'
  ],
  '⭐ CLIQUET : les SECURITY DEFINER exposées sans contrôle de l''appelant sont exactement cette liste'
);

SELECT * FROM finish();
ROLLBACK;

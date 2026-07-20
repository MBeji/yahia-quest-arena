-- =========================================================
-- Parcours entitlements + access resolver invariants
-- ---------------------------------------------------------
-- Asserts the per-parcours paywall that replaces the old global "difficulty >= 3"
-- gate, run against REAL Postgres with the real `authenticated` role:
--   * resolve_subject_parcours maps (theme, grade) -> the right parcours;
--   * has_parcours_entitlement: free parcours = always; live grant = yes;
--     expired/revoked = no; family pack (active linked parent's grant) = yes;
--   * resolve_exercise_access: free -> open; premium d1/quiz -> free preview;
--     premium d>=2 without a grant -> PARCOURS_LOCKED; with a grant -> open;
--   * admin_grant_parcours is is_admin()-guarded.
-- The 8 seeded parcours come from 20260608120000. Since the free-phase switch
-- (20260711100000) they are ALL is_premium=false, so the fixtures below restore
-- the flag on `concours-9eme` inside the transaction: these tests cover the
-- DORMANT paywall machinery that étude 01 re-activates, and without the restore
-- every premium assertion here passes vacuously through the "free parcours is
-- always open" short-circuit. Fixtures otherwise only add
-- users/subjects/exercises/grants.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(16);

-- ---------------------------------------------------------
-- Fixtures (as the superuser test role; no JWT claims set yet).
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('11111111-1111-1111-1111-111111111111', 'pe-none@test.local'),     -- no grant
  ('22222222-2222-2222-2222-222222222222', 'pe-granted@test.local'),  -- live grant
  ('33333333-3333-3333-3333-333333333333', 'pe-expired@test.local'),  -- expired grant
  ('44444444-4444-4444-4444-444444444444', 'pe-revoked@test.local'),  -- revoked grant
  ('55555555-5555-5555-5555-555555555555', 'pe-parent@test.local'),   -- holds grant (family)
  ('66666666-6666-6666-6666-666666666666', 'pe-child@test.local'),    -- active-linked child
  ('77777777-7777-7777-7777-777777777777', 'pe-child-inactive@test.local'), -- inactive-linked child
  ('88888888-8888-8888-8888-888888888888', 'pe-admin@test.local'),    -- admin actor
  ('99999999-9999-9999-9999-999999999999', 'pe-admin-target@test.local'); -- admin grant target

-- Profiles (handle_new_user may already create them; be defensive). The admin's
-- role is set here, before any JWT claims exist, so the role trigger allows it.
INSERT INTO public.profiles (id, display_name) VALUES
  ('11111111-1111-1111-1111-111111111111', 'None'),
  ('22222222-2222-2222-2222-222222222222', 'Granted'),
  ('33333333-3333-3333-3333-333333333333', 'Expired'),
  ('44444444-4444-4444-4444-444444444444', 'Revoked'),
  ('55555555-5555-5555-5555-555555555555', 'Parent'),
  ('66666666-6666-6666-6666-666666666666', 'Child'),
  ('77777777-7777-7777-7777-777777777777', 'ChildInactive'),
  ('88888888-8888-8888-8888-888888888888', 'Admin'),
  ('99999999-9999-9999-9999-999999999999', 'AdminTarget')
ON CONFLICT (id) DO NOTHING;
UPDATE public.profiles SET role = 'admin' WHERE id = '88888888-8888-8888-8888-888888888888';

-- A premium-parcours subject (ecole-tn + 9ème -> concours-9eme) and a free one
-- (culture-generale -> a 'libre' parcours).
INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id)
VALUES
  ('pe-prem', 'PE Premium', 'Esprit', 'subject-math', 'Brain', 'ecole-tn',
     (SELECT id FROM public.grades WHERE theme_id = 'ecole-tn' AND slug = '9eme-base')),
  ('pe-free', 'PE Free', 'Esprit', 'subject-svt', 'Globe', 'culture-generale', NULL);

INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('c1111111-1111-1111-1111-111111111111', 'pe-prem', 'Prem Ch1'),
  ('c2222222-2222-2222-2222-222222222222', 'pe-free', 'Free Ch1');

-- Premium exercises: d1 (preview), d3 (gated), quiz (preview). Free: d3 (open).
INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, difficulty, mode)
VALUES
  ('e1111111-1111-1111-1111-111111111111', 'c1111111-1111-1111-1111-111111111111', 'pe-prem', 'P d1',   50, 1, 'practice'),
  ('e3333333-3333-3333-3333-333333333333', 'c1111111-1111-1111-1111-111111111111', 'pe-prem', 'P d3',   50, 3, 'practice'),
  ('e2222222-2222-2222-2222-222222222222', 'c1111111-1111-1111-1111-111111111111', 'pe-prem', 'P quiz', 50, 2, 'quiz'),
  ('efffffff-ffff-ffff-ffff-ffffffffffff', 'c2222222-2222-2222-2222-222222222222', 'pe-free', 'F d3',   50, 3, 'practice');

-- Direct entitlement rows (writes normally go through admin RPCs; superuser
-- bypasses for fixtures). Live, expired, revoked, and a parent-held grant.
INSERT INTO public.parcours_entitlements (user_id, parcours_id, source, expires_at, revoked_at) VALUES
  ('22222222-2222-2222-2222-222222222222', 'concours-9eme', 'purchase', NULL, NULL),               -- live perpetual
  ('33333333-3333-3333-3333-333333333333', 'concours-9eme', 'purchase', now() - INTERVAL '1 day', NULL), -- expired
  ('44444444-4444-4444-4444-444444444444', 'concours-9eme', 'purchase', NULL, now()),              -- revoked
  ('55555555-5555-5555-5555-555555555555', 'concours-9eme', 'purchase', NULL, NULL);               -- parent holds it

-- Family links: child active, child-inactive inactive.
INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active) VALUES
  ('55555555-5555-5555-5555-555555555555', '66666666-6666-6666-6666-666666666666', true),
  ('55555555-5555-5555-5555-555555555555', '77777777-7777-7777-7777-777777777777', false);

-- Free phase (20260711100000) set every parcours to is_premium=false. This suite
-- asserts the DORMANT per-parcours paywall, so re-arm the flag on the parcours
-- under test — inside the transaction, undone by the final ROLLBACK. Without it
-- has_parcours_entitlement short-circuits on `NOT is_premium` and the negative
-- assertions (no grant / expired / revoked / inactive link) all go green for the
-- wrong reason. `culture-generale` stays free: it backs the "free is open" cases.
UPDATE public.parcours SET is_premium = true WHERE id = 'concours-9eme';

-- ---------------------------------------------------------
-- Resolver + entitlement-state assertions (callable as superuser: explicit args).
-- ---------------------------------------------------------
SELECT is(
  public.resolve_subject_parcours('ecole-tn', (SELECT id FROM public.grades WHERE theme_id='ecole-tn' AND slug='9eme-base')),
  'concours-9eme', 'resolve: ecole-tn + 9ème -> concours-9eme');

SELECT is(
  public.resolve_subject_parcours('culture-generale', NULL),
  'culture-generale', 'resolve: culture-generale + NULL grade -> the free parcours');

SELECT ok(
  public.has_parcours_entitlement('11111111-1111-1111-1111-111111111111', 'culture-generale'),
  'entitlement: a FREE parcours is always accessible');

SELECT ok(
  NOT public.has_parcours_entitlement('11111111-1111-1111-1111-111111111111', 'concours-9eme'),
  'entitlement: no grant -> premium parcours NOT accessible');

SELECT ok(
  public.has_parcours_entitlement('22222222-2222-2222-2222-222222222222', 'concours-9eme'),
  'entitlement: a live perpetual grant -> accessible');

SELECT ok(
  NOT public.has_parcours_entitlement('33333333-3333-3333-3333-333333333333', 'concours-9eme'),
  'entitlement: an EXPIRED grant is not accessible');

SELECT ok(
  NOT public.has_parcours_entitlement('44444444-4444-4444-4444-444444444444', 'concours-9eme'),
  'entitlement: a REVOKED grant is not accessible');

SELECT ok(
  public.has_parcours_entitlement('66666666-6666-6666-6666-666666666666', 'concours-9eme'),
  'family pack: an active linked parent''s grant covers the child');

SELECT ok(
  NOT public.has_parcours_entitlement('77777777-7777-7777-7777-777777777777', 'concours-9eme'),
  'family pack: an INACTIVE link does not cover the child');

-- ---------------------------------------------------------
-- resolve_exercise_access needs auth.uid() -> run as the 'no grant' user.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(
  (SELECT allowed FROM public.resolve_exercise_access('e1111111-1111-1111-1111-111111111111')),
  'access: premium difficulty-1 is a FREE PREVIEW (allowed without a grant)');

SELECT is(
  (SELECT reason FROM public.resolve_exercise_access('e3333333-3333-3333-3333-333333333333')),
  'PARCOURS_LOCKED', 'access: premium difficulty-3 without a grant -> PARCOURS_LOCKED');

SELECT ok(
  (SELECT is_preview FROM public.resolve_exercise_access('e2222222-2222-2222-2222-222222222222')),
  'access: the chapter comprehension quiz is in the free preview');

SELECT ok(
  (SELECT allowed FROM public.resolve_exercise_access('efffffff-ffff-ffff-ffff-ffffffffffff')),
  'access: difficulty-3 in a FREE parcours is open');

RESET ROLE;

-- ---------------------------------------------------------
-- Entitled user reaches the gated difficulty-3 mission.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"22222222-2222-2222-2222-222222222222","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(
  (SELECT allowed FROM public.resolve_exercise_access('e3333333-3333-3333-3333-333333333333')),
  'access: a live entitlement unlocks the premium difficulty-3 mission');

RESET ROLE;

-- ---------------------------------------------------------
-- admin_grant_parcours: admin can grant; a non-admin is rejected.
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"88888888-8888-8888-8888-888888888888","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT lives_ok(
  $$ SELECT public.admin_grant_parcours('99999999-9999-9999-9999-999999999999', 'concours-9eme', 'gift', NULL) $$,
  'admin_grant_parcours: an admin can grant an entitlement');

RESET ROLE;

SET LOCAL "request.jwt.claims" = '{"sub":"11111111-1111-1111-1111-111111111111","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.admin_grant_parcours('99999999-9999-9999-9999-999999999999', 'concours-6eme', 'gift', NULL) $$,
  'Unauthorized', 'admin_grant_parcours: a non-admin is rejected');

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;

-- =========================================================
-- Étude 08 lot 2 — le digest hebdo ENRICHI, opt-in.
-- ---------------------------------------------------------
-- Contre un vrai Postgres, avec les vrais rôles :
--   * parent_digest_prefs : désactivé par défaut (pas de ligne), lecture
--     owner-only, AUCUNE écriture directe (ni la préférence, ni l'estampille de
--     mesure) — tout passe par set_parent_digest_pref ;
--   * get_parent_digest_summary : inatteignable par anon ET par authenticated
--     (elle prend le parent en paramètre) ; en service-role, ne rend QUE les
--     enfants au lien ACTIF — jamais l'enfant d'un autre, jamais un lien coupé ;
--     vide pour un parent sans enfant ; zéros honnêtes pour un enfant inactif ;
--     aucun identifiant d'élève dans la charge ;
--   * admin_parent_digest_overview : admin seulement, des comptes.
-- Tout est annulé à la fin.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(22);

-- ---------------------------------------------------------
-- Fixtures : parent P lié à A (actif cette semaine) et B (inactif) ;
-- parent Q lié à C ; parent R sans enfant ; P a un lien COUPÉ vers D.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email) VALUES
  ('d8000000-0000-4000-8000-0000000000a1', 'digest-p@test.local'),
  ('d8000000-0000-4000-8000-0000000000a2', 'digest-q@test.local'),
  ('d8000000-0000-4000-8000-0000000000a3', 'digest-r@test.local'),
  ('d8000000-0000-4000-8000-0000000000b1', 'digest-a@test.local'),
  ('d8000000-0000-4000-8000-0000000000b2', 'digest-b@test.local'),
  ('d8000000-0000-4000-8000-0000000000b3', 'digest-c@test.local'),
  ('d8000000-0000-4000-8000-0000000000b4', 'digest-d@test.local'),
  ('d8000000-0000-4000-8000-0000000000ad', 'digest-admin@test.local');

INSERT INTO public.profiles (id, display_name) VALUES
  ('d8000000-0000-4000-8000-0000000000a1', 'DigestP'),
  ('d8000000-0000-4000-8000-0000000000a2', 'DigestQ'),
  ('d8000000-0000-4000-8000-0000000000a3', 'DigestR'),
  ('d8000000-0000-4000-8000-0000000000b1', 'Amine'),
  ('d8000000-0000-4000-8000-0000000000b2', 'Besma'),
  ('d8000000-0000-4000-8000-0000000000b3', 'Chedly'),
  ('d8000000-0000-4000-8000-0000000000b4', 'Dorra'),
  ('d8000000-0000-4000-8000-0000000000ad', 'DigestAdmin')
ON CONFLICT (id) DO UPDATE SET display_name = EXCLUDED.display_name;

UPDATE public.profiles SET role = 'parent'
 WHERE id IN ('d8000000-0000-4000-8000-0000000000a1',
              'd8000000-0000-4000-8000-0000000000a2',
              'd8000000-0000-4000-8000-0000000000a3');
UPDATE public.profiles SET role = 'admin'
 WHERE id = 'd8000000-0000-4000-8000-0000000000ad';
-- A : série vivante (active aujourd'hui). B : série ancienne, absente depuis 10 jours.
UPDATE public.profiles
   SET current_streak = 4, last_active_date = (now() AT TIME ZONE 'Africa/Tunis')::date
 WHERE id = 'd8000000-0000-4000-8000-0000000000b1';
UPDATE public.profiles
   SET current_streak = 9, last_active_date = (now() AT TIME ZONE 'Africa/Tunis')::date - 10
 WHERE id = 'd8000000-0000-4000-8000-0000000000b2';

INSERT INTO public.parent_student_links
  (parent_user_id, student_user_id, relation_label, is_active, created_at)
VALUES
  ('d8000000-0000-4000-8000-0000000000a1', 'd8000000-0000-4000-8000-0000000000b1', 'parent', true,  now() - INTERVAL '3 days'),
  ('d8000000-0000-4000-8000-0000000000a1', 'd8000000-0000-4000-8000-0000000000b2', 'parent', true,  now() - INTERVAL '2 days'),
  ('d8000000-0000-4000-8000-0000000000a1', 'd8000000-0000-4000-8000-0000000000b4', 'parent', false, now() - INTERVAL '1 day'),
  ('d8000000-0000-4000-8000-0000000000a2', 'd8000000-0000-4000-8000-0000000000b3', 'parent', true,  now());

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('digest-subj', 'Digest Test', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');

INSERT INTO public.chapters (id, subject_id, title) VALUES
  ('d8100000-0000-4000-8000-000000000001', 'digest-subj', 'Les fractions'),
  ('d8100000-0000-4000-8000-000000000002', 'digest-subj', 'La symétrie');

INSERT INTO public.exercises (id, chapter_id, subject_id, title) VALUES
  ('d8200000-0000-4000-8000-000000000001', 'd8100000-0000-4000-8000-000000000001', 'digest-subj', 'Ex fractions'),
  ('d8200000-0000-4000-8000-000000000002', 'd8100000-0000-4000-8000-000000000002', 'digest-subj', 'Ex symétrie');

-- A, cette semaine : 2 missions sur les fractions (40 %, 50 % → à revoir),
-- 1 sur la symétrie (90 %). Plus une mission VIEILLE de 20 jours, hors fenêtre.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES
  ('d8000000-0000-4000-8000-0000000000b1', 'd8200000-0000-4000-8000-000000000001', 'digest-subj', 2, 5, 40, 100, 10, now() - INTERVAL '9 seconds'),
  ('d8000000-0000-4000-8000-0000000000b1', 'd8200000-0000-4000-8000-000000000001', 'digest-subj', 5, 10, 50, 100, 10, now() - INTERVAL '8 seconds'),
  ('d8000000-0000-4000-8000-0000000000b1', 'd8200000-0000-4000-8000-000000000002', 'digest-subj', 9, 10, 90, 100, 10, now() - INTERVAL '7 seconds'),
  ('d8000000-0000-4000-8000-0000000000b1', 'd8200000-0000-4000-8000-000000000002', 'digest-subj', 1, 10, 10, 100, 10, now() - INTERVAL '20 days'),
  -- C (l'enfant de Q) : une mission, pour prouver qu'elle ne fuit pas chez P.
  ('d8000000-0000-4000-8000-0000000000b3', 'd8200000-0000-4000-8000-000000000001', 'digest-subj', 1, 5, 20, 100, 10, now() - INTERVAL '5 seconds'),
  -- D (lien COUPÉ avec P) : idem.
  ('d8000000-0000-4000-8000-0000000000b4', 'd8200000-0000-4000-8000-000000000001', 'digest-subj', 1, 5, 20, 100, 10, now() - INTERVAL '5 seconds');

-- 25 minutes d'apprentissage mesurées pour A (un pouls de navigation ne compte
-- pas). Un pouls plafonne à 300 s ; tout est daté à quelques secondes de
-- maintenant pour qu'un passage de minuit ne coupe pas la journée en deux.
INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at)
SELECT 'd8000000-0000-4000-8000-0000000000b1', 'lesson', 300, now() - (g || ' seconds')::interval
  FROM generate_series(1, 5) g;
INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at) VALUES
  ('d8000000-0000-4000-8000-0000000000b1', 'browse', 300, now() - INTERVAL '6 seconds');

-- ---------------------------------------------------------
-- 1. Anonyme : rien n'est atteignable.
-- ---------------------------------------------------------
SET LOCAL ROLE anon;

SELECT throws_ok(
  $$SELECT public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a1')$$,
  '42501', NULL, 'anon : le résumé est inatteignable');
SELECT throws_ok(
  $$SELECT public.set_parent_digest_pref(true)$$,
  '42501', NULL, 'anon : l''interrupteur est inatteignable');
SELECT throws_ok(
  $$SELECT * FROM public.parent_digest_prefs$$,
  '42501', NULL, 'anon : la table des préférences est illisible');

-- ---------------------------------------------------------
-- 2. Le parent P : désactivé par défaut, s'inscrit, ne triche pas.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d8000000-0000-4000-8000-0000000000a1","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT COUNT(*)::int FROM public.parent_digest_prefs), 0,
  'défaut : aucune ligne — le digest enrichi est DÉSACTIVÉ tant qu''on ne l''a pas demandé (Q-1)');

SELECT throws_ok(
  $$SELECT public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a1')$$,
  '42501', NULL, 'authenticated : même SON propre résumé ne se lit pas par ce chemin (service-role seulement)');

SELECT throws_ok(
  $$INSERT INTO public.parent_digest_prefs (parent_user_id, enriched_digest)
    VALUES ('d8000000-0000-4000-8000-0000000000a1', true)$$,
  '42501', NULL, 'aucun INSERT direct sur parent_digest_prefs');

SELECT is(
  (public.set_parent_digest_pref(true) ->> 'enriched')::boolean, true,
  'set : le parent active le digest enrichi');

SELECT is(
  (SELECT enriched_digest FROM public.parent_digest_prefs
    WHERE parent_user_id = 'd8000000-0000-4000-8000-0000000000a1'), true,
  'lecture : le parent relit SA préférence');

SELECT throws_ok(
  $$UPDATE public.parent_digest_prefs SET first_enriched_sent_at = now()$$,
  '42501', NULL, 'aucun UPDATE direct — l''estampille de mesure ne se falsifie pas');

-- ---------------------------------------------------------
-- 3. Le parent Q : ne voit pas la préférence de P, règle la sienne.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d8000000-0000-4000-8000-0000000000a2","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT COUNT(*)::int FROM public.parent_digest_prefs), 0,
  'RLS : un autre parent ne lit pas la préférence de P');

SELECT is(
  (public.set_parent_digest_pref(true) ->> 'enriched')::boolean, true,
  'set : Q active pour lui-même');
SELECT is(
  (public.set_parent_digest_pref(false) ->> 'enriched')::boolean, false,
  'set : puis coupe (upsert, même ligne)');

SELECT throws_ok(
  $$SELECT public.admin_parent_digest_overview()$$,
  'Unauthorized', 'mesure : un parent ne lit pas les compteurs');

-- ---------------------------------------------------------
-- 4. Le cron (service-role) : le résumé, et rien que les enfants liés.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL ROLE service_role;

SELECT is(
  jsonb_array_length(public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a1')), 2,
  'résumé de P : ses DEUX enfants au lien actif — ni l''enfant de Q, ni le lien coupé');

SELECT is(
  public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a1') -> 0,
  jsonb_build_object(
    'displayName', 'Amine', 'learningMinutes', 25, 'missions', 3,
    'activeDays', 1, 'streak', 4, 'weakChapter', 'Les fractions'),
  'enfant actif : temps mesuré (hors navigation), missions de la SEMAINE, série, un chapitre à revoir');

SELECT is(
  public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a1') -> 1,
  jsonb_build_object(
    'displayName', 'Besma', 'learningMinutes', 0, 'missions', 0,
    'activeDays', 0, 'streak', 0, 'weakChapter', NULL),
  'enfant sans activité : des zéros honnêtes, et une série ancienne ne s''affiche plus');

SELECT ok(
  public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a1')::text !~ 'd8000000',
  'aucun identifiant d''élève dans la charge utile');

SELECT is(
  public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a2') -> 0 ->> 'displayName',
  'Chedly', 'résumé de Q : son enfant, pas ceux de P');

SELECT is(
  public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000a3'), '[]'::jsonb,
  'parent sans enfant lié : résumé vide');

SELECT is(
  public.get_parent_digest_summary('d8000000-0000-4000-8000-0000000000b1'), '[]'::jsonb,
  'un élève passé en paramètre n''est le parent de personne : vide');

-- Le cron estampille le premier envoi réel de Q (qui a coupé depuis).
UPDATE public.parent_digest_prefs SET first_enriched_sent_at = now()
 WHERE parent_user_id = 'd8000000-0000-4000-8000-0000000000a2';

-- ---------------------------------------------------------
-- 5. L'admin lit la mesure : des comptes, pas des personnes.
-- ---------------------------------------------------------
RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d8000000-0000-4000-8000-0000000000ad","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  public.admin_parent_digest_overview() - 'linkedParents',
  jsonb_build_object('optedIn', 1, 'everSent', 1, 'cutAfterFirstSend', 1),
  'mesure : 1 opt-in (P), 1 envoi daté, 1 coupure après le premier envoi (Q)');

SELECT cmp_ok(
  (public.admin_parent_digest_overview() ->> 'linkedParents')::int, '>=', 2,
  'mesure : les parents liés (liens actifs) sont le dénominateur de l''opt-in');

SELECT * FROM finish();
ROLLBACK;

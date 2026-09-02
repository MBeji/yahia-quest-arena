-- =========================================================
-- Étude 31, lot 1 — LA MESURE DU RETOUR (`admin_engagement_overview`).
-- ---------------------------------------------------------
-- Une console de rétention se trompe de trois façons, et les trois sont
-- silencieuses. Ce fichier les tient toutes :
--
--   1. ⭐ LA GARDE. Un non-admin est REFUSÉ. La fonction agrège TOUT le parc
--      (cohortes, séries, volumétrie) : un SECURITY DEFINER ouvert transformerait
--      la console en fuite de chiffres d'entreprise pour n'importe quel élève.
--   2. ⭐ LES VALEURS SONT EXACTES, pas « plausibles ». Chaque décor est construit
--      pour qu'UN SEUL calcul produise le chiffre attendu : CURR 66,7 % ne tombe
--      que si l'intersection des deux semaines est faite (2 revenus sur 3 actifs),
--      et un élève actif la semaine suivante SEULEMENT n'entre pas au dénominateur.
--   3. ⭐ LA SÉRIE FANTÔME. `profiles.current_streak` n'est réécrite que par
--      `award_xp` : un élève parti depuis cinq jours porte encore « 40 ». Le décor
--      en pose un exprès. S'il apparaît dans « 30 jours et + », la page publie des
--      séries qui n'existent pas — c'est le constat n° 7 de l'étude, en base.
--
-- Plus : « pas encore mesurable » ≠ « personne n'est revenu » (une cohorte dont la
-- fenêtre n'est pas écoulée rend NULL, jamais 0), le journal de consentement push
-- (KPI-D — l'opt-out n'était PAS comptable avant ce lot), et les grants explicites
-- (piège CLAUDE.md : sur base vierge, une vue neuve n'hérite d'aucun droit).
--
-- ⚠️ AUCUNE DATE EN DUR (leçon #934) : tout est relatif à `app_current_week_start()`
-- et à `now()`. Les jours d'activité sont posés à midi, heure de Tunis, pour que le
-- passage timestamptz → date locale ne dépende jamais de l'heure d'exécution.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(29);

-- ---------------------------------------------------------
-- Décor de catalogue : de quoi accrocher des tentatives (FK réelles) et un
-- chapitre COMPLÉTABLE (une mission admin hors quiz, aucun quiz → non gaté).
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades)
VALUES ('eng-theme', 'Engagement Theme', 'Brain', 'subject-math', true);

INSERT INTO public.grades (id, theme_id, slug, name_fr, cycle, display_order)
VALUES ('e0000000-0000-4000-8000-0000000000f1'::uuid, 'eng-theme', 'eng-9', 'ENG 9ème', 'college', 9);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id, grade_id, content_language)
VALUES ('eng-subj', 'ENG Maths', 'Esprit', 'subject-math', 'Brain', 'eng-theme',
        'e0000000-0000-4000-8000-0000000000f1'::uuid, 'fr');

INSERT INTO public.chapters (id, subject_id, title, summary, lesson_content)
VALUES ('e0000000-0000-4000-8000-0000000000c1'::uuid, 'eng-subj', 'ENG Chapitre',
        'Résumé ENG', '## Leçon');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, difficulty, mode, source)
VALUES ('e0000000-0000-4000-8000-0000000000e1'::uuid,
        'e0000000-0000-4000-8000-0000000000c1'::uuid, 'eng-subj', 'ENG Ex', 1, 'practice', 'admin');

-- ---------------------------------------------------------
-- Les comptes. Un admin, douze élèves, trois familles disjointes :
--   s1..s4 : la CURR, la précision, les chapitres complétés ;
--   c1..c4 : les cohortes d'inscription (leur activité est ANTÉRIEURE aux
--            semaines dont on assert la CURR — les deux mesures ne se marchent
--            pas dessus) ;
--   k1..k4 : les séries, dont le fantôme.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
SELECT
  ('e0000000-0000-4000-8000-00000000000' || n)::uuid,
  'eng-user-' || n || '@test.local', 'x', now(),
  '{"display_name":"Eng"}'::jsonb, now(), now(),
  'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'
FROM generate_series(1, 9) n
UNION ALL
SELECT
  ('e0000000-0000-4000-8000-0000000000' || n)::uuid,
  'eng-user-' || n || '@test.local', 'x', now(),
  '{"display_name":"Eng"}'::jsonb, now(), now(),
  'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'
FROM generate_series(10, 13) n;

-- Le profil naît par trigger ; on ne règle ici que ce que la mesure lit.
-- 13 = l'admin. Les 12 autres restent 'student' (défaut).
UPDATE public.profiles SET role = 'admin' WHERE id = 'e0000000-0000-4000-8000-000000000013'::uuid;

-- =========================================================
-- 1. Les droits — le premier rempart, avant même la garde de rôle.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('anon', 'public.admin_engagement_overview()', 'EXECUTE'),
  'anon ne peut pas appeler la console d''engagement — le REVOKE tient sans dépendre de is_admin()'
);

SELECT ok(
  has_function_privilege('authenticated', 'public.admin_engagement_overview()', 'EXECUTE'),
  'un connecté peut l''appeler : c''est la garde de RÔLE, pas le GRANT, qui trie les admins'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.eng_activity_days', 'SELECT'),
  '⭐ la vue des jours d''activité est fermée aux élèves — elle porte le user_id de TOUT le parc'
);

SELECT ok(
  NOT has_table_privilege('anon', 'public.eng_activity_weeks', 'SELECT'),
  'la vue des semaines est fermée à anon'
);

SELECT ok(
  NOT has_table_privilege('authenticated', 'public.push_consent_events', 'SELECT'),
  'le journal de consentement push n''est lisible par aucun client (grants explicites, base vierge)'
);

-- =========================================================
-- 2. ⭐ LA GARDE. Un élève ordinaire ne lit pas la volumétrie du parc.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e0000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.admin_engagement_overview() $$,
  'P0001',
  'Unauthorized',
  '⭐ un NON-admin est refusé — la fonction agrège cohortes, séries et volumétrie'
);

RESET ROLE;

-- =========================================================
-- 3. LE PARC VIDE — des zéros et des NULL, jamais une division par zéro.
--    (Aucune tentative, aucun pouls n'existe encore à ce point.)
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e0000000-0000-4000-8000-000000000013","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  jsonb_array_length(public.admin_engagement_overview()->'curr'),
  8,
  'la CURR publie 8 semaines mesurables — la semaine en cours et la précédente en sont exclues'
);

SELECT is(
  (public.admin_engagement_overview()->'curr'->7->>'curr_pct'),
  NULL,
  '⭐ sur une semaine sans aucun actif, la CURR vaut NULL — « 0 % de retour » serait un chiffre faux'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->>'accuracy_avg_pct'),
  NULL,
  'sans aucune tentative, la précision est NULL — la fonction RÉPOND, elle ne lève pas'
);

SELECT is(
  (public.admin_engagement_overview()->'push'->>'optout_pct'),
  NULL,
  'sans aucun abonné, le taux d''opt-out est NULL, pas une division par zéro'
);

RESET ROLE;

-- ---------------------------------------------------------
-- LE DÉCOR MESURÉ.
--
-- CURR — semaine S-3 contre semaine S-2 (S = lundi de la semaine en cours) :
--   s1 : active S-3 ET S-2   → revenue
--   s2 : active S-3 seule    → perdue
--   s3 : active S-3 ET S-2   → revenue
--   s4 : active S-2 seule    → PAS au dénominateur de S-3
--   ⇒ CURR(S-3) = 2/3 = 66,7. Aucune autre lecture ne donne cette valeur :
--     compter s4 donnerait 50,0 ; oublier l'intersection, 100,0.
--
-- PRÉCISION (30 j) — 4 tentatives à 80 % (s1, s3) et 2 à 50 % (s2, s4) ⇒ 70,00.
-- CHAPITRES — seuls s1 et s3 passent la barre des 60 % : 2 chapitres complétés
--   pour 5 actifs sur 30 jours (s1..s4 + k1, qui n'a qu'un pouls) ⇒ 0,40.
-- ---------------------------------------------------------
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
SELECT u, 'e0000000-0000-4000-8000-0000000000e1'::uuid, 'eng-subj',
       CASE WHEN s = 80 THEN 4 ELSE 2 END, 5, s, 120, 20, 'classic',
       ((public.app_current_week_start() + off + TIME '12:00') AT TIME ZONE 'Africa/Tunis')
FROM (VALUES
  ('e0000000-0000-4000-8000-000000000001'::uuid, -19, 80),  -- s1, semaine S-3
  ('e0000000-0000-4000-8000-000000000001'::uuid, -12, 80),  -- s1, semaine S-2
  ('e0000000-0000-4000-8000-000000000002'::uuid, -19, 50),  -- s2, semaine S-3
  ('e0000000-0000-4000-8000-000000000003'::uuid, -18, 80),  -- s3, semaine S-3
  ('e0000000-0000-4000-8000-000000000003'::uuid, -11, 80),  -- s3, semaine S-2
  ('e0000000-0000-4000-8000-000000000004'::uuid, -10, 50)   -- s4, semaine S-2 seule
) AS v(u, off, s);

-- Les cohortes : quatre comptes inscrits LE MÊME JOUR (donc une seule cohorte),
-- dont les retours tombent dans des fenêtres différentes.
UPDATE public.profiles
   SET created_at = ((public.app_current_week_start() - 50 + TIME '09:00') AT TIME ZONE 'Africa/Tunis')
 WHERE id IN (
   'e0000000-0000-4000-8000-000000000005'::uuid,
   'e0000000-0000-4000-8000-000000000006'::uuid,
   'e0000000-0000-4000-8000-000000000007'::uuid,
   'e0000000-0000-4000-8000-000000000008'::uuid
 );

-- s1..s4 et k1..k4 sont inscrits BIEN AVANT la fenêtre des cohortes : ils ne
-- doivent pas s'y inviter (sinon la cohorte mesurée changerait de taille).
UPDATE public.profiles
   SET created_at = now() - INTERVAL '120 days'
 WHERE role = 'student'
   AND id NOT IN (
     'e0000000-0000-4000-8000-000000000005'::uuid,
     'e0000000-0000-4000-8000-000000000006'::uuid,
     'e0000000-0000-4000-8000-000000000007'::uuid,
     'e0000000-0000-4000-8000-000000000008'::uuid
   );

INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct,
   duration_seconds, xp_earned, variant, completed_at)
SELECT u, 'e0000000-0000-4000-8000-0000000000e1'::uuid, 'eng-subj', 4, 5, 80, 120, 20, 'classic',
       ((public.app_current_week_start() - 50 + off + TIME '12:00') AT TIME ZONE 'Africa/Tunis')
FROM (VALUES
  ('e0000000-0000-4000-8000-000000000005'::uuid, 1),   -- c1 : J+1  → D1, D7, D30
  ('e0000000-0000-4000-8000-000000000006'::uuid, 5),   -- c2 : J+5  → D7, D30
  ('e0000000-0000-4000-8000-000000000007'::uuid, 15)   -- c3 : J+15 → D30 seul
  -- c4 : jamais revenu.
) AS v(u, off);

-- Les séries. Aucune tentative ici : la série vit dans `profiles`, et c'est
-- exactement le point — la colonne survit à l'inactivité.
UPDATE public.profiles SET current_streak = 10, last_active_date = CURRENT_DATE
 WHERE id = 'e0000000-0000-4000-8000-000000000009'::uuid;   -- k1 : vivante (7-29)
UPDATE public.profiles SET current_streak = 3, last_active_date = CURRENT_DATE - 1
 WHERE id = 'e0000000-0000-4000-8000-000000000010'::uuid;   -- k2 : vivante (1-6)
UPDATE public.profiles SET current_streak = 40, last_active_date = CURRENT_DATE - 5
 WHERE id = 'e0000000-0000-4000-8000-000000000011'::uuid;   -- k3 : ⭐ LE FANTÔME
UPDATE public.profiles SET current_streak = 0, last_active_date = NULL
 WHERE id = 'e0000000-0000-4000-8000-000000000012'::uuid;   -- k4 : jamais joué

-- k1 est le seul actif de la semaine en cours : il porte KPI-C à lui seul.
INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at)
VALUES ('e0000000-0000-4000-8000-000000000009'::uuid, 'lesson', 120, now());

-- Un pouls de NAVIGATION ne vaut pas un retour (RISK-1 : métrique de vanité).
INSERT INTO public.learning_pulses (user_id, surface, active_seconds, occurred_at)
VALUES ('e0000000-0000-4000-8000-000000000012'::uuid, 'browse', 120, now());

-- =========================================================
-- 4. ⭐ LA CURR — la seule valeur que produit une vraie intersection.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e0000000-0000-4000-8000-000000000013","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT (w->>'active')::int
     FROM jsonb_array_elements(public.admin_engagement_overview()->'curr') w
    WHERE (w->>'week_start')::date = public.app_current_week_start() - 21),
  3,
  'trois élèves actifs en semaine S-3 — celui qui n''arrive qu''en S-2 n''y est pas'
);

SELECT is(
  (SELECT (w->>'curr_pct')::numeric
     FROM jsonb_array_elements(public.admin_engagement_overview()->'curr') w
    WHERE (w->>'week_start')::date = public.app_current_week_start() - 21),
  66.7::numeric,
  '⭐ CURR(S-3) = 2 revenus / 3 actifs = 66,7 % — compter s4 donnerait 50, oublier l''intersection 100'
);

-- =========================================================
-- 5. ⭐ LES COHORTES — et la différence entre « non mesurable » et « zéro ».
-- =========================================================
SELECT is(
  (SELECT (c->>'size')::int
     FROM jsonb_array_elements(public.admin_engagement_overview()->'cohorts') c
    WHERE (c->>'cohort_week')::date = date_trunc('week', public.app_current_week_start() - 50)::date),
  4,
  'la cohorte de la semaine d''inscription compte ses quatre comptes'
);

SELECT is(
  (SELECT (c->>'d1_pct')::numeric
     FROM jsonb_array_elements(public.admin_engagement_overview()->'cohorts') c
    WHERE (c->>'cohort_week')::date = date_trunc('week', public.app_current_week_start() - 50)::date),
  25.0::numeric,
  'D1 = 1/4 — seul le retour du lendemain compte, le jour de l''inscription ne compte jamais'
);

SELECT is(
  (SELECT (c->>'d7_pct')::numeric
     FROM jsonb_array_elements(public.admin_engagement_overview()->'cohorts') c
    WHERE (c->>'cohort_week')::date = date_trunc('week', public.app_current_week_start() - 50)::date),
  50.0::numeric,
  '⭐ D7 = 2/4 : la fenêtre (J+1..J+7) englobe D1 — une lecture « jour exact » donnerait 25'
);

SELECT is(
  (SELECT (c->>'d30_pct')::numeric
     FROM jsonb_array_elements(public.admin_engagement_overview()->'cohorts') c
    WHERE (c->>'cohort_week')::date = date_trunc('week', public.app_current_week_start() - 50)::date),
  75.0::numeric,
  'D30 = 3/4 — la rétention par fenêtre est monotone : D1 ≤ D7 ≤ D30'
);

-- Une cohorte toute neuve : mesurable pour rien, donc NULL partout — surtout pas 0.
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES ('e0000000-0000-4000-8000-000000000014'::uuid, 'eng-fresh@test.local', 'x', now(),
        '{"display_name":"Fresh"}'::jsonb, now(), now(),
        'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000');

SELECT is(
  (SELECT (c->>'d30_pct')
     FROM jsonb_array_elements(public.admin_engagement_overview()->'cohorts') c
    WHERE (c->>'cohort_week')::date = public.app_current_week_start()),
  NULL,
  '⭐ un compte créé aujourd''hui rend NULL à D30 — « pas encore mesurable » n''est pas « perdu »'
);

SELECT is(
  (SELECT (c->>'size')::int
     FROM jsonb_array_elements(public.admin_engagement_overview()->'cohorts') c
    WHERE (c->>'cohort_week')::date = public.app_current_week_start()),
  1,
  'ce compte tout neuf est bien COMPTÉ dans sa cohorte — il n''est pas caché, il est non mesurable'
);

-- =========================================================
-- 6. ⭐ LES SÉRIES — le fantôme ne doit pas monter sur le podium.
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'streaks'->>'b30_plus')::int,
  0,
  '⭐ l''élève parti depuis 5 jours avec current_streak = 40 n''est PAS compté « 30 jours et + »'
);

SELECT is(
  (public.admin_engagement_overview()->'streaks'->>'b7_29')::int,
  1,
  'seule la série RÉELLEMENT vivante (dernière activité aujourd''hui) tient dans 7-29'
);

SELECT is(
  (public.admin_engagement_overview()->'streaks'->>'b1_6')::int,
  1,
  'une série d''hier reste vivante : la journée n''est pas finie, on ne la tue pas d''un jour d''avance'
);

SELECT is(
  (public.admin_engagement_overview()->'streaks'->>'weekly_active_7plus')::int,
  1,
  'KPI-C : un seul actif de la semaine tient une série ≥ 7 jours'
);

-- =========================================================
-- 7. LA MÉTRIQUE DE GARDE (R-1) — elle doit exister ET être juste.
-- =========================================================
SELECT is(
  (public.admin_engagement_overview()->'learning'->>'accuracy_avg_pct')::numeric,
  70.00::numeric,
  'précision moyenne sur 30 jours = (4×80 + 2×50)/6 — les tentatives d''il y a 50 jours n''y entrent pas'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->>'chapters_completed')::int,
  2,
  'deux élèves ont réellement complété le chapitre (≥ 60 %) — pas les deux qui ont eu 50 %'
);

SELECT is(
  (public.admin_engagement_overview()->'learning'->>'chapters_per_active')::numeric,
  0.40::numeric,
  '2 chapitres pour 5 actifs sur 30 jours — la progression se publie À CÔTÉ de l''engagement (R-1)'
);

-- Le pouls `browse` de k4 ne l'a pas rendu « actif » : sinon MAU vaudrait 6.
SELECT is(
  (public.admin_engagement_overview()->'activity'->>'mau')::int,
  5,
  '⭐ naviguer dans le catalogue n''est pas revenir — le pouls « browse » ne compte pas (RISK-1)'
);

RESET ROLE;

-- =========================================================
-- 8. KPI-D — le consentement push, par le VRAI chemin (les deux RPC).
--    Avant ce lot, l'opt-out n'était pas comptable : le désabonnement SUPPRIME
--    la ligne, donc « jamais abonné » et « parti » se ressemblaient.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e0000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.save_push_subscription('https://push.test/s1-a', 'k', 'a', 'UA');
SELECT public.save_push_subscription('https://push.test/s1-b', 'k', 'a', 'UA');
SELECT public.delete_push_subscription('https://push.test/s1-a');
RESET ROLE;

SET LOCAL request.jwt.claims = '{"sub":"e0000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;
SELECT public.save_push_subscription('https://push.test/s2-a', 'k', 'a', 'UA');
SELECT public.delete_push_subscription('https://push.test/s2-a');
RESET ROLE;

SELECT is(
  (SELECT COUNT(*)::int FROM public.push_consent_events WHERE action = 'optin'),
  2,
  '⭐ deux bascules d''opt-in, pas trois : un second appareil n''est pas un nouveau consentement'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.push_consent_events WHERE action = 'optout'),
  1,
  '⭐ retirer UN appareil sur deux n''est pas un opt-out — seule la dernière ligne qui part en est un'
);

SET LOCAL request.jwt.claims = '{"sub":"e0000000-0000-4000-8000-000000000013","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.admin_engagement_overview()->'push'->>'optout_pct')::numeric,
  50.0::numeric,
  'taux d''opt-out = 1 coupure / (1 abonné restant + 1 coupure) — le garde-fou R-4 a enfin un chiffre'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;

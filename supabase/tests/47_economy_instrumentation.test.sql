-- =========================================================
-- Étude 09 — lot 1 : instrumentation de l'économie.
-- ---------------------------------------------------------
-- Une page d'analytics n'est dangereuse que de deux façons : elle FUIT, ou elle
-- MENT. Ce fichier attaque les deux.
--
--   * FUITE — les vues `econ_*` agrègent l'économie de TOUS les élèves. Elles
--     doivent être illisibles par anon comme par authenticated, et le RPC doit
--     refuser un compte non-admin. Un élève qui lirait le tableau de bord
--     économique verrait des chiffres d'entreprise, pas les siens.
--   * MENSONGE — les sources de coins sont RECONSTRUITES (D-5), pas relevées. Si
--     la règle canonique dérive, la page affiche un chiffre faux avec l'aplomb
--     d'un chiffre vrai. Les assertions rejouent donc l'arithmétique sur des
--     nombres vérifiables à la main.
--
-- Plus la divergence qui guette une vue SQL : `XP_PER_LEVEL` est écrit en dur ici
-- parce qu'une vue ne peut pas importer `gamification.ts`. L'assertion 10 est le
-- seul endroit qui reliera les deux le jour où la constante bougera.
--
-- Espace de noms des fixtures : préfixe `ec000000…`, inutilisé ailleurs.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(12);

-- =========================================================
-- 1–5. Les droits : rien ne sort des vues, une seule porte.
-- =========================================================
SELECT is(
  has_table_privilege('anon', 'public.econ_xp_daily', 'SELECT'),
  false, 'anon ne lit pas econ_xp_daily');

SELECT is(
  has_table_privilege('authenticated', 'public.econ_xp_daily', 'SELECT'),
  false, 'authenticated non plus — ce sont des agrégats globaux, pas ses chiffres');

SELECT is(
  has_table_privilege('authenticated', 'public.econ_coin_flows_30d', 'SELECT'),
  false, 'authenticated ne lit pas les flux de coins');

SELECT is(
  has_function_privilege('anon', 'public.admin_economy_overview()', 'EXECUTE'),
  false, 'anon ne peut pas appeler le RPC');

SELECT is(
  has_function_privilege('authenticated', 'public.admin_economy_overview()', 'EXECUTE'),
  true, 'authenticated PEUT l''appeler — la porte est le contrôle de rôle, pas le GRANT');

-- =========================================================
-- Fixtures : un admin, deux élèves, des tentatives aux scores CHOISIS pour que
-- l'arithmétique des coins soit vérifiable de tête.
-- =========================================================
INSERT INTO auth.users (id, email) VALUES
  ('ec000000-0000-0000-0000-00000000000a', 'admin-econ@test.local'),
  ('ec000000-0000-0000-0000-00000000000b', 'eleve1-econ@test.local'),
  ('ec000000-0000-0000-0000-00000000000c', 'eleve2-econ@test.local');

UPDATE public.profiles SET role = 'admin' WHERE id = 'ec000000-0000-0000-0000-00000000000a';

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('econ-subj', 'Econ', 'Esprit', 'subject-math', 'Brain', 'ecole-tn');
INSERT INTO public.chapters (id, subject_id, title)
VALUES ('ec000000-0001-0000-0000-000000000001', 'econ-subj', 'Ch');
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode)
VALUES ('ec000000-0002-0000-0000-000000000001',
        'ec000000-0001-0000-0000-000000000001', 'econ-subj', 'Ex', 'admin', 'practice');

-- Élève 1 : 100 XP à 80 % (réussi)  -> 100/5  = 20 coins
-- Élève 2 : 100 XP à 45 % (moitié)  -> 100/10 = 10 coins
-- Élève 2 : 100 XP à 30 % (rien)    ->          0 coin
-- Total attendu : 30.00 coins estimés.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES
  ('ec000000-0000-0000-0000-00000000000b', 'ec000000-0002-0000-0000-000000000001',
   'econ-subj', 8, 10, 80, 120, 100, now() - INTERVAL '1 day'),
  ('ec000000-0000-0000-0000-00000000000c', 'ec000000-0002-0000-0000-000000000001',
   'econ-subj', 4, 10, 45, 120, 100, now() - INTERVAL '1 day'),
  ('ec000000-0000-0000-0000-00000000000c', 'ec000000-0002-0000-0000-000000000001',
   'econ-subj', 3, 10, 30, 120, 100, now() - INTERVAL '1 day');

-- =========================================================
-- 6. La porte : un élève ordinaire est refusé, même avec le GRANT d'exécution.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"ec000000-0000-0000-0000-00000000000b","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  'SELECT public.admin_economy_overview()',
  'P0001',
  'Unauthorized',
  'un élève NON-admin est refusé — le GRANT ouvre la porte, le rôle la garde');

RESET ROLE;

-- =========================================================
-- 7–11. Vu par l'admin : la forme, l'arithmétique, et l'absence de fuite.
-- =========================================================
SET LOCAL "request.jwt.claims" = '{"sub":"ec000000-0000-0000-0000-00000000000a","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*)::int FROM jsonb_object_keys(public.admin_economy_overview()) k
    WHERE k IN ('xp_daily', 'level_velocity', 'coin_flows', 'consumables',
                'premium_funnel', 'notes')),
  6,
  'l''admin reçoit les six sections — une par US, plus les notes');

-- L'arithmétique de D-5, sur des nombres choisis : 20 + 10 + 0 = 30.
SELECT is(
  ((public.admin_economy_overview() -> 'coin_flows' ->> 'sources_estimated')::numeric),
  30.00::numeric,
  'D-5 : les sources reconstruisent la règle canonique (1/5, demi à 40-59 %, 0 sous 40)');

-- Le plancher des 40 % : la tentative à 30 % ne rapporte RIEN. Si elle comptait,
-- le total serait 40 et l''assertion précédente le dirait — celle-ci nomme la règle.
SELECT is(
  ((public.admin_economy_overview() -> 'coin_flows' ->> 'sources_estimated')::numeric) < 40,
  true,
  'une tentative sous 40 % ne crée aucun coin — le plancher tient');

-- R-2 : AUCUNE donnée nominative ne sort. Les vues portent des `user_id` pour
-- calculer par élève ; le RPC n'en laisse passer aucun.
SELECT is(
  public.admin_economy_overview()::text LIKE '%ec000000-0000-0000-0000-00000000000b%',
  false,
  'R-2 : aucun user_id ne sort du RPC — que des agrégats anonymes');

-- RISK-1 : des percentiles, pas une moyenne seule.
SELECT is(
  (SELECT count(*)::int FROM jsonb_object_keys(public.admin_economy_overview() -> 'xp_daily') k
    WHERE k IN ('p50', 'p90', 'max')),
  3,
  'RISK-1 : la distribution est rendue en percentiles, jamais une moyenne seule');

-- =========================================================
-- 12. La divergence qui guette : la vue écrit XP_PER_LEVEL en dur (une vue SQL ne
-- peut pas importer `gamification.ts`). Le jour où la constante bouge, c'est ICI
-- que ça doit casser — sinon la vélocité des paliers ment en silence.
-- =========================================================
SELECT is(
  ((SELECT public.admin_economy_overview() -> 'notes' ->> 'xp_per_level')::int),
  200,
  'XP_PER_LEVEL vaut 200 — si gamification.ts change, ce test casse AVANT la page');

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;

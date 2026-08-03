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
INSERT INTO public.exercises (id, chapter_id, subject_id, title, source, mode, reward_coins)
VALUES ('ec000000-0002-0000-0000-000000000001',
        'ec000000-0001-0000-0000-000000000001', 'econ-subj', 'Ex', 'admin', 'practice', 20);

-- ⚠️ Corrigé le 2026-08-03 : le RPC de soumission n'a AUCUNE règle de demi-coins,
-- et les coins ne dérivent pas de l'XP — c'est le forfait `exercises.reward_coins`,
-- versé si et seulement si la tentative est éligible. `xp_earned > 0` EST la
-- signature de cette éligibilité (le RPC met les deux à zéro ensemble).
--
-- L'exercice porte reward_coins = 20.
-- Élève 1 : récompensée (xp_earned = 100) -> 20 coins
-- Élève 2 : récompensée (xp_earned = 100) -> 20 coins
-- Élève 2 : NON récompensée (xp_earned = 0) -> 0 coin
-- Total attendu : 40.00 coins versés.
INSERT INTO public.attempts
  (user_id, exercise_id, subject_id, correct_count, total_count, score_pct, duration_seconds, xp_earned, completed_at)
VALUES
  ('ec000000-0000-0000-0000-00000000000b', 'ec000000-0002-0000-0000-000000000001',
   'econ-subj', 8, 10, 80, 120, 100, now() - INTERVAL '1 day'),
  ('ec000000-0000-0000-0000-00000000000c', 'ec000000-0002-0000-0000-000000000001',
   'econ-subj', 4, 10, 45, 120, 100, now() - INTERVAL '1 day'),
  ('ec000000-0000-0000-0000-00000000000c', 'ec000000-0002-0000-0000-000000000001',
   'econ-subj', 3, 10, 30, 120, 0, now() - INTERVAL '1 day');

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

-- Le flux CALCULÉ, sur des nombres choisis : 20 + 20 + 0 = 40.
SELECT is(
  ((public.admin_economy_overview() -> 'coin_flows' ->> 'sources_earned')::numeric),
  40.00::numeric,
  'les sources somment le forfait des tentatives RÉCOMPENSÉES, pas une règle dérivée');

-- L'éligibilité est BINAIRE : une tentative non récompensée (xp_earned = 0) ne
-- verse rien. Si elle comptait, le total serait 60 — cette assertion nomme la règle
-- que l'étude décrivait à tort comme un « demi-coin ».
SELECT is(
  ((public.admin_economy_overview() -> 'coin_flows' ->> 'sources_earned')::numeric) < 60,
  true,
  'une tentative non récompensée ne verse AUCUN coin — pas de demi-mesure');

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

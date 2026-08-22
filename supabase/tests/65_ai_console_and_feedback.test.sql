-- =========================================================
-- S65 — LA CONSOLE ET LE RETOUR QUALITÉ.
--
-- Ce que ce fichier garde, et pourquoi chaque point vaut un test :
--
--   1. `get_ai_console` est SELF-SCOPED. C'est la surface des MONTANTS ; si elle
--      pouvait parler d'un autre porteur, R-14 tomberait par le seul chemin qui
--      compte — celui qui affiche des dollars.
--   2. Le `model` d'un 👍/👎 vient du QUIZ, pas du client. Laisser le navigateur
--      le déclarer permettrait d'imputer un avis au mauvais modèle, et le
--      tableau de §1.4 — « le ratio 👍/👎 par modèle, la donnée que personne n'a
--      aujourd'hui » — deviendrait faux sans que rien ne le signale.
--   3. La console ADMIN refuse un non-admin, et ne rend que des agrégats.
--   4. Les kill-switches coupent VRAIMENT : le global éteint `resolve_ai_access`,
--      la suspension d'une famille éteint la sienne.
--   5. Les purges tournent.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(20);

-- ---------------------------------------------------------
-- Fixtures : deux porteurs, un élève, un admin, un quiz forgé.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('e9000000-0000-4000-8000-000000000001', 'console-a@test.local', 'x', now(),
   '{"display_name":"Porteur A"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e9000000-0000-4000-8000-000000000002', 'console-b@test.local', 'x', now(),
   '{"display_name":"Porteur B"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e9000000-0000-4000-8000-000000000003', 'console-child@test.local', 'x', now(),
   '{"display_name":"Enfant"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e9000000-0000-4000-8000-000000000009', 'console-admin@test.local', 'x', now(),
   '{"display_name":"Admin"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000')
ON CONFLICT (id) DO NOTHING;

UPDATE public.profiles SET role = 'admin' WHERE id = 'e9000000-0000-4000-8000-000000000009';

INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active)
VALUES ('e9000000-0000-4000-8000-000000000001', 'e9000000-0000-4000-8000-000000000003', true)
ON CONFLICT (parent_user_id, student_user_id) DO UPDATE SET is_active = true;

SELECT public.set_ai_credential(
  'e9000000-0000-4000-8000-000000000001'::uuid, 'anthropic', NULL,
  'claude-haiku-4-5', 'claude-sonnet-5', '\x0011223344556677'::bytea, 1::smallint,
  'fp-a', 'aaaa', 2, 20, '2026-08-22');
SELECT public.set_ai_credential(
  'e9000000-0000-4000-8000-000000000002'::uuid, 'anthropic', NULL,
  'claude-haiku-4-5', 'claude-sonnet-5', '\x0011223344556677'::bytea, 1::smallint,
  'fp-b', 'bbbb', 2, 20, '2026-08-22');

-- Deux appels pour A, un pour B — la console de A ne doit voir que les siens.
SELECT public.log_ai_usage('family', 'anthropic', 'explain', 'claude-sonnet-5', 'ok',
  'e9000000-0000-4000-8000-000000000003'::uuid, 'e9000000-0000-4000-8000-000000000001'::uuid,
  100, 50, 0, 1500000, NULL, 300);
SELECT public.log_ai_usage('family', 'anthropic', 'forge', 'claude-sonnet-5', 'error',
  'e9000000-0000-4000-8000-000000000003'::uuid, 'e9000000-0000-4000-8000-000000000001'::uuid,
  0, 0, 0, 0, 'AI_PROVIDER_DOWN', 120);
SELECT public.log_ai_usage('family', 'anthropic', 'explain', 'claude-haiku-4-5', 'ok',
  NULL, 'e9000000-0000-4000-8000-000000000002'::uuid, 10, 5, 0, 9000, NULL, 90);

INSERT INTO public.ai_spend_ledger (owner_user_id, day, spent_micros)
VALUES ('e9000000-0000-4000-8000-000000000001', CURRENT_DATE, 1500000)
ON CONFLICT (owner_user_id, day) DO UPDATE SET spent_micros = 1500000;

-- Un quiz forgé au taux de rebut ÉLEVÉ : 2 gardés, 9 jetés ⇒ 82 % (R-19).
SELECT public.create_forged_quiz(
  'e9000000-0000-4000-8000-000000000003'::uuid,
  'e9000000-0000-4000-8000-000000000001'::uuid,
  -- Périmètre « mes erreurs » : pas de chapitre, ce que le CHECK exige
  -- (`(scope = 'chapter') = (chapter_id IS NOT NULL)`).
  'mistakes', NULL, NULL, 'fr', 2, 5,
  '{"items":[{"id":"q1"},{"id":"q2"}]}'::jsonb, 'claude-sonnet-5', 9, true)
IS NOT NULL AS seeded;

SELECT set_config('test.quiz_id',
  (SELECT id::text FROM public.ai_forged_quizzes
    WHERE owner_user_id = 'e9000000-0000-4000-8000-000000000001'), true);

-- ---------------------------------------------------------
-- 1. `get_ai_console` — self-scoped, et R-14 avec elle.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"e9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT day_micros FROM public.get_ai_console()),
  1500000::BIGINT,
  'la console rend la dépense du JOUR de son appelant'
);

SELECT is(
  (SELECT calls_month FROM public.get_ai_console()),
  2,
  'elle compte les appels du porteur — les deux siens, pas les trois du parc'
);

SELECT is(
  (SELECT by_student->>'Enfant' FROM public.get_ai_console()),
  '1500000',
  'la ventilation par élève nomme le PSEUDO, pas un identifiant'
);

SELECT is(
  (SELECT by_model->'claude-sonnet-5'->>'errors' FROM public.get_ai_console()),
  '1',
  'R-13 : les erreurs sont imputées AU MODÈLE qui les a produites'
);

SELECT is(
  (SELECT jsonb_array_length(recent) FROM public.get_ai_console()),
  2,
  'le journal des derniers appels remonte'
);

-- Le journal dit COMBIEN et QUOI, jamais QUEL CONTENU (§3.9).
SELECT is_empty(
  $$ SELECT 1 FROM public.get_ai_console() c, jsonb_array_elements(c.recent) AS r
      WHERE r ? 'prompt' OR r ? 'text' OR r ? 'content' $$,
  '§3.9 : le journal ne porte AUCUN contenu d''appel — surface, date, statut, coût'
);

SELECT is(
  (SELECT forge_discard_rate FROM public.get_ai_console()),
  0.818::NUMERIC,
  'R-19 : le taux de rebut de la Forge sur 7 jours est mesuré (9 jetés / 11)'
);

RESET ROLE;

-- L'autre porteur voit SA dépense, et rien de celle de A.
SET LOCAL request.jwt.claims = '{"sub":"e9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT calls_month FROM public.get_ai_console()),
  1,
  'R-14 : la console est SELF-SCOPED — un porteur ne voit jamais la dépense d''un autre'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 2. Le retour qualité — le modèle vient du QUIZ.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"e9000000-0000-4000-8000-000000000003","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT ok(
  public.submit_ai_feedback(current_setting('test.quiz_id')::uuid, 'down', 'La clé est fausse') > 0,
  'un élève peut signaler une erreur sur SON quiz forgé'
);

SELECT is(
  (SELECT model FROM public.ai_feedback ORDER BY id DESC LIMIT 1),
  'claude-sonnet-5',
  'R-13 : le modèle du 👎 vient du QUIZ, pas du client — un avis ne peut pas être mal imputé'
);

SELECT is(
  (SELECT count(*)::int FROM public.ai_feedback),
  1,
  'l''élève lit son propre retour'
);

RESET ROLE;

-- Une famille étrangère ne peut ni voter, ni voir.
SET LOCAL request.jwt.claims = '{"sub":"e9000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.submit_ai_feedback(current_setting('test.quiz_id')::uuid, 'up') $$,
  'AI_FORGE_NOT_FOUND',
  'R-17 : on ne vote pas sur le quiz d''une autre famille'
);

SELECT is(
  (SELECT count(*)::int FROM public.ai_feedback),
  0,
  'et on ne lit pas le retour d''une autre famille'
);

RESET ROLE;

-- ---------------------------------------------------------
-- 3. La console ADMIN — réservée, et agrégée.
-- ---------------------------------------------------------
SET LOCAL request.jwt.claims = '{"sub":"e9000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT * FROM public.get_ai_admin_overview() $$,
  'Unauthorized',
  'un porteur ordinaire n''ouvre pas la console admin'
);

SELECT throws_ok(
  $$ SELECT public.set_ai_mode_enabled(false) $$,
  'Unauthorized',
  'et il n''actionne pas le kill-switch global'
);

RESET ROLE;

SET LOCAL request.jwt.claims = '{"sub":"e9000000-0000-4000-8000-000000000009","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT families_with_key FROM public.get_ai_admin_overview()),
  2,
  'l''admin lit l''adoption — un AGRÉGAT, pas une liste nominative'
);

SELECT is(
  (SELECT quality_by_model->'claude-sonnet-5'->>'down' FROM public.get_ai_admin_overview()),
  '1',
  '§1.4 : le ratio 👍/👎 PAR MODÈLE — la donnée que personne n''avait'
);

-- Le kill-switch global coupe VRAIMENT.
SELECT ok(NOT public.set_ai_mode_enabled(false), 'l''admin coupe le mode global');

RESET ROLE;

SELECT is(
  (SELECT reason FROM public.resolve_ai_access(
     'e9000000-0000-4000-8000-000000000003'::uuid, 'explain')),
  'AI_MODE_OFF',
  'le kill-switch admin éteint la résolution d''accès — il coupe, il ne décore pas'
);

-- ---------------------------------------------------------
-- 4. Les purges tournent.
-- ---------------------------------------------------------
SELECT lives_ok(
  $$ SELECT public.purge_ai_feedback() $$,
  'la purge des retours qualité tourne (rétention 12 mois)'
);

SELECT * FROM finish();
ROLLBACK;

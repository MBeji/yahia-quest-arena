-- =========================================================
-- é11 R-15 — l'énergie d'un appel IA tué par la plateforme est rendue.
-- ---------------------------------------------------------
-- Migration 20261026100000. Avant elle, `sweep_ai_reservations()` remettait à
-- zéro l'ARGENT réservé d'un appel mort, jamais l'ÉNERGIE : une fonction tuée
-- par `maxDuration` coûtait à l'élève une unité pour la journée.
--
-- Trois issues pour une réservation, une assertion par issue :
--   succès (settle_ai_energy)  → l'énergie reste dépensée, le balayage n'y touche pas ;
--   panne connue (release_*)   → l'énergie est rendue tout de suite ;
--   appel tué (aucun des deux) → le balayage la rend après 5 minutes, pas avant.
-- Les deux chemins (plateforme et famille) marquent l'énergie « en vol ».
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(14);

-- Décor : un élève plateforme, et une famille (porteur + enfant lié, activé).
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('e5000000-0000-4000-8000-000000000001', 'aes-eleve@test.local', 'x', now(),
   '{"display_name":"Plateforme"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e5000000-0000-4000-8000-000000000002', 'aes-parent@test.local', 'x', now(),
   '{"display_name":"Parent"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e5000000-0000-4000-8000-000000000003', 'aes-enfant@test.local', 'x', now(),
   '{"display_name":"Enfant"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000');

SELECT public.set_ai_credential(
  'e5000000-0000-4000-8000-000000000002'::uuid, 'anthropic', NULL,
  'm-fast', 'm-rich', '\x00112233445566778899aabbccddeeff'::bytea, 1::smallint,
  'fp-aes', 'zzzz', 2, 20, '2026-10-26');

INSERT INTO public.ai_student_access (student_user_id, owner_user_id, enabled, daily_energy_max)
VALUES ('e5000000-0000-4000-8000-000000000003'::uuid,
        'e5000000-0000-4000-8000-000000000002'::uuid, true, 10);

-- =========================================================
-- 1. La réservation marque l'énergie « en vol », sur les deux chemins.
-- =========================================================
SELECT is(
  (SELECT granted FROM public.reserve_platform_spend(
     'e5000000-0000-4000-8000-000000000001'::uuid, 0::BIGINT, 2, 1000000::BIGINT)),
  true,
  'décor : la réservation plateforme passe'
);

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  '(2,2)',
  'plateforme : l''énergie réservée est dépensée ET en vol'
);

SELECT is(
  (SELECT granted FROM public.reserve_ai_spend(
     'e5000000-0000-4000-8000-000000000002'::uuid,
     'e5000000-0000-4000-8000-000000000003'::uuid, 0::BIGINT, 3)),
  true,
  'décor : la réservation famille passe'
);

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000003'::uuid
      AND day = CURRENT_DATE),
  '(3,3)',
  'famille : l''énergie réservée est dépensée ET en vol'
);

-- =========================================================
-- 2. Succès : solder sort l'énergie du vol, sans la rendre.
-- =========================================================
SELECT lives_ok(
  $$SELECT public.settle_ai_energy('e5000000-0000-4000-8000-000000000001'::uuid, 1)$$,
  'settle_ai_energy solde une unité'
);

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  '(2,1)',
  'succès : l''unité soldée reste dépensée, une seule reste en vol'
);

-- =========================================================
-- 3. Panne connue : la libération rend l'énergie ET la sort du vol.
-- =========================================================
SELECT lives_ok(
  $$SELECT public.release_ai_reservation(
      'e5000000-0000-4000-8000-000000000002'::uuid,
      'e5000000-0000-4000-8000-000000000003'::uuid, 0::BIGINT, 1)$$,
  'release_ai_reservation rend une unité'
);

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000003'::uuid
      AND day = CURRENT_DATE),
  '(2,2)',
  'panne connue : l''unité libérée n''est ni dépensée ni en vol'
);

-- =========================================================
-- 4. Appel tué : le balayage attend 5 minutes, puis rend ce qui est en vol.
-- =========================================================
SELECT public.sweep_ai_reservations();

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  '(2,1)',
  'le balayage ne touche pas une réservation de moins de 5 minutes — l''appel peut être encore en vol'
);

UPDATE public.ai_energy_ledger
   SET updated_at = now() - INTERVAL '6 minutes'
 WHERE student_user_id IN ('e5000000-0000-4000-8000-000000000001'::uuid,
                           'e5000000-0000-4000-8000-000000000003'::uuid);

SELECT public.sweep_ai_reservations();

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  '(1,0)',
  'R-15 (plateforme) : l''unité d''un appel tué est rendue, l''unité soldée reste dépensée'
);

SELECT is(
  (SELECT row(spent, reserved)::TEXT FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000003'::uuid
      AND day = CURRENT_DATE),
  '(0,0)',
  'R-15 (famille) : les unités d''appels tués sont rendues'
);

SELECT public.sweep_ai_reservations();

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'e5000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  1,
  'un second balayage ne rend rien de plus : l''énergie soldée n''est jamais remboursée'
);

-- =========================================================
-- 5. Privilèges : solder est un geste du serveur, jamais d'un client.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('authenticated', 'public.settle_ai_energy(uuid, integer)', 'EXECUTE'),
  'settle_ai_energy n''est PAS appelable par un élève'
);

SELECT ok(
  NOT has_function_privilege('anon', 'public.settle_ai_energy(uuid, integer)', 'EXECUTE'),
  'settle_ai_energy n''est PAS appelable par anon'
);

SELECT * FROM finish();
ROLLBACK;

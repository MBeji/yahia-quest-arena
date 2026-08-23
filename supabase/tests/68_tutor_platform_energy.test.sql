-- =========================================================
-- Étude 11 — R-12 (énergie) et R-13 (budget plateforme).
-- ---------------------------------------------------------
-- Ce fichier teste UNE affirmation, sous plusieurs angles : sur le chemin
-- plateforme, le dépassement est IMPOSSIBLE, pas signalé (Q-3).
--
-- L'affirmation valait d'être testée parce qu'elle était fausse jusqu'ici.
-- `callOnPlatform()` appelait le fournisseur sans rien réserver ; poser
-- `ANTHROPIC_API_KEY` en production aurait donné un tuteur illimité, à nos
-- frais, à chaque élève sans clé de famille — puisque `resolve_ai_access`
-- renvoie `payer = 'platform'` pour tous ceux-là.
--
-- L'ASSERTION LA PLUS IMPORTANTE est celle de la section 1.3 : un refus de
-- budget ne doit RIEN écrire dans le grand livre. Un refus qui compte quand même
-- ferait dériver le total du jour à chaque tentative, et fermerait le tuteur
-- pour tout le monde bien avant le vrai plafond.
--
-- Plus la recharge par indice (R-12 / D-9) et son invariant anti-gaspillage,
-- hérité de `consume_hint` : on ne prend jamais une charge qui ne servirait à rien.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(27);

-- ---------------------------------------------------------
-- Décor : un élève « plateforme » avec un indice en poche, un élève sans rien,
-- et une famille (porteur + enfant lié) pour vérifier que la recharge profite
-- AUSSI au chemin BYOK.
-- ---------------------------------------------------------
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at,
                        raw_user_meta_data, created_at, updated_at,
                        aud, role, instance_id)
VALUES
  ('e1000000-0000-4000-8000-000000000001', 'tpe-eleve@test.local', 'x', now(),
   '{"display_name":"Plateforme"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e1000000-0000-4000-8000-000000000002', 'tpe-sans-item@test.local', 'x', now(),
   '{"display_name":"SansItem"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e1000000-0000-4000-8000-000000000003', 'tpe-parent@test.local', 'x', now(),
   '{"display_name":"Parent"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000'),
  ('e1000000-0000-4000-8000-000000000004', 'tpe-enfant@test.local', 'x', now(),
   '{"display_name":"Enfant"}'::jsonb, now(), now(),
   'authenticated', 'authenticated', '00000000-0000-0000-0000-000000000000');

INSERT INTO public.shop_items (id, code, name, item_type, price_coins, effect_payload)
VALUES ('e1000000-0000-4000-8000-0000000000f1'::uuid, 'tpe_booster_hint', 'Indice TPE',
        'booster', 50, '{"hints":3}'::jsonb);

INSERT INTO public.inventory_items (student_user_id, shop_item_id, quantity)
VALUES ('e1000000-0000-4000-8000-000000000001'::uuid,
        'e1000000-0000-4000-8000-0000000000f1'::uuid, 2);

-- =========================================================
-- 1. R-13 — le budget plateforme coupe DANS le chemin de requête.
-- =========================================================
-- Budget du jour : 1 $ (1 000 000 micro-dollars). Deux appels à 600 000 : le
-- premier passe, le second dépasse.

SELECT is(
  (SELECT granted FROM public.reserve_platform_spend(
     'e1000000-0000-4000-8000-000000000001'::uuid, 600000::BIGINT, 1, 1000000::BIGINT)),
  true,
  'R-13 : sous le plafond du jour, la réservation est accordée'
);

SELECT is(
  (SELECT reserved_micros FROM public.ai_platform_ledger WHERE day = CURRENT_DATE),
  600000::BIGINT,
  'R-13 : la réservation est ÉCRITE avant l''appel (D-8), pas après'
);

SELECT is(
  (SELECT reason FROM public.reserve_platform_spend(
     'e1000000-0000-4000-8000-000000000001'::uuid, 600000::BIGINT, 1, 1000000::BIGINT)),
  'AI_BUDGET_REACHED',
  'R-13 : le second appel dépasse le plafond du jour et est refusé'
);

-- ⚠️ L'assertion qui compte. Un refus qui compterait quand même ferait dériver
-- le total à chaque tentative et fermerait le tuteur bien avant le vrai plafond.
SELECT is(
  (SELECT reserved_micros FROM public.ai_platform_ledger WHERE day = CURRENT_DATE),
  600000::BIGINT,
  'R-13 : un refus n''écrit RIEN — le grand livre est inchangé'
);

SELECT lives_ok(
  $$SELECT public.settle_platform_spend(600000::BIGINT, 250000::BIGINT)$$,
  'le solde réel remplace la réservation'
);

SELECT is(
  (SELECT reserved_micros || '/' || spent_micros FROM public.ai_platform_ledger
    WHERE day = CURRENT_DATE),
  '0/250000',
  'R-13 : après solde, la réservation est libérée et le RÉEL est compté'
);

-- Le total du jour = réservé + dépensé : un appel qui ferait franchir 1 $ en
-- comptant le déjà-dépensé doit être refusé.
SELECT is(
  (SELECT reason FROM public.reserve_platform_spend(
     'e1000000-0000-4000-8000-000000000001'::uuid, 800000::BIGINT, 0, 1000000::BIGINT)),
  'AI_BUDGET_REACHED',
  'R-13 : le plafond porte sur réservé + DÉPENSÉ, pas sur la seule réservation'
);

-- =========================================================
-- 2. R-12 — l'énergie de l'élève, sur un chemin sans ligne d'activation.
-- =========================================================
-- L'élève a déjà consommé 1 (section 1). Son plafond de base est celui de
-- l'étude : 10.

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'e1000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  1,
  'R-12 : l''énergie est décomptée dans la MÊME transaction que l''argent'
);

SELECT is(
  (SELECT granted FROM public.reserve_platform_spend(
     'e1000000-0000-4000-8000-000000000001'::uuid, 0::BIGINT, 9, 1000000::BIGINT)),
  true,
  'R-12 : les 10 unités du jour sont dépensables (1 + 9)'
);

SELECT is(
  (SELECT reason FROM public.reserve_platform_spend(
     'e1000000-0000-4000-8000-000000000001'::uuid, 0::BIGINT, 1, 1000000::BIGINT)),
  'AI_ENERGY_SPENT',
  'R-12 : la onzième unité est refusée — le plafond est un plafond'
);

SELECT lives_ok(
  $$SELECT public.release_platform_reservation(
      'e1000000-0000-4000-8000-000000000001'::uuid, 0::BIGINT, 1)$$,
  'la libération d''une réservation rend son énergie'
);

SELECT is(
  (SELECT spent FROM public.ai_energy_ledger
    WHERE student_user_id = 'e1000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  9,
  'R-15 : un élève ne paie pas en énergie une panne de fournisseur'
);

-- =========================================================
-- 3. R-12 / D-9 — la recharge par indice.
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e1000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.recharge_tutor_energy())->>'consumed',
  'true',
  'D-9 : consommer un indice de l''inventaire recharge l''énergie'
);

RESET ROLE;

SELECT is(
  (SELECT bonus FROM public.ai_energy_ledger
    WHERE student_user_id = 'e1000000-0000-4000-8000-000000000001'::uuid
      AND day = CURRENT_DATE),
  3,
  'R-12 : la recharge vaut +3 (TUTOR_ENERGY_PER_HINT)'
);

SELECT is(
  (SELECT quantity FROM public.inventory_items
    WHERE student_user_id = 'e1000000-0000-4000-8000-000000000001'::uuid),
  1,
  'D-9 : exactement UNE charge est consommée, comme dans consume_hint'
);

-- Le plafond du jour est passé de 10 à 13 : la onzième unité, refusée plus haut,
-- passe maintenant.
SELECT is(
  (SELECT granted FROM public.reserve_platform_spend(
     'e1000000-0000-4000-8000-000000000001'::uuid, 0::BIGINT, 1, 1000000::BIGINT)),
  true,
  'R-12 : la recharge relève le plafond du JOUR, et l''appel repart'
);

-- Sans charge en poche : rien n'est consommé, et l'élève l'apprend.
SET LOCAL request.jwt.claims = '{"sub":"e1000000-0000-4000-8000-000000000002","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.recharge_tutor_energy())->>'reason',
  'NO_ITEM',
  'D-9 : sans charge d''indice, la recharge ne fait rien et le dit'
);

RESET ROLE;

-- Déjà au plafond DUR : la charge ne servirait à rien, on ne la prend pas.
-- C'est l'invariant anti-gaspillage de `consume_hint` (« si rien à révéler, on
-- ne dépense rien »), transposé à l'énergie.
UPDATE public.ai_energy_ledger SET bonus = 20
 WHERE student_user_id = 'e1000000-0000-4000-8000-000000000001'::uuid
   AND day = CURRENT_DATE;

SET LOCAL request.jwt.claims = '{"sub":"e1000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.recharge_tutor_energy())->>'reason',
  'AT_CAP',
  'R-12 : au plafond dur, la recharge est refusée…'
);

RESET ROLE;

SELECT is(
  (SELECT quantity FROM public.inventory_items
    WHERE student_user_id = 'e1000000-0000-4000-8000-000000000001'::uuid),
  1,
  '…et surtout : l''indice n''est PAS consommé pour rien'
);

-- =========================================================
-- 4. L'état d'énergie rendu à l'écran (lot 7).
-- =========================================================
SET LOCAL request.jwt.claims = '{"sub":"e1000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.get_tutor_energy())->>'max',
  '30',
  'get_tutor_energy : le plafond affiché ne dépasse jamais le plafond dur'
);

SELECT is(
  (public.get_tutor_energy())->>'canRecharge',
  'false',
  'get_tutor_energy : au plafond dur, l''écran sait qu''une recharge serait vaine'
);

RESET ROLE;

-- =========================================================
-- 5. La recharge profite AUSSI au chemin famille (révision vivante).
-- =========================================================
-- Sans la substitution dans `resolve_ai_access`, un enfant dont les parents ont
-- branché leur clé paierait un indice pour rien.
INSERT INTO public.parent_student_links (parent_user_id, student_user_id, is_active)
VALUES ('e1000000-0000-4000-8000-000000000003'::uuid,
        'e1000000-0000-4000-8000-000000000004'::uuid, true);

SELECT public.set_ai_credential(
  'e1000000-0000-4000-8000-000000000003'::uuid, 'anthropic', NULL,
  'm-fast', 'm-rich', '\x00112233445566778899aabbccddeeff'::bytea, 1::smallint,
  'fp-tpe', 'zzzz', 2, 20, '2026-08-22');

INSERT INTO public.ai_student_access (student_user_id, owner_user_id, enabled, features, daily_energy_max)
VALUES ('e1000000-0000-4000-8000-000000000004'::uuid,
        'e1000000-0000-4000-8000-000000000003'::uuid, true, ARRAY['explain'], 10);

INSERT INTO public.ai_energy_ledger (student_user_id, day, spent, bonus)
VALUES ('e1000000-0000-4000-8000-000000000004'::uuid, CURRENT_DATE, 10, 3);

SELECT is(
  (SELECT energy_left FROM public.resolve_ai_access(
     'e1000000-0000-4000-8000-000000000004'::uuid, 'explain')),
  3,
  'R-12 : côté famille aussi, l''énergie restante compte les recharges'
);

-- =========================================================
-- 6. Droits d'exécution — la comptabilité n'est pas une API cliente.
-- =========================================================
SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.reserve_platform_spend(uuid, bigint, integer, bigint)', 'EXECUTE'),
  'reserve_platform_spend n''est PAS appelable par un client — c''est notre facture'
);

SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.settle_platform_spend(bigint, bigint)', 'EXECUTE'),
  'settle_platform_spend n''est PAS appelable par un client'
);

SELECT ok(
  NOT has_function_privilege('authenticated',
    'public.release_platform_reservation(uuid, bigint, integer)', 'EXECUTE'),
  'release_platform_reservation n''est PAS appelable par un client'
);

SELECT ok(
  has_function_privilege('authenticated', 'public.recharge_tutor_energy()', 'EXECUTE'),
  'recharge_tutor_energy, elle, est un GESTE de l''élève'
);

SET LOCAL request.jwt.claims = '{"sub":"e1000000-0000-4000-8000-000000000001","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (SELECT count(*) FROM public.ai_platform_ledger)::INT,
  0,
  'R-14 : aucun élève ne lit la facture de la plateforme'
);

RESET ROLE;

SELECT * FROM finish();
ROLLBACK;

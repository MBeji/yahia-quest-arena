-- =========================================================
-- Shop & consumables journey — buy → arm → consume, all as `authenticated`.
-- ---------------------------------------------------------
-- End-to-end DB-level coverage of the virtual-economy user journey:
--   1. purchase_shop_item deducts coins atomically and credits the inventory;
--      an insufficient balance is rejected (no free items).
--   2. activate_inventory_item arms a multiplier potion (is_active).
--   3. submit_exercise_attempt APPLIES the armed xpMultiplier (doubled XP),
--      reports it, and CONSUMES the potion (row gone at quantity 0).
--   4. consume_hint reveals a question's explanation, spends EXACTLY one
--      charge, and never spends one when there is nothing to reveal
--      (anti-waste invariant).
-- Mocked JS tests stub supabase.rpc, so only this file executes the real SQL.
-- =========================================================

BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap;
SELECT plan(14);

-- ---------------------------------------------------------
-- Fixtures (superuser): isolated theme (no parcours mapping → no premium gate),
-- one 5-question exercise (xp 100), two students, two catalogue items.
-- ---------------------------------------------------------
INSERT INTO public.themes (id, name_fr, icon, color_token, has_grades, display_order)
VALUES ('shop-test-theme', 'Shop Test', 'Brain', 'subject-math', false, 998);

INSERT INTO public.subjects (id, name_fr, attribute, color_token, icon, theme_id)
VALUES ('shop-subj', 'Shop Subject', 'Esprit', 'subject-math', 'Brain', 'shop-test-theme');

INSERT INTO public.chapters (id, subject_id, title)
VALUES ('d1000000-0000-0000-0000-000000000001', 'shop-subj', 'Shop Chapter');

INSERT INTO public.exercises (id, chapter_id, subject_id, title, xp_reward, reward_coins, mode)
VALUES ('d2000000-0000-0000-0000-000000000001',
        'd1000000-0000-0000-0000-000000000001', 'shop-subj',
        'Shop Exercise', 100, 20, 'practice');

-- 5 QCM questions, correct 'a'. Q1 carries an explanation (the hint source);
-- Q2 deliberately has none (anti-waste case).
INSERT INTO public.questions (id, exercise_id, prompt, options, correct_option, explanation, display_order)
SELECT
  ('d3000000-0000-0000-0000-00000000000' || g)::uuid,
  'd2000000-0000-0000-0000-000000000001',
  'Q' || g,
  '[{"id":"a","text":"right"},{"id":"b","text":"wrong"}]'::jsonb,
  'a',
  CASE WHEN g = 1 THEN 'Indice : pense à la réponse a.' ELSE NULL END,
  g
FROM generate_series(1, 5) AS g;

INSERT INTO auth.users (id, email) VALUES
  ('d4444444-4444-4444-4444-444444444444', 'shop-buyer@test.local'),
  ('d5555555-5555-5555-5555-555555555555', 'shop-broke@test.local');
UPDATE public.profiles SET yahia_coins = 500
 WHERE id = 'd4444444-4444-4444-4444-444444444444';

INSERT INTO public.shop_items (id, code, name, description, price_coins, item_type, effect_payload)
VALUES
  ('d6000000-0000-0000-0000-000000000001', 'potion_xp_pgtap', 'Potion XP x2',
   'double le prochain gain d''XP', 100, 'potion', '{"xpMultiplier":2}'::jsonb),
  ('d6000000-0000-0000-0000-000000000002', 'hint_pack_pgtap', 'Pack d''indices',
   'révèle des indices', 50, 'booster', '{"hints":2}'::jsonb)
ON CONFLICT (code) DO NOTHING;

-- ---------------------------------------------------------
-- 1) Purchase journey (as the buyer).
-- ---------------------------------------------------------
SET LOCAL "request.jwt.claims" = '{"sub":"d4444444-4444-4444-4444-444444444444","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT lives_ok(
  $$ SELECT public.purchase_shop_item('potion_xp_pgtap') $$,
  'purchase: a student with enough coins buys the potion'
);

SELECT is(
  (SELECT yahia_coins FROM public.profiles
    WHERE id = 'd4444444-4444-4444-4444-444444444444'),
  400,
  'purchase: the price (100) is deducted from the balance (500 → 400)'
);

SELECT is(
  (SELECT quantity FROM public.inventory_items
    WHERE student_user_id = 'd4444444-4444-4444-4444-444444444444'
      AND shop_item_id = 'd6000000-0000-0000-0000-000000000001'),
  1,
  'purchase: the potion lands in the inventory (quantity 1)'
);

RESET ROLE;
SET LOCAL "request.jwt.claims" = '{"sub":"d5555555-5555-5555-5555-555555555555","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT throws_ok(
  $$ SELECT public.purchase_shop_item('potion_xp_pgtap') $$,
  NULL, NULL,
  'purchase: an insufficient balance (0 coins) is rejected'
);

-- ---------------------------------------------------------
-- 2) Arm the potion, 3) play a quest: XP doubled, potion consumed.
-- ---------------------------------------------------------
RESET ROLE;
INSERT INTO public.exercise_sessions (id, user_id, exercise_id, started_at)
VALUES ('d7000000-0000-0000-0000-000000000001',
        'd4444444-4444-4444-4444-444444444444',
        'd2000000-0000-0000-0000-000000000001',
        clock_timestamp() - INTERVAL '120 seconds');  -- clears the 5*4s anti-rush gate

SET LOCAL "request.jwt.claims" = '{"sub":"d4444444-4444-4444-4444-444444444444","role":"authenticated"}';
SET LOCAL ROLE authenticated;

SELECT is(
  (public.activate_inventory_item('potion_xp_pgtap') ->> 'is_active')::boolean,
  true,
  'arm: activate_inventory_item arms the potion'
);

SELECT is(
  (SELECT is_active FROM public.inventory_items
    WHERE student_user_id = 'd4444444-4444-4444-4444-444444444444'
      AND shop_item_id = 'd6000000-0000-0000-0000-000000000001'),
  true,
  'arm: the inventory row is flagged active (next-quest slot)'
);

SELECT set_config(
  'test.submit_result',
  public.submit_exercise_attempt(
    'd7000000-0000-0000-0000-000000000001',
    'd2000000-0000-0000-0000-000000000001',
    '[{"questionId":"d3000000-0000-0000-0000-000000000001","choice":"a"},
      {"questionId":"d3000000-0000-0000-0000-000000000002","choice":"a"},
      {"questionId":"d3000000-0000-0000-0000-000000000003","choice":"a"},
      {"questionId":"d3000000-0000-0000-0000-000000000004","choice":"a"},
      {"questionId":"d3000000-0000-0000-0000-000000000005","choice":"a"}]'::jsonb
  )::text,
  true
);

SELECT is(
  (current_setting('test.submit_result')::jsonb ->> 'xpEarned')::int,
  200,
  'potion: a perfect run earns DOUBLED XP (100 × xpMultiplier 2 = 200)'
);

SELECT ok(
  current_setting('test.submit_result')::jsonb ? 'potionApplied',
  'potion: the response reports the applied potion (potionApplied)'
);

SELECT is_empty(
  $$ SELECT 1 FROM public.inventory_items
      WHERE student_user_id = 'd4444444-4444-4444-4444-444444444444'
        AND shop_item_id = 'd6000000-0000-0000-0000-000000000001' $$,
  'potion: the consumed potion is removed from the inventory (quantity 0)'
);

-- ---------------------------------------------------------
-- 4) Hints: one charge per reveal, never spent for nothing.
-- ---------------------------------------------------------
SELECT lives_ok(
  $$ SELECT public.purchase_shop_item('hint_pack_pgtap') $$,
  'hints: the student buys the hint pack'
);

SELECT set_config(
  'test.hint_qty_before',
  (SELECT quantity::text FROM public.inventory_items
    WHERE student_user_id = 'd4444444-4444-4444-4444-444444444444'
      AND shop_item_id = 'd6000000-0000-0000-0000-000000000002'),
  true
);

SELECT is(
  (public.consume_hint('d3000000-0000-0000-0000-000000000001') ->> 'consumed')::boolean,
  true,
  'hints: revealing an existing explanation consumes a charge'
);

SELECT is(
  (SELECT quantity FROM public.inventory_items
    WHERE student_user_id = 'd4444444-4444-4444-4444-444444444444'
      AND shop_item_id = 'd6000000-0000-0000-0000-000000000002'),
  current_setting('test.hint_qty_before')::int - 1,
  'hints: exactly ONE charge is decremented per reveal'
);

SELECT is(
  (public.consume_hint('d3000000-0000-0000-0000-000000000002') ->> 'consumed')::boolean,
  false,
  'hints: a question WITHOUT an explanation spends NO charge (anti-waste)'
);

SELECT is(
  (SELECT quantity FROM public.inventory_items
    WHERE student_user_id = 'd4444444-4444-4444-4444-444444444444'
      AND shop_item_id = 'd6000000-0000-0000-0000-000000000002'),
  current_setting('test.hint_qty_before')::int - 1,
  'hints: the balance is untouched after the no-op reveal'
);

RESET ROLE;
SELECT * FROM finish();
ROLLBACK;

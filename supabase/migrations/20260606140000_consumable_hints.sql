-- =========================================================
-- Consumable hints: reveal-a-hint booster & rappel potion (step 3)
-- ---------------------------------------------------------
-- Builds on step 1 (20260606120000 potions) and step 2 (20260606130000 shields).
-- This migration makes the two HINT consumables actually do something:
--
--   * Indice Mystique (item_type 'booster', effect {"hints":3}, code booster_hint):
--       "Révèle un indice sur une question difficile".
--   * Potion de Rappel (item_type 'potion', effect {"hintBoost":1}, code potion_rappel):
--       "Accorde un indice sur une question difficile".
--
-- Model: NOT armed, NOT applied at submit time. These are consumed ON DEMAND
-- during a quest, one reveal per click of the per-question "Indice" button. Each
-- owned unit (the inventory `quantity`, NOT the payload number) = one reveal,
-- decremented on use. They do NOT participate in the arm/slot system at all —
-- submit_exercise_attempt and activate_inventory_item are left completely untouched.
--
-- The consume_hint RPC:
--   * validates the caller owns a hint consumable with quantity >= 1
--     (item_type IN ('booster','potion') whose effect_payload ? 'hints' OR ? 'hintBoost'),
--   * picks the OLDEST/cheapest such row first (acquired_at ASC) for consistency,
--   * locks that inventory row FOR UPDATE, decrements quantity by 1, deletes at 0,
--   * sources the hint text from the question's `explanation` column,
--   * returns a graceful fallback when the explanation is NULL/empty (no column added).
--
-- Hints are purely informational: they grant NO XP/coins and do not touch scoring,
-- the tooFast/>=60%/improved gates, or the arm/slot system.
--
-- Idempotent: CREATE OR REPLACE FUNCTION + the standard REVOKE/GRANT pattern.
-- No new column is needed (we reuse questions.explanation).
-- =========================================================

CREATE OR REPLACE FUNCTION public.consume_hint(p_question_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_inv_id uuid;
  v_item_code text;
  v_item_name text;
  v_explanation text;
  v_hint text;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;
  IF p_question_id IS NULL THEN RAISE EXCEPTION 'Question is required.'; END IF;

  -- The question must exist; read its explanation (the hint source).
  SELECT explanation
    INTO v_explanation
    FROM public.questions
    WHERE id = p_question_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Question not found.'; END IF;

  -- Pick the user's oldest/cheapest hint consumable with at least one charge and
  -- lock ONLY that inventory row (never the shared shop_items catalog) so two
  -- concurrent reveals can't both decrement the same unit: the second blocks
  -- here, then re-checks. Charge count = inventory.quantity (one reveal each).
  SELECT inv.id, si.code, si.name
    INTO v_inv_id, v_item_code, v_item_name
    FROM public.inventory_items inv
    JOIN public.shop_items si ON si.id = inv.shop_item_id
    WHERE inv.student_user_id = v_user
      AND inv.quantity >= 1
      AND si.item_type IN ('booster', 'potion')
      AND (si.effect_payload ? 'hints' OR si.effect_payload ? 'hintBoost')
    ORDER BY inv.acquired_at ASC
    LIMIT 1
    FOR UPDATE OF inv;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No hint charge available.';
  END IF;

  -- Consume one charge: -1 quantity, delete the row at 0.
  UPDATE public.inventory_items
    SET quantity = quantity - 1
    WHERE id = v_inv_id;
  DELETE FROM public.inventory_items
    WHERE id = v_inv_id AND quantity <= 0;

  -- Hint source = the question's explanation. Graceful fallback when it is
  -- NULL/empty so a charge is never spent for nothing: a generic "no hint
  -- available" message (kept simple, no eliminate-option machinery).
  v_hint := NULLIF(btrim(COALESCE(v_explanation, '')), '');

  RETURN jsonb_build_object(
    'questionId', p_question_id,
    'hint', v_hint,
    'itemCode', v_item_code,
    'itemName', v_item_name
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.consume_hint(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.consume_hint(uuid) TO authenticated;

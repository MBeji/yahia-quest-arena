-- =========================================================
-- Reward integrity fixes (C1 remediation: GAP-014 + GAP-012)
-- ---------------------------------------------------------
-- Two gameplay-economy correctness bugs found in the functional audit:
--
--   GAP-014 — a paid "x3" hint pack delivered only ONE charge. purchase_shop_item
--     always granted inventory quantity = 1 and ignored the item's advertised charge
--     count in effect_payload ({"hints":3} / {"hintBoost":1}). Since consume_hint
--     treats each inventory unit as one reveal, the player got 1 reveal for a 3-pack.
--     Fix: grant quantity = the payload's charge count (default 1 for everything else).
--
--   GAP-012 — daily-objective / weekly-quest rewards were never credited. The goal's
--     status flipped to 'completed' but its xp_reward / coin_reward were never paid,
--     so the UI's "+50 XP" promise was a lie. Fix: an AFTER UPDATE trigger credits the
--     advertised reward exactly once, on the transition into 'completed', via the
--     existing award_xp / award_coins RPCs.
--
-- Both changes are ADDITIVE / behaviour-only: no signature change, no new RPC the app
-- must call, no revoke. There is NO deploy-order constraint — apply this migration and
-- deploy the C1 code in any order. Idempotent (CREATE OR REPLACE + DROP/CREATE TRIGGER).
-- =========================================================

-- ----- GAP-014: grant the advertised number of charges on purchase -----
CREATE OR REPLACE FUNCTION public.purchase_shop_item(p_item_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_item public.shop_items%ROWTYPE;
  v_existing_id uuid;
  v_remaining int;
  v_units int;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT * INTO v_item FROM public.shop_items
    WHERE code = p_item_code AND is_active = true;
  IF NOT FOUND THEN RAISE EXCEPTION 'Item not available.'; END IF;

  SELECT id INTO v_existing_id FROM public.inventory_items
    WHERE student_user_id = v_user AND shop_item_id = v_item.id;

  IF v_item.item_type = 'skin' AND v_existing_id IS NOT NULL THEN
    RAISE EXCEPTION 'This skin is already in your inventory.';
  END IF;

  -- Charges granted per purchase. Hint consumables advertise their charge count in
  -- the effect payload ({"hints":3} = 3 reveals, {"hintBoost":1} = 1) and each
  -- inventory unit = one reveal (consume_hint decrements quantity). Everything else
  -- grants a single unit. (GAP-014: the payload count used to be ignored.)
  v_units := GREATEST(1, COALESCE(
    NULLIF(v_item.effect_payload ->> 'hints', '')::int,
    NULLIF(v_item.effect_payload ->> 'hintBoost', '')::int,
    1
  ));

  -- Race-safe deduction: only succeeds if the balance is sufficient.
  UPDATE public.profiles
    SET yahia_coins = yahia_coins - v_item.price_coins
    WHERE id = v_user AND yahia_coins >= v_item.price_coins
    RETURNING yahia_coins INTO v_remaining;
  IF v_remaining IS NULL THEN RAISE EXCEPTION 'Insufficient XP Coins.'; END IF;

  IF v_existing_id IS NOT NULL THEN
    UPDATE public.inventory_items SET quantity = quantity + v_units WHERE id = v_existing_id;
  ELSE
    INSERT INTO public.inventory_items (student_user_id, shop_item_id, quantity, is_equipped)
      VALUES (v_user, v_item.id, v_units, false);
  END IF;

  RETURN jsonb_build_object(
    'item_code', v_item.code,
    'remaining_coins', v_remaining,
    'purchased_item_name', v_item.name
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purchase_shop_item(text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.purchase_shop_item(text) TO authenticated;

-- ----- GAP-012: credit objective / weekly-quest rewards on completion -----
CREATE OR REPLACE FUNCTION public.credit_goal_reward()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- Credit the advertised XP/coins exactly once, when a goal first reaches
  -- 'completed' (enforced by the trigger WHEN clause). award_xp / award_coins are
  -- SECURITY DEFINER and self-guarded; called here (as the function owner) they
  -- credit the goal's owner. award_xp never writes these tables (no recursion) and
  -- is a same-day no-op on the streak (last_active_date is already today during a
  -- study session), so there is no streak inflation.
  IF COALESCE(NEW.xp_reward, 0) > 0 THEN
    PERFORM public.award_xp(NEW.user_id, NEW.xp_reward);
  END IF;
  IF COALESCE(NEW.coin_reward, 0) > 0 THEN
    PERFORM public.award_coins(NEW.user_id, NEW.coin_reward);
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_credit_daily_objective_reward ON public.daily_objectives;
CREATE TRIGGER trg_credit_daily_objective_reward
  AFTER UPDATE ON public.daily_objectives
  FOR EACH ROW
  WHEN (NEW.status = 'completed' AND OLD.status IS DISTINCT FROM 'completed')
  EXECUTE FUNCTION public.credit_goal_reward();

DROP TRIGGER IF EXISTS trg_credit_weekly_quest_reward ON public.weekly_quests;
CREATE TRIGGER trg_credit_weekly_quest_reward
  AFTER UPDATE ON public.weekly_quests
  FOR EACH ROW
  WHEN (NEW.status = 'completed' AND OLD.status IS DISTINCT FROM 'completed')
  EXECUTE FUNCTION public.credit_goal_reward();

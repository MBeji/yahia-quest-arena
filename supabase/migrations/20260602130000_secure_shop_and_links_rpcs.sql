-- =========================================================
-- Security hardening (round 2): move shop + family-link writes
-- behind SECURITY DEFINER RPCs and revoke direct client writes.
-- 2026-06-02 review, findings #2 (parent links) and #4 (inventory).
-- =========================================================
-- Before this, a client could INSERT/UPDATE inventory_items directly
-- (grant itself skins/quantity without paying) and INSERT parent_student_links
-- with an arbitrary student_user_id (read another user's report). All such
-- mutations now go through validated, ownership-checked RPCs; direct
-- INSERT/UPDATE is revoked from the authenticated role.

-- ----- Buy a shop item (atomic coin deduction + inventory write) -----
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

  -- Race-safe deduction: only succeeds if the balance is sufficient.
  UPDATE public.profiles
    SET yahia_coins = yahia_coins - v_item.price_coins
    WHERE id = v_user AND yahia_coins >= v_item.price_coins
    RETURNING yahia_coins INTO v_remaining;
  IF v_remaining IS NULL THEN RAISE EXCEPTION 'Insufficient XP Coins.'; END IF;

  IF v_existing_id IS NOT NULL THEN
    UPDATE public.inventory_items SET quantity = quantity + 1 WHERE id = v_existing_id;
  ELSE
    INSERT INTO public.inventory_items (student_user_id, shop_item_id, quantity, is_equipped)
      VALUES (v_user, v_item.id, 1, false);
  END IF;

  RETURN jsonb_build_object(
    'item_code', v_item.code,
    'remaining_coins', v_remaining,
    'purchased_item_name', v_item.name
  );
END;
$$;

-- ----- Equip a skin (single source of truth for is_equipped + avatar) -----
CREATE OR REPLACE FUNCTION public.equip_inventory_skin(p_item_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_inv_id uuid;
  v_item_name text;
  v_item_type text;
  v_effect jsonb;
  v_avatar text;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT inv.id, si.name, si.item_type, si.effect_payload
    INTO v_inv_id, v_item_name, v_item_type, v_effect
    FROM public.inventory_items inv
    JOIN public.shop_items si ON si.id = inv.shop_item_id
    WHERE inv.student_user_id = v_user AND si.code = p_item_code;
  IF v_inv_id IS NULL THEN RAISE EXCEPTION 'Item not found in inventory.'; END IF;
  IF v_item_type <> 'skin' THEN RAISE EXCEPTION 'Only skins can be equipped.'; END IF;

  UPDATE public.inventory_items inv
    SET is_equipped = (inv.id = v_inv_id)
    FROM public.shop_items si
    WHERE inv.shop_item_id = si.id
      AND inv.student_user_id = v_user
      AND si.item_type = 'skin';

  v_avatar := v_effect ->> 'avatarSlug';
  IF v_avatar IS NOT NULL THEN
    UPDATE public.profiles SET avatar_slug = v_avatar WHERE id = v_user;
  END IF;

  RETURN jsonb_build_object(
    'item_code', p_item_code,
    'item_name', v_item_name,
    'avatar_slug', v_avatar
  );
END;
$$;

-- ----- Link a parent to a student via the alliance code (= student UUID) -----
-- The code IS the validation: a caller must know the student's UUID, and must
-- be a parent/admin, and the target must be a student. Direct INSERTs are
-- revoked below so this is the only way to create a link.
CREATE OR REPLACE FUNCTION public.link_student_by_code(p_code text, p_relation text DEFAULT 'parent')
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user uuid := auth.uid();
  v_role text;
  v_hex text;
  v_student uuid;
  v_student_role text;
  v_student_name text;
  v_relation text := COALESCE(NULLIF(btrim(p_relation), ''), 'parent');
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT role INTO v_role FROM public.profiles WHERE id = v_user;
  IF v_role IS NULL OR v_role NOT IN ('parent', 'admin') THEN
    RAISE EXCEPTION 'Parent account required to link a student.';
  END IF;

  v_hex := lower(regexp_replace(p_code, '[^a-fA-F0-9]', '', 'g'));
  IF v_hex !~ '^[0-9a-f]{32}$' THEN
    RAISE EXCEPTION 'Invalid student alliance code.';
  END IF;
  v_student := (
    substr(v_hex, 1, 8) || '-' || substr(v_hex, 9, 4) || '-' || substr(v_hex, 13, 4)
    || '-' || substr(v_hex, 17, 4) || '-' || substr(v_hex, 21, 12)
  )::uuid;

  IF v_student = v_user THEN RAISE EXCEPTION 'You cannot link your own account.'; END IF;

  SELECT role, display_name INTO v_student_role, v_student_name
    FROM public.profiles WHERE id = v_student;
  IF v_student_role IS NULL THEN RAISE EXCEPTION 'Student not found.'; END IF;
  IF v_student_role <> 'student' THEN
    RAISE EXCEPTION 'This code does not belong to a student account.';
  END IF;

  INSERT INTO public.parent_student_links
      (parent_user_id, student_user_id, relation_label, is_active)
    VALUES (v_user, v_student, left(v_relation, 40), true)
    ON CONFLICT (parent_user_id, student_user_id)
    DO UPDATE SET relation_label = EXCLUDED.relation_label, is_active = true;

  RETURN jsonb_build_object(
    'linked', true,
    'student_id', v_student,
    'student_display_name', v_student_name
  );
END;
$$;

-- ----- Permissions: RPCs callable by authenticated; direct writes revoked -----
REVOKE EXECUTE ON FUNCTION public.purchase_shop_item(text) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.equip_inventory_skin(text) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.link_student_by_code(text, text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.purchase_shop_item(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.equip_inventory_skin(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.link_student_by_code(text, text) TO authenticated;

REVOKE INSERT, UPDATE ON public.inventory_items FROM authenticated;
REVOKE INSERT, UPDATE, DELETE ON public.parent_student_links FROM authenticated;

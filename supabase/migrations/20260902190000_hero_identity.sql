-- Étude 31 — lot 7 : L'IDENTITÉ DU HÉROS (US-11, R-22).
--
-- CONSTAT N° 10 : « l'investissement identitaire est PAUVRE ». Six skins-emoji
-- jamais renouvelés, `avatar_tier` calculé à chaque gain d'XP et rendu NULLE
-- PART, une classe de héros stockée en **français non accentué** et affichée
-- telle quelle dans les trois langues, aucun titre, aucun cadre — et des pièces
-- sans puits (é09 mesure le `sink_ratio`).
--
-- CE QUE POSE CETTE MIGRATION
--
-- 1. `hero_class` cesse d'être du français stocké. La base garde un CODE
--    (`novice`, `candidat`, …) et l'affichage passe par l'i18n (R-22). Un élève
--    qui lit l'application en arabe voyait « Guerrier des Equations ».
-- 2. Deux cosmétiques de plus — CADRE et TITRE — avec leur emplacement propre :
--    équiper un cadre ne doit pas déséquiper l'avatar. Ce sont des PUITS de
--    pièces (é09), la seule chose qui manquait à une économie qui ne dépense pas.
--
-- ⚠️ LE `DROP CONSTRAINT` EST UN ÉLARGISSEMENT, pas une destruction : la
-- contrainte de type d'objet passe de quatre valeurs à six. Aucune ligne
-- existante ne devient invalide. Il est livré dans un commit SÉPARÉ du code qui
-- l'utilise, comme la DoD §7 le demande pour tout ce qui touche à une contrainte.

-- ===========================================================================
-- 1. La classe de héros devient un CODE (R-22).
--
--    Les six libellés écrits par `award_xp` — plus le « Novice » du défaut de
--    colonne, qui n'a jamais eu de palier à lui — sont convertis en place. Le
--    mapping est explicite : une conversion par `lower(replace(...))` produirait
--    des codes à rallonge et casserait au premier libellé retouché.
-- ===========================================================================
UPDATE public.profiles SET hero_class = v.code
FROM (VALUES
  ('Novice',                 'novice'),
  ('Candidat Civil',         'candidat'),
  ('Aspirant Academicien',   'aspirant'),
  ('Guerrier des Equations', 'guerrier'),
  ('Maitre des Langues',     'maitre'),
  ('Elite du Concours',      'elite'),
  ('S-Rank Legend',          's_rank')
) AS v(label, code)
WHERE public.profiles.hero_class = v.label;

-- Un libellé inconnu (donnée héritée, import manuel) retombe sur le socle plutôt
-- que de bloquer la contrainte ci-dessous — on ne perd qu'un titre, jamais un compte.
UPDATE public.profiles
   SET hero_class = 'novice'
 WHERE hero_class NOT IN ('novice','candidat','aspirant','guerrier','maitre','elite','s_rank');

ALTER TABLE public.profiles ALTER COLUMN hero_class SET DEFAULT 'novice';

DO $$ BEGIN
  ALTER TABLE public.profiles
    ADD CONSTRAINT profiles_hero_class_check
    CHECK (hero_class IN ('novice','candidat','aspirant','guerrier','maitre','elite','s_rank'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

COMMENT ON COLUMN public.profiles.hero_class IS
  'é31 R-22 : un CODE, jamais un libellé. L''affichage passe par l''i18n (FR/EN/AR) — la colonne portait du français non accentué, rendu tel quel dans les trois langues.';

-- ===========================================================================
-- 2. Les emplacements cosmétiques : un cadre, un titre.
--
--    Colonnes séparées parce que ce sont des emplacements SÉPARÉS : équiper un
--    cadre ne déséquipe pas l'avatar. C'est exactement l'erreur que la RPC
--    d'équipement historique ferait si on lui faisait porter les trois.
-- ===========================================================================
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS frame_slug TEXT,
  ADD COLUMN IF NOT EXISTS title_code TEXT;

-- ===========================================================================
-- 3. Les objets. Prix proposés par l'exécuteur dans la fourchette des skins
--    existants (80-500), inscrits au registre économie §3.9 :
--      cadres  — 120 / 220 / 400 (le cadre se voit sur chaque écran : il vaut
--                plus cher qu'une potion, moins qu'un skin légendaire) ;
--      titres  —  90 / 180 / 350 (un titre est plus discret qu'un cadre).
--    Aucun n'est un consommable : ils s'achètent une fois et s'équipent.
-- ===========================================================================
ALTER TABLE public.shop_items DROP CONSTRAINT IF EXISTS shop_items_type_check;
ALTER TABLE public.shop_items
  ADD CONSTRAINT shop_items_type_check
  CHECK (item_type IN ('skin', 'potion', 'shield', 'booster', 'frame', 'title'));

INSERT INTO public.shop_items (code, name, item_type, description, price_coins, effect_payload, is_active)
VALUES
  ('frame_bronze',  'Cadre de Bronze',   'frame', 'Une bordure sobre autour de ton avatar.',        120, '{"frameSlug":"bronze"}',  true),
  ('frame_gold',    'Cadre d''Or',        'frame', 'La bordure dorée de l''Académie.',                220, '{"frameSlug":"gold"}',    true),
  ('frame_neon',    'Cadre Néon',        'frame', 'Une bordure qui pulse — pour qui ne passe pas inaperçu.', 400, '{"frameSlug":"neon"}', true),
  ('title_studious','Titre « L''Assidu »','title', 'Le titre de celui qui revient chaque jour.',      90, '{"titleCode":"studious"}', true),
  ('title_sharp',   'Titre « La Lame »',  'title', 'Le titre de celui qui ne rate rien.',            180, '{"titleCode":"sharp"}',   true),
  ('title_legend',  'Titre « Légende »',  'title', 'Le titre que personne n''obtient par hasard.',    350, '{"titleCode":"legend"}',  true)
ON CONFLICT (code) DO NOTHING;

-- ===========================================================================
-- 4. `equip_cosmetic` — un emplacement à la fois, jamais les trois.
--
--    Généralise `equip_inventory_skin` (qui reste, ses appelants ne bougent pas)
--    aux deux emplacements neufs. La règle « un seul équipé par emplacement »
--    vaut PAR TYPE : c'est ce qui empêche un cadre d'éteindre un avatar.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.equip_cosmetic(p_item_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user   UUID := auth.uid();
  v_inv_id UUID;
  v_name   TEXT;
  v_type   TEXT;
  v_effect JSONB;
BEGIN
  IF v_user IS NULL THEN RAISE EXCEPTION 'Not authenticated.'; END IF;

  SELECT inv.id, si.name, si.item_type, si.effect_payload
    INTO v_inv_id, v_name, v_type, v_effect
    FROM public.inventory_items inv
    JOIN public.shop_items si ON si.id = inv.shop_item_id
   WHERE inv.student_user_id = v_user AND si.code = p_item_code;

  IF v_inv_id IS NULL THEN RAISE EXCEPTION 'Item not found in inventory.'; END IF;
  IF v_type NOT IN ('skin', 'frame', 'title') THEN
    RAISE EXCEPTION 'Only cosmetics can be equipped.';
  END IF;

  -- Un seul équipé PAR TYPE : équiper un cadre laisse l'avatar en place.
  UPDATE public.inventory_items inv
     SET is_equipped = (inv.id = v_inv_id)
    FROM public.shop_items si
   WHERE inv.shop_item_id = si.id
     AND inv.student_user_id = v_user
     AND si.item_type = v_type;

  UPDATE public.profiles
     SET avatar_slug = COALESCE(v_effect ->> 'avatarSlug', avatar_slug),
         frame_slug  = COALESCE(v_effect ->> 'frameSlug',  frame_slug),
         title_code  = COALESCE(v_effect ->> 'titleCode',  title_code)
   WHERE id = v_user;

  RETURN jsonb_build_object(
    'item_code', p_item_code,
    'item_name', v_name,
    'item_type', v_type,
    'avatar_slug', v_effect ->> 'avatarSlug',
    'frame_slug',  v_effect ->> 'frameSlug',
    'title_code',  v_effect ->> 'titleCode'
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.equip_cosmetic(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.equip_cosmetic(TEXT) TO authenticated;

-- ===========================================================================
-- 5. `award_xp` écrit désormais des CODES de classe. Substituée depuis sa
--    révision vivante (20260902150000, lot 3) : une seule ancre, le CASE des
--    paliers. Les seuils ne bougent pas d'un niveau — seul le vocabulaire change.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.award_xp(p_user UUID, p_xp INT)
RETURNS public.profiles
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec public.profiles;
  today DATE := CURRENT_DATE;
  -- é31 lot 3 (R-12) — le compteur d'XP du jour, tenu dans la frappe elle-même.
  v_daily_base INT;
  new_streak INT;
  new_level INT;
  new_class TEXT;
  new_tier INT;
  caller_role TEXT := current_setting('request.jwt.claim.role', true);
  v_streak_shield_id uuid;
BEGIN
  IF p_xp IS NULL OR p_xp < 0 THEN
    RAISE EXCEPTION 'Invalid xp value';
  END IF;

  -- Allow service role jobs, otherwise enforce self-only updates.
  IF caller_role IS DISTINCT FROM 'service_role' AND auth.uid() IS DISTINCT FROM p_user THEN
    RAISE EXCEPTION 'Not allowed to award XP for another user';
  END IF;

  SELECT * INTO rec FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Streak logic
  IF rec.last_active_date IS NULL THEN
    new_streak := 1;
  ELSIF rec.last_active_date = today THEN
    new_streak := rec.current_streak;
  ELSIF rec.last_active_date = today - INTERVAL '1 day' THEN
    new_streak := rec.current_streak + 1;
  ELSIF rec.last_active_date = today - INTERVAL '2 days' THEN
    -- Exactly one missed day: a single armed streak shield can save the streak.
    -- Defensive lookup (LIMIT 1, locked) so a missing shield never breaks award_xp.
    SELECT inv.id
      INTO v_streak_shield_id
      FROM public.inventory_items inv
      JOIN public.shop_items si ON si.id = inv.shop_item_id
      WHERE inv.student_user_id = p_user
        AND inv.is_active = true
        AND inv.quantity >= 1
        AND si.item_type = 'shield'
        AND (si.effect_payload ? 'streakShield')
      ORDER BY inv.acquired_at ASC
      LIMIT 1
      FOR UPDATE OF inv;

    IF v_streak_shield_id IS NOT NULL THEN
      -- Preserve the streak (today still counts) and consume the shield.
      new_streak := rec.current_streak + 1;
      UPDATE public.inventory_items
        SET quantity = quantity - 1,
            is_active = false
        WHERE id = v_streak_shield_id;
      DELETE FROM public.inventory_items
        WHERE id = v_streak_shield_id AND quantity <= 0;
    ELSE
      new_streak := 1;
    END IF;
  ELSE
    -- Gap of >= 2 missed days: one shield can't save it → reset, do NOT consume.
    new_streak := 1;
  END IF;

  -- é31 lot 3 — L'XP DU JOUR, exact pour TOUTES les sources. `attempts` ignore
  -- le donjon, les duels et les objectifs : eux aussi passent par ici, et
  -- seulement par ici. Au premier crédit du jour, la base est l'XP d'AVANT ce
  -- crédit ; l'anneau lit ensuite `xp - daily_xp_base`.
  IF rec.daily_xp_day IS DISTINCT FROM today THEN
    v_daily_base := rec.xp;
  ELSE
    v_daily_base := rec.daily_xp_base;
  END IF;

  -- Level curve: each level = 200 xp
  new_level := GREATEST(1, ((rec.xp + p_xp) / 200) + 1);

  -- Hero class progression
  -- é31 lot 7 (R-22) — des CODES, plus des libellés français : l'affichage passe
  -- par l'i18n. Les paliers eux-mêmes ne bougent pas d'un niveau.
  new_class := CASE
    WHEN new_level >= 50 THEN 's_rank'
    WHEN new_level >= 31 THEN 'elite'
    WHEN new_level >= 21 THEN 'maitre'
    WHEN new_level >= 11 THEN 'guerrier'
    WHEN new_level >= 6 THEN 'aspirant'
    ELSE 'candidat'
  END;

  new_tier := LEAST(6, GREATEST(1, (new_level / 8) + 1));

  UPDATE public.profiles
  SET
    xp = xp + p_xp,
    level = new_level,
    hero_class = new_class,
    avatar_tier = new_tier,
    current_streak = new_streak,
    longest_streak = GREATEST(longest_streak, new_streak),
    last_active_date = today,
    daily_xp_day = today,
    daily_xp_base = v_daily_base
  WHERE id = p_user
  RETURNING * INTO rec;

  RETURN rec;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_xp(uuid, int) FROM authenticated, anon, public;

-- ===========================================================================
-- 6. ⚠️ `award_duel_rewards` — LE SECOND ÉCRIVAIN DE `hero_class`.
--
--    Il recopie la courbe de niveau d'`award_xp` (duplication antérieure à ce
--    lot, é05) et écrivait donc, lui aussi, du français. Sans cette
--    substitution, la contrainte posée plus haut ferait ÉCHOUER chaque
--    récompense de duel — la suite pgTAP `25_duel_forfeit` l'a montré en local
--    avant la CI.
--
--    Substituée depuis 20260706170000, une seule ancre : le CASE des paliers.
--    La duplication de la courbe, elle, reste — la réduire est un chantier d'é09,
--    pas un effet de bord d'un lot d'engagement.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.award_duel_rewards(p_user UUID, p_xp INT, p_coins INT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile public.profiles;
  v_level INT;
  v_class TEXT;
  v_tier INT;
BEGIN
  IF p_xp IS NULL OR p_xp < 0 OR p_coins IS NULL OR p_coins < 0 THEN
    RAISE EXCEPTION 'Invalid duel reward';
  END IF;

  SELECT * INTO v_profile FROM public.profiles WHERE id = p_user FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found';
  END IF;

  -- Same level curve as award_xp (200 XP/level); no streak side-effects — the
  -- streak system is owned by the exercise/quiz path.
  v_level := GREATEST(1, ((v_profile.xp + p_xp) / 200) + 1);
  -- é31 lot 7 (R-22) — des CODES, comme `award_xp`. Les seuils ne bougent pas.
  v_class := CASE
    WHEN v_level >= 50 THEN 's_rank'
    WHEN v_level >= 31 THEN 'elite'
    WHEN v_level >= 21 THEN 'maitre'
    WHEN v_level >= 11 THEN 'guerrier'
    WHEN v_level >= 6 THEN 'aspirant'
    ELSE 'candidat'
  END;
  v_tier := LEAST(6, GREATEST(1, (v_level / 8) + 1));

  UPDATE public.profiles
  SET xp = xp + p_xp,
      yahia_coins = yahia_coins + p_coins,
      level = v_level,
      hero_class = v_class,
      avatar_tier = v_tier
  WHERE id = p_user;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.award_duel_rewards(uuid, int, int) FROM PUBLIC, anon, authenticated;

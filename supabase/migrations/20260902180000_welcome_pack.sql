-- Étude 31 — lot 6 : L'ACCUEIL (US-9, R-19).
--
-- CONSTAT N° 8 : « le compte naît à ZÉRO ». L'onboarding est trois écrans de
-- choix — aucune question jouée, aucune récompense de bienvenue, et une fin qui
-- renvoie vers un tableau de bord vide. Le premier moment d'un élève est donc
-- une page d'administration, alors que la boucle de jeu, elle, est excellente.
--
-- CE QUE POSE CETTE MIGRATION
--
-- * `claim_welcome_pack()` — 30 pièces (Q-4, arbitrée : « un `booster_hint`
--   exactement — la boutique s'apprend par l'usage »), créditées UNE SEULE FOIS,
--   par `award_coins` (la frappe existante ; rien de neuf dans l'économie).
-- * La MÊME fonction rend la première quête du parcours choisi, pour que la fin
--   de l'accueil soit UNE action et pas un menu (R-19). Elle est là parce qu'elle
--   sait déjà résoudre le parcours : deux allers-retours pour un seul geste,
--   c'est un écran qui clignote.
--
-- ⚠️ ÉCART ASSUMÉ AU §3.2 : l'étude parle d'« une ligne de garde par user ».
-- C'est une COLONNE (`profiles.welcome_pack_at`) : même garantie d'unicité, une
-- table de moins à sécuriser, et la date reste lisible pour le jour où on voudra
-- mesurer le délai entre inscription et première quête.

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS welcome_pack_at TIMESTAMPTZ;

COMMENT ON COLUMN public.profiles.welcome_pack_at IS
  'é31 R-19 : date du versement de la récompense de bienvenue. NULL = jamais versée. Sert de garde d''idempotence — la seule.';

CREATE OR REPLACE FUNCTION public.claim_welcome_pack()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user   UUID := auth.uid();
  v_coins  CONSTANT INT := 30;   -- Q-4, arbitrée le 2026-09-01 (registre §3.9)
  v_claimed BOOLEAN;
  v_theme  TEXT;
  v_grade  UUID;
  v_first  UUID;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- ⭐ L'IDEMPOTENCE EST DANS L'UPDATE, pas dans un SELECT suivi d'un INSERT :
  -- deux appels simultanés (double clic, rejeu réseau) ne peuvent pas gagner
  -- tous les deux, parce que le second ne trouve plus de ligne à mettre à jour.
  UPDATE public.profiles
     SET welcome_pack_at = clock_timestamp()
   WHERE id = v_user AND welcome_pack_at IS NULL;
  v_claimed := FOUND;

  IF v_claimed THEN
    PERFORM public.award_coins(v_user, v_coins);
  END IF;

  -- La première quête du parcours choisi : une matière, un chapitre, un exercice
  -- jouable. `display_order` porte l'intention de l'auteur du corpus — c'est le
  -- premier chapitre du programme, pas le premier par hasard.
  SELECT pa.theme_id, pa.grade_id
    INTO v_theme, v_grade
    FROM public.profiles pr
    JOIN public.parcours pa ON pa.id = pr.current_parcours_id
   WHERE pr.id = v_user;

  IF v_theme IS NOT NULL THEN
    SELECT e.id INTO v_first
      FROM public.exercises e
      JOIN public.chapters c ON c.id = e.chapter_id
      JOIN public.subjects s ON s.id = c.subject_id
     WHERE s.theme_id = v_theme
       AND (v_grade IS NULL OR s.grade_id = v_grade)
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
       -- Le premier exercice doit être ABORDABLE : la difficulté 1 d'abord,
       -- sinon l'accueil peut ouvrir sur un boss.
     ORDER BY s.display_order, c.display_order, e.difficulty, e.display_order
     LIMIT 1;
  END IF;

  RETURN jsonb_build_object(
    -- `granted` dit si CET appel a crédité : l'écran ne fête pas deux fois.
    'granted', v_claimed,
    'coins', CASE WHEN v_claimed THEN v_coins ELSE 0 END,
    'firstExerciseId', v_first
  );
END;
$$;

COMMENT ON FUNCTION public.claim_welcome_pack() IS
  'é31 R-19 : la récompense de bienvenue (30 pièces, Q-4), versée une seule fois, plus la première quête du parcours choisi — une action, pas un menu.';

REVOKE EXECUTE ON FUNCTION public.claim_welcome_pack() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.claim_welcome_pack() TO authenticated;

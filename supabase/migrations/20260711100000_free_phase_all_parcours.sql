-- =========================================================
-- Phase gratuite — tous les parcours ouverts (étude 15, D-3 / arbitrage Q-2)
-- ---------------------------------------------------------
-- Décision produit du 2026-07-10 : dans cette phase, l'application est 100 %
-- gratuite — pas de paiement, pas de premium, tout le programme accessible.
-- La bascule est DATA + une porte, volontairement réversible :
--
--  1. `parcours.is_premium` passe à false partout. Le premium gate existant
--     (« a FREE parcours is always open », resolve_exercise_access) ouvre alors
--     toutes les missions sans autre changement. Les DEUX parcours qui étaient
--     premium — `concours-9eme` et `concours-6eme` — sont notés ici pour que
--     l'étude 01 (paiement en ligne) puisse les re-basculer d'un UPDATE inverse.
--  2. `get_dungeon_access()` perd sa raison SUBSCRIPTION : le Donjon n'est plus
--     un avantage premium ; ses verrous d'ENGAGEMENT (prérequis de progression,
--     niveau, limite quotidienne) sont conservés à l'identique. La forme OUT est
--     inchangée (`has_subscription` renvoie true) → CREATE OR REPLACE suffit et
--     le serveur/le lobby restent compatibles pendant le déploiement.
--
-- Le schéma (tables/RLS/RPCs d'entitlement) reste intact et DORMANT : rien à
-- ré-apprendre pour l'étude 01. Aucune donnée n'est supprimée.
-- =========================================================

UPDATE public.parcours
SET is_premium = false
WHERE is_premium;

CREATE OR REPLACE FUNCTION public.get_dungeon_access()
RETURNS TABLE (
  level INT,
  max_runs_per_day INT,
  runs_today INT,
  subjects_done INT,
  chapters_done INT,
  required_subjects INT,
  required_chapters INT,
  has_subscription BOOLEAN,
  can_access BOOLEAN,
  reason TEXT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_level INT;
  v_max INT;
  v_runs INT;
  v_subjects INT;
  v_chapters INT;
  c_req_subjects CONSTANT INT := 2;
  c_req_chapters CONSTANT INT := 3;
  c_cap CONSTANT INT := 5;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT p.level INTO v_level FROM public.profiles p WHERE p.id = v_user;
  v_level := COALESCE(v_level, 0);
  v_max := LEAST(GREATEST(v_level, 0), c_cap);

  SELECT COUNT(DISTINCT a.subject_id) INTO v_subjects
  FROM public.attempts a WHERE a.user_id = v_user;

  SELECT COUNT(DISTINCT e.chapter_id) INTO v_chapters
  FROM public.attempts a
  JOIN public.exercises e ON e.id = a.exercise_id
  WHERE a.user_id = v_user;

  SELECT COUNT(*) INTO v_runs
  FROM public.dungeon_runs d
  WHERE d.user_id = v_user
    AND d.created_at >= date_trunc('day', timezone('utc', now()));

  level := v_level;
  max_runs_per_day := v_max;
  runs_today := v_runs;
  subjects_done := v_subjects;
  chapters_done := v_chapters;
  required_subjects := c_req_subjects;
  required_chapters := c_req_chapters;
  -- Phase gratuite (étude 15, Q-2) : plus de porte premium sur le Donjon. La
  -- colonne OUT est conservée (compat UI/serveur) et vaut toujours true ;
  -- l'étude 01 réintroduira la vraie condition d'entitlement ici.
  has_subscription := true;

  IF v_subjects < c_req_subjects OR v_chapters < c_req_chapters THEN
    can_access := false; reason := 'PREREQ';
  ELSIF v_max < 1 THEN
    can_access := false; reason := 'LEVEL';
  ELSIF v_runs >= v_max THEN
    can_access := false; reason := 'DAILY_LIMIT';
  ELSE
    can_access := true; reason := '';
  END IF;

  RETURN NEXT;
END;
$$;

REVOKE ALL ON FUNCTION public.get_dungeon_access() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_dungeon_access() FROM anon;
GRANT EXECUTE ON FUNCTION public.get_dungeon_access() TO authenticated;

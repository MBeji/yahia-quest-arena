-- Étude 08 — lot 3 : LE COMPARATIF DE PARCOURS, SEUILLÉ (US-8, R-5, R-6, D-3).
--
-- CE QUE LE PARENT DEMANDE. « Est-ce que c'est bien, 68 % ? » Un chiffre seul ne
-- répond pas ; il lui faut un repère. Le seul repère HONNÊTE dont la plateforme
-- dispose est le sien : la moyenne des élèves qui suivent le même parcours ICI.
--
-- * **R-5 — jamais « moyenne nationale ».** Ce n'en est pas une : c'est la
--   moyenne des élèves actifs de la plateforme sur ce parcours. Le libellé le dit.
-- * **R-6 — masqué sous 30 élèves.** En dessous, une moyenne désigne des enfants.
--   La fonction rend alors `masked = true` et AUCUN chiffre — ni les moyennes, ni
--   l'effectif : même le nombre exact serait une information sur un petit groupe.
-- * **D-3 — un agrégat, jamais un rang.** Rien ne situe un enfant parmi les
--   autres ; il n'y a ni classement, ni percentile, ni minimum/maximum.
-- * **Une seule définition** : `_parcours_student_stats` calcule les chiffres
--   d'UN élève ou de TOUS avec la même requête — l'enfant et la plateforme ne
--   peuvent pas être mesurés différemment.
--
-- LA MESURE. Fenêtre : les 28 derniers jours civils de Tunis (quatre semaines,
-- aujourd'hui compris). « Élève actif sur le parcours » = profil `student` ayant
-- rendu au moins une mission d'une matière du parcours dans la fenêtre.
--   score moyen   = moyenne des moyennes PAR ÉLÈVE (un élève = une voix : dix
--                   élèves très actifs ne tirent pas la moyenne des trente) ;
--   temps hebdo   = minutes d'apprentissage mesurées (hors navigation) sur les
--                   matières du parcours, ÷ 4, moyenne par élève.
--
-- Migration ADDITIVE : trois fonctions neuves, rien de modifié.

-- L'agrégat lit les pouls PAR MATIÈRE sur une fenêtre ; les index existants
-- partent tous de `user_id`. Sans celui-ci, chaque ouverture du bilan parcourrait
-- la table entière.
CREATE INDEX IF NOT EXISTS idx_learning_pulses_subject_recent
  ON public.learning_pulses (subject_id, occurred_at)
  WHERE subject_id IS NOT NULL;

-- ---------------------------------------------------------------------------
-- 1. La mesure par élève — interne, REVOKE de tout rôle client.
--    `p_student` NULL = tous les élèves actifs du parcours.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._parcours_student_stats(p_parcours TEXT, p_student UUID)
RETURNS TABLE (user_id UUID, avg_score NUMERIC, weekly_minutes NUMERIC)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH bounds AS (
    SELECT (((now() AT TIME ZONE 'Africa/Tunis')::date - 27)::timestamp
              AT TIME ZONE 'Africa/Tunis') AS from_ts
  ),
  subj AS (
    SELECT s.id
      FROM public.parcours p
      JOIN public.subjects s
        ON s.theme_id = p.theme_id
       AND s.grade_id IS NOT DISTINCT FROM p.grade_id
     WHERE p.id = p_parcours
  ),
  scores AS (
    SELECT a.user_id, AVG(a.score_pct) AS avg_score
      FROM public.attempts a
      JOIN public.profiles pr ON pr.id = a.user_id AND pr.role = 'student'
     WHERE a.subject_id IN (SELECT id FROM subj)
       AND a.completed_at >= (SELECT from_ts FROM bounds)
       AND (p_student IS NULL OR a.user_id = p_student)
     GROUP BY a.user_id
  ),
  minutes AS (
    SELECT lp.user_id, SUM(lp.active_seconds) AS seconds
      FROM public.learning_pulses lp
     WHERE lp.subject_id IN (SELECT id FROM subj)
       AND lp.surface <> 'browse'
       AND lp.occurred_at >= (SELECT from_ts FROM bounds)
       AND (p_student IS NULL OR lp.user_id = p_student)
     GROUP BY lp.user_id
  )
  SELECT sc.user_id,
         sc.avg_score,
         COALESCE(m.seconds, 0) / 60.0 / 4.0 AS weekly_minutes
    FROM scores sc
    LEFT JOIN minutes m ON m.user_id = sc.user_id;
$$;

REVOKE EXECUTE ON FUNCTION public._parcours_student_stats(TEXT, UUID)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. L'agrégat plateforme — anonyme, seuillé (R-6).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_parcours_platform_stats(p_parcours TEXT)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  c_min_students CONSTANT INT := 30;
  v_students INT;
  v_avg_score NUMERIC;
  v_weekly NUMERIC;
BEGIN
  IF auth.uid() IS NULL AND COALESCE(auth.role(), '') <> 'service_role' THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT COUNT(*)::INT, AVG(s.avg_score), AVG(s.weekly_minutes)
    INTO v_students, v_avg_score, v_weekly
    FROM public._parcours_student_stats(p_parcours, NULL) s;

  IF v_students < c_min_students THEN
    -- Ni chiffre ni effectif : sous le seuil, tout nombre parle de quelqu'un.
    RETURN jsonb_build_object(
      'masked', true, 'minStudents', c_min_students, 'windowDays', 28,
      'students', NULL, 'avgScore', NULL, 'weeklyMinutes', NULL);
  END IF;

  RETURN jsonb_build_object(
    'masked', false,
    'minStudents', c_min_students,
    'windowDays', 28,
    'students', v_students,
    'avgScore', ROUND(v_avg_score)::INT,
    'weeklyMinutes', ROUND(v_weekly)::INT
  );
END;
$$;

COMMENT ON FUNCTION public.get_parcours_platform_stats(TEXT) IS
  'Étude 08 lot 3 (US-8) : moyenne des élèves ACTIFS DE LA PLATEFORME sur un parcours, 28 jours — jamais une « moyenne nationale » (R-5). Masquée sous 30 élèves, effectif compris (R-6). Agrégat seul : ni rang, ni identifiant.';

REVOKE EXECUTE ON FUNCTION public.get_parcours_platform_stats(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_parcours_platform_stats(TEXT) TO authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 3. L'enfant face au repère — une lecture pour l'écran parent.
--    Garde : `assert_can_read_student_activity` (admin, ou parent au lien actif).
--    Le parcours est celui de l'élève (`current_parcours_id`) : le parent ne
--    choisit pas un parcours arbitraire à sonder.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_student_parcours_comparison(p_student UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_parcours public.parcours%ROWTYPE;
  v_score NUMERIC;
  v_weekly NUMERIC;
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);

  SELECT p.* INTO v_parcours
    FROM public.profiles pr
    JOIN public.parcours p ON p.id = pr.current_parcours_id
   WHERE pr.id = p_student;
  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT s.avg_score, s.weekly_minutes INTO v_score, v_weekly
    FROM public._parcours_student_stats(v_parcours.id, p_student) s;

  RETURN jsonb_build_object(
    'parcours', jsonb_build_object(
      'nameFr', v_parcours.name_fr, 'nameEn', v_parcours.name_en, 'nameAr', v_parcours.name_ar),
    -- NULL = l'enfant n'a rendu aucune mission de ce parcours sur la fenêtre.
    'student', CASE WHEN v_score IS NULL THEN NULL ELSE jsonb_build_object(
      'avgScore', ROUND(v_score)::INT,
      'weeklyMinutes', ROUND(v_weekly)::INT) END,
    'platform', public.get_parcours_platform_stats(v_parcours.id)
  );
END;
$$;

COMMENT ON FUNCTION public.get_student_parcours_comparison(UUID) IS
  'Étude 08 lot 3 (US-8) : les chiffres d''un élève sur son parcours courant, à côté de l''agrégat plateforme seuillé. Admin ou parent au lien actif. Même mesure des deux côtés (_parcours_student_stats).';

REVOKE EXECUTE ON FUNCTION public.get_student_parcours_comparison(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_parcours_comparison(UUID) TO authenticated;

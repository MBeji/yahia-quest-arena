-- Étude 22, lot 4 (R-23) — le classement gagne une cohorte de CLASSE.
--
-- Le classement n'avait qu'une échelle : l'académie entière. Un élève de 3ème année s'y
-- mesurait à des lycéens, ce qui rend le rang illisible et décourageant. « Ma classe » ramène
-- la comparaison à des pairs réels.
--
-- La cohorte est le GRADE, pas le parcours (D-5) : un élève inscrit en « Concours 9ème » et un
-- élève en « 9ème » sont des pairs scolaires et doivent partager un classement. Segmenter par
-- parcours fragmenterait les 9èmes en deux files.
--
-- Même contrat de sortie que `get_global_leaderboard` (mêmes colonnes, même politique : aucun
-- `user_id` de tiers ne sort, seulement des champs publics plus le drapeau `is_me`), et même
-- posture de confidentialité — c'est pour cela que la fonction est `SECURITY DEFINER` : depuis
-- 20260522153000 la policy SELECT de `profiles` est « son profil ou ceux qui lui sont liés »,
-- donc une lecture directe ne renverrait que la ligne de l'appelant.
--
-- Pas de vue matérialisée ici, contrairement au global : une cohorte de classe se compte en
-- dizaines ou centaines de lignes, pas en dizaines de milliers. Le rang est donc calculé en
-- direct — il est exact à la seconde, là où le global tolère 5 minutes de retard.
--
-- Élève sans `current_grade_id` (parcours libre) : retour VIDE. Ce n'est pas une erreur, c'est
-- l'absence de cohorte ; le client masque alors l'onglet plutôt que d'afficher un classement
-- vide sans explication.

CREATE OR REPLACE FUNCTION public.get_grade_leaderboard(p_limit INT DEFAULT 50)
RETURNS TABLE (
  rank BIGINT,
  display_name TEXT,
  hero_class TEXT,
  level INT,
  xp INT,
  current_streak INT,
  avatar_tier INT,
  is_me BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  WITH caller AS (
    SELECT p.current_grade_id AS grade_id
    FROM public.profiles p
    WHERE p.id = (SELECT auth.uid())
      AND p.role = 'student'
  ),
  cohort AS (
    -- `xp > 0` (cold-start, étude 15 D-7) : on n'annonce jamais un rang à qui n'a rien joué,
    -- et on ne peuple pas la classe de faux concurrents à zéro point.
    SELECT
      p.id AS user_id,
      rank() OVER (ORDER BY p.xp DESC) AS rank
    FROM public.profiles p
    JOIN caller c ON c.grade_id IS NOT NULL
    WHERE p.current_grade_id = c.grade_id
      AND p.role = 'student'
      AND p.xp > 0
  ),
  board AS (
    SELECT co.rank, co.user_id
    FROM cohort co
    WHERE co.rank <= GREATEST(p_limit, 1)
      AND co.user_id <> (SELECT auth.uid())
  ),
  me AS (
    -- La ligne de l'appelant est toujours renvoyee, meme hors du top : c'est elle qui porte
    -- « ton rang ». Sortie du board pour ne pas apparaitre deux fois.
    SELECT co.rank, co.user_id
    FROM cohort co
    WHERE co.user_id = (SELECT auth.uid())
  ),
  combined AS (
    SELECT rank, user_id FROM board
    UNION ALL
    SELECT rank, user_id FROM me
  )
  SELECT
    c.rank,
    p.display_name,
    p.hero_class,
    p.level,
    p.xp,
    p.current_streak,
    p.avatar_tier,
    (c.user_id = (SELECT auth.uid())) AS is_me
  FROM combined c
  JOIN public.profiles p ON p.id = c.user_id AND p.role = 'student'
  ORDER BY c.rank;
$$;

REVOKE ALL ON FUNCTION public.get_grade_leaderboard(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_grade_leaderboard(INT) TO authenticated;

-- Sert le filtre de cohorte + le tri par XP en une seule passe.
CREATE INDEX IF NOT EXISTS idx_profiles_grade_xp
  ON public.profiles(current_grade_id, xp DESC)
  WHERE role = 'student';

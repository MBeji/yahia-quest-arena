-- La référence de nouveauté d'un chapitre n'est plus recalculée à chaque mission.
--
-- LE MÉCANISME (audit de performance du 2026-10-31, constat db-01)
-- ---------------------------------------------------------------------------
-- `chapter_star_rungs` (20260914120000) posait sa référence dans une CTE :
--   WITH ref AS (SELECT public.chapter_progress_ref(p_user, p_chapter) AS at)
-- puis la lisait deux fois par mission (`r.at IS NOT NULL AND e.created_at > r.at`).
-- Depuis Postgres 12, une CTE référencée UNE fois et sans effet de bord est
-- APLATIE par le planificateur : l'appel de fonction STABLE est recopié dans
-- l'expression, donc évalué à chaque ligne. EXPLAIN VERBOSE du corps le montre
-- noir sur blanc — `chapter_progress_ref(...)` apparaît deux fois dans le
-- FILTER de l'agrégat, plus du tout dans une CTE. Or `chapter_progress_ref`
-- joint TOUTES les tentatives de l'élève au chapitre (0,5-0,7 ms à 5 000
-- tentatives) : on la payait 2 × missions fois par appel de crans.
--
-- Mesuré sur la chaîne rejouée (2 000 élèves, 105 k tentatives ; élève engagé =
-- 5 000 tentatives sur 20 matières × 10 chapitres × 18 missions), compteur
-- `track_functions` :
--   * hub matière (get_subject_progress, 10 chapitres) : 1 464 évaluations de
--     chapter_progress_ref pour 40 appels de crans, 126-150 ms ;
--   * tableau de bord (get_user_subject_stars, 15 matières) : 5 490 pour 150
--     appels, 380-430 ms ;
--   * une soumission (trigger record_progress_stars) : 38 pour 1 appel.
--
-- LA RÉPARATION — un mot, aucun changement de résultat
-- ---------------------------------------------------------------------------
-- `WITH ref AS MATERIALIZED` : la CTE est évaluée une fois par appel, garanti
-- (PG ≥ 12, Supabase est en 15/17). Le corps est ré-émis À L'IDENTIQUE à ce mot
-- près ; les empreintes md5 des sorties (get_subject_progress sur 20 matières,
-- les 800 lignes de crans et les 200 étoiles vivantes de l'élève,
-- get_user_subject_stars) sont les mêmes avant et après. Le REVOKE de la
-- définition d'origine est re-posé : la fonction lit les tentatives d'un élève
-- ARBITRAIRE et reste fermée aux clients.
--
-- Hors de ce lot, à mesurer avant d'y toucher : get_subject_progress appelle
-- les crans trois fois par chapitre (étoile vivante, crans, nouveautés), et
-- chapter_progress_ref elle-même joint toutes les tentatives de l'élève.

CREATE OR REPLACE FUNCTION public.chapter_star_rungs(p_user UUID, p_chapter UUID)
RETURNS TABLE (
  difficulty       SMALLINT,
  missions_total   INT,
  missions_counted INT,
  missions_new     INT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  -- MATERIALIZED : la référence se calcule UNE fois par appel. Sans ce mot le
  -- planificateur recopie la fonction dans l'expression et l'évalue deux fois
  -- par mission (constat db-01, 2026-10-31).
  WITH ref AS MATERIALIZED (
    SELECT public.chapter_progress_ref(p_user, p_chapter) AS at
  ),
  missions AS (
    SELECT
      -- `exercises.difficulty` n'a aucune contrainte CHECK en base : on borne
      -- ici plutôt que de faire confiance à la donnée.
      LEAST(GREATEST(e.difficulty, 1), 4)::SMALLINT AS d,
      public.mission_is_counted(p_user, e.id) AS counted,
      (
        r.at IS NOT NULL
        AND e.created_at > r.at
        AND NOT EXISTS (
          SELECT 1 FROM public.attempts a
           WHERE a.user_id = p_user AND a.exercise_id = e.id
        )
      ) AS is_new
      FROM public.exercises e
      CROSS JOIN ref r
     WHERE e.chapter_id = p_chapter
       AND e.source = 'admin'
       AND e.mode IS DISTINCT FROM 'quiz'
  )
  SELECT
    m.d,
    count(*)::INT,
    count(*) FILTER (WHERE m.counted)::INT,
    count(*) FILTER (WHERE m.is_new)::INT
    FROM missions m
   GROUP BY m.d
   ORDER BY m.d;
$fn$;

COMMENT ON FUNCTION public.chapter_star_rungs(UUID, UUID) IS
  'Étude 34 R-8 : les crans de la jauge d''un chapitre — un par niveau de difficulté PRÉSENT, avec son total, ce qui compte, et ce qui est arrivé après la référence de l''élève (✨).';

REVOKE ALL ON FUNCTION public.chapter_star_rungs(UUID, UUID) FROM PUBLIC, anon, authenticated;

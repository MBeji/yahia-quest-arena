-- =============================================================================
-- Étude 40, lot 0 — LA MESURE DU RETOUR, côté comptes : `admin_return_overview()`.
-- -----------------------------------------------------------------------------
-- Le propriétaire a demandé, le 2026-11-12 : « je veux que les utilisateurs
-- reviennent après une première visite ». L'étude 40 a constaté que rien de ce
-- retour ne se lisait. PostHog ne sait pas dire QUI est revenu (profils de
-- personne désactivés — protection des mineurs) ; la console d'engagement lit la
-- rétention des comptes qui ont DÉJÀ joué. Entre les deux, trois questions
-- restaient sans chiffre :
--
--   1. LA PREMIÈRE QUÊTE (KPI-2). Un compte créé a-t-il joué dans sa première
--      semaine ? KPI-B (`admin_engagement_overview`) exclut le jour J à dessein —
--      il mesure le RETOUR. Mais un compte qui ne joue jamais n'a rien à quoi
--      revenir, et c'est la première marche qui se perd.
--   2. LA PORTÉE DU PUSH (KPI-3). Le rappel est le seul canal qui peut ramener
--      quelqu'un ; combien d'élèves et de parents peut-il seulement atteindre ?
--   3. LES JAMAIS-JOUÉ. Combien de comptes n'ont aucun jour d'activité, du tout ?
--
-- ⚠️ FONCTION SÉPARÉE, À DESSEIN. `admin_engagement_overview()` fait quatre cents
-- lignes et trois études l'ont déjà ré-émise (é34 §3.7). Cette migration ne la
-- touche pas : une lecture neuve, une porte neuve, additive.
--
-- DÉFINITIONS ARRÊTÉES (é40 §3.1), affichées telles quelles sur la console :
--   * cohorte      = semaine d'inscription (lundi, jour de Tunis), rôle `student`.
--                    HUIT semaines, la semaine en cours comprise — une semaine
--                    sans inscription rend une ligne à zéro, pas une ligne absente.
--   * confirmed    = `auth.users.email_confirmed_at IS NOT NULL`.
--   * played_7d    = au moins un jour dans `eng_activity_days` entre J et J+7,
--                    JOUR J INCLUS — c'est la première quête, pas un retour.
--   * back_7d      = au moins un jour entre J+1 et J+7 — la définition de KPI-B,
--                    reprise telle quelle (le jour de l'inscription ne compte pas).
--   * `_base`      = les comptes dont la fenêtre de sept jours est ENTIÈREMENT
--                    écoulée (`J+7 < aujourd'hui`). Un compte d'hier n'a pas « raté »
--                    sa première semaine : il n'est pas encore mesurable. « Perdu »
--                    se lit `base − played`, jamais `signups − played`.
--   * never_played = élèves sans AUCUN jour d'activité, toutes dates confondues.
--   * reachable    = au moins une ligne dans `push_subscriptions`.
--
-- Un compte NON CONFIRMÉ reste dans `signups` et dans les bases : il s'est inscrit
-- et n'a pas joué, c'est exactement ce que la mesure doit voir. `confirmed` voyage
-- à côté pour dire quelle part de la perte se joue AVANT le premier écran.
--
-- SÉCURITÉ : SECURITY DEFINER (lit `auth.users`, `push_subscriptions` et les vues
-- `eng_*`, toutes fermées aux clients), `search_path` fixé, garde `is_admin()`,
-- REVOKE puis GRANT explicite — le GRANT ouvre l'appel, la garde de RÔLE trie.
-- STABLE : elle ne peut rien écrire.
-- =============================================================================

CREATE OR REPLACE FUNCTION public.admin_return_overview()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_out   JSONB;
  v_today DATE := (now() AT TIME ZONE 'Africa/Tunis')::date;
  v_week  DATE := public.app_current_week_start();
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  WITH
  -- Huit lundis, du plus ancien à la semaine en cours. La série est GÉNÉRÉE :
  -- une semaine sans inscription existe quand même, avec des zéros.
  weeks AS (
    SELECT generate_series(v_week - 49, v_week, INTERVAL '1 week')::date AS week
  ),
  members AS (
    SELECT
      p.id AS user_id,
      (p.created_at AT TIME ZONE 'Africa/Tunis')::date AS signup_day,
      date_trunc('week', (p.created_at AT TIME ZONE 'Africa/Tunis')::date)::date AS week,
      (u.email_confirmed_at IS NOT NULL) AS confirmed
    FROM public.profiles p
    LEFT JOIN auth.users u ON u.id = p.id
    WHERE p.role = 'student'
      AND (p.created_at AT TIME ZONE 'Africa/Tunis')::date >= v_week - 49
  ),
  flags AS (
    SELECT
      m.week,
      m.confirmed,
      -- Mesurable = J+7 est derrière nous. Même borne que KPI-B (`d7_measurable`).
      (m.signup_day + 7 < v_today) AS measurable,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day >= m.signup_day AND d.day <= m.signup_day + 7) AS played_7d,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 7) AS back_7d
    FROM members m
  ),
  cohorts AS (
    SELECT
      w.week,
      COUNT(f.week)::int                                        AS signups,
      COUNT(*) FILTER (WHERE f.confirmed)::int                  AS confirmed,
      COUNT(*) FILTER (WHERE f.measurable AND f.played_7d)::int AS played_7d,
      COUNT(*) FILTER (WHERE f.measurable)::int                 AS played_7d_base,
      COUNT(*) FILTER (WHERE f.measurable AND f.back_7d)::int   AS back_7d,
      COUNT(*) FILTER (WHERE f.measurable)::int                 AS back_7d_base
    FROM weeks w
    LEFT JOIN flags f ON f.week = w.week
    GROUP BY w.week
  ),
  students AS (
    SELECT p.id AS user_id FROM public.profiles p WHERE p.role = 'student'
  ),
  -- Un parent « lié » a au moins un lien ACTIF ; il se compte une fois, quel que
  -- soit le nombre d'enfants suivis.
  parents AS (
    SELECT DISTINCT l.parent_user_id AS user_id
    FROM public.parent_student_links l
    WHERE l.is_active = true
  )
  SELECT jsonb_build_object(
    'cohorts', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'week',           c.week,
        'signups',        c.signups,
        'confirmed',      c.confirmed,
        'played_7d',      c.played_7d,
        'played_7d_base', c.played_7d_base,
        'back_7d',        c.back_7d,
        'back_7d_base',   c.back_7d_base
      ) ORDER BY c.week), '[]'::jsonb)
      FROM cohorts c
    ),
    -- Le dénominateur de « jamais joué » : sans lui, « 36 » ne se lit pas.
    'students', (SELECT COUNT(*) FROM students),
    'never_played', (
      SELECT COUNT(*) FROM students s
       WHERE NOT EXISTS (SELECT 1 FROM public.eng_activity_days d WHERE d.user_id = s.user_id)
    ),
    'push', jsonb_build_object(
      'students_active_30d', (
        SELECT COUNT(DISTINCT d.user_id) FROM public.eng_activity_days d
         WHERE d.day > v_today - 30
      ),
      'students_reachable', (
        SELECT COUNT(*) FROM students s
         WHERE EXISTS (SELECT 1 FROM public.push_subscriptions ps WHERE ps.user_id = s.user_id)
      ),
      'parents_linked', (SELECT COUNT(*) FROM parents),
      'parents_reachable', (
        SELECT COUNT(*) FROM parents pa
         WHERE EXISTS (SELECT 1 FROM public.push_subscriptions ps WHERE ps.user_id = pa.user_id)
      )
    ),
    'generated_at', now()
  )
  INTO v_out;

  RETURN v_out;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_return_overview() FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.admin_return_overview() TO authenticated;

COMMENT ON FUNCTION public.admin_return_overview() IS
  'Étude 40 lot 0 — la mesure du retour côté comptes : première quête et retour à 7 jours par cohorte d''inscription, élèves jamais actifs, portée du push. Lecture seule, admin uniquement.';

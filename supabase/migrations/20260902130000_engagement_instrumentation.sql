-- Étude 31 — lot 1 : MESURER le retour de l'élève (US-13, KPI-A/B/C/D/E).
--
-- POURQUOI CE LOT EST LE PREMIER
-- ---------------------------------------------------------------------------
-- Le constat n° 1 de l'étude est qu'il n'existe AUCUNE mesure de rétention :
-- ni vue, ni RPC, ni écran. STATUS §1bis porte la ligne « rétention **jamais
-- publiée** » depuis le 2026-07-19 (é26 KPI-4). Tant qu'elle tient, chaque
-- mécanique d'engagement ajoutée est un pari : on ne saurait pas dire si elle
-- ramène quelqu'un. Ce lot remplace l'opinion par un chiffre.
--
-- D-1 — LA RÉTENTION SE CALCULE DANS POSTGRES, PAS DANS POSTHOG. PostHog est
-- volontairement anonymisé (`$process_person_profile: false`) : sans profil de
-- personne, il ne SAIT PAS dire qui est revenu. Réactiver les profils serait
-- rouvrir une décision de protection des mineurs pour un confort d'outil — refusé.
-- PostHog reste l'outil de FUNNEL ; la rétention par personne vit ici.
--
-- R-1 — LA MÉTRIQUE DE GARDE EST L'APPRENTISSAGE. Toute surface qui publie un
-- chiffre d'engagement publie à côté la précision et la progression (KPI-E) : la
-- section `learning` du JSON n'est pas décorative, elle est la condition pour que
-- les autres chiffres aient le droit d'être lus. Aucun objectif de « temps passé »
-- n'existe nulle part ici — la durée n'est même pas agrégée.
--
-- DEUX HORLOGES, ET C'EST VOULU
-- ---------------------------------------------------------------------------
--   * les SEMAINES et les JOURS d'activité sont en **Africa/Tunis** — même
--     horloge que la ligue (`app_current_week_start()`), sinon deux écrans
--     donneraient deux « lundis » ;
--   * la SÉRIE est en **UTC**, parce que `award_xp` la calcule sur `CURRENT_DATE`
--     (base en UTC). Recalculer la série en heure de Tunis ici inventerait des
--     séries mortes ou vivantes que le moteur ne connaît pas.
-- Les deux sont écrites dans `notes` du JSON, donc visibles à l'écran.
--
-- ⚠️ GRANTS EXPLICITES (piège CLAUDE.md) : les vues neuves ne sont lisibles par
-- PERSONNE côté client, la table neuve non plus. La seule porte est le RPC
-- SECURITY DEFINER, gardé par `is_admin()` — même posture que
-- `admin_economy_overview` (é09 lot 1). Ce sont des chiffres d'entreprise
-- (volumétrie du parc), pas des chiffres d'élève.

-- ===========================================================================
-- 1. `push_consent_events` — le consentement push laisse enfin une trace.
--
--    US-13 demande « opt-in ET opt-out ». L'opt-in se compte (une ligne dans
--    `push_subscriptions`), l'opt-out ne se comptait PAS : `delete_push_subscription`
--    SUPPRIME la ligne, donc un désabonnement était indistinguable d'un
--    utilisateur qui n'a jamais accepté. KPI-D (« opt-out mensuel < 5 % » —
--    le garde-fou de R-4 contre RISK-2) était donc non mesurable par construction.
--
--    Table append-only, minuscule, SANS PII : un identifiant, un verbe, une date.
--    Elle ne pilote rien — le dispatcher continue de lire `push_subscriptions`.
-- ===========================================================================
CREATE TABLE IF NOT EXISTS public.push_consent_events (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  action TEXT NOT NULL CHECK (action IN ('optin', 'optout')),
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.push_consent_events IS
  'Journal append-only des bascules de consentement push (é31 lot 1, KPI-D). Écrit par save_push_subscription / delete_push_subscription uniquement ; lu par admin_engagement_overview. Aucune PII.';

CREATE INDEX IF NOT EXISTS idx_push_consent_events_recent
  ON public.push_consent_events (occurred_at DESC);

ALTER TABLE public.push_consent_events ENABLE ROW LEVEL SECURITY;

-- Aucune policy : personne ne lit ni n'écrit directement. Les deux RPC de
-- consentement (SECURITY DEFINER) écrivent, le RPC admin (SECURITY DEFINER) lit.
REVOKE ALL ON public.push_consent_events FROM PUBLIC, anon, authenticated;
GRANT ALL ON public.push_consent_events TO service_role;

-- ---------------------------------------------------------------------------
-- Les deux RPC de consentement, ré-émises avec le journal.
--
-- ⚠️ Le navigateur RE-ENREGISTRE l'abonnement à chaque chargement : logger un
-- `optin` à chaque appel gonflerait KPI-D d'un facteur « nombre de visites ».
-- On ne journalise donc que les VRAIES BASCULES — première ligne pour cet élève,
-- dernière ligne retirée. Le reste du corps est repris à l'identique de
-- 20260613120000 (rebind de l'endpoint compris) : rien d'autre ne change.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.save_push_subscription(
  p_endpoint   TEXT,
  p_p256dh     TEXT,
  p_auth       TEXT,
  p_user_agent TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_had_any BOOLEAN;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT EXISTS (
    SELECT 1 FROM public.push_subscriptions WHERE user_id = v_user
  ) INTO v_had_any;

  INSERT INTO public.push_subscriptions (user_id, endpoint, p256dh, auth, user_agent)
  VALUES (v_user, p_endpoint, p_p256dh, p_auth, p_user_agent)
  ON CONFLICT (endpoint) DO UPDATE
    SET user_id       = v_user,
        p256dh        = EXCLUDED.p256dh,
        auth          = EXCLUDED.auth,
        user_agent    = EXCLUDED.user_agent,
        failure_count = 0;

  -- Une bascule, pas un rafraîchissement.
  IF NOT v_had_any THEN
    INSERT INTO public.push_consent_events (user_id, action) VALUES (v_user, 'optin');
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.save_push_subscription(TEXT, TEXT, TEXT, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.save_push_subscription(TEXT, TEXT, TEXT, TEXT) TO authenticated;

CREATE OR REPLACE FUNCTION public.delete_push_subscription(p_endpoint TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_removed INT;
  v_left    INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  DELETE FROM public.push_subscriptions
  WHERE endpoint = p_endpoint AND user_id = v_user;
  -- ⚠️ `FOUND` après un `SELECT COUNT(*) INTO` vaut toujours vrai (un agrégat
  -- rend une ligne) : le nombre de suppressions se lit ICI, tout de suite.
  GET DIAGNOSTICS v_removed = ROW_COUNT;

  SELECT COUNT(*) INTO v_left
  FROM public.push_subscriptions WHERE user_id = v_user;

  -- Un élève à deux appareils qui en retire un n'a pas coupé les notifications :
  -- l'opt-out, c'est la DERNIÈRE ligne qui part. Et un désabonnement d'un
  -- endpoint inconnu (rejeu, appareil déjà nettoyé) ne journalise rien.
  IF v_removed > 0 AND v_left = 0 THEN
    INSERT INTO public.push_consent_events (user_id, action) VALUES (v_user, 'optout');
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.delete_push_subscription(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.delete_push_subscription(TEXT) TO authenticated;

-- ===========================================================================
-- 2. `eng_activity_days` — LE fait élémentaire : « cet élève a été actif ce
--    jour-là ». Tout le reste (CURR, cohortes, DAU/WAU) en découle.
--
--    « Actif » = au moins une tentative terminée **ou** un pouls d'apprentissage
--    (é31 §3.2). Les deux, pas seulement `attempts` : un élève qui lit un cours
--    vingt minutes sans terminer d'exercice EST revenu — le compter absent
--    ferait mentir la rétention dans le sens qui arrange, ce qui est exactement
--    ce que R-1 interdit.
--
--    Le pouls `browse` est EXCLU : naviguer dans le catalogue n'est pas de
--    l'apprentissage (la table le dit elle-même : « hors apprentissage »), et une
--    rétention gonflée par des ouvertures d'app sans pratique serait la métrique
--    de vanité que RISK-1 dénonce.
-- ===========================================================================
CREATE OR REPLACE VIEW public.eng_activity_days AS
SELECT u.user_id, u.day
FROM (
  SELECT
    a.user_id,
    (a.completed_at AT TIME ZONE 'Africa/Tunis')::date AS day
  FROM public.attempts a
  WHERE a.completed_at IS NOT NULL
  UNION
  SELECT
    p.user_id,
    (p.occurred_at AT TIME ZONE 'Africa/Tunis')::date AS day
  FROM public.learning_pulses p
  WHERE p.surface <> 'browse'
) u
-- Le parc mesuré, ce sont les ÉLÈVES : un compte admin qui rejoue un exercice
-- pour vérifier un contenu n'est pas un retour à mesurer, et il pèserait lourd
-- sur une base à deux chiffres. Même population que les cohortes et les séries.
JOIN public.profiles pr ON pr.id = u.user_id AND pr.role = 'student';

-- ===========================================================================
-- 3. `eng_activity_weeks` — le même fait, au grain de la semaine ISO de Tunis.
--    C'est l'unité de la CURR (KPI-A) : é26 KPI-4 définit le retour comme
--    « actif en semaine N, revenu en semaine N+1 ».
-- ===========================================================================
CREATE OR REPLACE VIEW public.eng_activity_weeks AS
SELECT DISTINCT
  d.user_id,
  date_trunc('week', d.day)::date AS week_start
FROM public.eng_activity_days d;

REVOKE ALL ON public.eng_activity_days  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.eng_activity_weeks FROM PUBLIC, anon, authenticated;

-- ===========================================================================
-- 4. Le RPC admin — une seule porte, un seul JSONB, une section par KPI.
--
--    R-2 (é09, repris ici) : QUE DES AGRÉGATS. Aucun `user_id` ne sort de cette
--    fonction. Les vues en portent pour pouvoir intersecter des semaines, pas
--    pour être exposées.
-- ===========================================================================
CREATE OR REPLACE FUNCTION public.admin_engagement_overview()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_out          JSONB;
  v_today        DATE := (now() AT TIME ZONE 'Africa/Tunis')::date;
  v_week         DATE := public.app_current_week_start();
  -- La série se lit sur l'horloge d'`award_xp` (UTC), pas sur celle des semaines.
  v_utc_today    DATE := CURRENT_DATE;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  WITH
  -- --- KPI-A : la CURR maison (é26 KPI-4). -------------------------------
  -- Huit semaines TERMINÉES et MESURABLES : une semaine n'a de CURR que si sa
  -- SUIVANTE est elle-même finie. La semaine en cours et la précédente sont donc
  -- hors série — publier « 0 % » sur une semaine encore ouverte serait un faux
  -- chiffre, pas un chiffre prudent.
  weeks AS (
    SELECT generate_series(v_week - INTERVAL '9 weeks', v_week - INTERVAL '2 weeks',
                           INTERVAL '1 week')::date AS week_start
  ),
  curr AS (
    SELECT
      w.week_start,
      (SELECT COUNT(*) FROM public.eng_activity_weeks a
        WHERE a.week_start = w.week_start)::int AS active,
      (SELECT COUNT(*) FROM public.eng_activity_weeks a
        WHERE a.week_start = w.week_start
          AND EXISTS (
            SELECT 1 FROM public.eng_activity_weeks n
             WHERE n.user_id = a.user_id
               AND n.week_start = w.week_start + 7
          ))::int AS returned
    FROM weeks w
  ),
  -- --- KPI-B : rétention par cohorte d'inscription. ----------------------
  -- DÉFINITION ARRÊTÉE ICI (et affichée sur la page) : D-N = « revenu au moins
  -- une fois entre J+1 et J+N après l'inscription ». C'est la lecture par
  -- FENÊTRE, pas par jour exact. Deux raisons : à ce volume, un « exactement le
  -- 30ᵉ jour » ne mesurerait que du bruit ; et la fenêtre est monotone
  -- (D1 ≤ D7 ≤ D30), donc un calcul cassé se voit à l'œil nu.
  -- Le jour de l'inscription lui-même n'entre pas : sinon tout élève qui joue sa
  -- première quête serait « retenu » à J+1, et la courbe dirait 100 %.
  members AS (
    SELECT
      p.id AS user_id,
      (p.created_at AT TIME ZONE 'Africa/Tunis')::date AS signup_day,
      date_trunc('week', (p.created_at AT TIME ZONE 'Africa/Tunis')::date)::date AS cohort_week
    FROM public.profiles p
    WHERE p.role = 'student'
      AND (p.created_at AT TIME ZONE 'Africa/Tunis')::date >= v_week - INTERVAL '8 weeks'
  ),
  cohort_flags AS (
    SELECT
      m.cohort_week,
      m.user_id,
      -- Mesurable = la fenêtre est ENTIÈREMENT écoulée. Un compte de la semaine
      -- dernière ne peut pas avoir « raté » son J+30 ; le compter comme perdu
      -- écraserait la cohorte à zéro et ferait paniquer sur une donnée absente.
      (m.signup_day + 1  < v_today) AS d1_measurable,
      (m.signup_day + 7  < v_today) AS d7_measurable,
      (m.signup_day + 30 < v_today) AS d30_measurable,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 1)  AS d1_back,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 7)  AS d7_back,
      EXISTS (SELECT 1 FROM public.eng_activity_days d
               WHERE d.user_id = m.user_id
                 AND d.day > m.signup_day AND d.day <= m.signup_day + 30) AS d30_back
    FROM members m
  ),
  cohorts AS (
    SELECT
      c.cohort_week,
      COUNT(*)::int AS size,
      COUNT(*) FILTER (WHERE c.d1_measurable)::int  AS d1_base,
      COUNT(*) FILTER (WHERE c.d7_measurable)::int  AS d7_base,
      COUNT(*) FILTER (WHERE c.d30_measurable)::int AS d30_base,
      COUNT(*) FILTER (WHERE c.d1_measurable  AND c.d1_back)::int  AS d1_back,
      COUNT(*) FILTER (WHERE c.d7_measurable  AND c.d7_back)::int  AS d7_back,
      COUNT(*) FILTER (WHERE c.d30_measurable AND c.d30_back)::int AS d30_back
    FROM cohort_flags c
    GROUP BY c.cohort_week
  ),
  -- --- Activité brute : DAU / WAU / MAU + la courbe des 14 derniers jours. --
  daily AS (
    SELECT
      g.day::date AS day,
      (SELECT COUNT(*) FROM public.eng_activity_days d WHERE d.day = g.day::date)::int AS actives
    FROM generate_series(v_today - 13, v_today, INTERVAL '1 day') g(day)
  ),
  -- --- KPI-C : la série, telle qu'elle est VRAIMENT. ---------------------
  -- `profiles.current_streak` n'est réécrit que par `award_xp` : un élève parti
  -- depuis dix jours porte encore « 12 ». Lire la colonne brute publierait donc
  -- des séries de fantômes. La série EFFECTIVE vaut la colonne tant que
  -- `last_active_date` est aujourd'hui ou hier (la journée n'est pas finie),
  -- et zéro sinon. Même règle que la bannière de rachat (lot 3).
  streaks AS (
    SELECT
      CASE
        WHEN p.last_active_date IS NULL THEN 0
        WHEN p.last_active_date >= v_utc_today - 1 THEN p.current_streak
        ELSE 0
      END AS effective_streak,
      EXISTS (
        SELECT 1 FROM public.eng_activity_days d
         WHERE d.user_id = p.id AND d.day > v_today - 7
      ) AS active_7d
    FROM public.profiles p
    WHERE p.role = 'student'
  ),
  -- --- KPI-D : le consentement push, ses deux sens. ----------------------
  push AS (
    SELECT
      (SELECT COUNT(DISTINCT s.user_id) FROM public.push_subscriptions s)::int AS optin_students,
      (SELECT COUNT(*) FROM public.push_subscriptions)::int                    AS subscriptions,
      (SELECT COUNT(DISTINCT e.user_id) FROM public.push_consent_events e
        WHERE e.action = 'optin'  AND e.occurred_at >= now() - INTERVAL '30 days')::int AS optin_30d,
      (SELECT COUNT(DISTINCT e.user_id) FROM public.push_consent_events e
        WHERE e.action = 'optout' AND e.occurred_at >= now() - INTERVAL '30 days')::int AS optout_30d
  ),
  -- --- KPI-E : LA MÉTRIQUE DE GARDE (R-1). -------------------------------
  -- Précision et progression, publiées à côté de l'engagement. Si l'engagement
  -- monte et que ces deux-là baissent, l'étude a échoué — et ça se lit sur le
  -- même écran, pas dans un rapport séparé qu'on ne relit jamais.
  active_30d AS (
    SELECT DISTINCT d.user_id FROM public.eng_activity_days d
     WHERE d.day > v_today - 30
  ),
  accuracy AS (
    SELECT
      AVG(a.score_pct)::numeric(6, 2)                                        AS avg_pct,
      percentile_cont(0.5) WITHIN GROUP (ORDER BY a.score_pct)::numeric(6, 2) AS p50_pct,
      COUNT(*)::int                                                          AS attempts
    FROM public.attempts a
    WHERE a.completed_at >= now() - INTERVAL '30 days'
      AND a.variant = 'classic'
  ),
  -- Chapitre COMPLÉTÉ : la définition canonique de `get_user_parcours_progress`
  -- (é22 R-15/R-16), rejouée en ensemble au lieu d'être rescopée sur un élève.
  -- On part des chapitres RÉELLEMENT touchés : un chapitre publié porte au moins
  -- une mission obligatoire, donc sans tentative il ne peut pas être complété —
  -- cadrage qui évite le produit cartésien élèves × catalogue.
  touched AS (
    SELECT DISTINCT a.user_id, e.chapter_id
    FROM public.attempts a
    JOIN public.exercises e ON e.id = a.exercise_id
    JOIN active_30d ac ON ac.user_id = a.user_id
    WHERE e.chapter_id IS NOT NULL
  ),
  chapter_gate AS (
    SELECT
      t.user_id,
      t.chapter_id,
      (s.grade_id IS NOT NULL AND q.id IS NOT NULL) AS quiz_gated,
      q.id AS quiz_id
    FROM touched t
    JOIN public.chapters c ON c.id = t.chapter_id
    JOIN public.subjects s ON s.id = c.subject_id
    LEFT JOIN LATERAL (
      SELECT e.id FROM public.exercises e
       WHERE e.chapter_id = t.chapter_id AND e.mode = 'quiz' LIMIT 1
    ) q ON TRUE
    WHERE EXISTS (
      SELECT 1 FROM public.exercises e
       WHERE e.chapter_id = t.chapter_id
         AND e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz'
    )
  ),
  chapters_done AS (
    SELECT g.user_id, COUNT(*)::int AS chapters
    FROM chapter_gate g
    WHERE (
      NOT g.quiz_gated
      OR EXISTS (
        SELECT 1 FROM public.attempts a
         WHERE a.user_id = g.user_id AND a.exercise_id = g.quiz_id
           AND a.score_pct >= 80
           AND a.duration_seconds >= a.total_count * 4
      )
    )
    AND NOT EXISTS (
      SELECT 1 FROM public.exercises e
       WHERE e.chapter_id = g.chapter_id
         AND e.source = 'admin' AND e.mode IS DISTINCT FROM 'quiz'
         AND NOT EXISTS (
           SELECT 1 FROM public.attempts a
            WHERE a.user_id = g.user_id AND a.exercise_id = e.id
              AND a.variant = 'classic' AND a.score_pct >= 60
         )
    )
    GROUP BY g.user_id
  )
  SELECT jsonb_build_object(
    'curr', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'week_start', c.week_start,
        'active',     c.active,
        'returned',   c.returned,
        'curr_pct',   CASE WHEN c.active > 0
                        THEN ROUND(100.0 * c.returned / c.active, 1)
                        ELSE NULL END
      ) ORDER BY c.week_start), '[]'::jsonb)
      FROM curr c
    ),
    'cohorts', (
      SELECT COALESCE(jsonb_agg(jsonb_build_object(
        'cohort_week', k.cohort_week,
        'size',        k.size,
        'd1_base',     k.d1_base,  'd1_back',  k.d1_back,
        'd7_base',     k.d7_base,  'd7_back',  k.d7_back,
        'd30_base',    k.d30_base, 'd30_back', k.d30_back,
        -- NULL, pas 0, quand la fenêtre n'est pas écoulée : « pas encore
        -- mesurable » et « personne n'est revenu » ne se ressemblent pas.
        'd1_pct',  CASE WHEN k.d1_base  > 0 THEN ROUND(100.0 * k.d1_back  / k.d1_base,  1) END,
        'd7_pct',  CASE WHEN k.d7_base  > 0 THEN ROUND(100.0 * k.d7_back  / k.d7_base,  1) END,
        'd30_pct', CASE WHEN k.d30_base > 0 THEN ROUND(100.0 * k.d30_back / k.d30_base, 1) END
      ) ORDER BY k.cohort_week), '[]'::jsonb)
      FROM cohorts k
    ),
    'activity', jsonb_build_object(
      'dau', (SELECT COUNT(*) FROM public.eng_activity_days d WHERE d.day = v_today),
      'wau', (SELECT COUNT(DISTINCT d.user_id) FROM public.eng_activity_days d
               WHERE d.day > v_today - 7),
      'mau', (SELECT COUNT(*) FROM active_30d),
      'daily', (SELECT COALESCE(jsonb_agg(jsonb_build_object('day', d.day, 'actives', d.actives)
                                          ORDER BY d.day), '[]'::jsonb) FROM daily d)
    ),
    'streaks', jsonb_build_object(
      'students',   (SELECT COUNT(*) FROM streaks),
      'b0',         (SELECT COUNT(*) FROM streaks WHERE effective_streak = 0),
      'b1_6',       (SELECT COUNT(*) FROM streaks WHERE effective_streak BETWEEN 1 AND 6),
      'b7_29',      (SELECT COUNT(*) FROM streaks WHERE effective_streak BETWEEN 7 AND 29),
      'b30_plus',   (SELECT COUNT(*) FROM streaks WHERE effective_streak >= 30),
      -- KPI-C : la part des ACTIFS HEBDO qui tiennent une série de 7 jours ou plus.
      'weekly_active',       (SELECT COUNT(*) FROM streaks WHERE active_7d),
      'weekly_active_7plus', (SELECT COUNT(*) FROM streaks WHERE active_7d AND effective_streak >= 7)
    ),
    'push', (
      SELECT jsonb_build_object(
        'optin_students', p.optin_students,
        'subscriptions',  p.subscriptions,
        'optin_30d',      p.optin_30d,
        'optout_30d',     p.optout_30d,
        'students_total', (SELECT COUNT(*) FROM public.profiles WHERE role = 'student'),
        -- Taux d'opt-out mensuel = coupures / base exposée (abonnés encore là +
        -- ceux qui viennent de partir). Garde-fou R-4 : < 5 %.
        'optout_pct', CASE
          WHEN (p.optin_students + p.optout_30d) > 0
            THEN ROUND(100.0 * p.optout_30d / (p.optin_students + p.optout_30d), 1)
          ELSE NULL END
      ) FROM push p
    ),
    'learning', jsonb_build_object(
      'active_30d',          (SELECT COUNT(*) FROM active_30d),
      'accuracy_avg_pct',    (SELECT avg_pct  FROM accuracy),
      'accuracy_p50_pct',    (SELECT p50_pct  FROM accuracy),
      'attempts_30d',        (SELECT attempts FROM accuracy),
      'chapters_completed',  (SELECT COALESCE(SUM(chapters), 0) FROM chapters_done),
      'chapters_per_active', CASE
        WHEN (SELECT COUNT(*) FROM active_30d) > 0
          THEN ROUND((SELECT COALESCE(SUM(chapters), 0) FROM chapters_done)::numeric
                     / (SELECT COUNT(*) FROM active_30d), 2)
        ELSE NULL END
    ),
    'notes', jsonb_build_object(
      'generated_at',    now(),
      'week_timezone',   'Africa/Tunis',
      'streak_clock',    'UTC (award_xp)',
      'retention_rule',  'window',
      'activity_rule',   'attempts + learning_pulses hors browse',
      'current_week',    v_week
    )
  ) INTO v_out;

  RETURN v_out;
END;
$$;

REVOKE ALL ON FUNCTION public.admin_engagement_overview() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_engagement_overview() TO authenticated;

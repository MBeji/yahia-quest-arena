-- Étude 04 — lot A2, socle : R-2 CESSE D'ÊTRE RECOPIÉ.
--
-- LE PROBLÈME QUE CETTE MIGRATION RÉSOUT AVANT D'AJOUTER QUOI QUE CE SOIT
-- ---------------------------------------------------------------------------
-- R-2 dit : « une misconception est ACTIVE à partir de 3 occurrences du même tag
-- sur ≥ 2 sessions dans les 30 derniers jours (constantes CENTRALISÉES,
-- ajustables) ». Les constantes n'ont jamais été centralisées : le triplet
-- (3, 2, 30 jours) est écrit à la main dans `get_daily_plan` (deux révisions,
-- dont une vivante) et dans `get_tutor_learner_context` (é11 lot 1, hier).
--
-- Le lot A2.1 en aurait fait une quatrième copie, et A2.2 une cinquième. Un seuil
-- pédagogique dupliqué cinq fois n'est plus ajustable : le jour où Mohamed veut
-- passer à 4 occurrences, quatre des cinq surfaces le suivront et la cinquième
-- dira autre chose au même élève, sans que rien ne rougisse.
--
-- D'où l'ordre de cette PR : le socle D'ABORD, les deux surfaces ensuite.
--
-- CE QUI NE CHANGE PAS, ET COMMENT ON LE PROUVE
-- ---------------------------------------------------------------------------
-- `get_daily_plan` est réécrite ici, mais son COMPORTEMENT est identique : le
-- CTE `active_tags` devient un appel à la fonction canonique, tout le reste est
-- le texte de la révision vivante (`20260725140000`), substitué et non retapé.
-- La preuve est la suite pgTAP existante `35_daily_plan.test.sql` (16 assertions
-- sur la sélection, l'ordre, le seuil R-2 et la porte d'accès) : elle doit rester
-- verte sans qu'une seule ligne n'y soit touchée. Si elle bouge, la réécriture
-- est fausse — c'est exactement à ça qu'elle sert.

-- ---------------------------------------------------------------------------
-- 1. Les constantes de R-2, à UN seul endroit.
-- ---------------------------------------------------------------------------
-- Une fonction IMMUTABLE plutôt qu'une table de configuration : ces trois
-- nombres sont une décision d'étude, pas un réglage d'exploitation. Les changer
-- doit demander une migration — donc une revue — et non un UPDATE en base que
-- personne ne relit.
CREATE OR REPLACE FUNCTION public.misconception_active_thresholds()
RETURNS TABLE (min_occurrences INT, min_sessions INT, window_days INT)
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT 3, 2, 30;
$$;

COMMENT ON FUNCTION public.misconception_active_thresholds() IS
  'Étude 04 R-2 : les trois constantes du seuil « erreur active », à un seul endroit. Les changer demande une migration, donc une revue.';

REVOKE EXECUTE ON FUNCTION public.misconception_active_thresholds() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.misconception_active_thresholds() TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. La définition canonique d'une erreur ACTIVE.
-- ---------------------------------------------------------------------------
-- Prend l'élève en paramètre plutôt que de lire `auth.uid()` : la fonction est
-- appelée depuis du SECURITY INVOKER (`get_daily_plan`) ET du SECURITY DEFINER
-- (le tuteur, le rapport parent). Un `auth.uid()` interne serait juste dans le
-- premier cas et faux dans le troisième — le parent n'est pas l'élève.
--
-- SECURITY INVOKER : elle ne contourne aucune RLS. Depuis `get_daily_plan`, la
-- policy « Users read own misconceptions » s'applique comme avant ; depuis un
-- DEFINER, l'appelant a déjà vérifié le droit de regarder cet élève, et le
-- filtre `user_id = p_user` reste explicite ici.
CREATE OR REPLACE FUNCTION public.active_misconceptions(p_user UUID)
RETURNS TABLE (
  tag           TEXT,
  occurrences   INT,
  sessions_seen INT,
  last_seen_at  TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  SELECT um.tag, um.occurrences, um.sessions_seen, um.last_seen_at
    FROM public.user_misconceptions um,
         public.misconception_active_thresholds() t
   WHERE um.user_id = p_user
     AND um.occurrences   >= t.min_occurrences
     AND um.sessions_seen >= t.min_sessions
     AND um.last_seen_at  >= now() - make_interval(days => t.window_days);
$$;

COMMENT ON FUNCTION public.active_misconceptions(UUID) IS
  'Étude 04 R-2 : les erreurs ACTIVES d''un élève — installées, reproduites, récentes. Source unique ; toute surface qui filtre elle-même les seuils est un bug.';

REVOKE EXECUTE ON FUNCTION public.active_misconceptions(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.active_misconceptions(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. `get_daily_plan` — MÊME corps, le CTE en moins.
-- ---------------------------------------------------------------------------
-- Texte de la révision vivante `20260725140000_daily_plan_competency_aware.sql`,
-- à une substitution près (le CTE `active_tags`). Non-régression prouvée par
-- `35_daily_plan.test.sql`, inchangée.
CREATE OR REPLACE FUNCTION public.get_daily_plan(p_limit INT DEFAULT 3)
RETURNS TABLE (
  exercise_id    UUID,
  chapter_id     UUID,
  subject_id     TEXT,
  exercise_title TEXT,
  chapter_title  TEXT,
  days_overdue   INT,
  weak_tags      INT,
  is_fallback    BOOLEAN
)
LANGUAGE sql
STABLE
SECURITY INVOKER
SET search_path = public
AS $$
  -- Les révisions ÉCHUES, une ligne par exercice : un même exercice peut porter plusieurs
  -- échéances ouvertes (le cycle 1j/3j/7j en pose trois d'un coup), et c'est la plus ancienne
  -- qui dit depuis quand la mémoire décroche.
  WITH due AS (
    SELECT s.exercise_id AS ex_id,
           max(EXTRACT(EPOCH FROM (now() - s.scheduled_for)) / 86400.0) AS overdue_days
      FROM public.spaced_repetition_schedule s
     WHERE s.user_id = (SELECT auth.uid())
       AND s.status = 'pending'
       AND s.scheduled_for <= now()
     GROUP BY s.exercise_id
  ),
  -- Seuil R-2 : INCHANGÉ, mais il ne vit plus ici. `active_misconceptions` porte désormais
  -- les trois constantes pour toutes les surfaces à la fois — c'est la seule différence
  -- entre cette révision et la précédente, et `35_daily_plan.test.sql` en est la preuve.
  active_tags AS (
    SELECT am.tag FROM public.active_misconceptions((SELECT auth.uid())) am
  ),
  -- Où ces erreurs ont-elles été commises ? `question_attempts.chapter_id` est dénormalisé
  -- exactement pour cette agrégation (A0.1).
  weak AS (
    SELECT qa.chapter_id AS chap_id,
           count(DISTINCT qa.misconception_tag)::int AS tags
      FROM public.question_attempts qa
      JOIN active_tags t ON t.tag = qa.misconception_tag
     WHERE qa.user_id = (SELECT auth.uid())
       AND qa.created_at >= now() - INTERVAL '30 days'
     GROUP BY qa.chapter_id
  ),
  -- Étude 07 lot 5 (US-3) : le maillon faible de chaque exercice dû. Borné aux exercices de
  -- `due` — on ne balaie jamais tout le catalogue taggé pour classer trois révisions. Un
  -- exercice sans question taggée, ou dont aucune compétence n'a encore de maîtrise, n'a
  -- simplement pas de ligne ici : le LEFT JOIN plus bas le laisse neutre.
  competency_floor AS (
    SELECT q.exercise_id AS ex_id,
           min(public.competency_mastery_with_decay(m.mastery, m.last_attempt_at)) AS weakest
      FROM public.questions q
      JOIN public.question_competencies qc ON qc.question_id = q.id
      JOIN public.user_competency_mastery m ON m.competency_id = qc.competency_id
     WHERE m.user_id = (SELECT auth.uid())
       AND q.exercise_id IN (SELECT d.ex_id FROM due d)
     GROUP BY q.exercise_id
  ),
  scored AS (
    SELECT e.id AS ex_id,
           e.chapter_id AS chap_id,
           e.subject_id AS subj_id,
           e.title AS ex_title,
           c.title AS chap_title,
           floor(d.overdue_days)::int AS overdue_int,
           COALESCE(w.tags, 0) AS tag_count,
           LEAST(d.overdue_days, 30) / 30.0
             + 0.5 * LEAST(COALESCE(w.tags, 0), 3) / 3.0
             -- Faiblesse de compétence : nulle au-dessus du seuil d'échec (50), maximale à 0.
             -- `GREATEST(0, …)` fait le clip par le haut, `COALESCE(…, 50)` le neutre du
             -- non-taggé — les deux dans la même expression, pour que le terme se lise d'un
             -- trait avec les deux autres.
             + 0.5 * GREATEST(0, 50 - COALESCE(cf.weakest, 50)) / 50.0 AS score
      FROM due d
      JOIN public.exercises e ON e.id = d.ex_id
      JOIN public.chapters c ON c.id = e.chapter_id
      LEFT JOIN weak w ON w.chap_id = e.chapter_id
      LEFT JOIN competency_floor cf ON cf.ex_id = d.ex_id
     ORDER BY score DESC, d.overdue_days DESC, e.id
     -- Quatre fois le plafond : de quoi absorber les verrous et les doublons de repli sans
     -- soumettre TOUT l'arriéré d'un élève à la porte d'accès.
     LIMIT GREATEST(LEAST(COALESCE(p_limit, 3), 3), 0) * 4
  ),
  gated AS (
    SELECT s.*, acc.allowed
      FROM scored s
      CROSS JOIN LATERAL public.resolve_exercise_access(s.ex_id) acc
  ),
  resolved AS (
    SELECT g.chap_id, g.subj_id, g.chap_title, g.overdue_int, g.tag_count, g.score,
           COALESCE(CASE WHEN g.allowed THEN g.ex_id END, fb.id) AS final_id,
           COALESCE(CASE WHEN g.allowed THEN g.ex_title END, fb.title) AS final_title,
           NOT g.allowed AS fallback_used
      FROM gated g
      LEFT JOIN LATERAL (
        SELECT x.id, x.title
          FROM public.exercises x
         WHERE NOT g.allowed
           AND x.chapter_id = g.chap_id
           AND x.id <> g.ex_id
           AND x.source = 'admin'
           -- Le quiz de compréhension est la PORTE du chapitre, pas une révision : il reste
           -- hors du repli même si l'aperçu gratuit l'ouvre.
           AND x.mode IS DISTINCT FROM 'quiz'
           AND x.difficulty <= 2
           AND (SELECT a.allowed FROM public.resolve_exercise_access(x.id) a)
         ORDER BY x.difficulty, x.display_order, x.id
         LIMIT 1
      ) fb ON true
  ),
  -- Deux exercices verrouillés du même chapitre retombent sur le même repli : sans ce
  -- DISTINCT, le plan proposerait deux fois la même mission.
  picked AS (
    SELECT DISTINCT ON (r.final_id) r.*
      FROM resolved r
     WHERE r.final_id IS NOT NULL
     ORDER BY r.final_id, r.score DESC
  )
  SELECT p.final_id, p.chap_id, p.subj_id, p.final_title, p.chap_title,
         p.overdue_int, p.tag_count, p.fallback_used
    FROM picked p
   -- R-4 : trois, jamais plus, quoi que demande l'appelant.
   ORDER BY p.score DESC, p.overdue_int DESC, p.final_id
   LIMIT GREATEST(LEAST(COALESCE(p_limit, 3), 3), 0);
$$;

REVOKE EXECUTE ON FUNCTION public.get_daily_plan(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_daily_plan(INT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. `get_tutor_learner_context` — le second appelant vivant, rebranché.
-- ---------------------------------------------------------------------------
-- Texte de la révision d'hier (`20260822231000`), à une substitution près : le
-- filtre R-2 recopié devient un appel à `active_misconceptions`. Après cette
-- migration, le triplet (3, 2, 30 jours) n'existe plus qu'à UN endroit dans
-- toute la base — c'est ce que R-2 demandait depuis le premier jour.
CREATE OR REPLACE FUNCTION public.get_tutor_learner_context()
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_p    RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  SELECT p.level, p.current_streak, p.current_grade_id, g.slug AS grade_slug,
         COALESCE(g.is_concours_national, false) AS is_concours
    INTO v_p
    FROM public.profiles p
    LEFT JOIN public.grades g ON g.id = p.current_grade_id
   WHERE p.id = v_user;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'NO_PROFILE';
  END IF;

  RETURN jsonb_build_object(
    'grade_slug', v_p.grade_slug,
    'age_band',   public.tutor_age_band(v_p.current_grade_id),
    'goal',       CASE WHEN v_p.is_concours THEN 'concours' ELSE 'scolaire' END,
    -- Le niveau de jeu en bucket : « 12 » n'apprend rien au modèle que
    -- « débutant / confirmé » n'apprenne mieux, et il change tous les jours.
    'level_band', CASE WHEN v_p.level <= 5 THEN 'debutant'
                       WHEN v_p.level <= 15 THEN 'confirme'
                       ELSE 'avance' END,
    'streak_band', CASE WHEN v_p.current_streak = 0 THEN 'aucune'
                        WHEN v_p.current_streak < 7 THEN 'courte'
                        ELSE 'longue' END,
    -- Les erreurs ACTIVES, au sens de é04 R-2 : ≥ 3 occurrences sur ≥ 2
    -- sessions dans les 30 jours. Top 3, avec leurs libellés élève.
    'active_misconceptions', COALESCE((
      SELECT jsonb_agg(x ORDER BY x->>'occurrences' DESC)
        FROM (
          SELECT jsonb_build_object(
                   'tag', um.tag,
                   'occurrences', um.occurrences,
                   'label_fr', m.label_fr,
                   'label_en', m.label_en,
                   'label_ar', m.label_ar
                 ) AS x
            FROM public.active_misconceptions(v_user) um
            LEFT JOIN public.misconceptions m ON m.tag = um.tag
           ORDER BY um.occurrences DESC
           LIMIT 3
        ) t
    ), '[]'::jsonb),
    -- Les préférences, si l'élève en a posé. Absentes = défauts, jamais une
    -- erreur : un tuteur doit savoir parler à quelqu'un qui n'a rien réglé.
    'interests', COALESCE((SELECT tp.interests FROM public.tutor_prefs tp WHERE tp.user_id = v_user), '{}'),
    'verbosity', COALESCE((SELECT tp.verbosity FROM public.tutor_prefs tp WHERE tp.user_id = v_user), 'normale')
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_tutor_learner_context() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_learner_context() TO authenticated;

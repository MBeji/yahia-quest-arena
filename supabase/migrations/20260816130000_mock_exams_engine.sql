-- Étude 02 — examen blanc, lot 2 : le moteur de session, en SQL.
--
-- Le scoring du projet vit en SQL (`submit_exercise_attempt`, `submit_duel_answer`,
-- `check_answers`) et il n'y a aucune raison d'ouvrir un second chemin en TypeScript
-- pour l'examen : les six RPC ci-dessous réutilisent `score_answer` / `answer_key_display`,
-- les MÊMES primitives qui corrigent une quête. Une réponse ne peut donc pas être
-- jugée différemment selon l'écran qui la pose.
--
-- LES QUATRE INVARIANTS QUE CE FICHIER TIENT
--
--   R-2  La deadline est SERVEUR. `save_mock_answers` refuse après l'heure, et
--        `finish_mock_exam` fige `finished_at = LEAST(now(), deadline)` : rendre en
--        retard ne vole pas de temps, ça tronque aux réponses déjà enregistrées.
--        Chaque payload emporte `serverNow` pour que le chrono du client se cale sur
--        l'horloge du serveur au lieu de celle du poste.
--
--   R-3  Aucune clé pendant l'épreuve. `start_mock_exam` construit son JSON à la
--        main et n'y met NI `correct_option`, NI `answer_key`, NI `explanation`.
--        C'est la différence avec `get_dungeon_questions`, qui envoie l'explication
--        d'avance — acceptable pour un donjon à une vie, inacceptable ici : la
--        review ne s'ouvre qu'à l'état `finished`, par `get_mock_exam_review`.
--
--   R-4  Une seule session CLASSÉE par (examen, élève) — tenue par l'index partiel
--        du lot 1, pas par une convention. Les reprises sont `practice` : ni XP, ni
--        classement. Un examen blanc qu'on peut refaire pour améliorer son rang ne
--        mesure plus rien.
--
--   R-8  Les réponses sont écrites au fil de l'eau et la fusion est idempotente
--        (`answers || patch`). Un rafraîchissement, une coupure réseau ou un double
--        envoi ne perdent rien et ne dupliquent rien.
--
-- CE QUE LE BARÈME PRODUIT. Chaque épreuve rapporte `points × (justes / total)`,
-- donc une matière à coefficient 4 pèse quatre fois une matière à coefficient 1 —
-- comme au concours. La note /20 est `20 × score / max`, la seule échelle que
-- l'élève et le parent savent lire ; le pourcentage sert à l'économie de jeu.
--
-- RÉCOMPENSE (répond à la Q-1 de l'étude par sa propre proposition, faute d'un
-- arbitrage humain : 300 XP et 60 pièces × le score, session classée seulement).
-- Ancrage : un exercice complet vaut ≈ 75 XP / 15 pièces, un blanc en vaut cinq à
-- six et se joue une fois par mois. La valeur est mirrorée dans
-- `src/shared/constants/gamification.ts` — ici c'est la garde, là-bas l'affichage.

-- ---------------------------------------------------------------------------
-- 1. Le catalogue : mes examens et mon historique.
--
-- INVOKER, pas DEFINER : la RLS du lot 1 fait déjà exactement le tri voulu
-- (examens publiés, mes sessions à moi). Une fonction DEFINER ici n'ajouterait
-- qu'un contournement de RLS à maintenir.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.list_mock_exams(p_parcours_id TEXT DEFAULT NULL)
RETURNS JSONB
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', e.id,
        'parcoursId', e.parcours_id,
        'titleFr', e.title_fr,
        'titleEn', e.title_en,
        'titleAr', e.title_ar,
        'durationMinutes', e.duration_minutes,
        'paperCount', (
          SELECT count(*) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id
        ),
        'maxPoints', COALESCE((
          SELECT sum(pp.points) FROM public.mock_exam_papers pp WHERE pp.exam_id = e.id
        ), 0),
        'mySessions', COALESCE((
          SELECT jsonb_agg(
                   jsonb_build_object(
                     'id', s.id,
                     'kind', s.kind,
                     'startedAt', s.started_at,
                     'deadline', s.deadline,
                     'finishedAt', s.finished_at,
                     'scorePoints', s.score_points,
                     'maxPoints', s.max_points
                   ) ORDER BY s.started_at DESC
                 )
          FROM public.mock_exam_sessions s
          WHERE s.exam_id = e.id AND s.user_id = (SELECT auth.uid())
        ), '[]'::jsonb)
      ) ORDER BY e.display_order, e.created_at
    ),
    '[]'::jsonb
  )
  FROM public.mock_exams e
  WHERE e.status = 'published'
    AND (p_parcours_id IS NULL OR e.parcours_id = p_parcours_id);
$$;

-- ---------------------------------------------------------------------------
-- 2. Ouvrir (ou reprendre) une session.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.start_mock_exam(p_exam_id UUID, p_kind TEXT DEFAULT 'ranked')
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_exam    public.mock_exams%ROWTYPE;
  v_session public.mock_exam_sessions%ROWTYPE;
  v_papers  INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_kind IS NULL OR p_kind NOT IN ('ranked', 'practice') THEN
    RAISE EXCEPTION 'Invalid session kind';
  END IF;

  SELECT * INTO v_exam
    FROM public.mock_exams
   WHERE id = p_exam_id AND status = 'published';
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_NOT_FOUND';
  END IF;

  -- Une application de contenu peut avoir emporté les épreuves (CASCADE, lot 1) :
  -- mieux vaut refuser franchement que servir une coquille vide chronométrée.
  SELECT count(*) INTO v_papers
    FROM public.mock_exam_papers WHERE exam_id = p_exam_id;
  IF v_papers = 0 THEN
    RAISE EXCEPTION 'MOCK_EXAM_EMPTY';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE exam_id = p_exam_id AND user_id = v_user AND kind = p_kind
   ORDER BY started_at DESC
   LIMIT 1
     FOR UPDATE;

  IF FOUND THEN
    IF v_session.finished_at IS NOT NULL THEN
      -- R-4 : la classée est jouée une fois. La reprise passe par `practice`,
      -- que le client demande explicitement.
      IF p_kind = 'ranked' THEN
        RAISE EXCEPTION 'MOCK_EXAM_ALREADY_RANKED';
      END IF;
      v_session := NULL;                    -- un entraînement fini : on en rouvre un
    ELSIF p_kind = 'practice' AND now() >= v_session.deadline THEN
      v_session := NULL;                    -- entraînement périmé : idem
    END IF;
    -- Une CLASSÉE non finie est reprise telle quelle, même après la deadline :
    -- le client la trouvera expirée et la rendra (auto-rendu R-2), ce qui vaut
    -- mieux que de lui interdire l'accès à sa propre copie.
  END IF;

  IF v_session.id IS NULL THEN
    BEGIN
      INSERT INTO public.mock_exam_sessions (exam_id, user_id, kind, deadline)
      VALUES (
        p_exam_id, v_user, p_kind,
        now() + make_interval(mins => v_exam.duration_minutes)
      )
      RETURNING * INTO v_session;
    EXCEPTION WHEN unique_violation THEN
      -- Deux onglets ont cliqué en même temps : l'index partiel a tranché,
      -- on sert la session gagnante au lieu de renvoyer une erreur.
      SELECT * INTO v_session
        FROM public.mock_exam_sessions
       WHERE exam_id = p_exam_id AND user_id = v_user AND kind = p_kind
       ORDER BY started_at DESC
       LIMIT 1;
    END;
  END IF;

  RETURN jsonb_build_object(
    'session', jsonb_build_object(
      'id', v_session.id,
      'kind', v_session.kind,
      'startedAt', v_session.started_at,
      'deadline', v_session.deadline,
      'finishedAt', v_session.finished_at,
      'answers', v_session.answers
    ),
    'serverNow', now(),
    'exam', jsonb_build_object(
      'id', v_exam.id,
      'parcoursId', v_exam.parcours_id,
      'titleFr', v_exam.title_fr,
      'titleEn', v_exam.title_en,
      'titleAr', v_exam.title_ar,
      'durationMinutes', v_exam.duration_minutes
    ),
    -- R-3 : ni clé, ni explication. Le JSON est construit champ par champ
    -- précisément pour qu'un ajout de colonne ne puisse pas en faire fuir une.
    'papers', COALESCE((
      SELECT jsonb_agg(
               jsonb_build_object(
                 'exerciseId', pp.exercise_id,
                 'labelFr', pp.label_fr,
                 'labelEn', pp.label_en,
                 'labelAr', pp.label_ar,
                 'points', pp.points,
                 'subjectId', ex.subject_id,
                 'questions', COALESCE((
                   SELECT jsonb_agg(
                            jsonb_build_object(
                              'id', q.id,
                              'prompt', q.prompt,
                              'options', q.options,
                              'questionType', q.question_type
                            ) ORDER BY q.display_order, q.id
                          )
                     FROM public.questions q
                    WHERE q.exercise_id = pp.exercise_id
                 ), '[]'::jsonb)
               ) ORDER BY pp.display_order
             )
        FROM public.mock_exam_papers pp
        JOIN public.exercises ex ON ex.id = pp.exercise_id
       WHERE pp.exam_id = p_exam_id
    ), '[]'::jsonb)
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 3. Sauvegarder au fil de l'eau (R-8).
--
-- Le patch est FILTRÉ, pas validé-puis-rejeté : une clé qui ne correspond à
-- aucune question de cet examen est ignorée en silence. Un payload bricolé ne
-- doit ni polluer la copie ni interrompre une épreuve chronométrée en cours.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.save_mock_answers(p_session_id UUID, p_answers JSONB)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_session public.mock_exam_sessions%ROWTYPE;
  v_clean   JSONB;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'object' THEN
    RAISE EXCEPTION 'Invalid answers payload';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE id = p_session_id AND user_id = v_user
     FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_SESSION_NOT_FOUND';
  END IF;
  IF v_session.finished_at IS NOT NULL THEN
    RAISE EXCEPTION 'MOCK_EXAM_FINISHED';
  END IF;
  IF now() >= v_session.deadline THEN
    RAISE EXCEPTION 'MOCK_EXAM_DEADLINE_PASSED';
  END IF;

  SELECT COALESCE(jsonb_object_agg(kv.key, kv.value), '{}'::jsonb)
    INTO v_clean
    FROM jsonb_each_text(p_answers) AS kv(key, value)
   WHERE length(kv.value) BETWEEN 1 AND 512
     AND EXISTS (
       SELECT 1
         FROM public.mock_exam_papers pp
         JOIN public.questions q ON q.exercise_id = pp.exercise_id
        WHERE pp.exam_id = v_session.exam_id
          AND q.id::text = kv.key
     );

  UPDATE public.mock_exam_sessions
     SET answers = answers || v_clean
   WHERE id = p_session_id
   RETURNING * INTO v_session;

  RETURN jsonb_build_object(
    'answered', (SELECT count(*) FROM jsonb_object_keys(v_session.answers)),
    'deadline', v_session.deadline,
    'serverNow', now()
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 4. Rendre la copie et corriger.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.finish_mock_exam(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user      UUID := (SELECT auth.uid());
  v_session   public.mock_exam_sessions%ROWTYPE;
  v_breakdown JSONB;
  v_score     NUMERIC := 0;
  v_max       INT     := 0;
  v_pct       NUMERIC := 0;
  v_xp        INT     := 0;
  v_coins     INT     := 0;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE id = p_session_id AND user_id = v_user
     FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_SESSION_NOT_FOUND';
  END IF;
  IF v_session.finished_at IS NOT NULL THEN
    RAISE EXCEPTION 'MOCK_EXAM_FINISHED';
  END IF;

  -- Une épreuve sans réponse enregistrée vaut zéro, elle ne « plante » pas :
  -- `score_answer(q, NULL)` renvoie false par contrat (20260727120000).
  WITH per_paper AS (
    SELECT
      pp.exercise_id,
      pp.label_fr,
      pp.label_en,
      pp.label_ar,
      pp.points,
      pp.display_order,
      count(q.id)::INT AS total,
      count(*) FILTER (
        WHERE public.score_answer(q, v_session.answers ->> q.id::text)
      )::INT AS correct
    FROM public.mock_exam_papers pp
    JOIN public.questions q ON q.exercise_id = pp.exercise_id
   WHERE pp.exam_id = v_session.exam_id
   GROUP BY pp.exercise_id, pp.label_fr, pp.label_en, pp.label_ar,
            pp.points, pp.display_order
  )
  SELECT
    COALESCE(sum(points * correct::NUMERIC / NULLIF(total, 0)), 0),
    COALESCE(sum(points), 0)::INT,
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'exerciseId', exercise_id,
          'labelFr', label_fr,
          'labelEn', label_en,
          'labelAr', label_ar,
          'points', points,
          'correct', correct,
          'total', total,
          'earned', ROUND(points * correct::NUMERIC / NULLIF(total, 0), 2)
        ) ORDER BY display_order
      ),
      '[]'::jsonb
    )
    INTO v_score, v_max, v_breakdown
    FROM per_paper;

  v_pct := CASE WHEN v_max > 0 THEN ROUND(v_score * 100.0 / v_max, 1) ELSE 0 END;

  UPDATE public.mock_exam_sessions
     SET finished_at  = LEAST(now(), deadline),   -- R-2 : rendre en retard tronque
         score_points = ROUND(v_score, 2),
         max_points   = v_max
   WHERE id = p_session_id
   RETURNING * INTO v_session;

  -- R-5 : versé UNE fois, sur la session classée seulement. `award_xp` porte déjà
  -- le passage de niveau et les badges ; on ne recopie pas cette logique ici.
  IF v_session.kind = 'ranked' THEN
    v_xp    := GREATEST(0, ROUND(300 * v_pct / 100.0)::INT);
    v_coins := GREATEST(0, ROUND(60 * v_pct / 100.0)::INT);
    IF v_xp > 0 THEN
      PERFORM public.award_xp(v_user, v_xp);
    END IF;
    IF v_coins > 0 THEN
      UPDATE public.profiles
         SET yahia_coins = yahia_coins + v_coins
       WHERE id = v_user;
    END IF;
  END IF;

  RETURN jsonb_build_object(
    'sessionId', v_session.id,
    'kind', v_session.kind,
    'finishedAt', v_session.finished_at,
    'scorePoints', v_session.score_points,
    'maxPoints', v_session.max_points,
    'scorePct', v_pct,
    -- La seule échelle que l'élève et le parent savent lire.
    'scoreOn20', CASE WHEN v_max > 0 THEN ROUND(v_score * 20.0 / v_max, 2) ELSE 0 END,
    'xpEarned', v_xp,
    'coinsEarned', v_coins,
    'papers', v_breakdown
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 5. La review — R-3 : après le rendu, jamais avant.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_mock_exam_review(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := (SELECT auth.uid());
  v_session public.mock_exam_sessions%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE id = p_session_id AND user_id = v_user;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_SESSION_NOT_FOUND';
  END IF;
  IF v_session.finished_at IS NULL THEN
    RAISE EXCEPTION 'MOCK_EXAM_NOT_FINISHED';
  END IF;

  RETURN COALESCE((
    SELECT jsonb_agg(
             jsonb_build_object(
               'exerciseId', pp.exercise_id,
               'labelFr', pp.label_fr,
               'labelEn', pp.label_en,
               'labelAr', pp.label_ar,
               'questions', COALESCE((
                 SELECT jsonb_agg(
                          jsonb_build_object(
                            'questionId', q.id,
                            'prompt', q.prompt,
                            'options', q.options,
                            'questionType', q.question_type,
                            'selectedChoice', v_session.answers ->> q.id::text,
                            'isCorrect', public.score_answer(q, v_session.answers ->> q.id::text),
                            'correctChoice', public.answer_key_display(q),
                            'explanation', q.explanation
                          ) ORDER BY q.display_order, q.id
                        )
                   FROM public.questions q
                  WHERE q.exercise_id = pp.exercise_id
               ), '[]'::jsonb)
             ) ORDER BY pp.display_order
           )
      FROM public.mock_exam_papers pp
     WHERE pp.exam_id = v_session.exam_id
  ), '[]'::jsonb);
END;
$$;

-- ---------------------------------------------------------------------------
-- 6. Le percentile (D-3, R-6).
--
-- Affiché à partir de 20 candidats : en dessous, un rang est une anecdote qu'on
-- lirait comme une mesure. Le seuil est mirroré dans les constantes TS.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_mock_exam_percentile(p_session_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user       UUID := (SELECT auth.uid());
  v_session    public.mock_exam_sessions%ROWTYPE;
  v_candidates INT;
  v_below      INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_session
    FROM public.mock_exam_sessions
   WHERE id = p_session_id AND user_id = v_user;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'MOCK_EXAM_SESSION_NOT_FOUND';
  END IF;

  IF v_session.kind <> 'ranked' OR v_session.finished_at IS NULL THEN
    RETURN jsonb_build_object('candidates', 0, 'percentile', NULL, 'minCandidates', 20);
  END IF;

  SELECT
    count(*)::INT,
    count(*) FILTER (WHERE s.score_points < v_session.score_points)::INT
    INTO v_candidates, v_below
    FROM public.mock_exam_sessions s
   WHERE s.exam_id = v_session.exam_id
     AND s.kind = 'ranked'
     AND s.finished_at IS NOT NULL
     AND s.score_points IS NOT NULL;

  RETURN jsonb_build_object(
    'candidates', v_candidates,
    'minCandidates', 20,
    'percentile', CASE
      WHEN v_candidates >= 20 THEN ROUND(v_below * 100.0 / v_candidates, 1)
      ELSE NULL
    END
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- 7. Droits — nominatifs, réservés à l'élève connecté ; rien pour anon.
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION public.list_mock_exams(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.start_mock_exam(UUID, TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.save_mock_answers(UUID, JSONB) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.finish_mock_exam(UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_mock_exam_review(UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_mock_exam_percentile(UUID) FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.list_mock_exams(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.start_mock_exam(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.save_mock_answers(UUID, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION public.finish_mock_exam(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_mock_exam_review(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_mock_exam_percentile(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 8. La première session : « Concours blanc 9ᵉ — session 1 ».
--
-- Composée PAR REQUÊTE, pas par une liste d'UUID en dur — un id d'exercice du
-- corpus ne vit pas dans ce dépôt (étude 24 : le contenu est appliqué depuis le
-- dépôt privé) et une FK littérale vers lui rendrait une base vierge
-- irreconstructible (`db:check-chain`). Ici l'INSERT … SELECT ne rend rien quand
-- le corpus est absent, ce qui est le comportement voulu sur une base neuve.
--
-- LE BARÈME EST CELUI DU CONCOURS : maths 4, arabe 2+2, français 3, sciences 3
-- (physique + SVT), anglais 1 — ×10 pour rester en entiers, soit 150 points.
-- ⚠️ Piège de slug documenté au CATALOGUE : en 9ᵉ, `svt` porte LA PHYSIQUE
-- (العلوم الفيزيائية) et `sciences-vie-terre` porte la SVT. Les libellés
-- ci-dessous rétablissent la vérité côté élève.
--
-- L'examen naît en `draft` et ne passe `published` que s'il a réellement récolté
-- ses épreuves : mieux vaut aucun examen visible qu'un examen à trois matières
-- qui se présenterait comme un concours blanc.
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  v_exam_id UUID := 'e9a10000-0000-4000-8000-000000000001';
  v_papers  INT;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.parcours WHERE id = 'concours-9eme') THEN
    RETURN;
  END IF;

  INSERT INTO public.mock_exams (
    id, parcours_id, title_fr, title_en, title_ar,
    duration_minutes, status, display_order
  )
  VALUES (
    v_exam_id, 'concours-9eme',
    'Concours blanc 9ᵉ — session 1',
    'Mock exam, 9th grade — session 1',
    'امتحان تجريبي — التاسعة أساسي، الدورة 1',
    90, 'draft', 1
  )
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.mock_exam_papers (
    exam_id, exercise_id, label_fr, label_en, label_ar, points, display_order
  )
  SELECT v_exam_id, pick.id, s.label_fr, s.label_en, s.label_ar, s.points, s.ord
    FROM (VALUES
      ('math',              40, 1, 'Mathématiques',      'Mathematics',       'الرياضيات'),
      ('arabic',            40, 2, 'Arabe',              'Arabic',            'العربية'),
      ('french',            30, 3, 'Français',           'French',            'الفرنسية'),
      ('svt',               15, 4, 'Sciences physiques', 'Physical sciences', 'العلوم الفيزيائية'),
      ('sciences-vie-terre', 15, 5, 'SVT',                'Life & earth sciences', 'علوم الحياة والأرض'),
      ('english',           10, 6, 'Anglais',            'English',           'الإنجليزية')
    ) AS s(subject_id, points, ord, label_fr, label_en, label_ar)
   CROSS JOIN LATERAL (
      SELECT e.id
        FROM public.exercises e
        JOIN public.subjects sub ON sub.id = e.subject_id
        JOIN public.grades g     ON g.id = sub.grade_id
       WHERE e.subject_id = s.subject_id
         AND g.slug = '9eme-base'
         AND e.source = 'admin'
         AND e.mode <> 'quiz'
         AND EXISTS (SELECT 1 FROM public.questions q WHERE q.exercise_id = e.id)
       ORDER BY e.difficulty DESC, e.display_order, e.id
       LIMIT 1
   ) AS pick
  ON CONFLICT (exam_id, exercise_id) DO NOTHING;

  SELECT count(*) INTO v_papers
    FROM public.mock_exam_papers WHERE exam_id = v_exam_id;

  IF v_papers >= 5 THEN
    UPDATE public.mock_exams SET status = 'published' WHERE id = v_exam_id;
  END IF;
END $$;

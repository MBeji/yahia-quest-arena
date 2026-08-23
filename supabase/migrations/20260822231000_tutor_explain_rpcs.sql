-- Étude 11 — lot 1 : les RPC de « Demander au Prof ».
--
-- CE QUE CES FONCTIONS DÉCIDENT, ET CE QU'ELLES NE DÉCIDENT PAS
-- ---------------------------------------------------------------------------
-- Elles décident de la PÉDAGOGIE et de l'ANTI-TRICHE : qui a le droit de
-- demander (R-1), ce que le modèle a le droit de savoir (R-16), ce qu'on sait
-- de l'élève (§2.2), et ce qu'on lui a déjà dit (R-7).
--
-- Elles ne décident RIEN de l'argent ni de l'énergie. L'étude 29 a livré
-- `resolve_ai_access` + `reserve_ai_spend` + `ai_energy_ledger`, et `callAi()`
-- les enchaîne dans une seule transaction. Dupliquer ici un compteur d'énergie
-- créerait deux vérités sur le même quota — exactement ce que Q-1 a arbitré en
-- déclarant un socle unique. `can_use_tutor` ne renvoie donc PAS d'énergie :
-- elle répond « cet élève a-t-il le droit de parler de CETTE question », rien
-- d'autre. Le refus pour énergie épuisée vient de `callAi()`, avec son code.

-- ---------------------------------------------------------------------------
-- 1. La bande d'âge — dérivée, jamais collectée (R-14).
-- ---------------------------------------------------------------------------
-- L'application ne demande pas sa date de naissance à un enfant. La bande se
-- lit sur l'échelle des classes : `display_order` court de 1 (1ère année de
-- base) à 13 (Bac). Hors programme scolaire (culture générale, anglais…), il
-- n'y a pas de classe : on retombe sur la bande médiane, qui est le réglage le
-- moins risqué — ni infantilisant, ni trop dense.
CREATE OR REPLACE FUNCTION public.tutor_age_band(p_grade_id UUID)
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(
    (SELECT CASE
              WHEN g.display_order <= 3 THEN '6-8'
              WHEN g.display_order <= 6 THEN '9-11'
              WHEN g.display_order <= 9 THEN '12-14'
              ELSE '15-19'
            END
       FROM public.grades g
      WHERE g.id = p_grade_id),
    '12-14'
  );
$$;

REVOKE EXECUTE ON FUNCTION public.tutor_age_band(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_age_band(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. R-1 — LA PORTE. Le tuteur n'existe qu'après une réponse soumise.
-- ---------------------------------------------------------------------------
-- Quatre refus possibles, dans cet ordre, et l'ordre compte : on dit à l'élève
-- la raison la plus proche de son geste. Un élève en plein donjon n'a pas
-- « pas encore répondu » — il est en donjon, et c'est ça qu'il faut lui dire.
--
-- ⚠️ `NOT_ATTEMPTED` est la garde qui rend R-16 possible. Tant qu'elle n'est
-- pas franchie, `get_tutor_question_context` refuse de rendre la clé — donc le
-- modèle ne peut pas divulguer ce qu'il n'a pas reçu.
CREATE OR REPLACE FUNCTION public.can_use_tutor(
  p_scope       TEXT,
  p_question_id UUID DEFAULT NULL,
  p_chapter_id  UUID DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'NOT_AUTHENTICATED');
  END IF;

  IF p_scope NOT IN ('question', 'chapter') THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'BAD_SCOPE');
  END IF;

  -- Épreuves notées d'abord : un donjon ou un duel en cours interdit le tuteur
  -- partout, y compris sur une question d'un autre chapitre. C'est la lecture
  -- stricte de R-1 — « jamais pendant un donjon, un duel ».
  IF EXISTS (
    SELECT 1 FROM public.dungeon_runs d
     WHERE d.user_id = v_user AND d.status = 'active'
  ) THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_DUNGEON');
  END IF;

  IF EXISTS (
    SELECT 1
      FROM public.duel_participants dp
      JOIN public.duels du ON du.id = dp.duel_id
     WHERE dp.user_id = v_user
       AND dp.finished_at IS NULL
       AND du.status = 'active'
  ) THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_DUEL');
  END IF;

  IF p_scope = 'question' THEN
    IF p_question_id IS NULL THEN
      RETURN jsonb_build_object('allowed', false, 'reason', 'BAD_SCOPE');
    END IF;

    -- Une session d'exercice NON terminée sur l'exercice qui porte la question :
    -- l'élève est encore dedans, il peut encore changer sa réponse. Le tuteur
    -- serait alors une antisèche.
    IF EXISTS (
      SELECT 1
        FROM public.exercise_sessions s
        JOIN public.questions q ON q.exercise_id = s.exercise_id
       WHERE s.user_id = v_user
         AND s.completed_at IS NULL
         AND q.id = p_question_id
    ) THEN
      RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_SESSION');
    END IF;

    IF NOT EXISTS (
      SELECT 1 FROM public.question_attempts a
       WHERE a.user_id = v_user AND a.question_id = p_question_id
    ) THEN
      RETURN jsonb_build_object('allowed', false, 'reason', 'NOT_ATTEMPTED');
    END IF;

    RETURN jsonb_build_object('allowed', true, 'reason', 'OK');
  END IF;

  -- Portée chapitre (chat, lot 3) : hors de toute session active, donc les deux
  -- gardes globales ci-dessus suffisent. La porte est ouverte dès maintenant
  -- parce que la refuser ici obligerait le lot 3 à modifier une fonction en
  -- production plutôt qu'à en appeler une.
  IF p_chapter_id IS NULL THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'BAD_SCOPE');
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.exercise_sessions s
      JOIN public.exercises e ON e.id = s.exercise_id
     WHERE s.user_id = v_user AND s.completed_at IS NULL AND e.chapter_id = p_chapter_id
  ) THEN
    RETURN jsonb_build_object('allowed', false, 'reason', 'ACTIVE_SESSION');
  END IF;

  RETURN jsonb_build_object('allowed', true, 'reason', 'OK');
END;
$$;

REVOKE EXECUTE ON FUNCTION public.can_use_tutor(TEXT, UUID, UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.can_use_tutor(TEXT, UUID, UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. R-16 — le contexte de la question. La clé n'en sort que si elle a été vue.
-- ---------------------------------------------------------------------------
-- Cette fonction rend la correction complète : options, clé, explication
-- canonique, erreur diagnostiquée. C'est légitime EXACTEMENT parce que la
-- première ligne du corps refuse tout si l'élève n'a pas soumis.
--
-- La variante « sans clé » du mode socratique futur sera une AUTRE fonction,
-- comme l'étude l'exige — pas un paramètre booléen sur celle-ci : un booléen
-- se met à `false` par accident, une fonction absente ne s'appelle pas.
--
-- Le choix de l'élève et son tag viennent de `question_attempts` : le tag y est
-- déjà résolu server-side depuis é04 lot A1.2a. On ne relit jamais
-- `distractor_tags` ici — la map entière désignerait la bonne réponse par
-- élimination (stop-point D-A1.2-2).
CREATE OR REPLACE FUNCTION public.get_tutor_question_context(p_question_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user    UUID := auth.uid();
  v_attempt RECORD;
  v_row     RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  -- La dernière tentative fait foi : si l'élève a rejoué la question, c'est de
  -- son dernier choix qu'il veut parler.
  SELECT a.choice, a.is_correct, a.misconception_tag, a.chapter_id
    INTO v_attempt
    FROM public.question_attempts a
   WHERE a.user_id = v_user AND a.question_id = p_question_id
   ORDER BY a.created_at DESC
   LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'NOT_ATTEMPTED';
  END IF;

  SELECT q.prompt,
         q.options,
         q.correct_option,
         q.explanation,
         q.question_type,
         c.id      AS chapter_id,
         c.title   AS chapter_title,
         c.summary AS chapter_summary,
         -- Bornage DUR de l'extrait de cours. Le découpage fin par sections est
         -- fait côté Node (§3.4) ; ce que la base garantit, c'est qu'aucune
         -- requête ne rapatrie un chapitre de 200 Ko pour en garder 1 500 mots.
         left(COALESCE(c.lesson_content, ''), 8000) AS lesson_excerpt,
         s.content_language,
         g.name_fr AS grade_label,
         g.id      AS grade_id
    INTO v_row
    FROM public.questions q
    JOIN public.exercises e ON e.id = q.exercise_id
    JOIN public.chapters  c ON c.id = e.chapter_id
    JOIN public.subjects  s ON s.id = c.subject_id
    LEFT JOIN public.grades g ON g.id = s.grade_id
   WHERE q.id = p_question_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'QUESTION_NOT_FOUND';
  END IF;

  RETURN jsonb_build_object(
    'question_id',      p_question_id,
    'prompt',           v_row.prompt,
    'options',          v_row.options,
    'question_type',    v_row.question_type,
    'selected_choice',  v_attempt.choice,
    'is_correct',       v_attempt.is_correct,
    'correct_option',   v_row.correct_option,
    'explanation',      v_row.explanation,
    'misconception',    v_attempt.misconception_tag,
    -- Les trois langues du libellé, comme é04 A1.2b : mettre en langue est une
    -- décision de rendu. Ici c'est le prompt qui choisit, selon la langue de la
    -- matière — mais la base rend les trois et ne tranche pas.
    'misconception_labels', (
      SELECT jsonb_build_object('fr', m.label_fr, 'en', m.label_en, 'ar', m.label_ar)
        FROM public.misconceptions m
       WHERE m.tag = v_attempt.misconception_tag
    ),
    'chapter_id',       v_row.chapter_id,
    'chapter_title',    v_row.chapter_title,
    'chapter_summary',  v_row.chapter_summary,
    'lesson_excerpt',   v_row.lesson_excerpt,
    'lang',             CASE WHEN v_row.content_language IN ('fr', 'en', 'ar')
                             THEN v_row.content_language ELSE 'fr' END,
    'grade_label',      v_row.grade_label,
    'age_band',         public.tutor_age_band(v_row.grade_id)
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_tutor_question_context(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_question_context(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. §2.2 — le pack élève. Discrétisé, borné, sans PII.
-- ---------------------------------------------------------------------------
-- Des BUCKETS, pas des valeurs brutes : c'est ce qui rend le préfixe de prompt
-- stable d'un appel à l'autre (donc cachable côté fournisseur) et ce qui évite
-- de reconstruire un profil identifiant à partir d'un cumul de nombres exacts.
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
            FROM public.user_misconceptions um
            LEFT JOIN public.misconceptions m ON m.tag = um.tag
           WHERE um.user_id = v_user
             AND um.occurrences >= 3
             AND um.sessions_seen >= 2
             AND um.last_seen_at >= now() - INTERVAL '30 days'
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

-- ---------------------------------------------------------------------------
-- 5. R-7 — le fil, et l'escalier de reformulation.
-- ---------------------------------------------------------------------------
-- `open_tutor_thread` rend le fil actif de (élève, question) ou le crée. Le
-- registre à servir se lit sur `variant_served` : c'est la base qui garantit
-- qu'« Explique autrement » ne redit jamais la même chose, y compris si deux
-- onglets demandent en même temps.
CREATE OR REPLACE FUNCTION public.open_tutor_thread(
  p_question_id UUID,
  p_lang        TEXT,
  p_age_band    TEXT,
  p_snapshot    JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_row  RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  -- R-1 encore : on ne crée pas un fil sur une question qu'on n'a pas jouée.
  -- La porte est vérifiée ici AUSSI, pas seulement à l'écran : une RPC est une
  -- surface publique dès qu'elle est GRANT à `authenticated`.
  IF NOT ((public.can_use_tutor('question', p_question_id, NULL))->>'allowed')::BOOLEAN THEN
    RAISE EXCEPTION 'TUTOR_FORBIDDEN';
  END IF;

  SELECT * INTO v_row
    FROM public.tutor_threads t
   WHERE t.user_id = v_user AND t.question_id = p_question_id
     AND t.status = 'active' AND t.scope = 'question';

  IF NOT FOUND THEN
    INSERT INTO public.tutor_threads (user_id, scope, question_id, lang, age_band, context_snapshot)
    VALUES (v_user, 'question', p_question_id, p_lang, p_age_band, p_snapshot)
    RETURNING * INTO v_row;
  END IF;

  RETURN jsonb_build_object(
    'thread_id',      v_row.id,
    'variant_served', v_row.variant_served,
    'messages',       v_row.messages,
    'resolved',       v_row.resolved
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.open_tutor_thread(UUID, TEXT, TEXT, JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.open_tutor_thread(UUID, TEXT, TEXT, JSONB) TO authenticated;

-- Append + compteurs, en une écriture. `p_advance_variant` n'est vrai que pour
-- une explication servie : un 👍 ou un « j'ai compris » ne consomme pas un
-- registre.
CREATE OR REPLACE FUNCTION public.append_tutor_message(
  p_thread          UUID,
  p_role            TEXT,
  p_kind            TEXT,
  p_content         TEXT,
  p_tokens_in       INT DEFAULT 0,
  p_tokens_out      INT DEFAULT 0,
  p_advance_variant BOOLEAN DEFAULT false
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_row  RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;
  IF p_role NOT IN ('student', 'tutor') THEN
    RAISE EXCEPTION 'BAD_ROLE';
  END IF;

  UPDATE public.tutor_threads t
     SET messages = t.messages || jsonb_build_object(
                      'role', p_role, 'kind', p_kind,
                      'content', left(p_content, 4000), 'at', now()
                    ),
         tokens_in  = t.tokens_in  + GREATEST(p_tokens_in, 0),
         tokens_out = t.tokens_out + GREATEST(p_tokens_out, 0),
         -- Le plafond de 3 est dans le CHECK ; on n'y arrive jamais par cette
         -- porte, mais LEAST le rend explicite plutôt qu'accidentel.
         variant_served = CASE WHEN p_advance_variant
                               THEN LEAST(t.variant_served + 1, 3)
                               ELSE t.variant_served END,
         updated_at = now()
   WHERE t.id = p_thread AND t.user_id = v_user AND t.status = 'active'
  RETURNING * INTO v_row;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'THREAD_NOT_FOUND';
  END IF;

  RETURN jsonb_build_object(
    'message_ix',     jsonb_array_length(v_row.messages) - 1,
    'variant_served', v_row.variant_served
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.append_tutor_message(UUID, TEXT, TEXT, TEXT, INT, INT, BOOLEAN)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.append_tutor_message(UUID, TEXT, TEXT, TEXT, INT, INT, BOOLEAN)
  TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. R-15.2 / D-9 — le cache mutualisé.
-- ---------------------------------------------------------------------------
-- Lecture gardée comme le contexte : l'appelant doit avoir soumis. Une
-- explication est un morceau de correction ; la servir à qui n'a pas répondu
-- contournerait R-1 par la porte du cache.
CREATE OR REPLACE FUNCTION public.find_tutor_explanation(
  p_question_id   UUID,
  p_misconception TEXT,
  p_lang          TEXT,
  p_age_band      TEXT,
  p_variant       TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_row  RECORD;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.question_attempts a
     WHERE a.user_id = v_user AND a.question_id = p_question_id
  ) THEN
    RAISE EXCEPTION 'NOT_ATTEMPTED';
  END IF;

  -- Le pot commun d'abord, la réserve privée ensuite : à qualité égale, une
  -- explication déjà payée par la communauté coûte moins qu'une des siennes.
  SELECT * INTO v_row
    FROM public.tutor_explanations e
   WHERE e.question_id = p_question_id
     AND e.misconception IS NOT DISTINCT FROM p_misconception
     AND e.lang = p_lang
     AND e.age_band = p_age_band
     AND e.variant = p_variant
     AND (e.shared OR e.owner_user_id = v_user)
   ORDER BY e.shared DESC, e.serve_count DESC
   LIMIT 1;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  UPDATE public.tutor_explanations SET serve_count = serve_count + 1 WHERE id = v_row.id;

  RETURN jsonb_build_object('body', v_row.body, 'model', v_row.model, 'shared', v_row.shared);
END;
$$;

REVOKE EXECUTE ON FUNCTION public.find_tutor_explanation(UUID, TEXT, TEXT, TEXT, TEXT)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.find_tutor_explanation(UUID, TEXT, TEXT, TEXT, TEXT)
  TO authenticated;

-- `p_shared` est calculé par Node contre `AI_CURATED_MODELS` et n'est PAS
-- vérifiable en base — la liste curée est une constante d'application, pas une
-- table. C'est un écart assumé : la fonction n'est appelable que par le serveur
-- (elle n'est GRANT qu'à `service_role`), donc aucun client ne peut prétendre
-- qu'un modèle inconnu appartient au pot commun.
CREATE OR REPLACE FUNCTION public.store_tutor_explanation(
  p_question_id   UUID,
  p_misconception TEXT,
  p_lang          TEXT,
  p_age_band      TEXT,
  p_variant       TEXT,
  p_body          TEXT,
  p_model         TEXT,
  p_shared        BOOLEAN,
  p_owner         UUID
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO public.tutor_explanations
    (question_id, misconception, lang, age_band, variant, body, model, shared, owner_user_id)
  VALUES
    (p_question_id, p_misconception, p_lang, p_age_band, p_variant,
     left(p_body, 4000), p_model, COALESCE(p_shared, false), p_owner)
  RETURNING id INTO v_id;
  RETURN v_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION
  public.store_tutor_explanation(UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, BOOLEAN, UUID)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION
  public.store_tutor_explanation(UUID, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, BOOLEAN, UUID)
  TO service_role;

-- ---------------------------------------------------------------------------
-- 7. R-17 et les préférences — triviaux, propriétaire.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.rate_tutor_message(
  p_thread     UUID,
  p_message_ix INT,
  p_rating     SMALLINT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.tutor_threads t WHERE t.id = p_thread AND t.user_id = v_user
  ) THEN
    RAISE EXCEPTION 'THREAD_NOT_FOUND';
  END IF;

  INSERT INTO public.tutor_feedback (thread_id, user_id, message_ix, rating)
  VALUES (p_thread, v_user, p_message_ix, p_rating)
  ON CONFLICT (thread_id, message_ix, user_id)
  DO UPDATE SET rating = EXCLUDED.rating, created_at = now();
END;
$$;

REVOKE EXECUTE ON FUNCTION public.rate_tutor_message(UUID, INT, SMALLINT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.rate_tutor_message(UUID, INT, SMALLINT) TO authenticated;

CREATE OR REPLACE FUNCTION public.set_tutor_prefs(
  p_interests TEXT[],
  p_verbosity TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  INSERT INTO public.tutor_prefs (user_id, interests, verbosity, updated_at)
  VALUES (v_user, COALESCE(p_interests, '{}'), COALESCE(p_verbosity, 'normale'), now())
  ON CONFLICT (user_id)
  DO UPDATE SET interests = EXCLUDED.interests,
                verbosity = EXCLUDED.verbosity,
                updated_at = now();
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_tutor_prefs(TEXT[], TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_tutor_prefs(TEXT[], TEXT) TO authenticated;

-- Étude 11 — lot 3 : le chat cadré, côté base.
--
-- CE QUE LE LOT 1 A DÉJÀ POSÉ, ET QU'ON NE REFAIT PAS
-- ---------------------------------------------------------------------------
-- `tutor_threads` porte déjà `scope IN ('question','chapter')` et son index
-- unique partiel sur le fil de chapitre actif — le lot 1 les a écrits en
-- prévoyant celui-ci, « pour que le lot 3 n'ait pas à migrer une colonne en
-- production ». `can_use_tutor('chapter', …)` répond déjà. `append_tutor_message`
-- écrit déjà.
--
-- Ne manquaient que trois choses : de quoi PARLER (le contexte du chapitre),
-- de quoi SE SOUVENIR dans les bornes de R-14 (la fenêtre et son résumé), et de
-- quoi RELIRE (l'historique).
--
-- LA BORNE DE MÉMOIRE EST UNE RÈGLE, PAS UNE OPTIMISATION
-- ---------------------------------------------------------------------------
-- §1.5 : « Pas de mémoire conversationnelle longue : fils courts par sujet +
-- résumé roulant borné ; pas de "le tuteur se souvient de tout depuis toujours"
-- (vie privée + coût). » La fenêtre est donc rendue par la BASE, tronquée à dix
-- messages, et non par du code qui pourrait un jour en demander cinquante.

-- ---------------------------------------------------------------------------
-- 1. Le contexte d'un chapitre — R-2, sans jamais une clé de réponse.
-- ---------------------------------------------------------------------------
-- Différence FONDAMENTALE avec `get_tutor_question_context` : cette fonction-ci
-- ne rend AUCUNE correction. Le chat n'est pas post-review — il se tient à côté
-- du cours, souvent avant toute tentative — donc R-16 s'applique dans sa forme
-- la plus stricte : le modèle ne reçoit que le cours, et ne peut pas divulguer
-- ce qu'il n'a pas.
--
-- C'est pour cette raison que le chat n'a pas besoin de la garde « a-t-il
-- soumis ? » : il n'y a rien à protéger dans ce qu'il transmet.
CREATE OR REPLACE FUNCTION public.get_tutor_chapter_context(p_chapter_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
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

  SELECT c.id,
         c.title,
         c.summary,
         -- ≤ 6 000 caractères ≈ 1 500 tokens : la borne de §3.4, appliquée là où
         -- le texte est. Même borne que `get_forge_context`, volontairement.
         LEFT(COALESCE(c.lesson_content, ''), 6000) AS lesson_excerpt,
         COALESCE(s.content_language, 'fr') AS lang,
         s.id AS subject_id,
         s.name_fr AS subject_title
    INTO v_row
    FROM public.chapters c
    JOIN public.subjects s ON s.id = c.subject_id
   WHERE c.id = p_chapter_id;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('found', false);
  END IF;

  RETURN jsonb_build_object(
    'found', true,
    'chapter_id', v_row.id,
    'chapter_title', v_row.title,
    'chapter_summary', v_row.summary,
    'lesson_excerpt', v_row.lesson_excerpt,
    'subject_id', v_row.subject_id,
    'subject_title', v_row.subject_title,
    'lang', v_row.lang,
    -- R-4 : la bande d'âge est dérivée de la CLASSE de l'élève, jamais collectée.
    'age_band', public.tutor_age_band(
      (SELECT p.current_grade_id FROM public.profiles p WHERE p.id = v_user))
  );
END;
$$;

COMMENT ON FUNCTION public.get_tutor_chapter_context(UUID) IS
  'Étude 11 lot 3 : le cours d''un chapitre pour le chat du tuteur. Ne rend AUCUNE correction — le chat n''est pas post-review, donc R-16 s''applique dans sa forme stricte.';

REVOKE EXECUTE ON FUNCTION public.get_tutor_chapter_context(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_chapter_context(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. Ouvrir (ou retrouver) le fil d'un chapitre.
-- ---------------------------------------------------------------------------
-- Jumelle de `open_tutor_thread` du lot 1, sur l'autre portée. Un seul fil actif
-- par (élève, chapitre) : rouvrir le lecteur doit RETROUVER la conversation, pas
-- en démarrer une seconde — l'index unique partiel du lot 1 le garantit, et
-- l'`ON CONFLICT` ci-dessous s'y appuie.
CREATE OR REPLACE FUNCTION public.open_tutor_chapter_thread(
  p_chapter_id UUID,
  p_lang       TEXT,
  p_age_band   TEXT,
  p_snapshot   JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user   UUID := auth.uid();
  v_thread public.tutor_threads%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  SELECT * INTO v_thread
    FROM public.tutor_threads t
   WHERE t.user_id = v_user
     AND t.chapter_id = p_chapter_id
     AND t.scope = 'chapter'
     AND t.status = 'active';

  IF NOT FOUND THEN
    INSERT INTO public.tutor_threads
      (user_id, scope, chapter_id, lang, age_band, context_snapshot)
    VALUES (v_user, 'chapter', p_chapter_id, p_lang, p_age_band, p_snapshot)
    RETURNING * INTO v_thread;
  END IF;

  RETURN jsonb_build_object(
    'thread_id', v_thread.id,
    'summary', v_thread.summary,
    -- La FENÊTRE, tronquée en base : dix messages, jamais cinquante (§1.5).
    'messages', public.tutor_thread_window(v_thread.messages),
    'message_count', jsonb_array_length(v_thread.messages)
  );
END;
$$;

COMMENT ON FUNCTION public.open_tutor_chapter_thread(UUID, TEXT, TEXT, JSONB) IS
  'Étude 11 lot 3 : ouvre ou retrouve LE fil actif d''un (élève, chapitre). Rend la fenêtre bornée, jamais l''historique entier (§1.5).';

REVOKE EXECUTE ON FUNCTION public.open_tutor_chapter_thread(UUID, TEXT, TEXT, JSONB)
  FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.open_tutor_chapter_thread(UUID, TEXT, TEXT, JSONB)
  TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. La fenêtre — dix derniers messages, décidé ICI.
-- ---------------------------------------------------------------------------
-- Une fonction, pas une constante recopiée : « pas de mémoire conversationnelle
-- longue » est une règle de vie privée ET de coût, et une règle qui vit à deux
-- endroits n'en est plus une.
CREATE OR REPLACE FUNCTION public.tutor_thread_window(p_messages JSONB)
RETURNS JSONB
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT COALESCE(
    (SELECT jsonb_agg(m ORDER BY ord)
       FROM (
         SELECT m, ord
           FROM jsonb_array_elements(COALESCE(p_messages, '[]'::jsonb))
                WITH ORDINALITY AS t(m, ord)
          ORDER BY ord DESC
          LIMIT 10
       ) last_ten),
    '[]'::jsonb
  );
$$;

COMMENT ON FUNCTION public.tutor_thread_window(JSONB) IS
  'Étude 11 §3.4 : les dix derniers messages d''un fil. La borne vit ici, à un seul endroit — c''est une règle de vie privée et de coût, pas un réglage.';

REVOKE EXECUTE ON FUNCTION public.tutor_thread_window(JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.tutor_thread_window(JSONB) TO authenticated;

-- ---------------------------------------------------------------------------
-- 4. Le résumé roulant.
-- ---------------------------------------------------------------------------
-- Écrit par Node tous les dix messages, depuis un appel `fast` dédié (§3.4).
-- C'est ce qui permet à un fil de rester utile sans grandir : la fenêtre glisse,
-- le résumé porte ce qui précède, et rien n'est conservé indéfiniment.
CREATE OR REPLACE FUNCTION public.set_tutor_thread_summary(p_thread UUID, p_summary TEXT)
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

  UPDATE public.tutor_threads
     SET summary = LEFT(COALESCE(p_summary, ''), 1200), updated_at = now()
   WHERE id = p_thread AND user_id = v_user;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.set_tutor_thread_summary(UUID, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.set_tutor_thread_summary(UUID, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. L'historique — US-9, lecture seule.
-- ---------------------------------------------------------------------------
-- « L'historique est consultable (liste simple, lecture seule). » Et c'est aussi
-- une garantie de R-14, dans l'autre sens : les transcripts sont visibles PAR
-- L'ÉLÈVE. Ce qui est écrit sur lui, il peut le lire.
CREATE OR REPLACE FUNCTION public.list_tutor_threads(p_limit INT DEFAULT 20)
RETURNS TABLE (
  thread_id     UUID,
  scope         TEXT,
  chapter_id    UUID,
  question_id   UUID,
  title         TEXT,
  lang          TEXT,
  message_count INT,
  resolved      BOOLEAN,
  updated_at    TIMESTAMPTZ
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT t.id,
         t.scope,
         t.chapter_id,
         t.question_id,
         COALESCE(c.title, ec.title, ''),
         t.lang,
         jsonb_array_length(t.messages)::INT,
         t.resolved,
         t.updated_at
    FROM public.tutor_threads t
    LEFT JOIN public.chapters c ON c.id = t.chapter_id
    LEFT JOIN public.questions q ON q.id = t.question_id
    LEFT JOIN public.exercises e ON e.id = q.exercise_id
    LEFT JOIN public.chapters ec ON ec.id = e.chapter_id
   WHERE t.user_id = (SELECT auth.uid())
     AND jsonb_array_length(t.messages) > 0
   ORDER BY t.updated_at DESC
   LIMIT GREATEST(LEAST(COALESCE(p_limit, 20), 50), 1);
$$;

COMMENT ON FUNCTION public.list_tutor_threads(INT) IS
  'Étude 11 US-9 : l''historique des fils de l''élève, en lecture seule. R-14 dans l''autre sens — ce qui est écrit sur lui, il peut le lire.';

REVOKE EXECUTE ON FUNCTION public.list_tutor_threads(INT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.list_tutor_threads(INT) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_tutor_thread(p_thread UUID)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user   UUID := auth.uid();
  v_thread public.tutor_threads%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'NOT_AUTHENTICATED';
  END IF;

  SELECT * INTO v_thread
    FROM public.tutor_threads t
   WHERE t.id = p_thread AND t.user_id = v_user;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('found', false);
  END IF;

  RETURN jsonb_build_object(
    'found', true,
    'thread_id', v_thread.id,
    'scope', v_thread.scope,
    'lang', v_thread.lang,
    'summary', v_thread.summary,
    -- L'élève relit son fil ENTIER : la borne de dix ne protège pas de lui, elle
    -- protège le PROMPT (coût, vie privée vis-à-vis du modèle).
    'messages', v_thread.messages,
    'resolved', v_thread.resolved
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_tutor_thread(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_tutor_thread(UUID) TO authenticated;

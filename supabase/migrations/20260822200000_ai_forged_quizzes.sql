-- Étude 29 — lot 4 : LA FORGE. Un quiz écrit à la demande de l'élève.
--
-- CE QUE LA FORGE EST, ET CE QU'ELLE N'EST PAS (§2.3)
-- ---------------------------------------------------------------------------
-- Elle est jouable, éphémère (30 jours), et étiquetée « écrit par l'IA de ta
-- famille ». Elle n'est PAS notée : aucun XP, aucune pièce, aucun badge, aucune
-- série, aucune écriture dans `question_attempts`, `attempts` ni
-- `spaced_repetition_schedule` (R-16, D-13). Et elle ne quitte pas la famille :
-- non promue au catalogue, non partagée, non indexée (R-17).
--
-- LA CLÉ DE RÉPONSE NE DESCEND PAS AU CLIENT
-- ---------------------------------------------------------------------------
-- `payload` contient les items VALIDÉS, clés comprises. La table est donc
-- `REVOKE ALL` pour anon et authenticated, exactement comme le coffre : la
-- lecture élève passe par `serve_forged_quiz`, qui retire les clés — le motif de
-- `resolve_exercise_access`, appliqué au contenu forgé.
--
-- POURQUOI LA CORRECTION EST EN SQL
-- ---------------------------------------------------------------------------
-- `grade_forged_quiz` compare côté serveur et ne verse RIEN. Corriger côté
-- client obligerait à descendre la clé ; verser quoi que ce soit violerait R-16.
-- Les deux moitiés de la règle tiennent dans la même fonction, et c'est voulu :
-- personne ne peut ajouter une récompense sans passer devant l'interdiction.
--
-- AGENTS.md : une table neuve embarque ses propres GRANT explicites.

-- ---------------------------------------------------------------------------
-- 1. La table.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_forged_quizzes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Qui a payé ce quiz. C'est aussi la frontière de R-17 : un quiz forgé reste
  -- privé à SON payeur, contrairement aux explications, mutualisées depuis Q-3.
  owner_user_id   UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scope           TEXT NOT NULL CHECK (scope IN ('chapter', 'competency', 'mistakes')),
  chapter_id      UUID REFERENCES public.chapters(id) ON DELETE CASCADE,
  -- `competency_id` n'est VOLONTAIREMENT pas une clé étrangère : é07 lot 1 est
  -- livré, mais le référentiel des compétences vient du corpus privé. Une FK
  -- ferait dépendre cette table de lignes absentes du dépôt public — le piège
  -- que `db:check-chain` existe pour attraper (§3.3).
  competency_id   TEXT,
  lang            TEXT NOT NULL CHECK (lang IN ('fr', 'en', 'ar')),
  difficulty      INT NOT NULL CHECK (difficulty BETWEEN 1 AND 4),
  requested       INT NOT NULL CHECK (requested BETWEEN 5 AND 10),
  -- Items VALIDÉS, clés comprises. REVOKE total ci-dessous.
  payload         JSONB NOT NULL,
  model           TEXT NOT NULL,
  -- Candidats rejetés par les filtres ou par la double résolution. C'est la
  -- matière première du taux de rebut, donc de l'avertissement R-19 : sans ce
  -- compteur, un mauvais modèle reste indétectable.
  discarded       INT NOT NULL DEFAULT 0 CHECK (discarded >= 0),
  -- R-18bis.2 : l'étiquette « non vérifié » est portée par le CONTENU, pas par
  -- l'écran de création. Elle doit donc voyager avec le quiz.
  verified        BOOLEAN NOT NULL DEFAULT true,
  expires_at      TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '30 days'),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT ai_forged_scope_chapter CHECK ((scope = 'chapter') = (chapter_id IS NOT NULL))
);

COMMENT ON TABLE public.ai_forged_quizzes IS
  'Quiz forgés par l''IA de la famille (étude 29 lot 4). Éphémères (30 j), non notés (R-16), privés à leur payeur (R-17). `payload` porte les clés : REVOKE total, lecture via serve_forged_quiz.';

CREATE INDEX IF NOT EXISTS idx_forged_student
  ON public.ai_forged_quizzes (student_user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_forged_expiry ON public.ai_forged_quizzes (expires_at);

ALTER TABLE public.ai_forged_quizzes ENABLE ROW LEVEL SECURITY;

-- ⚠️ Comme le coffre : aucun droit client, aucune policy. `payload` porte les
-- clés de réponse, et l'invariant d'AGENTS.md est absolu — « la clé n'est JAMAIS
-- envoyée au client, en phase gratuite ou non ».
REVOKE ALL ON public.ai_forged_quizzes FROM anon, authenticated;
GRANT ALL ON public.ai_forged_quizzes TO service_role;

-- ---------------------------------------------------------------------------
-- 2. Le quota (R-18) — vérifié EN BASE, pas seulement dans l'écran.
-- ---------------------------------------------------------------------------
-- « ≤ 3 quiz forgés par élève et par jour. » Un client modifié ne doit pas
-- pouvoir en demander trente : la Forge est l'action la plus chère du produit.
CREATE OR REPLACE FUNCTION public.ai_forge_quota_left(p_student UUID)
RETURNS INT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT GREATEST(3 - COUNT(*)::INT, 0)
    FROM public.ai_forged_quizzes q
   WHERE q.student_user_id = p_student
     AND q.created_at >= date_trunc('day', now());
$$;

REVOKE EXECUTE ON FUNCTION public.ai_forge_quota_left(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.ai_forge_quota_left(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 3. L'écriture — après validation complète, jamais avant.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.create_forged_quiz(
  p_student UUID,
  p_owner UUID,
  p_scope TEXT,
  p_chapter UUID,
  p_competency TEXT,
  p_lang TEXT,
  p_difficulty INT,
  p_requested INT,
  p_payload JSONB,
  p_model TEXT,
  p_discarded INT,
  p_verified BOOLEAN
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id UUID;
BEGIN
  -- R-18 : le quota est la dernière barrière avant l'écriture. La chaîne a déjà
  -- dépensé quand on arrive ici, mais un quiz de trop ne doit pas s'installer.
  IF public.ai_forge_quota_left(p_student) <= 0 THEN
    RAISE EXCEPTION 'AI_FORGE_QUOTA';
  END IF;

  INSERT INTO public.ai_forged_quizzes (
    student_user_id, owner_user_id, scope, chapter_id, competency_id,
    lang, difficulty, requested, payload, model, discarded, verified
  )
  VALUES (
    p_student, p_owner, p_scope, p_chapter, p_competency,
    p_lang, p_difficulty, p_requested, p_payload, p_model,
    GREATEST(COALESCE(p_discarded, 0), 0), COALESCE(p_verified, true)
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.create_forged_quiz(
  UUID, UUID, TEXT, UUID, TEXT, TEXT, INT, INT, JSONB, TEXT, INT, BOOLEAN)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 4. La lecture élève — SANS les clés (motif `resolve_exercise_access`).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.serve_forged_quiz(p_quiz UUID)
RETURNS TABLE (
  id UUID,
  scope TEXT,
  chapter_id UUID,
  lang TEXT,
  difficulty INT,
  verified BOOLEAN,
  expires_at TIMESTAMPTZ,
  items JSONB
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_quiz public.ai_forged_quizzes%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_quiz FROM public.ai_forged_quizzes q WHERE q.id = p_quiz;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'AI_FORGE_NOT_FOUND';
  END IF;

  -- R-17 : un quiz forgé ne quitte pas la famille. L'élève à qui il est destiné
  -- le joue ; le porteur qui l'a payé peut le relire. Personne d'autre.
  IF v_quiz.student_user_id <> v_user AND v_quiz.owner_user_id <> v_user THEN
    RAISE EXCEPTION 'AI_FORGE_NOT_FOUND';
  END IF;

  IF v_quiz.expires_at < now() THEN
    RAISE EXCEPTION 'AI_FORGE_EXPIRED';
  END IF;

  RETURN QUERY
  SELECT v_quiz.id, v_quiz.scope, v_quiz.chapter_id, v_quiz.lang, v_quiz.difficulty,
         v_quiz.verified, v_quiz.expires_at,
         -- La projection EST la garantie : on nomme les trois champs servis, et
         -- `correctOption` / `explanation` n'en font pas partie. Un `-` sur les
         -- clés à retirer serait fragile — il faudrait penser à l'étendre à
         -- chaque champ ajouté ; ici, ajouter un champ au payload ne le sert pas.
         COALESCE(
           (SELECT jsonb_agg(jsonb_build_object(
                     'id', item->>'id',
                     'prompt', item->>'prompt',
                     'options', item->'options')
                   ORDER BY ordinality)
              FROM jsonb_array_elements(v_quiz.payload->'items') WITH ORDINALITY AS t(item, ordinality)),
           '[]'::jsonb);
END;
$$;

COMMENT ON FUNCTION public.serve_forged_quiz(UUID) IS
  'Sert un quiz forgé à son élève ou à son payeur, SANS clé de réponse ni explication (motif resolve_exercise_access). Refuse un quiz expiré ou d''une autre famille (R-17).';

REVOKE EXECUTE ON FUNCTION public.serve_forged_quiz(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.serve_forged_quiz(UUID) TO authenticated;

-- ---------------------------------------------------------------------------
-- 5. La correction — serveur, et SANS AUCUNE récompense (R-16, D-13).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.grade_forged_quiz(p_quiz UUID, p_answers JSONB)
RETURNS TABLE (
  correct INT,
  total INT,
  review JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
  v_quiz public.ai_forged_quizzes%ROWTYPE;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT * INTO v_quiz FROM public.ai_forged_quizzes q WHERE q.id = p_quiz;
  IF NOT FOUND OR (v_quiz.student_user_id <> v_user AND v_quiz.owner_user_id <> v_user) THEN
    RAISE EXCEPTION 'AI_FORGE_NOT_FOUND';
  END IF;

  RETURN QUERY
  WITH items AS (
    SELECT item->>'id' AS qid,
           item->>'prompt' AS prompt,
           item->>'correctOption' AS key,
           item->>'explanation' AS explanation
      FROM jsonb_array_elements(v_quiz.payload->'items') AS t(item)
  ),
  graded AS (
    SELECT i.qid,
           i.prompt,
           i.key,
           i.explanation,
           COALESCE(p_answers->>i.qid, '') AS chosen,
           COALESCE(p_answers->>i.qid, '') = i.key AS ok
      FROM items i
  )
  SELECT COUNT(*) FILTER (WHERE g.ok)::INT,
         COUNT(*)::INT,
         COALESCE(jsonb_agg(jsonb_build_object(
           'questionId', g.qid,
           'prompt', g.prompt,
           'selectedChoice', g.chosen,
           'correctChoice', g.key,
           'isCorrect', g.ok,
           'explanation', g.explanation)), '[]'::jsonb)
    FROM graded g;

  -- ⚠️ IL N'Y A RIEN APRÈS CE RETURN, ET C'EST LA RÈGLE.
  -- Pas d'award_xp, pas d'award_coins, pas de badge, pas de série, pas
  -- d'écriture dans question_attempts / attempts / spaced_repetition_schedule
  -- (R-16, D-13). Du contenu non revu ne pilote ni l'adaptativité, ni le SM-2.
  -- pgTAP S64 vérifie l'absence, parce qu'une récompense ajoutée « juste pour
  -- encourager » ne casserait aucun test existant.
END;
$$;

COMMENT ON FUNCTION public.grade_forged_quiz(UUID, JSONB) IS
  'Corrige un quiz forgé côté serveur et ne verse RIEN : aucun XP, aucune pièce, aucun badge, aucune écriture dans la télémétrie d''apprentissage (R-16, D-13).';

REVOKE EXECUTE ON FUNCTION public.grade_forged_quiz(UUID, JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.grade_forged_quiz(UUID, JSONB) TO authenticated;

-- ---------------------------------------------------------------------------
-- 6. Le CONTEXTE de génération — déterministe, et sans clé de réponse.
-- ---------------------------------------------------------------------------
-- « contexte fermé : cours du chapitre (≤ 1 500 tk) + 3 questions du catalogue
-- comme RÉFÉRENCE DE STYLE, jamais à recopier » (§3.6).
--
-- Les questions d'exemple partent SANS leur clé : le modèle n'a pas besoin de
-- savoir laquelle est juste pour imiter un style, et tout ce qui ne part pas ne
-- peut pas fuiter. Les énoncés du chapitre partent en entier, eux, parce que le
-- filtre anti-doublon en a besoin (§3.6) — et ils sont déjà publics.
CREATE OR REPLACE FUNCTION public.get_forge_context(p_chapter UUID)
RETURNS TABLE (
  chapter_title TEXT,
  subject_id TEXT,
  content_lang TEXT,
  grade_rank INT,
  lesson_excerpt TEXT,
  sample_prompts TEXT[],
  existing_prompts TEXT[]
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT c.title,
         c.subject_id,
         COALESCE(s.content_language, 'fr'),
         g.display_order,
         -- ≤ 6 000 caractères ≈ 1 500 tokens : la borne du §3.6, appliquée là
         -- où le texte est, pas dans le prompt qui l'assemble.
         LEFT(COALESCE(c.lesson_content, ''), 6000),
         COALESCE((
           SELECT array_agg(p ORDER BY p)
             FROM (SELECT q.prompt AS p
                     FROM public.questions q
                     JOIN public.exercises e ON e.id = q.exercise_id
                    WHERE e.chapter_id = c.id
                    ORDER BY q.display_order
                    LIMIT 3) sample
         ), ARRAY[]::TEXT[]),
         COALESCE((
           SELECT array_agg(q.prompt)
             FROM public.questions q
             JOIN public.exercises e ON e.id = q.exercise_id
            WHERE e.chapter_id = c.id
         ), ARRAY[]::TEXT[])
    FROM public.chapters c
    JOIN public.subjects s ON s.id = c.subject_id
    LEFT JOIN public.grades g ON g.id = s.grade_id
   WHERE c.id = p_chapter;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_forge_context(UUID) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 7. La liste des quiz d'un élève — pour l'écran de la Forge.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.list_forged_quizzes()
RETURNS TABLE (
  id UUID,
  scope TEXT,
  chapter_id UUID,
  chapter_title TEXT,
  lang TEXT,
  difficulty INT,
  question_count INT,
  verified BOOLEAN,
  created_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := auth.uid();
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  RETURN QUERY
  SELECT q.id, q.scope, q.chapter_id, c.title, q.lang, q.difficulty,
         COALESCE(jsonb_array_length(q.payload->'items'), 0),
         q.verified, q.created_at, q.expires_at
    FROM public.ai_forged_quizzes q
    LEFT JOIN public.chapters c ON c.id = q.chapter_id
   WHERE (q.student_user_id = v_user OR q.owner_user_id = v_user)
     AND q.expires_at > now()
   ORDER BY q.created_at DESC
   LIMIT 20;
END;
$$;

REVOKE EXECUTE ON FUNCTION public.list_forged_quizzes() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.list_forged_quizzes() TO authenticated;

-- ---------------------------------------------------------------------------
-- 8. Purge — 30 jours (R-17).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.purge_ai_forged_quizzes()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM public.ai_forged_quizzes WHERE expires_at < now();
END;
$$;

REVOKE EXECUTE ON FUNCTION public.purge_ai_forged_quizzes() FROM PUBLIC, anon, authenticated;

DO $$
BEGIN
  CREATE EXTENSION IF NOT EXISTS pg_cron;
  PERFORM cron.unschedule(jobid) FROM cron.job WHERE jobname = 'purge-ai-forged-quizzes';
  PERFORM cron.schedule(
    'purge-ai-forged-quizzes', '45 3 * * *',
    $cron$SELECT public.purge_ai_forged_quizzes();$cron$
  );
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE
    'pg_cron indisponible (%). Les quiz forgés fonctionnent mais ne seront PAS purgés à 30 jours (R-17). Activer pg_cron puis rejouer le bloc cron.schedule(...).',
    SQLERRM;
END;
$$;

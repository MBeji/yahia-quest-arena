-- =========================================================
-- Borne durable devant les RPC anonymes SECURITY DEFINER (audit 2026-09-12, S-1 / geste 8)
-- ---------------------------------------------------------
-- Constat re-fait le 2026-11-12 en rejouant la chaîne avec les privilèges par défaut de
-- Supabase : 14 RPC `SECURITY DEFINER` sont exécutables par `anon` (8 en septembre ; l'étude 39
-- en a ajouté 5 avec le test de niveau, et `get_student_daily_report_by_code` a deux
-- signatures). Devant elles, la seule limite pour un anonyme était une `Map` en mémoire par
-- instance Vercel (`rate-limit.ts`) — que n'importe qui contourne en appelant PostgREST
-- directement avec la clé publique.
--
-- Ce que pose cette migration (ADDITIVE : une table, une fonction, des `CREATE OR REPLACE`) :
--
--  1. `rpc_rate_limit_policies` — les seuils, en DONNÉES : les régler est une migration d'une
--     ligne (`UPDATE`), pas une réécriture de fonction.
--  2. `enforce_rpc_rate_limit(scope)` — interne (ni `anon` ni `authenticated`), appelée en
--     PREMIÈRE instruction des RPC bornées. Trois paliers, comptés dans `rate_limit_events`
--     (donc partagés par toutes les instances) :
--       · compte connecté   → par utilisateur ;
--       · anonyme           → par SOURCE (IP vue par la passerelle Supabase), ET
--       · anonyme           → GLOBAL par scope : c'est lui qui tient quand la source tourne
--                             ou ment (un `x-forwarded-for` se forge).
--     Le refus est `SQLSTATE PT429` : PostgREST le rend en HTTP 429.
--  3. Les huit RPC VOLATILES reçoivent l'appel : `check_answers`, `score_quiz`, les quatre
--     `get_student_*_by_code`, `start_placement_session`, `finish_placement_session`.
--     Corps repris TELS QUELS de leur dernière définition (une ligne ajoutée) ;
--     `supabase/tests/108_rpc_rate_limit.test.sql` échoue si une migration future les
--     redéfinit sans l'appel, ou ouvre une nouvelle RPC anonyme sans la classer.
--  4. `check_rate_limit` (comptes connectés) : la clé est désormais PRÉFIXÉE par
--     `auth.uid()`. Avant, la clé était celle que l'appelant fournissait — un compte pouvait
--     donc vider le seau `submit_<uuid>` d'un autre élève (déni de service ciblé) ou gonfler
--     la table sans borne (`p_max_requests` libre). Plafonds : 1 000 événements, 1 h.
--
-- Ce que cette migration NE fait PAS, et pourquoi :
--  - Les six RPC anonymes STABLE (`get_active_event`, `get_recall_availability`,
--    `parcours_interest_counts`, `list_placement_subjects`, `get_placement_subject`,
--    `get_placement_session`) ne sont pas bornées : PostgREST les exécute dans une
--    transaction en LECTURE SEULE, où l'on ne peut pas compter ; et elles ne lisent rien
--    qu'un `SELECT` anonyme sur le catalogue ne lise déjà (même `statement_timeout`).
--  - Une source = une IP. Le trafic anonyme légitime passe par les fonctions Vercel et
--    arrive donc groupé sous quelques IP de sortie : le palier « source » est dimensionné
--    pour TOUT le site derrière une IP, pas pour un visiteur. Le visiteur individuel reste
--    limité par le premier étage en mémoire (30/min) dans la server fn.
--  - L'IP n'est pas stockée en clair : la clé porte son md5 (pseudonymisation, purge ≤ 1 h).
-- =========================================================

CREATE TABLE IF NOT EXISTS public.rpc_rate_limit_policies (
  scope           TEXT PRIMARY KEY,
  window_seconds  INT  NOT NULL CHECK (window_seconds BETWEEN 1 AND 3600),
  anon_source_max INT  NOT NULL CHECK (anon_source_max > 0),
  anon_global_max INT  NOT NULL CHECK (anon_global_max >= anon_source_max),
  user_max        INT  NOT NULL CHECK (user_max > 0),
  note            TEXT
);

ALTER TABLE public.rpc_rate_limit_policies ENABLE ROW LEVEL SECURITY;
-- Table neuve : aucune policy, aucun droit côté client — seule la fonction (SECURITY
-- DEFINER) la lit. Les seuils ne sont pas un secret, mais rien n'a à les lire.
REVOKE ALL ON public.rpc_rate_limit_policies FROM PUBLIC, anon, authenticated;
GRANT ALL ON public.rpc_rate_limit_policies TO service_role;

COMMENT ON TABLE public.rpc_rate_limit_policies IS
  'Seuils de enforce_rpc_rate_limit, par scope. anon_source_max = tout le trafic anonyme derrière une IP (les fonctions Vercel sortent groupées) ; anon_global_max = tous les anonymes ; user_max = un compte.';

INSERT INTO public.rpc_rate_limit_policies
  (scope, window_seconds, anon_source_max, anon_global_max, user_max, note)
VALUES
  ('check_answers',    60, 300, 1200, 120,
   'Correction publique. Le palier compte inclut reveal_session_answer, qui l''appelle.'),
  ('score_quiz',       60, 300, 1200, 120, 'Score du quiz de compréhension.'),
  ('report_by_code',   60, 300, 1200, 240,
   'Les quatre get_student_*_by_code partagent ce seau (une page /suivi en appelle 2 ou 3).'),
  ('placement_start',  60,  60,  120,  30,
   'S''ajoute à la digue R-18 (120 créations anonymes/min) : une seule source ne la remplit plus.'),
  ('placement_finish', 60, 120,  600,  60, 'Fin de test de niveau.')
ON CONFLICT (scope) DO NOTHING;

CREATE OR REPLACE FUNCTION public.enforce_rpc_rate_limit(p_scope TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_policy  public.rpc_rate_limit_policies%ROWTYPE;
  v_user    UUID := (SELECT auth.uid());
  v_since   TIMESTAMPTZ;
  v_headers JSONB;
  v_source  TEXT;
  v_key     TEXT;
  v_global  TEXT;
BEGIN
  SELECT * INTO v_policy FROM public.rpc_rate_limit_policies WHERE scope = p_scope;
  IF NOT FOUND THEN
    -- Un scope sans ligne ne bloque pas la RPC (une faute de frappe ne doit pas fermer le
    -- site) ; pgTAP 108 exige que chaque scope appelé ait sa ligne.
    RETURN;
  END IF;

  -- Le serveur de confiance (clé service) n'est pas un visiteur.
  IF v_user IS NULL AND (SELECT auth.role()) = 'service_role' THEN
    RETURN;
  END IF;

  -- Purge opportuniste : aucune fenêtre ne dépasse une heure (CHECK ci-dessus, plafond de
  -- check_rate_limit), donc rien de plus vieux ne sert.
  IF random() < 0.01 THEN
    PERFORM public.cleanup_rate_limit_events(1);
  END IF;

  v_since := clock_timestamp() - make_interval(secs => v_policy.window_seconds);

  IF v_user IS NOT NULL THEN
    v_key := 'rpc:' || p_scope || ':u:' || v_user::text;
    IF (SELECT count(*) FROM public.rate_limit_events
         WHERE scope_key = v_key AND created_at >= v_since) >= v_policy.user_max THEN
      RAISE LOG 'rpc_rate_limited scope=% tier=user', p_scope;
      RAISE EXCEPTION 'RATE_LIMITED' USING ERRCODE = 'PT429',
        HINT = 'Trop de requêtes. Réessaie dans un instant.';
    END IF;
    INSERT INTO public.rate_limit_events (scope_key) VALUES (v_key);
    RETURN;
  END IF;

  -- Anonyme. PostgREST expose les en-têtes de la requête ; hors PostgREST (psql, cron) il
  -- n'y en a pas et la source est « unknown » — un seul seau, le plus strict des cas.
  BEGIN
    v_headers := nullif(current_setting('request.headers', true), '')::jsonb;
  EXCEPTION WHEN OTHERS THEN
    v_headers := NULL;
  END;
  v_source := coalesce(
    nullif(btrim(v_headers ->> 'cf-connecting-ip'), ''),
    nullif(btrim(split_part(v_headers ->> 'x-forwarded-for', ',', 1)), ''),
    'unknown'
  );
  v_key    := 'rpc:' || p_scope || ':ip:' || md5(v_source);
  v_global := 'rpc:' || p_scope || ':anon';

  IF (SELECT count(*) FROM public.rate_limit_events
       WHERE scope_key = v_key AND created_at >= v_since) >= v_policy.anon_source_max THEN
    RAISE LOG 'rpc_rate_limited scope=% tier=source', p_scope;
    RAISE EXCEPTION 'RATE_LIMITED' USING ERRCODE = 'PT429',
      HINT = 'Trop de requêtes. Réessaie dans un instant.';
  END IF;
  IF (SELECT count(*) FROM public.rate_limit_events
       WHERE scope_key = v_global AND created_at >= v_since) >= v_policy.anon_global_max THEN
    RAISE LOG 'rpc_rate_limited scope=% tier=global', p_scope;
    RAISE EXCEPTION 'RATE_LIMITED' USING ERRCODE = 'PT429',
      HINT = 'Trop de requêtes. Réessaie dans un instant.';
  END IF;

  -- Pas de verrou : sous concurrence le plafond peut être dépassé de quelques unités, ce
  -- qui vaut mieux que de sérialiser tous les anonymes derrière une ligne chaude.
  INSERT INTO public.rate_limit_events (scope_key) VALUES (v_key), (v_global);
END;
$$;

REVOKE ALL ON FUNCTION public.enforce_rpc_rate_limit(TEXT) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.enforce_rpc_rate_limit(TEXT) TO service_role;

COMMENT ON FUNCTION public.enforce_rpc_rate_limit(TEXT) IS
  'Borne durable des RPC anonymes (S-1). Interne : appelée en première instruction d''une RPC SECURITY DEFINER VOLATILE. Lève PT429 (HTTP 429) au-delà du seuil de rpc_rate_limit_policies.';

-- ---------------------------------------------------------
-- check_rate_limit : la clé appartient à l'appelant
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.check_rate_limit(
  p_key TEXT,
  p_max_requests INT,
  p_window_ms INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user UUID := (SELECT auth.uid());
  v_now TIMESTAMPTZ := clock_timestamp();
  v_window_start TIMESTAMPTZ;
  v_request_count INT;
  v_key TEXT;
  v_max INT;
  v_window_ms INT;
BEGIN
  IF v_user IS NULL THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_key IS NULL OR btrim(p_key) = '' THEN
    RAISE EXCEPTION 'Rate limit key is required';
  END IF;

  IF length(p_key) > 200 THEN
    RAISE EXCEPTION 'Rate limit key is too long';
  END IF;

  IF p_max_requests IS NULL OR p_max_requests <= 0 THEN
    RAISE EXCEPTION 'Invalid max request limit';
  END IF;

  IF p_window_ms IS NULL OR p_window_ms <= 0 THEN
    RAISE EXCEPTION 'Invalid rate limit window';
  END IF;

  -- La clé fournie n'est qu'un SUFFIXE : le seau est celui de l'appelant, quel que soit
  -- le texte envoyé. Un compte ne peut ni lire ni remplir le seau d'un autre.
  v_key := 'u:' || v_user::text || ':' || p_key;
  -- Bornes dures : un seau ne retient jamais plus de 1 000 lignes ni plus d'une heure.
  v_max := least(p_max_requests, 1000);
  v_window_ms := least(p_window_ms, 3600000);

  -- Opportunistic global cleanup (~1% of calls) to avoid stale key accumulation.
  IF random() < 0.01 THEN
    PERFORM public.cleanup_rate_limit_events(1);
  END IF;

  PERFORM pg_advisory_xact_lock(hashtextextended(v_key, 0));

  v_window_start := v_now - make_interval(secs => v_window_ms / 1000.0);

  DELETE FROM public.rate_limit_events
  WHERE scope_key = v_key
    AND created_at < v_window_start;

  SELECT COUNT(*)::INT
  INTO v_request_count
  FROM public.rate_limit_events
  WHERE scope_key = v_key
    AND created_at >= v_window_start;

  IF v_request_count >= v_max THEN
    RETURN TRUE;
  END IF;

  INSERT INTO public.rate_limit_events (scope_key)
  VALUES (v_key);

  RETURN FALSE;
END;
$$;

-- ---------------------------------------------------------
-- Les huit RPC anonymes volatiles, bornées
-- ---------------------------------------------------------
-- check_answers(p_exercise_id uuid, p_answers jsonb) — corps repris tel quel de 20260713120000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.check_answers(p_exercise_id uuid, p_answers jsonb)
 RETURNS TABLE(question_id uuid, is_correct boolean, correct_option text, explanation text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
DECLARE
  v_source text;
  v_mode text;
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('check_answers');

  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'array' THEN
    RETURN;
  END IF;

  SELECT e.source, e.mode
    INTO v_source, v_mode
    FROM public.exercises e
    WHERE e.id = p_exercise_id;

  -- Only the public (admin) catalogue is anonymously checkable; the comprehension
  -- quiz is the gate and is never anonymously corrected.
  IF v_source IS DISTINCT FROM 'admin' OR v_mode = 'quiz' THEN
    RETURN;
  END IF;

  RETURN QUERY
    SELECT
      q.id,
      public.score_answer(q, a.elem ->> 'choice') AS is_correct,
      public.answer_key_display(q) AS correct_option,
      -- The explanation is withheld from anonymous callers (hint-economy content);
      -- signed-in callers keep it, exactly as in the connected post-answer review.
      CASE WHEN auth.uid() IS NULL THEN NULL ELSE q.explanation END AS explanation
    FROM jsonb_array_elements(p_answers) AS a(elem)
    JOIN public.questions q
      ON q.id = nullif(a.elem ->> 'questionId', '')::uuid
    WHERE q.exercise_id = p_exercise_id;
END;
$$;

-- score_quiz(p_exercise_id uuid, p_answers jsonb) — corps repris tel quel de 20260913120000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.score_quiz(p_exercise_id uuid, p_answers jsonb)
 RETURNS TABLE(correct integer, total integer)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
DECLARE
  v_source text;
  v_mode text;
  -- Anonyme ⇒ `auth.uid()` NULL ⇒ false : le catalogue public ne sert jamais
  -- une question ouverte, il ne peut donc pas en compter une.
  v_open_ok boolean := public.can_play_open_questions(auth.uid());
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('score_quiz');

  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'array' THEN
    RETURN QUERY SELECT 0, 0;
    RETURN;
  END IF;

  SELECT e.source, e.mode
    INTO v_source, v_mode
    FROM public.exercises e
    WHERE e.id = p_exercise_id;

  -- Only the public (admin) catalogue's comprehension quiz is scorable here.
  IF v_source IS DISTINCT FROM 'admin' OR v_mode IS DISTINCT FROM 'quiz' THEN
    RETURN QUERY SELECT 0, 0;
    RETURN;
  END IF;

  RETURN QUERY
    SELECT
      (
        SELECT count(*)
          FROM jsonb_array_elements(p_answers) AS a(elem)
          JOIN public.questions q
            ON q.id = nullif(a.elem ->> 'questionId', '')::uuid
         WHERE q.exercise_id = p_exercise_id
           AND public.is_question_in_play(q, v_open_ok)
           AND public.score_answer(q, a.elem ->> 'choice')
      )::integer AS correct,
      (
        SELECT count(*)
          FROM public.questions q
         WHERE q.exercise_id = p_exercise_id
           AND public.is_question_in_play(q, v_open_ok)
      )::integer AS total;
END;
$$;

-- get_student_report_by_code(p_code text) — corps repris tel quel de 20260708120000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.get_student_report_by_code(p_code text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
DECLARE
  v_hex TEXT;
  v_student UUID;
  v_role TEXT;
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('report_by_code');

  v_hex := lower(regexp_replace(p_code, '[^a-fA-F0-9]', '', 'g'));
  IF v_hex !~ '^[0-9a-f]{32}$' THEN
    RAISE EXCEPTION 'Invalid student alliance code.';
  END IF;
  v_student := (
    substr(v_hex, 1, 8) || '-' || substr(v_hex, 9, 4) || '-' || substr(v_hex, 13, 4)
    || '-' || substr(v_hex, 17, 4) || '-' || substr(v_hex, 21, 12)
  )::uuid;

  SELECT role INTO v_role FROM public.profiles WHERE id = v_student;
  IF v_role IS NULL THEN
    RAISE EXCEPTION 'Student not found.';
  END IF;
  IF v_role IS DISTINCT FROM 'student' THEN
    RAISE EXCEPTION 'This code does not belong to a student account.';
  END IF;

  RETURN public._student_report_json(v_student);
END;
$$;

-- get_student_daily_report_by_code(p_code text, p_from date, p_to date) — corps repris tel quel de 20260817120000 / 20260817160000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.get_student_daily_report_by_code(p_code text, p_from date, p_to date)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('report_by_code');

  RETURN public._student_daily_report_json(
    public._student_id_from_alliance_code(p_code), p_from, p_to
  );
END;
$$;

-- get_student_daily_report_by_code(p_code text, p_from date, p_to date, p_scope text) — corps repris tel quel de 20260817120000 / 20260817160000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.get_student_daily_report_by_code(p_code text, p_from date, p_to date, p_scope text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
DECLARE
  v_student UUID;
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('report_by_code');

  v_student := public._student_id_from_alliance_code(p_code);
  RETURN public._daily_report_with_scopes(v_student, p_from, p_to, p_scope);
END;
$$;

-- get_student_attempt_detail_by_code(p_code text, p_attempt uuid) — corps repris tel quel de 20260816200000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.get_student_attempt_detail_by_code(p_code text, p_attempt uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('report_by_code');

  RETURN public._student_attempt_detail_json(
    public._student_id_from_alliance_code(p_code), p_attempt
  );
END;
$$;

-- start_placement_session(p_subject_id text, p_audience text) — corps repris tel quel de 20261101100000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.start_placement_session(p_subject_id text, p_audience text DEFAULT 'student'::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
DECLARE
  v_user         UUID := (SELECT auth.uid());
  v_items        CONSTANT INT := 10;   -- PLACEMENT_ITEMS (R-1), miroir en constante client
  v_min_items    CONSTANT INT := 5;    -- en deçà, la matière n'est pas testable (R-1)
  v_flood_cap    CONSTANT INT := 120;  -- créations anonymes par minute, toute la plateforme (R-18)
  v_question_ids UUID[];
  v_row          public.placement_sessions%ROWTYPE;
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('placement_start');

  IF p_audience IS NULL OR p_audience NOT IN ('student', 'parent') THEN
    RAISE EXCEPTION 'Invalid audience';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.subjects s WHERE s.id = p_subject_id) THEN
    RAISE EXCEPTION 'PLACEMENT_SUBJECT_NOT_FOUND';
  END IF;

  -- La digue (R-18) : seulement pour l'anonyme — un compte est déjà limité par
  -- `check_rate_limit` dans la server fn, et nommé.
  IF v_user IS NULL AND (
       SELECT count(*)
         FROM public.placement_sessions ps
        WHERE ps.user_id IS NULL
          AND ps.started_at > now() - interval '1 minute'
     ) >= v_flood_cap THEN
    RAISE EXCEPTION 'PLACEMENT_BUSY';
  END IF;

  WITH elig AS (
    SELECT * FROM public.placement_eligible_questions(p_subject_id)
  ),
  ch AS (
    SELECT chapter_id,
           dense_rank() OVER (ORDER BY min(chapter_order), chapter_id) AS idx,
           count(*)     OVER ()                                         AS cnt
      FROM elig
     GROUP BY chapter_id
  ),
  picked AS (
    SELECT DISTINCT ON (floor((idx - 1) * LEAST(v_items, cnt)::numeric / cnt))
           chapter_id, idx
      FROM ch
     ORDER BY floor((idx - 1) * LEAST(v_items, cnt)::numeric / cnt), idx
  ),
  by_exercise AS (
    -- Le rang d'une question DANS sa mission (aléatoire) : il passe avant tout, pour que la
    -- seconde question d'un chapitre vienne d'une autre mission que la première.
    SELECT el.question_id,
           el.chapter_id,
           el.difficulty,
           p.idx,
           row_number() OVER (PARTITION BY el.chapter_id, el.exercise_id ORDER BY random()) AS ex_rn
      FROM elig el
      JOIN picked p ON p.chapter_id = el.chapter_id
  ),
  ranked AS (
    SELECT question_id,
           idx,
           row_number() OVER (
             PARTITION BY chapter_id
             ORDER BY ex_rn, (difficulty > 2), random()
           ) AS rn
      FROM by_exercise
  ),
  chosen AS (
    SELECT question_id, idx, rn
      FROM ranked
     ORDER BY rn, idx
     LIMIT v_items
  )
  SELECT array_agg(question_id ORDER BY idx, rn)
    INTO v_question_ids
    FROM chosen;

  IF v_question_ids IS NULL OR cardinality(v_question_ids) < v_min_items THEN
    RAISE EXCEPTION 'PLACEMENT_NOT_ENOUGH_QUESTIONS';
  END IF;

  INSERT INTO public.placement_sessions (user_id, subject_id, audience, question_ids)
  VALUES (v_user, p_subject_id, p_audience, v_question_ids)
  RETURNING * INTO v_row;

  RETURN jsonb_build_object(
    'id', v_row.id,
    -- R-14 : la SEULE fois où le jeton sort.
    'token', v_row.token,
    'status', v_row.status,
    'audience', v_row.audience,
    'startedAt', v_row.started_at,
    'subject', public.placement_subject_json(v_row.subject_id),
    'questions', public.placement_questions_json(v_row.question_ids)
  );
END;
$$;

-- finish_placement_session(p_session_id uuid, p_token uuid, p_answers jsonb, p_duration_seconds integer) — corps repris tel quel de 20261101100000, une ligne ajoutée.
CREATE OR REPLACE FUNCTION public.finish_placement_session(p_session_id uuid, p_token uuid DEFAULT NULL::uuid, p_answers jsonb DEFAULT '{}'::jsonb, p_duration_seconds integer DEFAULT 0)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path = public
AS $$
DECLARE
  v_user      UUID := (SELECT auth.uid());
  v_row       public.placement_sessions%ROWTYPE;
  v_clean     JSONB;
  v_questions JSONB;
  v_chapters  JSONB;
  v_correct   INT;
  v_total     INT;
BEGIN
  -- Borne durable (S-1) : voir public.enforce_rpc_rate_limit.
  PERFORM public.enforce_rpc_rate_limit('placement_finish');

  -- Un seul message pour « id inconnu » et « jeton faux » : pas d'oracle sur l'existence.
  SELECT * INTO v_row
    FROM public.placement_sessions
   WHERE id = p_session_id
     AND (
           (p_token IS NOT NULL AND token = p_token)
        OR (v_user IS NOT NULL AND user_id = v_user)
     )
     FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'PLACEMENT_NOT_FOUND';
  END IF;

  IF v_row.status = 'completed' THEN
    RETURN public.placement_bilan_json(v_row, v_user IS NOT NULL AND v_row.user_id = v_user);
  END IF;

  -- Les réponses sont FILTRÉES, jamais rejetées en bloc : une clé étrangère au test ou une
  -- valeur hors bornes est ignorée, le reste compte (patron `save_mock_answers`).
  IF p_answers IS NULL OR jsonb_typeof(p_answers) <> 'object' THEN
    p_answers := '{}'::jsonb;
  END IF;
  SELECT COALESCE(jsonb_object_agg(kv.key, kv.value), '{}'::jsonb)
    INTO v_clean
    FROM jsonb_each_text(p_answers) AS kv(key, value)
   WHERE length(kv.value) BETWEEN 1 AND 512
     -- Comparé en TEXTE : une clé qui n'est pas un UUID est ignorée, jamais castée (un
     -- payload bricolé ne doit pas lever au milieu d'une fin de test).
     AND kv.key IN (SELECT qid::text FROM unnest(v_row.question_ids) AS qid);

  -- Le jugement : `score_answer`, le seul juge du projet. Une question sans réponse vaut
  -- faux (`score_answer(q, NULL)` rend false par contrat), une question disparue ne compte
  -- plus (le dénominateur est ce qui existe encore à l'instant de la note).
  WITH played AS (
    SELECT u.qid, u.ord
      FROM unnest(v_row.question_ids) WITH ORDINALITY AS u(qid, ord)
  ),
  scored AS (
    SELECT p.ord,
           q.id                           AS question_id,
           c.id                           AS chapter_id,
           c.title                        AS chapter_title,
           c.display_order                AS chapter_order,
           (c.lesson_content IS NOT NULL AND length(btrim(c.lesson_content)) > 0) AS has_lesson,
           v_clean ->> q.id::text         AS choice,
           public.score_answer(q, v_clean ->> q.id::text) AS ok
      FROM played p
      JOIN public.questions q ON q.id = p.qid
      JOIN public.exercises e ON e.id = q.exercise_id
      JOIN public.chapters  c ON c.id = e.chapter_id
  ),
  per_chapter AS (
    SELECT chapter_id, min(chapter_title) AS title, min(chapter_order) AS display_order,
           bool_or(has_lesson) AS has_lesson,
           count(*) FILTER (WHERE ok)::INT AS correct,
           count(*)::INT AS total
      FROM scored
     GROUP BY chapter_id
  )
  SELECT
    (SELECT COALESCE(jsonb_agg(jsonb_build_object(
               'questionId', s.question_id,
               'chapterId', s.chapter_id,
               'choice', s.choice,
               'isCorrect', s.ok
             ) ORDER BY s.ord), '[]'::jsonb) FROM scored s),
    (SELECT COALESCE(jsonb_agg(jsonb_build_object(
               'chapterId', pc.chapter_id,
               'title', pc.title,
               'displayOrder', pc.display_order,
               'correct', pc.correct,
               'total', pc.total,
               'held', pc.correct = pc.total,
               'hasLesson', pc.has_lesson
             ) ORDER BY pc.display_order, pc.chapter_id), '[]'::jsonb) FROM per_chapter pc),
    (SELECT count(*) FILTER (WHERE s.ok)::INT FROM scored s),
    (SELECT count(*)::INT FROM scored s)
    INTO v_questions, v_chapters, v_correct, v_total;

  UPDATE public.placement_sessions
     SET status           = 'completed',
         finished_at      = now(),
         duration_seconds = GREATEST(0, COALESCE(p_duration_seconds, 0)),
         answers          = v_clean,
         correct_count    = v_correct,
         total_count      = v_total,
         result           = jsonb_build_object('questions', v_questions, 'chapters', v_chapters)
   WHERE id = v_row.id
   RETURNING * INTO v_row;

  RETURN public.placement_bilan_json(v_row, v_user IS NOT NULL AND v_row.user_id = v_user);
END;
$$;

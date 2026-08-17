-- Suivi parental — le filtre devient une LISTE des parcours et niveaux que
-- l'élève utilise réellement, au lieu d'un interrupteur « sa classe / tout ».
--
-- LE BESOIN. Un élève ne travaille pas que sa classe : il révise l'année d'avant,
-- suit un extra, prépare un concours. « Sa classe / tout » ne permettait pas de
-- regarder l'une de ces pistes isolément — or c'est précisément ce qu'un parent
-- veut faire quand il se demande si la révision de 8ème avance.
--
-- LA CLÉ DE REGROUPEMENT. Une matière porte un niveau (`subjects.grade_id`) ou
-- n'en porte pas. Avec niveau, on regroupe par NIVEAU (« 9ème année ») ; sans
-- niveau, par THÈME (« Culture générale », « Éducation islamique »), sinon tous
-- les extras se retrouveraient dans un même sac anonyme. C'est ce qui donne la
-- lecture demandée : les parcours ET les niveaux qu'il utilise.
--
-- LA LISTE EST CALCULÉE SUR TOUT L'HISTORIQUE, jamais sur la période affichée.
-- Sinon choisir « aujourd'hui » ferait disparaître les options non travaillées
-- aujourd'hui — dont celle qu'on vient de sélectionner. Un sélecteur qui se vide
-- en cours de route est inutilisable.
--
-- FORME. Aucune reprise du calcul du rapport : les enveloppes ENRICHISSENT la
-- charge utile (`||` et `jsonb_set`). La fonction de 460 lignes n'est pas
-- rouverte, donc ce lot ne peut pas y introduire de régression.
--
-- DEGRÉ DE TOLÉRANCE. Un périmètre inconnu retombe sur « tout ». Un filtre qui
-- lèverait une erreur sur une clé périmée — un niveau retiré du catalogue, un
-- favori gardé par le navigateur — casserait l'écran au lieu de le dégrader.

-- ---------------------------------------------------------------------------
-- 1. Les matières d'un périmètre. `NULL` = aucun filtre.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._scope_subject_ids(p_student UUID, p_scope TEXT)
RETURNS TEXT[]
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_ids TEXT[];
BEGIN
  IF p_scope IS NULL OR p_scope = 'all' THEN
    RETURN NULL;
  END IF;

  -- « class » reste compris : c'est ce que le client livré en #762 envoie.
  IF p_scope = 'class' THEN
    RETURN public._student_class_subject_ids(p_student);
  END IF;

  IF p_scope LIKE 'grade:%' THEN
    BEGIN
      SELECT array_agg(s.id) INTO v_ids
      FROM public.subjects s
      WHERE s.grade_id = substr(p_scope, 7)::uuid;
    EXCEPTION WHEN invalid_text_representation THEN
      -- Clé mal formée : on ne filtre pas plutôt que de casser l'écran.
      RETURN NULL;
    END;
    -- Vide = rien à montrer : on ne filtre pas plutôt que de rendre un écran nu.
    RETURN CASE WHEN v_ids IS NULL OR cardinality(v_ids) = 0 THEN NULL ELSE v_ids END;
  END IF;

  IF p_scope LIKE 'theme:%' THEN
    SELECT array_agg(s.id) INTO v_ids
    FROM public.subjects s
    WHERE s.theme_id = substr(p_scope, 7)
      AND s.grade_id IS NULL;
    -- Vide = rien à montrer : on ne filtre pas plutôt que de rendre un écran nu.
    RETURN CASE WHEN v_ids IS NULL OR cardinality(v_ids) = 0 THEN NULL ELSE v_ids END;
  END IF;

  RETURN NULL;
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._scope_subject_ids(UUID, TEXT)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 2. Les périmètres où l'élève a RÉELLEMENT de l'activité — sur tout son
--    historique, pour que la liste ne bouge pas avec la période choisie.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._student_activity_scopes(p_student UUID)
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  WITH touched AS (
    -- Une matière est « utilisée » dès qu'elle porte une tentative ou du temps.
    SELECT a.subject_id FROM public.attempts a WHERE a.user_id = p_student
    UNION
    SELECT lp.subject_id FROM public.learning_pulses lp
     WHERE lp.user_id = p_student AND lp.subject_id IS NOT NULL
  ),
  grouped AS (
    SELECT
      CASE WHEN s.grade_id IS NOT NULL
           THEN 'grade:' || s.grade_id::text
           ELSE 'theme:' || s.theme_id END AS key,
      CASE WHEN s.grade_id IS NOT NULL THEN 'grade' ELSE 'theme' END AS kind,
      COALESCE(g.name_fr, th.name_fr, s.theme_id) AS label,
      COALESCE(g.display_order, 900 + th.display_order) AS sort_order,
      (s.grade_id IS NOT NULL AND s.grade_id = p.current_grade_id) AS is_current
      FROM touched t
      JOIN public.subjects s ON s.id = t.subject_id
      LEFT JOIN public.grades g ON g.id = s.grade_id
      LEFT JOIN public.themes th ON th.id = s.theme_id
      CROSS JOIN (SELECT current_grade_id FROM public.profiles WHERE id = p_student) p
  )
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'key', r.key,
        'kind', r.kind,
        'label', r.label,
        -- La classe de l'élève est mise en tête côté client, pas ici : le
        -- serveur rend des faits, l'ordre d'affichage est une décision d'écran.
        'isCurrent', r.is_current
      ) ORDER BY r.is_current DESC, r.sort_order, r.label
    ),
    '[]'::jsonb
  )
  FROM (SELECT DISTINCT key, kind, label, sort_order, is_current FROM grouped) r;
$fn$;

REVOKE EXECUTE ON FUNCTION public._student_activity_scopes(UUID)
  FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- 3. Les enveloppes : elles résolvent le périmètre, puis ENRICHISSENT la charge
--    utile. Le calcul du rapport n'est pas rouvert.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public._daily_report_with_scopes(
  p_student UUID,
  p_from DATE,
  p_to DATE,
  p_scope TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_scope TEXT;
  v_subject_ids TEXT[];
  v_payload JSONB;
  v_scopes JSONB;
  v_applied TEXT;
  v_label TEXT;
BEGIN
  -- « class » est un alias du niveau courant. Le résoudre ici plutôt que de le
  -- laisser tel quel évite une clé qui n'existe dans aucune entrée de la liste —
  -- le sélecteur ne saurait ni la surligner ni la nommer.
  v_scope := p_scope;
  IF v_scope = 'class' THEN
    SELECT 'grade:' || pr.current_grade_id::text INTO v_scope
    FROM public.profiles pr
    WHERE pr.id = p_student AND pr.current_grade_id IS NOT NULL;
    v_scope := COALESCE(v_scope, 'all');
  END IF;

  v_subject_ids := public._scope_subject_ids(p_student, v_scope);
  v_scopes := public._student_activity_scopes(p_student);

  -- Ce qui a VRAIMENT été appliqué : un périmètre qui ne filtre rien s'annonce
  -- « all », sinon le sélecteur afficherait une sélection que les chiffres
  -- démentent.
  v_applied := CASE WHEN v_subject_ids IS NULL THEN 'all' ELSE COALESCE(v_scope, 'all') END;

  SELECT s ->> 'label' INTO v_label
  FROM jsonb_array_elements(v_scopes) s
  WHERE s ->> 'key' = v_applied;

  v_payload := public._student_daily_report_json(p_student, p_from, p_to, v_subject_ids);

  v_payload := jsonb_set(v_payload, '{scope,applied}', to_jsonb(v_applied));
  v_payload := jsonb_set(v_payload, '{scope,label}', COALESCE(to_jsonb(v_label), 'null'::jsonb));

  RETURN v_payload || jsonb_build_object('scopes', v_scopes);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public._daily_report_with_scopes(UUID, DATE, DATE, TEXT)
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.get_student_daily_report(
  p_student UUID,
  p_from DATE,
  p_to DATE,
  p_scope TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  PERFORM public.assert_can_read_student_activity(p_student);
  RETURN public._daily_report_with_scopes(p_student, p_from, p_to, p_scope);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE, TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report(UUID, DATE, DATE, TEXT) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_student_daily_report_by_code(
  p_code TEXT,
  p_from DATE,
  p_to DATE,
  p_scope TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_student UUID;
BEGIN
  v_student := public._student_id_from_alliance_code(p_code);
  RETURN public._daily_report_with_scopes(v_student, p_from, p_to, p_scope);
END;
$fn$;

REVOKE EXECUTE ON FUNCTION public.get_student_daily_report_by_code(TEXT, DATE, DATE, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_student_daily_report_by_code(TEXT, DATE, DATE, TEXT)
  TO anon, authenticated;

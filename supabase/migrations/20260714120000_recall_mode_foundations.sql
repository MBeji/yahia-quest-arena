-- Étude 17 — Rappel actif · lot 1 (FableEtudes/17-rappel-actif#lot-1).
-- Fondations SQL pures du mode « Rappel » (rejouer un QCM maîtrisé en saisie libre).
-- DB-only : rien d'appelable par le client (les 3 fonctions sont REVOKE'd) ; le défaut
-- 'classic' des deux colonnes garantit que le code déployé continue de fonctionner à
-- l'identique (DoD §7 — migration additive AVANT le code des lots suivants).
--
-- Contenu (spec §3) :
--   * colonnes discriminantes `variant` (exercise_sessions, attempts) + index anti-farm ;
--   * `normalize_recall_text`  — pipeline de normalisation IMMUTABLE, 100 % SQL pur (D-2) ;
--   * `is_question_recall_eligible` — éligibilité déterministe R-2 (a)–(i) ;
--   * `score_recall_answer` — comparaison normalisée stricte, tout-ou-rien (R-4) ;
--   * REVOKEs — la clé de réponse reste server-only, pas d'oracle client (R-1).
-- `score_answer` (étude 03) n'est PAS touchée (D-3). Aucune nouvelle table → aucun grant
-- nouveau : les écritures passent par les RPCs DEFINER (lot 2) et le SELECT RLS « own rows »
-- existant expose la colonne `variant` sans risque.

-- ---------------------------------------------------------------------------
-- 1. Modèle de données — deux colonnes additives (défaut = existant, zéro backfill).
-- ---------------------------------------------------------------------------
ALTER TABLE public.exercise_sessions
  ADD COLUMN IF NOT EXISTS variant text NOT NULL DEFAULT 'classic'
  CHECK (variant IN ('classic', 'recall'));

ALTER TABLE public.attempts
  ADD COLUMN IF NOT EXISTS variant text NOT NULL DEFAULT 'classic'
  CHECK (variant IN ('classic', 'recall'));

-- Anti-farm scopé + déverrouillage : MAX(score_pct)/EXISTS par (user, exercise, variant).
CREATE INDEX IF NOT EXISTS idx_attempts_user_exercise_variant
  ON public.attempts (user_id, exercise_id, variant);

-- ---------------------------------------------------------------------------
-- 2. Normalisation — IMMUTABLE, pur SQL, AUCUNE extension (unaccent/citext/pg_trgm
--    absents — D-2). Les maps translate() sont closes et déterministes. Appliquée aux
--    DEUX côtés de la comparaison (R-4). Pipeline exact (ordre = spec §3) :
--      1. NFKC puis lower()
--      2. dé-accentuation latine (translate) + pliage des ligatures œ→oe, æ→ae
--         (NFKC ne les décompose pas)
--      3. arabe : suppression tashkeel/tatweel, pliage أ/إ/آ→ا, ى→ي, ة→ه
--      4. chiffres arabes-indics (٠-٩ / ۰-۹) → occidentaux
--      5. (jonction des groupes de chiffres séparés par espaces — réalisée par l'étape 9)
--      6. virgule décimale → point (séparateurs latin ',' et arabe '٫')
--      7. suppression de toute ponctuation/symbole SAUF '.' (%/° rendus insignifiants)
--      8. suppression des '.' non intercalés entre deux chiffres
--      9. suppression de TOUS les espaces (comparaison insensible à la segmentation)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.normalize_recall_text(p text)
RETURNS text
IMMUTABLE
LANGUAGE sql
SET search_path = public
AS $$
  WITH step1 AS (                                    -- (1) NFKC + casse
    SELECT lower(normalize(coalesce(p, ''), NFKC)) AS t
  ),
  step2 AS (                                          -- (2) ligatures + dé-accent latin
    SELECT translate(
             replace(replace(t, 'œ', 'oe'), 'æ', 'ae'),
             'àâäáãéèêëïîíôöòõùûüúÿçñ',
             'aaaaaeeeeiiioooouuuuycn'
           ) AS t FROM step1
  ),
  step3 AS (                                          -- (3) arabe : tashkeel/tatweel + pliages
    SELECT translate(
             regexp_replace(t, '[ً-ْـٰ]', '', 'g'),
             'أإآىة', 'ااايه'
           ) AS t FROM step2
  ),
  step4 AS (                                          -- (4) chiffres arabes-indics → occidentaux
    SELECT translate(t, '٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹', '01234567890123456789') AS t FROM step3
  ),
  step6 AS (                                          -- (6) virgule décimale → point
    SELECT replace(replace(t, '٫', '.'), ',', '.') AS t FROM step4
  ),
  step7 AS (                                          -- (7) purge symboles/ponctuation sauf '.'
    SELECT regexp_replace(t, '[^a-z0-9. ء-ي]', '', 'g') AS t FROM step6
  ),
  step8 AS (                                          -- (8) ne garder que les '.' intercalés
    SELECT replace(
             replace(
               regexp_replace(
                 regexp_replace(t, '([0-9])\.([0-9])', '\1' || chr(1) || '\2', 'g'),
                 '([0-9])\.([0-9])', '\1' || chr(1) || '\2', 'g'
               ),
               '.', ''
             ),
             chr(1), '.'
           ) AS t FROM step7
  )
  SELECT regexp_replace(t, '[[:space:]]', '', 'g') FROM step8;  -- (9) suppression des espaces
$$;

-- ---------------------------------------------------------------------------
-- 3. Éligibilité question (R-2 a–i) — IMMUTABLE, fonction du seul row `questions`.
--    Volontairement conservatrice (précision d'abord : un refus injuste coûte plus cher
--    qu'une question non proposée — annexe §9). Listes closes en tête.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_question_recall_eligible(q public.questions)
RETURNS boolean
IMMUTABLE
LANGUAGE plpgsql
SET search_path = public
AS $func$
DECLARE
  v_text  text;   -- texte affiché de la bonne option
  v_norm  text;   -- sa forme normalisée (R-4)
  v_words int;
BEGIN
  -- (a) QCM avec une bonne option (le contenu généré écrit toujours 'mcq' explicitement).
  IF q.question_type IS DISTINCT FROM 'mcq' OR q.correct_option IS NULL THEN
    RETURN false;
  END IF;

  -- (b) au moins 3 options.
  IF q.options IS NULL
     OR jsonb_typeof(q.options) <> 'array'
     OR jsonb_array_length(q.options) < 3 THEN
    RETURN false;
  END IF;

  -- Résolution du texte de la bonne option.
  SELECT opt ->> 'text' INTO v_text
  FROM jsonb_array_elements(q.options) AS opt
  WHERE opt ->> 'id' = q.correct_option
  LIMIT 1;

  IF v_text IS NULL THEN
    RETURN false;
  END IF;

  -- (c) 1–60 caractères, une seule ligne, ≤ 6 mots.
  IF char_length(v_text) < 1 OR char_length(v_text) > 60 THEN
    RETURN false;
  END IF;
  IF v_text ~ '[\n\r]' THEN
    RETURN false;
  END IF;
  v_words := coalesce(array_length(regexp_split_to_array(btrim(v_text), '\s+'), 1), 0);
  IF v_words = 0 OR v_words > 6 THEN
    RETURN false;
  END IF;

  -- (d) sans contenu riche.
  IF v_text ~* '(<svg|<img|\!\[|\$\$|http)' THEN
    RETURN false;
  END IF;

  -- (e) sans symbole mathématique de structure (incl. exposants/indices Unicode).
  IF v_text ~ '[=<>^√×÷±≤≥≠≈→∈∪∩²³¹⁰-⁹₀-₉]' THEN
    RETURN false;
  END IF;

  -- (f) sans marqueur composite : '/', '…', '...', '___', parenthèse ouvrante initiale.
  IF v_text ~ '[/…]'
     OR v_text LIKE '%...%'
     OR v_text ~ '_{3,}'
     OR btrim(v_text) LIKE '(%' THEN
    RETURN false;
  END IF;

  -- (g) énoncé auto-suffisant : ne matche aucun motif « dépendant des options » (liste close).
  IF coalesce(q.prompt, '') ~* '(lequel|laquelle|lesquel|parmi|suivante?s?|ci-dessous|ci-dessus|intrus|incorrect|which of|following|below|odd one out|مما يلي|من بين|أي من|الدخيل|الخاطئ)' THEN
    RETURN false;
  END IF;

  -- Normalisation unique de la bonne réponse (R-4).
  v_norm := public.normalize_recall_text(v_text);

  -- (i) charset tapable au clavier (rejette aussi une réponse qui se normalise en vide).
  IF v_norm !~ '^[a-z0-9.ء-ي]+$' THEN
    RETURN false;
  END IF;

  -- (h) pas de collision : la bonne réponse normalisée ≠ un distracteur normalisé.
  IF EXISTS (
    SELECT 1
    FROM jsonb_array_elements(q.options) AS opt
    WHERE opt ->> 'id' IS DISTINCT FROM q.correct_option
      AND public.normalize_recall_text(opt ->> 'text') = v_norm
  ) THEN
    RETURN false;
  END IF;

  RETURN true;
END;
$func$;

-- ---------------------------------------------------------------------------
-- 4. Scoring Rappel — STABLE. `score_answer` (étude 03) n'est PAS modifiée (D-3).
--    Comparaison normalisée stricte, tout-ou-rien ; réponse vide/blanche = fausse.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.score_recall_answer(q public.questions, p_choice text)
RETURNS boolean
STABLE
LANGUAGE sql
SET search_path = public
AS $$
  SELECT public.normalize_recall_text(p_choice) = public.normalize_recall_text(
           (SELECT opt ->> 'text'
              FROM jsonb_array_elements(q.options) opt
             WHERE opt ->> 'id' = q.correct_option
             LIMIT 1)
         )
     AND btrim(coalesce(p_choice, '')) <> '';
$$;

-- ---------------------------------------------------------------------------
-- 5. Server-side only (R-1) — pas d'oracle de réponse côté client.
-- ---------------------------------------------------------------------------
REVOKE EXECUTE ON FUNCTION public.normalize_recall_text(text)
  FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.is_question_recall_eligible(public.questions)
  FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.score_recall_answer(public.questions, text)
  FROM PUBLIC, anon, authenticated;

-- Native question types — phase B3 lot B3.1 (FableEtudes/03-types-questions-natifs #lot-B3.1).
-- Spec normative : docs/interactive-question-types.md (Tier B).
--
-- Extends THE scoring seam (`score_answer`, D-1) with the LAST Tier-B type —
-- the five scoring RPCs already call it, so once again no RPC rewiring:
--   * `multi` — key `{correct:["a","c"]}`, answer `choice:"a,c"` (sorted id
--     CSV) : SET equality of the checked ids (order-insensitive, duplicates
--     collapse), no partial credit (R-2). A subset or superset scores false.
--   Malformed answers/keys score false and never raise (R-3); mcq, numeric,
--   ordering and matching semantics are strictly unchanged.
--
-- `answer_key_display` gains the matching serialization ('multi' → sorted id
-- CSV, the same wire format as `choice`); the three correction-revealing RPCs
-- call the helper and need no change.

CREATE OR REPLACE FUNCTION public.score_answer(q public.questions, p_choice text)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
  v_answer numeric;
  v_value numeric;
  v_tolerance numeric;
BEGIN
  IF p_choice IS NULL THEN
    RETURN false;
  END IF;

  -- 'mcq' fast path: strictly the historical semantics (zero regression, US-4).
  IF q.question_type = 'mcq' OR q.question_type IS NULL THEN
    RETURN q.correct_option = p_choice;
  END IF;

  IF q.question_type = 'numeric' THEN
    IF q.answer_key IS NULL OR NOT (q.answer_key ? 'value') THEN
      RETURN false;
    END IF;
    BEGIN
      -- Accept '-', '.' and ',' (normalized) — US-1. Unparseable input is a
      -- wrong answer, never an exception (a bad payload must not kill a session).
      v_answer := replace(btrim(p_choice), ',', '.')::numeric;
      v_value := (q.answer_key ->> 'value')::numeric;
      v_tolerance := COALESCE((q.answer_key ->> 'tolerance')::numeric, 0);
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
    RETURN abs(v_answer - v_value) <= v_tolerance;
  END IF;

  -- 'ordering': the submitted id CSV must reproduce the key's EXACT sequence.
  -- All-or-nothing (no partial credit, spec R-2); whitespace-insensitive.
  IF q.question_type = 'ordering' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'order') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(t.part ORDER BY t.ord), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) WITH ORDINALITY AS t(part, ord)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(k.val ORDER BY k.ord), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'matching': the submitted "left:right" pair CSV must equal the key's pair
  -- SET (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'matching' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'pairs') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(
          array_agg(DISTINCT ((p.pair ->> 0) || ':' || (p.pair ->> 1))
                    ORDER BY ((p.pair ->> 0) || ':' || (p.pair ->> 1))),
          ARRAY[]::text[]
        )
        FROM jsonb_array_elements(q.answer_key -> 'pairs') AS p(pair)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- 'multi': the checked option ids as a CSV — SET equality with the key
  -- (order-insensitive, duplicates collapse, no partial credit).
  IF q.question_type = 'multi' THEN
    IF q.answer_key IS NULL
       OR jsonb_typeof(q.answer_key -> 'correct') IS DISTINCT FROM 'array' THEN
      RETURN false;
    END IF;
    BEGIN
      RETURN (
        SELECT COALESCE(array_agg(DISTINCT t.part ORDER BY t.part), ARRAY[]::text[])
        FROM unnest(string_to_array(replace(p_choice, ' ', ''), ',')) AS t(part)
        WHERE t.part <> ''
      ) = (
        SELECT COALESCE(array_agg(DISTINCT k.val ORDER BY k.val), ARRAY[]::text[])
        FROM jsonb_array_elements_text(q.answer_key -> 'correct') AS k(val)
      );
    EXCEPTION WHEN OTHERS THEN
      RETURN false;
    END;
  END IF;

  -- Unknown / future types: score false, never crash (R-3).
  RETURN false;
END;
$$;

-- Server-side only (unchanged posture): no client answer-key oracle.
REVOKE EXECUTE ON FUNCTION public.score_answer(public.questions, text) FROM PUBLIC, anon, authenticated;

-- ---------------------------------------------------------------------------
-- Canonical answer display — 'multi' serializes as the sorted id CSV.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.answer_key_display(q public.questions)
RETURNS text
LANGUAGE sql
STABLE
SET search_path = public
AS $$
  SELECT CASE q.question_type
    WHEN 'numeric' THEN q.answer_key ->> 'value'
    WHEN 'ordering' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'order') = 'array' THEN (
        SELECT string_agg(k.val, ',' ORDER BY k.ord)
        FROM jsonb_array_elements_text(q.answer_key -> 'order') WITH ORDINALITY AS k(val, ord)
      ) END
    WHEN 'matching' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'pairs') = 'array' THEN (
        SELECT string_agg((p.pair ->> 0) || ':' || (p.pair ->> 1), ',' ORDER BY p.ord)
        FROM jsonb_array_elements(q.answer_key -> 'pairs') WITH ORDINALITY AS p(pair, ord)
      ) END
    WHEN 'multi' THEN
      CASE WHEN jsonb_typeof(q.answer_key -> 'correct') = 'array' THEN (
        SELECT string_agg(k.val, ',' ORDER BY k.val)
        FROM jsonb_array_elements_text(q.answer_key -> 'correct') AS k(val)
      ) END
    ELSE q.correct_option
  END;
$$;

REVOKE EXECUTE ON FUNCTION public.answer_key_display(public.questions) FROM PUBLIC, anon, authenticated;

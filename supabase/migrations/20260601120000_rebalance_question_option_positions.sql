-- Rebalance question option positions so correct answers are not overwhelmingly stored as "a".
-- The mapping is deterministic per question content, but distributed across positions.

WITH ranked_questions AS (
  SELECT
    q.id,
    q.exercise_id,
    q.prompt,
    q.options,
    q.correct_option,
    jsonb_array_length(q.options) AS option_count,
    row_number() OVER (
      ORDER BY md5(q.exercise_id::text || '|' || q.prompt), q.id
    ) AS question_rank
  FROM public.questions AS q
  WHERE jsonb_typeof(q.options) = 'array'
    AND jsonb_array_length(q.options) >= 2
),
correct_rows AS (
  SELECT
    rq.id,
    option_item.option,
    option_item.option->>'id' AS original_id,
    TRUE AS is_correct,
    1 + ((rq.question_rank - 1) % rq.option_count) AS new_position
  FROM ranked_questions AS rq
  CROSS JOIN LATERAL jsonb_array_elements(rq.options) AS option_item(option)
  WHERE option_item.option->>'id' = rq.correct_option
),
distractor_rows AS (
  SELECT
    d.id,
    d.option,
    d.original_id,
    FALSE AS is_correct,
    CASE
      WHEN d.distractor_rank < d.target_position THEN d.distractor_rank
      ELSE d.distractor_rank + 1
    END AS new_position
  FROM (
    SELECT
      rq.id,
      rq.exercise_id,
      rq.prompt,
      option_item.option,
      option_item.option->>'id' AS original_id,
      1 + ((rq.question_rank - 1) % rq.option_count) AS target_position,
      row_number() OVER (
        PARTITION BY rq.id
        ORDER BY md5(rq.exercise_id::text || '|' || rq.prompt || '|' || (option_item.option->>'id')), option_item.option->>'id'
      ) AS distractor_rank
    FROM ranked_questions AS rq
    CROSS JOIN LATERAL jsonb_array_elements(rq.options) AS option_item(option)
    WHERE option_item.option->>'id' <> rq.correct_option
  ) AS d
),
remapped_options AS (
  SELECT
    combined.id,
    jsonb_agg(
      jsonb_set(combined.option, '{id}', to_jsonb(chr((96 + combined.new_position)::int)))
      ORDER BY combined.new_position
    ) AS new_options,
    max(chr((96 + combined.new_position)::int)) FILTER (WHERE combined.is_correct) AS new_correct_option
  FROM (
    SELECT * FROM correct_rows
    UNION ALL
    SELECT * FROM distractor_rows
  ) AS combined
  GROUP BY combined.id
)
UPDATE public.questions AS q
SET options = remapped_options.new_options,
    correct_option = remapped_options.new_correct_option
FROM remapped_options
WHERE q.id = remapped_options.id;

UPDATE public.questions
SET explanation = replace(
  explanation,
  'Seule la phrase (a) respecte cette règle.',
  'Seule la phrase correcte respecte cette règle.'
)
WHERE explanation LIKE '%Seule la phrase (a) respecte cette règle.%';
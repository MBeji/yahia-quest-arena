-- C8 / L0.3 — Public stateless answer-checking for ANONYMOUS practice.
--
-- Anonymous visitors can practice admin catalogue exercises and get an immediate
-- correction WITHOUT a session, an attempt, or any XP. The answer key is masked
-- from clients at the column level (20260610170000_hide_answer_key), so this
-- SECURITY DEFINER RPC is the only path that may compare answers and reveal the
-- correction to an anonymous caller.
--
-- Scope & safety (decided 2026-06-21, "complète sauf quiz"):
--   * Only source = 'admin' exercises (the public catalogue) are checkable.
--   * Comprehension QUIZZES are NEVER corrected here (anti-memorisation of the
--     gate) — mirrors get_attempt_review, which also hides quiz corrections.
--   * Writes nothing, grants no rewards. correct_option/explanation are returned
--     only for practice/boss so the practice UI can show the right answer.
--
-- p_answers shape: [{ "questionId": <uuid>, "choice": <text> }, ...]

create or replace function public.check_answers(p_exercise_id uuid, p_answers jsonb)
returns table (question_id uuid, is_correct boolean, correct_option text, explanation text)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_source text;
  v_mode text;
begin
  if p_answers is null or jsonb_typeof(p_answers) <> 'array' then
    return;
  end if;

  select e.source, e.mode
    into v_source, v_mode
    from public.exercises e
    where e.id = p_exercise_id;

  -- Only the public (admin) catalogue is anonymously checkable; the comprehension
  -- quiz is the gate and is never anonymously corrected.
  if v_source is distinct from 'admin' or v_mode = 'quiz' then
    return;
  end if;

  return query
    select
      q.id,
      (q.correct_option = (a.elem ->> 'choice')) as is_correct,
      q.correct_option,
      q.explanation
    from jsonb_array_elements(p_answers) as a(elem)
    join public.questions q
      on q.id = nullif(a.elem ->> 'questionId', '')::uuid
    where q.exercise_id = p_exercise_id;
end;
$$;

-- Public (anonymous) practice + signed-in unscored practice. The function itself
-- enforces source='admin' and the quiz exclusion; it never writes or rewards.
revoke execute on function public.check_answers(uuid, jsonb) from public;
grant execute on function public.check_answers(uuid, jsonb) to anon, authenticated;

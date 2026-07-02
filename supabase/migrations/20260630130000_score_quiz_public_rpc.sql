-- Public, stateless SCORING for the comprehension quiz — anonymous gate parity.
--
-- Context: signed-in students must PASS a chapter's comprehension quiz (>= 80%,
-- not rushed) before its exercises unlock — the gate lives in
-- start_exercise_session (20260610180000). Anonymous visitors had no way to take
-- that quiz at all (the public check_answers RPC refuses mode='quiz' to keep the
-- answer key secret), so they could jump straight to the exercises — a divergence
-- from the connected flow.
--
-- This RPC closes that gap WITHOUT leaking the gate: it returns ONLY the aggregate
-- (correct count + total), never per-question correctness, the correct option, or
-- the explanation. So an anonymous visitor can self-validate their comprehension
-- and unlock the chapter's practice client-side, exactly like the connected gate —
-- but the quiz answers stay as secret as they are for signed-in students (whose
-- quiz attempts also return a score only, no on-screen correction).
--
-- Scope & safety:
--   * Only source = 'admin' AND mode = 'quiz' exercises are scorable here.
--   * `total` is the quiz's FULL question count (an unanswered question counts as
--     wrong), so a partial answer set cannot inflate the percentage.
--   * Writes nothing, grants no rewards. No correct_option / explanation returned.
--
-- p_answers shape: [{ "questionId": <uuid>, "choice": <text> }, ...]

create or replace function public.score_quiz(p_exercise_id uuid, p_answers jsonb)
returns table (correct integer, total integer)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_source text;
  v_mode text;
begin
  if p_answers is null or jsonb_typeof(p_answers) <> 'array' then
    return query select 0, 0;
    return;
  end if;

  select e.source, e.mode
    into v_source, v_mode
    from public.exercises e
    where e.id = p_exercise_id;

  -- Only the public (admin) catalogue's comprehension quiz is scorable here.
  if v_source is distinct from 'admin' or v_mode is distinct from 'quiz' then
    return query select 0, 0;
    return;
  end if;

  return query
    select
      (
        select count(*)
          from jsonb_array_elements(p_answers) as a(elem)
          join public.questions q
            on q.id = nullif(a.elem ->> 'questionId', '')::uuid
         where q.exercise_id = p_exercise_id
           and q.correct_option = (a.elem ->> 'choice')
      )::integer as correct,
      (
        select count(*)
          from public.questions q
         where q.exercise_id = p_exercise_id
      )::integer as total;
end;
$$;

-- Public (anonymous) quiz self-validation + signed-in unscored scoring. The
-- function enforces source='admin' + mode='quiz' and returns aggregates only; it
-- never writes, rewards, or reveals the answer key.
revoke execute on function public.score_quiz(uuid, jsonb) from public;
grant execute on function public.score_quiz(uuid, jsonb) to anon, authenticated;

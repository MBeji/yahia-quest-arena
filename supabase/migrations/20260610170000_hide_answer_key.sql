-- Security hardening (GAP-020) — stop leaking the answer key to the client.
--
-- The RLS policy "Questions visible through readable exercises" returns the FULL
-- questions row (including `correct_option` and `explanation`) for every catalogue
-- exercise. Confirmed dynamically (C3): a free student could
--   GET /rest/v1/questions?select=correct_option
-- and dump every answer (incl. premium exercises). The hint (`explanation`) is also
-- meant to be sold via the consume_hint RPC, yet was directly readable too.
--
-- Fix: the correction reaches the client only through SECURITY DEFINER RPCs:
--   * get_attempt_review (below) — the end-of-quest correction, gated on a COMPLETED
--     session owned by the caller (so it cannot be read before answering), hidden for
--     comprehension quizzes;
--   * consume_hint — the paid, on-demand hint (unchanged).
-- Then revoke the `correct_option`/`explanation` columns from direct client SELECT.
-- The app's getExercise already selects only id/prompt/options/display_order, and the
-- submit server fn is switched to call get_attempt_review — so nothing client-side
-- needs the masked columns.

create or replace function public.get_attempt_review(p_session_id uuid)
returns table (question_id uuid, prompt text, correct_option text, explanation text)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_owner uuid;
  v_exercise uuid;
  v_completed timestamptz;
  v_mode text;
begin
  select s.user_id, s.exercise_id, s.completed_at
    into v_owner, v_exercise, v_completed
    from public.exercise_sessions s
    where s.id = p_session_id;

  -- Only the owner, only after the attempt has been submitted, may see the
  -- correction. Comprehension quizzes never reveal it (anti-memorisation of the gate).
  if v_owner is null or v_owner is distinct from v_user then
    return;
  end if;
  if v_completed is null then
    return;
  end if;

  select e.mode into v_mode from public.exercises e where e.id = v_exercise;
  if v_mode = 'quiz' then
    return;
  end if;

  return query
    select q.id, q.prompt, q.correct_option, q.explanation
    from public.questions q
    where q.exercise_id = v_exercise
    order by q.display_order;
end;
$$;

revoke execute on function public.get_attempt_review(uuid) from public, anon;
grant execute on function public.get_attempt_review(uuid) to authenticated;

-- Mask the answer key + the (paid) hint from direct client reads.
revoke select on public.questions from authenticated, anon;
grant select (id, exercise_id, prompt, options, display_order)
  on public.questions to authenticated, anon;

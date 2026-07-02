-- Wrap auth.uid() in (SELECT auth.uid()) on the multi-row hot-path RLS policies.
--
-- From the scalability audit (docs/performance-audit.md, C1): a bare auth.uid()
-- in a policy is treated as volatile and RE-EVALUATED PER ROW. Wrapping it as
-- (SELECT auth.uid()) lets the planner evaluate it ONCE per query (an InitPlan),
-- which is Postgres's documented RLS-performance pattern. It is strictly
-- behaviour-preserving: (SELECT auth.uid()) returns the same value as auth.uid().
--
-- Scope: the tables that are actually scanned multi-row at scale and that the
-- audit flags — `profiles` (the leaderboard/admin reads + the per-row EXISTS
-- against parent_student_links) and `attempts` (a user's growing history). The
-- many single-row "own record" policies on other tables gain nothing measurable
-- and are intentionally left out to keep this change's blast radius small.
--
-- ALTER POLICY is surgical: it rewrites ONLY the named clause, so the column-level
-- GRANTs and the role-escalation trigger on `profiles` (added by the security
-- hardening migrations) are untouched.

-- profiles --------------------------------------------------------------------
ALTER POLICY "Users can view own or linked profiles" ON public.profiles
  USING (
    (SELECT auth.uid()) = id
    OR EXISTS (
      SELECT 1
      FROM public.parent_student_links l
      WHERE l.is_active = true
        AND (
          (l.parent_user_id = (SELECT auth.uid()) AND l.student_user_id = profiles.id)
          OR (l.student_user_id = (SELECT auth.uid()) AND l.parent_user_id = profiles.id)
        )
    )
  );

ALTER POLICY "Users can insert own profile" ON public.profiles
  WITH CHECK ((SELECT auth.uid()) = id);

ALTER POLICY "Users can update own profile" ON public.profiles
  USING ((SELECT auth.uid()) = id);

-- attempts --------------------------------------------------------------------
ALTER POLICY "Users select own attempts" ON public.attempts
  USING ((SELECT auth.uid()) = user_id);

ALTER POLICY "Users insert own attempts" ON public.attempts
  WITH CHECK ((SELECT auth.uid()) = user_id);

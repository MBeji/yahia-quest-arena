-- Perf: hoist auth.uid() / auth.role() out of per-row RLS evaluation.
--
-- Finding C1 of docs/performance-audit.md (2026-06-30), still open on
-- 2026-08-10. A bare `auth.uid()` inside a policy expression is treated as
-- volatile by the planner, so it is re-evaluated FOR EVERY CANDIDATE ROW.
-- Wrapped as `(SELECT auth.uid())` the planner hoists it into an InitPlan and
-- evaluates it ONCE per query. This is Supabase's own documented remedy.
--
-- Semantics are unchanged: same function, same value, same visibility. Only the
-- number of times it runs changes. `ALTER POLICY` rewrites in place, so no
-- policy is ever dropped — there is no window where a table sits unprotected.
--
-- The 35 statements below were GENERATED from `pg_policies` on a full replay of
-- this migration chain, not hand-written, so they cannot mistranscribe an
-- expression or resurrect a policy that a later migration dropped. Each one is
-- the policy's current deparsed expression with `auth.uid()` / `auth.role()`
-- wrapped — verified by re-applying the chain and diffing the normalized
-- expressions to byte-equality (only the wrapper differs).
--
-- Scope: 64 occurrences over 35 policies on 19 tables in `public`. Deliberately
-- NOT touched here: `is_admin()` (5 call sites) could be hoisted the same way,
-- and `is_parent_of_student(uid, row_column)` cannot — it is row-dependent by
-- construction. Both are follow-ups, not this lot.
--
-- Additive and reversible: no schema change, no data change, no grant change.

ALTER POLICY "Badges readable by authenticated users" ON public.badges
  USING ((( SELECT auth.role() ) = 'authenticated'::text));

ALTER POLICY "beta insert own pending" ON public.beta_access_requests
  WITH CHECK (((user_id = ( SELECT auth.uid() )) AND (status = 'pending'::text)));

ALTER POLICY "beta read own or admin" ON public.beta_access_requests
  USING (((user_id = ( SELECT auth.uid() )) OR is_admin()));

ALTER POLICY "bug reports insert own" ON public.bug_reports
  WITH CHECK (((user_id = ( SELECT auth.uid() )) AND (status = 'open'::text)));

ALTER POLICY "bug reports read own or admin" ON public.bug_reports
  USING (((user_id = ( SELECT auth.uid() )) OR is_admin()));

ALTER POLICY "content reports insert own" ON public.content_reports
  WITH CHECK (((user_id = ( SELECT auth.uid() )) AND (status = 'open'::text)));

ALTER POLICY "content reports read own or admin" ON public.content_reports
  USING (((user_id = ( SELECT auth.uid() )) OR is_admin()));

ALTER POLICY "Users manage own daily objectives" ON public.daily_objectives
  USING ((( SELECT auth.uid() ) = user_id))
  WITH CHECK ((( SELECT auth.uid() ) = user_id));

ALTER POLICY "Users manage own difficulty adaptation" ON public.difficulty_adaptation
  USING ((( SELECT auth.uid() ) = user_id))
  WITH CHECK ((( SELECT auth.uid() ) = user_id));

ALTER POLICY "Assigner can update assignment state" ON public.exercise_assignments
  USING (((( SELECT auth.uid() ) = assigned_by_user_id) OR (( SELECT auth.uid() ) = student_user_id)));

ALTER POLICY "Assignments visible to assignee or assigning parent" ON public.exercise_assignments
  USING (((( SELECT auth.uid() ) = student_user_id) OR (( SELECT auth.uid() ) = assigned_by_user_id) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id)));

ALTER POLICY "Parents can assign to linked students" ON public.exercise_assignments
  WITH CHECK (((( SELECT auth.uid() ) = assigned_by_user_id) AND ((student_user_id = ( SELECT auth.uid() )) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id))));

ALTER POLICY "Users select own exercise sessions" ON public.exercise_sessions
  USING ((( SELECT auth.uid() ) = user_id));

ALTER POLICY "Authenticated users can create owned exercises" ON public.exercises
  WITH CHECK (((( SELECT auth.uid() ) = created_by) AND (source = 'parent'::text) AND ((target_student_id IS NULL) OR (target_student_id = ( SELECT auth.uid() )) OR is_parent_of_student(( SELECT auth.uid() ), target_student_id))));

ALTER POLICY "Creators can update own exercises" ON public.exercises
  USING (((( SELECT auth.uid() ) = created_by) AND (source = 'parent'::text)));

ALTER POLICY "Exercises visible to assigned users" ON public.exercises
  USING (((( SELECT auth.role() ) = 'authenticated'::text) AND ((source = 'admin'::text) OR (created_by = ( SELECT auth.uid() )) OR (target_student_id = ( SELECT auth.uid() )) OR ((target_student_id IS NOT NULL) AND is_parent_of_student(( SELECT auth.uid() ), target_student_id)))));

ALTER POLICY "Inventory owned by student or linked parent" ON public.inventory_items
  WITH CHECK (((( SELECT auth.uid() ) = student_user_id) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id)));

ALTER POLICY "Inventory updates owned by student or linked parent" ON public.inventory_items
  USING (((( SELECT auth.uid() ) = student_user_id) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id)));

ALTER POLICY "Inventory visible to owner or linked parent" ON public.inventory_items
  USING (((( SELECT auth.uid() ) = student_user_id) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id)));

ALTER POLICY "Entitlements readable by owner, admin or linked parent" ON public.parcours_entitlements
  USING (((user_id = ( SELECT auth.uid() )) OR is_admin() OR (EXISTS ( SELECT 1
   FROM parent_student_links l
  WHERE ((l.parent_user_id = ( SELECT auth.uid() )) AND (l.student_user_id = parcours_entitlements.user_id) AND l.is_active)))));

ALTER POLICY "interest read own or admin" ON public.parcours_interest
  USING (((user_id = ( SELECT auth.uid() )) OR is_admin()));

ALTER POLICY "Parents and students can view their links" ON public.parent_student_links
  USING (((( SELECT auth.uid() ) = parent_user_id) OR (( SELECT auth.uid() ) = student_user_id)));

ALTER POLICY "Parents can create their own links" ON public.parent_student_links
  WITH CHECK ((( SELECT auth.uid() ) = parent_user_id));

ALTER POLICY "Parents can update their own links" ON public.parent_student_links
  USING ((( SELECT auth.uid() ) = parent_user_id));

ALTER POLICY "Exercise creators can create questions" ON public.questions
  WITH CHECK ((EXISTS ( SELECT 1
   FROM exercises e
  WHERE ((e.id = questions.exercise_id) AND (e.created_by = ( SELECT auth.uid() )) AND (e.source = 'parent'::text)))));

ALTER POLICY "Exercise creators can update questions" ON public.questions
  USING ((EXISTS ( SELECT 1
   FROM exercises e
  WHERE ((e.id = questions.exercise_id) AND (e.created_by = ( SELECT auth.uid() )) AND (e.source = 'parent'::text)))));

ALTER POLICY "Questions visible through readable exercises" ON public.questions
  USING (((( SELECT auth.role() ) = 'authenticated'::text) AND (EXISTS ( SELECT 1
   FROM exercises e
  WHERE ((e.id = questions.exercise_id) AND ((e.source = 'admin'::text) OR (e.created_by = ( SELECT auth.uid() )) OR (e.target_student_id = ( SELECT auth.uid() )) OR ((e.target_student_id IS NOT NULL) AND is_parent_of_student(( SELECT auth.uid() ), e.target_student_id))))))));

ALTER POLICY "Shop items readable by authenticated users" ON public.shop_items
  USING ((( SELECT auth.role() ) = 'authenticated'::text));

ALTER POLICY "Users manage own spaced repetition schedule" ON public.spaced_repetition_schedule
  USING ((( SELECT auth.uid() ) = user_id))
  WITH CHECK ((( SELECT auth.uid() ) = user_id));

ALTER POLICY "Student badges visible to owner or linked parent" ON public.student_badges
  USING (((( SELECT auth.uid() ) = student_user_id) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id)));

ALTER POLICY "Students can self-insert earned badges" ON public.student_badges
  WITH CHECK (((( SELECT auth.uid() ) = student_user_id) OR is_parent_of_student(( SELECT auth.uid() ), student_user_id)));

ALTER POLICY "Authenticated users can create owned theory scrolls" ON public.theory_scrolls
  WITH CHECK (((( SELECT auth.uid() ) = created_by) AND (source = 'parent'::text) AND ((target_student_id IS NULL) OR (target_student_id = ( SELECT auth.uid() )) OR is_parent_of_student(( SELECT auth.uid() ), target_student_id))));

ALTER POLICY "Creators can update theory scrolls" ON public.theory_scrolls
  USING ((( SELECT auth.uid() ) = created_by));

ALTER POLICY "Theory scrolls visible to assigned users" ON public.theory_scrolls
  USING (((( SELECT auth.role() ) = 'authenticated'::text) AND ((source = 'admin'::text) OR (created_by = ( SELECT auth.uid() )) OR (target_student_id = ( SELECT auth.uid() )) OR ((target_student_id IS NOT NULL) AND is_parent_of_student(( SELECT auth.uid() ), target_student_id)))));

ALTER POLICY "Users manage own weekly quests" ON public.weekly_quests
  USING ((( SELECT auth.uid() ) = user_id))
  WITH CHECK ((( SELECT auth.uid() ) = user_id));

-- Fix: Admin RLS policies on 'profiles' caused infinite recursion because they
-- queried 'profiles' within a policy ON 'profiles'. Using a SECURITY DEFINER
-- function bypasses RLS for the admin check, breaking the recursion.

-- Step 1: Create a SECURITY DEFINER function to check admin status without RLS
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  );
$$;

-- Step 2: Drop the broken recursive policies
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Admins can view all attempts" ON attempts;
DROP POLICY IF EXISTS "Admins can view all exercise_sessions" ON exercise_sessions;

-- Step 3: Recreate policies using the SECURITY DEFINER function
CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  USING (public.is_admin());

CREATE POLICY "Admins can view all attempts"
  ON attempts FOR SELECT
  USING (public.is_admin());

CREATE POLICY "Admins can view all exercise_sessions"
  ON exercise_sessions FOR SELECT
  USING (public.is_admin());

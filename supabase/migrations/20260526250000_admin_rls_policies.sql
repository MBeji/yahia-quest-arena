-- Add RLS policies for admin role to view all data for reporting

-- Admin can view ALL profiles
CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- Admin can view ALL attempts
CREATE POLICY "Admins can view all attempts"
  ON attempts FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- Admin can view ALL exercise_sessions
CREATE POLICY "Admins can view all exercise_sessions"
  ON exercise_sessions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

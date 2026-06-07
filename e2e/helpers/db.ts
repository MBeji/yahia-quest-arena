import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { requireAdminEnv } from "./env";

/**
 * Test-only DB access via the service-role key (bypasses RLS). Use to pick
 * deterministic content ids / set up data, instead of walking a quiz-gated UI.
 * Exposed to specs through the `adminDb` fixture.
 */
export interface AdminDb {
  readonly client: SupabaseClient;
  /**
   * Id of a premium (subscription-only) subject. A free account opening its
   * subject page gets the subscription paywall rendered directly.
   */
  premiumSubjectId(): Promise<string>;
  /**
   * A non-premium subject bound to a school grade (`grade_id != null`). Its
   * chapters are comprehension-quiz-gated for a fresh free user.
   */
  schoolSubjectId(): Promise<string>;
  /**
   * A non-premium, non-school subject (`grade_id` null — culture-générale,
   * muscle-cerveau/IQ, language tracks). Never quiz-gated.
   */
  nonSchoolSubjectId(): Promise<string>;
  /**
   * A free-accessible exercise of a subject: a non-quiz mission at difficulty
   * <= 2 (no premium-difficulty gate), lowest display order.
   */
  freeExerciseId(subjectId: string): Promise<string>;
}

export function createAdminDb(): AdminDb {
  const { url, serviceRoleKey } = requireAdminEnv();
  const client = createClient(url, serviceRoleKey, { auth: { persistSession: false } });

  return {
    client,
    async premiumSubjectId() {
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", true)
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`premiumSubjectId: ${error.message}`);
      if (!data) throw new Error("No premium subject (is_premium=true) found in the test project.");
      return data.id as string;
    },
    async schoolSubjectId() {
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", false)
        .not("grade_id", "is", null)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`schoolSubjectId: ${error.message}`);
      if (!data) throw new Error("No free school subject (grade_id != null) in the test project.");
      return data.id as string;
    },
    async nonSchoolSubjectId() {
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", false)
        .is("grade_id", null)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`nonSchoolSubjectId: ${error.message}`);
      if (!data) throw new Error("No free non-school subject (grade_id null) in the test project.");
      return data.id as string;
    },
    async freeExerciseId(subjectId: string) {
      const { data, error } = await client
        .from("exercises")
        .select("id")
        .eq("subject_id", subjectId)
        .neq("mode", "quiz")
        .lte("difficulty", 2)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`freeExerciseId: ${error.message}`);
      if (!data)
        throw new Error(`No free exercise (non-quiz, difficulty<=2) for subject ${subjectId}.`);
      return data.id as string;
    },
  };
}

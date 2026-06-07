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
  /**
   * A premium-gated exercise (difficulty >= 3) in a FREE, NON-school subject, so
   * the ONLY active gate is the difficulty premium gate — never the quiz gate.
   * Lets a test prove free=locked / premium=unlocked without a quiz confound.
   */
  premiumDifficultyExercise(): Promise<{ exerciseId: string; subjectId: string }>;
  /** First non-premium subject under a theme slug (e.g. "culture-generale"). */
  subjectIdByTheme(themeSlug: string): Promise<string | null>;
  /** Theme slugs that currently have at least one subject in the catalogue. */
  themeSlugsWithSubjects(): Promise<string[]>;
  /** Resolve a seeded test user's auth id by email (service-role admin API). */
  userIdByEmail(email: string): Promise<string>;
  /** Overwrite a user's coin balance — deterministic setup for shop tests. */
  setCoins(userId: string, coins: number): Promise<void>;
  /** Read a user's live gameplay counters (xp / coins / level). */
  profileStats(userId: string): Promise<{ xp: number; coins: number; level: number }>;
  /**
   * Ordered answer key for an exercise: the correct option's TEXT per question
   * (the quest UI shuffles options, so a test must match by text, not position).
   */
  answerKey(exerciseId: string): Promise<{ prompt: string; correctText: string }[]>;
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
    async premiumDifficultyExercise() {
      // FREE + non-school subjects → no quiz gate, so difficulty is the only gate.
      const { data: subs, error: subErr } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", false)
        .is("grade_id", null);
      if (subErr) throw new Error(`premiumDifficultyExercise(subjects): ${subErr.message}`);
      const ids = (subs ?? []).map((s) => s.id as string);
      if (ids.length === 0) throw new Error("No free non-school subject for premium-gate test.");
      const { data, error } = await client
        .from("exercises")
        .select("id, subject_id")
        .in("subject_id", ids)
        .neq("mode", "quiz")
        .gte("difficulty", 3)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`premiumDifficultyExercise: ${error.message}`);
      if (!data)
        throw new Error("No difficulty>=3 exercise in a free non-school subject (apply content?).");
      return { exerciseId: data.id as string, subjectId: data.subject_id as string };
    },
    async subjectIdByTheme(themeSlug: string) {
      const { data: theme, error: tErr } = await client
        .from("themes")
        .select("id")
        .eq("slug", themeSlug)
        .maybeSingle();
      if (tErr) throw new Error(`subjectIdByTheme(theme): ${tErr.message}`);
      if (!theme) return null;
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("theme_id", theme.id)
        .eq("is_premium", false)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`subjectIdByTheme(subject): ${error.message}`);
      return (data?.id as string) ?? null;
    },
    async themeSlugsWithSubjects() {
      const { data: subs, error: subErr } = await client.from("subjects").select("theme_id");
      if (subErr) throw new Error(`themeSlugsWithSubjects(subjects): ${subErr.message}`);
      const themeIds = [...new Set((subs ?? []).map((s) => s.theme_id as string))];
      if (themeIds.length === 0) return [];
      const { data: themes, error: tErr } = await client
        .from("themes")
        .select("slug")
        .in("id", themeIds);
      if (tErr) throw new Error(`themeSlugsWithSubjects(themes): ${tErr.message}`);
      return (themes ?? []).map((t) => t.slug as string);
    },
    async userIdByEmail(email: string) {
      for (let page = 1; page <= 20; page += 1) {
        const { data, error } = await client.auth.admin.listUsers({ page, perPage: 200 });
        if (error) throw new Error(`userIdByEmail: ${error.message}`);
        const found = data.users.find((u) => u.email?.toLowerCase() === email.toLowerCase());
        if (found) return found.id;
        if (data.users.length < 200) break;
      }
      throw new Error(`No auth user for ${email} (seed test users first).`);
    },
    async setCoins(userId: string, coins: number) {
      const { error } = await client
        .from("profiles")
        .update({ yahia_coins: coins })
        .eq("id", userId);
      if (error) throw new Error(`setCoins: ${error.message}`);
    },
    async profileStats(userId: string) {
      const { data, error } = await client
        .from("profiles")
        .select("xp, yahia_coins, level")
        .eq("id", userId)
        .maybeSingle();
      if (error) throw new Error(`profileStats: ${error.message}`);
      if (!data) throw new Error(`No profile for ${userId}.`);
      return {
        xp: (data.xp as number) ?? 0,
        coins: (data.yahia_coins as number) ?? 0,
        level: (data.level as number) ?? 0,
      };
    },
    async answerKey(exerciseId: string) {
      const { data, error } = await client
        .from("questions")
        .select("prompt, options, correct_option, display_order")
        .eq("exercise_id", exerciseId)
        .order("display_order");
      if (error) throw new Error(`answerKey: ${error.message}`);
      return (data ?? []).map((q) => {
        const opts = (q.options as { id: string; text: string }[]) ?? [];
        const correct = opts.find((o) => o.id === q.correct_option);
        return { prompt: q.prompt as string, correctText: correct?.text ?? "" };
      });
    },
  };
}

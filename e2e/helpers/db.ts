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
   * Id of a subject under a PREMIUM concours parcours (theme 'ecole-tn' + a
   * national-exam grade). A free account without an entitlement is gated on its
   * difficulty>=2 missions — only the comprehension quiz + difficulty-1 preview
   * is free (resolve_exercise_access).
   */
  premiumParcoursSubjectId(): Promise<string>;
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
   * A non-premium school subject in a NON-concours grade (`grades.is_concours_national
   * = false`), so its parcours is FREE — the comprehension-quiz gate is the ONLY gate
   * (no entitlement paywall in play). Lets a test isolate the quiz gate cleanly.
   */
  freeSchoolSubjectId(): Promise<string>;
  /**
   * A (quiz, mission) pair in the SAME chapter of a subject — the lowest-display_order
   * chapter that has both a comprehension quiz and a non-quiz mission. Null when no
   * such chapter exists. Lets a test prove the quiz gate locks/unlocks that mission.
   */
  chapterQuizAndMission(subjectId: string): Promise<{ quizId: string; missionId: string } | null>;
  /**
   * A free-accessible exercise of a subject: a non-quiz mission at difficulty
   * <= 2 (no premium-difficulty gate), lowest display order.
   */
  freeExerciseId(subjectId: string): Promise<string>;
  /**
   * A chapter that owns a non-quiz practice exercise: its chapterId + that
   * exercise's id (the subject's first non-quiz mission by display order, which
   * is also its chapter's first — the exact target the course reader's « practise
   * this chapter » CTA links to). Null when the subject has nothing to practise.
   * Lets a nav test click cours→exercice and exercice→cours on deterministic ids.
   */
  chapterWithPractice(subjectId: string): Promise<{ chapterId: string; exerciseId: string } | null>;
  /**
   * A premium-gated mission in a PREMIUM concours parcours: a non-quiz exercise
   * at difficulty >= 2 (outside the free difficulty-1/quiz preview), so the ONLY
   * active gate is the per-parcours entitlement. Lets a test prove
   * locked-without-entitlement / unlocked-with-entitlement.
   */
  premiumParcoursExercise(): Promise<{ exerciseId: string; subjectId: string }>;
  /** A PREMIUM concours parcours: its id + the (theme_id, grade_id) its subjects share. */
  premiumConcoursParcours(): Promise<{ id: string; theme: string; grade: string }>;
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
  /** Delete an auth user by email if it exists — cleanup for the signup test. */
  deleteUserByEmail(email: string): Promise<void>;
  /**
   * Whether the project auto-confirms new signups (GoTrue `mailer_autoconfirm`).
   * When false, UI signup needs a working SMTP to complete — used to skip the
   * signup happy-path on test projects that have neither.
   */
  authAutoconfirm(): Promise<boolean>;
  /** Delete every student link owned by a parent — clean slate for link tests. */
  clearParentLinks(parentUserId: string): Promise<void>;
  /** The comprehension-quiz exercise (mode='quiz') with the lowest display order. */
  quizExerciseId(subjectId: string): Promise<string>;
  /**
   * An admin, non-quiz mission carrying at least one native `numeric` question
   * (Tier B, phase B1) — null until the content lot (B1.4) seeds one. Lets the
   * numeric e2e spec skip cleanly instead of failing on an empty catalogue.
   */
  numericExerciseId(): Promise<string | null>;
  /**
   * An admin, non-quiz mission carrying at least one native board question
   * (`ordering`/`matching` — Tier B, phase B2) — null until seeded (lot B2.4).
   */
  boardExerciseId(): Promise<string | null>;
  /**
   * An admin, non-quiz mission carrying at least one native `multi` question
   * (Tier B, phase B3) — null until seeded (lot B3.4).
   */
  multiExerciseId(): Promise<string | null>;
  /**
   * Grant a user a live entitlement on a parcours (per-parcours premium model)
   * via the admin_grant_parcours RPC — service-role bypasses is_admin(). Pass
   * `months` for a time-boxed grant; omit for perpetual. Idempotent (upserts the
   * live-grant slot).
   */
  grantEntitlement(userId: string, parcoursId: string, months?: number): Promise<void>;
  /** Soft-revoke a user's live entitlement on a parcours (admin_revoke_parcours). */
  revokeEntitlement(userId: string, parcoursId: string): Promise<void>;
  /** Whether a user currently holds a live (non-revoked, non-expired) grant on a parcours. */
  hasEntitlement(userId: string, parcoursId: string): Promise<boolean>;
}

export function createAdminDb(): AdminDb {
  const { url, serviceRoleKey } = requireAdminEnv();
  const client = createClient(url, serviceRoleKey, { auth: { persistSession: false } });

  return {
    client,
    async premiumParcoursSubjectId() {
      // A subject under a PREMIUM concours parcours: same (theme_id, grade_id) as
      // an is_premium parcours of kind 'concours' (e.g. concours-9eme → ecole-tn /
      // 9eme-base). Premium is per-parcours now, not the subject's is_premium flag.
      const { theme, grade } = await this.premiumConcoursParcours();
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("theme_id", theme)
        .eq("grade_id", grade)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`premiumParcoursSubjectId: ${error.message}`);
      if (!data)
        throw new Error("No subject under a premium concours parcours (apply content to TEST?).");
      return data.id as string;
    },
    async schoolSubjectId() {
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", false)
        .not("grade_id", "is", null)
        // `id` is a deterministic tiebreaker: several school subjects can share
        // the lowest display_order (e.g. 9ème-Math and 6ème-Math both at 1), and
        // without it Postgres returns an arbitrary one — making the chosen quiz
        // (and so the whole test) non-deterministic from run to run.
        .order("display_order")
        .order("id")
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
    async freeSchoolSubjectId() {
      // Non-concours grades resolve to FREE parcours (the premium concours parcours
      // are the national-exam years), so the only gate left is the chapter quiz.
      const { data: grades, error: gErr } = await client
        .from("grades")
        .select("id")
        .eq("is_concours_national", false);
      if (gErr) throw new Error(`freeSchoolSubjectId(grades): ${gErr.message}`);
      const gradeIds = (grades ?? []).map((g) => g.id as string);
      if (gradeIds.length === 0)
        throw new Error("No non-concours grade in the test project (apply migrations?).");
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("is_premium", false)
        .in("grade_id", gradeIds)
        .order("display_order")
        .order("id")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`freeSchoolSubjectId: ${error.message}`);
      if (!data)
        throw new Error(
          "No free non-concours school subject in the test project (apply content?).",
        );
      return data.id as string;
    },
    async chapterQuizAndMission(subjectId: string) {
      const { data, error } = await client
        .from("exercises")
        .select("id, chapter_id, mode")
        .eq("subject_id", subjectId)
        .order("display_order");
      if (error) throw new Error(`chapterQuizAndMission: ${error.message}`);
      const rows = data ?? [];
      for (const r of rows) {
        if (r.mode !== "quiz") continue;
        const mission = rows.find((x) => x.chapter_id === r.chapter_id && x.mode !== "quiz");
        if (mission) return { quizId: r.id as string, missionId: mission.id as string };
      }
      return null;
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
    async chapterWithPractice(subjectId: string) {
      // The subject's first non-quiz exercise (by display order) + its chapter.
      // Exercises are globally display-ordered, so this is also its chapter's
      // first non-quiz mission — matching getChapterLesson's practiceExerciseId.
      const { data, error } = await client
        .from("exercises")
        .select("id, chapter_id")
        .eq("subject_id", subjectId)
        .neq("mode", "quiz")
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`chapterWithPractice: ${error.message}`);
      if (!data) return null;
      return { chapterId: data.chapter_id as string, exerciseId: data.id as string };
    },
    async premiumParcoursExercise() {
      // A premium-gated mission in a PREMIUM concours parcours: a non-quiz exercise
      // at difficulty >= 2 (outside the difficulty-1/quiz free preview). Its subject
      // shares the parcours' (theme_id, grade_id), so the entitlement is the only gate.
      const { theme, grade } = await this.premiumConcoursParcours();
      const { data: subs, error: subErr } = await client
        .from("subjects")
        .select("id")
        .eq("theme_id", theme)
        .eq("grade_id", grade);
      if (subErr) throw new Error(`premiumParcoursExercise(subjects): ${subErr.message}`);
      const ids = (subs ?? []).map((s) => s.id as string);
      if (ids.length === 0)
        throw new Error("No subject under a premium concours parcours (apply content to TEST?).");
      const { data, error } = await client
        .from("exercises")
        .select("id, subject_id")
        .in("subject_id", ids)
        .neq("mode", "quiz")
        .gte("difficulty", 2)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`premiumParcoursExercise: ${error.message}`);
      if (!data)
        throw new Error(
          "No difficulty>=2 mission under a premium concours parcours (apply content to TEST?).",
        );
      return { exerciseId: data.id as string, subjectId: data.subject_id as string };
    },
    /**
     * Resolve a concours parcours' (theme_id, grade_id) and id — the EX-premium
     * tracks. Phase gratuite (étude 15, lot 2) : `is_premium` is false everywhere,
     * so the parcours stays identifiable by its kind; étude 01 will reinstate the
     * is_premium filter when premium returns. Throws if none is seeded (the
     * parcours migration seeds concours-9eme / concours-6eme).
     */
    async premiumConcoursParcours() {
      const { data, error } = await client
        .from("parcours")
        .select("id, theme_id, grade_id")
        .eq("kind", "concours")
        .not("grade_id", "is", null)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`premiumConcoursParcours: ${error.message}`);
      if (!data)
        throw new Error(
          "No premium concours parcours seeded in the test project (apply migrations?).",
        );
      return {
        id: data.id as string,
        theme: data.theme_id as string,
        grade: data.grade_id as string,
      };
    },
    async subjectIdByTheme(themeSlug: string) {
      // themes.id IS the slug ('ecole-tn', 'culture-generale'…), and subjects.theme_id
      // stores that slug directly — no separate themes.slug column exists.
      const { data, error } = await client
        .from("subjects")
        .select("id")
        .eq("theme_id", themeSlug)
        .eq("is_premium", false)
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`subjectIdByTheme: ${error.message}`);
      return (data?.id as string) ?? null;
    },
    async themeSlugsWithSubjects() {
      // subjects.theme_id is the theme slug; distinct values = families with content.
      const { data: subs, error } = await client.from("subjects").select("theme_id");
      if (error) throw new Error(`themeSlugsWithSubjects: ${error.message}`);
      return [...new Set((subs ?? []).map((s) => s.theme_id as string))];
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
    async deleteUserByEmail(email: string) {
      const id = await this.userIdByEmail(email).catch(() => null);
      if (!id) return;
      const { error } = await client.auth.admin.deleteUser(id);
      if (error) throw new Error(`deleteUserByEmail: ${error.message}`);
    },
    async authAutoconfirm() {
      const res = await fetch(`${url}/auth/v1/settings`, { headers: { apikey: serviceRoleKey } });
      if (!res.ok) return false;
      const settings = (await res.json()) as { mailer_autoconfirm?: boolean };
      return settings.mailer_autoconfirm === true;
    },
    async clearParentLinks(parentUserId: string) {
      const { error } = await client
        .from("parent_student_links")
        .delete()
        .eq("parent_user_id", parentUserId);
      if (error) throw new Error(`clearParentLinks: ${error.message}`);
    },
    async numericExerciseId() {
      const { data, error } = await client
        .from("questions")
        .select("exercise_id, exercises!inner(mode, source)")
        .eq("question_type", "numeric")
        .neq("exercises.mode", "quiz")
        .eq("exercises.source", "admin")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`numericExerciseId: ${error.message}`);
      return (data?.exercise_id as string) ?? null;
    },
    async boardExerciseId() {
      const { data, error } = await client
        .from("questions")
        .select("exercise_id, exercises!inner(mode, source)")
        .in("question_type", ["ordering", "matching"])
        .neq("exercises.mode", "quiz")
        .eq("exercises.source", "admin")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`boardExerciseId: ${error.message}`);
      return (data?.exercise_id as string) ?? null;
    },
    async multiExerciseId() {
      const { data, error } = await client
        .from("questions")
        .select("exercise_id, exercises!inner(mode, source)")
        .eq("question_type", "multi")
        .neq("exercises.mode", "quiz")
        .eq("exercises.source", "admin")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`multiExerciseId: ${error.message}`);
      return (data?.exercise_id as string) ?? null;
    },
    async quizExerciseId(subjectId: string) {
      const { data, error } = await client
        .from("exercises")
        .select("id")
        .eq("subject_id", subjectId)
        .eq("mode", "quiz")
        .order("display_order")
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`quizExerciseId: ${error.message}`);
      if (!data) throw new Error(`No quiz exercise for subject ${subjectId}.`);
      return data.id as string;
    },
    async grantEntitlement(userId: string, parcoursId: string, months?: number) {
      // NOT via admin_grant_parcours: its is_admin() guard keys off auth.uid(),
      // which is NULL for a service-role call -> 'Unauthorized'. The service key
      // bypasses RLS, so write the live-grant slot directly (clear + insert,
      // idempotent). Omit months for a perpetual grant.
      let expiry: string | null = null;
      if (typeof months === "number") {
        const d = new Date();
        d.setMonth(d.getMonth() + months);
        expiry = d.toISOString();
      }
      const del = await client
        .from("parcours_entitlements")
        .delete()
        .eq("user_id", userId)
        .eq("parcours_id", parcoursId);
      if (del.error) throw new Error(`grantEntitlement: ${del.error.message}`);
      const ins = await client.from("parcours_entitlements").insert({
        user_id: userId,
        parcours_id: parcoursId,
        source: "purchase",
        expires_at: expiry,
      });
      if (ins.error) throw new Error(`grantEntitlement: ${ins.error.message}`);
    },
    async revokeEntitlement(userId: string, parcoursId: string) {
      // Same service-role constraint as grantEntitlement: soft-revoke directly.
      const { error } = await client
        .from("parcours_entitlements")
        .update({ revoked_at: new Date().toISOString() })
        .eq("user_id", userId)
        .eq("parcours_id", parcoursId)
        .is("revoked_at", null);
      if (error) throw new Error(`revokeEntitlement: ${error.message}`);
    },
    async hasEntitlement(userId: string, parcoursId: string) {
      const { data, error } = await client
        .from("parcours_entitlements")
        .select("id, expires_at")
        .eq("user_id", userId)
        .eq("parcours_id", parcoursId)
        .is("revoked_at", null)
        .order("granted_at", { ascending: false })
        .limit(1)
        .maybeSingle();
      if (error) throw new Error(`hasEntitlement: ${error.message}`);
      if (!data) return false;
      const expires = data.expires_at as string | null;
      return expires === null || new Date(expires) > new Date();
    },
  };
}

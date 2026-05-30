import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { parseStudentAllianceCode } from "@/lib/family-link";

/**
 * Get the list of students visible to the current user (parent sees linked, admin sees all).
 */
export const getLinkedStudents = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }) => {
    const { supabase, userId } = context;

    const { data: profile } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", userId)
      .single();

    if (!profile || (profile.role !== "parent" && profile.role !== "admin")) {
      throw new Error("Access denied: parent or admin account required.");
    }

    // Admin sees ALL students
    if (profile.role === "admin") {
      const { data: students } = await supabase
        .from("profiles")
        .select("id, display_name, hero_class, level, xp, current_streak, longest_streak, last_active_date, created_at, role")
        .in("role", ["student"])
        .order("created_at", { ascending: true });

      return {
        role: "admin" as const,
        students: (students ?? []).map((s) => ({
          ...s,
          relation: "admin",
        })),
      };
    }

    // Parent sees linked students only
    const { data: links } = await supabase
      .from("parent_student_links")
      .select("student_user_id, relation_label, is_active")
      .eq("parent_user_id", userId)
      .eq("is_active", true);

    if (!links || links.length === 0) {
      return { role: "parent" as const, students: [] };
    }

    const studentIds = links.map((l) => l.student_user_id);

    const { data: students } = await supabase
      .from("profiles")
      .select("id, display_name, hero_class, level, xp, current_streak, longest_streak, last_active_date, created_at")
      .in("id", studentIds);

    return {
      role: "parent" as const,
      students: (students ?? []).map((s) => ({
        ...s,
        relation: links.find((l) => l.student_user_id === s.id)?.relation_label ?? "parent",
      })),
    };
  });

/**
 * Full student activity report for a parent or admin.
 */
export const getStudentReport = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
    z.object({ studentId: z.string().uuid() }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    // Check role: admin can access any student, parent needs link
    const { data: callerProfile } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", userId)
      .single();

    if (!callerProfile || (callerProfile.role !== "admin" && callerProfile.role !== "parent")) {
      throw new Error("Access denied.");
    }

    if (callerProfile.role === "parent") {
      const { data: isParent } = await supabase.rpc("is_parent_of_student", {
        p_parent: userId,
        p_student: data.studentId,
      });
      if (!isParent) {
        throw new Error("Access denied: you are not linked to this student.");
      }
    }

    // Fetch all data in parallel
    const [profileRes, attemptsRes, recentAttemptsRes, subjectsRes, streakRes] = await Promise.all([
      // Student profile
      supabase
        .from("profiles")
        .select("*")
        .eq("id", data.studentId)
        .single(),

      // All attempts (for global stats)
      supabase
        .from("attempts")
        .select("id, subject_id, score_pct, duration_seconds, xp_earned, completed_at")
        .eq("user_id", data.studentId)
        .order("completed_at", { ascending: false }),

      // Last 30 days of attempts (for activity chart)
      supabase
        .from("attempts")
        .select("score_pct, duration_seconds, completed_at, subject_id")
        .eq("user_id", data.studentId)
        .gte("completed_at", new Date(Date.now() - 30 * 86400000).toISOString())
        .order("completed_at", { ascending: true }),

      // Subjects list
      supabase
        .from("subjects")
        .select("id, name_fr, color_token"),

      // Recent daily activity (last 7 days) 
      supabase
        .from("attempts")
        .select("completed_at")
        .eq("user_id", data.studentId)
        .gte("completed_at", new Date(Date.now() - 7 * 86400000).toISOString()),
    ]);

    const profile = profileRes.data;
    const allAttempts = attemptsRes.data ?? [];
    const recentAttempts = recentAttemptsRes.data ?? [];
    const subjects = subjectsRes.data ?? [];
    const last7DaysAttempts = streakRes.data ?? [];

    if (!profile) {
      throw new Error("Student profile not found.");
    }

    // ===== COMPUTE METRICS =====

    // Total time spent (in minutes)
    const totalTimeMinutes = Math.round(
      allAttempts.reduce((acc, a) => acc + (a.duration_seconds ?? 0), 0) / 60
    );

    // Average score overall
    const avgScore = allAttempts.length > 0
      ? Math.round(allAttempts.reduce((acc, a) => acc + Number(a.score_pct), 0) / allAttempts.length)
      : 0;

    // Total exercises completed
    const totalExercises = allAttempts.length;

    // Per-subject breakdown
    const subjectStats = subjects.map((s) => {
      const subAttempts = allAttempts.filter((a) => a.subject_id === s.id);
      const avg = subAttempts.length > 0
        ? Math.round(subAttempts.reduce((acc, a) => acc + Number(a.score_pct), 0) / subAttempts.length)
        : 0;
      const totalTime = Math.round(subAttempts.reduce((acc, a) => acc + (a.duration_seconds ?? 0), 0) / 60);
      return {
        subjectId: s.id,
        name: s.name_fr,
        colorToken: s.color_token,
        attempts: subAttempts.length,
        avgScore: avg,
        totalTimeMinutes: totalTime,
      };
    }).filter((s) => s.attempts > 0);

    // Daily activity for the last 30 days
    const dailyActivity: { date: string; exercises: number; minutes: number; avgScore: number }[] = [];
    const dayMap = new Map<string, { exercises: number; totalTime: number; totalScore: number }>();

    for (const a of recentAttempts) {
      const day = a.completed_at.split("T")[0];
      const existing = dayMap.get(day) ?? { exercises: 0, totalTime: 0, totalScore: 0 };
      existing.exercises += 1;
      existing.totalTime += a.duration_seconds ?? 0;
      existing.totalScore += Number(a.score_pct);
      dayMap.set(day, existing);
    }

    // Fill in all 30 days (even empty ones)
    for (let i = 29; i >= 0; i--) {
      const d = new Date(Date.now() - i * 86400000);
      const key = d.toISOString().split("T")[0];
      const entry = dayMap.get(key);
      dailyActivity.push({
        date: key,
        exercises: entry?.exercises ?? 0,
        minutes: Math.round((entry?.totalTime ?? 0) / 60),
        avgScore: entry && entry.exercises > 0 ? Math.round(entry.totalScore / entry.exercises) : 0,
      });
    }

    // Days active in last 7 days
    const activeDaysSet = new Set(last7DaysAttempts.map((a) => a.completed_at.split("T")[0]));
    const daysActiveThisWeek = activeDaysSet.size;

    // Seriousness score (0-100)
    // Based on: streak consistency, frequency, score trend, time invested
    const streakFactor = Math.min(profile.current_streak / 7, 1) * 25; // max 25 pts for 7+ day streak
    const frequencyFactor = Math.min(daysActiveThisWeek / 5, 1) * 25; // max 25 pts for 5+ days/week
    const scoreFactor = Math.min(avgScore / 80, 1) * 25; // max 25 pts for 80%+ avg
    const timeFactor = Math.min(totalTimeMinutes / 120, 1) * 25; // max 25 pts for 2h+ total
    const seriousnessScore = Math.round(streakFactor + frequencyFactor + scoreFactor + timeFactor);

    // Verdict
    let verdict: "excellent" | "good" | "average" | "needs_improvement" | "inactive";
    if (seriousnessScore >= 80) verdict = "excellent";
    else if (seriousnessScore >= 60) verdict = "good";
    else if (seriousnessScore >= 40) verdict = "average";
    else if (totalExercises > 0) verdict = "needs_improvement";
    else verdict = "inactive";

    // Score trend (last 10 vs previous 10)
    const last10 = allAttempts.slice(0, 10);
    const prev10 = allAttempts.slice(10, 20);
    const last10Avg = last10.length > 0 ? last10.reduce((a, b) => a + Number(b.score_pct), 0) / last10.length : 0;
    const prev10Avg = prev10.length > 0 ? prev10.reduce((a, b) => a + Number(b.score_pct), 0) / prev10.length : 0;
    const scoreTrend = prev10.length > 0 ? Math.round(last10Avg - prev10Avg) : 0;

    return {
      student: {
        displayName: profile.display_name,
        heroClass: profile.hero_class,
        level: profile.level,
        xp: profile.xp,
        currentStreak: profile.current_streak,
        longestStreak: profile.longest_streak,
        lastActiveDate: profile.last_active_date,
        createdAt: profile.created_at,
      },
      summary: {
        totalTimeMinutes,
        totalExercises,
        avgScore,
        daysActiveThisWeek,
        seriousnessScore,
        verdict,
        scoreTrend,
      },
      subjectStats,
      dailyActivity,
    };
  });

/**
 * Link a parent account to a student account using the student's alliance code.
 */
export const linkStudentByCode = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
    z.object({
      studentCode: z.string().min(8).max(64),
      relationLabel: z.string().min(2).max(40).default("parent"),
    }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    const { data: profile, error: profileError } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", userId)
      .single();

    if (profileError) throw new Error(profileError.message);
    if (!profile || (profile.role !== "parent" && profile.role !== "admin")) {
      throw new Error("Parent account required to link a student.");
    }

    const studentId = parseStudentAllianceCode(data.studentCode);
    if (!studentId) throw new Error("Invalid student alliance code.");

    const { data: studentProfile, error: studentError } = await supabase
      .from("profiles")
      .select("id,display_name,role")
      .eq("id", studentId)
      .maybeSingle();

    if (studentError) throw new Error(studentError.message);
    if (!studentProfile) throw new Error("Student not found.");
    if (studentProfile.role !== "student") throw new Error("This code does not belong to a student account.");
    if (studentProfile.id === userId) throw new Error("You cannot link your own account.");

    const { error: linkError } = await supabase
      .from("parent_student_links")
      .upsert(
        {
          parent_user_id: userId,
          student_user_id: studentProfile.id,
          relation_label: data.relationLabel,
          is_active: true,
        },
        { onConflict: "parent_user_id,student_user_id" },
      );

    if (linkError) throw new Error(linkError.message);

    return {
      linked: true,
      student: {
        id: studentProfile.id,
        displayName: studentProfile.display_name,
      },
    };
  });

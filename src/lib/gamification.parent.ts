import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/integrations/supabase/auth-middleware";
import { parseStudentAllianceCode } from "@/lib/family-link";

type ParentStudent = {
  id: string;
  display_name: string | null;
  hero_class: string | null;
  level: number;
  xp: number;
  current_streak: number;
  longest_streak: number;
  last_active_date: string | null;
  created_at: string;
  role?: string;
  relation: string;
};

type StudentReportShape = {
  student: {
    displayName: string | null;
    heroClass: string | null;
    level: number;
    xp: number;
    currentStreak: number;
    longestStreak: number;
    lastActiveDate: string | null;
    createdAt: string;
  };
  summary: {
    totalTimeMinutes: number;
    totalExercises: number;
    avgScore: number;
    daysActiveThisWeek: number;
    seriousnessScore: number;
    verdict: "excellent" | "good" | "average" | "needs_improvement" | "inactive";
    scoreTrend: number;
  };
  subjectStats: Array<{
    subjectId: string;
    name: string;
    colorToken: string | null;
    attempts: number;
    avgScore: number;
    totalTimeMinutes: number;
  }>;
  dailyActivity: Array<{
    date: string;
    exercises: number;
    minutes: number;
    avgScore: number;
  }>;
};

function parseStudentReportPayload(payload: unknown): StudentReportShape {
  if (!payload || typeof payload !== "object") {
    throw new Error("Invalid student report payload.");
  }

  return payload as StudentReportShape;
}

/**
 * Get the list of students visible to the current user (parent sees linked, admin sees all).
 */
export const getLinkedStudents = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z.object({
      page: z.number().int().min(1).default(1),
      pageSize: z.number().int().min(1).max(200).default(100),
    }).parse((d ?? {}) as Record<string, unknown>),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;
    const page = data.page;
    const pageSize = data.pageSize;
    const from = (page - 1) * pageSize;
    const to = from + pageSize - 1;

    const { data: profile, error: profileErr } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", userId)
      .single();
    if (profileErr) throw new Error(profileErr.message);

    if (!profile || (profile.role !== "parent" && profile.role !== "admin")) {
      throw new Error("Access denied: parent or admin account required.");
    }

    // Admin sees all students with pagination.
    if (profile.role === "admin") {
      const [studentsRes, countRes] = await Promise.all([
        supabase
          .from("profiles")
          .select("id, display_name, hero_class, level, xp, current_streak, longest_streak, last_active_date, created_at, role")
          .eq("role", "student")
          .order("created_at", { ascending: true })
          .range(from, to),
        supabase
          .from("profiles")
          .select("id", { count: "exact", head: true })
          .eq("role", "student"),
      ]);

      if (studentsRes.error) throw new Error(studentsRes.error.message);
      if (countRes.error) throw new Error(countRes.error.message);

      const students: ParentStudent[] = (studentsRes.data ?? []).map((s) => ({
        ...s,
        relation: "admin",
      }));

      const total = countRes.count ?? students.length;

      return {
        role: "admin" as const,
        students,
        pagination: {
          page,
          pageSize,
          total,
          hasMore: page * pageSize < total,
        },
      };
    }

    // Parent sees linked students only
    const { data: links, error: linksErr } = await supabase
      .from("parent_student_links")
      .select("student_user_id, relation_label, is_active")
      .eq("parent_user_id", userId)
      .eq("is_active", true);
    if (linksErr) throw new Error(linksErr.message);

    if (!links || links.length === 0) {
      return {
        role: "parent" as const,
        students: [],
        pagination: {
          page: 1,
          pageSize,
          total: 0,
          hasMore: false,
        },
      };
    }

    const studentIds = links.map((l) => l.student_user_id);

    const { data: students, error: studentsErr } = await supabase
      .from("profiles")
      .select("id, display_name, hero_class, level, xp, current_streak, longest_streak, last_active_date, created_at")
      .in("id", studentIds);
    if (studentsErr) throw new Error(studentsErr.message);

    const linkedStudents: ParentStudent[] = (students ?? []).map((s) => ({
      ...s,
      relation: links.find((l) => l.student_user_id === s.id)?.relation_label ?? "parent",
    }));

    return {
      role: "parent" as const,
      students: linkedStudents,
      pagination: {
        page: 1,
        pageSize: linkedStudents.length,
        total: linkedStudents.length,
        hasMore: false,
      },
    };
  });

/**
 * Full student activity report for a parent or admin.
 */
export const getStudentReport = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
    z.object({ studentId: z.string().uuid() }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: reportData, error: reportErr } = await supabase.rpc("get_student_report", {
      p_student: data.studentId,
    });

    if (reportErr) throw new Error(reportErr.message);

    return parseStudentReportPayload(reportData);
  });

/**
 * Link a parent account to a student account using the student's alliance code.
 */
export const linkStudentByCode = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d: unknown) =>
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

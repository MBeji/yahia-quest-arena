import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";

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
    z
      .object({
        page: z.number().int().min(1).default(1),
        pageSize: z.number().int().min(1).max(200).default(100),
      })
      .parse((d ?? {}) as Record<string, unknown>),
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
          .select(
            "id, display_name, hero_class, level, xp, current_streak, longest_streak, last_active_date, created_at, role",
          )
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
      .select(
        "id, display_name, hero_class, level, xp, current_streak, longest_streak, last_active_date, created_at",
      )
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
  .inputValidator((d: unknown) => z.object({ studentId: z.string().uuid() }).parse(d))
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
    z
      .object({
        studentCode: z.string().min(8).max(64),
        relationLabel: z
          .string()
          .trim()
          .min(2)
          .max(40)
          .regex(/^[\p{L}\p{N} _-]+$/u)
          .default("parent"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `parent_link_${userId}`, 20, 60_000)) {
      throw new Error("Too many link attempts. Please slow down.");
    }

    // Role check, alliance-code decode, student validation and the link write
    // all happen inside the `link_student_by_code` SECURITY DEFINER RPC; direct
    // INSERTs into parent_student_links are revoked at the DB layer so a caller
    // can no longer self-link to an arbitrary student.
    const { data: result, error } = await supabase.rpc("link_student_by_code", {
      p_code: data.studentCode,
      p_relation: data.relationLabel,
    });
    if (error) throw new Error(error.message);

    const row = result && typeof result === "object" ? (result as Record<string, unknown>) : {};
    return {
      linked: row.linked === true,
      student: {
        id: typeof row.student_id === "string" ? row.student_id : "",
        displayName: typeof row.student_display_name === "string" ? row.student_display_name : null,
      },
    };
  });

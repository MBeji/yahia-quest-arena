import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";

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

// The RPC returns a `Json` value; validate field-by-field with zod, coercing
// numbers, defaulting arrays to [], and constraining the verdict union with a
// safe fallback so the route's `.map()`/`summary.verdict` access can never crash.
const numberish = z.coerce.number().catch(0);
const VERDICT_VALUES = ["excellent", "good", "average", "needs_improvement", "inactive"] as const;

const weekSliceSchema = z
  .object({
    exercises: numberish,
    minutes: numberish,
    avgScore: numberish,
  })
  .catch({ exercises: 0, minutes: 0, avgScore: 0 });

const chapterInsightSchema = z.object({
  chapterId: z.string().catch(""),
  chapterTitle: z.string().catch(""),
  subjectId: z.string().catch(""),
  subjectName: z.string().catch(""),
  attempts: numberish,
  avgScore: numberish,
});

const studentReportSchema = z.object({
  student: z
    .object({
      displayName: z.string().nullable().catch(null),
      heroClass: z.string().nullable().catch(null),
      level: numberish,
      xp: numberish,
      currentStreak: numberish,
      longestStreak: numberish,
      lastActiveDate: z.string().nullable().catch(null),
      createdAt: z.string().catch(""),
    })
    .catch({
      displayName: null,
      heroClass: null,
      level: 0,
      xp: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastActiveDate: null,
      createdAt: "",
    }),
  summary: z
    .object({
      totalTimeMinutes: numberish,
      totalExercises: numberish,
      avgScore: numberish,
      daysActiveThisWeek: numberish,
      seriousnessScore: numberish,
      verdict: z.enum(VERDICT_VALUES).catch("average"),
      scoreTrend: numberish,
    })
    .catch({
      totalTimeMinutes: 0,
      totalExercises: 0,
      avgScore: 0,
      daysActiveThisWeek: 0,
      seriousnessScore: 0,
      verdict: "average",
      scoreTrend: 0,
    }),
  subjectStats: z
    .array(
      z.object({
        subjectId: z.string().catch(""),
        name: z.string().catch(""),
        colorToken: z.string().nullable().catch(null),
        attempts: numberish,
        avgScore: numberish,
        totalTimeMinutes: numberish,
      }),
    )
    .catch([]),
  dailyActivity: z
    .array(
      z.object({
        date: z.string().catch(""),
        exercises: numberish,
        minutes: numberish,
        avgScore: numberish,
      }),
    )
    .catch([]),
  weekComparison: z
    .object({
      thisWeek: weekSliceSchema,
      lastWeek: weekSliceSchema,
    })
    .catch({
      thisWeek: { exercises: 0, minutes: 0, avgScore: 0 },
      lastWeek: { exercises: 0, minutes: 0, avgScore: 0 },
    }),
  chapterInsights: z
    .object({
      strengths: z.array(chapterInsightSchema).catch([]),
      weaknesses: z.array(chapterInsightSchema).catch([]),
    })
    .catch({ strengths: [], weaknesses: [] }),
});

type StudentReportShape = z.infer<typeof studentReportSchema>;

function parseStudentReportPayload(payload: unknown): StudentReportShape {
  if (!payload || typeof payload !== "object") {
    throw new Error("Invalid student report payload.");
  }

  return studentReportSchema.parse(payload);
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
    if (profileErr) {
      failWithClientError(
        "parentReport.getLinkedStudents: failed to load profile",
        profileErr,
        "Impossible de charger votre profil.",
      );
    }

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

      if (studentsRes.error) {
        failWithClientError(
          "parentReport.getLinkedStudents: failed to load students",
          studentsRes.error,
          "Impossible de charger la liste des élèves.",
        );
      }
      if (countRes.error) {
        failWithClientError(
          "parentReport.getLinkedStudents: failed to count students",
          countRes.error,
          "Impossible de charger la liste des élèves.",
        );
      }

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
    if (linksErr) {
      failWithClientError(
        "parentReport.getLinkedStudents: failed to load links",
        linksErr,
        "Impossible de charger les élèves associés.",
      );
    }

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
    if (studentsErr) {
      failWithClientError(
        "parentReport.getLinkedStudents: failed to load linked students",
        studentsErr,
        "Impossible de charger les élèves associés.",
      );
    }

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
  .inputValidator((d: unknown) => z.object({ studentId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: reportData, error: reportErr } = await supabase.rpc("get_student_report", {
      p_student: data.studentId,
    });

    if (reportErr) {
      failWithClientError(
        "parentReport.getStudentReport: RPC failed",
        reportErr,
        "Impossible de charger le rapport de l'élève.",
      );
    }

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
    if (error) {
      failWithClientError(
        "parentReport.linkStudentByCode: RPC failed",
        error,
        "Impossible d'associer cet élève. Vérifiez le code et réessayez.",
      );
    }

    const row = result && typeof result === "object" ? (result as Record<string, unknown>) : {};
    return {
      linked: row.linked === true,
      student: {
        id: typeof row.student_id === "string" ? row.student_id : "",
        displayName: typeof row.student_display_name === "string" ? row.student_display_name : null,
      },
    };
  });

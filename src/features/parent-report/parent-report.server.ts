import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { optionalSupabaseAuth } from "@/shared/integrations/supabase/optional-auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { GOAL_TARGET_MAX } from "@/shared/constants/gamification";
import { logger } from "@/shared/lib/logger";
import { errorMessage, failWithClientError } from "@/shared/lib/safe-error";
// Alliance-code failures travel as STABLE codes and are translated client-side
// in the visitor's language (étude 15, lot 3 — audit §F-1). Codes + prefixes +
// mappers live in the pure, client-safe ./parent-code-errors module.
import {
  PARENT_LINK_ERROR_PREFIX,
  REPORT_CODE_ERROR_PREFIX,
  parentCodeErrorCode,
} from "./parent-code-errors";
import { parseAttemptDetail, parseDailyReport } from "./insights/daily-report.schemas";
// Les schémas de niveau module vivent à part (2026-10-31) : voir ce fichier.
import {
  dailyGoalSchema,
  examSummarySchema,
  isoDate,
  parseStudentReportPayload,
  tutorCountersSchema,
  weeklyGoalSchema,
  type StudentExamSummary,
} from "./parent-report.schemas";

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

/**
 * Get the list of students visible to the current user (parent sees linked, admin sees all).
 */
export const getLinkedStudents = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
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
  .validator((d: unknown) => z.object({ studentId: z.guid() }).parse(d))
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
 * Le tableau de bord « jour par jour » : tout ce qui est MESURÉ sur une période.
 *
 * Les règles de jugement (engagement, efficacité, alertes) ne sont pas ici :
 * elles vivent dans `./insights`, en TypeScript pur et testé. Le serveur ne rend
 * que des faits — c'est aussi ce qui permettra d'y brancher une couche
 * d'insights IA sans retoucher le SQL.
 *
 * L'accès (admin, ou parent réellement lié à l'élève) est vérifié dans la RPC
 * SECURITY DEFINER. Rien de ceci n'est joignable par le chemin public au code
 * alliance : l'activité détaillée d'un mineur ne passe pas derrière une capacité
 * au porteur.
 */
export const getStudentDailyReport = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
    z
      .object({
        studentId: z.guid(),
        from: isoDate,
        to: isoDate,
        // Le périmètre n'est plus un jeu fermé — les niveaux et les thèmes sont
        // des données, pas une énumération. Sa FORME, elle, l'est : la RPC
        // dégrade vers « tout » sur une clé inconnue, ici on refuse simplement
        // ce qui n'a pas la bonne tête.
        scope: z
          .string()
          .regex(/^(all|class|grade:[0-9a-fA-F-]{36}|theme:[a-z0-9-]{1,64})$/)
          .default("all"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: payload, error } = await supabase.rpc("get_student_daily_report", {
      p_student: data.studentId,
      p_from: data.from,
      p_to: data.to,
      p_scope: data.scope,
    });

    if (error) {
      failWithClientError(
        "parentReport.getStudentDailyReport: RPC failed",
        error,
        "Impossible de charger l'activité de l'élève.",
      );
    }

    return parseDailyReport(payload);
  });

/**
 * Le même tableau de bord, ouvert au PORTEUR DU CODE alliance — sans compte.
 *
 * Décision produit du 2026-08-16 : le parent qui ouvre `/suivi` avec le code voit
 * exactement ce que voit le parent connecté. C'est un accès au porteur assumé,
 * comme le bilan depuis étude 15 : quiconque détient le code voit tout. Le
 * décodage du code et la vérification « c'est bien un élève » vivent dans la RPC.
 */
export const getStudentDailyReportByCode = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d: unknown) =>
    z
      .object({
        studentCode: z.string().min(8).max(64),
        from: isoDate,
        to: isoDate,
        // Le périmètre n'est plus un jeu fermé — les niveaux et les thèmes sont
        // des données, pas une énumération. Sa FORME, elle, l'est : la RPC
        // dégrade vers « tout » sur une clé inconnue, ici on refuse simplement
        // ce qui n'a pas la bonne tête.
        scope: z
          .string()
          .regex(/^(all|class|grade:[0-9a-fA-F-]{36}|theme:[a-z0-9-]{1,64})$/)
          .default("all"),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: payload, error } = await supabase.rpc("get_student_daily_report_by_code", {
      p_code: data.studentCode,
      p_from: data.from,
      p_to: data.to,
      p_scope: data.scope,
    });

    if (error) {
      const raw = errorMessage(error);
      logger.error("parentReport.getStudentDailyReportByCode: RPC failed", { error: raw });
      throw new Error(REPORT_CODE_ERROR_PREFIX + parentCodeErrorCode(raw));
    }

    return parseDailyReport(payload);
  });

/**
 * Le détail d'une tentative : les questions posées et ce que l'enfant a répondu.
 *
 * La bonne réponse et l'explication sont volontairement absentes pour un quiz de
 * compréhension — la RPC les met à `null` et lève `reviewHidden`. Sans cette
 * règle, il suffirait à un élève d'ouvrir un compte parent et de s'y lier avec
 * son propre code pour lire la correction d'un quiz qu'il doit repasser.
 */
export const getStudentAttemptDetail = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => z.object({ studentId: z.guid(), attemptId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: payload, error } = await supabase.rpc("get_student_attempt_detail", {
      p_student: data.studentId,
      p_attempt: data.attemptId,
    });

    if (error) {
      failWithClientError(
        "parentReport.getStudentAttemptDetail: RPC failed",
        error,
        "Impossible de charger le détail de cet exercice.",
      );
    }

    return parseAttemptDetail(payload);
  });

/** Le même détail, ouvert au porteur du code alliance (cf. ci-dessus). */
export const getStudentAttemptDetailByCode = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d: unknown) =>
    z.object({ studentCode: z.string().min(8).max(64), attemptId: z.guid() }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: payload, error } = await supabase.rpc("get_student_attempt_detail_by_code", {
      p_code: data.studentCode,
      p_attempt: data.attemptId,
    });

    if (error) {
      const raw = errorMessage(error);
      logger.error("parentReport.getStudentAttemptDetailByCode: RPC failed", { error: raw });
      throw new Error(REPORT_CODE_ERROR_PREFIX + parentCodeErrorCode(raw));
    }

    return parseAttemptDetail(payload);
  });

/**
 * Read the current-week family goal (target + live progress) for a linked student.
 * Returns null when no goal is set this week.
 */
export const getStudentWeeklyGoal = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => z.object({ studentId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: goal, error } = await supabase.rpc("get_family_weekly_goal", {
      p_student: data.studentId,
    });
    if (error) {
      failWithClientError(
        "parentReport.getStudentWeeklyGoal: RPC failed",
        error,
        "Impossible de charger l'objectif de la semaine.",
      );
    }
    return weeklyGoalSchema.parse(goal ?? null);
  });

/**
 * Set (upsert) the current-week goal for a linked student. The link check lives
 * in the `set_parent_weekly_goal` SECURITY DEFINER RPC.
 */
export const setStudentWeeklyGoal = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
    z
      .object({ studentId: z.guid(), target: z.number().int().min(1).max(GOAL_TARGET_MAX) })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `weekly_goal_${userId}`, 30, 60_000)) {
      throw new Error("Too many goal updates. Please slow down.");
    }

    const { data: result, error } = await supabase.rpc("set_parent_weekly_goal", {
      p_student: data.studentId,
      p_target: data.target,
    });
    if (error) {
      failWithClientError(
        "parentReport.setStudentWeeklyGoal: RPC failed",
        error,
        "Impossible d'enregistrer l'objectif de la semaine.",
      );
    }

    const row = result && typeof result === "object" ? (result as Record<string, unknown>) : {};
    return { target: typeof row.target === "number" ? row.target : data.target };
  });

/**
 * Read today's family goal (target + live progress) for a linked student.
 * Returns null when no goal is set today.
 */
export const getStudentDailyGoal = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => z.object({ studentId: z.guid() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { data: goal, error } = await supabase.rpc("get_family_daily_goal", {
      p_student: data.studentId,
    });
    if (error) {
      failWithClientError(
        "parentReport.getStudentDailyGoal: RPC failed",
        error,
        "Impossible de charger l'objectif du jour.",
      );
    }
    return dailyGoalSchema.parse(goal ?? null);
  });

/**
 * Set (upsert) today's goal for a linked student. The link check lives in the
 * `set_parent_daily_goal` SECURITY DEFINER RPC.
 */
export const setStudentDailyGoal = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
    z
      .object({ studentId: z.guid(), target: z.number().int().min(1).max(GOAL_TARGET_MAX) })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `daily_goal_${userId}`, 30, 60_000)) {
      throw new Error("Too many goal updates. Please slow down.");
    }

    const { data: result, error } = await supabase.rpc("set_parent_daily_goal", {
      p_student: data.studentId,
      p_target: data.target,
    });
    if (error) {
      failWithClientError(
        "parentReport.setStudentDailyGoal: RPC failed",
        error,
        "Impossible d'enregistrer l'objectif du jour.",
      );
    }

    const row = result && typeof result === "object" ? (result as Record<string, unknown>) : {};
    return { target: typeof row.target === "number" ? row.target : data.target };
  });

/**
 * Link a parent account to a student account using the student's alliance code.
 */
export const linkStudentByCode = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) =>
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
      const raw = errorMessage(error);
      logger.error("parentReport.linkStudentByCode: RPC failed", { error: raw });
      throw new Error(PARENT_LINK_ERROR_PREFIX + parentCodeErrorCode(raw));
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

/**
 * PUBLIC student report by alliance code — no account, no session required.
 *
 * Product decision (2026-07-08): a parent can open their child's read-only report
 * with the alliance code alone. The code is a bearer capability (= the student's
 * 122-bit-random UUID, shown on their dashboard). Access, code decode and the
 * "target must be a student" check all live in the anon-callable
 * `get_student_report_by_code` SECURITY DEFINER RPC; login stays optional and only
 * unlocks the write-side extras (weekly goal, push digest).
 */
export const getStudentReportByCode = createServerFn({ method: "GET" })
  .middleware([optionalSupabaseAuth])
  .validator((d: unknown) => z.object({ studentCode: z.string().min(8).max(64) }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;

    const { data: reportData, error } = await supabase.rpc("get_student_report_by_code", {
      p_code: data.studentCode,
    });

    if (error) {
      const raw = errorMessage(error);
      logger.error("parentReport.getStudentReportByCode: RPC failed", { error: raw });
      throw new Error(REPORT_CODE_ERROR_PREFIX + parentCodeErrorCode(raw));
    }

    return parseStudentReportPayload(reportData);
  });
// ---------------------------------------------------------------------------
// ÉTUDE 11 LOT 4 (Q-5) — CE QUE LE PARENT VOIT DE L'AIDE DU TUTEUR.
// ---------------------------------------------------------------------------
// Des compteurs et des THÈMES, jamais le verbatim des conversations.
//
// ⚠️ DEUX FRONTIÈRES SE CROISENT ICI, ET AUCUNE N'EST NÉGOCIABLE.
//
// 1. FRONTIÈRE DE FEATURES (AGENTS.md) : `parent-report` n'importe PAS
//    `@/features/tutor`. La server fn appelle donc la RPC directement, comme
//    toutes ses voisines de ce fichier. Il n'y a rien à partager entre les deux
//    features — le contrat est en SQL.
//
// 2. FRONTIÈRE DE VIE PRIVÉE (Q-5) : ces compteurs ne rejoignent PAS
//    `_student_report_json`. Cette fonction-là sert aussi
//    `get_student_report_by_code`, qui est GRANT à **anon** — un accès au
//    porteur du code alliance. Y greffer l'usage du tuteur le publierait à
//    quiconque détient le code, sans aucun lien parent vérifié. D'où une RPC
//    séparée, une server fn séparée, et un prop OPTIONNEL sur `ReportContent`
//    que seule la route AUTHENTIFIÉE remplit.

/** Les compteurs d'aide, tels que l'écran parent les rend. Aucun verbatim. */
export type TutorParentCounters = {
  interactions7d: number;
  interactions30d: number;
  topThemes: {
    tag: string;
    labelFr: string;
    labelEn: string;
    labelAr: string;
    count: number;
  }[];
};

/**
 * Q-5 — le compteur d'usage du tuteur pour un enfant LIÉ.
 *
 * Le lien actif est exigé par la RPC (`is_parent_of_student`), pas ici : un
 * second contrôle côté Node donnerait deux juges du même lien, et c'est celui
 * de Node qui oublierait `is_active` un jour.
 *
 * Rend `null` sur refus comme sur panne, et c'est délibéré : un encadré vide
 * disparaît de l'écran, alors qu'une erreur ferait croire à un parent que le
 * rapport entier est cassé. Le reste du rapport, lui, est déjà chargé.
 */
export const getTutorParentCounters = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => z.object({ studentId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<TutorParentCounters | null> => {
    const { supabase } = context;

    const { data: raw, error } = await (
      supabase as unknown as {
        rpc: (
          fn: "get_tutor_parent_counters",
          args: Record<string, unknown>,
        ) => PromiseLike<{ data: unknown; error: { message: string } | null }>;
      }
    ).rpc("get_tutor_parent_counters", { p_student_id: data.studentId });

    if (error) {
      logger.warn("parentReport.tutorCounters", { error: errorMessage(error) });
      return null;
    }
    const parsed = tutorCountersSchema.safeParse(raw);
    if (!parsed.success) return null;
    return {
      interactions7d: parsed.data.interactions_7d,
      interactions30d: parsed.data.interactions_30d,
      topThemes: parsed.data.top_themes.map((theme) => ({
        tag: theme.tag,
        labelFr: theme.label_fr,
        labelEn: theme.label_en,
        labelAr: theme.label_ar,
        count: theme.count,
      })),
    };
  });

// ---------------------------------------------------------------------------
// ÉTUDE 08 LOT 1 (US-5) — LES EXAMENS BLANCS DE L'ENFANT.
// ---------------------------------------------------------------------------
// Même double frontière que les compteurs du tuteur ci-dessus : la lecture passe
// par une RPC à part (`parent-report` n'importe pas `@/features/exam`), et elle
// ne rejoint PAS `_student_report_json` — le chemin public au code alliance ne
// la sert donc pas. Le lien actif est jugé dans la RPC.
//
// `null` sur refus comme sur panne : la section disparaît, le reste du bilan —
// déjà chargé — reste lisible. Une section qui échoue ne casse pas la page.
export const getStudentExamSummary = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .validator((d: unknown) => z.object({ studentId: z.guid() }).parse(d))
  .handler(async ({ data, context }): Promise<StudentExamSummary | null> => {
    const { supabase } = context;

    const { data: raw, error } = await supabase.rpc("get_student_exam_summary", {
      p_student: data.studentId,
    });
    if (error) {
      logger.warn("parentReport.examSummary", { error: errorMessage(error) });
      return null;
    }
    const parsed = examSummarySchema.safeParse(raw);
    return parsed.success ? parsed.data : null;
  });

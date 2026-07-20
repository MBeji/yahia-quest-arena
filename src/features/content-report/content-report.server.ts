import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import type { TablesInsert } from "@/shared/integrations/supabase/types";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";

export type ContentReportStatus = "open" | "resolved" | "dismissed";

/**
 * What the student is reporting (étude 20, Q-3 — cadrage du type au lot 1).
 *
 * `recall_false_negative` = « ma réponse était juste et le Rappel l'a refusée »
 * (US-5). Le lot 1 se contente de rendre ces signalements DISTINGUABLES dès
 * maintenant, pour que la file existante ne les noie pas ; la file admin dédiée
 * et la procédure d'ajout de variante sont le lot 6, quand le volume réel sera
 * connu. Enum fermé, miroir du CHECK `content_reports_kind_check`.
 */
export type ContentReportKind = "content_error" | "recall_false_negative";

const CONTENT_REPORT_KINDS = ["content_error", "recall_false_negative"] as const;

/**
 * Ligne d'insertion élargie à la colonne `kind` de l'étude 20, que les types
 * Supabase GÉNÉRÉS ignorent encore (ils datent d'avant la migration de ce lot).
 * Même posture que le narrowing `ChapterLessonRow` de `quest.server.ts` pour la
 * colonne `videos` : on décrit la ligne localement plutôt que d'éditer à la main
 * `src/shared/integrations/supabase/types.ts`, qui est généré. Dette : la
 * prochaine régénération des types rend ce type superflu.
 */
type ContentReportInsert = {
  user_id: string;
  exercise_id: string | null;
  question_id: string | null;
  message: string;
  status: ContentReportStatus;
  kind: ContentReportKind;
};

/** A content error report, as exposed to the admin queue. */
export type ContentReport = {
  id: string;
  message: string;
  status: ContentReportStatus;
  createdAt: string;
  exerciseId: string | null;
  exerciseTitle: string | null;
  subjectId: string | null;
  questionId: string | null;
};

const LOAD_ERROR_FR = "Impossible de charger les signalements.";

/** Report a suspected mistake in an exercise/question. Rate-limited (anti-spam). */
export const reportContentError = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        exerciseId: z.guid().optional(),
        questionId: z.guid().optional(),
        message: z.string().trim().min(5).max(1000),
        // Étude 20 Q-3: omis = le signalement de contenu historique, donc les
        // appelants existants sont inchangés.
        kind: z.enum(CONTENT_REPORT_KINDS).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `report_${userId}`, 5, 60_000)) {
      throw new Error("Trop de signalements. Réessaie dans une minute.");
    }

    const row: ContentReportInsert = {
      user_id: userId,
      exercise_id: data.exerciseId ?? null,
      question_id: data.questionId ?? null,
      message: data.message,
      status: "open",
      kind: data.kind ?? "content_error",
    };
    // Le client rejette toute propriété excédentaire, et `kind` n'existe pas
    // encore dans les types générés. Le cast ne porte QUE là-dessus : `row` est
    // vérifié juste au-dessus contre `ContentReportInsert`, donc les colonnes
    // historiques restent typées, et `kind` part bien sur le fil.
    const { error } = await supabase
      .from("content_reports")
      .insert(row as TablesInsert<"content_reports">);
    if (error)
      failWithClientError(
        "contentReport.reportContentError",
        error,
        "Impossible d'envoyer le signalement. Réessaie.",
      );
    return { ok: true } as const;
  });

/** Admin: list all reports (open first) with exercise context. */
export const listContentReports = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ reports: ContentReport[] }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_list_content_reports");
    if (error) failWithClientError("contentReport.listContentReports", error, LOAD_ERROR_FR);
    return {
      reports: (data ?? []).map((r) => ({
        id: r.id,
        message: r.message,
        status: r.status as ContentReportStatus,
        createdAt: r.created_at,
        exerciseId: r.exercise_id,
        exerciseTitle: r.exercise_title,
        subjectId: r.subject_id,
        questionId: r.question_id,
      })),
    };
  });

/** Admin: count of open reports (nav badge). Graceful 0 on error / non-admin. */
export const getOpenReportsCount = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ count: number }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_open_reports_count");
    if (error) return { count: 0 };
    return { count: typeof data === "number" ? data : 0 };
  });

/** Admin: resolve or dismiss a report. */
export const resolveContentReport = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({ reportId: z.guid(), status: z.enum(["resolved", "dismissed"]) }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("admin_resolve_content_report", {
      p_report: data.reportId,
      p_status: data.status,
    });
    if (error)
      failWithClientError(
        "contentReport.resolveContentReport",
        error,
        "Impossible de traiter le signalement.",
      );
    return { ok: true } as const;
  });

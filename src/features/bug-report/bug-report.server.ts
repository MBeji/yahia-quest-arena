import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { isRateLimited } from "@/shared/lib/rate-limit";
import { failWithClientError } from "@/shared/lib/safe-error";

export type BugReportStatus = "open" | "resolved" | "dismissed";

/** A bug report, as exposed to the admin queue. */
export type BugReport = {
  id: string;
  message: string;
  page: string | null;
  status: BugReportStatus;
  createdAt: string;
};

const LOAD_ERROR_FR = "Impossible de charger les bugs signalés.";

/**
 * Report a general bug during the beta phase (broken UI, stuck flow, perf…).
 * Distinct from content reports (those flag a mistake in a specific exercise).
 * Rate-limited (anti-spam). `page` carries the route the user was on.
 */
export const reportBug = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        message: z.string().trim().min(5).max(2000),
        page: z.string().trim().max(200).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase, userId } = context;

    if (await isRateLimited(supabase, `bug_${userId}`, 5, 60_000)) {
      throw new Error("Trop de signalements. Réessaie dans une minute.");
    }

    const { error } = await supabase.from("bug_reports").insert({
      user_id: userId,
      message: data.message,
      page: data.page ?? null,
      status: "open",
    });
    if (error)
      failWithClientError(
        "bugReport.reportBug",
        error,
        "Impossible d'envoyer le signalement. Réessaie.",
      );
    return { ok: true } as const;
  });

/** Admin: list all bug reports (open first). */
export const listBugReports = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ reports: BugReport[] }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_list_bug_reports");
    if (error) failWithClientError("bugReport.listBugReports", error, LOAD_ERROR_FR);
    return {
      reports: (data ?? []).map((r) => ({
        id: r.id,
        message: r.message,
        page: r.page,
        status: r.status as BugReportStatus,
        createdAt: r.created_at,
      })),
    };
  });

/** Admin: count of open bug reports (nav badge). Graceful 0 on error / non-admin. */
export const getOpenBugsCount = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ count: number }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_open_bugs_count");
    if (error) return { count: 0 };
    return { count: typeof data === "number" ? data : 0 };
  });

/** Admin: resolve or dismiss a bug report. */
export const resolveBugReport = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z.object({ reportId: z.guid(), status: z.enum(["resolved", "dismissed"]) }).parse(d),
  )
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("admin_resolve_bug_report", {
      p_report: data.reportId,
      p_status: data.status,
    });
    if (error)
      failWithClientError(
        "bugReport.resolveBugReport",
        error,
        "Impossible de traiter le signalement.",
      );
    return { ok: true } as const;
  });

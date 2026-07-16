import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { logger } from "@/shared/lib/logger";

// ---------- Manuel élève full PDF (login-gated, subject level) ----------

/** One official-textbook PDF volume available on the subject page. */
export type SubjectManuel = { code: string; label: string | null; url: string };

/** Private Storage bucket holding the complete manuel-élève PDFs (one per volume). */
const MANUEL_ELEVE_BUCKET = "manuel-eleve";
/** Signed-URL lifetime — mirrors the manuel-pages gallery's TTL. */
const MANUEL_PDF_SIGNED_URL_TTL_SECONDS = 60 * 60;

/**
 * Mint **signed URLs** for official student-textbook (manuel élève) PDF
 * volumes, gated to authenticated users. The volume list itself is public
 * metadata (`subjects.manuel_refs`, shipped with `getSubject`); the client
 * passes back the codes it wants to open. This grants nothing beyond the
 * caller's own storage rights — the private bucket's RLS already lets ANY
 * authenticated user read every object in it (and lets anonymous read none) —
 * the fn only turns that right into short-lived URLs. Codes are shape-checked
 * (path-traversal guard) and volumes whose file is missing are skipped, so the
 * card degrades to nothing when the PDFs are not uploaded yet.
 */
export const getSubjectManuels = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        manuels: z
          .array(
            z.object({
              code: z.string().regex(/^[A-Za-z0-9_-]+$/),
              label: z.string().min(1).nullish(),
            }),
          )
          .min(1)
          .max(8),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<{ manuels: SubjectManuel[] }> => {
    const { supabase } = context;

    const paths = data.manuels.map((m) => `${m.code}.pdf`);
    const { data: signed, error: signError } = await supabase.storage
      .from(MANUEL_ELEVE_BUCKET)
      .createSignedUrls(paths, MANUEL_PDF_SIGNED_URL_TTL_SECONDS);
    if (signError || !signed) {
      logger.warn("quest.getSubjectManuels: failed to sign manuel pdf urls", {
        codes: data.manuels.map((m) => m.code),
      });
      return { manuels: [] };
    }

    const urlByPath = new Map(
      signed.flatMap((s) => (s.error || !s.signedUrl || !s.path ? [] : [[s.path, s.signedUrl]])),
    );
    // Preserve the authored volume order; skip volumes whose file is missing.
    const manuels: SubjectManuel[] = data.manuels.flatMap((m) => {
      const url = urlByPath.get(`${m.code}.pdf`);
      return url ? [{ code: m.code, label: m.label ?? null, url }] : [];
    });

    return { manuels };
  });

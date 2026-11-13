import { createServerFn } from "@tanstack/react-start";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";

/**
 * « Cet élève a-t-il un parent lié ACTIF ? » — étude 40, lot 5 (R-20).
 *
 * Lue par l'écran de résultat pour décider de la carte « Inviter mon parent ». Un fichier à part,
 * importé directement par la route : passer par `parent-report.server.ts` (ou par le barrel)
 * tirerait les schémas du bilan dans le chunk de la quête.
 *
 * Aucune entrée : l'élève est celui de la session, et la politique RLS « Parents and students can
 * view their links » ne lui rend que SES liens. Même colonne, même filtre que le digest
 * (`tutor/digest.server.ts`) — deux lectures cohérentes, pas deux juges. Un booléen sort, rien
 * d'autre : ni le parent, ni le libellé de la relation.
 *
 * Une lecture en échec LÈVE : l'appelant n'a alors pas de réponse, donc pas de carte (sens sûr).
 */
export const hasActiveParentLink = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<boolean> => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("parent_student_links")
      .select("parent_user_id")
      .eq("student_user_id", userId)
      .eq("is_active", true)
      .limit(1);
    if (error) {
      failWithClientError(
        "parentReport.hasActiveParentLink: failed to load links",
        error,
        "Impossible de lire le lien parent.",
      );
    }
    return (data ?? []).length > 0;
  });

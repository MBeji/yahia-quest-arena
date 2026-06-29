import { createServerFn } from "@tanstack/react-start";
import { z } from "zod";
import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import { failWithClientError } from "@/shared/lib/safe-error";
import {
  BETA_ACCESS_MONTHS,
  FLAGSHIP_PARCOURS_ID,
  PREMIUM_PARCOURS_IDS,
  type BetaRequestStatus,
} from "@/shared/constants/subscription";

/** A beta access request as exposed to the client. */
export type BetaRequest = {
  id: string;
  name: string;
  email: string;
  motivation: string | null;
  status: BetaRequestStatus;
  createdAt: string;
  reviewedAt: string | null;
};

const LOAD_ERROR_FR = "Impossible de charger les demandes d'accès bêta.";
/** Thrown when a user who already has a live request submits a new one. */
export const BETA_ALREADY_REQUESTED_FR =
  "Tu as déjà une demande d'accès bêta en cours. Consulte son statut.";

/** The current user's latest beta access request (drives the request form/status). */
export const getMyBetaRequest = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<BetaRequest | null> => {
    const { supabase, userId } = context;
    const { data, error } = await supabase
      .from("beta_access_requests")
      .select("id,name,email,motivation,status,created_at,reviewed_at")
      .eq("user_id", userId)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();
    if (error) failWithClientError("betaAccess.getMyBetaRequest", error, LOAD_ERROR_FR);
    if (!data) return null;
    return {
      id: data.id,
      name: data.name,
      email: data.email,
      motivation: data.motivation,
      status: data.status as BetaRequestStatus,
      createdAt: data.created_at,
      reviewedAt: data.reviewed_at,
    };
  });

/** Submit a beta access request (status pending). Rejected if one is already live. */
export const requestBetaAccess = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) =>
    z
      .object({
        name: z.string().trim().min(1).max(120),
        email: z.string().trim().email().max(200),
        motivation: z.string().trim().max(1000).optional(),
      })
      .parse(d),
  )
  .handler(async ({ data, context }): Promise<{ status: BetaRequestStatus }> => {
    const { supabase, userId } = context;

    // A pending or already-approved request means no new submission.
    const { data: existing, error: exErr } = await supabase
      .from("beta_access_requests")
      .select("status")
      .eq("user_id", userId)
      .in("status", ["pending", "approved"])
      .limit(1)
      .maybeSingle();
    if (exErr) failWithClientError("betaAccess.requestBetaAccess", exErr, LOAD_ERROR_FR);
    if (existing)
      failWithClientError("betaAccess.requestBetaAccess", null, BETA_ALREADY_REQUESTED_FR);

    const { error } = await supabase.from("beta_access_requests").insert({
      user_id: userId,
      name: data.name,
      email: data.email,
      motivation: data.motivation ?? null,
      status: "pending",
    });
    if (error)
      failWithClientError(
        "betaAccess.requestBetaAccess",
        error,
        "Impossible d'envoyer ta demande. Réessaie.",
      );
    return { status: "pending" };
  });

/** Admin: list all beta access requests (pending first). */
export const listBetaRequests = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ requests: BetaRequest[] }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_list_beta_requests");
    if (error) failWithClientError("betaAccess.listBetaRequests", error, LOAD_ERROR_FR);
    return {
      requests: (data ?? []).map((r) => ({
        id: r.id,
        name: r.name,
        email: r.email,
        motivation: r.motivation,
        status: r.status as BetaRequestStatus,
        createdAt: r.created_at,
        reviewedAt: r.reviewed_at,
      })),
    };
  });

/** Admin: count of pending requests (nav badge). */
export const getPendingBetaCount = createServerFn({ method: "GET" })
  .middleware([requireSupabaseAuth])
  .handler(async ({ context }): Promise<{ count: number }> => {
    const { supabase } = context;
    const { data, error } = await supabase.rpc("admin_pending_beta_count");
    // Graceful: non-admins / missing RPC → 0 (the nav badge just hides).
    if (error) return { count: 0 };
    return { count: typeof data === "number" ? data : 0 };
  });

/**
 * Admin: approve or reject a request. Approval grants free premium access.
 *
 * `admin_review_beta_request` is status-only (migration 20260609000000 removed
 * its legacy `subscription_*` write). Premium for a beta tester is a per-parcours
 * entitlement: on approval we grant a `beta` entitlement so the tester gets
 * access under the live (entitlement-based) gate.
 */
export const reviewBetaRequest = createServerFn({ method: "POST" })
  .middleware([requireSupabaseAuth])
  .inputValidator((d) => z.object({ requestId: z.guid(), approve: z.boolean() }).parse(d))
  .handler(async ({ data, context }) => {
    const { supabase } = context;
    const { error } = await supabase.rpc("admin_review_beta_request", {
      p_request: data.requestId,
      p_approve: data.approve,
    });
    if (error)
      failWithClientError(
        "betaAccess.reviewBetaRequest",
        error,
        "Impossible de traiter la demande.",
      );

    // On approval, grant a per-parcours `beta` entitlement so the tester gets
    // access under the live (entitlement-based) gate. Target the requester's
    // current parcours when it's premium; otherwise default to the flagship.
    if (data.approve) {
      const { data: req } = await supabase
        .from("beta_access_requests")
        .select("user_id")
        .eq("id", data.requestId)
        .maybeSingle();
      const betaUserId = req?.user_id;
      if (betaUserId) {
        const { data: profile } = await supabase
          .from("profiles")
          .select("current_parcours_id")
          .eq("id", betaUserId)
          .maybeSingle();
        const current = profile?.current_parcours_id ?? null;
        const targetParcoursId =
          current && (PREMIUM_PARCOURS_IDS as readonly string[]).includes(current)
            ? current
            : FLAGSHIP_PARCOURS_ID;

        const expires = new Date();
        expires.setMonth(expires.getMonth() + BETA_ACCESS_MONTHS);
        const { error: grantErr } = await supabase.rpc("admin_grant_parcours", {
          p_user: betaUserId,
          p_parcours: targetParcoursId,
          p_source: "beta",
          p_expires_at: expires.toISOString(),
        });
        if (grantErr)
          failWithClientError(
            "betaAccess.reviewBetaRequest.grant",
            grantErr,
            "Impossible de traiter la demande.",
          );
      }
    }

    return { ok: true } as const;
  });

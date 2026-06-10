import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/shared/integrations/supabase/client";
import { useAuth } from "./use-auth";

/**
 * Single source of truth for the signed-in user's role + active parcours.
 *
 * Every consumer — the authenticated layout (conditional nav + onboarding guard)
 * and all `/admin/*` route guards — MUST use this hook rather than rolling its own
 * `useQuery({ queryKey: ["me-role", user?.id] })`.
 *
 * They used to each inline that query with DIVERGING `queryFn` return shapes: the
 * layout returned the profile row object `{ role, current_parcours_id }`, while the
 * admin routes returned a bare `role` string. React Query caches by `queryKey`, so
 * the parent layout (which always mounts first) won the shared cache entry with the
 * object, and the admin routes then read that object where they expected a string →
 * `role === "admin"` was always false → admins were locked out of every console.
 * One definition, one shape, no collision.
 */
export function useMyRole() {
  const { user } = useAuth();

  const query = useQuery({
    queryKey: ["me-role", user?.id],
    enabled: !!user,
    staleTime: 5 * 60_000,
    queryFn: async () => {
      const { data } = await supabase
        .from("profiles")
        .select("role,current_parcours_id")
        .eq("id", user!.id)
        .single();
      return data ?? null;
    },
  });

  const profile = query.data ?? null;

  return {
    /** The profile role, or null while loading or if the profile row is missing. */
    role: profile?.role ?? null,
    /** The active parcours id (null = not onboarded yet). */
    currentParcoursId: profile?.current_parcours_id ?? null,
    /** True once a profile row has actually been read (distinguishes "no row" from "loading"). */
    hasProfile: profile != null,
    /** Convenience flag for admin-gated UI. */
    isAdmin: profile?.role === "admin",
    /** True once the query has resolved (success), regardless of whether a row exists. */
    isLoaded: query.isSuccess,
  };
}

import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/shared/integrations/supabase/client";
import { useAuth } from "./use-auth";

/**
 * Compact account stats for the signed-in user — the data behind the persistent
 * {@link AccountHud} (daily streak + XP) shown in BOTH shells so the value of the
 * account stays visible on shared content, not only on the dashboard (audit reco
 * #1/#6).
 *
 * Read-only select of the user's OWN profile row (the same RLS path `useMyRole`
 * relies on). Deliberately kept on its own query key `["me-stats", userId]` and NOT
 * folded into `["me-role"]` (which selects a different column set): two consumers of
 * one key with diverging shapes is exactly the cache-collision bug `useMyRole`
 * documents.
 */
export function useMyStats() {
  const { user } = useAuth();

  const query = useQuery({
    queryKey: ["me-stats", user?.id],
    enabled: !!user,
    staleTime: 60_000,
    queryFn: async () => {
      const { data } = await supabase
        .from("profiles")
        .select("xp,current_streak")
        .eq("id", user!.id)
        .single();
      return data ?? null;
    },
  });

  const profile = query.data ?? null;

  return {
    /** Lifetime XP, or null while loading / if the profile row is missing. */
    xp: profile?.xp ?? null,
    /** Current daily streak in days, or null while loading / if missing. */
    currentStreak: profile?.current_streak ?? null,
    /** True once a stats row has actually been read (distinguishes "no row" from "loading"). */
    hasStats: profile != null,
    /** True once the stats query has resolved (success), regardless of row presence. */
    isLoaded: query.isSuccess,
  };
}

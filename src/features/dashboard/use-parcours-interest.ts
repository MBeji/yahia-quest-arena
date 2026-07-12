import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { useT } from "@/lib/i18n";
import {
  getMyParcoursInterests,
  getParcoursInterestCounts,
  toggleParcoursInterest,
} from "./parcours-interest.server";

/** Per-parcours interest state, threaded from a route into the catalogue UI. */
export type ParcoursInterestState = {
  counts: Record<string, number>;
  mine: Set<string>;
  togglingId: string | null;
  onToggle: (id: string) => void;
};

const MINE_KEY = ["my-parcours-interests"] as const;
const COUNTS_KEY = ["parcours-interest-counts"] as const;

type MineData = { parcoursIds: string[] };
type CountsData = { counts: { parcoursId: string; name: string; count: number }[] };

/**
 * Interest-vote state + optimistic toggle for coming-soon parcours, shared by the
 * onboarding school step, the Explorer hub and the public lycée year page.
 * Encapsulates the two queries (my votes + aggregate counts) and the toggle
 * mutation so the routes stay thin.
 *
 * Anonymous surfaces (étude 16 D-7): pass `canVote: false` — the aggregate
 * counts still load (the RPC is anon-granted), the per-user votes query is
 * disabled, and a toggle attempt calls `onRequireAuth` (honest sign-in invite)
 * instead of hitting the authenticated RPC.
 */
export function useParcoursInterest(opts?: {
  canVote?: boolean;
  onRequireAuth?: () => void;
}): ParcoursInterestState {
  const canVote = opts?.canVote !== false;
  const t = useT();
  const queryClient = useQueryClient();
  const fetchMine = useServerFn(getMyParcoursInterests);
  const fetchCounts = useServerFn(getParcoursInterestCounts);
  const toggle = useServerFn(toggleParcoursInterest);

  const mineQuery = useQuery({ queryKey: MINE_KEY, queryFn: () => fetchMine(), enabled: canVote });
  const countsQuery = useQuery({ queryKey: COUNTS_KEY, queryFn: () => fetchCounts() });

  const mutation = useMutation({
    mutationFn: (parcoursId: string) => toggle({ data: { parcoursId } }),
    // Optimistic: flip membership + nudge the count so the toggle feels instant.
    onMutate: async (parcoursId) => {
      await Promise.all([
        queryClient.cancelQueries({ queryKey: MINE_KEY }),
        queryClient.cancelQueries({ queryKey: COUNTS_KEY }),
      ]);
      const prevMine = queryClient.getQueryData<MineData>(MINE_KEY);
      const prevCounts = queryClient.getQueryData<CountsData>(COUNTS_KEY);
      const ids = prevMine?.parcoursIds ?? [];
      const wasInterested = ids.includes(parcoursId);
      queryClient.setQueryData<MineData>(MINE_KEY, {
        parcoursIds: wasInterested ? ids.filter((x) => x !== parcoursId) : [...ids, parcoursId],
      });
      const delta = wasInterested ? -1 : 1;
      const counts = prevCounts?.counts ?? [];
      const exists = counts.some((c) => c.parcoursId === parcoursId);
      queryClient.setQueryData<CountsData>(COUNTS_KEY, {
        counts: exists
          ? counts.map((c) =>
              c.parcoursId === parcoursId ? { ...c, count: Math.max(0, c.count + delta) } : c,
            )
          : [...counts, { parcoursId, name: parcoursId, count: Math.max(0, delta) }],
      });
      return { prevMine, prevCounts };
    },
    onError: (_e, _id, ctx) => {
      if (ctx?.prevMine) queryClient.setQueryData(MINE_KEY, ctx.prevMine);
      if (ctx?.prevCounts) queryClient.setQueryData(COUNTS_KEY, ctx.prevCounts);
      toast.error(t.parcoursInterest.toggleError);
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: MINE_KEY });
      queryClient.invalidateQueries({ queryKey: COUNTS_KEY });
    },
  });

  const counts: Record<string, number> = {};
  for (const c of countsQuery.data?.counts ?? []) counts[c.parcoursId] = c.count;

  return {
    counts,
    mine: new Set(mineQuery.data?.parcoursIds ?? []),
    togglingId: mutation.isPending ? (mutation.variables ?? null) : null,
    onToggle: (id: string) => {
      if (!canVote) {
        opts?.onRequireAuth?.();
        return;
      }
      mutation.mutate(id);
    },
  };
}

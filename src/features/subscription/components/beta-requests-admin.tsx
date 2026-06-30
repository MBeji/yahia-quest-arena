import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Check, X, Loader2, Sparkles, Clock } from "lucide-react";
import { useT } from "@/lib/i18n";
import { isRtlText } from "@/shared/lib/utils";
import type { BetaRequestStatus } from "@/shared/constants/subscription";
import { listBetaRequests, reviewBetaRequest } from "../beta-access.server";

function StatusBadge({ status }: { status: BetaRequestStatus }) {
  const t = useT();
  const map = {
    pending: {
      Icon: Clock,
      label: t.betaAccess.statusPending,
      cls: "text-[color:var(--neon-gold)] border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/10",
    },
    approved: {
      Icon: Check,
      label: t.betaAccess.statusApproved,
      cls: "text-emerald-400 border-emerald-500/40 bg-emerald-500/10",
    },
    rejected: {
      Icon: X,
      label: t.betaAccess.statusRejected,
      cls: "text-destructive border-destructive/40 bg-destructive/10",
    },
  }[status];
  const { Icon } = map;
  return (
    <span
      className={`inline-flex items-center gap-1 rounded-full border px-2.5 py-0.5 text-xs font-bold ${map.cls}`}
    >
      <Icon className="h-3.5 w-3.5" /> {map.label}
    </span>
  );
}

/** Admin panel: lists beta access requests and lets the admin approve/reject them. */
export function BetaRequestsAdmin() {
  const t = useT();
  const qc = useQueryClient();
  const fetchList = useServerFn(listBetaRequests);
  const review = useServerFn(reviewBetaRequest);
  const [pendingId, setPendingId] = useState<string | null>(null);

  const listQuery = useQuery({
    queryKey: ["beta-requests-admin"],
    queryFn: () => fetchList(),
  });

  const mutation = useMutation({
    mutationFn: (v: { requestId: string; approve: boolean }) => review({ data: v }),
    onMutate: (v) => setPendingId(v.requestId),
    onSuccess: (_d, v) => {
      toast.success(v.approve ? t.betaAccess.approveOk : t.betaAccess.rejectOk);
      qc.invalidateQueries({ queryKey: ["beta-requests-admin"] });
      qc.invalidateQueries({ queryKey: ["beta-pending-count"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.betaAccess.reviewError),
    onSettled: () => setPendingId(null),
  });

  if (listQuery.isLoading) {
    return (
      <div className="grid place-items-center py-16">
        <Loader2 className="h-8 w-8 animate-spin text-[color:var(--neon-gold)]" />
      </div>
    );
  }
  if (listQuery.isError) {
    return (
      <div className="rounded-2xl border border-destructive/40 bg-destructive/5 p-6 text-sm text-destructive">
        {t.betaAccess.reviewError}
      </div>
    );
  }

  const requests = listQuery.data?.requests ?? [];
  const pendingCount = requests.filter((r) => r.status === "pending").length;

  return (
    <div>
      <div className="mb-6 flex items-center gap-3">
        <div className="grid h-11 w-11 place-items-center rounded-xl bg-[image:var(--gradient-gold)] shadow-gold">
          <Sparkles className="h-5 w-5 text-black" />
        </div>
        <div>
          <h1 className="flex items-center gap-2 font-display text-2xl font-bold">
            {t.betaAccess.adminTitle}
            {pendingCount > 0 && (
              <span className="rounded-full bg-[color:var(--neon-gold)]/20 px-2 py-0.5 text-xs font-bold text-[color:var(--neon-gold)]">
                {pendingCount} {t.betaAccess.pendingCount}
              </span>
            )}
          </h1>
          <p className="text-sm text-muted-foreground">{t.betaAccess.adminDesc}</p>
        </div>
      </div>

      {requests.length === 0 ? (
        <div className="rounded-2xl border border-border/50 bg-card/40 p-10 text-center text-sm text-muted-foreground">
          {t.betaAccess.empty}
        </div>
      ) : (
        <div className="space-y-3">
          {requests.map((r) => {
            const busy = pendingId === r.id && mutation.isPending;
            return (
              <div
                key={r.id}
                className="rounded-2xl border border-[color:var(--neon-gold)]/20 bg-card/50 p-4 backdrop-blur-md"
              >
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div className="min-w-0">
                    <div className="flex items-center gap-2 font-display font-bold">
                      {r.name} <StatusBadge status={r.status} />
                    </div>
                    <a
                      href={`mailto:${r.email}`}
                      className="text-sm text-[color:var(--neon-gold)] hover:underline"
                    >
                      {r.email}
                    </a>
                    <div className="text-xs text-muted-foreground">
                      {new Date(r.createdAt).toLocaleDateString()}
                    </div>
                  </div>
                  {r.status === "pending" && (
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => mutation.mutate({ requestId: r.id, approve: true })}
                        disabled={busy}
                        className="inline-flex min-h-11 items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-3 py-1.5 text-sm font-bold text-black shadow-gold transition hover:scale-105 disabled:opacity-50"
                      >
                        {busy ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Check className="h-4 w-4" />
                        )}
                        {t.betaAccess.approve}
                      </button>
                      <button
                        onClick={() => mutation.mutate({ requestId: r.id, approve: false })}
                        disabled={busy}
                        className="inline-flex min-h-11 items-center gap-1.5 rounded-lg border border-destructive/50 px-3 py-1.5 text-sm font-semibold text-destructive transition hover:bg-destructive/10 disabled:opacity-50"
                      >
                        <X className="h-4 w-4" /> {t.betaAccess.reject}
                      </button>
                    </div>
                  )}
                </div>
                {r.motivation && (
                  <p
                    className="mt-3 rounded-lg border border-border/40 bg-background/30 p-3 text-sm text-muted-foreground"
                    dir={isRtlText(r.motivation) ? "rtl" : undefined}
                  >
                    {r.motivation}
                  </p>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Bug, Check, X, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import { isRtlText } from "@/shared/lib/utils";
import type { BugReportStatus } from "../bug-report.server";
import { listBugReports, resolveBugReport } from "../bug-report.server";

function StatusBadge({ status }: { status: BugReportStatus }) {
  const t = useT();
  const map = {
    open: {
      label: t.bugReport.statusOpen,
      cls: "text-[color:var(--neon-gold)] border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/10",
    },
    resolved: {
      label: t.bugReport.statusResolved,
      cls: "text-success border-success/40 bg-success/10",
    },
    dismissed: {
      label: t.bugReport.statusDismissed,
      cls: "text-muted-foreground border-border/50 bg-card/40",
    },
  }[status];
  return (
    <span className={`rounded-full border px-2.5 py-0.5 text-xs font-bold ${map.cls}`}>
      {map.label}
    </span>
  );
}

/** Admin panel: review and resolve/dismiss user-submitted bug reports. */
export function BugReportsAdmin() {
  const t = useT();
  const qc = useQueryClient();
  const fetchList = useServerFn(listBugReports);
  const resolve = useServerFn(resolveBugReport);
  const [pendingId, setPendingId] = useState<string | null>(null);

  const listQuery = useQuery({
    queryKey: ["bug-reports-admin"],
    queryFn: () => fetchList(),
  });

  const mutation = useMutation({
    mutationFn: (v: { reportId: string; status: "resolved" | "dismissed" }) => resolve({ data: v }),
    onMutate: (v) => setPendingId(v.reportId),
    onSuccess: () => {
      toast.success(t.bugReport.updated);
      qc.invalidateQueries({ queryKey: ["bug-reports-admin"] });
      qc.invalidateQueries({ queryKey: ["open-bugs-count"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.bugReport.updateError),
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
        {t.bugReport.updateError}
      </div>
    );
  }

  const reports = listQuery.data?.reports ?? [];
  const openCount = reports.filter((r) => r.status === "open").length;

  return (
    <div>
      <div className="mb-6 flex items-center gap-3">
        <div className="grid h-11 w-11 place-items-center rounded-xl bg-[image:var(--gradient-gold)] shadow-gold">
          <Bug className="h-5 w-5 text-black" />
        </div>
        <div>
          <h1 className="flex items-center gap-2 font-display text-2xl font-bold">
            {t.bugReport.adminTitle}
            {openCount > 0 && (
              <span className="rounded-full bg-[color:var(--neon-gold)]/20 px-2 py-0.5 text-xs font-bold text-[color:var(--neon-gold)]">
                {openCount} {t.bugReport.openCount}
              </span>
            )}
          </h1>
          <p className="text-sm text-muted-foreground">{t.bugReport.adminDesc}</p>
        </div>
      </div>

      {reports.length === 0 ? (
        <div className="rounded-2xl border border-border/50 bg-card/40 p-10 text-center text-sm text-muted-foreground">
          {t.bugReport.empty}
        </div>
      ) : (
        <div className="space-y-3">
          {reports.map((r) => {
            const busy = pendingId === r.id && mutation.isPending;
            return (
              <div
                key={r.id}
                className="rounded-2xl border border-[color:var(--neon-gold)]/20 bg-card/50 p-4 backdrop-blur-md"
              >
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div className="min-w-0">
                    <div className="flex items-center gap-2 font-display font-bold">
                      <span className="font-mono text-sm text-[color:var(--neon-gold)]">
                        {r.page ?? t.bugReport.unknownPage}
                      </span>
                      <StatusBadge status={r.status} />
                    </div>
                    <div className="text-xs text-muted-foreground">
                      {new Date(r.createdAt).toLocaleDateString()}
                    </div>
                  </div>
                  {r.status === "open" && (
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => mutation.mutate({ reportId: r.id, status: "resolved" })}
                        disabled={busy}
                        className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-3 py-1.5 text-sm font-bold text-black shadow-gold transition hover:scale-105 disabled:opacity-50"
                      >
                        {busy ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Check className="h-4 w-4" />
                        )}
                        {t.bugReport.resolve}
                      </button>
                      <button
                        onClick={() => mutation.mutate({ reportId: r.id, status: "dismissed" })}
                        disabled={busy}
                        className="inline-flex items-center gap-1.5 rounded-lg border border-border/50 px-3 py-1.5 text-sm font-semibold text-muted-foreground transition hover:text-foreground disabled:opacity-50"
                      >
                        <X className="h-4 w-4" /> {t.bugReport.dismiss}
                      </button>
                    </div>
                  )}
                </div>
                <p
                  className="mt-3 rounded-lg border border-border/40 bg-background/30 p-3 text-sm text-muted-foreground"
                  dir={isRtlText(r.message) ? "rtl" : undefined}
                >
                  {r.message}
                </p>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

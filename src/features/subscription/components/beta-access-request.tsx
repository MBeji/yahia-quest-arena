import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { toast } from "sonner";
import { Sparkles, Clock, Check, X, Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import type { BetaRequestStatus } from "@/shared/constants/subscription";
import { getMyBetaRequest, requestBetaAccess } from "../beta-access.server";

const INPUT =
  "mt-1 w-full rounded-lg border border-[color:var(--neon-gold)]/30 bg-background/50 px-3 py-2 text-sm outline-none focus:border-[color:var(--neon-gold)]/70";

function StatusCard({ status }: { status: BetaRequestStatus }) {
  const t = useT();
  const map = {
    pending: {
      Icon: Clock,
      label: t.betaAccess.statusPending,
      desc: t.betaAccess.pendingDesc,
      cls: "text-[color:var(--neon-gold)] border-[color:var(--neon-gold)]/40 bg-[color:var(--neon-gold)]/10",
    },
    approved: {
      Icon: Check,
      label: t.betaAccess.statusApproved,
      desc: t.betaAccess.approvedDesc,
      cls: "text-success border-success/40 bg-success/10",
    },
    rejected: {
      Icon: X,
      label: t.betaAccess.statusRejected,
      desc: t.betaAccess.rejectedDesc,
      cls: "text-destructive border-destructive/40 bg-destructive/10",
    },
  }[status];
  const { Icon } = map;
  return (
    <div className="mt-4 rounded-xl border border-[color:var(--neon-gold)]/30 bg-background/30 p-4">
      <div className="text-xs uppercase tracking-widest text-muted-foreground">
        {t.betaAccess.statusLabel}
      </div>
      <div
        className={`mt-2 inline-flex items-center gap-1.5 rounded-full border px-3 py-1 text-sm font-bold ${map.cls}`}
      >
        <Icon className="h-4 w-4" /> {map.label}
      </div>
      <p className="mt-2 text-sm text-muted-foreground">{map.desc}</p>
    </div>
  );
}

/**
 * Beta tester free-access request, shown inside the paywall. Lets a user submit
 * one request (name/email/motivation); if a request already exists it shows its
 * status instead of the form (pending / approved / rejected).
 */
export function BetaAccessRequest() {
  const t = useT();
  const qc = useQueryClient();
  const fetchMine = useServerFn(getMyBetaRequest);
  const submit = useServerFn(requestBetaAccess);

  const [open, setOpen] = useState(false);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [motivation, setMotivation] = useState("");

  const mine = useQuery({ queryKey: ["beta-request"], queryFn: () => fetchMine() });

  const mutation = useMutation({
    mutationFn: () =>
      submit({
        data: {
          name: name.trim(),
          email: email.trim(),
          motivation: motivation.trim() || undefined,
        },
      }),
    onSuccess: () => {
      toast.success(t.betaAccess.sentTitle);
      setOpen(false);
      qc.invalidateQueries({ queryKey: ["beta-request"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.betaAccess.error),
  });

  if (mine.isLoading) {
    return (
      <div className="mt-4 flex items-center gap-2 text-sm text-muted-foreground">
        <Loader2 className="h-4 w-4 animate-spin" />
      </div>
    );
  }

  // Existing request → show its status (no new submission allowed).
  if (mine.data) return <StatusCard status={mine.data.status} />;

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="mt-4 inline-flex w-full items-center justify-center gap-2 rounded-lg border border-[color:var(--neon-gold)]/50 bg-[color:var(--neon-gold)]/10 px-4 py-2.5 text-sm font-bold text-[color:var(--neon-gold)] transition hover:bg-[color:var(--neon-gold)]/20"
      >
        <Sparkles className="h-4 w-4" /> {t.betaAccess.cta}
      </button>
    );
  }

  const canSubmit = name.trim().length > 0 && /\S+@\S+\.\S+/.test(email.trim());

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        if (canSubmit && !mutation.isPending) mutation.mutate();
      }}
      className="mt-4 rounded-xl border border-[color:var(--neon-gold)]/30 bg-background/30 p-4"
    >
      <div className="flex items-center gap-2 font-display text-sm font-bold text-[color:var(--neon-gold)]">
        <Sparkles className="h-4 w-4" /> {t.betaAccess.title}
      </div>
      <p className="mt-1 text-xs text-muted-foreground">{t.betaAccess.desc}</p>

      <label className="mt-3 block text-xs font-semibold text-muted-foreground">
        {t.betaAccess.nameLabel}
        <input
          className={INPUT}
          value={name}
          onChange={(e) => setName(e.target.value)}
          maxLength={120}
          required
        />
      </label>
      <label className="mt-3 block text-xs font-semibold text-muted-foreground">
        {t.betaAccess.emailLabel}
        <input
          type="email"
          className={INPUT}
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          maxLength={200}
          required
        />
      </label>
      <label className="mt-3 block text-xs font-semibold text-muted-foreground">
        {t.betaAccess.motivationLabel}
        <textarea
          className={INPUT}
          value={motivation}
          onChange={(e) => setMotivation(e.target.value)}
          maxLength={1000}
          rows={3}
          placeholder={t.betaAccess.motivationPlaceholder}
        />
      </label>

      <div className="mt-4 flex items-center gap-2">
        <button
          type="submit"
          disabled={!canSubmit || mutation.isPending}
          className="inline-flex items-center gap-1.5 rounded-lg bg-[image:var(--gradient-gold)] px-4 py-2 text-sm font-bold text-black shadow-gold transition hover:scale-105 disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:scale-100 [@media(pointer:coarse)]:min-h-11"
        >
          {mutation.isPending ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" /> {t.betaAccess.submitting}
            </>
          ) : (
            <>
              <Sparkles className="h-4 w-4" /> {t.betaAccess.submit}
            </>
          )}
        </button>
        <button
          type="button"
          onClick={() => setOpen(false)}
          className="rounded-lg border border-border/50 px-4 py-2 text-sm font-semibold text-muted-foreground hover:text-foreground [@media(pointer:coarse)]:min-h-11"
        >
          {t.betaAccess.cancel}
        </button>
      </div>
    </form>
  );
}

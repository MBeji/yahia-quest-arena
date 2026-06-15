import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ArrowLeft, CreditCard, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { useMyRole } from "@/features/auth";
import {
  listParcoursEntitlements,
  grantParcoursEntitlement,
  revokeParcoursEntitlement,
  ParcoursEntitlementsAdmin,
  type AdminParcoursOption,
} from "@/features/subscription";
import { getParcours } from "@/features/dashboard";
import {
  ADMIN_CONTACT_PHONE,
  type ParcoursEntitlementSource,
} from "@/shared/constants/subscription";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/admin/subscriptions")({
  head: () => ({ meta: [{ title: "Abonnements · Na9ra Nal3ab" }] }),
  component: AdminSubscriptionsPage,
});

function AdminSubscriptionsPage() {
  const t = useT();
  const qc = useQueryClient();
  const { role, isAdmin } = useMyRole();

  const fetchEntitlements = useServerFn(listParcoursEntitlements);
  const fetchParcours = useServerFn(getParcours);
  const grant = useServerFn(grantParcoursEntitlement);
  const revoke = useServerFn(revokeParcoursEntitlement);

  const listQuery = useQuery({
    queryKey: ["admin-parcours-entitlements"],
    enabled: isAdmin,
    queryFn: () => fetchEntitlements(),
  });

  const parcoursQuery = useQuery({
    queryKey: ["admin-parcours-options"],
    enabled: isAdmin,
    queryFn: () => fetchParcours(),
  });

  const grantMutation = useMutation({
    mutationFn: (input: {
      userId: string;
      parcoursId: string;
      source: ParcoursEntitlementSource;
      months?: number;
    }) => grant({ data: input }),
    onSuccess: () => {
      toast.success(t.subscription.granted);
      qc.invalidateQueries({ queryKey: ["admin-parcours-entitlements"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.subscription.updateError),
  });

  const revokeMutation = useMutation({
    mutationFn: (input: { userId: string; parcoursId: string }) => revoke({ data: input }),
    onSuccess: () => {
      toast.success(t.subscription.revoked);
      qc.invalidateQueries({ queryKey: ["admin-parcours-entitlements"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.subscription.updateError),
  });

  if (role !== null && !isAdmin) {
    return (
      <div className="mx-auto max-w-2xl px-6 py-12 text-center">
        <h1 className="font-display text-2xl font-bold">{t.subscription.accessDenied}</h1>
        <Link
          to="/dashboard"
          className="mt-4 inline-block text-sm text-[color:var(--gold)] hover:underline"
        >
          {t.common.backToHall}
        </Link>
      </div>
    );
  }

  const parcoursOptions: AdminParcoursOption[] = (parcoursQuery.data?.parcours ?? []).map((p) => ({
    id: p.id,
    name: p.name_fr,
    isPremium: p.is_premium,
  }));

  const pendingKey = revokeMutation.isPending
    ? `${revokeMutation.variables?.userId}:${revokeMutation.variables?.parcoursId}`
    : null;

  return (
    <div className="mx-auto max-w-5xl px-6 py-10">
      <Link
        to="/dashboard"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.common.backToHall}
      </Link>

      <div className="mb-6 flex items-center gap-3">
        <div className="grid h-11 w-11 place-items-center rounded-xl bg-[image:var(--gradient-gold)] shadow-gold">
          <CreditCard className="h-5 w-5 text-black" />
        </div>
        <div>
          <h1 className="font-display text-2xl font-bold">{t.subscription.adminTitle}</h1>
          <p className="text-sm text-muted-foreground">{t.subscription.adminDesc}</p>
        </div>
      </div>

      <p className="mb-6 rounded-xl border border-border/50 bg-card/30 px-4 py-3 text-sm text-muted-foreground">
        {t.subscription.contactTitle}: <span className="font-semibold">{ADMIN_CONTACT_PHONE}</span>
      </p>

      {listQuery.isLoading ? (
        <div className="grid place-items-center py-16">
          <Loader2 className="h-8 w-8 animate-spin text-[color:var(--gold)]" />
        </div>
      ) : listQuery.isError ? (
        <div className="rounded-2xl border border-destructive/40 bg-destructive/5 p-6 text-sm text-destructive">
          {t.subscription.updateError}
        </div>
      ) : (
        <ParcoursEntitlementsAdmin
          entitlements={listQuery.data?.entitlements ?? []}
          parcoursOptions={parcoursOptions}
          onGrant={(input) => grantMutation.mutate(input)}
          onRevoke={(userId, parcoursId) => revokeMutation.mutate({ userId, parcoursId })}
          pendingKey={pendingKey}
          isGranting={grantMutation.isPending}
        />
      )}
    </div>
  );
}

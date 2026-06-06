import { createFileRoute, Link } from "@tanstack/react-router";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ArrowLeft, CreditCard, Loader2 } from "lucide-react";
import { toast } from "sonner";
import { useAuth } from "@/features/auth";
import {
  listSubscriptions,
  setSubscription,
  clearSubscription,
  SubscriptionAdminTable,
} from "@/features/subscription";
import { supabase } from "@/shared/integrations/supabase/client";
import type { SubscriptionType } from "@/shared/constants/subscription";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/admin/subscriptions")({
  head: () => ({ meta: [{ title: "Abonnements · XP Scholars" }] }),
  component: AdminSubscriptionsPage,
});

function AdminSubscriptionsPage() {
  const t = useT();
  const qc = useQueryClient();
  const { user } = useAuth();

  const { data: role = null } = useQuery({
    queryKey: ["me-role", user?.id],
    enabled: !!user,
    staleTime: 5 * 60_000,
    queryFn: async () => {
      const { data } = await supabase.from("profiles").select("role").eq("id", user!.id).single();
      return data?.role ?? null;
    },
  });

  const fetchList = useServerFn(listSubscriptions);
  const activate = useServerFn(setSubscription);
  const block = useServerFn(clearSubscription);

  const listQuery = useQuery({
    queryKey: ["admin-subscriptions"],
    enabled: role === "admin",
    queryFn: () => fetchList(),
  });

  const mutation = useMutation({
    mutationFn: (action: { userId: string; type?: SubscriptionType }) =>
      action.type
        ? activate({ data: { userId: action.userId, type: action.type } })
        : block({ data: { userId: action.userId } }),
    onSuccess: () => {
      toast.success(t.subscription.updated);
      qc.invalidateQueries({ queryKey: ["admin-subscriptions"] });
    },
    onError: (e) => toast.error(e instanceof Error ? e.message : t.subscription.updateError),
  });

  if (role !== null && role !== "admin") {
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

      {listQuery.isLoading ? (
        <div className="grid place-items-center py-16">
          <Loader2 className="h-8 w-8 animate-spin text-[color:var(--gold)]" />
        </div>
      ) : listQuery.isError ? (
        <div className="rounded-2xl border border-destructive/40 bg-destructive/5 p-6 text-sm text-destructive">
          {t.subscription.updateError}
        </div>
      ) : (
        <SubscriptionAdminTable
          users={listQuery.data?.users ?? []}
          pendingUserId={mutation.isPending ? (mutation.variables?.userId ?? null) : null}
          onActivate={(userId, type) => mutation.mutate({ userId, type })}
          onBlock={(userId) => mutation.mutate({ userId })}
        />
      )}
    </div>
  );
}

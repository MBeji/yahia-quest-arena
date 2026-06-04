import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { ArrowLeft } from "lucide-react";
import { useAuth } from "@/features/auth";
import { BetaRequestsAdmin } from "@/features/subscription";
import { supabase } from "@/shared/integrations/supabase/client";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/admin/beta-requests")({
  head: () => ({ meta: [{ title: "Demandes bêta · XP Scholars" }] }),
  component: AdminBetaRequestsPage,
});

function AdminBetaRequestsPage() {
  const t = useT();
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
      {role === "admin" && <BetaRequestsAdmin />}
    </div>
  );
}

import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { ArrowLeft, TrendingUp, Loader2 } from "lucide-react";
import { useMyRole } from "@/features/auth";
import { getParcoursInterestCounts, ParcoursInterestAdmin } from "@/features/dashboard";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/admin/parcours-interest")({
  head: () => ({ meta: [{ title: "Intérêts · Na9ra Nal3ab" }] }),
  component: AdminParcoursInterestPage,
});

/**
 * Admin priority ranking: how many users registered interest in each coming-soon
 * class, busiest first → "build the most-requested program next". Same admin
 * guard wiring as the other /admin consoles (GAP-017).
 */
function AdminParcoursInterestPage() {
  const t = useT();
  const { role, isAdmin } = useMyRole();
  const fetchCounts = useServerFn(getParcoursInterestCounts);

  const countsQuery = useQuery({
    queryKey: ["admin-parcours-interest"],
    enabled: isAdmin,
    queryFn: () => fetchCounts(),
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

  return (
    <div className="mx-auto max-w-3xl px-6 py-10">
      <Link
        to="/dashboard"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.common.backToHall}
      </Link>

      <div className="mb-6 flex items-center gap-3">
        <div className="grid h-11 w-11 place-items-center rounded-xl bg-[image:var(--gradient-gold)] shadow-gold">
          <TrendingUp className="h-5 w-5 text-black" />
        </div>
        <div>
          <h1 className="font-display text-2xl font-bold">{t.parcoursInterest.adminTitle}</h1>
          <p className="text-sm text-muted-foreground">{t.parcoursInterest.adminDesc}</p>
        </div>
      </div>

      {countsQuery.isLoading ? (
        <div className="grid place-items-center py-16">
          <Loader2 className="h-8 w-8 animate-spin text-[color:var(--gold)]" />
        </div>
      ) : countsQuery.isError ? (
        <div className="rounded-2xl border border-destructive/40 bg-destructive/5 p-6 text-sm text-destructive">
          {t.parcoursInterest.loadError}
        </div>
      ) : (
        <ParcoursInterestAdmin counts={countsQuery.data?.counts ?? []} />
      )}
    </div>
  );
}

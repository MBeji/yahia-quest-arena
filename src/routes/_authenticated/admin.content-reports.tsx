import { createFileRoute, Link } from "@tanstack/react-router";
import { ArrowLeft } from "lucide-react";
import { useMyRole } from "@/features/auth";
import { ContentReportsAdmin } from "@/features/content-report";
import { useT } from "@/lib/i18n";

export const Route = createFileRoute("/_authenticated/admin/content-reports")({
  head: () => ({ meta: [{ title: "Signalements · Na9ra Nal3ab" }] }),
  component: AdminContentReportsPage,
});

function AdminContentReportsPage() {
  const t = useT();
  const { role, isAdmin } = useMyRole();

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
    <div className="mx-auto max-w-5xl px-6 py-10">
      <Link
        to="/dashboard"
        className="mb-6 inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4 rtl:-scale-x-100" /> {t.common.backToHall}
      </Link>
      {isAdmin && <ContentReportsAdmin />}
    </div>
  );
}

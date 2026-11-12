import { createFileRoute, Link } from "@tanstack/react-router";
import { useMyRole } from "@/features/auth";
import { BugReportsAdmin } from "@/features/bug-report";
import { useT } from "@/lib/i18n";
import { BackLink } from "@/components/ui/back-link";

export const Route = createFileRoute("/_authenticated/admin/bug-reports")({
  head: () => ({ meta: [{ title: "Bugs signalés · Na9ra Nal3ab" }] }),
  component: AdminBugReportsPage,
});

function AdminBugReportsPage() {
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
      <BackLink to="/dashboard">{t.common.backToHall}</BackLink>
      {isAdmin && <BugReportsAdmin />}
    </div>
  );
}

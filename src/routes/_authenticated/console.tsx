import { createFileRoute, Link } from "@tanstack/react-router";
import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import {
  Bug,
  ChevronRight,
  ClipboardList,
  Coins,
  CreditCard,
  Flag,
  FlaskConical,
  TrendingUp,
} from "lucide-react";

import { PageShell } from "@/components/ui/page-shell";
import { useMyRole } from "@/features/auth";
import { getOpenBugsCount } from "@/features/bug-report";
import { getOpenReportsCount } from "@/features/content-report";
import { getPendingBetaCount } from "@/features/subscription";
import { useT } from "@/lib/i18n";

/**
 * Console — le pôle d'administration.
 *
 * Les six consoles occupaient six entrées de la nav PRINCIPALE, pour un seul
 * utilisateur : le header de l'admin comptait seize objets interactifs, et sous
 * `lg` leurs libellés tombaient en icône seule (ce que l'audit s'interdit
 * ailleurs). Elles tiennent ici sous une entrée unique — même geste que l'Arène
 * pour les trois écrans compétitifs (étude 15, lot 5).
 *
 * Le pôle récupère aussi `/admin/economie`, console réelle que RIEN ne liait :
 * elle ne s'atteignait qu'en tapant son URL.
 *
 * Ce n'est PAS le contrôle d'accès : chaque console garde le sien, côté serveur.
 * Cette page ne fait que les rassembler.
 */
export const Route = createFileRoute("/_authenticated/console")({
  head: () => ({ meta: [{ title: "Console · Na9ra Nal3ab" }] }),
  component: ConsolePage,
});

function ConsolePage() {
  const t = useT();
  const { role } = useMyRole();
  const isAdmin = role === "admin";

  // Mêmes clés de requête que la coquille : React Query dédoublonne, la pastille
  // du header et le détail d'ici ne coûtent qu'un aller-retour chacun.
  const fetchBeta = useServerFn(getPendingBetaCount);
  const fetchReports = useServerFn(getOpenReportsCount);
  const fetchBugs = useServerFn(getOpenBugsCount);
  const { data: beta } = useQuery({
    queryKey: ["beta-pending-count"],
    enabled: isAdmin,
    staleTime: 60_000,
    queryFn: () => fetchBeta(),
  });
  const { data: reports } = useQuery({
    queryKey: ["open-reports-count"],
    enabled: isAdmin,
    staleTime: 60_000,
    queryFn: () => fetchReports(),
  });
  const { data: bugs } = useQuery({
    queryKey: ["open-bugs-count"],
    enabled: isAdmin,
    staleTime: 60_000,
    queryFn: () => fetchBugs(),
  });

  const consoles = [
    { to: "/parent-report" as const, Icon: ClipboardList, label: t.layout.parentReport, count: 0 },
    {
      to: "/admin/subscriptions" as const,
      Icon: CreditCard,
      label: t.layout.subscriptions,
      count: 0,
    },
    {
      to: "/admin/beta-requests" as const,
      Icon: FlaskConical,
      label: t.layout.betaRequests,
      count: beta?.count ?? 0,
    },
    {
      to: "/admin/content-reports" as const,
      Icon: Flag,
      label: t.layout.contentReports,
      count: reports?.count ?? 0,
    },
    {
      to: "/admin/bug-reports" as const,
      Icon: Bug,
      label: t.layout.bugReports,
      count: bugs?.count ?? 0,
    },
    {
      to: "/admin/parcours-interest" as const,
      Icon: TrendingUp,
      label: t.layout.parcoursInterest,
      count: 0,
    },
    { to: "/admin/economie" as const, Icon: Coins, label: t.layout.economy, count: 0 },
  ];

  return (
    <PageShell width="reading" className="py-8">
      <header className="mb-6">
        <h1 className="font-display text-3xl font-bold sm:text-4xl">{t.adminHub.title}</h1>
        <p className="mt-2 text-muted-foreground">{t.adminHub.subtitle}</p>
      </header>

      <div className="grid gap-3">
        {consoles.map(({ to, Icon, label, count }) => (
          <Link
            key={to}
            to={to}
            className="group flex min-h-11 items-center gap-4 rounded-2xl border border-[color:var(--gold)]/25 bg-surface-2 p-4 backdrop-blur-md transition hover:border-[color:var(--gold)]/50"
          >
            <div className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/15">
              <Icon className="h-5 w-5 text-[color:var(--gold)]" />
            </div>
            <span className="min-w-0 flex-1 font-display text-lg font-bold">{label}</span>
            {count > 0 && (
              <span className="shrink-0 rounded-full bg-[image:var(--gradient-gold)] px-2 py-0.5 text-xs font-bold text-primary-foreground">
                {count}
              </span>
            )}
            <ChevronRight className="h-5 w-5 shrink-0 text-muted-foreground transition group-hover:text-[color:var(--gold)] rtl:-scale-x-100" />
          </Link>
        ))}
      </div>
    </PageShell>
  );
}

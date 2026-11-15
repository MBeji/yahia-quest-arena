import { Link } from "@tanstack/react-router";
import { useT } from "@/lib/i18n";
import { studentNavItems } from "@/components/student-nav";

/**
 * La barre d'onglets du bas — la navigation principale d'un élève sur téléphone et tablette.
 *
 * Elle vit dans les DEUX coquilles depuis le 2026-11-15 (arbitrage du propriétaire). Les pages
 * de catalogue — programme, classe, matière, cours — sont servies par la coquille publique, y
 * compris à un élève connecté : en ouvrant une matière depuis son Hall, il perdait ses onglets
 * et n'avait plus, pour revenir, que le logo. La barre le suit désormais partout où il n'est
 * pas en train de jouer ; c'est la coquille qui décide de la monter (rôle, écran immersif).
 *
 * `lg:hidden` : au-delà, c'est la barre du haut qui porte la navigation. `print:hidden` : elle
 * est `fixed`, donc à l'impression elle se tamponnerait sur chaque page d'un cours.
 */
export function StudentTabBar() {
  const t = useT();
  const items = studentNavItems(t);
  return (
    <nav
      data-testid="student-tab-bar"
      aria-label={t.public.header.account}
      className="fixed inset-x-0 bottom-0 z-30 flex items-stretch justify-around border-t border-[color:var(--gold)]/15 bg-surface-3 pb-[env(safe-area-inset-bottom)] backdrop-blur-xl lg:hidden print:hidden"
    >
      {items.map(({ to, Icon, label }) => (
        <Link
          key={to}
          to={to}
          title={label}
          className="flex min-h-[52px] flex-1 flex-col items-center justify-center gap-0.5 px-1 py-1.5 text-[10px] font-semibold leading-tight text-muted-foreground transition"
          activeProps={{ className: "text-[color:var(--gold)]" }}
        >
          <Icon className="h-5 w-5 shrink-0" aria-hidden="true" />
          <span className="max-w-full truncate">{label}</span>
        </Link>
      ))}
    </nav>
  );
}

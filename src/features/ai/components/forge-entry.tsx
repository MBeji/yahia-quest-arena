import { useQuery } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { Link } from "@tanstack/react-router";
import { Hammer } from "lucide-react";

import { useT } from "@/lib/i18n";
import { getAiStudentSurfaces } from "../ai-access.server";

/**
 * L'ENTRÉE de la Forge — R-1, appliquée à un point d'entrée.
 *
 * « Aucune surface IA n'est visible sans mode actif : pas de bouton grisé, pas
 * d'appel à l'action, pas de "bientôt". » Ce composant rend donc `null` dans
 * TOUS les cas où la Forge n'est pas allumée pour CET élève — y compris pendant
 * le chargement, parce qu'un squelette est déjà une promesse.
 *
 * `authenticated` est passé par la ROUTE et non lu ici : ce composant est monté
 * sur une page publique (le lecteur de chapitre), et une feature n'importe pas
 * `@/features/auth`. La route sait déjà qui regarde ; elle le dit.
 */
export function ForgeEntry({
  chapterId,
  authenticated,
}: {
  chapterId: string | null;
  authenticated: boolean;
}) {
  const t = useT();
  const fetchSurfaces = useServerFn(getAiStudentSurfaces);

  const { data } = useQuery({
    queryKey: ["ai-surfaces"],
    queryFn: () => fetchSurfaces(),
    // Un visiteur anonyme n'interroge RIEN : la server fn exige une session, et
    // l'appeler produirait une erreur 401 par page vue.
    enabled: authenticated,
    staleTime: 60_000,
  });

  if (!data?.enabled || !data.features.includes("forge")) return null;

  return (
    <Link
      to="/forge"
      search={chapterId ? { chapitre: chapterId } : undefined}
      data-testid="forge-entry"
      className="mt-4 flex min-h-11 items-center gap-3 rounded-2xl border border-[color:var(--gold)]/25 bg-surface-2 p-3 backdrop-blur-md transition hover:border-[color:var(--gold)]/50"
    >
      <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[color:var(--gold)]/15">
        <Hammer className="h-5 w-5 text-[color:var(--gold)]" />
      </span>
      <span className="min-w-0">
        <span className="block font-display font-bold">{t.ai.forgeTitle}</span>
        <span className="block text-xs text-muted-foreground">{t.ai.forgeDesc}</span>
      </span>
    </Link>
  );
}

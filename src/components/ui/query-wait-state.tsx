import { onlineManager } from "@tanstack/react-query";
import { WifiOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { useT } from "@/lib/i18n";
import { cn } from "@/shared/lib/utils";

/**
 * Cette requête attend-elle le RÉSEAU, sans rien à montrer en attendant ?
 *
 * Hors connexion, TanStack Query ne lance pas une requête neuve : il la met en
 * pause (`fetchStatus: "paused"`). `isLoading` retombe alors à `false` avec `data`
 * toujours absente — et un écran qui teste `isLoading || !data` rend son squelette
 * sans fin, sans dire pourquoi (étude 38, R-9). Une requête en pause qui a DÉJÀ ses
 * données n'attend rien : l'écran les affiche.
 */
export function isWaitingForNetwork(query: { fetchStatus: string; data: unknown }): boolean {
  return query.fetchStatus === "paused" && query.data === undefined;
}

/**
 * L'écran d'une route dont la lecture attend le réseau — à la place du squelette.
 * Rien à faire au retour du réseau : la requête repart seule, et cet état s'efface.
 *
 * « Réessayer » ne relance pas une requête en pause (elle le resterait) : il
 * rattrape un événement `online` que le navigateur n'aurait pas émis — au geste de
 * l'élève seulement, jamais par un second écouteur (D-4) —, puis relance.
 */
export function WaitingForNetwork({
  onRetry,
  className,
}: {
  onRetry: () => void;
  className?: string;
}) {
  const t = useT();
  const retry = () => {
    if (typeof navigator !== "undefined" && navigator.onLine) onlineManager.setOnline(true);
    onRetry();
  };
  return (
    <div data-testid="waiting-for-network" className={cn("mx-auto max-w-md px-6 py-20", className)}>
      <EmptyState
        icon={WifiOff}
        title={t.offline.waiting}
        description={t.offline.waitingDesc}
        action={
          <Button variant="outline" onClick={retry}>
            {t.common.retry}
          </Button>
        }
      />
    </div>
  );
}

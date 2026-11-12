import { CloudOff } from "lucide-react";

import { useT } from "@/lib/i18n";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { cn } from "@/shared/lib/utils";

/**
 * L'écran d'un chargement qui a ÉCHOUÉ — annoncé (`role="alert"`), avec toujours une
 * issue : réessayer, et celle que la page ajoute (un retour, le plus souvent).
 *
 * Il remplace les trois façons de ne rien dire que l'audit d'affichage a trouvées
 * (#1228) : un squelette sans fin (`/parcours`), un indicateur de chargement sans fin
 * (`/boutique`) et une ligne d'anglais sans action (« Profile not found. »). Un écran
 * qui attend indéfiniment une réponse déjà arrivée — en erreur — ment à l'élève.
 */
export function LoadError({
  title,
  description,
  onRetry,
  children,
  className,
}: {
  /** Par défaut le titre générique des erreurs ; la page peut dire mieux. */
  title?: string;
  description?: string;
  onRetry: () => void;
  /** Une seconde issue, à côté de « Réessayer ». */
  children?: React.ReactNode;
  className?: string;
}) {
  const t = useT();
  return (
    <div className={cn("mx-auto max-w-md px-6 py-20", className)}>
      <EmptyState
        icon={CloudOff}
        tone="error"
        title={title ?? t.errors.errorTitle}
        description={description}
        action={
          <div className="flex flex-wrap items-center justify-center gap-2">
            <Button variant="outline" className="min-h-11" onClick={onRetry}>
              {t.common.retry}
            </Button>
            {children}
          </div>
        }
      />
    </div>
  );
}

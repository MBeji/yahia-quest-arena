import { AlertTriangle } from "lucide-react";
import { EmptyState } from "@/components/ui/empty-state";

// =============================================================================
// L'échec de DÉMARRAGE d'une mission, montré à l'écran.
//
// Sans session, il n'y a pas de partie : `validate()` refuse d'agir. Rendre le
// lecteur quand même donnait un bouton « Valider » ACTIF et sans effet — l'élève
// sélectionnait sa réponse, validait, et l'écran ne bougeait pas, sans que rien
// ne le lui dise (le toast d'erreur est déjà passé, quand il ne s'affiche pas
// hors champ sur mobile). On nomme donc la panne, et on offre la seule action
// qui la répare : réessayer.
// =============================================================================
export function QuestSessionError({
  title,
  message,
  retryLabel,
  onRetry,
}: {
  title: string;
  message: string;
  retryLabel: string;
  onRetry: () => void;
}) {
  return (
    <div className="mx-auto max-w-md px-6 py-12">
      <EmptyState
        icon={AlertTriangle}
        title={title}
        description={message}
        action={
          <button
            type="button"
            data-testid="quest-session-retry"
            onClick={onRetry}
            className="inline-flex items-center gap-2 rounded-lg bg-[image:var(--gradient-gold)] px-6 py-2.5 text-sm font-bold text-primary-foreground shadow-gold transition"
          >
            {retryLabel}
          </button>
        }
      />
    </div>
  );
}

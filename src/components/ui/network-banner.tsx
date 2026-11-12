import { useEffect, useState } from "react";
import { WifiOff } from "lucide-react";
import { useOnlineStatus } from "@/hooks/use-online-status";
import { useT } from "@/lib/i18n";
import { cn } from "@/shared/lib/utils";

/**
 * Combien de missions attendent d'être envoyées — lu dans la file d'envoi
 * (`outbox.ts`) seulement quand le bandeau s'affiche.
 *
 * La file est en import DYNAMIQUE, comme à la racine et pour la même raison : un
 * import en tête la ferait entrer dans le chunk d'entrée (`__root.tsx` raconte le
 * précédent). Elle est déjà chargée — la racine la démarre au montage — donc cet
 * `import()` ne demande rien au réseau, qui justement manque.
 */
function usePendingMissions(active: boolean): number {
  const [count, setCount] = useState(0);
  useEffect(() => {
    if (!active) {
      setCount(0);
      return;
    }
    let unsubscribe: (() => void) | undefined;
    let cancelled = false;
    void import("@/shared/lib/outbox")
      .then((outbox) => {
        if (cancelled) return;
        const read = () => setCount(outbox.pendingCount());
        read();
        unsubscribe = outbox.subscribe(read);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
      unsubscribe?.();
    };
  }, [active]);
  return count;
}

/**
 * Le bandeau « hors connexion » des deux coquilles (étude 38, R-9 et R-12).
 *
 * La région `role="status"` est TOUJOURS dans le document, vide quand le réseau est
 * là : un lecteur d'écran n'annonce un changement que dans une région qu'il
 * connaissait déjà. `polite` : l'annonce attend la fin de la phrase en cours, et le
 * focus ne bouge pas — l'élève qui tape une réponse n'est pas interrompu.
 *
 * Écrit sans pronom : la coquille publique vouvoie, la coquille connectée tutoie,
 * et ce bandeau est le même dans les deux.
 */
export function NetworkBanner({ className }: { className?: string }) {
  const t = useT();
  const online = useOnlineStatus();
  const pending = usePendingMissions(!online);
  return (
    // `className` (le collage sous l'en-tête) va sur la RÉGION, pas sur le bandeau : un
    // élément collant ne voyage que dans son parent, et celui-ci n'est pas plus haut que lui.
    <div
      role="status"
      aria-live="polite"
      data-testid="network-banner"
      className={cn("print:hidden", className)}
    >
      {!online && (
        <div className="flex items-center justify-center gap-2 border-b border-border bg-muted px-4 py-2 text-center text-sm font-medium text-foreground">
          <WifiOff className="h-4 w-4 shrink-0" aria-hidden />
          <span>
            {t.offline.banner}
            {pending > 0 && (
              <span data-testid="network-banner-pending">
                {" · "}
                {pending === 1
                  ? t.offline.pendingOne
                  : t.offline.pendingMany.replace("{n}", String(pending))}
              </span>
            )}
          </span>
        </div>
      )}
    </div>
  );
}

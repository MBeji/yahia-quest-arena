import { useEffect, useRef, useState } from "react";
import { Timer } from "lucide-react";

import { cn } from "@/shared/lib/utils";

/**
 * Le chrono de l'épreuve — un compte à rebours qui ne décide de RIEN.
 *
 * R-2 : la deadline est serveur. Ce composant n'est qu'un afficheur, et il se
 * cale sur l'horloge du serveur via `clockOffsetMs` (mesuré une fois à
 * l'ouverture : `serverNow - Date.now()`). Sans cet écart, un poste dont
 * l'horloge avance de trois minutes verrait son épreuve se terminer trois
 * minutes trop tôt — un bug qui ne se reproduit que chez la victime.
 *
 * Il porte son propre state à 1 Hz, comme `boss-chrono`, pour ne re-rendre que
 * la pastille et pas l'arbre complet de l'épreuve.
 */
export function ExamCountdown({
  deadline,
  clockOffsetMs,
  onExpire,
  className,
}: {
  deadline: string;
  clockOffsetMs: number;
  onExpire?: () => void;
  className?: string;
}) {
  const deadlineMs = Date.parse(deadline);
  const remainingNow = () =>
    Math.max(0, Math.round((deadlineMs - (Date.now() + clockOffsetMs)) / 1000));

  const [remaining, setRemaining] = useState(remainingNow);

  // L'appelant re-crée souvent `onExpire` ; le lire par ref évite de relancer
  // l'intervalle à chaque rendu (motif de `boss-chrono`).
  const onExpireRef = useRef(onExpire);
  onExpireRef.current = onExpire;
  const firedRef = useRef(false);

  useEffect(() => {
    const tick = () => {
      const left = Math.max(0, Math.round((deadlineMs - (Date.now() + clockOffsetMs)) / 1000));
      setRemaining(left);
      if (left <= 0 && !firedRef.current) {
        firedRef.current = true;
        onExpireRef.current?.();
      }
    };
    tick();
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);
  }, [deadlineMs, clockOffsetMs]);

  const hours = Math.floor(remaining / 3600);
  const minutes = Math.floor((remaining % 3600) / 60);
  const seconds = remaining % 60;
  const pad = (n: number) => String(n).padStart(2, "0");

  // Cinq minutes : le moment où l'on arrête de découvrir et où l'on relit.
  const urgent = remaining <= 300;

  return (
    <span
      role="timer"
      aria-live="off"
      className={cn(
        "inline-flex items-center gap-2 rounded-full border px-3 py-1 font-mono text-sm tabular-nums",
        urgent
          ? "border-destructive/40 bg-destructive/10 text-destructive"
          : "border-border bg-surface-2 text-foreground",
        className,
      )}
    >
      <Timer className="size-4" aria-hidden="true" />
      {hours > 0 ? `${pad(hours)}:` : ""}
      {pad(minutes)}:{pad(seconds)}
    </span>
  );
}

import type { LucideIcon } from "lucide-react";
import type { ReactNode } from "react";
import { cn } from "@/shared/lib/utils";

/**
 * Intertitre de zone. Un écran dense se lit comme une liste tant que rien n'y
 * découpe le flux : après le héros, l'œil n'a plus d'ancrage et douze blocs de
 * même volume se valent. Cet intertitre pose ces ancrages — un titre, une icône,
 * et une action facultative alignée à la fin.
 *
 * Le filet part du titre et se perd : il sépare sans encadrer, ce qui laisse
 * les cartes de la zone porter seules leur propre élévation.
 */
export function SectionHeading({
  icon: Icon,
  title,
  action,
  className,
}: {
  icon?: LucideIcon;
  title: string;
  action?: ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("mb-4 flex items-center gap-3", className)}>
      <h2 className="flex shrink-0 items-center gap-2 font-display text-xl font-bold">
        {Icon && <Icon className="h-5 w-5 text-[color:var(--gold)]" aria-hidden="true" />}
        {title}
      </h2>
      <span
        aria-hidden="true"
        className="h-px min-w-4 flex-1 bg-gradient-to-r from-[color:var(--gold)]/30 to-transparent"
      />
      {action}
    </div>
  );
}

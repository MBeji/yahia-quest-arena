import { useEffect } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useServerFn } from "@tanstack/react-start";
import { CalendarDays } from "lucide-react";

import { GoldProgress } from "@/components/game/gold-progress";
import { useI18n } from "@/lib/i18n";
import { claimEventBadge, type ActiveEvent } from "@/features/dashboard";

/**
 * LA BANNIÈRE D'ÉVÉNEMENT (étude 31 lot 8 — US-12, R-21).
 *
 * Rien ne rythmait l'année scolaire : la seule chose datée du produit était une
 * suggestion de changement de classe. Cette bannière est le seul endroit où le
 * calendrier se voit.
 *
 * Trois règles la tiennent :
 *
 *   * **elle ne borne aucun CONTENU** (R-2) : elle annonce un défi et un badge,
 *     et n'enlève l'accès à rien. C'est ce qui sépare un événement d'un mur ;
 *   * **une seule à la fois** (R-21) — garanti côté base par une contrainte
 *     d'exclusion, pas par la discipline de qui écrit un seed ;
 *   * **aucun compte à rebours anxiogène** : une date de fin, pas un chronomètre
 *     qui tourne. Le ton reste celui d'El Ostedh (R-8).
 */
export function EventBanner({ event }: { event: ActiveEvent | null }) {
  const { locale } = useI18n();
  const queryClient = useQueryClient();
  const claim = useServerFn(claimEventBadge);

  const done = event ? event.progress >= event.goalTarget : false;

  const mutation = useMutation({
    mutationFn: () => claim(),
    onSuccess: (res) => {
      if (res.granted) queryClient.invalidateQueries({ queryKey: ["dashboard", "secondary"] });
    },
  });

  // Le badge se réclame TOUT SEUL une fois l'objectif atteint : demander un clic
  // pour une récompense déjà méritée, c'est une corvée déguisée en fête.
  useEffect(() => {
    if (done && event?.badgeCode && !mutation.isPending && !mutation.isSuccess) {
      mutation.mutate();
    }
    // `mutation` change d'identité à chaque rendu : seules ces trois entrées
    // décident réellement du déclenchement.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [done, event?.badgeCode]);

  if (!event) return null;

  const name = event.name[locale] ?? event.name.fr ?? event.code;
  const description = event.description[locale] ?? event.description.fr ?? "";
  const pct = event.goalTarget > 0 ? Math.min(100, (event.progress / event.goalTarget) * 100) : 0;

  return (
    <section
      data-testid="event-banner"
      data-event={event.code}
      className="rounded-2xl border border-[color:var(--neon-gold)]/30 bg-[color:var(--neon-gold)]/5 p-5 backdrop-blur-md"
    >
      <h2 className="flex items-center gap-2 font-display text-lg font-bold">
        <CalendarDays className="h-5 w-5 text-[color:var(--neon-gold)]" aria-hidden="true" />
        {name}
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">{description}</p>

      <GoldProgress value={pct} size="sm" className="mt-3" aria-label={name} />
      <div className="mt-1 text-xs text-muted-foreground tabular-nums" data-testid="event-progress">
        {event.progress}/{event.goalTarget} {done ? "✓" : ""}
      </div>
    </section>
  );
}

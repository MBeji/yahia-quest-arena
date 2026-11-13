import { useLayoutEffect, useRef, useState, type ReactNode } from "react";
import { appLocalDate } from "@/shared/lib/app-day";
import {
  chooseNudge,
  markDismissed,
  markSettled,
  markShown,
  type NudgeKind,
} from "@/shared/lib/nudge-memory";

/**
 * L'EMPLACEMENT D'INVITATION D'UN ÉCRAN — étude 40, R-12 : UNE SEULE invitation par écran.
 *
 * L'écran (une ROUTE : elle seule a le droit de composer plusieurs features) déclare les
 * invitations qu'il sait proposer ; cet emplacement en retient au plus une, dans l'ordre
 * rappel → installation → parent, selon la mémoire commune (`nudge-memory.ts`). Ajouter une
 * invitation à un écran, c'est ajouter un candidat à sa liste — le choix ne se réécrit pas.
 *
 * AUCUN DÉCALAGE DE MISE EN PAGE. Le choix se fait dans un effet de MISE EN PAGE, avant la
 * première peinture : la carte paraît avec l'écran, ou pas du tout. Un candidat qui devient
 * proposable APRÈS (l'événement d'installation arrivé tard) est ignoré — une carte qui pousse ce
 * qu'on est en train de lire coûte plus qu'une invitation manquée. `late` lève cette retenue pour
 * un emplacement en BAS de page, où rien n'est poussé.
 */

/** Ce qu'une carte dit de son issue à la mémoire commune. */
export type NudgeControls = {
  /** Refus (« Plus tard ») : pas avant le délai du genre ; deux refus ⇒ plus jamais. */
  readonly dismiss: () => void;
  /** L'invitation a abouti : elle ne revient plus. */
  readonly settle: () => void;
};

export type NudgeCandidate = {
  readonly kind: NudgeKind;
  /** L'écran peut-il la proposer MAINTENANT (bon moment, appareil capable) ? La mémoire, elle, est lue ici. */
  readonly available: boolean;
  /**
   * La réponse à `available` est-elle encore en route (l'état du push se lit du service worker,
   * en asynchrone) ? Tant qu'un candidat est en attente, l'emplacement ne choisit PAS : sans cette
   * retenue, une invitation plus haute dans l'ordre perdrait sa place à chaque fois, au profit
   * de la suivante. Le candidat doit borner son attente lui-même (étude 40, lot 2).
   */
  readonly pending?: boolean;
  readonly render: (controls: NudgeControls) => ReactNode;
};

const today = (): string => appLocalDate(new Date());

export function NudgeSlot({
  candidates,
  late = false,
}: {
  candidates: readonly NudgeCandidate[];
  late?: boolean;
}) {
  const [chosen, setChosen] = useState<NudgeKind | null>(null);
  const [closed, setClosed] = useState(false);
  const decided = useRef(false);
  const available = candidates
    .filter((candidate) => candidate.available)
    .map((candidate) => candidate.kind)
    .join(",");
  const waiting = candidates.some((candidate) => candidate.pending === true);

  useLayoutEffect(() => {
    if (chosen !== null || (decided.current && !late)) return;
    // Un candidat dont la réponse est en route : on attend, sans rien retenir.
    if (waiting) return;
    decided.current = true;
    const day = today();
    const kind = chooseNudge(available ? (available.split(",") as NudgeKind[]) : [], day);
    // Montrée seulement si la mémoire a pu le retenir (stockage plein ou refusé ⇒ rien).
    if (kind !== null && markShown(kind, day)) setChosen(kind);
  }, [available, late, chosen, waiting]);

  const candidate = candidates.find((c) => c.kind === chosen && c.available);
  if (!candidate || closed) return null;
  const { kind } = candidate;
  return candidate.render({
    dismiss: () => {
      markDismissed(kind, today());
      setClosed(true);
    },
    settle: () => {
      markSettled(kind, today());
      setClosed(true);
    },
  });
}

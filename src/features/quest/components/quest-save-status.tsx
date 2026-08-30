import { CloudOff, Check } from "lucide-react";
import type { AutosaveStatus } from "@/features/quest/components/use-quest-autosave";

// =============================================================================
// « Est-ce que mon travail est enregistré ? » — la réponse, à l'écran.
//
// POURQUOI CETTE PASTILLE EXISTE. Quand la soumission échoue, le travail n'est
// plus perdu (il est en file, `outbox.ts` le rejouera) — mais l'élève, lui, n'en
// sait rien. Un bêta-testeur qui voit un toast d'erreur et rien d'autre en
// conclut que sa partie est perdue, et la refait. Il faut donc DIRE la
// différence entre « perdu » et « pas encore parti ».
//
// Discrète par construction : rien à afficher tant qu'il n'y a rien à signaler.
// L'état `idle` ne rend rien du tout — un indicateur permanent finirait par ne
// plus être lu, et ferait douter là où tout va bien.
// =============================================================================
export function QuestSaveStatus({
  status,
  pendingLabel,
  doneLabel,
}: {
  status: AutosaveStatus;
  pendingLabel: string;
  doneLabel: string;
}) {
  if (status === "idle") return null;

  const pending = status === "pending";
  const Icon = pending ? CloudOff : Check;

  return (
    <div
      // `polite` et pas `alert` : c'est une information d'arrière-plan, elle ne
      // doit pas couper la lecture d'un lecteur d'écran en pleine question.
      role="status"
      aria-live="polite"
      data-testid="quest-save-status"
      data-status={status}
      className={[
        "inline-flex items-center gap-1.5 rounded-full px-3 py-1 text-xs font-medium",
        pending
          ? "bg-[color:var(--neon-gold)]/10 text-[color:var(--neon-gold)]"
          : "bg-muted text-muted-foreground",
      ].join(" ")}
    >
      <Icon className="h-3.5 w-3.5" aria-hidden="true" />
      {pending ? pendingLabel : doneLabel}
    </div>
  );
}

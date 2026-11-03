import { Loader2 } from "lucide-react";
import { useT } from "@/lib/i18n";
import type { QuestLabels } from "@/shared/lib/quest-labels";

/**
 * Le bouton « Valider » / « Continuer » du lecteur, sorti de `exercise-player.tsx`
 * (2026-11-03). Il ne décide de rien : le lecteur lui dit s'il est actif, s'il
 * attend, quelle phase il porte (valider, continuer après la correction) et si la
 * question est la dernière — ici, seulement le libellé et l'habillage.
 */
export function QuestSubmitButton({
  feedbackShown,
  disabled,
  busy,
  bossMode,
  isLast,
  labels,
  onClick,
}: {
  /** Une correction est à l'écran : le bouton passe de « valider » à « continuer ». */
  feedbackShown: boolean;
  disabled: boolean;
  /** Un envoi, un démarrage ou une correction est en cours : on montre le sablier. */
  busy: boolean;
  bossMode: boolean;
  isLast: boolean;
  labels: QuestLabels;
  onClick: () => void;
}) {
  const t = useT();
  const label = feedbackShown
    ? isLast
      ? labels.feedbackFinish
      : labels.feedbackContinue
    : bossMode
      ? isLast
        ? t.quest.bossFinalBlow
        : t.quest.bossAttack
      : isLast
        ? t.quest.finishQuest
        : t.quest.nextQuestion;

  return (
    <button
      data-testid="quest-submit"
      disabled={disabled}
      onClick={onClick}
      className={`inline-flex items-center gap-2 rounded-lg px-6 py-2.5 text-sm font-bold shadow-gold transition disabled:opacity-40 ${
        bossMode
          ? "bg-linear-to-r from-destructive to-gold text-primary-foreground"
          : "bg-[image:var(--gradient-gold)] text-primary-foreground"
      }`}
    >
      {busy && <Loader2 className="h-4 w-4 animate-spin" />}
      {label}
    </button>
  );
}

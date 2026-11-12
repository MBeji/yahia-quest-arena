import { GraduationCap } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useT } from "@/lib/i18n";

/**
 * LA CARTE DE CLASSE DE LA QUÊTE (étude 38, lot 2 — R-5, US-2).
 *
 * Un élève qui n'a pas encore choisi sa classe et qui tape une quête la JOUE :
 * l'assistant d'accueil ne s'interpose plus. Cette carte, posée au-dessus du
 * lecteur, lui propose la classe du chapitre en un geste — ou « plus tard ».
 *
 * Trois choses qu'elle ne fait pas, à dessein :
 *  - elle n'OUVRE rien : la quête se joue déjà, avec ou sans classe ;
 *  - elle ne DÉCIDE rien : choisir, c'est le réglage de profil que fait déjà
 *    l'assistant, par la même fonction serveur — c'est la route qui la lui passe ;
 *  - elle ne sait pas QUI regarde : la route ne la monte que pour un élève sans
 *    parcours. Présentation pure, comme `seal-mark` et `gold-progress`.
 *
 * Registre : elle tutoie (élève connecté, R-12).
 */
export function ParcoursQuickPick({
  parcoursName,
  onChoose,
  onLater,
  isChoosing = false,
}: {
  /** Le nom de la classe, déjà dans la langue de l'élève. */
  parcoursName: string;
  onChoose: () => void;
  onLater: () => void;
  /** L'adoption est en vol : les deux boutons attendent. */
  isChoosing?: boolean;
}) {
  const t = useT();
  return (
    <section
      data-testid="parcours-quick-pick"
      aria-label={t.onboarding.quickPickTitle.replace("{parcours}", parcoursName)}
      className="flex w-full flex-col gap-3 rounded-2xl border border-border bg-surface-2 p-4 sm:flex-row sm:items-center sm:justify-between"
    >
      <p className="flex items-start gap-2 text-sm font-medium text-foreground">
        <GraduationCap className="mt-0.5 h-4 w-4 shrink-0 text-primary" aria-hidden="true" />
        <span>{t.onboarding.quickPickTitle.replace("{parcours}", parcoursName)}</span>
      </p>
      <div className="flex shrink-0 items-center gap-2">
        <Button type="button" size="sm" onClick={onChoose} disabled={isChoosing}>
          {isChoosing ? t.onboarding.saving : t.onboarding.quickPickCta}
        </Button>
        <Button type="button" size="sm" variant="ghost" onClick={onLater} disabled={isChoosing}>
          {t.onboarding.quickPickLater}
        </Button>
      </div>
    </section>
  );
}

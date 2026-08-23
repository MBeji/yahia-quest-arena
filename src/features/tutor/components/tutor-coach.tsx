// LA VOIX D'EL OSTEDH SUR LE PLAN DU JOUR — étude 11 lot 2 (US-5, US-15).
//
// CE QUE CES DEUX COMPOSANTS COÛTENT : RIEN
// ---------------------------------------------------------------------------
// Aucun appel de modèle, aucune énergie, aucun aller-retour serveur. Ils rendent
// une clé i18n choisie par une fonction pure (`coaching.ts`) à partir de faits
// que le tableau de bord a DÉJÀ chargés. C'est l'étage 0 de §3.7, et c'est lui
// qui rend ~70 % de la personnalisation perçue gratuite (R-10, D-3).
//
// POURQUOI ILS VIVENT DANS `features/tutor` ET PAS DANS `progression`
// ---------------------------------------------------------------------------
// La sélection du plan appartient à é04 (`get_daily_plan`) et son panneau à la
// feature `progression`. La VOIX, elle, appartient au tuteur : c'est le même
// personnage qui explique une erreur sur l'écran de correction et qui commente
// le plan le matin. Une feature n'en importe pas une autre (AGENTS.md) — c'est
// donc la ROUTE qui compose, par un slot, exactement comme `renderTutor` sur
// l'écran de correction.

import { GraduationCap } from "lucide-react";

import { useT } from "@/lib/i18n";
import type { DailyPlanItem } from "@/shared/types/daily-plan";
import { dayIndexOf, momentKey, planCoachKey, type TutorMomentState } from "../coaching";

/** Les clés de coaching, à plat : le sélecteur rend un nom, on le résout ici. */
type CoachDict = ReturnType<typeof useT>["tutor"]["coach"];

function line(coach: CoachDict, key: string): string {
  return (coach as unknown as Record<string, string>)[key] ?? "";
}

/**
 * La phrase de coach d'UN item du plan. Rendue sous le titre de la mission, dans
 * la langue de l'INTERFACE — c'est de la microcopy, pas du contenu pédagogique
 * (R-4 : les deux ne se confondent pas).
 */
export function TutorCoachLine({ item, index }: { item: DailyPlanItem; index: number }) {
  const t = useT();
  const text = line(t.tutor.coach, planCoachKey(item, index));
  if (!text) return null;

  return (
    <p className="text-muted-foreground mt-1 flex items-center gap-1.5 text-xs italic">
      <GraduationCap className="size-3 shrink-0" aria-hidden="true" />
      {text}
    </p>
  );
}

/**
 * L'accueil du matin — un moment, pas un bulletin (US-15).
 *
 * Aucun des quatre registres n'est culpabilisant, et ce n'est pas un détail de
 * rédaction : l'étude 15 et R-15 l'exigent ensemble. « Ça faisait longtemps ! »
 * accueille ; « tu as disparu huit jours » accuse. Le second n'entrera jamais
 * dans la bibliothèque.
 *
 * `now` est injectable pour que le test n'ait pas à geler l'horloge globale : la
 * variante tourne sur le NUMÉRO DE JOUR, donc deux visites le même matin disent
 * la même phrase.
 */
export function TutorGreeting({
  state,
  now = new Date(),
}: {
  state: TutorMomentState;
  now?: Date;
}) {
  const t = useT();
  const text = line(t.tutor.coach, momentKey(state, dayIndexOf(now)));
  if (!text) return null;

  return (
    <p className="text-muted-foreground mt-3 flex items-center gap-2 text-sm">
      <GraduationCap className="size-4 shrink-0 text-[color:var(--gold)]" aria-hidden="true" />
      <span>
        <span className="text-foreground font-semibold">{t.tutor.coach.signature}</span>
        {" — "}
        {text}
      </span>
    </p>
  );
}

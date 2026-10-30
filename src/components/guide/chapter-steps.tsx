import { BookOpen, Brain, Check, Lock, Swords } from "lucide-react";

import { useGuideT } from "@/lib/i18n/guide";
import type { ChapterStepStates, StepState } from "@/shared/lib/guide";
import { cn } from "@/shared/lib/utils";

const STEPS = [
  { key: "lesson", Icon: BookOpen },
  { key: "quiz", Icon: Brain },
  { key: "missions", Icon: Swords },
] as const;

const STATE_CLASS: Record<StepState, string> = {
  // Le vert succès teinte la bordure, le fond et l'icône ; le TEXTE reste en
  // `foreground` : `text-success` sur `success/10` plafonne à 3,9:1 en thème
  // clair (seuil AA 4,5:1 — #1191).
  done: "border-success/40 bg-success/10 text-foreground",
  current: "border-primary bg-primary/10 text-primary ring-1 ring-primary/40",
  next: "border-border bg-card text-foreground",
  locked: "border-dashed border-border bg-card text-muted-foreground",
};

/**
 * Les 3 étapes d'un chapitre en un coup d'œil — « 1. Cours › 2. Quiz ›
 * 3. Missions » — avec l'étape à faire maintenant en surbrillance. L'ordre ne
 * se devine plus : il se voit avant même de toucher un cadenas.
 */
export function ChapterSteps({
  states,
  className,
}: {
  states: ChapterStepStates;
  className?: string;
}) {
  const t = useGuideT();
  return (
    <ol
      aria-label={t.guide.stepper.label}
      data-testid="chapter-steps"
      className={cn("grid grid-cols-3 gap-1.5", className)}
    >
      {STEPS.map(({ key, Icon }, index) => {
        const state = states[key];
        const StateIcon = state === "done" ? Check : state === "locked" ? Lock : Icon;
        return (
          <li
            key={key}
            data-state={state}
            aria-current={state === "current" ? "step" : undefined}
            className={cn(
              "flex min-w-0 flex-col items-center gap-0.5 rounded-lg border px-1.5 py-2 text-center",
              STATE_CLASS[state],
            )}
          >
            <StateIcon
              className={cn("h-4 w-4 shrink-0", state === "done" && "text-success")}
              aria-hidden="true"
            />
            <span className="max-w-full truncate text-xs font-bold">
              {index + 1}. {t.guide.stepper[key]}
            </span>
            {/* Jamais d'`opacity-*` ici : à 90 %, `text-primary` sur `primary/10`
                tombe à 4,41:1 en thème clair et axe fait rougir le nightly (#1191). */}
            <span className="max-w-full text-2xs leading-tight">{t.guide.stepper[state]}</span>
          </li>
        );
      })}
    </ol>
  );
}

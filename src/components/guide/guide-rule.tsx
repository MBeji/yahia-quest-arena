import { BookOpen, Brain, Swords } from "lucide-react";

import { useGuideT } from "@/lib/i18n/guide";
import { MIN_SECONDS_PER_QUESTION, QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { fillGuideText } from "@/shared/lib/guide";
import { cn } from "@/shared/lib/utils";

const STEPS = [
  { key: "lesson", Icon: BookOpen },
  { key: "quiz", Icon: Brain },
  { key: "missions", Icon: Swords },
] as const;

/**
 * La règle d'or, dite en entier : cours → quiz de compréhension → missions.
 * Posée dans la fiche d'aide, sur la carte de première visite d'une matière et
 * à la fin de l'inscription — partout où l'élève peut croiser un cadenas.
 */
export function GuideRule({
  className,
  showTitle = true,
}: {
  className?: string;
  showTitle?: boolean;
}) {
  const t = useGuideT();
  const values = { pct: QUIZ_PASS_THRESHOLD_PCT, sec: MIN_SECONDS_PER_QUESTION };
  return (
    <section className={className} data-testid="guide-rule">
      {showTitle && (
        <>
          <h3 className="font-display text-base font-bold">{t.guide.rule.title}</h3>
          <p className="mt-1 text-sm text-muted-foreground">{t.guide.rule.intro}</p>
        </>
      )}
      <ol className={cn("space-y-2", showTitle && "mt-3")}>
        {STEPS.map(({ key, Icon }) => (
          <li
            key={key}
            className="flex items-start gap-3 rounded-xl border border-border bg-card p-3"
          >
            <span className="grid h-9 w-9 shrink-0 place-items-center rounded-lg bg-primary/10 text-primary">
              <Icon className="h-5 w-5" aria-hidden="true" />
            </span>
            <span className="min-w-0">
              <span className="block text-sm font-bold">{t.guide.rule[key].title}</span>
              <span className="mt-0.5 block text-sm leading-relaxed text-muted-foreground">
                {fillGuideText(t.guide.rule[key].text, values)}
              </span>
            </span>
          </li>
        ))}
      </ol>
    </section>
  );
}

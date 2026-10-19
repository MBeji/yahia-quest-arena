import { useEffect, useState } from "react";

import { Button } from "@/components/ui/button";
import { useGuideT } from "@/lib/i18n/guide";
import type { GuideScreenKey } from "@/lib/i18n/guide.types";
import {
  browserGuideStorage,
  readIntroDismissed,
  writeIntroDismissed,
} from "@/shared/lib/guide-storage";
import { cn } from "@/shared/lib/utils";
import { useGuide } from "./guide-context";
import { GuideRule } from "./guide-rule";

/**
 * La carte de PREMIÈRE VISITE d'un écran : ce qu'on y fait, en trois lignes,
 * puis « J'ai compris ». Posée dans la page — jamais en surimpression : elle ne
 * cache aucun bouton, et ne se remontre plus une fois lue (sur cet appareil).
 *
 * `rule` remplace les lignes de la fiche par la règle d'or — pour les écrans où
 * l'élève rencontre ses premiers cadenas.
 */
export function GuideIntroCard({
  screen,
  variant = "items",
  className,
}: {
  screen: GuideScreenKey;
  variant?: "items" | "rule";
  className?: string;
}) {
  const t = useGuideT();
  const { openGuide } = useGuide();
  // Lue après montage seulement : SSR et premier rendu client s'accordent (rien),
  // puis la carte apparaît si l'appareil ne l'a jamais fermée.
  const [visible, setVisible] = useState(false);
  useEffect(() => {
    setVisible(!readIntroDismissed(browserGuideStorage(), screen));
  }, [screen]);

  if (!visible) return null;
  const copy = t.guide.screens[screen];
  const headingId = `guide-intro-${screen}-title`;

  function dismiss() {
    writeIntroDismissed(browserGuideStorage(), screen);
    setVisible(false);
  }

  return (
    <section
      aria-labelledby={headingId}
      data-testid={`guide-intro-${screen}`}
      className={cn("rounded-2xl border-2 border-primary/40 bg-primary/5 p-4 sm:p-5", className)}
    >
      <span className="inline-flex items-center gap-1 rounded-full bg-primary px-2.5 py-0.5 text-2xs font-bold uppercase tracking-wider text-primary-foreground">
        👋 {t.guide.intro.badge}
      </span>
      <h2 id={headingId} className="mt-2 font-display text-lg font-bold">
        {copy.title}
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">{copy.intro}</p>

      {variant === "rule" ? (
        <GuideRule className="mt-3" showTitle={false} />
      ) : (
        <ul className="mt-3 space-y-2">
          {copy.items.slice(0, 3).map((item) => (
            <li key={item.label} className="flex items-start gap-2.5 text-sm">
              <span className="text-lg leading-none" aria-hidden="true">
                {item.icon}
              </span>
              <span className="min-w-0">
                <span className="font-bold">{item.label}</span>
                <span className="text-muted-foreground"> — {item.text}</span>
              </span>
            </li>
          ))}
        </ul>
      )}

      <div className="mt-4 flex flex-wrap gap-2">
        <Button onClick={dismiss} data-testid="guide-intro-dismiss" className="min-h-11">
          {t.guide.intro.gotIt}
        </Button>
        <Button variant="outline" onClick={openGuide} className="min-h-11">
          {t.guide.intro.more}
        </Button>
      </div>
    </section>
  );
}

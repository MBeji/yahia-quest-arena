import { useRouterState } from "@tanstack/react-router";

import { useI18n } from "@/lib/i18n";
import { useGuideT } from "@/lib/i18n/guide";
import type { GuideScreenKey } from "@/lib/i18n/guide.types";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Switch } from "@/components/ui/switch";
import { guideScreenFor } from "@/shared/lib/guide";
import { useGuide } from "./guide-context";
import { GuideRule } from "./guide-rule";

/** Les fiches parent n'ont pas de cadenas à expliquer : pas de règle d'or. */
const PARENT_SCREENS: ReadonlySet<GuideScreenKey> = new Set(["parent", "suivi"]);

/**
 * La fiche d'aide de l'écran affiché : à quoi sert chaque bouton, la règle d'or,
 * et l'interrupteur des bulles « ? ». Chargée paresseusement par `GuideProvider`.
 */
export function GuideSheet({
  open,
  onOpenChange,
}: {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const t = useGuideT();
  const { dir } = useI18n();
  const { tipsEnabled, setTipsEnabled } = useGuide();
  const pathname = useRouterState({ select: (s) => s.location.pathname });
  const screen = guideScreenFor(pathname);
  const copy = t.guide.screens[screen];

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent
        side={dir === "rtl" ? "left" : "right"}
        dir={dir}
        data-testid="guide-sheet"
        className="w-full overflow-y-auto sm:max-w-md"
      >
        {/* La croix de fermeture est posée en absolu dans le coin DROIT (physique) :
            côté fin en français, côté début en arabe. */}
        <SheetHeader className="pe-10 text-start rtl:ps-10">
          <SheetTitle className="font-display text-xl">{t.guide.sheetTitle}</SheetTitle>
          <SheetDescription>{t.guide.sheetSubtitle}</SheetDescription>
        </SheetHeader>

        <section className="mt-5" data-testid={`guide-screen-${screen}`}>
          <h3 className="font-display text-lg font-bold">{copy.title}</h3>
          <p className="mt-1 text-sm text-muted-foreground">{copy.intro}</p>
          <h4 className="mt-4 text-xs font-bold uppercase tracking-wider text-muted-foreground">
            {t.guide.onThisScreen}
          </h4>
          <ul className="mt-2 space-y-2">
            {copy.items.map((item) => (
              <li
                key={item.label}
                className="flex items-start gap-3 rounded-xl bg-secondary/50 p-3"
              >
                <span className="text-xl leading-none" aria-hidden="true">
                  {item.icon}
                </span>
                <span className="min-w-0">
                  <span className="block text-sm font-bold">{item.label}</span>
                  <span className="mt-0.5 block text-sm leading-relaxed text-muted-foreground">
                    {item.text}
                  </span>
                </span>
              </li>
            ))}
          </ul>
        </section>

        {!PARENT_SCREENS.has(screen) && <GuideRule className="mt-6" />}

        <div className="mt-6 flex items-start justify-between gap-4 rounded-xl border border-border p-3">
          <label htmlFor="guide-tips-switch" className="min-w-0">
            <span className="block text-sm font-bold">{t.guide.tips.toggleLabel}</span>
            <span className="mt-0.5 block text-xs leading-relaxed text-muted-foreground">
              {t.guide.tips.toggleHint}
            </span>
          </label>
          <Switch
            id="guide-tips-switch"
            data-testid="guide-tips-switch"
            checked={tipsEnabled}
            onCheckedChange={setTipsEnabled}
          />
        </div>

        <p className="mt-6 text-center text-xs text-muted-foreground">{t.guide.footer}</p>
      </SheetContent>
    </Sheet>
  );
}

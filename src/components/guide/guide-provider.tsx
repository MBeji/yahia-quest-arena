import { Suspense, lazy, useCallback, useEffect, useMemo, useState, type ReactNode } from "react";

import { browserGuideStorage, readTipsEnabled, writeTipsEnabled } from "@/shared/lib/guide-storage";
import { GuideContext, type GuideContextValue } from "./guide-context";

// La fiche et son catalogue (`i18n-guide`) ne descendent qu'au premier « Aide » :
// le provider vit à la racine, donc dans le chunk index, qui n'a que quelques KB
// de marge (`scripts/check-bundle-budget.mjs`).
const GuideSheet = lazy(() => import("./guide-sheet").then((m) => ({ default: m.GuideSheet })));

export function GuideProvider({ children }: { children: ReactNode }) {
  // Allumées au premier rendu (SSR et client d'accord), puis alignées sur le
  // choix mémorisé de l'appareil après montage.
  const [tipsEnabled, setTipsState] = useState(true);
  useEffect(() => {
    setTipsState(readTipsEnabled(browserGuideStorage()));
  }, []);

  const [isOpen, setIsOpen] = useState(false);
  // La fiche reste montée après sa première ouverture, pour que sa fermeture
  // s'anime au lieu de disparaître d'un coup.
  const [requested, setRequested] = useState(false);

  const setTipsEnabled = useCallback((enabled: boolean) => {
    setTipsState(enabled);
    writeTipsEnabled(browserGuideStorage(), enabled);
  }, []);
  const openGuide = useCallback(() => {
    setRequested(true);
    setIsOpen(true);
  }, []);
  const closeGuide = useCallback(() => setIsOpen(false), []);

  const value = useMemo<GuideContextValue>(
    () => ({ tipsEnabled, setTipsEnabled, isOpen, openGuide, closeGuide }),
    [tipsEnabled, setTipsEnabled, isOpen, openGuide, closeGuide],
  );

  return (
    <GuideContext.Provider value={value}>
      {children}
      {requested && (
        <Suspense fallback={null}>
          <GuideSheet open={isOpen} onOpenChange={setIsOpen} />
        </Suspense>
      )}
    </GuideContext.Provider>
  );
}

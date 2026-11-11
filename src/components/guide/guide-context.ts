import { createContext, useContext } from "react";

/**
 * L'état partagé du guide intégré : la fiche d'aide est-elle ouverte, les
 * bulles « ? » sont-elles allumées. Tenu par `<GuideProvider>` à la racine.
 *
 * Sans provider (tests d'écran isolés), les bulles sont allumées et ouvrir la
 * fiche ne fait rien : un composant d'aide ne casse jamais un écran.
 */
export interface GuideContextValue {
  tipsEnabled: boolean;
  setTipsEnabled: (enabled: boolean) => void;
  isOpen: boolean;
  openGuide: () => void;
  closeGuide: () => void;
}

const noop = () => {};

export const GuideContext = createContext<GuideContextValue>({
  tipsEnabled: true,
  setTipsEnabled: noop,
  isOpen: false,
  openGuide: noop,
  closeGuide: noop,
});

export function useGuide(): GuideContextValue {
  return useContext(GuideContext);
}

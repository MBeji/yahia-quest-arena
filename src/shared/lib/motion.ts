import { useSyncExternalStore } from "react";
import { useReducedMotion } from "motion/react";

/**
 * Standard entrance vocabulary for `motion/react` elements (étude 14, D-5).
 * Screens spread `useEntrance(...)` instead of hand-rolling `initial/animate`
 * objects, so every entrance is automatically neutralized under
 * `prefers-reduced-motion` (the audit found only 2 of ~12 screens gated it).
 */
export const MOTION_PRESETS = {
  fade: { initial: { opacity: 0 }, animate: { opacity: 1 } },
  rise: { initial: { opacity: 0, y: 12 }, animate: { opacity: 1, y: 0 } },
  scale: { initial: { opacity: 0, scale: 0.95 }, animate: { opacity: 1, scale: 1 } },
} as const;

export type MotionPreset = keyof typeof MOTION_PRESETS;

type EntranceProps =
  | { initial: false }
  | {
      initial: false | (typeof MOTION_PRESETS)[MotionPreset]["initial"];
      animate: (typeof MOTION_PRESETS)[MotionPreset]["animate"];
      transition: { duration: number; ease: "easeOut"; delay: number };
    };

/**
 * Non-hook variant for STAGGERED lists (per-item delay inside a `.map()`, where
 * a hook call would be illegal): call `useReducedMotion()` once in the component
 * and thread its result here.
 */
export function entrance(
  reduced: boolean | null,
  preset: MotionPreset = "rise",
  delay = 0,
): EntranceProps {
  if (reduced) return { initial: false };
  const { initial, animate } = MOTION_PRESETS[preset];
  return { initial, animate, transition: { duration: 0.35, ease: "easeOut", delay } };
}

const noSubscription = () => () => {};

/**
 * Faux sur le serveur ET pendant le rendu d'hydratation, vrai ensuite : « ce rendu doit-il encore
 * ressembler au HTML que le serveur a envoyé ? ». `useSyncExternalStore` est le seul outil de React 19
 * qui distingue les deux — un `useState` + `useEffect` rendrait la même valeur aux deux premiers rendus.
 */
function useHydrated(): boolean {
  return useSyncExternalStore(
    noSubscription,
    () => true,
    () => false,
  );
}

/**
 * Entrance props for a `motion.*` element. Under reduced motion the element
 * renders directly in its final state (`initial: false` — no animation, no
 * opacity flash).
 *
 * ⚠️ UNE EXCEPTION, ET C'EST ELLE QUI TENAIT LA CONNEXION. Le serveur ne connaît pas la préférence
 * « réduire les animations » : il rend l'état de DÉPART (`style="opacity:0;transform:scale(.95)"`).
 * Un premier rendu client en `initial: false` ne le corrige pas — React ne corrige pas les attributs
 * à l'hydratation — et, faute d'`animate`, `motion` n'écrit plus rien : la carte de /auth et de
 * /auth/reset restait à `opacity: 0` POUR TOUJOURS, donc personne ne pouvait se connecter.
 *
 * Pendant l'hydratation seulement, on rend donc ce que le serveur a rendu (`initial`), avec une durée
 * nulle : `motion` amène l'élément à son état final dès la première image, sans une seconde de
 * mouvement. Et `animate` RESTE défini au rendu suivant : le retirer (`{ initial: false }` seul, comme
 * avant) est lu par `motion` comme « retourne à ta valeur de base » — celle du HTML serveur, donc
 * `opacity: 0` — et défait l'animation avant qu'elle ait écrit quoi que ce soit. Pour tout élément monté
 * après l'hydratation, `initial: false` + `animate` rend directement l'état final, sans image de départ.
 */
export function useEntrance(preset: MotionPreset = "rise", delay = 0): EntranceProps {
  const reduced = useReducedMotion();
  const hydrated = useHydrated();
  if (reduced) {
    const { initial, animate } = MOTION_PRESETS[preset];
    return {
      initial: hydrated ? false : initial,
      animate,
      transition: { duration: 0, ease: "easeOut", delay: 0 },
    };
  }
  return entrance(reduced, preset, delay);
}

/**
 * Question-to-question horizontal slide inside an `AnimatePresence`
 * (quest player, dungeon). Lives apart from the presets because it carries an
 * `exit`; under reduced motion the incoming question renders in place and the
 * outgoing one is removed instantly (no exit prop → no exit animation).
 */
export function questionSlide(reduced: boolean | null) {
  if (reduced) return { initial: false as const };
  return {
    initial: { opacity: 0, x: 30 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: -30 },
    transition: { duration: 0.3 },
  };
}

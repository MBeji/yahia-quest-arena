import { useEffect, useRef } from "react";

/** Les touches qui ferment une célébration : celles qu'un élève essaie d'instinct. */
const DISMISS_KEYS = new Set(["Escape", "Enter", " "]);

/**
 * Rend une modale de célébration (montée de niveau, sceau) utilisable AU CLAVIER.
 *
 * Avant, ces modales ne se fermaient qu'au clic sur leur fond : un élève au
 * clavier, ou avec un lecteur d'écran, restait bloqué derrière un voile plein
 * écran (audit d'affichage du 2026-10-31). Tant que `show` est vrai :
 *
 *  - le focus entre dans la modale (la référence rendue, à poser sur l'élément
 *    `role="dialog"` avec `tabIndex={-1}`), et revient d'où il venait à la fermeture ;
 *  - Échap, Entrée et Espace ferment. Une touche MAINTENUE est ignorée : l'Entrée
 *    qui vient de valider la dernière réponse ne doit pas refermer la modale
 *    avant qu'elle ait été vue.
 *
 * `onComplete` est lu par référence : un appelant qui passe une fonction neuve à
 * chaque rendu ne relance pas l'effet, donc ne déplace pas le focus.
 */
export function useCelebrationDismiss<T extends HTMLElement>(
  show: boolean,
  onComplete: (() => void) | undefined,
) {
  const dialogRef = useRef<T>(null);
  const onCompleteRef = useRef(onComplete);
  useEffect(() => {
    onCompleteRef.current = onComplete;
  }, [onComplete]);

  useEffect(() => {
    if (!show) return;
    const previous = document.activeElement instanceof HTMLElement ? document.activeElement : null;
    dialogRef.current?.focus({ preventScroll: true });

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.repeat || !DISMISS_KEYS.has(event.key)) return;
      event.preventDefault();
      onCompleteRef.current?.();
    };
    window.addEventListener("keydown", onKeyDown);
    return () => {
      window.removeEventListener("keydown", onKeyDown);
      previous?.focus({ preventScroll: true });
    };
  }, [show]);

  return dialogRef;
}

import { useEffect, useRef } from "react";

/** La variable CSS que lit `scroll-padding-top` (voir `styles.css`). */
export const STICKY_HEADER_VAR = "--public-header-h";

/**
 * Publie la hauteur RÉELLE de l'en-tête collant dans `--public-header-h`, sur
 * `<html>`, et la tient à jour.
 *
 * Pourquoi : un saut d'ancre (sommaire d'un cours, `/#espace-famille`, panneau du
 * tuteur) amène sa cible tout en haut de la fenêtre — donc SOUS l'en-tête collant.
 * Les cibles portaient une marge fixe de 5 rem, alors que l'en-tête mesure jusqu'à
 * 168 px sur téléphone (deux rangées de navigation) : le titre visé restait caché
 * (audit d'affichage du 2026-10-31). La hauteur dépend de la largeur, de la langue
 * et de l'état du compte ; on la mesure donc au lieu de la deviner. Sans
 * `ResizeObserver` (ou avant l'hydratation), `styles.css` garde une valeur de
 * repli par largeur d'écran.
 */
export function useStickyHeaderOffset<T extends HTMLElement>() {
  const headerRef = useRef<T>(null);

  useEffect(() => {
    const header = headerRef.current;
    if (!header) return;
    const root = document.documentElement;
    const publish = () => {
      root.style.setProperty(
        STICKY_HEADER_VAR,
        `${Math.round(header.getBoundingClientRect().height)}px`,
      );
    };
    publish();
    const observer = typeof ResizeObserver === "undefined" ? null : new ResizeObserver(publish);
    observer?.observe(header);
    return () => {
      observer?.disconnect();
      // Hors de la coquille publique il n'y a plus d'en-tête collant : la variable
      // disparaît avec lui, et `scroll-padding-top` retombe sur sa marge seule.
      root.style.removeProperty(STICKY_HEADER_VAR);
    };
  }, []);

  return headerRef;
}

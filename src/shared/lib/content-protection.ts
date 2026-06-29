import { useEffect } from "react";

/**
 * Light-touch in-browser deterrents for the public (Référence) shell (Couche 5
 * du plan de protection IP). Honnête sur la portée : trivialement contournable
 * (view-source, devtools, JS désactivé) — c'est une dissuasion de courtoisie
 * contre la copie occasionnelle, PAS une vraie protection. La vraie protection
 * IP, c'est le filigrane d'impression, les métadonnées, robots.txt + bot-guard,
 * et la notice légale. On NE désactive PAS la sélection de texte (mauvais pour
 * les élèves, l'accessibilité et le SEO) : la copie reste permise, mais une
 * attribution « source + © » lui est ajoutée.
 */

// On n'attribue que les copies non triviales (un mot copié reste intact).
const ATTRIBUTION_MIN_LENGTH = 60;

/** Texte presse-papier d'une copie, avec attribution source + © ajoutée. */
export function buildAttributedCopy(selection: string, url: string): string {
  const text = selection ?? "";
  if (text.trim().length < ATTRIBUTION_MIN_LENGTH) return text;
  const source = url ? `\n\n— Source : ${url}` : "\n";
  return `${text}${source}\n© Na9ra Nal3ab — Propriété intellectuelle.`;
}

/** La cible de l'événement est-elle une <img> (ou un nœud à l'intérieur) ? */
export function isImageTarget(target: EventTarget | null): boolean {
  return target instanceof Element && target.closest("img") !== null;
}

/**
 * Branche les dissuasifs light-touch sur la coquille publique :
 *  - la copie de texte fonctionne, mais une attribution source + © est ajoutée ;
 *  - les images ne peuvent être ni glissées-déposées ni ouvertes au clic droit.
 * Sûr pour le SSR : effet client uniquement, aucun rendu.
 */
export function usePublicContentProtection(): void {
  useEffect(() => {
    if (typeof document === "undefined") return;

    const onCopy = (event: ClipboardEvent) => {
      const selection = document.getSelection()?.toString() ?? "";
      if (selection.trim().length < ATTRIBUTION_MIN_LENGTH) return;
      const url = typeof window !== "undefined" ? window.location.href : "";
      event.clipboardData?.setData("text/plain", buildAttributedCopy(selection, url));
      event.preventDefault();
    };

    const onImageGuard = (event: Event) => {
      if (isImageTarget(event.target)) event.preventDefault();
    };

    document.addEventListener("copy", onCopy);
    document.addEventListener("contextmenu", onImageGuard);
    document.addEventListener("dragstart", onImageGuard);
    return () => {
      document.removeEventListener("copy", onCopy);
      document.removeEventListener("contextmenu", onImageGuard);
      document.removeEventListener("dragstart", onImageGuard);
    };
  }, []);
}

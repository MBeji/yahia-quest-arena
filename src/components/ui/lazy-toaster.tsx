import { lazy, Suspense, useEffect, useState, type ComponentProps } from "react";
import type { Toaster as ToasterComponent } from "@/components/ui/sonner";

/**
 * L'afficheur de notifications, chargé APRÈS le premier rendu.
 *
 * Pourquoi : `sonner` pèse 32,8 Ko, et monté en dur à la racine il entrait dans le
 * chunk d'entrée que chaque visiteur télécharge avant de voir la moindre page —
 * pour une notification qui n'arrive qu'après un geste de l'élève (issue #1250 :
 * le chunk d'entrée était à 0,3 Ko de son plafond, et `react` 19.3 n'y tenait
 * plus). Ici son code part dans un chunk à part, tiré une fois la page hydratée.
 *
 * Aucune notification n'est perdue pendant ce délai : `sonner` rejoue à
 * l'abonnement de son `Toaster` tout ce qui est encore actif (« A toast can be
 * created before the Toaster had a chance to subscribe », `Observer.subscribe`).
 * `lazy-toaster.test.tsx` tient cette garantie : une montée de version qui la
 * retirerait fait échouer le test au lieu de faire taire un message d'erreur.
 *
 * Rien n'est rendu côté serveur ni au premier rendu client — donc aucun écart
 * d'hydratation, et le chunk n'est demandé qu'une fois l'application interactive.
 */
const Toaster = lazy(() =>
  import("@/components/ui/sonner").then((module) => ({ default: module.Toaster })),
);

export function LazyToaster(props: ComponentProps<typeof ToasterComponent>) {
  const [hydrated, setHydrated] = useState(false);
  useEffect(() => {
    setHydrated(true);
  }, []);
  if (!hydrated) return null;
  return (
    <Suspense fallback={null}>
      <Toaster {...props} />
    </Suspense>
  );
}

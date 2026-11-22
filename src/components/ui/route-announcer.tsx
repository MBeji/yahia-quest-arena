import { useEffect, useState } from "react";
import { useRouter } from "@tanstack/react-router";

/** L'identifiant du `<main>` de chaque coquille : cible du lien d'évitement et du focus. */
export const MAIN_CONTENT_ID = "contenu";

/**
 * DIRE QU'ON A CHANGÉ DE PAGE (audit de navigation du 2026-11-21, N-16).
 *
 * Une navigation sans rechargement ne dit rien à un lecteur d'écran : le focus retombait sur
 * `<body>` (le lien touché venait de disparaître) et rien n'annonçait la nouvelle page. Après chaque
 * navigation résolue — pas le chargement de la page, que le navigateur annonce lui-même — on lit le
 * titre de la page dans une région polie, et, si le focus s'est perdu, on le pose sur le contenu
 * principal. On ne le déplace JAMAIS s'il est encore sur un élément : changer un filtre ou un onglet
 * qui touche l'adresse ne doit pas arracher l'élève à son contrôle.
 */
export function RouteAnnouncer() {
  const router = useRouter();
  const [message, setMessage] = useState("");

  useEffect(() => {
    // L'adresse au moment de l'abonnement, pas « le premier événement » : l'abonnement arrive après
    // l'hydratation, souvent APRÈS la résolution initiale — sauter le premier événement sautait alors
    // la première vraie navigation (constaté en rejouant, 2026-11-22).
    let last = router.state.location.href;
    return router.subscribe("onResolved", () => {
      const href = router.state.location.href;
      if (href === last) return;
      last = href;
      // Le titre est posé par `<HeadContent>` au même rendu : on le lit à l'image suivante.
      requestAnimationFrame(() => {
        setMessage(document.title);
        const active = document.activeElement;
        if (active === null || active === document.body) {
          document.getElementById(MAIN_CONTENT_ID)?.focus({ preventScroll: true });
        }
      });
    });
  }, [router]);

  return (
    <p aria-live="polite" aria-atomic="true" className="sr-only" data-testid="route-announcer">
      {message}
    </p>
  );
}

/** Le premier élément atteint au clavier : il saute l'en-tête et ses menus. */
export function SkipToContent({ label }: { label: string }) {
  return (
    <a
      href={`#${MAIN_CONTENT_ID}`}
      className="sr-only focus:not-sr-only focus:fixed focus:top-2 focus:start-2 focus:z-50 focus:rounded-md focus:bg-background focus:px-4 focus:py-2 focus:text-sm focus:font-semibold focus:text-foreground focus:shadow-lg"
    >
      {label}
    </a>
  );
}

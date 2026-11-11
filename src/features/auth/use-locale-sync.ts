import { useEffect, useRef } from "react";
import { useServerFn } from "@tanstack/react-start";

import { useI18n } from "@/lib/i18n";
import { setProfileLocale } from "./auth.server";

/**
 * Étude 31 lot 4 (R-17) — pousse la langue d'interface dans le profil.
 *
 * Le fournisseur i18n ne peut pas le faire lui-même : il vit dans `lib/`, et une
 * brique partagée n'appelle pas une server fn de feature. Ce hook est monté par la
 * coquille authentifiée — le seul endroit qui sait à la fois QUI est connecté et
 * QUELLE langue est affichée.
 *
 * **Fire-and-forget, et une seule fois par valeur.** Un échec d'écriture coûte une
 * notification en français, jamais un écran cassé : on ne bloque rien, on
 * n'affiche rien, et on ne réessaie pas en boucle.
 */
export function useProfileLocaleSync(enabled: boolean): void {
  const { locale } = useI18n();
  const pushLocale = useServerFn(setProfileLocale);
  const lastSent = useRef<string | null>(null);

  useEffect(() => {
    if (!enabled || lastSent.current === locale) return;
    lastSent.current = locale;
    void pushLocale({ data: { locale } }).catch(() => {
      // Silencieux par choix : voir l'en-tête. On laisse la prochaine bascule
      // retenter, plutôt que de boucler sur une erreur réseau.
      lastSent.current = null;
    });
  }, [enabled, locale, pushLocale]);
}

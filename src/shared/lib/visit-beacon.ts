// LE DÉCLENCHEMENT DE LA MESURE DU RETOUR — étude 40, lot 0, R-2.
//
// Appelé UNE fois par chargement de page, après l'hydratation, par un import dynamique depuis
// `__root.tsx` : rien de ce fichier n'entre dans le chunk d'entrée. La racine lui passe le jour
// civil de Tunis (`appLocalDate`) — voir `visit-memory.ts` pour la raison, mesurée.
//
//   mémoire absente                 ⇒ `visit_first{entry_surface, standalone}`
//   mémoire présente, autre jour    ⇒ `visit_returned{days_bucket, has_account, entry, standalone}`
//   même jour, ou stockage en panne ⇒ rien
//
// La source d'entrée (`?src=`) est consommée DANS TOUS LES CAS : l'adresse affichée redevient
// propre même le jour où rien n'est émis.
//
// R-4 — zéro donnée personnelle : des étiquettes fermées et deux booléens. `has_account` dit
// « une session existe sur cet appareil », jamais laquelle.

import {
  consumeEntrySource,
  entrySurfaceFromPath,
  isStandaloneDisplay,
  type EntrySource,
  type EntrySurface,
} from "@/shared/lib/entry-source";
import { trackProductEvent, type ProductEventProps } from "@/shared/lib/product-events";
import { recordVisit, type VisitVerdict } from "@/shared/lib/visit-memory";

/** Tout ce que la mesure lit du monde — injectable, pour que chaque règle ait son test. */
export type VisitBeaconDeps = {
  readonly recordVisit: (today: string) => VisitVerdict;
  readonly consumeEntrySource: () => EntrySource;
  readonly entrySurface: () => EntrySurface;
  readonly standalone: () => boolean;
  readonly hasAccount: () => Promise<boolean>;
  readonly track: (name: "visit_first" | "visit_returned", props: ProductEventProps) => void;
};

/**
 * Une session existe-t-elle sur cet appareil ? Le client Supabase est déjà chargé par la racine
 * (`useExitOnRefusedSession`) ; l'import dynamique ne coûte donc rien, et il tient ce module hors
 * de portée d'un environnement sans configuration Supabase.
 */
async function sessionExists(): Promise<boolean> {
  try {
    const { supabase } = await import("@/shared/integrations/supabase/client");
    const { data } = await supabase.auth.getSession();
    return data.session !== null;
  } catch {
    return false;
  }
}

const BROWSER_DEPS: VisitBeaconDeps = {
  recordVisit: (today) => recordVisit({ today }),
  consumeEntrySource: () => consumeEntrySource(),
  entrySurface: () => entrySurfaceFromPath(window.location.pathname),
  standalone: () => isStandaloneDisplay(),
  hasAccount: sessionExists,
  track: (name, props) => {
    // Deux appels littéraux, à dessein : le test du catalogue cherche chaque événement « live »
    // sous cette forme exacte pour prouver qu'il est réellement émis.
    if (name === "visit_first") trackProductEvent("visit_first", props);
    else trackProductEvent("visit_returned", props);
  },
};

/**
 * Classe la visite du jour et émet AU PLUS un événement. Ne lève jamais.
 *
 * @param today le jour civil de TUNIS (`appLocalDate(new Date())`), `AAAA-MM-JJ`.
 */
export async function trackVisit(
  today: string,
  deps: VisitBeaconDeps = BROWSER_DEPS,
): Promise<void> {
  try {
    // La surface se lit AVANT de toucher à l'adresse ; la source se consomme dans tous les cas.
    const surface = deps.entrySurface();
    const entry = deps.consumeEntrySource();
    const verdict = deps.recordVisit(today);
    if (verdict.kind === "first") {
      deps.track("visit_first", { entry_surface: surface, standalone: deps.standalone() });
    } else if (verdict.kind === "returned") {
      deps.track("visit_returned", {
        days_bucket: verdict.daysBucket,
        has_account: await deps.hasAccount(),
        entry,
        standalone: deps.standalone(),
      });
    }
  } catch {
    // Une mesure qui casse la page qu'elle observe n'aurait aucun sens.
  }
}

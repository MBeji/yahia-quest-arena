/**
 * LE TEST DE NIVEAU (étude 39) — les constantes que l'écran et le serveur partagent.
 *
 * La VÉRITÉ est en SQL (`start_placement_session` compose, `placement_band` classe,
 * `placement_bilan_json` compte les participants) : ce fichier n'en porte que le MIROIR
 * d'affichage, pour que le texte de l'écran dise les mêmes nombres que la base — « 10 questions »,
 * « à partir de 20 participants » — sans qu'un chiffre soit écrit deux fois à la main dans le
 * client. Zéro import serveur : il voyage dans le chunk de la route publique.
 */

/** Combien de questions compose un test — `v_items` de `start_placement_session` (R-1). */
export const PLACEMENT_ITEMS = 10;

/**
 * Sous ce nombre de tests finis par des élèves, non bâclés, le percentile n'est pas affiché :
 * un rang sur douze participants se lirait comme une mesure (R-9, seuil repris de é02).
 */
export const PLACEMENT_MIN_CANDIDATES = 20;

/** Les quatre bandes de niveau (R-6), dans l'ordre descendant — la clé voyage dans le bilan. */
export const PLACEMENT_BANDS = ["solide", "en-route", "consolider", "reprendre"] as const;
export type PlacementBand = (typeof PLACEMENT_BANDS)[number];

/**
 * Le seuil bas (inclus, sur 20) de chaque bande — miroir de `placement_band` en SQL, qui reste
 * le juge : l'écran ne reclasse jamais une note, il lit la bande que le bilan porte. Ce miroir
 * sert au TEXTE DE PARTAGE et aux tests, pas à la décision.
 */
export const PLACEMENT_BAND_FLOORS: Readonly<Record<PlacementBand, number>> = {
  solide: 16,
  "en-route": 12,
  consolider: 8,
  reprendre: 0,
};

/** La bande d'une note sur 20 — même table de vérité que `placement_band`, pour le client. */
export function placementBandFor(scoreOn20: number): PlacementBand {
  if (!Number.isFinite(scoreOn20)) return "reprendre";
  if (scoreOn20 >= PLACEMENT_BAND_FLOORS.solide) return "solide";
  if (scoreOn20 >= PLACEMENT_BAND_FLOORS["en-route"]) return "en-route";
  if (scoreOn20 >= PLACEMENT_BAND_FLOORS.consolider) return "consolider";
  return "reprendre";
}

/**
 * Sous cette note, le texte de partage proposé tait le chiffre (RISK-2 : un 4/20 partagé n'est
 * pas une bonne publicité pour l'élève) — il peut toujours l'ajouter lui-même.
 */
export const PLACEMENT_SHARE_SCORE_FLOOR = 8;

/** Combien de tests l'appareil retient (R-15) — assez pour une famille, pas un historique. */
export const PLACEMENT_MEMORY_MAX = 5;

/** Durée de vie de la mémoire d'appareil (R-15) : au-delà, l'envie de retrouver un bilan est passée. */
export const PLACEMENT_MEMORY_TTL_MS = 30 * 24 * 60 * 60 * 1000;

/** Le chemin public du test — une seule source pour le lien de partage, le sitemap et l'en-tête. */
export const PLACEMENT_PATH = "/test-de-niveau";

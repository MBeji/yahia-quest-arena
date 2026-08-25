// Constantes du tuteur déterministe — source unique de vérité côté TypeScript
// (étude 30 §3.2, dépôt privé `FableEtudes/30-tuteur-deterministe`).
//
// POURQUOI CE FICHIER EXISTE
// ---------------------------------------------------------------------------
// L'étude 30 pose une variable de décision — `p_known`, une croyance calibrée par
// Bayesian Knowledge Tracing — à côté de la variable d'affichage de é07 (`mastery`,
// l'EWMA 0-100). Les seuils qui séparent « maîtrisé », « en cours », « fragile » et
// « lacune » sont lus à DEUX endroits : par le SQL, qui décide, et par le client, qui
// affiche. R-4 de é07 (« constantes centralisées, jamais en ligne à l'appel ») s'applique
// aux deux — et ce module est la moitié TypeScript.
//
// Ce module est ISOMORPHE : aucun secret, aucun accès réseau, aucun import `.server`.
// Il ne contient que des seuils, et c'est justement pour cela qu'il peut être public :
// connaître le seuil de maîtrise ne donne la réponse d'aucun item.
//
// ⚠️ CE QUI N'EST *PAS* ICI, ET NE DOIT PAS Y ARRIVER : `p_known` lui-même. D-1 est
// explicite — aucune surface élève n'affiche une probabilité de croyance ; les écrans
// rendent un ÉTAT (lot 3), la console d'admin est la seule exception. Les valeurs
// ci-dessous servent à *nommer* un état, jamais à en afficher le nombre.

// ---------------------------------------------------------------------------
// 1. Les bandes de croyance — ce qui sépare les quatre états
// ---------------------------------------------------------------------------

/**
 * Seuil canonique de maîtrise de Corbett & Anderson (1994). Il ne suffit pas :
 * la maîtrise se DÉCLARE sur cinq conditions conjointes (R-4), dont celle-ci n'est
 * que la première — voir {@link MIN_EVIDENCE}, {@link MIN_SESSIONS}, {@link MIN_FORMS}
 * et {@link EVIDENCE_STALE_DAYS}. Une croyance à 0,99 obtenue quatre fois sur le même
 * QCM ne déclare rien.
 */
export const MASTERY_THRESHOLD = 0.95;

/**
 * Symétrique bas : en deçà, on parle de LACUNE — mais seulement avec assez de preuves
 * (R-5 : `evidence_count >= 3`). Accuser sur deux items est une erreur de mesure, pas
 * un diagnostic.
 */
export const GAP_THRESHOLD = 0.25;

/** Borne basse de la zone « fragile » : entre elle et {@link MASTERY_THRESHOLD}, la
 *  compétence est en cours d'acquisition et vaut d'être consolidée. */
export const FRAGILE_THRESHOLD = 0.6;

// ---------------------------------------------------------------------------
// 2. « Répétée ET variée » — le mandat rendu opposable (R-4)
// ---------------------------------------------------------------------------

/** Nombre minimal de preuves jouées avant de pouvoir déclarer une maîtrise. */
export const MIN_EVIDENCE = 4;

/** Preuves réparties sur au moins deux sessions distinctes : un bon jour n'est pas une
 *  maîtrise. */
export const MIN_SESSIONS = 2;

/**
 * Preuves apportées sous au moins deux FORMES d'items distinctes (la variante rappel
 * comptant pour une forme à part entière). C'est le « et variée » du mandat : quatre QCM
 * identiques prouvent qu'on sait reconnaître, pas qu'on sait faire.
 */
export const MIN_FORMS = 2;

/**
 * Au-delà, la dernière preuve est trop vieille pour soutenir une déclaration de maîtrise.
 * Aligné sur la fenêtre des misconceptions de é04 (R-2) — deux organes qui regardent le
 * même passé doivent le regarder sur la même durée.
 */
export const EVIDENCE_STALE_DAYS = 30;

// ---------------------------------------------------------------------------
// 3. L'inférence dans le graphe (lot 2 — R-7 à R-9)
// ---------------------------------------------------------------------------

/** γ : l'amortissement par niveau de profondeur. Une maîtrise à 0,88 relève un prérequis
 *  direct à 0,616, son grand-parent à 0,431. */
export const INFERENCE_DAMPING = 0.7;

/** L'inférence s'arrête à deux niveaux : au-delà, γ² l'a déjà rendue négligeable, et le
 *  coût de la propagation cesse d'être borné. */
export const INFERENCE_MAX_DEPTH = 2;

/**
 * Plafond dur de toute croyance déduite — sous {@link MASTERY_THRESHOLD} PAR CONSTRUCTION
 * (R-9). On peut être dispensé d'un prérequis par déduction ; on n'est déclaré maître que
 * de ce qu'on a fait soi-même.
 */
export const INFERENCE_CEILING = 0.9;

// ---------------------------------------------------------------------------
// 4. Le poids de la preuve (R-21) et la zone proximale (§3.4)
// ---------------------------------------------------------------------------

/**
 * `p_final = p_avant + w · (p_après − p_avant)`. C'est l'échafaudage de Bruner rendu
 * arithmétique : l'aide se retire à mesure que l'autonomie se prouve, et le système sait
 * toujours de quelle autonomie il parle.
 *
 * - `unaided` — l'élève a résolu seul ;
 * - `tier12` — après les paliers « orienter » et « la règle » (lot 5, différé) ;
 * - `tier3` — après « décomposer », qui donne la première étape.
 */
export const EVIDENCE_WEIGHTS = {
  unaided: 1.0,
  tier12: 0.5,
  tier3: 0.25,
} as const;

/**
 * Le mini-check du tuteur (é11 US-4) : une question posée juste après une explication est
 * structurellement une reprise après aide, pas une preuve d'autonomie. Il pèse donc comme
 * les paliers 1-2. Côté serveur, il se détecte par le FIL (`tutor_threads`), pas par la
 * source — é11 lot 4 écrit `source = 'exercise'` avec le fil pour `session_id`.
 */
export const TUTOR_CHECK_WEIGHT = EVIDENCE_WEIGHTS.tier12;

/**
 * La zone proximale de développement, en nombres : l'intervalle de `P(réussite)` prédite
 * que le sélecteur vise (`P = p·(1−S) + (1−p)·G`). En dessous c'est la frustration, au
 * dessus l'ennui. C'est ce que é11 US-13 appelait « probabilité de réussite estimée
 * 60-80 % » — elle cesse d'être estimée.
 */
export const ZPD_TARGET = { min: 0.55, max: 0.8 } as const;

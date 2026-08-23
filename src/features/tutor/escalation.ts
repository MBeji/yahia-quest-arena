// L'ESCALADE DE COMPRÉHENSION — étude 11 lot 4, R-8.
//
// POURQUOI CE FICHIER EXISTE ALORS QUE LE SQL DÉCIDE DÉJÀ
// ---------------------------------------------------------------------------
// R-10 : « le déterministe décide, le LLM rédige ». Le déterministe, ici, c'est
// `tutor_understanding_signal()` — les trois signaux et le niveau recommandé
// sont calculés en base, sur des faits, et rien de ce fichier ne les recalcule.
//
// Ce module tient l'autre moitié : l'ORDRE des marches et la CLÉ de microcopy
// qui les nomme. Il est ici plutôt qu'en SQL pour une raison de vérifiabilité —
// la matrice (a, b, c) a huit cases, et huit cases se testent en millisecondes
// sans base, alors qu'une assertion pgTAP par case demanderait de fabriquer
// huit historiques d'élève. Le SQL porte la même matrice (§4 de la migration
// 20260823140000) ; ce fichier est celui qui la PROUVE.
//
// Il choisit une CLÉ, jamais une phrase — même contrat que `coaching.ts` : les
// phrases vivent dans les trois dictionnaires i18n (R-18). Aucune horloge,
// aucun import de supabase, aucun effet.

/**
 * Les cinq marches de R-8, DANS L'ORDRE. L'index dans ce tableau EST le
 * `escalation_level` stocké sur `tutor_threads` (0..4, borné par un CHECK).
 *
 * L'ordre n'est pas négociable et ne se réordonne pas « pour essayer » : il va
 * du moins coûteux pour l'élève au plus engageant. Montrer le prérequis avant
 * d'avoir seulement re-expliqué renverrait un enfant deux chapitres en arrière
 * pour une phrase mal formulée ; prévenir le parent avant d'avoir tout tenté en
 * ferait un rapport de discipline plutôt qu'un signal d'entraide.
 */
export const TUTOR_ESCALATION_STEPS = [
  /** 0 — re-expliquer dans un AUTRE registre (R-7). L'état de départ de tout fil. */
  "reteach",
  /** 1 — « Montre-moi le cours » : deep-link vers le chapitre. */
  "lesson",
  /** 2 — le prérequis faible, via `get_competency_blockers`. */
  "prerequisite",
  /** 3 — un item du plan du jour, via `get_daily_plan`. */
  "plan",
  /** 4 — mention AGRÉGÉE dans le digest parent (Q-5). Jamais le verbatim. */
  "parentDigest",
] as const;

export type TutorEscalationStep = (typeof TUTOR_ESCALATION_STEPS)[number];

/** Le plafond de `tutor_threads.escalation_level`, en un seul endroit. */
export const TUTOR_MAX_ESCALATION = TUTOR_ESCALATION_STEPS.length - 1;

/**
 * Les trois signaux OBJECTIFS de R-8, tels que le SQL les rend. Trois, et aucun
 * quatrième : la liste est fermée par la règle, pas par le confort du code.
 */
export type TutorUnderstandingSignals = {
  /** (a) Échec au mini-check DEUX fois sur le même tag. */
  readonly signalA: boolean;
  /** (b) Deux « Explique autrement » consécutifs, SUIVIS d'un échec. */
  readonly signalB: boolean;
  /** (c) Tag toujours ACTIF 7 jours après au moins 2 explications servies. */
  readonly signalC: boolean;
};

/**
 * Le niveau d'escalade recommandé par la matrice R-8.
 *
 * Chaque signal dit à quelle PROFONDEUR la compréhension a décroché, donc où
 * reprendre — la matrice n'est pas un barème de gravité, c'est un diagnostic :
 *
 *   (a) l'explication ne prend pas       → 1, montrer le COURS
 *   (b) les trois registres sont épuisés → 2, chercher le PRÉREQUIS
 *   (c) ça dure depuis une semaine       → 3, inscrire au PLAN
 *   les trois à la fois                  → 4, le dire au PARENT
 *
 * Le signal le plus PROFOND l'emporte, et non le plus récent : un élève qui
 * traîne le tag depuis sept jours (c) n'a rien à gagner à ce qu'on lui remontre
 * le cours (a) une fois de plus. Seule la conjonction des trois franchit la
 * dernière marche — prévenir le parent sur un signal isolé serait une alerte
 * pour du bruit, et c'est ainsi qu'on apprend à un parent à ignorer les alertes.
 *
 * ⚠️ Cette fonction est le MIROIR du `CASE` de `tutor_understanding_signal()`.
 * Les deux doivent bouger ensemble ; c'est `tutor-escalation.test.ts` qui fige
 * les huit cases.
 */
export function escalationLevel(signals: TutorUnderstandingSignals): number {
  const { signalA, signalB, signalC } = signals;
  if (signalA && signalB && signalC) return 4;
  if (signalC) return 3;
  if (signalB) return 2;
  if (signalA) return 1;
  return 0;
}

/** La marche d'un niveau. Hors bornes, on retombe sur l'état de départ plutôt que sur `undefined`. */
export function escalationStep(level: number): TutorEscalationStep {
  if (!Number.isFinite(level)) return TUTOR_ESCALATION_STEPS[0];
  const clamped = Math.min(Math.max(Math.trunc(level), 0), TUTOR_MAX_ESCALATION);
  return TUTOR_ESCALATION_STEPS[clamped];
}

/**
 * La marche SUIVANTE — celle que `escalate_tutor_thread()` servira au prochain
 * appel. Au sommet, elle se répète : au niveau 4 on re-mentionne au parent, on
 * ne « déborde » pas. Le SQL applique le même `LEAST(level + 1, 4)`.
 */
export function nextEscalationStep(level: number): TutorEscalationStep {
  return escalationStep(escalationStepIndex(level) + 1);
}

/** L'index borné d'un niveau — le seul endroit qui sait clamper. */
function escalationStepIndex(level: number): number {
  if (!Number.isFinite(level)) return 0;
  return Math.min(Math.max(Math.trunc(level), 0), TUTOR_MAX_ESCALATION);
}

/**
 * La clé de microcopy d'une marche, sous `t.tutor.escalation`.
 *
 * Une CLÉ, pas une phrase : la marche « prerequisite » se dit différemment en
 * arabe et en français, et ce module n'a pas à le savoir.
 */
export function escalationKey(step: TutorEscalationStep): string {
  return step;
}

/**
 * Le nom d'action rendu par `escalate_tutor_thread()`, traduit en marche.
 *
 * Les deux vocabulaires diffèrent d'un seul mot — `parent_digest` en SQL,
 * `parentDigest` en TypeScript — parce que chacun suit la convention de sa
 * langue (snake_case en base, camelCase pour une clé i18n). Ce pont est ici
 * plutôt qu'en ligne dans le composant pour que la correspondance soit TESTÉE :
 * une action inconnue retomberait sinon sur `undefined` et l'écran afficherait
 * un trou à la place d'une proposition.
 *
 * Une action non reconnue vaut `reteach` — la marche la plus douce, jamais la
 * plus engageante. Se tromper vers « je te réexplique » est sans conséquence ;
 * se tromper vers « j'en parle à tes parents » ne l'est pas.
 */
export function escalationStepFromAction(action: string | null | undefined): TutorEscalationStep {
  switch (action) {
    case "lesson":
      return "lesson";
    case "prerequisite":
      return "prerequisite";
    case "plan":
      return "plan";
    case "parent_digest":
      return "parentDigest";
    default:
      return "reteach";
  }
}

/**
 * Le raccourci de bout en bout : des signaux à la marche à servir.
 *
 * Rend la marche du niveau RECOMMANDÉ, pas la suivante — `escalationLevel` a
 * déjà dit où reprendre, et y ajouter un cran ferait sauter une marche à chaque
 * diagnostic.
 */
export function recommendedEscalation(signals: TutorUnderstandingSignals): {
  level: number;
  step: TutorEscalationStep;
} {
  const level = escalationLevel(signals);
  return { level, step: escalationStep(level) };
}

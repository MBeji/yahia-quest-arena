// Feature : tuteur « El Ostedh » (étude 11 lot 1) — API publique.
// Import depuis "@/features/tutor".
//
// ⚠️ Une feature n'importe jamais une autre feature (AGENTS.md). `quest` ne
// connaît donc pas ce module : c'est la ROUTE de correction qui compose
// `QuestReviewList` et `TutorPanel`, en passant le second au premier par un slot.

export {
  escalateTutorThread,
  explainMistake,
  getTutorAvailability,
  getTutorMiniCheck,
  getTutorPrefs,
  getTutorUnderstandingSignal,
  isCuratedModel,
  nextVariant,
  rateTutorMessage,
  setTutorPlanPush,
  setTutorPrefs,
  submitTutorMiniCheck,
  type TutorEscalation,
  type TutorEscalationTarget,
  type TutorExplanation,
  type TutorMiniCheck,
  type TutorMiniCheckResult,
  type TutorPrefs,
} from "./tutor.server";

export {
  escalationKey,
  escalationLevel,
  escalationStep,
  escalationStepFromAction,
  nextEscalationStep,
  recommendedEscalation,
  TUTOR_ESCALATION_STEPS,
  TUTOR_MAX_ESCALATION,
  type TutorEscalationStep,
  type TutorUnderstandingSignals,
} from "./escalation";

export {
  startTargetedPractice,
  type TutorPracticeItem,
  type TutorPracticeResult,
} from "./tutor.practice.server";

export { decidePractice, type TutorPracticeFacts, type TutorPracticeIntent } from "./practice";

export {
  dayIndexOf,
  daysAwayFrom,
  momentKey,
  momentKind,
  planCoachKey,
  planCoachKind,
  type TutorMoment,
  type TutorMomentState,
  type TutorPlanCoachKind,
} from "./coaching";

export {
  TUTOR_AGE_BANDS,
  TUTOR_INTERESTS,
  TUTOR_LANGS,
  TUTOR_VARIANTS,
  type TutorAgeBand,
  type TutorInterest,
  type TutorLang,
  type TutorVariant,
} from "./prompt";

export { getWeeklyDigest, type TutorDigestView } from "./digest.server";

export { TUTOR_DIGEST_AUDIENCES, type TutorDigestAudience } from "./digest";

// ⚠️ NI `handleDigestCron`, NI `generateWeeklyDigests`, NI leurs options.
//
// Le batch hebdomadaire n'est pas une API de feature : c'est une PORTE HTTP, et
// elle traîne derrière elle `callAi` et le client `service_role`. Le précédent
// est nommé et il tient depuis é24 — `notifications/index.ts` garde
// `notifications.cron.server.ts` hors du barrel pour cette raison exacte, et
// `src/server.ts` l'importe par son chemin complet. Ce barrel-ci est tiré par du
// code CLIENT (`quest.$exerciseId.tsx` en importe `TutorPanel`) : y faire entrer
// un module de batch, c'est offrir à l'arbre de dépendances du navigateur une
// branche qui n'a rien à y faire.

export {
  rechargeOutcome,
  tutorEnergyState,
  TUTOR_ENERGY_QUERY_KEY,
  type TutorEnergyCap,
  type TutorEnergyLevel,
  type TutorEnergyReading,
  type TutorEnergyState,
  type TutorRechargeOutcome,
  type TutorRechargeReason,
} from "./energy";

export {
  getTutorCacheStats,
  getTutorEnergy,
  rechargeTutorEnergy,
  type TutorCacheStats,
  type TutorRechargeResult,
} from "./tutor.energy.server";

export { TutorPanel } from "./components/tutor-panel";
export { TutorPracticeEntry } from "./components/tutor-practice-entry";
export { TutorCoachLine, TutorGreeting } from "./components/tutor-coach";
export { TutorPlanPushCard } from "./components/tutor-plan-push-card";
// ⚠️ `TutorCachePanel` et non `TutorCacheStats` : ce dernier est le TYPE de la
// forme rendue par la RPC, et un barrel ne peut pas porter deux membres du même
// nom, fût-ce un type et un composant venus de deux modules.
export { TutorCachePanel } from "./components/tutor-cache-stats";
export { TutorEnergyMeter } from "./components/tutor-energy";
export { TutorDigestCard, TutorParentDigest } from "./components/tutor-digest";

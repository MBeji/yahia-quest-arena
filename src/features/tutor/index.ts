// Feature : tuteur « El Ostedh » (étude 11 lot 1) — API publique.
// Import depuis "@/features/tutor".
//
// ⚠️ Une feature n'importe jamais une autre feature (AGENTS.md). `quest` ne
// connaît donc pas ce module : c'est la ROUTE de correction qui compose
// `QuestReviewList` et `TutorPanel`, en passant le second au premier par un slot.

export {
  explainMistake,
  getTutorAvailability,
  getTutorPrefs,
  isCuratedModel,
  nextVariant,
  rateTutorMessage,
  setTutorPlanPush,
  setTutorPrefs,
  type TutorExplanation,
  type TutorPrefs,
} from "./tutor.server";

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

export { TutorPanel } from "./components/tutor-panel";
export { TutorCoachLine, TutorGreeting } from "./components/tutor-coach";
export { TutorPlanPushCard } from "./components/tutor-plan-push-card";

// Feature: Parcours (gamified adventure path / journey map)
// Public API — import from "@/features/parcours"
export { JourneyMap } from "./components/journey-map";
export { SubjectPath } from "./components/subject-path";
export {
  buildSubjectNodes,
  buildChapterNodes,
  xpProgress,
  nodeSide,
  type SubjectNode,
  type ChapterNode,
  type NodeState,
  type XpProgress,
} from "./journey";

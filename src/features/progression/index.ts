// Feature: Progression (streak recovery, révision du jour)
// Public API — import from "@/features/progression"

export { recoverStreak, getCompetencyExercises } from "./progression.server";
// Tuteur déterministe (étude 30, lot 3). Les trois lectures de croyance : l'état et la zone
// de chaque compétence, la frontière « prêt à apprendre », et le geste de contestation d'une
// déduction (US-3/R-10).
export { getLearningState, getLearningFrontier, disputeInference } from "./progression.server";
// « Carte de compétences » (étude 07, lot 4). Comme le panneau de révision, il vit dans la
// progression et ses données arrivent par `getDashboard` (get_my_competency_map +
// get_competency_blockers), lu une seule fois. La route dashboard compose.
export { CompetencyMapPanel } from "./components/competency-map-panel";
// « Révision du jour » (étude 04, lot A1.1). Le panneau vit ici — la révision est de la
// progression — mais ses DONNÉES arrivent par `getDashboard`, qui appelle `get_daily_plan`
// une seule fois pour alimenter à la fois la bande focus et ce panneau (étude 22, D-8).
// La route dashboard compose les deux ; les features ne s'importent jamais entre elles.
export { DailyReviewPanel } from "./components/daily-review-panel";
// « Tes points faibles » (étude 04, lot A2.1). Même motif que ses deux voisins :
// le panneau vit ici, ses DONNÉES arrivent par `getDashboard` en une seule lecture
// (é22 D-8), et la route dashboard compose.
export { WeaknessesPanel } from "./components/weaknesses-panel";
// Tuteur déterministe (étude 30, lot 3) — la porte unique des deux panneaux de croyance
// (« Prêt à apprendre » et la carte à 4 états), repli R-6 sur la carte de é07 compris. La
// route ne compose plus qu'un composant ; le choix de quelle carte montrer appartient ici.
export { LearningPanels } from "./components/learning-panels";

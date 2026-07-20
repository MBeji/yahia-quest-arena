// Feature: Progression (streak recovery, révision du jour)
// Public API — import from "@/features/progression"

export { recoverStreak } from "./progression.server";
// « Révision du jour » (étude 04, lot A1.1). Le panneau vit ici — la révision est de la
// progression — mais ses DONNÉES arrivent par `getDashboard`, qui appelle `get_daily_plan`
// une seule fois pour alimenter à la fois la bande focus et ce panneau (étude 22, D-8).
// La route dashboard compose les deux ; les features ne s'importent jamais entre elles.
export { DailyReviewPanel } from "./components/daily-review-panel";

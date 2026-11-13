// Public barrel for the notifications feature.
// NOTE: the cron dispatcher (notifications.cron.server.ts) imports `web-push`
// (Node-only) and is intentionally NOT re-exported here — it is imported
// directly by src/server.ts so it never leaks into a client bundle.
export { EnablePushCard } from "./components/enable-push-card";
// Étude 08 lot 2 — la carte du bilan dominical (canal + digest enrichi opt-in).
export { ParentDigestCard } from "./components/parent-digest-card";
export { savePushSubscription, deletePushSubscription } from "./notifications.server";
// Exporté pour les surfaces qui doivent SAVOIR si le push est armé sur cet
// appareil avant de proposer un rappel : le tuteur (é11 US-7) ne montre son
// opt-in que si la permission existe — un interrupteur qui n'allume rien est
// pire que pas d'interrupteur (#813).
export { usePush, type PushMoment, type PushState } from "./use-push";
// Étude 40, lot 2 — le rappel proposé après une victoire, candidat de `NudgeSlot`.
export { usePushVictoryCandidate } from "./components/use-push-victory-candidate";

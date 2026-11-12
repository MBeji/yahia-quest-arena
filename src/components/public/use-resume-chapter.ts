import { useSyncExternalStore } from "react";
import { useAuth } from "@/features/auth";
import {
  readLastChapter,
  subscribeAnonContinuity,
  type ResumeChapter,
} from "@/shared/lib/anon-continuity";

// AUCUN ÉCART D'HYDRATATION (étude 38, lot 5). Le serveur ne connaît pas le stockage :
// `useSyncExternalStore` lui fait rendre `null`, rejoue ce `null` pendant l'hydratation, puis lit
// l'appareil. Sur une page rendue par le client seul (navigation interne), le chapitre est là dès
// le premier rendu.

const noChapterOnServer = (): null => null;
const readFromDevice = (): ResumeChapter | null => readLastChapter();

/** Le chapitre à proposer à CE lecteur, ou `null` : serveur, session en cours de lecture, connecté, rien à reprendre. */
export function useResumeChapter(): ResumeChapter | null {
  const { user, loading } = useAuth();
  const chapter = useSyncExternalStore(subscribeAnonContinuity, readFromDevice, noChapterOnServer);
  return loading || user ? null : chapter;
}

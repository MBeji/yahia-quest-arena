import { registerSender } from "@/shared/lib/outbox";
import { QUEST_SUBMIT_KIND, type QuestSubmitPayload } from "@/features/quest/quest-draft";
import { submitAttempt } from "@/features/quest/quest.server";

// =============================================================================
// QUI SAIT ENVOYER UNE SOUMISSION DE MISSION RESTÉE EN FILE.
//
// POURQUOI CE FICHIER EXISTE PLUTÔT QUE TROIS LIGNES DANS `__root.tsx`. La file
// démarre au montage de l'application — il le faut, une soumission en attente
// appartenant à la session PRÉCÉDENTE. Mais `__root` est le point d'entrée du
// chunk `index`, qui a un budget de taille (450 ko) : tout ce qu'il importe
// STATIQUEMENT y entre. Nommer `QUEST_SUBMIT_KIND` depuis la racine suffisait à
// y faire entrer `quest-draft.ts` — et le budget est passé de 449 à 452,26 ko,
// rouge en CI. Le barrel porte déjà l'avertissement pour `recall-messages`
// (« importing these plain strings must NOT pull the server module into the
// client index chunk »), c'est le même piège une étude plus tard.
//
// La racine ne connaît donc plus rien de la quête : elle appelle CETTE
// fonction, derrière un `import()` dynamique, et la feature déclare elle-même
// ce qu'elle sait envoyer.
// =============================================================================

/**
 * Déclare l'expéditeur des soumissions de mission auprès de la file.
 *
 * Idempotente : la file indexe ses expéditeurs par genre, un second appel
 * remplace le premier par l'identique.
 */
export function registerQuestOutboxSender(): void {
  registerSender(QUEST_SUBMIT_KIND, (payload) =>
    submitAttempt({ data: payload as QuestSubmitPayload }),
  );
}

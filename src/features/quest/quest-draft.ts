// LE BROUILLON D'UNE MISSION EN COURS — ce que l'état React ne survit pas.
//
// Les réponses d'une mission s'accumulaient dans un `useState` et n'en sortaient
// qu'à la soumission finale. Un rechargement à la question 7 sur 10 renvoyait
// donc l'élève à la question 1, et un onglet mobile tué par le système faisait
// pareil — sans que rien ne soit jamais parti vers le serveur, puisque la
// soumission n'a lieu qu'à la fin.
//
// Ce module n'envoie RIEN. Il écrit sur l'appareil, et c'est tout : l'envoi est
// l'affaire de `outbox.ts`, la file qui garde la soumission finale jusqu'à ce
// qu'elle passe. Les deux étages sont séparés parce qu'ils protègent deux choses
// différentes — la partie en cours, et la partie terminée.
import { logger } from "@/shared/lib/logger";

const PREFIX = "nn:quest-draft:v1:";

/**
 * Au-delà, un brouillon ne décrit plus une partie que l'élève a en tête. Le
 * proposer relancerait une mission oubliée depuis deux jours au lieu d'en
 * ouvrir une neuve.
 */
export const DRAFT_MAX_AGE_MS = 2 * 60 * 60 * 1000;

export type QuestDraftAnswer = { readonly questionId: string; readonly choice: string };

/** Le genre d'item que la file porte pour une mission. */
export const QUEST_SUBMIT_KIND = "quest.submit";

/**
 * Ce qu'un item de file transporte — exactement l'entrée de `submitAttempt`.
 *
 * Déclaré à la main plutôt que dérivé de la server fn : `Parameters<typeof
 * submitAttempt>` traverse toute la pile de middlewares de TanStack Start et ne
 * se résout pas en un objet nommable. Le zod de `submitAttempt` reste l'autorité
 * — ce type n'est que la forme que l'appelant doit produire, et le serveur
 * refusera tout ce qui s'en écarte.
 */
export type QuestSubmitPayload = {
  readonly sessionId: string;
  readonly exerciseId: string;
  readonly answers: readonly QuestDraftAnswer[];
};

export type QuestDraft = {
  /** La session serveur à laquelle ces réponses appartiennent. */
  readonly sessionId: string | null;
  readonly answers: readonly QuestDraftAnswer[];
  /** L'index de la question affichée, pour reprendre au bon endroit. */
  readonly idx: number;
  readonly updatedAt: number;
};

/**
 * L'identifiant de file d'une soumission de mission.
 *
 * POURQUOI LA SESSION, ET PAS UN UUID TIRÉ AU SORT. La session EST déjà la clé
 * d'unicité du serveur : `submit_exercise_attempt` la verrouille, refuse une
 * seconde soumission (`completed_at`), et `attempts.session_id` la retient. Un
 * identifiant client tiré au sort à côté serait une seconde clé pour la même
 * chose — donc une occasion de plus qu'elles divergent. Celle-ci est stable par
 * construction, survit au rechargement (elle voyage dans le payload en file) et
 * désigne exactement la partie dont il s'agit.
 */
export function questOutboxClientId(sessionId: string): string {
  return `quest.submit:${sessionId}`;
}

function storageKey(exerciseId: string, variant: string): string {
  return `${PREFIX}${exerciseId}:${variant}`;
}

/**
 * Le brouillon de cette mission, s'il en existe un d'assez frais.
 *
 * Rend `null` sur tout ce qui n'est pas exploitable — pas de stockage, JSON
 * cassé, forme inattendue, brouillon périmé. Un brouillon douteux vaut moins
 * qu'aucun brouillon : le rejeter renvoie l'élève au début de sa mission, le
 * croire lui ferait reprendre des réponses qui ne sont pas les siennes.
 */
export function loadDraft(exerciseId: string, variant: string): QuestDraft | null {
  if (typeof window === "undefined") return null;
  try {
    const raw = window.localStorage.getItem(storageKey(exerciseId, variant));
    if (!raw) return null;
    const parsed: unknown = JSON.parse(raw);
    const draft = toDraft(parsed);
    if (!draft) return null;
    if (Date.now() - draft.updatedAt > DRAFT_MAX_AGE_MS) {
      clearDraft(exerciseId, variant);
      return null;
    }
    return draft;
  } catch {
    return null;
  }
}

/** Écrit le brouillon. Synchrone — c'est ce qu'exige `pagehide`. */
export function saveDraft(
  exerciseId: string,
  variant: string,
  draft: Omit<QuestDraft, "updatedAt">,
): void {
  if (typeof window === "undefined") return;
  // Une mission sans réponse n'a rien à sauvegarder, et écrire un brouillon vide
  // ferait proposer une reprise à qui vient à peine d'ouvrir la mission.
  if (draft.answers.length === 0) return;
  try {
    window.localStorage.setItem(
      storageKey(exerciseId, variant),
      JSON.stringify({ ...draft, updatedAt: Date.now() }),
    );
  } catch (error) {
    logger.warn("quest-draft.write-failed", { error: String(error), exerciseId });
  }
}

/** Efface le brouillon — la mission est rendue, ou l'élève repart de zéro. */
export function clearDraft(exerciseId: string, variant: string): void {
  if (typeof window === "undefined") return;
  try {
    window.localStorage.removeItem(storageKey(exerciseId, variant));
  } catch {
    // Un brouillon qu'on n'arrive pas à effacer périmera de lui-même.
  }
}

/**
 * Où reprendre une mission, à partir des questions RÉELLEMENT servies et des
 * réponses du brouillon.
 *
 * ⚠️ POURQUOI ON NE FAIT PAS CONFIANCE À `draft.idx`. Rien ne garantit que la
 * mission serve ses questions dans le même ordre d'un chargement à l'autre —
 * et en mode rappel, elle ne sert même pas le même SOUS-ENSEMBLE. Un index
 * repris tel quel désignerait alors une autre question que celle où l'élève
 * s'était arrêté : il en re-répondrait une déjà répondue, et la réponse
 * partirait en double dans le payload. On recalcule donc la position à partir
 * des identifiants, qui sont la seule chose stable.
 *
 * Les réponses sont filtrées sur les questions effectivement servies (une
 * question retirée du corpus entre-temps n'a plus rien à noter) et
 * dédoublonnées.
 */
export function resumeFrom(
  questionIds: readonly string[],
  draftAnswers: readonly QuestDraftAnswer[],
): { answers: QuestDraftAnswer[]; idx: number } {
  const served = new Set(questionIds);
  const seen = new Set<string>();
  const answers: QuestDraftAnswer[] = [];
  for (const answer of draftAnswers) {
    if (!served.has(answer.questionId) || seen.has(answer.questionId)) continue;
    seen.add(answer.questionId);
    answers.push(answer);
  }
  // La première question sans réponse, dans l'ordre où elles sont servies —
  // pas la « suivante » d'un index conservé.
  const firstUnanswered = questionIds.findIndex((id) => !seen.has(id));
  return { answers, idx: firstUnanswered === -1 ? questionIds.length : firstUnanswered };
}

function toDraft(value: unknown): QuestDraft | null {
  if (!value || typeof value !== "object") return null;
  const raw = value as Partial<QuestDraft>;
  if (typeof raw.updatedAt !== "number" || typeof raw.idx !== "number") return null;
  if (!Array.isArray(raw.answers)) return null;
  const answers = raw.answers.filter(
    (a): a is QuestDraftAnswer =>
      Boolean(a) &&
      typeof (a as QuestDraftAnswer).questionId === "string" &&
      typeof (a as QuestDraftAnswer).choice === "string",
  );
  if (answers.length !== raw.answers.length) return null;
  return {
    sessionId: typeof raw.sessionId === "string" ? raw.sessionId : null,
    answers,
    idx: raw.idx,
    updatedAt: raw.updatedAt,
  };
}

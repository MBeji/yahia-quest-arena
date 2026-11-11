// UNE RÉPONSE CORRIGÉE EST DÉFINITIVE — le pendant client du verrou serveur
// (migration 20260929120000).
//
// Le serveur fige, par session, la réponse de toute question dont le verdict a été
// montré (`exercise_session_reveals`), et c'est sur elle qu'il note. Ce module ne
// décide rien : il RÉUNIT ce que le serveur a figé et ce que le lecteur tient, pour
// que l'écran — la reprise après un rechargement, la correction de fin de partie —
// dise la même chose que la note.
import { resumeFrom, type QuestDraftAnswer } from "@/features/quest/quest-draft";

/**
 * Les réponses d'une partie où chaque réponse FIGÉE remplace celle du lecteur, ou
 * s'y ajoute si le lecteur ne l'a pas encore (elle n'y entre qu'à « Continuer »).
 * L'ordre du lecteur est conservé ; les réponses figées qu'il n'avait pas suivent.
 */
export function mergeRevealedAnswers(
  answers: readonly QuestDraftAnswer[],
  revealed: readonly QuestDraftAnswer[],
): QuestDraftAnswer[] {
  const locked = new Map(revealed.map((answer) => [answer.questionId, answer.choice]));
  const merged = answers.map((answer) => {
    const choice = locked.get(answer.questionId);
    return choice === undefined ? answer : { questionId: answer.questionId, choice };
  });
  const present = new Set(answers.map((answer) => answer.questionId));
  return [...merged, ...revealed.filter((answer) => !present.has(answer.questionId))];
}

export type ResumePlan = {
  answers: QuestDraftAnswer[];
  /** La question à afficher. */
  idx: number;
  /** La réponse à présélectionner sur cette question — la sienne, figée. */
  selected: string | null;
};

/**
 * Où reprendre une partie, brouillon local ET réponses figées réunis — `null`
 * s'il n'y a rien à reprendre.
 *
 * ⚠️ UN BROUILLON COMPLET À LUI SEUL N'EST PAS REPRIS (règle de
 * `useQuestDraftRestore`, inchangée) : la partie était finie, seule sa soumission
 * a échoué, et elle attend déjà dans la file.
 *
 * Quand ce sont les réponses FIGÉES qui complètent la partie — l'élève a vu la
 * correction de la dernière question, puis a rechargé avant « Terminer » —, il
 * revient sur cette dernière question, sa réponse figée présélectionnée : valider
 * lui remontre le même verdict, puis « Terminer » rend la partie. Le renvoyer au
 * début lui ferait recliquer toute une mission dont aucune réponse ne peut plus
 * changer.
 */
export function planResume(
  questionIds: readonly string[],
  draftAnswers: readonly QuestDraftAnswer[],
  revealed: readonly QuestDraftAnswer[],
): ResumePlan | null {
  if (draftAnswers.length > 0 && resumeFrom(questionIds, draftAnswers).idx >= questionIds.length) {
    return null;
  }
  const { answers, idx } = resumeFrom(questionIds, mergeRevealedAnswers(draftAnswers, revealed));
  if (answers.length === 0) return null;
  if (idx < questionIds.length) return { answers, idx, selected: null };
  const lastId = questionIds[questionIds.length - 1];
  return {
    answers: answers.filter((answer) => answer.questionId !== lastId),
    idx: questionIds.length - 1,
    selected: answers.find((answer) => answer.questionId === lastId)?.choice ?? null,
  };
}

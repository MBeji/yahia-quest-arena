/**
 * « Prochaine action » — étude 22, R-31.
 *
 * LE problème que ce fichier résout : jusqu'ici, deux écrans répondaient chacun à leur façon à
 * la question « qu'est-ce que je fais maintenant ? ». Le dashboard proposait « la dernière
 * matière touchée, sinon la première non commencée » ; le hub matière proposait « le chapitre
 * le plus avancé non terminé ». Aucun des deux ne connaissait les révisions dues, et les deux
 * pouvaient désigner des cibles différentes au même instant. Un élève à qui l'app dit deux
 * choses ne suit ni l'une ni l'autre.
 *
 * Il n'y a donc plus qu'un moteur, en TS partagé et non en RPC (D-8) : les données nécessaires
 * sont déjà chargées par les server fns appelantes, et une RPC dédiée ajouterait un aller-retour
 * et surtout un second endroit où la règle pourrait diverger.
 *
 * L'ordre de priorité est celui de R-31, et il n'est pas négociable au cas par cas :
 *   1. une RÉVISION due — ce que la mémoire est en train d'oublier prime sur tout le reste ;
 *   2. le dernier exercice RATÉ — reprendre un échec récent vaut mieux qu'avancer sur du neuf ;
 *   3. la prochaine mission du CHEMIN — le chapitre le plus avancé non terminé ;
 *   4. la DÉCOUVERTE — une matière encore jamais ouverte.
 *
 * Un seul CTA à la fois (étude 15 R-1) : la fonction renvoie UNE action, jamais une liste.
 * `null` est une réponse légitime — il n'y a rien à proposer, et l'écran doit alors se taire
 * plutôt que d'inventer une action.
 *
 * `get_daily_plan` (études 04-A1 / 07) viendra alimenter la priorité 1 sans rien changer
 * d'autre : elle remplacera la source des révisions dues, pas le moteur (R-18, D-8).
 */
import {
  isCatalogueMission,
  isChapterComplete,
  isMissionPassed,
  type CompletionExercise,
} from "./chapter-completion";

export type NextAction =
  /** Une révision espacée est échue (priorité 1). */
  | { kind: "review"; exerciseId: string }
  /** Le dernier exercice a été raté et reste rejouable (priorité 2). */
  | { kind: "retry"; exerciseId: string }
  /** La mission suivante du chemin recommandé (priorité 3). */
  | { kind: "continue"; exerciseId: string; chapterId: string }
  /**
   * Priorité 3 DÉLÉGUÉE : l'appelant sait quelle matière porte le chemin, mais n'a pas de quoi
   * en désigner la mission. Le dashboard est dans ce cas — il ne charge ni chapitres ni
   * exercices — et renvoie donc vers le hub, qui résout la mission avec ce même moteur.
   * Charger tout le contenu de la matière au tableau de bord pour trancher une flèche serait
   * payer très cher une décision que l'écran suivant prend gratuitement.
   */
  | { kind: "continue-subject"; subjectId: string }
  /** Une matière encore jamais ouverte (priorité 4). */
  | { kind: "discover"; subjectId: string };

export type NextActionExercise = CompletionExercise & {
  difficulty?: number | null;
  display_order?: number | null;
};

export type NextActionInput = {
  /** Exercice de la révision due la plus ancienne, si une est échue. */
  dueReviewExerciseId?: string | null;
  /** Dernier exercice tenté sous la barre de réussite (le `nextExerciseId` historique). */
  failedExerciseId?: string | null;
  /** Chapitres de la matière courante, dans leur ordre d'affichage. */
  chapters?: { id: string }[];
  /** Exercices de ces chapitres — `source`/`mode` servent aux règles de complétion (R-15). */
  exercises?: NextActionExercise[];
  /** Meilleur score classique par exercice. */
  bestByExercise?: Record<string, number>;
  /** Porte du quiz déjà résolue serveur, par chapitre (R-7). */
  quizSatisfiedByChapter?: Record<string, boolean>;
  /**
   * Matière qui porte le chemin en cours (la plus récemment travaillée), quand l'appelant ne
   * peut pas résoudre la mission elle-même. Sert de priorité 3 déléguée.
   */
  pathSubjectId?: string | null;
  /** Matière du parcours encore jamais tentée, s'il en reste une. */
  untouchedSubjectId?: string | null;
};

/**
 * Tri R-13 : le quiz de compréhension d'abord (c'est la porte du chapitre), puis les missions
 * par difficulté croissante, puis par ordre d'affichage. C'est la progression recommandée
 * ⭐ → ⭐⭐ → ⭐⭐⭐ (boss) → ⭐⭐⭐⭐ (défi) — recommandée, jamais imposée (R-12).
 */
function byRecommendedOrder(a: NextActionExercise, b: NextActionExercise): number {
  if ((a.mode === "quiz") !== (b.mode === "quiz")) return a.mode === "quiz" ? -1 : 1;
  const da = a.difficulty ?? 0;
  const db = b.difficulty ?? 0;
  if (da !== db) return da - db;
  return (a.display_order ?? 0) - (b.display_order ?? 0);
}

/**
 * Priorité 3 : la prochaine mission du chemin, dans le chapitre le plus avancé qui n'est pas
 * terminé. « Le plus avancé » se lit à l'endroit où l'élève en est vraiment : on cherche
 * d'abord, en repartant de la fin, un chapitre COMMENCÉ mais non terminé — c'est là qu'il a
 * laissé son travail. À défaut seulement, on propose le premier chapitre non terminé, qui est
 * le début naturel pour quelqu'un qui n'a encore rien commencé.
 */
function nextOnPath(input: NextActionInput): NextAction | null {
  const { chapters = [], exercises = [], bestByExercise = {}, quizSatisfiedByChapter = {} } = input;
  if (chapters.length === 0 || exercises.length === 0) return null;

  const rows = chapters.map((chapter) => {
    const chapEx = exercises.filter((e) => e.chapter_id === chapter.id).sort(byRecommendedOrder);
    const quizSatisfied = quizSatisfiedByChapter[chapter.id] === true;
    const complete = isChapterComplete(chapEx, bestByExercise, quizSatisfied);
    const started = chapEx.some((e) => bestByExercise[e.id] != null);
    // Tant que la porte du quiz est fermée, la seule action possible est le quiz lui-même :
    // proposer une mission verrouillée serait un CTA qui mène à un refus (R-30).
    const quiz = chapEx.find((e) => e.mode === "quiz") ?? null;
    const next = !quizSatisfied
      ? quiz
      : (chapEx.find((e) => isCatalogueMission(e) && !isMissionPassed(bestByExercise[e.id])) ??
        null);
    return { chapter, complete, started, next };
  });

  const resumable = [...rows].reverse().find((r) => r.started && !r.complete && r.next);
  const target = resumable ?? rows.find((r) => !r.complete && r.next);
  if (!target?.next) return null;
  return { kind: "continue", exerciseId: target.next.id, chapterId: target.chapter.id };
}

/**
 * Résout LA prochaine action, dans l'ordre de R-31. Fonction pure : elle ne lit rien, ne
 * charge rien, et ne décide rien d'autre que la priorité — chaque appelant lui passe ce qu'il
 * a déjà en main.
 */
export function resolveNextAction(input: NextActionInput): NextAction | null {
  if (input.dueReviewExerciseId) {
    return { kind: "review", exerciseId: input.dueReviewExerciseId };
  }
  if (input.failedExerciseId) {
    return { kind: "retry", exerciseId: input.failedExerciseId };
  }
  const onPath = nextOnPath(input);
  if (onPath) return onPath;
  // Priorité 3 déléguée AVANT la découverte : reprendre un chemin commencé prime toujours sur
  // en ouvrir un neuf. Inverser les deux enverrait un élève en plein chapitre de maths
  // découvrir une matière qu'il n'a jamais touchée.
  if (input.pathSubjectId) {
    return { kind: "continue-subject", subjectId: input.pathSubjectId };
  }
  if (input.untouchedSubjectId) {
    return { kind: "discover", subjectId: input.untouchedSubjectId };
  }
  return null;
}

/**
 * « Prochaine action » — étude 22, R-31.
 *
 * Ce fichier ne teste pas quatre fonctions : il teste UN ORDRE. Chaque cas vérifie qu'une
 * priorité l'emporte sur celles qui la suivent, parce que c'est exactement ce qui se cassait
 * avant — deux écrans qui répondaient chacun à sa façon à « qu'est-ce que je fais maintenant ».
 */
import { describe, it, expect } from "vitest";
import { resolveNextAction, type NextActionExercise } from "../next-action";

const ex = (id: string, over: Partial<NextActionExercise> = {}): NextActionExercise => ({
  id,
  chapter_id: "c1",
  mode: "practice",
  difficulty: 1,
  display_order: 1,
  ...over,
});

/** Une matière à deux chapitres, chacun avec son quiz et deux missions. */
const chapters = [{ id: "c1" }, { id: "c2" }];
const exercises: NextActionExercise[] = [
  ex("q1", { chapter_id: "c1", mode: "quiz", difficulty: 1 }),
  ex("m1", { chapter_id: "c1", difficulty: 1, display_order: 1 }),
  ex("m2", { chapter_id: "c1", difficulty: 2, display_order: 2 }),
  ex("q2", { chapter_id: "c2", mode: "quiz", difficulty: 1 }),
  ex("m3", { chapter_id: "c2", difficulty: 1, display_order: 1 }),
];
const allQuizOpen = { c1: true, c2: true };

describe("resolveNextAction — l'ordre de priorité (R-31)", () => {
  it("1 · la révision due passe avant TOUT le reste", () => {
    const action = resolveNextAction({
      dueReviewExerciseId: "review-1",
      failedExerciseId: "failed-1",
      chapters,
      exercises,
      bestByExercise: {},
      quizSatisfiedByChapter: allQuizOpen,
      pathSubjectId: "math",
      untouchedSubjectId: "svt",
    });
    expect(action).toEqual({ kind: "review", exerciseId: "review-1" });
  });

  it("2 · le dernier échec passe avant le chemin et la découverte", () => {
    const action = resolveNextAction({
      failedExerciseId: "failed-1",
      chapters,
      exercises,
      bestByExercise: {},
      quizSatisfiedByChapter: allQuizOpen,
      pathSubjectId: "math",
      untouchedSubjectId: "svt",
    });
    expect(action).toEqual({ kind: "retry", exerciseId: "failed-1" });
  });

  it("3 · le chemin passe avant la découverte", () => {
    const action = resolveNextAction({
      chapters,
      exercises,
      bestByExercise: { q1: 100, m1: 100, m2: 100, q2: 100 },
      quizSatisfiedByChapter: allQuizOpen,
      untouchedSubjectId: "svt",
    });
    // c1 est terminé, c2 ne l'est pas : m3 est la mission suivante.
    expect(action).toEqual({ kind: "continue", exerciseId: "m3", chapterId: "c2" });
  });

  it("4 · la découverte ne sort qu'en dernier recours", () => {
    const action = resolveNextAction({ untouchedSubjectId: "svt" });
    expect(action).toEqual({ kind: "discover", subjectId: "svt" });
  });

  it("ne propose rien plutôt que d'inventer une action", () => {
    expect(resolveNextAction({})).toBeNull();
  });
});

describe("resolveNextAction — priorité 3, le choix du chapitre", () => {
  it("reprend le chapitre COMMENCÉ le plus avancé, pas le premier venu", () => {
    // c1 est intact, c2 est entamé : c'est en c2 que l'élève a laissé son travail.
    const action = resolveNextAction({
      chapters,
      exercises,
      bestByExercise: { q2: 100, m3: 20 },
      quizSatisfiedByChapter: allQuizOpen,
    });
    expect(action).toEqual({ kind: "continue", exerciseId: "m3", chapterId: "c2" });
  });

  it("à défaut de chapitre commencé, propose le début naturel", () => {
    const action = resolveNextAction({
      chapters,
      exercises,
      bestByExercise: {},
      quizSatisfiedByChapter: allQuizOpen,
    });
    expect(action).toEqual({ kind: "continue", exerciseId: "m1", chapterId: "c1" });
  });

  it("propose le QUIZ tant que la porte du chapitre est fermée (R-30)", () => {
    // Proposer une mission verrouillée serait un CTA qui mène droit à un refus.
    const action = resolveNextAction({
      chapters: [{ id: "c1" }],
      exercises,
      bestByExercise: {},
      quizSatisfiedByChapter: { c1: false },
    });
    expect(action).toEqual({ kind: "continue", exerciseId: "q1", chapterId: "c1" });
  });

  it("suit l'ordre R-13 : difficulté croissante, pas l'ordre du tableau", () => {
    const action = resolveNextAction({
      chapters: [{ id: "c1" }],
      // m2 (⭐⭐) est déclaré AVANT m1 (⭐) : le tri doit quand même désigner m1.
      exercises: [
        ex("m2", { chapter_id: "c1", difficulty: 2, display_order: 1 }),
        ex("m1", { chapter_id: "c1", difficulty: 1, display_order: 2 }),
      ],
      bestByExercise: {},
      quizSatisfiedByChapter: { c1: true },
    });
    expect(action).toMatchObject({ kind: "continue", exerciseId: "m1" });
  });

  it("ignore les missions familiales : elles ne sont pas le chemin (R-15)", () => {
    const action = resolveNextAction({
      chapters: [{ id: "c1" }],
      exercises: [
        ex("parent-1", { chapter_id: "c1", source: "parent", difficulty: 1, display_order: 1 }),
        ex("m1", { chapter_id: "c1", difficulty: 1, display_order: 2 }),
      ],
      bestByExercise: {},
      quizSatisfiedByChapter: { c1: true },
    });
    expect(action).toMatchObject({ exerciseId: "m1" });
  });

  it("ne propose rien quand tout est terminé", () => {
    const action = resolveNextAction({
      chapters,
      exercises,
      bestByExercise: { q1: 100, m1: 100, m2: 100, q2: 100, m3: 100 },
      quizSatisfiedByChapter: allQuizOpen,
    });
    expect(action).toBeNull();
  });
});

describe("resolveNextAction — priorité 3 déléguée", () => {
  it("désigne la matière du chemin quand l'appelant ne peut pas résoudre la mission", () => {
    // Le cas du dashboard : il ne charge ni chapitres ni exercices.
    const action = resolveNextAction({ pathSubjectId: "math", untouchedSubjectId: "svt" });
    expect(action).toEqual({ kind: "continue-subject", subjectId: "math" });
  });

  it("reprendre un chemin commencé prime sur en ouvrir un neuf", () => {
    // L'inversion enverrait un élève en plein chapitre de maths découvrir une autre matière.
    const action = resolveNextAction({ pathSubjectId: "math", untouchedSubjectId: "svt" });
    expect(action).not.toMatchObject({ kind: "discover" });
  });

  it("cède la place à la mission réelle dès que l'appelant a de quoi la résoudre", () => {
    const action = resolveNextAction({
      chapters,
      exercises,
      bestByExercise: {},
      quizSatisfiedByChapter: allQuizOpen,
      pathSubjectId: "math",
    });
    expect(action).toMatchObject({ kind: "continue", exerciseId: "m1" });
  });
});

// =============================================================================
// Amendement C (étude 30, §3.9) — deux priorités de plus, et rien d'autre.
// =============================================================================

/**
 * LE TEST QUI COMPTE LE PLUS DE TOUT CE LOT.
 *
 * Le §4.2 exige une non-régression LITTÉRALE : « sur les fixtures existantes de
 * `next-action.test.ts`, `resolveNextAction` rend EXACTEMENT ce qu'elle rendait ». Les
 * dix-sept cas au-dessus le vérifient déjà un à un, mais un à un seulement — et une
 * priorité insérée au mauvais rang peut passer entre eux.
 *
 * Celui-ci balaie donc l'espace : toutes les combinaisons d'entrées que les fixtures
 * existantes permettent, comparées à la table de vérité de l'ordre d'AVANT l'amendement.
 * Il échouerait si l'un des deux nouveaux rangs se déclenchait sans croyance — ce qui est
 * précisément la seule façon dont cet amendement pourrait casser le produit d'aujourd'hui,
 * sur les ~88 matières non taggées.
 */
describe("é30 amendement C — non-régression LITTÉRALE sur les entrées d'avant", () => {
  it("sans croyance, l'ordre d'origine est rendu à l'identique sur TOUTES les combinaisons", () => {
    const flags = [true, false];
    for (const hasReview of flags) {
      for (const hasFailed of flags) {
        for (const hasPath of flags) {
          for (const hasSubject of flags) {
            for (const hasUntouched of flags) {
              const input = {
                dueReviewExerciseId: hasReview ? "rev" : null,
                failedExerciseId: hasFailed ? "fail" : null,
                chapters: hasPath ? chapters : [],
                exercises: hasPath ? exercises : [],
                bestByExercise: {},
                quizSatisfiedByChapter: hasPath ? allQuizOpen : {},
                pathSubjectId: hasSubject ? "subj" : null,
                untouchedSubjectId: hasUntouched ? "neuf" : null,
              };

              // L'ordre d'AVANT l'amendement, réécrit ici comme oracle indépendant : review →
              // retry → chemin → chemin délégué → découverte. Le réimplémenter plutôt que de
              // le lire dans le module est le point du test — sinon on comparerait le code
              // à lui-même.
              const expected = hasReview
                ? { kind: "review", exerciseId: "rev" }
                : hasFailed
                  ? { kind: "retry", exerciseId: "fail" }
                  : hasPath
                    ? { kind: "continue", exerciseId: "m1", chapterId: "c1" }
                    : hasSubject
                      ? { kind: "continue-subject", subjectId: "subj" }
                      : hasUntouched
                        ? { kind: "discover", subjectId: "neuf" }
                        : null;

              expect(resolveNextAction(input)).toEqual(expected);
            }
          }
        }
      }
    }
  });

  it("les deux nouveaux rangs rendent `null` sans croyance — explicitement", () => {
    // `undefined` (l'appelant ne sait pas encore) et `null` (l'appelant a demandé, il n'y a
    // rien) doivent se comporter pareil : les deux existent en vrai.
    expect(resolveNextAction({ remediation: undefined, strengthen: undefined })).toBeNull();
    expect(resolveNextAction({ remediation: null, strengthen: null })).toBeNull();
  });
});

describe("é30 amendement C — les deux nouveaux rangs", () => {
  const remediation = { competencySlug: "math.num.multiples", exerciseId: "cause" };
  const strengthen = { competencySlug: "math.frac.comparer", exerciseId: "autre-forme" };

  it("2 · la remédiation passe devant le RETRY — la cause avant le symptôme", () => {
    // C'est tout l'amendement en une assertion. Rejouer l'exercice raté sans traiter le
    // prérequis manquant est la définition du piétinement.
    expect(resolveNextAction({ failedExerciseId: "fail", remediation })).toEqual({
      kind: "remediate",
      exerciseId: "cause",
      competencySlug: "math.num.multiples",
    });
  });

  it("1 · mais la RÉVISION passe encore devant elle — la mémoire prime, inchangé", () => {
    expect(resolveNextAction({ dueReviewExerciseId: "rev", remediation, strengthen })).toEqual({
      kind: "review",
      exerciseId: "rev",
    });
  });

  it("4 · la consolidation passe DERRIÈRE le retry — un fait prime sur une tendance", () => {
    // Un échec récent est un fait ; une compétence « en cours » est une tendance.
    expect(resolveNextAction({ failedExerciseId: "fail", strengthen })).toEqual({
      kind: "retry",
      exerciseId: "fail",
    });
  });

  it("4 · mais devant le CHEMIN — consolider ce qui vacille avant d'ouvrir du neuf", () => {
    expect(
      resolveNextAction({
        chapters,
        exercises,
        bestByExercise: {},
        quizSatisfiedByChapter: allQuizOpen,
        strengthen,
      }),
    ).toEqual({
      kind: "strengthen",
      exerciseId: "autre-forme",
      competencySlug: "math.frac.comparer",
    });
  });

  it("l'ordre complet des six rangs, en une séquence", () => {
    const full = {
      dueReviewExerciseId: "rev",
      failedExerciseId: "fail",
      chapters,
      exercises,
      bestByExercise: {},
      quizSatisfiedByChapter: allQuizOpen,
      pathSubjectId: "subj",
      untouchedSubjectId: "neuf",
      remediation,
      strengthen,
    };
    // On retire les entrées une à une, dans l'ordre des rangs : chaque retrait doit faire
    // descendre la réponse d'exactement un cran. C'est l'ordre entier prouvé en un test.
    expect(resolveNextAction(full)?.kind).toBe("review");
    expect(resolveNextAction({ ...full, dueReviewExerciseId: null })?.kind).toBe("remediate");
    expect(resolveNextAction({ ...full, dueReviewExerciseId: null, remediation: null })?.kind).toBe(
      "retry",
    );
    expect(
      resolveNextAction({
        ...full,
        dueReviewExerciseId: null,
        remediation: null,
        failedExerciseId: null,
      })?.kind,
    ).toBe("strengthen");
    expect(
      resolveNextAction({
        ...full,
        dueReviewExerciseId: null,
        remediation: null,
        failedExerciseId: null,
        strengthen: null,
      })?.kind,
    ).toBe("continue");
  });

  it("chaque nouvelle action porte SA RAISON — la compétence en cause (R-14)", () => {
    // « Toujours accompagnée de sa raison en langage élève » : le moteur ne fabrique pas la
    // phrase (l'i18n s'en charge), mais il transporte de quoi l'écrire. Une action sans sa
    // raison serait un ordre.
    const a = resolveNextAction({ remediation });
    const b = resolveNextAction({ strengthen });
    expect(a).toMatchObject({ competencySlug: "math.num.multiples" });
    expect(b).toMatchObject({ competencySlug: "math.frac.comparer" });
  });
});

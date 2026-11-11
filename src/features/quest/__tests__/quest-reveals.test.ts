// @vitest-environment node
import { describe, expect, it } from "vitest";
import { mergeRevealedAnswers, planResume } from "@/features/quest/quest-reveals";

// La triche au F5 (migration 20260929120000) : la réponse corrigée est figée au
// serveur. Ces deux fonctions ne décident rien — elles réunissent ce que le
// serveur a figé et ce que le lecteur tient, et c'est cette réunion qui est
// testée ici : la réponse figée gagne TOUJOURS.

const IDS = ["q1", "q2", "q3"];

describe("mergeRevealedAnswers", () => {
  it("lets the locked answer replace the one the player holds", () => {
    expect(
      mergeRevealedAnswers(
        [
          { questionId: "q1", choice: "a" },
          { questionId: "q2", choice: "a" },
        ],
        [{ questionId: "q1", choice: "b" }],
      ),
    ).toEqual([
      { questionId: "q1", choice: "b" },
      { questionId: "q2", choice: "a" },
    ]);
  });

  it("adds a locked answer the player never recorded (corrected, but not yet « Continuer »)", () => {
    expect(
      mergeRevealedAnswers(
        [{ questionId: "q1", choice: "a" }],
        [{ questionId: "q2", choice: "c" }],
      ),
    ).toEqual([
      { questionId: "q1", choice: "a" },
      { questionId: "q2", choice: "c" },
    ]);
  });

  it("leaves the answers untouched when nothing is locked", () => {
    const answers = [{ questionId: "q1", choice: "a" }];
    expect(mergeRevealedAnswers(answers, [])).toEqual(answers);
  });
});

describe("planResume", () => {
  it("has nothing to resume on a fresh run", () => {
    expect(planResume(IDS, [], [])).toBeNull();
  });

  it("resumes a plain draft exactly as before (no locked answer)", () => {
    expect(planResume(IDS, [{ questionId: "q1", choice: "a" }], [])).toEqual({
      answers: [{ questionId: "q1", choice: "a" }],
      idx: 1,
      selected: null,
    });
  });

  it("the F5 case: the corrected question is skipped, its locked answer kept", () => {
    // Brouillon : q1 donnée. q2 corrigée (fausse) puis F5 avant « Continuer ».
    expect(
      planResume(IDS, [{ questionId: "q1", choice: "a" }], [{ questionId: "q2", choice: "b" }]),
    ).toEqual({
      answers: [
        { questionId: "q1", choice: "a" },
        { questionId: "q2", choice: "b" },
      ],
      idx: 2,
      selected: null,
    });
  });

  it("the locked answer beats the draft's for the same question", () => {
    expect(
      planResume(IDS, [{ questionId: "q1", choice: "a" }], [{ questionId: "q1", choice: "d" }]),
    ).toMatchObject({ answers: [{ questionId: "q1", choice: "d" }], idx: 1 });
  });

  it("resumes from the locked answers alone when the draft is gone (other device, cleared storage)", () => {
    expect(planResume(IDS, [], [{ questionId: "q1", choice: "c" }])).toEqual({
      answers: [{ questionId: "q1", choice: "c" }],
      idx: 1,
      selected: null,
    });
  });

  it("every question locked: back on the last one, its locked answer preselected", () => {
    expect(
      planResume(
        IDS,
        [
          { questionId: "q1", choice: "a" },
          { questionId: "q2", choice: "a" },
        ],
        [{ questionId: "q3", choice: "b" }],
      ),
    ).toEqual({
      answers: [
        { questionId: "q1", choice: "a" },
        { questionId: "q2", choice: "a" },
      ],
      idx: 2,
      selected: "b",
    });
  });

  it("keeps the old rule: a draft complete on its own is a queued submission, not a run to reopen", () => {
    const complete = IDS.map((questionId) => ({ questionId, choice: "a" }));
    expect(planResume(IDS, complete, [{ questionId: "q1", choice: "b" }])).toBeNull();
  });
});

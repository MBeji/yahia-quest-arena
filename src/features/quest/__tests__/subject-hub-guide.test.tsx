import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";

const subject = {
  name_fr: "Mathématiques",
  attribute: "Logique",
  description: null,
  content_language: "fr",
};
const chapters = [{ id: "c1", title: "Les nombres", description: null }];
const exercises = [
  { id: "q1", chapter_id: "c1", mode: "quiz", title: "Quiz", difficulty: 1, xp_reward: 10 },
  { id: "m1", chapter_id: "c1", mode: "classic", title: "Compter", difficulty: 1, xp_reward: 20 },
];

/**
 * Guide intégré dans le hub matière : l'ordre « cours → quiz → missions » se
 * voit avant le premier cadenas, et une mission fermée dit pourquoi.
 */
describe("SubjectHub — guide intégré", () => {
  it("porte fermée : les 3 étapes, le cours en cours, la mission fermée explicable", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: false }}
        isAuthenticated={false}
      />,
    );
    const steps = screen.getByTestId("chapter-steps");
    expect(steps.querySelector('[aria-current="step"]')).toHaveTextContent("Cours");
    expect(screen.getByTestId("locked-mission-m1").tagName).toBe("BUTTON");
    // La bulle « ? » du quiz fermé, et celle du cours.
    expect(screen.getAllByTestId("help-tip").length).toBeGreaterThanOrEqual(2);
  });

  it("quiz réussi (grand livre) : les missions deviennent l'étape du moment", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true }}
        progress={{
          subjectId: "math",
          seals: [],
          nextSeal: null,
          effort: { missionsCounted: 0, xp: 0, chaptersStarted: 1, chaptersMastered: 0 },
          chapters: [
            {
              chapterId: "c1",
              star: 0,
              starLive: 0,
              mastered: false,
              isNew: false,
              newMissions: 0,
              quiz: { gated: true, cleared: true },
              rungs: [],
              family: { total: 0, counted: 0 },
            },
          ],
          missions: [],
        }}
        isAuthenticated
      />,
    );
    const steps = screen.getByTestId("chapter-steps");
    expect(steps.querySelector('[aria-current="step"]')).toHaveTextContent("Missions");
    expect(screen.queryByTestId("locked-mission-m1")).toBeNull();
  });

  it("sans porte (thème hors école, pré-ouvert par le serveur) : aucun parcours affiché", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true }}
        isAuthenticated={false}
      />,
    );
    expect(screen.queryByTestId("chapter-steps")).toBeNull();
  });
});

import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { frPublic } from "@/lib/i18n/fr-public";

const subject = {
  name_fr: "Mathématiques",
  attribute: "Logique",
  description: null,
  content_language: "fr",
};
const chapters = [{ id: "c1", title: "Les nombres", description: "Compter et comparer." }];
const exercises = [
  { id: "e1", chapter_id: "c1", mode: "quiz", title: "Quiz", difficulty: 1, xp_reward: 10 },
];

describe("SubjectHub — « Lire le cours »", () => {
  it("le chapitre ouvert s'ouvre sur un bouton de cours qui mène à sa leçon", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true }}
        isAuthenticated={false}
      />,
    );
    const cta = screen.getByTestId("read-course-c1");
    expect(cta.getAttribute("href")).toBe("/chapitre/$chapterId");
    expect(cta).toHaveTextContent(frPublic.subject.readCourse);
  });
});

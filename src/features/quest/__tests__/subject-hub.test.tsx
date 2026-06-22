import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { SubjectHub } from "../components/subject-hub";

const subject = {
  name_fr: "Mathématiques",
  attribute: "Logique",
  description: "Le calcul et les nombres.",
  content_language: "fr",
};
const chapters = [
  { id: "c1", title: "Les nombres", description: "Compter et comparer." },
  { id: "c2", title: "Les fractions", description: null },
];
const exercises = [
  {
    id: "e1",
    chapter_id: "c1",
    mode: "quiz",
    title: "Quiz : les nombres",
    difficulty: 1,
    xp_reward: 10,
  },
  {
    id: "e2",
    chapter_id: "c1",
    mode: "normal",
    title: "Additionner",
    difficulty: 2,
    xp_reward: 20,
  },
  { id: "e3", chapter_id: "c2", mode: "normal", title: "Un demi", difficulty: 1, xp_reward: 15 },
];

describe("SubjectHub", () => {
  it("renders the subject header and one card per chapter with a read-course link", () => {
    const { container } = render(
      <SubjectHub subject={subject} chapters={chapters} exercises={exercises} />,
    );
    expect(screen.getByRole("heading", { level: 1, name: "Mathématiques" })).toBeInTheDocument();
    expect(screen.getByText("Logique")).toBeInTheDocument();
    expect(screen.getAllByRole("heading", { level: 2 })).toHaveLength(2);
    // one "Lire le cours" → public reader per chapter
    expect(container.querySelectorAll('a[href="/chapitre/$chapterId"]')).toHaveLength(2);
  });

  it("lists each chapter's exercises under it, linking to the quest screen", () => {
    const { container } = render(
      <SubjectHub subject={subject} chapters={chapters} exercises={exercises} />,
    );
    expect(container.querySelectorAll('a[href="/quest/$exerciseId"]')).toHaveLength(3);
    expect(screen.getByText(/Quiz : les nombres/)).toBeInTheDocument();
    expect(screen.getByText(/Additionner/)).toBeInTheDocument();
  });

  it("renders an Arabic subject right-to-left", () => {
    const { container } = render(
      <SubjectHub
        subject={{ ...subject, name_fr: "الرياضيات", content_language: "ar" }}
        chapters={[{ id: "c1", title: "الأعداد", description: null }]}
        exercises={[]}
      />,
    );
    expect(container.querySelector('div[dir="rtl"]')).not.toBeNull();
  });
});

import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

// Stub TanStack Link → <a href={to}> so we can assert navigation targets without a router.
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { LessonReader, type LessonReaderChapter } from "../components/lesson-reader";

const chapter: LessonReaderChapter = {
  title: "Le présent : être et avoir",
  lesson_content: "## Section A\nLe verbe être.\n## Section B\nLe verbe avoir.",
  summary: "Résumé : être et avoir au présent.",
  subject_id: "francais-a1",
  subjects: { name_fr: "Français", content_language: "fr" },
};

const siblings = [
  { id: "c0", title: "Intro", hasLesson: true },
  { id: "c1", title: "Le présent : être et avoir", hasLesson: true },
  { id: "c2", title: "Le futur", hasLesson: true },
];

describe("LessonReader", () => {
  it("renders the title, the course body, prev/next links and the account invite", () => {
    const { container } = render(
      <LessonReader chapterId="c1" chapter={chapter} allChapters={siblings} />,
    );
    expect(
      screen.getByRole("heading", { level: 1, name: /Le présent : être et avoir/ }),
    ).toBeInTheDocument();
    const lesson = container.querySelector(".lesson-content");
    expect(lesson?.textContent).toContain("Section A");
    // prev (c0) + next (c2) both link to the public reader
    expect(container.querySelectorAll('a[href="/chapitre/$chapterId"]').length).toBe(2);
    // soft, non-blocking account invite → signup
    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
    expect(screen.getByText(/Apprends en jouant/)).toBeInTheDocument();
    // FR content reads LTR even though it may be viewed under an Arabic UI
    expect(container.querySelector('.lesson-content[dir="ltr"]')).not.toBeNull();
  });

  it("toggles between Cours and Résumé", () => {
    const { container } = render(
      <LessonReader chapterId="c1" chapter={chapter} allChapters={siblings} />,
    );
    expect(container.querySelector(".lesson-content")?.textContent).toContain("Section A");
    fireEvent.click(screen.getByRole("button", { name: "Résumé" }));
    expect(container.querySelector(".lesson-content")?.textContent).toContain(
      "Résumé : être et avoir",
    );
    expect(container.querySelector(".lesson-content")?.textContent).not.toContain("Section A");
  });

  it("omits prev on the first chapter and next on the last", () => {
    const first = render(<LessonReader chapterId="c0" chapter={chapter} allChapters={siblings} />);
    expect(first.container.querySelectorAll('a[href="/chapitre/$chapterId"]').length).toBe(1);
    first.unmount();
    const last = render(<LessonReader chapterId="c2" chapter={chapter} allChapters={siblings} />);
    expect(last.container.querySelectorAll('a[href="/chapitre/$chapterId"]').length).toBe(1);
  });

  it("shows the coming-soon state and no Cours/Résumé toggle when there is no content", () => {
    render(
      <LessonReader
        chapterId="c1"
        chapter={{ ...chapter, lesson_content: null, summary: null }}
        allChapters={siblings}
      />,
    );
    expect(screen.getByText(/arrive bientôt/)).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: "Résumé" })).toBeNull();
  });

  it("renders Arabic content right-to-left", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={{
          ...chapter,
          lesson_content: "## مقدمة\nالنص العربي.",
          summary: null,
          subjects: { name_fr: "العربية", content_language: "ar" },
        }}
        allChapters={siblings}
      />,
    );
    expect(container.querySelector('.lesson-content[dir="rtl"]')).not.toBeNull();
  });

  it("shows a practise CTA to the chapter exercise — anon → free practice", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={chapter}
        allChapters={siblings}
        practiceExerciseId="ex9"
        isAuthenticated={false}
      />,
    );
    expect(screen.getByText(/entraîner sur ce chapitre/i)).toBeInTheDocument();
    expect(container.querySelector('a[href="/exercice/$exerciseId"]')).not.toBeNull();
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).toBeNull();
  });

  it("routes the practise CTA to the scored quest when authenticated", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={chapter}
        allChapters={siblings}
        practiceExerciseId="ex9"
        isAuthenticated={true}
      />,
    );
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).not.toBeNull();
    expect(container.querySelector('a[href="/exercice/$exerciseId"]')).toBeNull();
  });

  it("omits the practise CTA when the chapter has nothing to practise", () => {
    render(
      <LessonReader
        chapterId="c1"
        chapter={chapter}
        allChapters={siblings}
        practiceExerciseId={null}
      />,
    );
    expect(screen.queryByText(/entraîner sur ce chapitre/i)).not.toBeInTheDocument();
  });
});

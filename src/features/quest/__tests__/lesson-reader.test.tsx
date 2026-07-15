import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

// Stub TanStack Link → <a href={to}> so we can assert navigation targets without a router.
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

// The « Pages du manuel » section self-fetches (useQuery + a gated server fn); stub it
// so the presentational reader can be tested without a QueryClient. It has its own
// test (manuel-pages-section.test.tsx).
vi.mock("../components/manuel-pages-section", () => ({ ManuelPagesSection: () => null }));

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

  it("links the subject name back to its matière hub (remontée hiérarchique)", () => {
    const { container } = render(
      <LessonReader chapterId="c1" chapter={chapter} allChapters={siblings} />,
    );
    const backLink = container.querySelector('a[href="/matiere/$subjectId"]');
    expect(backLink).not.toBeNull();
    expect(backLink?.textContent).toContain("Français");
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

  it("hides the account invite for signed-in readers (they HAVE an account)", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={chapter}
        allChapters={siblings}
        practiceExerciseId="ex9"
        isAuthenticated={true}
      />,
    );
    expect(screen.queryByText(/Apprends en jouant/)).not.toBeInTheDocument();
    expect(container.querySelector('a[href="/signup"]')).toBeNull();
  });

  it("routes the single CTA to the comprehension quiz while the gate is closed", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={chapter}
        allChapters={siblings}
        practiceExerciseId="ex9"
        quizCta={{ exerciseId: "quiz1" }}
        isAuthenticated={false}
      />,
    );
    // One CTA only, targeting the quiz — never a locked exercise.
    expect(screen.getByText(/Commencer par le quiz de compréhension/)).toBeInTheDocument();
    expect(screen.queryByText(/entraîner sur ce chapitre/i)).not.toBeInTheDocument();
    expect(container.querySelector('a[href="/exercice/$exerciseId"]')).not.toBeNull();
  });

  // ---- Sommaire & blocs pédagogiques (étude 18, lot 1) ----

  it("renders a table of contents from the lesson sections", () => {
    const { container } = render(
      <LessonReader chapterId="c1" chapter={chapter} allChapters={siblings} />,
    );
    const toc = container.querySelector('[data-testid="lesson-toc"]');
    expect(toc).not.toBeNull();
    expect(toc?.textContent).toContain("Section A");
    expect(toc?.textContent).toContain("Section B");
    // Les ancres ciblent les id que le renderer a toujours émis — et que rien n'utilisait.
    expect(toc?.querySelector('a[href="#section-0"]')).not.toBeNull();
    expect(toc?.querySelector('a[href="#section-1"]')).not.toBeNull();
  });

  it("hides the table of contents on the summary tab and below two sections", () => {
    const { container, unmount } = render(
      <LessonReader chapterId="c1" chapter={chapter} allChapters={siblings} />,
    );
    fireEvent.click(screen.getByRole("button", { name: "Résumé" }));
    expect(container.querySelector('[data-testid="lesson-toc"]')).toBeNull();
    unmount();

    // Un sommaire d'une seule entrée est du bruit.
    const single = render(
      <LessonReader
        chapterId="c1"
        chapter={{ ...chapter, lesson_content: "## Seule section\nDu texte." }}
        allChapters={siblings}
      />,
    );
    expect(single.container.querySelector('[data-testid="lesson-toc"]')).toBeNull();
  });

  it("promotes the callouts already written in the content into typed blocks", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={{
          ...chapter,
          lesson_content: "## Thalès\n\n> ⚠️ MN/BC ne vaut pas AM/MB.\n\n> 🗡️ Écris les rapports.",
        }}
        allChapters={siblings}
      />,
    );
    expect(container.querySelector(".lesson-blk--piege")).not.toBeNull();
    expect(container.querySelector(".lesson-blk--astuce")).not.toBeNull();
    // Le libellé suit la langue du CONTENU (fr ici), pas la locale de l'interface.
    expect(container.querySelector(".lesson-blk--piege")?.textContent).toContain("Piège");
  });

  it("renders the summary tab as a deck of revision cards, the course as blocks (US-6)", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={{
          ...chapter,
          lesson_content: "## Thalès\n\n> ⚠️ Un piège.",
          summary: "- **La formule**: AM/AB = AN/AC\n- ⚠️ **Le piège**: MN/BC ≠ AM/MB",
        }}
        allChapters={siblings}
      />,
    );

    // Onglet Cours : des blocs, pas des cartes.
    expect(container.querySelector(".lesson-blk--piege")).not.toBeNull();
    expect(container.querySelector(".lesson-cards")).toBeNull();

    fireEvent.click(screen.getByRole("button", { name: "Résumé" }));

    // Onglet Résumé : un paquet de cartes — dont une carte-piège typée.
    expect(container.querySelector(".lesson-cards")).not.toBeNull();
    expect(container.querySelectorAll(".lesson-card").length).toBe(2);
    expect(container.querySelector(".lesson-card--piege")).not.toBeNull();
    expect(container.querySelector(".lesson-card__title")?.textContent).toBe("La formule");
  });

  it("opens a figure in a zoom dialog on click and on keyboard (US-3)", () => {
    const svg = '<svg viewBox="0 0 10 10"><circle cx="5" cy="5" r="4"/></svg>';
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={{
          ...chapter,
          lesson_content: `## Thalès\n\n::: figure Le triangle ABC\n${svg}\n:::`,
          summary: null,
        }}
        allChapters={siblings}
      />,
    );

    const figure = container.querySelector(".lesson-figure");
    expect(figure).not.toBeNull();
    expect(screen.queryByTestId("lesson-figure-zoom")).toBeNull();

    fireEvent.click(figure as Element);
    const dialog = screen.getByTestId("lesson-figure-zoom");
    expect(dialog).toBeInTheDocument();
    expect(dialog.querySelector("svg")).not.toBeNull();
    // La légende sert de titre accessible au dialogue.
    expect(dialog.textContent).toContain("Le triangle ABC");

    fireEvent.keyDown(document, { key: "Escape" });
  });

  it("labels the blocks in the content language for an Arabic lesson (R-8)", () => {
    const { container } = render(
      <LessonReader
        chapterId="c1"
        chapter={{
          ...chapter,
          lesson_content: "## مقدمة\n\n> ⚠️ انتبه إلى النسب.",
          summary: null,
          subjects: { name_fr: "الرياضيات", content_language: "ar" },
        }}
        allChapters={siblings}
      />,
    );
    expect(container.querySelector(".lesson-blk--piege")?.textContent).toContain("تحذير");
    expect(container.querySelector(".lesson-blk--piege")?.textContent).not.toContain("Piège");
  });
});

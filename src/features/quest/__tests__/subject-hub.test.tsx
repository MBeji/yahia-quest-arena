import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";

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
const parcours = { id: "ecole-3eme-base", name_fr: "3ème année de base" };
/** Expand every collapsed chapter (idempotent — the default already opens one). */
function expandAll(container: HTMLElement) {
  for (const btn of Array.from(container.querySelectorAll('button[aria-expanded="false"]'))) {
    fireEvent.click(btn);
  }
}

beforeEach(() => sessionStorage.clear());

describe("SubjectHub", () => {
  it("renders the level anchor (kicker + back link) instead of the RPG attribute", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        parcours={parcours}
        isAuthenticated={false}
      />,
    );
    expect(screen.getByRole("heading", { level: 1, name: "Mathématiques" })).toBeInTheDocument();
    // Kicker + breadcrumb = the CLASS; the RPG attribute is gone (audit §D-3).
    expect(screen.getAllByText("3ème année de base").length).toBeGreaterThanOrEqual(2);
    expect(screen.queryByText("Logique")).not.toBeInTheDocument();
    expect(container.querySelector('a[href="/niveau/$parcoursId"]')).not.toBeNull();
  });

  it("anonymous: every unlocked exercise links to public practice — quiz included", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        // Both chapters unlocked (non-school semantics: server pre-marks true).
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={false}
      />,
    );
    expandAll(container);
    expect(container.querySelectorAll('a[href="/exercice/$exerciseId"]').length).toBe(3);
    expect(container.querySelectorAll('a[href="/quest/$exerciseId"]').length).toBe(0);
  });

  it("authenticated: every unlocked exercise links to the scored quest (XP shown)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={true}
      />,
    );
    expandAll(container);
    // Row links only (the « Reprendre » band adds its own quest link on top).
    expect(container.querySelectorAll('ul a[href="/quest/$exerciseId"]').length).toBe(3);
    expect(container.querySelectorAll('a[href="/exercice/$exerciseId"]').length).toBe(0);
    // Signed-in todo rows advertise their XP (R-4)…
    expect(screen.getByText(/\+20 XP/)).toBeInTheDocument();
  });

  it("anonymous: XP chips are hidden (audit §D-3 — noise for visitors who can't earn them)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={false}
      />,
    );
    expandAll(container);
    expect(screen.queryByText(/\+20 XP/)).not.toBeInTheDocument();
  });

  it("locked chapter: non-quiz rows are inert, the quiz stays clickable and the contract is said", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        // c1 gated & not passed; c2 open.
        quizPassedByChapter={{ c1: false, c2: true }}
        isAuthenticated={false}
      />,
    );
    expandAll(container);
    // c1: only the quiz link remains (e2 is locked); c2: e3 links. → 2 links total.
    expect(container.querySelectorAll('a[href="/exercice/$exerciseId"]').length).toBe(2);
    expect(screen.getByText(/quiz à passer/i)).toBeInTheDocument();
    expect(screen.getByText(/déverrouille le chapitre/i)).toBeInTheDocument();
    // The contract interpolates the REAL threshold constant — never a hard-coded pct.
    expect(
      screen.getByText(new RegExp(`Réussis le quiz \\(≥ ${QUIZ_PASS_THRESHOLD_PCT} %\\)`)),
    ).toBeInTheDocument();
  });

  it("signed-in progress: done rows show their best score and the chapter chip counts them", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        bestByExercise={{ e1: 92, e2: 85 }}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={true}
      />,
    );
    // c1 fully done → chip "2/2 ✓" on its header (visible even collapsed).
    expect(screen.getByText("2/2 ✓")).toBeInTheDocument();
    expandAll(container);
    expect(screen.getByText("92%")).toBeInTheDocument();
  });

  it("« Reprendre ici » targets the in-progress chapter's next mission (signed-in only)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        bestByExercise={{ e1: 92 }}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={true}
      />,
    );
    const resume = container.querySelector('[data-testid="hub-resume"]');
    expect(resume).not.toBeNull();
    expect(screen.getByText("Reprendre ici")).toBeInTheDocument();
    expect(screen.getByText(/1\/2 missions/)).toBeInTheDocument();
  });

  it("anonymous: no resume band", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        bestByExercise={{ e1: 92 }}
        isAuthenticated={false}
      />,
    );
    expect(container.querySelector('[data-testid="hub-resume"]')).toBeNull();
  });

  it("renders an Arabic subject right-to-left", () => {
    const { container } = render(
      <SubjectHub
        subject={{ ...subject, name_fr: "الرياضيات", content_language: "ar" }}
        chapters={[{ id: "c1", title: "الأعداد", description: null }]}
        exercises={[]}
        isAuthenticated={false}
      />,
    );
    expect(container.querySelector('div[dir="rtl"]')).not.toBeNull();
  });
});

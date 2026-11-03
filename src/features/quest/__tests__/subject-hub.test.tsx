import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { frPublic } from "@/lib/i18n/fr-public";
import {
  chapters,
  exercises,
  expandAll,
  parcours,
  progressOf,
  subject,
} from "./subject-hub-fixtures";

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
        progress={progressOf({
          chapters: {
            c1: { star: 4, quizCleared: true, rungs: [{ difficulty: 2, total: 1, counted: 1 }] },
            c2: { star: 0, quizCleared: true, rungs: [{ difficulty: 1, total: 1, counted: 0 }] },
          },
          missions: { e2: { counted: true, bestClassic: 85 }, e3: { chapterId: "c2" } },
        })}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={true}
      />,
    );
    // c1 à l'étoile 4 AU GRAND LIVRE → « Maîtrisé ✓ », le seul mot de verdict (R-5, Q-2).
    expect(screen.getByTestId("chapter-mastered")).toHaveTextContent("Maîtrisé ✓");
    expandAll(container);
    expect(screen.getByText("85%")).toBeInTheDocument();
  });

  it("« Reprendre ici » targets the in-progress chapter's next mission (signed-in only)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf({
          chapters: {
            c1: { star: 0, quizCleared: true, rungs: [{ difficulty: 2, total: 1, counted: 0 }] },
            c2: { star: 0, quizCleared: false, rungs: [{ difficulty: 1, total: 1, counted: 0 }] },
          },
          missions: { e2: {}, e3: { chapterId: "c2" } },
        })}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={true}
      />,
    );
    const resume = container.querySelector('[data-testid="hub-resume"]');
    expect(resume).not.toBeNull();
    expect(screen.getByText("Reprendre ici")).toBeInTheDocument();
    // R-15 : le quiz n'est PAS une mission. c1 porte une seule mission de catalogue (e2), pas
    // encore réussie — donc 0/1, là où l'ancien compteur annonçait « 1/2 » en comptant le quiz.
    expect(screen.getByText(/0\/1 missions/)).toBeInTheDocument();
  });

  it("counts only catalogue missions passed at >= 60% (R-14/R-15)", () => {
    const withParent = [
      ...exercises,
      // Une mission familiale sur c1 : hors catalogue, elle ne doit peser sur aucun compteur.
      {
        id: "p1",
        chapter_id: "c1",
        mode: "normal",
        title: "Devoir de maman",
        difficulty: 1,
        xp_reward: 5,
        source: "parent",
      },
    ];
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={withParent}
        // e2 tentée mais ratée (30 %) : « tentée » ne vaut pas « comptée ». p1 est
        // une mission de la FAMILLE, réussie à 100 % : elle ne pèse sur aucune étoile.
        progress={progressOf({
          chapters: {
            c1: {
              star: 0,
              quizCleared: true,
              rungs: [{ difficulty: 2, total: 1, counted: 0 }],
              family: { total: 1, counted: 1 },
            },
            c2: { star: 0, quizCleared: true, rungs: [{ difficulty: 1, total: 1, counted: 0 }] },
          },
          missions: {
            e2: { bestClassic: 30 },
            e3: { chapterId: "c2" },
            p1: { source: "parent", counted: true, bestClassic: 100 },
          },
        })}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated={true}
      />,
    );
    expect(screen.getByText(/0\/1 missions/)).toBeInTheDocument();
    expect(screen.queryByTestId("chapter-mastered")).not.toBeInTheDocument();
    // US-6 : la famille a sa propre ligne, et la ligne dit pourquoi elle est à part.
    expect(screen.getByTestId("chapter-family")).toHaveTextContent("Missions de la famille 1/1");
  });

  it("anonymous: no resume band", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        isAuthenticated={false}
      />,
    );
    expect(container.querySelector('[data-testid="hub-resume"]')).toBeNull();
  });

  it("accès de test (admin) : le bandeau dit pourquoi tout est ouvert — absent pour un compte ordinaire", () => {
    const { rerender } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated
        unrestricted
      />,
    );
    expect(screen.getByTestId("hub-unrestricted")).toHaveTextContent(
      frPublic.subject.unrestrictedBanner,
    );
    rerender(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={{ c1: true, c2: true }}
        isAuthenticated
      />,
    );
    expect(screen.queryByTestId("hub-unrestricted")).not.toBeInTheDocument();
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

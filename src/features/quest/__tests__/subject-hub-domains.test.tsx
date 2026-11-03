import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { fr } from "@/lib/i18n/fr";
import { chapters, exercises, expandAll, progressOf, subject } from "./subject-hub-fixtures";

beforeEach(() => sessionStorage.clear());

/**
 * Domaines de programme — les « sections » d'une matière (Algèbre / Géométrie,
 * قواعد اللغة / فهم المقروء). Le hub ne les invente pas : il lit `chapters.domain`
 * et retombe sur sa liste plate dès qu'il n'y a pas deux groupes à montrer.
 */
describe("SubjectHub — domaines de programme", () => {
  /**
   * Les en-têtes des GROUPES, et eux seuls. La page porte d'autres `h2` — le bloc
   * des sceaux depuis l'étude 34 — et la question posée ici est celle du
   * regroupement des chapitres, pas celle du plan de titres de la page.
   */
  const groupHeadings = () =>
    screen.queryAllByTestId("domain-group").map((g) => g.querySelector("h2")?.textContent ?? null);

  const sectioned = [
    { id: "c1", title: "Les nombres", description: null, domain: "Algèbre" },
    { id: "c2", title: "Thalès", description: null, domain: "Géométrie" },
    { id: "c3", title: "Les fractions", description: null, domain: "Algèbre" },
  ];

  it("pose un en-tête par domaine, dans l'ordre du programme", () => {
    render(
      <SubjectHub subject={subject} chapters={sectioned} exercises={[]} isAuthenticated={false} />,
    );
    expect(groupHeadings()).toEqual(["Algèbre", "Géométrie"]);
  });

  it("range chaque chapitre sous son domaine", () => {
    render(
      <SubjectHub subject={subject} chapters={sectioned} exercises={[]} isAuthenticated={false} />,
    );
    const groups = screen.getAllByTestId("domain-group");
    expect(groups[0]?.textContent).toContain("Les nombres");
    expect(groups[0]?.textContent).toContain("Les fractions");
    expect(groups[0]?.textContent).not.toContain("Thalès");
    expect(groups[1]?.textContent).toContain("Thalès");
  });

  it("compte les chapitres terminés du domaine, pas ses missions", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={sectioned}
        exercises={[
          { id: "e1", chapter_id: "c1", mode: "normal", title: "M1", difficulty: 1, xp_reward: 10 },
          { id: "e2", chapter_id: "c3", mode: "normal", title: "M2", difficulty: 1, xp_reward: 10 },
        ]}
        // c1 maîtrisé, c3 raté : 1 chapitre sur 2 pour Algèbre.
        progress={progressOf({
          chapters: {
            c1: { star: 4, quizCleared: true, rungs: [{ difficulty: 1, total: 1, counted: 1 }] },
            c3: { star: 0, quizCleared: true, rungs: [{ difficulty: 1, total: 1, counted: 0 }] },
          },
          missions: {
            e1: { counted: true, bestClassic: 100 },
            e2: { chapterId: "c3", bestClassic: 20 },
          },
        })}
        quizPassedByChapter={{ c1: true, c3: true }}
        isAuthenticated={true}
      />,
    );
    expect(screen.getByText("1/2 chapitres")).toBeInTheDocument();
    expect(screen.getByText("0/1 chapitres")).toBeInTheDocument();
  });

  it("regroupe les chapitres sans domaine sous « Autres chapitres »", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={[
          { id: "c1", title: "Les nombres", description: null, domain: "Algèbre" },
          { id: "c2", title: "Divers", description: null },
        ]}
        exercises={[]}
        isAuthenticated={false}
      />,
    );
    expect(groupHeadings()).toEqual(["Algèbre", fr.public.subject.otherChapters]);
  });

  it("garde la liste plate quand aucun chapitre n'est rattaché", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        isAuthenticated={false}
      />,
    );
    expect(screen.queryAllByTestId("domain-group")).toHaveLength(0);
    expect(groupHeadings()).toHaveLength(0);
    // Les chapitres restent affichés — la bascule ne coûte rien à une matière
    // que le contenu n'a pas encore sectionnée.
    expect(screen.getByText("Les nombres")).toBeInTheDocument();
    expect(screen.getByText("Les fractions")).toBeInTheDocument();
  });

  it("garde la liste plate quand un domaine unique couvre toute la matière", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={[
          { id: "c1", title: "Les nombres", description: null, domain: "Algèbre" },
          { id: "c2", title: "Les fractions", description: null, domain: "Algèbre" },
        ]}
        exercises={[]}
        isAuthenticated={false}
      />,
    );
    expect(screen.queryAllByTestId("domain-group")).toHaveLength(0);
  });

  it("les chapitres restent dépliables une fois groupés", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={sectioned}
        exercises={[
          {
            id: "e1",
            chapter_id: "c2",
            mode: "normal",
            title: "Config",
            difficulty: 1,
            xp_reward: 10,
          },
        ]}
        quizPassedByChapter={{ c2: true }}
        isAuthenticated={false}
      />,
    );
    expandAll(container);
    expect(screen.getByText("Config")).toBeInTheDocument();
  });
});

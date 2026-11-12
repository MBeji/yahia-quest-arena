import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  // `BackLink` se construit avec `createLink` : il rend l'ancre qu'on lui passe.
  createLink:
    (Comp: React.ElementType) =>
    ({ to, params: _params, ...rest }: { to: string; params?: unknown }) =>
      React.createElement(Comp, { ...rest, href: to }),
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { chapters, exercises, expandAll, progressOf, subject } from "./subject-hub-fixtures";

beforeEach(() => sessionStorage.clear());

/**
 * ÉTOILES DE CHAPITRE & SCEAUX DE MATIÈRE — étude 34, lot 2.
 *
 * Ces cas disent ce que le hub PROMET : rien ne recule quand le contenu grandit,
 * l'écart est nommé plutôt que tu, et l'anonyme voit la forme sans qu'on calcule
 * quoi que ce soit pour lui.
 */
describe("SubjectHub — étoiles et sceaux (é34)", () => {
  const open = { c1: true, c2: true };

  it("US-1 : le contenu grandit, le verdict ne recule pas — et la ✨ dit pourquoi", () => {
    // Le chapitre était maîtrisé (étoile 4 au grand livre) ; une campagne vient
    // d'ajouter une mission ⭐⭐. Le VIVANT est retombé à 1 ; l'acquis, lui, tient.
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf({
          chapters: {
            c1: {
              star: 4,
              starLive: 1,
              quizCleared: true,
              rungs: [{ difficulty: 2, total: 2, counted: 1, new: 1 }],
            },
            c2: { star: 0, quizCleared: true, rungs: [{ difficulty: 1, total: 1, counted: 0 }] },
          },
          missions: { e2: { counted: true, bestClassic: 85 }, e3: { chapterId: "c2" } },
        })}
        quizPassedByChapter={open}
        isAuthenticated
      />,
    );
    expect(screen.getByTestId("chapter-mastered")).toHaveTextContent("Maîtrisé ✓");
    expect(screen.getByTestId("chapter-mastered")).toHaveTextContent("✨ 1");
    expandAll(container);
    expect(screen.getByTestId("chapter-new-missions")).toHaveTextContent("✨ 1");
  });

  it("R-3 : une réussite précipitée montre son score SANS cocher la mission", () => {
    // C'est la divergence que le lot supprime : le hub cochait à ≥ 60 % alors que
    // le serveur exigeait en plus « non précipitée ». Il lit désormais `counted`.
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf({
          chapters: {
            c1: { star: 0, quizCleared: true, rungs: [{ difficulty: 2, total: 1, counted: 0 }] },
            c2: { star: 0, quizCleared: true, rungs: [{ difficulty: 1, total: 1, counted: 0 }] },
          },
          missions: { e2: { counted: false, bestClassic: 65 }, e3: { chapterId: "c2" } },
        })}
        quizPassedByChapter={open}
        isAuthenticated
      />,
    );
    expandAll(container);
    expect(screen.getByText("65%")).toBeInTheDocument();
    // Aucun cran gagné : la jauge de c1 reste à zéro allumé.
    const gauges = screen.getAllByTestId("star-rung-2");
    expect(gauges.some((g) => g.getAttribute("data-lit") === "true")).toBe(false);
  });

  it("R-9 : le sceau acquis, le prochain, et ce qui l'a fait bouger", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf({
          seals: [{ star: 1, reachedAt: "2026-09-01T10:00:00.000Z" }],
          nextSeal: { star: 2, chaptersReady: 12, chaptersTotal: 20, newChapters: 1 },
          effort: { missionsCounted: 26, xp: 1540, chaptersStarted: 12, chaptersMastered: 0 },
          chapters: { c1: { star: 1, quizCleared: true } },
        })}
        quizPassedByChapter={open}
        isAuthenticated
      />,
    );
    expect(screen.getByTestId("seal-current")).toHaveTextContent("Sceau ⭐");
    // La SEULE fraction de l'étude, et elle nomme ce qui l'a fait bouger.
    expect(screen.getByTestId("seal-next")).toHaveTextContent(
      "Prochain sceau ⭐⭐ : 12/20 chapitres prêts, dont 1 nouveaux",
    );
    // R-10 : des compteurs qui montent, jamais un pourcentage.
    const effort = screen.getByTestId("subject-effort");
    expect(effort).toHaveTextContent("26 missions réussies");
    expect(effort).toHaveTextContent("1540 XP");
    expect(effort.textContent).not.toMatch(/%/);
  });

  it("US-2 : sans aucun sceau, l'élève lit ce qu'il a — jamais « 0 % »", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf({
          nextSeal: { star: 1, chaptersReady: 12, chaptersTotal: 20, newChapters: 0 },
          effort: { missionsCounted: 26, xp: 1540, chaptersStarted: 12, chaptersMastered: 0 },
          chapters: { c1: { star: 0, quizCleared: true } },
        })}
        quizPassedByChapter={open}
        isAuthenticated
      />,
    );
    expect(screen.getByTestId("seal-none")).toBeInTheDocument();
    expect(screen.getByTestId("seal-next")).toHaveTextContent("12/20 chapitres prêts");
    // Un « 0 % » ISOLÉ : la carte de première visite du guide cite le seuil du
    // quiz (« 80 % »), qui n'est pas un score de l'élève.
    expect(container.textContent).not.toMatch(/(?<!\d)0\s*%/);
  });

  it("US-8 : l'anonyme voit la FORME et une promesse — aucun chiffre calculé", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={open}
        isAuthenticated={false}
      />,
    );
    expect(screen.getByTestId("seal-anon-promise")).toHaveTextContent(
      "Connecte-toi pour garder tes étoiles",
    );
    // Les quatre cachets sont là, tous en attente.
    const seals = screen.getAllByTestId("seal-mark");
    expect(seals).toHaveLength(4);
    expect(seals.every((s) => s.getAttribute("data-earned") === "false")).toBe(true);
    // Les jauges existent (la forme du chapitre) mais aucun cran n'est allumé…
    const rungs = container.querySelectorAll('[data-testid^="star-rung-"]');
    expect(rungs.length).toBeGreaterThan(0);
    expect([...rungs].every((r) => r.getAttribute("data-lit") === "false")).toBe(true);
    // …et rien d'un compte : ni effort, ni note de chapitre.
    expect(screen.queryByTestId("subject-effort")).not.toBeInTheDocument();
    expect(screen.queryByTestId("chapter-stars-note")).not.toBeInTheDocument();
  });

  it("R-7 : un chapitre arrivé après la dernière étoile se signale", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf({
          chapters: {
            c1: { star: 4, quizCleared: true, rungs: [{ difficulty: 2, total: 1, counted: 1 }] },
            c2: {
              star: 0,
              isNew: true,
              quizCleared: false,
              rungs: [{ difficulty: 1, total: 1, counted: 0, new: 1 }],
            },
          },
          missions: {
            e2: { counted: true, bestClassic: 85 },
            e3: { chapterId: "c2", isNew: true },
          },
        })}
        quizPassedByChapter={open}
        isAuthenticated
      />,
    );
    expect(screen.getByTestId("chapter-new")).toHaveTextContent("✨ Nouveau chapitre");
  });

  it("R-8 : la légende nomme le geste qui donne le prochain cran", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={[chapters[0]!]}
        exercises={exercises}
        progress={progressOf({
          chapters: {
            c1: {
              star: 1,
              quizCleared: true,
              rungs: [
                { difficulty: 1, total: 1, counted: 1 },
                { difficulty: 3, total: 2, counted: 0 },
              ],
            },
          },
          missions: { e2: {} },
        })}
        quizPassedByChapter={open}
        isAuthenticated
      />,
    );
    expandAll(container);
    // Le cran suivant est le 3 — « boss », le nom de l'échelle du CONTENU.
    expect(screen.getByTestId("chapter-stars-note")).toHaveTextContent(
      "Gagne l'étoile 3 en réussissant toutes les missions jusqu'à boss.",
    );
    // …et ce que « comptée » veut dire, en une phrase d'élève.
    expect(screen.getByTestId("chapter-stars-note")).toHaveTextContent(
      "Une mission compte à partir de 60 %, en prenant ton temps.",
    );
  });

  it("un quiz franchi est coché, et cesse d'annoncer ses XP", () => {
    // La charge du serveur ne porte que les missions : sans verdict propre, la
    // ligne du quiz se serait remise à promettre ses XP comme s'il restait à faire.
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={[chapters[0]!]}
        exercises={exercises}
        progress={progressOf({
          chapters: {
            c1: { star: 1, quizCleared: true, rungs: [{ difficulty: 2, total: 1, counted: 1 }] },
          },
          missions: { e2: { counted: true, bestClassic: 90 } },
        })}
        quizPassedByChapter={{ c1: true }}
        isAuthenticated
      />,
    );
    expandAll(container);
    expect(screen.queryByText(/\+10 XP/)).not.toBeInTheDocument();
  });
});

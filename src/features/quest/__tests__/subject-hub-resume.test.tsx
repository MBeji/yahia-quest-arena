import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

// Same router shim as subject-hub.test.tsx: the hub only needs <Link> to render an <a>.
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";

/**
 * « REPRENDRE ICI » ET L'ACCORDÉON OUVERT — le chapitre que le hub ouvre est celui où
 * l'élève a laissé son travail (é22 R-31), et cette décision se lit dans l'attribut
 * `aria-expanded` de l'en-tête de chapitre. Ce fichier est né d'une régression que seul
 * le nightly a vue (#1047, quatre nuits) : depuis é34 lot 2 le hub lisait `quiz.cleared`
 * comme « quiz tenté », or `cleared` vaut AUSSI « non gaté » — la définition même de
 * `chapter_quiz_cleared`. Hors école, chaque chapitre à quiz était donc « commencé »
 * d'office, et le résolveur, qui cherche le DERNIER chapitre commencé, ouvrait le dernier
 * de la matière. Vécu sur `anglais-a1` : mission maîtrisée au chapitre 4 sur 5, hub ouvert
 * sur le 5, ligne de rappel repliée avec le 4.
 *
 * Fichier à part parce que `subject-hub.test.tsx` est à son plafond de lignes — pas
 * parce que le sujet serait à part : c'est le même hub, la même charge.
 */
const subject = {
  name_fr: "English — Beginner (A1)",
  attribute: "Agilité",
  description: "Une matière hors école : aucune porte de quiz.",
  content_language: "en",
};

const chapters = [
  { id: "k1", title: "Premier", description: null },
  { id: "k2", title: "Deuxième", description: null },
  { id: "k3", title: "Troisième", description: null },
];

const mission = (id: string, chapter_id: string, difficulty: number) => ({
  id,
  chapter_id,
  mode: "normal",
  title: `Mission ${id}`,
  difficulty,
  xp_reward: 20,
});
const quiz = (id: string, chapter_id: string) => ({
  id,
  chapter_id,
  mode: "quiz",
  title: `Quiz ${id}`,
  difficulty: 1,
  xp_reward: 10,
});
const exercises = [
  quiz("q1", "k1"),
  mission("m1", "k1", 1),
  mission("m1b", "k1", 2),
  quiz("q2", "k2"),
  mission("m2", "k2", 1),
  mission("m2b", "k2", 2),
  quiz("q3", "k3"),
  mission("m3", "k3", 1),
];

type ChapterSpec = { star?: number; gated: boolean; cleared: boolean; counted?: number };
type MissionSpec = { chapterId: string; counted?: boolean; bestClassic?: number | null };

/** A `get_subject_progress` payload in the RPC's exact shape (pgTAP 101 checks it). */
function progressOf(
  chapterSpecs: Record<string, ChapterSpec>,
  missionSpecs: Record<string, MissionSpec>,
) {
  return {
    subjectId: "anglais-a1",
    seals: [],
    nextSeal: null,
    effort: { missionsCounted: 0, xp: 0, chaptersStarted: 0, chaptersMastered: 0 },
    chapters: Object.entries(chapterSpecs).map(([chapterId, c]) => ({
      chapterId,
      star: c.star ?? 0,
      starLive: c.star ?? 0,
      mastered: false,
      isNew: false,
      newMissions: 0,
      quiz: { gated: c.gated, cleared: c.cleared },
      rungs: [{ difficulty: 1, total: 1, counted: c.counted ?? 0, new: 0 }],
      family: { total: 0, counted: 0 },
    })),
    missions: Object.entries(missionSpecs).map(([exerciseId, m]) => ({
      exerciseId,
      chapterId: m.chapterId,
      source: "admin",
      counted: m.counted ?? false,
      bestClassic: m.bestClassic ?? null,
      mastered: (m.bestClassic ?? 0) >= 100,
      isNew: false,
    })),
  };
}

const expanded = (id: string) =>
  screen.getByTestId(`chapter-toggle-${id}`).getAttribute("aria-expanded");

describe("SubjectHub — « Reprendre ici » sur une matière hors école (#1047)", () => {
  // Hors école : la porte n'existe pas, donc `cleared` est vrai d'office sur les trois.
  const noGate = { gated: false, cleared: true };

  it("ouvre le chapitre où l'élève a travaillé, pas le dernier de la matière", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf(
          { k1: noGate, k2: { ...noGate, star: 1, counted: 1 }, k3: noGate },
          {
            m1: { chapterId: "k1" },
            m1b: { chapterId: "k1" },
            m2: { chapterId: "k2", counted: true, bestClassic: 100 },
            m2b: { chapterId: "k2" },
            m3: { chapterId: "k3" },
          },
        )}
        quizPassedByChapter={{ k1: true, k2: true, k3: true }}
        isAuthenticated
      />,
    );
    expect(expanded("k2")).toBe("true");
    expect(expanded("k1")).toBe("false");
    expect(expanded("k3")).toBe("false");
  });

  it("un quiz franchi derrière une VRAIE porte reste du travail commencé", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf(
          {
            k1: { gated: true, cleared: false },
            k2: { gated: true, cleared: true },
            k3: { gated: true, cleared: false },
          },
          {
            m1: { chapterId: "k1" },
            m1b: { chapterId: "k1" },
            m2: { chapterId: "k2" },
            m2b: { chapterId: "k2" },
            m3: { chapterId: "k3" },
          },
        )}
        quizPassedByChapter={{ k1: false, k2: true, k3: false }}
        isAuthenticated
      />,
    );
    expect(expanded("k2")).toBe("true");
    expect(expanded("k3")).toBe("false");
  });

  it("sans rien de commencé, le premier chapitre s'ouvre — comme avant é34", () => {
    render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        progress={progressOf(
          { k1: noGate, k2: noGate, k3: noGate },
          { m1: { chapterId: "k1" }, m2: { chapterId: "k2" }, m3: { chapterId: "k3" } },
        )}
        quizPassedByChapter={{ k1: true, k2: true, k3: true }}
        isAuthenticated
      />,
    );
    expect(expanded("k1")).toBe("true");
    expect(expanded("k3")).toBe("false");
  });
});

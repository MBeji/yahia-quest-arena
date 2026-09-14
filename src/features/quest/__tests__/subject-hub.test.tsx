import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...rest }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...("data-testid" in rest ? rest : {}) }, children),
}));

import { SubjectHub } from "../components/subject-hub";
import { QUIZ_PASS_THRESHOLD_PCT } from "@/shared/constants/gamification";
import { fr } from "@/lib/i18n/fr";
import { frPublic } from "@/lib/i18n/fr-public";

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

/**
 * Une charge `get_subject_progress` à la forme EXACTE de la RPC (étude 34) — la
 * même que celle dont pgTAP 101 vérifie la structure. Les décors parlent donc en
 * étoiles et en missions comptées, comme le produit, et non plus en « meilleurs
 * scores » que le hub re-seuillerait : c'est tout l'objet du lot.
 */
type ChapterSpec = {
  star?: number;
  starLive?: number;
  quizCleared?: boolean;
  quizGated?: boolean;
  isNew?: boolean;
  family?: { total: number; counted: number };
  rungs?: { difficulty: number; total: number; counted: number; new?: number }[];
};
type MissionSpec = {
  chapterId?: string;
  source?: string;
  counted?: boolean;
  bestClassic?: number | null;
  isNew?: boolean;
};
function progressOf({
  chapters: chapterSpecs = {},
  missions: missionSpecs = {},
  seals = [],
  nextSeal = null,
  effort = {},
}: {
  chapters?: Record<string, ChapterSpec>;
  missions?: Record<string, MissionSpec>;
  seals?: { star: number; reachedAt: string }[];
  nextSeal?: {
    star: number;
    chaptersReady: number;
    chaptersTotal: number;
    newChapters: number;
  } | null;
  effort?: Partial<{
    missionsCounted: number;
    xp: number;
    chaptersStarted: number;
    chaptersMastered: number;
  }>;
}) {
  return {
    subjectId: "math",
    seals,
    nextSeal,
    effort: {
      missionsCounted: 0,
      xp: 0,
      chaptersStarted: 0,
      chaptersMastered: 0,
      ...effort,
    },
    chapters: Object.entries(chapterSpecs).map(([chapterId, c]) => ({
      chapterId,
      star: c.star ?? 0,
      starLive: c.starLive ?? c.star ?? 0,
      mastered: (c.star ?? 0) >= 4,
      isNew: c.isNew ?? false,
      newMissions: (c.rungs ?? []).reduce((n, r) => n + (r.new ?? 0), 0),
      quiz: { gated: c.quizGated ?? true, cleared: c.quizCleared ?? false },
      rungs: (c.rungs ?? []).map((r) => ({ ...r, new: r.new ?? 0 })),
      family: c.family ?? { total: 0, counted: 0 },
    })),
    missions: Object.entries(missionSpecs).map(([exerciseId, m]) => ({
      exerciseId,
      chapterId: m.chapterId ?? "c1",
      source: m.source ?? "admin",
      counted: m.counted ?? false,
      bestClassic: m.bestClassic ?? null,
      mastered: (m.bestClassic ?? 0) >= 100,
      isNew: m.isNew ?? false,
    })),
  };
}
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

describe("SubjectHub — recall mission row (étude 17, US-6 + override R-9)", () => {
  const openC1 = { c1: true, c2: true };

  it("unlocked: an eligible + mastered mission links into the recall run with its best score", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e2: 5 },
          unlockedByExercise: { e2: true },
          bestByExercise: { e2: 88 },
        }}
      />,
    );
    expandAll(container);
    const chip = screen.getByTestId("recall-chip-unlocked");
    expect(chip).toBeInTheDocument();
    expect(chip.getAttribute("href")).toBe("/quest/$exerciseId");
    expect(screen.getByText(/88%/)).toBeInTheDocument();
  });

  it("locked: eligible but not mastered shows the inert lock, never a link", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e2: 5 },
          unlockedByExercise: {},
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    expect(screen.getByTestId("recall-chip-locked")).toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
    // Signed-in reason omits the "sign in" step.
    expect(screen.getByText(fr.quest.recallLockedHint)).toBeInTheDocument();
  });

  it("absent below RECALL_MIN_QUESTIONS eligible questions (no dead end)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e2: 2 },
          unlockedByExercise: { e2: true },
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    expect(screen.queryByTestId("recall-chip-locked")).not.toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
  });

  it("anonymous visitor: the recall mission is DISCOVERABLE but locked (override R-9)", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={false}
        // Anon never unlocks (no durable attempts) → server returns unlocked=false.
        recall={{
          eligibleByExercise: { e2: 5 },
          unlockedByExercise: {},
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    // Locked row shown with the sign-in reason; never a playable link.
    expect(screen.getByTestId("recall-chip-locked")).toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
    expect(screen.getByText(fr.quest.recallLockedHintAnon)).toBeInTheDocument();
  });

  it("absent on the quiz row even when signed-in and eligible", () => {
    const { container } = render(
      <SubjectHub
        subject={subject}
        chapters={chapters}
        exercises={exercises}
        quizPassedByChapter={openC1}
        isAuthenticated={true}
        recall={{
          eligibleByExercise: { e1: 5 },
          unlockedByExercise: { e1: true },
          bestByExercise: {},
        }}
      />,
    );
    expandAll(container);
    // e1 is the quiz mission → no recall chip, only e-row chips would appear.
    expect(screen.queryByTestId("recall-chip-unlocked")).not.toBeInTheDocument();
    expect(screen.queryByTestId("recall-chip-locked")).not.toBeInTheDocument();
  });
});

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
    expect(container.textContent).not.toMatch(/0\s*%/);
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

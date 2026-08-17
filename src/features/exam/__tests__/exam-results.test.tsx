import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { ExamResults } from "@/features/exam/components/exam-results";
import type { ExamPercentile, ExamResult, ExamReview } from "@/features/exam";

/**
 * La copie corrigée — ce qui doit tenir dans le temps :
 *
 *  1. **La note /20 vient du serveur**, elle n'est pas recalculée à l'écran. Un
 *     écran qui refait le calcul finirait par diverger de la RPC, et c'est la
 *     note que l'élève montre à ses parents.
 *  2. **Le coefficient est affiché à côté de chaque épreuve.** Sans lui,
 *     « 1/2 en maths » et « 1/2 en anglais » se lisent pareil alors qu'ils ne
 *     pèsent pas pareil au concours — c'est l'information qui doit changer la
 *     révision de la semaine suivante.
 *  3. **Le rang se tait sous le seuil** plutôt que d'afficher un chiffre.
 *  4. **Un entraînement ne se présente pas comme une session classée.**
 */

vi.mock("@/lib/i18n", () => ({
  useI18n: () => ({ locale: "fr" }),
  useT: () => ({
    exam: {
      scoreOn20: "Note / 20",
      scorePoints: "{score} / {max} points",
      rewards: "+{xp} XP · +{coins} pièces",
      practiceNoRank: "Entraînement : ni classement ni XP.",
      percentile: "Tu fais mieux que {pct} % des candidats.",
      percentilePending: "Classement affiché à partir de {n} candidats.",
      byPaper: "Par épreuve",
      coefficient: "coef. {n}",
      review: "Corrigé",
      yourAnswer: "Ta réponse",
      correctAnswer: "Réponse attendue",
      noAnswer: "Sans réponse",
      retryPractice: "Refaire en entraînement",
    },
  }),
}));

vi.mock("@/components/ui/svg-figure", () => ({
  RichField: ({ raw }: { raw: string }) => <p>{raw}</p>,
  OptionContent: ({ raw }: { raw: string }) => <span>{raw}</span>,
}));

const RESULT: ExamResult = {
  sessionId: "s-1",
  kind: "ranked",
  finishedAt: "2026-08-16T11:00:00Z",
  scorePoints: 30,
  maxPoints: 50,
  scorePct: 60,
  scoreOn20: 12,
  xpEarned: 180,
  coinsEarned: 36,
  papers: [
    {
      exerciseId: "e-1",
      labelFr: "Mathématiques",
      labelEn: null,
      labelAr: null,
      points: 40,
      correct: 1,
      total: 2,
      earned: 20,
    },
    {
      exerciseId: "e-2",
      labelFr: "Anglais",
      labelEn: null,
      labelAr: null,
      points: 10,
      correct: 1,
      total: 1,
      earned: 10,
    },
  ],
};

const REVIEW: ExamReview = [
  {
    exerciseId: "e-1",
    labelFr: "Mathématiques",
    labelEn: null,
    labelAr: null,
    questions: [
      {
        questionId: "q-1",
        prompt: "2 + 2 ?",
        options: [
          { id: "a", text: "trois" },
          { id: "b", text: "quatre" },
        ],
        questionType: "mcq",
        selectedChoice: "a",
        isCorrect: false,
        correctChoice: "b",
        explanation: "Deux et deux font quatre.",
      },
      {
        questionId: "q-2",
        prompt: "3 × 3 ?",
        options: [{ id: "a", text: "neuf" }],
        questionType: "mcq",
        selectedChoice: null,
        isCorrect: false,
        correctChoice: "a",
        explanation: null,
      },
    ],
  },
];

describe("ExamResults", () => {
  it("affiche la note /20 telle que le serveur l'a calculée", () => {
    render(<ExamResults result={RESULT} percentile={null} review={null} />);
    expect(screen.getByText("12.00")).toBeInTheDocument();
    expect(screen.getByText("30 / 50 points")).toBeInTheDocument();
  });

  it("montre le coefficient de chaque épreuve — sans lui, deux 1/2 se lisent pareil", () => {
    render(<ExamResults result={RESULT} percentile={null} review={null} />);
    expect(screen.getByText(/coef\. 4/)).toBeInTheDocument();
    expect(screen.getByText(/coef\. 1/)).toBeInTheDocument();
  });

  it("se tait sur le rang tant que les candidats manquent (R-6)", () => {
    const pct: ExamPercentile = { candidates: 3, minCandidates: 20, percentile: null };
    render(<ExamResults result={RESULT} percentile={pct} review={null} />);
    expect(screen.getByText("Classement affiché à partir de 20 candidats.")).toBeInTheDocument();
  });

  it("affiche le rang une fois le seuil franchi", () => {
    const pct: ExamPercentile = { candidates: 40, minCandidates: 20, percentile: 72.5 };
    render(<ExamResults result={RESULT} percentile={pct} review={null} />);
    expect(screen.getByText("Tu fais mieux que 72.5 % des candidats.")).toBeInTheDocument();
  });

  it("dit clairement qu'un entraînement ne rapporte rien", () => {
    render(
      <ExamResults
        result={{ ...RESULT, kind: "practice", xpEarned: 0, coinsEarned: 0 }}
        percentile={null}
        review={null}
      />,
    );
    expect(screen.getByText("Entraînement : ni classement ni XP.")).toBeInTheDocument();
    expect(screen.queryByText(/XP ·/)).not.toBeInTheDocument();
  });

  it("rend le corrigé : la réponse donnée, celle attendue, et l'explication", () => {
    render(<ExamResults result={RESULT} percentile={null} review={REVIEW} />);
    expect(screen.getByText("Deux et deux font quatre.")).toBeInTheDocument();
    expect(screen.getByText("trois")).toBeInTheDocument();
    expect(screen.getByText("quatre")).toBeInTheDocument();
    // Une question laissée vide se dit, elle ne disparaît pas de la copie.
    expect(screen.getByText("Sans réponse")).toBeInTheDocument();
  });

  it("ne laisse fuir aucun gabarit non interpolé", () => {
    const pct: ExamPercentile = { candidates: 40, minCandidates: 20, percentile: 72.5 };
    render(<ExamResults result={RESULT} percentile={pct} review={REVIEW} />);
    expect(screen.queryByText(/\{xp\}|\{pct\}|\{score\}|\{n\}/)).not.toBeInTheDocument();
  });
});

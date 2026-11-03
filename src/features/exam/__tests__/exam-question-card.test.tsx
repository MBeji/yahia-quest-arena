import { useCallback, useState } from "react";
import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { ExamQuestionCard } from "@/features/exam/components/exam-question-card";
import type { ExamQuestion } from "@/features/exam";
import { buildQuestLabels } from "@/shared/lib/quest-labels";
import type { DisplayOption } from "@/shared/lib/question-utils";

/**
 * Une épreuve = 10-20 questions, un seul état `answers` dans le runner. Avant
 * le 2026-10-31, chaque coche re-rendait TOUS les articles (mesuré en jsdom :
 * 20 questions à figures, +100 `DOMPurify.sanitize` et 300-400 ms par tap).
 * Ce test épingle le mécanisme qui l'évite : la carte est mémoïsée et le runner
 * lui passe des props stables, donc une coche ne re-rend que la question
 * touchée. `RichField` est remplacé par une sonde qui compte les rendus
 * d'article — c'est le composant qui repaie l'assainissement à chaque passage.
 */

const richFieldRenders = vi.fn();
vi.mock("@/components/ui/svg-figure", () => ({
  RichField: ({ raw }: { raw: string }) => {
    richFieldRenders(raw);
    return <p>{raw}</p>;
  },
  OptionContent: ({ raw }: { raw: string }) => <span>{raw}</span>,
}));

const N = 20;
const labels = buildQuestLabels("fr");

const questions: ExamQuestion[] = Array.from({ length: N }, (_, i) => ({
  id: `q${i}`,
  prompt: `Énoncé ${i}`,
  questionType: "mcq",
  options: [
    { id: "a", text: `A${i}` },
    { id: "b", text: `B${i}` },
  ],
}));

const optionsByQuestion = new Map<string, DisplayOption[]>(
  questions.map((q) => [
    q.id,
    q.options.map((o, k) => ({ ...o, displayId: String.fromCharCode(65 + k) })),
  ]),
);

// Le même contrat que `ExamRunner` : un état `answers` unique, un `onAnswer`
// stable, des options et des libellés construits une fois.
function Paper() {
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const onAnswer = useCallback((questionId: string, choice: string) => {
    setAnswers((prev) => ({ ...prev, [questionId]: choice }));
  }, []);
  return (
    <section>
      {questions.map((q, i) => (
        <ExamQuestionCard
          key={q.id}
          question={q}
          heading={`Question ${i + 1} / ${N}`}
          options={optionsByQuestion.get(q.id) ?? []}
          value={answers[q.id] ?? null}
          onAnswer={onAnswer}
          rtl={false}
          labels={labels}
        />
      ))}
      <output data-testid="count">{Object.keys(answers).length}</output>
    </section>
  );
}

describe("ExamQuestionCard — une coche ne re-rend que la question touchée", () => {
  it("re-rend 1 article par coche, pas les N de l'épreuve", () => {
    render(<Paper />);
    expect(richFieldRenders).toHaveBeenCalledTimes(N);
    richFieldRenders.mockClear();

    fireEvent.click(screen.getByRole("radio", { name: /A3/ }));
    expect(screen.getByTestId("count").textContent).toBe("1");
    expect(richFieldRenders).toHaveBeenCalledTimes(1);
    expect(richFieldRenders).toHaveBeenCalledWith("Énoncé 3");

    // Changer d'avis sur la même question : toujours un seul article.
    richFieldRenders.mockClear();
    fireEvent.click(screen.getByRole("radio", { name: /B3/ }));
    expect(richFieldRenders).toHaveBeenCalledTimes(1);

    // Une autre question : son article, et lui seul.
    richFieldRenders.mockClear();
    fireEvent.click(screen.getByRole("radio", { name: /A17/ }));
    expect(screen.getByTestId("count").textContent).toBe("2");
    expect(richFieldRenders).toHaveBeenCalledTimes(1);
    expect(richFieldRenders).toHaveBeenCalledWith("Énoncé 17");
  });

  it("marque la sélection sans verdict et confine chaque article", () => {
    const { container } = render(<Paper />);
    fireEvent.click(screen.getByRole("radio", { name: /A3/ }));
    const selected = screen.getByRole("radio", { name: /A3/ });
    expect(selected).toHaveAttribute("aria-checked", "true");
    expect(selected.className).toMatch(/border-gold/);
    expect(selected.className).not.toMatch(/destructive|success/);

    const articles = container.querySelectorAll("article");
    expect(articles).toHaveLength(N);
    for (const article of articles) expect(article.className).toMatch(/\bexam-question-cv\b/);
  });
});

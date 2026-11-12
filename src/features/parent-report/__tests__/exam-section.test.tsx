import { render, screen, within } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { parentTranslations } from "@/lib/i18n/parent";
import type { StudentExamSummary } from "../parent-report.schemas";

const locale = vi.hoisted(() => ({ current: "fr" as "fr" | "en" | "ar" }));
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: locale.current }) }));
vi.mock("@/lib/i18n/parent", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/parent")>();
  return { ...actual, useParentT: () => actual.parentTranslations(locale.current) };
});

import { ExamSection } from "../components/exam-section";

const LRI = "⁦";
const PDI = "⁩";

const exam = (over: Partial<StudentExamSummary["exams"][number]> = {}) => ({
  examId: "exam-1",
  titleFr: "Concours blanc 9ᵉ — session 1",
  titleEn: "Mock exam — session 1",
  titleAr: "امتحان تجريبي — الدورة 1",
  finishedAt: "2026-11-08T10:00:00Z",
  scorePoints: 120,
  maxPoints: 150,
  scoreOn20: 16,
  candidates: 42,
  percentile: 65 as number | null,
  ...over,
});

const summary = (over: Partial<StudentExamSummary> = {}): StudentExamSummary => ({
  minCandidates: 20,
  openExams: 0,
  exams: [exam()],
  ...over,
});

beforeEach(() => {
  locale.current = "fr";
});

describe("ExamSection — étude 08 lot 1 (US-5)", () => {
  it("ni examen rendu ni examen ouvert : rien à l'écran", () => {
    const { container } = render(<ExamSection summary={summary({ exams: [] })} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("aucun examen rendu mais des examens ouverts : une phrase, pas un tableau vide", () => {
    render(<ExamSection summary={summary({ exams: [], openExams: 2 })} />);
    const fr = parentTranslations("fr").parentReport;
    expect(screen.getByTestId("report-exams-empty")).toHaveTextContent(fr.examsNone);
    expect(screen.queryByTestId("report-exam")).not.toBeInTheDocument();
    // L'encart « à son rythme » n'accompagne qu'un résultat.
    expect(screen.queryByText(fr.examsHint)).not.toBeInTheDocument();
  });

  it("⭐ affiche la note sur 20, les points et le percentile d'un examen rendu", () => {
    render(<ExamSection summary={summary()} />);
    const row = within(screen.getByTestId("report-exam"));
    expect(row.getByText("Concours blanc 9ᵉ — session 1")).toBeInTheDocument();
    expect(row.getByText(`${LRI}16.00 / 20${PDI}`)).toBeInTheDocument();
    expect(row.getByText(`${LRI}120 / 150${PDI} points`)).toBeInTheDocument();
    expect(row.getByText("Mieux que 65 % des 42 candidats.")).toBeInTheDocument();
  });

  it("⭐ sous le seuil (règle é02) : aucun rang, et l'écran dit quand il viendra", () => {
    render(
      <ExamSection summary={summary({ exams: [exam({ candidates: 19, percentile: null })] })} />,
    );
    expect(screen.getByText("Classement affiché à partir de 20 candidats.")).toBeInTheDocument();
    expect(screen.queryByText(/Mieux que/)).not.toBeInTheDocument();
  });

  it("le seuil affiché est celui que le serveur a rendu, pas une constante de l'écran", () => {
    render(
      <ExamSection summary={summary({ minCandidates: 30, exams: [exam({ percentile: null })] })} />,
    );
    expect(screen.getByText("Classement affiché à partir de 30 candidats.")).toBeInTheDocument();
  });

  it("un percentile de 0 est un résultat, pas une absence", () => {
    render(<ExamSection summary={summary({ exams: [exam({ percentile: 0 })] })} />);
    expect(screen.getByText("Mieux que 0 % des 42 candidats.")).toBeInTheDocument();
  });

  it("rappelle qu'un examen blanc est un entraînement — jamais un classement d'enfants", () => {
    render(<ExamSection summary={summary()} />);
    expect(screen.getByText(parentTranslations("fr").parentReport.examsHint)).toBeInTheDocument();
  });

  it("plusieurs examens : une ligne chacun", () => {
    render(
      <ExamSection
        summary={summary({ exams: [exam(), exam({ examId: "exam-2", titleFr: "Session 2" })] })}
      />,
    );
    expect(screen.getAllByTestId("report-exam")).toHaveLength(2);
  });

  it("titre dans la langue du parent, repli sur le français s'il manque", () => {
    locale.current = "en";
    const { rerender } = render(<ExamSection summary={summary()} />);
    expect(screen.getByText("Mock exam — session 1")).toBeInTheDocument();
    rerender(<ExamSection summary={summary({ exams: [exam({ titleEn: null })] })} />);
    expect(screen.getByText("Concours blanc 9ᵉ — session 1")).toBeInTheDocument();
  });

  it("RTL : la fraction reste un bloc LTR et chaque phrase un seul nœud de texte", () => {
    locale.current = "ar";
    render(<ExamSection summary={summary()} />);
    const ar = parentTranslations("ar").parentReport;
    const row = within(screen.getByTestId("report-exam"));
    const points = row.getByText(`${LRI}120 / 150${PDI} نقطة`);
    expect(points.childNodes).toHaveLength(1);
    const rank = row.getByText(ar.examsPercentile.replace("{pct}", "65").replace("{n}", "42"));
    expect(rank.childNodes).toHaveLength(1);
    expect(row.getByText("امتحان تجريبي — الدورة 1")).toHaveAttribute("dir", "auto");
  });

  it("les trois langues portent les clés de la section, sans mot d'argent", () => {
    for (const code of ["fr", "en", "ar"] as const) {
      const p = parentTranslations(code).parentReport;
      for (const key of [
        "examsTitle",
        "examsPoints",
        "examsPercentile",
        "examsPending",
        "examsNone",
        "examsHint",
      ] as const) {
        expect(p[key].trim().length).toBeGreaterThan(0);
        expect(p[key].toLowerCase()).not.toMatch(/premium|abonnement|payant|subscription/);
      }
      expect(p.examsPercentile).toContain("{pct}");
      expect(p.examsPending).toContain("{n}");
      expect(p.examsPoints).toContain("{points}");
    }
  });
});

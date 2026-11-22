/**
 * Bilan et programme du jour — les deux composants partagés par l'élève et son parent.
 *
 * Ce que ces tests protègent : l'élève et le parent lisent LE MÊME contenu (commande du
 * 2026-11-22) ; la seule différence est que l'élève peut lancer une mission. Et le geste
 * « chapitres vus » envoie la déclaration entière de la matière.
 */
import { fireEvent, render, screen, within } from "@testing-library/react";
import React from "react";
import { beforeEach, describe, expect, it, vi } from "vitest";

import { chapter, report, subject } from "@/shared/lib/__tests__/study-report.fixture";

const locale = vi.hoisted(() => ({ current: "fr" as "fr" | "en" | "ar" }));
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ locale: locale.current }) }));
vi.mock("@/lib/i18n/study", async (orig) => {
  const actual = await orig<typeof import("@/lib/i18n/study")>();
  return { ...actual, useStudyT: () => actual.studyTranslations(locale.current) };
});
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
  }) => React.createElement("a", { href: to, "data-exercise": params?.exerciseId }, children),
}));

import { StudyPlanCard } from "../study-report/study-plan-card";
import { StudySubjects } from "../study-report/study-subjects";

beforeEach(() => {
  locale.current = "fr";
});

describe("StudyPlanCard", () => {
  it("montre l'objectif mesuré, ce qui reste et ce qui est fait", () => {
    render(<StudyPlanCard report={report()} audience="student" />);
    expect(screen.getByTestId("study-goal-progress")).toHaveTextContent("10 min sur 30");
    expect(screen.getByTestId("study-plan-minutes")).toHaveTextContent("≈ 9 min");
    expect(screen.getAllByTestId("study-plan-item")).toHaveLength(2);
    expect(screen.getByText("À reprendre")).toBeInTheDocument();
    expect(screen.getByText("Quiz du chapitre")).toBeInTheDocument();
    expect(screen.getByText("Mathématiques · Équations")).toBeInTheDocument();
    expect(screen.getByTestId("study-done-today")).toHaveTextContent("Mission faite");
    expect(screen.getByRole("progressbar")).toHaveAttribute("aria-valuenow", "33");
  });

  it("l'élève peut lancer chaque étape", () => {
    render(<StudyPlanCard report={report()} audience="student" />);
    const links = screen.getAllByRole("link");
    expect(links.map((a) => a.getAttribute("data-exercise"))).toEqual(["e1", "e2"]);
  });

  it("le parent lit le même programme, sans lien de jeu", () => {
    render(<StudyPlanCard report={report()} audience="parent" />);
    expect(screen.getAllByTestId("study-plan-item")).toHaveLength(2);
    expect(screen.queryByRole("link")).not.toBeInTheDocument();
  });

  it("propose le bilan complet seulement là où on le demande", () => {
    const { rerender } = render(<StudyPlanCard report={report()} audience="student" />);
    expect(screen.queryByText("Voir le bilan complet")).not.toBeInTheDocument();
    rerender(<StudyPlanCard report={report()} audience="student" showReportLink />);
    expect(screen.getByText("Voir le bilan complet").closest("a")).toHaveAttribute(
      "href",
      "/bilan",
    );
  });

  it("objectif atteint : le programme se tait et le dit", () => {
    render(<StudyPlanCard report={report({ doneMinutes: 32, plan: [] })} audience="student" />);
    expect(screen.getByText("Objectif du jour atteint 🎉")).toBeInTheDocument();
    expect(screen.getByTestId("study-plan-empty")).toHaveTextContent("À demain");
    expect(screen.queryByTestId("study-plan-minutes")).not.toBeInTheDocument();
  });

  it("rien à proposer avant l'objectif : tout ce qui a été vu est travaillé", () => {
    render(<StudyPlanCard report={report({ plan: [], today: [] })} audience="parent" />);
    expect(screen.getByTestId("study-plan-empty")).toHaveTextContent(
      "Cochez les nouveaux chapitres",
    );
    expect(screen.queryByTestId("study-done-today")).not.toBeInTheDocument();
  });

  it("se lit en arabe et en anglais", () => {
    locale.current = "ar";
    const { unmount } = render(<StudyPlanCard report={report()} audience="student" />);
    expect(screen.getByText("برنامج اليوم")).toBeInTheDocument();
    unmount();
    locale.current = "en";
    render(<StudyPlanCard report={report()} audience="student" />);
    expect(screen.getByText("Today's plan")).toBeInTheDocument();
  });
});

describe("StudyPlanCard — l'objectif quotidien", () => {
  it("ne se règle pas là où on ne le demande pas (tableau de bord)", () => {
    render(<StudyPlanCard report={report()} audience="student" />);
    expect(screen.queryByTestId("study-target")).not.toBeInTheDocument();
  });

  it("propose les objectifs, marque le courant, et envoie le choix", () => {
    const onSetTarget = vi.fn();
    render(<StudyPlanCard report={report()} audience="student" onSetTarget={onSetTarget} />);
    const group = within(screen.getByTestId("study-target"));
    expect(group.getAllByRole("button").map((b) => b.textContent)).toEqual([
      "30 min",
      "45 min",
      "60 min",
      "90 min",
    ]);
    expect(group.getByRole("button", { name: "30 min" })).toHaveAttribute("aria-pressed", "true");
    fireEvent.click(group.getByRole("button", { name: "45 min" }));
    expect(onSetTarget).toHaveBeenCalledWith(45);
  });

  it("se fige pendant l'enregistrement", () => {
    render(<StudyPlanCard report={report()} audience="parent" onSetTarget={vi.fn()} saving />);
    expect(
      within(screen.getByTestId("study-target"))
        .getAllByRole("button")
        .every((b) => (b as HTMLButtonElement).disabled),
    ).toBe(true);
  });
});

describe("StudySubjects", () => {
  it("donne le niveau, la réussite récente et l'avancement sur ce qui a été vu", () => {
    render(<StudySubjects report={report()} audience="student" />);
    const card = screen.getByTestId("study-subject");
    expect(within(card).getByTestId("study-level")).toHaveTextContent("En progrès");
    expect(card).toHaveTextContent("% de réussite sur 9 mission(s) récente(s)");
    expect(card).toHaveTextContent("2 chapitre(s) acquis sur 3 vu(s) en classe");
    expect(within(card).queryByTestId("study-exam")).not.toBeInTheDocument();
  });

  it("ne prétend rien sans missions récentes", () => {
    render(
      <StudySubjects
        report={report({
          subjects: [subject({ level: "non-evalue", recentAttempts: 1, recentAvgScore: 90 })],
        })}
        audience="parent"
      />,
    );
    expect(screen.getByTestId("study-level")).toHaveTextContent("Pas encore évalué");
    expect(screen.getByText("Pas assez de missions récentes pour juger")).toBeInTheDocument();
  });

  it("affiche la dernière épreuve sur 20", () => {
    render(
      <StudySubjects
        report={report({
          subjects: [
            subject({
              exam: { scorePoints: 135, maxPoints: 200, finishedAt: "2026-11-21T10:00:00Z" },
            }),
          ],
        })}
        audience="parent"
      />,
    );
    expect(screen.getByTestId("study-exam")).toHaveTextContent("13,5/20");
  });

  it("« à travailler » : les chapitres vus non acquis, le fragile d'abord", () => {
    render(<StudySubjects report={report()} audience="student" />);
    const rows = screen.getAllByTestId("study-to-work");
    expect(rows.map((r) => r.textContent)).toEqual([
      expect.stringContaining("Équations"),
      expect.stringContaining("Fractions"),
    ]);
    expect(rows[0]).toHaveTextContent("Fragile · 2 étape(s) avant l'étoile 1");
  });

  it("dit quand il ne reste rien à travailler", () => {
    render(
      <StudySubjects
        report={report({
          subjects: [subject({ chapters: [chapter({ status: "acquis", star: 1 })] })],
        })}
        audience="student"
      />,
    );
    expect(
      screen.getByText("Rien en attente dans les chapitres vus en classe."),
    ).toBeInTheDocument();
  });

  it("cocher un chapitre envoie la déclaration ENTIÈRE de la matière", () => {
    const onSetChapters = vi.fn();
    render(<StudySubjects report={report()} audience="student" onSetChapters={onSetChapters} />);
    const boxes = screen.getAllByRole("checkbox");
    expect(boxes.map((b) => (b as HTMLInputElement).checked)).toEqual([true, true, true, false]);
    fireEvent.click(boxes[3]!);
    expect(onSetChapters).toHaveBeenCalledWith("math", ["c1", "c2", "c3", "c4"]);
    fireEvent.click(boxes[1]!);
    expect(onSetChapters).toHaveBeenLastCalledWith("math", ["c1", "c3"]);
  });

  it("« j'en suis là » coche jusqu'au chapitre", () => {
    const onSetChapters = vi.fn();
    render(<StudySubjects report={report()} audience="student" onSetChapters={onSetChapters} />);
    fireEvent.click(screen.getAllByRole("button", { name: "Jusqu'ici" })[1]!);
    expect(onSetChapters).toHaveBeenCalledWith("math", ["c1", "c2"]);
  });

  it("sans écriture, les cases se lisent et ne se modifient pas", () => {
    render(<StudySubjects report={report()} audience="parent" />);
    expect(screen.getAllByRole("checkbox").every((b) => (b as HTMLInputElement).disabled)).toBe(
      true,
    );
    expect(screen.queryByRole("button", { name: "Jusqu'ici" })).not.toBeInTheDocument();
  });

  it("pendant l'enregistrement la matière est gelée ; une erreur se dit", () => {
    render(
      <StudySubjects
        report={report()}
        audience="student"
        onSetChapters={vi.fn()}
        savingSubjectId="math"
        errorSubjectId="math"
      />,
    );
    expect(screen.getAllByRole("checkbox").every((b) => (b as HTMLInputElement).disabled)).toBe(
      true,
    );
    expect(screen.getByRole("alert")).toHaveTextContent("Enregistrement impossible");
  });

  it("sans déclaration, dit que « vu » est une estimation du calendrier", () => {
    render(
      <StudySubjects
        report={report({ subjects: [subject({ declared: false })] })}
        audience="student"
      />,
    );
    expect(screen.getByTestId("study-class-chapters")).toHaveTextContent(
      "Estimation d'après le calendrier scolaire",
    );
  });

  it("sans le détail des chapitres (tableau de bord), reste au niveau par matière", () => {
    render(
      <StudySubjects
        report={report({ subjects: [subject({ chapters: null })] })}
        audience="student"
      />,
    );
    expect(screen.getByTestId("study-level")).toBeInTheDocument();
    expect(screen.queryByTestId("study-class-chapters")).not.toBeInTheDocument();
  });
});

describe("StudySubjects — les matières prioritaires", () => {
  const three = () =>
    report({
      subjects: [
        subject({ id: "math", name: "Maths", chapters: null }),
        subject({ id: "fr", name: "Français", focus: true, chapters: null }),
        subject({ id: "ar", name: "Arabe", chapters: null }),
      ],
    });

  it("basculer une matière envoie la liste entière des prioritaires", () => {
    const onSetFocus = vi.fn();
    render(<StudySubjects report={three()} audience="student" onSetFocus={onSetFocus} />);
    expect(screen.getByTestId("study-focus-hint")).toHaveTextContent("deux matières prioritaires");
    const toggles = screen.getAllByTestId("study-focus-toggle");
    expect(toggles.map((b) => b.getAttribute("aria-pressed"))).toEqual(["false", "true", "false"]);
    expect(toggles[1]).toHaveTextContent("Prioritaire");
    fireEvent.click(toggles[0]!);
    expect(onSetFocus).toHaveBeenCalledWith(["math", "fr"]);
    fireEvent.click(toggles[1]!);
    expect(onSetFocus).toHaveBeenLastCalledWith([]);
  });

  it("avec deux matières choisies, une troisième ne se choisit pas", () => {
    const full = three();
    full.subjects[0]!.focus = true;
    const onSetFocus = vi.fn();
    render(<StudySubjects report={full} audience="parent" onSetFocus={onSetFocus} />);
    const toggles = screen.getAllByTestId("study-focus-toggle") as HTMLButtonElement[];
    expect(toggles.map((b) => b.disabled)).toEqual([false, false, true]);
  });

  it("sans réglage, la matière prioritaire se lit par un simple repère", () => {
    render(<StudySubjects report={three()} audience="student" />);
    expect(screen.queryByTestId("study-focus-toggle")).not.toBeInTheDocument();
    expect(screen.getAllByTestId("study-focus-badge")).toHaveLength(1);
  });

  it("dit quand le réglage n'a pas pu être enregistré", () => {
    render(<StudySubjects report={three()} audience="student" onSetFocus={vi.fn()} focusError />);
    expect(screen.getByRole("alert")).toHaveTextContent("Enregistrement impossible");
  });
});

import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    ...rest
  }: {
    children: React.ReactNode;
    to: string;
    params?: unknown;
    className?: string;
    "data-testid"?: string;
  }) =>
    React.createElement(
      "a",
      { href: to, className: rest.className, "data-testid": rest["data-testid"] },
      children,
    ),
}));

import { frGuide } from "@/lib/i18n/guide/fr";
import { LockedMissionRow } from "../components/locked-mission-row";

function renderRow(quizExerciseId: string | null) {
  return render(
    <ul>
      <LockedMissionRow
        exerciseId="e2"
        title="Les fractions ⭐⭐"
        titleNode={<span>Les fractions ⭐⭐</span>}
        chapterId="c1"
        quizExerciseId={quizExerciseId}
        exerciseTo="/quest/$exerciseId"
      />
    </ul>,
  );
}

describe("LockedMissionRow — une mission fermée dit pourquoi", () => {
  it("est un bouton qui s'annonce, et non une ligne muette", () => {
    renderRow("q1");
    const row = screen.getByRole("button", {
      name: "Mission fermée : Les fractions ⭐⭐. Touche pour savoir pourquoi.",
    });
    expect(row).toHaveTextContent(frGuide.guide.locked.why);
    expect(row).not.toHaveTextContent("—");
  });

  it("au toucher : l'explication, les 3 étapes, et le chemin vers le cours ET le quiz", async () => {
    renderRow("q1");
    fireEvent.click(screen.getByTestId("locked-mission-e2"));
    const explainer = await screen.findByTestId("locked-mission-explainer");
    expect(explainer).toHaveTextContent(frGuide.guide.locked.title);
    expect(explainer).toHaveTextContent("80 %");
    expect(screen.getByTestId("chapter-steps")).toBeInTheDocument();
    expect(document.querySelector('a[href="/chapitre/$chapterId"]')).not.toBeNull();
    expect(screen.getByTestId("locked-mission-take-quiz")).toHaveAttribute(
      "href",
      "/quest/$exerciseId",
    );
  });

  it("sans quiz connu, ne propose que le cours", async () => {
    renderRow(null);
    fireEvent.click(screen.getByTestId("locked-mission-e2"));
    await screen.findByTestId("locked-mission-explainer");
    expect(screen.queryByTestId("locked-mission-take-quiz")).toBeNull();
    expect(document.querySelector('a[href="/chapitre/$chapterId"]')).not.toBeNull();
  });
});

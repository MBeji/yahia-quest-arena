import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { QuestResultActions } from "../components/quest-result-actions";

describe("QuestResultActions", () => {
  it("calls onReplay when the replay button is clicked", () => {
    const onReplay = vi.fn();
    render(<QuestResultActions subjectId={null} nextExerciseId={null} onReplay={onReplay} />);
    fireEvent.click(screen.getByRole("button"));
    expect(onReplay).toHaveBeenCalledTimes(1);
  });

  it("renders the next-quest link only when nextExerciseId is set", () => {
    const { container, rerender } = render(
      <QuestResultActions subjectId="s1" nextExerciseId={null} onReplay={() => {}} />,
    );
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).toBeNull();
    rerender(<QuestResultActions subjectId="s1" nextExerciseId="ex2" onReplay={() => {}} />);
    expect(container.querySelector('a[href="/quest/$exerciseId"]')).not.toBeNull();
  });

  it("renders the back-to-subject link only when subjectId is set", () => {
    const { container } = render(
      <QuestResultActions subjectId={null} nextExerciseId={null} onReplay={() => {}} />,
    );
    expect(container.querySelector('a[href="/matiere/$subjectId"]')).toBeNull();
    // Back-to-hall link is always present.
    expect(container.querySelector('a[href="/dashboard"]')).not.toBeNull();
  });
});

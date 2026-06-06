import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

import { QuizLockScreen } from "../components/quiz-lock-screen";

describe("QuizLockScreen", () => {
  it("renders the title/body and both the review and back links when ids are set", () => {
    const { container } = render(
      <QuizLockScreen
        title="Locked"
        body="Pass the quiz first"
        reviewLabel="Review the lesson"
        backLabel="Back to subject"
        chapterId="c1"
        subjectId="s1"
        rtl={false}
      />,
    );
    expect(screen.getByText("Locked")).toBeInTheDocument();
    expect(screen.getByText("Pass the quiz first")).toBeInTheDocument();
    expect(container.querySelector('a[href="/lesson/$chapterId"]')).not.toBeNull();
    expect(container.querySelector('a[href="/subject/$subjectId"]')).not.toBeNull();
    // No RTL direction unless requested.
    expect(container.querySelector('[dir="rtl"]')).toBeNull();
  });

  it("omits the review link without a chapter, omits back without a subject, and honors rtl", () => {
    const { container } = render(
      <QuizLockScreen
        title="Locked"
        body="Pass the quiz first"
        reviewLabel="Review the lesson"
        backLabel="Back to subject"
        chapterId={null}
        subjectId={null}
        rtl
      />,
    );
    expect(container.querySelector('a[href="/lesson/$chapterId"]')).toBeNull();
    expect(container.querySelector('a[href="/subject/$subjectId"]')).toBeNull();
    expect(container.querySelector('[dir="rtl"]')).not.toBeNull();
  });
});

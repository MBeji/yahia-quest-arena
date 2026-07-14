import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    params,
  }: {
    children: React.ReactNode;
    to: string;
    params?: Record<string, string>;
  }) =>
    React.createElement(
      "a",
      { href: params ? to.replace(/\$(\w+)/g, (_m, k: string) => params[k] ?? `$${k}`) : to },
      children,
    ),
}));
vi.mock("motion/react", () => ({
  motion: {
    div: ({ children, ...p }: { children?: React.ReactNode }) =>
      React.createElement("div", p, children),
  },
}));
vi.mock("@/shared/lib/motion", () => ({ useEntrance: () => ({}) }));
// A 2-level proxy: any t.<section>.<key> resolves to a stable string with .replace().
const t = new Proxy(
  {},
  { get: (_o, k1) => new Proxy({}, { get: (_o2, k2) => `${String(k1)}.${String(k2)}` }) },
);
vi.mock("@/lib/i18n", () => ({ useI18n: () => ({ t, locale: "fr" }), useT: () => t }));

import { ReportContent } from "../components/report-content";

const report = {
  student: {
    displayName: "Yahia",
    heroClass: "Guerrier",
    level: 5,
    currentStreak: 3,
    createdAt: "2026-01-01T00:00:00Z",
    lastActiveDate: "2026-07-13T00:00:00Z",
  },
  summary: {
    seriousnessScore: 80,
    verdict: "good",
    totalTimeMinutes: 120,
    totalExercises: 20,
    avgScore: 75,
    daysActiveThisWeek: 4,
    scoreTrend: 5,
  },
  subjectStats: [],
  dailyActivity: [{ date: "2026-07-13", exercises: 2, minutes: 10, avgScore: 80 }],
  weekComparison: {
    thisWeek: { exercises: 5, minutes: 30, avgScore: 75 },
    lastWeek: { exercises: 3, minutes: 20, avgScore: 70 },
  },
  chapterInsights: {
    strengths: [],
    weaknesses: [
      {
        chapterId: "chap-frac",
        chapterTitle: "Fractions",
        subjectId: "s-math",
        subjectName: "Maths",
        attempts: 3,
        avgScore: 40,
      },
    ],
  },
};

describe("ReportContent — actionable weak points (étude 15 lot 12, D-9)", () => {
  it("links each weak chapter — and the weekly advice — into its /chapitre reader", () => {
    const { container } = render(<ReportContent report={report as never} />);
    expect(screen.getByText("Fractions")).toBeInTheDocument();
    // Two clickable paths to the same weak chapter: the insight row + the advice CTA.
    expect(container.querySelectorAll('a[href="/chapitre/chap-frac"]')).toHaveLength(2);
  });
});

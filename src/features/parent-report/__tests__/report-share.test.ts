import { describe, it, expect } from "vitest";
import { frParent } from "@/lib/i18n/parent/fr";
import { buildFamilyReportShareText, buildWeeklyAdvice, type ReportData } from "../report-share";

function makeReport(overrides: Partial<ReportData> = {}): ReportData {
  return {
    student: {
      displayName: "Yahia",
      heroClass: "warrior",
      level: 5,
      xp: 500,
      currentStreak: 3,
      longestStreak: 7,
      lastActiveDate: "2026-06-30",
      createdAt: "2026-01-01",
    },
    summary: {
      totalTimeMinutes: 120,
      totalExercises: 30,
      avgScore: 82,
      daysActiveThisWeek: 4,
      seriousnessScore: 75,
      verdict: "good",
      scoreTrend: 3,
    },
    subjectStats: [],
    dailyActivity: [],
    weekComparison: {
      thisWeek: { exercises: 12, minutes: 45, avgScore: 82 },
      lastWeek: { exercises: 8, minutes: 30, avgScore: 75 },
    },
    // Étude 04 A2.2 : le défaut de la fixture est VIDE — un rapport sans erreur
    // installée est le cas le plus courant, et le partage doit tenir sans elles.
    misconceptionInsights: [],
    chapterInsights: {
      strengths: [
        {
          chapterId: "c1",
          chapterTitle: "Les fractions",
          subjectId: "s1",
          subjectName: "Math",
          attempts: 4,
          avgScore: 92,
        },
      ],
      weaknesses: [
        {
          chapterId: "c2",
          chapterTitle: "Thalès",
          subjectId: "s1",
          subjectName: "Math",
          attempts: 3,
          avgScore: 45,
        },
      ],
    },
    ...overrides,
  };
}

describe("parent-report — buildWeeklyAdvice", () => {
  it("targets the weakest chapter first", () => {
    const advice = buildWeeklyAdvice(makeReport(), frParent);
    expect(advice).toContain("Thalès");
    expect(advice).toContain("Math");
  });

  it("suggests a short session when inactive and no weakness stands out", () => {
    const report = makeReport({
      summary: { ...makeReport().summary, verdict: "inactive" },
      chapterInsights: { strengths: [], weaknesses: [] },
    });
    expect(buildWeeklyAdvice(report, frParent)).toBe(frParent.parentReport.adviceInactive);
  });

  it("congratulates by name when everything is on track", () => {
    const report = makeReport({ chapterInsights: { strengths: [], weaknesses: [] } });
    expect(buildWeeklyAdvice(report, frParent)).toContain("Yahia");
  });
});

describe("parent-report — buildFamilyReportShareText", () => {
  it("includes the week summary, strengths, weaknesses and the advice", () => {
    const text = buildFamilyReportShareText(makeReport(), frParent);
    expect(text).toContain(frParent.parentReport.printTitle);
    expect(text).toContain("Yahia — 12");
    expect(text).toContain("45");
    expect(text).toContain("82%");
    expect(text).toContain("Les fractions (92%)");
    expect(text).toContain("Thalès (45%)");
    expect(text).toContain(frParent.parentReport.adviceTitle);
  });

  it("omits the insights lines when there is nothing to show", () => {
    const report = makeReport({ chapterInsights: { strengths: [], weaknesses: [] } });
    const text = buildFamilyReportShareText(report, frParent);
    expect(text).not.toContain(frParent.parentReport.strengthsTitle);
    expect(text).not.toContain(frParent.parentReport.weaknessesTitle);
    // Still leads with the title and ends with the advice.
    expect(text).toContain(frParent.parentReport.printTitle);
    expect(text).toContain(frParent.parentReport.adviceTitle);
  });
});

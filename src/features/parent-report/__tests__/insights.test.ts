import { describe, expect, it } from "vitest";
import { computeEngagement } from "../insights/engagement";
import { computeEfficiency, paceRatio, revisionGain } from "../insights/efficiency";
import { deriveKpis, formatMinutes, formatSeconds, longestActiveStreak } from "../insights/kpis";
import { clampRange, rangeLengthDays, resolvePeriod, shiftDays } from "../insights/periods";
import { bandFor, scoreIndex, topContributors, topGaps } from "../insights/scoring";
import { analyzeSubjects, subjectLevel } from "../insights/subjects";
import { parseDailyReport } from "../insights/daily-report";
import { makeDay, makeReport, makeRun, makeTotals } from "./daily-fixtures";

describe("periods", () => {
  it("résout chaque préréglage autour d'une date fixée", () => {
    const today = "2026-08-13"; // un jeudi
    expect(resolvePeriod("today", { today })).toEqual({ from: today, to: today });
    expect(resolvePeriod("yesterday", { today })).toEqual({
      from: "2026-08-12",
      to: "2026-08-12",
    });
    // « 7 derniers jours » inclut aujourd'hui : J-6 → J.
    expect(resolvePeriod("last7", { today })).toEqual({ from: "2026-08-07", to: today });
    expect(resolvePeriod("last30", { today })).toEqual({ from: "2026-07-15", to: today });
    // La semaine commence le LUNDI.
    expect(resolvePeriod("thisWeek", { today })).toEqual({ from: "2026-08-10", to: today });
    expect(resolvePeriod("thisMonth", { today })).toEqual({ from: "2026-08-01", to: today });
  });

  it("commence la semaine au bon jour même un dimanche", () => {
    expect(resolvePeriod("thisWeek", { today: "2026-08-16" })).toEqual({
      from: "2026-08-10",
      to: "2026-08-16",
    });
  });

  it("remet une plage à l'endroit et la borne à 92 jours", () => {
    expect(clampRange({ from: "2026-08-13", to: "2026-08-01" })).toEqual({
      from: "2026-08-01",
      to: "2026-08-13",
    });
    const clamped = clampRange({ from: "2020-01-01", to: "2026-08-13" });
    expect(rangeLengthDays(clamped)).toBe(92);
    expect(clamped.to).toBe("2026-08-13");
  });

  it("compte les jours bornes incluses", () => {
    expect(rangeLengthDays({ from: "2026-08-01", to: "2026-08-01" })).toBe(1);
    expect(rangeLengthDays({ from: "2026-08-01", to: "2026-08-07" })).toBe(7);
  });

  it("traverse un changement de mois sans dériver", () => {
    expect(shiftDays("2026-03-01", -1)).toBe("2026-02-28");
    expect(shiftDays("2026-12-31", 1)).toBe("2027-01-01");
  });
});

describe("scoring", () => {
  it("place chaque score dans sa bande", () => {
    expect(bandFor(95)).toBe("excellent");
    expect(bandFor(80)).toBe("excellent");
    expect(bandFor(60)).toBe("good");
    expect(bandFor(40)).toBe("fair");
    expect(bandFor(39)).toBe("weak");
  });

  it("renormalise les poids sur les seuls facteurs mesurés", () => {
    // Deux facteurs sur trois disponibles : leurs poids doivent se répartir 100,
    // et non laisser 40 points inaccessibles.
    const result = scoreIndex([
      { key: "a", weight: 30, ratio: 1, detail: {} },
      { key: "b", weight: 30, ratio: 1, detail: {} },
      { key: "c", weight: 40, ratio: null, detail: {} },
    ]);
    expect(result.score).toBe(100);
    expect(result.insufficientData).toBe(false);
  });

  it("ne note rien quand aucun facteur n'est mesurable", () => {
    const result = scoreIndex([{ key: "a", weight: 30, ratio: null, detail: {} }]);
    expect(result.insufficientData).toBe(true);
    expect(result.score).toBe(0);
  });

  it("sépare ce qui porte le score de ce qui le retient", () => {
    const result = scoreIndex([
      { key: "strong", weight: 50, ratio: 0.9, detail: {} },
      { key: "weak", weight: 50, ratio: 0.1, detail: {} },
    ]);
    expect(topContributors(result).map((f) => f.key)).toEqual(["strong"]);
    expect(topGaps(result).map((f) => f.key)).toEqual(["weak"]);
  });
});

describe("computeEngagement", () => {
  it("récompense la régularité, l'activité et la persévérance", () => {
    const report = makeReport({
      totals: makeTotals({
        activeDays: 5,
        appMinutes: 200,
        learningMinutes: 180,
        exercises: 18,
        lessonsOpened: 6,
        lessonsStudied: 6,
        exerciseSessionsStarted: 18,
        exerciseSessionsCompleted: 18,
        byActivity: { lesson: 60, exercise: 100, quiz: 10, recall: 40, arena: 0, browse: 20 },
      }),
    });
    const result = computeEngagement(report);
    expect(result.insufficientData).toBe(false);
    expect(result.score).toBeGreaterThanOrEqual(80);
    expect(result.band).toBe("excellent");
  });

  it("retire — et ne met pas à zéro — les facteurs de temps hors mesure", () => {
    // Période antérieure à l'instrumentation : « 0 minute » n'est pas un fait,
    // c'est une absence de mesure. Punir l'enfant pour ça serait un bug.
    const facts = {
      activeDays: 5,
      exercises: 21,
      exerciseSessionsStarted: 21,
      exerciseSessionsCompleted: 21,
    };
    const unmeasured = computeEngagement(
      makeReport({
        range: {
          from: "2026-08-09",
          to: "2026-08-15",
          days: 7,
          timezone: "Africa/Tunis",
          measuredSince: null,
        },
        totals: makeTotals(facts),
      }),
    );
    const measured = computeEngagement(makeReport({ totals: makeTotals(facts) }));

    expect(unmeasured.factors.find((f) => f.key === "learningTime")?.ratio).toBeNull();
    expect(measured.factors.find((f) => f.key === "learningTime")?.ratio).toBe(0);
    // Sans mesure du temps, le score ne s'effondre pas.
    expect(unmeasured.score).toBeGreaterThan(measured.score);
  });

  it("ignore la tendance de score quand il y a trop peu de tentatives", () => {
    const result = computeEngagement(
      makeReport({
        totals: makeTotals({ exercises: 2, avgScore: 90 }),
        previous: makeTotals({ exercises: 2, avgScore: 40 }),
      }),
    );
    expect(result.factors.find((f) => f.key === "progress")?.ratio).toBeNull();
  });

  it("sanctionne l'abandon systématique des exercices commencés", () => {
    const result = computeEngagement(
      makeReport({
        totals: makeTotals({ exerciseSessionsStarted: 10, exerciseSessionsCompleted: 2 }),
      }),
    );
    expect(result.factors.find((f) => f.key === "perseverance")?.ratio).toBeCloseTo(0.2);
  });
});

describe("computeEfficiency", () => {
  it("note en cloche le rythme de réponse : trop vite ET trop lent sont mauvais", () => {
    expect(paceRatio(3)).toBeLessThan(0.3); // clique sans lire
    expect(paceRatio(25)).toBe(1); // réfléchit
    expect(paceRatio(120)).toBeLessThan(0.3); // a décroché
    expect(paceRatio(0)).toBe(0);
  });

  it("mesure le gain d'une révision par rapport au mode classique", () => {
    expect(
      revisionGain([
        makeRun({ attemptId: "a", variant: "classic", scorePct: 50 }),
        makeRun({ attemptId: "b", variant: "recall", scorePct: 80 }),
      ]),
    ).toBe(30);
    // Un seul mode présent : rien à comparer.
    expect(revisionGain([makeRun({ variant: "classic" })])).toBeNull();
  });

  it("distingue « beaucoup de temps » de « apprend efficacement »", () => {
    const common = {
      exercises: 10,
      exercisesPassed: 6,
      correct: 60,
      questions: 100,
      avgScore: 60,
      avgSecondsPerQuestion: 25,
      activeDays: 5,
    };
    // Même travail, même résultat — mais l'un y a passé trois fois plus de temps.
    const efficient = computeEfficiency(
      makeReport({ totals: makeTotals({ ...common, appMinutes: 60, learningMinutes: 50 }) }),
    );
    const wasteful = computeEfficiency(
      makeReport({ totals: makeTotals({ ...common, appMinutes: 320, learningMinutes: 300 }) }),
    );
    expect(efficient.score).toBeGreaterThan(wasteful.score);
  });

  it("écarte le rendement du temps quand le temps n'est pas mesuré", () => {
    const result = computeEfficiency(
      makeReport({
        range: {
          from: "2026-08-09",
          to: "2026-08-15",
          days: 7,
          timezone: "Africa/Tunis",
          measuredSince: null,
        },
        totals: makeTotals({ exercises: 10, exercisesPassed: 8, correct: 80, questions: 100 }),
      }),
    );
    expect(result.factors.find((f) => f.key === "timeToResult")?.ratio).toBeNull();
  });
});

describe("kpis", () => {
  it("dérive les taux sans jamais diviser par zéro", () => {
    const kpis = deriveKpis(makeReport());
    expect(kpis.accuracyPct).toBe(0);
    expect(kpis.exerciseSuccessPct).toBe(0);
    expect(kpis.scoreDelta).toBeNull();
  });

  it("ne compare que ce qui est comparable", () => {
    const withPrevious = deriveKpis(
      makeReport({
        totals: makeTotals({ exercises: 5, avgScore: 70, learningMinutes: 100 }),
        previous: makeTotals({ exercises: 5, avgScore: 60, learningMinutes: 80 }),
      }),
    );
    expect(withPrevious.scoreDelta).toBe(10);
    expect(withPrevious.learningMinutesDelta).toBe(20);

    const noPrevious = deriveKpis(
      makeReport({ totals: makeTotals({ exercises: 5, avgScore: 70 }) }),
    );
    expect(noPrevious.scoreDelta).toBeNull();
    expect(noPrevious.exercisesDelta).toBeNull();
  });

  it("trouve la plus longue série de jours actifs de la période", () => {
    const days = [
      makeDay("2026-08-09", { activities: 2 }),
      makeDay("2026-08-10"),
      makeDay("2026-08-11", { activities: 1 }),
      makeDay("2026-08-12", { appMinutes: 15 }),
      makeDay("2026-08-13", { activities: 3 }),
      makeDay("2026-08-14"),
    ];
    expect(longestActiveStreak(days)).toBe(3);
  });

  it("formate les durées comme un parent les lit", () => {
    expect(formatMinutes(0)).toBe("—");
    expect(formatMinutes(45)).toBe("45 min");
    expect(formatMinutes(135)).toBe("2 h 15");
    expect(formatMinutes(120)).toBe("2 h");
    expect(formatSeconds(42)).toBe("42 s");
    expect(formatSeconds(600)).toBe("10 min");
  });
});

describe("analyzeSubjects", () => {
  const subject = (over: Record<string, unknown>) => ({
    subjectId: "s",
    name: "Matière",
    colorToken: null,
    gradeName: null,
    minutes: 0,
    lessons: 0,
    exercises: 0,
    previousExercises: 0,
    avgScore: 0,
    scoreDelta: null,
    chaptersTotal: 0,
    chaptersCompleted: 0,
    ...over,
  });

  it("sépare fortes, fragiles, délaissées et en progression", () => {
    const report = makeReport({
      subjects: [
        subject({ subjectId: "math", name: "Maths", exercises: 6, avgScore: 88 }),
        subject({ subjectId: "fr", name: "Français", exercises: 4, avgScore: 45 }),
        subject({ subjectId: "en", name: "Anglais", exercises: 0, previousExercises: 5 }),
        subject({
          subjectId: "svt",
          name: "SVT",
          exercises: 3,
          avgScore: 70,
          scoreDelta: 12,
          chaptersTotal: 0,
          chaptersCompleted: 0,
        }),
      ],
      chapters: [
        {
          chapterId: "c1",
          title: "Fractions",
          subjectId: "math",
          subjectName: "Maths",
          exercises: 3,
          avgScore: 58,
          correct: 17,
          questions: 30,
        },
      ],
    });

    const analysis = analyzeSubjects(report);
    expect(analysis.strong.map((s) => s.subjectId)).toEqual(["math"]);
    expect(analysis.fragile.map((s) => s.subjectId)).toEqual(["fr"]);
    expect(analysis.neglected.map((s) => s.subjectId)).toEqual(["en"]);
    expect(analysis.mostImproved.map((s) => s.subjectId)).toEqual(["svt"]);
    expect(analysis.chaptersToReview.map((c) => c.chapterId)).toEqual(["c1"]);
  });

  it("refuse de qualifier un niveau sur une seule tentative", () => {
    expect(subjectLevel(subject({ exercises: 1, avgScore: 100 }))).toBeNull();
    expect(subjectLevel(subject({ exercises: 4, avgScore: 85 }))).toBe("excellent");
    expect(subjectLevel(subject({ exercises: 4, avgScore: 30 }))).toBe("weak");
  });
});

describe("parseDailyReport", () => {
  it("survit à une charge utile trouée plutôt que de casser l'écran", () => {
    const report = parseDailyReport({
      student: null,
      range: { from: "2026-08-01", to: "2026-08-07", days: "7", measuredSince: null },
      days: null,
      totals: { appMinutes: "42", exercises: null },
      subjects: [{ subjectId: "math", name: "Maths", exercises: "3", avgScore: "80" }],
    });

    expect(report.range.days).toBe(7);
    expect(report.days).toEqual([]);
    expect(report.totals.appMinutes).toBe(42);
    expect(report.totals.exercises).toBe(0);
    expect(report.subjects[0].exercises).toBe(3);
    expect(report.previous.avgScore).toBe(0);
  });

  it("refuse une charge utile qui n'est pas un objet", () => {
    expect(() => parseDailyReport(null)).toThrow();
    expect(() => parseDailyReport("nope")).toThrow();
  });
});

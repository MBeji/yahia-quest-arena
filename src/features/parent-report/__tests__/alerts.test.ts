// @vitest-environment node
import { describe, expect, it } from "vitest";
import { buildAlerts } from "../insights/alerts";
import { makeReport, makeTotals } from "./daily-fixtures";

/**
 * Les alertes sont ce que le parent lira en premier. Deux propriétés comptent
 * autant que leur contenu : elles doivent être RARES (sinon elles deviennent du
 * bruit qu'on apprend à ignorer) et ORDONNÉES (l'avertissement avant le
 * compliment). Les tests portent donc autant sur le silence que sur le signal.
 */

const chapter = (over: Record<string, unknown> = {}) => ({
  chapterId: "chap-fractions",
  title: "Les fractions",
  subjectId: "math",
  subjectName: "Mathématiques",
  exercises: 4,
  avgScore: 58,
  correct: 20,
  questions: 40,
  ...over,
});

const subject = (over: Record<string, unknown> = {}) => ({
  subjectId: "math",
  name: "Mathématiques",
  colorToken: null,
  gradeName: null,
  minutes: 135,
  lessons: 2,
  exercises: 8,
  previousExercises: 8,
  avgScore: 58,
  scoreDelta: null,
  chaptersTotal: 0,
  chaptersCompleted: 0,
  ...over,
});

describe("buildAlerts", () => {
  it("reste muet quand tout va bien", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({
          appMinutes: 90,
          learningMinutes: 85,
          activeDays: 5,
          exercises: 12,
          exercisesPassed: 11,
          correct: 100,
          questions: 110,
          avgScore: 88,
          exerciseSessionsStarted: 12,
          exerciseSessionsCompleted: 12,
          byActivity: { lesson: 30, exercise: 40, quiz: 5, recall: 10, arena: 0, browse: 5 },
        }),
        previous: makeTotals({ exercises: 10, avgScore: 86 }),
      }),
    );
    expect(alerts.filter((a) => a.tone === "warning")).toEqual([]);
  });

  it("produit l'alerte phare : beaucoup de temps, peu de progrès, et où réviser", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({
          appMinutes: 150,
          learningMinutes: 135,
          activeDays: 4,
          exercises: 8,
          exercisesPassed: 3,
          correct: 46,
          questions: 80,
          avgScore: 58,
          exerciseSessionsStarted: 8,
          exerciseSessionsCompleted: 8,
          byActivity: { lesson: 40, exercise: 80, quiz: 5, recall: 10, arena: 0, browse: 15 },
        }),
        previous: makeTotals({ exercises: 8, avgScore: 60 }),
        subjects: [subject()],
        chapters: [chapter()],
      }),
    );

    const flagship = alerts.find((a) => a.key === "timeWithoutProgress");
    expect(flagship).toBeDefined();
    expect(flagship?.params).toMatchObject({
      subjectName: "Mathématiques",
      minutes: 135,
      chapterTitle: "Les fractions",
      chapterScore: 58,
    });
    // Elle doit être ACTIONNABLE : le chapitre à ouvrir voyage avec elle.
    expect(flagship?.chapterId).toBe("chap-fractions");
  });

  it("ne répète pas le chapitre déjà cité par l'alerte phare", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({
          appMinutes: 150,
          learningMinutes: 135,
          exercises: 8,
          avgScore: 55,
          activeDays: 4,
        }),
        previous: makeTotals({ exercises: 8, avgScore: 60 }),
        subjects: [subject()],
        chapters: [chapter()],
      }),
    );
    const cited = alerts.filter((a) => a.chapterId === "chap-fractions" && a.tone === "warning");
    expect(cited.map((a) => a.key)).not.toContain("chapterStruggle");
  });

  it("signale une matière travaillée avant et abandonnée maintenant", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({ exercises: 4, appMinutes: 40, activeDays: 3 }),
        subjects: [
          subject({
            subjectId: "fr",
            name: "Français",
            exercises: 0,
            minutes: 0,
            previousExercises: 6,
          }),
        ],
      }),
    );
    const neglected = alerts.find((a) => a.key === "subjectNeglected");
    expect(neglected?.params).toMatchObject({ subjectName: "Français", previousExercises: 6 });
  });

  it("signale les exercices commencés et jamais finis", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({
          exercises: 3,
          appMinutes: 40,
          activeDays: 3,
          exerciseSessionsStarted: 10,
          exerciseSessionsCompleted: 3,
        }),
      }),
    );
    const abandoned = alerts.find((a) => a.key === "abandonedExercises");
    expect(abandoned?.params).toMatchObject({ started: 10, abandoned: 7, pct: 70 });
  });

  it("ne juge pas la régularité sur une seule journée", () => {
    const oneDay = buildAlerts(
      makeReport({
        range: {
          from: "2026-08-15",
          to: "2026-08-15",
          days: 1,
          timezone: "Africa/Tunis",
          measuredSince: "2026-01-01",
        },
        totals: makeTotals({ exercises: 1, appMinutes: 10, activeDays: 1 }),
      }),
    );
    expect(oneDay.map((a) => a.key)).not.toContain("lowRegularity");
  });

  it("dit qu'il ne s'est rien passé plutôt que d'inventer des motifs", () => {
    const alerts = buildAlerts(makeReport());
    expect(alerts[0].key).toBe("noActivity");
    expect(alerts.some((a) => a.key === "lowRegularity")).toBe(false);
  });

  it("salue une progression et un objectif atteint, après les avertissements", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({
          exercises: 10,
          avgScore: 82,
          appMinutes: 60,
          learningMinutes: 55,
          activeDays: 5,
          exerciseSessionsStarted: 10,
          exerciseSessionsCompleted: 10,
        }),
        previous: makeTotals({ exercises: 10, avgScore: 70 }),
        subjects: [subject({ exercises: 10, avgScore: 82 })],
      }),
      { weeklyGoal: { target: 5, done: 7 } },
    );

    const keys = alerts.map((a) => a.key);
    expect(keys).toContain("improvement");
    expect(keys).toContain("goalReached");

    const firstPositive = alerts.findIndex((a) => a.tone === "positive");
    const lastWarning = alerts.map((a) => a.tone).lastIndexOf("warning");
    expect(lastWarning).toBeLessThan(
      firstPositive === -1 ? Number.POSITIVE_INFINITY : firstPositive,
    );
  });

  it("l'objectif du jour atteint déclenche l'alerte, sans objectif hebdo posé", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({ exercises: 4, avgScore: 80, activeDays: 1 }),
        subjects: [subject({ exercises: 4, avgScore: 80 })],
      }),
      { dailyGoal: { target: 3, done: 4 } },
    );

    const reached = alerts.find((a) => a.key === "goalReached");
    expect(reached?.params).toEqual({ target: 3, done: 4 });
  });

  it("les deux objectifs atteints ne rendent QU'UNE alerte — la plus exigeante", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({ exercises: 12, avgScore: 80, activeDays: 5 }),
        subjects: [subject({ exercises: 12, avgScore: 80 })],
      }),
      { dailyGoal: { target: 3, done: 4 }, weeklyGoal: { target: 10, done: 12 } },
    );

    const reached = alerts.filter((a) => a.key === "goalReached");
    expect(reached).toHaveLength(1);
    expect(reached[0].params).toEqual({ target: 10, done: 12 });
  });

  it("ne rend jamais plus de six alertes", () => {
    const alerts = buildAlerts(
      makeReport({
        totals: makeTotals({
          appMinutes: 200,
          learningMinutes: 190,
          activeDays: 1,
          exercises: 9,
          avgScore: 40,
          exerciseSessionsStarted: 20,
          exerciseSessionsCompleted: 4,
        }),
        previous: makeTotals({ exercises: 9, avgScore: 75 }),
        subjects: [
          subject(),
          subject({
            subjectId: "fr",
            name: "Français",
            exercises: 0,
            minutes: 0,
            previousExercises: 4,
          }),
          subject({
            subjectId: "en",
            name: "Anglais",
            exercises: 0,
            minutes: 0,
            previousExercises: 3,
          }),
        ],
        chapters: [
          chapter(),
          chapter({ chapterId: "c2", title: "Décimaux", avgScore: 40 }),
          chapter({ chapterId: "c3", title: "Aires", avgScore: 35 }),
        ],
      }),
    );
    expect(alerts.length).toBeLessThanOrEqual(6);
  });
});

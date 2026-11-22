// @vitest-environment node
/**
 * Bilan et programme du jour — le contrat (`study-report.schema.ts`) et les lectures pures
 * (`study-report.ts`).
 *
 * Ce que ces tests protègent : (1) une RPC qui dérive ne produit jamais un demi-bilan — le
 * schéma rend `null`, la surface se tait ; (2) le geste « chapitres vus » envoie toujours la
 * déclaration ENTIÈRE de la matière, parce que la base la remplace ; (3) « à travailler »
 * ne montre que des chapitres vus en classe, le plus pressant d'abord.
 */
import { describe, expect, it } from "vitest";

import {
  chaptersToWork,
  examMarkOutOf20,
  focusSubjectIds,
  toggleFocusSubject,
  withStudyPreferences,
  isStudyGoalReached,
  seenThroughChapter,
  studyGoalPercent,
  studyPlanMinutes,
  toggleSeenChapter,
  withSeenChapters,
} from "../study-report";
import { parseStudyReport } from "../study-report.schema";
import { chapter, report, subject } from "./study-report.fixture";

describe("parseStudyReport", () => {
  it("accepte le bilan tel que la RPC le rend, détail des chapitres compris", () => {
    expect(parseStudyReport(report())).toEqual(report());
  });

  it("accepte le bilan sans le détail (tableau de bord) et sans parcours", () => {
    const light = report({ parcoursId: null, subjects: [subject({ chapters: null })] });
    expect(parseStudyReport(light)?.subjects[0]?.chapters).toBeNull();
  });

  it("rend null sur une forme inattendue — jamais un demi-bilan", () => {
    expect(parseStudyReport(null)).toBeNull();
    expect(parseStudyReport({ ...report(), plan: "rien" })).toBeNull();
    expect(
      parseStudyReport(report({ subjects: [{ ...subject(), level: "excellent" as never }] })),
    ).toBeNull();
    expect(
      parseStudyReport(report({ plan: [{ ...report().plan[0]!, kind: "review" as never }] })),
    ).toBeNull();
  });
});

describe("l'objectif du jour", () => {
  it("est atteint quand le temps mesuré couvre l'objectif", () => {
    expect(isStudyGoalReached({ doneMinutes: 29, targetMinutes: 30 })).toBe(false);
    expect(isStudyGoalReached({ doneMinutes: 30, targetMinutes: 30 })).toBe(true);
  });

  it("se lit en pourcentage borné à 100", () => {
    expect(studyGoalPercent({ doneMinutes: 10, targetMinutes: 30 })).toBe(33);
    expect(studyGoalPercent({ doneMinutes: 45, targetMinutes: 30 })).toBe(100);
    expect(studyGoalPercent({ doneMinutes: 0, targetMinutes: 0 })).toBe(100);
  });

  it("additionne la durée estimée de ce qui reste", () => {
    expect(studyPlanMinutes(report().plan)).toBe(9);
    expect(studyPlanMinutes([])).toBe(0);
  });
});

describe("examMarkOutOf20", () => {
  it("ramène la note sur 20, au dixième", () => {
    expect(examMarkOutOf20({ scorePoints: 135, maxPoints: 200 })).toBe(13.5);
    expect(examMarkOutOf20({ scorePoints: 7, maxPoints: 9 })).toBe(15.6);
  });
});

describe("chaptersToWork", () => {
  it("ne garde que les chapitres VUS non acquis : fragile, puis en cours, puis non commencé", () => {
    const chapters = [
      chapter({ id: "a", status: "non-commence" }),
      chapter({ id: "b", status: "acquis" }),
      chapter({ id: "c", status: "en-cours" }),
      chapter({ id: "d", status: "fragile" }),
      chapter({ id: "e", status: "maitrise" }),
      chapter({ id: "f", status: "fragile", seen: false }),
    ];
    expect(chaptersToWork(chapters).map((c) => c.id)).toEqual(["d", "c", "a"]);
  });
});

describe("la déclaration des chapitres vus", () => {
  const chapters = subject().chapters ?? [];

  it("cocher un chapitre rend la liste entière, lui compris", () => {
    expect(toggleSeenChapter(chapters, "c4")).toEqual(["c1", "c2", "c3", "c4"]);
  });

  it("décocher un chapitre rend la liste entière, sans lui", () => {
    expect(toggleSeenChapter(chapters, "c2")).toEqual(["c1", "c3"]);
  });

  it("« j'en suis là » coche tout jusqu'au chapitre, et rien après", () => {
    expect(seenThroughChapter(chapters, "c2")).toEqual(["c1", "c2"]);
    expect(seenThroughChapter(chapters, "c4")).toEqual(["c1", "c2", "c3", "c4"]);
  });

  it("« j'en suis là » sur un chapitre inconnu ne change rien", () => {
    expect(seenThroughChapter(chapters, "zz")).toEqual(["c1", "c2", "c3"]);
  });

  it("withSeenChapters applique la déclaration à la seule matière visée", () => {
    const base = report({ subjects: [subject(), subject({ id: "fr", name: "Français" })] });
    const next = withSeenChapters(base, "math", ["c1"]);
    expect(next.subjects[0]?.chapters?.map((c) => c.seen)).toEqual([true, false, false, false]);
    expect(next.subjects[0]?.chaptersSeen).toBe(1);
    expect(next.subjects[0]?.declared).toBe(true);
    expect(next.subjects[1]).toEqual(base.subjects[1]);
  });

  it("une déclaration vide rend la matière à l'estimation — le serveur dira laquelle", () => {
    const next = withSeenChapters(report(), "math", []);
    expect(next.subjects[0]?.declared).toBe(false);
    expect(next.subjects[0]?.chaptersSeen).toBe(3);
  });

  it("sans détail des chapitres, rien à appliquer", () => {
    const light = report({ subjects: [subject({ chapters: null })] });
    expect(withSeenChapters(light, "math", ["c1"])).toEqual(light);
  });
});

describe("les réglages : matières prioritaires et objectif", () => {
  const three = report({
    subjects: [
      subject({ id: "math" }),
      subject({ id: "fr", focus: true }),
      subject({ id: "ar", focus: false }),
    ],
  });

  it("le schéma accepte le bilan avec ou sans le drapeau « prioritaire »", () => {
    expect(parseStudyReport(three)?.subjects.map((s) => s.focus)).toEqual([undefined, true, false]);
  });

  it("focusSubjectIds rend les matières prioritaires, dans l'ordre du parcours", () => {
    expect(focusSubjectIds(three)).toEqual(["fr"]);
    expect(focusSubjectIds(report())).toEqual([]);
  });

  it("basculer une matière l'ajoute ou la retire, dans l'ordre du parcours", () => {
    expect(toggleFocusSubject(three, "math")).toEqual(["math", "fr"]);
    expect(toggleFocusSubject(three, "fr")).toEqual([]);
  });

  it("une troisième matière prioritaire est refusée", () => {
    const two = withStudyPreferences(three, { focusSubjectIds: ["math", "fr"] });
    expect(toggleFocusSubject(two, "ar")).toBeNull();
    expect(toggleFocusSubject(two, "math")).toEqual(["fr"]);
  });

  it("withStudyPreferences applique l'objectif et les matières, sans toucher au reste", () => {
    const next = withStudyPreferences(three, { dailyMinutes: 45 });
    expect(next.targetMinutes).toBe(45);
    expect(next.subjects).toBe(three.subjects);
    const focused = withStudyPreferences(three, { focusSubjectIds: ["ar"] });
    expect(focused.targetMinutes).toBe(30);
    expect(focusSubjectIds(focused)).toEqual(["ar"]);
  });
});

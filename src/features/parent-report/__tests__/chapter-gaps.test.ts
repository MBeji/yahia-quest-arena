// @vitest-environment node
import { describe, expect, it } from "vitest";

import { chapterGapRows, gapBlocker } from "@/features/parent-report/insights";
import type { ChapterGap, DailyReport } from "@/features/parent-report/insights";
import { makeReport } from "./daily-fixtures";

const gap = (over: Partial<ChapterGap> = {}): ChapterGap => ({
  subjectId: "math",
  chapterId: "ch-1",
  title: "Les fractions",
  missionsTotal: 6,
  missionsPassed: 4,
  quizGated: true,
  quizSatisfied: true,
  ...over,
});

/** Le rapport tel que l'écran le reçoit, avec une matière nommée pour s'y rattacher. */
function reportWith(
  gaps: ChapterGap[],
  subjects = [{ id: "math", name: "الرياضيات" }],
): DailyReport {
  return makeReport({
    chapterGaps: gaps,
    subjects: subjects.map((s) => ({
      subjectId: s.id,
      name: s.name,
      colorToken: null,
      gradeName: "9ème année de base",
      minutes: 0,
      lessons: 0,
      exercises: 0,
      previousExercises: 0,
      avgScore: 0,
      scoreDelta: null,
      chaptersTotal: 20,
      chaptersCompleted: 3,
    })),
  });
}

describe("ce qui bloque un chapitre", () => {
  it("nomme les trois formes, et seulement elles", () => {
    expect(gapBlocker(gap({ missionsPassed: 4, missionsTotal: 6, quizSatisfied: true }))).toBe(
      "missions",
    );
    expect(gapBlocker(gap({ missionsPassed: 6, missionsTotal: 6, quizSatisfied: false }))).toBe(
      "quiz",
    );
    expect(gapBlocker(gap({ missionsPassed: 4, missionsTotal: 6, quizSatisfied: false }))).toBe(
      "both",
    );
  });

  it("ignore le quiz d'une matière NON scolaire — elle n'a pas de théorie à valider", () => {
    // Culture générale, IQ, langues : `quizGated` est faux, et un `quizSatisfied`
    // à faux qui traînerait ne doit pas inventer un geste qui n'existe pas.
    expect(gapBlocker(gap({ quizGated: false, quizSatisfied: false, missionsPassed: 6 }))).toBe(
      "missions",
    );
  });
});

describe("les lignes affichées", () => {
  it("met LE PLUS PROCHE DU BUT en tête — celui à qui il ne manque que le quiz", () => {
    // C'est tout l'objet du tri : ce chapitre-là est à UN geste, et personne ne
    // sait aujourd'hui que ce geste est dû. L'enterrer sous des chapitres à
    // quatre missions près reviendrait à ne rien afficher.
    const rows = chapterGapRows(
      reportWith([
        gap({ chapterId: "loin", title: "Loin", missionsPassed: 1, missionsTotal: 6 }),
        gap({
          chapterId: "quiz-seul",
          title: "Quiz seul",
          missionsPassed: 6,
          missionsTotal: 6,
          quizSatisfied: false,
        }),
        gap({ chapterId: "presque", title: "Presque", missionsPassed: 5, missionsTotal: 6 }),
      ]),
    );

    expect(rows.map((r) => r.chapterId)).toEqual(["quiz-seul", "presque", "loin"]);
    expect(rows[0].blocker).toBe("quiz");
    expect(rows[0].missionsRemaining).toBe(0);
  });

  it("rattache chaque lacune à sa matière ET à son niveau", () => {
    // Sans le niveau, « Mathématiques » apparaît autant de fois que l'élève
    // suit de classes, et aucune ligne ne se relie à rien.
    const [row] = chapterGapRows(reportWith([gap()]));
    expect(row.subjectName).toBe("الرياضيات");
    expect(row.gradeName).toBe("9ème année de base");
    expect(row.missionsPassed).toBe(4);
    expect(row.missionsTotal).toBe(6);
    expect(row.missionsRemaining).toBe(2);
  });

  it("écarte une lacune dont la matière est absente du rapport", () => {
    // Elle s'afficherait sans nom : un chapitre orphelin n'aide personne.
    const rows = chapterGapRows(reportWith([gap({ subjectId: "matiere-filtree" })]));
    expect(rows).toEqual([]);
  });

  it("borne la liste — le suivi propose, il n'assomme pas", () => {
    const many = Array.from({ length: 12 }, (_, i) =>
      gap({ chapterId: `ch-${i}`, title: `Chapitre ${i}`, missionsPassed: i % 6 }),
    );
    expect(chapterGapRows(reportWith(many)).length).toBe(6);
    expect(chapterGapRows(reportWith(many), 2).length).toBe(2);
  });

  it("ne tombe pas sur des comptes incohérents venus du serveur", () => {
    // `missionsPassed > missionsTotal` ne doit jamais produire un « -2 missions
    // à réussir » : un tableau de bord parental affiche zéro et continue.
    const [row] = chapterGapRows(reportWith([gap({ missionsPassed: 9, missionsTotal: 6 })]));
    expect(row.missionsRemaining).toBe(0);
    expect(row.missionsPassed).toBe(6);
  });

  it("ne rend rien quand tout est maîtrisé — pas de bloc vide à l'écran", () => {
    expect(chapterGapRows(reportWith([]))).toEqual([]);
  });
});

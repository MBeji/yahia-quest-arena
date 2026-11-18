import { describe, expect, it } from "vitest";

import {
  schoolYearProgress,
  selectableThroughChapters,
  suggestThroughChapterId,
  type ScopeChapter,
} from "../placement-scope";

/**
 * Étude 39 R-22 — la proposition du calendrier : une part de l'année de cours, un chapitre
 * atteint. Le serveur reste le juge de la portée ; ici, seulement la valeur par défaut.
 */
const chapters = (n: number, enoughFrom = 1): ScopeChapter[] =>
  Array.from({ length: n }, (_, i) => ({
    chapterId: `c${i + 1}`,
    title: `Chapitre ${i + 1}`,
    enough: i + 1 >= enoughFrom,
  }));

describe("schoolYearProgress", () => {
  it("vaut 0 à la rentrée et avant le premier cours de l'année", () => {
    expect(schoolYearProgress(new Date(2026, 8, 15))).toBe(0);
  });

  it("avance avec l'année : un quart à la mi-novembre, la moitié fin janvier", () => {
    expect(schoolYearProgress(new Date(2026, 10, 18))).toBeCloseTo(0.25, 1);
    expect(schoolYearProgress(new Date(2027, 0, 22))).toBeCloseTo(0.5, 1);
  });

  it("vaut 1 de la fin des cours à la rentrée suivante — juin, l'été, début septembre", () => {
    expect(schoolYearProgress(new Date(2027, 4, 31))).toBe(1);
    expect(schoolYearProgress(new Date(2027, 5, 20))).toBe(1);
    expect(schoolYearProgress(new Date(2027, 7, 10))).toBe(1);
    expect(schoolYearProgress(new Date(2027, 8, 14))).toBe(1);
  });
});

describe("suggestThroughChapterId", () => {
  it("mi-novembre, vingt chapitres : le cinquième", () => {
    expect(suggestThroughChapterId(chapters(20), new Date(2026, 10, 18))).toBe("c5");
  });

  it("à la rentrée : le premier chapitre qui porte un test, jamais un test tronqué", () => {
    expect(suggestThroughChapterId(chapters(6, 2), new Date(2026, 8, 16))).toBe("c2");
  });

  it("en fin d'année, l'été, ou sur une matière d'un chapitre : tout le programme", () => {
    expect(suggestThroughChapterId(chapters(6), new Date(2027, 5, 1))).toBeNull();
    expect(suggestThroughChapterId(chapters(6), new Date(2027, 4, 20))).toBeNull();
    expect(suggestThroughChapterId(chapters(1), new Date(2026, 10, 18))).toBeNull();
    expect(suggestThroughChapterId([], new Date(2026, 10, 18))).toBeNull();
  });
});

describe("selectableThroughChapters", () => {
  it("propose les chapitres qui portent un test, sauf le dernier (= tout le programme)", () => {
    expect(selectableThroughChapters(chapters(4, 2)).map((c) => c.chapterId)).toEqual(["c2", "c3"]);
    expect(selectableThroughChapters(chapters(1))).toEqual([]);
  });
});

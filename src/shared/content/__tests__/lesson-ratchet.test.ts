// @vitest-environment node
import { describe, it, expect } from "vitest";
import {
  lessonPatternFindings,
  lessonRatchet,
  PATTERN_THEME,
} from "../../../../scripts/content/lesson-ratchet.ts";
import type { LoadedSubject } from "../schema.ts";

/**
 * Le cliquet du patron de notion (é35). Ce que ces tests protègent : (1) un cours au patron
 * ne compte aucun constat et un cours qui énonce en compte, (2) un chapitre neuf du programme
 * doit naître au patron, (3) un cours retouché peut garder sa dette sans l'aggraver, et (4)
 * rien ne crie sur un cours inchangé ni sur un chapitre neuf hors programme.
 */

// Une section au patron : amorce (T1), règle (T2), exemple (T4), erreur typique (T5),
// vérification (T7).
const AT_PATTERN = [
  "# Leçon",
  "",
  "## La notion",
  "",
  "Sami achète trois cahiers au même prix ; il paie 6 dinars.",
  "Combien coûte un cahier ?",
  "",
  "::: definition Le prix unitaire",
  "Le prix d'une unité.",
  ":::",
  "",
  "::: exemple Le cahier",
  "1. 6 ÷ 3 = 2.",
  ":::",
  "",
  "> ⚠️ L'erreur typique : diviser 3 par 6. On partage le prix, pas les cahiers.",
  "",
  "::: verifie À toi",
  "Quatre stylos coûtent 8 dinars : un stylo ?",
  "---",
  "2 dinars.",
  ":::",
].join("\n");

// Le même savoir à l'ancienne : la règle d'emblée, ni exemple ni vérification.
const STATES = [
  "# Leçon",
  "",
  "## La notion",
  "",
  "::: definition Le prix unitaire",
  "Le prix d'une unité.",
  ":::",
].join("\n");

// Un cours sans aucun bloc de savoir : invisible pour le régime souple, compté par le strict.
const NO_BLOCK = [
  "# Leçon",
  "",
  "## La notion",
  "",
  "Le prix unitaire est le prix d'une unité.",
].join("\n");

const subject = (
  themeId: string,
  chapters: Array<{ slug: string; lesson: string }>,
): LoadedSubject =>
  ({
    meta: { id: "s", themeId },
    chapters: chapters.map((c) => ({ ...c, summary: "", quiz: { questions: [] }, exercises: [] })),
  }) as unknown as LoadedSubject;

describe("lessonPatternFindings — le régime strict", () => {
  it("ne compte rien sur un cours au patron", () => {
    expect(lessonPatternFindings(AT_PATTERN, "01-a")).toBe(0);
  });

  it("compte la règle sans exemple, la section qui ouvre sur sa règle et l'erreur typique absente", () => {
    expect(lessonPatternFindings(STATES, "01-a")).toBe(3);
  });

  it("voit le cours qui n'a aucun bloc de savoir, que le régime souple laisse passer", () => {
    expect(lessonPatternFindings(NO_BLOCK, "01-a")).toBe(2);
  });
});

describe("lessonRatchet — un cours neuf naît au patron, un cours retouché ne recule pas", () => {
  const all = new Set(["01-a", "02-b"]);

  it("refuse un chapitre neuf du programme écrit à l'ancienne", () => {
    const now = subject(PATTERN_THEME, [{ slug: "01-a", lesson: STATES }]);
    expect(lessonRatchet(now, all, null)).toEqual([
      { chapter: "01-a", base: null, now: 3, regressed: true },
    ]);
  });

  it("accepte un chapitre neuf du programme écrit au patron", () => {
    const now = subject(PATTERN_THEME, [{ slug: "01-a", lesson: AT_PATTERN }]);
    expect(lessonRatchet(now, all, null)[0].regressed).toBe(false);
  });

  it("ne tient pas au zéro un chapitre neuf hors programme", () => {
    const now = subject("anglais", [{ slug: "01-a", lesson: STATES }]);
    expect(lessonRatchet(now, all, null)[0]).toMatchObject({ now: 3, regressed: false });
  });

  it("laisse un cours retouché garder sa dette, mais pas l'aggraver", () => {
    const base = subject(PATTERN_THEME, [{ slug: "01-a", lesson: NO_BLOCK }]);
    const same = subject(PATTERN_THEME, [
      { slug: "01-a", lesson: `${NO_BLOCK}\nUne phrase de plus.` },
    ]);
    const worse = subject(PATTERN_THEME, [{ slug: "01-a", lesson: STATES }]);
    expect(lessonRatchet(same, all, base)[0]).toMatchObject({ base: 2, now: 2, regressed: false });
    expect(lessonRatchet(worse, all, base)[0]).toMatchObject({ base: 2, now: 3, regressed: true });
  });

  it("vaut aussi hors programme pour un cours retouché", () => {
    const base = subject("anglais", [{ slug: "01-a", lesson: AT_PATTERN }]);
    const now = subject("anglais", [{ slug: "01-a", lesson: STATES }]);
    expect(lessonRatchet(now, all, base)[0].regressed).toBe(true);
  });

  it("ignore un cours inchangé et un chapitre hors tranche", () => {
    const base = subject(PATTERN_THEME, [
      { slug: "01-a", lesson: STATES },
      { slug: "02-b", lesson: STATES },
    ]);
    const now = subject(PATTERN_THEME, [
      { slug: "01-a", lesson: STATES },
      { slug: "02-b", lesson: `${STATES}\n` },
    ]);
    expect(lessonRatchet(now, new Set(["01-a"]), base)).toEqual([]);
  });
});

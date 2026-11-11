// @vitest-environment node
import { describe, expect, it } from "vitest";

import { LOCKED_CHAPTER_STEPS, chapterSteps, fillGuideText, guideScreenFor } from "../guide";
import {
  GUIDE_TIPS_KEY,
  browserGuideStorage,
  guideIntroKey,
  readIntroDismissed,
  readTipsEnabled,
  writeIntroDismissed,
  writeTipsEnabled,
  type GuideStorage,
} from "../guide-storage";

function memoryStorage(): GuideStorage & { data: Map<string, string> } {
  const data = new Map<string, string>();
  return {
    data,
    getItem: (key) => data.get(key) ?? null,
    setItem: (key, value) => {
      data.set(key, value);
    },
  };
}

const brokenStorage: GuideStorage = {
  getItem: () => {
    throw new Error("SecurityError");
  },
  setItem: () => {
    throw new Error("QuotaExceededError");
  },
};

describe("guideScreenFor — la fiche de l'écran affiché", () => {
  it.each([
    ["/dashboard", "dashboard"],
    ["/parcours", "parcours"],
    ["/programme", "programme"],
    ["/programme/lycee/1", "programme"],
    ["/niveau/p1", "programme"],
    ["/extras", "programme"],
    ["/themes", "programme"],
    ["/arene", "arena"],
    ["/dungeon", "arena"],
    ["/duel/d1", "arena"],
    ["/leaderboard", "arena"],
    ["/matiere/s1", "subject"],
    ["/subject/s1", "subject"],
    ["/chapitre/c1", "lesson"],
    ["/lesson/c1", "lesson"],
    ["/quest/e1", "quest"],
    ["/exercice/e1", "quest"],
    ["/parent-report", "parent"],
    ["/suivi", "suivi"],
    ["/parametrage", "settings"],
    ["/", "general"],
    ["/login", "general"],
  ])("%s → %s", (path, screen) => {
    expect(guideScreenFor(path)).toBe(screen);
  });

  it("ne confond pas un préfixe : /parcoursx n'est pas la carte", () => {
    expect(guideScreenFor("/parcoursx")).toBe("general");
  });
});

describe("chapterSteps — où en est l'élève dans les 3 étapes", () => {
  it("sans porte (pas de quiz, thème hors école), aucun parcours à afficher", () => {
    expect(chapterSteps({ gated: false, cleared: false })).toBeNull();
    expect(chapterSteps({ gated: false, cleared: true })).toBeNull();
  });

  it("porte fermée : le cours maintenant, le quiz ensuite, les missions fermées", () => {
    expect(chapterSteps({ gated: true, cleared: false })).toEqual({
      lesson: "current",
      quiz: "next",
      missions: "locked",
    });
    expect(chapterSteps({ gated: true, cleared: false })).toBe(LOCKED_CHAPTER_STEPS);
  });

  it("quiz réussi : cours et quiz faits, les missions sont l'étape du moment", () => {
    expect(chapterSteps({ gated: true, cleared: true })).toEqual({
      lesson: "done",
      quiz: "done",
      missions: "current",
    });
  });
});

describe("mémoire de l'appareil", () => {
  it("les bulles sont allumées par défaut, et seul un « off » explicite les éteint", () => {
    const storage = memoryStorage();
    expect(readTipsEnabled(storage)).toBe(true);
    writeTipsEnabled(storage, false);
    expect(storage.data.get(GUIDE_TIPS_KEY)).toBe("off");
    expect(readTipsEnabled(storage)).toBe(false);
    writeTipsEnabled(storage, true);
    expect(readTipsEnabled(storage)).toBe(true);
  });

  it("une carte de première visite se ferme écran par écran", () => {
    const storage = memoryStorage();
    expect(readIntroDismissed(storage, "dashboard")).toBe(false);
    writeIntroDismissed(storage, "dashboard");
    expect(storage.data.get(guideIntroKey("dashboard"))).toBe("seen");
    expect(readIntroDismissed(storage, "dashboard")).toBe(true);
    expect(readIntroDismissed(storage, "subject")).toBe(false);
  });

  it("sans stockage, ou s'il refuse, retombe sur l'aide visible sans planter", () => {
    expect(readTipsEnabled(null)).toBe(true);
    expect(readIntroDismissed(null, "parent")).toBe(false);
    expect(readTipsEnabled(brokenStorage)).toBe(true);
    expect(readIntroDismissed(brokenStorage, "parent")).toBe(false);
    expect(() => writeTipsEnabled(brokenStorage, false)).not.toThrow();
    expect(() => writeIntroDismissed(brokenStorage, "parent")).not.toThrow();
    expect(() => writeTipsEnabled(null, false)).not.toThrow();
  });

  it("côté serveur (pas de window), il n'y a pas de stockage", () => {
    expect(browserGuideStorage()).toBeNull();
  });
});

describe("fillGuideText", () => {
  it("remplace chaque {clé} connue et laisse les autres intactes", () => {
    expect(fillGuideText("{pct} % en {sec} s — {pct}", { pct: 80, sec: 4 })).toBe(
      "80 % en 4 s — 80",
    );
    expect(fillGuideText("Aide : {label} {inconnu}", { label: "Cours" })).toBe(
      "Aide : Cours {inconnu}",
    );
  });
});

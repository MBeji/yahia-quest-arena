import { readFileSync } from "node:fs";
import { join } from "node:path";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import {
  ANON_CONTINUITY_TTL_MS,
  LAST_CHAPTER_KEY,
  QUIZ_PASSED_KEY,
  daysSince,
  forgetAnonContinuity,
  hasPassedQuizOnDevice,
  readLastChapter,
  rememberLastChapter,
  rememberQuizPassed,
  subscribeAnonContinuity,
} from "@/shared/lib/anon-continuity";

/**
 * Étude 38 lot 5 — LA CONTINUITÉ DU VISITEUR : ce que son appareil retient, trente jours.
 *
 * Les critères du lot qui se prouvent ici : TTL échu ⇒ rien ; « oublier » ⇒ rien ; stockage jeté,
 * illisible ou indisponible ⇒ le comportement d'avant, sans erreur ; aucun score mémorisé ; rien
 * ne part au serveur.
 */
const DAY = 24 * 60 * 60 * 1000;
const NOW = Date.UTC(2026, 10, 12, 9, 0, 0);

beforeEach(() => {
  window.localStorage.clear();
});
afterEach(() => {
  vi.restoreAllMocks();
});

describe("le dernier chapitre lu", () => {
  it("⭐ un chapitre lu est rendu à la lecture suivante, titre et langue compris", () => {
    expect(readLastChapter(NOW)).toBeNull();
    expect(
      rememberLastChapter({ id: "ch-fractions", title: "Les fractions", lang: "fr" }, NOW),
    ).toBe(true);
    expect(readLastChapter(NOW + DAY)).toEqual({
      id: "ch-fractions",
      title: "Les fractions",
      lang: "fr",
      at: NOW,
    });
  });

  it("c'est le DERNIER chapitre qui compte : une lecture remplace la précédente", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" }, NOW);
    rememberLastChapter({ id: "ch-2", title: "Deux" }, NOW + 1000);
    expect(readLastChapter(NOW + 2000)?.id).toBe("ch-2");
  });

  it("⭐ TTL échu ⇒ rien : trente jours tenus, une milliseconde de plus oubliée", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" }, NOW);
    expect(readLastChapter(NOW + ANON_CONTINUITY_TTL_MS)?.id).toBe("ch-1");
    expect(readLastChapter(NOW + ANON_CONTINUITY_TTL_MS + 1)).toBeNull();
  });

  it("une date dans le futur (horloge reculée, stockage trafiqué) n'est pas crue", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" }, NOW);
    expect(readLastChapter(NOW - DAY)).toBeNull();
  });

  it("rend le MÊME objet tant que la mémoire n'a pas changé (instantané stable)", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" }, NOW);
    expect(readLastChapter(NOW + 1)).toBe(readLastChapter(NOW + 2));
  });

  it("refuse ce qui ne peut pas être un chapitre : identifiant hostile, titre vide ou démesuré", () => {
    expect(rememberLastChapter({ id: "../auth?x=1", title: "Un" }, NOW)).toBe(false);
    expect(rememberLastChapter({ id: "ch-1", title: "   " }, NOW)).toBe(false);
    expect(rememberLastChapter({ id: "ch-1", title: "x".repeat(201) }, NOW)).toBe(false);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
  });

  it("une langue qui n'en est pas une est ignorée, pas le chapitre", () => {
    rememberLastChapter({ id: "ch-1", title: "Un", lang: '"><script>' }, NOW);
    expect(readLastChapter(NOW)).toMatchObject({ id: "ch-1", lang: null });
  });

  it.each([
    ["du JSON cassé", "{pas du json"],
    ["un tableau", "[1,2]"],
    ["un identifiant hostile", JSON.stringify({ id: "//evil.tn", title: "T", at: NOW })],
    ["un titre absent", JSON.stringify({ id: "ch-1", at: NOW })],
    ["une date qui n'est pas un nombre", JSON.stringify({ id: "ch-1", title: "T", at: "hier" })],
  ])("un stockage illisible (%s) ⇒ rien, sans erreur", (_label, raw) => {
    window.localStorage.setItem(LAST_CHAPTER_KEY, raw);
    expect(readLastChapter(NOW)).toBeNull();
  });
});

describe("les quiz de compréhension réussis", () => {
  it("⭐ une réussite tient trente jours, chapitre par chapitre", () => {
    expect(hasPassedQuizOnDevice("ch-1", NOW)).toBe(false);
    rememberQuizPassed("ch-1", NOW);
    expect(hasPassedQuizOnDevice("ch-1", NOW + 29 * DAY)).toBe(true);
    expect(hasPassedQuizOnDevice("ch-2", NOW + 29 * DAY)).toBe(false);
    expect(hasPassedQuizOnDevice("ch-1", NOW + ANON_CONTINUITY_TTL_MS + 1)).toBe(false);
  });

  it("une réussite périmée ne survit pas à l'écriture suivante", () => {
    rememberQuizPassed("ch-vieux", NOW);
    rememberQuizPassed("ch-neuf", NOW + 31 * DAY);
    expect(JSON.parse(window.localStorage.getItem(QUIZ_PASSED_KEY) ?? "{}")).toEqual({
      "ch-neuf": NOW + 31 * DAY,
    });
  });

  it("⭐ STOP-POINT : aucun score mémorisé — une date par chapitre, rien d'autre", () => {
    rememberQuizPassed("ch-1", NOW);
    rememberLastChapter({ id: "ch-1", title: "Un", lang: "fr" }, NOW);
    expect(JSON.parse(window.localStorage.getItem(QUIZ_PASSED_KEY) ?? "null")).toEqual({
      "ch-1": NOW,
    });
    expect(Object.keys(JSON.parse(window.localStorage.getItem(LAST_CHAPTER_KEY) ?? "{}"))).toEqual([
      "id",
      "title",
      "lang",
      "at",
    ]);
  });

  it("la mémoire ne grossit pas sans fin : les 200 réussites les plus récentes", () => {
    for (let i = 0; i < 205; i += 1) rememberQuizPassed(`ch-${i}`, NOW + i);
    const kept = JSON.parse(window.localStorage.getItem(QUIZ_PASSED_KEY) ?? "{}") as object;
    expect(Object.keys(kept)).toHaveLength(200);
    expect(hasPassedQuizOnDevice("ch-0", NOW + 300)).toBe(false);
    expect(hasPassedQuizOnDevice("ch-204", NOW + 300)).toBe(true);
  });

  it("un identifiant vide ou hostile n'est ni lu ni écrit", () => {
    expect(rememberQuizPassed(null, NOW)).toBe(false);
    expect(rememberQuizPassed("", NOW)).toBe(false);
    expect(rememberQuizPassed("a b", NOW)).toBe(false);
    expect(hasPassedQuizOnDevice(undefined, NOW)).toBe(false);
    expect(window.localStorage.getItem(QUIZ_PASSED_KEY)).toBeNull();
  });

  it("un stockage illisible ⇒ porte fermée, et la réussite suivante le réécrit proprement", () => {
    window.localStorage.setItem(QUIZ_PASSED_KEY, "{pas du json");
    expect(hasPassedQuizOnDevice("ch-1", NOW)).toBe(false);
    rememberQuizPassed("ch-1", NOW);
    expect(hasPassedQuizOnDevice("ch-1", NOW)).toBe(true);
  });
});

describe("« oublier »", () => {
  it("⭐ efface le chapitre ET les quiz, et prévient les abonnés", () => {
    rememberLastChapter({ id: "ch-1", title: "Un" }, NOW);
    rememberQuizPassed("ch-1", NOW);
    const listener = vi.fn();
    const unsubscribe = subscribeAnonContinuity(listener);

    forgetAnonContinuity();

    expect(readLastChapter(NOW)).toBeNull();
    expect(hasPassedQuizOnDevice("ch-1", NOW)).toBe(false);
    expect(window.localStorage.getItem(LAST_CHAPTER_KEY)).toBeNull();
    expect(window.localStorage.getItem(QUIZ_PASSED_KEY)).toBeNull();
    expect(listener).toHaveBeenCalledTimes(1);

    unsubscribe();
    forgetAnonContinuity();
    expect(listener).toHaveBeenCalledTimes(1);
  });

  it("un autre onglet qui écrit ou vide la mémoire prévient aussi les abonnés", () => {
    const listener = vi.fn();
    const unsubscribe = subscribeAnonContinuity(listener);
    window.dispatchEvent(new StorageEvent("storage", { key: LAST_CHAPTER_KEY }));
    window.dispatchEvent(new StorageEvent("storage", { key: null }));
    window.dispatchEvent(new StorageEvent("storage", { key: "autre.chose" }));
    expect(listener).toHaveBeenCalledTimes(2);
    unsubscribe();
  });
});

describe("stockage indisponible — le comportement d'avant, sans erreur", () => {
  it("⭐ `localStorage` qui lève (navigation privée, quota) : rien n'est retenu, rien ne casse", () => {
    const boom = () => {
      throw new DOMException("refusé", "SecurityError");
    };
    vi.spyOn(Storage.prototype, "getItem").mockImplementation(boom);
    vi.spyOn(Storage.prototype, "setItem").mockImplementation(boom);
    vi.spyOn(Storage.prototype, "removeItem").mockImplementation(boom);

    expect(rememberLastChapter({ id: "ch-1", title: "Un" }, NOW)).toBe(false);
    expect(readLastChapter(NOW)).toBeNull();
    expect(rememberQuizPassed("ch-1", NOW)).toBe(false);
    expect(hasPassedQuizOnDevice("ch-1", NOW)).toBe(false);
    expect(() => forgetAnonContinuity()).not.toThrow();
  });

  it("l'accès même à `window.localStorage` qui lève est absorbé", () => {
    const getter = vi.spyOn(window, "localStorage", "get").mockImplementation(() => {
      throw new DOMException("refusé", "SecurityError");
    });
    expect(readLastChapter(NOW)).toBeNull();
    expect(rememberLastChapter({ id: "ch-1", title: "Un" }, NOW)).toBe(false);
    expect(hasPassedQuizOnDevice("ch-1", NOW)).toBe(false);
    getter.mockRestore();
  });
});

describe("la mesure", () => {
  it("`daysSince` compte des jours pleins, jamais négatifs", () => {
    expect(daysSince(NOW, NOW + 23 * 60 * 60 * 1000)).toBe(0);
    expect(daysSince(NOW, NOW + DAY)).toBe(1);
    expect(daysSince(NOW, NOW + 12 * DAY + 5)).toBe(12);
    expect(daysSince(NOW, NOW - DAY)).toBe(0);
  });
});

describe("STOP-POINT — rien n'atteint le serveur", () => {
  it("⭐ le module n'importe rien : ni client Supabase, ni server fn, ni mesure, ni `fetch`", () => {
    const source = readFileSync(join(process.cwd(), "src/shared/lib/anon-continuity.ts"), "utf8");
    const code = source
      .split("\n")
      .filter((line) => !line.trim().startsWith("//") && !line.trim().startsWith("*"))
      .join("\n");
    expect(code).not.toMatch(/\bimport\b/);
    expect(code).not.toMatch(/\bfetch\s*\(|sendBeacon|XMLHttpRequest|document\.cookie/);
  });
});

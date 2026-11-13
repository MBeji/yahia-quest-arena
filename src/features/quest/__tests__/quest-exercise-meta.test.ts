// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * getExerciseMeta — ce que le <head> d'une page d'entraînement publique reçoit au
 * rendu serveur : trois noms, une seule lecture, jamais une question.
 */

const mockFrom = vi.fn();
const mockSupabase = { from: mockFrom };

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      validator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: { data: unknown }) =>
          handlerFn({
            data: validatorFn ? validatorFn(input.data) : input.data,
            context: { supabase: mockSupabase, userId: null },
          });
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: "mock-optional-middleware",
}));

vi.mock("@tanstack/react-start/server", () => ({
  getRequest: vi.fn(() => ({ headers: new Headers() })),
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn().mockResolvedValue(false),
  isRateLimitedLocal: vi.fn().mockReturnValue(false),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

import { getExerciseMeta } from "@/features/quest/quest.practice.server";
import { logger } from "@/shared/lib/logger";

const EXERCISE_ID = "6e7219be-5c5a-586e-bedd-318a6262ec8f";

function mockLookup(result: { data: unknown; error: unknown }) {
  const select = vi.fn();
  const eq = vi.fn();
  const maybeSingle = vi.fn().mockResolvedValue(result);
  select.mockReturnValue({ eq });
  eq.mockReturnValue({ maybeSingle });
  mockFrom.mockReturnValue({ select });
  return { select, eq };
}

beforeEach(() => {
  vi.clearAllMocks();
});

describe("getExerciseMeta", () => {
  it("returns the exercise, chapter and subject names", async () => {
    const { select, eq } = mockLookup({
      data: {
        title: "Mission 3 — Fractions",
        mode: "practice",
        chapters: { title: "Les fractions" },
        subjects: { name_fr: "Mathématiques", content_language: "ar" },
      },
      error: null,
    });

    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).resolves.toEqual({
      title: "Mission 3 — Fractions",
      mode: "practice",
      chapterTitle: "Les fractions",
      subjectName: "Mathématiques",
      contentLanguage: "ar",
      lockedForNewVisitor: false,
    });
    // Matière sans classe : aucune porte de quiz, aucune lecture de plus.
    expect(mockFrom).toHaveBeenCalledTimes(1);
    expect(mockFrom).toHaveBeenCalledWith("exercises");
    expect(eq).toHaveBeenCalledWith("id", EXERCISE_ID);
    // Le <head> n'a besoin d'aucune question : la clé de réponse ne peut pas fuir
    // par une lecture qui ne touche pas la table `questions`.
    expect(select.mock.calls[0][0]).not.toMatch(/question|correct|option/i);
  });

  it("tolerates a missing chapter or subject relation", async () => {
    mockLookup({
      data: { title: "Mission", mode: "boss", chapters: null, subjects: null },
      error: null,
    });
    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).resolves.toEqual({
      title: "Mission",
      mode: "boss",
      chapterTitle: null,
      subjectName: null,
      contentLanguage: null,
      lockedForNewVisitor: false,
    });
  });

  // `null` = la lecture a RÉUSSI et n'a rien rendu : la page répond 404.
  it("returns null for an unknown exercise — the page answers 404", async () => {
    mockLookup({ data: null, error: null });
    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
    expect(logger.error).not.toHaveBeenCalled();
  });

  // Une lecture en ÉCHEC ne doit jamais passer pour « introuvable » : elle lève,
  // la page garde son 200 et son titre générique, le lecteur charge côté client.
  it("throws when the lookup fails — a failed read is not a missing exercise", async () => {
    mockLookup({ data: null, error: { message: "boom" } });
    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).rejects.toThrow(
      "Impossible de charger l'exercice.",
    );
    expect(logger.error).toHaveBeenCalledWith(
      expect.stringContaining("getExerciseMeta"),
      expect.objectContaining({ error: "boom" }),
    );
  });

  it("rejects an id that is not a GUID before any read", async () => {
    await expect(getExerciseMeta({ data: { exerciseId: "pas-un-uuid" } })).rejects.toThrow();
    expect(mockFrom).not.toHaveBeenCalled();
  });

  // Décision du 2026-11-13 (option B) : la page d'une mission qu'un visiteur neuf
  // trouve fermée porte `noindex`. La règle est celle de la porte du quiz.
  describe("lockedForNewVisitor — la porte du quiz, vue par un visiteur neuf", () => {
    // Chaque monde empile deux réponses ; un exercice qui n'en lit qu'une laisse
    // l'autre en file — elle ne doit pas déborder sur le test suivant.
    beforeEach(() => {
      mockFrom.mockReset();
    });

    function mockWorld(
      exercise: { mode: string; grade_id: string | null; chapter_id?: string | null },
      quizLookup: { data: unknown; error: unknown } = { data: [{ id: "qz" }], error: null },
    ) {
      const quizEq = vi.fn();
      const limit = vi.fn().mockResolvedValue(quizLookup);
      quizEq.mockReturnValue({ eq: quizEq, limit });
      mockFrom
        .mockReturnValueOnce({
          select: () => ({
            eq: () => ({
              maybeSingle: () =>
                Promise.resolve({
                  data: {
                    title: "Mission",
                    mode: exercise.mode,
                    chapter_id: exercise.chapter_id === undefined ? "ch-1" : exercise.chapter_id,
                    chapters: { title: "Chapitre" },
                    subjects: {
                      name_fr: "Maths",
                      content_language: "fr",
                      grade_id: exercise.grade_id,
                    },
                  },
                  error: null,
                }),
            }),
          }),
        })
        .mockReturnValueOnce({ select: () => ({ eq: quizEq }) });
      return { quizEq };
    }
    const locked = async () =>
      (await getExerciseMeta({ data: { exerciseId: EXERCISE_ID } }))?.lockedForNewVisitor;

    it("mission scolaire d'un chapitre qui a un quiz : fermée", async () => {
      const { quizEq } = mockWorld({ mode: "practice", grade_id: "g-6" });
      await expect(locked()).resolves.toBe(true);
      expect(quizEq).toHaveBeenCalledWith("chapter_id", "ch-1");
      expect(quizEq).toHaveBeenCalledWith("mode", "quiz");
    });

    it("mission scolaire d'un chapitre sans quiz : ouverte", async () => {
      mockWorld({ mode: "boss", grade_id: "g-6" }, { data: [], error: null });
      await expect(locked()).resolves.toBe(false);
    });

    it("le quiz lui-même, ou une matière hors programme : ouverts, sans lecture de plus", async () => {
      mockWorld({ mode: "quiz", grade_id: "g-6" });
      await expect(locked()).resolves.toBe(false);
      expect(mockFrom).toHaveBeenCalledTimes(1);
      mockFrom.mockReset();
      mockWorld({ mode: "practice", grade_id: null });
      await expect(locked()).resolves.toBe(false);
      expect(mockFrom).toHaveBeenCalledTimes(1);
    });

    it("lecture du quiz en échec : tenue pour fermée, et journalisée", async () => {
      mockWorld(
        { mode: "practice", grade_id: "g-6" },
        { data: null, error: { message: "timeout" } },
      );
      await expect(locked()).resolves.toBe(true);
      expect(logger.warn).toHaveBeenCalledWith(
        expect.stringContaining("getExerciseMeta"),
        expect.objectContaining({ error: "timeout" }),
      );
    });
  });
});

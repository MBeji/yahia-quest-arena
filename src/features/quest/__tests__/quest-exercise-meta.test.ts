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
        subjects: { name_fr: "Mathématiques" },
      },
      error: null,
    });

    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).resolves.toEqual({
      title: "Mission 3 — Fractions",
      mode: "practice",
      chapterTitle: "Les fractions",
      subjectName: "Mathématiques",
    });
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
    });
  });

  it("returns null for an unknown exercise — the page keeps its generic title", async () => {
    mockLookup({ data: null, error: null });
    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
    expect(logger.warn).not.toHaveBeenCalled();
  });

  it("returns null and logs when the lookup fails", async () => {
    mockLookup({ data: null, error: { message: "boom" } });
    await expect(getExerciseMeta({ data: { exerciseId: EXERCISE_ID } })).resolves.toBeNull();
    expect(logger.warn).toHaveBeenCalledWith(
      expect.stringContaining("getExerciseMeta"),
      expect.objectContaining({ error: "boom" }),
    );
  });

  it("rejects an id that is not a GUID before any read", async () => {
    await expect(getExerciseMeta({ data: { exerciseId: "pas-un-uuid" } })).rejects.toThrow();
    expect(mockFrom).not.toHaveBeenCalled();
  });
});

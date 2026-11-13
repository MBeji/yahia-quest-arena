// @vitest-environment node
import { describe, it, expect, vi, beforeEach } from "vitest";

/**
 * getChapterLesson quiz-gate affordance (étude 15, lot 1 — audit §D-4): the
 * reader CTA needs the chapter's quiz id, whether the gate applies (school
 * subjects only) and, signed-in, whether THIS user already passed (score AND
 * not rushed — the same rule as getSubject). Split from quest.test.ts, which
 * sits at its max-lines budget; same self-contained mock harness.
 */

// ---- Mocks (same shape as quest.test.ts) ----
const mockFrom = vi.fn();
const mockRpc = vi.fn();
const mockSupabase = { from: mockFrom, rpc: mockRpc };

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
        return async (input: unknown) => {
          const data = validatorFn ? validatorFn(input) : input;
          return handlerFn({
            data,
            context: { supabase: mockSupabase, userId: "user-123", claims: { sub: "user-123" } },
          });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
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

function mockQuery(data: unknown, error: unknown = null) {
  const chain: Record<string, unknown> = {};
  const result = { data, error };
  chain.select = vi.fn().mockReturnValue(chain);
  chain.eq = vi.fn().mockReturnValue(chain);
  chain.order = vi.fn().mockReturnValue(chain);
  chain.limit = vi.fn().mockReturnValue(chain);
  chain.single = vi.fn().mockReturnValue(result);
  chain.maybeSingle = vi.fn().mockReturnValue(result);
  chain.in = vi.fn().mockReturnValue(chain);
  chain.gte = vi.fn().mockReturnValue(chain);
  chain.not = vi.fn().mockReturnValue(chain);
  chain.neq = vi.fn().mockReturnValue(chain);
  chain.is = vi.fn().mockReturnValue(chain);
  chain.then = (fn: (v: unknown) => unknown) => fn(result);
  Object.assign(chain, result);
  return chain;
}

/** chapters reads: (1) the chapter row, then sibling metadata / has-lesson sets. */
function mockChapterWorld({
  gradeId,
  exercises,
  attempts = [],
  videos,
}: {
  gradeId: string | null;
  exercises: Array<{ id: string; mode: string; display_order: number }>;
  attempts?: Array<{ duration_seconds: number; total_count: number }>;
  videos?: unknown;
}) {
  let calls = 0;
  mockFrom.mockImplementation((table: string) => {
    if (table === "chapters") {
      calls += 1;
      return calls === 1
        ? mockQuery({
            id: "ch-1",
            title: "C1",
            subject_id: "s1",
            lesson_content: "x",
            videos,
            subjects: { id: "s1", name_fr: "Maths", grade_id: gradeId },
          })
        : mockQuery([{ id: "ch-1", title: "C1", display_order: 1, lesson_content: "x" }]);
    }
    if (table === "exercises") return mockQuery(exercises);
    if (table === "attempts") return mockQuery(attempts);
    return mockQuery([]);
  });
}

type LessonGateResult = {
  quizExerciseId: string | null;
  quizGated: boolean;
  quizPassed: boolean | null;
};

const CH = "11111111-1111-1111-1111-111111111111";

async function callGetChapterLesson(): Promise<LessonGateResult> {
  const { getChapterLesson } = await import("@/features/quest");
  return (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
    chapterId: CH,
  })) as LessonGateResult;
}

describe("gamification.quest — getChapterLesson quiz gate (étude 15, lot 1)", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  it("surfaces the quiz id + gate and the signed-in pass state (score AND not rushed)", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [
        { id: "qz", mode: "quiz", display_order: 1 },
        { id: "ex", mode: "practice", display_order: 2 },
      ],
      // Passing attempt, not rushed (40s ≥ 5 questions × 4s) → gate already open.
      attempts: [{ duration_seconds: 40, total_count: 5 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizExerciseId).toBe("qz");
    expect(res.quizGated).toBe(true);
    expect(res.quizPassed).toBe(true);
  });

  it("treats a rushed passing attempt as NOT passed (mirrors the connected gate)", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [{ id: "qz", mode: "quiz", display_order: 1 }],
      // Score reached but rushed: 8s for 5 questions < the 20s floor.
      attempts: [{ duration_seconds: 8, total_count: 5 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizGated).toBe(true);
    expect(res.quizPassed).toBe(false);
  });

  it("never gates non-school chapters (no grade): quiz surfaced but open, pass state null", async () => {
    mockChapterWorld({
      gradeId: null,
      exercises: [{ id: "qz", mode: "quiz", display_order: 1 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizExerciseId).toBe("qz");
    expect(res.quizGated).toBe(false);
    expect(res.quizPassed).toBeNull();
  });

  it("compte de test (admin) : la porte est franchie d'office, sans lire les tentatives", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [
        { id: "qz", mode: "quiz", display_order: 1 },
        { id: "ex", mode: "practice", display_order: 2 },
      ],
    });
    mockRpc.mockImplementation((fn: string) =>
      fn === "is_admin" ? { data: true, error: null } : { data: null, error: null },
    );

    const res = await callGetChapterLesson();
    expect(res.quizGated).toBe(true);
    expect(res.quizPassed).toBe(true);
    expect(mockFrom).not.toHaveBeenCalledWith("attempts");
  });

  it("reports no quiz target at all for a chapter without a quiz exercise", async () => {
    mockChapterWorld({
      gradeId: "g-9eme",
      exercises: [{ id: "ex", mode: "practice", display_order: 1 }],
    });

    const res = await callGetChapterLesson();
    expect(res.quizExerciseId).toBeNull();
    expect(res.quizGated).toBe(false);
    expect(res.quizPassed).toBeNull();
  });
});

describe("gamification.quest — « n'existe pas » n'est pas « lecture en échec »", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  // Le faux 404 du 2026-11-12 : `.single()` confondait les deux en une même
  // erreur, et `/chapitre/<id inconnu>` répondait HTTP 200 avec un écran d'erreur.
  it("getChapterLesson : chapitre absent → notFound(), pas une erreur de chargement", async () => {
    mockFrom.mockImplementation(() => mockQuery(null));
    const { isNotFound } = await import("@tanstack/react-router");
    const thrown = await callGetChapterLesson().catch((e: unknown) => e);
    expect(isNotFound(thrown)).toBe(true);
    // Une seule lecture : rien n'est cherché autour d'un chapitre qui n'existe pas.
    expect(mockFrom).toHaveBeenCalledTimes(1);
  });

  it("getChapterLesson : lecture en échec → erreur ordinaire, jamais un 404", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "timeout" }));
    const { isNotFound } = await import("@tanstack/react-router");
    const thrown = await callGetChapterLesson().catch((e: unknown) => e);
    expect(isNotFound(thrown)).toBe(false);
    expect((thrown as Error).message).toBe("Impossible de charger la leçon.");
  });

  async function callCheckSubjectExists(): Promise<boolean> {
    const { checkSubjectExists } = await import("@/features/quest/quest.lesson.server");
    return (checkSubjectExists as unknown as (d: unknown) => Promise<boolean>)({
      subjectId: "math-6eme",
    });
  }

  it("checkSubjectExists : une ligne → true ; aucune → false ; une seule colonne lue", async () => {
    const found = mockQuery({ id: "math-6eme" });
    mockFrom.mockImplementation(() => found);
    await expect(callCheckSubjectExists()).resolves.toBe(true);
    expect(mockFrom).toHaveBeenCalledWith("subjects");
    expect(found.select).toHaveBeenCalledWith("id");

    mockFrom.mockImplementation(() => mockQuery(null));
    await expect(callCheckSubjectExists()).resolves.toBe(false);
  });

  it("checkSubjectExists : lecture en échec → lève, ne dit jamais « absente »", async () => {
    mockFrom.mockImplementation(() => mockQuery(null, { message: "timeout" }));
    await expect(callCheckSubjectExists()).rejects.toThrow("Impossible de charger la matière.");
  });
});

describe("gamification.quest — le niveau d'une matière, lisible sans compte", () => {
  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  const PARCOURS = { id: "ecole-6eme-base", name_fr: "6ème année", name_en: null, name_ar: null };

  async function callGetSubjectParcours(): Promise<unknown> {
    const { getSubjectParcours } = await import("@/features/quest/quest.lesson.server");
    return (getSubjectParcours as unknown as (d: unknown) => Promise<unknown>)({
      subjectId: "math-6eme",
    });
  }

  // La RPC `resolve_subject_parcours` est refusée à l'anonyme : le rendu serveur
  // (toujours anonyme) ne connaissait jamais le niveau. Lecture directe de la table.
  it("getSubjectParcours : lit `parcours` par (thème, classe), sans la RPC", async () => {
    const parcoursQuery = mockQuery(PARCOURS);
    mockFrom.mockImplementation((table: string) =>
      table === "subjects" ? mockQuery({ theme_id: "scolaire", grade_id: "g-6" }) : parcoursQuery,
    );
    await expect(callGetSubjectParcours()).resolves.toEqual(PARCOURS);
    expect(parcoursQuery.eq).toHaveBeenCalledWith("theme_id", "scolaire");
    expect(parcoursQuery.eq).toHaveBeenCalledWith("grade_id", "g-6");
    expect(mockRpc).not.toHaveBeenCalled();
  });

  it("getSubjectParcours : un parcours libre se cherche par classe NULLE", async () => {
    const parcoursQuery = mockQuery(PARCOURS);
    mockFrom.mockImplementation((table: string) =>
      table === "subjects" ? mockQuery({ theme_id: "anglais", grade_id: null }) : parcoursQuery,
    );
    await callGetSubjectParcours();
    expect(parcoursQuery.is).toHaveBeenCalledWith("grade_id", null);
  });

  it("getSubjectParcours : matière absente → null ; niveau illisible → null, sans lever", async () => {
    mockFrom.mockImplementation(() => mockQuery(null));
    await expect(callGetSubjectParcours()).resolves.toBeNull();

    mockFrom.mockImplementation((table: string) =>
      table === "subjects"
        ? mockQuery({ theme_id: "scolaire", grade_id: "g-6" })
        : mockQuery(null, { message: "timeout" }),
    );
    await expect(callGetSubjectParcours()).resolves.toBeNull();
  });

  it("getChapterLesson : rend le niveau du chapitre, pour le fil d'Ariane", async () => {
    let chapterReads = 0;
    mockFrom.mockImplementation((table: string) => {
      if (table === "parcours") return mockQuery(PARCOURS);
      if (table === "chapters") {
        chapterReads += 1;
        return chapterReads === 1
          ? mockQuery({
              id: "ch-1",
              title: "C1",
              subject_id: "math-6eme",
              subjects: {
                id: "math-6eme",
                name_fr: "Maths",
                grade_id: "g-6",
                theme_id: "scolaire",
              },
            })
          : mockQuery([]);
      }
      return mockQuery([]);
    });
    const res = (await callGetChapterLesson()) as unknown as { parcours: unknown };
    expect(res.parcours).toEqual(PARCOURS);
  });
});

/**
 * `chapters.videos` est un JSONB : le type généré n'en dit que `Json`. Chaque
 * entrée est relue par le schéma de la vidéo de correction (étude 23 D-10) — une
 * entrée malformée ou héritée disparaît au lieu de devenir un lecteur à moitié
 * construit, et la leçon s'affiche quand même.
 */
describe("getChapterLesson — les vidéos du chapitre sont relues à la frontière", () => {
  const VALID = {
    id: "v-thales",
    provider: "youtube",
    videoId: "dQw4w9WgXcQ",
    title: "Le théorème de Thalès",
    channel: "Maths Tunisie",
    lang: "fr",
    durationSec: 420,
  };

  beforeEach(() => {
    vi.resetModules();
    mockFrom.mockReset();
    mockRpc.mockReset();
  });

  async function lessonVideos(videos: unknown): Promise<unknown> {
    mockChapterWorld({ gradeId: null, exercises: [], videos });
    const { getChapterLesson } = await import("@/features/quest");
    const res = (await (getChapterLesson as unknown as (d: unknown) => Promise<unknown>)({
      chapterId: CH,
    })) as { chapter: { videos: unknown } };
    return res.chapter.videos;
  }

  it("garde les entrées valides et écarte les autres", async () => {
    await expect(
      lessonVideos([
        VALID,
        { ...VALID, id: "v-url", videoId: "https://evil.example/x" },
        "https://youtu.be/legacy",
        { ...VALID, id: "v-sans-titre", title: "" },
      ]),
    ).resolves.toEqual([VALID]);
  });

  it("rend une liste vide pour une colonne qui n'est pas un tableau", async () => {
    await expect(lessonVideos({ legacy: true })).resolves.toEqual([]);
    await expect(lessonVideos(undefined)).resolves.toEqual([]);
  });
});

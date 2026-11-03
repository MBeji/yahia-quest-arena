// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * Étude 39 — la couche serveur du test de niveau : elle valide, limite, met en forme. Ce qu'on
 * épingle : la forme du bilan est vérifiée (une forme inattendue est une panne, pas un écran à
 * moitié rempli), les codes SQL deviennent des phrases, le tableau de réponses se replie en objet
 * (une réponse par question), et le jeton absent du propriétaire passe en `NULL` SQL.
 */
const rpc = vi.fn();
const rateLimited = vi.fn().mockResolvedValue(false);
const rateLimitedLocal = vi.fn().mockReturnValue(false);

vi.mock("@tanstack/react-start", () => ({
  createServerFn: () => {
    const chain = {
      middleware: () => chain,
      // `async` : une entrée refusée par zod REJETTE la promesse, comme la vraie server fn —
      // elle ne lève pas en synchrone.
      validator: (fn: (d: unknown) => unknown) => ({
        ...chain,
        handler:
          (h: (ctx: { data: unknown; context: unknown }) => unknown) =>
          async (input: { data?: unknown }) =>
            h({ data: fn(input?.data), context: ctxHolder.context }),
      }),
      handler: (h: (ctx: { data: unknown; context: unknown }) => unknown) => async () =>
        h({ data: undefined, context: ctxHolder.context }),
    };
    return chain;
  },
}));
vi.mock("@tanstack/react-start/server", () => ({ getRequest: () => ({ headers: new Headers() }) }));
vi.mock("@/shared/integrations/supabase/optional-auth-middleware", () => ({
  optionalSupabaseAuth: {},
}));
vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({ requireSupabaseAuth: {} }));
vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: (...a: unknown[]) => rateLimited(...a),
  isRateLimitedLocal: (...a: unknown[]) => rateLimitedLocal(...a),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { info: vi.fn(), warn: vi.fn(), error: vi.fn() },
}));

const ctxHolder = vi.hoisted(() => ({
  context: { supabase: { rpc: (...a: unknown[]) => rpc(...a) }, userId: null as string | null },
}));

import {
  finishPlacementSession,
  getPlacementSession,
  placementErrorCode,
  startPlacementSession,
} from "../placement.server";

const subject = {
  id: "math",
  nameFr: "Mathématiques",
  contentLanguage: "fr",
  gradeNameFr: "9ᵉ",
  gradeSlug: "9eme-base",
  parcoursId: "concours-9eme",
};
const bilan = {
  id: "11111111-1111-4111-8111-111111111111",
  status: "completed",
  audience: "student",
  startedAt: "2026-11-01T10:00:00Z",
  finishedAt: "2026-11-01T10:05:00Z",
  subject,
  correct: 7,
  total: 10,
  scoreOn20: 14,
  band: "en-route",
  durationSeconds: 300,
  tooFast: false,
  chapters: [],
  firstToReview: null,
  percentile: { candidates: 1, minCandidates: 20, percentile: null },
  review: [],
  insightsLocked: true,
};

describe("placement.server", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    ctxHolder.context.userId = null;
  });

  it("start : rend le test typé, jeton compris, et nomme le visiteur dans le débit par adresse", async () => {
    rpc.mockResolvedValue({
      data: {
        id: bilan.id,
        token: "22222222-2222-4222-8222-222222222222",
        status: "running",
        audience: "student",
        startedAt: bilan.startedAt,
        subject,
        questions: [],
      },
      error: null,
    });
    const started = await startPlacementSession({ data: { subjectId: "math" } });
    expect(started.token).toBe("22222222-2222-4222-8222-222222222222");
    expect(rpc).toHaveBeenCalledWith("start_placement_session", {
      p_subject_id: "math",
      p_audience: "student",
    });
    expect(rateLimitedLocal).toHaveBeenCalled();
    expect(rateLimited).not.toHaveBeenCalled();
  });

  it("start : un compte passe par le limiteur persistant", async () => {
    ctxHolder.context.userId = "u1";
    rpc.mockResolvedValue({ data: null, error: { message: "PLACEMENT_BUSY" } });
    await expect(startPlacementSession({ data: { subjectId: "math" } })).rejects.toThrow(
      /Beaucoup de monde/,
    );
    expect(rateLimited).toHaveBeenCalled();
  });

  it("les codes SQL deviennent des phrases, et l'écran sait les reconnaître", async () => {
    rpc.mockResolvedValue({ data: null, error: { message: "PLACEMENT_NOT_ENOUGH_QUESTIONS" } });
    const err = await startPlacementSession({ data: { subjectId: "mince" } }).catch(
      (e: unknown) => e,
    );
    expect(placementErrorCode(err)).toBe("notEnough");
    expect(placementErrorCode(new Error("PLACEMENT_BUSY → Beaucoup de monde passe le test"))).toBe(
      "busy",
    );
    expect(placementErrorCode(new Error("Ce test est introuvable."))).toBe("notFound");
    expect(placementErrorCode(new Error("autre chose"))).toBeNull();
  });

  it("finish : replie les réponses en objet et refuse une forme de bilan inattendue", async () => {
    rpc.mockResolvedValue({ data: bilan, error: null });
    const res = await finishPlacementSession({
      data: {
        sessionId: bilan.id,
        token: "22222222-2222-4222-8222-222222222222",
        answers: [
          { questionId: "33333333-3333-4333-8333-333333333333", choice: "a" },
          { questionId: "33333333-3333-4333-8333-333333333333", choice: "b" },
        ],
        durationSeconds: 300,
      },
    });
    expect(res.scoreOn20).toBe(14);
    expect(rpc).toHaveBeenCalledWith("finish_placement_session", {
      p_session_id: bilan.id,
      p_token: "22222222-2222-4222-8222-222222222222",
      // La dernière réponse d'une même question gagne : une clé, jamais deux.
      p_answers: { "33333333-3333-4333-8333-333333333333": "b" },
      p_duration_seconds: 300,
    });

    rpc.mockResolvedValue({ data: { ...bilan, band: "pas-une-bande" }, error: null });
    await expect(
      finishPlacementSession({
        data: { sessionId: bilan.id, token: null, answers: [], durationSeconds: 1 },
      }),
    ).rejects.toThrow(/inattendue/);
  });

  it("get : sans jeton (le propriétaire), l'argument SQL est omis — donc NULL", async () => {
    ctxHolder.context.userId = "u1";
    rpc.mockResolvedValue({ data: bilan, error: null });
    const res = await getPlacementSession({ data: { sessionId: bilan.id, token: null } });
    expect(res.status).toBe("completed");
    expect(rpc).toHaveBeenCalledWith("get_placement_session", {
      p_session_id: bilan.id,
      p_token: undefined,
    });
  });

  it("get : l'entrée est validée — un identifiant qui n'est pas un UUID est refusé avant tout appel", async () => {
    await expect(
      getPlacementSession({ data: { sessionId: "nope", token: null } }),
    ).rejects.toThrow();
    expect(rpc).not.toHaveBeenCalled();
  });
});

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
  claimPlacementSessions,
  finishPlacementSession,
  getMyPlacementOverview,
  getPlacementSession,
  getPlacementSubject,
  listPlacementSubjects,
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

/**
 * Les quatre lectures que rien n'appelait (couverture 69 %) : l'entrée par classe, le lien
 * partagé, le rattachement des tests de l'appareil au compte, et la carte du Hall. Plus le refus
 * de cadence de la borne durable (PT429, audit S-1), traduit depuis #1291.
 */
describe("placement.server — les lectures d'entrée et du Hall", () => {
  const TOKEN = "33333333-3333-4333-8333-333333333333";

  beforeEach(() => {
    vi.clearAllMocks();
    ctxHolder.context.userId = null;
  });

  it("listSubjects : les matières testables d'une classe, langue par défaut comprise", async () => {
    rpc.mockResolvedValue({
      data: [
        {
          id: "math",
          nameFr: "Mathématiques",
          contentLanguage: null,
          chapters: "6",
          questions: 40,
        },
      ],
      error: null,
    });

    await expect(listPlacementSubjects({ data: { parcoursId: "concours-9eme" } })).resolves.toEqual(
      [{ id: "math", nameFr: "Mathématiques", contentLanguage: null, chapters: 6, questions: 40 }],
    );
    expect(rpc).toHaveBeenCalledWith("list_placement_subjects", { p_parcours_id: "concours-9eme" });
  });

  it("listSubjects : une forme inattendue est une panne nommée, pas une liste à moitié remplie", async () => {
    rpc.mockResolvedValue({ data: [{ id: "math" }], error: null });

    await expect(listPlacementSubjects({ data: { parcoursId: "concours-9eme" } })).rejects.toThrow(
      "Réponse inattendue du serveur du test.",
    );
  });

  it("getSubject : la carte d'un lien partagé, et null pour une matière inconnue", async () => {
    rpc.mockResolvedValueOnce({
      data: { ...subject, testable: true, questions: "40", chapters: 6 },
      error: null,
    });
    await expect(getPlacementSubject({ data: { subjectId: "math" } })).resolves.toEqual({
      ...subject,
      testable: true,
      questions: 40,
      chapters: 6,
    });

    rpc.mockResolvedValueOnce({ data: null, error: null });
    await expect(getPlacementSubject({ data: { subjectId: "inconnue" } })).resolves.toBeNull();
  });

  it("claim : rattache les tests de l'appareil et ne compte que ce qui l'a été", async () => {
    ctxHolder.context.userId = "u1";
    rpc.mockResolvedValue({ data: { claimed: [bilan.id] }, error: null });

    await expect(claimPlacementSessions({ data: { tokens: [TOKEN] } })).resolves.toEqual({
      claimed: [bilan.id],
    });
    expect(rpc).toHaveBeenCalledWith("claim_placement_sessions", { p_tokens: [TOKEN] });
    expect(rateLimited).toHaveBeenCalledWith(expect.anything(), "placement_claim_u1", 10, 60_000);
  });

  it("claim : une rafale est refusée avant d'appeler la base", async () => {
    ctxHolder.context.userId = "u1";
    rateLimited.mockResolvedValueOnce(true);

    await expect(claimPlacementSessions({ data: { tokens: [TOKEN] } })).rejects.toThrow(
      /Trop de requêtes/,
    );
    expect(rpc).not.toHaveBeenCalled();
  });

  it("claim : refuse une liste vide ou un jeton qui n'est pas un uuid", async () => {
    ctxHolder.context.userId = "u1";
    await expect(claimPlacementSessions({ data: { tokens: [] } })).rejects.toThrow();
    await expect(claimPlacementSessions({ data: { tokens: ["pas-un-uuid"] } })).rejects.toThrow();
    expect(rpc).not.toHaveBeenCalled();
  });

  it("overview : le dernier bilan par matière, chapitres à revoir par défaut vides", async () => {
    ctxHolder.context.userId = "u1";
    rpc.mockResolvedValue({
      data: [
        {
          sessionId: bilan.id,
          subjectId: "math",
          subjectNameFr: "Mathématiques",
          scoreOn20: "14",
          band: "en-route",
          finishedAt: bilan.finishedAt,
        },
      ],
      error: null,
    });

    await expect(getMyPlacementOverview()).resolves.toEqual([
      {
        sessionId: bilan.id,
        subjectId: "math",
        subjectNameFr: "Mathématiques",
        contentLanguage: "fr",
        scoreOn20: 14,
        band: "en-route",
        finishedAt: bilan.finishedAt,
        chaptersToReview: [],
      },
    ]);
  });

  it("overview : une bande hors du domaine fait échouer la lecture", async () => {
    ctxHolder.context.userId = "u1";
    rpc.mockResolvedValue({
      data: [
        {
          sessionId: bilan.id,
          subjectId: "math",
          subjectNameFr: "Mathématiques",
          scoreOn20: 14,
          band: "excellent",
          finishedAt: bilan.finishedAt,
        },
      ],
      error: null,
    });

    await expect(getMyPlacementOverview()).rejects.toThrow(
      "Réponse inattendue du serveur du test.",
    );
  });

  it("start : un refus de la borne durable (PT429) se dit « trop de requêtes », pas une panne", async () => {
    rpc.mockResolvedValue({
      data: null,
      error: { code: "PT429", message: "RATE_LIMITED", details: null, hint: null },
    });

    await expect(startPlacementSession({ data: { subjectId: "math" } })).rejects.toThrow(
      /Trop de requêtes/,
    );
  });
});

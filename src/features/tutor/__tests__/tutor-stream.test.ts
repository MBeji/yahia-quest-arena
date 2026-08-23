import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

/**
 * LA ROUTE `/api/tutor/stream` — étude 11 lot 3.
 *
 * Dix gardes, dans un ordre qui EST le contrat. Ce fichier vérifie les six qui
 * décident si l'appel part, et surtout les trois qui décident qu'il ne partira
 * PAS sans rien coûter :
 *
 *   • l'âge (Q-6) — le champ libre n'existe pas en primaire ;
 *   • le bornage (R-5) — trop long, une URL, du vide ;
 *   • le bien-être (R-6) — cette catégorie n'atteint JAMAIS le modèle.
 *
 * ⭐ L'assertion la plus importante est celle du bien-être : un enfant qui écrit
 * sa détresse reçoit une phrase écrite par des humains, ne consomme aucune
 * énergie, et personne n'en est prévenu automatiquement (Q-5).
 */

const rpcCalls: { fn: string; args: Record<string, unknown> }[] = [];
let rpcReplies: Record<string, unknown> = {};
let authOk = true;
let rateLimited = false;
const streamCalls: { feature: string; system: string }[] = [];
let streamChunks: unknown[] = [];

vi.mock("@/shared/integrations/supabase/auth-request", () => ({
  resolveSupabaseAuth: vi.fn(async () =>
    authOk
      ? {
          ok: true,
          userId: "22222222-2222-4222-8222-222222222222",
          claims: {},
          supabase: {
            rpc: async (fn: string, args: Record<string, unknown>) => {
              rpcCalls.push({ fn, args });
              return { data: rpcReplies[fn] ?? null, error: null };
            },
          },
        }
      : { ok: false, failure: "INVALID_TOKEN" },
  ),
}));

vi.mock("@/shared/lib/rate-limit", () => ({
  isRateLimited: vi.fn(async () => rateLimited),
}));

vi.mock("@/features/ai", () => ({
  streamAi: vi.fn(async function* (req: { feature: string; system: string }) {
    streamCalls.push({ feature: req.feature, system: req.system });
    for (const chunk of streamChunks) yield chunk;
  }),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn() },
}));

import { handleTutorStream } from "../tutor.stream.server";

const CHAPTER = "33333333-3333-4333-8333-333333333333";

function post(body: unknown, method = "POST"): Request {
  return new Request("https://app.test/api/tutor/stream", {
    method,
    headers: { "content-type": "application/json", authorization: "Bearer t" },
    ...(method === "POST" ? { body: JSON.stringify(body) } : {}),
  });
}

/** Décode un flux SSE en `[{event, data}]`. */
async function framesOf(response: Response): Promise<{ event: string; data: unknown }[]> {
  const text = await response.text();
  return text
    .split("\n\n")
    .filter(Boolean)
    .map((frame) => ({
      event: /^event: (.+)$/m.exec(frame)?.[1] ?? "",
      data: JSON.parse(/^data: (.+)$/m.exec(frame)?.[1] ?? "null"),
    }));
}

beforeEach(() => {
  rpcCalls.length = 0;
  streamCalls.length = 0;
  authOk = true;
  rateLimited = false;
  streamChunks = [
    { type: "text", text: "Une " },
    { type: "text", text: "explication assez longue pour passer le validateur de sortie." },
    {
      type: "done",
      text: "Une explication assez longue pour passer le validateur de sortie.",
      model: "claude-haiku-4-5",
      payer: "family",
      costUsdMicros: 12,
    },
  ];
  rpcReplies = {
    can_use_tutor: { allowed: true, reason: "OK" },
    get_tutor_chapter_context: {
      found: true,
      chapter_id: CHAPTER,
      chapter_title: "Les fractions",
      chapter_summary: null,
      lesson_excerpt: "On garde le dénominateur.",
      subject_title: "Maths",
      lang: "fr",
      age_band: "12-14",
    },
    open_tutor_chapter_thread: {
      thread_id: "44444444-4444-4444-8444-444444444444",
      summary: null,
      messages: [],
      message_count: 0,
    },
    get_tutor_learner_context: null,
  };
});

afterEach(() => {
  vi.clearAllMocks();
});

const called = (fn: string) => rpcCalls.filter((c) => c.fn === fn);

describe("les gardes d'entrée", () => {
  it("refuse une méthode autre que POST", async () => {
    expect((await handleTutorStream(post(null, "GET"))).status).toBe(405);
  });

  it("refuse un jeton invalide — un flux anonyme n'existe pas", async () => {
    authOk = false;
    const res = await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" }));
    expect(res.status).toBe(401);
    expect(streamCalls).toHaveLength(0);
  });

  it("refuse un corps hors schéma", async () => {
    expect((await handleTutorStream(post({ intent: "summarize" }))).status).toBe(400);
  });

  it("R-1 : une porte fermée rend SA raison, et rien ne part", async () => {
    rpcReplies.can_use_tutor = { allowed: false, reason: "ACTIVE_DUNGEON" };
    const res = await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" }));
    expect(await framesOf(res)).toEqual([{ event: "error", data: { code: "ACTIVE_DUNGEON" } }]);
    expect(streamCalls).toHaveLength(0);
  });

  it("l'anti-rafale coupe AVANT le contexte, donc avant toute dépense", async () => {
    rateLimited = true;
    const res = await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" }));
    expect(await framesOf(res)).toEqual([{ event: "error", data: { code: "RATE_LIMITED" } }]);
    expect(called("get_tutor_chapter_context")).toHaveLength(0);
    expect(streamCalls).toHaveLength(0);
  });
});

describe("Q-6 et R-5 — le champ libre", () => {
  it("n'existe pas en primaire, et c'est le SERVEUR qui le dit", async () => {
    rpcReplies.get_tutor_chapter_context = {
      ...(rpcReplies.get_tutor_chapter_context as object),
      age_band: "9-11",
    };
    const res = await handleTutorStream(
      post({ chapterId: CHAPTER, intent: "free", freeText: "pourquoi ?" }),
    );
    expect(await framesOf(res)).toEqual([
      { event: "error", data: { code: "FREE_TEXT_NOT_ALLOWED" } },
    ]);
    expect(streamCalls).toHaveLength(0);
  });

  it("refuse une URL sans dépenser un centime", async () => {
    const res = await handleTutorStream(
      post({ chapterId: CHAPTER, intent: "free", freeText: "va voir https://triche.com" }),
    );
    expect(await framesOf(res)).toEqual([{ event: "error", data: { code: "FREE_TEXT_URL" } }]);
    expect(streamCalls).toHaveLength(0);
  });

  it("refuse au-delà de 300 caractères", async () => {
    const res = await handleTutorStream(
      post({ chapterId: CHAPTER, intent: "free", freeText: "a".repeat(400) }),
    );
    expect(await framesOf(res)).toEqual([{ event: "error", data: { code: "FREE_TEXT_TOO_LONG" } }]);
  });
});

describe("⭐ R-6 — la détresse n'atteint jamais le modèle", () => {
  it("répond une phrase écrite par des humains, sans appeler personne", async () => {
    const res = await handleTutorStream(
      post({ chapterId: CHAPTER, intent: "free", freeText: "on me harcèle à l'école" }),
    );

    const frames = await framesOf(res);
    expect(frames[0].event).toBe("token");
    expect((frames[0].data as { text: string }).text).toContain("adulte");
    expect(frames.at(-1)?.event).toBe("done");

    // Le modèle n'a pas été appelé : ni énergie, ni argent, ni transmission du
    // message d'un enfant en détresse à un fournisseur tiers.
    expect(streamCalls).toHaveLength(0);
  });

  it("garde la trace dans le fil de l'élève, et n'alerte personne (Q-5)", async () => {
    await handleTutorStream(
      post({ chapterId: CHAPTER, intent: "free", freeText: "je veux mourir" }),
    );
    const appended = called("append_tutor_message");
    // Son message, puis la réponse fixe : l'élève peut relire ce qu'on lui a dit.
    expect(appended).toHaveLength(2);
    expect(appended[1].args.p_kind).toBe("wellbeing");
    // Aucune notification, aucun signal parent : la confiance de l'élève prime.
    expect(rpcCalls.some((c) => c.fn.includes("notify") || c.fn.includes("alert"))).toBe(false);
  });
});

describe("le flux nominal", () => {
  it("rend des trames `token` puis `done`", async () => {
    const res = await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" }));
    expect(res.headers.get("content-type")).toContain("text/event-stream");

    const frames = await framesOf(res);
    expect(frames.filter((f) => f.event === "token")).toHaveLength(2);
    expect(frames.at(-1)?.event).toBe("done");
  });

  it("persiste la réponse VALIDÉE, pas le texte brut du flux", async () => {
    // ⚠️ Le corps d'un flux est PARESSEUX : `start()` ne s'exécute qu'à la
    // lecture. Sans ce `framesOf`, l'assertion mesurerait un travail qui n'a
    // pas encore commencé — et passerait pour une régression.
    await framesOf(await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" })));
    const appended = called("append_tutor_message");
    expect(appended).toHaveLength(1);
    expect(appended[0].args.p_role).toBe("tutor");
  });

  it("une intention fermée n'écrit AUCUN message d'élève dans le fil", async () => {
    await framesOf(await handleTutorStream(post({ chapterId: CHAPTER, intent: "example" })));
    const appended = called("append_tutor_message");
    expect(appended.every((c) => c.args.p_role === "tutor")).toBe(true);
  });

  it("§3.4 : une sortie rejetée par le validateur ne rejoint pas le fil", async () => {
    streamChunks = [
      { type: "text", text: "ok" },
      { type: "done", text: "ok", model: "m", payer: "family", costUsdMicros: 1 },
    ];
    const res = await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" }));
    const frames = await framesOf(res);
    expect(frames.at(-1)).toEqual({ event: "error", data: { code: "AI_OUTPUT_REJECTED" } });
    expect(called("append_tutor_message")).toHaveLength(0);
  });

  it("un refus de la porte é29 ressort tel quel, en trame `error` (R-15)", async () => {
    streamChunks = [{ type: "error", code: "AI_ENERGY_SPENT" }];
    const res = await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" }));
    expect(await framesOf(res)).toEqual([{ event: "error", data: { code: "AI_ENERGY_SPENT" } }]);
  });

  it("le chat passe par la surface `chat`, jamais par `explain`", async () => {
    await framesOf(await handleTutorStream(post({ chapterId: CHAPTER, intent: "summarize" })));
    expect(streamCalls[0].feature).toBe("chat");
  });
});

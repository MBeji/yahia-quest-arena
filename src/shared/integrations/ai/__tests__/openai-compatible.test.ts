import { describe, expect, it, vi } from "vitest";
import { EventEmitter } from "node:events";

import {
  buildCompletionPayload,
  completionsUrl,
  makeOpenAiCompatibleProvider,
  parseCompletion,
} from "../openai-compatible.server";
import { AiError } from "../errors";
import { sealSecret, type AiCredential, type AiRequest } from "../types";
import type { EgressLookup, HttpsRequestFn } from "../egress.server";

/**
 * L'adaptateur `openai_compatible` — ce que l'étude 29 §3.5 exige de lui « quel
 * que soit le fournisseur » : 2 retries sur 429/5xx, **aucun retry sur 401/403**,
 * usage → coût, erreurs re-typées.
 *
 * Le réseau est remplacé de bout en bout : ni DNS, ni socket. C'est la règle du
 * §5 — « aucun appel réel vers un fournisseur, jamais, sous aucun prétexte ».
 */

const lookup: EgressLookup = async () => [{ address: "93.184.216.34", family: 4 }];

const cred: AiCredential = {
  provider: "openai_compatible",
  baseUrl: "https://api.example.com/v1",
  secret: sealSecret("sk-test-0000-4f2a"),
  models: { fast: "gpt-5-mini", rich: "gpt-5" },
};

const req: AiRequest = {
  tier: "fast",
  system: "Tu es un professeur.",
  blocks: [{ label: "cours", text: "Les fractions.", cacheBoundary: true }],
  maxTokens: 400,
  feature: "explain",
};

/** File de réponses : une par tentative, pour observer les retries. */
function scriptedTransport(responses: { statusCode: number; body: string }[]) {
  const calls: { headers: Record<string, string>; body: string }[] = [];
  let index = 0;
  const requestFn = ((options: Record<string, unknown>, callback: (res: EventEmitter) => void) => {
    const scripted = responses[Math.min(index, responses.length - 1)];
    index += 1;
    const req_ = new EventEmitter() as EventEmitter & {
      write: (chunk: string) => void;
      end: () => void;
      destroy: () => void;
    };
    let sent = "";
    req_.write = (chunk: string) => {
      sent += chunk;
    };
    req_.destroy = () => {};
    req_.end = () => {
      calls.push({ headers: options.headers as Record<string, string>, body: sent });
      queueMicrotask(() => {
        const res = new EventEmitter() as EventEmitter & {
          statusCode: number;
          destroy: () => void;
        };
        res.statusCode = scripted.statusCode;
        res.destroy = () => {};
        callback(res);
        res.emit("data", Buffer.from(scripted.body));
        res.emit("end");
      });
    };
    return req_;
  }) as unknown as HttpsRequestFn;
  return { requestFn, calls, attempts: () => index };
}

const okBody = JSON.stringify({
  model: "gpt-5-mini-2026",
  choices: [{ message: { content: "Voici l'explication." } }],
  usage: {
    prompt_tokens: 1200,
    completion_tokens: 300,
    prompt_tokens_details: { cached_tokens: 900 },
  },
});

describe("construction de la requête", () => {
  it("colle /chat/completions en tolérant la barre finale", () => {
    expect(completionsUrl("https://api.example.com/v1")).toBe(
      "https://api.example.com/v1/chat/completions",
    );
    expect(completionsUrl("https://api.example.com/v1/")).toBe(
      "https://api.example.com/v1/chat/completions",
    );
  });

  it("porte le modèle du palier et le plafond de tokens (R-10)", () => {
    expect(buildCompletionPayload(req, "gpt-5-mini")).toMatchObject({
      model: "gpt-5-mini",
      max_tokens: 400,
    });
  });

  it("demande une sortie structurée quand un schéma est fourni", () => {
    const payload = buildCompletionPayload({ ...req, responseSchema: { type: "object" } }, "m");
    expect(payload.response_format).toMatchObject({ type: "json_schema" });
  });

  it("n'émet AUCUN identifiant de plateforme — condition 7 de R-6", async () => {
    const { requestFn, calls } = scriptedTransport([{ statusCode: 200, body: okBody }]);
    await makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, cred);

    const headerNames = Object.keys(calls[0].headers).map((h) => h.toLowerCase());
    expect(headerNames.sort()).toEqual([
      "accept",
      "authorization",
      "content-length",
      "content-type",
    ]);
    // Ni cookie, ni user-agent maison, ni en-tête de traçage.
    expect(headerNames).not.toContain("cookie");
    expect(headerNames).not.toContain("user-agent");
    expect(calls[0].headers.authorization).toBe("Bearer sk-test-0000-4f2a");
  });
});

describe("lecture de la réponse", () => {
  it("rapporte l'usage et le modèle RÉEL (R-13)", () => {
    const result = parseCompletion(okBody, "gpt-5-mini", 42);
    expect(result).toEqual({
      text: "Voici l'explication.",
      usage: { inputTokens: 1200, outputTokens: 300, cachedTokens: 900 },
      // Le service a substitué un modèle : c'est le SIEN qui est journalisé.
      model: "gpt-5-mini-2026",
      latencyMs: 42,
    });
  });

  it("retombe sur le modèle demandé quand le service n'en rapporte pas", () => {
    const raw = JSON.stringify({ choices: [{ message: { content: "x" } }] });
    expect(parseCompletion(raw, "gpt-5-mini", 1).model).toBe("gpt-5-mini");
  });

  it("refuse proprement un service hors format (D-6 : on ne devine pas)", () => {
    expect(() => parseCompletion("pas du json", "m", 1)).toThrow(AiError);
    expect(() => parseCompletion(JSON.stringify({ choices: [] }), "m", 1)).toThrowError(
      /AI_OUTPUT_REJECTED/,
    );
  });
});

describe("retries — 429/5xx oui, 401/403 JAMAIS", () => {
  it("réessaie un 500 puis réussit", async () => {
    vi.useFakeTimers();
    const { requestFn, attempts } = scriptedTransport([
      { statusCode: 500, body: "boom" },
      { statusCode: 200, body: okBody },
    ]);
    const promise = makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, cred);
    await vi.runAllTimersAsync();
    await expect(promise).resolves.toMatchObject({ text: "Voici l'explication." });
    expect(attempts()).toBe(2);
    vi.useRealTimers();
  });

  it("abandonne après 2 retries (3 tentatives au total)", async () => {
    vi.useFakeTimers();
    const { requestFn, attempts } = scriptedTransport([{ statusCode: 503, body: "down" }]);
    const promise = makeOpenAiCompatibleProvider({ lookup, requestFn })
      .generate(req, cred)
      .catch((e: unknown) => e);
    await vi.runAllTimersAsync();
    expect(await promise).toMatchObject({ code: "AI_PROVIDER_DOWN" });
    expect(attempts()).toBe(3);
    vi.useRealTimers();
  });

  it("NE réessaie PAS un 401 — une clé invalide le reste, et le quota du parent n'est pas à brûler", async () => {
    const { requestFn, attempts } = scriptedTransport([{ statusCode: 401, body: "unauthorized" }]);
    await expect(
      makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, cred),
    ).rejects.toMatchObject({ code: "AI_KEY_INVALID" });
    expect(attempts()).toBe(1);
  });

  it("NE réessaie PAS un 403", async () => {
    const { requestFn, attempts } = scriptedTransport([{ statusCode: 403, body: "forbidden" }]);
    await expect(
      makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, cred),
    ).rejects.toMatchObject({ code: "AI_KEY_INVALID" });
    expect(attempts()).toBe(1);
  });

  it("NE réessaie PAS un 429 « crédit épuisé », malgré son statut retentable", async () => {
    const { requestFn, attempts } = scriptedTransport([
      { statusCode: 429, body: '{"error":{"code":"insufficient_quota"}}' },
    ]);
    await expect(
      makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, cred),
    ).rejects.toMatchObject({ code: "AI_CREDIT_EXHAUSTED" });
    expect(attempts()).toBe(1);
  });

  it("réessaie un 429 de DÉBIT", async () => {
    vi.useFakeTimers();
    const { requestFn, attempts } = scriptedTransport([
      { statusCode: 429, body: "slow down" },
      { statusCode: 200, body: okBody },
    ]);
    const promise = makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, cred);
    await vi.runAllTimersAsync();
    await expect(promise).resolves.toBeTruthy();
    expect(attempts()).toBe(2);
    vi.useRealTimers();
  });
});

describe("R-6 dans le chemin d'appel, pas seulement à la saisie", () => {
  it("refuse une base_url privée à CHAQUE appel, sans réessayer", async () => {
    const privateLookup: EgressLookup = async () => [{ address: "169.254.169.254", family: 4 }];
    const { requestFn, attempts } = scriptedTransport([{ statusCode: 200, body: okBody }]);
    await expect(
      makeOpenAiCompatibleProvider({ lookup: privateLookup, requestFn }).generate(req, cred),
    ).rejects.toMatchObject({ code: "AI_HOST_NOT_ALLOWED" });
    expect(attempts()).toBe(0);
  });

  it("refuse un crédential sans base_url", async () => {
    const { requestFn } = scriptedTransport([{ statusCode: 200, body: okBody }]);
    await expect(
      makeOpenAiCompatibleProvider({ lookup, requestFn }).generate(req, {
        ...cred,
        baseUrl: undefined,
      }),
    ).rejects.toMatchObject({ code: "AI_HOST_NOT_ALLOWED", detail: "missing_base_url" });
  });
});

describe("dégradation prévue — le streaming retombe en réponse entière (§3.5)", () => {
  it("déclare ne pas streamer, et rend quand même le contrat de flux", async () => {
    const provider = makeOpenAiCompatibleProvider({
      lookup,
      requestFn: scriptedTransport([{ statusCode: 200, body: okBody }]).requestFn,
    });
    expect(provider.capabilities.streaming).toBe(false);

    const chunks = [];
    for await (const chunk of provider.stream(req, cred)) chunks.push(chunk);
    expect(chunks).toHaveLength(2);
    expect(chunks[1]).toMatchObject({ type: "done" });
  });
});

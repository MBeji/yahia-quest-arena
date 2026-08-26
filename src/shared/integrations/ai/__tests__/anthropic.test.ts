// @vitest-environment node
import { describe, expect, it, vi } from "vitest";
import type Anthropic from "@anthropic-ai/sdk";

import { AI_MAX_RETRIES, AI_TIMEOUT_MS } from "@/shared/constants/ai";
import { buildAnthropicContent, makeAnthropicProvider } from "../anthropic.server";
import { sealSecret, type AiCredential, type AiRequest } from "../types";

/**
 * L'adaptateur `anthropic`. Le SDK est remplacé par une fabrique injectée : la
 * CI n'ouvre aucune socket (§5), et ce fichier vérifie ce que l'adaptateur
 * PROMET — la césure de cache posée au bon endroit, le modèle réel journalisé,
 * et surtout R-5 : aucune erreur du SDK ne ressort telle quelle.
 */

const cred: AiCredential = {
  provider: "anthropic",
  secret: sealSecret("sk-ant-test"),
  models: { fast: "claude-haiku-4-5", rich: "claude-sonnet-5" },
};

const req: AiRequest = {
  tier: "rich",
  system: "Tu es un professeur.",
  blocks: [
    { label: "cours", text: "Le théorème de Pythagore.", cacheBoundary: true },
    { label: "reponse_eleve", text: "42" },
  ],
  maxTokens: 700,
  feature: "explain",
};

function fakeSdk(message: Partial<Anthropic.Message>) {
  const create = vi.fn().mockResolvedValue({
    content: [{ type: "text", text: "Voici pourquoi." }],
    usage: { input_tokens: 500, output_tokens: 120, cache_read_input_tokens: 400 },
    model: "claude-sonnet-5",
    stop_reason: "end_turn",
    ...message,
  });
  const factory = vi.fn().mockReturnValue({ messages: { create } } as unknown as Anthropic);
  return { factory, create };
}

describe("le contexte porte la césure de cache (é11 §3.4)", () => {
  it("pose cache_control sur le DERNIER bloc stable, et sur lui seul", () => {
    const content = buildAnthropicContent(req);
    expect(content).toHaveLength(2);
    expect(content[0]).toMatchObject({ cache_control: { type: "ephemeral" } });
    expect(content[1]).not.toHaveProperty("cache_control");
  });

  it("ne pose rien quand aucun bloc n'est marqué", () => {
    const content = buildAnthropicContent({ ...req, blocks: [{ label: "a", text: "x" }] });
    expect(content[0]).not.toHaveProperty("cache_control");
  });

  it("étiquette chaque bloc, pour que le modèle sache ce qu'il lit", () => {
    const [first] = buildAnthropicContent(req);
    expect(first).toMatchObject({ text: "<cours>\nLe théorème de Pythagore.\n</cours>" });
  });
});

describe("l'appel", () => {
  it("résout le palier vers le bon modèle et respecte la borne de tokens", async () => {
    const { factory, create } = fakeSdk({});
    await makeAnthropicProvider(factory).generate(req, cred);
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({ model: "claude-sonnet-5", max_tokens: 700 }),
      expect.anything(),
    );
  });

  it("surcharge le délai et les essais PAR SURFACE, et non par client", async () => {
    // Le client est construit une fois ; sans cette surcharge par requête, un
    // élève attendrait deux fois moins longtemps selon la clé de sa famille.
    const { factory, create } = fakeSdk({});
    await makeAnthropicProvider(factory).generate({ ...req, feature: "forge" }, cred);

    expect(create.mock.calls[0][1]).toMatchObject({
      timeout: AI_TIMEOUT_MS.forge,
      maxRetries: AI_MAX_RETRIES.forge,
    });
  });

  it("cache aussi le système — premier élément du préfixe stable", async () => {
    const { factory, create } = fakeSdk({});
    await makeAnthropicProvider(factory).generate(req, cred);
    const args = create.mock.calls[0][0] as { system: unknown[] };
    expect(args.system[0]).toMatchObject({ cache_control: { type: "ephemeral" } });
  });

  it("rapporte l'usage, cache lu compris — c'est lui qui allège la facture", async () => {
    const { factory } = fakeSdk({});
    const result = await makeAnthropicProvider(factory).generate(req, cred);
    expect(result.usage).toEqual({ inputTokens: 500, outputTokens: 120, cachedTokens: 400 });
  });

  it("journalise le modèle RÉEL rapporté par l'API (R-13)", async () => {
    const { factory } = fakeSdk({ model: "claude-sonnet-5-substitue" as Anthropic.Model });
    const result = await makeAnthropicProvider(factory).generate(req, cred);
    expect(result.model).toBe("claude-sonnet-5-substitue");
  });

  it("demande la sortie structurée quand un schéma est fourni", async () => {
    const { factory, create } = fakeSdk({});
    await makeAnthropicProvider(factory).generate(
      { ...req, responseSchema: { type: "object", properties: {} } },
      cred,
    );
    expect(create.mock.calls[0][0]).toMatchObject({
      output_config: { format: { type: "json_schema" } },
    });
  });

  it("compte un refus du modèle comme un REBUT, pas comme une panne", async () => {
    // Ce n'est ni une clé invalide ni un fournisseur en rade : c'est une sortie
    // refusée, et elle doit peser dans le taux de rebut (R-13, R-19).
    const { factory } = fakeSdk({ stop_reason: "refusal" });
    await expect(makeAnthropicProvider(factory).generate(req, cred)).rejects.toMatchObject({
      code: "AI_OUTPUT_REJECTED",
      detail: "refusal",
    });
  });
});

describe("R-5 — rien du SDK ne franchit la frontière", () => {
  it("re-type une erreur d'authentification, sans son message", async () => {
    const create = vi
      .fn()
      .mockRejectedValue(
        Object.assign(new Error('401 invalid x-api-key "sk-ant-live-abcdef"'), { status: 401 }),
      );
    const factory = vi.fn().mockReturnValue({ messages: { create } } as unknown as Anthropic);

    let failure: Error | null = null;
    try {
      await makeAnthropicProvider(factory).generate(req, cred);
    } catch (error) {
      failure = error as Error;
    }

    expect(failure?.message).toBe("AI_KEY_INVALID");
    expect(failure?.message).not.toContain("sk-ant-live");
  });

  it("re-type une panne réseau sans statut", async () => {
    const create = vi.fn().mockRejectedValue(new Error("socket hang up"));
    const factory = vi.fn().mockReturnValue({ messages: { create } } as unknown as Anthropic);
    await expect(makeAnthropicProvider(factory).generate(req, cred)).rejects.toMatchObject({
      code: "AI_UNKNOWN",
    });
  });

  it("re-type un abandon (timeout de l'adaptateur) en panne de fournisseur", async () => {
    const create = vi
      .fn()
      .mockRejectedValue(Object.assign(new Error("aborted"), { name: "AbortError" }));
    const factory = vi.fn().mockReturnValue({ messages: { create } } as unknown as Anthropic);
    await expect(makeAnthropicProvider(factory).generate(req, cred)).rejects.toMatchObject({
      code: "AI_PROVIDER_DOWN",
    });
  });
});

describe("le streaming", () => {
  it("rend les morceaux puis le résultat complet", async () => {
    const events = [
      { type: "content_block_delta", delta: { type: "text_delta", text: "Voici " } },
      { type: "content_block_delta", delta: { type: "text_delta", text: "pourquoi." } },
      { type: "message_stop" },
    ];
    const stream = {
      async *[Symbol.asyncIterator]() {
        for (const event of events) yield event;
      },
      finalMessage: async () => ({
        content: [{ type: "text", text: "Voici pourquoi." }],
        usage: { input_tokens: 10, output_tokens: 5, cache_read_input_tokens: 0 },
        model: "claude-sonnet-5",
      }),
    };
    const factory = vi
      .fn()
      .mockReturnValue({ messages: { stream: () => stream } } as unknown as Anthropic);

    const chunks = [];
    for await (const chunk of makeAnthropicProvider(factory).stream(req, cred)) chunks.push(chunk);

    expect(chunks.filter((c) => c.type === "text")).toHaveLength(2);
    const done = chunks.at(-1);
    expect(done?.type === "done" && done.result.text).toBe("Voici pourquoi.");
  });
});

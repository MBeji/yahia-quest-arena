import { readFileSync } from "node:fs";
import { join } from "node:path";
import { afterEach, describe, expect, it, vi } from "vitest";

import { AI_MAX_TOKENS } from "@/shared/constants/ai";
import { makeFakeAiProvider } from "../fake.server";
import { logAiRequest, logAiUsage } from "../usage.server";
import { sealSecret, renderBlocks, cacheBoundaryIndex, revealSecret } from "../types";
import type { AiCredential, AiRequest } from "../types";

/**
 * La PORTE — ce que le lot 1 doit garantir avant qu'un seul lot suivant existe :
 * un barrel qui ne peut pas traîner le SDK dans le bundle client, des
 * kill-switches qui répondent à l'environnement au moment où on les lit, un
 * fournisseur factice qui rend la CI déterministe, et une comptabilité qui ne
 * casse jamais l'écran de l'élève.
 */

const cred: AiCredential = {
  provider: "anthropic",
  secret: sealSecret("sk-fake"),
  models: { fast: "claude-haiku-4-5", rich: "claude-sonnet-5" },
};

const req: AiRequest = {
  tier: "fast",
  system: "Système.",
  blocks: [
    { label: "cours", text: "Stable.", cacheBoundary: true },
    { label: "question", text: "Volatile." },
  ],
  maxTokens: AI_MAX_TOKENS.explain,
  feature: "explain",
};

describe("le barrel est ISOMORPHE — l'invariant de bundle, prouvé par lecture (§3.8)", () => {
  it("ne réexporte AUCUN module .server", () => {
    // « Absence du bundle client prouvée par build:check » — mais build:check
    // arrive trop tard pour dire POURQUOI. Cette lecture-ci nomme la cause : un
    // seul `export … from "./x.server"` suffirait à faire entrer
    // `@anthropic-ai/sdk` et `node:https` dans le graphe du navigateur.
    const source = readFileSync(join(process.cwd(), "src/shared/integrations/ai/index.ts"), "utf8");
    const imports = [...source.matchAll(/from\s+"(\.[^"]+)"/g)].map((m) => m[1]);
    expect(imports.length).toBeGreaterThan(0);
    for (const specifier of imports) {
      expect(specifier, `${specifier} est un module serveur`).not.toMatch(/\.server$/);
    }
  });

  it("aucun module isomorphe n'importe node:https ni le SDK", () => {
    for (const file of ["index.ts", "types.ts", "errors.ts", "pricing.ts"]) {
      const source = readFileSync(join(process.cwd(), "src/shared/integrations/ai", file), "utf8");
      // On vise les IMPORTS, pas les mentions en commentaire : ces fichiers
      // parlent volontiers du SDK pour expliquer pourquoi ils ne l'importent pas.
      expect(source, file).not.toMatch(/from\s+"@anthropic-ai\/sdk"/);
      expect(source, file).not.toMatch(/from\s+"node:/);
      expect(source, file).not.toMatch(/require\(/);
    }
  });
});

describe("les kill-switches lisent l'environnement à CHAQUE appel (§3.10)", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
    vi.resetModules();
  });

  async function load() {
    vi.resetModules();
    return import("../provider.server");
  }

  it("le mode IA est allumé par défaut", async () => {
    const { isAiModeEnabled } = await load();
    expect(isAiModeEnabled()).toBe(true);
  });

  it("AI_MODE_ENABLED=0 éteint TOUT — famille comme plateforme", async () => {
    vi.stubEnv("AI_MODE_ENABLED", "0");
    vi.stubEnv("AI_KEY_ENC_KEY", "x".repeat(44));
    vi.stubEnv("ANTHROPIC_API_KEY", "sk-platform");
    const { isAiModeEnabled, isByokEnabled, isPlatformPathEnabled } = await load();
    expect(isAiModeEnabled()).toBe(false);
    expect(isByokEnabled()).toBe(false);
    expect(isPlatformPathEnabled()).toBe(false);
  });

  it("sans AI_KEY_ENC_KEY, le BYOK est éteint et la plateforme CONTINUE", async () => {
    vi.stubEnv("ANTHROPIC_API_KEY", "sk-platform");
    const { isByokEnabled, isPlatformPathEnabled } = await load();
    expect(isByokEnabled()).toBe(false);
    expect(isPlatformPathEnabled()).toBe(true);
  });

  it("AI_BYOK_ENABLED=0 coupe le seul chemin famille", async () => {
    vi.stubEnv("AI_KEY_ENC_KEY", "x".repeat(44));
    vi.stubEnv("AI_BYOK_ENABLED", "0");
    vi.stubEnv("ANTHROPIC_API_KEY", "sk-platform");
    const { isByokEnabled, isPlatformPathEnabled } = await load();
    expect(isByokEnabled()).toBe(false);
    expect(isPlatformPathEnabled()).toBe(true);
  });

  it("sans ANTHROPIC_API_KEY, seul le BYOK fonctionne", async () => {
    vi.stubEnv("AI_KEY_ENC_KEY", "x".repeat(44));
    const { isByokEnabled, isPlatformPathEnabled, platformCredential } = await load();
    expect(isByokEnabled()).toBe(true);
    expect(isPlatformPathEnabled()).toBe(false);
    expect(platformCredential({ fast: "a", rich: "b" })).toBeNull();
  });

  it("le crédential plateforme sort de l'environnement, pas du coffre", async () => {
    vi.stubEnv("ANTHROPIC_API_KEY", "sk-platform-123");
    const { platformCredential } = await load();
    const credential = platformCredential({ fast: "a", rich: "b" });
    expect(credential?.provider).toBe("anthropic");
    expect(revealSecret(credential!.secret)).toBe("sk-platform-123");
  });

  it("AI_FAKE_PROVIDER=1 court-circuite TOUT — la CI ne peut pas appeler un vrai fournisseur", async () => {
    vi.stubEnv("AI_FAKE_PROVIDER", "1");
    const { getAiProvider } = await load();
    expect(getAiProvider("anthropic").id).toBe("fake");
    expect(getAiProvider("openai_compatible").id).toBe("fake");
  });

  it("le plafond plateforme vaut 5 $/jour par défaut (A5)", async () => {
    const { platformDailyBudgetUsd } = await load();
    expect(platformDailyBudgetUsd()).toBe(5);
    vi.stubEnv("AI_PLATFORM_DAILY_BUDGET_USD", "12.5");
    const reloaded = await load();
    expect(reloaded.platformDailyBudgetUsd()).toBe(12.5);
  });
});

describe("le fournisseur factice — déterministe, et il applique les mêmes bornes", () => {
  it("rend deux fois la même chose pour la même requête", async () => {
    const provider = makeFakeAiProvider();
    const a = await provider.generate(req, cred);
    const b = await provider.generate(req, cred);
    expect(a.text).toBe(b.text);
    expect(a.usage).toEqual(b.usage);
  });

  it("rend une chose DIFFÉRENTE pour une requête différente", async () => {
    const provider = makeFakeAiProvider();
    const a = await provider.generate(req, cred);
    const b = await provider.generate(
      { ...req, blocks: [{ label: "cours", text: "Autre chose." }] },
      cred,
    );
    expect(a.text).not.toBe(b.text);
  });

  it("rapporte un usage non nul — les tests de coût exercent le vrai calcul", async () => {
    const result = await makeFakeAiProvider().generate(req, cred);
    expect(result.usage.inputTokens).toBeGreaterThan(0);
    expect(result.usage.outputTokens).toBeGreaterThan(0);
  });

  it("résout le palier vers le bon modèle", async () => {
    const provider = makeFakeAiProvider();
    expect((await provider.generate(req, cred)).model).toBe("claude-haiku-4-5");
    expect((await provider.generate({ ...req, tier: "rich" }, cred)).model).toBe("claude-sonnet-5");
  });

  it("refuse un maxTokens au-delà de la borne de la surface (R-10)", async () => {
    await expect(
      makeFakeAiProvider().generate({ ...req, maxTokens: AI_MAX_TOKENS.explain + 1 }, cred),
    ).rejects.toMatchObject({ code: "AI_OUTPUT_REJECTED" });
  });

  it("répond `OK` à la vérification de clé — US-2 tient dans 16 tokens", async () => {
    const result = await makeFakeAiProvider().generate(
      { ...req, feature: "verify", maxTokens: AI_MAX_TOKENS.verify },
      cred,
    );
    expect(result.text).toBe("OK");
  });

  it("streame en plusieurs morceaux puis rend le résultat complet", async () => {
    const chunks = [];
    for await (const chunk of makeFakeAiProvider().stream(req, cred)) chunks.push(chunk);
    const text = chunks
      .filter((c) => c.type === "text")
      .map((c) => (c.type === "text" ? c.text : ""))
      .join("");
    const done = chunks.at(-1);
    expect(done?.type).toBe("done");
    expect(done?.type === "done" && done.result.text).toBe(text);
  });

  it("un fournisseur sans streaming échoue au lieu de faire semblant", async () => {
    const provider = makeFakeAiProvider({
      streaming: false,
      structuredOutput: false,
      promptCache: false,
    });
    const iterator = provider.stream(req, cred)[Symbol.asyncIterator]();
    await expect(iterator.next()).rejects.toThrow();
  });
});

describe("l'ordre des blocs sert le cache de prompt (é11 §3.4)", () => {
  it("assemble les blocs dans l'ordre donné", () => {
    expect(renderBlocks(req.blocks)).toBe(
      "<cours>\nStable.\n</cours>\n\n<question>\nVolatile.\n</question>",
    );
  });

  it("repère la césure de cache, et rend -1 quand il n'y en a pas", () => {
    expect(cacheBoundaryIndex(req.blocks)).toBe(0);
    expect(cacheBoundaryIndex([{ label: "a", text: "x" }])).toBe(-1);
  });
});

describe("le secret est opaque (D-3)", () => {
  it("ne se sérialise pas, ne s'imprime pas", () => {
    const secret = sealSecret("sk-live-tres-secret");
    expect(String(secret)).toBe("[secret]");
    expect(`${secret}`).not.toContain("sk-live");
  });

  it("ne se rend qu'au travers d'un appel NOMMÉ, donc cherchable en revue", () => {
    expect(revealSecret(sealSecret("sk-live-tres-secret"))).toBe("sk-live-tres-secret");
  });
});

describe("la comptabilité ne casse jamais l'écran de l'élève", () => {
  const event = {
    userId: "u1",
    payer: "family" as const,
    credentialOwner: "p1",
    provider: "anthropic",
    feature: "explain" as const,
    model: "claude-haiku-4-5",
    status: "ok" as const,
  };

  it("écrit l'événement par la RPC, avec son payeur (R-7)", async () => {
    const rpc = vi.fn().mockResolvedValue({ data: 1, error: null });
    await expect(logAiUsage({ rpc }, event)).resolves.toBe(true);
    expect(rpc).toHaveBeenCalledWith(
      "log_ai_usage",
      expect.objectContaining({ p_payer: "family", p_credential_owner: "p1" }),
    );
  });

  it("rend `false` sans lever quand l'écriture échoue", async () => {
    const rpc = vi.fn().mockResolvedValue({ data: null, error: { message: "boom" } });
    await expect(logAiUsage({ rpc }, event)).resolves.toBe(false);
  });

  it("n'envoie ni texte d'élève, ni sortie de modèle — la liste des champs est fermée (§3.9)", async () => {
    const rpc = vi.fn().mockResolvedValue({ data: 1, error: null });
    await logAiUsage({ rpc }, event);
    const args = rpc.mock.calls[0][1] as Record<string, unknown>;
    expect(Object.keys(args).sort()).toEqual([
      "p_cached_tokens",
      "p_cost_usd_micros",
      "p_credential_owner",
      "p_error_code",
      "p_feature",
      "p_input_tokens",
      "p_latency_ms",
      "p_model",
      "p_output_tokens",
      "p_payer",
      "p_provider",
      "p_status",
      "p_user",
    ]);
  });

  it("le log structuré passe par le logger du projet, jamais par console", () => {
    const spy = vi.spyOn(console, "info").mockImplementation(() => {});
    logAiRequest({
      feature: "explain",
      payer: "family",
      provider: "anthropic",
      model: "claude-haiku-4-5",
      tier: "fast",
      latencyMs: 12,
      tokensIn: 10,
      tokensOut: 20,
      costUsdMicros: 30,
      status: "ok",
    });
    const line = JSON.parse(spy.mock.calls[0][0] as string) as Record<string, unknown>;
    expect(line.message).toBe("ai.request");
    expect(line.payer).toBe("family");
    spy.mockRestore();
  });
});

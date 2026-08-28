// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * CHANGER DE MODÈLE SANS RECOLLER LA CLÉ — et l'invariant du §5 qui tient quand
 * même : « rien n'est écrit qui n'ait répondu ».
 *
 * Le besoin est venu de l'usage, le 2026-08-28 : R-4 rend une clé enregistrée
 * irrécupérable, si bien que corriger un simple identifiant de modèle imposait
 * de ressaisir la clé entière — sur le geste le plus courant qui soit, quitter
 * un modèle à raisonnement trop lent pour répondre devant un élève.
 *
 * Ce que ce fichier surveille, et qui est la seule chose qui compte ici :
 *   1. l'appel de vérification a lieu AVANT l'écriture, avec le NOUVEAU modèle ;
 *   2. un modèle refusé par le fournisseur ne laisse AUCUNE trace en base ;
 *   3. le client n'envoie que deux modèles — il ne peut pas, au passage, se
 *      réécrire un plafond, un consentement ou une adresse.
 */

const USER = "11111111-1111-4111-8111-111111111111";

/** Le contrat d'un appel de modèle, réduit à ce que les assertions lisent. */
type VerifyCall = (
  request: { tier: string; feature: string },
  credential: { models: { fast: string; rich: string } },
) => Promise<unknown>;
type RpcCall = (
  fn: string,
  args?: Record<string, unknown>,
) => Promise<{ data: unknown; error: { message: string } | null }>;

const { mockUserRpc, mockAdminRpc, mockGenerate, mockOpenOwnerSecret, mockResolveEgress } =
  vi.hoisted(() => ({
    mockUserRpc: vi.fn<RpcCall>(),
    mockAdminRpc: vi.fn<RpcCall>(),
    mockGenerate: vi.fn<VerifyCall>(),
    mockOpenOwnerSecret: vi.fn<(owner: string) => Promise<unknown>>(),
    mockResolveEgress: vi.fn<(url: string) => Promise<unknown>>(),
  }));

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (fn: unknown) => fn }),
  createServerFn: () => {
    let handlerFn: (opts: unknown) => unknown;
    let validatorFn: ((d: unknown) => unknown) | undefined;
    const chain = {
      middleware: () => chain,
      inputValidator: (fn: (d: unknown) => unknown) => {
        validatorFn = fn;
        return chain;
      },
      handler: (fn: (opts: unknown) => unknown) => {
        handlerFn = fn;
        return async (input: unknown) => {
          const payload =
            input && typeof input === "object" && "data" in input
              ? (input as { data: unknown }).data
              : input;
          const data = validatorFn ? validatorFn(payload) : payload;
          return handlerFn({ data, context: { supabase: { rpc: mockUserRpc }, userId: USER } });
        };
      },
    };
    return chain;
  },
}));

vi.mock("@/shared/integrations/supabase/auth-middleware", () => ({
  requireSupabaseAuth: "mock-middleware",
}));
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { rpc: mockAdminRpc },
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));
vi.mock("@/shared/integrations/ai/provider.server", () => ({
  isAiModeEnabled: () => true,
  isByokEnabled: () => true,
  getAiProvider: () => ({ generate: mockGenerate }),
}));
vi.mock("@/shared/integrations/ai/egress.server", () => ({
  resolveEgressTarget: (url: string) => mockResolveEgress(url),
}));
vi.mock("@/shared/integrations/ai/usage.server", () => ({ logAiUsage: vi.fn() }));
vi.mock("../ai-vault.server", () => ({
  openOwnerSecret: (owner: string) => mockOpenOwnerSecret(owner),
  markCredentialState: vi.fn(),
}));
vi.mock("../crypto.server", () => ({
  AI_ENC_VERSION: 1,
  isVaultAvailable: () => true,
  sealForRow: () => Buffer.from("scelle"),
  fingerprint: () => "empreinte",
  last4: () => "6hzw",
}));

import { AiError } from "@/shared/integrations/ai";
import { sealSecret } from "@/shared/integrations/ai/types";
import { setAiModels } from "../ai-credentials.server";

/** La ligne telle que `get_ai_credential_status` la rend. */
const ROW = {
  provider: "openai_compatible",
  base_url: "https://api.x.ai/v1",
  model_fast: "grok-4.6",
  model_rich: "grok-4.6",
  last4: "6hzw",
  status: "active",
  last_error_code: null,
  verified_at: "2026-08-28T09:00:00Z",
  last_used_at: null,
  daily_budget_usd: 2,
  monthly_budget_usd: 20,
  double_solve: true,
  consent_version: "2026-08-22",
  limits_enforced: false,
};

const OK_RESULT = {
  text: "OK",
  usage: { inputTokens: 8, outputTokens: 2, cachedTokens: 0 },
  model: "grok-4-fast",
  latencyMs: 120,
};

beforeEach(() => {
  vi.clearAllMocks();
  mockUserRpc.mockImplementation(async (fn: string) =>
    fn === "get_ai_credential_status" ? { data: [ROW], error: null } : { data: null, error: null },
  );
  mockAdminRpc.mockImplementation(async () => ({ data: null, error: null }));
  mockGenerate.mockResolvedValue(OK_RESULT);
  mockOpenOwnerSecret.mockResolvedValue({
    secret: sealSecret("sk-xai-secret-de-test"),
    provider: "openai_compatible",
  });
  mockResolveEgress.mockResolvedValue({});
});

describe("setAiModels — la clé vient du coffre, la vérification reste obligatoire", () => {
  it("vérifie le NOUVEAU modèle, puis écrit", async () => {
    await setAiModels({ data: { modelFast: "grok-4-fast", modelRich: "grok-4" } });

    // §5 : l'appel de US-2, à l'identique — même prompt, même plafond de tokens.
    expect(mockGenerate).toHaveBeenCalledTimes(1);
    const [request, credential] = mockGenerate.mock.calls[0];
    expect(request).toMatchObject({ tier: "fast", feature: "verify" });
    expect(credential.models).toEqual({ fast: "grok-4-fast", rich: "grok-4" });

    const write = mockAdminRpc.mock.calls.find(([fn]) => fn === "set_ai_credential");
    expect(write?.[1]).toMatchObject({
      p_model_fast: "grok-4-fast",
      p_model_rich: "grok-4",
      p_status: "active",
    });
  });

  it("n'écrit RIEN quand le fournisseur refuse le modèle", async () => {
    mockGenerate.mockRejectedValue(new AiError("AI_MODEL_UNKNOWN", { httpStatus: 404 }));

    await expect(
      setAiModels({ data: { modelFast: "modele-qui-nexiste-pas", modelRich: "grok-4" } }),
    ).rejects.toThrow(/AI_MODEL_UNKNOWN/);

    // La ligne en base ne bouge pas : un modèle non vérifié n'est jamais servi
    // à un élève, et le porteur garde celui qui marchait.
    expect(mockAdminRpc.mock.calls.find(([fn]) => fn === "set_ai_credential")).toBeUndefined();
  });

  it("reprend l'état COURANT pour tout ce que le client n'envoie pas", async () => {
    await setAiModels({ data: { modelFast: "grok-4-fast", modelRich: "grok-4" } });

    const write = mockAdminRpc.mock.calls.find(([fn]) => fn === "set_ai_credential");
    // Le client n'envoie que deux modèles. Plafonds, consentement, fournisseur
    // et adresse viennent de la BASE — il ne peut donc pas s'en réécrire un au
    // passage, ce qui serait une élévation de privilège déguisée en réglage.
    expect(write?.[1]).toMatchObject({
      p_owner: USER,
      p_provider: "openai_compatible",
      p_base_url: "https://api.x.ai/v1",
      p_daily_budget_usd: 2,
      p_monthly_budget_usd: 20,
      p_consent_version: "2026-08-22",
      p_double_solve: true,
    });
  });

  it("re-passe R-6 sur l'adresse, même déjà enregistrée", async () => {
    mockResolveEgress.mockRejectedValue(new AiError("AI_HOST_NOT_ALLOWED", { detail: "private" }));

    await expect(
      setAiModels({ data: { modelFast: "grok-4-fast", modelRich: "grok-4" } }),
    ).rejects.toThrow(/AI_HOST_NOT_ALLOWED/);
    // Recalée avant le moindre octet envoyé au fournisseur.
    expect(mockGenerate).not.toHaveBeenCalled();
  });

  it("refuse quand il n'y a aucune clé à modifier", async () => {
    mockUserRpc.mockImplementation(async () => ({ data: [], error: null }));

    await expect(
      setAiModels({ data: { modelFast: "grok-4-fast", modelRich: "grok-4" } }),
    ).rejects.toThrow(/AI_MODE_OFF/);
    expect(mockOpenOwnerSecret).not.toHaveBeenCalled();
  });

  it("nomme la clé illisible au lieu d'écrire par-dessus (RISK-10)", async () => {
    mockOpenOwnerSecret.mockResolvedValue(null);

    await expect(
      setAiModels({ data: { modelFast: "grok-4-fast", modelRich: "grok-4" } }),
    ).rejects.toThrow(/AI_KEY_INVALID/);
    expect(mockGenerate).not.toHaveBeenCalled();
  });
});

// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

/**
 * `openOwnerSecret` — la lecture du CHIFFRÉ d'une clé de famille, en un seul
 * exemplaire. Le type généré ne garde de `ai_credentials.provider` que `string` ;
 * le SQL le borne par un CHECK, et le fournisseur entre dans l'AAD du chiffré. Un
 * fournisseur hors de `AI_PROVIDERS` est donc une clé INUTILISABLE : elle ne doit
 * pas atteindre le coffre, ni être marquée invalide comme une clé illisible.
 */
const { mockMaybeSingle, mockOpenSecret, mockRpc, mockLoggerError } = vi.hoisted(() => ({
  mockMaybeSingle: vi.fn(),
  mockOpenSecret: vi.fn(),
  mockRpc: vi.fn(),
  mockLoggerError: vi.fn(),
}));

const select = vi.fn(() => ({ eq: vi.fn(() => ({ maybeSingle: mockMaybeSingle })) }));
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { from: vi.fn(() => ({ select })), rpc: mockRpc },
}));
vi.mock("@/shared/integrations/ai/crypto.server", () => ({
  openSecret: (...args: unknown[]) => mockOpenSecret(...args),
  rewriteUnderCurrentKek: vi.fn(),
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: mockLoggerError, warn: vi.fn(), info: vi.fn() },
}));

import { openOwnerSecret } from "../ai-vault.server";

const ROW = { secret_enc: "\\x0a0b0c", enc_version: 1, provider: "anthropic" };
const SECRET = { sealed: true };

beforeEach(() => {
  vi.clearAllMocks();
  mockRpc.mockResolvedValue({ error: null });
  mockOpenSecret.mockReturnValue({ secret: SECRET, needsRewrite: false });
});

describe("openOwnerSecret", () => {
  it("ouvre la clé d'un fournisseur connu et le rend tel quel", async () => {
    mockMaybeSingle.mockResolvedValue({ data: ROW, error: null });

    await expect(openOwnerSecret("parent-1")).resolves.toEqual({
      secret: SECRET,
      provider: "anthropic",
    });
    expect(select).toHaveBeenCalledWith("secret_enc, enc_version, provider");
    expect(mockOpenSecret).toHaveBeenCalledWith(Buffer.from("0a0b0c", "hex"), {
      ownerUserId: "parent-1",
      provider: "anthropic",
      encVersion: 1,
    });
  });

  it("refuse un fournisseur inconnu AVANT le coffre, sans marquer la clé illisible", async () => {
    mockMaybeSingle.mockResolvedValue({ data: { ...ROW, provider: "mistral" }, error: null });

    await expect(openOwnerSecret("parent-1")).resolves.toBeNull();
    expect(mockOpenSecret).not.toHaveBeenCalled();
    // `invalid` dirait au parent de re-saisir une clé qui n'est pas en cause.
    expect(mockRpc).not.toHaveBeenCalled();
    expect(mockLoggerError).toHaveBeenCalledWith("ai.credential.load", {
      error: "unknown provider",
    });
  });

  it("rend null sur une ligne absente", async () => {
    mockMaybeSingle.mockResolvedValue({ data: null, error: null });

    await expect(openOwnerSecret("parent-1")).resolves.toBeNull();
    expect(mockOpenSecret).not.toHaveBeenCalled();
  });
});

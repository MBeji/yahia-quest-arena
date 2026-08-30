// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockInsert, mockFrom } = vi.hoisted(() => {
  const insert = vi.fn();
  return { mockInsert: insert, mockFrom: vi.fn(() => ({ insert })) };
});

vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { from: mockFrom },
}));

import { MAX_CLIENT_LOG_BYTES, handleClientLogRequest } from "@/shared/lib/client-log.server";

function post(body: unknown, headers: Record<string, string> = {}): Request {
  return new Request("https://na9ra.test/api/client-log", {
    method: "POST",
    headers: { "content-type": "application/json", ...headers },
    body: typeof body === "string" ? body : JSON.stringify(body),
  });
}

const VALID = {
  stage: "outbox-flush",
  clientId: "quest.submit:s-1",
  errMessage: "Unauthorized: Invalid token",
  ttlS: 1800,
  hiddenTotalMs: 400_000,
  lastHiddenMs: 380_000,
};

beforeEach(() => {
  vi.clearAllMocks();
  mockInsert.mockResolvedValue({ error: null });
});

describe("handleClientLogRequest", () => {
  it("N'EXIGE AUCUN JETON — c'est la condition de son utilité", async () => {
    // Au moment où un élève a quelque chose à raconter ici, son jeton est cassé.
    // Exiger un Bearer valide ne consignerait que les incidents qui ne se sont
    // PAS produits. Aucun en-tête `authorization` dans cette requête.
    const response = await handleClientLogRequest(post(VALID));

    expect(response.status).toBe(204);
    expect(mockInsert).toHaveBeenCalledTimes(1);
  });

  it("consigne les champs du diagnostic", async () => {
    await handleClientLogRequest(post(VALID, { "user-agent": "Mozilla/5.0 (iPhone)" }));

    expect(mockFrom).toHaveBeenCalledWith("client_errors");
    expect(mockInsert).toHaveBeenCalledWith(
      expect.objectContaining({
        stage: "outbox-flush",
        client_id: "quest.submit:s-1",
        err_message: "Unauthorized: Invalid token",
        ttl_s: 1800,
        hidden_total_ms: 400_000,
        last_hidden_ms: 380_000,
        // L'agent vient de l'EN-TÊTE, pas du corps.
        user_agent: "Mozilla/5.0 (iPhone)",
      }),
    );
  });

  it("plafonne le corps à 8 ko, sur le Content-Length annoncé", async () => {
    const response = await handleClientLogRequest(
      post(VALID, { "content-length": String(MAX_CLIENT_LOG_BYTES + 1) }),
    );

    expect(response.status).toBe(204);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("plafonne aussi sur les octets RÉELLEMENT reçus", async () => {
    // `Content-Length` est absent en `Transfer-Encoding: chunked` : la seconde
    // mesure est celle qui tient vraiment.
    const oversized = { stage: "x", errMessage: "a".repeat(MAX_CLIENT_LOG_BYTES) };

    const response = await handleClientLogRequest(post(oversized));

    expect(response.status).toBe(204);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("ignore un corps illisible", async () => {
    const response = await handleClientLogRequest(post("{pas du json"));

    expect(response.status).toBe(204);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("ignore une ligne sans `stage` — elle ne dirait d'où elle vient", async () => {
    const response = await handleClientLogRequest(post({ errMessage: "boom" }));

    expect(response.status).toBe(204);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("ignore un tableau ou un scalaire à la racine", async () => {
    expect((await handleClientLogRequest(post([1, 2]))).status).toBe(204);
    expect((await handleClientLogRequest(post("42"))).status).toBe(204);
    expect(mockInsert).not.toHaveBeenCalled();
  });

  it("neutralise les champs numériques que le client aurait mal remplis", async () => {
    await handleClientLogRequest(post({ ...VALID, ttlS: "beaucoup", httpStatus: null }));

    expect(mockInsert).toHaveBeenCalledWith(
      expect.objectContaining({ ttl_s: null, http_status: null }),
    );
  });

  it("ne répond jamais autre chose que 204, même base en panne", async () => {
    // Un client qui apprend que sa télémétrie a échoué ne peut rien en faire.
    mockInsert.mockRejectedValue(new Error("database is down"));

    const response = await handleClientLogRequest(post(VALID));

    expect(response.status).toBe(204);
  });

  it("n'écrit rien sur une méthode autre que POST", async () => {
    const response = await handleClientLogRequest(
      new Request("https://na9ra.test/api/client-log", { method: "GET" }),
    );

    expect(response.status).toBe(204);
    expect(mockInsert).not.toHaveBeenCalled();
  });
});

import { beforeEach, describe, expect, it, vi } from "vitest";

import { RATE_LIMIT_MAX_REQUESTS } from "@/shared/lib/bot-guard";

const {
  mockRenderErrorPage,
  mockConsumeLastCapturedError,
  mockLoggerError,
  mockServerFetch,
  mockHandleHealthRequest,
  mockHandleDigestCron,
} = vi.hoisted(() => ({
  mockRenderErrorPage: vi.fn(() => "<html>fallback</html>"),
  mockConsumeLastCapturedError: vi.fn((): unknown => undefined),
  mockLoggerError: vi.fn(),
  mockServerFetch: vi.fn(),
  mockHandleHealthRequest: vi.fn(),
  mockHandleDigestCron: vi.fn(),
}));

vi.mock("@/shared/lib/health", () => ({
  handleHealthRequest: mockHandleHealthRequest,
}));

/**
 * Le batch des bilans hebdomadaires (é11 lot 6) est MOQUÉ, et pas seulement
 * parce qu'aucune assertion d'ici ne le déclenche.
 *
 * Chaque test de ce fichier fait `vi.resetModules()` puis ré-importe `@/server`
 * — c'est le seul moyen de rejouer le wrapper avec des collaborateurs neufs.
 * Le vrai `digest.server.ts` traîne `callAi` (donc tout le barrel `features/ai`,
 * son fournisseur et son crypto) et le client `service_role` : à cinq reprises,
 * ce graphe a fait passer la phase `tests` de ce fichier de 1,4 s à 7,5 s,
 * jusqu'à crever le `testTimeout` de 15 s dès que la machine est chargée. Le
 * sujet du fichier est le ROUTAGE du wrapper, jamais ce que le batch rédige :
 * ses 796 lignes de tests vivent dans `features/tutor/__tests__`.
 */
vi.mock("@/features/tutor/digest.server", () => ({
  handleDigestCron: mockHandleDigestCron,
}));

vi.mock("@tanstack/react-start/server-entry", () => ({
  default: {
    fetch: mockServerFetch,
  },
}));

vi.mock("@/shared/lib/error-page", () => ({
  renderErrorPage: mockRenderErrorPage,
}));

vi.mock("@/shared/lib/error-capture", () => ({
  consumeLastCapturedError: mockConsumeLastCapturedError,
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: {
    error: mockLoggerError,
  },
}));

describe("server fetch wrapper", () => {
  beforeEach(() => {
    vi.resetModules();
    mockServerFetch.mockReset();
    mockLoggerError.mockReset();
    mockConsumeLastCapturedError.mockReset();
    mockRenderErrorPage.mockReset();
    mockRenderErrorPage.mockReturnValue("<html>fallback</html>");
    mockHandleHealthRequest.mockReset();
    mockHandleDigestCron.mockReset();
  });

  it("serves /api/health BEFORE the bot guard, so a monitor is never refused", async () => {
    mockHandleHealthRequest.mockResolvedValue(
      new Response('{"status":"ok"}', {
        status: 200,
        headers: { "content-type": "application/json" },
      }),
    );

    const server = (await import("@/server")).default;
    // `python-requests` is on the guard's block list (403) — and it is exactly
    // the kind of agent a real uptime monitor announces itself with. If this
    // ever regresses to running after the guard, the monitor reports a
    // permanent outage that does not exist.
    const request = new Request("https://app.local/api/health", {
      headers: { "user-agent": "python-requests/2.31.0" },
    });

    const response = await server.fetch(request, {}, {});

    expect(response.status).toBe(200);
    expect(mockHandleHealthRequest).toHaveBeenCalled();
    expect(mockServerFetch).not.toHaveBeenCalled();
  });

  it("answers 503 JSON — not the branded HTML page — when the probe itself throws", async () => {
    mockHandleHealthRequest.mockRejectedValue(new Error("boom"));

    const server = (await import("@/server")).default;
    const response = await server.fetch(new Request("https://app.local/api/health"), {}, {});

    expect(response.status).toBe(503);
    expect(response.headers.get("content-type")).toContain("application/json");
    expect(response.headers.get("cache-control")).toContain("no-store");
    expect(mockLoggerError).toHaveBeenCalledWith("Health endpoint failed", expect.anything());
  });

  // ÉTUDE 11 LOT 6 — la porte du batch hebdomadaire, et pourquoi sa POSITION
  // dans la chaîne est le contrat plutôt qu'un détail d'implémentation.
  it("sert /api/cron/digest AU-DELÀ du plafond de rafale par IP, sans réveiller le SSR", async () => {
    mockHandleDigestCron.mockResolvedValue(
      new Response('{"done":3,"cursor":null}', {
        status: 200,
        headers: { "content-type": "application/json" },
      }),
    );

    const server = (await import("@/server")).default;
    const slice = (n: number) =>
      new Request(`https://app.local/api/cron/digest?n=${n}`, {
        method: "POST",
        // Une seule IP : celle du runner GitHub qui exécute
        // `scripts/ai/tutor-digests.mjs`, lequel rappelle la route JUSQU'À
        // épuisement du curseur.
        headers: { authorization: "Bearer secret", "x-forwarded-for": "203.0.113.7" },
      });

    // On dépasse volontairement le plafond : c'est le contrôle négatif de ce
    // test. Si l'interception repassait un jour APRÈS `guardRequest`, la
    // 601ᵉ tranche recevrait un 429 — le batch s'arrêterait au milieu, et
    // treize heures plus tard la notification dominicale annoncerait des bilans
    // qui n'ont jamais été écrits.
    for (let n = 0; n < RATE_LIMIT_MAX_REQUESTS + 1; n += 1) {
      const response = await server.fetch(slice(n), {}, {});
      expect(response.status).toBe(200);
    }

    expect(mockHandleDigestCron).toHaveBeenCalledTimes(RATE_LIMIT_MAX_REQUESTS + 1);
    expect(mockServerFetch).not.toHaveBeenCalled();
  });

  it("répond 500 en JSON quand le batch jette — jamais la page HTML de marque", async () => {
    mockHandleDigestCron.mockRejectedValue(new Error("boom"));

    const server = (await import("@/server")).default;
    const response = await server.fetch(
      new Request("https://app.local/api/cron/digest", { method: "POST" }),
      {},
      {},
    );

    // L'appelant est un SCRIPT, pas un navigateur : lui rendre la page d'erreur
    // de marque le ferait boucler sur du HTML qu'il ne sait pas lire. Il doit
    // voir un statut d'échec net, et l'incident doit être journalisé — sans quoi
    // une semaine sans bilan passerait pour une semaine sans activité.
    expect(response.status).toBe(500);
    expect(mockRenderErrorPage).not.toHaveBeenCalled();
    expect(mockLoggerError).toHaveBeenCalledWith("Digest cron dispatch failed", expect.anything());
  });

  it("returns branded HTML response when server entry throws", async () => {
    mockServerFetch.mockRejectedValue(new Error("boom"));

    const server = (await import("@/server")).default;
    const request = new Request("https://app.local/fail");

    const response = await server.fetch(request, {}, {});

    expect(response.status).toBe(500);
    expect(response.headers.get("content-type")).toContain("text/html");
    await expect(response.text()).resolves.toBe("<html>fallback</html>");
    expect(mockLoggerError).toHaveBeenCalledWith(
      "Unhandled server fetch error",
      expect.objectContaining({ path: "/fail" }),
    );
  });

  it("normalizes swallowed catastrophic SSR JSON errors", async () => {
    mockServerFetch.mockResolvedValue(
      new Response(JSON.stringify({ unhandled: true, message: "HTTPError", status: 500 }), {
        status: 500,
        headers: { "content-type": "application/json" },
      }),
    );
    mockConsumeLastCapturedError.mockReturnValue(new Error("captured-ssr"));

    const server = (await import("@/server")).default;
    const request = new Request("https://app.local/catastrophic");

    const response = await server.fetch(request, {}, {});

    expect(response.status).toBe(500);
    expect(response.headers.get("content-type")).toContain("text/html");
    await expect(response.text()).resolves.toBe("<html>fallback</html>");
    expect(mockLoggerError).toHaveBeenCalledWith(
      "SSR response normalized after swallowed catastrophic error",
      expect.objectContaining({ status: 500 }),
    );
  });

  it("keeps non-catastrophic responses unchanged", async () => {
    const upstream = new Response(JSON.stringify({ ok: true }), {
      status: 500,
      headers: { "content-type": "application/json" },
    });
    mockServerFetch.mockResolvedValue(upstream);

    const server = (await import("@/server")).default;
    const request = new Request("https://app.local/regular");

    const response = await server.fetch(request, {}, {});

    expect(response).toBe(upstream);
    expect(mockLoggerError).not.toHaveBeenCalled();
  });
});

import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockLoggerError, mockCreatePublicClient } = vi.hoisted(() => ({
  mockLoggerError: vi.fn(),
  mockCreatePublicClient: vi.fn(),
}));

vi.mock("@/shared/lib/logger", () => ({
  logger: { error: mockLoggerError, warn: vi.fn(), info: vi.fn(), debug: vi.fn() },
}));

vi.mock("@/shared/integrations/supabase/public-client", () => ({
  createPublicSupabaseClient: mockCreatePublicClient,
}));

import {
  probeDatabase,
  deploymentCommit,
  buildHealthReport,
  healthResponse,
  handleHealthRequest,
  HEALTH_TIMEOUT_MS,
} from "@/shared/lib/health";

type ProbeClient = Parameters<typeof probeDatabase>[0];

/** Minimal stand-in for the Supabase query chain `.from().select().limit().abortSignal()`. */
function fakeClient(settle: () => Promise<{ error: unknown }>): ProbeClient {
  const chain = {
    select: () => chain,
    limit: () => chain,
    abortSignal: () => settle(),
  };
  return { from: () => chain } as unknown as ProbeClient;
}

describe("probeDatabase", () => {
  beforeEach(() => mockLoggerError.mockReset());

  it("reports healthy when the read comes back without an error", async () => {
    await expect(probeDatabase(fakeClient(async () => ({ error: null })))).resolves.toBe(true);
    expect(mockLoggerError).not.toHaveBeenCalled();
  });

  it("reports unhealthy — and logs — when the read returns a Postgres error", async () => {
    const client = fakeClient(async () => ({ error: { message: "permission denied" } }));
    await expect(probeDatabase(client)).resolves.toBe(false);
    expect(mockLoggerError).toHaveBeenCalledWith(
      "Health probe: database read failed",
      expect.objectContaining({ error: expect.anything() }),
    );
  });

  it("reports unhealthy when the connection throws, instead of propagating", async () => {
    const client = fakeClient(async () => {
      throw new Error("ECONNREFUSED db.internal:5432");
    });
    await expect(probeDatabase(client)).resolves.toBe(false);
    expect(mockLoggerError).toHaveBeenCalledWith(
      "Health probe: database unreachable",
      expect.anything(),
    );
  });

  it("passes an abort signal so a hung database cannot hang the probe", async () => {
    const abortSignal = vi.fn(async () => ({ error: null }));
    const chain = { select: () => chain, limit: () => chain, abortSignal };
    const client = { from: () => chain } as unknown as ProbeClient;

    await probeDatabase(client, 1234);

    expect(abortSignal).toHaveBeenCalledWith(expect.any(AbortSignal));
    expect(HEALTH_TIMEOUT_MS).toBeGreaterThan(0);
  });
});

describe("deploymentCommit", () => {
  it("shortens the Vercel commit SHA — the answer to 'which code is live?'", () => {
    expect(deploymentCommit({ VERCEL_GIT_COMMIT_SHA: "1de1a973e1165e758b1cb3e64f" })).toBe(
      "1de1a97",
    );
  });

  it("falls back to 'unknown' outside a Vercel build", () => {
    expect(deploymentCommit({})).toBe("unknown");
  });
});

describe("buildHealthReport", () => {
  const now = new Date("2026-07-20T18:30:00.000Z");

  it("is ok when the database answers", () => {
    expect(buildHealthReport(true, { commit: "abc1234", now })).toEqual({
      status: "ok",
      checks: { database: "ok" },
      commit: "abc1234",
      ts: "2026-07-20T18:30:00.000Z",
    });
  });

  it("is degraded when the database does not", () => {
    const report = buildHealthReport(false, { commit: "abc1234", now });
    expect(report.status).toBe("degraded");
    expect(report.checks.database).toBe("fail");
  });
});

describe("healthResponse", () => {
  const now = new Date("2026-07-20T18:30:00.000Z");

  it("answers 200 when healthy, so a status-code-only monitor suffices", async () => {
    const response = healthResponse(buildHealthReport(true, { commit: "abc1234", now }));
    expect(response.status).toBe(200);
    expect(response.headers.get("content-type")).toContain("application/json");
    await expect(response.json()).resolves.toMatchObject({ status: "ok", commit: "abc1234" });
  });

  it("answers 503 when degraded", () => {
    expect(healthResponse(buildHealthReport(false, { now })).status).toBe(503);
  });

  it("forbids caching — a cached health check reports the past", () => {
    const response = healthResponse(buildHealthReport(true, { now }));
    expect(response.headers.get("cache-control")).toContain("no-store");
  });

  it("never leaks anything beyond ok/fail in the body", async () => {
    const body = await healthResponse(buildHealthReport(false, { now })).text();
    expect(body).not.toMatch(/supabase|postgres|password|key|ECONNREFUSED|https?:/i);
  });
});

describe("handleHealthRequest", () => {
  beforeEach(() => {
    mockLoggerError.mockReset();
    mockCreatePublicClient.mockReset();
  });

  it("answers 200 when the probe succeeds", async () => {
    mockCreatePublicClient.mockReturnValue(fakeClient(async () => ({ error: null })));

    const response = await handleHealthRequest();

    expect(response.status).toBe(200);
    await expect(response.json()).resolves.toMatchObject({ status: "ok" });
  });

  it("reports degraded — not a 500 — when the Supabase env is missing", async () => {
    // readSupabaseEnv() throws when SUPABASE_URL/KEY are absent. A deployment
    // that cannot even build a client IS unhealthy, and the probe must say so
    // rather than crash: a 500 tells a monitor nothing about what broke.
    mockCreatePublicClient.mockImplementation(() => {
      throw new Error("Missing Supabase environment variable(s): SUPABASE_URL");
    });

    const response = await handleHealthRequest();

    expect(response.status).toBe(503);
    await expect(response.json()).resolves.toMatchObject({
      status: "degraded",
      checks: { database: "fail" },
    });
    expect(mockLoggerError).toHaveBeenCalledWith(
      "Health probe: Supabase client unavailable",
      expect.anything(),
    );
  });

  it("keeps the env failure detail out of the response body", async () => {
    mockCreatePublicClient.mockImplementation(() => {
      throw new Error("Missing Supabase environment variable(s): SUPABASE_URL");
    });

    const body = await (await handleHealthRequest()).text();

    expect(body).not.toMatch(/SUPABASE_URL|Missing/i);
  });
});

import { describe, it, expect, vi, beforeEach } from "vitest";

const mockSetVapid = vi.fn();
const mockSend = vi.fn();

class WebPushError extends Error {
  statusCode: number;
  constructor(message: string, statusCode: number) {
    super(message);
    this.statusCode = statusCode;
  }
}

vi.mock("web-push", () => ({
  default: { setVapidDetails: mockSetVapid, sendNotification: mockSend },
  WebPushError,
}));

const mockFrom = vi.fn();
// Le rappel du plan du jour (étude 11 US-7) lit son audience par RPC, pas par
// table : la sélection — opt-in armé, révision due, pas venu — est en SQL.
type PlanAudienceReply = {
  data: { user_id: string; due_count: number }[] | null;
  error: { message: string } | null;
};
const mockRpc = vi.fn(async (): Promise<PlanAudienceReply> => ({ data: [], error: null }));
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { from: mockFrom, rpc: mockRpc },
}));
vi.mock("@/shared/lib/logger", () => ({
  logger: { error: vi.fn(), warn: vi.fn(), info: vi.fn() },
}));

function cronRequest(authHeader?: string): Request {
  return new Request("https://app.test/api/cron/notify", {
    headers: authHeader ? { authorization: authHeader } : {},
  });
}

// Deterministic clocks (18:00 UTC → 19:00 Tunis, same civil day).
const WEDNESDAY = new Date("2026-07-01T18:00:00Z");
const SUNDAY = new Date("2026-07-05T18:00:00Z");

async function loadHandler() {
  return (await import("../notifications.cron.server")).handlePushCron;
}

beforeEach(() => {
  vi.resetModules();
  mockSetVapid.mockReset();
  mockSend.mockReset();
  mockFrom.mockReset();
  mockRpc.mockReset();
  mockRpc.mockResolvedValue({ data: [], error: null });
  process.env.CRON_SECRET = "secret";
  process.env.VAPID_SUBJECT = "mailto:a@b.c";
  process.env.VAPID_PUBLIC_KEY = "pub";
  process.env.VAPID_PRIVATE_KEY = "priv";
});

describe("handlePushCron", () => {
  it("returns 401 without the cron secret", async () => {
    const handle = await loadHandler();
    expect((await handle(cronRequest())).status).toBe(401);
  });

  it("returns 401 with a wrong secret", async () => {
    const handle = await loadHandler();
    expect((await handle(cronRequest("Bearer nope"))).status).toBe(401);
  });

  it("returns 500 when a VAPID var is missing", async () => {
    delete process.env.VAPID_PRIVATE_KEY;
    const handle = await loadHandler();
    expect((await handle(cronRequest("Bearer secret"))).status).toBe(500);
  });

  it("returns audience 0 when nobody is at risk (no digest outside Sunday)", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return { select: () => ({ gt: () => Promise.resolve({ data: [], error: null }) }) };
      throw new Error(`unexpected table ${table}`);
    });
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 0,
      sent: 0,
      pruned: 0,
      tutorPlan: { audience: 0, sent: 0, pruned: 0 },
      parentDigest: null,
    });
    expect(mockSend).not.toHaveBeenCalled();
  });

  it("sends to at-risk users and prunes dead endpoints (410)", async () => {
    const deleteIn = vi.fn().mockResolvedValue({ error: null });
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return {
          select: () => ({
            gt: () =>
              Promise.resolve({
                // last_active far in the past → at risk regardless of "today".
                data: [{ id: "u1", current_streak: 3, last_active_date: "2000-01-01" }],
                error: null,
              }),
          }),
        };
      if (table === "push_subscriptions")
        return {
          select: () => ({
            in: () =>
              Promise.resolve({
                data: [
                  { id: "s1", endpoint: "https://push/1", p256dh: "k1", auth: "a1" },
                  { id: "s2", endpoint: "https://push/2", p256dh: "k2", auth: "a2" },
                ],
                error: null,
              }),
          }),
          delete: () => ({ in: deleteIn }),
        };
      throw new Error(`unexpected table ${table}`);
    });
    mockSend.mockResolvedValueOnce(undefined); // s1 delivered
    mockSend.mockRejectedValueOnce(new WebPushError("gone", 410)); // s2 dead

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 1,
      sent: 1,
      pruned: 1,
      tutorPlan: { audience: 0, sent: 0, pruned: 0 },
      parentDigest: null,
    });
    expect(mockSetVapid).toHaveBeenCalledWith("mailto:a@b.c", "pub", "priv");
    expect(deleteIn).toHaveBeenCalledWith("id", ["s2"]);
  });

  it("prunes a burst of dead endpoints in ONE delete round-trip, not one per subscriber", async () => {
    const deleteIn = vi.fn().mockResolvedValue({ error: null });
    // 5 subscribers, every one of them gone: the old per-row DELETE issued 5
    // round-trips. The bulk prune must issue exactly one.
    const subs = Array.from({ length: 5 }, (_, i) => ({
      id: `s${i}`,
      endpoint: `https://push/${i}`,
      p256dh: `k${i}`,
      auth: `a${i}`,
    }));
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return {
          select: () => ({
            gt: () =>
              Promise.resolve({
                data: [{ id: "u1", current_streak: 3, last_active_date: "2000-01-01" }],
                error: null,
              }),
          }),
        };
      if (table === "push_subscriptions")
        return {
          select: () => ({ in: () => Promise.resolve({ data: subs, error: null }) }),
          delete: () => ({ in: deleteIn }),
        };
      throw new Error(`unexpected table ${table}`);
    });
    mockSend.mockRejectedValue(new WebPushError("gone", 410));

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 1,
      sent: 0,
      pruned: 5,
      tutorPlan: { audience: 0, sent: 0, pruned: 0 },
      parentDigest: null,
    });
    expect(deleteIn).toHaveBeenCalledTimes(1);
    expect(deleteIn).toHaveBeenCalledWith("id", ["s0", "s1", "s2", "s3", "s4"]);
  });

  it("keeps the cron green — and does not over-report — when pruning fails", async () => {
    const deleteIn = vi.fn().mockResolvedValue({ error: { message: "boom" } });
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return {
          select: () => ({
            gt: () =>
              Promise.resolve({
                data: [{ id: "u1", current_streak: 3, last_active_date: "2000-01-01" }],
                error: null,
              }),
          }),
        };
      if (table === "push_subscriptions")
        return {
          select: () => ({
            in: () =>
              Promise.resolve({
                data: [{ id: "s1", endpoint: "https://push/1", p256dh: "k1", auth: "a1" }],
                error: null,
              }),
          }),
          delete: () => ({ in: deleteIn }),
        };
      throw new Error(`unexpected table ${table}`);
    });
    mockSend.mockRejectedValueOnce(new WebPushError("gone", 410));

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    // The notification work already happened; a failed cleanup must not 500.
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 1,
      sent: 0,
      pruned: 0,
      tutorPlan: { audience: 0, sent: 0, pruned: 0 },
      parentDigest: null,
    });
  });

  it("on Sunday, also sends the weekly family digest to distinct linked parents", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return { select: () => ({ gt: () => Promise.resolve({ data: [], error: null }) }) };
      if (table === "parent_student_links")
        return {
          select: () => ({
            eq: () =>
              Promise.resolve({
                // p1 has two linked children → must receive ONE push, not two.
                data: [
                  { parent_user_id: "p1" },
                  { parent_user_id: "p1" },
                  { parent_user_id: "p2" },
                ],
                error: null,
              }),
          }),
        };
      if (table === "push_subscriptions")
        return {
          select: () => ({
            in: (_col: string, ids: string[]) => {
              expect(ids).toEqual(["p1", "p2"]);
              return Promise.resolve({
                data: [{ id: "s1", endpoint: "https://push/p1", p256dh: "k", auth: "a" }],
                error: null,
              });
            },
          }),
        };
      throw new Error(`unexpected table ${table}`);
    });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 0,
      sent: 0,
      pruned: 0,
      tutorPlan: { audience: 0, sent: 0, pruned: 0 },
      parentDigest: { audience: 2, sent: 1, pruned: 0 },
    });
    const payload = JSON.parse(mockSend.mock.calls[0][1] as string) as { tag: string; url: string };
    expect(payload.tag).toBe("weekly-family-report");
    expect(payload.url).toBe("/parent-report");
  });

  it("on Sunday with no active links, the digest reports an empty audience", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return { select: () => ({ gt: () => Promise.resolve({ data: [], error: null }) }) };
      if (table === "parent_student_links")
        return { select: () => ({ eq: () => Promise.resolve({ data: [], error: null }) }) };
      throw new Error(`unexpected table ${table}`);
    });

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 0,
      sent: 0,
      pruned: 0,
      tutorPlan: { audience: 0, sent: 0, pruned: 0 },
      parentDigest: { audience: 0, sent: 0, pruned: 0 },
    });
    expect(mockSend).not.toHaveBeenCalled();
  });
});

/**
 * LE RAPPEL DU PLAN DU JOUR — étude 11 US-7.
 *
 * Une seule promesse à garder, et c'est elle qui décide si l'opt-in survit :
 * AU PLUS UN RAPPEL PAR JOUR. Le rappel de série vise exactement la même
 * population — l'élève inactif d'aujourd'hui — donc sans exclusion explicite un
 * élève en série recevrait DEUX notifications le même soir, pour la même raison.
 * C'est la meilleure façon de faire couper les notifications, et c'est le test
 * qui suit.
 */
describe("le rappel du plan du jour (étude 11 US-7)", () => {
  function withProfiles(profiles: unknown[], subs: unknown[]) {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return { select: () => ({ gt: () => Promise.resolve({ data: profiles, error: null }) }) };
      if (table === "push_subscriptions")
        return {
          select: () => ({ in: () => Promise.resolve({ data: subs, error: null }) }),
          delete: () => ({ in: vi.fn().mockResolvedValue({ error: null }) }),
        };
      throw new Error(`unexpected table ${table}`);
    });
  }

  it("appelle l'audience avec le JOUR de Tunis, pas celui du serveur", async () => {
    withProfiles([], []);
    const handle = await loadHandler();
    // 18:00 UTC un mercredi → même jour civil à Tunis.
    await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect(mockRpc).toHaveBeenCalledWith("tutor_plan_push_audience", { p_today: "2026-07-01" });
  });

  it("envoie aux élèves qui l'ont armé, et le texte dit COMBIEN", async () => {
    withProfiles([], [{ id: "s1", endpoint: "https://push/1", p256dh: "k", auth: "a" }]);
    mockRpc.mockResolvedValue({ data: [{ user_id: "u9", due_count: 3 }], error: null });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(res.status).toBe(200);
    expect((await res.json()).tutorPlan).toEqual({ audience: 1, sent: 1, pruned: 0 });
    const payload = JSON.parse(mockSend.mock.calls[0][1] as string) as {
      tag: string;
      body: string;
    };
    expect(payload.tag).toBe("tutor-daily-plan");
    expect(payload.body).toContain("3");
  });

  it("⭐ n'appelle PAS deux fois le même élève le même soir", async () => {
    // u1 a une série en danger : il reçoit déjà le rappel de série.
    withProfiles(
      [{ id: "u1", current_streak: 3, last_active_date: "2000-01-01" }],
      [{ id: "s1", endpoint: "https://push/1", p256dh: "k", auth: "a" }],
    );
    mockRpc.mockResolvedValue({ data: [{ user_id: "u1", due_count: 2 }], error: null });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    const body = (await res.json()) as { tutorPlan: { audience: number } };
    // Audience 0 : il a été retiré, pas juste ignoré à l'envoi.
    expect(body.tutorPlan.audience).toBe(0);
    expect(mockSend).toHaveBeenCalledTimes(1);
    const payload = JSON.parse(mockSend.mock.calls[0][1] as string) as { tag: string };
    expect(payload.tag).toBe("streak-at-risk");
  });

  it("groupe par nombre de révisions plutôt qu'un envoi par élève", async () => {
    withProfiles([], [{ id: "s1", endpoint: "https://push/1", p256dh: "k", auth: "a" }]);
    mockRpc.mockResolvedValue({
      data: [
        { user_id: "a", due_count: 1 },
        { user_id: "b", due_count: 1 },
        { user_id: "c", due_count: 2 },
      ],
      error: null,
    });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), WEDNESDAY);

    // Deux payloads distincts (« une seule révision » / « 2 révisions »), pas trois.
    const bodies = mockSend.mock.calls.map(
      (c) => (JSON.parse(c[1] as string) as { body: string }).body,
    );
    expect(new Set(bodies).size).toBe(2);
  });

  it("une audience illisible fait échouer le cron plutôt que de mentir", async () => {
    withProfiles([], []);
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect(res.status).toBe(500);
  });
});

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
vi.mock("@/shared/integrations/supabase/client.server", () => ({
  supabaseAdmin: { from: mockFrom },
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
    expect(await res.json()).toEqual({ audience: 0, sent: 0, pruned: 0, parentDigest: null });
    expect(mockSend).not.toHaveBeenCalled();
  });

  it("sends to at-risk users and prunes dead endpoints (410)", async () => {
    const deleteEq = vi.fn().mockResolvedValue({ error: null });
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
          delete: () => ({ eq: deleteEq }),
        };
      throw new Error(`unexpected table ${table}`);
    });
    mockSend.mockResolvedValueOnce(undefined); // s1 delivered
    mockSend.mockRejectedValueOnce(new WebPushError("gone", 410)); // s2 dead

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ audience: 1, sent: 1, pruned: 1, parentDigest: null });
    expect(mockSetVapid).toHaveBeenCalledWith("mailto:a@b.c", "pub", "priv");
    expect(deleteEq).toHaveBeenCalledWith("id", "s2");
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
      parentDigest: { audience: 0, sent: 0, pruned: 0 },
    });
    expect(mockSend).not.toHaveBeenCalled();
  });
});

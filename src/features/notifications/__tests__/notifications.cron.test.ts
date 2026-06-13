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

  it("returns audience 0 when nobody is at risk", async () => {
    mockFrom.mockImplementation((table: string) => {
      if (table === "profiles")
        return { select: () => ({ gt: () => Promise.resolve({ data: [], error: null }) }) };
      throw new Error(`unexpected table ${table}`);
    });
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"));
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ audience: 0, sent: 0, pruned: 0 });
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
    const res = await handle(cronRequest("Bearer secret"));

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ audience: 1, sent: 1, pruned: 1 });
    expect(mockSetVapid).toHaveBeenCalledWith("mailto:a@b.c", "pub", "priv");
    expect(deleteEq).toHaveBeenCalledWith("id", "s2");
  });
});

// @vitest-environment node
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
/**
 * é31 lot 4 — les SIX audiences d'élève tiennent en UNE lecture
 * (`push_daily_audiences`), et le pipeline de priorité n'en garde qu'un candidat
 * par élève. Avant ce lot, chaque audience avait sa requête et son exclusion
 * croisée écrite à la main ; ce mock reflète la nouvelle forme.
 */
type AudienceRow = {
  user_id: string;
  tag: string;
  locale: string | null;
  arg: number | null;
  detail: string | null;
};
type AudienceReply = { data: AudienceRow[] | null; error: { message: string } | null };
const mockRpc = vi.fn(async (): Promise<AudienceReply> => ({ data: [], error: null }));
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

const SUB = (i: number) => ({
  id: `s${i}`,
  endpoint: `https://push/${i}`,
  p256dh: `k${i}`,
  auth: `a${i}`,
});

async function loadHandler() {
  return (await import("../notifications.cron.server")).handlePushCron;
}

/** Décor minimal : les abonnements servis à toute audience, et rien d'autre. */
function withSubscriptions(subs: unknown[], deleteIn = vi.fn().mockResolvedValue({ error: null })) {
  mockFrom.mockImplementation((table: string) => {
    if (table === "push_subscriptions")
      return {
        select: () => ({ in: () => Promise.resolve({ data: subs, error: null }) }),
        delete: () => ({ in: deleteIn }),
      };
    throw new Error(`unexpected table ${table}`);
  });
  return deleteIn;
}

function audience(rows: Partial<AudienceRow>[]) {
  mockRpc.mockResolvedValue({
    data: rows.map((r) => ({
      user_id: "u1",
      tag: "streak-at-risk",
      locale: "fr",
      arg: 3,
      detail: null,
      ...r,
    })),
    error: null,
  });
}

function payloads(): { tag: string; body: string; title: string; url: string }[] {
  return mockSend.mock.calls.map(
    (c) => JSON.parse(c[1] as string) as { tag: string; body: string; title: string; url: string },
  );
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

  it("interroge l'audience avec le JOUR de Tunis, pas celui du serveur", async () => {
    withSubscriptions([]);
    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect(mockRpc).toHaveBeenCalledWith("push_daily_audiences", { p_today: "2026-07-01" });
  });

  it("returns audience 0 when nobody is due (no digest outside Sunday)", async () => {
    withSubscriptions([]);
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 0,
      sent: 0,
      pruned: 0,
      byTag: {},
      parentDigest: null,
    });
    expect(mockSend).not.toHaveBeenCalled();
  });

  it("sends to the resolved audience and prunes dead endpoints (410)", async () => {
    const deleteIn = withSubscriptions([SUB(1), SUB(2)]);
    audience([{ user_id: "u1", tag: "streak-at-risk", arg: 3 }]);
    mockSend.mockResolvedValueOnce(undefined); // s1 delivered
    mockSend.mockRejectedValueOnce(new WebPushError("gone", 410)); // s2 dead

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      audience: 1,
      sent: 1,
      pruned: 1,
      byTag: { "streak-at-risk": 1 },
      parentDigest: null,
    });
    expect(mockSetVapid).toHaveBeenCalledWith("mailto:a@b.c", "pub", "priv");
    expect(deleteIn).toHaveBeenCalledWith("id", ["s2"]);
  });

  it("prunes a burst of dead endpoints in ONE delete round-trip, not one per subscriber", async () => {
    const subs = Array.from({ length: 5 }, (_, i) => SUB(i));
    const deleteIn = withSubscriptions(subs);
    audience([{ user_id: "u1" }]);
    mockSend.mockRejectedValue(new WebPushError("gone", 410));

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(res.status).toBe(200);
    expect((await res.json()).pruned).toBe(5);
    expect(deleteIn).toHaveBeenCalledTimes(1);
    expect(deleteIn).toHaveBeenCalledWith("id", ["s0", "s1", "s2", "s3", "s4"]);
  });

  it("keeps the cron green — and does not over-report — when pruning fails", async () => {
    withSubscriptions([SUB(1)], vi.fn().mockResolvedValue({ error: { message: "boom" } }));
    audience([{ user_id: "u1" }]);
    mockSend.mockRejectedValueOnce(new WebPushError("gone", 410));

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    // The notification work already happened; a failed cleanup must not 500.
    expect(res.status).toBe(200);
    expect(await res.json()).toMatchObject({ audience: 1, sent: 0, pruned: 0 });
  });

  it("une audience illisible fait échouer le cron plutôt que de mentir", async () => {
    withSubscriptions([]);
    mockRpc.mockResolvedValue({ data: null, error: { message: "boom" } });
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect(res.status).toBe(500);
  });
});

/**
 * ⭐ LA PROMESSE QUI DÉCIDE SI L'OPT-IN SURVIT (R-4) : au plus UN push par élève
 * et par jour. Avant é31, elle tenait par une exclusion croisée entre DEUX
 * audiences ; il y en a six désormais, et la règle est devenue structurelle.
 */
describe("é31 lot 4 — un seul push par élève et par soir", () => {
  it("⭐ un élève éligible à trois audiences ne reçoit qu'UNE notification", async () => {
    withSubscriptions([SUB(1)]);
    audience([
      { user_id: "u1", tag: "comeback", arg: null },
      { user_id: "u1", tag: "tutor-daily-plan", arg: 2 },
      { user_id: "u1", tag: "league-result", arg: 30 },
    ]);
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(mockSend).toHaveBeenCalledTimes(1);
    // Et c'est le plus prioritaire qui part : une nouvelle avant un service,
    // un service avant une relance.
    expect(payloads()[0].tag).toBe("league-result");
    expect((await res.json()).byTag).toEqual({ "league-result": 1 });
  });

  it("⭐ l'élève qui a PERDU sa série est enfin recontacté — le trou du canal d'avant", async () => {
    withSubscriptions([SUB(1)]);
    audience([{ user_id: "u1", tag: "streak-lost", arg: 12 }]);
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), WEDNESDAY);

    const p = payloads()[0];
    expect(p.tag).toBe("streak-lost");
    expect(p.body).toContain("12");
  });

  it("⭐ chacun reçoit dans SA langue (R-17)", async () => {
    withSubscriptions([SUB(1)]);
    audience([
      { user_id: "u1", tag: "comeback", locale: "ar", arg: null },
      { user_id: "u2", tag: "comeback", locale: "en", arg: null },
    ]);
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), WEDNESDAY);

    const titles = payloads().map((p) => p.title);
    expect(titles).toHaveLength(2);
    expect(new Set(titles).size).toBe(2);
  });

  it("groupe par (tag, langue, nombre) plutôt qu'un envoi par élève", async () => {
    withSubscriptions([SUB(1)]);
    audience([
      { user_id: "a", tag: "tutor-daily-plan", arg: 1 },
      { user_id: "b", tag: "tutor-daily-plan", arg: 1 },
      { user_id: "c", tag: "tutor-daily-plan", arg: 2 },
    ]);
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), WEDNESDAY);

    // Deux payloads distincts (« une seule révision » / « 2 révisions »), pas trois.
    expect(new Set(payloads().map((p) => p.body)).size).toBe(2);
  });
});

describe("le bilan famille du dimanche", () => {
  function withParents(links: unknown[], profiles: unknown[]) {
    mockFrom.mockImplementation((table: string) => {
      if (table === "parent_student_links")
        return { select: () => ({ eq: () => Promise.resolve({ data: links, error: null }) }) };
      if (table === "profiles")
        return { select: () => ({ in: () => Promise.resolve({ data: profiles, error: null }) }) };
      if (table === "push_subscriptions")
        return {
          select: () => ({ in: () => Promise.resolve({ data: [SUB(1)], error: null }) }),
          delete: () => ({ in: vi.fn().mockResolvedValue({ error: null }) }),
        };
      throw new Error(`unexpected table ${table}`);
    });
  }

  it("on Sunday, sends the digest ONCE per parent, in their language", async () => {
    withParents(
      // p1 a deux enfants liés → il doit recevoir UN push, pas deux.
      [{ parent_user_id: "p1" }, { parent_user_id: "p1" }, { parent_user_id: "p2" }],
      [
        { id: "p1", locale: "ar" },
        { id: "p2", locale: "fr" },
      ],
    );
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(res.status).toBe(200);
    const body = (await res.json()) as { parentDigest: { audience: number } };
    expect(body.parentDigest.audience).toBe(2);
    const sent = payloads();
    expect(sent.every((p) => p.tag === "weekly-family-report")).toBe(true);
    expect(sent.every((p) => p.url === "/parent-report")).toBe(true);
    // Deux langues ⇒ deux textes, un envoi par langue.
    expect(new Set(sent.map((p) => p.title)).size).toBe(2);
  });

  it("on Sunday with no active links, the digest reports an empty audience", async () => {
    withParents([], []);
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);
    expect(res.status).toBe(200);
    expect((await res.json()).parentDigest).toEqual({ audience: 0, sent: 0, pruned: 0 });
    expect(mockSend).not.toHaveBeenCalled();
  });

  it("le mercredi, aucun bilan famille n'est envoyé", async () => {
    withSubscriptions([]);
    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), WEDNESDAY);
    expect((await res.json()).parentDigest).toBeNull();
  });
});

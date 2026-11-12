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

/**
 * Étude 08 lot 2 (US-7, R-7) — le digest ENRICHI, opt-in.
 *
 * Le décor : p1 a demandé le résumé, p2 non. Les assertions du bloc précédent ne
 * bougent pas — leur décor ne connaît pas `parent_digest_prefs`, et c'est déjà
 * un test : une table de préférences illisible rend le générique à tout le monde.
 */
describe("le digest enrichi du dimanche (étude 08 lot 2)", () => {
  type Summary = unknown;
  const AMINE = {
    displayName: "Amine",
    learningMinutes: 80,
    missions: 12,
    activeDays: 5,
    streak: 4,
    weakChapter: "Les fractions",
  };

  function decor(opts: {
    parents: { id: string; locale: string }[];
    optIns: string[];
    summaries?: Record<string, Summary>;
    summaryError?: boolean;
    prefsError?: boolean;
  }) {
    const stamp = vi.fn().mockResolvedValue({ error: null });
    const sentTo: string[][] = [];
    mockFrom.mockImplementation((table: string) => {
      if (table === "parent_student_links")
        return {
          select: () => ({
            eq: () =>
              Promise.resolve({
                data: opts.parents.map((p) => ({ parent_user_id: p.id })),
                error: null,
              }),
          }),
        };
      if (table === "profiles")
        return {
          select: () => ({ in: () => Promise.resolve({ data: opts.parents, error: null }) }),
        };
      if (table === "parent_digest_prefs")
        return {
          select: () => ({
            eq: () =>
              Promise.resolve(
                opts.prefsError
                  ? { data: null, error: { message: "boom" } }
                  : { data: opts.optIns.map((id) => ({ parent_user_id: id })), error: null },
              ),
          }),
          update: (patch: unknown) => ({
            in: (_col: string, ids: string[]) => ({ is: () => stamp(patch, ids) }),
          }),
        };
      if (table === "push_subscriptions")
        return {
          select: () => ({
            in: (_col: string, ids: string[]) => {
              sentTo.push(ids);
              return Promise.resolve({
                data: ids.map((id, i) => ({ ...SUB(i), endpoint: `https://push/${id}` })),
                error: null,
              });
            },
          }),
          delete: () => ({ in: vi.fn().mockResolvedValue({ error: null }) }),
        };
      throw new Error(`unexpected table ${table}`);
    });
    mockRpc.mockImplementation((async (fn: string, args: { p_parent?: string }) => {
      if (fn !== "get_parent_digest_summary") return { data: [], error: null };
      if (opts.summaryError) return { data: null, error: { message: "rpc down" } };
      return { data: opts.summaries?.[args.p_parent ?? ""] ?? [], error: null };
    }) as unknown as typeof mockRpc);
    return { stamp, sentTo };
  }

  /** Le payload reçu par l'abonnement d'un parent donné. */
  function payloadOf(parentId: string) {
    const call = mockSend.mock.calls.find(
      (c) => (c[0] as { endpoint: string }).endpoint === `https://push/${parentId}`,
    );
    return call
      ? (JSON.parse(call[1] as string) as { title: string; body: string; url: string; tag: string })
      : null;
  }

  const TWO = [
    { id: "p1", locale: "fr" },
    { id: "p2", locale: "fr" },
  ];

  it("⭐ l'opt-in est respecté : le résumé pour qui l'a demandé, le générique pour les autres", async () => {
    decor({ parents: TWO, optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);
    const body = (await res.json()) as {
      parentDigest: { audience: number; sent: number };
      parentDigestKinds: { optedIn: number; enriched: number; fallback: number };
    };

    expect(body.parentDigest).toMatchObject({ audience: 2, sent: 2 });
    expect(body.parentDigestKinds).toEqual({ optedIn: 1, enriched: 1, fallback: 0 });
    expect(payloadOf("p1")?.title).toBe("📋 La semaine de Amine");
    expect(payloadOf("p2")?.title).toBe("📋 Le bilan famille de la semaine est prêt");
    // Jamais les deux : un seul push par parent.
    expect(mockSend).toHaveBeenCalledTimes(2);
  });

  it("⭐ le message porte les chiffres de la semaine, et rien dans l'URL", async () => {
    decor({ parents: [TWO[0]], optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), SUNDAY);

    const sent = payloadOf("p1");
    expect(sent?.body).toBe(
      "1 h 20 · 12 missions · série de 4 jours. À revoir ensemble : Les fractions.",
    );
    expect(sent?.url).toBe("/parent-report");
    expect(sent?.tag).toBe("weekly-family-report");
  });

  it("le résumé part dans la langue du parent", async () => {
    decor({ parents: [{ id: "p1", locale: "ar" }], optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(payloadOf("p1")?.title).toBe("📋 أسبوع Amine");
    expect(payloadOf("p1")?.body).toContain("للمراجعة معا: Les fractions.");
  });

  it("le résumé est demandé pour le parent opt-in, et pour lui seul", async () => {
    decor({ parents: TWO, optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), SUNDAY);

    const summaryCalls = mockRpc.mock.calls.filter(
      (c) => (c as unknown[])[0] === "get_parent_digest_summary",
    );
    expect(summaryCalls).toEqual([["get_parent_digest_summary", { p_parent: "p1" }]]);
  });

  it("un opt-in dont le lien a disparu ne reçoit rien et ne coûte aucune lecture", async () => {
    decor({ parents: [TWO[1]], optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect((await res.json()).parentDigestKinds).toEqual({ optedIn: 0, enriched: 0, fallback: 0 });
    expect(payloadOf("p1")).toBeNull();
  });

  it("⭐ repli sur le générique quand le résumé est en panne — le dimanche reste servi", async () => {
    decor({ parents: TWO, optIns: ["p1"], summaryError: true });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);
    const body = (await res.json()) as {
      parentDigest: { sent: number };
      parentDigestKinds: { enriched: number; fallback: number };
    };

    expect(res.status).toBe(200);
    expect(body.parentDigest.sent).toBe(2);
    expect(body.parentDigestKinds).toMatchObject({ enriched: 0, fallback: 1 });
    expect(payloadOf("p1")?.title).toBe("📋 Le bilan famille de la semaine est prêt");
  });

  it("repli sur le générique quand le résumé a une forme inattendue ou est vide", async () => {
    decor({
      parents: TWO,
      optIns: ["p1", "p2"],
      summaries: { p1: { nope: true }, p2: [] },
    });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect((await res.json()).parentDigestKinds).toEqual({ optedIn: 2, enriched: 0, fallback: 2 });
    expect(payloadOf("p1")?.title).toBe("📋 Le bilan famille de la semaine est prêt");
    expect(payloadOf("p2")?.title).toBe("📋 Le bilan famille de la semaine est prêt");
  });

  it("repli sur le générique pour TOUS quand les préférences sont illisibles", async () => {
    decor({ parents: TWO, optIns: ["p1"], prefsError: true, summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(res.status).toBe(200);
    expect((await res.json()).parentDigest.sent).toBe(2);
    expect(payloadOf("p1")?.title).toBe("📋 Le bilan famille de la semaine est prêt");
  });

  it("un enfant sans activité : un constat et une invitation, jamais un reproche", async () => {
    decor({
      parents: [TWO[0]],
      optIns: ["p1"],
      summaries: {
        p1: [{ ...AMINE, learningMinutes: 0, missions: 0, streak: 0, weakChapter: null }],
      },
    });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(payloadOf("p1")?.body).toBe(
      "Pas d'activité mesurée cette semaine. Dix minutes ensemble suffisent pour repartir.",
    );
  });

  it("la mesure : le premier envoi enrichi RÉEL est daté, pour ce parent seulement", async () => {
    const { stamp } = decor({ parents: TWO, optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockResolvedValue(undefined);

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(stamp).toHaveBeenCalledTimes(1);
    expect(stamp).toHaveBeenCalledWith({ first_enriched_sent_at: SUNDAY.toISOString() }, ["p1"]);
  });

  it("la mesure ne date rien quand le push n'est pas parti", async () => {
    const { stamp } = decor({ parents: [TWO[0]], optIns: ["p1"], summaries: { p1: [AMINE] } });
    mockSend.mockRejectedValue(new Error("network"));

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(res.status).toBe(200);
    expect(stamp).not.toHaveBeenCalled();
  });

  it("VAPID absent : 500, et aucune donnée d'élève n'est lue", async () => {
    decor({ parents: TWO, optIns: ["p1"], summaries: { p1: [AMINE] } });
    delete process.env.VAPID_PRIVATE_KEY;

    const handle = await loadHandler();
    const res = await handle(cronRequest("Bearer secret"), SUNDAY);

    expect(res.status).toBe(500);
    expect(mockRpc).not.toHaveBeenCalled();
    expect(mockFrom).not.toHaveBeenCalled();
    expect(mockSend).not.toHaveBeenCalled();
  });

  it("le mercredi, aucune préférence ni aucun résumé n'est lu", async () => {
    decor({ parents: TWO, optIns: ["p1"], summaries: { p1: [AMINE] } });

    const handle = await loadHandler();
    await handle(cronRequest("Bearer secret"), WEDNESDAY);

    expect(mockFrom).not.toHaveBeenCalledWith("parent_digest_prefs");
    expect(
      mockRpc.mock.calls.some((c) => (c as unknown[])[0] === "get_parent_digest_summary"),
    ).toBe(false);
  });
});

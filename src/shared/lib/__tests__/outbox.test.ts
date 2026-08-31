// jsdom (défaut) : le module s'appuie sur `localStorage` et sur les événements
// de `window`/`document`, qui sont tout le sujet.
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockEnsureFresh } = vi.hoisted(() => ({ mockEnsureFresh: vi.fn() }));
vi.mock("@/shared/integrations/supabase/session-freshness", () => ({
  ensureFreshSession: mockEnsureFresh,
}));

import {
  clearOutboxForTests,
  enqueue,
  flush,
  pending,
  pendingCount,
  registerSender,
  startOutbox,
  subscribe,
} from "@/shared/lib/outbox";

const KIND = "quest.submit";

beforeEach(() => {
  clearOutboxForTests();
  vi.clearAllMocks();
  mockEnsureFresh.mockResolvedValue("renewed-token");
});

afterEach(() => {
  clearOutboxForTests();
  // ⚠️ `clearAllMocks` remet les compteurs à zéro mais NE RESTAURE PAS les
  // espions : sans ceci, le `navigator.onLine = false` du test hors-ligne
  // survivait à son test et faisait sortir tous les flushs suivants par la
  // branche « hors ligne » — huit échecs pour une seule cause.
  vi.restoreAllMocks();
  vi.useRealTimers();
});

/** Le refus exact que produit `requireSupabaseAuth` — le seul que l'on rejoue. */
function rejectedToken() {
  return new Error("Unauthorized: Invalid token");
}

describe("enqueue", () => {
  it("persists the work before anything touches the network", () => {
    enqueue({ clientId: "c1", kind: KIND, payload: { answers: ["a"] } });

    // Aucun expéditeur n'est enregistré : rien n'a pu partir. Le travail est
    // pourtant déjà à l'abri — c'est toute la raison d'être du module.
    expect(pendingCount()).toBe(1);
    expect(pending()[0].payload).toEqual({ answers: ["a"] });
  });

  it("survives a reload: the queue is read back from localStorage", async () => {
    enqueue({ clientId: "c1", kind: KIND, payload: { answers: ["a"] } });

    // Un rechargement, c'est un module neuf devant le même stockage.
    vi.resetModules();
    const reloaded = await import("@/shared/lib/outbox");

    expect(reloaded.pendingCount()).toBe(1);
  });

  it("replaces an item with the same clientId instead of duplicating it", () => {
    enqueue({ clientId: "c1", kind: KIND, payload: { answers: ["a"] } });
    enqueue({ clientId: "c1", kind: KIND, payload: { answers: ["a", "b"] } });

    expect(pendingCount()).toBe(1);
    expect(pending()[0].payload).toEqual({ answers: ["a", "b"] });
  });

  it("keeps the original age across replacements", () => {
    // Sinon un autosave qui retape toutes les 20 s rajeunirait l'item sans fin,
    // et la péremption ne tomberait jamais.
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-08-30T10:00:00Z"));
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });
    const first = pending()[0].createdAt;

    vi.setSystemTime(new Date("2026-08-30T10:05:00Z"));
    enqueue({ clientId: "c1", kind: KIND, payload: 2 });

    expect(pending()[0].createdAt).toBe(first);
  });

  it("notifies subscribers", () => {
    const listener = vi.fn();
    subscribe(listener);

    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    expect(listener).toHaveBeenCalled();
  });
});

describe("flush", () => {
  it("sends a pending item and clears it", async () => {
    const send = vi.fn().mockResolvedValue({ ok: true });
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: { answers: ["a"] } });

    await expect(flush()).resolves.toEqual({ sent: 1, dropped: 0, kept: 0 });
    expect(send).toHaveBeenCalledWith({ answers: ["a"] });
    expect(pendingCount()).toBe(0);
  });

  it("keeps an item whose sender is not registered yet", async () => {
    enqueue({ clientId: "c1", kind: "unknown", payload: 1 });

    await expect(flush()).resolves.toEqual({ sent: 0, dropped: 0, kept: 1 });
    expect(pendingCount()).toBe(1);
  });

  it("sends nothing while offline, and keeps everything", async () => {
    const send = vi.fn();
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });
    vi.spyOn(navigator, "onLine", "get").mockReturnValue(false);

    await expect(flush()).resolves.toEqual({ sent: 0, dropped: 0, kept: 1 });
    expect(send).not.toHaveBeenCalled();
    expect(pendingCount()).toBe(1);
  });

  // --- CONCURRENCE ----------------------------------------------------------
  // L'intervalle et le retour de focus tombent volontiers ensemble ; deux passes
  // simultanées enverraient le même item deux fois.

  it("joins an in-flight pass instead of opening a second one", async () => {
    let release: (value: unknown) => void = () => {};
    const send = vi.fn().mockReturnValue(
      new Promise((resolve) => {
        release = resolve;
      }),
    );
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    const first = flush();
    const second = flush();
    release({ ok: true });
    const [a, b] = await Promise.all([first, second]);

    expect(send).toHaveBeenCalledTimes(1);
    expect(a).toEqual(b);
  });

  // --- LE JETON REFUSÉ ------------------------------------------------------

  it("forces a refresh and retries EXACTLY once on a rejected token", async () => {
    const send = vi.fn().mockRejectedValueOnce(rejectedToken()).mockResolvedValueOnce({ ok: true });
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    await expect(flush()).resolves.toEqual({ sent: 1, dropped: 0, kept: 0 });
    expect(mockEnsureFresh).toHaveBeenCalledWith(true);
    expect(send).toHaveBeenCalledTimes(2);
    expect(pendingCount()).toBe(0);
  });

  it("does not loop when the replay is refused too — the item waits", async () => {
    // Insister masquerait une session réellement morte. L'item reste en file
    // pour un prochain flush, quand l'élève se sera reconnecté.
    const send = vi.fn().mockRejectedValue(rejectedToken());
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    await expect(flush()).resolves.toEqual({ sent: 0, dropped: 0, kept: 1 });
    expect(send).toHaveBeenCalledTimes(2);
    expect(pendingCount()).toBe(1);
  });

  it("never forces a refresh for an error that is not a token refusal", async () => {
    const send = vi.fn().mockRejectedValue(new Error("network down"));
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    await flush();

    expect(mockEnsureFresh).not.toHaveBeenCalled();
    expect(send).toHaveBeenCalledTimes(1);
  });

  // --- CLASSEMENT DES ÉCHECS ------------------------------------------------

  it("keeps a transient failure and counts the attempt", async () => {
    const send = vi.fn().mockRejectedValue(new Error("Failed to fetch"));
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    await expect(flush()).resolves.toEqual({ sent: 0, dropped: 0, kept: 1 });
    expect(pending()[0].attempts).toBe(1);
  });

  it("drops a terminal refusal — the work is already recorded server-side", async () => {
    const send = vi.fn().mockRejectedValue(new Error("This quest session is already completed."));
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    await expect(flush()).resolves.toEqual({ sent: 0, dropped: 1, kept: 0 });
    expect(pendingCount()).toBe(0);
  });

  it("gives up after enough failed attempts rather than retrying forever", async () => {
    const send = vi.fn().mockRejectedValue(new Error("Failed to fetch"));
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    for (let i = 0; i < 8; i += 1) await flush();

    expect(pendingCount()).toBe(0);
  });
});

describe("startOutbox", () => {
  // ⚠️ Le démontage passe par `afterEach` et pas par la fin du test : un test qui
  // échoue en cours de route ne l'atteindrait jamais, et ses écouteurs
  // survivraient au test SUIVANT — qui verrait alors des envois qu'il n'a pas
  // déclenchés. C'est exactement comme ça que le second test d'ici a d'abord
  // échoué, pour une faute commise dans le premier.
  let stop: (() => void) | null = null;
  afterEach(() => {
    stop?.();
    stop = null;
  });

  it("flushes on mount, on focus return, and on reconnection", async () => {
    const send = vi.fn().mockResolvedValue({ ok: true });
    registerSender(KIND, send);
    enqueue({ clientId: "c1", kind: KIND, payload: 1 });

    stop = startOutbox();
    // `flush()` REJOINT la passe déclenchée par le montage : l'attendre, c'est
    // attendre celle-là. Sans quoi le déclencheur suivant se contenterait de la
    // rejoindre elle aussi, et n'enverrait rien de neuf — la garde de
    // concurrence faisant précisément son travail.
    await flush();
    expect(send).toHaveBeenCalledTimes(1);

    enqueue({ clientId: "c2", kind: KIND, payload: 2 });
    window.dispatchEvent(new Event("online"));
    await flush();
    expect(send).toHaveBeenCalledTimes(2);

    enqueue({ clientId: "c3", kind: KIND, payload: 3 });
    vi.spyOn(document, "visibilityState", "get").mockReturnValue("visible");
    document.dispatchEvent(new Event("visibilitychange"));
    await flush();
    expect(send).toHaveBeenCalledTimes(3);
  });

  it("stops listening once torn down", async () => {
    const send = vi.fn().mockResolvedValue({ ok: true });
    registerSender(KIND, send);

    stop = startOutbox();
    await flush();
    stop();
    stop = null;

    enqueue({ clientId: "c1", kind: KIND, payload: 1 });
    window.dispatchEvent(new Event("online"));
    // Un tour de boucle d'événements : si un écouteur avait survécu, il aurait
    // eu tout le loisir d'envoyer.
    await new Promise((resolve) => setTimeout(resolve, 0));

    expect(send).not.toHaveBeenCalled();
  });
});

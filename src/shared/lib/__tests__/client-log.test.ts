// jsdom (défaut) : `navigator.sendBeacon`, `document.visibilityState` et les
// événements de visibilité sont tout le sujet.
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockLastKnownExpiry } = vi.hoisted(() => ({ mockLastKnownExpiry: vi.fn() }));
vi.mock("@/shared/integrations/supabase/session-freshness", async (importOriginal) => {
  // `secondsUntilExpiry` est une fonction pure : on garde la vraie, c'est elle
  // qu'on veut voir à l'œuvre. Seule la source de l'expiration est simulée.
  const actual =
    await importOriginal<typeof import("@/shared/integrations/supabase/session-freshness")>();
  return { ...actual, lastKnownExpiry: mockLastKnownExpiry };
});

import {
  hiddenTime,
  initHiddenTimeTracking,
  reportClientError,
  resetHiddenTimeForTests,
} from "@/shared/lib/client-log";

/** Le corps réellement envoyé, quel que soit le canal utilisé. */
function sentBody(beacon: ReturnType<typeof vi.fn>): Record<string, unknown> {
  const blob = beacon.mock.calls[0][1] as { text?: () => Promise<string> };
  // jsdom rend un vrai Blob ; on relit son contenu via le constructeur simulé.
  return JSON.parse((blob as unknown as { __text: string }).__text) as Record<string, unknown>;
}

let beacon: ReturnType<typeof vi.fn>;
let stopTracking: (() => void) | null = null;

beforeEach(() => {
  vi.clearAllMocks();
  resetHiddenTimeForTests();
  mockLastKnownExpiry.mockReturnValue(Math.floor(Date.now() / 1000) + 1800);

  // Un Blob qui retient son texte : jsdom ne sait pas le relire de façon
  // synchrone, et c'est le CONTENU qui nous intéresse.
  vi.stubGlobal(
    "Blob",
    class {
      __text: string;
      type: string;
      constructor(parts: string[], options?: { type?: string }) {
        this.__text = parts.join("");
        this.type = options?.type ?? "";
      }
    },
  );

  beacon = vi.fn().mockReturnValue(true);
  vi.stubGlobal("navigator", { ...navigator, sendBeacon: beacon });
});

afterEach(() => {
  stopTracking?.();
  stopTracking = null;
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

describe("reportClientError", () => {
  it("part en sendBeacon — le seul canal qui survit à la fermeture de l'onglet", () => {
    reportClientError({ stage: "outbox-flush", errMessage: "Unauthorized: Invalid token" });

    expect(beacon).toHaveBeenCalledTimes(1);
    expect(beacon.mock.calls[0][0]).toBe("/api/client-log");
  });

  it("emporte le TTL restant du jeton — la mesure qui départage les hypothèses", () => {
    // 1800 s de reste : l'appareil se croyait LARGEMENT dans les temps, et le
    // serveur a pourtant refusé. C'est la signature de la dérive d'horloge.
    reportClientError({ stage: "token-attach", errMessage: "Unauthorized: Invalid token" });

    const body = sentBody(beacon);
    expect(body.ttlS).toBeGreaterThan(1790);
    expect(body.stage).toBe("token-attach");
    expect(body.errMessage).toBe("Unauthorized: Invalid token");
  });

  it("rend un TTL négatif quand le jeton était déjà expiré", () => {
    mockLastKnownExpiry.mockReturnValue(Math.floor(Date.now() / 1000) - 120);

    reportClientError({ stage: "outbox-flush" });

    expect(sentBody(beacon).ttlS).toBeLessThan(0);
  });

  it("retombe sur fetch keepalive quand sendBeacon refuse", () => {
    // `sendBeacon` rend `false` au-delà de son quota : le repli doit offrir la
    // même garantie de survie, d'où `keepalive`.
    beacon.mockReturnValue(false);
    const fetchSpy = vi.fn().mockResolvedValue(new Response(null, { status: 204 }));
    vi.stubGlobal("fetch", fetchSpy);

    reportClientError({ stage: "outbox-flush" });

    expect(fetchSpy).toHaveBeenCalledTimes(1);
    expect(fetchSpy.mock.calls[0][1]).toMatchObject({ method: "POST", keepalive: true });
  });

  it("retombe sur fetch quand sendBeacon n'existe pas", () => {
    vi.stubGlobal("navigator", {});
    const fetchSpy = vi.fn().mockResolvedValue(new Response(null, { status: 204 }));
    vi.stubGlobal("fetch", fetchSpy);

    reportClientError({ stage: "outbox-flush" });

    expect(fetchSpy).toHaveBeenCalledTimes(1);
  });

  it("ne lève jamais, quoi qu'il arrive au canal d'envoi", () => {
    // La télémétrie ne doit pas casser le chemin d'une panne.
    beacon.mockImplementation(() => {
      throw new Error("beacon exploded");
    });
    vi.stubGlobal("fetch", () => {
      throw new Error("fetch exploded");
    });

    expect(() => reportClientError({ stage: "outbox-flush" })).not.toThrow();
  });
});

describe("temps passé onglet caché", () => {
  it("commence à zéro", () => {
    expect(hiddenTime()).toEqual({ hiddenTotalMs: 0, lastHiddenMs: 0 });
  });

  it("compte une veille terminée, et la cumule", () => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-08-30T10:00:00Z"));
    stopTracking = initHiddenTimeTracking();
    const visibility = vi.spyOn(document, "visibilityState", "get");

    visibility.mockReturnValue("hidden");
    document.dispatchEvent(new Event("visibilitychange"));
    vi.setSystemTime(new Date("2026-08-30T10:06:00Z")); // 6 minutes
    visibility.mockReturnValue("visible");
    document.dispatchEvent(new Event("visibilitychange"));

    expect(hiddenTime()).toEqual({ hiddenTotalMs: 360_000, lastHiddenMs: 360_000 });
    vi.useRealTimers();
  });

  it("compte la veille EN COURS, sans attendre le retour", () => {
    // Sinon un envoi déclenché pendant que l'onglet dort rapporterait zéro —
    // pour le cas même qu'on cherche.
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-08-30T10:00:00Z"));
    stopTracking = initHiddenTimeTracking();
    vi.spyOn(document, "visibilityState", "get").mockReturnValue("hidden");

    document.dispatchEvent(new Event("visibilitychange"));
    vi.setSystemTime(new Date("2026-08-30T10:02:00Z"));

    expect(hiddenTime().lastHiddenMs).toBe(120_000);
    vi.useRealTimers();
  });

  it("cesse de compter une fois démonté", () => {
    const stop = initHiddenTimeTracking();
    stop();
    vi.spyOn(document, "visibilityState", "get").mockReturnValue("hidden");

    document.dispatchEvent(new Event("visibilitychange"));

    expect(hiddenTime().hiddenTotalMs).toBe(0);
  });
});

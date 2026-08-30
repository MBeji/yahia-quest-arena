// @vitest-environment node
import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetSession, mockRefreshSession } = vi.hoisted(() => ({
  mockGetSession: vi.fn(),
  mockRefreshSession: vi.fn(),
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: { auth: { getSession: mockGetSession, refreshSession: mockRefreshSession } },
}));

import {
  ensureFreshSession,
  resetSessionFreshnessForTests,
  secondsUntilExpiry,
  REFRESH_MARGIN_SECONDS,
} from "@/shared/integrations/supabase/session-freshness";

/** Un instant d'expiration à N secondes d'ici, au format d'auth-js (secondes UNIX). */
function expiresIn(seconds: number): number {
  return Math.floor(Date.now() / 1000) + seconds;
}

function session(token: string, ttlSeconds: number) {
  return { data: { session: { access_token: token, expires_at: expiresIn(ttlSeconds) } } };
}

beforeEach(() => {
  vi.clearAllMocks();
  resetSessionFreshnessForTests();
});

describe("secondsUntilExpiry", () => {
  it("treats a missing expiry as already expired", () => {
    // Le défaut sûr : 0 déclenche un rafraîchissement au lieu d'en sauter un.
    expect(secondsUntilExpiry(undefined)).toBe(0);
    expect(secondsUntilExpiry(Number.NaN)).toBe(0);
  });

  it("measures the remaining life of a token", () => {
    expect(secondsUntilExpiry(expiresIn(300))).toBeGreaterThan(295);
    expect(secondsUntilExpiry(expiresIn(-10))).toBeLessThan(0);
  });
});

describe("ensureFreshSession", () => {
  it("keeps a token that still has margin, without touching the network", async () => {
    mockGetSession.mockResolvedValue(session("fresh", REFRESH_MARGIN_SECONDS + 60));

    await expect(ensureFreshSession()).resolves.toBe("fresh");
    expect(mockRefreshSession).not.toHaveBeenCalled();
  });

  it("refreshes a token that is under the margin", async () => {
    mockGetSession.mockResolvedValue(session("stale", REFRESH_MARGIN_SECONDS - 10));
    mockRefreshSession.mockResolvedValue(session("renewed", 3600));

    await expect(ensureFreshSession()).resolves.toBe("renewed");
    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
  });

  it("refreshes regardless of the clock when forced", async () => {
    // Le cas du jeton REFUSÉ : l'horloge locale le croit bon, le serveur non.
    // Lui redemander son avis n'aurait aucun sens — d'où `force`.
    mockRefreshSession.mockResolvedValue(session("renewed", 3600));

    await expect(ensureFreshSession(true)).resolves.toBe("renewed");
    expect(mockGetSession).not.toHaveBeenCalled();
    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
  });

  it("returns null when there is no session at all", async () => {
    mockGetSession.mockResolvedValue({ data: { session: null } });

    await expect(ensureFreshSession()).resolves.toBeNull();
    expect(mockRefreshSession).not.toHaveBeenCalled();
  });

  it("keeps the current token when the refresh fails to produce one", async () => {
    mockGetSession.mockResolvedValue(session("old", 10));
    mockRefreshSession.mockResolvedValue({ data: { session: null } });

    // Le serveur tranchera, et `auth-attacher` rattrapera son refus : effacer un
    // jeton encore peut-être utilisable ne ferait qu'avancer la panne.
    await expect(ensureFreshSession()).resolves.toBe("old");
  });

  // --- LE MUTEX -------------------------------------------------------------
  // C'est la raison d'être du module : chaque `refreshSession()` fait TOURNER le
  // refresh token, donc N rafraîchissements concurrents produisent N-1 jetons
  // morts et un `Invalid Refresh Token: Already Used`.

  it("coalesces N concurrent callers into a SINGLE network refresh", async () => {
    mockGetSession.mockResolvedValue(session("stale", 5));
    let resolveRefresh: (value: unknown) => void = () => {};
    mockRefreshSession.mockReturnValue(
      new Promise((resolve) => {
        resolveRefresh = resolve;
      }),
    );

    const callers = Array.from({ length: 10 }, () => ensureFreshSession());
    // Laisse les dix atteindre le mutex avant de débloquer le réseau.
    await Promise.resolve();
    resolveRefresh(session("renewed", 3600));

    await expect(Promise.all(callers)).resolves.toEqual(Array(10).fill("renewed"));
    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
  });

  it("chains a forced call after an in-flight unforced one instead of joining it", async () => {
    // Rejoindre donnerait au demandeur FORCÉ le jeton que l'horloge locale juge
    // encore bon — précisément celui que le serveur vient de refuser.
    mockGetSession.mockResolvedValue(session("clock-says-fine", 3600));
    mockRefreshSession.mockResolvedValue(session("server-issued", 3600));

    const unforced = ensureFreshSession();
    const forced = ensureFreshSession(true);

    await expect(unforced).resolves.toBe("clock-says-fine");
    await expect(forced).resolves.toBe("server-issued");
    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
  });

  it("opens a new race once the previous one has settled", async () => {
    mockGetSession.mockResolvedValue(session("stale", 5));
    mockRefreshSession.mockResolvedValue(session("renewed", 3600));

    await ensureFreshSession();
    await ensureFreshSession();

    expect(mockRefreshSession).toHaveBeenCalledTimes(2);
  });
});

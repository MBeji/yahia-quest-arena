// @vitest-environment node
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetSession, mockRefreshSession } = vi.hoisted(() => ({
  mockGetSession: vi.fn(),
  mockRefreshSession: vi.fn(),
}));

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({
    client: (handler: unknown) => handler,
  }),
}));

vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      getSession: mockGetSession,
      refreshSession: mockRefreshSession,
    },
  },
}));

import {
  attachSupabaseAuth,
  resetRejectedTokenForTests,
} from "@/shared/integrations/supabase/auth-attacher";
import {
  isRejectedTokenError,
  shouldReplayRejectedToken,
} from "@/shared/integrations/supabase/auth-rejection";

// The mock above makes `.client(handler)` return the handler, so at runtime the
// middleware is directly callable. Cast to a callable for type-checking the tests.
const callMiddleware = attachSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

describe("attachSupabaseAuth", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
  });

  it("attaches Authorization header when session token exists", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: {
          access_token: "token-123",
        },
      },
    });

    const next = vi.fn().mockResolvedValue("ok");

    const result = await callMiddleware({ next } as never);

    expect(result).toBe("ok");
    expect(next).toHaveBeenCalledWith({
      headers: {
        Authorization: "Bearer token-123",
      },
    });
  });

  it("passes empty headers when no session token exists", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: null,
      },
    });

    const next = vi.fn().mockResolvedValue("ok");

    await callMiddleware({ next } as never);

    expect(next).toHaveBeenCalledWith({ headers: {} });
  });
});

// =============================================================================
// Le rafraîchissement raté (signalé en prod le 2026-08-18).
//
// `getSession()` rafraîchit déjà une session expirée : quand il rend malgré
// tout `session: null` AVEC une erreur, c'est que ce rafraîchissement a échoué.
// Le client se croit alors connecté — rien n'a effacé la session, donc aucune
// redirection vers la connexion — mais plus aucune server fn n'aboutit :
// « Failed to load dashboard », dont seule une déconnexion/reconnexion sortait.
// =============================================================================
describe("attachSupabaseAuth — rafraîchissement raté", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
  });

  it("retente une fois, et l'appel repart avec le jeton neuf", async () => {
    mockGetSession.mockResolvedValue({
      data: { session: null },
      error: { message: "refresh failed" },
    });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
    expect(next).toHaveBeenCalledWith({ headers: { Authorization: "Bearer token-neuf" } });
  });

  it("si la reprise échoue aussi, on n'invente pas d'en-tête", async () => {
    mockGetSession.mockResolvedValue({
      data: { session: null },
      error: { message: "refresh failed" },
    });
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: { message: "still failing" },
    });

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(next).toHaveBeenCalledWith({ headers: {} });
  });

  it("visiteur anonyme : aucune session, donc AUCUN appel de reprise", async () => {
    // La distinction tient à `error` : nul = personne n'est connecté, il n'y a
    // rien à retenter. Sans ce garde, chaque appel du registre public paierait
    // un `refreshSession()` de plus.
    mockGetSession.mockResolvedValue({ data: { session: null }, error: null });

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(mockRefreshSession).not.toHaveBeenCalled();
    expect(next).toHaveBeenCalledWith({ headers: {} });
  });
});

// =============================================================================
// LE JETON RENDU, PUIS REFUSÉ (signalé en prod : « Invalid token » en fin de quiz).
//
// Les trois cas ci-dessus supposent tous qu'un jeton RENDU est un bon jeton.
// C'est faux : `__loadSession` (auth-js) ne juge de la péremption que sur
// `expires_at` et l'horloge de L'APPAREIL, sans jamais vérifier la signature.
// Une horloge en retard de plus de 90 s (EXPIRY_MARGIN_MS) fait donc rendre un
// jeton réellement périmé — et le ticker d'`autoRefreshToken`, qui lit la même
// horloge, ne se déclenche pas davantage. L'élève est enfermé, et le reste :
// l'élève terminait son quiz et perdait ses réponses, qui ne vivent que dans
// l'état React.
// =============================================================================
describe("attachSupabaseAuth — jeton refusé par le serveur", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    resetRejectedTokenForTests();
  });

  it("laisse remonter l'échec — le middleware ne rejoue RIEN lui-même", async () => {
    // `executeMiddleware` consomme sa liste par `shift()` : un second `next()`
    // ne referait aucun appel HTTP et rendrait `undefined`. Ce test épingle le
    // fait qu'on n'essaie pas.
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    const next = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));

    await expect(callMiddleware({ next } as never)).rejects.toThrow("Unauthorized: Invalid token");
    expect(next).toHaveBeenCalledTimes(1);
  });

  it("après un refus, l'appel suivant FORCE un jeton neuf sans croire l'horloge", async () => {
    // `getSession()` rend obstinément le même jeton périmé — c'est tout le
    // problème. Seul `refreshSession()` fait émettre un jeton par le serveur.
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const rejeté = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));
    await expect(callMiddleware({ next: rejeté } as never)).rejects.toThrow();

    const rejoué = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next: rejoué } as never);

    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
    expect(rejoué).toHaveBeenCalledWith({ headers: { Authorization: "Bearer token-neuf" } });
  });

  it("le forçage ne vaut QUE pour l'appel suivant", async () => {
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "bon" } } });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const rejeté = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));
    await expect(callMiddleware({ next: rejeté } as never)).rejects.toThrow();

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never); // consomme le drapeau
    await callMiddleware({ next } as never); // ne doit plus rien forcer

    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
    expect(next).toHaveBeenLastCalledWith({ headers: { Authorization: "Bearer bon" } });
  });

  it("si le forçage échoue, on retombe sur le chemin normal", async () => {
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    mockRefreshSession.mockResolvedValue({ data: { session: null }, error: { message: "mort" } });

    const rejeté = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));
    await expect(callMiddleware({ next: rejeté } as never)).rejects.toThrow();

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(next).toHaveBeenCalledWith({ headers: { Authorization: "Bearer périmé" } });
  });

  it("un échec ORDINAIRE n'arme rien — sinon chaque panne réseau paierait un refresh", async () => {
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "bon" } } });

    const next = vi.fn().mockRejectedValue(new Error("Failed to load dashboard"));
    await expect(callMiddleware({ next } as never)).rejects.toThrow("Failed to load dashboard");

    const suivant = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next: suivant } as never);

    expect(mockRefreshSession).not.toHaveBeenCalled();
    expect(suivant).toHaveBeenCalledWith({ headers: { Authorization: "Bearer bon" } });
  });
});

describe("isRejectedTokenError", () => {
  it("ne reconnaît QUE le refus posé avant tout code métier", () => {
    // C'est ce prédicat qui autorise le rejeu d'une MUTATION : il doit donc
    // rester exact. `requireSupabaseAuth` est le seul à lever ce message —
    // `optionalSupabaseAuth`, lui, dégrade en anonyme sans jamais lever.
    expect(isRejectedTokenError(new Error("Unauthorized: Invalid token"))).toBe(true);
    expect(isRejectedTokenError(new Error("Unauthorized: No token provided"))).toBe(false);
    expect(
      isRejectedTokenError(new Error("Auth verification unavailable. Please try again.")),
    ).toBe(false);
    expect(isRejectedTokenError(new Error("submit_exercise_attempt failed"))).toBe(false);
    expect(isRejectedTokenError("Unauthorized: Invalid token")).toBe(false);
    expect(isRejectedTokenError(null)).toBe(false);
  });
});

describe("shouldReplayRejectedToken", () => {
  it("rejoue UNE fois un jeton refusé, et rien d'autre", () => {
    expect(shouldReplayRejectedToken(0, new Error("Unauthorized: Invalid token"))).toBe(true);
    // Le rejeu est parti avec un jeton neuf : s'il est refusé aussi, la session
    // est morte. Insister ne ferait que retarder l'écran qui le dit.
    expect(shouldReplayRejectedToken(1, new Error("Unauthorized: Invalid token"))).toBe(false);
    // Tout le reste : une mutation ne se rejoue pas, elle écrirait deux fois.
    expect(shouldReplayRejectedToken(0, new Error("submit_exercise_attempt failed"))).toBe(false);
  });
});

// =============================================================================
// LA BOUCLE COMPLÈTE, avec le vrai moteur de reprise de React Query : c'est la
// composition qui sauve le quiz, et aucun des deux morceaux ne le fait seul.
// =============================================================================
describe("la reprise sauve la mutation (bout en bout)", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    resetRejectedTokenForTests();
  });

  it("le second essai part avec le jeton neuf et la réponse est enregistrée", async () => {
    const { MutationObserver, QueryClient } = await import("@tanstack/react-query");

    // L'horloge de l'appareil est en retard : `getSession()` rend obstinément un
    // jeton que le serveur, lui, sait périmé.
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    // La server fn : refuse le jeton périmé, accepte le neuf.
    const serverFn = vi.fn(async (headers: Record<string, string>) => {
      if (headers.Authorization !== "Bearer token-neuf") {
        throw new Error("Unauthorized: Invalid token");
      }
      return "attempt-enregistrée";
    });

    const client = new QueryClient({
      defaultOptions: { mutations: { retry: shouldReplayRejectedToken, retryDelay: 0 } },
    });
    const observer = new MutationObserver(client, {
      mutationFn: () =>
        callMiddleware({
          next: (ctx: { headers: Record<string, string> }) => serverFn(ctx.headers),
        } as never),
    });

    await expect(observer.mutate()).resolves.toBe("attempt-enregistrée");
    expect(serverFn).toHaveBeenCalledTimes(2);
    expect(serverFn).toHaveBeenNthCalledWith(1, { Authorization: "Bearer périmé" });
    expect(serverFn).toHaveBeenNthCalledWith(2, { Authorization: "Bearer token-neuf" });
  });

  it("sans la politique de reprise, la même mutation est perdue", async () => {
    // Le témoin : c'est exactement ce que vivait l'élève avant ce correctif.
    const { MutationObserver, QueryClient } = await import("@tanstack/react-query");

    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const serverFn = vi.fn(async (headers: Record<string, string>) => {
      if (headers.Authorization !== "Bearer token-neuf") {
        throw new Error("Unauthorized: Invalid token");
      }
      return "attempt-enregistrée";
    });

    const client = new QueryClient();
    const observer = new MutationObserver(client, {
      mutationFn: () =>
        callMiddleware({
          next: (ctx: { headers: Record<string, string> }) => serverFn(ctx.headers),
        } as never),
    });

    await expect(observer.mutate()).rejects.toThrow("Unauthorized: Invalid token");
    expect(serverFn).toHaveBeenCalledTimes(1);
  });
});

// =============================================================================
// LE SERVICE AUTH QUI NE RÉPOND PAS.
//
// Poser le jeton est la première chose que fait tout appel de server fn : tant
// qu'elle n'a pas rendu, la mutation reste `isPending` — et dans le lecteur de
// mission, `isPending` GRISE « Valider ». Une lecture de session qui ne revient
// jamais ne donne donc pas une erreur, elle donne un bouton mort avec sa
// roulette, dont seul un rechargement sort. auth-js sérialise l'accès derrière
// `navigator.locks` et temporise ses rafraîchissements en échec : c'est
// précisément la situation d'un jeton refusé.
// =============================================================================
describe("attachSupabaseAuth — le service Auth ne répond pas", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    resetRejectedTokenForTests();
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("ne reste JAMAIS suspendu : l'appel part sans jeton et l'échec se voit", async () => {
    mockGetSession.mockReturnValue(new Promise(() => {})); // ne rend jamais

    const next = vi.fn().mockResolvedValue("ok");
    const pending = callMiddleware({ next } as never);

    await vi.advanceTimersByTimeAsync(8_000);
    await pending;

    expect(next).toHaveBeenCalledWith({ headers: {} });
  });

  it("le rafraîchissement FORCÉ est borné lui aussi", async () => {
    // Le chemin ajouté par ce correctif : après un refus, on force un
    // rafraîchissement. S'il pendait, on aurait remplacé une erreur visible par
    // un gel — soit exactement le bouton grisé qu'on cherche à éviter.
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    mockRefreshSession.mockReturnValue(new Promise(() => {}));

    const rejeté = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));
    await expect(callMiddleware({ next: rejeté } as never)).rejects.toThrow();

    const next = vi.fn().mockResolvedValue("ok");
    const pending = callMiddleware({ next } as never);
    await vi.advanceTimersByTimeAsync(8_000);
    await pending;

    // Le forçage a expiré : on retombe sur le chemin normal plutôt que d'attendre.
    expect(next).toHaveBeenCalledWith({ headers: { Authorization: "Bearer périmé" } });
  });

  it("une réponse simplement LENTE aboutit encore — ce n'est pas un budget de perf", async () => {
    let resolveSession: (v: unknown) => void = () => {};
    mockGetSession.mockReturnValue(
      new Promise((resolve) => {
        resolveSession = resolve;
      }),
    );

    const next = vi.fn().mockResolvedValue("ok");
    const pending = callMiddleware({ next } as never);

    await vi.advanceTimersByTimeAsync(5_000);
    resolveSession({ data: { session: { access_token: "lent-mais-bon" } } });
    await pending;

    expect(next).toHaveBeenCalledWith({ headers: { Authorization: "Bearer lent-mais-bon" } });
  });
});

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
  isSessionRefusalError,
  shouldReplaySessionRefusal,
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

describe("isSessionRefusalError", () => {
  it("reconnaît les DEUX refus posés avant tout code métier, et rien d'autre", () => {
    // C'est ce prédicat qui autorise le rejeu d'une MUTATION : il doit donc
    // rester exact. `requireSupabaseAuth` est le seul à lever ces messages —
    // `optionalSupabaseAuth`, lui, dégrade en anonyme sans jamais lever.
    // Le jeton POSÉ et refusé : la panne de fin de quiz (#914).
    expect(isSessionRefusalError(new Error("Unauthorized: Invalid token"))).toBe(true);
    // Le jeton ABSENT : la panne « Failed to load dashboard ». Le manquer est ce
    // qui laissait l'élève sur un écran d'erreur que rien ne guérissait — voir
    // le bloc de bout en bout plus bas.
    expect(isSessionRefusalError(new Error("Unauthorized: No authorization header provided"))).toBe(
      true,
    );

    // Ce qui reste dehors, et le contrôle négatif compte autant : aucun de ces
    // refus n'est guérissable par un jeton neuf.
    expect(isSessionRefusalError(new Error("Unauthorized: No token provided"))).toBe(false);
    expect(isSessionRefusalError(new Error("Unauthorized: Only Bearer tokens are supported"))).toBe(
      false,
    );
    expect(isSessionRefusalError(new Error("Unauthorized: No user ID found in token"))).toBe(false);
    expect(
      isSessionRefusalError(new Error("Auth verification unavailable. Please try again.")),
    ).toBe(false);
    expect(isSessionRefusalError(new Error("submit_exercise_attempt failed"))).toBe(false);
    expect(isSessionRefusalError("Unauthorized: Invalid token")).toBe(false);
    expect(isSessionRefusalError(null)).toBe(false);
  });
});

describe("shouldReplaySessionRefusal", () => {
  it("rejoue UNE fois un refus de session, et rien d'autre", () => {
    expect(shouldReplaySessionRefusal(0, new Error("Unauthorized: Invalid token"))).toBe(true);
    // Le jeton absent se rejoue au même titre : c'est le refus que #915 disait
    // déjà rattraper (« l'échec se voit, et la reprise rejoue l'appel ») sans
    // que la politique le reconnaisse — la phrase était fausse.
    expect(
      shouldReplaySessionRefusal(0, new Error("Unauthorized: No authorization header provided")),
    ).toBe(true);
    // Le rejeu est parti avec un jeton neuf : s'il est refusé aussi, la session
    // est morte. Insister ne ferait que retarder l'écran qui le dit.
    expect(shouldReplaySessionRefusal(1, new Error("Unauthorized: Invalid token"))).toBe(false);
    expect(
      shouldReplaySessionRefusal(1, new Error("Unauthorized: No authorization header provided")),
    ).toBe(false);
    // Tout le reste : une mutation ne se rejoue pas, elle écrirait deux fois.
    expect(shouldReplaySessionRefusal(0, new Error("submit_exercise_attempt failed"))).toBe(false);
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
      defaultOptions: { mutations: { retry: shouldReplaySessionRefusal, retryDelay: 0 } },
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

// =============================================================================
// « FAILED TO LOAD DASHBOARD » — LA BOUCLE DONT RIEN NE SORTAIT.
//
// La panne signalée le 2026-08-18, puis de nouveau APRÈS #914/#915 : l'élève
// arrive sur le Hall des Héros, l'écran affiche « Failed to load dashboard », et
// son bouton « Réessayer » rejoue exactement la même chose. Rien n'a émis
// `SIGNED_OUT`, donc le garde de `_authenticated` ne renvoie pas vers la
// connexion : seule une déconnexion/reconnexion manuelle en sortait.
//
// La cause n'était PAS le jeton refusé que #914 a traité, mais le jeton ABSENT :
// quand `resolveAccessToken` ne rend rien, l'appel part sans en-tête et le
// serveur lève « Unauthorized: No authorization header provided ». Ce message-là
// n'était dans aucun prédicat de reprise — donc le drapeau n'était jamais armé,
// donc l'essai suivant refaisait la lecture de session qui venait d'échouer, et
// les trois reprises par défaut d'une requête empruntaient toutes ce chemin mort.
// =============================================================================
describe("attachSupabaseAuth — l'appel est parti SANS jeton", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    resetRejectedTokenForTests();
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("arme le forçage — sinon l'essai suivant reprend le même chemin mort", async () => {
    // La lecture de session ne rend jamais : auth-js sérialise derrière
    // `navigator.locks` et temporise ses rafraîchissements en échec. C'est l'état
    // que #915 borne à 8 s — en partant SANS jeton, ce que le serveur refuse.
    mockGetSession.mockReturnValue(new Promise(() => {}));
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const refusé = vi
      .fn()
      .mockRejectedValue(new Error("Unauthorized: No authorization header provided"));
    // L'attente est posée AVANT d'avancer les minuteries : sans elle, le rejet
    // tomberait pendant l'avance, sans gestionnaire, et Vitest le compterait
    // comme une erreur non gérée du run.
    const premier = expect(callMiddleware({ next: refusé } as never)).rejects.toThrow(
      "Unauthorized: No authorization header provided",
    );
    await vi.advanceTimersByTimeAsync(8_000);
    await premier;
    expect(refusé).toHaveBeenCalledWith({ headers: {} });

    // L'essai suivant ne redemande PAS son avis à `getSession()` — qui pend
    // toujours — mais force un jeton neuf. C'est tout le correctif : sans lui,
    // ce second appel repart sans en-tête et l'écran d'erreur se rejoue.
    const rejoué = vi.fn().mockResolvedValue("ok");
    const second = callMiddleware({ next: rejoué } as never);
    await vi.advanceTimersByTimeAsync(8_000); // ne sert que si rien n'a été armé
    await second;

    expect(mockRefreshSession).toHaveBeenCalledTimes(1);
    expect(rejoué).toHaveBeenCalledWith({ headers: { Authorization: "Bearer token-neuf" } });
  });
});

// =============================================================================
// LE TABLEAU DE BORD SE CHARGE TOUT SEUL, avec le vrai moteur de reprise de
// React Query. Les deux moitiés ne valent que composées : le middleware ARME le
// forçage, les trois reprises par défaut d'une requête le CONSOMMENT.
// =============================================================================
describe("le tableau de bord guérit seul (bout en bout)", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    resetRejectedTokenForTests();
  });

  it("la seconde tentative part avec un jeton neuf et le Hall s'affiche", async () => {
    const { QueryClient, QueryObserver } = await import("@tanstack/react-query");

    // La lecture de session ne rend rien ET ne signale rien — donc le chemin
    // « cas 1 » de `resolveAccessToken` sort sans même tenter un rafraîchissement.
    // Le jeton de rafraîchissement, lui, est bel et bien encore valide.
    mockGetSession.mockResolvedValue({ data: { session: null }, error: null });
    mockRefreshSession.mockResolvedValue({
      data: { session: { access_token: "token-neuf" } },
      error: null,
    });

    const getDashboard = vi.fn(async (headers: Record<string, string>) => {
      if (headers.Authorization !== "Bearer token-neuf") {
        throw new Error("Unauthorized: No authorization header provided");
      }
      return { profile: { display_name: "Yahia" } };
    });

    // `retry: 3` est posé EXPLICITEMENT, et il ne triche pas : c'est le défaut de
    // la librairie DANS LE NAVIGATEUR, celui sur lequel `router.tsx` s'appuie en
    // ne posant justement pas de `retry` sur ses `queries`. Ce fichier tourne en
    // environnement `node`, où React Query bascule ce défaut à 0 pour le SSR —
    // sans cette ligne, la requête n'aurait qu'un seul essai et le test
    // mesurerait le rendu SSR au lieu de l'écran de l'élève. `retryDelay: 0`
    // évite d'attendre le repli exponentiel pour rien.
    const client = new QueryClient({ defaultOptions: { queries: { retry: 3, retryDelay: 0 } } });
    const observer = new QueryObserver(client, {
      queryKey: ["dashboard"],
      queryFn: () =>
        callMiddleware({
          next: (ctx: { headers: Record<string, string> }) => getDashboard(ctx.headers),
        } as never),
    });

    const result = await new Promise<{ status: string }>((resolve) => {
      const unsubscribe = observer.subscribe((r) => {
        if (r.status === "success" || r.status === "error") {
          unsubscribe();
          resolve(r);
        }
      });
    });

    // Sans le correctif : les trois essais partent tous sans en-tête, la requête
    // finit en `error`, et c'est l'écran « Failed to load dashboard ».
    expect(result.status).toBe("success");
    expect(getDashboard).toHaveBeenNthCalledWith(1, {});
    expect(getDashboard).toHaveBeenNthCalledWith(2, { Authorization: "Bearer token-neuf" });
  });
});

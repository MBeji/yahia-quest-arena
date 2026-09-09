// @vitest-environment node
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetSession, mockRefreshSession, mockSignOut } = vi.hoisted(() => ({
  mockGetSession: vi.fn(),
  mockRefreshSession: vi.fn(),
  mockSignOut: vi.fn(),
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
      signOut: mockSignOut,
    },
  },
}));

import {
  attachSupabaseAuth,
  resetRejectedTokenForTests,
} from "@/shared/integrations/supabase/auth-attacher";
import { AuthApiError, AuthRetryableFetchError } from "@supabase/supabase-js";
import { RECOVERABLE_REFUSAL_MESSAGES } from "@/shared/integrations/supabase/auth-refusals";
import {
  isSessionRefusalError,
  shouldLeaveForLogin,
  shouldReplaySessionRefusal,
} from "@/shared/integrations/supabase/auth-rejection";

// The mock above makes `.client(handler)` return the handler, so at runtime the
// middleware is directly callable. Cast to a callable for type-checking the tests.
const callMiddleware = attachSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

describe("attachSupabaseAuth", () => {
  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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

  it("si le forçage échoue SANS refus du serveur, on retombe sur le chemin normal", async () => {
    // ⚠️ CE TEST A ÉTÉ RÉÉCRIT (#969), et ce qu'il disait avant vaut d'être noté.
    // Il s'appelait « si le forçage échoue, on retombe sur le chemin normal » et
    // son erreur de rafraîchissement était un `{ message: "mort" }` sans statut
    // — donc, en vrai, un REFUS du serveur. Il épinglait alors comme attendu le
    // fait de reposer `Bearer périmé`, c'est-à-dire très exactement la boucle qui
    // enfermait l'élève : le jeton refusé reposé indéfiniment, faute que
    // quiconque termine la session. Un test peut protéger un bug ; celui-ci l'a
    // fait pendant trois semaines.
    //
    // Ce qui reste vrai, et que ce test garde : un échec dont le serveur n'est
    // PAS l'auteur (transport, 5xx, 429, délai dépassé) ne prouve rien sur le
    // jeton. On repart alors du jeton stocké — le serveur tranchera. La sortie
    // n'appartient qu'au refus prouvé, couvert par la suite « les deux jetons
    // sont morts ».
    mockGetSession.mockResolvedValue({ data: { session: { access_token: "périmé" } } });
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: new AuthRetryableFetchError("Failed to fetch", 0),
    });

    const rejeté = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));
    await expect(callMiddleware({ next: rejeté } as never)).rejects.toThrow();

    const next = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next } as never);

    expect(mockSignOut).not.toHaveBeenCalled();
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
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
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

// =============================================================================
// LA SESSION MORTE QUE PERSONNE N'EFFACE (#938 → #969).
//
// Les suites ci-dessus couvrent le jeton refusé RATTRAPABLE : un refresh forcé
// rend un jeton neuf, l'élève ne voit rien. Restait le cas où le refresh échoue
// LUI AUSSI — les deux jetons sont morts.
//
// On pourrait croire qu'auth-js s'en charge : il sait effacer une session et
// émettre `SIGNED_OUT`. Il ne le fait PAS ici, et c'est délibéré de sa part. À
// l'échec d'un rafraîchissement il ne détruit la session que si `expires_at`
// est déjà passé ; sinon il la PRÉSERVE, en supposant qu'un access token non
// expiré fonctionne encore (`GoTrueClient`, branche « proactive refresh failed,
// access token still valid »). L'hypothèse est bonne en général — elle évite de
// déconnecter quelqu'un dont le jeton marche — et fausse exactement ici, parce
// que NOUS savons que le serveur vient de refuser cet access token. auth-js ne
// connaît que l'horloge ; le middleware, lui, a vu le refus.
//
// Sans le correctif, `getSession()` rendait donc indéfiniment le même jeton
// refusé : `user` restait vrai, le garde de `_authenticated` ne redirigeait
// jamais, et l'élève restait sur un écran dont rien ne le sortait — la forme
// exacte de #931 et #914/#915. La spec e2e `session-invalidation.spec.ts` le
// mesurait dans un vrai navigateur ; ces tests-ci épinglent la décision.
// =============================================================================
describe("attachSupabaseAuth — les deux jetons sont morts", () => {
  /** Un access token que le serveur refuse, mais qu'auth-js rend sans broncher. */
  const REFUSÉ = { data: { session: { access_token: "refusé" } } };

  beforeEach(() => {
    mockGetSession.mockReset();
    mockRefreshSession.mockReset();
    mockSignOut.mockReset();
    mockSignOut.mockResolvedValue({ error: null });
    resetRejectedTokenForTests();
  });

  async function faireRefuserLeJeton(): Promise<void> {
    const rejeté = vi.fn().mockRejectedValue(new Error("Unauthorized: Invalid token"));
    await expect(callMiddleware({ next: rejeté } as never)).rejects.toThrow();
  }

  it("le serveur refuse AUSSI le rafraîchissement : la session se termine localement", async () => {
    mockGetSession.mockResolvedValue(REFUSÉ);
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: new AuthApiError(
        "Invalid Refresh Token: Already Used",
        400,
        "refresh_token_already_used",
      ),
    });

    await faireRefuserLeJeton();

    const suivant = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next: suivant } as never);

    // `scope: "local"` : les jetons sont morts, une révocation réseau échouerait
    // et ferait dépendre la SORTIE de l'élève d'un appel qui peut pendre.
    expect(mockSignOut).toHaveBeenCalledWith({ scope: "local" });
    // Et surtout : on ne repose PAS le jeton que le serveur vient de refuser.
    expect(suivant).toHaveBeenCalledWith({ headers: {} });
  });

  it("LA RÉGRESSION : sans la sortie, `getSession()` reposerait le même jeton refusé", async () => {
    // Le cœur de #969. `getSession()` ne vérifie aucune signature : il rend le
    // jeton stocké tant qu'`expires_at` est dans le futur — donc le MÊME jeton
    // refusé, à chaque appel, indéfiniment. Ce test échoue si le code retombe
    // sur le chemin normal après un refus terminal.
    // Le mock modélise le CONTRAT du SDK : `signOut({scope:"local"})` efface le
    // stockage, donc `getSession()` ne rend plus rien ensuite. Sans cet état, le
    // test mesurerait un mock immobile au lieu de la conduite réelle.
    let sessionVivante = true;
    mockGetSession.mockImplementation(() =>
      Promise.resolve(sessionVivante ? REFUSÉ : { data: { session: null }, error: null }),
    );
    mockSignOut.mockImplementation(() => {
      sessionVivante = false;
      return Promise.resolve({ error: null });
    });
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: new AuthApiError("Invalid Refresh Token", 400, "bad_refresh_token"),
    });

    await faireRefuserLeJeton();

    for (const _ of [1, 2, 3]) {
      const appel = vi.fn().mockResolvedValue("ok");
      await callMiddleware({ next: appel } as never);
      expect(appel).not.toHaveBeenCalledWith({
        headers: { Authorization: "Bearer refusé" },
      });
    }
  });

  it("panne de transport : on ne déconnecte PERSONNE pour un réseau qui tousse", async () => {
    // La distinction qui protège l'élève : le serveur n'a pas dit « ce jeton est
    // mauvais », il n'a rien dit du tout. Déconnecter ici punirait un métro sans
    // réseau. On retombe sur le chemin normal, exactement comme avant.
    mockGetSession.mockResolvedValue(REFUSÉ);
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: new AuthRetryableFetchError("Failed to fetch", 0),
    });

    await faireRefuserLeJeton();

    const suivant = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next: suivant } as never);

    expect(mockSignOut).not.toHaveBeenCalled();
    expect(suivant).toHaveBeenCalledWith({ headers: { Authorization: "Bearer refusé" } });
  });

  it("une erreur SANS statut ne prouve rien : on ne déconnecte pas", async () => {
    // Le défaut sûr, et il a failli manquer. La première version de ce correctif
    // finissait sur `return true` — donc toute erreur d'une forme inattendue
    // valait « session morte ». Déconnecter est un geste DESTRUCTEUR : il se
    // mérite par une preuve positive (le service Auth a répondu 4xx), jamais par
    // défaut. Un objet d'erreur exotique, un `{ message }` nu, une couche
    // intermédiaire qui ré-emballe : tout cela retombe désormais sur « on ne
    // sait pas », et l'élève garde sa session.
    mockGetSession.mockResolvedValue(REFUSÉ);
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: { message: "quelque chose a échoué" },
    });

    await faireRefuserLeJeton();

    const suivant = vi.fn().mockResolvedValue("ok");
    await callMiddleware({ next: suivant } as never);

    expect(mockSignOut).not.toHaveBeenCalled();
    expect(suivant).toHaveBeenCalledWith({ headers: { Authorization: "Bearer refusé" } });
  });

  it("5xx et 429 sont des indisponibilités, pas des refus", async () => {
    // Même raison : « je ne peux pas répondre » ne vaut pas « ton jeton est
    // mort ». Un pic de charge sur le service Auth ne doit pas vider les
    // sessions de tous les élèves connectés au même instant.
    for (const status of [429, 500, 503]) {
      resetRejectedTokenForTests();
      mockSignOut.mockClear();
      mockGetSession.mockResolvedValue(REFUSÉ);
      mockRefreshSession.mockResolvedValue({
        data: { session: null },
        error: new AuthApiError("service indisponible", status, undefined),
      });

      await faireRefuserLeJeton();
      await callMiddleware({ next: vi.fn().mockResolvedValue("ok") } as never);

      expect(mockSignOut, `statut ${status}`).not.toHaveBeenCalled();
    }
  });

  it("une déconnexion locale qui échoue ne masque pas le refus : l'appel part sans jeton", async () => {
    // Le défaut sûr est l'erreur VISIBLE, jamais l'exception avalée : si même
    // effacer le stockage échoue, le serveur refusera et l'écran le dira.
    mockGetSession.mockResolvedValue(REFUSÉ);
    mockRefreshSession.mockResolvedValue({
      data: { session: null },
      error: new AuthApiError("Invalid Refresh Token", 400, "bad_refresh_token"),
    });
    mockSignOut.mockRejectedValue(new Error("storage indisponible"));

    await faireRefuserLeJeton();

    const suivant = vi.fn().mockResolvedValue("ok");
    await expect(callMiddleware({ next: suivant } as never)).resolves.toBe("ok");
    expect(suivant).toHaveBeenCalledWith({ headers: {} });
  });
});

// =============================================================================
// LA SORTIE DE DERNIER RECOURS (#938 → #969).
//
// Le garde de `_authenticated` sort une session morte. Mais quand la frontière
// d'erreur racine rend, elle REMPLACE l'arbre : le garde est démonté, son effet
// ne tourne plus, et plus personne n'écoute `SIGNED_OUT`. C'est ce qui a rendu
// #1009 et #1010 insuffisants — ils réparaient l'amont d'une porte déjà murée.
// `shouldLeaveForLogin` redit la règle du garde là où le garde n'existe plus.
// =============================================================================
describe("shouldLeaveForLogin — sortir d'un cul-de-sac, et de rien d'autre", () => {
  const REFUS = new Error("Unauthorized: Invalid token");

  it("session morte + refus d'authentification : on sort vers la connexion", () => {
    expect(shouldLeaveForLogin({ loading: false, hasUser: false, error: REFUS })).toBe(true);
  });

  it("une panne ORDINAIRE garde son écran d'erreur et son bouton Réessayer", () => {
    // Renvoyer un élève vers la connexion pour un bug de rendu ou un 500 serait
    // une régression, pas un correctif : son problème n'a rien à voir avec sa
    // session, et la connexion ne le résoudrait pas.
    for (const message of ["Boom", "Failed to fetch", "Internal Server Error"]) {
      expect(
        shouldLeaveForLogin({ loading: false, hasUser: false, error: new Error(message) }),
        message,
      ).toBe(false);
    }
  });

  it("tant qu'une session existe, le refus peut être passager : on ne sort pas", () => {
    // `auth-attacher` ne termine la session que sur un refus PROUVÉ. Qu'il en
    // reste une signifie donc qu'il n'a pas conclu à la mort — insister ici
    // déconnecterait sur une panne réseau.
    expect(shouldLeaveForLogin({ loading: false, hasUser: true, error: REFUS })).toBe(false);
  });

  it("on ne sort personne pendant qu'on lit encore sa session", () => {
    // Même précaution que le garde : sans elle, chaque rechargement sortirait
    // tout le monde le temps d'un aller-retour de stockage.
    expect(shouldLeaveForLogin({ loading: true, hasUser: false, error: REFUS })).toBe(false);
  });

  it("le refus ABSENT de jeton compte aussi — c'est la panne du 2026-08-18", () => {
    const sansEnTete = new Error("Unauthorized: No authorization header provided");
    expect(shouldLeaveForLogin({ loading: false, hasUser: false, error: sansEnTete })).toBe(true);
  });

  it("les messages viennent de la TABLE, jamais d'une liste écrite ici", () => {
    // Le garde-fou de #931 et #914/#915 : deux listes tenues à la main ont
    // divergé deux fois. Si un refus `fresh-token` est reformulé dans
    // `auth-refusals.ts`, ce test suit sans être touché.
    for (const message of RECOVERABLE_REFUSAL_MESSAGES) {
      expect(
        shouldLeaveForLogin({ loading: false, hasUser: false, error: new Error(message) }),
        message,
      ).toBe(true);
    }
  });
});

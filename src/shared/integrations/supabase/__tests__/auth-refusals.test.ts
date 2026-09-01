// @vitest-environment node
//
// LE MÉCANISME ANTI-RECHUTE, ET SON CONTRÔLE.
//
// Deux pannes en trois semaines — « Failed to load dashboard » (#931) et le
// bouton « Valider » grisé sans fin (#914/#915) — ont eu la même cause de fond :
// le serveur sait refuser de sept façons, et le client décidait quoi en faire à
// partir d'une liste de messages tenue à la main, dans un autre fichier, sans
// rien qui relie les deux.
//
// `auth-refusals.ts` ferme cette porte par la COMPILATION (un huitième refus ne
// compile pas sans sa ligne). Ce fichier ferme les deux autres moitiés, par des
// tests PILOTÉS PAR LA TABLE — jamais par une liste de cas écrite à la main :
//
//   1. le client fait vraiment ce que la table déclare (`recovery`) ;
//   2. le serveur lève vraiment le message que la table porte.
//
// Écrits ainsi, ces tests couvrent AUTOMATIQUEMENT tout refus ajouté demain.
// C'est le point : un test qui énumère les cas à la main aurait le même angle
// mort que le code qu'il surveille.
import { beforeEach, describe, expect, it, vi } from "vitest";

const { mockGetRequest, mockCreateClient, mockGetClaims } = vi.hoisted(() => ({
  mockGetRequest: vi.fn(),
  mockCreateClient: vi.fn(),
  mockGetClaims: vi.fn(),
}));

vi.mock("@tanstack/react-start", () => ({
  createMiddleware: () => ({ server: (handler: unknown) => handler }),
}));
vi.mock("@tanstack/react-start/server", () => ({ getRequest: mockGetRequest }));
vi.mock("@supabase/supabase-js", async (importOriginal) => ({
  ...(await importOriginal<typeof import("@supabase/supabase-js")>()),
  createClient: mockCreateClient,
}));
vi.mock("@/shared/lib/logger", () => ({ logger: { error: vi.fn(), warn: vi.fn() } }));

import { requireSupabaseAuth } from "@/shared/integrations/supabase/auth-middleware";
import {
  AUTH_REFUSALS,
  RECOVERABLE_REFUSAL_MESSAGES,
  type AuthFailure,
} from "@/shared/integrations/supabase/auth-refusals";
import { isSessionRefusalError } from "@/shared/integrations/supabase/auth-rejection";

const callMiddleware = requireSupabaseAuth as unknown as (ctx: never) => Promise<unknown>;

/** Les sept refus, lus DE LA TABLE : un huitième entrera ici tout seul. */
const ALL_REFUSALS = Object.entries(AUTH_REFUSALS) as [
  AuthFailure,
  (typeof AUTH_REFUSALS)[AuthFailure],
][];

describe("la table des refus — sa forme", () => {
  it("chaque refus porte un message et une conduite", () => {
    for (const [failure, refusal] of ALL_REFUSALS) {
      expect(refusal.message, `${failure} sans message`).toBeTruthy();
      expect(["fresh-token", "none"]).toContain(refusal.recovery);
    }
  });

  it("la table ne transporte QUE ce qui sert à l'exécution", () => {
    // Ce module part dans le bundle du navigateur (via `auth-rejection.ts`). La
    // raison de chaque choix est en COMMENTAIRE, jamais en champ : écrite comme
    // propriété `why`, elle a fait dépasser le budget de `index` (450,40 kB pour
    // 450). Ce test empêche de la réintroduire sans s'en apercevoir.
    for (const [failure, refusal] of ALL_REFUSALS) {
      expect(Object.keys(refusal).sort(), `${failure} porte un champ de trop`).toEqual([
        "message",
        "recovery",
      ]);
    }
  });

  it("aucun message n'est porté par DEUX refus", () => {
    // Le client ne voit que le message : deux refus qui partagent le leur
    // seraient indiscernables, et l'un hériterait de la conduite de l'autre.
    const messages = ALL_REFUSALS.map(([, refusal]) => refusal.message);
    expect(new Set(messages).size).toBe(messages.length);
  });

  it("la liste dérivée est exactement celle des refus guérissables", () => {
    const expected = ALL_REFUSALS.filter(([, r]) => r.recovery === "fresh-token").map(
      ([, r]) => r.message,
    );
    expect([...RECOVERABLE_REFUSAL_MESSAGES].sort()).toEqual(expected.sort());
  });
});

describe("le CLIENT fait ce que la table déclare", () => {
  // L'invariant qui manquait. Avant la table, `auth-rejection.ts` reconnaissait
  // « Invalid token » et rien d'autre — alors que `NO_HEADER` est la panne du
  // tableau de bord. Ce test l'aurait vu, et il le verra pour le prochain.
  it.each(ALL_REFUSALS)("%s", (failure, refusal) => {
    expect(
      isSessionRefusalError(new Error(refusal.message)),
      `${failure} est déclaré recovery:"${refusal.recovery}" — le prédicat client doit suivre.`,
    ).toBe(refusal.recovery === "fresh-token");
  });
});

describe("le SERVEUR lève le message que la table porte", () => {
  // L'autre moitié : sans elle, la table pourrait être juste ET décorative, le
  // middleware continuant de lever ses propres chaînes. C'est exactement la
  // divergence qui rendait la panne invisible aux tests — chaque côté validait
  // sa propre copie du message.
  beforeEach(() => {
    process.env.SUPABASE_URL = "https://example.supabase.co";
    process.env.SUPABASE_PUBLISHABLE_KEY = "public-key";
    vi.clearAllMocks();
    mockCreateClient.mockReturnValue({ auth: { getClaims: mockGetClaims } });
  });

  /** Chaque refus, provoqué par la requête qui le déclenche RÉELLEMENT. */
  const provoke: Record<AuthFailure, () => void> = {
    NO_HEADER: () => mockGetRequest.mockReturnValue({ headers: new Headers() }),
    BAD_SCHEME: () =>
      mockGetRequest.mockReturnValue({ headers: new Headers({ authorization: "Basic abc" }) }),
    EMPTY_TOKEN: () => mockGetRequest.mockReturnValue({ headers: { get: () => "Bearer " } }),
    INVALID_TOKEN: () => {
      mockGetRequest.mockReturnValue({ headers: new Headers({ authorization: "Bearer jeton" }) });
      mockGetClaims.mockResolvedValue({ data: null, error: { message: "bad signature" } });
    },
    NO_SUBJECT: () => {
      mockGetRequest.mockReturnValue({ headers: new Headers({ authorization: "Bearer jeton" }) });
      mockGetClaims.mockResolvedValue({ data: { claims: {} }, error: null });
    },
    UNAVAILABLE: async () => {
      const { AuthRetryableFetchError } = await import("@supabase/supabase-js");
      mockGetRequest.mockReturnValue({ headers: new Headers({ authorization: "Bearer jeton" }) });
      mockGetClaims.mockResolvedValue({
        data: null,
        error: new AuthRetryableFetchError("network down", 0),
      });
    },
    MISCONFIGURED: () => {
      delete process.env.SUPABASE_URL;
      delete process.env.SUPABASE_PUBLISHABLE_KEY;
      mockGetRequest.mockReturnValue({ headers: new Headers() });
    },
  };

  it.each(ALL_REFUSALS)("%s", async (failure, refusal) => {
    await provoke[failure]();
    await expect(callMiddleware({ next: vi.fn() } as never)).rejects.toThrow(refusal.message);
  });
});

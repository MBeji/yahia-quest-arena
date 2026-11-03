import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

const mockNavigate = vi.fn();
const mockPush = vi.fn();
const mockSearch: { mode: string; role?: "parent"; returnTo?: string } = { mode: "signup" };
vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useSearch: () => mockSearch,
  }),
  useNavigate: () => mockNavigate,
  useRouter: () => ({ history: { push: mockPush } }),
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));
vi.mock("@tanstack/react-start", () => ({ useServerFn: () => vi.fn() }));
vi.mock("@/features/parent-report", () => ({ linkStudentByCode: vi.fn() }));
vi.mock("@/features/auth", () => ({ bootstrapProfile: vi.fn() }));
vi.mock("motion/react", () => ({
  motion: {
    div: ({ children, ...p }: { children?: React.ReactNode }) =>
      React.createElement("div", p, children),
  },
}));
vi.mock("@/shared/lib/motion", () => ({ useEntrance: () => ({}) }));
vi.mock("@/components/ui/language-switcher", () => ({ LanguageSwitcher: () => null }));

const toastError = vi.fn();
vi.mock("sonner", () => ({
  toast: { success: vi.fn(), error: (m: string) => toastError(m) },
}));

const mockSignUp = vi.fn();
const mockSignIn = vi.fn();
const mockResend = vi.fn();
const mockGetSession = vi.fn();
const mockOnAuthStateChange = vi.fn();
vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      signUp: (...a: unknown[]) => mockSignUp(...a),
      signInWithPassword: (...a: unknown[]) => mockSignIn(...a),
      resend: (...a: unknown[]) => mockResend(...a),
      getSession: () => mockGetSession(),
      onAuthStateChange: (...a: unknown[]) => mockOnAuthStateChange(...a),
    },
  },
}));

// é38 lot 0 : le tunnel émet `signup` et `login` — on lit ce qui part, pas le transport.
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

import { notePageForFunnel } from "@/shared/lib/funnel-origin";
import { peekReturnTo, rememberReturnTo } from "@/shared/lib/return-to";
import { Route, friendlyAuthError, isEmailNotConfirmed, isFreshGoogleSignIn } from "../auth";

// The page itself is NOT exported: exporting a route's component defeats TanStack
// Start's route splitting and drags its whole import graph (motion, icons, form
// primitives) into the entry chunk — measured at +80 kB, over the bundle budget.
// `createFileRoute` is mocked above to hand back its options, so the component is
// reachable through the route object without adding an export for the test's sake.
const AuthPage = (Route as unknown as { component: React.ComponentType }).component;

/** Fill the signup form and submit it. */
function submitSignup(email = "hero@example.com") {
  fireEvent.change(screen.getByPlaceholderText(/Prénom ou pseudo/), {
    target: { value: "Hero" },
  });
  fireEvent.change(screen.getByPlaceholderText("Email"), { target: { value: email } });
  fireEvent.change(screen.getByPlaceholderText(/Mot de passe/), {
    target: { value: "motdepasse123" },
  });
  fireEvent.click(screen.getByRole("button", { name: /Créer mon compte/ }));
}

/** Fill the login form and submit it. */
function submitLogin(email = "a@example.com") {
  fireEvent.change(screen.getByPlaceholderText("Email"), { target: { value: email } });
  fireEvent.change(screen.getByPlaceholderText(/Mot de passe/), {
    target: { value: "motdepasse123" },
  });
  fireEvent.click(screen.getByRole("button", { name: /Se connecter/ }));
}

describe("AuthPage — confirmation e-mail", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockSearch.mode = "signup";
    mockGetSession.mockResolvedValue({ data: { session: null } });
    mockOnAuthStateChange.mockReturnValue({ data: { subscription: { unsubscribe: vi.fn() } } });
  });

  // Supabase's email-enumeration protection answers a repeat signup with 200 and an
  // obfuscated user, WITHOUT sending anything. Promising a mail there stranded the
  // address for good (observed on prod, 2026-08-16).
  it("an address that already has an account: says so instead of promising a mail", async () => {
    mockSignUp.mockResolvedValue({
      data: { user: { id: "obfuscated", identities: [] }, session: null },
      error: null,
    });
    render(<AuthPage />);
    submitSignup();

    expect(await screen.findByText(/Cette adresse a déjà un compte/)).toBeInTheDocument();
    expect(screen.queryByText(/Confirme ton email/)).not.toBeInTheDocument();
  });

  it("a genuinely new account: shows the interstitial and can ask for the mail again", async () => {
    mockSignUp.mockResolvedValue({
      data: { user: { id: "u1", identities: [{ identity_id: "i1" }] }, session: null },
      error: null,
    });
    mockResend.mockResolvedValue({ error: null });
    render(<AuthPage />);
    submitSignup("nouveau@example.com");

    expect(await screen.findByText(/Confirme ton email/)).toBeInTheDocument();
    fireEvent.click(screen.getByRole("button", { name: /Renvoyer l'email/ }));

    await waitFor(() =>
      expect(mockResend).toHaveBeenCalledWith(
        expect.objectContaining({ type: "signup", email: "nouveau@example.com" }),
      ),
    );
    expect(await screen.findByText(/Email renvoyé/)).toBeInTheDocument();
    // The button then mirrors GoTrue's own cooldown rather than inviting a doomed retry.
    expect(screen.getByRole("button", { name: /Renvoyer dans 60 s/ })).toBeDisabled();
  });

  it("a mailer failure is reported as such, not as an authentication error", async () => {
    mockSignUp.mockResolvedValue({
      data: { user: null, session: null },
      error: new Error("Error sending confirmation email"),
    });
    render(<AuthPage />);
    submitSignup();

    expect(await screen.findByText(/n'a pas pu partir/)).toBeInTheDocument();
    expect(screen.queryByText(/Erreur d'authentification/)).not.toBeInTheDocument();
  });

  it("signing in on an unconfirmed account offers the resend", async () => {
    mockSearch.mode = "login";
    mockSignIn.mockResolvedValue({ error: new Error("Email not confirmed") });
    mockResend.mockResolvedValue({ error: null });
    render(<AuthPage />);

    fireEvent.change(screen.getByPlaceholderText("Email"), {
      target: { value: "attente@example.com" },
    });
    fireEvent.change(screen.getByPlaceholderText(/Mot de passe/), {
      target: { value: "motdepasse123" },
    });
    fireEvent.click(screen.getByRole("button", { name: /Se connecter/ }));

    const resendBtn = await screen.findByRole("button", { name: /Renvoyer l'email/ });
    fireEvent.click(resendBtn);
    await waitFor(() =>
      expect(mockResend).toHaveBeenCalledWith(
        expect.objectContaining({ type: "signup", email: "attente@example.com" }),
      ),
    );
  });
});

describe("AuthPage — parent signup with alliance code", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockSearch.mode = "signup";
    // Pre-select the parent role via URL param so the alliance-code field renders.
    mockSearch.role = "parent";
    mockGetSession.mockResolvedValue({ data: { session: null } });
    mockOnAuthStateChange.mockReturnValue({ data: { subscription: { unsubscribe: vi.fn() } } });
  });

  afterEach(() => {
    delete mockSearch.role;
  });

  // Regression for report 04d460bf: when the optional alliance-code linking step
  // fails (invalid code, network error, or the server fn returns undefined and
  // `linkRes.linked` throws), the outer catch swallowed the error and never
  // reached `navigate({ to: "/dashboard" })`, leaving the parent on the auth page
  // even though their account had been created successfully.
  it("an alliance-code error must not block navigation to /dashboard", async () => {
    // Auto-login signup: both user and session present.
    // With the default useServerFn mock, linkByCode() returns undefined and
    // `undefined.linked` throws — that is the bug trigger this test pins.
    mockSignUp.mockResolvedValue({
      data: {
        user: { id: "parent-u1", identities: [{ identity_id: "i1" }] },
        session: { user: { id: "parent-u1" } },
      },
      error: null,
    });
    render(<AuthPage />);

    fireEvent.change(screen.getByPlaceholderText(/Code Alliance élève/), {
      target: { value: "ABCD-1234-ABCD-1234-ABCD-1234-ABCD-1234" },
    });
    submitSignup();

    await waitFor(() => expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" }));
  });
});

describe("friendlyAuthError", () => {
  const t = {
    auth: {
      errorInvalidLogin: "invalid",
      errorEmailNotConfirmed: "not-confirmed",
      errorAccountExists: "exists",
      errorMailerDown: "mailer-down",
      errorRateLimit: "rate-limit",
      passwordTooShort: "short",
      errorSignupDisabled: "disabled",
      errorGeneric: "generic",
    },
  } as unknown as Parameters<typeof friendlyAuthError>[0];

  it.each([
    ["Error sending confirmation email", "mailer-down"],
    // GoTrue's cooldown wording contains neither « rate limit » nor « too many ».
    ["For security purposes, you can only request this after 54 seconds", "rate-limit"],
    ["Email rate limit exceeded", "rate-limit"],
    ["Invalid login credentials", "invalid"],
    ["Email not confirmed", "not-confirmed"],
    ["Database is on fire", "generic"],
  ])("maps %s", (message, expected) => {
    expect(friendlyAuthError(t, new Error(message))).toBe(expected);
  });

  it("reads the error code when supabase-js provides one", () => {
    const err = Object.assign(new Error("weird wording"), { code: "over_email_send_rate_limit" });
    expect(friendlyAuthError(t, err)).toBe("rate-limit");
    expect(
      isEmailNotConfirmed(Object.assign(new Error("x"), { code: "email_not_confirmed" })),
    ).toBe(true);
  });
});

describe("AuthPage — les événements du tunnel (é38 lot 0)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    notePageForFunnel("/");
    window.localStorage.clear();
    window.history.replaceState({}, "", "/auth");
    mockSearch.mode = "signup";
    delete mockSearch.role;
    delete mockSearch.returnTo;
    mockGetSession.mockResolvedValue({ data: { session: null } });
    mockOnAuthStateChange.mockReturnValue({ data: { subscription: { unsubscribe: vi.fn() } } });
  });

  function fillLogin() {
    fireEvent.change(screen.getByPlaceholderText("Email"), { target: { value: "a@example.com" } });
    fireEvent.change(screen.getByPlaceholderText(/Mot de passe/), {
      target: { value: "motdepasse123" },
    });
    fireEvent.click(screen.getByRole("button", { name: /Se connecter/ }));
  }

  it("signup : dit le rôle, si une confirmation est attendue, et que le retour n'est pas gardé", async () => {
    mockSignUp.mockResolvedValue({
      data: { user: { id: "u1", identities: [{ identity_id: "i1" }] }, session: null },
      error: null,
    });
    render(<AuthPage />);
    submitSignup();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("signup", {
        role: "student",
        needs_confirmation: true,
        return_to_kept: false,
        from_content: false,
      }),
    );
  });

  it("signup : from_content vaut true quand la page d'avant était un cours", async () => {
    notePageForFunnel("/chapitre/c1");
    mockSignUp.mockResolvedValue({
      data: { user: { id: "u1", identities: [{ identity_id: "i1" }] }, session: null },
      error: null,
    });
    render(<AuthPage />);
    submitSignup();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith(
        "signup",
        expect.objectContaining({ from_content: true }),
      ),
    );
  });

  it("une adresse déjà inscrite ne compte pas comme une inscription", async () => {
    mockSignUp.mockResolvedValue({
      data: { user: { id: "obfuscated", identities: [] }, session: null },
      error: null,
    });
    render(<AuthPage />);
    submitSignup();

    await screen.findByText(/Cette adresse a déjà un compte/);
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("connexion par mot de passe : un login frais, sans retour gardé", async () => {
    mockSearch.mode = "login";
    mockSignIn.mockResolvedValue({ error: null });
    render(<AuthPage />);
    fillLogin();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("login", {
        method: "password",
        reason: "fresh",
        return_to_kept: false,
        from_content: false,
      }),
    );
  });

  it("une connexion refusée n'émet aucun login", async () => {
    mockSearch.mode = "login";
    mockSignIn.mockResolvedValue({ error: new Error("Invalid login credentials") });
    render(<AuthPage />);
    fillLogin();

    await screen.findByText(/Email ou mot de passe incorrect/);
    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  /** Une session telle que la renvoie Supabase juste après une connexion par `provider`. */
  const sessionOf = (provider: string, signedInAt: string) => ({
    user: { id: "u1", identities: [{ provider, last_sign_in_at: signedInAt }] },
  });

  it("retour de Google : UN login, dont l'origine se lit sur le retour gardé", () => {
    // Le flux du projet est IMPLICITE : le retour arrive dans le fragment, jamais dans ?code=.
    window.history.replaceState({}, "", "/auth#access_token=abc&token_type=bearer");
    render(<AuthPage />);
    const listener = mockOnAuthStateChange.mock.calls[0][0] as (e: string, s: unknown) => void;
    const fresh = sessionOf("google", new Date().toISOString());

    listener("SIGNED_IN", fresh);
    listener("SIGNED_IN", fresh);

    expect(trackProductEvent).toHaveBeenCalledTimes(1);
    expect(trackProductEvent).toHaveBeenCalledWith("login", {
      method: "google",
      reason: "fresh",
      return_to_kept: false,
      from_content: false,
    });
  });

  it("retour de Google : le retour gardé a SURVÉCU au rechargement, il dit d'où l'on venait", () => {
    // La page est rechargée chez Google : la dernière page en mémoire est perdue, la mémoire
    // du retour (localStorage), non. C'est ce qui rend `from_content` lisible pour Google.
    rememberReturnTo("/chapitre/c1");
    render(<AuthPage />);
    const listener = mockOnAuthStateChange.mock.calls[0][0] as (e: string, s: unknown) => void;

    listener("SIGNED_IN", sessionOf("google", new Date().toISOString()));

    expect(trackProductEvent).toHaveBeenCalledWith("login", {
      method: "google",
      reason: "fresh",
      return_to_kept: true,
      from_content: true,
    });
    expect(mockPush).toHaveBeenCalledWith("/chapitre/c1");
  });

  it("une session Google ANCIENNE qui se rouvre (onglet retrouvé) n'est pas une connexion", () => {
    render(<AuthPage />);
    const listener = mockOnAuthStateChange.mock.calls[0][0] as (e: string, s: unknown) => void;

    listener("SIGNED_IN", sessionOf("google", "2026-01-01T00:00:00.000Z"));

    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" });
  });

  it("le retour d'un lien de confirmation e-mail n'est pas un login Google", () => {
    render(<AuthPage />);
    const listener = mockOnAuthStateChange.mock.calls[0][0] as (e: string, s: unknown) => void;

    listener("SIGNED_IN", sessionOf("email", new Date().toISOString()));

    expect(trackProductEvent).not.toHaveBeenCalled();
  });

  it("un visiteur déjà connecté qui passe par /auth n'est pas une connexion", () => {
    render(<AuthPage />);
    const listener = mockOnAuthStateChange.mock.calls[0][0] as (e: string, s: unknown) => void;

    listener("SIGNED_IN", { user: { id: "u1" } });

    expect(trackProductEvent).not.toHaveBeenCalled();
    expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" });
  });
});

describe("AuthPage — le retour au point de départ (é38 lot 1)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.localStorage.clear();
    window.history.replaceState({}, "", "/auth");
    notePageForFunnel("/");
    mockSearch.mode = "login";
    delete mockSearch.role;
    delete mockSearch.returnTo;
    mockGetSession.mockResolvedValue({ data: { session: null } });
    mockOnAuthStateChange.mockReturnValue({ data: { subscription: { unsubscribe: vi.fn() } } });
    mockSignIn.mockResolvedValue({ error: null });
  });

  const signedUp = {
    data: {
      user: { id: "u1", identities: [{ identity_id: "i1" }] },
      session: { user: { id: "u1" } },
    },
    error: null,
  };
  const needsConfirmation = {
    data: { user: { id: "u1", identities: [{ identity_id: "i1" }] }, session: null },
    error: null,
  };

  it("après la connexion, ramène à la page gardée — et pas au Hall", async () => {
    rememberReturnTo("/chapitre/c1");
    render(<AuthPage />);
    submitLogin();

    await waitFor(() => expect(mockPush).toHaveBeenCalledWith("/chapitre/c1"));
    expect(mockNavigate).not.toHaveBeenCalled();
    // Il ne sert qu'une fois : consommé.
    expect(peekReturnTo()).toBeNull();
  });

  it("sans retour gardé, c'est le Hall, comme avant", async () => {
    render(<AuthPage />);
    submitLogin();

    await waitFor(() => expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" }));
    expect(mockPush).not.toHaveBeenCalled();
  });

  it("après l'inscription qui ouvre une session, ramène à la page gardée", async () => {
    mockSearch.mode = "signup";
    mockSignUp.mockResolvedValue(signedUp);
    rememberReturnTo("/matiere/m1");
    render(<AuthPage />);
    submitSignup();

    await waitFor(() => expect(mockPush).toHaveBeenCalledWith("/matiere/m1"));
    expect(mockNavigate).not.toHaveBeenCalled();
  });

  it("l'inscription qui attend une confirmation GARDE le retour pour le lien du mail", async () => {
    mockSearch.mode = "signup";
    mockSignUp.mockResolvedValue(needsConfirmation);
    rememberReturnTo("/chapitre/c1");
    render(<AuthPage />);
    submitSignup();

    await screen.findByText(/Confirme ton email/);
    expect(peekReturnTo()).toBe("/chapitre/c1");
    expect(mockPush).not.toHaveBeenCalled();
  });

  it("le lien de confirmation, ouvert sur /auth, ramène à la page gardée", async () => {
    // Le lien du mail rouvre /auth ; Supabase y ouvre la session ; la page n'a plus qu'à repartir.
    rememberReturnTo("/chapitre/c1");
    mockGetSession.mockResolvedValue({ data: { session: { user: { id: "u1" } } } });
    render(<AuthPage />);

    await waitFor(() => expect(mockPush).toHaveBeenCalledWith("/chapitre/c1"));
    expect(mockNavigate).not.toHaveBeenCalled();
  });

  it("UNE seule navigation, même quand le rappel de session ET SIGNED_IN arrivent tous deux", async () => {
    rememberReturnTo("/chapitre/c1");
    mockGetSession.mockResolvedValue({ data: { session: { user: { id: "u1" } } } });
    render(<AuthPage />);
    const listener = mockOnAuthStateChange.mock.calls[0][0] as (e: string, s: unknown) => void;

    await waitFor(() => expect(mockPush).toHaveBeenCalledTimes(1));
    // Le second arrivant retrouverait une mémoire consommée et renverrait au Hall PAR-DESSUS le retour.
    listener("SIGNED_IN", { user: { id: "u1" } });
    listener("TOKEN_REFRESHED", { user: { id: "u1" } });

    expect(mockPush).toHaveBeenCalledTimes(1);
    expect(mockNavigate).not.toHaveBeenCalled();
  });

  it("l'adresse peut écrire le retour : un lien d'invitation partagé", () => {
    mockSearch.returnTo = "/matiere/m1";
    render(<AuthPage />);

    expect(peekReturnTo()).toBe("/matiere/m1");
  });

  it.each(["//evil.tn", "https://evil.tn/phish", "javascript:alert(1)", "/\\evil.tn", "/auth"])(
    "…mais un retour dangereux dans l'adresse (%s) est ignoré",
    (hostile) => {
      mockSearch.returnTo = hostile;
      render(<AuthPage />);

      expect(peekReturnTo()).toBeNull();
    },
  );

  it("un retour dangereux DÉJÀ dans le stockage — écrit par une autre page — est ignoré", async () => {
    window.localStorage.setItem(
      "na9ra.returnTo.v1",
      JSON.stringify({ path: "//evil.tn", at: Date.now() }),
    );
    render(<AuthPage />);
    submitLogin();

    await waitFor(() => expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" }));
    expect(mockPush).not.toHaveBeenCalled();
  });

  it("les événements disent que le retour est gardé et d'où l'on venait", async () => {
    rememberReturnTo("/chapitre/c1");
    render(<AuthPage />);
    submitLogin();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("login", {
        method: "password",
        reason: "fresh",
        return_to_kept: true,
        from_content: true,
      }),
    );
  });

  it("l'inscription le dit aussi", async () => {
    mockSearch.mode = "signup";
    mockSignUp.mockResolvedValue(needsConfirmation);
    rememberReturnTo("/chapitre/c1");
    render(<AuthPage />);
    submitSignup();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("signup", {
        role: "student",
        needs_confirmation: true,
        return_to_kept: true,
        from_content: true,
      }),
    );
  });

  it("le lien de confirmation revient sur /auth — et non plus sur /dashboard", async () => {
    mockSearch.mode = "signup";
    mockSignUp.mockResolvedValue(needsConfirmation);
    mockResend.mockResolvedValue({ error: null });
    render(<AuthPage />);
    submitSignup();

    await waitFor(() =>
      expect(mockSignUp).toHaveBeenCalledWith(
        expect.objectContaining({
          options: expect.objectContaining({
            emailRedirectTo: `${window.location.origin}/auth`,
          }),
        }),
      ),
    );
    fireEvent.click(await screen.findByRole("button", { name: /Renvoyer l'email/ }));
    await waitFor(() =>
      expect(mockResend).toHaveBeenCalledWith(
        expect.objectContaining({
          options: { emailRedirectTo: `${window.location.origin}/auth` },
        }),
      ),
    );
  });
});

describe("isFreshGoogleSignIn", () => {
  const now = Date.parse("2026-10-30T19:00:00.000Z");
  const secondsAgo = (n: number) => new Date(now - n * 1000).toISOString();

  it("une identité Google connectée depuis quelques secondes est un retour de Google", () => {
    const session = {
      user: { identities: [{ provider: "google", last_sign_in_at: secondsAgo(5) }] },
    };
    expect(isFreshGoogleSignIn(session, now)).toBe(true);
  });

  it("la même identité, cinq minutes plus tard, est une session retrouvée", () => {
    const session = {
      user: { identities: [{ provider: "google", last_sign_in_at: secondsAgo(300) }] },
    };
    expect(isFreshGoogleSignIn(session, now)).toBe(false);
  });

  it("une identité e-mail fraîche n'est pas Google", () => {
    const session = {
      user: { identities: [{ provider: "email", last_sign_in_at: secondsAgo(5) }] },
    };
    expect(isFreshGoogleSignIn(session, now)).toBe(false);
  });

  it("un compte à deux identités : c'est la plus récemment connectée qui compte", () => {
    const googleFresh = {
      user: {
        identities: [
          { provider: "email", last_sign_in_at: secondsAgo(86_400) },
          { provider: "google", last_sign_in_at: secondsAgo(3) },
        ],
      },
    };
    const emailFresh = {
      user: {
        identities: [
          { provider: "google", last_sign_in_at: secondsAgo(86_400) },
          { provider: "email", last_sign_in_at: secondsAgo(3) },
        ],
      },
    };
    expect(isFreshGoogleSignIn(googleFresh, now)).toBe(true);
    expect(isFreshGoogleSignIn(emailFresh, now)).toBe(false);
  });

  it("sans identités, retombe sur le fournisseur et la date de la session", () => {
    const fresh = {
      user: { app_metadata: { provider: "google" }, last_sign_in_at: secondsAgo(2) },
    };
    const stale = {
      user: { app_metadata: { provider: "google" }, last_sign_in_at: secondsAgo(900) },
    };
    expect(isFreshGoogleSignIn(fresh, now)).toBe(true);
    expect(isFreshGoogleSignIn(stale, now)).toBe(false);
  });

  it("une session qui ne dit rien n'est pas une connexion Google", () => {
    expect(isFreshGoogleSignIn({ user: {} }, now)).toBe(false);
    expect(isFreshGoogleSignIn({ user: { identities: null } }, now)).toBe(false);
  });
});

/**
 * Revue de sécurité du lot 1 — LA MESURE SE LIT AVANT QUE LA MÉMOIRE SOIT CONSOMMÉE.
 *
 * Les tests d'événements plus haut passaient pour une mauvaise raison : leur `signInWithPassword`
 * simulé rendait la main SANS que l'écouteur d'état d'authentification ait parlé. Le vrai client
 * (`auth-js`) notifie `SIGNED_IN` — et attend les écouteurs — AVANT de rendre la main : la page a déjà
 * navigué, et `leave()` a déjà vidé la mémoire, quand le formulaire veut mesurer. Ici l'écouteur parle
 * d'abord, comme en production.
 */
describe("AuthPage — la mesure se lit avant la consommation (revue de sécurité du lot 1)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    window.localStorage.clear();
    window.history.replaceState({}, "", "/auth");
    notePageForFunnel("/");
    mockSearch.mode = "login";
    delete mockSearch.role;
    delete mockSearch.returnTo;
    mockGetSession.mockResolvedValue({ data: { session: null } });
    mockOnAuthStateChange.mockReturnValue({ data: { subscription: { unsubscribe: vi.fn() } } });
  });

  /** L'écouteur que la page a posé sur l'état d'authentification. */
  const listener = () =>
    mockOnAuthStateChange.mock.calls[0][0] as (event: string, session: unknown) => void;

  /** Comme le vrai client : SIGNED_IN est notifié AVANT que l'appel ne rende la main. */
  const signedInBeforeResolving = (result: unknown) => async () => {
    listener()("SIGNED_IN", { user: { id: "u1" } });
    return result;
  };

  const loginEvents = () => trackProductEvent.mock.calls.filter(([name]) => name === "login");

  const freshGoogle = () => ({
    user: {
      id: "u1",
      identities: [{ provider: "google", last_sign_in_at: new Date().toISOString() }],
    },
  });

  it("connexion par mot de passe : le retour est ramené ET mesuré comme gardé", async () => {
    rememberReturnTo("/chapitre/c1");
    mockSignIn.mockImplementation(signedInBeforeResolving({ error: null }));
    render(<AuthPage />);
    submitLogin();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("login", {
        method: "password",
        reason: "fresh",
        return_to_kept: true,
        from_content: true,
      }),
    );
    expect(mockPush).toHaveBeenCalledTimes(1);
    expect(mockPush).toHaveBeenCalledWith("/chapitre/c1");
  });

  it("inscription qui ouvre une session : même chose", async () => {
    mockSearch.mode = "signup";
    rememberReturnTo("/chapitre/c1");
    mockSignUp.mockImplementation(
      signedInBeforeResolving({
        data: {
          user: { id: "u1", identities: [{ identity_id: "i1" }] },
          session: { access_token: "t" },
        },
        error: null,
      }),
    );
    render(<AuthPage />);
    submitSignup();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("signup", {
        role: "student",
        needs_confirmation: false,
        return_to_kept: true,
        from_content: true,
      }),
    );
    expect(mockPush).toHaveBeenCalledTimes(1);
    expect(mockPush).toHaveBeenCalledWith("/chapitre/c1");
  });

  it("sans retour gardé, la mesure dit toujours faux — c'est le Hall", async () => {
    mockSignIn.mockImplementation(signedInBeforeResolving({ error: null }));
    render(<AuthPage />);
    submitLogin();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("login", {
        method: "password",
        reason: "fresh",
        return_to_kept: false,
        from_content: false,
      }),
    );
    expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" });
  });

  it("retour de Google, session DÉJÀ ouverte au montage : un login, avec le contexte d'arrivée", async () => {
    rememberReturnTo("/chapitre/c1");
    mockGetSession.mockResolvedValue({ data: { session: freshGoogle() } });
    render(<AuthPage />);

    await waitFor(() => expect(mockPush).toHaveBeenCalledWith("/chapitre/c1"));
    // SIGNED_IN arrive APRÈS que le rappel de session a déjà consommé la mémoire : il ne doit ni
    // doubler l'événement, ni le fausser.
    listener()("SIGNED_IN", freshGoogle());

    expect(loginEvents()).toEqual([
      ["login", { method: "google", reason: "fresh", return_to_kept: true, from_content: true }],
    ]);
    expect(mockPush).toHaveBeenCalledTimes(1);
  });

  it("retour de Google, INITIAL_SESSION d'abord puis SIGNED_IN : un seul login, avec le bon contexte", () => {
    rememberReturnTo("/chapitre/c1");
    render(<AuthPage />);

    listener()("INITIAL_SESSION", freshGoogle());
    listener()("SIGNED_IN", freshGoogle());

    expect(loginEvents()).toHaveLength(1);
    expect(loginEvents()[0][1]).toEqual({
      method: "google",
      reason: "fresh",
      return_to_kept: true,
      from_content: true,
    });
  });

  it("une session Google ancienne, vue par le rappel de session, n'est pas une connexion", async () => {
    mockGetSession.mockResolvedValue({
      data: {
        session: {
          user: {
            id: "u1",
            identities: [{ provider: "google", last_sign_in_at: "2026-01-01T00:00:00.000Z" }],
          },
        },
      },
    });
    render(<AuthPage />);

    await waitFor(() => expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" }));
    expect(loginEvents()).toHaveLength(0);
  });
});

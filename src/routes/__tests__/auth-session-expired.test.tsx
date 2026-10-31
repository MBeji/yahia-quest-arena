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
import { peekReturnReason, peekReturnTo, rememberReturnTo } from "@/shared/lib/return-to";
import { Route } from "../auth";

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

/**
 * Étude 38 lot 3 (R-7) — la session qui meurt revient au même endroit.
 *
 * `useExitOnRefusedSession` a retenu la page quittée avec la raison `expired` avant de fermer la session ;
 * la garde a renvoyé sur /auth. L'écran le dit, et la reconnexion ramène — la mesure le sépare d'une
 * connexion ordinaire. Comme plus haut, le simulacre de connexion fait parler l'écouteur AVANT de rendre
 * sa valeur : c'est l'ordre réel de `auth-js`.
 */
describe("AuthPage — la session qui meurt (é38 lot 3, R-7)", () => {
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

  /** Ce que `useExitOnRefusedSession` laisse derrière lui avant de fermer la session. */
  const expire = (path = "/quest/ex-1") => rememberReturnTo(path, Date.now(), "expired");

  const listener = () =>
    mockOnAuthStateChange.mock.calls[0][0] as (event: string, session: unknown) => void;

  const signedInBeforeResolving = (result: unknown) => async () => {
    listener()("SIGNED_IN", { user: { id: "u1" } });
    return result;
  };

  it("dit « Ta session a expiré » en tête du formulaire de connexion", async () => {
    expire();
    render(<AuthPage />);

    expect(await screen.findByTestId("auth-session-expired")).toHaveTextContent(
      /Ta session a expiré/,
    );
  });

  it("ne le dit pas sans retour d'expiration : ni mémoire, ni mémoire ordinaire", async () => {
    const { rerender } = render(<AuthPage />);
    await waitFor(() => expect(mockGetSession).toHaveBeenCalled());
    expect(screen.queryByTestId("auth-session-expired")).toBeNull();

    rememberReturnTo("/chapitre/c1");
    rerender(<AuthPage />);
    expect(screen.queryByTestId("auth-session-expired")).toBeNull();
  });

  it("ne le dit pas en inscription : créer un compte n'a rien à voir avec une session qui meurt", async () => {
    mockSearch.mode = "signup";
    expire();
    render(<AuthPage />);
    await waitFor(() => expect(mockGetSession).toHaveBeenCalled());

    expect(screen.queryByTestId("auth-session-expired")).toBeNull();
  });

  it("un lien d'invitation (?returnTo=) REMPLACE l'expiration : l'avis ne vaut plus", async () => {
    expire();
    mockSearch.returnTo = "/chapitre/c1";
    render(<AuthPage />);
    await waitFor(() => expect(peekReturnTo()).toBe("/chapitre/c1"));

    expect(peekReturnReason()).toBeNull();
    expect(screen.queryByTestId("auth-session-expired")).toBeNull();
  });

  it("l'avis est dans une région d'état toujours montée : un lecteur d'écran l'annonce", async () => {
    expire();
    render(<AuthPage />);
    const hint = await screen.findByTestId("auth-session-expired");

    expect(hint.parentElement).toHaveAttribute("role", "status");
    expect(hint.parentElement).toHaveAttribute("aria-live", "polite");
  });

  it("la reconnexion ramène à la page quittée ET se mesure comme une connexion après expiration", async () => {
    expire("/quest/ex-1?variant=recall");
    mockSignIn.mockImplementation(signedInBeforeResolving({ error: null }));
    render(<AuthPage />);
    submitLogin();

    await waitFor(() =>
      expect(trackProductEvent).toHaveBeenCalledWith("login", {
        method: "password",
        reason: "expired",
        return_to_kept: true,
        from_content: false,
      }),
    );
    expect(mockPush).toHaveBeenCalledTimes(1);
    expect(mockPush).toHaveBeenCalledWith("/quest/ex-1?variant=recall");
    // La mémoire est consommée : la prochaine connexion ne rejouera pas l'expiration.
    expect(peekReturnReason()).toBeNull();
  });

  it("retour de Google après une expiration : même mesure", async () => {
    expire("/quest/ex-1");
    mockGetSession.mockResolvedValue({
      data: {
        session: {
          user: {
            id: "u1",
            identities: [{ provider: "google", last_sign_in_at: new Date().toISOString() }],
          },
        },
      },
    });
    render(<AuthPage />);

    await waitFor(() => expect(mockPush).toHaveBeenCalledWith("/quest/ex-1"));
    const logins = trackProductEvent.mock.calls.filter(([name]) => name === "login");
    expect(logins).toEqual([
      ["login", { method: "google", reason: "expired", return_to_kept: true, from_content: false }],
    ]);
  });

  it("une connexion ordinaire n'est JAMAIS mesurée comme une expiration", async () => {
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
  });

  it("l'inscription ne porte pas de raison : `signup` reste à ses trois propriétés", async () => {
    mockSearch.mode = "signup";
    expire();
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
        return_to_kept: true,
        from_content: false,
      }),
    );
  });
});

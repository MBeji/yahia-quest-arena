import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

const mockNavigate = vi.fn();
const mockSearch: { mode: string; role?: "parent" } = { mode: "signup" };
vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: Record<string, unknown>) => ({
    ...opts,
    useSearch: () => mockSearch,
  }),
  useNavigate: () => mockNavigate,
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

import { Route, friendlyAuthError, isEmailNotConfirmed } from "../auth";

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

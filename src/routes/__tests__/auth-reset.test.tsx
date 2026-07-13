import { render, screen, waitFor, fireEvent, act } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

const mockNavigate = vi.fn();
vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: unknown) => opts,
  useNavigate: () => mockNavigate,
  Link: ({
    children,
    to,
    search,
  }: {
    children: React.ReactNode;
    to: string;
    search?: { mode?: string };
  }) =>
    React.createElement("a", { href: search?.mode ? `${to}?mode=${search.mode}` : to }, children),
}));
vi.mock("motion/react", () => ({
  motion: {
    div: ({ children, ...p }: { children?: React.ReactNode }) =>
      React.createElement("div", p, children),
  },
}));
vi.mock("@/shared/lib/motion", () => ({ useEntrance: () => ({}) }));
vi.mock("@/components/ui/language-switcher", () => ({ LanguageSwitcher: () => null }));

const toastSuccess = vi.fn();
const toastError = vi.fn();
vi.mock("sonner", () => ({
  toast: { success: (m: string) => toastSuccess(m), error: (m: string) => toastError(m) },
}));

const mockOnAuthStateChange = vi.fn();
const mockGetSession = vi.fn();
const mockUpdateUser = vi.fn();
vi.mock("@/shared/integrations/supabase/client", () => ({
  supabase: {
    auth: {
      onAuthStateChange: (...a: unknown[]) => mockOnAuthStateChange(...a),
      getSession: () => mockGetSession(),
      updateUser: (...a: unknown[]) => mockUpdateUser(...a),
    },
  },
}));

import { ResetPasswordPage } from "../auth_.reset";

describe("ResetPasswordPage (/auth/reset)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockOnAuthStateChange.mockReturnValue({ data: { subscription: { unsubscribe: vi.fn() } } });
  });

  it("with a recovery session: sets a new password then lands on the dashboard", async () => {
    mockGetSession.mockResolvedValue({ data: { session: { user: { id: "u1" } } } });
    mockUpdateUser.mockResolvedValue({ error: null });
    render(<ResetPasswordPage />);

    // Recovery session resolves → the new-password form appears.
    const input = await screen.findByPlaceholderText(/Nouveau mot de passe/);
    fireEvent.change(input, { target: { value: "newpass123" } });
    fireEvent.click(screen.getByRole("button", { name: /Enregistrer/ }));

    await waitFor(() => expect(mockUpdateUser).toHaveBeenCalledWith({ password: "newpass123" }));
    await waitFor(() => expect(mockNavigate).toHaveBeenCalledWith({ to: "/dashboard" }));
    expect(toastSuccess).toHaveBeenCalled();
  });

  it("rejects a password shorter than 8 chars without calling updateUser", async () => {
    mockGetSession.mockResolvedValue({ data: { session: { user: { id: "u1" } } } });
    render(<ResetPasswordPage />);
    const input = await screen.findByPlaceholderText(/Nouveau mot de passe/);
    fireEvent.change(input, { target: { value: "short" } });
    fireEvent.click(screen.getByRole("button", { name: /Enregistrer/ }));
    expect(mockUpdateUser).not.toHaveBeenCalled();
    expect(screen.getByText(/au moins 8 caractères/)).toBeInTheDocument();
  });

  it("an invalid/expired link resolves to an actionable « request a new one » state", async () => {
    vi.useFakeTimers();
    mockGetSession.mockResolvedValue({ data: { session: null } });
    const { container } = render(<ResetPasswordPage />);
    // No session materialises within the grace window → invalid state (R-2, no dead end).
    await act(async () => {
      await vi.advanceTimersByTimeAsync(2600);
    });
    expect(screen.getByText(/Lien invalide ou expiré/)).toBeInTheDocument();
    expect(container.querySelector('a[href="/auth?mode=forgot"]')).not.toBeNull();
    vi.useRealTimers();
  });
});

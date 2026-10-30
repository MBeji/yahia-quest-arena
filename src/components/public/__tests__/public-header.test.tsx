import { fireEvent, render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { peekReturnTo } from "@/shared/lib/return-to";
import React from "react";

// Match the lightweight router stub used by the sibling PublicLanding test: the
// header only needs <Link> to render an anchor with its `to` as the href.
vi.mock("@tanstack/react-router", () => ({
  Link: ({
    children,
    to,
    onClick,
  }: {
    children: React.ReactNode;
    to: string;
    onClick?: () => void;
  }) =>
    React.createElement(
      "a",
      {
        href: to,
        onClick: (e: React.MouseEvent) => {
          e.preventDefault();
          onClick?.();
        },
      },
      children,
    ),
}));

// é38 lot 0 : les clics d'invitation émettent `account_invite_clicked`.
const trackProductEvent = vi.fn();
vi.mock("@/shared/lib/product-events", () => ({
  trackProductEvent: (...a: unknown[]) => trackProductEvent(...a),
}));

// The header is auth-aware; mock useAuth so we can drive both states.
const mockUseAuth = vi.fn();
vi.mock("@/features/auth", () => ({ useAuth: () => mockUseAuth() }));

// The signed-in branch renders <AccountHud/> (its own tested unit); stub it to a
// plain dashboard link so this spec stays focused on the header's auth branching.
vi.mock("@/components/account-hud", () => ({
  AccountHud: () =>
    React.createElement("a", { href: "/dashboard", "data-testid": "account-hud" }, "hud"),
}));

import { I18nProvider } from "@/lib/i18n";
import { PublicHeader } from "../public-header";

const renderHeader = () =>
  render(
    <I18nProvider>
      <PublicHeader />
    </I18nProvider>,
  );

describe("PublicHeader", () => {
  beforeEach(() => {
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
  });

  it("exposes the settings menu so the public (no-login) pages are switchable fr/en/ar", async () => {
    renderHeader();
    // Un seul déclencheur pour tous les réglages (l'engrenage), là où le header
    // portait deux boutons distincts (langue, thème). Ciblé par testid : son
    // aria-label est traduit, et le défaut est le français (GAP-010).
    await userEvent.click(screen.getByTestId("settings-trigger"));
    for (const label of ["English", "Français", "العربية"]) {
      expect(screen.getByRole("menuitemradio", { name: label })).toBeInTheDocument();
    }
  });

  it("le visiteur anonyme peut aussi couper le son — ce que l'ancien header public n'offrait pas", async () => {
    renderHeader();
    await userEvent.click(screen.getByTestId("settings-trigger"));
    expect(screen.getByRole("switch", { name: /effets sonores/i })).toBeInTheDocument();
    expect(screen.getByRole("switch", { name: /musique/i })).toBeInTheDocument();
  });

  it("n'expose NI la page de paramétrage NI la déconnexion : le bloc compte est réservé à la coquille connectée", async () => {
    renderHeader();
    await userEvent.click(screen.getByTestId("settings-trigger"));
    expect(screen.queryByRole("link", { name: /param/i })).toBeNull();
    expect(screen.queryByRole("button", { name: /déconnexion|sign out/i })).toBeNull();
  });

  it("logged out: links to the catalogue + the login/signup CTAs (no account link)", () => {
    const { container } = renderHeader();
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
    expect(container.querySelector('a[href="/login"]')).not.toBeNull();
    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
    expect(container.querySelector('a[href="/dashboard"]')).toBeNull();
    // Logo = public home when logged out.
    expect(container.querySelector('a[href="/"]')).not.toBeNull();
  });

  it("logged in: shows the account link back to the dashboard, never login/signup", () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    const { container } = renderHeader();
    expect(container.querySelector('a[href="/dashboard"]')).not.toBeNull();
    expect(container.querySelector('a[href="/login"]')).toBeNull();
    expect(container.querySelector('a[href="/signup"]')).toBeNull();
    // Catalogue nav stays available to a signed-in visitor.
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
  });

  it("logged in: the brand logo goes to the dashboard, not the logged-out home (issue #312)", () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    const { container } = renderHeader();
    // A signed-in visitor stranded on the public shell taps the logo to return to
    // their space — it must NOT drop them on the public "/" landing.
    expect(container.querySelector('a[href="/"]')).toBeNull();
    // The brand logo now points at the dashboard.
    const brand = screen.getByText("Na9ra Nal3ab").closest("a");
    expect(brand).toHaveAttribute("href", "/dashboard");
  });
});

describe("PublicHeader — invitation mesurée (é38 lot 0)", () => {
  beforeEach(() => {
    trackProductEvent.mockClear();
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
  });

  it("« Créer mon compte » émet l'invitation depuis l'en-tête", () => {
    const { container } = renderHeader();
    fireEvent.click(container.querySelector('a[href="/signup"]') as HTMLElement);
    expect(trackProductEvent).toHaveBeenCalledWith("account_invite_clicked", {
      surface: "header",
    });
  });

  it("« Connexion » n'est pas une invitation : un compte existe déjà, rien à mesurer", () => {
    const { container } = renderHeader();
    for (const link of container.querySelectorAll('a[href="/login"]')) {
      fireEvent.click(link);
    }
    expect(trackProductEvent).not.toHaveBeenCalled();
  });
});

describe("PublicHeader — le retour au point de départ (é38 lot 1)", () => {
  beforeEach(() => {
    window.localStorage.clear();
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
  });
  afterEach(() => {
    window.history.replaceState({}, "", "/");
    window.localStorage.clear();
  });

  it("« Créer mon compte » retient la page où l'on est, requête comprise", () => {
    window.history.replaceState({}, "", "/chapitre/c1?x=1");
    const { container } = renderHeader();
    fireEvent.click(container.querySelector('a[href="/signup"]') as HTMLElement);

    expect(peekReturnTo()).toBe("/chapitre/c1?x=1");
  });

  it("« Connexion » aussi — au bureau comme sur la rangée de téléphone", () => {
    window.history.replaceState({}, "", "/programme");
    const { container } = renderHeader();
    const links = container.querySelectorAll('a[href="/login"]');
    expect(links).toHaveLength(2);

    for (const link of links) {
      window.localStorage.clear();
      fireEvent.click(link);
      expect(peekReturnTo()).toBe("/programme");
    }
  });

  it("depuis l'accueil rien n'est retenu : le Hall vaut mieux que la vitrine", () => {
    window.history.replaceState({}, "", "/");
    const { container } = renderHeader();
    fireEvent.click(container.querySelector('a[href="/signup"]') as HTMLElement);

    expect(peekReturnTo()).toBeNull();
  });
});

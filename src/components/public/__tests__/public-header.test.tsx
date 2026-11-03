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

// The header is auth-aware; mock useAuth so we can drive both states. `useMyRole` donne le rôle
// (R-14), `useSignOutInPlace` la déconnexion sur place (R-11) — l'un et l'autre ont leurs propres tests.
const mockUseAuth = vi.fn();
const mockUseMyRole = vi.fn();
const mockSignOut = vi.fn();
vi.mock("@/features/auth", () => ({
  useAuth: () => mockUseAuth(),
  useMyRole: () => mockUseMyRole(),
  useSignOutInPlace: () => mockSignOut,
}));

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
    mockUseMyRole.mockReturnValue({ role: null });
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
    mockUseMyRole.mockReturnValue({ role: "student" });
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
    mockUseMyRole.mockReturnValue({ role: null });
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
    mockUseMyRole.mockReturnValue({ role: null });
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

describe("PublicHeader — aucun libellé ne devine le compte (é38 lot 1, R-6)", () => {
  beforeEach(() => {
    // `useAuth` démarre à { user: null, loading: true } : c'est aussi l'état rendu côté serveur.
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: true });
    mockUseMyRole.mockReturnValue({ role: null });
  });

  it("pendant la lecture de la session : ni « Connexion », ni « Créer mon compte », ni le HUD", () => {
    const { container } = renderHeader();

    expect(container.querySelector('a[href="/login"]')).toBeNull();
    expect(container.querySelector('a[href="/signup"]')).toBeNull();
    expect(screen.queryByTestId("account-hud")).toBeNull();
  });

  it("le bloc neutre garde l'essentiel : réglages, aide, catalogue, et la marque vers l'accueil", () => {
    const { container } = renderHeader();

    expect(screen.getByTestId("settings-trigger")).toBeInTheDocument();
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
    expect(container.querySelector('a[href="/"]')).not.toBeNull();
  });

  it("la lecture finie, le visiteur voit ses deux entrées — le bloc neutre est transitoire", () => {
    const { container, rerender } = renderHeader();
    expect(container.querySelector('a[href="/signup"]')).toBeNull();

    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
    rerender(
      <I18nProvider>
        <PublicHeader />
      </I18nProvider>,
    );

    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
    expect(container.querySelectorAll('a[href="/login"]')).toHaveLength(2);
  });

  it("la lecture finie, le connecté voit son HUD — jamais les invitations", () => {
    const { container, rerender } = renderHeader();

    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    rerender(
      <I18nProvider>
        <PublicHeader />
      </I18nProvider>,
    );

    expect(screen.getByTestId("account-hud")).toBeInTheDocument();
    expect(container.querySelector('a[href="/signup"]')).toBeNull();
    expect(container.querySelector('a[href="/login"]')).toBeNull();
  });
});

describe("PublicHeader — se déconnecter sans quitter la page (é38 lot 1, R-11)", () => {
  beforeEach(() => {
    mockSignOut.mockReset();
    mockUseMyRole.mockReturnValue({ role: "student" });
  });

  it("un connecté trouve « Déconnexion » dans le menu des réglages, et elle appelle la déconnexion sur place", async () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    renderHeader();

    await userEvent.click(screen.getByTestId("settings-trigger"));
    await userEvent.click(screen.getByRole("button", { name: /déconnexion|sign out/i }));

    expect(mockSignOut).toHaveBeenCalledTimes(1);
  });

  it("le bloc compte comprend aussi « Tous les paramètres »", async () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    renderHeader();

    await userEvent.click(screen.getByTestId("settings-trigger"));

    expect(screen.getByRole("link", { name: /param/i })).toBeInTheDocument();
  });

  it("un visiteur n'a pas de déconnexion à offrir : son menu reste celui des réglages rapides", async () => {
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
    renderHeader();

    await userEvent.click(screen.getByTestId("settings-trigger"));

    expect(screen.queryByRole("button", { name: /déconnexion|sign out/i })).toBeNull();
    expect(mockSignOut).not.toHaveBeenCalled();
  });
});

describe("PublicHeader — « Suivi parent » n'est pas la porte d'un élève (é38 lot 1, R-14)", () => {
  const suiviLinks = (container: HTMLElement) => container.querySelectorAll('a[href="/suivi"]');

  it("le visiteur le voit, sur le bureau comme sur la rangée de téléphone", () => {
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: false });
    mockUseMyRole.mockReturnValue({ role: null });
    const { container } = renderHeader();

    expect(suiviLinks(container)).toHaveLength(2);
  });

  it("il y est aussi pendant la lecture de la session : le HTML rendu côté serveur ne le perd pas", () => {
    mockUseAuth.mockReturnValue({ user: null, session: null, loading: true });
    mockUseMyRole.mockReturnValue({ role: null });
    const { container } = renderHeader();

    expect(suiviLinks(container)).toHaveLength(2);
  });

  it("un élève connecté ne le voit pas", () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    mockUseMyRole.mockReturnValue({ role: "student" });
    const { container } = renderHeader();

    expect(suiviLinks(container)).toHaveLength(0);
  });

  it("un connecté dont le rôle n'est pas encore lu ne le voit pas non plus : mieux vaut un lien qui arrive qu'un lien qui disparaît", () => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    mockUseMyRole.mockReturnValue({ role: null });
    const { container } = renderHeader();

    expect(suiviLinks(container)).toHaveLength(0);
  });

  it.each(["parent", "admin"])("un %s connecté le garde", (role) => {
    mockUseAuth.mockReturnValue({ user: { id: "u1" }, session: {}, loading: false });
    mockUseMyRole.mockReturnValue({ role });
    const { container } = renderHeader();

    expect(suiviLinks(container)).toHaveLength(2);
  });
});

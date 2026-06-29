import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

// Match the lightweight router stub used by the sibling PublicLanding test: the
// header only needs <Link> to render an anchor with its `to` as the href.
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
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

  it("exposes the language switcher so the public (no-login) pages are switchable fr/en/ar", () => {
    renderHeader();
    // The shared LanguageSwitcher trigger (aria-label is what the e2e nav targets too).
    expect(screen.getByRole("button", { name: /change language/i })).toBeInTheDocument();
  });

  it("logged out: links to the catalogue + the login/signup CTAs (no account link)", () => {
    const { container } = renderHeader();
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
    expect(container.querySelector('a[href="/login"]')).not.toBeNull();
    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
    expect(container.querySelector('a[href="/dashboard"]')).toBeNull();
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
});

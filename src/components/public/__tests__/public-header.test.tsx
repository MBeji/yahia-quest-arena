import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import React from "react";

// Match the lightweight router stub used by the sibling PublicLanding test: the
// header only needs <Link> to render an anchor with its `to` as the href.
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
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
  it("exposes the language switcher so the public (no-login) pages are switchable fr/en/ar", () => {
    renderHeader();
    // The shared LanguageSwitcher trigger (aria-label is what the e2e nav targets too).
    expect(screen.getByRole("button", { name: /change language/i })).toBeInTheDocument();
  });

  it("links to the catalogue (programme + extras) and the account CTAs", () => {
    const { container } = renderHeader();
    expect(container.querySelector('a[href="/programme"]')).not.toBeNull();
    expect(container.querySelector('a[href="/extras"]')).not.toBeNull();
    expect(container.querySelector('a[href="/login"]')).not.toBeNull();
    expect(container.querySelector('a[href="/signup"]')).not.toBeNull();
  });
});

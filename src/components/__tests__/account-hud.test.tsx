import { render, screen } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";

// The HUD is a single dashboard link whose label is the user's stats; the router
// Link stub renders an anchor carrying `to` (and forwarded data-testid/aria-label).
vi.mock("@tanstack/react-router", () => ({
  Link: ({ children, to, ...props }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to, ...props }, children),
}));

// Drive the two stat states.
const mockUseMyStats = vi.fn();
vi.mock("@/features/auth", () => ({ useMyStats: () => mockUseMyStats() }));

import { I18nProvider } from "@/lib/i18n";
import { AccountHud } from "../account-hud";

const renderHud = () =>
  render(
    <I18nProvider>
      <AccountHud />
    </I18nProvider>,
  );

describe("AccountHud", () => {
  beforeEach(() => {
    mockUseMyStats.mockReturnValue({
      xp: null,
      currentStreak: null,
      hasStats: false,
      isLoaded: false,
    });
  });

  it("always links back to the dashboard, showing the account label before stats load", () => {
    renderHud();
    const hud = screen.getByTestId("account-hud");
    expect(hud.getAttribute("href")).toBe("/dashboard");
    // No figures yet — the account entry stays present via the label fallback.
    expect(hud.textContent).not.toMatch(/XP/);
  });

  it("shows the streak + XP once the stats have loaded", () => {
    mockUseMyStats.mockReturnValue({
      xp: 1280,
      currentStreak: 5,
      hasStats: true,
      isLoaded: true,
    });
    renderHud();
    const hud = screen.getByTestId("account-hud");
    expect(hud.getAttribute("href")).toBe("/dashboard");
    expect(hud.textContent).toContain("5");
    // XP is rendered in compact notation so a large value never widens the header
    // chip past the phone viewport (1280 → "1.3K").
    expect(hud.textContent).toContain("1.3K");
    expect(hud.textContent).toContain("XP");
  });

  it("compacts a large XP value so the header chip stays narrow on phones", () => {
    mockUseMyStats.mockReturnValue({
      xp: 12345,
      currentStreak: 9,
      hasStats: true,
      isLoaded: true,
    });
    renderHud();
    const hud = screen.getByTestId("account-hud");
    expect(hud.textContent).toContain("12.3K");
    expect(hud.textContent).not.toContain("12345");
  });
});

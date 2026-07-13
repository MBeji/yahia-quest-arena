import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import React from "react";

// The Arène pole (étude 15, lot 5 / D-4) lists the three competitive screens with
// their reward hint (R-4: the stakes are shown BEFORE the click). Captured from the
// route's createFileRoute call and rendered in isolation, like the other route tests.
let captured: React.ComponentType | undefined;

vi.mock("@tanstack/react-router", () => ({
  createFileRoute: () => (opts: { component: React.ComponentType }) => {
    captured = opts.component;
    return {};
  },
  Link: ({ children, to }: { children: React.ReactNode; to: string }) =>
    React.createElement("a", { href: to }, children),
}));

vi.mock("@/components/ui/page-shell", () => ({
  PageShell: ({ children }: { children: React.ReactNode }) =>
    React.createElement("main", null, children),
}));

// Rewards come from the real game constants — the hub must never hard-code them.
vi.mock("@/features/dungeon", () => ({ DUNGEON_XP_PER_FLOOR: 15 }));

vi.mock("@/lib/i18n", () => ({
  useT: () => ({
    // Hub-specific copy (new keys).
    arena: {
      title: "Arène",
      subtitle: "Mesure-toi aux autres héros.",
      dungeonReward: "+{xp} XP par étage",
      duelReward: "Jusqu'à +{xp} XP par victoire",
      rankingDesc: "Situe-toi dans l'Académie.",
      rankingReward: "Gagne des XP pour grimper",
    },
    // Titles/pitches reused from the modes' own sections (DRY).
    dungeon: { title: "Le Donjon Infini", desc: "Descends le plus bas possible." },
    duel: { title: "Duels", subtitle: "Défie un adversaire." },
    leaderboard: { titleGradient: "Classement" },
  }),
}));

async function renderArene() {
  await import("@/routes/_authenticated/arene");
  if (!captured) throw new Error("ArenePage not captured");
  return render(React.createElement(captured));
}

describe("Arène hub", () => {
  it("links to the three competitive screens", async () => {
    const { container } = await renderArene();
    expect(container.querySelector('a[href="/dungeon"]')).not.toBeNull();
    expect(container.querySelector('a[href="/duel"]')).not.toBeNull();
    expect(container.querySelector('a[href="/leaderboard"]')).not.toBeNull();
  });

  it("shows each mode's reward from the game constants (interpolated, not literal)", async () => {
    await renderArene();
    // DUNGEON_XP_PER_FLOOR (15) interpolated into the reward template.
    expect(screen.getByText("+15 XP par étage")).toBeInTheDocument();
    // DUEL_REWARDS.win.xp (60) comes from the real constant.
    expect(screen.getByText(/\+60 XP par victoire/)).toBeInTheDocument();
    // No unrendered placeholder leaks to the UI.
    expect(screen.queryByText(/\{xp\}/)).not.toBeInTheDocument();
  });
});

import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { Coins } from "lucide-react";

import { GoldProgress } from "@/components/game/gold-progress";
import { StatTile } from "@/components/game/stat-tile";
import { DifficultyStars } from "@/components/game/difficulty-stars";
import { PremiumBadge } from "@/components/game/premium-badge";

describe("GoldProgress", () => {
  it("exposes a clamped progressbar with a width-based (RTL-safe) fill", () => {
    render(<GoldProgress value={137} aria-label="XP" />);
    const bar = screen.getByRole("progressbar", { name: "XP" });
    expect(bar).toHaveAttribute("aria-valuenow", "100");
    const fill = bar.firstElementChild as HTMLElement;
    expect(fill.style.width).toBe("100%");
    expect(fill.style.transform).toBe(""); // no translateX — width fills from inline-start
  });

  it("clamps negative values to zero and supports sizes", () => {
    render(<GoldProgress value={-5} size="lg" aria-label="HP" />);
    const bar = screen.getByRole("progressbar", { name: "HP" });
    expect(bar).toHaveAttribute("aria-valuenow", "0");
    expect(bar.className).toContain("h-3");
    expect((bar.firstElementChild as HTMLElement).style.width).toBe("0%");
  });
});

describe("StatTile", () => {
  it("renders value, label and tone surface", () => {
    const { container } = render(<StatTile icon={Coins} value="+120" label="Pièces" />);
    expect(screen.getByText("+120")).toBeInTheDocument();
    expect(screen.getByText("Pièces")).toBeInTheDocument();
    expect(container.firstElementChild!.className).toContain("bg-gold/15");
  });

  it("supports the flame tone", () => {
    const { container } = render(<StatTile value="x3" label="Série" tone="flame" />);
    expect(container.firstElementChild!.className).toContain("bg-flame/15");
  });
});

describe("DifficultyStars", () => {
  it("renders max stars with the level filled and an accessible label", () => {
    render(<DifficultyStars level={3} />);
    // Default locale (fr) label from t.common.difficulty.
    const group = screen.getByRole("img", { name: "Difficulté 3 sur 4" });
    const stars = group.querySelectorAll("svg");
    expect(stars).toHaveLength(4);
    const filled = [...stars].filter((s) => s.getAttribute("class")?.includes("fill-gold"));
    expect(filled).toHaveLength(3);
  });

  it("is extensible beyond 4 (Q-4: always stars)", () => {
    render(<DifficultyStars level={5} max={6} />);
    const group = screen.getByRole("img", { name: "Difficulté 5 sur 6" });
    expect(group.querySelectorAll("svg")).toHaveLength(6);
  });

  it("clamps an out-of-range level", () => {
    render(<DifficultyStars level={9} />);
    expect(screen.getByRole("img", { name: "Difficulté 4 sur 4" })).toBeInTheDocument();
  });
});

describe("PremiumBadge", () => {
  it("renders the lock chip with its default wording", () => {
    render(<PremiumBadge />);
    const badge = screen.getByText("Premium");
    expect(badge.className).toContain("bg-card");
    expect(badge.querySelector("svg")).not.toBeNull();
  });
});

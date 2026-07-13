import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import { fr } from "@/lib/i18n/fr";
import { DuelLeague } from "../components/duel-league";
import { tierLabel } from "../duel-tiers";
import type { DuelLeagueRow } from "../duel.server";

const L = fr.duel;

const row = (over: Partial<DuelLeagueRow>): DuelLeagueRow => ({
  rank: 1,
  displayName: "Alpha",
  heroClass: null,
  avatarTier: 1,
  points: 4,
  wins: 1,
  played: 2,
  tier: "gold",
  isMe: false,
  ...over,
});

describe("tierLabel", () => {
  it("maps known tiers to their localized names", () => {
    expect(tierLabel("diamond", L)).toBe(L.tierDiamond);
    expect(tierLabel("bronze", L)).toBe(L.tierBronze);
  });
  it("falls back to Bronze for an unknown tier", () => {
    expect(tierLabel("mystery", L)).toBe(L.tierBronze);
  });
});

describe("DuelLeague", () => {
  it("shows the empty state when there are no standings", () => {
    render(<DuelLeague rows={[]} lastAward={null} labels={L} />);
    expect(screen.getByText(L.leagueEmpty)).toBeInTheDocument();
  });

  it("renders standings with rank, tier and points", () => {
    render(
      <DuelLeague
        rows={[row({ rank: 1, displayName: "Alpha", tier: "gold", points: 4 })]}
        lastAward={null}
        labels={L}
      />,
    );
    expect(screen.getByText("Alpha")).toBeInTheDocument();
    expect(screen.getByText(L.tierGold)).toBeInTheDocument();
    expect(screen.getByText(L.leaguePts.replace("{n}", "4"))).toBeInTheDocument();
  });

  it("renders the last-week award banner with tier + coins", () => {
    render(
      <DuelLeague
        rows={[]}
        lastAward={{ weekStart: "2026-06-29", tier: "diamond", rank: 1, points: 9, coins: 100 }}
        labels={L}
      />,
    );
    expect(
      screen.getByText(L.lastAward.replace("{tier}", L.tierDiamond).replace("{coins}", "100")),
    ).toBeInTheDocument();
  });
});

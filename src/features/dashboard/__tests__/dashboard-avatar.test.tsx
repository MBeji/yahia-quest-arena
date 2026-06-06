import { render, screen } from "@testing-library/react";
import { describe, it, expect, beforeAll } from "vitest";
import { DashboardRadarInventory } from "../components/dashboard-radar-inventory";
import { DashboardBadgesShop } from "../components/dashboard-badges-shop";

// recharts' ResponsiveContainer (used by the radar) needs ResizeObserver,
// which jsdom does not provide.
beforeAll(() => {
  globalThis.ResizeObserver = class {
    observe() {}
    unobserve() {}
    disconnect() {}
  };
});

describe("equipped skin rendering", () => {
  it("shows the equipped skin glyph in the inventory avatar", () => {
    render(
      <DashboardRadarInventory
        radarData={[]}
        inventory={[]}
        avatarSlug="dragon"
        displayName="Yahia"
        isActivatePending={false}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("🐲")).toBeInTheDocument();
  });

  it("falls back to initials when no skin is equipped", () => {
    render(
      <DashboardRadarInventory
        radarData={[]}
        inventory={[]}
        avatarSlug={null}
        displayName="Yahia"
        isActivatePending={false}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("YA")).toBeInTheDocument();
  });

  it("shows the skin glyph on a shop skin card", () => {
    render(
      <DashboardBadgesShop
        badges={[]}
        shopItems={[
          {
            code: "skin_pharaoh",
            name: "Masque du Pharaon",
            description: null,
            itemType: "skin",
            priceCoins: 200,
            isOwned: false,
            isEquipped: false,
            quantity: 0,
            avatarSlug: "pharaoh",
            isArmable: false,
            armSlot: null,
            isActive: false,
          },
        ]}
        availableCoins={500}
        isPurchasePending={false}
        isEquipPending={false}
        isActivatePending={false}
        onPurchase={() => {}}
        onEquip={() => {}}
        onActivate={() => {}}
      />,
    );
    expect(screen.getByText("👑")).toBeInTheDocument();
  });
});
